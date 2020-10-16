# Linux Kniha kouzel, skript extrakce/copykobr.awk
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
    FS = "\n";
    RS = "";
    OFS = "";
    ORS = "\n";

    delete hledane_obrazky;
    for (i = 2; i < ARGC; ++i) {hledane_obrazky[ARGV[i]] = 1}
    ARGC = 2;

    #for (i in hledane_obrazky) {print "LADĚNÍ: hledaný obrázek \"" i "\"." > "/dev/stderr"}

    delete zaznamy; # [číslo-záznamu] => záznam (dělený \n)
    delete zaznamy_k_obrazkum; # [cesta/obrázku] => číslo-záznamu
    pocet_zaznamu = 0;
}

# Přeskočit úvodní odstavec
NR == 1 {next}

/^Files:/ {
    delete files;       n_files = 0;
    delete copyright;   n_copyright = 0;
    delete license;     n_license = 0;
    delete poznamky;    n_poznamky = 0;
    delete docasnepole; n_docasnepole = 0;
    prefix = "";

    # Analyzovat odstavec
    for (i = 1; i <= NF; ++i) {
        if ($i ~ /^Files:/) {prefix = "Files"}
        if ($i ~ /^Copyright:/) {prefix = "Copyright"}
        if ($i ~ /^License:/) {prefix = "License"}

        if ($i ~/^[^ :]*:/) {
            text = gensub(/^[^ :]*:\s*/, "", 1, $i);
        } else if ($i == " .") {
            text = "";
        } else if ($i ~ /^ /) {
            text = gensub(/^\s*/, "", 1, $i);
        } else {
            text = "";
        }
        #print "LADĚNÍ: vstupř<" FNR ">;prefix<" prefix ">;text<" text ">;řádek<" $i ">" > "/dev/stderr";
        switch (prefix) {
            case "Files":
                n_docasnepole = split(substr($i, 7), docasnepole, "\\s+");
                for (j = 1; j <= n_docasnepole; ++j) {
                    if (docasnepole[j] != "") {
                        files[++n_files] = docasnepole[j];
                    }
                }
                break;
            case "Copyright":
                copyright[++n_copyright] = text;
                break;
            case "License":
                if ($i ~ /^License:/) {
                    license[++n_license] = text;
                } else {
                    poznamky[++n_poznamky] = text;
                }
        }
        #print "LADĚNÍ: " n_files " " n_copyright " " n_license " " n_poznamky > "/dev/stderr";
    }

    if (n_files == 0) {ShoditFatalniVyjimku("Chybí pole „Files:“!")}
    if (n_license == 0) {ShoditFatalniVyjimku("Chybí pole License!")}
    if (n_license > 1) {ShoditFatalniVyjimku("Pole License zadáno vícekrát!")}
    if (n_copyright == 0 && license[1] != "public-domain") {ShoditFatalniVyjimku("Chybí pole Copyright!")}

    #print "LADĚNÍ: [" (pocet_zaznamu + 1) "]: " n_files " " n_license " " n_copyright "\n" > "/dev/stderr";

    # Sestavit a uložit interní záznam
    s = "";
    for (i = 1; i <= n_copyright; ++i) {
        s = s "\nCopyright (c) " copyright[i];
        #print "LADĚNÍ: +copy: " copyright[i] > "/dev/stderr";
    }
    if (n_license != 0) {
        s = s "\nLicense: " license[1];
        #print "LADĚNÍ: +lice: " license[i] > "/dev/stderr";
    }
    for (i = 1; i <= n_poznamky; ++i) {
        s = s "\n" poznamky[i];
        #print "LADĚNÍ: +pozn: " poznamky[i] > "/dev/stderr";
    }
    sub(/^\n/, "", s);
    zaznamy[++pocet_zaznamu] = s;
    #print "LADĚNÍ: ULOŽENO: zaznamy[" pocet_zaznamu "] = {" s "}" > "/dev/stderr";

    # Identifikovat obrázky, ke kterým by záznam mohl patřit
    for (i = 1; i <= n_files; ++i) {
        vzorek = files[i];
        #print "LADĚNÍ: vzorek \"" vzorek "\"." > "/dev/stderr";
        if (vzorek ~ /^[^?*]+$/) {
            # Vzorek neobsahuje znaky ? ani * – testovat na přesnou shodu.
            if (vzorek in hledane_obrazky) {
                zaznamy_k_obrazkum[vzorek] = pocet_zaznamu;
                #print "LADĚNÍ: Přesná shoda: \"" vzorek "\"." > "/dev/stderr";
            }
            #else {
            #    print "LADĚNÍ: Přesná shoda nenalezena: \"" vzorek "\"." > "/dev/stderr";
            #}
        } else if (vzorek ~ /^[^?*]*\*[^?*]*$/) {
            # Vzorek obsahuje právě jeden znak * – testovat na shodu předpony a přípony.
            pozice = index(vzorek, "*");
            predpona = substr(vzorek, 1, pozice - 1);
            pripona = substr(vzorek, pozice + 1);
            #print "LADĚNÍ: Hledám předponu <" predpona "> a příponu <" pripona "> podle vzorku <" vzorek ">." > "/dev/stderr";
            for (obrazek in hledane_obrazky) {
                #print "LADĚNÍ: Testy: \"" SubstrZleva(obrazek, length(predpona)) "\" ? \"" predpona "\" && \"" SubstrZprava(obrazek, length(pripona)) "\" ? \"" pripona "\"." > "/dev/stderr";
                if (SubstrZleva(obrazek, length(predpona)) == predpona && SubstrZprava(obrazek, length(pripona)) == pripona) {
                    zaznamy_k_obrazkum[obrazek] = pocet_zaznamu;
                    #print "LADĚNÍ: Vzorek \"" vzorek "\": odpovídá \"" i "\"." > "/dev/stderr";
                }
            }
        } else {
            ShoditFatalniVyjimku("Nepodporovaný tvar vzorku: " vzorek);
        }
    }
}

END {
    if (FATALNI_VYJIMKA) {exit FATALNI_VYJIMKA}

    #for (i in zaznamy_k_obrazkum) {
        #print "Záznam " i ":" zaznamy[zaznamy_k_obrazkum[i]];
    #}

    # Nahradit HTML entity a redukovat vícenásobné konce řádků
    for (i in zaznamy) {
        gsub(/&/, "\\&amp;", zaznamy[i]);
        gsub(/</, "\\&lt;", zaznamy[i]);
        gsub(/>/, "\\&gt;", zaznamy[i]);
        gsub(/ /, "\\&nbsp;", zaznamy[i]);
        gsub(/\n+/, "\n", zaznamy[i]);
    }

    # Zkontrolovat chybějící záznamy
    for (i in hledane_obrazky) {
        if (!(i in zaznamy_k_obrazkum)) {
            print "VAROVÁNÍ: Nenalezen záznam k obrázku \"" i "\"!" > "/dev/stderr";
        }
    }

    pocet = asorti(zaznamy_k_obrazkum, podle_abecedy, "@ind_str_asc");

    for (i = 1; i <= pocet; ++i) {
        soubor = podle_abecedy[i];
        zaznam = zaznamy[zaznamy_k_obrazkum[soubor]];
        #print "LADĚNÍ: i = " i "; podle_abecedy[i] = " podle_abecedy[i] "; zaznamy_k_obrazkum[soubor] = " zaznamy_k_obrazkum[soubor] " zaznamy[zaznamy_k_obrazkum[soubor]] = " zaznamy[zaznamy_k_obrazkum[soubor]] "." > "/dev/stderr";
        #exit;
        print "<dt><a href=\"", OmezitNazev(soubor, 1), "\">", OmezitNazev(soubor, 1), "</a></dt>";
        print "<dd><pre>", zaznam, "</pre></dd>";
    }
}
