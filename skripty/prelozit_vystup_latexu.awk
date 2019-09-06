# Linux Kniha kouzel, skript prelozit_vystup_latexu.awk
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

# Smyslem tohoto skriptu je zestručnit vybraná varování vypisovaná LaTeXem.

@include "skripty/utility.awk"

BEGIN {
    split("", fronta);
}

{
    if (length(fronta) == 0 && $0 == "") {
        fronta[1] = $0;

    } else if (length(fronta) == 1 && $0 ~ /^LaTeX Font Warning: Font shape `T1\/bsk\/(m|bx)\/(n|it|sl)' undefined$/) {
        fronta[2] = $0;

    } else if (length(fronta) == 2 && $0 ~ /^\(Font\)              using `T1\/[a-z]+\/[a-z]+\/n' instead on input line [0-9]+\.$/) {
        fronta[3] = $0;

    } else if (length(fronta) == 3 && $0 == "") {
        puvodni = fronta[2];
        match(puvodni, /`.+'/);
        puvodni = substr(puvodni, RSTART + 1, RLENGTH - 2);
        novy = fronta[3];
        match(novy, /[0-9]+\.$/);
        cislo = substr(novy, RSTART, RLENGTH - 1);
        match(novy, /`.+'/);
        novy = substr(novy , RSTART + 1, RLENGTH - 2);

        print cislo ": '" puvodni "' => '" novy "'";

        delete fronta;

    } else {
        if (length(fronta) != 0) {
            for (i = 1; i <= length(fronta); ++i) {
                print fronta[i];
            }
            delete fronta;
        }
        print $0;
    }
}

END {
    # Končíme-li s fatální výjimkou, skončit hned.
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
}
