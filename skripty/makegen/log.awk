# Linux Kniha kouzel, skript makegen/log.awk
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

@include "skripty/makegen/hlavní.awk"

BEGIN {
    n = 0; # počítadlo pro „zavislosti“
    delete zavislosti; # závislosti pro kořenový prvek „html“

    print "# Tento soubor byl automaticky vygenerován skriptem skripty/makegen/log.awk\n\n";
    print "SHELL := /bin/bash\n";
    print ".PHONY: log\n";
    print "log:\n\n";
}

# Jen pro fragmenty určené na výstup:
{
    uplneId = $2;
    adresar = $6;
    plocheId = $3;
    #plocheIdBezDiakr = $13;
    #ikonaKapitoly = $12;

    # 1. */*.md => soubory_překladu/log/{plochéId}.log
    # cíl
    Cil(zavislosti[++n] = VYSTUP_PREKLADU "/log/" plocheId ".log");
    # závislosti
    Zavislost(adresar "/" uplneId ".md");
    Zavislost("skripty/překlad/do_logu.awk");
    Zavislost("skripty/překlad/hlavní.awk");
    Zavislost("skripty/plnění-šablon/kapitola.awk");
    Zavislost("skripty/plnění-šablon/hlavní.awk");
    Zavislost("skripty/utility.awk");
    Zavislost("formáty/log/šablona");
    Zavislost(SOUBORY_PREKLADU "/fragmenty.tsv");
    ZavislostNaDatuSestaveni();
    # příkazy
    Prikaz("@mkdir -pv $(dir $@) " SOUBORY_PREKLADU "/log");
    Prikaz(AWK " -f skripty/překlad/do_logu.awk $< >" SOUBORY_PREKLADU "/log/" plocheId ".log");
    Prikaz(AWK " -f skripty/plnění-šablon/kapitola.awk -v IDFORMATU=log -v IDKAPITOLY=" uplneId " -v TELOKAPITOLY=" SOUBORY_PREKLADU "/log/" plocheId ".log formáty/log/šablona >$@");
}

END {
    if (FATALNI_VYJIMKA) {exit FATALNI_VYJIMKA}

    # Závěr
    Cil("log");
    Zavislost(zavislosti);
    Hotovo();
}
