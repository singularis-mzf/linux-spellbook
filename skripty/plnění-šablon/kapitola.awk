# Linux Kniha kouzel, skript plnění-šablon/kapitola.awk
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

    if ("id/" IDKAPITOLY in FRAGMENTY) {
        cislo_kapitoly = FRAGMENTY["id/" IDKAPITOLY];
        adresar = FRAGMENTY[cislo_kapitoly "/adr"];
        nazev_kapitoly = FRAGMENTY[cislo_kapitoly "/nazev"];
        if (cislo_kapitoly != 1) {
            id_predchozi = FRAGMENTY[(cislo_kapitoly - 1) "/id"];
            nazev_predchozi = FRAGMENTY[(cislo_kapitoly - 1) "/nazev"];
        } else {
            id_predchozi = nazev_predchozi = "";
        }
        if ((cislo_kapitoly + 1) in FRAGMENTY) {
            id_nasledujici = FRAGMENTY[(cislo_kapitoly + 1) "/id"];
            nazev_nasledujici = FRAGMENTY[(cislo_kapitoly + 1) "/nazev"];
        } else {
            id_nasledujici = nazev_nasledujici = "";
        }
        ikona_kapitoly = FRAGMENTY[cislo_kapitoly "/ikkap"];
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
function RidiciRadek(text,   prikaz, i) {
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

        case "ODKAZY DOLE":
            VyzadujeFragmentyTSV();
            if (IDKAPITOLY == "") {ShoditFatalniVyjimku("Chybějící ID kapitoly pro {{ODKAZY DOLE}}!")}
            if (IDFORMATU != "html") {ShoditFatalniVyjimku("{{ODKAZY DOLE}} jsou implementovány pouze pro formát HTML!")}
            prikaz = "seq 1 " FRAGMENTY["pocet"] " | shuf";
            i = 1;
            while (i <= 3 && (prikaz | getline)) {
                if (!($0 in FRAGMENTY)) {ShoditFatalniVyjimku("Chybná iterační hodnota: \"" $0 "\"!")}
                # Aby byla kapitola přijatelná pro odkazy dole...
                # 1. Musí to být jiná kapitola než ta současná
                if (FRAGMENTY[$0 "/id"] == IDKAPITOLY) {continue}
                # 2. Musí to být kapitola
                if (FRAGMENTY[$0 "/adr"] != "kapitoly") {continue}
                # 3. Musí mít štítky
                if (FRAGMENTY[$0 "/stitky"] == "NULL") {continue}
                #
                if (i == 1) {printf("<div class=\"odkazydole\"><div>")}
                printf("<a href=\"%s.htm\"><img src=\"obrazky/%s\" alt=\"\" width=\"32\" height=\"32\">%s</a>", FRAGMENTY[$0 "/id"], FRAGMENTY[$0 "/ikkap"], FRAGMENTY[$0 "/nazev"]);
                ++i;
            }
            if (i != 1) {printf("</div></div>\n")}
            while (prikaz | getline) {}
            close(prikaz);
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
#    gsub(/\{\{JMÉNO VERZE\}\}/, OdzvlastnitKNahrade(JMENOVERZE), radek);
    gsub(/\{\{NÁZEV KAPITOLY\}\}/, nazev_kapitoly, radek);
    gsub(/\{\{PŘEDCHOZÍ ID\}\}/, id_predchozi, radek);
    gsub(/\{\{PŘEDCHOZÍ NÁZEV\}\}/, nazev_predchozi, radek);
    gsub(/\{\{PŘEDCHOZÍ ČÍSLO\}\}/, id_predchozi != "" ? cislo_kapitoly - 1 : 0, radek);
    gsub(/\{\{NÁSLEDUJÍCÍ ID\}\}/, id_nasledujici, radek);
    gsub(/\{\{NÁSLEDUJÍCÍ NÁZEV\}\}/, nazev_nasledujici, radek);
    gsub(/\{\{NÁSLEDUJÍCÍ ČÍSLO\}\}/, id_nasledujici != "" ? cislo_kapitoly + 1 : 0, radek);
    gsub(/\{\{ČÍSLO KAPITOLY\}\}/, cislo_kapitoly, radek);
    gsub(/\{\{OZNAČENÍ VERZE\}\}/, OdzvlastnitKNahrade(ZjistitOznaceniVerze(JMENOVERZE, 1)), radek);
    gsub(/\{\{OZNAČENÍ VERZE S INICIÁLAMI\}\}/, OdzvlastnitKNahrade(ZjistitOznaceniVerze(JMENOVERZE, 1)), radek);
    gsub(/\{\{JMÉNO VERZE\}\}/, OdzvlastnitKNahrade(ZjistitJmenoVerze(JMENOVERZE)), radek);
    gsub(/\{\{PŘEDEVŚIM PRO\}\}/, OdzvlastnitKNahrade(predevsim_pro), radek);
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

function VypsatPrehledStitku(format,   i, n, s, cislo_kapitoly, stitky_kapitol, stitky_kapitoly, ikony_kapitol) {
    if (format != "html") {
        ShoditFatalniVyjimku("Přehled štítků pro formát " format " není podporován!");
    }

    VyzadujeFragmentyTSV();

    # Načíst štítky ze štítky.tsv:
    stitky_tsv = gensub(/fragmenty/, "štítky", 1, FRAGMENTY_TSV);
    while (getline < stitky_tsv) {
        # obrazky/ik-vychozi.png 64x64
        if (NF < 3) {ShoditFatalniVyjimku("Chyba formátu stitky.tsv: očekávány alespoň tři sloupce!")}
        # $1 = štítek $2 = omezené id štítku $3..$NF = id kapitol
        print "<dt id=\"" $2 "\" class=\"stitky\"><span><a href=\"#" $2 "\">" $1 "</a></span></dt><dd>";
        for (i = 3; i <= NF; ++i) {
            if (!("id/" $i in FRAGMENTY)) {ShoditFatalniVyjimku("Nečekané id kapitoly: " $i)}
            cislo_kapitoly = FRAGMENTY["id/" $i];

            print "<div><a href=\"" $i ".htm\"><span class=\"cislo\">" cislo_kapitoly ".</span>\n<img src=\"obrazky/" FRAGMENTY[cislo_kapitoly "/ikkap"] "\" width=\"64\" height=\"64\" alt=\"\">\n<span class=\"nazev\">" FRAGMENTY[cislo_kapitoly "/nazev"] "</span></a><span class=\"dalsistitky\">";
            if (FRAGMENTY[cislo_kapitoly "/stitky"] != "NULL") {
                n = split(gensub(/^\{|\}$/, "", "g", FRAGMENTY[cislo_kapitoly "/stitky"]), stitky_kapitoly, "\\}\\{");
                for (j = 1; j <= n; ++j) {
                    print "<a href=\"#" GenerovatOmezeneId("s", stitky_kapitoly[j]) "\">" stitky_kapitoly[j] "</a>";
                }
            }
            print "</span></div>";
        }
        print "</dd>";
    }
    return close(stitky_tsv);
}

# ============================================================================
@include "skripty/plnění-šablon/hlavní.awk"
