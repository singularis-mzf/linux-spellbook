# Linux Kniha kouzel, skript plnění-šablon/manuálová-stránka.awk
# Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>
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

# Požadované proměnné: DATUM JAZYK JMENOVERZE
BEGIN {
    p = 1;
}

$0 == "#vše" || $0 == ("#" JAZYK) {
    p = 1;
    next;
}
$0 ~ /^#/ {
    p = 0;
    next;
}

p && /^\.TH/ {
    $0 = ".TH \"LKK\" 1 \"" gensub(/\s/, "\\\\~", "g", DATUM) "\" \"Linux: Kniha kouzel, " JMENOVERZE "\"";
}

p && $0 != ""

$0 ~ /^#/ && $0 !~ /^#(vše|en|cz|0)$/ {
    ShoditFatalniVyjimku("Chybná direktiva: \"" $0 "\"");
}
