<!--

Linux Kniha kouzel, kapitola Perl: Objekty a jmenné prostory
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

⊨
-->

# Perl: Objekty a jmenné prostory

!Štítky: {program}{Perl}{programování}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola z programovacího jazyka Perl pokrývá dělení kódu do více
souborů, do jmenných prostorů a objektově orientované programování.

Aby Perl usnadnil vytváření rozsáhlejších programů, umožňuje funkce a proměnné
rozdělit do více souborů a organizovat je do relativně samostatných kontextů
zvaných nejčastěji *moduly* (ale také balíčky, třídy či jmenné prostory).
Abyste mohl/a použít funkce z určitého modulu ve svém skriptu,
musíte nejprve *načíst* soubor, ve kterém jsou tyto funkce definovány,
a pak (volitelně) daný modul *připojit*. Obvykle se obě tyto operace
vykonávají dohromady příkazem „use“, ale můžete je vykonat i odděleně.

Pomocí modulů Perl také umožňuje objektově orientované programování,
ve kterém modul odpovídá pojmu „třída“ — modul definuje sadu metod
a následně se tento modul jednorázově *přiřazuje* přes ukazatel
každému objektu dané třídy. Když pak pomocí objektově orientovaného operátoru
„-&gt;“ zavoláte přes daný ukazatel metodu, Perl ji vyhledá v modulu,
který je k odkazovanému objektu přiřazen. Použitý ukazatel se metodě
předá jako dodatečný parametr, vsunutý před vámi zadané parametry
(jako použitím funkce „unshift“) a je na volané metodě, aby toho využila.

Zvláštním případem je volání některých metod (zejména takzvaných konstruktorů)
ta, že se namísto ukazatele na objekt uvádí přímo cesta modulu.
V takovém případě dostane metoda v dodatečném parametru místo ukazatele
řetězec s cestou modulu.

<!--
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->

## Definice

* **Jmenný prostor** (namespace) je pojmenovaný kontext pro umísťování funkcí a proměnných. Začátek každého zdrojového souboru (včetně hlavního skriptu) je v kontextu výchozího jmenného prostoru „main“, do jiných jmenných prostorů se přepíná příkazem „package“.
* **Název jmenného prostoru** je jednoznačné označení jmenného prostoru, které se skládá z posloupnosti jednoho či více identifikátorů oddělených dvojí dvojtečkou („::“), např. „Digest::MD5“ nebo „English“. Na rozdíl od jiných jazyků se v Perlu nezkracuje (vždy se uvádí celý) a mezi jmennými prostory není žádná automatická hierarchie.
* **Modul** (module), někdy také **balíček** (package) je takový jmenný prostor, který je definovan obvyklým způsobem v samostatném stejnojmenném souboru s příponou „.pm“, a díky tomu je možno ho snadno připojit ke skriptu příkazem „use“.
* **Symbol** je především identifikátor funkce nebo konstanty, ale také identifkátor nelokální proměnné včetně rozlišovacího symbolu „$“, „@“ nebo „%“, pokud je taková proměnná deklarována klíčovým slovem „our“ mimo jakýkoliv uzavírající blok.
* **Importovat symbol** znamená zpřístupnit symbol z jiného jmenného prostoru tak, jako by byl definován i v tomto jmenném prostoru. To umožňuje k danému symbolu (funkci, konstantě či proměnné) přistupovat bez kvalifikace názvem jmenného prostoru, případně ho dál exportovat. Importovat lze z každého jmenného prostoru pouze ty symboly, které výslovně exportuje; pomocí plně kvalifikovaného jména však lze přistoupit ke všem symbolům v každém jmenném prostoru.
* **Exportovat symbol** znamená umožnit ho ostatním modulům z tohoto modulu importovat. Exportován může být pouze symbol, který je v daném modulu definován nebo který do něj byl předtím importován.

### Objektově orientované programování

* Jako **metoda** se označuje funkce použitá objektově orientovaným způsobem (volaná objektově orientovaným operátorem „-&gt;“) nebo k tomu uzpůsobená.
* **Třída** (class) je jmenný prostor obsahující metody (alespoň jednu). Kromě metod může obsahovat i neobjektově orientované funkce.
* **Objekt** je dvojznačný pojem. V širším (a původním) slova smyslu označuje jakékoliv konkrétní místo paměti, které má svůj datový typ. V užším (objektově orientovaném) významu pak jde o objekt, jemuž byl přiřazena třída funkcí „bless()“.

!ÚzkýRežim: vyp

## Zaklínadla: Jmenné prostory a moduly

### Jmenné prostory

*# úplnou kvalifikací zavolat **funkci***<br>
{*Název::JmProstoru*}**::**{*názevfunkce*}**(**{*parametry*}**)**

*# úplnou kvalifikací přistoupit k skaláru/poli/asociativnímu poli*<br>
**$**{*Název::JmProstoru*}**::**{*identifikátor*}<br>
**@**{*Název::JmProstoru*}**::**{*identifikátor*}<br>
**%**{*Název::JmProstoru*}**::**{*identifikátor*}

*# **přepnout** do kontextu jiného jmenného prostoru*<br>
*// Poznámka: příkaz „package“ je přepínač fungující v době překladu. Jeho účinek trvá do dalšího příkazu „package“, nejdéle však do konce zdrojového souboru.*<br>
**package** {*Název::JmProstoru*}**;**<br>
**package main;**

*# přepnout do kontextu hlavního modulu*<br>
**package main;**

### Moduly

*# **připojit** modul a importovat z něj výchozí symboly/konkrétní symboly/neimportovat žádné symboly*<br>
*// Perl prohledá standardní adresáře a adresáře zadané příkazem „use lib“. Z každého takového adresáře hledá cestu sestavenou z komponent názvu jmenného prostoru, kde poslední komponentu doplní o příponu „.pm“. Např. příkaz „use Digest::MD5“ bude hledat soubor „Digest/MD5.pm“. Nalezený soubor se načte a z uvedeného jmenného prostoru se importují požadované symboly. Toto je obvyklý způsob používání modulů v Perlu.*<br>
**use** {*Název::JmProstoru*}**;**<br>
**use** {*Název::JmProstoru*}{*("seznam", "symbolů", "k", "importu")*}**;**<br>
**use** {*Název::JmProstoru*}**();**

*# hledat moduly i v zadaném adresáři*<br>
*// Cesta může být absolutní nebo relativní. Relativní cesta se však vyhodnocuje relativně vůči aktuálnímu adresáři, což nemusí být adresář, ve kterém se nachází běžící skript. Nově přidané cesty se prohledávají před dříve přidanými.*<br>
**use lib(**{*"cesta"*}[**,** {*"další/cesta"*}]...**);**

*# hledat moduly i ve stejném adresáři, kde se nachází daný zdrojový soubor*<br>
**use lib(((\_\_FILE\_\_ =~ s/^\[<nic>^\\/]\*$/.\\/x/r) =~ s/\\/\[<nic>^\\/]\*$//r));**
<!--
TODO: Otestovat!
-->

*# obvyklá **obecná struktura** souboru s modulem (\*.pm)*<br>
**package** {*Název::JmProstoru*}**;**<br>
**use strict;**<br>
**use warnings;**<br>
**use utf8;**<br>
**use English;**<br>
**use LinuxKnihaKouzel;**<br>
**use Exporter("import");**<br>
[**use parent("**{*Rodič*}**"**[**,** {*DalšíRodič*}]...**);**]<br>
[{*další příkazy use*}]<br>
**our @EXPORT =** {*(seznam symb. exportovaných ve výchozí nastavení)*}**;**<br>
**our @EXPORT\_OK =** {*(seznam ostatních exportovaných symb.)*}**;**<br>
[{*definice konstant*}]<br>
{*definice proměnných a funkcí*}<br>
**1;**



### Zdrojové soubory


*# načíst soubor (pomocí cesty modulu)*<br>
**require** [{*Adresář*}**\:\:**]...{*NázevModulu*}**;**

*# načíst funkce a proměnné ze souboru (pomocí adresářové cesty/pomocí ekvivalentního názvu modulu)*<br>
*// Název odkazovaného souboru u příkazu „require“ nemusí končit příponou „.pm“, ale jeho kód musí končit příkazem „1;“. Je v pořádku načítat tentýž soubor vícekrát – načte se jen jednou. Cesta může být relativní či absolutní, ale relativní cesta se vyhledává relativně vůči aktuálnímu adresáři.*<br>
**BEGIN {require("**{*cesta/k/souboru*}**")}**<br>
?
<!--
<br>
**BEGIN {require** {*Název::JmProstoru*}**}** // [ ] vyzkoušet
-->



## Zaklínadla: Třídy a objekty

### Použití metod

*# zavolat metodu přes objekt*<br>
*// Při tomto způsobu volání dostane metoda jako dodatečný první parametr zadaný ukazatel.*<br>
{*ukazatel*}**-&gt;**{*název\_metody*}**(**{*seznam, parametrů*}**)**

*# zavolat metodu přes modul (třídu)*<br>
*// Při tomto způsobu volání dostane metoda jako dodatečný první parametr řetězec obsahující cestu modulu.*<br>
{*Cesta::Modulu*}**-&gt;**{*název\_metody*}**(**{*seznam, parametrů*}**)**

*# zavolat metodu cizího modulu přes objekt*<br>
*// Při tomto způsobu volání dostane metoda jako dodatečný první parametr zadaný ukazatel.*<br>
{*ukazatel*}**-&gt;**{*Cesta::Modulu*}**::**{*název\_metody*}**(**{*seznam, parametrů*}**)**

*# zavolat funkci modulu neobjektově*<br>
*// Při tomto způsobu volání dostane funkce jen předané parametry, dodatečný parametr nebude před parametry vsunut.*<br>
{*Cesta::Modulu*}**::**{*název\_metody*}**(**{*seznam, parametrů*}**)**

### Vytváření objektů

*# **přiřadit** objektu třídu*<br>
*// Funkce bless() vrací předaný ukazatel beze změny, ale až poté, co odkazovanému objektu přiřadila modul. Pozor! Jednou vytvořené přiřazení u daného objektu nelze zrušit ani přepsat, nepřenáší se však při kopírování, takže stačí přiřadit objekt (ne ukazatel na něj) do nové proměnné a získáte „čistou“ kopii, bez přiřazeného modulu.*<br>
**bless(**{*ukazatel*}**,** {*Název::JmProstoru*}**)**

### Definice metod

*# obvyklá struktura **metody** (objektově orientované funkce)*<br>
**sub** {*název\_metody*} [**: lvalue**]<br>
**\{**<br>
<odsadit1>**my $self = shift(@ARG);**<br>
<odsadit1>{*tělo metody*}<br>
**\}**

*# obvyklá struktura konstruktoru*<br>
**sub new**<br>
**\{**<br>
<odsadit1>**my $self = {};**<br>
<odsadit1>{*tělo konstruktoru*}<br>
<odsadit1>**return bless($self, $ARG[0]);**<br>
**\}**

*# obvyklá struktura destruktoru*<br>
?

### Zkoumání objektů

*# je cíli ukazatele přiřazena třída?*<br>
**defined(blessed(**{*ukazatel*}**))**

*# která třída je přiřazena cíli ukazatele?*<br>
*// Pokud předaný skalár není ukazatel na objekt s přiřazeným modulem, tato funkce vrátí undef.*<br>
**blessed(**{*ukazatel*}**)**

*# je možno nad daným objektem zavolat metodu určitého názvu?*<br>
{*ukazatel*}**-&gt;can("**{*název\_metody*}**")**

## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíčků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

!ÚzkýRežim: zap

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

* Abyste se vyhnuli problémům s názvy modulů, nazývejte svoje moduly (a jejich adresáře) tak, aby název začínal velkým písmenem a obsahoval alespoň jedno malé písmeno.
* Proměnné deklarované na úrovni modulu klíčovým slovem „my“ jsou zamýšleny tak, že jsou omezeny jen na daný zdrojový soubor. Ve skutečnosti takto deklarovanou proměnnou můžete použít ve více zdrojových souborech, ale v takovém případě pro každý z nich vznikne samostatná proměnná!

Příkaz „require“ způsobí


## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

Co hledat:

* [Článek na Wikipedii](https://cs.wikipedia.org/wiki/Hlavn%C3%AD_strana)
* Oficiální stránku programu
* Oficiální dokumentaci
* [Manuálovou stránku](http://manpages.ubuntu.com/)
* [Balíček](https://packages.ubuntu.com/)
* Online referenční příručky
* Různé další praktické stránky, recenze, videa, tutorialy, blogy, ...
* Publikované knihy
* [Stránky TL;DR](https://github.com/tldr-pages/tldr/tree/master/pages/common)

!ÚzkýRežim: vyp
