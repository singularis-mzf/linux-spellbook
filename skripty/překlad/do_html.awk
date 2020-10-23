# Linux Kniha kouzel, skript do_html.awk
# Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>
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

# Převede znak vstupního formátu (Markdown) po odstranění odzvláštnění do výstupního formátu.
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

function ZacatekKapitoly(nazevKapitoly, cisloKapitoly, stitky, osnova, ikonaKapitoly, jeDodatek,  vysledek, polozky, jePrvni, melaPodsekce, maPodsekce, poleStitku, i, n) {
# Generování prvku <h1> obstarává šablona kapitoly.
#    return "<h1>" nazevKapitoly "</h1>\n";
    vysledek = "";
    delete polozky;

    if (stitky != "") {
        vysledek = "";
        n = split(stitky, poleStitku, "|");
        for (i = 1; i <= n; ++i) {
            vysledek = vysledek "<a href=\"x-stitky.htm#" GenerovatOmezeneId("s", poleStitku[i]) "\">" poleStitku[i] "</a>\n";
        }
        vysledek = "<div class=\"stitky\">" vysledek "</div>";
    } else {
        vysledek = "";
    }

    return vysledek; # negenerovat osnovu (je v menu)

    jePrvni = 1;
    melaPodsekce = 1;
    for (i = 1; i <= length(osnova); ++i) {
        if (osnova[i] ~ /^SEKCE\t/) {
            split(osnova[i], polozky);
            maPodsekce = i < length(osnova) && osnova[i + 1] ~ /^PODSEKCE\t/;
            if (jePrvni) {
                vysledek = vysledek "<div class=\"rozcestnikkapitol\">\n";
            } else if (melaPodsekce || maPodsekce) {
                vysledek = vysledek "<br>\n";
            } else {
                vysledek = vysledek "<span class=\"oddelovac\">&nbsp;|</span>\n";
            }
            vysledek = vysledek "<a href=\"#cast" polozky[2] "\" class=\"sekce\">" polozky[4] "</a>";
            if (maPodsekce) {
                vysledek = vysledek ": ";
                jePrvni = 1;
                do {
                    if (osnova[++i] ~ /^PODSEKCE\t/) {
                        split(osnova[i], polozky);
                        if (!jePrvni) {vysledek = vysledek "<span class=\"oddelovac\">&nbsp;|</span>\n"}
                        vysledek = vysledek "<a href=\"#cast" polozky[2] "\">" polozky[4] "</a>";
                        jePrvni = 0;
                    }
                } while (i < length(osnova) && osnova[i + 1] !~ /^SEKCE\t/);
            }
            jePrvni = 0;
            melaPodsekce = maPodsekce;
        }
    }
    if (!jePrvni) {vysledek = vysledek "</div>"}
    return vysledek;
}

function KonecKapitoly(nazevKapitoly, cislaPoznamek, textyPoznamek,   i, vysledek, prikaz, htmlPoznamky) {
    vysledek = "";
    if (length(cislaPoznamek) > 0) {
        vysledek = "<div class=\"ppc\">";
        for (i = 0; i < length(cislaPoznamek); ++i) {
            htmlPoznamky = textyPoznamek[cislaPoznamek[i]];
            vysledek = vysledek "<div id=\"kap" ID_KAPITOLY_OMEZENE "ppc" cislaPoznamek[i] "\"><a href=\"#kap" ID_KAPITOLY_OMEZENE "ppcr" cislaPoznamek[i] "\" class=\"cislopozn\">" cislaPoznamek[i] "</a>&nbsp;" htmlPoznamky "</div>\n<script>document.write(\"<div class=\\\"zpetdotextu\\\" onclick=\\\"window.history.back()\\\">zpět do textu</div>\");</script>\n";
        }
        #vysledek = vysledek "<div class=\"zrusitzvyrazneni\" id=\"zzv\"><a href=\"#zzv\">zrušit zvýraznění poznámky pod čarou</a></div></div>\n";
        vysledek = vysledek "</div>\n";
    }
    return vysledek;
}

function ZacatekSekce(kapitola, sekce, cisloKapitoly, cisloSekce) {
    return "\n<h2 id=\"cast" cisloSekce "\"" (sekce ~ /^Zaklínadla/ ? " class=\"zaklinadla\"" : "") \
        "><a href=\"#cast" cisloSekce "\"><span class=\"cislo\">" cisloSekce ".</span> " \
        sekce "</a></h2>\n";
}

function KonecSekce(kapitola, sekce) {
    return "";
}

function ZacatekPodsekce(kapitola, sekce, podsekce, cisloKapitoly, cisloSekce, cisloPodsekce) {
    return "\n<h3 id=\"cast" cisloSekce "x" cisloPodsekce "\"><span><a href=\"#cast" cisloSekce "x" cisloPodsekce "\" title=\"" sprintf("kapitola %d (%s), sekce %d (%s), podsekce %d (%s)", cisloKapitoly, kapitola, cisloSekce, sekce, cisloPodsekce, podsekce) "\">" sprintf("<sup>%d/</sup>%d", cisloSekce, cisloPodsekce) " " podsekce "</a></span></h3>\n";
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

function ZacatekZaklinadla(cisloZaklinadla, textZaklinadla, ikona, cislaPoznamek, textyPoznamek,   prvni, textPoznamky) {
    if (!isarray(cislaPoznamek) || !isarray(textyPoznamek)) {
        ShoditFatalniVyjimku("ZacatekZaklinadla(): Očekáváno pole!");
    }
    if (textZaklinadla == "" && length(cislaPoznamek) != 0) {
        ShoditFatalniVyjimku("ZacatekZaklinadla(): Zaklínadla bez záhlaví, ale s poznámkami pod čarou nejsou podporována!");
    }
    vysledek = "<div class=\"zaklinadlo\">";
    if (textZaklinadla != "") {
        if (ikona == "") {ikona = "&nbsp;\tD"}
        idzaklinadla = Hes(textZaklinadla);
        while (idzaklinadla in pridelenaIdZaklinadel) {idzaklinadla = idzaklinadla "x"}
        pridelenaIdZaklinadel[idzaklinadla] = 1;
        vysledek = vysledek "<div class=\"zahlavi\">" \
            gensub(/([^\t]*)\t([^\t]*)/, "<span class=\"ikona \\2\" id=\"z" idzaklinadla "\"><span><a href=\"#z" idzaklinadla "\">\\1</a></span></span>", 1, ikona) \
            textZaklinadla "<span class=\"cislo\">#" cisloZaklinadla " </span>";
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
                vysledek = vysledek "<a href=\"#kap" ID_KAPITOLY_OMEZENE "ppc" cislaPoznamek[i] "\" id=\"kap" ID_KAPITOLY_OMEZENE "ppcr" cislaPoznamek[i] "\" title=\"" textPoznamky "\">(" cislaPoznamek[i] ")</a>";
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
        src = "obrazky/" substr(src, 12);
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

function ZapnoutUzkyRezim() {
    return "";
}

function VypnoutUzkyRezim() {
    return "";
}

function VzornikIkon(pocetIkon, ikony,   i, vysledek, pole) {
    vysledek = "<div class=\"vzornikikon\">\n";
    for (i = 1; i <= pocetIkon; ++i) {
        split(ikony[i], pole, "\t"); # pole[1] = znak ikony; pole[2] = třída
        vysledek = vysledek "<span>" (i - 1) ":&nbsp;<span class=\"" pole[2] "\">" pole[1] "</span></span>\n";
    }
    vysledek = vysledek "</div>";
    return vysledek;
}

@include "skripty/překlad/hlavní.awk"
