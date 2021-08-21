# Linux Kniha kouzel, skript utility.awk
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

function SubstrZleva(text, maxDelka) {
    return length(text) > maxDelka ? substr(text, 1, maxDelka) : text;
}

function SubstrZprava(text, maxDelka) {
    return length(text) > maxDelka ? substr(text, 1 + length(text) - maxDelka) : text;
}

function PrecistKonfig(sekce, klic, vychoziHodnota,   prikaz, vysledek) {
    if (klic == "") {
        ShoditFatalniVyjimku("Nemohu číst prázdný klíč!");
    }
    prikaz = "bash skripty/přečíst-konfig.sh \"" sekce "\" \"" klic "\" \"" vychoziHodnota "\" < konfigurace/konfig.ini";
    vysledek = "";
    prikaz | getline vysledek;
    close(prikaz);
    return vysledek;
}

function PrvekPole(pole, ind, nahrHodnota) {
    return isarray(pole) && ind in pole ? pole[ind] : nahrHodnota;
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

function Odzvlastnit(s) {gsub(/[\\|.*+?{}\\/^$]/, "\\\\&", s);return s;}
function OdzvlastnitKNahrade(s) {gsub(/[\\&]/, "\\\\&", s);return s;}

function Test(parametry) {return !system("test " parametry);}

function BezDiakritiky(s,   t, c, i, bd) {
    gsub(/á/, "a", s); gsub(/Á/, "A", s);
    gsub(/č/, "c", s); gsub(/Č/, "C", s);
    gsub(/ď/, "d", s); gsub(/Ď/, "D", s);
    gsub(/[éě]/, "e", s); gsub(/[ÉĚ]/, "E", s);
    gsub(/í/, "i", s); gsub(/Í/, "I", s);
    gsub(/ň/, "n", s); gsub(/Ň/, "N", s);
    gsub(/ó/, "o", s); gsub(/Ó/, "O", s);
    gsub(/ř/, "r", s); gsub(/Ř/, "R", s);
    gsub(/š/, "s", s); gsub(/Š/, "S", s);
    gsub(/ť/, "t", s); gsub(/Ť/, "T", s);
    gsub(/[úů]/, "u", s); gsub(/[ÚŮ]/, "U", s);
    gsub(/ý/, "y", s); gsub(/Ý/, "Y", s);
    gsub(/ž/, "z", s); gsub(/Ž/, "Z", s);
    gsub(/[^\-\]\\ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 !"#$%&'()*+,./:;<=>?@^_`{}|~[]/, "", s); # "
    return s;
}

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
    if (JMENOVERZE ~ /^vanilková příchuť.*[^0-9]1\.[0-9]+(,.*)?$/) {
        return "Ubuntu 18.04 Bionic Beaver";
    } else if (JMENOVERZE ~ /^vanilková příchuť.*[^0-9]2\.[0-9]+(,.*)?$/) {
        return "Ubuntu 20.04 Focal Fossa";
    } else {
        return "";
    }
}

function ZjistitOznaceniVerze(textverze, pridatZkratku,   i, s) {
    if ((i = index(textverze, ",")) != 0) {
        s = substr(textverze, i + 1);
        gsub(/^\s*|\s*,.*$/, "", textverze);
        if (pridatZkratku) {
            if (s !~ /^\s*[Cc][Hh]/) {
                gsub(/\s+/, " ", s);
                gsub(/^\s|\s$/, "", s);
                s = toupper(substr(s, 1, 1)) ".";
            } else {
                s = "Ch.";
            }
            textverze = textverze ", " s " " s;
        }
    }
    return textverze;
}

function ZjistitJmenoVerze(textverze,   i) {
    i = index(textverze, ",");
    return i != 0 ? gensub(/^\s*|\s*$/, "", "g", substr(textverze, i + 1)) : "";
}

function NacistFragmentyTSV(soubor,   oldFS, oldRS, oldLN, i, vystupMax, nevystupMax, plneId) {
    delete FRAGMENTY;
    vystupMax = 0; # max. číslo fragmentu na výstup
    nevystupMax = 0; # počítadlo fragmentů ne-na-výstup
    oldFS = FS; oldRS = RS; oldLN = $0;
    FS = "\t"; RS = "\n";

    while (getline < soubor) {
        if ($1 != 0) {
            # je na výstup ($1 = číslo na výstupu)
            i = $1;
            if ($1 > vystupMax) {vystupMax = $1}
        } else {
            i = -(++nevystupMax);
        }
        FRAGMENTY[i] = $0;
        FRAGMENTY["id/" $2] = i;
        FRAGMENTY[i "/plné-id"] = $2;
        FRAGMENTY[i "/ploché-id"] = $3;
        FRAGMENTY[i "/holé-id"] = $4;
        FRAGMENTY[i "/název-podkapitoly"] = $5;
        FRAGMENTY[i "/adresář"] = $6;
        FRAGMENTY[i "/příznaky"] = $7;
        FRAGMENTY[i "/xheš"] = $8;
        FRAGMENTY[i "/id-nadkapitoly"] = $9;
        FRAGMENTY[i "/celý-název"] = $10 == "NULL" ? $5 : $10 " / " $5;
        FRAGMENTY[i "/štítky"] = $11;
        FRAGMENTY[i "/ikkap"] = $12;
        FRAGMENTY[i "/ploché-id-bez-diakr"] = $13;
        FRAGMENTY[i "/symbol"] = $14;
    }
    close(soubor);

    FS = oldFS; RS = oldRS; $0 = oldLN;
    FRAGMENTY["počet"] = vystupMax;
    FRAGMENTY["početnevýstup"] = nevystupMax;
    return vystupMax;
}

function FragInfo(a, b,   x) {
    if (!(1 in FRAGMENTY)) {
        ShoditFatalniVyjimku("fragmenty.tsv nejsou načteny!");
    }
    if (a ~ /^[^-0-9]/ && b == "") {
        # Použití A: zadává se celé id; vrací číslo
        #   pokud fragment nekončí otazníkem, musí existovat
        #   pokud končí otazníkem, pro neexistující fragmenty vrací 0
        # Příklady:
        #   c = FragInfo("diskové-oddíly/lvm");
        #   c = FragInfo("diskové-oddíly/lvm?");
        #
        if (a ~ /[^?]$/) {
            if (("id/" a) in FRAGMENTY) {
                return FRAGMENTY["id/" a];
            } else {
                ShoditFatalniVyjimku("FragInfo: Neznámé id fragmentu \"" a "\"!");
            }
        } else {
            sub(/\?$/, "", a);
            return (("id/" a) in FRAGMENTY) ? FRAGMENTY["id/" a] : 0;
        }
    } else if (a ~ /^-?[0-9]+$/ && b != "") {
        # Použití B: zadává se číslo, vrací informaci
        # Příklad:
        #   if (FragInfo(15, "existuje")) {s = FragInfo(15, "celý-název")}
        #
        if (!((a "/plné-id") in FRAGMENTY)) {
            if (b == "existuje") {return 0}
            ShoditFatalniVyjimku("FragInfo: Neznámé číslo fragmentu: " a "!");
        }
        switch (b) {
        case "existuje": return 1;
        case "plné-id": x = FRAGMENTY[a "/plné-id"]; break;
        case "ploché-id": x = FRAGMENTY[a "/ploché-id"]; break;
        case "holé-id": x = FRAGMENTY[a "/holé-id"]; break;
        case "název-podkapitoly": x = FRAGMENTY[a "/název-podkapitoly"]; break;
        case "adresář": x = FRAGMENTY[a "/adresář"]; break;
        case "příznaky": x = FRAGMENTY[a "/příznaky"]; break;
        case "xheš": x = FRAGMENTY[a "/xheš"]; break;
        case "id-nadkapitoly": x = FRAGMENTY[a "/id-nadkapitoly"]; break;
        case "číslo-nadkapitoly":
            x = FRAGMENTY[a "/id-nadkapitoly"];
            x = x == "NULL" ? 0 : FRAGMENTY["id/" x];
            break;
        case "celý-název": x = FRAGMENTY[a "/celý-název"]; break;
        case "štítky": x = FRAGMENTY[a "/štítky"]; break;
        case "ikona-kapitoly": x = FRAGMENTY[a "/ikkap"]; break;
        case "ploché-id-bez-diakr": x = FRAGMENTY[a "/ploché-id-bez-diakr"]; break;
        case "symbol": x = FRAGMENTY[a "/symbol"]; break;
        default:
            ShoditFatalniVyjimku("FragInfo: vyžadována naznámá informace \"" b "\"!");
        }
        if (x == "") {
            ShoditFatalniVyjimku("FragInfo: k fragmentu číslo \"" a "\" chybí informace \"" b "\"!");
        } else if (x == "NULL") {
            return "";
        } else {
            return x;
        }
    } else if (a == "" && b != "") {
        # Použití C: vrací globální informace
        # Příklad:
        #   n = FragInfo("", "počet");
        #
        switch (b) {
        case "počet":
            return FRAGMENTY["počet"];
        case "počet-nevýstup":
            return FRAGMENTY["početnevýstup"];
        default:
            ShoditFatalniVyjimku("Neznámá globální informace \"" b "\"!");
        }
    } else {
        ShoditFatalniVyjimku("Chybné použití FragInfo(\"" a "\", \"" b "\")!");
    }
}

function OmezitNazev(s, ponechatCestu) {
# Postup (viz skript „omezit-název.sh“):
#   1. Převést na malá písmena.
    s = tolower(s);
#   2. Obsahuje-li řetězec /, odstranit vše až po poslední výskyt „/“ včetně.
    if (!ponechatCestu) {sub(/.*\//, "", s)}
#   3. Odstranit diakritiku.
    s = BezDiakritiky(s);
#   4. Sekvence znaků „-“ a „_“ nahradit jednou pomlčkou.
    gsub(/[-_]+/, "-", s);
#   5. Případnou pomlčku na začátku nebo na konci řetězce vypustit.
    gsub(/^-|-$/, "", s);
    if (ponechatCestu) {gsub(/-\/|\/-/, "/", s)}

    return s;
}

# HtmlDivOdkaz(int indexFragmentu, bool iPodkapitoly) -> string
function HtmlDivOdkaz(fragIndex, cislaPodkapitol,   i, priznaky, vysl, plneId, podkapitoly, podkapitolyPocet) {
    if (!FragInfo(fragIndex, "existuje")) {
        ShoditFatalniVyjimku("Nemohu vypsat odkaz na neexistující fragment č. " fragIndex "!");
    }
    delete podkapitoly;
    podkapitolyPocet = cislaPodkapitol == "" ? 0 : split(cislaPodkapitol, podkapitoly, /\s+/);
    for (i = 1; i <= podkapitolyPocet; ++i) {
        if (!FragInfo(podkapitoly[i], "existuje")) {
            ShoditFatalniVyjimku("Nemohu vypsat odkaz na neexistující fragment č. " podkapitoly[i] "!");
        }
    }

    vysl = "<div class=\"fragodkaz\">" \
        "<span class=\"ikona\"><img src=\"obrazky/" OmezitNazev(FragInfo(fragIndex, "ikona-kapitoly"), 1) "\" alt=\"[]\"></span>" \
        "<span class=\"fragodkazy\">";
    priznaky = FragInfo(fragIndex, "příznaky");
    if (priznaky ~ /z/) {
        vysl = vysl "<a href=\"" FragInfo(fragIndex, "ploché-id-bez-diakr") ".htm\" class=\"odkaz\"><span><span class=\"cislo\">" FragInfo(fragIndex, "symbol") "</span>";
    } else {
        vysl = vysl "<span class=\"odkaz\"><span class=\"cislo\"></span>";
    }
    vysl = vysl FragInfo(fragIndex, "celý-název") "</span>" (priznaky ~ /z/ ? "</a>" : "");
    if (podkapitolyPocet > 0) {
        vysl = vysl "<span class=\"podkpodkazy\">";
        for (i = 1; i <= podkapitolyPocet; ++i) {
            plneId = FragInfo(podkapitoly[i], "plné-id");
            priznaky = FragInfo(podkapitoly[i], "příznaky");
            if (priznaky ~ /z/) {
                vysl = vysl "<a href=\"" FragInfo(podkapitoly[i], "ploché-id-bez-diakr") ".htm\" class=\"odkaz\"><span><span class=\"cislo\">" FragInfo(podkapitoly[i], "symbol") "</span>";
            } else {
                vysl = vysl "<span class=\"odkaz\"><span class=\"cislo\"></span>";
            }
            vysl = vysl FragInfo(podkapitoly[i], "název-podkapitoly") "</span>"
            if (priznaky ~ /z/) {vysl = vysl "</a>"}
        }
        vysl = vysl "</span>";
    }
    vysl = vysl "</span></div>";
    return vysl;
}

function NajitPodkapitoly(fragIndex, jenNaVystup,   plneId, vysl)
{
    plneId = FragInfo(fragIndex, "plné-id");
    vysl = "";
    # optimalizace:
    # - podkapitola nemůže mít další podkapitoly
    # - má-li fragment podkapitoly na výstup, má nastavený příznak "N"
    if (plneId ~ /\// || (jenNaVystup && FragInfo(fragIndex, "příznaky") !~ /N/)) {return ""}

    for (i = 1; FragInfo(i, "existuje"); ++i) {
        if (FragInfo(i, "id-nadkapitoly") == plneId) {
            vysl = vysl " " i;
        }
    }
    if (!jenNaVystup) {
        for (i = -1; FragInfo(i, "existuje"); --i) {
            if (FragInfo(i, "id-nadkapitoly") == plneId) {
                vysl = vysl " " i;
            }
        }
    }
    sub(/^ /, "", vysl);
    return vysl;
}
