# Linux Kniha kouzel, skript do_logu.awk
# Copyright (c) 2019-2021 Singularis <singularis@volny.cz>
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
    delete DO_LOGU_ZASOBNIK_UROVNI;
    DO_LOGU_ZASOBNIK_UROVNI_POCET = 0;
}

function ZasobnikUrovniPush(id)
{
    DO_LOGU_ZASOBNIK_UROVNI[++DO_LOGU_ZASOBNIK_UROVNI_POCET] = id;
    #printf("LADĚNÍ: [%d] = %s\n", DO_LOGU_ZASOBNIK_UROVNI_POCET, id) > "/dev/stderr";
    return 0;
}

function ZasobnikUrovniKontrola(id, popis)
{
    if (DO_LOGU_ZASOBNIK_UROVNI_POCET == 0)
    {
        ShoditFatalniVyjimku("Chybné vnoření úrovní: prázdný zásobník, když má platit úroveň " id " (popis=" popis ")!");
    }
    if (DO_LOGU_ZASOBNIK_UROVNI[DO_LOGU_ZASOBNIK_UROVNI_POCET] != id)
    {
        ShoditFatalniVyjimku("Chybné vnoření úrovní: úroveň " DO_LOGU_ZASOBNIK_UROVNI[DO_LOGU_ZASOBNIK_UROVNI_POCET] ", když má platit " id " (popis=" popis ")!");
    }
    return 0;
}

function ZasobnikUrovniPop(id, popis)
{
    if (DO_LOGU_ZASOBNIK_UROVNI_POCET == 0)
    {
        ShoditFatalniVyjimku("Chybné vnoření úrovní: prázdný zásobník, když má být ukončena úroveň " id " (popis=" popis ")!");
    }
    if (DO_LOGU_ZASOBNIK_UROVNI[DO_LOGU_ZASOBNIK_UROVNI_POCET] != id)
    {
        ShoditFatalniVyjimku("Chybné vnoření úrovní: úroveň " DO_LOGU_ZASOBNIK_UROVNI[DO_LOGU_ZASOBNIK_UROVNI_POCET] ", když je očekávána " id " (popis=" popis ")!");
    }
    --DO_LOGU_ZASOBNIK_UROVNI_POCET;
    #printf("LADĚNÍ: POP(%d, %s)\n", DO_LOGU_ZASOBNIK_UROVNI_POCET + 1, id) > "/dev/stderr";
    return 0;
}

# -------------------------------------------------------------------
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

function ZacatekKapitoly(cisloKapitoly, nazevKapitoly, stitky, stitkyxhes, osnova, ikonaKapitoly, jeDodatek, symbolKapitoly, \
    \
    osnovadohromady, stitkytext) {
    ZasobnikUrovniPush("kapitola");

    DO_LOGU_UROVEN_ODSTAVCE = 0;
    for (i = 1; i <= length(osnova); ++i) {
        osnovadohromady = osnovadohromady "\t" osnova[i] "\n";
#        if (i > 500) { ShoditFatalniVyjimku("Příliš mnoho osnovy!"); }
    }
    stitkytext = "";
    for (i = 1; i in stitky; ++i) {
        stitkytext = stitkytext "|" stitky[i] "[" stitkyxhes[i] "]";
    }
    stitkytext = stitkytext != "" ? substr(stitkytext, 2) : "";
    return "ZacatekKapitoly(\"" nazevKapitoly "\"" (stitkytext != "" ? ", štítky={" stitkytext "}" : "") ", ikona={" ikonaKapitoly "}, jedodatek=" (jeDodatek ? "ano" : "ne") ", symbol=\"" symbolKapitoly "\", číslo=(" cisloKapitoly ")" ") {\n" osnovadohromady "};\n";
}

function KonecKapitoly(cisloKapitoly, nazevKapitoly, cislaPoznamek, textyPoznamek,   i, vysledek) {
    ZasobnikUrovniPop("kapitola");

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
    vysledek = vysledek "KonecKapitoly(\"" nazevKapitoly "\"); # Uroven odstavce: " DO_LOGU_UROVEN_ODSTAVCE "\n";
    if (DO_LOGU_UROVEN_ODSTAVCE != 0) {
        ShoditFatalniVyjimku("Kapitole " nazevKapitoly " skončila s úrovní odstavce " DO_LOGU_UROVEN_ODSTAVCE ", což pravděpodobně znamená interní chybu lexikálně syntaktického analyzátoru.");
    }
    return vysledek;
}

function ZacatekSekce(cisloKapitoly, nazevKapitoly, cisloSekce, nazevSekce) {
    ZasobnikUrovniPush("sekce");
    return "ZacatekSekce(" cisloKapitoly "/\"" nazevKapitoly "\", " cisloSekce "/\"" nazevSekce "\");\n";
}

function KonecSekce(cisloKapitoly, nazevKapitoly, cisloSekce, nazevSekce) {
    ZasobnikUrovniPop("sekce");
    return "KonecSekce(" cisloKapitoly "/\"" nazevKapitoly "\", " cisloSekce "/\"" nazevSekce "\");\n";
}

function ZacatekPodsekce(cisloKapitoly, nazevKapitoly, cisloSekce, nazevSekce, cisloPodsekce, nazevPodsekce) {
    ZasobnikUrovniPush("podsekce");
    return "ZacatekPodsekce(" cisloKapitoly "/\"" nazevKapitoly "\", " cisloSekce "/\"" nazevSekce "\", " cisloPodsekce "/\"" nazevPodsekce "\");\n";
}

function KonecPodsekce(cisloKapitoly, nazevKapitoly, cisloSekce, nazevSekce, cisloPodsekce, nazevPodsekce) {
    ZasobnikUrovniPop("podsekce");
    return "KonecPodsekce(" cisloKapitoly "/\"" nazevKapitoly "\", " cisloSekce "/\"" nazevSekce "\", " cisloPodsekce "/\"" nazevPodsekce "\");\n";
}

function ZacatekOdstavcu(bylNadpis) {
    ZasobnikUrovniPush("odstavce");
    if (DO_LOGU_UROVEN_ODSTAVCE != 0) {
        ShoditFatalniVyjimku("Nečekaná úroveň odstavce na začátku odstavce: " DO_LOGU_UROVEN_ODSTAVCE);
    }
    ++DO_LOGU_UROVEN_ODSTAVCE;
    return "ZacatekOdstavce(bylNadpis = " (bylNadpis ? "ANO" : "NE") ");\n";
}

function PredelOdstavcu() {
    ZasobnikUrovniKontrola("odstavce");
    if (DO_LOGU_UROVEN_ODSTAVCE != 1) {
        ShoditFatalniVyjimku("Nečekaná úroveň odstavce v předělu: " DO_LOGU_UROVEN_ODSTAVCE);
    }
    return "PredelOdstavce();\n";
}

function KonecOdstavcu() {
    ZasobnikUrovniPop("odstavce");
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

function ZacatekSeznamu(uroven, kompaktni) {
    ZasobnikUrovniPush("seznam");
    return "ZacatekSeznamu(" uroven ", kompaktni=" (kompaktni ? "ANO" : "NE") ");\n";
}

function ZacatekPolozkySeznamu(uroven) {
    ZasobnikUrovniKontrola("seznam");
    ZasobnikUrovniPush("položkaseznamu");
    return "ZacatekPolozkySeznamu(" uroven ");\n";
}

function KonecPolozkySeznamu(uroven) {
    ZasobnikUrovniPop("položkaseznamu");
    return "KonecPolozkySeznamu(" uroven ");\n";
}

function KonecSeznamu(uroven) {
    ZasobnikUrovniPop("seznam");
    return "KonecSeznamu(" uroven ");\n";;
}

function ZacatekParametruPrikazu() {
    ZasobnikUrovniPush("parametrypříkazu");
    return "ZacatekParametruPrikazu();\n"
}

function ParametrPrikazu(parametr, text) {
    ZasobnikUrovniKontrola("parametrypříkazu");
    #    print "LADĚNÍ: ParametrPrikazu(\"" parametr "\", \"" text "\");" > "/dev/stderr";
    return "ParametrPrikazu(\"" parametr "\", \"" text "\");";
}

function KonecParametruPrikazu() {
    ZasobnikUrovniPop("parametrypříkazu");
    return "KonecParametruPrikazu();\n"
}

function ZacatekOblibenychZaklinadel(pocet) {
    ZasobnikUrovniPush("oblíbenázaklínadla");
    return "ZacatekOblibenychZaklinadel(" pocet ");\n";
}

function KonecOblibenychZaklinadel(pocet) {
    ZasobnikUrovniPop("oblíbenázaklínadla");
    return "KonecOblibenychZaklinadel(" pocet ");\n";
}

function ZacatekZaklinadla( \
    cisloKapitoly,
    nazevNadkapitoly,
    nazevPodkapitoly,
    cisloSekce,
    nazevSekce,
    cisloPodsekce,
    nazevPodsekce,
    cisloZaklinadla,
    textZaklinadla,
    hesZaklinadla,
    ikona,
    cislaPoznamek,
    textyPoznamek,
    samostatne,

    vysledek)
{
    ZasobnikUrovniPush("zaklínadlo");

    if (!isarray(cislaPoznamek) || !isarray(textyPoznamek)) {
        ShoditFatalniVyjimku("ZacatekZaklinadla(): Očekáváno pole!");
    }

    vysledek = "ZacatekZaklinadla(@(" cisloKapitoly "=" nazevNadkapitoly "/" nazevPodkapitoly ")/(" cisloSekce "=" nazevSekce ")/(" cisloPodsekce "=" nazevPodsekce "), " \
        (samostatne ? "(+samostatně)" : "") \
        "ikona:<" gensub(/\t.*/, "", 1, ikona) ">(písmo:" gensub(/.*\t/, "", 1, ikona) ")|" cisloZaklinadla ", \"" textZaklinadla "\", \"" hesZaklinadla "\", {";
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
    ZasobnikUrovniKontrola("zaklínadlo");

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
    ZasobnikUrovniPop("zaklínadlo");
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

function ZapnoutUzkyRezim() {
    if (DO__UZKY_REZIM) {
        ShoditFatalniVyjimku("Úzký režim opakovaně zapnut!");
    }
    DO__UZKY_REZIM = 1;
    return "ZapnoutUzkyRezim();\n";
}

function VypnoutUzkyRezim() {
    if (!DO__UZKY_REZIM) {
        ShoditFatalniVyjimku("Úzký režim vypnut bez zapnutí!!");
    }
    DO__UZKY_REZIM = 0;
    return "VypnoutUzkyRezim();\n";
}

function VzornikIkon(pocetIkon, ikony,   i, vysledek) {
    vysledek = "VzornikIkon {\n";
    if (pocetIkon < 1) {
        ShoditFatalniVyjimku("Chybný počet ikon: " pocetIkon);
    }
    for (i = 1; i <= pocetIkon; ++i) {
        if (i in ikony) {
            if (ikony[i] ~ /^\S\t[A-Z]$/) {
                vysledek = vysledek sprintf("- (%4d) ikona (%s) třídy (%s)\n", i - 1, substr(ikony[i], 1, 1), substr(ikony[i], 3));
            } else {
                ShoditFatalniVyjimku("Neplatný formát ikony číslo " i ": <" ikony[i] ">");
            }
        } else {
            ShoditFatalniVyjimku("Ikona číslo " i " chybí v zadaném poli!");
        }
    }
    vysledek = vysledek "}\n";
    return vysledek;
}

@include "skripty/překlad/hlavní.awk"
