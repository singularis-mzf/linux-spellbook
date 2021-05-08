# Linux Kniha kouzel, skript překlad/hlavní.awk
# Copyright (c) 2019-2021 Singularis <singularis@volny.cz>
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
        } else if (substr(VSTUP, 1, 7) == "&blank;") {
            VYSTUP = VYSTUP ZpracujZnak("␣");
            VSTUP = substr(VSTUP, 8);
        } else if (substr(VSTUP, 1, 4) == "&lt;") {
            VYSTUP = VYSTUP ZpracujZnak("<");
            VSTUP = substr(VSTUP, 5);
        } else if (substr(VSTUP, 1, 4) == "&gt;") {
            VYSTUP = VYSTUP ZpracujZnak(">");
            VSTUP = substr(VSTUP, 5);
        } else if (substr(VSTUP, 1, 5) == "&amp;") {
            VYSTUP = VYSTUP ZpracujZnak("&");
            VSTUP = substr(VSTUP, 6);
        } else if (substr(VSTUP, 1, 5) == "&apo;") {
            VYSTUP = VYSTUP ZpracujZnak("'");
            VSTUP = substr(VSTUP, 6);
        } else if (substr(VSTUP, 1, 6) == "&nbsp;") {
            VYSTUP = VYSTUP ZpracujZnak(" ");
            VSTUP = substr(VSTUP, 7);
        } else if (substr(VSTUP, 1, 6) == "&quot;") {
            VYSTUP = VYSTUP ZpracujZnak("\"");
            VSTUP = substr(VSTUP, 7);
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
# Lokálně používá zásobník "format".
function FormatovatRadek(text, stav,   VSTUP, VYSTUP, i, j, C, priznak) {
    priznak = 0; # příznak použitelný k zachování kontextu
    VSTUP = text;
    VYSTUP = "";
    VyprazdnitZasobnik("format");

    if (stav != FR_STAV_MIMO_ZAKLINADLO &&
        stav != FR_STAV_RADEK_ZAKLINADLA &&
        stav != FR_STAV_TEXT_AKCE) {ShoditFatalniVyjimku("Neplatný kontext formátování: " stav)}

    while (VSTUP != "") {
        # 11 znaků
        switch (C = substr(VSTUP, 1, 11)) {
            case "<neodsadit>":
                ShoditFatalniVyjimku("Značka <neodsadit> je dovolena jen na začátku prvního řádku nového odstavce!");
                continue;
            default:
                break;
        }
        # 7 znaků
        switch (C = substr(VSTUP, 1, 7)) {
            case "&blank;":
                VYSTUP = VYSTUP ZpracujZnak("␣");
                VSTUP = substr(VSTUP, 8);
                continue;
            default:
                break;
        }
        # 6 znaků
        switch (C = substr(VSTUP, 1, 6)) {
            case "&nbsp;":
                # nezlomitelná mezera se v této verzi nepovažuje za bílý znak
                VYSTUP = VYSTUP ZpracujZnak(" ");
                VSTUP = substr(VSTUP, 7);
                continue;
            case "&quot;":
                VYSTUP = VYSTUP ZpracujZnak("\"");
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab1>":
                VYSTUP = VYSTUP Tabulator(1);
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab2>":
                VYSTUP = VYSTUP Tabulator(2);
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab3>":
                VYSTUP = VYSTUP Tabulator(3);
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab4>":
                VYSTUP = VYSTUP Tabulator(4);
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab5>":
                VYSTUP = VYSTUP Tabulator(5);
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab6>":
                VYSTUP = VYSTUP Tabulator(6);
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab7>":
                VYSTUP = VYSTUP Tabulator(7);
                VSTUP = substr(VSTUP, 7);
                continue;
            case "<tab8>":
                VYSTUP = VYSTUP Tabulator(8);
                VSTUP = substr(VSTUP, 7);
                continue;
            default:
                break;
        }
        # 5 znaků
        switch (C = substr(VSTUP, 1, 5)) {
            case "&amp;":
                VYSTUP = VYSTUP ZpracujZnak("&");
                VSTUP = substr(VSTUP, 6);
                continue;
            case "&apo;":
                VYSTUP = VYSTUP ZpracujZnak("'");
                VSTUP = substr(VSTUP, 6);
                continue;
            case "<nic>":
                VSTUP = substr(VSTUP, 6);
                continue;
            case "<tab>":
                VYSTUP = VYSTUP Tabulator(8);
                VSTUP = substr(VSTUP, 6);
                continue;
            default:
                break;
        }
        # 4 znaky
        switch (C = substr(VSTUP, 1, 4)) {
            case "<br>":
                VYSTUP = VYSTUP KonecRadku();
                VSTUP = substr(VSTUP, 5);
                continue;
            case "&lt;":
                VYSTUP = VYSTUP ZpracujZnak("<");
                VSTUP = substr(VSTUP, 5);
                continue;
            case "&gt;":
                VYSTUP = VYSTUP ZpracujZnak(">");
                VSTUP = substr(VSTUP, 5);
                continue;
            default:
                break;
        }
        # 3 znaky
        switch (C = substr(VSTUP, 1, 3)) {
            case "{**":
                ShoditFatalniVyjimku("Neodzvláštněná kombinace \"{**\" není ve zdrojovém kódu povolena. Zkontrolujte prosím, co jste chtěl/a napsat.");
            case "**}":
                ShoditFatalniVyjimku("Neodzvláštněná kombinace \"**}\" není ve zdrojovém kódu povolena. Zkontrolujte prosím, co jste chtěl/a napsat.");
            case "...":
                if (stav == FR_STAV_RADEK_ZAKLINADLA && VelikostZasobniku("format") == 0 && substr(VSTUP, 4, 1) != ".") {
                    VYSTUP = VYSTUP TriTecky();
                    VSTUP = substr(VSTUP, 4);
                    continue;
                }
                break;
            default:
                break;
        }
        # 2 znaky
        switch (C = substr(VSTUP, 1, 2)) {
            case "**":
                if (Vrchol("format") != "**") {
                    if (stav != FR_STAV_RADEK_ZAKLINADLA) {
                        VYSTUP = VYSTUP FormatTucne(1);
                    }
                    Push("format", "**");
                } else {
                    if (stav != FR_STAV_RADEK_ZAKLINADLA) {
                        VYSTUP = VYSTUP FormatTucne(0);
                    }
                    Pop("format");
                }
                VSTUP = substr(VSTUP, 3);
                continue;
            case "{*":
                if (VelikostZasobniku("format") != 0)
                    break;
                VYSTUP = VYSTUP FormatDopln(1, priznak);
                priznak = 0;
                Push("format", "{*");
                VSTUP = substr(VSTUP, 3);
                continue;
            case "*}":
                if (VelikostZasobniku("format") != 1)
                    break;
                if (Pop("format") != "{*") {
                    ShoditFatalniVyjimku("Uzavřena neotevřená formátovací značka: {*..*}");
                }
                VYSTUP = VYSTUP FormatDopln(0, 0);
                VSTUP = substr(VSTUP, 3);
                priznak = substr(VSTUP, 1, 2) == "{*";
                continue;
            case "{_":
                if (VelikostZasobniku("format") != 0)
                    break;
                VYSTUP = VYSTUP FormatKlavesa(1, priznak);
                priznak = 0;
                Push("format", "{_");
                VSTUP = substr(VSTUP, 3);
                continue;
            case "_}":
                if (VelikostZasobniku("format") != 1)
                    break;
                if (Pop("format") != "{_") {
                    ShoditFatalniVyjimku("Uzavřena neotevřená formátovací značka: {_.._}");
                }
                VYSTUP = VYSTUP FormatKlavesa(0, 0);
                VSTUP = substr(VSTUP, 3);
                priznak = substr(VSTUP, 1, 2) == "{_";
                continue;
            case "$$":
                ShoditFatalniVyjimku("Funkce $$ není v této verzi podporována. Při opakování znaku $ musí být každý z těcho znaků odzvláštněn zpětným lomítkem.");
            case "--":
                ShoditFatalniVyjimku("Kombinace " C " musí být ve zdrojovém kódu povinné odzvláštněna.");
            case "\\0":
                ShoditFatalniVyjimku("Sekvence \\0 v tomto zdrojovém kódu není platná. Nemyslel/a jste \\\\0?");
            default:
                break;
        }
        # 1 znak
        switch (C = substr(VSTUP, 1, 1)) {
            case "\\":
                if (VSTUP ~ /^.[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"%',/;=?@^]/) {
                    ShoditFatalniVyjimku("Nadbytečné odzvláštnění " substr(VSTUP, 1, 2) " je striktně zakázáno.");
                } else if (VSTUP == "\\") {
                    ShoditFatalniVyjimku("Význam zpětného lomítka na konci řádku zatím není definován, proto není ve zdrojovém kódu povoleno.");
                }
                VYSTUP = VYSTUP ZpracujZnak(substr(VSTUP, 2, 1));
                VSTUP = substr(VSTUP, 3);
                continue;
            case "<":
                ShoditFatalniVyjimku("Nepovolený znak '<'. Musí být zakódován jako &lt;.");
                continue;
            case ">":
                ShoditFatalniVyjimku("Nepovolený znak '>'. Musí být zakódován jako &gt;.");
                continue;
            case "&":
                # Odlišné umístění závorek kvůli problémům se zvýrazněním syntaxe.
                if (match(VSTUP, /^&[0-9a-zA-Z#]{1,64};/))
                {
                    ShoditFatalniVyjimku("Nepovolená entita na řádku: '" substr(VSTUP, RSTART, RLENGTH) "'.");
                }
                else
                {
                    ShoditFatalniVyjimku("Nepovolený znak '&'. Musí být zakódován jako &amp;.");
                }
                continue;
            case "[":
                if (match(VSTUP, /^\[([^\]\\]|\\.)+\]\(([^)\\]|\\.)+\)/)) {
                    # j = délka celého výrazu; i = délka po dělící sekvenci „](“
                    j = RLENGTH;
                    match(VSTUP, /^\[([^\]\\]|\\.)+\]\(/);
                    i = RLENGTH - 1;
                    VYSTUP = VYSTUP HypertextovyOdkaz(ZpracujZnaky(substr(VSTUP, i + 2, j - i - 2)), ZpracujZnaky(substr(VSTUP, 2, i - 2)));
                    VSTUP = substr(VSTUP, j + 1);
                    continue;
                } else if (stav == 0 && VelikostZasobniku("format") == 0) {
                    VYSTUP = VYSTUP FormatVolitelny(1);
                    VSTUP = substr(VSTUP, 2);
                    continue;
                }
                break;
            case "]":
                if (stav == 0 && VelikostZasobniku("format") == 0) {
                    VYSTUP = VYSTUP FormatVolitelny(0);
                    VSTUP = substr(VSTUP, 2);
                    continue;
                }
                break;
            case "*":
                if (Vrchol("format") != "*") {
                    VYSTUP = VYSTUP FormatKurziva(1);
                    Push("format", "*");
                } else {
                    VYSTUP = VYSTUP FormatKurziva(0);
                    Pop("format");
                }
                VSTUP = substr(VSTUP, 2);
                continue;
            case "⫽":
                VYSTUP = VYSTUP ZpracujZnak("/") ZpracujZnak("/");
                VSTUP = substr(VSTUP, 2);
                continue;
            case "⊨":
                if (stav == FR_STAV_MIMO_ZAKLINADLO) {ShoditFatalniVyjimku("Znak ⊨ není povolen mimo jeho zvláštní použití v řádku zaklínadla!")}
                if (stav == FR_STAV_TEXT_AKCE) {ShoditFatalniVyjimku("Znak ⊨ se v řádku zaklínadla nesmí opakovat!")}
                if (VelikostZasobniku("format") != 0) {ShoditFatalniVyjimku("Znak ⊨ před uzavřením formátování (značka " Vrchol("format") ")!")}
                stav = FR_STAV_TEXT_AKCE;
                VYSTUP = VYSTUP "⊨";
                VSTUP = substr(VSTUP, 2);
                continue;
            case "`":
            case "_":
                ShoditFatalniVyjimku("Neodzvláštněný znak " C "! Všechny výskyty tohoto znaku musejí být odzvláštněny zpětným lomítkem.");
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
        VYSTUP = VYSTUP ((stav == FR_STAV_RADEK_ZAKLINADLA && VelikostZasobniku("format") == 0) ? ZpracujChybnyZnak(C) : ZpracujZnak(C));
        VSTUP = substr(VSTUP, 2);
    }

    if (VelikostZasobniku("format") > 0) {
        ShoditFatalniVyjimku("Formátovací značka neuzavřena do konce řádku " ZACATEK_ZVYRAZNENI FNR KONEC_ZVYRAZNENI ": " Vrchol("format") "\nVstup: <" text ">\nVýstup: <" VYSTUP ">\n\n");
    }
    return VYSTUP;
}

# Vrací počet řádek tvořících zaklínadlo (o kolik je třeba zvýšit „i“)
function VypsatZaklinadlo(iZacatek, jakoOblibene, titulekProOblibene,    c, i, iKonec, iPPC, ikona, pozice, ppc, ppt, s, tz)
{
    if (ZR_TYP[iZacatek] != "ZAKLÍNADLO") {ShoditFatalniVyjimku("Chybný index pro výstup zaklínadla: " iZacatek)}

    if (iZacatek > 1 && ZR_TYP[i - 1] ~ /^(ZAKLÍNADLO|POZNÁMKA|ŘÁDEK_ZAKLÍNADLA)$/) {
        ShoditFatalniVyjimku("Zaklínadlo nesmí následovat bezprostředně po předchozím zaklínadle. Vložte před něj prázdný řádek.");
    }
    JE_UVNITR_ZAKLINADLA = 1;

    # tz = text zaklínadla (pro zaklínadla bez titulku "")
    tz = ZR_TEXT[iZacatek] == "*# *<br>" ? "" : gensub(/^\*# |\*<br>$/, "", "g", ZR_TEXT[iZacatek]);
    if (length(tz) != length(ZR_TEXT[iZacatek]) - 8) {
        ShoditFatalniVyjimku("Vnitřní chyba: chybná náhrada \"" ZR_TEXT[iZacatek] "\" -> \"" tz "\"");
    }
    #else {printf("LADĚNÍ: zaklínadlo \"%s\" -> \"%s\"\n", ZR_TEXT[iZacatek], tz) > "/dev/stderr"}

    if (jakoOblibene && titulekProOblibene != "") {tz = titulekProOblibene}

    if (tz != "") {tz = FormatovatRadek(tz, FR_STAV_MIMO_ZAKLINADLO)}
    HES_ZAKLINADLA = ZR_HES[iZacatek];
    if (tz != "") {
        if (HES_ZAKLINADLA == "") {ShoditFatalniVyjimku("Chybí očekávaná heš zaklínadla!")}
    } else {
        # zaklínadlo bez titulku:
        if (HES_ZAKLINADLA != "") {ShoditFatalniVyjimku("Přebytečná heš pro zaklínadlo bez titulku!")}
        if (jakoOblibene) {ShoditFatalniVyjimku("Zaklínadlo bez titulku nemůže být vysázeno jako oblíbené!")}
    }
    for (iKonec = iZacatek + 1; ZR_TYP[iKonec] ~ /^(POZNÁMKA|ŘÁDEK_ZAKLÍNADLA)$/; ++iKonec);
    delete ppc;
    delete ppt;
    for (i = iZacatek + 1; ZR_TYP[i] == "POZNÁMKA"; ++i) {
        # "*// " ... "*<br>"
        iPPC = length(ppcall); # index poznámky pod čarou
        s = FormatovatRadek(gensub(/^\*\/\/ |\*<br>$/, "", "g", ZR_TEXT[i]), FR_STAV_MIMO_ZAKLINADLO); # správný kontext?
        ppcall[iPPC] = ppc[length(ppc)] = 1 + iPPC;
        pptall[iPPC + 1] = ppt[1 + iPPC] = s;
    }

    if (ZR_TYP[i] != "ŘÁDEK_ZAKLÍNADLA") {ShoditFatalniVyjimku("Zaklínadlo musí obsahovat alespoň jeden řádek!")}
    if (tz != "") {
        # zaklínadlo s titulkem
        c = strtonum("0" HES_ZAKLINADLA) % length(UCS_IKONY);
        ikona = substr(UCS_IKONY, 1 + c, 1) "\t" substr(UCS_IKONY_PISMA, 1 + c, 1);
        if (!jakoOblibene) {
            s = ZacatekZaklinadla(\
                C_KAPITOLY, NAZEV_NADKAPITOLY, NAZEV_PODKAPITOLY, ZR_C_SEKCE[iZacatek], ZR_N_SEKCE[iZacatek], ZR_C_PODSEKCE[iZacatek], ZR_N_PODSEKCE[iZacatek],
                ++C_ZAKLINADLA, tz, HES_ZAKLINADLA,
                ikona, ppc, ppt, 0);
        } else {
            s = ZacatekZaklinadla(\
                C_KAPITOLY, NAZEV_NADKAPITOLY, NAZEV_PODKAPITOLY, ZR_C_SEKCE[iZacatek], ZR_N_SEKCE[iZacatek], ZR_C_PODSEKCE[iZacatek], ZR_N_PODSEKCE[iZacatek],
                ++CISLO_OBLIBENEHO_ZAKLINADLA, tz, HES_ZAKLINADLA,
                ikona, ppc, ppt, 1);
        }
    } else {
        # zaklínadlo bez titulku
        s = ZacatekZaklinadla(C_KAPITOLY, NAZEV_NADKAPITOLY, NAZEV_PODKAPITOLY, ZR_C_SEKCE[iZacatek], ZR_N_SEKCE[iZacatek], ZR_C_PODSEKCE[iZacatek], ZR_N_PODSEKCE[iZacatek],
            0, "", "", "", ppc, ppt, 0);
    }
    printf("%s", s);

    # zpracovat řádku zaklínadla:
    while (i < iKonec) {
        s = gensub(/<br>$/, "", 1, ZR_TEXT[i]);
        if (s ~ /^<odsadit[1-8]>./) {
            UROVEN = substr(s, 9, 1);
            s = substr(s, 11);
            if (s ~ /^!: ?/) {ShoditFatalniVyjimku("Odsazení akcí není umožněno!")}
        } else if (s ~ /^\^\^./) {
            UROVEN = UROVEN_PREAMBULE;
            s = substr(s, 3);
        } else if (match(s, /^<odsadit[0-9]+>./)) {
            ShoditFatalniVyjimku("Nepodporovaná úroveň odsazení: " substr(s, RSTART, RLENGTH) "!");
        } else if (match(s, /^!: ?/)) {
            UROVEN = UROVEN_AKCE;
            s = substr(s, 1 + RLENGTH);
        } else {
            UROVEN = 0;
        }
        if (UROVEN == 0 && s == "?") {
            s = RadekZaklinadla(ReseniNezname(), 0, "");
        } else {
            gsub(/\s*⊨\s*/, "⊨", s);
            s = FormatovatRadek(s, UROVEN != UROVEN_AKCE ? FR_STAV_RADEK_ZAKLINADLA : FR_STAV_TEXT_AKCE);
            pozice = index(s, "⊨");
            if (pozice == 0) {
                s = RadekZaklinadla(s, UROVEN, "");
            } else if (UROVEN != UROVEN_AKCE) {
                s = RadekZaklinadla(substr(s, 1, pozice - 1), UROVEN, substr(s, pozice + 1));
            } else {
                ShoditFatalniVyjimku("Dělení akce znakem ⊨ není podporováno!");
            }
        }
        printf("%s", s);
        ++i;
    }
    printf("%s", KonecZaklinadla());
    JE_UVNITR_ZAKLINADLA = 0;
    HES_ZAKLINADLA = "";
    return iKonec - iZacatek;
}

function UzavritPodsekci()
{
    if (C_PODSEKCE != 0) {
        printf("%s", KonecPodsekce(C_KAPITOLY, KAPITOLA, C_SEKCE, SEKCE, C_PODSEKCE, PODSEKCE));
        C_PODSEKCE = 0;
        PODSEKCE = "";
    }
    return 0;
}
function UzavritSekci()
{
    if (C_SEKCE != 0) {
        UzavritPodsekci();
        printf("%s", KonecSekce(C_KAPITOLY, KAPITOLA, C_SEKCE, SEKCE));
        C_SEKCE = 0;
        SEKCE = "";
    }
    return 0;
}

function OtevritSekci(cislo, nazev)
{
    if (nazev == "") {ShoditFatalniVyjimku("Nelze otevřít sekci s prázdným názvem!")}
    if (C_SEKCE != 0) {ShoditFatalniVyjimku("Nelze otevřít sekci (" cislo ":" nazev "), když je stále otevřena sekce (" C_SEKCE ": " SEKCE ")!")}
    printf("%s", ZacatekSekce(C_KAPITOLY, KAPITOLA, C_SEKCE = cislo, SEKCE = nazev));
    C_ZAKLINADLA = 0;
    return 0;
}

function OtevritPodsekci(cislo, nazev)
{
    if (nazev == "") {ShoditFatalniVyjimku("Nelze otevřít podsekci s prázdným názvem!")}
    if (C_PODSEKCE != 0) {ShoditFatalniVyjimku("Nelze otevřít podsekci (" cislo ":" nazev "), když je stále otevřena podsekce (" C_PODSEKCE ":" PODSEKCE ")!")}
    if (C_SEKCE == 0) {ShoditFatalniVyjimku("Nelze otevřít podsekci (" cislo ":" nazev "), když není otevřena žádná sekce!")}
    C_PODSEKCE = cislo;
    PODSEKCE = nazev;
    printf("%s", ZacatekPodsekce(C_KAPITOLY, KAPITOLA, C_SEKCE, SEKCE, C_PODSEKCE = cislo, PODSEKCE = nazev));
    C_ZAKLINADLA = 0;
    return 0;
}

BEGIN {
    FS = OFS = "\t";
    RS = ORS = "\n";
    if (ARGC != 2) {
        ShoditFatalniVyjimku("Chybný počet parametrů (ARGC=" ARGC ")");
    }

    if ((SOUBORY_PREKLADU = ENVIRON["SOUBORY_PREKLADU"]) == "") {
        ShoditFatalniVyjimku("Vyžadovaná proměnná SOUBORY_PREKLADU není nastavena!");
    }

    # Určit ID kapitoly, nadkapitoly a podkapitoly
    n = split(gensub(/\.md$/, "", 1, ARGV[1]), casti, /\/+/);
    IDNADKAPITOLY = casti[n - 1] ~ /^(dodatky|kapitoly)$/ ? "" : casti[n - 1];
    IDPODKAPITOLY = casti[n];
    IDKAPITOLY = (IDNADKAPITOLY != "" ? IDNADKAPITOLY "/" : "") IDPODKAPITOLY;

    # Načíst a zpracovat štítky.tsv:
    delete STITKY_TEXT_NA_XHES;
    soubor = SOUBORY_PREKLADU "/štítky.tsv";
    while (getline < soubor) {
        STITKY_TEXT_NA_XHES[$1] = $2;
    }
    close(soubor);

    # Načíst a zpracovat údaje z fragmenty.tsv, jsou-li k dispozici:
    NacistFragmentyTSV(SOUBORY_PREKLADU "/fragmenty.tsv");
    # číslo kapitoly
    C_KAPITOLY = FragInfo(IDKAPITOLY "?");
    #printf("LADĚNÍ: číslo kapitoly(%s) id(%s)\n", C_KAPITOLY, IDKAPITOLY) > "/dev/stderr";
    if (C_KAPITOLY != 0 && FragInfo(C_KAPITOLY, "příznaky") ~ /z/) {
        # štítky
        stitky = FragInfo(C_KAPITOLY, "štítky");
        gsub(/^\{|\}$/, "", stitky);
        split(stitky, STITKY, /\}\{/);
        for (n in STITKY) {STITKY_XHES[STITKY[n]] = STITKY_TEXT_NA_XHES[STITKY[n]]}
        # ikona kapitoly
        IKONA_KAPITOLY = FragInfo(C_KAPITOLY, "ikona-kapitoly");
        # je dodatek?
        JE_DODATEK = FragInfo(C_KAPITOLY, "příznaky") ~ /d/;
        # název
        NAZEV_PODKAPITOLY = FragInfo(C_KAPITOLY, "název-podkapitoly");
        n = FragInfo(C_KAPITOLY, "číslo-nadkapitoly");
        NAZEV_NADKAPITOLY = n != 0 ? FragInfo(n, "celý-název") : "";
        # xheš
        XHES_KAPITOLY = FragInfo(C_KAPITOLY, "xheš");
    } else {
        C_KAPITOLY = 0;
        delete STITKY;
        delete STITKY_XHES;
        IKONA_KAPITOLY = "ik-vychozi.png";
        JE_DODATEK = 0;
        NAZEV_NADKAPITOLY = "";
        NAZEV_PODKAPITOLY = "Není";
        XHES_KAPITOLY = "x00000000";
    }

    # Načíst zvýraznění
    ZACATEK_ZVYRAZNENI = "";
    KONEC_ZVYRAZNENI = "";
    prikaz = "exec 2>/dev/null; tput setaf 1; tput bold";
    prikaz | getline ZACATEK_ZVYRAZNENI;
    close(prikaz);
    if (ZACATEK_ZVYRAZNENI != "") {
        prikaz = "exec 2>/dev/null; tput sgr0";
        prikaz | getline KONEC_ZVYRAZNENI;
        close(prikaz);
    }

    # Výčty:
    UROVEN = 0;
    UROVEN_AKCE = -1;
    UROVEN_PREAMBULE = -2;

    FR_STAV_MIMO_ZAKLINADLO = -1;
    FR_STAV_TEXT_AKCE = 1;
    FR_STAV_RADEK_ZAKLINADLA = 0;

    # Inicializovat globální proměnné:
    NULL_STRING = "\x01\x02";
    KAPITOLA = NAZEV_NADKAPITOLY == "" ? NAZEV_PODKAPITOLY : NAZEV_NADKAPITOLY "/" NAZEV_PODKAPITOLY;
    SEKCE = "";
    PODSEKCE = "";
    C_SEKCE = 0;
    C_PODSEKCE = 0;
    C_ZAKLINADLA = 0;
    FATALNI_VYJIMKA = 0;
    JE_UVNITR_ZAKLINADLA = 0;
    TEXT_ZAKLINADLA = NULL_STRING;
    JE_ZAPNUTY_UZKY_REZIM = 0;

    UCS_IKONY = VYCHOZI_UCS_IKONA = "♣";
    UCS_IKONY_PISMA = VYCHOZI_UCS_IKONA_PISMO = "L";
    HES_ZAKLINADLA = "";
    RADKY_OZ_POCET = 0;
    CISLO_OBLIBENEHO_ZAKLINADLA = 0;
    delete ppcall;
    delete pptall;
    delete RADKY_OZ;
    delete vstup; vstup_pocet = 0;

    ZR_POCET = 0;
    delete ZR_CISLO;
    delete ZR_TEXT;
    delete ZR_TYP;
    delete ZR_HES;
    delete ZR_C_SEKCE;
    delete ZR_N_SEKCE;
    delete ZR_C_PODSEKCE;
    delete ZR_N_PODSEKCE;

    # Načíst osnovu:
    delete OSNOVA;
    soubor = (SOUBORY_PREKLADU "/osnova/" gensub(/\//, "-", "g", IDKAPITOLY) ".tsv");
    while (getline < soubor) {
# $1=TYP $2=ID $3=ČÍSLO_ŘÁDKU $4=NÁZEV $5=;
        OSNOVA[1 + length(OSNOVA)] = sprintf("%s\t%s\t%s\t%s\t%s", $1, $2, $3, ZpracujZnaky($4), ";");
    }
    close(soubor);

    # Načíst oblíbená zaklínadla:
    delete OBLIBENE_HESE;
    while (getline < "konfigurace/oblíbená-zaklínadla.seznam") {
        if ($0 ~ /^(#|$)/) {continue} # komentář
        match($0, /^x[0123456789abcdef]+( ([-[:alnum:]  .,;:/]|\*\*)+)?/); # omezení dovolených znaků v titulku pro oblíbené zaklínadlo
        if (RLENGTH < length($0)) {
            ShoditFatalniVyjimku("Chybný formát řádky v seznamu oblíbených zaklínadel: správná část = \"" \
                substr($0, 1, RLENGTH) "\", zbytek = \"" substr($0, 1 + RLENGTH) "\"." );
        }
        xhes = gensub(/\s.*$/, "", 1);
        titulek = gensub(/^\S+ ?/, "", 1);
        if (titulek ~ /\*\*\*/) {
            ShoditFatalniVyjimku("Chybný titulek pro oblíbené zaklínadlo (nesmí obsahovat jednu ani víc než dvě \"*\" vedle sebe): \"" titulek "\"!");
        }
        OBLIBENE_HESE[xhes] = titulek;
    }
    #for (s in OBLIBENE_HESE) {printf("LADĚNÍ: Oblíbená heš: <%s> (titulek=<%s>)\n", s, OBLIBENE_HESE[s]) > "/dev/stderr"}
}
{
    vstup[vstup_pocet = FNR] = $0;
}
# main() - jako v jazyce C
function main(    i, j, o, s, pozice, uroven, pokracuje, c_sekce, n_sekce, c_podsekce, n_podsekce, indexyOblZakl, titulkyOblZakl)
{
    # 1. Vypustit komentáře
    i = o = 1;
    while (i <= vstup_pocet) {
        FNR = i + 1;
        # komentář započatý na samostatném řádku kompletně ignorovat
        # (není to ideální řešení, ale dokonalejší řešení jsou problematická)
        if (vstup[i] == "<!--") {
            while (vstup[++i] != "-->") {
                if (i >= vstup_pocet) {
                    ShoditFatalniVyjimku("Komentář otevřený samostatným řádkem \"<!--\" musí být ukončený v rámci téhož zdrojového souboru samostatným řádkem \"-->\".");
                }
            }
            ++i;
            continue;
        }
        if (vstup[i] ~ /^<!--.*-->$/) { # jednořádkový komentář (nesmí obsahovat --)
            if (vstup[i] ~ /^<!--.*--.*-->$/) {ShoditFatalniVyjimku("Chyba syntaxe: jednořádkový komentář nesmí obsahovat „--“!")}
            ++i;
            continue;
        }
        while (match(vstup[i], /<!--[^>]*-->/)) {
            zacatek = RSTART;
            konec = RSTART + RLENGTH;
            if (substr(vstup[i], RSTART + 4, RLENGTH - 7) ~ /--|>/) {ShoditFatalniVyjimku("Chyba syntaxe: komentář uvnitř řádky nesmí obsahovat „--“ ani „>“!")}
            vstup[i] = substr(vstup[i], 1, konec - 1) substr(vstup[i], konec); # [ ] vyzkoušet!
        }
        if (vstup[i] ~ /^[ \t\v\r\n]+$/) {ShoditFatalniVyjimku("Řádek tvořený pouze bílými znaky není v tomto projektu dovolen!\nŘádek č. " i ": <" vstup[i] ">")}
        if (vstup[i] ~ /[ \t\v\r\n]$/) {ShoditFatalniVyjimku("Bílé znaky na konci řádku nejsou v tomto projektu dovoleny!\nŘádek č. " i ": " vstup[i] ">")}
        if (vstup[i] ~ /^[ \t\v\r\n]/) {ShoditFatalniVyjimku("Bílé znaky na začátku řádku nejsou v tomto projektu dovoleny!\nŘádek č. " i ": " vstup[i] ">")}
        if (vstup[i] ~ /^# .+$/) {++i; continue;} # nadpis kapitoly vynechat (nebude se zpracovávat při překladu)
        if (vstup[i] != "" || o == 1 || ZR_TEXT[o - 1] != "") { # prázdný řádek nevkládat vícekrát
            ZR_CISLO[o] = i;
            ZR_TEXT[o] = vstup[i];
            ++o;
        }
        ++i;
    }
    ZR_POCET = o - 1;
    #printf("LADĚNÍ: %d zdrojových řádek načteno, %d propuštěno.\n", vstup_pocet, ZR_POCET) > "/dev/stderr";
    delete vstup;
    vstup_pocet = 0;

    # 2. Určit typ řádku a strukturu sekcí a podsekcí (o = index v osnově)
    o = 0;
    c_sekce = c_podsekce = 0;
    n_sekce = n_podsekce = "";
    for (i = 1; i <= ZR_POCET; ++i) {
        FNR = ZR_CISLO[i];
        ZR_C_SEKCE[i] = c_sekce;
        ZR_C_PODSEKCE[i] = c_podsekce;
        ZR_N_SEKCE[i] = n_sekce;
        ZR_N_PODSEKCE[i] = n_podsekce;

        ZR_TYP[i] = "";
        if (ZR_TEXT[i] == "") {
            ZR_TYP[i] = "PRÁZDNÝ";
        } else if (ZR_TEXT[i] ~ /^#+ .+/) {
            ZR_TYP[i] = "NADPIS";
            pozice = index(s = ZR_TEXT[i], " ");
            ZR_TEXT[i] = substr(ZR_TEXT[i], pozice + 1);
            switch (pozice) {
                case 2: # kapitola
                    ShoditFatalniVyjimku("Vnitřní chyba: označení kapitoly již mělo být odfiltrováno v předchozí fázi!");
                    #if (KAPITOLA != "") {ShoditFatalniVyjimku("Ve zdrojovém kódu kapitoly je dovolen jen jeden nadpis první úrovně!")}
                    #KAPITOLA = ZpracujZnaky(ZR_TEXT[i]);
                    #if (KAPITOLA == "") {ShoditFatalniVyjimku("Prázdný název kapitoly!")}
                    #ZR_C_SEKCE[i] = ZR_C_PODSEKCE[i] = c_sekce = c_podsekce = 0;
                    #ZR_N_SEKCE[i] = ZR_N_PODSEKCE[i] = n_sekce = n_podsekce = "";
                    #break;
                case 3: # sekce
                    ZR_C_SEKCE[i] = ++c_sekce;
                    ZR_N_SEKCE[i] = n_sekce = ZpracujZnaky(ZR_TEXT[i]);
                    ZR_C_PODSEKCE[i] = c_podsekce = 0;
                    ZR_N_PODSEKCE[i] = n_podsekce = "";
                    break;
                case 4: # podsekce
                    ZR_C_PODSEKCE[i] = ++c_podsekce;
                    ZR_N_PODSEKCE[i] = n_podsekce = ZpracujZnaky(ZR_TEXT[i]);
                    break;
                default: # ?
                    ShoditFatalniVyjimku("Chyba syntaxe nadpisu: \"" s "\"");
            }
        } else if (ZR_TEXT[i] ~ /^>+ .+/) {
            uroven = index(ZR_TEXT[i], " ") - 1;
            if (uroven > 6) {ShoditFatalniVyjimku("Příliš vysoká úroveň odsazení (víc než 6): " ZR_TEXT[i])}
            ZR_TYP[i] = "ODSAZENÝ_" uroven;
            ZR_TEXT[i] = substr(ZR_TEXT[i], uroven + 2);
        }
        if (ZR_TYP[i] == "" && ZR_TYP[i - 1] != "NORMÁLNÍ") {
            if (ZR_TEXT[i] ~ /^\* .+/) {
                ZR_TYP[i] = "POLOŽKA_SEZNAMU";
                ZR_TEXT[i] = substr(ZR_TEXT[i], 3);
            } else if (ZR_TEXT[i] ~ /^\*# .*\*<br>$/) {
                ZR_TYP[i] = "ZAKLÍNADLO";
                if (ZR_TEXT[i] ~ /^\*# .+\*<br>$/) {
                    # zaklínadlo s titulkem => přidělit heš
                    while (++o in OSNOVA && OSNOVA[o] !~ /^ZAKLÍNADLO\t/) {}
                    if (!(o in OSNOVA)) {ShoditFatalniVyjimku("V osnově chybí očekávané zaklínadlo! Pravděpodobně jde o vnitřní chybu mechanismu překladu.")}
                    ZR_HES[i] = gensub(/^[^\t]+\t([^\t]+)\t.*$/, "\\1", 1, OSNOVA[o]);
                }
            } else if (ZR_TEXT[i] ~ /^\*\/\/ .+\*(<br>)?$/) {
                ZR_TYP[i] = "POZNÁMKA";
            } else if (ZR_TEXT[i] ~ /^!\[.+\]\(.+\)$/) {
                ZR_TYP[i] = "OBRÁZEK";
            } else if (ZR_TEXT[i] ~ /^![A-Za-z0-9ÁČĎÉĚÍŇÓŘŠŤÚŮÝŽáčďéěíňóřšťúůýž]+:( |$)/) {
                ZR_TYP[i] = "DIREKTIVA";
            }
        }
        if (ZR_TYP[i] == "") {
            if (i > 1 && ZR_TYP[i - 1] ~ /^(ZAKLÍNADLO|POZNÁMKA|ŘÁDEK_ZAKLÍNADLA)$/) {
                ZR_TYP[i] = "ŘÁDEK_ZAKLÍNADLA";
            } else if (i > 1 && ZR_TYP[i - 1] == "POLOŽKA_SEZNAMU" || ZR_TYP[i - 1] == "POKRAČOVÁNÍ_POLOŽKY_SEZNAMU") {
                ZR_TYP[i] = "POKRAČOVÁNÍ_POLOŽKY_SEZNAMU";
            } else {
                ZR_TYP[i] = "NORMÁLNÍ";
            }
        }
        if (ZR_TYP[i] == "") {ShoditFatalniVyjimku("Vnitřní chyba: nebylo možno určit typ zdrojové řádky!")}
        #
        # LADĚNÍ:
        #    printf("\n<TYP=%s>%s>", PREDCHOZI_TYP_RADKU, TYP_RADKU);
    }
    ++ZR_POCET;
    ZR_CISLO[ZR_POCET] = ZR_CISLO[ZR_POCET - 1] + 1;
    ZR_TEXT[ZR_POCET] = "";
    ZR_TYP[ZR_POCET] = "KONEC";

    while (++o in OSNOVA && OSNOVA[o] !~ /^ZAKLÍNADLO\t/) {}
    if (o in OSNOVA) {ShoditFatalniVyjimku("Přebytečné zaklínadlo v osnově! Pravděpodobně jde o vnitřní chybu mechanismu překladu (o = " o ").")}

    # Parametry příkazů:
    i = 1;
    while (i <= ZR_POCET) {
        if (ZR_TYP[i] == "DIREKTIVA" && ZR_TEXT[i] ~ /^![Pp][Aa][Rr][Aa][Mm][Ee][Tt][Rr][Yy]:( |$)/) {
            while (++i <= ZR_POCET && ZR_TYP[i] == "PRÁZDNÝ");
            if (i > ZR_POCET || ZR_TYP[i] != "POLOŽKA_SEZNAMU") {
                FNR = ZR_CISLO[i];
                ShoditFatalniVyjimku("Po direktivě !Parametry musí následovat seznam!");
            }
            do {
                ZR_TYP[i++] = "PARAMETR_PŘÍKAZU";
            } while (ZR_TYP[i] == "POLOŽKA_SEZNAMU");
            if (ZR_TYP[i] != "PRÁZDNÝ") {ShoditFatalniVyjimku("Parametry příkazů musejí být ukončeny prázdným řádkem!")}
        }
        ++i;
    }

    # LADĚNÍ:
    #if (IDKAPITOLY == "základní-znalosti") {
        #for (i = 1; i <= ZR_POCET; ++i) {
            #printf("[%3d] %s <%s> (%s/%s)=(%s//%s)%s\n", ZR_CISLO[i], ZR_TEXT[i], ZR_TYP[i], ZR_C_SEKCE[i], ZR_C_PODSEKCE[i],
               #ZR_N_SEKCE[i], ZR_N_PODSEKCE[i], ZR_HES[i] != "" ? "(heš=" ZR_HES[i] ")" : "") > "/tmp/" NAZEV_PODKAPITOLY ".md";
        #}
    #}
    #ShoditFatalniVyjimku("Test");

    # 3. Otevřít kapitolu
    delete ppcall;
    delete pptall;
    printf("%s", ZacatekKapitoly(C_KAPITOLY, KAPITOLA,
        STITKY, STITKY_XHES, OSNOVA, IKONA_KAPITOLY, JE_DODATEK));
    if (tolower(NAZEV_PODKAPITOLY) == "licence") {
        printf("%s", ZapnoutRezimLicence());
    }

    # 4. Zpracovat zdrojový kód
    for (i = 1; i <= ZR_POCET; ++i) {
        FNR = ZR_CISLO[i];
        #printf("LADĚNÍ: Zpracuji i = <%s> číslo=<%s> typ=<%s>\n", i, ZR_CISLO[i], ZR_TYP[i]) > "/dev/stderr";

        # Zvláštní situace: předěl odstavce
        if (i > 1 && ZR_TYP[i - 1] == "NORMÁLNÍ" && ZR_TYP[i] == "PRÁZDNÝ" && ZR_TYP[i + 1] == "NORMÁLNÍ") {
            printf("%s", PredelOdstavcu());
            continue;
        }

        pokracuje = i > 1 && ZR_TYP[i - 1] == ZR_TYP[i];

        # Ukončit předchozí typ řádku
        if (i > 1 && !pokracuje) {
            switch (ZR_TYP[i - 1]) {
                case "NORMÁLNÍ":
                    printf("%s", KonecOdstavcu());
                    break;

                case "ODSAZENÝ_1":
                case "ODSAZENÝ_2":
                case "ODSAZENÝ_3":
                case "ODSAZENÝ_4":
                case "ODSAZENÝ_5":
                case "ODSAZENÝ_6":
                    printf("%s", KonecOdsazenehoOdstavce(substr(ZR_TYP[i - 1], 10)));
                    break;

                case "PARAMETR_PŘÍKAZU":
                    printf("%s", KonecParametruPrikazu());
                    break;

                case "POLOŽKA_SEZNAMU":
                    if (ZR_TYP[i] != "POKRAČOVÁNÍ_POLOŽKY_SEZNAMU") {
                        printf("%s", KonecPolozkySeznamu(1));
                        printf("%s", KonecSeznamu(1));
                    }
                    break;

                case "POKRAČOVÁNÍ_POLOŽKY_SEZNAMU":
                    printf("%s", KonecPolozkySeznamu(1));
                    printf("%s", ZR_TYP[i] != "POLOŽKA_SEZNAMU" ? KonecSeznamu(1) : ZacatekPolozkySeznamu(1));
                    break;
            }
        }

        # Zpracovat řádku podle jejího typu
        switch (ZR_TYP[i]) {
            case "NADPIS":
                if (ZR_C_PODSEKCE[i - 1] != 0 && ZR_C_PODSEKCE[i - 1] != ZR_C_PODSEKCE[i]) {
                    UzavritPodsekci();
                }
                if (ZR_C_SEKCE[i - 1] != ZR_C_SEKCE[i]) {
                    if (ZR_C_SEKCE[i - 1] != 0) {UzavritSekci()}
                    if (ZR_C_SEKCE[i] != 0) {OtevritSekci(ZR_C_SEKCE[i], ZR_N_SEKCE[i])}
                }
                if (ZR_C_PODSEKCE[i] != 0 && ZR_C_PODSEKCE[i - 1] != ZR_C_PODSEKCE[i]) {
                    OtevritPodsekci(ZR_C_PODSEKCE[i], ZR_N_PODSEKCE[i]);
                }
                break;

            case "OBRÁZEK":
                match(ZR_TEXT[i], /\]\(/);
                alt = substr(ZR_TEXT[i], 3, RSTART - 3);
                src = substr(ZR_TEXT[i], RSTART + 2, length(ZR_TEXT[i]) - RSTART - 2);
                printf("%s", Obrazek(ZpracujZnaky(src), ZpracujZnaky(alt), src, alt));
                break;

            case "NORMÁLNÍ":
                if (!pokracuje) {
                    if (i < 2 || (ZR_TYP[i - 2] != "NORMÁLNÍ" || ZR_TYP[i - 1] != "PRÁZDNÝ")) { # nebyl-li předěl
                        # + dodatečné pravidlo: v kapitole „Licence“ se všechny začátky odstavců uvažují jako po nadpisu (vypne odsazení).

                        predchoziTyp = ZR_TYP[i - 1];
                        if (predchoziTyp == "PRÁZDNÝ") {predchoziTyp = ZR_TYP[i - 2]}
                        printf("%s", ZacatekOdstavcu(predchoziTyp ~ /^(NADPIS|POLOŽKA_SEZNAMU|POKRAČOVÁNÍ_POLOŽKY_SEZNAMU|ŘÁDEK_ZAKLÍNADLA)?$/ || ZR_TEXT[i] ~ /^<neodsadit>/ || tolower(KAPITOLA) == "licence"));
                    }
                }
                s = gensub(/^<neodsadit>/, "", 1, ZR_TEXT[i]);
                printf("%s\n", FormatovatRadek(s, FR_STAV_MIMO_ZAKLINADLO));
                break;

            case "ODSAZENÝ_1":
            case "ODSAZENÝ_2":
            case "ODSAZENÝ_3":
            case "ODSAZENÝ_4":
            case "ODSAZENÝ_5":
            case "ODSAZENÝ_6":
                if (!pokracuje) {
                    printf("%s", ZacatekOdsazenehoOdstavce(substr(ZR_TYP[i], 10)));
                }
                printf("%s\n", FormatovatRadek(ZR_TEXT[i], FR_STAV_MIMO_ZAKLINADLO));
                break;

            case "POLOŽKA_SEZNAMU":
                if (pokracuje) {
                    printf("%s", KonecPolozkySeznamu(1));
                    printf("%s", ZacatekPolozkySeznamu(1));
                } else if (i == 1 || (ZR_TYP[i - 1] != "POLOŽKA_SEZNAMU" && ZR_TYP[i - 1] != "POKRAČOVÁNÍ_POLOŽKY_SEZNAMU")) {
                    printf("%s", ZacatekSeznamu(1, NR == KOMPAKTNI_SEZNAM_NR || (tolower(ZR_N_SEKCE[i]) !~ /^(tipy a.zkušenosti|definice|úvod)/ && tolower(KAPITOLA) !~ /^(koncepce projektu)/)));
                    printf("%s", ZacatekPolozkySeznamu(1));
                }
                printf("%s\n", FormatovatRadek(ZR_TEXT[i], FR_STAV_MIMO_ZAKLINADLO));
                break;

            case "PARAMETR_PŘÍKAZU":
                if (!pokracuje) {
                    printf("%s", ZacatekParametruPrikazu());
                }
                if (!match(ZR_TEXT[i], /\s*::\s*/)) {
                    ShoditFatalniVyjimku("Parametr příkazů musí obsahovat oddělovač „::“!");
                }
                parametr = gensub(/\f/, "", "g", substr(ZR_TEXT[i], 1, RSTART - 1));
                gsub(/\\?-/, "\\-", parametr);
                #gsub(/\\-/, "\f", parametr);
                #gsub("-|\f", "\\-", parametr);
                s = substr(ZR_TEXT[i], RSTART + RLENGTH);
                #ShoditFatalniVyjimku(sprintf("LADĚNÍ: Parametr: <%s>=<%s>+<%s>\n", ZR_TEXT[i], parametr, s));
                printf("%s\n", ParametrPrikazu(\
                    FormatovatRadek(parametr, FR_STAV_MIMO_ZAKLINADLO),
                    FormatovatRadek(s, FR_STAV_MIMO_ZAKLINADLO)));
                break;

            case "POKRAČOVÁNÍ_POLOŽKY_SEZNAMU":
                printf("%s\n", FormatovatRadek(ZR_TEXT[i], FR_STAV_MIMO_ZAKLINADLO));
                break;

            case "DIREKTIVA":
                match(ZR_TEXT[i], /[^!][^:]*:/);
                DIREKTIVA = toupper(substr(ZR_TEXT[i], RSTART, RLENGTH - 1));
                HODNOTA_DIREKTIVY = substr(ZR_TEXT[i], RSTART + RLENGTH);
                if (HODNOTA_DIREKTIVY ~ /^ /) {
                    HODNOTA_DIREKTIVY = substr(HODNOTA_DIREKTIVY, 2);
                }
                #print "LADĚNÍ: Direktiva !" DIREKTIVA "=" HODNOTA_DIREKTIVY "\\n" > "/dev/stderr";
                switch (DIREKTIVA) {
                    case "FIXACEIKON":
                        if (HODNOTA_DIREKTIVY !~ /^([0123456789]+|\*)$/) {ShoditFatalniVyjimku("Neplatný parametr direktivy !FixaceIkon: \"" HODNOTA_DIREKTIVY "\"!")}
                        UCS_IKONY = VYCHOZI_UCS_IKONA;
                        UCS_IKONY_PISMA = VYCHOZI_UCS_IKONA_PISMO;
                        if (HODNOTA_DIREKTIVY ~ /^0+$/) {break} # "!FixaceIkon: 0 vrací výchozí nastavení"
                        if ((getline UCS_IKONY < (SOUBORY_PREKLADU "/ucs_ikony.dat")) && (getline UCS_IKONY_PISMA < (SOUBORY_PREKLADU "/ucs_ikony.dat"))) {
                            close(SOUBORY_PREKLADU "/ucs_ikony.dat");
                        } else {
                            ShoditFatalniVyjimku("Nemohu správně načíst soubor " SOUBORY_PREKLADU "/ucs_ikony.dat!");
                        }
                        if (length(UCS_IKONY) < 1 || length(UCS_IKONY_PISMA) < 1) {
                            UCS_IKONY = VYCHOZI_UCS_IKONA;
                            UCS_IKONY_PISMA = VYCHOZI_UCS_IKONA_PISMO;
                        }
                        if (length(UCS_IKONY) == length(UCS_IKONY_PISMA)) {
                            #print "LADĚNÍ: Načteno " length(UCS_IKONY) " ikon." > "/dev/stderr";
                        } else {
                            ShoditFatalniVyjimku("Interní chyba: počet ikon neodpovídá počtu informací o písmu! (" length(UCS_IKONY) " != " length(UCS_IKONY_PISMA) ")!");
                        }
                        if (HODNOTA_DIREKTIVY == "*") {break}
                        while (HODNOTA_DIREKTIVY > length(UCS_IKONY)) {
                            UCS_IKONY = UCS_IKONY UCS_IKONY;
                            UCS_IKONY_PISMA = UCS_IKONY_PISMA UCS_IKONY_PISMA;
                        }
                        if (HODNOTA_DIREKTIVY < length(UCS_IKONY)) {
                            UCS_IKONY = substr(UCS_IKONY, 1, HODNOTA_DIREKTIVY);
                            UCS_IKONY_PISMA = substr(UCS_IKONY_PISMA, 1, HODNOTA_DIREKTIVY);
                        }
                        break;

                    case "KOMPAKTNÍSEZNAM":
                        #printf("LADĚNÍ: NASTAVIT: NR = (%s); K_S_NR = (%s)\n", NR, KOMPAKTNI_SEZNAM_NR) > "/dev/pts/5";
                        KOMPAKTNI_SEZNAM_NR = NR + 1;
                        break;

                    case "PARAMETRY":
                        if (HODNOTA_DIREKTIVY != "") {
                            ShoditFatalniVyjimku("Direktiva !PARAMETRY nepřijímá žádný parametr!");
                        }
                        # zpracování je jinde
                        break;

                    case "ŠTÍTKY":
                        break;

                    case "ÚZKÝREŽIM":
                        if (toupper(HODNOTA_DIREKTIVY) == "ZAP") {
                            printf("%s", ZapnoutUzkyRezim());
                            JE_ZAPNUTY_UZKY_REZIM = 1;
                        } else if (toupper(HODNOTA_DIREKTIVY) == "VYP") {
                            printf("%s", VypnoutUzkyRezim());
                            JE_ZAPNUTY_UZKY_REZIM = 0;
                        } else {
                            ShoditFatalniVyjimku("Neznámá hodnota direktivy ÚZKÝREŽIM: \"" HODNOTA_DIREKTIVY "\"");
                        }
                        break;

                    case "VZORNÍKIKON":
                        n = length(UCS_IKONY);
                        delete ikony;
                        for (j = 1; j <= n; ++j) {
                            ikony[j] = substr(UCS_IKONY, j, 1) "\t" substr(UCS_IKONY_PISMA, j, 1);
                        }
                        printf("%s", VzornikIkon(n, ikony));
                        delete ikony;
                        break;

                    case "OBLÍBENÁZAKLÍNADLA":
                        if (JE_ZAPNUTY_UZKY_REZIM) {ShoditFatalniVyjimku("Direktiva !OblíbenáZaklínadla není dovolena v úzkém režimu!")}
                        delete indexyOblZakl;
                        delete titulkyOblZakl;
                        pocetOblZakl = 0;
                        for (j = 1; j <= ZR_POCET; ++j) {
                            if (ZR_HES[j] in OBLIBENE_HESE) {
                                ++pocetOblZakl;
                                indexyOblZakl[pocetOblZakl] = j;
                                titulkyOblZakl[pocetOblZakl] = OBLIBENE_HESE[ZR_HES[j]];
                            }
                        }
                        if (pocetOblZakl > 0) {
                            CISLO_OBLIBENEHO_ZAKLINADLA = 0;
                            printf("%s", ZacatekOblibenychZaklinadel(pocetOblZakl));
                            for (j = 1; j <= pocetOblZakl; ++j) {
                                VypsatZaklinadlo(indexyOblZakl[j], 1, titulkyOblZakl[j]);
                            }
                            printf("%s", KonecOblibenychZaklinadel(pocetOblZakl));
                        }
                        break;

                    default:
                        ShoditFatalniVyjimku("Neznámá direktiva na řádku: \"" ZR_TEXT[i] "\"!");
                }
                #
                #    print "LADĚNÍ: Direktiva „" DIREKTIVA "“ = \"" HODNOTA_DIREKTIVY "\"" > "/dev/stderr";
                #
                break;

            case "ZAKLÍNADLO":
                puvodniI = i;
                i += VypsatZaklinadlo(i);
                #printf("LADĚNÍ: i: %d[%d]<%s> => %d[%d]<%s> (posun o %d)\n", puvodniI, ZR_CISLO[puvodniI], ZR_TYP[puvodniI], i, ZR_CISLO[i], ZR_TYP[i], i - puvodniI) > "/dev/stderr";
                break;

            case "POZNÁMKA":
            case "ŘÁDEK_ZAKLÍNADLA":
                ShoditFatalniVyjimku("Vnitřní chyba: Neočekávaný typ řádky: " ZR_TYP[i] "(i = " i ", text:" ZR_TEXT[i] ")");
        }
    }

    # 5. Uzavřít všechny konstrukce a kapitolu
    if (C_PODSEKCE != 0) {UzavritPodsekci()}
    if (C_SEKCE != 0) {UzavritSekci()}
    if (tolower(NAZEV_PODKAPITOLY) == "licence") {
        printf("%s", VypnoutRezimLicence());
    }
    printf("%s", KonecKapitoly(C_KAPITOLY, KAPITOLA, ppcall, pptall));
    return 0;
}

END {
    # Končíme-li s fatální výjimkou, skončit hned.
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
    main();
}
