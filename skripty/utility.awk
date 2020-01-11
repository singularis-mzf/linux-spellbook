# Linux Kniha kouzel, skript utility.awk
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

function max(a, b) {
    return a < b ? b : a;
}

function min(a, b) {
    return a > b ? b : a;
}

function JeBilyZnak(c) {
    return length(c) == 1 && index(" \t\n\r\v", c);
}

function ShoditFatalniVyjimku(popis, cislo) {
    print "gawk: Fatální výjimka v " FILENAME ":" FNR ": " popis | "cat >&2";
    FATALNI_VYJIMKA = max(1, min(cislo, 126));
    exit FATALNI_VYJIMKA;
}

function Zopakovat(text, kolikrat,  vysledek) {
    vysledek = "";
    while (kolikrat > 0) {
        vysledek = vysledek text;
        --kolikrat;
    }
    return vysledek;
}

function SubstrZprava(text, maxDelka) {
    return length(text) >= maxDelka ? substr(text, 1 + length(text) - maxDelka) : "";
}

function PrecistKonfig(sekce, klic, vychoziHodnota,   prikaz, vysledek) {
    if (klic == "") {
        ShoditFatalniVyjimku("Nemohu číst prázdný klíč!");
    }
    prikaz = "bash skripty/precist_konfig.sh \"" sekce "\" \"" klic "\" \"" vychoziHodnota "\" < konfig.ini";
    vysledek = "";
    prikaz | getline vysledek;
    close(prikaz);
    return vysledek;
}

function MesicVDruhemPade(cislo) {
    switch (cislo) {
    case 1:
        return "ledna";
    case 2:
        return "února";
    case 3:
        return "března";
    case 4:
        return "dubna";
    case 5:
        return "května";
    case 6:
        return "června";
    case 7:
        return "července";
    case 8:
        return "srpna";
    case 9:
        return "září";
    case 10:
        return "října";
    case 11:
        return "listopadu";
    case 12:
        return "prosince";
    default:
        ShoditFatalniVyjimku("Neplatné číslo měsíce: " cislo);
        return "";
    }
}

function Escapovat(s) {gsub(/[\\|.*+?{}\\/^$]/, "\\\\&", s);return s;}
function EscapovatKNahrade(s) {gsub(/[\\&]/, "\\\\&", s);return s;}

function GenerovatOmezeneId(prefix, id) {
    gsub(/č/, "c", id);
    gsub(/š/, "s", id);
    gsub(/ť/, "t", id);
    gsub(/ž/, "z", id);
    return prefix substr(tolower(gensub(/[^B-Zb-z0-9]/, "", "g", id)), 1, 16);
}

function Test(parametry) {return !system("test " parametry);}

#
# PRÁCE SE ZÁSOBNÍKY
# ============================================================================
function VyprazdnitZasobnik(zasobnik) {
    delete ZASOBNIKY_VRCHOLY[zasobnik];
    delete ZASOBNIKY[zasobnik];
    return 0;
}

function VelikostZasobniku(zasobnik) {
    return (zasobnik in ZASOBNIKY_VRCHOLY) ? 0 + ZASOBNIKY_VRCHOLY[zasobnik] : 0;
}

function DuplikovatZasobnik(zasobnik_odkud, zasobnik_kam,   i, pocet) {
    if (zasobnik_odkud == zasobnik_kam)
    {
        return VelikostZasobniku(zasobnik_odkud);
    }
    VyprazdnitZasobnik(zasobnik_kam);
    pocet = VelikostZasobniku(zasobnik_odkud);
    for (i = 0; i < pocet; ++i)
    {
        ZASOBNIKY[zasobnik_kam][i] = ZASOBNIKY[zasobnik_odkud][i];
    }
    return pocet;
}

function ObratitZasobnik(zasobnik,   i, pocet) {
    pocet = VelikostZasobniku(zasobnik);
    for (i = 0; i < pocet / 2; ++i) {
        ZASOBNIKY[zasobnik]["tmp"] = ZASOBNIKY[zasobnik][i];
        ZASOBNIKY[zasobnik][i] = ZASOBNIKY[zasobnik][pocet - i - 1];
        ZASOBNIKY[zasobnik][pocet - i - 1] = ZASOBNIKY[zasobnik]["tmp"];
    }
    delete ZASOBNIKY[zasobnik]["tmp"];
    return pocet;
}

function Push(zasobnik, hodnota) {
    return ZASOBNIKY[zasobnik][ZASOBNIKY_VRCHOLY[zasobnik]++] = hodnota;
}

function Pop(zasobnik) {
    if (VelikostZasobniku(zasobnik) > 0) {
        return ZASOBNIKY[zasobnik][--ZASOBNIKY_VRCHOLY[zasobnik]];
    } else {
        return "";
    }
}

function Vrchol(zasobnik) {
    if (VelikostZasobniku(zasobnik) > 0) {
        return ZASOBNIKY[zasobnik][ZASOBNIKY_VRCHOLY[zasobnik] - 1];
    } else {
        return "";
    }
}

#
# SPECIÁLNÍ FUNKCE PRO TENTO PROJEKT
# ============================================================================

function ZjistitPredevsimPro(verze) {
    if (JMENOVERZE ~ /^vanilková příchuť.*[^0-9]1\.[0-9]+$/) {
        return "Ubuntu 18.04 Bionic Beaver";
    } else if (JMENOVERZE ~ /^vanilková příchuť.*[^0-9]2\.[0-9]+$/) {
        return "Ubuntu 20.04 Focal Fossa";
    } else {
        return "";
    }
}
