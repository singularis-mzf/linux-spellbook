# Linux Kniha kouzel, skript css.awk
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
    VyzadujePromennou("MOTIV");
}

# VEŘEJNÉ FUNKCE
# ============================================================================

# Zacatek()
#       – Je volaná před začátkem zpracování (v místě řádku „{{ZAČÁTEK}}“).
#       – Jejím úkolem je inicializace.
#
function Zacatek() {
    delete MAKRA;
    MAKRA["MOTIV"] = MOTIV;
    return 0;
}

function Pokud(podminka) {
    if (podminka ~ /^JE MOTIV ./) {
        return MOTIV == substr(podminka, 10);
    }
    ShoditFatalniVyjimku("Neznámá direktiva {{POKUD " podminka "}}!");
}

# RidiciRadek()
#       – Obsluhuje obecné řídicí řádky, např. „{{XYZ}}“.
#       – Neobsluhuje {{ZAČÁTEK}}, {{KONEC}}, {{POKUD *}}, {{KONEC POKUD}}, {{VARIANTA *}}, {{VARIANTY *}}.
#       – Na návratové hodnotě nezáleží.
#
function RidiciRadek(text,   pozice) {
    if (text ~ /^MAKRO [^}= \t]+[ \t]*=/) {
        match(text, /[ \t]*=[ \t]*/);
        MAKRA[substr(text, 7, RSTART - 7)] = substr(text, RSTART + RLENGTH);
        #print "LADĚNÍ: Definuji makro: <" substr(text, 7, RSTART - 7) "> = <" substr(text, RSTART + RLENGTH) ">" > "/dev/stderr";
        return 0;
    } else {
        print PrelozitVystup(text);
        return 0;
    }
}

# PrelozitVystup()
#       – Má za úkol zpracovat obyčejný řádek, než bude vypsát na výstup.
#       – Typicky nahrazuje výskyty speciálních značek.
#
function PrelozitVystup(radek,   makro, i) {
    if (radek ~ /^#( |#|$)/) {return ""}

    i = 0;
    /\{/; # prázdný příkaz kvůli zvýrazňování syntaxe
    while (match(radek, /\{\{[^}=]+\}\}/)) {
        makro = substr(radek, RSTART + 2, RLENGTH - 4);
        if (makro in MAKRA) {
            radek = substr(radek, 1, RSTART - 1) MAKRA[makro] substr(radek, RSTART + RLENGTH);
        } else {
            ShoditFatalniVyjimku("Neznámé makro: <" substr(radek, RSTART, RLENGTH) ">");
        }
        if (++i > 2048) {
            ShoditFatalniVyjimku("Limit překročen. Pravděpodobné zacyklení rozvoje makra " makro);
        }
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

# ============================================================================
@include "skripty/plneni-sablon/hlavni.awk"
