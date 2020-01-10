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
}

# VEŘEJNÉ FUNKCE
# ============================================================================

# Zacatek()
#       − Je volaná před začátkem zpracování (v místě řádku „{{ZAČÁTEK}}“).
#       − Jejím úkolem je inicializace.
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
    } else if (IDKAPITOLY == "_autori") {
        id_predchozi = id_nasledujici = nazev_predchozi = nazev_nasledujici = "";
        cislo_kapitoly = 0;
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
    }

    predevsim_pro = ZjistitPredevsimPro(JMENOVERZE);
    return 0;
}

function Pokud(podminka) {
    if (podminka ~ /^JE FORMÁT ./) {
        return IDFORMATU == substr(podminka, 11);
    }
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
    }
    ShoditFatalniVyjimku("Neznámá direktiva {{POKUD " podminka "}}!");
}

# RidiciRadek()
#       − Obsluhuje obecné řídicí řádky, např. „{{XYZ}}“.
#       − Neobsluhuje {{ZAČÁTEK}}, {{KONEC}}, {{POKUD *}}, {{KONEC POKUD}}, {{VARIANTA *}}, {{VARIANTY *}}.
#       − Na návratové hodnotě nezáleží.
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

        default:
            ShoditFatalniVyjimku("Neznámý řídicí řádek: {{" text "}}!");
    }
}

# PrelozitVystup()
#       − Má za úkol zpracovat obyčejný řádek, než bude vypsát na výstup.
#       − Typicky nahrazuje výskyty speciálních značek.
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
    gsub(/\{\{JMÉNO VERZE\}\}/, EscapovatKNahrade(JMENOVERZE), radek);
    gsub(/\{\{PŘEDEVŚIM PRO\}\}/, EscapovatKNahrade(predevsim_pro), radek);
    gsub(/\{\{DATUMSESTAVENÍ\}\}/, DATUMSESTAVENI, radek);
    gsub(/\{\{DATUM SESTAVENÍ\}\}/, datum, radek);

    return radek;
}

# Konec()
#       − Je volaná na konci zpracování, nenastala-li fatální výjimka.
#
function Konec() {
    return 0;
}
# ============================================================================

# Soukromé funkce a proměnné:
# ============================================================================




# ============================================================================
@include "skripty/plneni-sablon/hlavni.awk"
