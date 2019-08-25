# Linux Kniha kouzel, skript hlavni.awk
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



# Tato funkce vezme řádek textu ve vstupním formátu (Markdown)
# a znak po znaku jej zkonvertuje do výstupního formátu.
# Používá se pro zpracování částí textu, které nepodporují formátování.
function ZpracujZnaky(text,     VSTUP, VYSTUP, ZNAK) {
    VSTUP = text;
    VYSTUP = "";
    
    while (VSTUP != "") {
        ZNAK = substr(VSTUP, 1, 1);
        if (ZNAK == "\\" && length(VSTUP) > 1) {
            VYSTUP = VYSTUP ZpracujZnak(substr(VSTUP, 2, 1));
            VSTUP = substr(VSTUP, 3);
        } else if (JeBilyZnak(ZNAK)) {
            VYSTUP = VYSTUP ZpracujBilyZnak(ZNAK, 0);
            while (VSTUP != "" && JeBilyZnak(C = substr(VSTUP = substr(VSTUP, 2), 1, 1))) {
                VYSTUP = VYSTUP ZpracujBilyZnak(C, 1);
            }
        } else {
            VYSTUP = VYSTUP ZpracujZnak(ZNAK);
            VSTUP = substr(VSTUP, 2);
        }
    }
    
    return VYSTUP;
}

# Tato funkce vezme řádek textu ve vstupním formátu a zpracuje všechno
# formátování na úrovni řádku. Výstupem je řádek ve výstupním formátu.
#
# Může využívat globálních proměnných TYP_RADKU a PREDCHOZI_TYP_RADKU.
# Lokálně používá zásobník "format".
function FormatovatRadek(text,   VSTUP, VYSTUP, i, C) {
    VSTUP = text;
    VYSTUP = "";
    VyprazdnitZasobnik("format");
    while (VSTUP != "") {
        # <br> (4 znaky)
        if (substr(VSTUP, 1, 4) == "<br>") {
            VYSTUP = VYSTUP KonecRadku();
            VSTUP = substr(VSTUP, 5);
            continue;
        }
        # 2 znaky
        switch (C = substr(VSTUP, 1, 2)) {
            case "**":
                if (Top("format") != "**") {
                    VYSTUP = VYSTUP FormatTucne(1);
                    Push("format", "**");
                } else {
                    VYSTUP = VYSTUP FormatTucne(0);
                    Pop("format");
                }
                VSTUP = substr(VSTUP, 3);
                continue;
            case "{*":
                if (VelikostZasobniku("format") != 0)
                    break;
                VYSTUP = VYSTUP FormatDopln(1);
                Push("format", "{*");
                VSTUP = substr(VSTUP, 3);
                continue;
            case "*}":
                if (VelikostZasobniku("format") != 1)
                    break;
                if (Pop("format") != "{*") {
                    ShoditFatalniVyjimku("Uzavřena neotevřená formátovací značka: {*..*}");
                }
                VYSTUP = VYSTUP FormatDopln(0);
                VSTUP = substr(VSTUP, 3);
                continue;
            default:
                break;
        }
        # 1 znak
        switch (C = substr(VSTUP, 1, 1)) {
            case "\\":
                VYSTUP = VYSTUP ZpracujZnak(substr(VSTUP, 2, 1));
                VSTUP = substr(VSTUP, 3);
                continue;
            case "[":
                if (match(VSTUP, /\[[^\]]+\][(][^)]+[)]/)) {
                    i = index(VSTUP, "](");
                    VYSTUP = VYSTUP HypertextovyOdkaz(substr(VSTUP, i + 2, RLENGTH - i - 2), substr(VSTUP, 2, i - 2));
                    VSTUP = substr(VSTUP, RLENGTH + 1);
                    continue;
                }
                break;
            case "*":
                if (Top("format") != "*") {
                    VYSTUP = VYSTUP FormatKurziva(1);
                    Push("format", "*");
                } else {
                    VYSTUP = VYSTUP FormatKurziva(0);
                    Pop("format");
                }
                VSTUP = substr(VSTUP, 2);
                continue;
            default:
                # Zpracování bílých znaků
                if (JeBilyZnak(C)) {
                    VYSTUP = VYSTUP ZpracujBilyZnak(C, 0);
                    while (VSTUP != "" && JeBilyZnak(C = substr(VSTUP = substr(VSTUP, 2), 1, 1))) {
                        VYSTUP = VYSTUP ZpracujBilyZnak(C, 1);
                    }
                    continue;
                }
                break;
        }
        VYSTUP = VYSTUP ZpracujZnak(C);
        VSTUP = substr(VSTUP, 2);
    }
    
    if (VelikostZasobniku("format") > 0) {
        ShoditFatalniVyjimku("Formátovací značka neuzavřena do konce řádku: " Top("format") "\nVstup: <" text ">\nVýstup: <" VYSTUP ">\n\n");
    }
    return VYSTUP;
}

# Tato funkce se volá pro první ze sekvence řádků určitého typu.
function ZacitTypRadku() {
    switch (TYP_RADKU) {
        case "NORMALNI":
            printf("%s", ZacatekOdstavce());
            break;
        case "POLOZKA_SEZNAMU":
            if (PREDCHOZI_TYP_RADKU != "POKRACOVANI_POLOZKY_SEZNAMU") {
                printf("%s", ZacatekSeznamu(1));
                printf("%s", ZacatekPolozkySeznamu(1));
            }
            break;
        default:
            break;
    }
}

# Tato funkce se volá po posledním ze sekvence řádků určitého typu.
# Slouží k řádnému uzavření konstrukcí typu začátek-oddělovač-konec.
function UkoncitPredchoziTypRadku() {
    switch (PREDCHOZI_TYP_RADKU) {
        case "NORMALNI":
            printf("%s", KonecOdstavce());
            return "";

        case "POLOZKA_SEZNAMU":
            if (TYP_RADKU != "POKRACOVANI_POLOZKY_SEZNAMU") {
                printf("%s", KonecPolozkySeznamu(1));
                printf("%s", KonecSeznamu(1));
            }
            return "";
            
        case "POKRACOVANI_POLOZKY_SEZNAMU":
            printf("%s", KonecPolozkySeznamu(1));
            if (TYP_RADKU != "POLOZKA_SEZNAMU") {
                printf("%s", KonecSeznamu(1));
            } else {
                printf("%s", ZacatekPolozkySeznamu(1));
            }
            return "";

        case "RADEK_PRIKLADU":
            printf("%s", KonecPrikladu());
            JE_UVNITR_PRIKLADU = 0;
            return "";

        default:
            return "";
    }
}

BEGIN {
    KAPITOLA = "";
    SEKCE = "";
    PODSEKCE = "";
    FATALNI_VYJIMKA = 0;
    TYP_RADKU = "PRAZDNY";
    JE_UVNITR_PRIKLADU = 0;
}

{
    PREDCHOZI_TYP_RADKU = TYP_RADKU;
    TYP_RADKU = "";
    ZPRACOVANO = 0;
}

# zaznamenat prázdný řádek
/^$/ {
    TYP_RADKU = "PRAZDNY";
}

# komentář se jako prázdný řádek nebere + uvnitř komentáře nic nezpracovávat
/^<!--$/,/^-->$/ {
    TYP_RADKU = "NEPRAZDNY";
    next;
}

# vyloučit nepovolené bílé znaky na začátku/konci řádku
/^[ \t\v\r\n]+$/ {
    ShoditFatalniVyjimku("Řádek tvořený pouze bílými znaky není v tomto projektu dovolen!\nŘádek: <" $0 ">");
}
/[ \t\v\r\n]$/ {
    ShoditFatalniVyjimku("Bílé znaky na konci řádku nejsou v tomto projektu dovoleny!\nŘádek: <" $0 ">");
}
/^[ \t\v\r\n]/ {
    ShoditFatalniVyjimku("Bílé znaky na začátku řádku nejsou v tomto projektu dovoleny!\nŘádek: <" $0 ">");
}

# vypustit z řádku inline komentáře (popř. je zpracovat)
/<!--.*-->/ { 
    while ((i = index($0, "<!--")) && (j = 4 + index(substr($0, i + 4), "-->"))) {
#        text_komentare = substr($0, i + 4, j - 5);
#        print "DEBUG: inline komentář <!--" text_komentare "-->.";

        $0 = substr($0, 1, i - 1) substr($0, i + j + 2);
    }
}       

# určit typ řádku, nebyl-li již určen
{
    if (TYP_RADKU != "") {
        # typ řádku již byl určen
    } else if ($0 ~ /^#+ .+/) {
        TYP_RADKU = "NADPIS";
    } else if (PREDCHOZI_TYP_RADKU != "NORMALNI" && $0 ~ /^\* .+/) {
        TYP_RADKU = "POLOZKA_SEZNAMU";
        $0 = substr($0, 3);
    } else if (PREDCHOZI_TYP_RADKU != "NORMALNI" && $0 ~ /^\*# .+\*<br>$/) {
        TYP_RADKU = "PRIKLAD";
        JE_UVNITR_PRIKLADU = 1;
    } else if (PREDCHOZI_TYP_RADKU != "NORMALNI" && $0 ~ /^\*\/\/ .+\*(<br>)?$/) {
        TYP_RADKU = "POZNAMKA";
    } else if (PREDCHOZI_TYP_RADKU != "NORMALNI" && $0 ~ /^!\[.+\]\(.+\)$/) {
        TYP_RADKU = "OBRAZEK";
    } else if (JE_UVNITR_PRIKLADU) {
        TYP_RADKU = "RADEK_PRIKLADU";
    } else if (PREDCHOZI_TYP_RADKU == "POLOZKA_SEZNAMU" || PREDCHOZI_TYP_RADKU == "POKRACOVANI_POLOZKY_SEZNAMU") {
        TYP_RADKU = "POKRACOVANI_POLOZKY_SEZNAMU";
    } else {
        TYP_RADKU = "NORMALNI";
    }
    
    # DEBUG:
    #printf("\n<TYP=%s>%s>", PREDCHOZI_TYP_RADKU, TYP_RADKU);
}

# pokud se typ řádku změnil, ukončit ten předchozí a zahájit nový
PREDCHOZI_TYP_RADKU != TYP_RADKU {
    UkoncitPredchoziTypRadku();
    ZacitTypRadku();
}

#
# ZPRACOVÁNÍ JEDNOTLIVÝCH TYPŮ ŘÁDKŮ
# ============================================================================
TYP_RADKU == "NADPIS" {
    if (PODSEKCE != "")
        printf("%s", KonecPodsekce(KAPITOLA, SEKCE, PODSEKCE));
    if (SEKCE != "" && $0 ~ /^##? /)
        printf("%s", KonecSekce(KAPITOLA, SEKCE));
    if (KAPITOLA != "" && $0 ~ /^# /)
        printf("%s", KonecKapitoly(KAPITOLA));
    if ($0 ~ /^# /) {
        KAPITOLA = substr($0, 3);
        SEKCE = "";
        PODSEKCE = "";
        printf("%s", ZacatekKapitoly(KAPITOLA));
    } else if ($0 ~ /^## /) {
        SEKCE = substr($0, 4);
        PODSEKCE = "";
        printf("%s", ZacatekSekce(KAPITOLA, SEKCE));
    } else {
        PODSEKCE = substr($0, 5);
        printf("%s", ZacatekPodsekce(KAPITOLA, SEKCE, PODSEKCE));
    }
    next;
}

TYP_RADKU == "OBRAZEK" {
# TODO: implementovat víc...
    printf("%s", ZnackaVeVystavbe());
    next;
}

TYP_RADKU == "NORMALNI" {
    printf("%s\n", FormatovatRadek($0));
    next;
}

TYP_RADKU == "POLOZKA_SEZNAMU" {
    if (PREDCHOZI_TYP_RADKU == TYP_RADKU) {
        printf("%s", KonecPolozkySeznamu(1));
        printf("%s", ZacatekPolozkySeznamu(1));
    }
    printf("%s\n", FormatovatRadek($0));
    next;
}

TYP_RADKU == "POKRACOVANI_POLOZKY_SEZNAMU" {
    printf("%s\n", FormatovatRadek($0));
    next;
}

TYP_RADKU == "PRIKLAD" {
    if ($0 ~ /<br>$/) {
        $0 = substr($0, 1, length($0) - 4);
    }
    $0 = substr($0, 4, length($0) - 4);
    printf("%s", ZacatekPrikladu(FormatovatRadek($0)));
    next;
}

TYP_RADKU == "POZNAMKA" {
    if ($0 ~ /<br>$/) {
        $0 = substr($0, 1, length($0) - 4);
    }
    printf("%s", Poznamka(FormatovatRadek(substr($0, 5, length($0) - 6)), JE_UVNITR_PRIKLADU));
    next;
}

TYP_RADKU == "RADEK_PRIKLADU" {
    if ($0 ~ /<br>$/) {
        $0 = substr($0, 1, length($0) - 4);
    }
    printf("%s", RadekPrikladu(FormatovatRadek($0)));
    next;
}

TYP_RADKU == "NEPRAZDNY" {
    next;
}

TYP_RADKU == "PRAZDNY" {
    next;
}

# Pokud nebyl daný typ řádku zpracován, pravděpodobně nebyl implementován,
# což je fatální chyba.
{
    ShoditFatalniVyjimku("Nezpracovany typ radku: " TYP_RADKU);
}

END {
    # Končíme-li s fatální výjimkou, skončit hned.
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
    
    # Řádně ukončit poslední otevřený typ řádku.
    if (TYP_RADKU != "") {
        PREDCHOZI_TYP_RADKU = TYP_RADKU;
        TYP_RADKU = "PRAZDNY";
        UkoncitPredchoziTypRadku();
    }
    
    # Řádně ukončit kapitolu, je-li otevřena.
    if (PODSEKCE != "")
        printf("%s", KonecPodsekce(KAPITOLA, SEKCE, PODSEKCE));
    if (SEKCE != "")
        printf("%s", KonecSekce(KAPITOLA, SEKCE));
    if (KAPITOLA != "")
        printf("%s", KonecKapitoly(KAPITOLA));
}
