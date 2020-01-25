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

/^(.*\n)?Files:/ {
    i_files = i_copyright = i_license = i_copyright_e = i_license_e = 0;
    last_i = "";
    for (i = 1; i <= NF; ++i) {
        if (match($i, /^Files: ?/)) {
            i_files = i;
            n_files = split(substr($i, 1 + RLENGTH), pole_files, "\\s+");
        } else if ($i ~ /^Copyright: ?/) {
            i_copyright = i_copyright_e = i;
            last_i = "i_copyright_e";
        } else if ($i ~ /^License: ?/) {
            i_license = i_license_e = i;
            last_i = "i_license_e";
        } else if ($i ~ /^[ \t]/) {
            SYMTAB[last_i] = i;
        } else {
            ShoditFatalniVyjimku("Chyba syntaxe v záznamu " FNR "!");
        }
    }

    if (i_files == 0) {ShoditFatalniVyjimku("Chybí pole „Files:“!")}
    if (i_license == 0 || i_license_e == 0) {ShoditFatalniVyjimku("Chybí pole License (" i_license ".." i_license_e ")")}
    if ((i_copyright == 0 || i_copyright_e == 0) && $i_license !~ /^License:\s+public-domain$/) {
        ShoditFatalniVyjimku("Chybí pole Copyright (" i_copyright ".." i_copyright_e ")");
    }
    if (n_files <= 0) {ShoditFatalniVyjimku("Chybí soubory v poli Files!")}

    # Sestavit záznam
    s = "";
    if (i_copyright_e != 0) {
        s = gensub(/^Copyright:\s*/, "Copyright (c) ", 1, $i_copyright);
        for (i = i_copyright + 1; i <= i_copyright_e; ++i) {
            s = s gensub(/^\s*/, "\nCopyright (c) ", 1, $i);
        }
    }
    s = s gensub(/^License:\s*/, "\nLicence: ", 1, $i_license);
    for (i = i_license + 1; i <= i_license_e; ++i) {
        s = s gensub(/^\s*(.$)?/, "\n", 1, $i);
    }
    zaznamy[++pocet_zaznamu] = s;
    #print "LADĚNÍ: ULOŽENO: zaznamy[" pocet_zaznamu "] = {" s "}";

    # Identifikovat obrázky, ke kterým by záznam mohl patřit
    for (i = 1; i <= n_files; ++i) {
        vzorek = pole_files[i];
        #print "LADĚNÍ: vzorek \"" vzorek "\"." > "/dev/stderr";
        if (vzorek ~ /^[^?*]+$/) {
            if (vzorek in hledane_obrazky) {
                zaznamy_k_obrazkum[vzorek] = pocet_zaznamu;
                #print "LADĚNÍ: Přesná shoda: \"" vzorek "\"." > "/dev/stderr";
            }
        } else if (vzorek ~ /^[^?*]*\*[^?*]*$/) {
            pozice = index(vzorek, "*");
            predpona = substr(vzorek, 1, pozice - 1);
            pripona = substr(vzorek, pozice + 1);
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

    # Nahradit HTML entity
    for (i in zaznamy_k_obrazkum) {
        gsub(/&/, "\\&amp;", zaznamy_k_obrazkum[i]);
        gsub(/</, "\\&lt;", zaznamy_k_obrazkum[i]);
        gsub(/>/, "\\&gt;", zaznamy_k_obrazkum[i]);
        gsub(/ /, "\\&nbsp;", zaznamy_k_obrazkum[i]);
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
        gsub(/&/, "\\&amp;", zaznam);
        gsub(/</, "\\&lt;", zaznam);
        gsub(/>/, "\\&gt;", zaznam);
        gsub(/ /, "\\&nbsp;", zaznam);
        gsub(/^\n+/, "", zaznam);
        print "<dt><a href=\"", soubor, "\">", soubor, "</a></dt>";
        print "<dd><pre>", zaznam, "</pre></dd>";
    }
}
