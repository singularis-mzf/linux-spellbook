# Linux Kniha kouzel, skript do_latexu.awk
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
    #
    # Do tohoto pole se ukládá při otevření odrážkovaného seznamu kód k jeho uzavření.
    delete DO__KONEC_SEZNAMU;
    #
    # Autonomní číslování poznámek pod čarou (oddělené kvůli hypertextovým odkazům).
    DO_LATEXU_CISLO_POZN_POD_CAROU = 0;
    #
    # Tento příznak se nastavuje s koncem bloku odstavců a ruší s každým nadpisem.
    # Jeho účelem je umožnit vložení mezery mezi odstavec a první zaklínadlo.
    DO_LATEXU_ODSTAVEC_PRED_ZAKLINADLEM = 0;
}

# Pomocná funkce:
function AlokovatPoznamkuPodCarou() {
    return ++DO_LATEXU_CISLO_POZN_POD_CAROU;
}

# Převede nezvláštní znak vstupního formátu (Markdown) do výstupního formátu.
# Pro bílé znaky se volá jedině tehdy, jsou-li odzvláštněny.
function ZpracujZnak(znak) {
   switch (znak) {
# ASCII
        case " ":
        case "!":
            return znak;
        case "\"":
            return "\\textquotedbl{}";
        case "#":
        case "$":
        case "%":
        case "&":
            return "\\" znak;
        case "'":
            return "\\textquotesingle{}";
        case "(":
        case ")":
        case "*":
        case "+":
        case ",":
            return znak;
        case "-":
            return "{-}";
        case ".":
        case "/":
        case "0":
        case "1":
        case "2":
        case "3":
        case "4":
        case "5":
        case "6":
        case "7":
        case "8":
        case "9":
        case ":":
        case ";":
            return znak;
        case "<":
            return "{\\mensinez}";
        case "=":
            return "{\\rovno}";
        case ">":
            return "{\\vetsinez}";
        case "?":
        case "@":
        case "A":
        case "B":
        case "C":
        case "D":
        case "E":
        case "F":
        case "G":
        case "H":
        case "I":
        case "J":
        case "K":
        case "L":
        case "M":
        case "N":
        case "O":
        case "P":
        case "Q":
        case "R":
        case "S":
        case "T":
        case "U":
        case "V":
        case "W":
        case "X":
        case "Y":
        case "Z":
        case "[":
            return znak;
        case "\\":
            return "\\textbackslash{}";
        case "]":
            return znak;
        case "^":
            return "\\char`\\^{}";
        case "_":
            return "\\_";
        case "`":
            return "\\textasciigrave{}";
        case "a":
        case "b":
        case "c":
        case "d":
        case "e":
        case "f":
        case "g":
        case "h":
        case "i":
        case "j":
        case "k":
        case "l":
        case "m":
        case "n":
        case "o":
        case "p":
        case "q":
        case "r":
        case "s":
        case "t":
        case "u":
        case "v":
        case "w":
        case "x":
        case "y":
        case "z":
            return znak;
        case "{":
            return "\\" znak;
        case "|":
            return "\\textbar{}";
        case "}":
            return "\\" znak;
        case "~":
            return "\\char`\\~{}";
#            return "\\textasciitilde{}";
# s diakritikou
        case "á": case "Á":
        case "č": case "Č":
        case "ď": case "Ď":
        case "é": case "É":
        case "ě": case "Ě":
        case "í": case "Í":
        case "ň": case "Ň":
        case "ó": case "Ó":
        case "ř": case "Ř":
        case "š": case "Š":
        case "ť": case "Ť":
        case "ú": case "Ú":
        case "ů": case "Ů":
        case "ý": case "Ý":
        case "ž": case "Ž":
            return znak;
# obvyklé UCS znaky
        case "°":
            return "\\degree{}";
        case "„":
            return "\\quotedblbase{}";
        case "“":
            return "\\textquotedblleft{}";
        case "–":
            return "\\textendash{}";
        case "—":
            return "\\textemdash{}";
        case " ":
            return "~";
        case "×":
            return "\\ensuremath{\\times}";
        case "≤":
            return "{\\mensineborovno}";
        case "≥":
            return "{\\vetsineborovno}";
        case "≠":
            return "{\\nerovno}";
        case "π":
            return "{\\lmmathfamily{π}}";

# speciality
        case "○":
        case "◉":
        case "☐":
        case "☑":
        case "☒":
        case "←":
        case "↑":
        case "→":
        case "↓":
            return "{\\pismodejavusans{}" znak "}";
        case "⫽":
            return "//";
        case "␣":
            return "{\\pismozaklinadlo\\textvisiblespace}";

        default:
            ShoditFatalniVyjimku("Nalezen nepodporovaný znak: '" znak "'");
    }
}

# Převede bílý znak ze vstupního formátu na výstupní.
function ZpracujBilyZnak(znak, opakovany) {
#    return (opakovany) ? "" : znak;
    return znak;
}

# Zatím jsou chybné znaky do formátu PDF exportovány jako normální.
function ZpracujChybnyZnak(znak) {
    return ZpracujZnak(znak);
}

function Tabulator(delka,  i, vysledek) {
    return "\\textcolor{seda}{\\guillemotright}{" Zopakovat("~", max(0, delka - 1)) "}";
}

function ZacatekKapitoly(cisloKapitoly, nazevKapitoly, stitky, stitkyxhes, osnova, ikonaKapitoly, jeDodatek, symbolKapitoly, \
    \
    kapitolaVelkymi, zkratkaKapitoly, n)
{
    DO_LATEXU_ODSTAVEC_PRED_ZAKLINADLEM = 0;
    kapitolaVelkymi = toupper(nazevKapitoly);
    zkratkaKapitoly = jeDodatek ? "" : SubstrZleva(gensub(/[^[:alnum:]]/, "", "g", kapitolaVelkymi), 3);
    nazevKapitoly = "\\kapitola{" ((cisloKapitoly - 1) % 21) "}{" zkratkaKapitoly "}{" symbolKapitoly "}{" kapitolaVelkymi "}{../pdf-společné/_obrázky/" ikonaKapitoly "}%\n\\label{kapx" XHES_KAPITOLY "}";
    if (1 in stitky) {
        nazevKapitoly = nazevKapitoly "\\noindent\\stitek{" stitky[1];
        for (n = 2; n in stitky; ++n) {nazevKapitoly = nazevKapitoly "}\\stitek{" stitky[n]}
        nazevKapitoly = nazevKapitoly "}\n";
    }
    return nazevKapitoly;
}

function KonecKapitoly(cisloKapitoly, nazevKapitoly, cislaPoznamek, textyPoznamek) {
    return "";
}

function ZacatekSekce(cisloKapitoly, nazevKapitoly, cisloSekce, nazevSekce) {
    DO_LATEXU_ODSTAVEC_PRED_ZAKLINADLEM = 0;
    switch (nazevSekce) {
        default:
            return "\\sekce{" nazevSekce "}%\n";
    }
}

function KonecSekce(cisloKapitoly, nazevKapitoly, cisloSekce, nazevSekce) {
    return "";
}

function ZacatekPodsekce(cisloKapitoly, nazevKapitoly, cisloSekce, nazevSekce, cisloPodsekce, nazevPodsekce) {
    DO_LATEXU_ODSTAVEC_PRED_ZAKLINADLEM = 0;
    return "\\podsekce{" nazevPodsekce "}%\n";
}

function KonecPodsekce(cisloKapitoly, nazevKapitoly, cisloSekce, nazevSekce, cisloPodsekce, nazevPodsekce) {
    return "";
}

function ZacatekOdstavcu(bylNadpis) {
    return "\\begin{odstavce}" (bylNadpis ? "" : "\\hspace{\\parindent}");
}

function PredelOdstavcu() {
    return "\n\n";
}

function KonecOdstavcu() {
    DO_LATEXU_ODSTAVEC_PRED_ZAKLINADLEM = 1;
    return "\\end{odstavce}";
}

function ZacatekOdsazenehoOdstavce(uroven) {
    return "\\begin{odsazenyodstavec}{" uroven "}";
}

function KonecOdsazenehoOdstavce(uroven) {
    return "\\end{odsazenyodstavec}";
}

function KonecRadku() {
    return "\\\\{}";
}

function HypertextovyOdkaz(adresa, text,   cisloPoznamky) {
    cisloPoznamky = AlokovatPoznamkuPodCarou();
    return text "\\footnotemark[" cisloPoznamky "]\\footnotetext[" cisloPoznamky "]{\\raggedright{}" adresa "}";
}

function ZacatekSeznamu(uroven, kompaktni) {
    DO__KONEC_SEZNAMU[uroven] = "\\end{" (kompaktni ? "kompaktniodrazky" : "odrazky") "}\n";
    return "\\begin{" (kompaktni ? "kompaktniodrazky" : "odrazky") "}";
}

function ZacatekPolozkySeznamu(uroven) {
    return "%\n\\item{}";
}

function KonecPolozkySeznamu(uroven) {
    return "\n";
}

function KonecSeznamu(uroven) {
    return DO__KONEC_SEZNAMU[uroven];
}

function ZacatekParametruPrikazu() {
    return "\\begin{parametryprikazu}"
}

function ParametrPrikazu(parametr, text) {
    return "\\parametrprikazu{" parametr "}{" text "}%\\n";
}

function KonecParametruPrikazu() {
    return "\\end{parametryprikazu}\n"
}

function ZacatekOblibenychZaklinadel(pocet) {
    DO_LATEXU_ODSTAVEC_PRED_ZAKLINADLEM = 0;
    return "\\sekcex{Oblíbená zaklínadla}%\n";
}

function KonecOblibenychZaklinadel(pocet) {
    return "";
}

function ZacatekZaklinadla(\
    cisloKapitoly,
    nazevNadkapitoly,
    nazevPodkapitoly,
    cisloSekce,
    nazevSekce,
    cisloPodsekce,
    nazevPodsekce,
    cisloZaklinadla,
    textZaklinadla,
    hesZaklinadla, # např. „x75e4112“; má smysl jen při neprázdném textu zaklínadla
    ikona,
    cislaPoznamek,
    textyPoznamek,
    samostatne,

    i, ax, base, jePosledni) {

    # určit, zda je zaklínadlo poslední ve skupině
    jePosledni = 0;
    if (!samostatne) {
        ax = cisloSekce;
        if (cisloPodsekce != 0) {ax = ax "x" cisloPodsekce}
        if (ax in ZAKLINADEL_NA_PODSEKCI) {
            jePosledni = (cisloZaklinadla == ZAKLINADEL_NA_PODSEKCI[ax]) ? 1 : 0;
        }
    }

    ax = "%\n";
    if (DO_LATEXU_ODSTAVEC_PRED_ZAKLINADLEM && cisloZaklinadla == 1 && textZaklinadla != "") {
        ax = ax "\\vspace{2ex}";
    }
    if (textZaklinadla != "") {
        if (DO__UZKY_REZIM) {
            ShoditFatalniVyjimku("Zaklínadla s titulkem jsou v úzkém režimu zakázána!");
        }
        ax = ax "\\zaklinadlo{";
        # #2 = číslo zaklínadla
        ax = ax cisloZaklinadla "}{";
        # #3 = pro poslední zaklínadlo „\hline“, jinak „“
        ax = jePosledni ? ax "\\hline}{" : ax "}{";
        # #4 = titulek zaklínadla + \footnotemark
        # Poznámka: kvůli mechanismu „postprocess“ je potřeba oddělit titulek zaklínadla na víceméně samostatný řádek.
        #if (samostatne) {
            #i = gensub(/^[Zz][Aa][Kk][Ll][íÍ][nN][Aa][Dd][Ll][Aa]:? ?/, "", 1, nazevSekce);
            #if (i != "") {
                #ax = ax "\\underline{\\emph{" i "}}\\\\";
            #}
            #if (nazevPodsekce != "") {
                #ax = ax "\\underline{\\emph{" nazevPodsekce "}}\\\\";
            #}
        #}
        ax = ax "%\n" textZaklinadla;
        if (length(cislaPoznamek) > 0) {
            base = AlokovatPoznamkuPodCarou();
            ax = ax "\\footnotemark[" base "]";
            for (i = 1; i < length(cislaPoznamek); ++i) {
                ax = ax "\\footnotemark[" AlokovatPoznamkuPodCarou() "]";
            }
        }
        ax = ax "}%\n{";
        # #5 = \footnotetext
        for (i = 0; i < length(cislaPoznamek); ++i) {
            ax = ax "\\footnotetext[" (base + i) "]{" textyPoznamek[cislaPoznamek[i]] "}";
        }
        ax = ax "}{";
        if (!samostatne && hesZaklinadla != "") {
            ax = ax "k" cisloKapitoly hesZaklinadla;
        }
        ax = ax "}{%\n";
    } else {
        ax = ax "\\ukazka{";
    }
    # #6 = řádky zaklínadla
    return ax;
}


# Pomocná funkce pro RadekZaklinadla(text).
# Toto je jednoduchá a rychlá implementace vkládání příkazu {\moznyzlom} pro umožnění zalomení
# delších řádků mimo mezery. Na vstup má již přeložený text v LaTeXu, takže je třeba
# k němu přistupovat opatrně.
function ZalomitRadekZaklinadla(text,   c, i, slzav, hrzav, lastzlom) {
    split("", zlomy);
    slzav = 0;
    hrzav = 0;
    lastzlom = 1;

    for (i = 1; i <= length(text); ++i) {
        switch (c = substr(text, i, 1)) {
            # Výčet znaků, za kterými je možno řádek zalomit:
            case ",":
            case ":":
            case ";":
            case "=":
            case "|":
                if (substr(text, i >= 6 ? i - 5 : 1, 10) !~ / /) {
                    if ((slzav == 0 || (slzav == 1 && substr(text, i - 1, 1) == "{" && substr(text, i + 1, 1) == "}")) && hrzav == 0 && i - lastzlom >= 5) {
                        zlomy[length(zlomy) + 1] = i;
                        lastzlom = i;
                    }
                }
                continue;
            case "{":
                if (substr(text, i, 8) == "{\\rovno}") {
                    i += 7;
                    if ((slzav == 0 || (slzav == 1 && substr(text, i - 1, 1) == "{" && substr(text, i + 1, 1) == "}")) && hrzav == 0 && i - lastzlom >= 5) {
                        zlomy[length(zlomy) + 1] = i;
                        lastzlom = i;
                    }
                    continue;
                }
                ++slzav;
                continue;
            case "}":
                --slzav;
                continue;
            case "[":
                ++hrzav;
                continue;
            case "]":
                --hrzav;
                continue;
            case "\\":
                ++i;
                continue;
            default:
                continue;
        }
    }

    for (i = length(zlomy); i > 0; --i) {
        text = substr(text, 1, zlomy[i]) "{\\moznyzlom}" substr(text, zlomy[i] + 1);
    }
    delete zlomy;
    return text;
}


function RadekZaklinadla(text, urovenOdsazeni, prikladHodnoty) {
#    gsub(/=/, "={\\moznyzlom}", text);

    if (urovenOdsazeni == 0) {
        return "%\n\\radekzaklinadla{\\pismolmmath{}∘\\hspace*{0.1em}}{" ZalomitRadekZaklinadla(text) (prikladHodnoty != "" ? "\\priklad{}" prikladHodnoty : "") "}";

    } else if (0 < urovenOdsazeni && urovenOdsazeni <= 9) {
        return "%\n\\radekzaklinadla{\\pismolmmath{}∘\\hspace*{0.1em}}{" Zopakovat("~", 2 * urovenOdsazeni) ZalomitRadekZaklinadla(text) (prikladHodnoty != "" ? "\\priklad{}" prikladHodnoty : "") "}";

    } else if (urovenOdsazeni == UROVEN_AKCE) {
        return "%\n\\radekzaklinadla{\\pismodejavusans{}➙\\hspace*{-0.15em}}{\\pismoserif{}" ZalomitRadekZaklinadla(text) "}";

    } else if (urovenOdsazeni == UROVEN_PREAMBULE) {
        return "%\n\\radekzaklinadla{\\pismolmmath{}↟\\hspace{0.04em}}{" ZalomitRadekZaklinadla(text) (prikladHodnoty != "" ? "\\priklad{}" prikladHodnoty : "") "}";

    } else {
        ShoditFatalniVyjimku("Nepodporovaná úroveň odsazení: " urovenOdsazeni);
    }
}

function KonecZaklinadla() {
    return "%\n}";
}

function FormatTucne(jeZacatek) {
    return jeZacatek ? "\\bfseries{}" : "\\mdseries{}";
}

function FormatKurziva(jeZacatek) {
    return jeZacatek ? "\\itshape{}" : "\\upshape{}";
}

function FormatDopln(jeZacatek, jePoJinemDopln) {
    return jeZacatek ? (jePoJinemDopln ? "\\hspace{0.2em}" : "") "\\dopln{" : "}";
}

function FormatKlavesa(jeZacatek, jePoJineKlavese) {
    return jeZacatek ? (jePoJineKlavese ? "\\hspace{0.2em}" : "") "\\klavesa{" : "}";
}

function FormatVolitelny(jeZacatek) {
    return jeZacatek ? "\\volitelnyzacatek{}" : "\\volitelnykonec{}";
}

function ReseniNezname() {
    return "{\\reseninezname}";
}

function TriTecky() {
    return "{\\color{seda}\\bfseries\\tritecky}";
}

function Obrazek(src, alt, rawSrc, rawAlt,   sirka) {
    src = rawSrc;
    sub(/^\.\.\/obr[aá]zky\//, "../pdf-společné/_obrázky/", src);
    sub(/\.svg$/, ".pdf", src);
    sirka = PrecistKonfig("Obrázky", rawSrc);
    if (sirka != "") {
        sirka = "[width=" sirka "]";
    }
    return "\\begin{center}\\includegraphics" sirka "{" src "}\\end{center}";
}

function ZapnoutRezimLicence() {
    if (DO__REZIM_LICENCE) {ShoditFatalniVyjimku("CHYBA: Opakované zapnutí režimu licence!")}
    DO__REZIM_LICENCE = 1;
    return "\\zapnoutrezimlicence{}";
}

function VypnoutRezimLicence() {
    if (!DO__REZIM_LICENCE) {ShoditFatalniVyjimku("CHYBA: Vypnutí režimu licence bez zapnutí!")}
    DO__REZIM_LICENCE = 0;
    return "\\vypnoutrezimlicence{}";
}

function ZapnoutUzkyRezim() {
    if (DO__UZKY_REZIM) {ShoditFatalniVyjimku("CHYBA: Opakované zapnutí úzkého režimu!")}
    DO__UZKY_REZIM = 1;
    return "\\begin{uzkyrezim}";
}

function VypnoutUzkyRezim() {
    if (!DO__UZKY_REZIM) {ShoditFatalniVyjimku("CHYBA: Vypnutí úzkého režimu bez zapnutí!")}
    DO__UZKY_REZIM = 0;
    return "\\end{uzkyrezim}";
}

function VzornikIkon(pocetIkon, ikony) {
    pocetIkon = ZacatekOdstavcu(1) "\\raggedright\\emph{(v PDF formátech již ikony zaklínadel nejsou podporovány)}%\n";
    return pocetIkon KonecOdstavcu();
}

function RejstrikPodleKlasickychPrikazu(    pocet, predchozi_typ, soubor, vysl) {
    #if (DO__UZKY_REZIM) {ShoditFatalniVyjimku("Rejstřík podle klasických příkazů není dovolen v úzkém režimu!");}
    soubor = SOUBORY_PREKLADU "/klasické-příkazy.dat";
    pocet = 0;
    predchozi_typ = "";
    vysl = "{\\raggedright\\medskip%\n";
    while (getline < soubor) {
        typ = substr($1, 1, 1);
        #if (pocet == 0) {vysl = vysl "<dl class=\"klasickeprikazy\">";}
        switch (typ) {
            case "%": # %<klasický-příkaz>\t<počet-úkolů>\t<popis-klpříkazu>
                if (pocet > 0) {
                    vysl = vysl "\\end{itemize}\\end{samepage}\\mbox{}\\\\[-0.5ex]";
                }
                vysl = vysl "\\noindent\\begin{samepage}\\textbf{" substr($1, 2) "}~---~\\emph{" $3 "}%\n\\begin{itemize}[leftmargin=18pt,rightmargin=0pt,nosep,label=]\\renewcommand*{\\baselinestretch}{1.05}\\raggedright\\selectfont%\n";
                break;
            case "-": # -<číslo-kapitoly>\t<ploché-id-bez-diakr>\t<xheš>\t<úkol>
                odk_kapitola = $2 ".htm";
                odk_xhes = $3;
                odk_index_kapitoly = substr($1, 2);
                odk_symbol_kapitoly = FragInfo(odk_index_kapitoly, "symbol");
                odk_nazev_kapitoly = FragInfo(odk_index_kapitoly, "celý-název");
                vysl = vysl "\\item\\relax{}" gensub(/ /, "~", "g", $4) "\\dotfill\\pageref{k" odk_index_kapitoly odk_xhes "}%\n";
                #"<li><a href=\"" odk_kapitola "#z" odk_xhes "\">"  "</a> <span class=\"kapitola\">(<a href=\"" odk_kapitola "\">" odk_symbol_kapitoly "&nbsp;" odk_nazev_kapitoly "</a>)</span></li>";
                break;
            default:
                ShoditFatalniVyjimku("Vnitřní chyba překladu: chybný typ záznamu \"" typ "\"!");
        }
        predchozi_typ = typ;
        ++pocet;
    }
    vysl = vysl (pocet == 0 ? "\\emph{Rejstřík neobsahuje žádné klasické příkazy.}\n\n" : "\\end{itemize}\\end{samepage}") "\\par}%\n";
    close(soubor);
    return vysl;
}


@include "skripty/překlad/hlavní.awk"
