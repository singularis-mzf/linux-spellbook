<!--

Linux Kniha kouzel, README
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
# Linux: Kniha kouzel
Linux: Kniha kouzel je příručka pro začátečníky a pokročilé, která nabídne
zjednodušený a uživatelsky přívětivý přehled toho, co v Linuxu můžete dělat
s pomocí příkazové řádky/příkazového řádku a konfiguračních souborů.

Příručka podléhá licenci
[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/),
s výjimkou některých snímků obrazovky v adresáři ``obrazky/gpl``,
které samy o sobě podléhají [GPL v3](https://www.gnu.org/licenses/gpl-3.0.html)
a jejich vkládání do příručky je otázka na delší právní diskusi.

![ve výstavbě](obrazky/ve-vystavbe.png) Příručka je zatím v rané fázi
vývoje, ale už je sestavitelná.

## Návod k sestavení

K sestavení příručky ze zdrojového kódu budete potřebovat Git, GNU make,
GNU awk a LaTeX (včetně extra-fontů a balíčku „boisik“). V minimální instalaci
Ubuntu 18.04 LTS můžete tyto nástroje nainstalovat příkazem:

> ``sudo apt-get install git make gawk texlive-latex-recommended texlive-fonts-extra texlive-lang-czechslovak``

Pak budete potřebovat stáhnout si repozitář:

> ``git clone https://github.com/singularis-mzf/linux-spellbook.git``

A nakonec stačí spustit make:

> ``make -C linux-spellbook``

Výstup ve všech podporovaných formátech najdete v podadresářích
adresáře ``linux-spellbook/vystup_prekladu``.

Pořadí a přítomnost kapitol a dodatků ve výstupu můžete ovlivnit v souboru
„kapitoly.lst“, který se automaticky vygeneruje při prvním překladu.
Kapitoly ani dodatky se však nesmějí opakovat.

Varování *„LaTeX Font Warning: Some font shapes were not available,
defaults substituted“* je bohužel v pořádku, zatím se mi ho nepodařilo zbavit.

Soubor ``vystup_prekladu/html/index.htm`` zatím bohužel není použitelný,
ale můžete si prohlédnout HTML soubory jednotlivých přeložených kapitol.



## Přehled kapitol podle stavu vývoje

### 5. Hotové
Zatím nejsou.

### 4. Betaverze
* [GNU Make](kapitoly/make.md)

### 3. Fáze organizace
* [Git](kapitoly/git.md)
* [Markdown](kapitoly/markdown.md)
* [Zpracování obrázků](kapitoly/obrazky.md)

### 2. Fáze shromažďování (pokročilá)
* [FFmpeg](kapitoly/ffmpeg.md)
* [GAWK](kapitoly/gawk.md)

### 1. Fáze shromažďování (začátek)
* [Docker](kapitoly/docker.md)
* [Firefox](kapitoly/firefox.md)
* [Hledání souboru](kapitoly/hledani-souboru.md)
* [LaTeX](kapitoly/latex.md)
* [Odkazy](kapitoly/odkazy.md)
* [Soubory](kapitoly/soubory.md)

### 0. Plánované
* Správa balíčků (apt/dpkg)
* Bash
* /etc/fstab
* GRUB
* Systém (služby, swap apod.)
* Přehrávání videa, zvuku a obrázků
* Vim
* Záznam obrazovky (screenshooter, screencast, ...)
