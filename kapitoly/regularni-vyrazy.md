<!--

Linux Kniha kouzel, kapitola Regulární výrazy
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

-->

# Regulární výrazy

!Štítky: {syntaxe}{zpracování textu}

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

Regulární výrazy jsou formálním jazykem, který nám slouží k tomu,
abychom dokázali vyhledávat a nahrazovat nejen konkrétní textové řetězce,
jak to umí téměř každý dostupný textový editor, ale i obecné podřetězce,
které mohou nabývat mnoha různých tvarů, jako jsou např. celá čísla.
Zatímco obyčejným řetězcem můžeme popsat jen konkrétní čísla jako např.
číslo „789“, regulárním výrazem „0|-?[1-9][0-9]\*“ najednou a elegantně
popíšeme množinu všech celých čísel. Regulární výrazy také můžeme
využít ke kontrole syntaxe (např. zda jde o platné PSČ) nebo
při analýze a zpracování textových dat.

V Linuxu se bohužel vyskytují tři různé syntaxe regulárních výrazů − základní
regulární výrazy, rozšířené regulární výrazy a regulární výrazy jazyka Perl.
Z praktických důvodů považuji za nejdůležitější rozšířené regulární výrazy,
a proto kdykoliv napíšu „regulární výraz“ bez dalšího upřesnění, mám na mysli
rozšířený regulární výraz. Kde se od sebe syntaxe liší, bude to u zaklínadel
upřesněno; kde není uvedena samostatná varianta pro Perl, platí pro Perl
varianta pro rozšířený regulární výraz.


## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

* Jako **atom** v několika zaklínadlech z praktických důvodů označuji nedělitelnou část regulárního výrazu. Úsek regulárního výrazu seskupený pomocí závorek je pro tento účel nedělitelný jako celek.

## Zaklínadla
### Jednotlivé znaky

*# konkrétní znak*<br>
*// Některé znaky musejí být v regulárních výrazech pro zbavení svého speciálního významu escapovány zpětným lomítkem.*<br>
{*znak*}

*# libovolný znak*<br>
**.**

*# kterýkoliv z uvedených znaků*<br>
*// Uvnitř těchto hranatých závorek se speciální znaky neescapují zpětným lomítkem, ale uvedením na určitou pozici.*<br>
**[**{*znaky*}**]**

*# libovolný znak kromě uvedených*<br>
**[^**{*znaky*}**]**

*# bílý znak/nebílý znak*<br>
**\\s**<br>
**\\S**

*# číslice desítková (rozšířený/základní/Perl)*<br>
**[[:digit:]]**<br>
**[[:digit:]]**<br>
**\\d**

*# nečíslice (rozšířený/základní/Perl)*<br>
**[^0-9]**<br>
**[^0-9]**<br>
**\\D**

*# závorky „()“ (rozšířený i základní)*<br>
**[(][)]**

*# závorky „[]“ (rozšířený i základní)*<br>
**\\[\\]**

*# závorky „{}“ (rozšířený/základní)*<br>
**\\{\\}**<br>
**{}**

*# libovolný alfanumerický znak, i národní abecedy (rozšířený/základní/Perl)*<br>
**[[:alnum:]]**<br>
**[[:alnum:]]**<br>
**\\w**

*# libovolný znak kromě alfanumerických (rozšířený/základní/Perl)*<br>
?<br>
?<br>
**\\W**

### Operátory opakování

*# nejvýše jednou (&lt;= 1)(rozšířený/základní)*<br>
{*atom*}**?**<br>
{*atom*}**\\?**

*# libovolný počet (&gt;= 0)(rozšířený/základní)*<br>
{*atom*}**\***<br>
{*atom*}**\***

*# alespoň jednou (&gt;= 1)(rozšířený/základní)*<br>
{*atom*}**+**<br>
{*atom*}**\\+**

*# konkrétní počet výskytů (rozšířený/základní)*<br>
{*atom*}**\{**{*počet*}**\}**<br>
{*atom*}**\\\{**{*počet*}**\\\}**

*# minimálně M výskytů, maximálně N výskytů (rozšířený/základní)*<br>
{*atom*}**\{**{*M*}**,**{*N*}**\}**<br>
{*atom*}**\\\{**{*M*}**,**{*N*}**\\\}**

*# alespoň M výskytů; může být i víc (rozšířený/základní)*<br>
{*atom*}**\{**{*M*}**,}**<br>
{*atom*}**\\\{**{*M*}**,\\}**

*# nejvýše M výskytů (rozšířený/základní)*<br>
{*atom*}**{,**{*N*}**\}**<br>
{*atom*}**\\{,**{*N*}**\\\}**

*# snažit se opakovat co nejméně (non-greedy)(jen Perl)*<br>
{*atom*}{*operátor-opakování*}**?**

### Pozice (odpovídá fiktivnímu prázdnému řetězci na určité pozici)
*# začátek/konec řetězce*<br>
?

*# začátek/konec řádku (rozšířený i základní)*<br>
**^**<br>
**$**

*# začátek/konec slova (rozšířený i základní, ale ne Perl)*<br>
**\\&lt;**<br>
**\\&gt;**

*# začátek nebo konec slova (rozšířený i základní)*<br>
**\\b**

### Seskupení

*# seskupení (rozšířený/základní)*<br>
**(**{*podvýraz*}**)**<br>
**\\(**{*podvýraz*}**\\)**

*# seskupení bez zapamatování (jen Perl)*<br>
**(?:**{*podvýraz*}**)**

### Paměť (omezená podpora)

*# vrátit podřetězec původního řetězce odpovídající seskupení (rozšířený i základní)*<br>
*// Tato funkce je podporovaná pouze v některých programech, mezi něž patří např. egrep, grep, perl a sed; ne však „gawk“.*<br>
**\\**{*pořadové-číslo-1-až-9*}

*# totéž, ale první písmeno malé/velké*<br>
*// Tuto variantu podporuje pravděpodobně jen Perl a sed a smí se vyskytnout pouze v řetězci pro náhradu, nikoliv přímo ve vlastním regulárním výrazu.*<br>
**\\l\\**{*pořadové-číslo-1-až-9*}**\\E**<br>
**\\u\\**{*pořadové-číslo-1-až-9*}**\\E**

*# totéž, ale celý text malými/velkými písmeny*<br>
*// Viz poznámku k předchozímu zaklínadlu.*<br>
**\\L\\**{*pořadové-číslo-1-až-9*}**\\E**<br>
**\\U\\**{*pořadové-číslo-1-až-9*}**\\E**

### Operátor „nebo“

*# některý z podvýrazů (rozšířený/základní)*<br>
{*výraz 1*}[**\|**{*další výraz*}]...<br>
{*výraz 1*}[**\\\|**{*další výraz*}]...

### Vyhlížení (jen Perl)

*# ověřit, že následujícící podřetězec vstupního řetězce odpovídá podvýrazu*<br>
**(?=**{*podvýraz*}**)**

*# ověřit, že následujícící podřetězec vstupního řetězce neodpovídá podvýrazu*<br>
**(?!**{*podvýraz*}**)**

## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti − ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Jak získat nápovědu
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje (ale neuvádějte konkrétní odkazy, ty patří do sekce „Odkazy“).
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Odkazy
![ve výstavbě](../obrazky/ve-vystavbe.png)

* [Seriál článků na Root.cz](https://www.root.cz/serialy/regularni-vyrazy/)
* [Článek Regulární výraz na Wikipedii](https://cs.wikipedia.org/wiki/Regul%C3%A1rn%C3%AD_v%C3%BDraz)

Co hledat:

* [stránku na Wikipedii](https://cs.wikipedia.org/wiki/Hlavn%C3%AD_strana)
* oficiální stránku programu
* oficiální dokumentaci
* [manuálovou stránku](http://manpages.ubuntu.com/)
* [balíček Bionic](https://packages.ubuntu.com/)
* online referenční příručky
* různé další praktické stránky, recenze, videa, tutorialy, blogy, ...
* publikované knihy
