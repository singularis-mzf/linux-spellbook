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
    if (JMENOVERZE == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná JMENOVERZE není nastavena pomocí parametru -v!");
    }
    if (DATUMSESTAVENI == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná DATUMSESTAVENI není nastavena pomocí parametru -v!");
    }
    if (IDFORMATU == "") {
        IDFORMATU = "html";
    }

    DATUM = sprintf("%d. %s %s", substr(DATUMSESTAVENI, 7, 2), MesicVDruhemPade(sprintf("%d", substr(DATUMSESTAVENI, 5, 2))), substr(DATUMSESTAVENI, 1, 4));

    if (FS != "\t") {
        ShoditFatalniVyjimku("Chybně nastavený field separator. Musí být tabulátor. Použijte parametr -F \\\\t při spouštění awk!");
    }


    delete ADRESAR;
    delete CISLO;
    delete ID;
    delete NAZEV;
    delete STITKY;

    delete VYCLENENO;

    PREDEVSIM_PRO = ZjistitPredevsimPro(JMENOVERZE);
    STAV_PODMINENENO_PREKLADU = 0;
    # 0 - mimo podmíněný blok
    # 1 - v podmíněném bloku, ale tiskne se
    # 2 - v podmíněném bloku, přeskakuje se
}

# zvláštní zpracování pro fragmenty.tsv:
ARGIND < 2 {
# 1=Adresář|2=ID|3=Název|4=Předchozí ID|5=Předchozí název|6=Následující ID|7=Následující název
# 8=Číslo dodatku/kapitoly|9=Štítky v {}
    ADRESAR[FNR] = $1;
    CISLO[FNR] = $8;
    ID[FNR] = $2;
    NAZEV[FNR] = $3;
    STITKY[FNR] = $9 != "NULL" ? $9 : "";
    VYCLENENO[FNR] = 0;
    next;
}

# Podmíněný překlad
# ====================================================
/^\{\{POKUD JE FORMÁT .+\}\}$/ {
    if (STAV_PODMINENENO_PREKLADU != 0) {
        ShoditFatalniVyjimku("Chyba syntaxe: {{POKUD JE FORMÁT ...}} bez ukončení předchozího podmíněného bloku!");
    }
    STAV_PODMINENENO_PREKLADU = (substr($0, 19, length($0) - 20) == IDFORMATU) ? 1 : 2;
    next;
}

/^\{\{POKUD ZNÁME PŘEDEVŠÍM PRO\}\}$/ {
    if (STAV_PODMINENENO_PREKLADU != 0) {
        ShoditFatalniVyjimku("Chyba syntaxe: {{POKUD ...}} bez ukončení předchozího podmíněného bloku!");
    }
    STAV_PODMINENENO_PREKLADU = (PREDEVSIM_PRO != "") ? 1 : 2;
    next;
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

# Zbytek zpracování šablony
# ====================================================
function VypsatOdkazNaKapitolu(i, vyclenit) {
    print "<li value=\"" CISLO[i] "\"><a href=\"" ID[i] ".htm\">" NAZEV[i] "</a></li>";
    if (vyclenit) {
        VYCLENENO[i] = 1;
    }
}
#    JE_RIDICI_RADEK = $0 ~ /^\{\{[^{}]+\}\}$/;

/^\{\{COPYRIGHTY (KAPITOL|OBRÁZKŮ)\}\}$/ {
    ShoditFatalniVyjimku($0 "již nejsou v index.html podporovány!");
}

{ZPRACOVAT = 0;}
/^\{\{ZAČÁTEK KNIHY\}\}$/,/^\{\{ZAČÁTEK KAPITOLY\}\}$/ {ZPRACOVAT = 1;}
/^\{\{KONEC KAPITOLY\}\}$/,/^\{\{KONEC KNIHY\}\}$/ {ZPRACOVAT = 1;}
/^\{\{((ZAČÁTEK|KONEC) (KNIHY|KAPITOLY))\}\}$/ || !ZPRACOVAT {next;}

/^\{\{VYČLENIT SEM PODLE ID:[^}]*\}\}$/ {
    s = substr($0, 25, length($0) - 26);
    for (i = 1; i <= length(ID); ++i) {
        if (ID[i] == s) {
            VypsatOdkazNaKapitolu(i, 1);
        }
    }
    next;
}

/^\{\{VYČLENIT SEM PODLE ŠTÍTKU:[^}]*\}\}$/ {
    s = substr($0, 29, length($0) - 30);
    for (i = 1; i <= length(ID); ++i) {
        if (index(STITKY[i], "{" s "}")) {
            VypsatOdkazNaKapitolu(i, 1);
        }
    }
    next;
}

/^\{\{VYPSAT ZBYTEK PO VYČLENĚNÍ\}\}$/ {
    for (i = 1; i <= length(ID); ++i) {
        if (!VYCLENENO[i]) {
            VypsatOdkazNaKapitolu(i, 0);
        }
    }
    next;
}

/^\{\{VYPSAT ZBYTEK KAPITOL\}\}$/ {
    for (i = 1; i <= length(ID); ++i) {
        if (!VYCLENENO[i] && ADRESAR[i] == "kapitoly") {
            VypsatOdkazNaKapitolu(i, 0);
        }
    }
    next;
}

/^\{\{VYPSAT ZBYTEK DODATKŮ\}\}$/ {
    for (i = 1; i <= length(ID); ++i) {
        if (!VYCLENENO[i] && ADRESAR[i] == "dodatky") {
            VypsatOdkazNaKapitolu(i, 0);
        }
    }
    next;
}


/\{\{(DATUM ?SESTAVENÍ|JMÉNO VERZE|PŘEDEVŠÍM PRO)\}\}/ {
    gsub(/\{\{DATUM SESTAVENÍ\}\}/, DATUM);
    gsub(/\{\{DATUMSESTAVENÍ\}\}/, DATUMSESTAVENI);
    gsub(/\{\{JMÉNO VERZE\}\}/, EscapovatKNahrade(JMENOVERZE));
    gsub(/\{\{PŘEDEVŠÍM PRO\}\}/, EscapovatKNahrade(PREDEVSIM_PRO));
}

/^\{\{.*\}\}$/ {
    ShoditFatalniVyjimku("Nezpracovaný řídicí řádek: " $0);
}

{
    print;
}

END {
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
}
