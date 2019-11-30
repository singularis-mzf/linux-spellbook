# Linux Kniha kouzel, skript extrahovat-pomocne-funkce.awk
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
    delete idkapitol;
    delete funkce_puvod;
    delete funkce_definice;
    delete skripty_puvod;
    delete skripty_definice;

    typ = "";
    jmeno = "";
    telo = "";
}

BEGINFILE {
    zapnuto = 0;
    if (ARGIND == 3) {
        print "=== Zahajuji extrakci pomocných funkcí a skriptů. ===";
    }
}

# zvláštní zpracování pro fragmenty.tsv
ARGIND < 2 {
    if ($1 == "kapitoly") {
        f = "kapitoly/" $2 ".md";
        if (system("test -r " f)) {
            ShoditFatalniVyjimku("Nemohu číst ze souboru " f "!");
        }
        idkapitol[ARGC] = $2;
        ARGV[ARGC++] = f;
    }
    next;
}


# pro jakýkoliv nadpis druhé úrovně vypnout načítání funkcí a skriptů
/^## / {
#    if (zapnuto) {
#        print "DEBUG: končím blok pomocných funkcí a skriptů v souboru " FILENAME ".";
#    }
    zapnuto = 0;
}

# pro vybrané nadpisy druhé úrovně zapnout načítání funkcí a skriptů
/^## Pomocné (funkce|skripty)( *a( | |&nbsp;)(funkce|skripty))?$/ {
    zapnuto = 1;
#    print "DEBUG: začínám blok pomocných funkcí a skriptů v souboru " FILENAME ".";
}

# dál pokračovat, jen je-li načítání zapnuté
!zapnuto {next;}

/^\*# ([-A-Za-z~/.]|\\.)+.*\*<br>$/ {
    $0 = ZpracujZnaky(substr($0, 4, length($0) - 8));
    match($0, /^([-A-Za-z~/._]|\\.)*/);
    jmeno = substr($0, 1, RLENGTH);
    typ = (substr($0, 1 + RLENGTH, 2) == "()" ? "FUNKCE" : "SKRIPT");
    telo = "";

#    print "DEBUG: " typ " \"" jmeno "\".";
    next;
}

jmeno != "" && /^\*\*.*\*\*(<br>)?$/ {
    jePosledni = !/<br>$/;
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
            if (!(jmeno ~ /^~\/bin\/[-A-Za-z_.]+$/)) {
                ShoditFatalniVyjimku("Nepodporované jméno pomocného skriptu \"" jmeno "\"; jméno skriptu musí začínat ~/bin/ a být tvořeno pouze znaky [-A-Za-z_.] (bez hranatých závorek).");
            }
            if (jmeno in skripty_puvod) {
                if (skripty_definice[jmeno] == telo) {
                    print "VAROVÁNÍ: Opakovaná (ale identická) definice pomocného skriptu " jmeno " v kapitole " idkapitol[ARGIND] ", původně definován v kapitole " skripty_puvod[jmeno] "." > "/dev/stderr";
                } else {
                    ShoditFatalniVyjimku("Opakovaná definice pomocného skriptu" jmeno "!");
                }
            }
            skripty_puvod[jmeno] = idkapitol[ARGIND];
            skripty_definice[jmeno] = telo;
        }
        delka = telo;
        gsub(/[^\n]/, "", delka);
        delka = length(delka);
        print "V kapitole " idkapitol[ARGIND] " nalezen" (typ == "FUNKCE" ? "a funkce " jmeno "()" : " skript " jmeno) "; definici tvoří " (delka == 1 ? "1 řádek" : delka " řádk" (1 < delka && delka < 5 ? "y" : "ů")) ".";
        jmeno = "";
    }
}

END {
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
    if (length(funkce_puvod) + length(skripty_puvod) > 0) {
        for (s in skripty_puvod) {
            fn = s;
            gsub("^~", "vystup_prekladu", fn);
            printf("%s", skripty_definice[s]) > fn;
            close(fn);
            system("chmod u+x " fn);
        }
        asorti(funkce_puvod, jmena_funkci);
        fn = "vystup_prekladu/bin/pomocne-funkce.sh";
        print "# Pomocné funkce pro projekt Linux: Kniha kouzel. Tento soubor byl automaticky vygenerován.\n#" > fn;
        for (i = 1; i <= length(jmena_funkci); ++i) {
            print "" > fn;
            print funkce_definice[jmena_funkci[i]] > fn;
        }
        close(fn);
    }
    print "=== Extrakce pomocných funkcí a skriptů dokončena. ===\nPočty nalezených funkcí a skriptů: " length(funkce_puvod) " a " length(skripty_puvod) ".";
}
