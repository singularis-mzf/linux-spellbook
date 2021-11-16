# Linux Kniha kouzel, skript do_html.awk
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

# Převede nezvláštní znak vstupního formátu (Markdown) do výstupního formátu.
# Pro bílé znaky se volá jedině tehdy, jsou-li odzvláštněny.
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

function ZacatekKapitoly(cisloKapitoly, nazevKapitoly, stitky, stitkyxhes, osnova, ikonaKapitoly, jeDodatek, symbolKapitoly, \
    \
    vysledek, i) {
# Generování prvku <h1> obstarává šablona kapitoly.
#    return "<h1>" nazevKapitoly "</h1>\n";
    vysledek = "";

    if (1 in stitky) {
        vysledek = "";
        for (i = 1; i in stitky; ++i) {
            vysledek = vysledek "<a href=\"x-stitky.htm#" stitkyxhes[i] "\">" stitky[i] "</a>\n";
        }
        vysledek = "<div class=\"stitky\">" vysledek "</div>";
    } else {
        vysledek = "";
    }

    return vysledek; # negenerovat osnovu (je v menu)
}

function KonecKapitoly(cisloKapitoly, nazevKapitoly, cislaPoznamek, textyPoznamek,   i, vysledek, prikaz, htmlPoznamky) {
    vysledek = "";
    if (length(cislaPoznamek) > 0) {
        vysledek = "<div class=\"ppc\">";
        for (i = 0; i < length(cislaPoznamek); ++i) {
            htmlPoznamky = textyPoznamek[cislaPoznamek[i]];
            vysledek = vysledek "<div id=\"kap" XHES_KAPITOLY "ppc" cislaPoznamek[i] "\"><a href=\"#kap" XHES_KAPITOLY "ppcr" cislaPoznamek[i] "\" class=\"cislopozn\">" cislaPoznamek[i] "</a>&nbsp;" htmlPoznamky "</div>\n<script>document.write(\"<div class=\\\"zpetdotextu\\\" onclick=\\\"window.history.back()\\\">zpět do textu</div>\");</script>\n";
        }
        #vysledek = vysledek "<div class=\"zrusitzvyrazneni\" id=\"zzv\"><a href=\"#zzv\">zrušit zvýraznění poznámky pod čarou</a></div></div>\n";
        vysledek = vysledek "</div>\n";
    }
    return vysledek;
}

function ZacatekSekce(cisloKapitoly, nazevKapitoly, cisloSekce, nazevSekce) {
    return "\n<h2 id=\"cast" cisloSekce "\"" (nazevSekce ~ /^Zaklínadla/ ? " class=\"zaklinadla\"" : "") \
        "><a href=\"#cast" cisloSekce "\"><span class=\"cislo\">" cisloSekce ".</span> " \
        nazevSekce "</a></h2>\n";
}

function KonecSekce(cisloKapitoly, nazevKapitoly, cisloSekce, nazevSekce) {
    return "";
}

function ZacatekPodsekce(cisloKapitoly, nazevKapitoly, cisloSekce, nazevSekce, cisloPodsekce, nazevPodsekce) {
    return "\n<h3 id=\"cast" cisloSekce "x" cisloPodsekce "\"><span><a href=\"#cast" cisloSekce "x" cisloPodsekce "\" title=\"" sprintf("kapitola %d (%s), sekce %d (%s), podsekce %d (%s)", cisloKapitoly, nazevKapitoly, cisloSekce, nazevSekce, cisloPodsekce, nazevPodsekce) "\">" sprintf("<sup>%d/</sup>%d", cisloSekce, cisloPodsekce) " " nazevPodsekce "</a></span></h3>\n";
}

function KonecPodsekce(cisloKapitoly, nazevKapitoly, cisloSekce, nazevSekce, cisloPodsekce, nazevPodsekce) {
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

function ZacatekSeznamu(uroven, kompaktni) {
    return kompaktni ? "<ul class=\"kompaktni\">" : "<ul>";
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

function ZacatekParametruPrikazu() {
    return "<table class=\"parametryprikazu\"><tbody>"
}

function ParametrPrikazu(parametr, text) {
    return "<tr><td>" parametr "</td><td>" text "</td></tr>\n";
}

function KonecParametruPrikazu() {
    return "</tbody></table>\n"
}

function ZacatekOblibenychZaklinadel(pocet) {
    return "";
}

function KonecOblibenychZaklinadel(pocet) {
    return "";
}

function ZacatekZaklinadla( \
    cisloKapitoly, # číslo > 0, pokud půjde kapitola na výstup; jinak 0
    nazevNadkapitoly, # "", pokud nemá nadkapitolu
    nazevPodkapitoly, # holý název kapitoly (např. „LVM“)
    cisloSekce, # číslo > 0, pokud není zaklínadlo mimo sekce; jinak 0
    nazevSekce, # název sekce, pokud není zaklínadlo mimo sekce; jinak ""
    cisloPodsekce, # číslo > 0, pokud není zaklínadlo mimo podsekci; jinak 0
    nazevPodsekce, # název podsekce, není-li zaklínadlo mimo podsekci; jinak ""
    cisloZaklinadla, # číslo > 0
    textZaklinadla, # neprázdný text v cílovém formátu, pokud nejde o zaklínadlo bez titulku; jinak ""
    hesZaklinadla, # heš zaklínadla (např. „x75e4112“)
    cislaPoznamek,
    textyPoznamek,
    samostatne, # normálně 0; je-li pravdivý, zaklínadlo je sázeno mimo svoji obvyklou polohu a mělo by být označeno i názvem sekce a podsekce

    prvni, textPoznamky) {
    if (!isarray(cislaPoznamek) || !isarray(textyPoznamek)) {
        ShoditFatalniVyjimku("ZacatekZaklinadla(): Očekáváno pole!");
    }
    if (textZaklinadla == "" && length(cislaPoznamek) != 0) {
        ShoditFatalniVyjimku("ZacatekZaklinadla(): Zaklínadla bez záhlaví, ale s poznámkami pod čarou nejsou podporována!");
    }
    vysledek = "<div class=\"zaklinadlo\">";
    if (textZaklinadla != "") {
        vysledek = vysledek \
            "<div class=\"zahlavi\">" \
                "<span class=\"ikona D" (samostatne ? "" : "\" id=\"z" hesZaklinadla) "\">" \
                    "<span><a href=\"#z" hesZaklinadla "\">@</a></span>" \
                "</span>" \
                textZaklinadla \
                "<span class=\"cislo\">#" cisloZaklinadla " </span>";
        prvni = 1;
        if (length(cislaPoznamek) > 0) {
            vysledek = vysledek "<sup>";
            for (i in cislaPoznamek) {
                if (prvni) {
                    prvni = 0;
                } else {
                    vysledek = vysledek ",&nbsp;";
                }
                textPoznamky = gensub(/<[^>]>/, "", "g", textyPoznamek[cislaPoznamek[i]]);
                gsub(/\n/, "", textPoznamky);
                gsub(/\t/, " ", textPoznamky);
                gsub(Odzvlastnit(ZpracujZnak("␣")), OdzvlastnitKNahrade("&blank;"), textPoznamky);
                vysledek = vysledek "<a href=\"#kap" XHES_KAPITOLY "ppc" cislaPoznamek[i] "\" id=\"kap" XHES_KAPITOLY "ppcr" cislaPoznamek[i] "\" title=\"" textPoznamky "\">(" cislaPoznamek[i] ")</a>";
            }
            vysledek = vysledek "</sup>";
        }
        vysledek = vysledek "</div>";
    }
    vysledek = vysledek "<div class=\"radky\">\n";
    return vysledek;
}

# urovenOdsazeni: 0 = normální řádek; 1, 2, atd. = odsazený řádek; -1 = UROVEN_AKCE; -2 = UROVEN_PREAMBULE
function RadekZaklinadla(text, urovenOdsazeni, prikladHodnoty) {
    if (prikladHodnoty != "") {
        prikladHodnoty = "<span class=\"prikladhodnoty\">⊨ " prikladHodnoty "</span>";
    }

    if (urovenOdsazeni == 0) {
        return "<div class=\"radekzaklinadla\">" text prikladHodnoty "</div>\n"

    } else if (0 < urovenOdsazeni && urovenOdsazeni <= 9) {
        return "<div class=\"radekzaklinadla\" style=\"padding-left:" (2 * urovenOdsazeni) "ch;\">" text prikladHodnoty "</div>\n"

    } else if (urovenOdsazeni == UROVEN_AKCE) {
        return "<div class=\"radekzaklinadla akce\">" text "</div>\n"

    } else if (urovenOdsazeni == UROVEN_PREAMBULE) {
        return "<div class=\"radekzaklinadla dopreambule\"><span title=\"Takto označený řádek " \
            "patří do preambule zdrojového kódu či do záhlaví skriptu.\">^</span>" text prikladHodnoty "</div>\n"

    } else {
        ShoditFatalniVyjimku("Nepodporovaná úroveň odsazení: " urovenOdsazeni);
    }
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

function FormatDopln(jeZacatek, jePoJinemDopln) {
    return jeZacatek ? "<i class=\"dopln\">" : "</i>";
}

function FormatKlavesa(jeZacatek, jePoJineKlavese) {
    return jeZacatek ? "<kbd>" : "</kbd>";
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
    if (src ~ /^\.\.\/obr[aá]zky\//) {
        src = "obrazky/" BezDiakritiky(substr(src, 12));
    }
    return "<div class=\"figureobal\"><figure><img src=\"" src "\" alt=\"" alt "\"></figure></div>";
}

function ZapnoutRezimLicence() {
    DO__REZIM_LICENCE = 1;
    return "<div class=\"rezimlicence\">\n";
}

function VypnoutRezimLicence() {
    DO__REZIM_LICENCE = 0;
    return "</div>\n";
}

function ZapnoutUzkyRezim() {
    return "";
}

function VypnoutUzkyRezim() {
    return "";
}

function RejstrikPodleKlasickychPrikazu(    pocet, predchozi_typ, soubor, vysl) {
    soubor = SOUBORY_PREKLADU "/klasické-příkazy.dat";
    pocet = 0;
    predchozi_typ = "";
    vysl = "";
    while (getline < soubor) {
        typ = substr($1, 1, 1);
        if (pocet == 0) {
            vysl = vysl "<dl class=\"klasickeprikazy\">";
        }
        switch (typ) {
            case "%": # %<klasický-příkaz>\t<počet-úkolů>\t<popis-klpříkazu>
                vysl = vysl (pocet > 0 ? "</ul></dd>" : "") "<dt><strong>" substr($1, 2) "</strong> -- <span>" $3 "</span></dt><dd><ul>";
                break;
            case "-": # -<číslo-kapitoly>\t<ploché-id-bez-diakr>\t<xheš>\t<úkol>
                odk_kapitola = $2 ".htm";
                odk_xhes = $3;
                odk_index_kapitoly = substr($1, 2);
                odk_symbol_kapitoly = FragInfo(odk_index_kapitoly, "symbol");
                odk_nazev_kapitoly = FragInfo(odk_index_kapitoly, "celý-název");
                vysl = vysl "<li><a href=\"" odk_kapitola "#z" odk_xhes "\">" gensub(/ /, "\\&nbsp;", "g", $4) "</a> <span class=\"kapitola\">(<a href=\"" odk_kapitola "\">" odk_symbol_kapitoly "&nbsp;" odk_nazev_kapitoly "</a>)</span></li>";
                break;
            default:
                ShoditFatalniVyjimku("Vnitřní chyba překladu: chybný typ záznamu \"" typ "\"!");
        }
        predchozi_typ = typ;
        ++pocet;
    }
    vysl = vysl (pocet == 0 ? "<p>Rejstřík neobsahuje žádné klasické příkazy.</p>" : "</ul></dd></dl>");
    close(soubor);
    return vysl;
}

@include "skripty/překlad/hlavní.awk"
