# Linux Kniha kouzel, skript makegen/pdf-společné.awk
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
    delete potrebne_ik; # ikony kapitol na výstup (asociativní pole)
    delete zavislosti; # závislosti pro kořenový prvek „html“

    print "# Tento soubor byl automaticky vygenerován skriptem skripty/makegen/pdf-společné.awk\n\n";
    print "SHELL := /bin/bash\n";
    print ".PHONY: pdf-společné\n";
    print "pdf-společné:\n\n";
}

$1 != 0 {
    # Jen fragmenty určené na výstup:
    uplneId = $2;
    adresar = $6;
    plocheId = $3;
    #plocheIdBezDiakr = $13;
    ikonaKapitoly = $12;

    # 1. */*.md => soubory_překladu/pdf-společné/{plocheId}.kap
    # cíl
    Cil(zavislosti[++n] = SOUBORY_PREKLADU "/pdf-společné/" plocheId ".kap");
    # závislosti
    Zavislost(adresar "/" uplneId ".md");
    Zavislost(SOUBORY_PREKLADU "/osnova/" plocheId ".tsv");
    Zavislost("skripty/překlad/do_latexu.awk");
    Zavislost("skripty/překlad/hlavní.awk");
    Zavislost("skripty/utility.awk");
    Zavislost(SOUBORY_PREKLADU "/fragmenty.tsv");
    # příkazy
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz(AWK " -f skripty/překlad/do_latexu.awk $< >$@");

    if (ikonaKapitoly != VYCHOZI_IKONA_KAPITOLY) {
        potrebne_ik[ikonaKapitoly] = 1;
    }
}

END {
    if (FATALNI_VYJIMKA) {exit FATALNI_VYJIMKA}

    # *. soubory_překladu/postprocess.dat
    # ----------------------------------------------------------------------------
    Cil(zavislosti[++n] = SOUBORY_PREKLADU "/postprocess.dat");
    Zavislost("$(wildcard postprocess.dat)");
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz("-test -r postprocess.dat && cat postprocess.dat >$@");
    Prikaz("touch $@");

    # 2. obrázky/{obrázek}.{jpg|png} => soubory_překladu/pdf-společné/_obrázky/{obrázek}.*
    prikaz = "cat seznamy/obrázky-jpeg.seznam seznamy/obrázky-png.seznam";
    while (prikaz | getline) {
        Cil(zavislosti[++n] = SOUBORY_PREKLADU "/pdf-společné/_obrázky/" $0);
        Zavislost("obrázky/" $0);
        Zavislost("konfigurace/konfig.ini");
        Prikaz("mkdir -pv $(dir $@)");
        Prikaz(CONVERT " $< $$(skripty/přečíst-konfig.sh \"Filtry\" \"../obrázky/" $0 "\" \"-colorspace Gray\" < konfigurace/konfig.ini) $@");
    }
    close(prikaz);

    # 2B. obrázky/ik/*.png => soubory_překladu/pdf-společné/_obrázky/ik/{obrázek}.png
    for (ikonaKapitoly in potrebne_ik) {
        Cil(zavislosti[++n] = SOUBORY_PREKLADU "/pdf-společné/_obrázky/" ikonaKapitoly);
        Zavislost("obrázky/" ikonaKapitoly);
        Zavislost("konfigurace/konfig.ini");
        Prikaz("mkdir -pv $(dir $@)");
        Prikaz(CONVERT " $< $$(skripty/přečíst-konfig.sh \"Filtry\" \"../obrázky/" $0 "\" \"-colorspace Gray\" < konfigurace/konfig.ini) $@");

        if (ikonaKapitoly !~ /^ik\//) {
            ShoditFatalniVyjimku("Neočekávaná ikona kapitoly: \"" ikonaKapitoly "\" (asi nutno doimplementovat)");
        }
    }

    # 3. obrázky/{obrázek}.svg => soubory_překladu/pdf-společné/_obrázky/{obrázek}.pdf
    soubor = "seznamy/obrázky-svg.seznam";
    while (getline <soubor) {
        Cil(zavislosti[++n] = SOUBORY_PREKLADU "/pdf-společné/_obrázky/" gensub(/\.svg$/, ".pdf", 1, $0));
        Zavislost("obrázky/" $0);
        Prikaz("mkdir -pv $(dir $@)");
        Prikaz("rsvg-convert -f pdf -o $@ $<"); # z balíčku „librsvg2-bin“
    }
    close(soubor);

    # 3B. qr.eps
    Cil(zavislosti[++n] = SOUBORY_PREKLADU "/pdf-společné/qr.eps");
    Zavislost("konfigurace/konfig.ini");
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz("skripty/přečíst-konfig.sh Adresy do-qr <$< | qrencode -o $@ -t eps -s 8");

    Cil("pdf-společné");
    Zavislost(zavislosti);

    # Závěr
    Hotovo();
}
