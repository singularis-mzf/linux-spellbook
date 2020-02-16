# Linux Kniha kouzel, skript gender/report.awk
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
    FS = "\t";
    RS = "\n";
    OFS = ",";
    ORS = "\n";
}

# $1 = id
# $2 = číslo řádku
# $3 = slovo
# $4 = rod ("0", "ženský", "mužský" nebo "?")
# $5 = původní řádek

{
    e[$1][$4] += 1;
}

END {
    print "id", "oboj.", "ženské", "mužské", "rozdíl", "nerozpoznané";
    n = asorti(e, x, "@ind_str_asc");
    for (i = 1; i <= n; ++i) {
        id = x[i];
        print id, int(e[id]["0"]), int(e[id]["ženský"]), int(e[id]["mužský"]), int(e[id]["ženský"]) - int(e[id]["mužský"]), int(e[id]["?"]);
    }
}
