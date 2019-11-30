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
    FS = "\t";
    OFS = "\t"
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
    ZPRACOVAT = 0;
}

/^\{\{ZAČÁTEK KNIHY\}\}$/,/^\{\{ZAČÁTEK KAPITOLY\}\}$/ {
    ZPRACOVAT = 1;
}

/^\{\{KONEC KAPITOLY\}\}$/,/^\{\{KONEC KNIHY\}\}$/ {
    ZPRACOVAT = 1;
    if ($0 == "{{KONEC KAPITOLY}}") {
        prikaz = "cat";
        while (getline < FRAGMENTY_TSV) {
            prikaz = prikaz " " VSTUPPREFIX $2 VSTUPSUFFIX;
        }
        close(FRAGMENTY_TSV);
        if (prikaz == "cat") {
            ShoditFatalniVyjimku("Žádné kapitoly ani dodatky ke zpracování!");
        }
        vysledek = system(prikaz);
        if (vysledek != 0) {
            exit vysledek;
        }
    }
}

ZPRACOVAT && $0 == "{{PŘEHLED PODLE ŠTÍTKŮ}}" {
    delete stitky;
    prikaz = "cut -f 9 " FRAGMENTY_TSV " | egrep -o '\\{[^}]*\\}' | tr -d '{}' | LC_ALL=\"cs_CZ.UTF-8\" sort -iu";
    while (prikaz | getline) {
        stitky[1 + length(stitky)] = $0;
    }
    close(prikaz);
    for (i = 1; i <= length(stitky); ++i) {
        prvniZaznamNaStitek = 1;
        while (getline < FRAGMENTY_TSV) {
            if (index($9, "{" stitky[i] "}")) {
                if (prvniZaznamNaStitek) {
                    prvniZaznamNaStitek = 0;
                    print "\\begin{ppsstitek}{" stitky[i] "}";
                }
# FRAGMENTY_TSV:
# 1=Adresář|2=ID|3=Název|4=Předchozí ID|5=Předchozí název|6=Následující ID|7=Následující název
# 8=Číslo dodatku/kapitoly|9=Štítky v {}
                stitkykapitoly = $9;
                gsub(/\{/, "\\ppsstitekpolozky{", stitkykapitoly); /\}/; # „/\}/“ jen kvůli zvýrazňování syntaxe, nic nedělá
                omezene_id = $2;
                gsub(/[^A-Za-z0-9]/, "", omezene_id);
                print "\\ppspolozka{" $3 "}{" stitkykapitoly "}{kapx" omezene_id "}%";
            }
        }
        close(FRAGMENTY_TSV);
        if (!prvniZaznamNaStitek) {
            print "\\end{ppsstitek}";
        }
    }
    next;
}

ZPRACOVAT && !JE_RIDICI_RADEK {
    gsub(/\{\{JMÉNO VERZE\}\}/, EscapovatKNahrade(JMENOVERZE));
    print $0;
}

END {
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
}
