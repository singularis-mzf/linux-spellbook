#!/bin/bash
# Linux Kniha kouzel, skript poradi-kapitol.sh
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

# Volání:
# poradi-kapitol.sh předmluva {kapitoly}...

set -e

{
    if test "${PORADI_KAPITOL:-}" != '_VŠE_' -a -n "${PORADI_KAPITOL:-}"
    then
        cat "$PORADI_KAPITOL"
    elif test "${PORADI_KAPITOL:-}" = '_VŠE_' || ! (cat pořadí-kapitol.lst || cat pořadí-kapitol.výchozí.lst || cat poradi-kapitol.lst || cat poradi-kapitol.vychozi.lst)
    then
        printf '%s\n' "$@" | fgrep -x předmluva || true
        printf '%s\n' "$@" | fgrep -vx předmluva | LC_ALL=cs_CZ.UTF-8 sort -f
    fi
} 2>/dev/null | while read -r id
do
    if [[ $id =~ ^[^'# '][^'# ']* ]]
    then
        printf %s\\n "$id"
    elif [[ $id =~ ^[^'#'] ]]
    then
        printf 'Chyba syntaxe: "%s"\n' "$id" >&2
        exit 1
    fi
done
