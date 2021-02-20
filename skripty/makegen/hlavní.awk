# Linux Kniha kouzel, skript makegen/hlavní.awk
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

@include "skripty/utility.awk"

BEGIN {
    FS = "\t";
    RS = "\n";
    OFS = ORS = "";

    AWK = "gawk";
    CONVERT = "convert";
    SED = "sed -E";

    SOUBORY_PREKLADU = ENVIRON["SOUBORY_PREKLADU"];
    VYSTUP_PREKLADU = ENVIRON["VYSTUP_PREKLADU"];
    JMENO_SESTAVENI = ENVIRON["JMENO"];
    DATUM_SESTAVENI = ENVIRON["DATUM_SESTAVENI"];
    DEB_VERZE = ENVIRON["DEB_VERZE"];

    if (SOUBORY_PREKLADU == "") {
        ShoditFatalniVyjimku("Chybí vyžadovaná proměnná SOUBORY_PREKLADU!");
    }
    if (VYSTUP_PREKLADU == "") {
        ShoditFatalniVyjimku("Chybí vyžadovaná proměnná VYSTUP_PREKLADU!");
    }
    if (JMENO_SESTAVENI == "") {
        ShoditFatalniVyjimku("Chybí vyžadovaná proměnná JMENO!");
    }
    if (DATUM_SESTAVENI == "") {
        ShoditFatalniVyjimku("Chybí vyžadovaná proměnná DATUM_SESTAVENI!");
    }
    if (DEB_VERZE == "") {
        ShoditFatalniVyjimku("Chybí vyžadovaná proměnná DEB_VERZE!");
    }

    VYCHOZI_IKONA_KAPITOLY = "ik-výchozí.png";
    MakeGenStav = "HOTOVO";
}

function Cil(cil)
{
    switch (MakeGenStav) {
    case "CÍL":
        print " ", cil;
        break;
    case "ZÁVISLOST":
    case "PŘÍKAZ":
        print "\n\n", cil;
        break;
    case "HOTOVO":
        print "\n", cil;
        break;
    }
    return MakeGenStav = "CÍL";
}

function Zavislost(zav)
{
    if (isarray(zav)) {return Zavislosti(zav)}

    switch (MakeGenStav) {
        case "CÍL":
            print ": ", zav;
            break;
        case "ZÁVISLOST":
            print " ", zav;
            return MakeGenStav;
        case "PŘÍKAZ":
        case "HOTOVO":
            ShoditFatalniVyjimku("Závislost bez cíle!");
    }
    return MakeGenStav = "ZÁVISLOST";
}

function Zavislosti(pole,   i, tmp)
{
    tmp = "";
    for (i = 1; i in pole; ++i) {
        tmp = Zavislost(pole[i]);
    }
    return tmp;
}

function Prikaz(prikaz)
{
    switch (MakeGenStav) {
        case "CÍL":
            print ":\n\t", prikaz;
            break;
        case "ZÁVISLOST":
        case "PŘÍKAZ":
            print "\n\t", prikaz;
            break;
        case "HOTOVO":
            ShoditFatalniVyjimku("Příkaz bez cíle!");
    }
    return MakeGenStav = "PŘÍKAZ";
}

function Hotovo()
{
    switch (MakeGenStav) {
    case "CÍL":
        print ":\n\n";
        break;
    case "ZÁVISLOST":
    case "PŘÍKAZ":
        print "\n\n";
        break;
    case "HOTOVO":
    default:
        break;
    }
    return MakeGenStav = "HOTOVO";
}

function join(oddelovac, pole,   i, s)
{
    if (!(1 in pole)) {return ""}
    if (!(2 in pole)) {return pole[1]}
    if (!(3 in pole)) {return pole[1] oddelovac pole[2]}
    s = pole[1];
    for (i = 2; i in pole; ++i) {s = s oddelovac pole[i]}
    return s;
}

#$(DATUM_SESTAVENI_SOUBOR) $(DEB_VERZE_SOUBOR) $(JMENO_SESTAVENI_SOUBOR):

function ZavislostNaJmenuSestaveni() {
    # JMENO_SESTAVENI_SOUBOR := $(SOUBORY_PREKLADU)/symboly/jméno-sestavení/$(shell printf %s "$${JMENO//[$'/ \n\t']/-}")
    return Zavislost(SOUBORY_PREKLADU "/symboly/jméno-sestavení/" gensub(/[/ \n\t]/, "-", "g", JMENO_SESTAVENI));
}
function ZavislostNaDatuSestaveni() {
    return Zavislost(SOUBORY_PREKLADU "/symboly/datum-sestavení/" DATUM_SESTAVENI);
}
function ZavislostNaPoradiKapitol() {
    return Zavislost(SOUBORY_PREKLADU "/fragmenty.tsv");
}
function ZavislostNaDebVerzi() {
    return Zavislost(SOUBORY_PREKLADU "/symboly/deb-verze/" DEB_VERZE);
}
