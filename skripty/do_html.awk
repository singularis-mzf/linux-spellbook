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
        case "×":
            return "&times;";
        case "␣":
            return "<span class=\"viditelnamezera\">&nbsp;</span>";
        default:
            return znak;
    }
}

# Převede bílý znak ze vstupního formátu na výstupní.
function ZpracujBilyZnak(znak, opakovany) {
    return (opakovany) ? "" : znak;
}

function ZpracujChybnyZnak(znak) {
    return "<span class=\"chybny\">" ZpracujZnak(znak) "</span>";
}

function Tabulator(delka,  i, vysledek) {
    return "<span class=\"tab\" style=\"width:" delka "ch\">&#9;</span>";
# old:
    vysledek = "<span class=\"tab\">»";
    for (i = 1; i < delka; ++i) {
        vysledek = vysledek "&nbsp;";
    }
    return vysledek "</span>";
}

# + OSNOVA, DELKA_OSNOVY

function ZacatekKapitoly(kapitola, cisloKapitoly, stitky, osnova,   vysledek, polozky) {
# Generování prvku <h1> obstarává šablona kapitoly (formaty/html/sablona_kapitoly).
#    return "<h1>" kapitola "</h1>\n";
    vysledek = "";
    delete polozky;

    if (stitky != "") {
        gsub(/\|/, "</span>\n<span>", stitky);
        vysledek = "<div class=\"stitky\"><span>" stitky "</span></div>";
    }

    vysledek = vysledek "<div class=\"rozcestnikkapitol\">\n";
    for (i = 1; i <= length(osnova); ++i) {
        split(osnova[i], polozky);
        if (polozky[1] == "SEKCE") {
            vysledek = vysledek "<a href=\"#cast" polozky[2] "\">" polozky[4] "</a><span class=\"oddelovac\">&nbsp;|</span>\n";
        }
    }
    vysledek = vysledek "</div>";
    return vysledek;
}

function KonecKapitoly(kapitola, cislaPoznamek, textyPoznamek,   i, vysledek) {
    vysledek = "";
    if (length(cislaPoznamek) > 0) {
        vysledek = "<div class=\"ppc\">";
        for (i = 0; i < length(cislaPoznamek); ++i) {
            vysledek = vysledek "<div id=\"kap" ID_KAPITOLY_OMEZENE "ppc" cislaPoznamek[i] "\"><a href=\"#kap" ID_KAPITOLY_OMEZENE "ppcr" cislaPoznamek[i] "\" class=\"cislopozn\">" cislaPoznamek[i] "</a>&nbsp;" textyPoznamek[cislaPoznamek[i]] "</div>\n";
        }
        vysledek = vysledek "<div class=\"zrusitzvyrazneni\" id=\"zzv\"><a href=\"#zzv\">zrušit zvýraznění poznámky pod čarou</a></div></div>\n";
    }
    return vysledek;
}

function ZacatekSekce(kapitola, sekce, cisloKapitoly, cisloSekce) {
    return "\n<h2 id=\"cast" cisloSekce "\"><span class=\"cislo\">" cisloSekce ".</span> " sekce "</h2>\n";
}

function KonecSekce(kapitola, sekce) {
    return "";
}

function ZacatekPodsekce(kapitola, sekce, podsekce, cisloKapitoly, cisloSekce, cisloPodsekce) {
    return "\n<h3 id=\"cast" cisloSekce "x" cisloPodsekce "\"><span class=\"cislo\">" cisloPodsekce "</span> " podsekce "</h3>\n";
}

function KonecPodsekce(kapitola, sekce, podsekce) {
    return "";
}

function ZacatekOdstavcu(bylNadpis) {
    return bylNadpis ? "<p class=\"ponadpisu\">\n" : "<p>\n";
}

function PredelOdstavcu() {
    return "</p><p>\n";
}

function KonecOdstavcu() {
    return "</p>\n";
}

function KonecRadku() {
    return "<br>";
}

function HypertextovyOdkaz(adresa, text) {
    return "<a href=\"" adresa "\">" text "</a>";
}

function ZacatekSeznamu(uroven, zarovatDoBloku) {
    return "<ul style=\"text-align:" (zarovatDoBloku ? "justify" : "left") "\">";
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

function ZacatekZaklinadla(cisloZaklinadla, textZaklinadla, cislaPoznamek, textyPoznamek,   prvni) {
    if (!isarray(cislaPoznamek) || !isarray(textyPoznamek)) {
        ShoditFatalniVyjimku("ZacatekZaklinadla(): Očekáváno pole!");
    }
    if (textZaklinadla == "" && length(cislaPoznamek) != 0) {
        ShoditFatalniVyjimku("ZacatekZaklinadla(): Zaklínadla bez záhlaví, ale s poznámkami pod čarou nejsou podporována!");
    }
    vysledek = "<div class=\"zaklinadlo\">";
    if (textZaklinadla != "") {
        vysledek = vysledek "<hr><div class=\"zahlavi\"><span class=\"cislo\">#" cisloZaklinadla " </span>" textZaklinadla;
        prvni = 1;
        if (length(cislaPoznamek) > 0) {
            vysledek = vysledek "<sup>";
            for (i in cislaPoznamek) {
                if (prvni) {
                    prvni = 0;
                } else {
                    vysledek = vysledek ",&nbsp;";
                }
                vysledek = vysledek "<a href=\"#kap" ID_KAPITOLY_OMEZENE "ppc" cislaPoznamek[i] "\" id=\"kap" ID_KAPITOLY_OMEZENE "ppcr" cislaPoznamek[i] "\">(" cislaPoznamek[i] ")</a>";
            }
            vysledek = vysledek "</sup>";
        }
        vysledek = vysledek "</div>";
    }
    vysledek = vysledek "<div class=\"radky\">\n";
    return vysledek;
}

# urovenOdsazeni: -1 = akce; 0 = normální řádek; 1, 2, atd. = odsazený řádek
function RadekZaklinadla(text, urovenOdsazeni) {
    return "<div class=\"radekzaklinadla" \
        (urovenOdsazeni == -1 ? " akce" : "") \
        "\"" \
        (urovenOdsazeni > 0 ? " style=\"padding-left:" (2 * urovenOdsazeni) "ch;\"" : "") \
        ">" text "</div>\n";
}

function KonecZaklinadla() {
    return "</div></div>\n";
}

function ZacatekOdsazenehoOdstavce(uroven) {
    return Zopakovat("<blockquote>", uroven);
}

function KonecOdsazenehoOdstavce(uroven) {
    return Zopakovat("</blockquote>", uroven);
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

function FormatVolitelny(jeZacatek) {
    return "<span class=\"volznak\">" (jeZacatek ? "[" : "]") "</span>";
}

function TriTecky() {
    return "<span class=\"tritecky\"></span>";
}

function ReseniNezname() {
    return "<a href=\"#\" class=\"reseninezname\" title=\"Řešení tohoto příkladu nebylo při vydání této verze kapitoly známo.\">?</a>";
}

function Obrazek(src, alt, rawSrc, rawAlt) {
    if (src ~ /^\.\.\/obrazky\//) {
        src = substr(src, 4);
    }
    return "<figure><img src=\"" src "\" alt=\"" alt "\"></figure>";
}

function ZapnoutRezimLicence() {
    DO__REZIM_LICENCE = 1;
    return "<div class=\"rezimlicence\">\n";
}

function VypnoutRezimLicence() {
    DO__REZIM_LICENCE = 0;
    return "</div>\n";
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
