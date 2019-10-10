# Linux Kniha kouzel, skript do_latexu.awk
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

BEGIN {
    DO_LATEXU_CISLO_POZN_POD_CAROU = 0;
}

# Pomocná funkce:
function AlokovatPoznamkuPodCarou() {
    return ++DO_LATEXU_CISLO_POZN_POD_CAROU;
}

# Převede odescapovaný znak vstupního formátu (Markdown) do výstupního formátu.
# Pro bílé znaky se volá jedině tehdy, jsou-li escapovány.
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
        case "<":
        case "=":
        case ">":
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
            return "{`}";
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
        case "−":
            return "\\textendash{}";
        case " ":
            return "~";
        case "×":
            return "\\ensuremath{\\times}";
# speciality
        case "⫽":
            return "//";
            # možná použít \sslash z balíčku {stix}
        case "␣":
            return "\\textvisiblespace{}";

        default:
            ShoditFatalniVyjimku("Nalezen nepodporovaný znak: '" znak "'");
    }
}

# Převede bílý znak ze vstupního formátu na výstupní.
function ZpracujBilyZnak(znak, opakovany) {
#    return (opakovany) ? "" : znak;
    return znak;
}

function Tabulator(delka,  i, vysledek) {
    return "\\textcolor{seda}{\\guillemotright}{" Zopakovat("~", max(0, delka - 1)) "}";
}

function ZacatekKapitoly(kapitola, cisloKapitoly) {
    return "\\kapitola{\\MakeUppercase{" kapitola "}}%\n";
}

function KonecKapitoly(kapitola, cislaPoznamek, textyPoznamek) {
    return "";
}

function ZacatekSekce(kapitola, sekce, cisloKapitoly, cisloSekce) {
    switch (sekce) {
        case "Ukázka":
            return "\\clearpage\\sekce{" sekce "}%\n";
        default:
            return "\\sekce{" sekce "}%\n";
    }
}

function KonecSekce(kapitola, sekce) {
    return "";
}

function ZacatekPodsekce(kapitola, sekce, podsekce, cisloKapitoly, cisloSekce, cisloPodsekce) {
    return "\\podsekce{" podsekce "}%\n";
}

function KonecPodsekce(kapitola, sekce, podsekce) {
    return "";
}

function ZacatekOdstavcu(bylNadpis) {
    return "\\begin{odstavce}" (bylNadpis ? "" : "\\hspace{\\parindent}");
}

function PredelOdstavcu() {
    return "\n\n";
}

function KonecOdstavcu() {
    return "\\end{odstavce}";
}

function KonecRadku() {
    return "\\\\{}";
}

function HypertextovyOdkaz(adresa, text,   cisloPoznamky) {
    cisloPoznamky = AlokovatPoznamkuPodCarou();
    return text "\\footnotemark[" cisloPoznamky "]\\footnotetext[" cisloPoznamky "]{" adresa "}";
}

function ZacatekSeznamu(uroven, zarovatDoBloku) {
    return "{" (zarovatDoBloku ? "" : "\\raggedright") "\\begin{itemize}\\relax{}";
}

function ZacatekPolozkySeznamu(uroven) {
    return "%\n\\item{}";
}

function KonecPolozkySeznamu(uroven) {
    return "\n";
}

function KonecSeznamu(uroven) {
    return "\\end{itemize}}";
}

function ZacatekZaklinadla(cisloZaklinadla, textZaklinadla, cislaPoznamek, textyPoznamek,   i, ax, base) {
    ax = "%\n\\zaklinadlo{";
    # #2 = číslo zaklínadla
    ax = ax cisloZaklinadla "}{";
    # #3 = text zaklínadla + \footnotemark
    if (textZaklinadla != "") {
        ax = ax textZaklinadla;
        if (length(cislaPoznamek) > 0) {
            base = AlokovatPoznamkuPodCarou();
            ax = ax "\\footnotemark[" base "]";
            for (i = 1; i < length(cislaPoznamek); ++i) {
                ax = ax "\\footnotemark[" AlokovatPoznamkuPodCarou() "]";
            }
        }
    }
    ax = ax "}%\n{";
    # #4 = \footnotetext
    if (textZaklinadla != "") {
        for (i = 0; i < length(cislaPoznamek); ++i) {
            ax = ax "\\footnotetext[" (base + i) "]{" textyPoznamek[cislaPoznamek[i]] "}";
        }
    }
    ax = ax "}{%\n";
    # #5 = řádky zaklínadla
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
                if (!(substr(text, i >= 6 ? i - 5 : 1, 10) ~ / /)) {
                    if ((slzav == 0 || (slzav == 1 && substr(text, i - 1, 1) == "{" && substr(text, i + 1, 1) == "}")) && hrzav == 0 && i - lastzlom >= 5) {
                        zlomy[length(zlomy) + 1] = i;
                        lastzlom = i;
                    }
                }
                continue;
            case "{":
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


function RadekZaklinadla(text, jeAkce) {
#    gsub(/=/, "={\\moznyzlom}", text);
    return "%\n\\" (jeAkce ? "akcezaklinadla" : "radekzaklinadla") "{" ZalomitRadekZaklinadla(text) "}";
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

function FormatDopln(jeZacatek) {
    return jeZacatek ? "\\dopln{" : "}";
}

function FormatVolitelny(jeZacatek) {
    return jeZacatek ? "\\volitelnyzacatek{}" : "\\volitelnykonec{}";
}

function TriTecky() {
    return "\\textcolor{seda}{\\tritecky}";
}

function Obrazek(src, alt, rawSrc, rawAlt,   sirka) {
    src = (rawSrc ~ /^\.\.\// ? "../pdf-spolecne/_" substr(rawSrc, 4) : rawSrc);
    sirka = PrecistKonfig("Obrázky", rawSrc);
    if (sirka != "") {
        sirka = "[width=" sirka "]";
    }
    return "\\begin{center}\\includegraphics" sirka "{" src "}\\end{center}";
}

@include "skripty/hlavni.awk"
