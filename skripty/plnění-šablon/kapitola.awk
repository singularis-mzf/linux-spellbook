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
    JMENOVERZE = ENVIRON["JMENO"];
    DATUMSESTAVENI = ENVIRON["DATUM_SESTAVENI"];
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

    if (IDKAPITOLY ~ /^_(autori|stitky)$/) {
        id_predchozi = id_nasledujici = nazev_predchozi = nazev_nasledujici = "";
        symbol_predchozi = symbol_nasledujici = "NULL";
        cislo_kapitoly = 0;
        ikona_kapitoly = "ik-výchozí.png";
    } else if ((cislo_kapitoly = FragInfo(IDKAPITOLY "?")) != 0 && FragInfo(cislo_kapitoly, "příznaky") ~ /z/) {
        adresar = FragInfo(cislo_kapitoly, "adresář");
        nazev_kapitoly = FragInfo(cislo_kapitoly, "celý-název");
        symbol_kapitoly = FragInfo(cislo_kapitoly, "symbol");
        if (cislo_kapitoly != 1) {
            id_predchozi = FragInfo(cislo_kapitoly - 1, "plné-id");
            id_predchozi_bez_diakr = FragInfo(cislo_kapitoly - 1, "ploché-id-bez-diakr");
            nazev_predchozi = FragInfo(cislo_kapitoly - 1, "celý-název");
            symbol_predchozi = FragInfo(cislo_kapitoly - 1, "symbol");
        } else {
            id_predchozi = id_predchozi_bez_diakr = nazev_predchozi = "";
        }
        if (FragInfo(cislo_kapitoly + 1, "existuje")) {
            id_nasledujici = FragInfo(cislo_kapitoly + 1, "plné-id");
            id_nasledujici_bez_diakr = FragInfo(cislo_kapitoly + 1, "ploché-id-bez-diakr");
            nazev_nasledujici = FragInfo(cislo_kapitoly + 1, "celý-název");
            symbol_nasledujici = FragInfo(cislo_kapitoly + 1, "symbol");
        } else {
            id_nasledujici = id_nasledujici_bez_diakr = nazev_nasledujici = "";
        }
        ikona_kapitoly = FragInfo(cislo_kapitoly, "ikona-kapitoly");
    } else {
        # kapitola, která není určena na výstup:
        adresar = FragInfo(FragInfo(IDKAPITOLY), "adresář");
        nazev_kapitoly = "(Není na výstup)";
        id_predchozi = id_predchozi_bez_diakr = id_nasledujici = id_nasledujici_bez_diakr = nazev_predchozi = nazev_nasledujici = "";
        ikona_kapitoly = "ik-výchozí.png";
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
        case "MÁ PODKAPITOLY":
            i = FragInfo(IDKAPITOLY "?");
            return i != 0 && FragInfo(i, "příznaky") ~ /N/;
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
            prikaz = "seq 1 " FragInfo("", "počet") " | shuf";
            i = 1;
            while (i <= 3 && (prikaz | getline)) {
                if (!FragInfo($0, "existuje")) {ShoditFatalniVyjimku("Chybná iterační hodnota: \"" $0 "\"!")}
                # Aby byla kapitola přijatelná pro odkazy dole...
                # 1. Musí to být jiná kapitola než ta současná
                if (FragInfo($0, "plné-id") == IDKAPITOLY) {continue}
                # 2. Musí to být kapitola
                if (FragInfo($0, "adresář") != "kapitoly") {continue}
                # 3. Musí mít štítky
                if (FragInfo($0, "štítky") == "") {continue}
                #
                if (i == 1) {printf("<div class=\"odkazydole\"><div>")}
                printf("<a href=\"%s.htm\"><img src=\"obrazky/%s\" alt=\"\" width=\"32\" height=\"32\">%s</a>", FragInfo($0, "ploché-id-bez-diakr"), OmezitNazev(FragInfo($0, "ikona-kapitoly"), 1), FragInfo($0, "celý-název"));
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
function PrelozitVystup(radek,   i, vysl) {
#    gsub(/\{\{JMÉNO VERZE\}\}/, OdzvlastnitKNahrade(JMENOVERZE), radek);
    gsub(/\{\{NÁZEV KAPITOLY\}\}/, nazev_kapitoly, radek);
    if (radek ~ /\{\{NÁZEV KAPITOLY HTML EXTRA\}\}/) {
        gsub(/\{\{NÁZEV KAPITOLY HTML EXTRA\}\}/, ZiskatNazevKapitolyHtmlExtra(IDKAPITOLY), radek);
    }
    gsub(/\{\{PŘEDCHOZÍ ID\}\}/, id_predchozi, radek);
    gsub(/\{\{PŘEDCHOZÍ ID BEZ DIAKRITIKY\}\}/, id_predchozi_bez_diakr, radek);
    gsub(/\{\{PŘEDCHOZÍ NÁZEV\}\}/, nazev_predchozi, radek);
    gsub(/\{\{PŘEDCHOZÍ ČÍSLO\}\}/, id_predchozi != "" ? symbol_predchozi : 0, radek);
    gsub(/\{\{NÁSLEDUJÍCÍ ID\}\}/, id_nasledujici, radek);
    gsub(/\{\{NÁSLEDUJÍCÍ ID BEZ DIAKRITIKY\}\}/, id_nasledujici_bez_diakr, radek);
    gsub(/\{\{NÁSLEDUJÍCÍ NÁZEV\}\}/, nazev_nasledujici, radek);
    gsub(/\{\{NÁSLEDUJÍCÍ ČÍSLO\}\}/, id_nasledujici != "" ? symbol_nasledujici : 0, radek);
    gsub(/\{\{ČÍSLO KAPITOLY\}\}/, symbol_kapitoly, radek);
    gsub(/\{\{OZNAČENÍ VERZE\}\}/, OdzvlastnitKNahrade(ZjistitOznaceniVerze(JMENOVERZE, 1)), radek);
    gsub(/\{\{OZNAČENÍ VERZE S INICIÁLAMI\}\}/, OdzvlastnitKNahrade(ZjistitOznaceniVerze(JMENOVERZE, 1)), radek);
    gsub(/\{\{JMÉNO VERZE\}\}/, OdzvlastnitKNahrade(ZjistitJmenoVerze(JMENOVERZE)), radek);
    gsub(/\{\{PŘEDEVŚIM PRO\}\}/, OdzvlastnitKNahrade(predevsim_pro), radek);
    gsub(/\{\{DATUMSESTAVENÍ\}\}/, DATUMSESTAVENI, radek);
    gsub(/\{\{DATUM SESTAVENÍ\}\}/, datum, radek);
    gsub(/\{\{IKONA KAPITOLY\}\}/, ikona_kapitoly, radek);
    gsub(/\{\{IKONA KAPITOLY BEZ DIAKRITIKY\}\}/, OmezitNazev(ikona_kapitoly, 1), radek);
    if (radek ~ /\{\{REKLAMNÍ PATA\}\}/) {
        #print "XYZ" > "/dev/stderr";
        VyzadujeFragmentyTSV();
        VyzadujePromennou("IDFORMATU", "{{REKLAMNÍ PATA}} je podporována jen ve formátech HTML a LOG!");
        if (IDFORMATU != "html") {ShoditFatalniVyjimku("{{REKLAMNÍ PATA}} je podporována jen ve formátech HTML a LOG!")}
        gsub(/\{\{REKLAMNÍ PATA\}\}/, REKLAMNI_PATA, radek);
    }
    if (radek ~ /\{\{ODKAZY NA PODKAPITOLY\}\}/) {
        VyzadujeFragmentyTSV();
        if (IDKAPITOLY == "") {ShoditFatalniVyjimku("Chybějící ID kapitoly pro {{ODKAZY NA PODKAPITOLY}}!")}
        if (IDFORMATU != "html") {ShoditFatalniVyjimku("{{ODKAZY NA PODKAPITOLY}} jsou implementovány pouze pro formát HTML!")}
        vysl = "";
        for (i = 1; FragInfo(i, "existuje"); ++i) {
            if (FragInfo(i, "id-nadkapitoly") == IDKAPITOLY) {
                vysl = sprintf("%s<a href=\"%s.htm\">%s %s</a>;\n", vysl, \
                    FragInfo(i, "ploché-id-bez-diakr"), FragInfo(i, "symbol"), FragInfo(i, "název-podkapitoly"));
            }
        }
        gsub(/\{\{ODKAZY NA PODKAPITOLY\}\}/, vysl, radek);
    }

    /^{/; # prázdný příkaz kvůli zvýrazňování syntaxe
    if (match(radek, /\{\{[^}]+\}\}/)) {
        ShoditFatalniVyjimku("Neznámé makro: " substr(radek, RSTART, RLENGTH) "\n<" radek ">");
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

function ZiskatNazevKapitolyHtmlExtra(plneId,   cisloKapitoly, cisloNadkapitoly)
{
    cisloKapitoly = FragInfo(plneId);
    if (plneId ~ /\// && (cisloNadkapitoly = FragInfo(cisloKapitoly, "číslo-nadkapitoly")) > 0) {
        return "<a href=\"" FragInfo(cisloNadkapitoly, "ploché-id-bez-diakr") ".htm\">"FragInfo(cisloNadkapitoly, "celý-název") "</a> / " FragInfo(cisloKapitoly, "název-podkapitoly");
    }
    return FragInfo(FragInfo(plneId), "celý-název");
}

function VypsatPrehledStitku(format,   i, n, s, cislo_kapitoly, symbol_kapitoly, stitky_kapitol, stitky_kapitoly, ikony_kapitol, stitek_na_xhes) {
    if (format != "html") {
        ShoditFatalniVyjimku("Přehled štítků pro formát " format " není podporován!");
    }

    VyzadujeFragmentyTSV();

    # Načíst štítky ze štítky.tsv:
    stitky_tsv = gensub(/fragmenty/, "štítky", 1, FRAGMENTY_TSV);
    delete stitek_na_xhes;
    while (getline < stitky_tsv) {
        if (NF < 3) {ShoditFatalniVyjimku("Chyba formátu štítky.tsv: očekávány alespoň tři sloupce!")}
        stitek_na_xhes[$1] = $2;
    }
    close(stitky_tsv);
    while (getline < stitky_tsv) {
        # $1 = štítek (text) $2 = xheš štítku $3..$NF = plná id kapitol
        print "<dt id=\"" $2 "\" class=\"stitky\"><span><a href=\"#" $2 "\">" $1 "</a></span></dt><dd>";
        for (i = 3; i <= NF; ++i) {
            cislo_kapitoly = FragInfo($i "?");
            if (cislo_kapitoly == 0) {ShoditFatalniVyjimku("Nečekané id kapitoly: " $i)}
            symbol_kapitoly = FragInfo(cislo_kapitoly, "symbol");
            idkap = FragInfo(cislo_kapitoly, "ploché-id-bez-diakr");

            print "<div><a href=\"" idkap ".htm\"><span class=\"cislo\">" symbol_kapitoly "</span>\n<img src=\"obrazky/" OmezitNazev(FragInfo(cislo_kapitoly, "ikona-kapitoly"), 1) "\" width=\"64\" height=\"64\" alt=\"\">\n<span class=\"nazev\">" FragInfo(cislo_kapitoly, "celý-název") "</span></a><span class=\"dalsistitky\">";
            if (FragInfo(cislo_kapitoly, "štítky") != "") {
                n = split(gensub(/^\{|\}$/, "", "g", FragInfo(cislo_kapitoly, "štítky")), stitky_kapitoly, "\\}\\{");
                for (j = 1; j <= n; ++j) {
                    print "<a href=\"#" stitek_na_xhes[stitky_kapitoly[j]] "\">" stitky_kapitoly[j] "</a>";
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
