# Linux Kniha kouzel, skript do_logu.awk
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

function ZpracujZnak(znak) {
    return "('" znak "')";
}

function ZpracujBilyZnak(znak, opakovany) {
    return "{" znak (opakovany ? "+" : "") "}";
#    return "ZpracujBilyZnak('" znak "', opakovany = " (opakovany ? "TRUE" : "FALSE") ");";
}

function ZacatekKapitoly(kapitola) {
    return "ZacatekKapitoly(\"" kapitola "\");\n";
}

function KonecKapitoly(kapitola) {
    return "KonecKapitoly(\"" kapitola "\");\n";
}

function ZacatekSekce(kapitola, sekce) {
    return "ZacatekSekce(\"" kapitola "\", \"" sekce "\");\n";
}

function KonecSekce(kapitola, sekce) {
    return "KonecSekce(\"" kapitola "\", \"" sekce "\");\n";
}

function ZacatekPodsekce(kapitola, sekce, podsekce) {
    return "ZacatekPodsekce(\"" kapitola "\", \"" sekce "\", \"" podsekce "\");\n";
}

function KonecPodsekce(kapitola, sekce, podsekce) {
    return "KonecPodsekce(\"" kapitola "\", \"" sekce "\", \"" podsekce "\");\n";
}

function ZacatekOdstavce() {
    return "ZacatekOdstavce();\n";
}

function KonecOdstavce() {
    return "KonecOdstavce();\n";
}

function KonecRadku() {
    return "KonecRadku();\n";
}

function HypertextovyOdkaz(adresa, text) {
    return "HypertextovyOdkaz(adresa = \"" adresa "\", text = \"" text "\");\n";
}

function ZacatekSeznamu(uroven) {
    return "ZacatekSeznamu(" uroven ");\n";
}

function ZacatekPolozkySeznamu(uroven) {
    return "ZacatekPolozkySeznamu(" uroven ");\n";
}

function KonecPolozkySeznamu(uroven) {
    return "KonecPolozkySeznamu(" uroven ");\n";
}

function KonecSeznamu(uroven) {
    return "KonecSeznamu(" uroven ");\n";;
}

function ZacatekPrikladu(textPrikladu) {
    return "  ZacatekPrikladu(\"" textPrikladu "\");\n";
}

function RadekPrikladu(text) {
    return "    RadekPrikladu(\"" text "\")\n";
}

function Poznamka(text, jeVPrikladu) {
    return (jeVPrikladu ? "    " : "") "Poznamka(\"" text "\", jeVPrikladu = " (jeVPrikladu ? "TRUE" : "FALSE") ");\n";
}

function KonecPrikladu() {
    return "  KonecPrikladu();\n";
}

function FormatTucne(jeZacatek) {
    return "FormatTucne[" (jeZacatek ? "zacatek" : "konec") "]";
}

function FormatKurziva(jeZacatek) {
    return "FormatKurziva[" (jeZacatek ? "zacatek" : "konec") "]";
}

function FormatDopln(jeZacatek) {
    return "FormatDopln[" (jeZacatek ? "zacatek" : "konec") "]";
}

function ZnackaVeVystavbe() {
    return "ZnackaVeVystavbe();\n";
}

@include "skripty/hlavni.awk"
