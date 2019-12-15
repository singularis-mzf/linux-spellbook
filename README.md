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

Verze 1.1 je cílena na *Ubuntu 18.04 Bionic Beaver* a jeho deriváty.

Příručka podléhá licenci
[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/). Podrobné údaje o autorství zdrojových souborů jsou uvedeny v komentářích v jejich záhlaví; údaje o autorství obrázkových souborů jsou uvedeny v souboru [COPYING](COPYING).

## Návod k sestavení

K sestavení příručky ze zdrojového kódu budete potřebovat Git, GNU make,
GNU awk, ImageMagick, rsvg-convert a LaTeX a kvůli řazení české locale
„cs\_CZ.UTF-8“. V Ubuntu 18.04 LTS, Debianu 10 a Linuxu Mint 17.2
můžete tyto nástroje nainstalovat příkazem:

> ``sudo apt-get install git make gawk imagemagick librsvg2-bin texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-fonts-extra texlive-lang-czechslovak hunspell-cs``

Nemáte-li v systému čestou lokalizaci, přidejte v Ubuntu a Linuxu Mint navíc balíček „language-pack-cs“. Jak se instaluje české locale v Debianu nevím.

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

## Stav vývoje kapitol (podle ID)
### Vydané kapitoly

* [barvy-a-titulek](kapitoly/barvy-a-titulek.md)
* [datum-cas-kalendar](kapitoly/datum-cas-kalendar.md)
* [docker](kapitoly/docker.md)
* [git](kapitoly/git.md)
* [make](kapitoly/make.md)
* [markdown](kapitoly/markdown.md)
* [planovani-uloh](kapitoly/planovani-uloh.md)
* [prace-s-archivy](kapitoly/prace-s-archivy.md)
* [regularni-vyrazy](kapitoly/regularni-vyrazy.md)
* [sprava-balicku](kapitoly/sprava-balicku.md)
* [stahovani-videi](kapitoly/stahovani-videi.md)
* [zpracovani-videa-a-zvuku](kapitoly/zpracovani-videa-a-zvuku.md)

### Dospělé nevydané kapitoly

*Zatím nejsou.*

### Kapitoly-děti

* [sprava-uzivatelu](kapitoly/sprava-uzivatelu.md) (80%)
* [awk](kapitoly/awk.md) (60%)
* [zpracovani-obrazku](kapitoly/zpracovani-obrazku.md) (40%)
* [x](kapitoly/x.md) (40%)
* [odkazy](kapitoly/odkazy.md) (20%)
* [konverze-formatu](kapitoly/konverze-formatu.md) (0%)
* [latex](kapitoly/latex.md) (0%)
* [zpracovani-textovych-souboru](kapitoly/zpracovani-textovych-souboru.md) (0%)

<!-- * [perl](kapitoly/perl.md) (0%) -->
<!-- * [unicode](kapitoly/unicode.md) (0%) -->

### Zvláštní kapitoly

* [_ostatni](kapitoly/_ostatni.md) − Slouží k dočasnému shromážďování dosud nezařazených zaklínadel.
* [_sablona](kapitoly/_sablona.md) − Nepřekládá se. Slouží jako výchozí podoba pro nově založené kapitoly.
* [_ukazka](kapitoly/_ukazka.md) − Překládá se, ale není součástí vydaných verzí. Slouží k dokumentaci a testování mechanismu překladu. Obsahuje všechny podporované jazykové konstrukce a znaky.
