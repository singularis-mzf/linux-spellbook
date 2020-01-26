# Linux Kniha kouzel, skript extrakce/ikony-zaklinadel.awk
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

@include "skripty/utility.awk";

BEGIN {
    OFS = "";
    RS = ORS = "\n";

    # Načíst povolené ikony
    delete povolene_ikony; # [znak] => zkratka písma
    FS = "\t";
    while (getline < "ucs_ikony/povolene-ikony.tsv") {
        if (NF >= 3) {
            povolene_ikony[$2] = $3;
        }
    }

    # Zpracovat navržené ikony
    ikony = "";
    pisma = "";
    FS = "";
    while (getline < "ucs_ikony/ikony.txt") {
        if (NF != 0 && $1 != "#") {
            for (i = 1; i <= NF; ++i) {
                if ($i ~ /\s/) {
                    # přeskočit bílé znaky
                } else if ($i in povolene_ikony) {
                    ikony = ikony $i;
                    pisma = pisma substr(povolene_ikony[$i] "-", 1, 1);
                } else {
                    print "VAROVÁNÍ: Znak \"" $i "\" není v seznamu povolených ikon! Bude přeskočen..." > "/dev/stderr";
                }
            }
        }
    }

    print ikony, "\n", pisma > "soubory_prekladu/ucs_ikony.dat";
    print "Ikony zaklínadel: bylo nastaveno " length(ikony) " ikon (" length(pisma) ")";
}
