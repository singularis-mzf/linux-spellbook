# Linux Kniha kouzel, skript postprocess.awk
# Copyright (c) 2019 Singularis <singularis@volny.cz>
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
    POSTPROCESS_TSV = "soubory_prekladu/postprocess.tsv";
    if (system("test -r " POSTPROCESS_TSV) != 0) {
        ShoditFatalniVyjimku("Nemohu číst ze souboru " POSTPROCESS_TSV "!");
    }
    if (IDFORMATU == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná IDFORMATU není nastavena pomocí parametru -v!");
    }
    if (IDKAPITOLY == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná IDKAPITOLY není nastavena pomocí parametru -v!");
    }

    split("", NAHRADY); # zdroj-text => id-náhrady
    split("", TEXT_NAHRADY_ZDROJ); # id-náhrady => zdroj-text
    split("", TEXT_NAHRADY_CIL); # id-náhrady => cíl-text
    split("", POCET_NAHRAD); # id-náhrady => počítadlo

    while (getline < POSTPROCESS_TSV) {
        # formát: <id-náhrady>[TAB]<id-formátu>[TAB]<id-kapitoly>[TAB]<původní řádek>[TAB]<nový řádek>
        # řádky začínající # a prázdné řádky se vynechávají
        split($0, sloupce, "\t");
        if ($0 != "" && substr($0, 1, 1) != "#" && sloupce[2] == IDFORMATU && sloupce[3] == IDKAPITOLY) {
            idnahrady = sloupce[1];
            z = sloupce[4];
            na = sloupce[5];

            if (idnahrady == "") {
                ShoditFatalniVyjimku("Prázdné id náhrady!");
            }
            if (z == na) {
                ShoditFatalniVyjimku("Neplatná náhrada id " idnahrady ": řádek se nemění.");
            }
            if (idnahrady in POCET_NAHRAD) {
                ShoditFatalniVyjimku("ID náhrady se opakuje: " idnahrady);
            }
            if (z in NAHRADY) {
                ShoditFatalniVyjimku("Víceznačná náhrada pro stejný text: id " NAHRADY[z] " a " idnahrady "!");
            }
            NAHRADY[z] = idnahrady;
            TEXT_NAHRADY_ZDROJ[idnahrady] = z;
            TEXT_NAHRADY_CIL[idnahrady] = na;
            POCET_NAHRAD[idnahrady] = 0;
        }
    }
    close(POSTPROCESS_TSV);
}

$0 in NAHRADY {
    idnahrady = NAHRADY[$0];
    $0 = TEXT_NAHRADY_CIL[idnahrady];
    ++POCET_NAHRAD[idnahrady];
}

{
    print;
}

function Popis(z, na,   i) {
    if (z == na) {
        ShoditFatalniVyjimku("Interní chyba: z == na nesmí nastat.");
    }
    gsub(/\t/, "\\t", z);
    gsub(/\t/, "\\t", na);
    for (i = 1; substr(z, i, 1) == substr(na, i, 1); ++i) {
    }
    i = i > 8 ? i - 8 : 1;
    return "..." substr(z, i, 16) "... => ..." substr(na, i, 16) "...";
}

END {
    if (LOGSOUBOR != "" && length(POCET_NAHRAD) > 0) {
        prikaz = "sort -n >>\"" LOGSOUBOR "\"";
        for (idnahrady in POCET_NAHRAD) {
            # <počet-použití>[TAB]<id-náhrady>[TAB]<id-kapitoly>@<formát>[TAB]popis
            print POCET_NAHRAD[idnahrady] "\t" idnahrady "\t" IDKAPITOLY "@" IDFORMATU "\t" Popis(TEXT_NAHRADY_ZDROJ[idnahrady], TEXT_NAHRADY_CIL[idnahrady]) | prikaz;
        }
        close(prikaz);
    }

    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
}
