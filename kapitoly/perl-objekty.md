<!--

Linux Kniha kouzel, kapitola Perl: objekty a jmenné prostory
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

# Perl: objekty a jmenné prostory

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
musíte nejprve *načíst* soubor, ve kterém jsou tyto funkce definovány.
Obvykle současně *importujete* některé funkce do svého jmenného prostoru.
Obě tyto operace bývají prováděné dohromady příkazem „use“.

Objektově orientované programování se v Perlu realizuje tak,
že obyčejnému objektu (poli, asociativnímu poli či skaláru) je přes ukazatel
přiřazen jmenný prostor (třída), který obsahuje metody pro práci s ním.
Když pak metodu zavoláte pomocí objektově orientovaného operátoru
„-&gt;“, Perl ji automaticky najde ve jmenném prostoru, který je k objektu
přiřazen, a při volání ji vsune použitý ukazatel jako dodatečný parametr
na začátku pole @ARG.

Zvláštním případem je volání některých metod (zejména takzvaných konstruktorů)
tak, že namísto ukazatele na objekt uvedete na levou stranu operátoru
„-&gt;“ přímo název jmenného prostoru. V takovém případě dostane metoda
v dodatečném parametru místo ukazatele řetězec s tímto názvem.

Tato verze kapitoly nepokrývá přetěžování operátorů, protože jsou s ním
komplikované problémy. Zájemce proto odkazuji na zdlouhavé studium
oficiální dokumentace.

## Definice

* **Jmenný prostor** (namespace) je pojmenovaný kontext pro umísťování funkcí a proměnných. Začátek každého zdrojového souboru (včetně hlavního skriptu) je v kontextu výchozího jmenného prostoru „main“, do jiných jmenných prostorů se přepíná příkazem „package“.
* **Název jmenného prostoru** je jednoznačné označení jmenného prostoru, které se skládá z posloupnosti jednoho či více identifikátorů oddělených dvojí dvojtečkou („::“), např. „Digest::MD5“ nebo „English“. Na rozdíl od jiných jazyků se v Perlu nezkracuje (vždy se uvádí celý) a mezi jmennými prostory není žádná automatická hierarchie.
* **Modul** (module), někdy také **balíček** (package) je soubor s příponou „.pm“ („Perl module“), který obsahuje úplnou definici stejnojmenného jmenného prostoru, což ho umožňuje příkazem „use“ snadno zpřístupnit a naimportovat z něj symboly, aniž byste se musel/a starat o to, ve kterých souborech je daný jmenný prostor definovan.
* **Symbol** je nejčastěji identifikátor funkce nebo konstanty, méně často identifkátor nelokální proměnné včetně rozlišovacího symbolu „$“, „@“ nebo „%“.
* **Importovat symbol** znamená zpřístupnit symbol z jiného jmenného prostoru tak, jako by byl definován i v tomto jmenném prostoru. To umožňuje k danému symbolu (funkci, konstantě či proměnné) přistupovat bez kvalifikace názvem jmenného prostoru, případně ho dál exportovat. Importovat lze z každého jmenného prostoru pouze ty symboly, které výslovně exportuje; pomocí plně kvalifikovaného jména však lze přistoupit ke všem symbolům v každém jmenném prostoru (kromě těch, jejichž viditelnost je omezena na obklopující blok).
* **Exportovat symbol** znamená umožnit ho ostatním modulům z tohoto modulu importovat. Exportován může být pouze symbol, který je v daném modulu definován nebo který do něj byl předtím importován.

### Objektově orientované programování

* Jako **metoda** se označuje funkce použitá objektově orientovaným způsobem (volaná objektově orientovaným operátorem „-&gt;“) nebo k tomu uzpůsobená.
* **Třída** (class) je jmenný prostor obsahující metody (alespoň jednu). Kromě metod může obsahovat i neobjektově orientované funkce.
* **Objekt** je dvojznačný pojem. V širším (a původním) slova smyslu označuje jakékoliv konkrétní místo paměti, které má svůj datový typ. V užším (objektově orientovaném) významu pak jde o objekt, jemuž byl přiřazena třída funkcí „bless()“.

!ÚzkýRežim: vyp

## Zaklínadla: Jmenné prostory


*# **obvyklá** struktura jmenného prostoru*<br>
**package** {*Název::JmProstoru*}**;**<br>
**use strict;**<br>
**use warnings;**<br>
**use utf8;**<br>
**use English;**<br>
**use Exporter("import");**<br>
**use LinuxKnihaKouzel;**<br>
[{*definice konstant*}]<br>
[**use parent("**{*Rodič*}**"**[**,** {*DalšíRodič*}]...**);**]<br>
[**use fields(**{*"seznam", "datových", "složek"*}**);**]<br>
[{*další příkazy use*}]<br>
**our @EXPORT =** {*(seznam symb. exportovaných ve výchozí nastavení)*}**;**<br>
**our @EXPORT\_OK =** {*(seznam ostatních exportovaných symb.)*}**;**<br>
{*definice proměnných a funkcí*}...

*# **přepnout** do kontextu jiného jmenného prostoru*<br>
*// Poznámka: příkaz „package“ je přepínač fungující v době překladu. Jeho účinek trvá do dalšího příkazu „package“, do konce bloku (jmenný prostor lze uzavřít do složených závorek) nebo do konce zdrojového souboru.*<br>
**package** {*Název::JmProstoru*}**;**

*# přepnout do kontextu hlavního jmenného prostoru*<br>
*// Tento příkaz obvykle nepotřebujete, protože je praktičtější ne-hlavní jmenné prostory uzavřít do složených závorek.*<br>
**package main;**

*# hledat moduly i v zadaném adresáři*<br>
*// Cesta může být absolutní nebo relativní. Relativní cesta se však vyhodnocuje relativně vůči aktuálnímu adresáři, což nemusí být adresář, ve kterém se nachází běžící skript. Nově přidané cesty se prohledávají před dříve přidanými.*<br>
**use lib(**{*"cesta"*}[**,** {*"další/cesta"*}]...**);**

*# hledat moduly i ve stejném adresáři, kde se nachází daný zdrojový soubor*<br>
**use lib(((\_\_FILE\_\_ =~ s/^\[<nic>^\\/]\*$/.\\/x/r) =~ s/\\/\[<nic>^\\/]\*$//r));**
<!--
TODO: Otestovat!
-->

*# **připojit** modul a z jeho jmenného prostoru importovat výchozí symboly/konkrétní symboly/neimportovat žádné symboly*<br>
*// Perl prohledá standardní adresáře a adresáře zadané příkazem „use lib“. Z každého takového adresáře hledá cestu sestavenou z komponent názvu jmenného prostoru, kde poslední komponentu doplní o příponu „.pm“. Např. příkaz „use Digest::MD5“ bude hledat soubor „Digest/MD5.pm“. Nalezený soubor se načte a z uvedeného jmenného prostoru se importují požadované symboly. Toto je obvyklý způsob používání modulů v Perlu.*<br>
**use** {*Název::JmProstoru*}**;**<br>
**use** {*Název::JmProstoru*}{*("seznam", "symbolů", "k", "importu")*}**;**<br>
**use** {*Název::JmProstoru*}**();**

*# deklarovat jiné jmenné prostory jako „rodiče“ tohoto*<br>
**use parent("**{*Rodič*}**"**[**,** {*DalšíRodič*}]...**);**
<!--
[ ] Doplnit přesný význam.
-->

*# načíst zdrojový soubor (cestu k souboru určit automaticky)*<br>
**require** {*Název::JmProstoru*}**;**

*# načíst zdrojový soubor*<br>
**BEGIN {require("**{*cesta/k/souboru*}**")}**
<!--
<br>
**BEGIN {require** {*Název::JmProstoru*}**}** // [ ] vyzkoušet
-->

### Třídy a metody

*# obvyklá definice **metody***<br>
**sub** {*název\_metody*} [**: lvalue**]<br>
**\{**<br>
<odsadit1>**my** [{*Název::JmProstoru*}] **$self = shift(@ARG);**<br>
<odsadit1>{*tělo metody*}<br>
**\}**

*# **zavolat metodu** přes ukazatel na objekt*<br>
*// Při tomto způsobu volání dostane metoda jako dodatečný první parametr zadaný ukazatel.*<br>
{*ukazatel*}**-&gt;**{*název\_metody*}**(**{*seznam, parametrů*}**)**

*# zavolat metodu přes třídu (typické pro volání konstruktorů)*<br>
*// Při tomto způsobu volání dostane metoda jako dodatečný první parametr řetězec obsahující název jmenného prostoru.*<br>
{*Název::JmProstoru*}**-&gt;**{*název\_metody*}**(**{*seznam, parametrů*}**)**

*# zavolat metodu **cizího** jmenného prostoru přes objekt (alternativy)*<br>
*// Při tomto způsobu volání dostane metoda jako dodatečný první parametr zadaný ukazatel.*<br>
{*ukazatel*}**-&gt;**{*Název::JmProstoru*}**::**{*název\_metody*}**(**{*seznam, parametrů*}**)**<br>
{*Název::JmProstoru*}**::**{*název\_metody*}**(**{*ukazatel*}[**,** {*seznam, parametrů*}]**)**

*# zavolat funkci ve jmenném prostoru neobjektově*<br>
*// Při tomto způsobu volání dostane funkce jen předané parametry, dodatečný první parametr nebude před vsunut.*<br>
{*Název::JmProstoru*}**::**{*název\_metody*}**(**{*seznam, parametrů*}**)**

*# obvyklý tvar **konstruktoru***<br>
**sub new**<br>
**\{**<br>
<odsadit1>**my** [{*Název::JmProstoru*}] **$self = bless({}, $ARG[0]);**<br>
<odsadit1>{*tělo konstruktoru*}<br>
<odsadit1>**return $self;**<br>
**\}**

*# obvyklá struktura **destruktoru***<br>
**sub DESTROY**<br>
**\{**<br>
<odsadit1>[**local ($NR, $ERRNO, $EVAL\_ERROR, $CHILD\_ERROR, $EXTENDED\_OS\_ERROR);**<br>
<odsadit1>**my** [{*Název::JmProstoru*}] **$self = shift(@ARG);**<br>
<odsadit1>{*příkazy*}...]<br>
**\}**

### Proměnné

*# deklarovat **specializovanou** proměnnou*<br>
*// Specializace nepředstavuje pro proměnnou žádné zásadní omezení, stále může obsahovat jakýkoliv skalár. Pokud je ovšem specializovaná na třídu s pevnou strukturou, použití neplatného konstantního klíče způsobí chybu již před spuštěním programu, což se vyplatí (je to jedna z mála „statický“ kontrol v Perlu).*<br>
{*my\|state\|our*} {*Název::JmProstoru*} **$**{*identifikátor*} [**=** {*inicializace*}]**;**

*# přístup k proměnným/funkcím v jiném jmenném prostoru*<br>
{*$@%*}{*Název::JmProstoru*}**::**{*identifikátor*}<br>
{*Název::JmProstoru*}**::**{*identifikátor*}[**(**{*parametry*}**)**]

### Třída s pevnou strukturou (deklarace a zkoumání)

*# omezit seznam dovolených klíčů*<br>
!: V záhlaví jmenného prostoru uvést:<br>
**use fields(**{*"seznam", "dovolených", "klíčů"*}**);**

*# obvyklý tvar **konstruktoru** (liší se od obecné třídy)*<br>
**sub new**<br>
**\{**<br>
<odsadit1>**my** {*Název::JmProstoru*} **$self = fields::new($ARG[0]);**<br>
<odsadit1>{*tělo konstruktoru*}<br>
<odsadit1>**return $self;**<br>
**\}**

*# **ukazuje** ukazatel na třídu s pevnou strukturou?*<br>
^^**use Hash::Util;**<br>
**Hash::Util::hashref\_locked(**{*ukazatel*}**)**

*# získat pole **dovolených klíčů** třídy s pevnou strukturou (z ukazatele/z třídy)*<br>
^^**require fields;**
^^**use Hash::Util;**<br>
**Hash::Util::legal\_ref\_keys(**{*ukazatel*}**)**<br>
**Hash::Util::legal\_ref\_keys(fields::new("**{*Název::JmProstoru*}**"))**
<!--
[ ] Vyzkoušet.
-->

*# získat asociativní pole dovolených klíčů*<br>
^^**use Hash::Util;**<br>
[{*%asocPole*} **=**] **(map {($ARG, exists** {*ukazatel*}**-&gt;{$ARG} ? 1 : 0)} Hash::Util::legal\_ref\_keys(**{*ukazatel*}**))**

*# je klíč dovolený?*<br>
^^**use Hash::Util;**<br>
**alength(grep {$ARG eq** {*"klíč"*}**\} Hash::Util::legal\_ref\_keys(**{*ukazatel*}**))**

*# vytvořit asociativní pole s pevnou strukturou*<br>
^^**use Hash::Util;**<br>
[{*$ukazatel*} **=**] **Hash::Util::lock\_ref\_keys({},** {*seznam, dovolených, klíčů*}**);**

*# vytvořit typovaný objekt s pevnou strukturou dynamicky*<br>
^^**use Hash::Util;**<br>
[{*$ukazatel*} **=**] **Hash::Util::lock\_ref\_keys(bless({},** {*"Název::JmProstoru"*}**),** {*seznam, dovolených, klíčů*}**);**


### Zkoumání jmenných prostorů a objektů

*# je cíli ukazatele přiřazen jmenný prostor?*<br>
*// Poznámka: některým vestavěným typům Perlu je také přiřazen jmenný prostor s metodami; např. regulární výrazy (vzniklé operátorem „qr//“) mají přiřazen jmenný prostor „Regexp“.*<br>
^^**use Scalar::Util;**<br>
**defined(Scalar::Util::blessed(**{*ukazatel*}**))**

*# která třída je přiřazena cíli ukazatele?*<br>
*// Pokud předaný skalár není ukazatel na objekt s přiřazeným jmenným prostorem, tato funkce vrátí undef.*<br>
**blessed(**{*ukazatel*}**)**

*# je možno nad daným objektem zavolat metodu určitého názvu?*<br>
{*ukazatel*}**-&gt;can("**{*název\_metody*}**")**

*# obsahuje jmenný prostor určitou funkci nebo konstantu?*<br>
{*Název::JmProstoru*}**-&gt;can("**{*identifikátor*}**")**

*# je ukazateli přiřazen určitý jmenný prostor nebo jeho potomek?*<br>
{*ukazatel*}**-&gt;isa("**{*Název::JmProstoru*}**")**

### Ostatní funkce

*# **přiřadit** objektu třídu*<br>
*// Funkce bless() vrací předaný ukazatel beze změny, ale až poté, co odkazovanému objektu přiřadila modul. Pozor! Jednou vytvořené přiřazení u daného objektu nelze zrušit ani přepsat, nepřenáší se však při kopírování, takže stačí přiřadit objekt (ne ukazatel na něj) do nové proměnné a získáte „čistou“ kopii, bez přiřazeného modulu.*<br>
**bless(**{*ukazatel*}**,** {*Název::JmProstoru*}**)**


<!--

[ ] Problém: Přetížení operátoru konverze na skalár (řetězec) nestačí, abyste s objektem mohl/a pracovat.

### Přetěžování operátorů

*# deklarovat přetížení operátorů (obecně)*<br>
*// Přetěžující funkce může být uvedena buď jako ukazatel na pojmenovanou či anonymní funkci, nebo jako řetězec (název funkce v aktuální jmenném prostoru).*<br>
**use overload(**<br>
<odsadit1>[**(**{*'operátor'*}**,** {*přetěžující-funkce*}**),**]...<br>
**);**

*# deklarovat přetížení operátorů (příklad)*<br>
**package MojeTřída;**<br>
[{*...*}]<br>
**use overload(**<br>
<odsadit1>**('""', sub {$ARG[0]-&gt;{"text"}}),**<br>
<odsadit1>**('+', sub {$ARG[0] . $ARG[1]})**<br>
**);**

*# deklarovat konverze na obyčejný skalár/ukazatel na pole/ukazatel na asociativní pole*<br>
**('""',** {*přetěžující-funkce*}**)**<br>
?<br>
?

<neodsadit>Konverzní operátory vhodné k přetížení:

'""' (konverze na obyčejný skalár)

<neodsadit>Binární operátory vhodné k přetížení:

'\+' '-' '\*' '/' '%' '\*\*' '&lt;&lt;' '&gt;&gt;' 'x' '.' '&amp;' '\|' '^' 'lt' 'le' 'eq' 'ne' 'ge' 'gt' '&lt;' '&lt;=' '==' '!=' '&gt;=' '&gt;'

<neodsadit>Unární operátory vhodné k přetížení:

'neg' (unární minus) '!' '\~' '++' '\-\-'

<neodsadit>Operátory dereference vhodné k přetížení:

'${}' '@{}' '%{}' '&{}'

Přetěžující metoda musí vracet ukazatel odpovídajícího typu, na kterém bude dereference provedena místo ukazatele na samotný objekt.
-->

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

* [Dokumentace přetěžování operátorů v Perlu](https://perldoc.perl.org/5.30.0/overload)

!ÚzkýRežim: vyp
