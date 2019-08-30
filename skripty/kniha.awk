# Linux Kniha kouzel, skript kniha.awk
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

function ExistujeKapitola(idkapitoly) {
    return system("test -r '" VstupniSoubor(idkapitoly) "'") == 0;
}

function VstupniSoubor(idkapitoly) {
    return VSTUPPREFIX idkapitoly VSTUPSUFFIX;
}

BEGIN {
    if (ENVIRON["SEZNAMKAPITOL"] == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná SEZNAMKAPITOL není nastavena!");
    }
    if (ENVIRON["VSTUPPREFIX"] == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná VSTUPPREFIX není nastavena!");
    }
    # ENVIRON["VSTUPSUFFIX"] je nepovinná

    VSTUPPREFIX = ENVIRON["VSTUPPREFIX"];
    VSTUPSUFFIX = ENVIRON["VSTUPSUFFIX"];
    split("", KAPITOLY);

    while ((getline < (ENVIRON["SEZNAMKAPITOL"])) == 1) {
        if (!($0 ~ /^(#| *$)/)) {
            if (!ExistujeKapitola($0)) {
                ShoditFatalniVyjimku("Kapitola s id \"" $0 "\" neexistuje, není dostupná nebo nebyla řádně přeložena!");
            }
            KAPITOLY[length(KAPITOLY) + 1] = $0;
        }
    }

    close(ENVIRON["SEZNAMKAPITOL"]);
}

{
    JE_RIDICI_RADEK = $0 ~ /^\{\{[^{}]+\}\}$/;
    VYTISKNOUT = 0;
}

/^\{\{ZAČÁTEK KNIHY\}\}$/,/^\{\{ZAČÁTEK KAPITOLY\}\}$/ {
    VYTISKNOUT =  !JE_RIDICI_RADEK;
}

/^\{\{KONEC KAPITOLY\}\}$/,/^\{\{KONEC KNIHY\}\}$/ {
    VYTISKNOUT =  !JE_RIDICI_RADEK;
    if ($0 == "{{KONEC KAPITOLY}}") {
        prikaz = "cat";
        for (i = 1; i <= length(KAPITOLY); ++i) {
            prikaz = prikaz " " VstupniSoubor(KAPITOLY[i]);
        }
        vysledek = system(prikaz);
        if (vysledek != 0) {
            exit vysledek;
        }
    }
}

VYTISKNOUT {
    print $0;
}

END {
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
}
