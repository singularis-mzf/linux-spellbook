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

    # Akce:
    DeklarovatVolbu("-e", "--editovat", "", "");
    DeklarovatVolbu("-f", "--najit", "", "");
    DeklarovatAliasVolby("-f", "--najít");
    DeklarovatVolbu("-h", "--help", "", "");
    DeklarovatAliasVolby("-h", "--napoveda");
    DeklarovatAliasVolby("-h", "--nápověda");
    DeklarovatVolbu("-l", "--seznam", "", "");
    DeklarovatVolbu("-p", "--vypsat", "", "");
    DeklarovatVolbu("-r", "--spustit", "", "");
    DeklarovatVolbu("-t", "--existuje", "", "");

    DeklarovatVolbu("-P", "--seznam-cest", "", "");

    # Přepínače:
    DeklarovatVolbu("-s", "--system", "", "");
    DeklarovatAliasVolby("-s", "--systém");
    DeklarovatVolbu("-x", "--jen-spustitelne", "", "");
    DeklarovatAliasVolby("-x", "--jen-spustitelné");

    ZpracovatParametry("0");

    # 1. Proskenovat přepínače a určit akci.
    akce = "";
    for (i = 1; i <= POCET_PREPINACU; ++i) {
        if (PREPINACE[i] ~ /^-[efhlpPrt]$/) {
            if (akce == "") {
                akce = substr(PREPINACE[i], 2);
            } else if (akce != substr(PREPINACE[i], 2)) {
                ShoditFatalniVyjimku("Spouštěč LKK dovoluje pouze jednu akci na volání!");
            }
        }
    }
    if (akce == "") {akce = "r"}

    if (POCET_PREPINACU == 0 && POCET_ARGUMENTU == 0) {
        print "lkk: Chybí název skriptu! Pro nápovědu zadejte: lkk --help" > stderr;
        exit 1;
    }

    # 2. Skript musí být zadán, ledaže ho akce nevyžaduje.
    if (akce !~ /^[hlP]$/ && (POCET_ARGUMENTU == 0 || ARGUMENTY[0] == "")) {
        ShoditFatalniVyjimku("Chybí název skriptu!");
    }

    # akce "h" (vypsat nápovědu)
    if (akce == "h") {
        print "„lkk“ − užití:" > stdout;
        print "\tlkk -e {skript} :: Vytvoří uživatelovu kopii skriptu a otevře ji ve výchozím editoru (sensible-editor)." > stdout;
        print "\tlkk -f {skript} :: Vypíše úplnou (absolutní) cestu k zadanému skriptu." > stdout;
        print "\tlkk -l          :: Vypíše seznam dostupných skriptů." > stdout;
        print "\tlkk -p {skript} :: Vypíše obsah skriptu na standardní výstup." > stdout;
        print "\tlkk [-r] [--] {skript} [parametry...] :: Spustí skript se zadanými parametry." > stdout;
        print "\tlkk -t {skript} :: Jen ověří, že daný skript existuje." > stdout;
        print "\tlkk --seznam-cest :: Vypíše seznam cest (i neexistujících), kde hledá skripty." > stdout;
        print "\nDalší volby:\n\t-s :: Skripty hledat jen v /usr/share/lkk/skripty; ignorovat proměnnou LKKPATH a uživatelské úložiště ~/.config/lkk/skripty." > stdout;
        print "\t-x :: Ignorovat nespustitelné skripty (tzv. úryvky)." > stdout;
        exit;
    }

    # 3. Sestavit seznam cest k prohledání.
    if ("-s" in PREP_VOLBY) {
        cesty[cest = 1] = "/usr/share/lkk/skripty";
    } else if ("LKKPATH" in ENVIRON) {
        cest = split(ENVIRON["LKKPATH"], cesty, ":");
    } else {
        cest = split(ENVIRON["HOME"] "/.config/lkk/skripty:/usr/share/lkk/skripty", cesty, ":");
    }

    # akce "l" (vypsat seznam dostupných skriptů)
    if (akce == "l") {
        if (cest == 0) {exit}
        prikaz = "find"
        for (i = 1; i <= cest; ++i) {
            if (system("test -r " DoApostrofu(cesty[i])) == 0) {
                prikaz = prikaz " " DoApostrofu(cesty[i]);
            }
        }
        if (prikaz == "find") {exit}
        prikaz = prikaz " -mindepth 1 -maxdepth 1" ("-x" in PREP_VOLBY ? " -executable" : "") " -printf '%f\\n' | sort -u";
        print prikaz > bashout;
        exit;
    }

    # akce "P" (vypsat seznam prohledávaných cest)
    if (akce == "P") {
        for (i = 1; i <= cest; ++i) {print cesty[i] > stdout}
        exit;
    }

    # 4. Vyhledat skript.
    skriptu = 0;
    test = ("-x" in PREP_VOLBY) ? "-x" : "-r";
    if (ARGUMENTY[0] ~ /^\//) {
        # absolutní cesta
        nova_cesta = VyhledatSkript("", ARGUMENTY[0]);
    } else {
        for (i = 1; i <= cest; ++i) {
            nova_cesta = VyhledatSkript(cesty[i], ARGUMENTY[0]);
            if (nova_cesta != "") {break}
        }
    }

    # akce "f" (najít skript) a "t" (existuje skript?)
    if (akce ~ /[ft]/) {
        if (nova_cesta == "") {exit 1}
        if (akce == "f") {print nova_cesta > stdout}
        exit;
    }

    # 5. Spustit akci.
    switch (akce) {
        case "e": # editovat
            if (nova_cesta != ENVIRON["HOME"] "/.config/lkk/skripty/" ARGUMENTY[0]) {
                print "mkdir -pv ~/.config/lkk/skripty && cp -- " DoApostrofu(nova_cesta) " " DoApostrofu(ENVIRON["HOME"] "/.config/lkk/skripty/" ARGUMENTY[0]) " && \\" > bashout;
            }
            print "exec sensible-editor " DoApostrofu(ENVIRON["HOME"] "/.config/lkk/skripty/" ARGUMENTY[0]) > bashout;
            exit;
        case "p": # vypsat skript
            print "exec cat " DoApostrofu(nova_cesta) > bashout;
            exit;
        case "r": # spustit skript
            prikaz = "exec " DoApostrofu(nova_cesta);
            for (i = 1; i < POCET_ARGUMENTU; ++i) {
                prikaz = prikaz " " DoApostrofu(ARGUMENTY[i]);
            }
            print prikaz > bashout;
            exit;
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
