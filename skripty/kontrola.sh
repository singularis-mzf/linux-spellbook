#!/bin/bash
# Linux Kniha kouzel, skript kontrola.sh
# Copyright (c) 2021 Singularis <singularis@volny.cz>
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

# Volání:
# skripty/kontrola.sh

# Základní kontroly
printf 'Kontroluji základní příkazy:'
if
    printf ' which' && ! type which >/dev/null ||
    printf ' bash' && ! which bash >/dev/null ||
    printf ' tput' && ! which tput >/dev/null
then
    printf '(chybí!)\n'
    exit 1
fi
printf '\n\n'

{
reset=$(tput sgr0)
cervena=$(tput setaf 1; tput bold)
zelena=$(tput setaf 2; tput bold)
} 2>/dev/null

function mam_prikaz
{
    which -- "$1"
    return $?
} &>/dev/null

# GNU sed (musí být zkontrolován přednostně)
if mam_prikaz sed
then
    sed_verze=$(sed --version | head -n 1)
    regex='GNU sed'
    if [[ $sed_verze =~ $regex ]]
    then
        printf "[${zelena}sed${reset}]\\t\\tV pořádku, byl nalezen GNU sed\\n"
        x_sed=0
    else
        printf "[${cervena}sed${reset}]\\t\\tByl nalezen sed, který není z projektu GNU. Překlad nemusí fungovat.\\n"
        x_sed=1
    fi
else
    printf "[${cervena}sed${reset}]\\t\\tChybí GNU sed! Překlad nebude fungovat.\\n"
    x_sed=1
fi


# Git
if mam_prikaz git
then
    printf "[${zelena}git${reset}]\\t\\tV pořádku, git byl nalezen.\\n"
    x_git=0
else
    printf "[${cervena}git${reset}]\\t\\tChybí git! Překlad však může fungovat, pokud máte zdrojový kód získaný jiným způsobem.\\n"
    x_git=1
fi

# GNU awk 5.0 nebo novější
if mam_prikaz gawk
then
    gawk_verze=$(gawk --version | sed -nE '1{s/^[^0-9.]*([0-9]+)\..*$/\1/;p}')
    if test "$gawk_verze" -ge 5
    then
        printf "[${zelena}gawk${reset}]\\t\\tV pořádku, bylo nalezeno GNU awk verze 5.0 nebo vyšší.\\n"
        x_gawk=0
    else
        printf "[${cervena}gawk${reset}]\\t\\tBylo nalezeno GNU awk verze nižší než 5.0! Překlad nemusí fungovat.\\n"
        x_gawk=1
    fi
else
    printf "[${cervena}gawk${reset}]\\t\\tChybí GNU awk! Překlad nebude fungovat.\\n"
    x_gawk=1
fi

# GNU make
if mam_prikaz make
then
    x=$(make --version)
    regex='^GNU Make'
    if [[ $x =~ $regex ]]
    then
        printf "[${zelena}make${reset}]\\t\\tV pořádku, byl nalezen GNU make.\\n"
        x_make=0
    else
        printf "[${cervena}make${reset}]\\t\\tByl nalezen příkaz „make“, ale nikoliv z projektu GNU! Překlad nemusí fungovat.\\n"
        x_make=1
    fi
else
    printf "[${cervena}make${reset}] Chybí GNU make! Překlad nebude fungovat.\\n"
    x_make=1
fi

# ImageMagick
if mam_prikaz convert
then
    printf "[${zelena}convert${reset}]\\tV pořádku, byl nalezen nějaký ImageMagick\\n"
    x_imagemagick=0
else
    printf "[${cervena}convert${reset}]\\tChybí ImageMagick! Překlad nebude fungovat.\\n"
    x_imagemagick=1
fi

# Perl 5.26
if mam_prikaz perl
then
    if perl -Mv5.26 -e ';' &>/dev/null
    then
        printf "[${zelena}perl${reset}]\\t\\tV pořádku, byl nalezen Perl 5.26 nebo novější\\n"
        x_perl=0
    else
        printf "[${cervena}perl${reset}]\\tByl nalezen Perl starší než 5.26, nebo jinak nefunkční. Překlad nebude fungovat.\\n"
        x_perl=1
    fi
else
    printf "[${cervena}perl${reset}]\\tChybí Perl! Překlad nebude fungovat.\\n"
    x_perl=1
fi

# GhostScript
if mam_prikaz gs
then
    printf "[${zelena}gs${reset}]\\t\\tV pořádku, byl nalezen GhostScript.\\n"
    x_gs=0
else
    printf "[${cervena}gs${reset}]\\t\\tChybí GhostScript. Překlad do PDF nebude fungovat, pokud nevypnete záložky kapitol.\\n"
    x_gs=1
fi

# rsvg-convert
if mam_prikaz rsvg-convert
then
    printf "[${zelena}rsvg-convert${reset}]\\tV pořádku, byl nalezen rsvg-convert.\\n"
    x_rsvg_convert=0
else
    printf "[${cervena}rsvg-convert${reset}]\\tChybí rsvg-convert. Překlad do PDF nebude fungovat.\\n"
    x_rsvg_convert=1
fi

# qrencode
if mam_prikaz qrencode
then
    printf "[${zelena}qrencode${reset}]\\tV pořádku, byla nalezena qrencode.\\n"
    x_qrencode=0
else
    printf "[${cervena}qrencode${reset}]\\tChybí qrencode. Překlad do PDF nebude fungovat.\\n"
    x_qrencode=1
fi

# iconv
if mam_prikaz iconv
then
    printf "[${zelena}iconv${reset}]\\t\\tV pořádku, byl nalezen iconv.\\n"
    x_iconv=0
else
    printf "[${cervena}iconv${reset}]\\t\\tChybí iconv. Překlad do PDF nemusí fungovat.\\n"
    x_iconv=1
fi

# xxd
if mam_prikaz xxd
then
    printf "[${zelena}xxd${reset}]\\t\\tV pořádku, byl nalezen xxd.\\n"
    x_xxd=0
else
    printf "[${cervena}xxd${reset}]\\t\\tChybí xxd. Překlad do PDF nemusí fungovat.\\n"
    x_xxd=1
fi

# české řazení příkazem sort
vysledek=$(printf %s\\n žába čádor tábor chalupa | LC_ALL="cs_CZ.UTF-8" sort | tr '\n' ':')
if test "$vysledek" = "čádor:chalupa:tábor:žába:"
then
    printf "[${zelena}sort${reset}]\\t\\tV pořádku, české řazení funguje, jak má.\\n"
    x_sort=0
else
    printf "[${cervena}sort${reset}]\\t\\tČeské řazení příkazem „sort“ nefunguje. Pořadí kapitol může být chybné.\\n"
    x_sort=1
fi

# dpkg-deb
if mam_prikaz dpkg-deb
then
    printf "[${zelena}dpkg-deb${reset}]\\tV pořádku, DPKG je dostupné.\\n"
    x_dpkg=0
else
    printf "[${cervena}dpkg-deb${reset}]\\tDPKG chybí. Nepůjde sestavit balíček DEB (ale překlad do ostatních formátů může fungovat).\\n"
    x_dpkg=1
fi

# XeLaTeX (kontrolovat jako poslední)
if mam_prikaz xelatex
then
    tmp_adr="$$-kontrola.sh"
    mkdir "/tmp/$tmp_adr"
    (
        x_xelatex=0 predpona=$'/^%$/i\\\n'
        cd "/tmp/$tmp_adr"
        printf %s\\n '\documentclass{book}' '%' '\begin{document}' '\end{document}' >test.tex
        if ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX není funkční. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage[czech,english]{babel}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {babel}. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage[xetex,layout=a4paper,inner=1.5cm,outer=1cm,top=2cm,bottom=1.5cm,twoside,layouthoffset=8mm,layoutvoffset=8mm,papersize={22.6cm,31.3cm}]{geometry}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {geometry}. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage[xetex,table]{xcolor}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {xcolor}. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage{changepage}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {changepage}. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage{dashbox}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {dashbox}. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage{enumitem}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {enumitem}. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage{etoolbox}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {etoolbox}. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage{fancyhdr}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {fancyhdr}. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage{fontspec}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {fontspec}. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage[bottom]{footmisc}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {footmisc}. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage[xetex]{graphicx}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {graphicx}. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage{multicol}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {multicol}. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage{tabu}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {tabu}. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage{tcolorbox}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {tcolorbox}. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage{titlesec}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {titlesec}. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage[titles]{tocloft}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {tocloft}. Překlad do PDF nemusí fungovat.\\n"
        elif sed -i -E "$predpona"'\\usepackage{verbatim}' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
        then
            x_xelatex=1
            printf "[${cervena}xelatex${reset}]\\tXeLaTeX selhal u balíčku {verbatim}. Překlad do PDF nemusí fungovat.\\n"
        else
            printf "[${zelena}xelatex${reset}]\\tV pořádku, XeLaTeX funguje a má potřebné balíčky.\\n"
        fi
        cd ..
        #rm -Rf "$$-kontrola.sh"
        exit $x_xelatex
    ) </dev/null
    x_xelatex=$?
    
    x_fonty=$x_xelatex
    if test $x_xelatex -eq 0
    then
        (
            cd "/tmp/$tmp_adr"
            sed -i -E '/^%$/d;/^\\end\{document\}/s/^/\\fontspec{}\nABC\n/' test.tex
            if pismo='DejaVu Sans'; sed -i -E '/^\\fontspec/s/.*/\\fontspec{'"$pismo"'}%/' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
            then
                x_fonty=1
                printf "[${cervena}xelatex: ${pismo}${reset}]\\tPožadované písmo ${pismo} chybí. Překlad do PDF nemusí fungovat.\\n"
            elif pismo='Latin Modern Math'; sed -i -E '/^\\fontspec/s/.*/\\fontspec{'"$pismo"'}%/' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
            then
                x_fonty=1
                printf "[${cervena}xelatex: ${pismo}${reset}]\\tPožadované písmo ${pismo} chybí. Překlad do PDF nemusí fungovat.\\n"
            elif pismo='Latin Modern Mono Slanted'; sed -i -E '/^\\fontspec/s/.*/\\fontspec{'"$pismo"'}%/' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
            then
                x_fonty=1
                printf "[${cervena}xelatex: ${pismo}${reset}]\\tPožadované písmo ${pismo} chybí. Překlad do PDF nemusí fungovat.\\n"
            elif pismo='Latin Modern Mono Slanted'; sed -i -E '/^\\fontspec/s/.*/\\fontspec{'"$pismo"'}%/' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
            then
                x_fonty=1
                printf "[${cervena}xelatex: ${pismo}${reset}]\\tPožadované písmo ${pismo} chybí. Překlad do PDF nemusí fungovat.\\n"
            elif pismo='Latin Modern Mono Light'; sed -i -E '/^\\fontspec/s/.*/\\fontspec{'"$pismo"'}%/' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
            then
                x_fonty=1
                printf "[${cervena}xelatex: ${pismo}${reset}]\\tPožadované písmo ${pismo} chybí. Překlad do PDF nemusí fungovat.\\n"
            elif pismo='Latin Modern Mono Light Cond'; sed -i -E '/^\\fontspec/s/.*/\\fontspec{'"$pismo"'}%/' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
            then
                x_fonty=1
                printf "[${cervena}xelatex: ${pismo}${reset}]\\tPožadované písmo ${pismo} chybí. Překlad do PDF nemusí fungovat.\\n"
            elif pismo='Latin Modern Roman'; sed -i -E '/^\\fontspec/s/.*/\\fontspec{'"$pismo"'}%/' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
            then
                x_fonty=1
                printf "[${cervena}xelatex: ${pismo}${reset}]\\tPožadované písmo ${pismo} chybí. Překlad do PDF nemusí fungovat.\\n"
            elif pismo='Latin Modern Sans'; sed -i -E '/^\\fontspec/s/.*/\\fontspec{'"$pismo"'}%/' test.tex && ! xelatex -halt-on-error test.tex >/dev/null
            then
                x_fonty=1
                printf "[${cervena}xelatex: ${pismo}${reset}]\\tPožadované písmo ${pismo} chybí. Překlad do PDF nemusí fungovat.\\n"
            else
                printf "[${zelena}xelatex: písma${reset}] V pořádku, XeLaTeXu jsou dostupné všechny požadované rodiny písma.\\n"
            fi
            exit $x_fonty
        ) </dev/null
        x_fonty=$?
    fi
    rm -Rf "/tmp/$tmp_adr"
else
    printf "[${cervena}xelatex${reset}]\\tChybí XeLaTeX. Překlad do PDF nebude fungovat.\\n"
    x_xelatex=1
fi

# ------------------------

printf '\nVýsledek kontroly pro jednotlivé výstupní formáty:\n'
printf 'deb\t'
if (( x_gawk + x_make + x_sed + x_dpkg ))
then
    printf "${cervena}něco chybí!${reset}\\n"
else
    printf "${zelena}v pořádku${reset}\\n"
fi

printf 'log\t'
if (( x_gawk + x_make + x_sed + x_perl + x_sort ))
then
    printf "${cervena}něco chybí!${reset}\\n"
else
    printf "${zelena}v pořádku${reset}\\n"
fi

printf 'html\t'
if (( x_gawk + x_make + x_sed + x_imagemagick + x_perl + x_sort ))
then
    printf "${cervena}něco chybí!${reset}\\n"
else
    printf "${zelena}v pořádku${reset}\\n"
fi

printf 'pdf-*\t'
if (( x_gawk + x_make + x_sed + x_imagemagick + x_perl + x_sort + x_dpkg + x_gs + x_rsvg_convert + x_xelatex + x_fonty + x_qrencode + x_iconv + x_xxd ))
then
    printf "${cervena}něco chybí!${reset}\\n"
else
    printf "${zelena}v pořádku${reset}\\n"
fi
