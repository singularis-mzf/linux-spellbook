# Linux Kniha kouzel, skript plnění-šablon/speciální.awk
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

# POŽADAVKY
# ============================================================================
BEGIN {
    VyzadujeFragmentyTSV();
    VyzadujePromennou("IDFORMATU");
    VyzadujePromennou("JMENOVERZE");
}

# VEŘEJNÉ FUNKCE
# ============================================================================
function Zacatek() {
    return 0;
}

function Pokud(podminka) {
    if (podminka == "MÁ VERZE JMÉNO") {
        return ZjistitJmenoVerze(JMENOVERZE) != "";
    } else {
        ShoditFatalniVyjimku("Neznámá direktiva {{POKUD " podminka "}}!");
    }
}

function RidiciRadek(text) {
    switch (text) {
        case "PŘEHLED PODLE ŠTÍTKŮ": # zatím výhradně pro PDF
            # 1. Shromáždit a seřadit existující štítky
            delete stitky;
            prikaz = "printf %s '";
            for (i = 1; i in FRAGMENTY; ++i) {
                if (FRAGMENTY[i "/stitky"] != "NULL") {
                    prikaz = prikaz gensub(/\{|\}|\|/, "\n", "g", gensub(/'/, "'\\\\''", "g", FRAGMENTY[i "/stitky"]));
                }
            }
            prikaz = prikaz "\n' | LC_ALL=\"cs_CZ.UTF-8\" sort -fu";
            i = 0;
            while (prikaz | getline) {if ($0 != "") {stitky[++i] = $0}}
            close(prikaz);
            l = i; # počet štítků

            for (i = 1; i <= l; ++i) {
                prvniZaznamNaStitek = 1;
                for (j = 1; j in FRAGMENTY; ++j) {
                    stitkykapitoly = FRAGMENTY[j "/stitky"];
                    if (index(stitkykapitoly, "{" stitky[i] "}")) {
                        if (prvniZaznamNaStitek) {
                            prvniZaznamNaStitek = 0;
                            print "\\begin{ppsstitek}{" stitky[i] "}";
                        }
                        gsub(/\{/, "\\ppsstitekpolozky{", stitkykapitoly); /\}/; # „/\}/“ jen kvůli zvýrazňování syntaxe, nic nedělá
                        print "\\ppspolozka{" $3 "}{" stitkykapitoly "}{" FRAGMENTY[j "/omezid"] "}%";
                    }
                }
                close(FRAGMENTY_TSV);
                if (!prvniZaznamNaStitek) {print "\\end{ppsstitek}"}
            }
            return 0;

        case "TĚLO":
            VyzadujePromennou("TELO", "Kapitola požaduje {{TĚLO}} a není nastavena proměnná TELO!");
            system("cat '" TELO "'");
            return 0;

        default:
            return RidiciRadekSpolecnaObsluha(text);
    }
}

function PrelozitVystup(radek) {
    gsub(/\{\{OZNAČENÍ VERZE\}\}/, OdzvlastnitKNahrade(ZjistitOznaceniVerze(JMENOVERZE)), radek);
    gsub(/\{\{JMÉNO VERZE\}\}/, OdzvlastnitKNahrade(ZjistitJmenoVerze(JMENOVERZE)), radek);
    return radek;
}

function Konec() {
    return 0;
}
# ============================================================================

# Soukromé funkce a proměnné:
# ============================================================================




# ============================================================================
@include "skripty/plnění-šablon/hlavní.awk"
