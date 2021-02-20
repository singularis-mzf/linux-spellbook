# Linux Kniha kouzel, skript makegen/pdf-varianta.awk
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
    #n = 0; # počítadlo pro „zavislosti“
    #delete zavislosti; # závislosti pro kořenový prvek „html“
    delete vfragmenty; # číslo => plocheId

    if (VARIANTA == "") {ShoditFatalniVyjimku("Chybí vyžadovaná proměnná VARIANTA!")}

    print "# Tento soubor byl automaticky vygenerován skriptem skripty/makegen/pdf.awk\n\n";
    print "SHELL := /bin/bash\n";
    print ".PHONY: ", VARIANTA, "\n";
    print VARIANTA, ": ", VYSTUP_PREKLADU, "/", VARIANTA, ".pdf\n\n";
}

$1 != 0 {
    # Jen fragmenty určené na výstup:
    #uplneId = $2;
    #adresar = $6;
    plocheId = $3;
    #plocheIdBezDiakr = $13;
    #ikonaKapitoly = $12;

    Cil(SOUBORY_PREKLADU "/" VARIANTA "/" plocheId ".kap");
    Zavislost(SOUBORY_PREKLADU "/pdf-společné/" plocheId ".kap");
    Zavislost(SOUBORY_PREKLADU "/postprocess.dat");
    Zavislost("skripty/postprocess.awk");
    Zavislost("skripty/utility.awk");
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz("touch " SOUBORY_PREKLADU "/postprocess.log");
    Prikaz(AWK " -v IDFORMATU=" VARIANTA " -f skripty/postprocess.awk " SOUBORY_PREKLADU "/postprocess.dat $< 2>&1 >$@");

    vfragmenty[$1] = plocheId;
}

END {
    if (FATALNI_VYJIMKA) {exit FATALNI_VYJIMKA}

    # 2. soubory_překladu/{VARIANTA}/{plocheId}.kap => soubory_překladu/{VARIANTA}/_všechny.kap => soubory_překladu/{VARIANTA}/kniha.tex
    Cil(SOUBORY_PREKLADU "/" VARIANTA "/kniha.tex");
    Zavislost("formáty/pdf/šablona.tex");
    Zavislost(SOUBORY_PREKLADU "/fragmenty.tsv");
    Zavislost("skripty/plnění-šablon/speciální.awk");
    Zavislost("skripty/plnění-šablon/hlavní.awk");
    Zavislost("skripty/utility.awk");
    prikaz = "cat";
    for (i = 1; i in vfragmenty; ++i) {
        Zavislost(SOUBORY_PREKLADU "/" VARIANTA "/" vfragmenty[i] ".kap");
        prikaz = prikaz " " SOUBORY_PREKLADU "/" VARIANTA "/" vfragmenty[i] ".kap";
    }
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz(prikaz " >" SOUBORY_PREKLADU "/" VARIANTA "/_všechny.kap");
    Prikaz(AWK " -f skripty/plnění-šablon/speciální.awk -v IDFORMATU=" VARIANTA " -v TELO=" SOUBORY_PREKLADU "/" VARIANTA "/_všechny.kap formáty/pdf/šablona.tex >$@");

    # 3. soubory_překladu/{VARIANTA}/kniha.tex => soubory_překladu/{VARIANTA}/kniha.pdf
    Cil(SOUBORY_PREKLADU "/" VARIANTA "/kniha.pdf");
    Zavislost(SOUBORY_PREKLADU "/" VARIANTA "/kniha.tex");
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz("ln -frsTv skripty " SOUBORY_PREKLADU "/" VARIANTA "/skripty");
    Prikaz("cd " SOUBORY_PREKLADU "/" VARIANTA " && exec " AWK " -f skripty/latex.awk");

    if (VARIANTA != "pdf-výplach") {
        # 4. soubory_překladu/{VARIANTA}/kniha.toc => soubory_překladu/{VARIANTA}/pdfmarks
        Cil(SOUBORY_PREKLADU "/" VARIANTA "/pdfmarks");
        Zavislost(SOUBORY_PREKLADU "/" VARIANTA "/kniha.pdf");
        Zavislost(SOUBORY_PREKLADU "/fragmenty.tsv");
        for (i = 1; i in vfragmenty; ++i) {
            Zavislost(SOUBORY_PREKLADU "/osnova/" vfragmenty[i] ".tsv");
        }
        Zavislost("skripty/extrakce/pdf-záložky.awk");
        Prikaz("mkdir -pv $(dir $@)");
        Prikaz(AWK " -f skripty/extrakce/pdf-záložky.awk " SOUBORY_PREKLADU "/" VARIANTA "/kniha.toc >$@");

        # 5. soubory_překladu/{VARIANTA}/kniha.pdf => vystup_překladu/{VARIANTA}.pdf
        Cil(VYSTUP_PREKLADU "/" VARIANTA ".pdf");
        Zavislost(SOUBORY_PREKLADU "/" VARIANTA "/kniha.pdf");
        Zavislost(SOUBORY_PREKLADU "/" VARIANTA "/pdfmarks");
        Prikaz("mkdir -pv $(dir $@)");
        Prikaz("if test \"$(PDF_ZALOZKY)\" != \"0\"; " \
            "then " \
            "gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=$@ " SOUBORY_PREKLADU "/" VARIANTA "/kniha.pdf " \
            SOUBORY_PREKLADU "/" VARIANTA "/pdfmarks </dev/null; " \
            "else cat $< >$@; " \
            "fi");
    } else {
        # 4+5. soubory_překladu/pdf-výplach/kniha.pdf => vystup_překladu/pdf-výplach.pdf
        Cil(VYSTUP_PREKLADU "/pdf-výplach.pdf");
        Zavislost(SOUBORY_PREKLADU "/pdf-výplach/kniha.pdf");
        Prikaz("mkdir -pv $(dir $@)");
        Prikaz("cat $< >$@");
    }

    # Závěr
    Hotovo();
}
