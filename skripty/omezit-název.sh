#!/bin/bash
# Linux Kniha kouzel, skript omezit-název.sh
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

set -e

#printf 'O(%s)' "$@" >&2

if test $# -eq 0
then
    cat
else
    printf %s\\n "$@"
fi | sed -E 's/.*/\L&/;s!.*/!!;'"$(printf 's/%s/%s/g;' á a č c ď d '[éě]' e í i ň n ó o ř r š s ť t '[úů]' u ý y ž z)"'s/[-_]+/-/g;s/^-|-$//g'
# Postup:
#   1. Převést na malá písmena.
#   2. Obsahuje-li řetězec /, odstranit vše až po poslední výskyt „/“ včetně.
#   3. Odstranit diakritiku.
#   4. Sekvence znaků „-“ a „_“ nahradit jednou pomlčkou.
#   5. Případnou pomlčku na začátku nebo na konci řetězce vypustit.

