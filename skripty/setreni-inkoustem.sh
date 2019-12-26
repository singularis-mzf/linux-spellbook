#!/bin/bash -e
# Linux Kniha kouzel, skript setreni-inkoustem.sh
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

# Volání:
# setreni-inkoustem.sh {vstupní-obrázek} {cílový-obrázek}

VYCHOZI=""
if test $# -ne 2
then
    echo -e "Chybný počet parametrů\! Správné volání:\\n$0 {vstupní-obrázek} {cílový-obrázek}" >&2
    exit 1
fi

HODNOTA="$(convert "$1" -resize 1x1\! -alpha off -colorspace Gray txt: | egrep -i -m 1 -o 'gray\([0-9]+\)' | egrep -o '[0-9]+')"
if test "$HODNOTA" -lt 128
then
    convert "$1" -colorspace Gray -negate "$2"
else
    convert "$1" -colorspace Gray "$2"
fi
