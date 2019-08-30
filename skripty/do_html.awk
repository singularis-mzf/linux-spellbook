# Linux Kniha kouzel, skript do_html.awk
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

# Převede odescapovaný znak vstupního formátu (Markdown) do výstupního formátu.
# Pro bílé znaky se volá jedině tehdy, jsou-li escapovány.
function ZpracujZnak(znak) {
    switch (znak) {
        case "<":
            return "&lt;";
        case ">":
            return "&gt;";
        case "&":
            return "&amp;";
        case "\"":
            return "&quot;";

        default:
            return znak;
    }
}

# Převede bílý znak ze vstupního formátu na výstupní.
function ZpracujBilyZnak(znak, opakovany) {
    return (opakovany) ? "" : znak;
}

function ZacatekKapitoly(kapitola) {
    return "<h1>" kapitola "</h1>\n";
}

function KonecKapitoly(kapitola, cislaPoznamek, textyPoznamek,   i, vysledek) {
    vysledek = "";
    if (length(cislaPoznamek) > 0) {
        vysledek = "<div class=\"ppc\">";
        for (i = 0; i < length(cislaPoznamek); ++i) {
            vysledek = vysledek "<div id=\"ppc" cislaPoznamek[i] "\"><sup>" cislaPoznamek[i] "</sup>&nbsp;" textyPoznamek[cislaPoznamek[i]] "</div>\n";
        }
        vysledek = vysledek "</div>\n";
    }
    return vysledek;
}

function ZacatekSekce(kapitola, sekce) {
    return "\n<h2>" sekce "</h2>\n";
}

function KonecSekce(kapitola, sekce) {
    return "";
}

function ZacatekPodsekce(kapitola, sekce, podsekce) {
    return "\n<h3>" podsekce "</h3>\n";
}

function KonecPodsekce(kapitola, sekce, podsekce) {
    return "";
}

function ZacatekOdstavce() {
    return "<p>\n";
}

function KonecOdstavce() {
    return "</p>\n";
}

function KonecRadku() {
    return "<br>";
}

function HypertextovyOdkaz(adresa, text) {
    return "<a href=\"" adresa "\">" text "</a>";
}

function ZacatekSeznamu(uroven) {
    return "<ul>";
}

function ZacatekPolozkySeznamu(uroven) {
    return "<li>";
}

function KonecPolozkySeznamu(uroven) {
    return "</li>";
}

function KonecSeznamu(uroven) {
    return "</ul>";
}

function ZacatekPrikladu(textPrikladu, cislaPoznamek, textyPoznamek,   prvni) {
    if (!isarray(cislaPoznamek) || !isarray(textyPoznamek)) {
        ShoditFatalniVyjimku("ZacatekPrikladu(): Očekáváno pole!");
    }
    vysledek = "<div class=\"priklad\"><div class=\"zahlavi\">" textPrikladu;
    prvni = 1;
    if (length(cislaPoznamek) > 0) {
        vysledek = vysledek "<sup>";
        for (i in cislaPoznamek) {
            if (prvni) {
                prvni = 0;
            } else {
                vysledek = vysledek ",&nbsp;";
            }
            vysledek = vysledek "<a href=\"#ppc" cislaPoznamek[i] "\">" cislaPoznamek[i] "</a>";
        }
        vysledek = vysledek "</sup>";
    }
    vysledek = vysledek "</div>\n";
    return vysledek;
}

function RadekPrikladu(text) {
    return "<div class=\"radekprikladu\">" text "</div>\n";
}

#function Poznamka(text, jeVPrikladu) {
#    return "<div class=\"poznamka\">" text "</div>\n";
#}

function KonecPrikladu() {
    return "</div>\n";
}

function FormatTucne(jeZacatek) {
    return jeZacatek ? "<b>" : "</b>";
}

function FormatKurziva(jeZacatek) {
    return jeZacatek ? "<i>" : "</i>";
}

function FormatDopln(jeZacatek) {
    return jeZacatek ? "<i class=\"dopln\">" : "</i>";
}

function ZnackaVeVystavbe() {
    return "<div>(VE VÝSTAVBĚ)</div>\n";
}

# dostává text poznámek v cílovém formátu
#function OdkazyNaPoznamkyPodCarou(cisla, texty,   i, vysledek) {
#    if (!isarray(cisla) || !isarray(texty)) {
#        ShoditFatalniVyjimku("OdkazyNaPoznamkyPodCarou(): Očekáváno pole!");
#    }
#    vysledek = "";
#    for (i in cisla) {
#        vysledek = vysledek "<sup><a href=\"#ppc" i "\">" i "</a></sup>";
#    }
#    return vysledek;
#}


@include "skripty/hlavni.awk"
