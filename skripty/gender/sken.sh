#!/bin/bash -e
# Linux Kniha kouzel, skript sken.sh
# Copyright (c) 2020, 2021 Singularis <singularis@volny.cz>
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

shopt -s nullglob
mkdir -pv "${SOUBORY_PREKLADU:=soubory_překladu}"
(
	if test $# -eq 0
	then
		find dodatky kapitoly -mindepth 1 -maxdepth 2 -type f -name '*.md' -print0
	else
		for x in "$@"
		do
			if test -f "kapitoly/$x.md"
			then
				printf 'kapitoly/%s.md\0' "$x"
			elif test -f "dodatky/$x.md"
			then
				printf 'dodatky/%s.md\0' "$x"
			fi
		done
	fi
) | xargs -r0 gawk -f skripty/gender/sken.awk > "${SOUBORY_PREKLADU}/sken-genderu.tsv"
#gawk -f skripty/gender/sken.awk dodatky/*.md kapitoly/*.md > "${SOUBORY_PREKLADU}/sken-genderu.tsv"
gawk -f skripty/gender/report.awk "${SOUBORY_PREKLADU}/sken-genderu.tsv" > "${SOUBORY_PREKLADU}/report-genderu.csv"
gawk 'BEGIN {FS=","; OFS="\t";} {print substr($1 "                                       ", 1, 32), $2, $3, $4, $5, $6}' "${SOUBORY_PREKLADU}/report-genderu.csv"
