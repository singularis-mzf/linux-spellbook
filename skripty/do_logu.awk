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
    return "_" znak;
}

function ZpracujBilyZnak(znak, opakovany) {
    return "{" znak (opakovany ? "+" : "") "}";
#    return "ZpracujBilyZnak('" znak "', opakovany = " (opakovany ? "TRUE" : "FALSE") ");";
}

function Tabulator(delka) {
    return "Tabulator(" delka ")";
}

function ZacatekKapitoly(kapitola, cisloKapitoly) {
    return "ZacatekKapitoly(\"" kapitola "\");\n";
}

function KonecKapitoly(kapitola, cislaPoznamek, textyPoznamek,   i, vysledek) {
    if (!isarray(cislaPoznamek) || !isarray(textyPoznamek)) {
        ShoditFatalniVyjimku("KonecKapitoly(): Očekáváno pole!");
    }
    if (length(cislaPoznamek) > 0) {
        vysledek = "PoznamkyPodCarou[{\n"
        for (i = 0; i < length(cislaPoznamek); ++i) {
            if (!(i in cislaPoznamek)) {
                ShoditFatalniVyjimku("Vnitřní chyba: v poli cislaPoznamek[] chybí index [" i "]!");
            }
            if (!(cislaPoznamek[i] in textyPoznamek)) {
                ShoditFatalniVyjimku("Vnitřní chyba: v poli textyPoznamek[] chybí index [" cislaPoznamek[i] "] vyžadovaný prvkem cislaPoznamek[" i "]!");
            }
            vysledek = vysledek "  " cislaPoznamek[i] " = (" textyPoznamek[cislaPoznamek[i]] "),\n";
        }
        vysledek = vysledek "}];\n";
    }
    vysledek = vysledek "KonecKapitoly(\"" kapitola "\");\n";
    return vysledek;
}

function ZacatekSekce(kapitola, sekce, cisloKapitoly, cisloSekce) {
    return "ZacatekSekce(\"" kapitola "\", \"" sekce "\");\n";
}

function KonecSekce(kapitola, sekce) {
    return "KonecSekce(\"" kapitola "\", \"" sekce "\");\n";
}

function ZacatekPodsekce(kapitola, sekce, podsekce, cisloKapitoly, cisloSekce, cisloPodsekce) {
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

function ZacatekPrikladu(cisloPrikladu, textPrikladu, cislaPoznamek, textyPoznamek,   vysledek) {
    if (!isarray(cislaPoznamek) || !isarray(textyPoznamek)) {
        ShoditFatalniVyjimku("ZacatekPrikladu(): Očekáváno pole!");
    }

    vysledek = "ZacatekPrikladu(" cisloPrikladu ", \"" textPrikladu "\", {";
    for (i = 0; i < length(cislaPoznamek); ++i) {
        if (!(i in cislaPoznamek)) {
            ShoditFatalniVyjimku("Vnitřní chyba: v poli cislaPoznamek očekáván index [" i "]!");
        }
        vysledek = vysledek cislaPoznamek[i] ", ";
    }
    vysledek = vysledek "}[" length(cislaPoznamek) "], {";
    for (i = 0; i < length(cislaPoznamek); ++i) {
        if (!(cislaPoznamek[i] in textyPoznamek)) {
            ShoditFatalniVyjimku("Vnitřní chyba: v poli textyPoznamek očekáván index [" cislaPoznamek[i] "] pole cislaPoznamek[" i "]!");
        }
        vysledek = vysledek "\"" textyPoznamek[cislaPoznamek[i]] "\", ";
    }
    vysledek = vysledek "}[" length(cislaPoznamek) "]);\n";
    return vysledek;
}

function RadekPrikladu(text, jeAkce) {
    return "    RadekPrikladu(\"" text "\", jeAkce=" (jeAkce ? "ANO" : "NE") ")\n";
}

function KonecPrikladu() {
    return "KonecPrikladu();\n";
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

function FormatVolitelny(jeZacatek) {
    return "FormatVolitelny[" (jeZacatek ? "zacatek" : "konec") "]";
}

function TriTecky() {
    return "TriTecky[]";
}

function Obrazek(src, alt, rawSrc, rawAlt) {
    return "Obrazek(src=" src ",alt=" alt ",rawSrc=" rawSrc ",rawAlt=" rawAlt ");\n";
}

function ZnackaVeVystavbe() {
    return "ZnackaVeVystavbe();\n";
}

@include "skripty/hlavni.awk"
