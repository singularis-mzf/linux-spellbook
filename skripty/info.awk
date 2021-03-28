# Linux Kniha kouzel, skript info.awk
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
    FS = RS = "\n";
    prikaz = "tput bold 2>/dev/null";
    prikaz | getline bold;
    close(prikaz);

    prikaz = "tput sgr0 2>/dev/null";
    prikaz | getline reset;
    close(prikaz);

    prikaz = "tput setaf 3 2>/dev/null";
    prikaz | getline hneda;
    close(prikaz);

    prikaz = "tput setaf 6 2>/dev/null";
    prikaz | getline tyrkysova;
    close(prikaz);

    prikaz = "tput setaf 11 2>/dev/null"
    prikaz | getline zluta;
    close(prikaz);

    # Globální nastavení
    FS = "\t";
    OFS = "";
    RS = ORS = "\n";

    soubory_prekladu = ENVIRON["SOUBORY_PREKLADU"];
    if (soubory_prekladu == "") {
        ShoditFatalniVyjimku("Proměnná prostředí SOUBORY_PREKLADU není správně nastavena!");
    }

    print "Jméno sestaveni = <", bold, tyrkysova, ENVIRON["JMENO"], reset, "> (symbol:", ENVIRON["SOUBORY_PREKLADU"], "/symboly/jméno-sestavení/", \
        gensub(/[\/ \n\t]/, "-", "g", ENVIRON["JMENO"]), ")";
    print "Datum sestavení = <", tyrkysova, ENVIRON["DATUM_SESTAVENI"], reset, "> (soubor:", ENVIRON["SOUBORY_PREKLADU"], "/symboly/datum-sestavení/", ENVIRON["DATUM_SESTAVENI"], ")";
    print "DEB verze = <", tyrkysova, ENVIRON["DEB_VERZE"], reset, "> (soubor:", ENVIRON["SOUBORY_PREKLADU"], "/symboly/deb-verze/", ENVIRON["DEB_VERZE"], ")";

    print "\nNastavení:";
    print "- [", ENVIRON["PDF_ZALOZKY"] ~ /^0?$/ ? "vyp" : "zap", "] PDF záložky <", ENVIRON["PDF_ZALOZKY"], "> (max. délka ", ENVIRON["PDF_ZALOZKY_MAX_DELKA"], ")";
    print "- [", ENVIRON["REKLAMNI_PATY"] == "1" ? "zap" : "vyp", "] HTML reklamní paty <", ENVIRON["REKLAMNI_PATY"], ">";
    print "- [", ENVIRON["PREMIOVE_KAPITOLY"] ~ /^0?$/ ? "vyp" : "zap", "] prémiové kapitoly <", ENVIRON["PREMIOVE_KAPITOLY"], ">";
    print "Adresáře: <", ENVIRON["SOUBORY_PREKLADU"], "> <", ENVIRON["VYSTUP_PREKLADU"], ">";

    print "\nFragmenty na výstup:";
    NacistFragmentyTSV(ENVIRON["SOUBORY_PREKLADU"] "/fragmenty.tsv");
    for (i = 1; FragInfo(i, "existuje"); ++i) {
        priznaky = FragInfo(i, "příznaky");
        printf("\n%4d. [%s] „%s“ (%s) {%s}\n", \
            i, \
            tyrkysova FragInfo(i, "plné-id") reset, \
            bold FragInfo(i, "celý-název") reset, \
            priznaky ~ /d/ ? "dodatek" : FragInfo(i, "id-nadkapitoly") != "" ? "podkapitola" : "kapitola", \
            priznaky \
        );
        printf("   vedlejší id: <%s><%s><%s><%s>\n", FragInfo(i, "ploché-id"), FragInfo(i, "ploché-id-bez-diakr"), FragInfo(i, "holé-id"), FragInfo(i, "xheš"));
        printf("   název podkapitoly = <%s>\n", FragInfo(i, "název-podkapitoly"));
        if (FragInfo(i, "id-nadkapitoly") != "") {
            printf("   nadkapitola: <%s> <%s>\n", FragInfo(i, "číslo-nadkapitoly"), FragInfo(i, "id-nadkapitoly"));
        }
        stitky = FragInfo(i, "štítky");
        if (stitky != "") {
            printf("   štítky: <%s>\n", gensub(/\{/, "{" hneda, "g", gensub(/\}|$/, reset "&", "g", stitky)));
        }
    }

    print "\nNezařazené fragmenty:";
    for (i = -1; FragInfo(i, "existuje"); --i) {
        printf("%4d. [%s] „%s“ {%s}\n", i, tyrkysova FragInfo(i, "plné-id") reset, bold FragInfo(i, "celý-název") reset, FragInfo(i, "příznaky"));
    }
}
