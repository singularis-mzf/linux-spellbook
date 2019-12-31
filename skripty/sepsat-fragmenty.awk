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
    delete VYSKYTY; # [id] -> 1; slouží ke kontrole duplicity v poradi-kapitol.lst
    delete ID;      # [index] -> id
    delete ADRESAR; # [index] -> dodatky|kapitoly
    delete NAZEV;   # [index] -> název dodatku či kapitoly (ne id)
    delete STITKY;  # [index] -> štítky, nebo ""
}
BEGINFILE {
    INDEX = (ARGIND < 2) ? 0 : ARGIND - 1;
}

# zpracování poradi-kapitol.lst
ARGIND < 2 {
    if ($0 == "" || substr($0, 1, 1) == "#") {
        next;
    }
    if (/[^-_A-Za-z0-9]/) {
        ShoditFatalniVyjimku("Řádek obsahuje znak, který není povolený v ID kapitoly či dodatku! Povoleny jsou pouze znaky [A-Za-z0-9], - a _.");
    }
    if ($0 in VYSKYTY) {
        print "VAROVÁNÍ: ID dodatku či kapitoly \"" $0 "\" se v souboru poradi-kapitol.lst opakuje! Bude použit pouze první výskyt." > "/dev/stderr";
        next;
    }

    VYSKYTY[$0] = 1;
    EXISTUJE_KAPITOLA = !system("test -r kapitoly/" $0 ".md");
    EXISTUJE_DODATEK = !system("test -r dodatky/" $0 ".md");

    ID[++INDEX] = $0;
    if (EXISTUJE_DODATEK && !EXISTUJE_KAPITOLA) {
        ADRESAR[INDEX] = "dodatky";
    } else if (!EXISTUJE_DODATEK && EXISTUJE_KAPITOLA) {
        ADRESAR[INDEX] = "kapitoly";
    } else if (EXISTUJE_DODATEK) {
        ShoditFatalniVyjimku("ID \"" $0 "\" existuje jako dodatek i jako kapitola!");
    } else {
        ShoditFatalniVyjimku("Dodatek ani kapitola " $0 ".md neexistuje!");
    }
    ARGC = INDEX + 2;
    ARGV[INDEX + 1] = ADRESAR[INDEX] "/" $0 ".md";
    NAZEV[INDEX] = "";
    STITKY[INDEX] = "";
    next;
}

# následuje zpracování pro jednotlivé kapitoly a dodatky:
NAZEV[INDEX] == "" && /^# ./ \
{
    if (NAZEV[INDEX] != "") {
        print "VAROVÁNÍ: Soubor " FILENAME " obsahuje víc nadpisů první úrovně. Pouze první bude použit jako název!" > "/dev/stderr";
        next;
    }
    NAZEV[INDEX] = substr($0, 3);
    if (NAZEV[INDEX] ~ /\t/) {
        ShoditFatalniVyjimku("Název v souboru " FILENAME " obsahuje tabulátor, což není dovoleno!");
    }
}

ADRESAR[INDEX] == "kapitoly" && match(toupper($0), /^!ŠTÍTKY:( |$)/) {
    s = substr($0, 1 + RLENGTH);
    if (s !~ /^({[A-Za-z0-9ÁČĎÉĚÍŇÓŘŠŤŮÝŽáčďéěíňóřšťůýž ]+})*$/) {
        ShoditFatalniVyjimku("Chybný formát štítků v " FILENAME ": " $0);
    }
    prikaz = "tr -d \\\\n | tr \\} \\\\n | LC_ALL=\"cs_CZ.UTF-8\" sort -iu | tr \\\\n \\}";
    print s |& prikaz;
    close(prikaz, "to");
    prikaz |& getline s;
    close(prikaz);
    STITKY[INDEX] = STITKY[INDEX] s;
}

ENDFILE {
    if (ARGIND >= 2) {
        if (NAZEV[INDEX] == "") {
            ShoditFatalniVyjimku("Nepodařilo se zjistit název kapitoly či dodatku ze souboru " FILENAME "!");
        }
        if (!(STITKY[INDEX] ~ /^({[^{}]+})*$/)) {
            ShoditFatalniVyjimku("Chybné uzávorkování štítků ve " FILENAME ": " STITKY[INDEX]);
        }
    }
}

END {
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
    OFS = "\t";
    ORS = "\n";
# 1=Adresář|2=ID|3=Název|4=Předchozí ID|5=Předchozí název|6=Následující ID|7=Následující název
# 8=Číslo dodatku/kapitoly|9=Štítky v {}
#
# Prázdná hodnota se nahrazuje „NULL“.
    for (i = 1; i < ARGC - 1; ++i) {
        print ADRESAR[i], ID[i], NAZEV[i], \
            i == 1 ? "NULL\tNULL" : ID[i - 1] "\t" NAZEV[i - 1], \
            i + 1 == ARGC - 1 ? "NULL\tNULL" : ID[i + 1] "\t" NAZEV[i + 1], \
            i, \
            STITKY[i] == "" ? "NULL" : STITKY[i];
    }
}
