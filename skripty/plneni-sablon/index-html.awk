# Linux Kniha kouzel, skript plneni-sablon/index-html.awk
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

# POŽADAVKY
# ============================================================================
BEGIN {
    VyzadujeFragmentyTSV();
    VyzadujePromennou("DATUMSESTAVENI");
    VyzadujePromennou("JMENOVERZE");
}

# VEŘEJNÉ FUNKCE
# ============================================================================
function Zacatek() {
    if (IDFORMATU == "") {IDFORMATU = "html"}
    datum = sprintf("%d. %s %s", substr(DATUMSESTAVENI, 7, 2), MesicVDruhemPade(sprintf("%d", substr(DATUMSESTAVENI, 5, 2))), substr(DATUMSESTAVENI, 1, 4));

    delete adresar;
    delete id;
    delete nazev;
    delete cislo;
    delete stitky;
    delete ikony;
    delete vycleneno;

    predevsim_pro = ZjistitPredevsimPro(JMENOVERZE);

    pocet = 0;
    while (getline < FRAGMENTY_TSV) {
# 1=Adresář|2=ID|3=Název|4=Předchozí ID|5=Předchozí název|6=Následující ID|7=Následující název
# 8=Číslo dodatku/kapitoly|9=Štítky v {}|10=Omezené id|11=ikona kapitoly
        ++pocet;
        adresar[pocet] = $1;
        id[pocet] = $2;
        nazev[pocet] = $3;
        cislo[pocet] = $8;
        stitky[pocet] = $9 != "NULL" ? $9 : "";
        ikony[pocet] = $11;
        vycleneno[pocet] = 0;
    }
    close(FRAGMENTY_TSV);
    return 0;
}

function Pokud(podminka) {
    if (podminka ~ /^JE FORMÁT ./) {
        return IDFORMATU == substr(podminka, 11);
    } else if (podminka == "ZNÁME PŘEDEVŠÍM PRO") {
        return predevsim_pro != "";
    } else if (podminka == "MÁ VERZE JMÉNO") {
        return ZjistitJmenoVerze(JMENOVERZE) != "";
    } else {
        ShoditFatalniVyjimku("Neznámá direktiva {{POKUD " podminka "}}!");
    }
}

function RidiciRadek(text,   i, s) {
    s = text;
    if (sub(/^VYČLENIT SEM PODLE ID:/, "", s) && s !~ /^$|\}/) {
        for (i = 1; i <= pocet; ++i) {
            if (id[i] == s) {VypsatOdkazNaKapitolu(i, 1)}
        }
        return 0;
    }

    s = text;
    if (sub(/^VYČLENIT SEM PODLE ŠTÍTKU:/, "", s) && s !~ /^$|\}/) {
        for (i = 1; i <= pocet; ++i) {
            if (index(stitky[i], "{" s "}")) {VypsatOdkazNaKapitolu(i, 1)}
        }
        return 0;
    }

    switch (text) {
        case "VYPSAT ZBYTEK PO VYČLENĚNÍ":
            for (i = 1; i <= pocet; ++i) {
                if (!vycleneno[i]) {VypsatOdkazNaKapitolu(i, 1)}
            }
            return 0;

        case "VYPSAT ZBYTEK KAPITOL":
            for (i = 1; i <= pocet; ++i) {
                if (!vycleneno[i] && adresar[i] == "kapitoly") {VypsatOdkazNaKapitolu(i, 1)}
            }
            return 0;

        case "VYPSAT ZBYTEK DODATKŮ":
            for (i = 1; i <= pocet; ++i) {
                if (!vycleneno[i] && adresar[i] == "dodatky") {VypsatOdkazNaKapitolu(i, 1)}
            }
            return 0;

        default:
            ShoditFatalniVyjimku("Neznámý řídicí řádek: {{" text "}}!");
    }
}

function PrelozitVystup(radek) {
    #gsub(/\{\{JMÉNO VERZE\}\}/, EscapovatKNahrade(JMENOVERZE), radek);
    gsub(/\{\{DATUM SESTAVENÍ\}\}/, datum, radek);
    gsub(/\{\{DATUMSESTAVENÍ\}\}/, DATUMSESTAVENI, radek);
    gsub(/\{\{JMÉNO VERZE\}\}/, EscapovatKNahrade(ZjistitJmenoVerze(JMENOVERZE)), radek);
    gsub(/\{\{OZNAČENÍ VERZE\}\}/, EscapovatKNahrade(ZjistitOznaceniVerze(JMENOVERZE)), radek);
    gsub(/\{\{PŘEDEVŠÍM PRO\}\}/, EscapovatKNahrade(predevsim_pro), radek);

    return radek;
}

function Konec() {
    return 0;
}
# ============================================================================

# Soukromé funkce a proměnné:
# ============================================================================

function VypsatOdkazNaKapitolu(i, vyclenit) {
    print "<li value=\"" cislo[i] "\"><a href=\"" id[i] ".htm\"><span class=\"ikona\"><img src=\"obrazky/" ikony[i] "\" alt=\"\"></span>" nazev[i] "</a></li>";
    if (vyclenit) {
        vycleneno[i] = 1;
    }
    return 0;
}

# ============================================================================
@include "skripty/plneni-sablon/hlavni.awk"
