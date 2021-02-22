# Linux Kniha kouzel, skript extrakce/pdf-záložky.awk
# Copyright (c) 2020 Singularis <singularis@volny.cz>
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
    FS = "\t";
    OFS = "";
    RS = ORS = "\n";

    SOUBORY_PREKLADU = ENVIRON["SOUBORY_PREKLADU"];
    if (SOUBORY_PREKLADU == "") {ShoditFatalniVyjimku("Proměnná SOUBORY_PREKLADU není nastavena!")}
    if (ARGC != 2) {ShoditFatalniVyjimku("Skript vyžaduje právě jeden vstupní soubor!")}

    KNIHA_TOC = ARGV[1];
    delete id_na_cislo;
    delete pocty_podkapitol;
    cislo_kapitoly = 0;
    NacistFragmentyTSV(SOUBORY_PREKLADU "/fragmenty.tsv");
    while (FragInfo(cislo_kapitoly + 1, "existuje")) {
        ++cislo_kapitoly;
        id_na_cislo[FragInfo(cislo_kapitoly, "ploché-id")] = cislo_kapitoly;
        ARGV[cislo_kapitoly] = SOUBORY_PREKLADU "/osnova/" FragInfo(cislo_kapitoly, "ploché-id") ".tsv";
        
        pocet_podkapitol = 0;
        while (FragInfo(2 + cislo_kapitoly + pocet_podkapitol, "existuje") && \
               FragInfo(2 + cislo_kapitoly + pocet_podkapitol, "číslo-nadkapitoly") == 1 + cislo_kapitoly) {
            ++pocet_podkapitol;
        }
        pocty_podkapitol[cislo_kapitoly + 1] = pocet_podkapitol;
    }
    if (cislo_kapitoly == 0) {ShoditFatalniVyjimku("Ve fragmenty.tsv nenalezena žádná kapitola!")}
    ARGV[cislo_kapitoly + 1] = KNIHA_TOC;
    ARGC = cislo_kapitoly + 2;

    delete nazvy;
    delete pocty;
    delete kody;

    for (i = 0; i <= 9; ++i) {kody[i] = "003" i}
    kody[" "] = "0020"; kody["."] = "002E";
    kody["("] = "0028"; kody[")"] = "0029";
    kody["["] = "005B"; kody["]"] = "005D";
    kody["{"] = "007B"; kody["]"] = "007D";
}

BEGINFILE {
    je_toc = (ARGIND == ARGC - 1);
    if (je_toc) {
        FS = " ";
        cislo_kapitoly = 0;

        # konverze:
        # printf '\uFEFF%s' "text" | iconv -f UTF-8 -t UTF-16BE | xxd -p -u -c 640
        #
        # „Linux: Kniha kouzel“
        print "[/Title <FEFF004C0069006E00750078003A0020004B006E0069006800610020006B006F0075007A0065006C>";

        # „Singularis a přispěvatelé“
        print " /Author <FEFF00530069006E00670075006C00610072006900730020006100A000700159006900730070011B0076006100740065006C00E9>";

        # „Svobodný software použitelný v Ubuntu“
        print " /Subject <FEFF00530076006F0062006F0064006E00FD00200073006F00660074007700610072006500200070006F0075017E006900740065006C006E00FD0020007600A0005500620075006E00740075>";

        # „kniha, Ubuntu, slovník, tisk, svobodný software“
        print " /Keywords <FEFF006B006E006900680061002C0020005500620075006E00740075002C00200073006C006F0076006E00ED006B002C0020007400690073006B002C002000730076006F0062006F0064006E00FD00200073006F006600740077006100720065>";

        print " /DOCINFO pdfmark";
    } else {
        FS = "\t";
        cislo_kapitoly = id_na_cislo[gensub(/^.*\/|\.tsv$/, "", "g", ARGV[ARGIND])];
        if (cislo_kapitoly == "") {ShoditFatalniVyjimku("Nedokážu určit číslo kapitoly ze souboru \"" ARGV[ARGIND] "\"! (ARGIND == " ARGIND ", ARGC == " ARGC ", FILE = " ARGV[ARGIND] ")")}
    }
    cislo_sekce = cislo_podsekce = 0;
}


!je_toc && $1 == "KAPITOLA" {
    nazvy[cislo_kapitoly] = NacistNazev($5, cislo_kapitoly " ");
    pocty[cislo_kapitoly] = 0;
    cislo_sekce = 0;
    cislo_podsekce = 0;
}
!je_toc && $1 == "SEKCE" {
    nazvy[cislo_kapitoly "/" ++cislo_sekce] = NacistNazev($5);
    pocty[cislo_kapitoly] += 1;
    pocty[cislo_kapitoly "/" cislo_sekce] = 0;
    cislo_podsekce = 0;
}

!je_toc && $1 == "PODSEKCE" {
    ++cislo_podsekce;
    nazvy[cislo_kapitoly "/" cislo_sekce "/" cislo_podsekce] = NacistNazev($5, cislo_sekce "." cislo_podsekce " ");
    pocty[cislo_kapitoly "/" cislo_sekce] += 1;
}

je_toc && $0 ~ /^\\contentsline \{(chapter|section|subsection)\}.*\{[^{}]+\}[% ]*$/ {
    gsub(/[% ]*$/, "");
    match($0, /\{[^{}]+\}/);
    typ = substr($0, RSTART + 1, RLENGTH - 2);
    match($0, /\{[^{}]+\}$/);
    page = substr($0, RSTART + 1, RLENGTH - 2);


    #
    # styl: 0 = normální; 1 = kurzíva; 2 = tučně; 3 = tučná kurzíva
    switch (typ) {
        case "chapter":
            ++cislo_kapitoly;
            cislo_sekce = cislo_podsekce = 0;
            count = -(pocty[cislo_kapitoly] + pocty_podkapitol[cislo_kapitoly]);
            title = nazvy[cislo_kapitoly];
            styl = 2;
            break;

        case "section":
            ++cislo_sekce;
            cislo_podsekce = 0;
            count = pocty[cislo_kapitoly "/" cislo_sekce];
            title = nazvy[cislo_kapitoly "/" cislo_sekce];
            styl = 0;
            break;

        case "subsection":
            ++cislo_podsekce;
            count = 0;
            title = nazvy[cislo_kapitoly "/" cislo_sekce "/" cislo_podsekce];
            styl = 0;
            break;

        default:
            ShoditFatalniVyjimku("Interní chyba: " + typ);
    }

    if (title == "" || page == "") {
        ShoditFatalniVyjimku("Interní chyba: (" cislo_kapitoly "," cislo_sekce "," cislo_podsekce "," typ, "," page "," count, "," title ",„" $0 "“)");
    }

    print "[", count == 0 ? "" : ("/Count " count " "),
        "/Title <", title, ">", styl != 0 ? " /F " styl : "", " /Page " page " /OUT pdfmark";
}

function NacistNazev(s, predpona) {
    gsub(/\\u/, "", s);
    return substr(s, 1, 4) ZakodovatRetezec(predpona) substr(s, 5);
}

function ZakodovatRetezec(s,   i, t) {
    if (s == "") {return ""}
    t = "";
    for (i = 1; i <= length(s); ++i) {
        if (substr(s, i, 1) in kody) {
            t = t kody[substr(s, i, 1)];
        } else {
            ShoditFatalniVyjimku("Neumím zakódovat znak: " substr(s, i, 1));
        }
    }
    return t;
}

END {
    # Končíme-li s fatální výjimkou, skončit hned.
    if (FATALNI_VYJIMKA) {
        exit FATALNI_VYJIMKA;
    }
}
