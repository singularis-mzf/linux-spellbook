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

function ZiskejHashTocSouboru(  prikaz, vysledek) {
    prikaz = "md5sum kniha.toc 2>/dev/null";
    vysledek = "";
    while (prikaz | getline vysledek) {}
    sub(/ .*/, "", vysledek);
    return close(prikaz) == 0 ? vysledek : "(not found)";
}

function ZiskejCisloZnaku(znak,   prikaz, vysledek) {
    if (znak == "") {return 0}
    znak = substr(znak, 1, 1);
    if (znak == "'") {return 39}
    prikaz = "printf %d\\n \\''" znak "'";
    vysledek = "";
    while (prikaz | getline vysledek) {}
    return close(prikaz) == 0 ? vysledek : 0;
}

function ZaradZpravu(hlavicka, text,   i) {
    i = 1 + length(hlavickyZprav);
    hlavickyZprav[i] = hlavicka;
    textyZprav[i] = text;
    return i;
}

function VypisZpravy(barva, jejiReset,   nejvetsiDelkaHlavicky, hranice, i) {
    nejvetsiDelkaHlavicky = 0;
    for (i in hlavickyZprav) {
        nejvetsiDelkaHlavicky = max(nejvetsiDelkaHlavicky, length(hlavickyZprav[i]));
    }
    hranice = Zopakovat("#", 2 + nejvetsiDelkaHlavicky);
    print barva, hranice;
    for (i = 1; i <= length(hlavickyZprav); ++i) {
        print barva, "# ", hlavickyZprav[i], jejiReset, textyZprav[i] != "" ? (": " textyZprav[i]) : "";
    }
    print barva, hranice, jejiReset;
    delete hlavickyZprav;
    delete textyZprav;
    return i;
}

BEGIN {
    # Globální nastavení
    FS = "\t";
    OFS = "";
    RS = ORS = "\n";
    ARGC = 1;

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
    delete hlavickyZprav;
    delete textyZprav;
    prikaz = "xelatex -halt-on-error -file-line-error -interaction=errorstopmode -no-shell-escape kniha.tex";
    beh = 0;
    puvodni_toc_hash = ZiskejHashTocSouboru();

    for (;;) {
        # Inicializovat lokální proměnné
        pamet = ""; # pokud se zdá, že řádek ještě neskončil, uloží se sem
        delete dulezite_radky;
        dulezitych_radku = 0;
        typ_radku = "PRÁZDNÝ";
        radek = "";

        ZaradZpravu("Spouštím LaTeX", "(" (++beh) ". běh)");
        ZaradZpravu("Heš toc souboru", puvodni_toc_hash);
        ZaradZpravu("Příkaz", prikaz);
        VypisZpravy(zelena, resetbarvy);

        # Spustit LaTeX a zpracovat výstup
        while (prikaz | getline) {
            while (length($0) == 79 && (pamet = pamet $0) != "" && ((prikaz | getline) || ($0 = ""))) {}
            predchozi_radek = radek;
            predchozi_typ_radku = typ_radku;
            radek = pamet $0;
            pamet = "";

            # Určit typ řádku
            if (radek == "") {
                typ_radku = "PRÁZDNÝ";
            } else if (radek ~ /^(Over|Under)full \\[hv]box /) {
                typ_radku = radek ~ /^[^\\]*\\h/ ? "FULL_HBOX" : "FULL_VBOX";
            } else if (radek ~ /^LaTeX Warning: /) {
                typ_radku = "VAROVÁNÍ";
            } else {
                typ_radku = "NORMALNI";
            }

            if (predchozi_typ_radku == "VAROVÁNÍ" && typ_radku == "PRÁZDNÝ") {
                predchozi_typ_radku = typ_radku;
                continue;
            }
            if (typ_radku ~ /^FULL_[HV]BOX$/) {
                dulezite_radky[++dulezitych_radku] = radek;
            } else if (predchozi_typ_radku == "FULL_HBOX") {
                dulezite_radky[++dulezitych_radku] = radek;
            }

            if (typ_radku == "VAROVÁNÍ") {
                print zluta, radek, resetbarvy;
            } else {
                print gensub(/\[[0-9]+\]/, zelena "&" resetbarvy, "g", radek);
            }
        }
        if (pamet != "") {
            print pamet;
            pamet = "";
        }

        # Závěr
        vysledek = close(prikaz);
        if (vysledek > 0) {
            print cervena, "CHYBA: LaTeX skončil s chybovým kódem ", vysledek, "!", resetbarvy > "/dev/stderr";
            exit vysledek;
        }

        nova_toc_hash = ZiskejHashTocSouboru();
        if (nova_toc_hash == puvodni_toc_hash) {break}
        puvodni_toc_hash = nova_toc_hash;
    }

    # Zpracovat log z posledního běhu
    while (getline < "kniha.log") {
            if (length($0) == 79) {
                pamet = pamet $0;
                continue;
            }
            predchozi_radek = radek;
            predchozi_typ_radku = typ_radku;
            radek = pamet $0;
            pamet = "";

            if (radek ~ /^Missing character: There is no . in font [^/]+\//) {
                typ_radku = "CHYBĚJÍCÍ_ZNAK";
            } else {
                typ_radku == "NORMALNI";
            }

            if (typ_radku == "CHYBĚJÍCÍ_ZNAK") {
                i = ZiskejCisloZnaku(substr(radek, 32, 1));
                font = gensub(/\/.*/, "", 1, substr(radek, 42));
                dulezite_radky[++dulezitych_radku] = sprintf("%s\\u%04x%s", substr(radek, 1, 31), i, substr(radek, 33));
            }
    }
    close("kniha.log");

    if (dulezitych_radku != 0) {
        print zluta, "Důležité řádky:";
        for (i = 1; i <= dulezitych_radku; ++i) {
            s = dulezite_radky[i];
            if (s ~ /^(Over|Under)full [^(]*\([^)]*\)/) {
                sub(/\([^)]*\)/, zelena "&" resetbarvy, s);
            }
            s = zelena "- " resetbarvy s;
            print s;
        }
        print resetbarvy;
    }
}

#
# /^LaTeX Font Warning: Font shape `T1\/bsk\/(m|bx)\/(n|it|sl)' undefined$/
# /^\(Font\)              using `T1\/[a-z]+\/[a-z]+\/n' instead on input line [0-9]+\.$/
#
# LaTeX Warning: Reference `kapxbarvyatitulek' on page 3 undefined on input line 284.

# Missing character: There is no  in font DejaVu Sans/OT:script=latn;language=DFLT;mapping=tex-text;!
