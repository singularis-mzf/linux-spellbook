#!/bin/bash
# Linux Kniha kouzel, skript přečíst-konfig.sh
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

# Volání:
# přečíst-konfig.sh {sekce} {klíč} [výchozí-hodnota] <

set -e

VYCHOZI=""
if test $# -eq 3
then
    VYCHOZI="$3"
elif test $# -ne 2
then
    echo -e "Chybný počet parametrů\! Správné volání:\\n$0 {sekce} {klíč} [výchozí-hodnota] < {konfigurační-soubor}" >&2
    exit 1
fi

export SEKCE="$1"
export KLIC="$2"
export VYCHOZI
VYSLEDEK=$(gawk -f "skripty/přečíst-konfig.awk"; printf x)
printf 'přečíst_konfig:[%s][%s][%s] = "%s"\n' "$SEKCE" "$KLIC" "$VYCHOZI" "$VYSLEDEK" >>"$SOUBORY_PREKLADU/přečíst_konfig.log"
printf %s\\n "${VYSLEDEK%x}"
