# Linux Kniha kouzel, skript gender/sken.awk
# Copyright (c) 2020 Singularis <singularis@volny.cz>
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

BEGIN {
    FS = "([^[:alnum:]]|<[[:alnum:]]*>|&[[:alnum:]];)+";
    RS = "\n";
    OFS = "\t";
    ORS = "\n";
}

BEGINFILE {
    predchozi = "";
    id = gensub(/.*\/|\.md$/, "", "g", FILENAME);
}

NF > 0 {
    puvodniradek = gensub(/[\t\n]/, " ", "g", $0);
    for (i = 1; i <= NF; ++i) {
        if ($i ~ /[[:alpha:]]/) {
            if ((rod = UrcitRod(predchozi, $i)) != "") {
                print id, FNR, $i, rod, puvodniradek;
            }
            predchozi = $i;
        }
    }
}

function UrcitRod(predchozi, slovo) {
    # Vrací:
    # - "ženský"
    # - "mužský"
    # - "0" (může být obojí)
    # - "?" (nelze rozpoznat)
    # - "" (není tvar slova "řádek" či "řádka")

    slovo = tolower(slovo);
    predchozi = tolower(predchozi);

    #print "LADĚNÍ: Určuji rod pro \"" slovo "\" (předchozí bylo \"" predchozi "\")." > "/dev/stderr";

    switch (slovo) {
        case "řádce":
            return "ženský";
        case "řádcích":
            return "mužský";
        case "řádek":
            # ŘÁDEK
            # ten řádek / vidím ten řádek / bez těch řádek
            return predchozi !~ /^(z|do|třída|pět|šest|sedm|osm|devět|více|počet|čísla)$|(ých|ících|ání)$/ ? "mužský" : "ženský";
        case "řádka":
        case "řádkách":
        case "řádkám":
        case "řádkami":
            return "ženský";
        case "řádkem":
            return "mužský";
        case "řádko":
        case "řádkou":
            return "ženský";
        case "řádku":
            # ŘÁDKU
            # mužský, ledaže „vidím tu řádku“
            if (predchozi ~ /[éí](ho|m)$|ní$|^(jednom|číslo|konec|konce|konci|zbytek|část|rámci|v|prefix|podřetězec|začátek|začátku)$/) {
                return "mužský";
            } else if (predchozi ~ /^(na)$|(číst|ou)$/) {
                return "ženský";
            } else {
                return "?";
            }
        case "řádků":
        case "řádkům":
            return "mužský";
        case "řádky":
            # ŘÁDKY
            # 1/4/5 = ty řádky / vidím ty řádky / ty řádky! = obojetné (0)
            # s těmi řádky = mužský; bez té řádky = ženský
            if (predchozi ~ /^dvěma$|ými$/) {
                return "mužský";
            } else if (predchozi ~ /^(zadání|prefix|z|číslo|příkazové|pozici|konce|dvě|tři|čtyři|konec|zbytek|část|podřetězec|začátek|ukončení)$/) {
                return "ženský";
            } else if (predchozi ~ /^(mít|všechny|má|tvoří|hledat|se|ostatní)$|ící$/) {
                return "0";
            } else {
                return "?";
            }
        default:
            return "";
    }
}
