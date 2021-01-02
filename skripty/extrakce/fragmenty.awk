# Linux Kniha kouzel, skript extrakce/fragmenty.awk
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

BEGIN {
    delete vyskyty;     # [id] -> 1; slouží ke kontrole duplicity v poradi-kapitol.lst
    delete vyskyty_oi;  # [omezeneid] -> id; slouží ke kontrole duplicit v omezeném ID

    delete id;          # [index] -> id
    delete omezeneid;   # [index] -> omezené id ("kapx" + id, jen znaky [a-z0-9])
    delete adresar;     # [index] -> dodatky|kapitoly
    delete nazev;       # [index] -> název dodatku či kapitoly (ne id)
    delete stitky;      # [index] -> štítky bez pořadí, nebo ""
    delete serazene_stitky; # [index] -> štítky po seřazení

    # štítky:
    delete poradi_stitku; # [štítek] -> pořadí štítků (do seřazení vždy 1)
    delete vsechny_stitky; # [pořadí] -> štítek

    # vydané kapitoly:
    delete premiove_kapitoly; # [id] -> 1
    soubor = "pořadí-kapitol.vydané.lst";
    if (Test("-r " soubor)) {
        while (getline s < soubor) {
            if (s ~ /^[^#]/ && Test("-r kapitoly/" s ".md")) {
                premiove_kapitoly[s] = 1;
            }
        }
        close(soubor);
    }
}
BEGINFILE {
    # číslo kapitoly
    c_kapitoly = (ARGIND < 2) ? 0 : ARGIND - 1;
}

# zpracování pořadí-kapitol.lst
ARGIND < 2 {
    if ($0 == "" || substr($0, 1, 1) == "#") {
        next;
    }
    if (/[^-_aábcčdďeéěfghiíjklmnňoópqrřsštťuúůvwxyýzž0123456789]/) {
        ShoditFatalniVyjimku("Řádek obsahuje znak, který není povolený v ID kapitoly či dodatku! Povolena jsou pouze malá písmena české abecedy, arabské číslice a znaky - a _.");
    }
    if ($0 in vyskyty) {
        print "VAROVÁNÍ: ID dodatku či kapitoly \"" $0 "\" se v souboru poradi-kapitol.lst opakuje! Bude použit pouze první výskyt." > "/dev/stderr";
        next;
    }

    vyskyty[$0] = 1;
    existuje_kapitola = Test("-r kapitoly/" $0 ".md");
    existuje_dodatek = Test("-r dodatky/" $0 ".md");

    id[++c_kapitoly] = $0;
    omezeneid[c_kapitoly] = GenerovatOmezeneId("kapx", $0);
    if (omezeneid[c_kapitoly] in vyskyty_oi) {
        ShoditFatalniVyjimku("Konflikt pro omezené ID " omezeneid[c_kapitoly] " mezi " vyskyty_oi[c_kapitoly] " a " $0 "!");
    }
    vyskyty_oi[omezeneid[c_kapitoly]] = $0;
    if (existuje_dodatek && !existuje_kapitola) {
        adresar[c_kapitoly] = "dodatky";
    } else if (!existuje_dodatek && existuje_kapitola) {
        adresar[c_kapitoly] = "kapitoly";
        delete premiove_kapitoly[$0]; # vyřadit z prémiových kapitol
    } else if (existuje_dodatek) {
        ShoditFatalniVyjimku("ID \"" $0 "\" existuje jako dodatek i jako kapitola!");
    } else {
        ShoditFatalniVyjimku("Dodatek ani kapitola " $0 ".md neexistuje!");
    }
    ARGC = c_kapitoly + 2;
    ARGV[c_kapitoly + 1] = adresar[c_kapitoly] "/" $0 ".md";
    nazev[c_kapitoly] = "";
    stitky[c_kapitoly] = "";
    serazene_stitky[c_kapitoly] = "";
    pocet_kapitol = c_kapitoly;
    #print "LADĚNÍ: Počet kapitol: " (c_kapitoly - 1) " => " c_kapitoly " (" id[c_kapitoly] ")" > "/dev/stderr";
    next;
}

# následuje zpracování pro jednotlivé kapitoly a dodatky:
nazev[c_kapitoly] == "" && /^# ./ \
{
    if (nazev[c_kapitoly] != "") {
        print "VAROVÁNÍ: Soubor " FILENAME " obsahuje víc nadpisů první úrovně. Pouze první bude použit jako název!" > "/dev/stderr";
        next;
    }
    nazev[c_kapitoly] = substr($0, 3);
    if (nazev[c_kapitoly] ~ /\t/) {
        ShoditFatalniVyjimku("Název v souboru " FILENAME " obsahuje tabulátor, což není dovoleno!");
    }
}

adresar[c_kapitoly] == "kapitoly" && match(toupper($0), /^!ŠTÍTKY:( |$)/) {
    s = substr($0, 1 + RLENGTH);
    if (s !~ /^(\{[A-Za-z0-9ÁČĎÉĚÍŇÓŘŠŤŮÝŽáčďéěíňóřšťůýž ]+\})*$/) {
        ShoditFatalniVyjimku("Chybný formát štítků v " FILENAME ": " $0);
    }
    stitky[c_kapitoly] = stitky[c_kapitoly] s;
    n = split(gensub(/^\{|\}$/, "", "g", stitky[c_kapitoly]), kapstitky, /\}\{/);
    for (i = 1; i <= n; ++i) {
        if (kapstitky[i] == "") {ShoditFatalniVyjimku("Interní chyba: nečekaný prázdný řetězec.")}
        poradi_stitku[kapstitky[i]] = 0;
    }
}

ENDFILE {
    if (ARGIND >= 2) {
        if (nazev[c_kapitoly] == "") {
            ShoditFatalniVyjimku("Nepodařilo se zjistit název kapitoly či dodatku ze souboru " FILENAME "!");
        }
        if (!(stitky[c_kapitoly] ~ /^({[^{}]+})*$/)) {
            ShoditFatalniVyjimku("Chybné uzávorkování štítků ve " FILENAME ": " stitky[c_kapitoly]);
        }
    }
}

END {
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
    OFS = "\t";
    ORS = "\n";
    FRAGMENTY_TSV = "/dev/fd/3";
    STITKY_TSV = "/dev/fd/4";

    # Seřadit štítky (= vyplnit správně „poradi_stitku“):
    prikaz = "LC_ALL=\"cs_CZ.UTF-8\" sort -fu";
    for (stitek in poradi_stitku) {
        print stitek |& prikaz;
    }
    close(prikaz, "to");
    i = 0;
    while (prikaz |& getline stitek) {
        if (!(stitek in poradi_stitku)) {
            #for (s in poradi_stitku) {print "Známý štítek: >" s "<" > "/dev/stderr"}
            ShoditFatalniVyjimku("Příkaz sort vrátil neznámý štítek: {" stitek "}")
        }
        poradi_stitku[stitek] = ++i;
    }
    close(prikaz);
    for (stitek in poradi_stitku) {
        if (poradi_stitku[stitek] == 0) {ShoditFatalniVyjimku("Příkaz sort neseřadil štítek: " stitek)}
    }
    pocet_stitku = asorti(poradi_stitku, vsechny_stitky, "@val_num_asc");
    # vsechny_stitky = [1..pocet_stitku] => štítky
    # poradi_stitku = [štítky] => pořadí

    #
    # štítky.tsv
    # ----------
    for (c_stitku = 1; c_stitku <= pocet_stitku; ++c_stitku) {
        #
        # štítky.tsv:
        #   1=Štítek|2=Omezené ID štítku|3..N=ID kapitol
        #
        id_stitku = vsechny_stitky[c_stitku];
        omezene_id_stitku = GenerovatOmezeneId("s", id_stitku);
        if (omezene_id_stitku in vyskyty_oi) {
            ShoditFatalniVyjimku("Konflikt omezených ID štítků mezi {" vyskyty_oi[omezene_id_stitku] "} a {" id_stitku "}!");
        }
        vyskyty_oi[omezene_id_stitku] = id_stitku;
        s = id_stitku "\t" omezene_id_stitku;
        for (c_kapitoly = 1; c_kapitoly <= pocet_kapitol; ++c_kapitoly) {
            if (index(stitky[c_kapitoly], "{" id_stitku "}")) {
                s = s "\t" id[c_kapitoly];
                serazene_stitky[c_kapitoly] = serazene_stitky[c_kapitoly] "{" id_stitku "}";
            }
        }
        print s > STITKY_TSV;
    }
    close(STITKY_TSV);

    #
    # fragmenty.tsv
    # -------------
    for (i = 1; i <= pocet_kapitol; ++i) {
        # fragmenty.tsv (PŮVODNĚ):
        #   1=Adresář|2=ID|3=Název|4=Předchozí ID|5=Předchozí název|
        #   6=Následující ID|7=Následující název|
        #   8=Číslo dodatku/kapitoly|9=Štítky v {}|
        #   10=Omezené ID|11=ikona kapitoly ("ik_vychozi.png", nebo "ik/" + ID.png)
        #
        # fragmenty.tsv (nově):
        #   #1=Číslo|#2=ID|#3=Název|#4=Adresář|#5=Omezené ID|#6=ikona kapitoly (ik_vychozi.png, nebo ik/{id}.png)|#7=štítky v {}
        # Prázdná hodnota se nahrazuje „NULL“.
        #
        if (system("test -e obrázky/ik/" id[i] ".png") == 0) {
            ikonakapitoly = "ik/" id[i] ".png";
        } else {
            ikonakapitoly = "ik-výchozí.png";
        }

        print i, id[i], nazev[i], adresar[i], omezeneid[i], ikonakapitoly, serazene_stitky[i] == "" ? "NULL" : serazene_stitky[i] > FRAGMENTY_TSV;
    }

    #
    # prémiové-kapitoly.tsv:
    # ------------------
    pocet_premiovych_kapitol = length(premiove_kapitoly);
    soubor = ENVIRON["SOUBORY_PREKLADU"] "/prémiové-kapitoly.tsv";
    # Proměnná PREMIOVE_KAPITOLY se nastavuje parametrem -v při spouštění skriptu.
    if (pocet_premiovych_kapitol > 0 && PREMIOVE_KAPITOLY == 1) {
        prikaz = "LC_ALL=cs_CZ.UTF-8 sort -d -t '\t' -k 2 >'" soubor "'";
        for (idkapitoly in premiove_kapitoly) {
            nazevkapitoly = idkapitoly;
            soubor = "kapitoly/" idkapitoly ".md";
            while (getline s < soubor) {
                if (s ~ /^# ./) {
                    nazevkapitoly = substr(s, 3);
                    break;
                }
            }
            close(soubor);
            if (nazevkapitoly ~ /\t/) {
                ShoditFatalniVyjimku("Chyba: název kapitoly id <" idkapitoly "> obsahuje tabulátor, což je zakázáno!");
            }
            print idkapitoly, nazevkapitoly | prikaz;
        }
        close(prikaz);
    } else {
        system("true >'" soubor "'");
    }
}
