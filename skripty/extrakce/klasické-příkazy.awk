# Linux Kniha kouzel, skript extrakce/klasické-příkazy.awk
# Copyright (c) 2021 Singularis <singularis@volny.cz>
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

@include "skripty/utility.awk"

BEGIN {
    FS = "\t";
    OFS = "";
    RS = ORS = "\n";

    SOUBORY_PREKLADU = ENVIRON["SOUBORY_PREKLADU"];
    if (SOUBORY_PREKLADU == "") {ShoditFatalniVyjimku("Proměnná SOUBORY_PREKLADU není nastavena!")}
    NacistFragmentyTSV(SOUBORY_PREKLADU "/fragmenty.tsv");

    SEZNAM = "konfigurace/klasické-příkazy.seznam";

    delete klprikazyporadi; # pořadové-číslo -> název
    delete klprikazypopisy; # název -> popis

    prikaz = "sed -E '" \
        "/^(#|$)/d;" \
        "/^\\[příkazy\\]$/,/^\\[/!d;" \
        "/^\\[/d;" \
        "s/\\s+|$/\\t/" \
        "' konfigurace/klasické-příkazy.seznam | LC_ALL=C sort";
    i = 0;
    while (prikaz | getline s) {
        poradi = ++i;
        nazev = gensub(/\t.*/, "", 1, s);
        popis = gensub(/\t/, "", "g", substr(s, 2 + length(nazev)));
        if (nazev in klprikazypopisy) {
            ShoditFatalniVyjimku("Klasický příkaz \"" nazev "\" se v seznamu opakuje!");
        }
        klprikazyporadi[poradi] = nazev;
        klprikazypopisy[nazev] = popis;
        ZkontrolujText(popis);
    }
    close(prikaz);
    #printf("LADĚNÍ: Načteno %d klasických příkazů.\n", length(klprikazyporadi)) > "/dev/stderr";
    delete osnova; # idkapitoly -> xheš -> popis zaklínadla
    delete odkazy; # klasický-příkaz -> pořadové-číslo -> číslo-kapitoly "\t" ploché-id-kapitoly "\t" xhes "\t" popis-úkolu
    klprikaz = "";
}

/^(#|$)/ {next}

/^\[/ {
    if ($0 !~ /^\[[^][]+\]$/) {
        ShoditFatalniVyjimku("Chybný formát řádky: " $0);
    }
    klprikaz = substr($0, 2, length($0) - 2);
    if (!(klprikaz in klprikazypopisy)) klprikaz = "";
    next;
}

klprikaz == "" {next}

# VSTUP:
# id-kapitoly    xheš-zaklínadla    Popis úkolu
# zpracování-binárních-souborů    x0b23bf6    Tabulkový překlad **bajtů**
#

{
    if (!match($0, /\s+/)) {ShoditFatalniVyjimku("Chybná syntaxe řádku: " $0)}
    idkapitoly = substr($0, 1, RSTART - 1);
    s = substr($0, RSTART + RLENGTH);
    if (!match(s, /\s+/)) {ShoditFatalniVyjimku("Chybná syntaxe řádku: " $0)}
    xhes = substr(s, 1, RSTART - 1);
    ukol = gensub(/\t/, " ", "g", gensub(/\s*$/, "", 1, substr(s, RSTART + RLENGTH)));

    ZkontrolujText(ukol);

    #printf("LADĚNÍ: idkapitoly=<%s> xheš=<%s> úkol=<%s>\n", idkapitoly, xhes, ukol) > "/dev/stderr";

    cislokapitoly = FragInfo(idkapitoly "?");
    if (!(cislokapitoly > 0)) {
        printf("VAROVÁNÍ: fragment \"%s\" neexistuje\n", idkapitoly) > "/dev/stderr";
        next;
    }
    if (!(idkapitoly in osnova)) {
        soubor = SOUBORY_PREKLADU "/osnova/" FragInfo(cislokapitoly, "ploché-id") ".tsv";
        #printf("LADĚNÍ: načíst osnovu <%s> (číslo: %s, soubor \"%s\")...\n", idkapitoly, cislokapitoly, soubor);
        i = 0;
        while (getline < soubor) {
            if ($1 == "ZAKLÍNADLO") {
                #printf("LADĚNÍ: načítám xheš <%s> = <%s>\n", $2, $4) > "/dev/stderr";
                osnova[idkapitoly][$2] = $4;
            }
            ++i;
        }
        #printf("LADĚNÍ: přečteno %d řádek osnovy\n", idkapitoly);
        close(soubor);
    }
    if (idkapitoly in osnova && xhes in osnova[idkapitoly]) {
        odkazy[klprikaz][""] = "";
        odkazy[klprikaz][length(odkazy[klprikaz])] = cislokapitoly "\t" FragInfo(cislokapitoly, "ploché-id-bez-diakr") "\t" xhes "\t" ukol;
    } else {
        printf("VAROVÁNÍ: Zaklínadlo s xheší %s nenalezeno v kapitole %s!\n", xhes, idkapitoly) > "/dev/stderr";
    }
}

END {
    # Končíme-li s fatální výjimkou, skončit hned.
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }

    # jinak vygenerovat výstup
    # %<klasický-příkaz>\t<počet-úkolů>\t<popis-klpříkazu>
    # -<číslo-kapitoly>\t<ploché-id-bez-diakr>\t<xheš>\t<úkol>

    for (i = 1; i in klprikazyporadi; ++i) {
        klprikaz = klprikazyporadi[i];
        popis = klprikazypopisy[klprikaz];
        delete odkazy[klprikaz][""];
        pocet = length(odkazy[klprikaz]);
        if (pocet > 0) {
            print "%", klprikaz, "\t", pocet, "\t", popis;
            for (j = 1; j in odkazy[klprikaz]; ++j) {
                print "-", odkazy[klprikaz][j];
            }
        }
    }
}

function ZkontrolujText(text) {
    if (match(text, /[^\-ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789  !?.,;/()áÁčČďĎéÉěĚíÍňŇóÓřŘšŠťŤúÚůŮýÝžŽ]/)) {
        ShoditFatalniVyjimku("Nedovolený znak '" substr(text, RSTART, RLENGTH) "' v popisu klasických příkazů \"" text "\"!");
    }
    return 0;
}
