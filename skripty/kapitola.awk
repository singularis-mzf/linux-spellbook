# Linux Kniha kouzel, skript kapitola.awk
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

@include "skripty/utility.awk"

BEGIN {
    if (ENVIRON["IDKAPITOLY"] == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná IDKAPITOLY není nastavena!");
    }
    if (ENVIRON["NAZEVKAPITOLY"] == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná NAZEVKAPITOLY není nastavena!");
    }
    if (ENVIRON["TELOKAPITOLY"] == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná TELOKAPITOLY není nastavena!");
    }
}

{
    JE_RIDICI_RADEK = $0 ~ /^\{\{[^{}]+\}\}$/;
    VYTISKNOUT = 0;
}

/^\{\{ZAČÁTEK KAPITOLY\}\}$/,/^\{\{KONEC KAPITOLY\}\}$/ {
    VYTISKNOUT =  !JE_RIDICI_RADEK;
    if ($0 == "{{TĚLO KAPITOLY}}") {
        system("cat '" ENVIRON["TELOKAPITOLY"] "'");
    }
}

VYTISKNOUT {
    gsub(/\{\{NÁZEV KAPITOLY\}\}/, ENVIRON["NAZEVKAPITOLY"], $0);
    print $0;
}

END {
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
}
