<!--

Linux Kniha kouzel, README
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
![Linux: Kniha kouzel](obrazky/banner.png)

„Linux: Kniha kouzel“ je open source sbírka velmi krátkých řešených příkladů pro příkazovou řádku/příkazový řádek systému Linux, především distribuce Ubuntu. V současnosti je dostupná ve formátu HTML pro zobrazení na počítači a ve formátu PDF pro tisk na papír.

Příručka podléhá licenci
[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/). Podrobné údaje o autorství zdrojových souborů jsou uvedeny v komentářích v jejich záhlaví; údaje o autorství obrázkových souborů jsou uvedeny v souboru [COPYING](COPYING).

## Návod k sestavení

K sestavení příručky ze zdrojového kódu budete potřebovat Git, GNU make,
GNU awk, ImageMagick a LaTeX. V Ubuntu 18.04 LTS, Debianu 10 a Linuxu Mint 17.2
můžete tyto nástroje nainstalovat příkazem:

> ``sudo apt-get install git make gawk imagemagick texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-fonts-extra texlive-lang-czechslovak``

Pak budete potřebovat stáhnout si repozitář:

> ``git clone https://github.com/singularis-mzf/linux-spellbook.git``

A nakonec stačí spustit make:

> ``cd linux-spellbook``<br>
> ``make``

Výstup ve všech podporovaných formátech najdete v podadresářích
adresáře ``vystup_prekladu``.

Pořadí a přítomnost kapitol a dodatků ve výstupu můžete ovlivnit v souboru
„kapitoly.lst“, který se při prvním překladu automaticky vygeneruje jako kopie souboru „kapitoly.lst.vychozi“.
Kapitoly ani dodatky se však nesmějí opakovat.
