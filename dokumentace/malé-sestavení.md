<!--

Linux Kniha kouzel, dokumentace: Malé sestavení
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
# Malé sestavení

**STAV TEXTU:** aktuální

## Předpoklady a potřebný software

K sestavení formátů „html“, „log“ a „deb“ *Linuxu: Knihy kouzel* ze zdrojového kódu budete potřebovat:

* Git
* GNU awk
* GNU make
* GNU sed
* ImageMagick
* qrencode, iconv, xxd
* české locale „cs\_CZ.UTF-8“ (musí fungovat české řazení příkazem „sort“) − nemusí být aktivní, stačí nainstalované a funkční
* pro balíček DEB také příkaz dpkg-deb (v Debianu a Ubuntu předinstalovaný)

V Ubuntu 20.04 LTS, Ubuntu 18.04 LTS, Linuxu Mint 20 a Linuxu Mint 17.3 můžete tyto nástroje nainstalovat příkazem:

> ``sudo apt-get install git make gawk imagemagick qrencode xxd``

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

Pak můžete spustit make (pokud některý formát nechcete sestavovat, můžete ho z příkazu vynechat):

> ``make -j4 html log deb``

Výstup ve všech sestavených formátech najdete v adresáři ``výstup_překladu``.
Očekávaná doba malého sestavení je několik sekund.

Pro sestavení formátů PDF pro tisk musíte využít [velké sestavení](velké-sestavení.md), které požaduje víc nástrojů.

## Přizpůsobení

Vaše sestavení si můžete přizpůsobit předáním dalších parametrů příkazu make při sestavení:

* Parametrem „JMENO“ můžete nastavit jméno a verzi sestavení. Doporučená syntaxe je ``JMENO='(označení distribuce) (číslo verze), (jméno verze)'``, kde jen číslo verze je povinná část (číslo verze se skládá z neprázdných sekvencí desítkových číslic oddělených tečkami).

Příklady:

> ``make JMENO='borůvková příchuť 2010.04, Šílený švec' html``<br>
> ``make JMENO='1.0' html deb``<br>
> ``make JMENO='Moje vlastní sestavení 1' html``

Překlad pravděpodobně bude fungovat i při nedodržení doporučené syntaxe, ale v takovém případě mohou nastat nečekané problémy.

* Parametrem „PREMIOVE\_KAPITOLY=1“ můžete zapnout generování přehledu vydaných, ale nezařazených kapitol.

*Příklad:*

``make PREMIOVE_KAPITOLY=1 -j4 html``

* Nastavením proměnné prostředí „PORADI\_KAPITOL“ na zvláštní hodnotu „\_VŠE\_“ můžete vynutit automatické přeložení všech kapitol a dodatků zapsaných v Makefile (tato funkce je používána při sestavování „výplachu repozitáře“):

``PORADI_KAPITOL='_VŠE_' make -j4 html``

## Ověření české lokalizace systému

Pokud používáte jinou než českou lokalizaci Vašeho systému (i slovenskou),
ověřte prosím před sestavením, že Váš systém zvládne správně české řazení.
Zadejte do terminálu příkaz:

> `printf %s\\n žába čádor tábor chalupa | LC_ALL="cs_CZ.UTF-8" sort`

a zkontrolujte, že vypsal řádky v tomto pořadí:

> čádor<br>chalupa<br>tábor<br>žába

Bude-li pořadí odlišné, sestavení sice bude fungovat, ale pořadí kapitol a štítků v přehledech může být chybné.

## Další poznámky

* Formát „log“ slouží k ladění mechanismu překladu. Jeho výstupní soubory obsahují přeložený zdrojový kód v podobě, která přesně odpovídá sekvenci volání ve skriptu „[skripty/překlad/hlavní.awk](skripty/překlad/hlavní.awk)“.
