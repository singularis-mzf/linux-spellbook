# Linux Kniha kouzel, skript makegen/html.awk
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
    n_vsechny_md = 0; # počítadlo pro „všechny_md“
    delete potrebne_ik; # ikony kapitol na výstup (asociativní pole)
    delete vsechny_md; # zdrojové md-soubory k výstupu
    delete zavislosti; # závislosti pro kořenový prvek „html“

    print "# Tento soubor byl automaticky vygenerován skriptem skripty/makegen/html.awk\n\n";
    print "SHELL := /bin/bash\n";
    print ".PHONY: html\n";
    print "html:\n\n";
}

{
    uplneId = $2;
    adresar = $6;
    plocheId = $3;
    plocheIdBezDiakr = $13;
    ikonaKapitoly = $12;

    # 1. */*.md => soubory_překladu/html/*.tělo
    # cíl
    Cil(SOUBORY_PREKLADU "/html/" plocheIdBezDiakr ".tělo");
    # závislosti
    Zavislost(adresar "/" uplneId ".md");
    Zavislost(SOUBORY_PREKLADU "/osnova/" plocheId ".tsv");
    Zavislost(SOUBORY_PREKLADU "/ucs_ikony.dat");
    Zavislost("skripty/překlad/do_html.awk");
    Zavislost("skripty/překlad/hlavní.awk");
    Zavislost("skripty/utility.awk");
    Zavislost(SOUBORY_PREKLADU "/fragmenty.tsv");
    # příkazy
    PrikazLI("'[HTML] " uplneId " (1/2)'");
    PrikazVytvorAdresar();
    Prikaz("@" AWK " -f skripty/překlad/do_html.awk $< >$@");

    if ($1 != 0) {
        # Jen pro fragmenty určené na výstup:
        # 2. soubory_překladu/html/*.tělo => výstup_překladu/html/*.htm
        # cíl
        Cil(zavislosti[++n] = VYSTUP_PREKLADU "/html/" plocheIdBezDiakr ".htm");
        # závislosti
        Zavislost(SOUBORY_PREKLADU "/html/" plocheIdBezDiakr ".tělo");
        Zavislost("skripty/plnění-šablon/kapitola.awk");
        Zavislost("skripty/plnění-šablon/hlavní.awk");
        Zavislost("formáty/html/šablona.htm");
        Zavislost(SOUBORY_PREKLADU "/fragmenty.tsv");
        ZavislostNaDatuSestaveni();
        # příkazy
        PrikazLI("'[HTML] " uplneId " (2/2)'");
        PrikazVytvorAdresar();
        Prikaz("@" AWK " -f skripty/plnění-šablon/kapitola.awk " \
            "-v IDFORMATU=html " \
            "-v IDKAPITOLY='" uplneId "' " \
            "-v TELOKAPITOLY=$< " \
            "-v VARIANTA=kapitola " \
            "formáty/html/šablona.htm >$@");

        vsechny_md[++n_vsechny_md] = adresar "/" uplneId ".md";
        if (ikonaKapitoly != VYCHOZI_IKONA_KAPITOLY) {
            potrebne_ik[ikonaKapitoly] = 1;
        }
    } else {
        # Jen pro fragmenty, které nejsou na výstup:
        zavislosti[++n] = SOUBORY_PREKLADU "/html/" plocheIdBezDiakr ".tělo";
    }
}

END {
    if (FATALNI_VYJIMKA) {exit FATALNI_VYJIMKA}

    # *. soubory_překladu/ucs_ikony.dat
    Cil(SOUBORY_PREKLADU "/ucs_ikony.dat");
    Zavislost("ucs_ikony/ikony.txt");
    Zavislost("skripty/extrakce/ikony-zaklínadel.awk");
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz(AWK " -f skripty/extrakce/ikony-zaklínadel.awk");

    # 3. formáty/html/šablona.css => vystup_překladu/html/lkk-*.css
    # cíl
    Cil(zavislosti[++n] = VYSTUP_PREKLADU "/html/lkk-" DATUM_SESTAVENI ".css");
    # závislosti
    Zavislost("formáty/html/šablona.css");
    Zavislost("skripty/plnění-šablon/css.awk");
    Zavislost("skripty/plnění-šablon/css2.awk");
    ZavislostNaDatuSestaveni();
    # příkazy
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz("$(RM) " VYSTUP_PREKLADU "/html/lkk-????????.css");
    Prikaz("set -o pipefail; " AWK " -v IDFORMATU=html -v MOTIV=hlavni -f skripty/plnění-šablon/css.awk $< | " AWK " -f skripty/plnění-šablon/css2.awk > $@");

    soubor = "seznamy/css-motivy.seznam";
    while (getline < soubor) {
        if ($0 != "") {
            # cíl
            Cil(zavislosti[++n] = VYSTUP_PREKLADU "/html/lkk-" DATUM_SESTAVENI "-" $0 ".css");
            # závislosti
            Zavislost("formáty/html/šablona.css");
            Zavislost("skripty/plnění-šablon/css.awk");
            Zavislost("skripty/plnění-šablon/css2.awk");
            # příkazy
            Prikaz("mkdir -pv $(dir $@)");
            Prikaz("$(RM) " VYSTUP_PREKLADU "/html/lkk-????????-" $0 ".css");
            Prikaz("set -o pipefail; " AWK " -v IDFORMATU=html -v MOTIV=" $0 " -f skripty/plnění-šablon/css.awk $< | " AWK " -f skripty/plnění-šablon/css2.awk > $@");
        }
    }
    close(soubor);

    # 4. obrázky/* => výstup_překladu/html/obrazky/{obrazek}
    prikaz = "cat seznamy/obrázky-jpeg.seznam seznamy/obrázky-png.seznam seznamy/obrázky-svg.seznam";
    while (prikaz | getline) {
        if ($0 != "") {
            # cíl
            Cil(zavislosti[++n] = VYSTUP_PREKLADU "/html/obrazky/" BezDiakritiky($0));
            # závislosti
            Zavislost("obrázky/" $0);
            # příkazy
            Prikaz("mkdir -pv $(dir $@)");
            Prikaz("cp -vT $< $@");
        }
    }
    close(prikaz);
    soubor = "seznamy/obrázky-ik.seznam";
    while (getline < soubor) {
        if ($0 != "" && ("ik/" $0) in potrebne_ik) { # [ ] odladit
            # cíl
            Cil(zavislosti[++n] = VYSTUP_PREKLADU "/html/obrazky/ik/" BezDiakritiky($0));
            # závislosti
            Zavislost("obrázky/ik/" $0);
            # příkazy
            Prikaz("mkdir -pv $(dir $@)");
            Prikaz("cp -vT $< $@");
        }
    }
    close(soubor);

    # 5. výstup_překladu/html/index.htm
    # cíl
    Cil(zavislosti[++n] = VYSTUP_PREKLADU "/html/index.htm");
    # závislosti
    Zavislost("formáty/html/šablona.htm");
    Zavislost("skripty/plnění-šablon/index-html.awk");
    Zavislost("skripty/plnění-šablon/hlavní.awk");
    Zavislost("skripty/utility.awk");
    Zavislost(SOUBORY_PREKLADU "/fragmenty.tsv");
    ZavislostNaDatuSestaveni();
    # příkazy
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz(AWK " -f skripty/plnění-šablon/index-html.awk " \
        "-v JMENOVERZE='" JMENO_SESTAVENI "' " \
        "-v DATUMSESTAVENI=" DATUM_SESTAVENI " " \
        "-v IDFORMATU=html " \
        "-v VARIANTA=index " \
        SOUBORY_PREKLADU "/fragmenty.tsv formáty/html/šablona.htm >$@");

    # 6. shromáždit copyrighty na stránku x-autori.htm
    # cíl
    Cil(zavislosti[++n] = VYSTUP_PREKLADU "/html/x-autori.htm");
    # závislosti
    Zavislost("skripty/extrakce/copyrighty.awk");
    Zavislost("skripty/extrakce/copykobr.awk");
    Zavislost("skripty/plnění-šablon/kapitola.awk");
    Zavislost("skripty/plnění-šablon/hlavní.awk");
    Zavislost("formáty/html/šablona.htm");
    Zavislost(vsechny_md);
    Zavislost(SOUBORY_PREKLADU "/fragmenty.tsv");
    ZavislostNaDatuSestaveni();
    # příkazy
    Prikaz("mkdir -pv $(dir $@) " SOUBORY_PREKLADU "/html");
    Prikaz(AWK " -f skripty/extrakce/copyrighty.awk " join(" ", vsechny_md) " >" SOUBORY_PREKLADU "/html/kap-copys.htm");
    Prikaz(AWK " -f skripty/extrakce/copykobr.awk COPYRIGHT " \
        "$(shell (sed -E 's!.*!obrázky/&!' seznamy/obrázky-jpeg.seznam seznamy/obrázky-png.seznam seznamy/obrázky-svg.seznam; sed -E 's!.*!obrázky/ik/&!' seznamy/obrázky-ik.seznam) | tr \\\\n \" \") >" SOUBORY_PREKLADU "/html/obr-copys.htm");
    Prikaz(AWK " -f skripty/plnění-šablon/kapitola.awk " \
        "-v JMENOVERZE='$(JMENO)' " \
        "-v IDFORMATU=html " \
        "-v IDKAPITOLY=_autori " \
        "-v DATUMSESTAVENI=" DATUM_SESTAVENI " " \
        "-v COPYRIGHTY_KAPITOL=" SOUBORY_PREKLADU "/html/kap-copys.htm " \
        "-v COPYRIGHTY_OBRAZKU=" SOUBORY_PREKLADU "/html/obr-copys.htm " \
        "-v VARIANTA=autoři " \
        "formáty/html/šablona.htm > $@");

    # 7. shromáždit štítky na stránku x-stitky.htm
    # cíl
    Cil(zavislosti[++n] = VYSTUP_PREKLADU "/html/x-stitky.htm");
    # závislosti
    Zavislost("skripty/plnění-šablon/kapitola.awk");
    Zavislost("skripty/plnění-šablon/hlavní.awk");
    Zavislost("formáty/html/šablona.htm");
    Zavislost(SOUBORY_PREKLADU "/fragmenty.tsv");
    ZavislostNaDatuSestaveni();
    # příkazy
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz(AWK " -f skripty/plnění-šablon/kapitola.awk " \
        "-v JMENOVERZE='$(JMENO)' " \
        "-v IDFORMATU=html " \
        "-v IDKAPITOLY=_stitky " \
        "-v DATUMSESTAVENI=" DATUM_SESTAVENI " " \
        "-v FRAGMENTY_TSV=" SOUBORY_PREKLADU "/fragmenty.tsv " \
        "-v VARIANTA=štítky " \
        "formáty/html/šablona.htm >$@");

    # Závěr
    Cil("html");
    Zavislost(zavislosti);
    Hotovo();
}
