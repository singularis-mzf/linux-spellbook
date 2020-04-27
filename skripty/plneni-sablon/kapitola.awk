# Linux Kniha kouzel, skript kapitola.awk
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
    VyzadujePromennou("IDKAPITOLY");
    VyzadujePromennou("JMENOVERZE");
    VyzadujePromennou("DATUMSESTAVENI");
    # Poznámka: tento skript obvykle nezná IDFORMATU! (Výjimkou je případ, kdy je použit {{PŘEHLED ŠTÍTKŮ}}.)
}

# VEŘEJNÉ FUNKCE
# ============================================================================

# Zacatek()
#       – Je volaná před začátkem zpracování (v místě řádku „{{ZAČÁTEK}}“).
#       – Jejím úkolem je inicializace.
#
function Zacatek() {
    datum = sprintf("%d. %s %s", substr(DATUMSESTAVENI, 7, 2), MesicVDruhemPade(sprintf("%d", substr(DATUMSESTAVENI, 5, 2))), substr(DATUMSESTAVENI, 1, 4));

    while (getline < FRAGMENTY_TSV) {
        if ($2 == IDKAPITOLY) {break}
    }
    close(FRAGMENTY_TSV);
    if ($2 == IDKAPITOLY) {
        adresar = $1;
        nazev_kapitoly = $3;
        if ($4 != "NULL") {
            id_predchozi = $4;
            nazev_predchozi = $5;
        } else {
            id_predchozi = nazev_predchozi = "";
        }
        if ($6 != "NULL") {
            id_nasledujici = $6;
            nazev_nasledujici = $7;
        } else {
            id_nasledujici = nazev_nasledujici = "";
        }
        cislo_kapitoly = $8;
        ikona_kapitoly = $11;
    } else if (IDKAPITOLY ~ /^_(autori|stitky)$/) {
        id_predchozi = id_nasledujici = nazev_predchozi = nazev_nasledujici = "";
        cislo_kapitoly = 0;
        ikona_kapitoly = "ik-vychozi.png";
    } else {
        # kapitola, pro kterou neexistuje záznam, takže pravděpodobně nebude zapsána na výstup:
        existuje_kapitola = Test("-r kapitoly/" IDKAPITOLY ".md");
        existuje_dodatek = Test("-r dodatky/" IDKAPITOLY ".md");
        if (existuje_dodatek == existuje_kapitola) {
            ShoditFatalniVyjimku("ID \"" IDKAPITOLY "\": " (existuje_kapitola ? "existuje kapitola i dodatek!" : "neexistuje ani kapitola ani dodatek!"));
        }
        adresar = (existuje_kapitola ? "kapitoly" : "dodatky");
        nazev_kapitoly = "(Není na výstup)";
        id_predchozi = id_nasledujici = nazev_predchozi = nazev_nasledujici = "";
        cislo_kapitoly = 0;
        ikona_kapitoly = "ik-vychozi.png";
    }

    predevsim_pro = ZjistitPredevsimPro(JMENOVERZE);
    return 0;
}

function Pokud(podminka,   i, pole) {
    switch (podminka) {
        case "JE PRVNÍ":
            return id_predchozi == "";
        case "NENÍ PRVNÍ":
            return id_predchozi != "";
        case "JE POSLEDNÍ":
            return id_nasledujici == "";
        case "NENÍ POSLEDNÍ":
            return id_nasledujici != "";
        case "ZNÁME PŘEDEVŚIM PRO":
            return predevsim_pro != "";
        case "MÁ VERZE JMÉNO":
            return ZjistitJmenoVerze(JMENOVERZE) != "";
    }
    ShoditFatalniVyjimku("Neznámá direktiva {{POKUD " podminka "}}!");
}

# RidiciRadek()
#       – Obsluhuje obecné řídicí řádky, např. „{{XYZ}}“.
#       – Neobsluhuje {{ZAČÁTEK}}, {{KONEC}}, {{POKUD *}}, {{KONEC POKUD}}, {{VARIANTA *}}, {{VARIANTY *}}.
#       – Na návratové hodnotě nezáleží.
#
function RidiciRadek(text) {
    switch (text) {
        case "TĚLO KAPITOLY":
            VyzadujePromennou("TELOKAPITOLY", "Kapitola požaduje {{TĚLO KAPITOLY}} a není nastavena proměnná TELOKAPITOLY!");
            system("cat '" TELOKAPITOLY "'");
            return 0;

        case "COPYRIGHTY KAPITOL":
            VyzadujePromennou("COPYRIGHTY_KAPITOL", "Kapitola požaduje {{COPYRIGHTY KAPITOL}} a není nastavena proměnná COPYRIGHTY_KAPITOL!");
            system("cat '" COPYRIGHTY_KAPITOL "'");
            return 0;

        case "COPYRIGHTY OBRÁZKŮ":
            VyzadujePromennou("COPYRIGHTY_OBRAZKU", "Kapitola požaduje {{COPYRIGHTY OBRÁZKŮ}} a není nastavena proměnná COPYRIGHTY_OBRAZKU!");
            system("cat '" COPYRIGHTY_OBRAZKU "'");
            return 0;

        case "PŘEHLED ŠTÍTKŮ":
            VyzadujePromennou("IDFORMATU", "Kapitola požaduje {{PŘEHLED ŠTÍTKŮ}}, ale není nastavena proměnná IDFORMATU!");
            VypsatPrehledStitku(IDFORMATU);
            return 0;

        default:
            return RidiciRadekSpolecnaObsluha(text);
    }
}

# PrelozitVystup()
#       – Má za úkol zpracovat obyčejný řádek, než bude vypsán na výstup.
#       – Typicky nahrazuje výskyty speciálních značek.
#
function PrelozitVystup(radek) {
#    gsub(/\{\{JMÉNO VERZE\}\}/, EscapovatKNahrade(JMENOVERZE), radek);
    gsub(/\{\{NÁZEV KAPITOLY\}\}/, nazev_kapitoly, radek);
    gsub(/\{\{PŘEDCHOZÍ ID\}\}/, id_predchozi, radek);
    gsub(/\{\{PŘEDCHOZÍ NÁZEV\}\}/, nazev_predchozi, radek);
    gsub(/\{\{PŘEDCHOZÍ ČÍSLO\}\}/, id_predchozi != "" ? cislo_kapitoly - 1 : 0, radek);
    gsub(/\{\{NÁSLEDUJÍCÍ ID\}\}/, id_nasledujici, radek);
    gsub(/\{\{NÁSLEDUJÍCÍ NÁZEV\}\}/, nazev_nasledujici, radek);
    gsub(/\{\{NÁSLEDUJÍCÍ ČÍSLO\}\}/, id_nasledujici != "" ? cislo_kapitoly + 1 : 0, radek);
    gsub(/\{\{ČÍSLO KAPITOLY\}\}/, cislo_kapitoly, radek);
    gsub(/\{\{OZNAČENÍ VERZE\}\}/, EscapovatKNahrade(ZjistitOznaceniVerze(JMENOVERZE)), radek);
    gsub(/\{\{JMÉNO VERZE\}\}/, EscapovatKNahrade(ZjistitJmenoVerze(JMENOVERZE)), radek);
    gsub(/\{\{PŘEDEVŚIM PRO\}\}/, EscapovatKNahrade(predevsim_pro), radek);
    gsub(/\{\{DATUMSESTAVENÍ\}\}/, DATUMSESTAVENI, radek);
    gsub(/\{\{DATUM SESTAVENÍ\}\}/, datum, radek);
    gsub(/\{\{IKONA KAPITOLY\}\}/, ikona_kapitoly, radek);

    /^{/; # prázdný příkaz kvůli zvýrazňování syntaxe
    if (match(radek, /\{\{[^}]+\}\}/)) {
        ShoditFatalniVyjimku("Neznámé makro: " substr(radek, RSTART, RLENGTH));
    }

    return radek;
}

# Konec()
#       – Je volaná na konci zpracování, nenastala-li fatální výjimka.
#
function Konec() {
    return 0;
}
# ============================================================================

# Soukromé funkce a proměnné:
# ============================================================================

function VypsatPrehledStitku(format,   i, n, s, nazvy_kapitol, cisla_kapitol, stitky_kapitol, stitky_kapitoly, ikony_kapitol) {
    if (format != "html") {
        ShoditFatalniVyjimku("Přehled štítků pro formát " format " není podporován!");
    }

    delete nazvy_kapitol; # $8
    delete cisla_kapitol; # $3
    delete stitky_kapitol; # $9
    delete ikony_kapitol; # $11
    VyzadujeFragmentyTSV();
    for (i = 1; i < POCET_KAPITOL; ++i) {
        $0 = FRAGMENTY_TSV_RADKY[i];
        cisla_kapitol[$2] = $8;
        nazvy_kapitol[$2] = $3;
        stitky_kapitol[$2] = $9;
        ikony_kapitol[$2] = $11;
    }

    # Načíst štítky ze stitky.tsv:
    stitky_tsv = gensub(/fragmenty/, "stitky", 1, FRAGMENTY_TSV);
    while (getline < stitky_tsv) {
        # obrazky/ik-vychozi.png 64x64
        if (NF < 3) {ShoditFatalniVyjimku("Chyba formátu stitky.tsv: očekávány alespoň tři sloupce!")}
        # $1 = štítek $2 = omezené id štítku $3..$NF = id kapitol
        print "<dt id=\"" $2 "\" class=\"stitky\"><span><a href=\"#" $2 "\">" $1 "</a></span></dt><dd>";
        for (i = 3; i <= NF; ++i) {
            if (!($i in cisla_kapitol)) {ShoditFatalniVyjimku("Nečekané id kapitoly: " $i)}

            print "<div><a href=\"" $i ".htm\"><span class=\"cislo\">" cisla_kapitol[$i] ".</span>\n<img src=\"obrazky/" ikony_kapitol[$i] "\" width=\"64\" height=\"64\" alt=\"\">\n<span class=\"nazev\">" nazvy_kapitol[$i] "</span></a><span class=\"dalsistitky\">";
            n = split(gensub(/^\{|\}$/, "", "g", stitky_kapitol[$i]), stitky_kapitoly, "\\}\\{");
            for (j = 1; j <= n; ++j) {
                print "<a href=\"#" GenerovatOmezeneId("s", stitky_kapitoly[j]) "\">" stitky_kapitoly[j] "</a>";
            }
            print "</span></div>";

            #print "<tr><td>" cisla_kapitol[$i] ".</td><td><img src=\"obrazky/ik-vychozi.png\" width=\"64\" height=\"64\" alt=\"\"></td><td><a href=\"" $i "\">" nazvy_kapitol[$i] "</a></td></tr>";

            #print "<div><span class=\"cislo\">" cisla_kapitol[$i] "</span><a href=\"" $i ".htm\">" nazvy_kapitol[$i] "</a></div>";
        }
        print "</dd>";
    }
    return close(stitky_tsv);
}

# ============================================================================
@include "skripty/plneni-sablon/hlavni.awk"
