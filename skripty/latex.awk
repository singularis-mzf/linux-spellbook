# Linux Kniha kouzel, skript latex.awk
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

function NactiBarvu(cislo,   prikaz, vysledek) {
    prikaz = cislo == "" ? "tput sgr0" : "tput setaf " cislo;
    while (prikaz | getline) {}
    vysledek = $0;
    return close(prikaz) == 0 ? vysledek : "";
}

BEGIN {
    # Globální nastavení
    FS = "\t";
    OFS = "";
    ORS = "\n";
    ARGC = 2;
    ARGV[1] = "/dev/null";

    # Načíst barvy
    if (ENVIRON["TERM"] != "" && system("test -t 1") == 0) {
        resetbarvy = NactiBarvu("");
        cervena = NactiBarvu(1);
        zelena = NactiBarvu(2);
        zluta = NactiBarvu(3);
    } else {
        resetbarvy = cervena = zelena = zluta = "";
    }

    # Inicializovat globální proměnné
    delete fronta;
    prikaz = "pdflatex -halt-on-error -no-shell-escape kniha | tr '\\200-\\376\\377' '?'";
    beh = 0;

    do {
        # Inicializovat lokální proměnné
        pamet = ""; # pokud se zdá, že řádek ještě neskončil, uloží se sem
        znovu = 0;  # pokud je třeba spustit LaTeX znovu, nastaví se tento příznak.
        po_varovani = 0;
        zprava = "Spouštím LaTeX (" (++beh) ". běh):";
        hranice = Zopakovat("#", length(zprava) + 2);
        delete dulezite_radky;
        po_full_hboxu = 0;

        # Spustit LaTeX a zpracovat výstup
        print "\n\n", zelena, hranice, "\n# ", zprava, resetbarvy, " ", prikaz, "\n", zelena, hranice, resetbarvy;
        while (prikaz | getline) {
            if (length($0) == 79) {
                pamet = pamet $0;
                continue;
            }
            if (pamet != "") {
                $0 = pamet $0;
                pamet = "";
            }
            if (po_varovani && $0 == "") {
                po_varovani = 0;
                continue;
            }
            if (po_full_hboxu) {
                po_full_hboxu = 0;
                dulezite_radky[1 + length(dulezite_radky)] = $0;
            }
            if ($0 ~ /^(Over|Under)full \\[hv]box /) {
                dulezite_radky[1 + length(dulezite_radky)] = $0;
                po_full_hboxu = $0 ~ /^(Over|Under)full \\h/;
            }

            if ($0 ~ /^LaTeX Warning: /) {
                print zluta, $0, resetbarvy;
                po_varovani = 1;
            } else {
                gsub(/\[[0-9]+\]/, zelena "&" resetbarvy);
                print $0;
                po_varovani = 0;
            }

            if ($0 == "LaTeX Warning: Label(s) may have changed. Rerun to get cross-references right.") {
                znovu = 1;
            }
        }
        if (pamet != "") {
            print pamet;
            pamet = "";
        }

        # Závěr
        vysledek = close(prikaz) / 256;
        if (vysledek > 0) {
            print "CHYBA: LaTeX skončil s chybovým kódem ", vysledek, "!" > "/dev/stderr";
            FATALNI_VYJIMKA = vysledek;
            exit;
        }
    } while (znovu);

    if (length(dulezite_radky) != 0) {
        print zluta, "Důležité řádky:";
        for (i = 1; i <= length(dulezite_radky); ++i) {
            print zelena, "- ", resetbarvy, dulezite_radky[i];
        }
        print resetbarvy;
    }
}

#
# /^LaTeX Font Warning: Font shape `T1\/bsk\/(m|bx)\/(n|it|sl)' undefined$/
# /^\(Font\)              using `T1\/[a-z]+\/[a-z]+\/n' instead on input line [0-9]+\.$/
#
# LaTeX Warning: Reference `kapxbarvyatitulek' on page 3 undefined on input line 284.
#LaTeX Warning: Reference `kapxzpracovanivideaazvuku' on page 4 undefined on input line 355.

END {
    # Končíme-li s fatální výjimkou, skončit hned.
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
}
