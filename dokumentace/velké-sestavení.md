<!--

Linux Kniha kouzel, dokumentace: Velké sestavení
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Velký překlad

**STAV TEXTU:** aktuální

## Předpoklady a potřebný software

K úplnému sestavení *Linuxu: Knihy kouzel* ze zdrojového kódu budete potřebovat:

* Git
* GNU awk
* GNU make
* GNU sed
* ImageMagick
* GhostScript
* rsvg-convert (kvůli konverzi SVG na PDF)
* XeLaTeX
* qrencode
* iconv
* xxd
* české locale „cs\_CZ.UTF-8“ (musí fungovat české řazení příkazem „sort“) − nemusí být aktivní, stačí nainstalované a funkční

Také budete potřebovat písma:

* DejaVu Sans
* Latin Modern Math
* Latin Modern Mono Slanted
* Latin Modern Mono Light
* Latin Modern Mono Light Cond
* Latin Modern Roman
* Latin Modern Sans

Ověřil/a jsem, že v Ubuntu 20.04 LTS, Ubuntu 18.04 LTS a Linuxu Mint 20 můžete všechny potřebné nástroje a písma nainstalovat příkazem:

> ``sudo apt-get install git make gawk xxd imagemagick librsvg2-bin qrencode texlive-xetex texlive-lang-czechslovak t1-cyrillic lmodern``

V budoucnu pravděpodobně sestavování přejde na Ubuntu 20.04, ale zatím je stále plně podporován i překlad na Ubuntu 18.04.

## Postup sestavení

Prvním krokem je stáhnout si a nastavit repozitář:

> ``git clone --branch stabilni https://github.com/singularis-mzf/linux-spellbook.git``<br>
> ``cd linux-spellbook``<br>
> ``git config --local core.quotePath false``

V druhém kroku si vyberte kapitoly, které mají být součástí sestavení:

> ``cp pořadí-kapitol.výchozí.lst pořadí-kapitol.lst``

Otevřete nově vytvořený soubor „pořadí-kapitol.lst“ v obyčejném textovém
editoru (např. vim, nano, Gedit, Kate, Mousepad, Leafpad apod.,
ne LibreOffice Writer!) a upravte pořadí či výběr kapitol.
Tento soubor bude určovat, které kapitoly či dodatky a v jakém pořadí
budou zařazeny do sestavení.

Prázdné řádky a řádky začínající znakem „#“ jsou ignorovány a lze je použít
jako komentáře. Ostatní řádky jsou názvy souborů v podadresářích „dodatky“
a „kapitoly“ bez přípony „.md“. Žádná kapitola či dodatek se nesmí opakovat
a jako první by měla být „předmluva“ (při nesplnění tohoto požadavku nemusí
sestavení fungovat).

Pokud budete vaše sestavení šířit ostatním osobám, doporučuji ponechat
dodatek „licence“.

Pak můžete spustit make (pokud nechcete sestavit všechny formáty, můžete některé z nich vynechat):

> ``make -j4 log html pdf-a4 pdf-a4-bez pdf-b5 pdf-b5-bez pdf-b5-na-a4 deb``

Výstup ve všech podporovaných formátech najdete v adresáři ``výstup_překladu``. Očekávaná doba překladu je cca 5 minut procesorového času (máte-li čtyřjádrový procesor, je to zhruba 1 minuta).

## Přizpůsobení

Vaše sestavení si můžete přizpůsobit předáním dalších parametrů příkazu make při sestavení:

* Parametrem „JMENO“ můžete nastavit jméno a verzi sestavení. Doporučená syntaxe je ``JMENO='(označení distribuce) (číslo verze), (jméno verze)'``, kde jen číslo verze je povinná část (číslo verze se skládá z neprázdných sekvencí desítkových číslic oddělených tečkami).

Příklady:

> ``make JMENO='borůvková příchuť 2010.04, Šílený švec' html pdf-a4``<br>
> ``make JMENO='1.0' html``<br>
> ``make JMENO='Moje vlastní sestavení 1' pdf-b5 html``

Překlad pravděpodobně bude fungovat i při nedodržení doporučené syntaxe, ale v takovém případě mohou nastat nečekané problémy.

* Parametrem „PDF\_ZALOZKY=0“ můžete vypnout generování „záložek“ v PDF.

*Příklad:*

``make PDF_ZALOZKY=0 -j4 html pdf-a4``

* Parametrem „PREMIOVE\_KAPITOLY=1“ můžete zapnout generování přehledu vydaných, ale nezařazených kapitol.

*Příklad:*

``make PREMIOVE_KAPITOLY=1 -j4 html pdf-4a``

## Ověření české lokalizace systému

Pokud používáte jinou než českou lokalizaci Vašeho systému (i slovenskou),
ověřte prosím před sestavením, že Váš systém zvládne správně české řazení.
Zadejte do terminálu příkaz:

> `printf %s\\n žába čádor tábor chalupa | LC_ALL="cs_CZ.UTF-8" sort`

a zkontrolujte, že vypsal řádky v tomto pořadí:

> čádor<br>chalupa<br>tábor<br>žába

Bude-li pořadí odlišné, sestavení sice bude fungovat, ale pořadí kapitol a štítků v přehledech může být chybné.

## Další poznámky

* Varování „*fontspec warning: "only-xetex-feature"*“ ignorujte; jde o chybu v balíčku „fontspec“, které již [byla nahlášena](https://github.com/wspr/fontspec/issues/382).
* Na Debianu 10 funguje podobný postup jako v Ubuntu, ale narazil/a jsem na problém s aktivací řazení podle českého locale, pokud nebylo zvoleno již při instalaci systému. Proto překlad na Debianu přímo nepodporuji.
* Formát „log“ slouží k ladění mechanismu překladu. Jeho výstupní soubory obsahují přeložený zdrojový kód v podobě, která přesně odpovídá sekvenci volání ve skriptu „[skripty/překlad/hlavní.awk](skripty/překlad/hlavní.awk)“.
