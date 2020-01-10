# Linux Kniha kouzel, skript extrakce/fragmenty.awk
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
    delete vyskyty; # [id] -> 1; slouží ke kontrole duplicity v poradi-kapitol.lst
    delete id;      # [index] -> id
    delete adresar; # [index] -> dodatky|kapitoly
    delete nazev;   # [index] -> název dodatku či kapitoly (ne id)
    delete stitky;  # [index] -> štítky, nebo ""
}
BEGINFILE {
    ind = (ARGIND < 2) ? 0 : ARGIND - 1;
}

# zpracování poradi-kapitol.lst
ARGIND < 2 {
    if ($0 == "" || substr($0, 1, 1) == "#") {
        next;
    }
    if (/[^-_A-Za-z0-9]/) {
        ShoditFatalniVyjimku("Řádek obsahuje znak, který není povolený v ID kapitoly či dodatku! Povoleny jsou pouze znaky [A-Za-z0-9], - a _.");
    }
    if ($0 in vyskyty) {
        print "VAROVÁNÍ: ID dodatku či kapitoly \"" $0 "\" se v souboru poradi-kapitol.lst opakuje! Bude použit pouze první výskyt." > "/dev/stderr";
        next;
    }

    vyskyty[$0] = 1;
    existuje_kapitola = Test("-r kapitoly/" $0 ".md");
    existuje_dodatek = Test("-r dodatky/" $0 ".md");

    id[++ind] = $0;
    if (existuje_dodatek && !existuje_kapitola) {
        adresar[ind] = "dodatky";
    } else if (!existuje_dodatek && existuje_kapitola) {
        adresar[ind] = "kapitoly";
    } else if (existuje_dodatek) {
        ShoditFatalniVyjimku("ID \"" $0 "\" existuje jako dodatek i jako kapitola!");
    } else {
        ShoditFatalniVyjimku("Dodatek ani kapitola " $0 ".md neexistuje!");
    }
    ARGC = ind + 2;
    ARGV[ind + 1] = adresar[ind] "/" $0 ".md";
    nazev[ind] = "";
    stitky[ind] = "";
    next;
}

# následuje zpracování pro jednotlivé kapitoly a dodatky:
nazev[ind] == "" && /^# ./ \
{
    if (nazev[ind] != "") {
        print "VAROVÁNÍ: Soubor " FILENAME " obsahuje víc nadpisů první úrovně. Pouze první bude použit jako název!" > "/dev/stderr";
        next;
    }
    nazev[ind] = substr($0, 3);
    if (nazev[ind] ~ /\t/) {
        ShoditFatalniVyjimku("Název v souboru " FILENAME " obsahuje tabulátor, což není dovoleno!");
    }
}

adresar[ind] == "kapitoly" && match(toupper($0), /^!ŠTÍTKY:( |$)/) {
    s = substr($0, 1 + RLENGTH);
    if (s !~ /^({[A-Za-z0-9ÁČĎÉĚÍŇÓŘŠŤŮÝŽáčďéěíňóřšťůýž ]+})*$/) {
        ShoditFatalniVyjimku("Chybný formát štítků v " FILENAME ": " $0);
    }
    prikaz = "tr -d \\\\n | tr \\} \\\\n | LC_ALL=\"cs_CZ.UTF-8\" sort -iu | tr \\\\n \\}";
    print s |& prikaz;
    close(prikaz, "to");
    prikaz |& getline s;
    close(prikaz);
    stitky[ind] = stitky[ind] s;
}

ENDFILE {
    if (ARGIND >= 2) {
        if (nazev[ind] == "") {
            ShoditFatalniVyjimku("Nepodařilo se zjistit název kapitoly či dodatku ze souboru " FILENAME "!");
        }
        if (!(stitky[ind] ~ /^({[^{}]+})*$/)) {
            ShoditFatalniVyjimku("Chybné uzávorkování štítků ve " FILENAME ": " stitky[ind]);
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
        print adresar[i], id[i], nazev[i], \
            i == 1 ? "NULL\tNULL" : id[i - 1] "\t" nazev[i - 1], \
            i + 1 == ARGC - 1 ? "NULL\tNULL" : id[i + 1] "\t" nazev[i + 1], \
            i, \
            stitky[i] == "" ? "NULL" : stitky[i];
    }
}
