#!/bin/bash
# Linux Kniha kouzel, skript dynamicky.sh
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

# Použití:
#   skripty/dynamicky.sh [-o] {*předpona-zdroje*} {*předpona-cíle*} [{*parametr*}]...
#
# -o: Při konstrukci cíle na každý parametr aplikuje skript „skript/omezit-název.sh“.
#     (Ve zdroji zůstane parametr nezměněn.)
#
# Vygeneruje pravidla do dynamického Makefile ve tvaru:
#   {*předpona-cíle*}{*parametr*}: {*předpona-zdroje*}{*parametr*}
#   <TAB>@{*zkopírovat zdroj do cíle; pokud zdroj neexistuje, odstranit cíl*}
#
set -e
unset omezit

test -v SOUBORY_PREKLADU || {
    printf 'Vyžadovaná proměnná SOUBORY_PREKLADU není definována!\n' >&2
    exit 1
}
#printf 'LADĚNÍ: %s parametrů.\n' "$#" >&2
if test "$1" = "-o"
then
    omezit=1
    shift
fi
test $# -ge 2 || {
    printf 'Parametry „předpona“ a „náhrada“ jsou vyžadovány!\n' >&2
    exit 1
}
pzdroje=$1 pcile=$2
shift; shift
exec >>"${SOUBORY_PREKLADU}/dynamický-Makefile"
for param in "$@"
do
    zdroj="${pzdroje}${param}"
    if test -v omezit
    then
        cil="${pcile}$(skripty/omezit-název.sh "$param")"
    else
        cil="${pcile}${param}"
    fi
    printf '%s: %s\n\t@if test -e $<; then mkdir -pv $(dir $@); cp -vfL $< $@; else rm -Rf $@; fi\n' "$cil" "$zdroj"
done
