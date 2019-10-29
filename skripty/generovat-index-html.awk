# Linux Kniha kouzel, skript generovat-index-html.awk
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
    FRAGMENTY_TSV = "soubory_prekladu/fragmenty.tsv";
    if (system("test -r " FRAGMENTY_TSV) != 0) {
        ShoditFatalniVyjimku("Nemohu číst ze souboru " FRAGMENTY_TSV "!");
    }
    if (JMENOVERZE == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná JMENOVERZE není nastavena pomocí parametru -v!");
    }
    if (IDFORMATU == "") {
        IDFORMATU = "html";
    }
    KAP_COPYS = "soubory_prekladu/" IDFORMATU "/kap-copys.htm";
    OBR_COPYS = "soubory_prekladu/" IDFORMATU "/obr-copys.htm";

    if (system("test -r " KAP_COPYS) != 0) {
        ShoditFatalniVyjimku("Nemohu číst ze souboru " KAP_COPYS "!");
    }
    if (system("test -r " OBR_COPYS) != 0) {
        ShoditFatalniVyjimku("Nemohu číst ze souboru " OBR_COPYS "!");
    }

    split("", KAPITOLY);
    STAV_PODMINENENO_PREKLADU = 0;
    # 0 - mimo podmíněný blok
    # 1 - v podmíněném bloku, ale tiskne se
    # 2 - v podmíněném bloku, přeskakuje se

    CAS = systime();
    DATUM = strftime("%-d. ", CAS) MesicVDruhemPade(strftime("%-m", CAS)) strftime(" %Y", CAS);
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

/^\{\{COPYRIGHTY KAPITOL\}\}$/ {
    system("cat '" KAP_COPYS "'");
    next;
}

/^\{\{COPYRIGHTY OBRÁZKŮ\}\}$/ {
    system("cat '" OBR_COPYS "'");
    next;
}

/^\{\{ZAČÁTEK KNIHY\}\}$/,/^\{\{ZAČÁTEK KAPITOLY\}\}$/ {
    VYTISKNOUT =  !JE_RIDICI_RADEK;
}

/^\{\{KONEC KAPITOLY\}\}$/,/^\{\{KONEC KNIHY\}\}$/ {
    VYTISKNOUT =  !JE_RIDICI_RADEK;
    if ($0 == "{{KONEC KAPITOLY}}") {
        while (getline < FRAGMENTY_TSV) {
            split($0, sloupce, "\t");
            print "<li value=\"" sloupce[8] "\"><a href=\"" sloupce[2] ".htm\">" sloupce[3] "</a></li>";
        }
    }
}

VYTISKNOUT {
    gsub(/\{\{DATUM SESTAVENÍ\}\}/, DATUM);
    gsub(/\{\{JMÉNO VERZE\}\}/, EscapovatKNahrade(JMENOVERZE));
    print $0;
}

END {
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
}
