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

    neslova["d"] = 1;
    neslova["gt"] = 1;
    neslova["lt"] = 1;
    neslova["n"] = 1;
}

BEGINFILE {
    predchozi = "";
    id = gensub(/.*\/|\.md$/, "", "g", FILENAME);
}

NF > 0 {
    puvodniradek = gensub(/[\t\n]/, " ", "g", $0);
    for (i = 1; i <= NF; ++i) {
        if ($i ~ /[[:alpha:]]/ && !($i in neslova)) {
            if ((rod = UrcitRod(predchozi, $i)) != "") {
                print id, FNR, tolower("(" predchozi ")" $i), rod, puvodniradek;
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
            # aktuální řádek / odsazení řádek
            if (predchozi ~ /^(n)$|(í)$/) {
                if (predchozi ~ /^(aktuální|první|následující)$|(ání)$/) {return "mužský"}
                if (predchozi ~ /^(odsazení)$/) {return "ženský"}
                return "?";
            }
            # ten řádek / vidím ten řádek / bez těch řádek
            return predchozi ~ /^(z|do|třída|pět|šest|sedm|osm|devět|více|počet|čísla|rozsah)$|(ých|ících)$/ ? "ženský" : "mužský";
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
            # mužský, ledaže „vidím tu řádku“ nebo „aktuální/předchozí řádku“
            if (predchozi ~ /[éí](ho|m)$|^(jednom|číslo|konec|konce|konci|zbytek|část|rámci|v|prefix|podřetězec|začátek|začátku)$/) {
                return "mužský";
            } else if (predchozi ~ /(číst|jednu|ou|ní|zí)$/) {
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
            if (predchozi ~ /^(dvěma|nad)$|ými$/) {
                return "mužský";
            } else if (predchozi ~ /^(zadání|prefix|z|číslo|čísla|číslem|znak|příkazové|pozici|konce|dvě|tři|čtyři|konec|koncem|zbytek|část|podřetězec|začátek|začátkem|ukončení|této|rámci|obsah|první|druhé|třetí|čtvrté|páté|řádky)$|(ím|ení)$/) {
                return "ženský";
            } else if (predchozi ~ /^(mít|všechny|má|tvoří|hledat|se|ostatní|znak|join|chomp|print|my|alength)$|ící$/) {
                return "0";
            } else {
                return "?";
            }
        default:
            return "";
    }
}
