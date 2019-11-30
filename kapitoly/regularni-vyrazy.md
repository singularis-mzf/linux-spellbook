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

- gawk, sed, perl, egrep, grep -P

-->

# Regulární výrazy

!Štítky: {syntaxe}{zpracování textu}

## Úvod
Regulární výraz je řetězec speciálních a obyčejných znaků, který slouží
k formálnímu popsání množiny textových řetězců splňujících určité
syntaktické parametry. Např. celá čísla můžeme popsat výrazem
„0|-?[1-9][0-9]\*“ a poštovní směrovací čísla výrazem „[0-9]{3} [0-9]{2}“.

Regulární výrazy se používají při vyhledávání, filtrování, zpracování textu
a kontrole syntaxe; objevují se ve většině programovacích jazyků,
ale neprogramátoři je využijí např. při nastavení filtrování e-mailů
či při vyhledávání komplikovanějších konstrukcí v textových editorech.

V Linuxu se bohužel vyskytují tři různé syntaxe regulárních výrazů − základní
regulární výrazy, rozšířené regulární výrazy a regulární výrazy jazyka Perl.
Z praktických důvodů považuji za nejdůležitější rozšířené regulární výrazy,
a proto kdykoliv napíšu „regulární výraz“ bez dalšího upřesnění, mám na mysli
rozšířený regulární výraz. Kde se od sebe syntaxe liší, bude to u zaklínadel
upřesněno; kde není uvedena samostatná varianta pro Perl, platí pro Perl
varianta pro rozšířený regulární výraz.

## Definice
* Jako **atom** z praktických důvodů označuji nejkratší část regulárního výrazu, která končí na dané pozici a tvořila by syntakticky správný regulární výraz sama o sobě. Atomem je např. „a“, „[abc]“, „(a|b)?“ či „\\s+“, ale ne „a|b“, protože „b“ je kratší a samo o sobě tvoří syntakticky platný regulární výraz.
* **Kvalifikátor** je speciální podřetězec, který se zapisuje za atom a určuje dovolený počet opakování.
* **Kotva** a **hranice** jsou speciální atomy odpovídající fiktivnímu prázdnému podřetězci na určité pozici.

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

*# libovolný znak **kromě uvedených***<br>
**[^**{*znaky*}**]**

*# **bílý znak**/nebílý znak*<br>
**\\s**<br>
**\\S**

*# desítková **číslice** (rozšířený/základní/Perl)*<br>
**[0-9]**<br>
**[0-9]**<br>
**\\d**

*# jiný znak než desítková číslice (rozšířený/základní/Perl)*<br>
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
**[^[:alnum:]]**<br>
**[^[:alnum:]]**<br>
**\\W**

### Kvalifikátory (operátory opakování)

*# **jednou nebo vůbec** (&lt;= 1)(rozšířený/základní)*<br>
{*atom*}**?**<br>
{*atom*}**\\?**

*# **libovolněkrát** (&gt;= 0)(rozšířený/základní)*<br>
{*atom*}**\***<br>
{*atom*}**\***

*# **jednou nebo víckrát** (&gt;= 1)(rozšířený/základní)*<br>
{*atom*}**+**<br>
{*atom*}**\\+**

*# přesně počet-krát (rozšířený/základní)*<br>
{*atom*}**\{**{*počet*}**\}**<br>
{*atom*}**\\\{**{*počet*}**\\\}**

*# M- až N-krát včetně (rozšířený/základní)*<br>
{*atom*}**\{**{*M*}**,**{*N*}**\}**<br>
{*atom*}**\\\{**{*M*}**,**{*N*}**\\\}**

*# M- nebo víckrát (rozšířený/základní)*<br>
{*atom*}**\{**{*M*}**,}**<br>
{*atom*}**\\\{**{*M*}**,\\}**

*# maximálně M-krát (rozšířený/základní)*<br>
{*atom*}**{,**{*N*}**\}**<br>
{*atom*}**\\{,**{*N*}**\\\}**

*# snažit se opakovat co nejméně (non-greedy)(jen Perl)*<br>
{*atom*}{*operátor-opakování*}**?**

### Operátor „nebo“

*# některý z podvýrazů (rozšířený/základní)*<br>
{*výraz 1*}[**\|**{*další výraz*}]...<br>
{*výraz 1*}[**\\\|**{*další výraz*}]...

### Kotvy a hranice (pozice)

Kotvy odpovídají fiktivnímu prázdnému řetězci na určité pozici.

*# začátek/konec řádku (rozšířený i základní)*<br>
**^**<br>
**$**

*# začátek slova (rozšířený a základní/Perl)*<br>
**\\&lt;**<br>
**\\b(?=\\w)**

*# konec slova (rozšířený a základní/Perl)*<br>
**\\&gt;**<br>
**\\b(?&lt;=\\w)**

*# začátek nebo konec slova (rozšířený/základní/Perl)*<br>
**(\\&lt;\|\\&gt;)**<br>
**\\(\\&lt;\\\|\\&gt;\\)**<br>
**\\b**

*# úplný začátek/konec testovaného řetězce (rozšířený i základní)*<br>
*// Pozor na escapování znaku „'“! Podpora těchto kotev v programech je omezená, ale gawk, sed i perl je podporují.*<br>
**\\\`**<br>
**\\'**

### Seskupení

*# seskupení (rozšířený/základní)*<br>
**(**{*podvýraz*}**)**<br>
**\\(**{*podvýraz*}**\\)**

*# seskupení bez zapamatování (jen Perl)*<br>
**(?:**{*podvýraz*}**)**

### Paměť (omezená podpora)

*# původní podřetězec odpovídající celému regulárnímu výrazu (rozšířený a základní/Perl)*<br>
*// Tato konstrukce je v programech „egrep“, „gawk“ a „perl“ rozeznávána jako speciální pouze v řetězci pro náhradu, nikoliv přímo v regulárním výrazu.*<br>
**&amp;**<br>
**$&amp;**

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

<!--
[ ] egrep
[ ] expr
[ ] gawk
[ ] grep -P
[ ] perl
[ ] sed -E
-->

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

Příkazy „egrep“, „expr“, „grep“, „perl“ a „sed“ jsou základními součástmi
Ubuntu. Příkaz „gawk“ je nutné doinstalovat, nebo místo něj použít méně
schopný příkaz „awk“, který je základní součástí Ubuntu.

*# *<br>
**sudo apt-get install gawk**

Regulární výrazy jsou i v mnoha dalších programech.

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

* V Perlu se k označení desítkové číslice běžně používá podvýraz „\\d“; v jiných syntaxích regulárních výrazů ovšem není podporován, proto doporučuji zvyknout si na podvýraz „[0-9]“, která je čitelnější a je podporovaná opravdu všude.

## Jak získat nápovědu
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje (ale neuvádějte konkrétní odkazy, ty patří do sekce „Odkazy“).
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Odkazy
* [Web regularnivyrazy.info](https://www.regularnivyrazy.info/)
* [Přednáška Lukáše Bařinky: Bash a regulární výrazy vs shellovské vzory](https://youtu.be/dOKydwMDYUU)
* [Seriál Regulární výrazy v PHP (Perl-compatible)](https://www.regularnivyrazy.info/serial-php-pcre-perl-compatible.html)
* [Seriál článků na Root.cz](https://www.root.cz/serialy/regularni-vyrazy/)
* [Článek Regulární výraz na Wikipedii](https://cs.wikipedia.org/wiki/Regul%C3%A1rn%C3%AD_v%C3%BDraz)
* Kniha: GOYVAERTS, Jan a Steven LEVITHAN. *Regulární výrazy: kuchařka programátora.* Brno: Computer Press, 2010. ISBN 978-80-251-1935-8.
* [Online tester regulárních výrazů](http://www.regexp.cz/index.php)
* [Přednáška Milana Davídka: Regulární výrazy](https://youtu.be/HHh-U0dZcOc)
* [Článek na blogu Miroslava Pecky](https://miroslavpecka.cz/blog/regularni-vyrazy-vse-co-jste-o-nich-chteli-vedet/)
* [Web Regular-Expressions.info](https://www.regular-expressions.info/) (anglicky)
* [Web RexEgg](https://www.rexegg.com/) (anglicky)
* [Online příručka GNU awk](https://www.gnu.org/software/gawk/manual/) (anglicky)
* [Online příručka GNU sed](https://www.gnu.org/software/sed/manual/) (anglicky)
* [Online příručka modulu perlre](https://perldoc.perl.org/perlre.html) (anglicky)
* [Manuálová stránka: grep](http://manpages.ubuntu.com/manpages/bionic/en/man1/grep.1.html) (anglicky)
* [Manuálová stránka: pcrepattern](http://manpages.ubuntu.com/manpages/bionic/en/man3/pcrepattern.3.html) (anglicky)
* [Balíček „gawk“](https://packages.ubuntu.com/bionic/gawk) (anglicky)
* [Balíček „perl“](https://packages.ubuntu.com/bionic/perl) (anglicky)
* [Balíček „sed“](https://packages.ubuntu.com/bionic/sed) (anglicky)
