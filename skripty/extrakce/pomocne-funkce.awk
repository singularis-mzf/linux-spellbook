# Linux Kniha kouzel, skript extrakce/pomocne-funkce.awk
# Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>
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

# Tento skript slouží k extrakci pomocných funkcí a skriptů ze zdrojových kódů kapitol.
# V první fázi načte id zpracovávaných kapitol ze souboru fragmenty.tsv.
# Následně prochází jednu kapitolu za druhou a hledá definice v sekcích nadepsaných
# „Pomocné funkce a skripty“ nebo podobně.
# Nakonec zapíše pomocné skripty do adresáře vystup_prekladu/bin a pomocné funkce
# do souboru vystup_prekladu/bin/pomocne-funkce.sh.

function ZpracujZnaky(text,     VSTUP, VYSTUP, C) {
    VSTUP = text;
    VYSTUP = "";

    while (VSTUP != "") {
        # 7 znaků
        switch (C = substr(VSTUP, 1, 7)) {
            case "&blank;":
                VYSTUP = VYSTUP " ";
                VSTUP = substr(VSTUP, 8);
                continue;
            default:
                break;
        }
        # 6 znaků
        switch (C = substr(VSTUP, 1, 6)) {
            case "&nbsp;":
                # nezlomitelná mezera se v této verzi nepovažuje za bílý znak
                VYSTUP = VYSTUP " ";
                VSTUP = substr(VSTUP, 7);
                continue;
            case "&quot;":
                VYSTUP = VYSTUP "\"";
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab1>":
            case "<tab2>":
            case "<tab3>":
            case "<tab4>":
            case "<tab5>":
            case "<tab6>":
            case "<tab7>":
            case "<tab8>":
                VYSTUP = VYSTUP "\t";
                VSTUP = substr(VSTUP, 7);
                continue;
            default:
                break;
        }
        # 5 znaků
        switch (C = substr(VSTUP, 1, 5)) {
            case "&amp;":
                VYSTUP = VYSTUP "&";
                VSTUP = substr(VSTUP, 6);
                continue;
            case "&apo;":
                VYSTUP = VYSTUP "'";
                VSTUP = substr(VSTUP, 6);
                continue;
            case "<tab>":
                VYSTUP = VYSTUP "\t";
                VSTUP = substr(VSTUP, 6);
                continue;
            default:
                break;
        }
        # 4 znaky
        switch (C = substr(VSTUP, 1, 4)) {
            case "<br>":
                VYSTUP = VYSTUP "\n";
                VSTUP = substr(VSTUP, 5);
                continue;
            case "&lt;":
                VYSTUP = VYSTUP "<";
                VSTUP = substr(VSTUP, 5);
                continue;
            case "&gt;":
                VYSTUP = VYSTUP ">";
                VSTUP = substr(VSTUP, 5);
                continue;
            default:
                break;
        }
        # 1 znak
        switch (C = substr(VSTUP, 1, 1)) {
            case "\\":
                VYSTUP = VYSTUP substr(VSTUP, 2, 1);
                VSTUP = substr(VSTUP, 3);
                continue;
            case "⫽":
                VYSTUP = VYSTUP "//";
                VSTUP = substr(VSTUP, 2);
                continue;
            case "`":
            case "_":
                ShoditFatalniVyjimku("Neescapovaný znak " C "! Všechny výskyty tohoto znaku musejí být escapovány zpětným lomítkem.");
                continue;
            default:
                # Zpracování bílých znaků
                break;
        }
        VYSTUP = VYSTUP C;
        VSTUP = substr(VSTUP, 2);
    }

    return VYSTUP;
}

BEGIN {
    FS = "\t";
    OFS = "";
    RS = ORS = "\n";

    delete idkapitol;       # [ARGIND] => "id-kapitoly"
    delete funkce_puvod;    # [jméno_funkce] => "id-kapitoly"
    delete funkce_definice; # [jméno_funkce] => "definice\n"
    delete skripty_puvod;   # [jméno-skriptu] => "id-kapitoly"
    delete skripty_definice;# [jméno-skriptu] => "definice\n"
    delete skripty_x;       # [jméno-skriptu] => 0 (jen k vypsání) nebo 1 (ke spuštění)

    typ = "";
    jmeno = "";
    telo = "";

    NacistFragmentyTSV("soubory_prekladu/fragmenty.tsv");
    i = 1;
    while (i in FRAGMENTY) {
        if (FRAGMENTY[i "/adr"] == "kapitoly") {
            f = "kapitoly/" FRAGMENTY[i "/id"] ".md";
            if (!Test("-r " f)) {
                ShoditFatalniVyjimku("Nemohu číst ze souboru " f "!");
            }
            idkapitol[ARGC] = $2;
            ARGV[ARGC++] = f;
        }
        ++i;
    }
    if (i > 1) {
        print "=== Zahajuji extrakci pomocných funkcí a skriptů. ===";
    }
}

BEGINFILE {
    zapnuto = 0;
    if (LADENI) {print "LADĚNÍ: otevírám soubor " FILENAME > "/dev/stderr"}
}

# vynechat zakomentované úseky
/^<!--$/,/^-->$/ {next}

/^## / {
    bylo_zapnuto = zapnuto;
    zapnuto = /^\043\043 Pomocné (funkce|skripty)( *a( | |&nbsp;)(funkce|skripty))?(\s+\([^)]*\))?$/;
    if (LADENI) {
        if (!zapnuto != !bylo_zapnuto) {
            print "LADĚNÍ: " (bylo_zapnuto ? "vypínám" : "zapínám") " pro řádek \"" $0 "\"." > "/dev/stderr";
        } else {
            printf("(=%s)\n", $0);
        }
    }
}

# dál pokračovat, jen je-li načítání zapnuté
!zapnuto {next}

# pomocný skript: /^\*#\s*lkk\s+()([-A-Za-z0-9]+)\s*–\s*(\S.*\S)\s*\*<br>$/
# pomocná funkce: /^\*#\s*(([A-Za-z0-9]|\\_)+)\(\)\s*–\s*(\S.*\S)\s*\*<br>$/
# pomocný úryvek: /^\*#\s*lkk\s+(-p\s+)([-A-Za-z0-9]+)\s*–\s*(\S.*\S)\s*\*<br>$/

# kvůli zvýrazňování syntaxe používám v regulárních výrazech \043 jako náhradu za znak „#“

# SKRIPTY:
(data_retezec = gensub(/^\*\043\s*lkk\s+(-p\s+)?([A-Za-z0-9][-A-Za-z0-9]*)\s*–\s*(\S[^\t]*\S)\s*\*<br>$/, "\\1\t\\2\t\\3", 1)) != $0 {
    split(data_retezec, data_pole);
    jmeno = data_pole[2];
    popis = data_pole[3];
    typ = data_pole[1] == "" ? "SKRIPT" : "URYVEK";
    if (LADENI) {print "LADÉNÍ: " typ " \"" jmeno "\" = \"" popis "\"" > "/dev/stderr"}
    next;
}

# FUNKCE:
(data_retezec = gensub(/^\*\043\s*(([A-Za-z0-9]|\\_)+)\(\)\s*–\s*(\S.*\S)\s*\*<br>$/, "\\1\t\\3", 1)) != $0 {
    i = index(data_retezec, "\t");
    jmeno = gensub(/\\_/, "_", "g", substr(data_retezec, 1, i - 1));
    popis = substr(data_retezec, i + 1);
    typ = "FUNKCE";
    if (LADENI) {print "LADĚNÍ: " typ " \"" jmeno "\" = \"" popis "\"" > "/dev/stderr"}
    next;
}

/^\*\043\s.*\*<br>$/ {
    ShoditFatalniVyjimku("Řádek nerozpoznán v režimu pomocných funkcí, skriptů a úryvků: " $0);
}

jmeno != "" && /^(<odsadit[1-8]>)?\*\*.*\*\*(<br>)?$/ {
    jePosledni = !/<br>$/;
    if (/^<odsadit[1-8]>/) {
        $0 = "**" Zopakovat("\t", substr($0, 9, 1)) substr($0, 13);
    }
    telo = telo ZpracujZnaky(substr($0, 3, length($0) - (jePosledni ? 4 : 8))) "\n";
    if (jePosledni) {
# konec definice
        if (typ == "FUNKCE") {
            if (jmeno in funkce_puvod) {
                if (funkce_definice[jmeno] == telo) {
                    print "VAROVÁNÍ: Opakovaná (ale identická) definice pomocné funkce " jmeno "() v kapitole " idkapitol[ARGIND] ", původně definována v kapitole " funkce_puvod[jmeno] "." > "/dev/stderr";
                } else {
                    ShoditFatalniVyjimku("Opakovaná definice pomocné funkce " jmeno "()!");
                }
            }
            funkce_puvod[jmeno] = idkapitol[ARGIND];
            funkce_definice[jmeno] = telo;
        } else {
            if (jmeno in skripty_puvod) {
                if (skripty_definice[jmeno] == telo) {
                    print "VAROVÁNÍ: Opakovaná (ale identická) definice pomocného skriptu " jmeno " v kapitole " idkapitol[ARGIND] ", původně definován v kapitole " skripty_puvod[jmeno] "." > "/dev/stderr";
                } else {
                    ShoditFatalniVyjimku("Opakovaná definice pomocného skriptu" jmeno "!");
                }
            }
            skripty_puvod[jmeno] = idkapitol[ARGIND];
            skripty_definice[jmeno] = telo;
            skripty_x[jmeno] = (typ == "SKRIPT" ? 1 : 0);
        }
        delka = length(gensub(/[^\n]/, "", "g", telo));
        print "V kapitole " idkapitol[ARGIND] " nalezen" (typ == "FUNKCE" ? "a funkce " jmeno "()" : typ == "SKRIPT" ? " skript " jmeno : " úryvek " jmeno) "; definici tvoří " (delka == 1 ? "1 řádek" : delka " řádk" (1 < delka && delka < 5 ? "y" : "ů")) ".";
        jmeno = "";
        popis = "";
        telo = "";
    }
}

END {
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
    if (length(funkce_puvod) + length(skripty_puvod) > 0) {
        for (s in skripty_puvod) {
            fn = "soubory_prekladu/deb/usr/share/lkk/skripty/" s;
            printf("%s", skripty_definice[s]) > fn;
            close(fn);
            system("chmod " (skripty_x[s] ? "755" : "644") " " fn);
        }
        asorti(funkce_puvod, jmena_funkci);
        fn = "soubory_prekladu/deb/usr/share/lkk/skripty/pomocne-funkce";
        print "# Pomocné funkce pro projekt Linux: Kniha kouzel. Tento soubor byl automaticky vygenerován.\n#" > fn;
        for (i = 1; i <= length(jmena_funkci); ++i) {
            printf("#začátek %s\n%s#konec %s\n", jmena_funkci[i], funkce_definice[jmena_funkci[i]], jmena_funkci[i]) > fn;
        }
        close(fn);
    }
    print "=== Extrakce pomocných funkcí a skriptů dokončena. ===\nPočty nalezených funkcí a skriptů+úryvků: " length(funkce_puvod) " a " length(skripty_puvod) ".";
}
