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

function VstupniSoubor(idkapitoly) {
    return VSTUPPREFIX idkapitoly VSTUPSUFFIX;
}

BEGIN {
    FRAGMENTY_TSV = "soubory_prekladu/fragmenty.tsv";
    if (system("test -r " FRAGMENTY_TSV) != 0) {
        ShoditFatalniVyjimku("Nemohu číst ze souboru " FRAGMENTY_TSV "!");
    }
    if (VSTUPPREFIX == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná VSTUPPREFIX není nastavena pomocí parametru -v!");
    }
    if (IDFORMATU == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná IDFORMATU není nastavena pomocí parametru -v!");
    }
    if (JMENOVERZE == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná JMENOVERZE není nastavena pomocí parametru -v!");
    }
    # Proměnná VSTUPSUFFIX je nepovinná

    split("", KAPITOLY);
    STAV_PODMINENENO_PREKLADU = 0;
    # 0 - mimo podmíněný blok
    # 1 - v podmíněném bloku, ale tiskne se
    # 2 - v podmíněném bloku, přeskakuje se
}

# Podmíněný překlad
# ====================================================
/^\{\{POKUD JE FORMÁT .+\}\}$/ {
    if (STAV_PODMINENENO_PREKLADU != 0) {
        ShoditFatalniVyjimku("Chyba syntaxe: {{POKUD JE FORMÁT ...}} bez ukončení předchozího podmíněného bloku!");
    }
    STAV_PODMINENENO_PREKLADU = (substr($0, 19, length($0) - 20) == IDFORMATU) ? 1 : 2;
}

# správně zpracovat neznámé direktivy „{{POKUD}}“
/^\{\{POKUD .*\}\}$/ {
    if (STAV_PODMINENENO_PREKLADU == 0) {
        STAV_PODMINENENO_PREKLADU = 1;
        next;
    }
}

/^\{\{KONEC POKUD\}\}$/ {
    if (STAV_PODMINENENO_PREKLADU != 0) {
        STAV_PODMINENENO_PREKLADU = 0;
        next;
    } else {
        ShoditFatalniVyjimku("{{KONEC POKUD}} bez odpovídajícího začátku");
    }
}

STAV_PODMINENENO_PREKLADU == 2 {
    next;
}

# Zbytek zpracování
# ====================================================
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
        while (getline < FRAGMENTY_TSV) {
            split($0, sloupce, "\t");
            prikaz = prikaz " " VSTUPPREFIX sloupce[2] VSTUPSUFFIX;
        }
        if (prikaz == "cat") {
            ShoditFatalniVyjimku("Žádné kapitoly ani dodatky ke zpracování!");
        }
        vysledek = system(prikaz);
        if (vysledek != 0) {
            exit vysledek;
        }
    }
}

VYTISKNOUT {
    gsub(/\{\{JMÉNO VERZE\}\}/, EscapovatKNahrade(JMENOVERZE));
    print $0;
}

END {
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
}
