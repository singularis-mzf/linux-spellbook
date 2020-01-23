# Linux Kniha kouzel, skript extrakce/osnova.awk
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

function ZpracujZnak(c) { return c; }

# Tato funkce vezme řádek textu ve vstupním formátu (Markdown)
# a znak po znaku jej zkonvertuje do výstupního formátu.
# Používá se pro zpracování částí textu, které nepodporují formátování.
function ZpracujZnaky(text,     VSTUP, VYSTUP, ZNAK) {
    VSTUP = text;
    VYSTUP = "";

    # tabulátory nahradit mezerami, aby nedělaly potíže:
    gsub(/\t/, " ", VSTUP);

    while (VSTUP != "") {
        ZNAK = substr(VSTUP, 1, 1);

        if (ZNAK == "\\" && length(VSTUP) > 1) {
            VYSTUP = VYSTUP ZpracujZnak(substr(VSTUP, 2, 1));
            VSTUP = substr(VSTUP, 3);
        } else if (substr(VSTUP, 1, 7) == "&blank;") {
            VYSTUP = VYSTUP ZpracujZnak("␣");
            VSTUP = substr(VSTUP, 8);
        } else if (substr(VSTUP, 1, 4) == "&lt;") {
            VYSTUP = VYSTUP ZpracujZnak("<");
            VSTUP = substr(VSTUP, 5);
        } else if (substr(VSTUP, 1, 4) == "&gt;") {
            VYSTUP = VYSTUP ZpracujZnak(">");
            VSTUP = substr(VSTUP, 5);
        } else if (substr(VSTUP, 1, 5) == "&amp;") {
            VYSTUP = VYSTUP ZpracujZnak("&");
            VSTUP = substr(VSTUP, 6);
        } else if (substr(VSTUP, 1, 5) == "&apo;") {
            VYSTUP = VYSTUP ZpracujZnak("'");
            VSTUP = substr(VSTUP, 6);
        } else if (substr(VSTUP, 1, 6) == "&nbsp;") {
            VYSTUP = VYSTUP ZpracujZnak(" ");
            VSTUP = substr(VSTUP, 7);
        } else if (substr(VSTUP, 1, 6) == "&quot;") {
            VYSTUP = VYSTUP ZpracujZnak("\"");
            VSTUP = substr(VSTUP, 7);
        } else {
            VYSTUP = VYSTUP ZpracujZnak(ZNAK);
            VSTUP = substr(VSTUP, 2);
        }
    }

    return VYSTUP;
}

# #1=TYP #2=ID #3=ČÍSLO_ŘÁDKU #4=NÁZEV #5=;

function VypsatPolozkuOsnovy(typ, id, cislo_radku, nazev, zarazka) {
    if (zarazka != ZARAZKA) {
        ShoditFatalniVyjimku("Interní chyba: chybné volání VypsatPolozkuOsnovy()!");
    }
    print typ, id, cislo_radku, nazev, ";";
    return 1;
}

BEGIN {
    if (IDKAPITOLY == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná IDKAPITOLY není vyplněna!");
    }
    FS = "\t";
    OFS = "\t";
    prikaz = "egrep '^[^\t]*\t" IDKAPITOLY "\t' soubory_prekladu/fragmenty.tsv";
    prikaz | getline;
    close(prikaz);

    if ($0 == "") {
        # Neznámé ID kapitoly, pravděpodobně se daná kapitola nebude generovat.
        exit;
    }
    c_kapitoly = $8;
    SOUBOR = $1 "/" $2 ".md";
    ZARAZKA = "\x01\x02XYZ";

#    ID_KAPITOLY_OMEZENE = IDKAPITOLY;
#    gsub(/[^A-Za-z0-9]/, "", ID_KAPITOLY_OMEZENE);
    c_sekce = 0;
    c_podsekce = 0;
    c_zaklinadla = 0;
    FATALNI_VYJIMKA = 0;
    JE_UVNITR_KOMENTARE = 0;
}

# komentář započatý na samostatném řádku kompletně ignorovat
# (není to ideální řešení, ale dokonalejší řešení jsou problematická)
/^<!--$/,/^-->$/ {
    JE_UVNITR_KOMENTARE = ($0 != "-->");
    next;
}

# vypustit z řádku inline komentáře (popř. je zpracovat)
/<!--.*-->/ {
    while ((i = index($0, "<!--")) && (j = 4 + index(substr($0, i + 4), "-->"))) {
        $0 = substr($0, 1, i - 1) substr($0, i + j + 2);
    }
}

/^#{1,3} .+/ {
    switch (index($0, " ")) {
    case 2:
        VypsatPolozkuOsnovy("KAPITOLA", c_kapitoly, FNR, ZpracujZnaky(substr($0, 3)), ZARAZKA);
        c_sekce = 0;
        c_podsekce = 0;
        break;
    case 3:
        VypsatPolozkuOsnovy("SEKCE", ++c_sekce, FNR, ZpracujZnaky(substr($0, 4)), ZARAZKA);
        c_podsekce = 0;
        break;
    case 4:
        VypsatPolozkuOsnovy("PODSEKCE", c_sekce "x" (++c_podsekce), FNR, ZpracujZnaky(substr($0, 5)), ZARAZKA);
        break;
    }
}

END {
    # Končíme-li s fatální výjimkou, skončit hned.
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }

    # Neukončený komentář?
    if (JE_UVNITR_KOMENTARE) {
        ShoditFatalniVyjimku("Komentář otevřený samostatným řádkem \"<!--\" musí být ukončený v rámci téhož zdrojového souboru samostatným řádkem \"-->\".");
    }
}
