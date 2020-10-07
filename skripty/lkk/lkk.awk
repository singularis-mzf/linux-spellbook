# Linux Kniha kouzel, skript lkk.awk
# Copyright (c) 2020 Singularis <singularis@volny.cz>
#
# Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
# podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
# vydané neziskovou organizací Creative Commons. Text licence je přiložený
# k tomuto projektu nebo ho můžete najít na webové adrese:
#
# https://creativecommons.org/licenses/by-sa/4.0/
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

@include "/usr/share/lkk/awkvolby.awk";

BEGIN {
    FS = OFS = "";
    RS = ORS = "\n";
    bashout = "/dev/stdout";
    stdout = "/dev/fd/9";
    stderr = "/dev/stderr";

    # Načíst proměnné prostředí:
    HOME = PromennaProstredi("HOME");
    if (HOME !~ /^\//) {ShoditFatalniVyjimku("Chybná hodnota proměnné $HOME!")}
    EDITOR = PromennaProstredi("EDITOR", "sensible-editor");
    XDG_DATA_HOME = PromennaProstredi("XDG_DATA_HOME", HOME "/.local/share");
    LKKPATH = PromennaProstredi("LKKPATH", XDG_DATA_HOME "/lkk/skripty:/usr/share/lkk/skripty");

    # Deklarovat akce:
    DeklarovatVolbu("-e", "--editovat", "", "akce");
    DeklarovatVolbu("-f", "--najit", "", "akce");
    DeklarovatAliasVolby("-f", "--najít");
    DeklarovatVolbu("-h", "--help", "", "akce");
    DeklarovatAliasVolby("-h", "--napoveda");
    DeklarovatAliasVolby("-h", "--nápověda");
    DeklarovatVolbu("-l", "--seznam", "", "akce");
    DeklarovatVolbu("-p", "--vypsat", "", "akce");
    DeklarovatVolbu("-r", "--spustit", "", "akce");
    DeklarovatVolbu("-t", "--existuje", "", "akce");
    DeklarovatVolbu("-F", "--funkce", "", "akce");

    DeklarovatVolbu("-P", "--seznam-cest", "", "akce");

    # Deklarovat přepínače:
    DeklarovatVolbu("--bash");
    DeklarovatVolbu("-s", "--system", "", "");
    DeklarovatAliasVolby("-s", "--systém");
    DeklarovatVolbu("-x", "--jen-spustitelne", "", "");
    DeklarovatAliasVolby("-x", "--jen-spustitelné");

    # Zpracovat parametry:
    ZpracovatParametry("0");

    # 1. Proskenovat přepínače a určit akci.
    akce = PREP_SKUPINY["akce"] != "" ? gensub(/^-*/, "", 1, PREP_SKUPINY["akce"]) : "r";
    if (POCET_PREPINACU == 0 && POCET_ARGUMENTU == 0) {
        ShoditFatalniVyjimku("Chybí název skriptu! Pro nápovědu zadejte: lkk --help");
    }

    # 2. Skript musí být zadán, ledaže ho akce nevyžaduje.
    if (akce ~ /^[hlP]$/) {
        if (POCET_ARGUMENTU != 0) {ShoditFatalniVyjimku("lkk: Chybné použití: akce -" akce " nepřijímá název skriptu!")}
    } else if (akce !~ /^[F]$/) {
        if (POCET_ARGUMENTU == 0 || ARGUMENTY[0] == "") {ShoditFatalniVyjimku("Chybí název skriptu!")}
        if (ARGUMENTY[0] ~ /\//) {ShoditFatalniVyjimku("lkk: Název skriptu nesmí obsahovat lomítko: " ARGUMENTY[0])}
    }

    # akce "h" (vypsat nápovědu)
    if (akce == "h") {
        print "„lkk“ – užití:" > stdout;
        print "\tlkk -e {skript} :: Vytvoří uživatelovu kopii skriptu a otevře ji ve výchozím editoru ($EDITOR, popř. sensible-editor)." > stdout;
        print "\tlkk -f {skript} :: Vypíše úplnou (absolutní) cestu k zadanému skriptu." > stdout;
        print "\tlkk -l          :: Vypíše seznam dostupných skriptů." > stdout;
        print "\tlkk -p {skript} :: Vypíše obsah skriptu na standardní výstup." > stdout;
        print "\tlkk [-r] [--] {skript} [parametry...] :: Spustí skript se zadanými parametry." > stdout;
        print "\tlkk -t {skript} :: Jen ověří, že daný skript existuje." > stdout;
        print "\tlkk --seznam-cest :: Vypíše seznam cest (i neexistujících), kde hledá skripty." > stdout;
        print "\tlkk --funkce [funkce] :: Vypíše pomocnou funkci (všechny, není-li zadána konkrétní)." > stdout;
        print "\nDalší volby:\n" > stdout;
        print "\t--bash :: Je-li zadáno -e na neexistující skript, vytvoří skript s hlavičkou „#!/bin/bash“." > stdout;
        print "\t-s :: Skripty hledat jen v /usr/share/lkk/skripty; ignorovat proměnnou LKKPATH a uživatelské úložiště ~/.local/share/lkk/skripty." > stdout;
        print "\t-x :: Ignorovat nespustitelné skripty (tzv. úryvky). Je-li zadáno -e na neexistující skript, nastaví nový skript jako spustitelný." > stdout;
        exit;
    }

    # 3. Sestavit seznam cest k prohledání.
    if ("-s" in PREP_VOLBY) {
        cesty[cest = 1] = "/usr/share/lkk/skripty";
    } else {
        cest = split(LKKPATH, cesty, ":");
    }

    # akce "l" (vypsat seznam dostupných skriptů)
    if (akce == "l") {
        if (POCET_ARGUMENTU != 0) {ShoditFatalniVyjimku("Chybné použití: akce -l nepřijímá název skriptu!")}
        if (cest == 0) {exit}
        prikaz = "find"
        for (i = 1; i <= cest; ++i) {
            if (system("test -r " DoApostrofu(cesty[i])) == 0) {
                prikaz = prikaz " " DoApostrofu(cesty[i]);
            }
        }
        if (prikaz == "find") {exit}
        prikaz = prikaz " -mindepth 1 -maxdepth 1 -readable";
        if ("-x" in PREP_VOLBY) {prikaz = prikaz " -executable"}
        prikaz = prikaz " -printf '%f\\n' | sort -u";
        print prikaz > bashout;
        exit;
    }

    # akce "P" (vypsat seznam prohledávaných cest)
    if (akce == "P") {
        for (i = 1; i <= cest; ++i) {print cesty[i] > stdout}
        exit;
    }

    # akce "F" (vypsat pomocnou funkci)
    if (akce == "F") {
        ARGUMENTY[1] = ARGUMENTY[0];
        ARGUMENTY[0] = "pomocné-funkce";
    }

    # 4. Vyhledat skript.
    i = 1;
    do
    {
        nova_cesta = VyhledatSkript(cesty[i], ARGUMENTY[0]);
    } while (nova_cesta == "" && ++i <= cest);

    # 5. Spustit akci.
    switch (akce) {
        case "e": # editovat
            if (nova_cesta != XDG_DATA_HOME "/lkk/skripty/" ARGUMENTY[0]) {
                print "mkdir -pv " DoApostrofu(XDG_DATA_HOME "/lkk/skripty") " && \\" > bashout;
                if (nova_cesta != "") {
                    # skript nalezen => zkopírovat se zachováním práv
                    print "cp -- " DoApostrofu(nova_cesta) " " DoApostrofu(XDG_DATA_HOME "/lkk/skripty/" ARGUMENTY[0]) " && \\" > bashout;
                    nova_cesta = DoApostrofu(XDG_DATA_HOME "/lkk/skripty/" ARGUMENTY[0]);
                } else if (system("test -e " DoApostrofu(XDG_DATA_HOME "/lkk/skripty/" ARGUMENTY[0])) != 0) {
                    # skript neexistuje
                    nova_cesta = DoApostrofu(XDG_DATA_HOME "/lkk/skripty/" ARGUMENTY[0]);
                    if ("--bash" in PREP_VOLBY) {
                        print "printf '#!/bin/bash -e\\n' > " nova_cesta " && \\" > bashout;
                    } else {
                        print "touch -- " nova_cesta " && \\" > bashout;
                    }
                    if ("-x" in PREP_VOLBY) {
                        print "chmod a+x -- " nova_cesta " && \\" > bashout;
                    }
                } else {
                    nova_cesta = DoApostrofu(XDG_DATA_HOME "/lkk/skripty/" ARGUMENTY[0]);
                }
            }
            print "exec " EDITOR " " nova_cesta > bashout;
            exit;

        case "f": # najít skript
            if (nova_cesta == "") {exit 1}
            print nova_cesta > stdout;
            exit;

        case "p": # vypsat skript
            if (nova_cesta == "") {
                ShoditFatalniVyjimku("skript či úryvek " ARGUMENTY[0] " nenalezen!");
            }
            print "exec cat " DoApostrofu(nova_cesta) > bashout;
            exit;

        case "F": # vypsat pomocnou funkci
            if (nova_cesta == "") {
                ShoditFatalniVyjimku("skript \"pomocné-funkce\" nenalezen!");
            }
            FS = "\n";
            if (ARGUMENTY[1] == "") {
                # vypsat všechny pomocné funkce
                print "exec egrep -v '^#' '" DoApostrofu(nova_cesta) "'" > bashout;
                exit;
            }
            # vypsat jednu pomocnou funkci
            if (ARGUMENTY[1] !~ /^lkk_/) {ARGUMENTY[1] = "lkk_" ARGUMENTY[1]}
            i = 1;
            zacatek = -1;
            konec = -1;
            while (getline < nova_cesta) {
                if (zacatek == -1 && $0 == "#začátek " ARGUMENTY[1]) {zacatek = i}
                if (konec == -1 && $0 == "#konec "ARGUMENTY[1]) {
                    konec = i;
                    if (konec - zacatek > 1) {
                        print "exec sed -n " (zacatek + 1) "," (konec - 1) "p '" DoApostrofu(nova_cesta) "'" > bashout;
                        exit;
                    } else {
                        ShoditFatalniVyjimku("Pomocná funkce \"" ARGUMENTY[1] "\" je prázdná!");
                    }
                }
                ++i;
            }
            ShoditFatalniVyjimku("Pomocná funkce \"" ARGUMENTY[1] "\" nenalezena!");
            exit;

        case "r": # spustit skript
            if (nova_cesta == "") {
                ShoditFatalniVyjimku("skript či úryvek " ARGUMENTY[0] " nenalezen!");
            }
            prikaz = "exec " DoApostrofu(nova_cesta);
            for (i = 1; i < POCET_ARGUMENTU; ++i) {
                prikaz = prikaz " " DoApostrofu(ARGUMENTY[i]);
            }
            print prikaz > bashout;
            exit;

        case "t": # existuje skript?
            exit nova_cesta == "" ? 1 : 0;

        default:
            ShoditFatalniVyjimku("Nepodpovaná akce: " akce);
            exit;
    }
}

function DoApostrofu(text) {
    gsub(/'/, "'\\''", text);
    return "'" text "'";
}

function Nacist(promenna, prikaz,   orig_rs) {
    orig_rs = RS;
    RS = "\n$";
    prikaz | getline SYMTAB[promenna];
    RS = orig_rs;
    return close(prikaz);
}

function ShoditFatalniVyjimku(text) {
    print "lkk: " text > stderr;
    exit 1;
}

function VyhledatSkript(cesta, skript) {
    if (Nacist("nova_cesta", (cesta != "" ? "cd " DoApostrofu(cesta) " 2>/dev/null && " : "") "realpath -eq " DoApostrofu(skript)) != 0) {return ""}
    cesta = DoApostrofu(nova_cesta);
    if (system("test -f " cesta " -a -r " cesta (("-x" in PREP_VOLBY) ? " -a -x " cesta : "")) != 0) {return ""}
    return nova_cesta;
}

function PromennaProstredi(nazev, nahradniHodnota) {
    if (nazev in ENVIRON && ENVIRON[nazev] != "") {return ENVIRON[nazev]}
    return nahradniHodnota;
}
