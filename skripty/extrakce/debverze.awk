# Linux Kniha kouzel, skript extrakce/debverze.awk
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
    if (ARGC != 2) {
        print "debverze.awk: Chybný počet parametrů (" ARGC ")!" > "/dev/stderr";
    }
    s = gensub(/[,\n].*/, "", 1, ARGV[1]);
    s = gensub(/^[^0-9.]*([0-9]+(\.[0-9]+)*).*$/, "\\1", 1, s);
    if (s == "") {s = "0"}
    if (tolower($1) ~ /sid/) {s = "0." s}
    if (tolower($1) ~ /beta/) {s = s "~beta"}
    print s;
}
