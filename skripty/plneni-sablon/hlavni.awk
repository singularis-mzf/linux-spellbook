# Linux Kniha kouzel, skript plneni-sablon/hlavni.awk
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

BEGIN {
    FS = OFS = "\t";
    RS = ORS = "\n";
    BYL_ZACATEK = 0;
    if (VARIANTA == "") {VARIANTA = "bez-nazvu"}
    STAV_PODMINENENO_PREKLADU = 0;
}

function VyzadujeFragmentyTSV() {
    FRAGMENTY_TSV = "soubory_prekladu/fragmenty.tsv";
    if (!Test("-r " FRAGMENTY_TSV)) {
        ShoditFatalniVyjimku("Nemohu číst ze souboru " FRAGMENTY_TSV "!");
    }
    return 1;
}

function VyzadujePromennou(nazev, popisChyby) {
    if (SYMTAB[nazev] == "") {
        ShoditFatalniVyjimku(popisChyby == "" ? "Vyžadovaná proměnná " nazev " není nastavena!" : popisChyby);
    }
    return 1;
}

$0 == "{{ZAČÁTEK}}" {
    if (!BYL_ZACATEK) {
        BYL_ZACATEK = 1;
        $0 = "";
        Zacatek();
        STAV_PODMINENENO_PREKLADU = (VARIANTA == "bez-nazvu" ? 0 : 3);
        next;
    } else {
        ShoditFatalniVyjimku("Opakovaný {{ZAČÁTEK}}!");
    }
}

!BYL_ZACATEK && /^\{\{[^{}]+\}\}$/ {
    ShoditFatalniVyjimku("První řídicí řádek šablony musí být {{ZAČÁTEK}}!");
}

# Zpracování variant ({{VARIANT[AY] ...}})
# ====================================================
(s = gensub(/^\{\{VARIANT[AY] ([^{}]+)\}\}$/, ",\\1,", 1)) != $0 {
    if (STAV_PODMINENENO_PREKLADU != 0 && STAV_PODMINENENO_PREKLADU != 3) {
        ShoditFatalniVyjimku("Uvnitř bloku {{POKUD ...}} nelze přepínat variantu!");
    }
    STAV_PODMINENENO_PREKLADU = (index(s, "," VARIANTA ",") ? 0 : 3);
    #print $0 ": Měním STAV_PODMINENENO_PREKLADU na " STAV_PODMINENENO_PREKLADU > "/dev/stderr";
    next;
}

STAV_PODMINENENO_PREKLADU == 3 {next}

# Podmíněný překlad
# ====================================================
# 0 - mimo podmíněný blok
# 1 - v podmíněném bloku, ale tiskne se
# 2 - v podmíněném bloku, přeskakuje se
# 3 - mimo podmíněný blok, ale řádek nepřísluší aktivní variantě šablony
#
/^\{\{POKUD .*\}\}$/ {
    if (STAV_PODMINENENO_PREKLADU != 0) {
        ShoditFatalniVyjimku("Chyba syntaxe: {{POKUD ...}} bez ukončení předchozího podmíněného bloku!");
    }
    STAV_PODMINENENO_PREKLADU = Pokud(substr($0, 9, length($0) - 10)) ? 1 : 2;
    next;
}

/^\{\{KONEC POKUD\}\}$/ {
    if (STAV_PODMINENENO_PREKLADU != 0) {
        STAV_PODMINENENO_PREKLADU = 0;
        next;
    } else {
        ShoditFatalniVyjimku("{{KONEC POKUD}} bez odpovídajícího začátku");
    }
}

STAV_PODMINENENO_PREKLADU == 2 {next}

# Řídicí řádky
# ====================================================
/^\{\{[^{}]+\}\}$/ {
    $0 = substr($0, 3, length($0) - 4);
    if ($0 == "KONEC") {exit}
    RidiciRadek($0);
    next;
}

# Obyčejné řádky
# ====================================================
BYL_ZACATEK {
    print PrelozitVystup($0);
}

END {
    if (!FATALNI_VYJIMKA && !BYL_ZACATEK) {
        ShoditFatalniVyjimku("Vadná šablona: nebyl začátek!");
    }
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
    Konec();
}
