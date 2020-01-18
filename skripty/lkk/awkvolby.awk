# awkvolby − Modul GNU awk pro zpracování voleb a argumentů na příkazové řádce
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
# PREP_VOLBY["název volby"] = pokud volba přijímá parametr, "jeho poslední hodnota", jinak ""

#
# Soukromé proměnné:
#
# awkvolby_aliasy["alias"] => "název volby"
# awkvolby_priznaky["název volby"] => "příznaky"
# awkvolby_napoveda["název volby"] => "název,alias,alias,...|text nápovědy"
#

#
# Příznaky:
#   1 − Volba se nesmí opakovat.
#   p − Volba vyžaduje parametr.
#   v − Volba přijímá volitelný parametr (vylučuje se s „p“).
#
function DeklarovatVolbu(nazev, alias, priznaky, napoveda, rezervovano,   i) {
    if (!awkvolby_jenazevvolby(nazev)) {awkvolby_chyba("Chybějící či neplatný název volby!")}
    if (alias != "" && !awkvolby_jenazevvolby(alias)) {awkvolby_chyba("Neplatný alias volby: " alias)}
    if (nazev in awkvolby_aliasy) {awkvolby_chyba("Název " nazev " je již alias pro jinou volbu!")}
    if (match(priznaky, /[^1pv]/)) {awkvolby_chyba("Nepodporovaný příznak '" substr(priznaky, RSTART, 1) "' v definici volby " nazev "!")}
    if (priznaky ~ /p/ && priznaky ~ /v/) {awkvolby_chyba("Příznaky „p“ a „v“ se vylučují!")}

    awkvolby_priznaky[nazev] = priznaky;
    awkvolby_napoveda[nazev] = nazev "|" napoveda;

    if (alias != "") {DeklarovatAliasVolby(nazev, alias)}
    return 0;
}

function DeklarovatAliasVolby(nazev, alias) {
    if (!awkvolby_jenazevvolby(nazev)) {awkvolby_chyba("Chybějící či neplatný název volby!")}
    if (alias != "" && !awkvolby_jenazevvolby(alias)) {awkvolby_chyba("Neplatný alias volby: " alias)}
    if (!(nazev in awkvolby_priznaky)) {awkvolby_chyba("Vytvoření aliasu selhalo, protože volba „" nazev "“ nebyla deklarována.")}
    if (alias in awkvolby_aliasy) {awkvolby_chyba("Alias " alias " již byl deklarován.")}
    if (alias in awkvolby_priznaky) {awkvolby_chyba("Deklarovanou volbu " nazev " nelze překrýt aliasem.")}

    awkvolby_aliasy[alias] = nazev;
    sub(/\|/, "," alias "|", awkvolby_napoveda[nazev]);
    return 0;
}

#
# Příznaky:
#   0 − po ukončení zpracování posune celé pole ARGUMENTY o jeden index dolů,
#       takže první argument bude ARGUMENTY[0]; ARGUMENTY[POCET_ARGUMENTU] = ""
#   m − „mixed“: povolí míchání voleb a argumentů nezačínajících „+“ nebo „-“
#
function ZpracovatParametry(priznaky,   i, i_parametru, j, nazev) {
    POCET_ARGUMENTU = POCET_PREPINACU = 0;
    delete ARGUMENTY;
    delete PREPINACE;
    delete PREP_VOLBY;

    i = 1;
    while (i < ARGC && ARGV[i] != "--") {
        if (ARGV[i] ~ /^(--|\+)[^-+=|]/) {
            # Dlouhá volba (tvary „--název“, „--název=hodnota“, „--název hodnota“, „+název“, „+název=hodnota“, „+název hodnota“)
            i_parametru = index(ARGV[i], "=");
            nazev = i_parametru ? substr(ARGV[i], 1, i_parametru - 1) : ARGV[i];
            if (nazev in awkvolby_aliasy) {nazev = awkvolby_aliasy[nazev]}
            if (!(nazev in awkvolby_priznaky)) {
                # Neznámá volba
                awkvolby_chyba("Neznámá dlouhá volba: " ARGV[i]);
            }
            PREPINACE[++POCET_PREPINACU] = nazev;
            if (awkvolby_priznaky[nazev] ~ /1/ && nazev in PREP_VOLBY) {
                awkvolby_chyba("Parametr " nazev " se nesmí opakovat.");
            }
            PREP_VOLBY[nazev] = "";
            if (awkvolby_priznaky[nazev] !~ /[pv]/) {
                # Nepřijímá parametr
                if (i_parametru) {awkvolby_chyba("Nadbytečná hodnota k parametru: " ARGV[i])}
            } else if (i_parametru) {
                # Parametr je již vyplněn
                PREP_VOLBY[nazev] = PREPINACE[POCET_PREPINACU "p"] = substr(ARGV[i], i_parametru + 1);
            } else if (awkvolby_priznaky[nazev] ~ /v/) {
                # Volitelný parametr nebyl zadán
                PREP_VOLBY[nazev] = PREPINACE[POCET_PREPINACU "p"] = "";
            } else if ( i + 1 != ARGC) {
                PREP_VOLBY[nazev] = PREPINACE[POCET_PREPINACU "p"] = ARGV[++i];
            } else {
                awkvolby_chyba("Chybí hodnota k parametru: " ARGV[i]);
            }
        } else if (ARGV[i] ~ /^-[^-+=|]/) {
            # Krátká volba (tvar „-n“, „-mnop“, „-mhodnota“, „-m=hodnota“)
            j = 2;
            while (j <= length(ARGV[i])) {
                nazev = "-" substr(ARGV[i], j, 1);

                if (nazev in awkvolby_aliasy) {nazev = awkvolby_aliasy[nazev]}
                if (!(nazev in awkvolby_priznaky)) {
                    # Neznámá volba
                    awkvolby_chyba("Neznámá krátká volba: " ARGV[i]);
                }
                PREPINACE[++POCET_PREPINACU] = nazev;
                if (awkvolby_priznaky[nazev] ~ /1/ && nazev in PREP_VOLBY) {
                    awkvolby_chyba("Parametr " nazev " se nesmí opakovat.");
                }
                PREP_VOLBY[nazev] = "";
                if (awkvolby_priznaky[nazev] ~ /[pv]/) {
                    if (j < length(ARGV[i])) {
                        # Zbývají nějaké znaky => použít je jako hodnotu.
                        PREP_VOLBY[nazev] = PREPINACE[POCET_PREPINACU "p"] = substr(ARGV[i], j + (substr(ARGV[i], j + 1, 1) == "=" ? 2 : 1));
                        break;
                    } else if (awkvolby_priznaky[nazev] ~ /v/) {
                        # Volitelný parametr chybí
                        PREP_VOLBY[nazev] = PREPINACE[POCET_PREPINACU "p"] = "";
                        break;
                    } else if (i + 1 != ARGC) {
                        PREP_VOLBY[nazev] = PREPINACE[POCET_PREPINACU "p"] = ARGV[++i];
                        break;
                    } else {
                        awkvolby_chyba("Chybí hodnota k parametru „" nazev "“: " ARGV[i]);
                    }
                }
                ++j;
            }
        } else if (ARGV[i] !~ /^[-+]/) {
            if (priznaky !~ /m/) {break}
            ARGUMENTY[++POCET_ARGUMENTU] = ARGV[i];
        } else {
            awkvolby_chyba("Neplatný tvar volby: " ARGV[i]);
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

function awkvolby_chyba(text) {
    printf("awkvolby: %s\n", text) > "/dev/stderr";
    exit 1;
}
