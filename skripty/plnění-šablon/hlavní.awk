# Linux Kniha kouzel, skript plnění-šablon/hlavní.awk
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

BEGIN {
    FS = OFS = "\t";
    RS = ORS = "\n";
    BYL_ZACATEK = 0;
    if (VARIANTA == "") {VARIANTA = "bez-nazvu"}
    STAV_PODMINENENO_PREKLADU = 0;
}

function VyzadujeFragmentyTSV() {
    if (POCET_KAPITOL) {return POCET_KAPITOL}
    FRAGMENTY_TSV = ENVIRON["SOUBORY_PREKLADU"] "/fragmenty.tsv";
    if (!Test("-r " FRAGMENTY_TSV)) {
        ShoditFatalniVyjimku("Nemohu číst ze souboru " FRAGMENTY_TSV "!");
    }
    if (IDKAPITOLY != "" && PrvekPole(ENVIRON, "REKLAMNI_PATY", "0"))
    {
        REKLAMNI_PATA = PrecistKonfig("Reklamní-Paty", IDKAPITOLY, "");
        if (REKLAMNI_PATA == "") {REKLAMNI_PATA = PrecistKonfig("Reklamní-Paty", "výchozí", "")}
        if (REKLAMNI_PATA == "-") {REKLAMNI_PATA = ""}
    } else {
        REKLAMNI_PATA = "";
    }
    return POCET_KAPITOL = NacistFragmentyTSV(FRAGMENTY_TSV);
}

function VyzadujePromennou(nazev, popisChyby) {
    if (SYMTAB[nazev] == "") {
        ShoditFatalniVyjimku(popisChyby == "" ? "Vyžadovaná proměnná " nazev " není nastavena!" : popisChyby);
    }
    return 1;
}

$0 == "{{ZAČÁTEK}}" {
    if (!BYL_ZACATEK) {
        BYL_ZACATEK = 1;
        $0 = "";
        Zacatek();
        STAV_PODMINENENO_PREKLADU = (VARIANTA == "bez-nazvu" ? 0 : 3);
        next;
    } else {
        ShoditFatalniVyjimku("Opakovaný {{ZAČÁTEK}}!");
    }
}

!BYL_ZACATEK && /^\{\{[^{}]+\}\}$/ {
    ShoditFatalniVyjimku("První řídicí řádek šablony musí být {{ZAČÁTEK}}!");
}

# Zpracování variant ({{VARIANT[AY] ...}})
# ====================================================
(s = gensub(/^\{\{VARIANT[AY] ([^{}]+)\}\}$/, ",\\1,", 1)) != $0 {
    if (STAV_PODMINENENO_PREKLADU != 0 && STAV_PODMINENENO_PREKLADU != 3) {
        ShoditFatalniVyjimku("Uvnitř bloku {{POKUD ...}} nelze přepínat variantu!");
    }
    STAV_PODMINENENO_PREKLADU = (index(s, "," VARIANTA ",") ? 0 : 3);
    #print $0 ": Měním STAV_PODMINENENO_PREKLADU na " STAV_PODMINENENO_PREKLADU > "/dev/stderr";
    next;
}

STAV_PODMINENENO_PREKLADU == 3 {next}

# Podmíněný překlad
# ====================================================
# 0 - mimo podmíněný blok
# 1 - v podmíněném bloku, ale tiskne se
# 2 - v podmíněném bloku, přeskakuje se
# 3 - mimo podmíněný blok, ale řádek nepřísluší aktivní variantě šablony
#
/^\{\{POKUD .*\}\}$/ {
    if (STAV_PODMINENENO_PREKLADU != 0) {
        ShoditFatalniVyjimku("Chyba syntaxe: {{POKUD ...}} bez ukončení předchozího podmíněného bloku!");
    }

    # Zvláštní obsluha pro tvar „{{POKUD (JE|NENÍ) FORMÁT abc|def}}“. Vyžaduje proměnnou IDFORMATU.
    if ($0 ~ /^\{\{POKUD JE FORMÁT ./) {
        if (IDFORMATU == "") {
            ShoditFatalniVyjimku("Podmínka " $0 " a proměnná IDFORMATU není nastavena!");
        }
        STAV_PODMINENENO_PREKLADU = index("|" substr($0, 19, length($0) - 20) "|", "|" IDFORMATU "|") ? 1 : 2;
        next;
    }
    if ($0 ~ /^\{\{POKUD NENÍ FORMÁT ./) {
        if (IDFORMATU == "") {
            ShoditFatalniVyjimku("Podmínka " $0 " a proměnná IDFORMATU není nastavena!");
        }
        STAV_PODMINENENO_PREKLADU = index("|" substr($0, 21, length($0) - 22) "|", "|" IDFORMATU "|") ? 2 : 1;
        next;
    }

    switch ($0)
    {
        case "{{POKUD JSOU PRÉMIOVÉ KAPITOLY}}":
            STAV_PODMINENENO_PREKLADU = (system("test -s '" ENVIRON["SOUBORY_PREKLADU"] "/prémiové-kapitoly.tsv'") == 0) ? 1 : 2;
            next;
        case "{{POKUD MÁ REKLAMNÍ PATU}}":
            STAV_PODMINENENO_PREKLADU = REKLAMNI_PATA != "" ? 1 : 2;
            next;
        default:
            STAV_PODMINENENO_PREKLADU = Pokud(substr($0, 9, length($0) - 10)) ? 1 : 2;
            next;
    }
}

/^\{\{KONEC POKUD\}\}$/ {
    if (STAV_PODMINENENO_PREKLADU != 0) {
        STAV_PODMINENENO_PREKLADU = 0;
        #print "LADĚNÍ: " $0 " => STAV_PODMINENENO_PREKLADU = " STAV_PODMINENENO_PREKLADU " (" IDFORMATU ")" > "/dev/stderr";
        next;
    } else {
        ShoditFatalniVyjimku("{{KONEC POKUD}} bez odpovídajícího začátku");
    }
}

STAV_PODMINENENO_PREKLADU == 2 {next}

# Řídicí řádky
# ====================================================
/^\{\{[^{}]+\}\}$/ {
    $0 = substr($0, 3, length($0) - 4);
    if ($0 == "KONEC") {exit}
    RidiciRadek($0);
    next;
}

/^\{\{[^{}]+=.*\}\}$/ {
    # zkontrolovat uzávorkování:
    l = 0;
    for (i = index($0, "=") + 1; i <= length($0) - 2; ++i) {
        switch (substr($0, i, 1)) {
            case "{":
                ++l;
                break;
            case "}":
                if (--l < 0) {ShoditFatalniVyjimku("Chybné uzávorkování řídicího řádku: " $0)}
                break;
            default:
                break;
        }
    }
    if (l != 0) {ShoditFatalniVyjimku("Chybné uzávorkování řídicího řádku: " $0)}
    RidiciRadek($0 = substr($0, 3, length($0) - 4));
    next;
}

# Obyčejné řádky
# ====================================================
BYL_ZACATEK {
    print PrelozitVystup($0);
}

# Společná obsluha pro řídicí řádky
# ====================================================
function RidiciRadekSpolecnaObsluha(text,   i, soubor) {
    switch (text) {
        case "MENU OSNOVA":
            if (IDFORMATU != "html") {ShoditFatalniVyjimku("{{MENU OSNOVA}} je podporováno jen pro formát HTML!")}
            if (IDKAPITOLY ~ /^(_|$)/) {
                printf("<div class=\"text\">Menu Osnova má smysl pouze na stránkách kapitol a některých dodatků.</div>\n");
                return 0;
            }
            VyzadujeFragmentyTSV();
            soubor = gensub(/fragmenty\.tsv$/, "osnova/" gensub(/\//, "-", 1, IDKAPITOLY) ".tsv", 1, FRAGMENTY_TSV);
            if (system("test -r '" soubor "'")) {
                ShoditFatalniVyjimku("Soubor '" soubor "' neexistuje nebo nelze otevřít ke čtení!");
            }
            while (getline < soubor) {
                # $1 = {SEKCE|PODSEKCE}, $2 = číselné označení, $4 = titulek
                switch ($1) {
                    case "SEKCE":
                    case "PODSEKCE":
                        # TODO: přeložit údaje do HTML (zejména entity jako &amp;)
                        printf("<a href=\"#cast%s\" class=\"%s\">%s %s</a>\n", $2, $1 == "SEKCE" ? "sekce" : "podsekce", ($1 == "SEKCE" ? "" : "/") gensub(/^.*[^[:digit:]]/, "", 1, $2), $4);
                        break;
                    default:
                        break;
                }
            }
            close(soubor);
            #printf("<div>DEBUG: osnova kapitoly %s.</div>\n", IDKAPITOLY);
            return 0;

        case "MENU KAPITOLY":
            if (IDFORMATU != "html") {ShoditFatalniVyjimku("{{MENU KAPITOLY}} je podporováno jen pro formát HTML!")}
            VyzadujeFragmentyTSV();
            for (i = 1; FragInfo(i, "existuje"); ++i) {
                printf("<a href=\"%s.htm\" class=\"kapitola\"><span class=\"ikona\"><img src=\"obrazky/%s\" alt=\"[]\"></span><span class=\"cislo\">%d</span><span class=\"nazev\">%s</span></a>\n", FragInfo(i, "ploché-id-bez-diakr"), OmezitNazev(FragInfo(i, "ikona-kapitoly"), 1), i, FragInfo(i, "celý-název"));
            }
            jsou_premiove = 0;
            soubor = ENVIRON["SOUBORY_PREKLADU"] "/prémiové-kapitoly.tsv";
            while (getline < soubor) {
                if (!jsou_premiove) {
                    jsou_premiove = 1;
                    printf("%s\n", "<div class=\"premiove\"><strong>Prémiové kapitoly:</strong>");
                }
                printf("<div>%s</div>\n", $2);
            }
            close(soubor);
            if (jsou_premiove) {
                printf("%s %s\n", "</div><p>Tyto kapitoly můžete získat jako odměnu za překlad ze zdrojového kódu. Podrobnější informace",
                       "<a href=\"https://github.com/singularis-mzf/linux-spellbook/blob/stabiln%C3%AD/dokumentace/odm%C4%9Bna-za-sestaven%C3%AD.md\">na GitHubu</a>.</p>");
            }
            return 0;

        case "MENU ŠTÍTKY":
            if (IDFORMATU != "html") {ShoditFatalniVyjimku("{{MENU ŠTÍTKY}} je podporováno jen pro formát HTML!")}
            VyzadujeFragmentyTSV();
            stitky_tsv = gensub(/fragmenty/, "štítky", 1, FRAGMENTY_TSV);
            while (getline < stitky_tsv) {
                if (NF < 3) {ShoditFatalniVyjimku("Chyba formátu štítky.tsv: očekávány alespoň tři sloupce!")}
                # $1 = štítek $2 = omezené id štítku
                printf("<a href=\"x-stitky.htm#%s\">%s&nbsp;&nbsp;(%d)</a>\n", $2, $1, NF - 2);
            }
            close(stitky_tsv);
            return 0;

        case "MENU NÁPOVĚDA":
            if (IDFORMATU != "html") {ShoditFatalniVyjimku("{{MENU NÁPOVÉDA}} je podporováno jen pro formát HTML!")}
            VyzadujeFragmentyTSV();
            cislo = FragInfo("předmluva");
            if (FragInfo(cislo, "příznaky") ~ /z/) {
                printf("<a href=\"%s.htm\">%s</a>\n", FragInfo(cislo, "ploché-id-bez-diakr"), FragInfo(cislo, "celý-název"));
            }
            cislo = FragInfo("koncepce-projektu");
            if (FragInfo(cislo, "příznaky") ~ /z/) {
                printf("<a href=\"%s.htm\">%s</a>\n", FragInfo(cislo, "ploché-id-bez-diakr"), FragInfo(cislo, "celý-název"));
            }
            printf("%s\n%s\n%s\n", "<a href=\"https://singularis-mzf.github.io/\">Ostatní verze knihy</a>",
                "<a href=\"https://github.com/singularis-mzf/linux-spellbook\">Repozitář na GitHubu</a>",
                "<a href=\"https://github.com/singularis-mzf/linux-spellbook/blob/stabiln%C3%AD/dokumentace/odm%C4%9Bna-za-sestaven%C3%AD.md\">Odměna za sestavení (prémiové kapitoly)</a>");
            return 0;

        default:
            ShoditFatalniVyjimku("Neznámý řídicí řádek: {{" text "}}!");
    }
}

END {
    if (!FATALNI_VYJIMKA && !BYL_ZACATEK) {
        ShoditFatalniVyjimku("Vadná šablona: nebyl začátek!");
    }
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
    Konec();
}
