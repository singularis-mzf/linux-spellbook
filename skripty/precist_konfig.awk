# Linux Kniha kouzel, skript precist_konfig.awk
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

# Parametry:
# [volitelný] SEKCE - požadovaná sekce konfiguračního souboru
#             KLIC  - klíč k přečtení
# [volitelný] VYCHOZI - hodnota k vrácení v případě, že klíč nebyl nalezen

@include "skripty/utility.awk"

BEGIN {
    if (ENVIRON["KLIC"] == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná prostředí KLIC není nastavena!");
    }

    AKTUALNI_SEKCE = "Výchozí";

    SEKCE =  "SEKCE" in ENVIRON && ENVIRON["SEKCE"] != "" ? ENVIRON["SEKCE"] : AKTUALNI_SEKCE;
    KLIC = ENVIRON["KLIC"];
    VYSLEDEK = "VYCHOZI" in ENVIRON ? ENVIRON["VYCHOZI"] : "";
}

/^\[.+]$/ {
    AKTUALNI_SEKCE = substr($0, 2, length($0) - 2);
}

/^[^=#][^=]*=/ {
    AKTUALNI_KLIC = substr($0, 1, index($0, "=") - 1);
    if (AKTUALNI_SEKCE == SEKCE && AKTUALNI_KLIC == KLIC) {
        VYSLEDEK = substr($0, index($0, "=") + 1);
        exit;
    }
}

{}

END {
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    } else {
        printf("%s", VYSLEDEK);
    }
}
