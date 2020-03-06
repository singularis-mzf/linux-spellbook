# Linux Kniha kouzel, skript postprocess.awk
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

BEGIN {
    if (ARGC != 3) {
        ShoditFatalniVyjimku("Chybný počet parametrů: " (ARGC - 1));
    }
    if (ARGV[2] !~ /\/[-_A-Za-z0-9]+\.[a-z]+$/) {
        ShoditFatalniVyjimku("Druhý parametr má chybný tvar: nedokážu vyextrahovat id z \"" ARGV[2] "\"!");
    }
    if (IDFORMATU == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná IDFORMATU není nastavena pomocí parametru -v!");
    }

    LOG_SOUBOR = gensub(/[^\/]*$/, "postprocess.log", 1, ARGV[1]);
    IDKAPITOLY = gensub(/^.*\/|\.[a-z]*$/, "", "g", ARGV[2]);
    prikaz = "date \"+%F %T %z\"";
    cas = "";
    prikaz | getline cas;
    close(prikaz);

    OFS = "";
    ORS = "\n";

    pocet_nahrad = 0;
    delete nahrady;         # [pův.text] = id-náhrady
    delete nahrady_cil;     # [id-náhrady] = opravený text
    delete nahrady_vyskyty; # [id-náhrady] = počet nahrazení
}

BEGINFILE {
    switch (ARGIND) {
        case 1: # postprocess.dat
            Log("Inicializace postprocessingu \"" cas "\" zahájena.");
            FS = "\n";
            RS = "";
            break;
        case 2: # {id}.md
            if (pocet_nahrad == 0) {
                Log("\"" cas "\" − nenalezeny žádné odpovídající náhrady.");
            }
            FS = "\t";
            RS = "\n";
            switch (pocet_nahrad) {
                case 1:
                    Log("Postprocessing spuštěn. Bude vyhledávána 1 náhrada.");
                    break;
                case 2: case 3: case 4:
                    Log("Postprocessing spuštěn. Budou vyhledávány " pocet_nahrad " náhrady.");
                    break;
                default:
                    Log("Postprocessing spuštěn. Bude vyhledáváno " pocet_nahrad " náhrad.");
            }
            break;
        default:
            ShoditFatalniVyjimku("Neplatná hodnota ARGIND: " ARGIND);
    }
}

ARGIND == 2 { # {id}.md
    if (pocet_nahrad != 0 && $0 in nahrady) {
        idnahrady = nahrady[$0];
        ++nahrady_vyskyty[idnahrady];
        print nahrady_cil[idnahrady];
        Log("[" nahrady_vyskyty[idnahrady] "] Na řádku " FNR " použita náhrada id " idnahrady " (" length($0) " >> " length(nahrady_cil[idnahrady]) ").");
    } else {
        print $0;
    }
    posledni_radek = FNR;
    next;
}

ENDFILE {
    if (ARGIND == 2) {
        for (nahrada in nahrady) {
            idnahrady = nahrady[nahrada];
            Log("Náhrada id=" idnahrady ": počet použití = " nahrady_vyskyty[idnahrady] (nahrady_vyskyty[idnahrady] == 1 ? "." : "!!!!!!!!"));
        }
        Log("Končím − postprocessing \"" cas "\" proběhl úspěšně (počet řádků: " posledni_radek ").");
    }
}

# Formát postprocess.dat:
#
# $1 = id opravy
# $2 = formát (regulární výraz; IDFORMATU musí být přesná shoda)
# $3 = id kapitoly (musí odpovídat IDKAPITOLY)
# $4 = původní řádek
# $5 = opravený řádek
# záznamy, jejichž $1 začíná znakem # jsou při načítání ignorovány

$0 ~ /^$|^#/ {next}
NF < 5 {
    ShoditFatalniVyjimku("Chybný záznam v konfiguraci postprocessingu: NF = " NF ", ID = \"" $1 "\"");
}
NF > 5 {print "VAROVÁNÍ: ", "NF = ", NF, "!" > "/dev/stderr"}
$4 == $5 {ShoditFatalniVyjimku("Chybná náhrada id " $1 ": řádek se nemění!")}

IDFORMATU ~ ("^(" $2 ")$") && $3 == IDKAPITOLY {
    if ($4 in nahrady) {
        ShoditFatalniVyjimku("Víceznačná náhrada pro stejný text: id " nahrady[$4] " a " $1 "!");
    }
    if ($1 in nahrady_cil) {
        ShoditFatalniVyjimku("ID náhrady se opakuje: " $1);
    }
    # Přidat náhradu:
    nahrady[$4] = idnahrady = $1;
    nahrady_cil[$1] = $5;
    nahrady_vyskyty[$1] = 0;
    ++pocet_nahrad;
}

END {
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
}

function Log(text, jenSoubor,   s) {
    s = sprintf("* %s:%s: %s\n", IDFORMATU, IDKAPITOLY, text);
    if (!jenSoubor || LOG_SOUBOR == "") {
        printf("%s", s) > "/dev/stderr";
    }
    if (LOG_SOUBOR != "") {
        printf("%s", s) >> LOG_SOUBOR;
    }
    return 0;
}

#function OdpovidaIdFormatu(vzorek) {
#    if (pozice = index(vzorek, "*")) {
#        return length(IDFORMATU) >= length(vzorek) - 1 && \
#            SubstrZleva(IDFORMATU, pozice - 1) == SubstrZleva(vzorek, pozice - 1) && \
#            SubstrZprava(IDFORMATU, length(vzorek) - pozice) == SubstrZprava(vzorek, length(vzorek) - pozice);
#    } else {
#        return IDFORMATU == vzorek;
#    }
#}

