# awkvolby – Modul GNU awk pro zpracování voleb a argumentů na příkazové řádce
#
# Copyright (c) 2020 Singularis
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#
# Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
# podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
# vydané neziskovou organizací Creative Commons. Text licence je přiložený
# k tomuto projektu nebo ho můžete najít na webové adrese:
#
# https://creativecommons.org/licenses/by-sa/4.0/

#
# Použití:
#
# 1. Vložte tento modul na začátek skriptu příkazem „@include "awkvolby.awk"“.
# 2. Funkcemi DeklarovatVolbu() a DeklarovatAliasVolby() deklarujte,
#    které volby váš skript přijímá.
# 3. Zavolejte funkci ZpracovatParametry().
# 4. Zpracujte volby a argumenty. Volby můžete zpracovat buď sekvenčně, nebo logicky.
#

# Veřejné proměnné:
#
# PREPINACE[1..POCET_PREPINACU] = "název volby"
# PREPINACE[1 "p"..POCET_PREPINACU "p"] = "parametr volby"
# ARGUMENTY[1..POCET_ARGUMENTU] = "text argumentu"
# PREP_SKUPINY["název skupiny"] = "název volby" (jen byla-li zadána volba z dané skupiny)
# PREP_VOLBY["název volby"] = pokud volba přijímá parametr, "jeho poslední hodnota", jinak ""

#
# Soukromé proměnné:
#
# awkvolby_aliasy["alias"] => "název volby"
# awkvolby_skupina["název volby"] => "skupina"
# awkvolby_skupiny["skupina"]["název_volby"] = 1 # volby ve skupinách
# awkvolby_priznaky["název volby"] => "příznaky"
# awkvolby_napoveda["název volby"] => "název,alias,alias,...|text nápovědy"
#

#
# Příznaky:
#   1 – Volba se nesmí opakovat.
#   c – Volba typu „počítadlo“; nepřijímá parametr, ale má výchozí hodnotu parametru „1“ a s každým opakováním se inkrementuje.
#       Vylučuje se s~1, p, v.
#   g – Byla-li již zadána jiná volba z téže skupiny, je to fatální chyba (jinak se předchozí volba přepíše).
#   p – Volba vyžaduje parametr.
#   P – Volba vyžaduje neprázdný parametr.
#   v – Volba přijímá volitelný parametr (vylučuje se s „p“).
#
function DeklarovatVolbu(nazev, alias, priznaky, skupina, napoveda,   rezervovano, i) {
    awkvolby_jenazevvolby(nazev) || awkvolby_chyba("Chybějící či neplatný název volby!");
    alias == "" || awkvolby_jenazevvolby(alias) || awkvolby_chyba("Neplatný alias volby: " alias "!");
    (nazev in awkvolby_aliasy) && awkvolby_chyba("Název " nazev " je již alias pro jinou volbu!");
    match(priznaky, /[^1cgpPv]/) && awkvolby_chyba("Nepodporovaný příznak '" substr(priznaky, RSTART, 1) "' v definici volby " nazev "!");
    priznaky ~ /c/ && priznaky ~ /[1pPv]/ && awkvolby_chyba("Příznak „c“ se vylučuje s příznaky „1“, „p“, „P“ a „v“!");
    priznaky ~ /[pP]/ && priznaky ~ /v/ && awkvolby_chyba("Příznaky „p“/„P“ a „v“ se vylučují!");

    awkvolby_priznaky[nazev] = priznaky;
    awkvolby_napoveda[nazev] = nazev "|" napoveda;
    if (skupina != "") {
        awkvolby_skupina[nazev] = skupina;
        awkvolby_skupiny[skupina] = nazev;
    }
    if (alias != "") {
        DeklarovatAliasVolby(nazev, alias);
    }
    return 0;
}

function DeklarovatAliasVolby(nazev, alias) {
    if (!awkvolby_jenazevvolby(nazev)) {awkvolby_chyba("Chybějící či neplatný název volby!")}
    if (alias != "" && !awkvolby_jenazevvolby(alias)) {awkvolby_chyba("Neplatný alias volby!")}
    if (!(nazev in awkvolby_priznaky)) {awkvolby_chyba("Vytvoření aliasu selhalo, protože volba „" nazev "“ nebyla deklarována.")}
    if (alias in awkvolby_aliasy) {awkvolby_chyba("Alias " alias " již byl deklarován.")}
    if (alias in awkvolby_priznaky) {awkvolby_chyba("Deklarovanou volbu " nazev " nelze překrýt aliasem.")}

    awkvolby_aliasy[alias] = nazev;
    sub(/\|/, "," alias "|", awkvolby_napoveda[nazev]);
    return 0;
}

#
# Příznaky:
#   0 – po ukončení zpracování posune celé pole ARGUMENTY o jeden index dolů,
#       takže první argument bude ARGUMENTY[0]; ARGUMENTY[POCET_ARGUMENTU] = ""
#   m – „mixed“: povolí míchání voleb a argumentů nezačínajících „+“ nebo „-“
#   ! ~ zakáže zpracování parametrů zadaných pomocí znaku „=“.
#
function ZpracovatParametry(priznaky,   i, i_parametru, j, nazev) {

    match(priznaky, /[^0m!]/) && awkvolby_chyba("Nepodporovaný příznak: " substr(priznaky, RSTART, 1));

    POCET_ARGUMENTU = POCET_PREPINACU = 0;
    delete ARGUMENTY;
    delete PREPINACE;
    delete PREP_SKUPINY;
    delete PREP_VOLBY;

    i = 1;
    while (i < ARGC && ARGV[i] != "--") {
        if (ARGV[i] ~ /^(--|\+)[^-+=][^+=]*$/) {
            # tvar „--název“, „+název“,, popř. „--název hodnota“ nebo „+název hodnota“
            nazev = awkvolby_prelozitvolbu(ARGV[i]);
            nazev == "" && awkvolby_chyba("Neznámá dlouhá volba: " ARGV[i]);
            if (awkvolby_priznaky[nazev] !~ /[pP]/ || i + 1 >= ARGC) {
                awkvolby_zpracovatprepinac(nazev);
            } else {
                awkvolby_zpracovatprepinac(nazev, 1, ARGV[++i]);
            }
        } else if (ARGV[i] ~ /^(--|\+)[^-+=][^+=]*=/) {
            # tvar „--název-volby=parametr“ nebo „+název-volby=parametr“
            priznaky !~ /!/ || awkvolby_chyba("Zadávání parametrů syntaxí --volba=parametr není podporováno!");
            nazev = awkvolby_prelozitvolbu(gensub(/=.*/, "", 1, ARGV[i]));
            awkvolby_zpracovatprepinac(nazev, 1, gensub(/^[^=]*=/, "", 1, ARGV[i]));
        } else if (ARGV[i] ~ /^-[^-+=|]/) {
            # tvar „-x“ nebo „-xparametr“ (resp. „-xyz“, pokud nepřijímají parametr)
            # také může být „-x parametr“
            j = 2;
            while (j <= length(ARGV[i])) {
                nazev = "-" substr(ARGV[i], j, 1);
                awkvolby_jenazevvolby(nazev) || awkvolby_chyba("Chybný znak ve volbě: '" substr(nazev, 2) "'");
                nazev = awkvolby_prelozitvolbu(nazev);
                nazev == "" && awkvolby_chyba("Neznámá krátká volba \"-" substr(ARGV[i], j, 1) "\" v parametru \"" ARGV[i] "\"!");
                if (j < length(ARGV[i]) && awkvolby_priznaky[nazev] ~ /[pPv]/) {
                    # Použít jako argument zbytek znaků zbytek znaků jako argument
                    awkvolby_zpracovatprepinac(nazev, 1, substr(ARGV[i], j + 1));
                    break;
                } else if (awkvolby_priznaky[nazev] ~ /p/ && i + 1 < ARGC) {
                    awkvolby_zpracovatprepinac(nazev, 1, ARGV[++i]);
                    break;
                } else {
                    awkvolby_zpracovatprepinac(nazev);
                    ++j;
                }
            }
        } else if (ARGV[i] ~ /^[-+]/) {
            awkvolby_chyba("Neplatný tvar volby: " ARGV[i]);
        } else if (priznaky ~ /m/){
            ARGUMENTY[++POCET_ARGUMENTU] = ARGV[++i];
            continue;
        } else {
            break;
        }
        ++i
    }
    if (i < ARGC && ARGV[i] == "--") {++i}
    while (i < ARGC) {
        ARGUMENTY[++POCET_ARGUMENTU] = ARGV[i++];
    }
    if (priznaky ~ /0/) {
        for (i = 0; i < POCET_ARGUMENTU; ++i) {
            ARGUMENTY[i] = ARGUMENTY[i + 1];
        }
        ARGUMENTY[POCET_ARGUMENTU] = "";
    }
    return POCET_ARGUMENTU + POCET_PREPINACU;
}

function awkvolby_jenazevvolby(nazev) {
    return nazev ~ /^(\+|--)[^-+=][^=]*$|^-[^-+=]$/;
}

function awkvolby_zpracovatprepinac(nazev, ma_parametr, parametr) {
    if (awkvolby_priznaky[nazev] ~ /1/ && nazev in PREP_VOLBY) {
        awkvolby_chyba("Volba " nazev " se nesmí opakovat!");
    }
    if (ma_parametr && awkvolby_priznaky[nazev] !~ /[pPv]/) {
        awkvolby_chyba("Nadbytečný parametr volby " nazev "!");
    }
    if (awkvolby_priznaky[nazev] ~ /P/ && (!ma_parametr || parametr == "")) {
        awkvolby_chyba("Volba " nazev " vyžaduje neprázdný parametr!");
    }
    if (awkvolby_priznaky[nazev] ~ /p/ && !ma_parametr) {
        awkvolby_chyba("Volba " nazev " vyžaduje parametr!");
    }
    PREPINACE[++POCET_PREPINACU] = nazev;
    if (awkvolby_priznaky[nazev] ~ /c/) {
        #print "LADĚNÍ: c: PREP_VOLBY[\"" nazev "\"] <= " PREP_VOLBY[nazev] > "/dev/stderr";
        PREPINACE[POCET_PREPINACU "p"] = ++PREP_VOLBY[nazev];
        #print "LADĚNÍ: c: PREP_VOLBY[\"" nazev "\"] => " PREP_VOLBY[nazev] > "/dev/stderr";
    } else if (ma_parametr) {
        PREPINACE[POCET_PREPINACU "p"] = PREP_VOLBY[nazev] = parametr;
    } else {
        PREP_VOLBY[nazev] = "";
    }
    if (nazev in awkvolby_skupina && PREP_SKUPINY[awkvolby_skupina[nazev]] != nazev) {
        if (awkvolby_skupina[nazev] in PREP_SKUPINY) {
            awkvolby_priznaky[nazev] !~ /g/ || awkvolby_chyba("Jen jedna z voleb „" PREP_SKUPINY[awkvolby_skupina[nazev]] "“ a „" nazev "“ může být zadána!");
            delete PREP_VOLBY[PREP_SKUPINY[awkvolby_skupina[nazev]]];
            delete PREP_VOLBY[PREP_SKUPINY[awkvolby_skupina[nazev]] "p"];
        }
        PREP_SKUPINY[awkvolby_skupina[nazev]] = nazev;
    }
    return "";
}

function awkvolby_prelozitvolbu(nazev,   vysledek) {
    awkvolby_jenazevvolby(nazev) || awkvolby_chyba("\"" nazev "\" není platný název volby!");
    if (nazev in awkvolby_aliasy) {
        vysledek = awkvolby_aliasy[nazev];
    } else if (nazev in awkvolby_priznaky) {
        vysledek = nazev;
    } else {
        vysledek = "";
    }
    #print "LADĚNÍ: překlad „" nazev "“ => „" vysledek "“ [" (vysledek in awkvolby_priznaky ? awkvolby_priznaky[vysledek] : "") "]" > "/dev/stderr";
    return vysledek;
}

function awkvolby_chyba(text) {
    printf("awkvolby: %s\n", text) > "/dev/stderr";
    exit 1;
}
