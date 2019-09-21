# Linux Kniha kouzel, skript sepsat-fragmenty.awk
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

BEGIN {
    CISLO = 1;
}

/^$/ {
    next;
}

/^#/ {
    next;
}

/[^A-Za-z0-9\-_]/ {
    ShoditFatalniVyjimku("Řádek obsahuje znak, který není povolený v ID kapitoly či dodatku!");
}

{
    ID[CISLO] = $0;
    EXISTUJE_KAPITOLA = !system("test -r kapitoly/" ID[CISLO] ".md");
    EXISTUJE_DODATEK = !system("test -r dodatky/" ID[CISLO] ".md");

    if (ZPRACOVANO[ID[CISLO]]) {
        print "VAROVÁNÍ: ID dodatku či kapitoly \"" $0 "\" se v souboru kapitoly.lst opakuje! Bude použit pouze první výskyt." | "cat >&2";
        next;
    }

    if (EXISTUJE_DODATEK && !EXISTUJE_KAPITOLA) {
        ADRESAR[CISLO] = "dodatky";
    } else if (!EXISTUJE_DODATEK && EXISTUJE_KAPITOLA) {
        ADRESAR[CISLO] = "kapitoly";
    } else if (EXISTUJE_DODATEK) {
        ShoditFatalniVyjimku("ID \"" ID[CISLO] "\" existuje jako dodatek i jako kapitola!");
    } else {
        ShoditFatalniVyjimku("Dodatek ani kapitola " ID[CISLO] ".md neexistuje!");
    }

    NAZEV[CISLO] = "";
    while (getline < (ADRESAR[CISLO] "/" ID[CISLO] ".md")) {
        if ($0 ~ /^# ./) {
            NAZEV[CISLO] = substr($0, 3);
            if (NAZEV[CISLO] ~ /\t/) {
                ShoditFatalniVyjimku("Název v souboru " ADRESAR[CISLO] "/" ID[CISLO] ".md obsahuje tabulátor, což není dovoleno!");
            }
            break;
        }
    }
    if (NAZEV[CISLO] == "") {
        ShoditFatalniVyjimku("Nepodařilo se zjistit název kapitoly či dodatku ze souboru " ADRESAR[CISLO] "/" ID[CISLO] ".md");
    }

    ZPRACOVANO[ID[CISLO]] = 1;

    ++CISLO;
}

END {
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
    for (i = 1; i < CISLO; ++i) {
        print ADRESAR[i] "\t" ID[i] "\t" NAZEV[i] "\t" (i == 1 ? "NULL\tNULL\t" : ID[i - 1] "\t" NAZEV[i - 1] "\t") (i + 1 == CISLO ? "NULL\tNULL\t" : ID[i + 1] "\t" NAZEV[i + 1] "\t") i;
    }
}
