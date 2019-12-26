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

function ZpracujChybnyZnak(znak) {
    return "{CHYBNÝ ZNAK:" znak"}";
}

function Tabulator(delka) {
    return "Tabulator(" delka ")";
}

function ZacatekKapitoly(kapitola, cisloKapitoly, stitky, osnova,   osnovadohromady) {
    DO_LOGU_UROVEN_ODSTAVCE = 0;
    gsub(/\|/, "}{", stitky);
    for (i = 1; i <= length(osnova); ++i) {
        osnovadohromady = osnovadohromady "\t" osnova[i] "\n";
#        if (i > 500) { ShoditFatalniVyjimku("Příliš mnoho osnovy!"); }
    }
    return "ZacatekKapitoly(\"" kapitola "\"" (stitky != "" ? ", štítky={" stitky "}" : "") ") {\n" osnovadohromady "};\n";
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
    vysledek = vysledek "KonecKapitoly(\"" kapitola "\"); # Uroven odstavce: " DO_LOGU_UROVEN_ODSTAVCE "\n";
    if (DO_LOGU_UROVEN_ODSTAVCE != 0) {
        ShoditFatalniVyjimku("Kapitole " kapitola " skončila s úrovní odstavce " DO_LOGU_UROVEN_ODSTAVCE ", což pravděpodobně znamená interní chybu lexikálně syntaktického analyzátoru.");
    }
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

function ZacatekOdstavcu(bylNadpis) {
    if (DO_LOGU_UROVEN_ODSTAVCE != 0) {
        ShoditFatalniVyjimku("Nečekaná úroveň odstavce na začátku odstavce: " DO_LOGU_UROVEN_ODSTAVCE);
    }
    ++DO_LOGU_UROVEN_ODSTAVCE;
    return "ZacatekOdstavce(bylNadpis = " (bylNadpis ? "ANO" : "NE") ");\n";
}

function PredelOdstavcu() {
    if (DO_LOGU_UROVEN_ODSTAVCE != 1) {
        ShoditFatalniVyjimku("Nečekaná úroveň odstavce v předělu: " DO_LOGU_UROVEN_ODSTAVCE);
    }
    return "PredelOdstavce();\n";
}

function KonecOdstavcu() {
    if (DO_LOGU_UROVEN_ODSTAVCE != 1) {
        ShoditFatalniVyjimku("Nečekaná úroveň odstavce na konci odstavce: " DO_LOGU_UROVEN_ODSTAVCE);
    }
    --DO_LOGU_UROVEN_ODSTAVCE;
    return "KonecOdstavce();\n";
}

function ZacatekOdsazenehoOdstavce(uroven) {
    if (uroven < 1 || uroven > 6) {
        ShoditFatalniVyjimku("Nepodporovaná úroveň odsazení: " uroven);
    }
    return "ZacatekOdsazenehoOdstavce(" uroven ")";
}

function KonecOdsazenehoOdstavce(uroven) {
    if (uroven < 1 || uroven > 6) {
        ShoditFatalniVyjimku("Nepodporovaná úroveň odsazení: " uroven);
    }
    return "KonecOdsazenehoOdstavce(" uroven ")";
}

function KonecRadku() {
    return "KonecRadku();\n";
}

function HypertextovyOdkaz(adresa, text) {
    return "HypertextovyOdkaz(adresa = \"" adresa "\", text = \"" text "\");\n";
}

function ZacatekSeznamu(uroven, zarovnatDoBloku) {
    return "ZacatekSeznamu(" uroven ", zarovnat=" (zarovnatDoBloku ? "DO_BLOKU" : "VLEVO") ");\n";
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

function ZacatekParametruPrikazu() {
    return "ZacatekParametruPrikazu();\n"
}

function ParametrPrikazu(parametr, text) {
#    print "LADĚNÍ: ParametrPrikazu(\"" parametr "\", \"" text "\");" > "/dev/stderr";
    return "ParametrPrikazu(\"" parametr "\", \"" text "\");";
}

function KonecParametruPrikazu() {
    return "KonecParametruPrikazu();\n"
}

function ZacatekZaklinadla(cisloZaklinadla, textZaklinadla, cislaPoznamek, textyPoznamek,   vysledek) {
    if (!isarray(cislaPoznamek) || !isarray(textyPoznamek)) {
        ShoditFatalniVyjimku("ZacatekZaklinadla(): Očekáváno pole!");
    }

    vysledek = "ZacatekZaklinadla(" cisloZaklinadla ", \"" textZaklinadla "\", {";
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

# urovenOdsazeni: 0 = normální řádek; 1, 2, atd. = odsazený řádek; -1 = UROVEN_AKCE; -2 = UROVEN_PREAMBULE
function RadekZaklinadla(text, urovenOdsazeni, prikladHodnoty) {
    text = "    RadekZaklinadla(\"" text "\"";
    if (urovenOdsazeni == 0) {

    } else if (0 < urovenOdsazeni && urovenOdsazeni <= 9) {
        text = text ", ODSAZENI=" urovenOdsazeni;

    } else if (urovenOdsazeni == UROVEN_AKCE) {
        text = text ", JE_AKCE";

    } else if (urovenOdsazeni == UROVEN_PREAMBULE) {
        text = text ", DO_PREAMBULE";

    } else {
        ShoditFatalniVyjimku("Nepodporovaná úroveň odsazení: " urovenOdsazeni);
    }
    if (prikladHodnoty != "") {
        text = text ", PRIKLAD_HODNOTY = \"" prikladHodnoty "\"";
    }
    return text ")\n";
}

function KonecZaklinadla() {
    return "KonecZaklinadla();\n";
}

function FormatTucne(jeZacatek) {
    return "FormatTucne[" (jeZacatek ? "zacatek" : "konec") "]";
}

function FormatKurziva(jeZacatek) {
    return "FormatKurziva[" (jeZacatek ? "zacatek" : "konec") "]";
}

function FormatDopln(jeZacatek, jePoJinemDopln) {
    return "FormatDopln[" (jeZacatek ? "zacatek" : "konec") (jePoJinemDopln ? " po jinem Dopln" : "") "]";
}

function FormatKlavesa(jeZacatek, jePoJineKlavese) {
    return "FormatKlavesa[" (jeZacatek ? "zacatek" : "konec") (jePoJineKlavese ? " po jine Klavese" : "") "]";
}

function FormatVolitelny(jeZacatek) {
    return "FormatVolitelny[" (jeZacatek ? "zacatek" : "konec") "]";
}

function TriTecky() {
    return "TriTecky[]";
}

function ReseniNezname() {
    return "ReseniNezname();\n";
}

function Obrazek(src, alt, rawSrc, rawAlt) {
    return "Obrazek(src=" src ",alt=" alt ",rawSrc=" rawSrc ",rawAlt=" rawAlt ");\n";
}

function ZapnoutRezimLicence() {
    if (DO__REZIM_LICENCE) {
        ShoditFatalniVyjimku("Režim licence opakovaně zapnut!");
    }
    DO__REZIM_LICENCE = 1;
    return "ZapnoutRezimLicence();\n";
}

function VypnoutRezimLicence() {
    if (!DO__REZIM_LICENCE) {
        ShoditFatalniVyjimku("Režim licence vypnut bez zapnutí!!");
    }
    DO__REZIM_LICENCE = 0;
    return "VypnoutRezimLicence();\n";
}

@include "skripty/hlavni.awk"
