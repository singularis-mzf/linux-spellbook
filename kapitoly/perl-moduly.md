<!--

Linux Kniha kouzel, kapitola Perl: moduly a objekty
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

# Perl: moduly a objekty

!Štítky: {program}{Perl}{programování}
!FixaceIkon: 1754
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod

Tato kapitola z programovacího jazyka Perl pokrývá dělení kódu do modulů, práci s nimi
a objektově orientované programování.

Objektově orientované programování se v Perlu realizuje tak,
že obyčejnému objektu (poli, asociativnímu poli či skaláru) je přes ukazatel
přiřazen modul (třída), který obsahuje metody pro práci s ním.
Když pak metodu zavoláte pomocí objektově orientovaného operátoru
„-&gt;“, Perl ji automaticky najde v modulu, který je k objektu
přiřazen (nebo v některém z jeho „rodičů“, jak je modul deklaruje),
a při volání funkci vsune použitý ukazatel jako dodatečný parametr na začátku pole @ARG.

<!--
// příliš podrobné:
Zvláštním případem je volání některých metod (zejména takzvaných konstruktorů)
tak, že namísto ukazatele na objekt uvedete na levou stranu operátoru
„-&gt;“ přímo název jmenného prostoru. V takovém případě dostane metoda
v dodatečném parametru místo ukazatele řetězec s tímto názvem.
-->

## Definice

* **Symbol** je identifikátor funkce nebo konstanty nebo identifikátor proměnné včetně rozlišovacího symbolu „$“, „@“ nebo „%“.
* **Modul** (module) je pojmenovaný kontext pro umísťování funkcí a proměnných, oddělený od hlavního skriptu do samostatného souboru s příponou „.pm“ („Perl module“).
* **Hlavní skript** je zdrojový soubor, který byl přímo spuštěn interpretem Perlu. Na hlavní skript se při jeho spuštění nabalí moduly odkazované přímo či nepřímo příkazy „use“ a „require“.
* **Název modulu** je jednoznačné označení modulu, které se skládá z posloupnosti jednoho či více identifikátorů oddělených dvojí dvojtečkou („::“), např. „Digest::MD5“ nebo „English“. V adresářové cestě se pak dvojtečka nahradí za lomítko („/“) a na konec názvu se doplní „.pm“. Na rozdíl od jiných jazyků se název modulu v Perlu nezkracuje (vždy se uvádí celý) a mezi moduly není žádná automatická hierarchie.
* **Importovat symbol** znamená zpřístupnit symbol z jiného modulu tak, jako by byl definován i v tomto modulu. To umožňuje daný symbol používat bez kvalifikace názvem modulu, případně ho dál exportovat. Importovat lze jen ty symboly, které jsou daným modulem exportovány.
* **Exportovat symbol** znamená umožnit symbol ostatním modulům z tohoto modulu importovat.
* **Objekt** je místo paměti, které má svůj datový typ a hodnotu, je to tedy skalár, pole nebo asociativní pole. Objekty se dělí na **obyčejné objekty** a **objekty tříd** (jimž byla přiřazena třída).

### Objektově orientované programování

* Jako **metoda** se označuje funkce použitá objektově orientovaným způsobem (volaná objektově orientovaným operátorem „-&gt;“) nebo k tomu uzpůsobená.
* **Třída** (class) je modul obsahující metody (alespoň jednu). Kromě metod může obsahovat i funkce, které nejsou objektově orientované.
* **Rodič** třídy je modul (třída) uvedený/á příkazem „use parent“. Není-li požadovaná metoda nalezena v třídě, která je objektu přímo přiřazena, bude ji Perl hledat v jejích rodičích.

!ÚzkýRežim: vyp

## Zaklínadla

### Obvyklá struktura zdrojových souborů

*# obvyklá struktura hlavního **skriptu** (\*.pl)*<br>
[{*komentář*}]...<br>
[{*příkazy use*}]<br>
[{*definice konstant*}]<br>
[{*deklarace prototypů funkcí*}]<br>
{*definice proměnných a hlavní kód programu*}<br>
[{*definice funkcí*}]...

<!--
- use utf8; musí být před příkazem „package“, jinak Perl nedovolí diakritiku v názvu modulu.
-->
*# obvyklá struktura souboru **modulu** (\*.pm)*<br>
[{*komentář*}]...<br>
**use utf8;**<br>
**package** {*Název::Modulu*}**;**<br>
**use strict; use warnings; use v5.26.0;**<br>
**use LinuxKnihaKouzel; use English;**<br>
**use Exporter("import");**<br>
[{*další příkazy use*}]<br>
[{*definice konstant*}]<br>
[**use parent("**{*Rodič*}**"**[**,** {*DalšíRodič*}]...**);**]<br>
[**use fields(**{*"seznam", "datových", "složek"*}**);**]<br>
[**our @EXPORT =** {*("seznam", "symbolů", "pro", "výchozí", "import")*}**;**]<br>
**our @EXPORT\_OK =** {*("seznam", "ostatních", "exportovaných", "symb.")*}**;**<br>
[{*definice proměnných a inicializační kód*}]<br>
{*definice funkcí*}...<br>
**1;**

### Vyhledávání a připojování modulů

*# **připojit** modul a importovat výchozí symboly/konkrétní symboly/neimportovat žádné symboly*<br>
*// Perl prohledá standardní adresáře a adresáře zadané příkazem „use lib“ (resp. parametrem „-I“). Z každého takového adresáře hledá cestu sestavenou z komponent názvu modulu, kde poslední komponentu doplní o příponu „.pm“. Např. příkaz „use Digest::MD5“ bude hledat soubor „Digest/MD5.pm“. Nalezený modul se načte a z jeho jmenného prostoru se importují požadované symboly. Toto je obvyklý způsob používání modulů v Perlu.*<br>
**use** {*Název::Modulu*}**;**<br>
**use** {*Název::Modulu*}{*("seznam", "symbolů", "k", "importu")*}**;**<br>
**use** {*Název::Modulu*}**();**

*# hledat moduly i v zadaném adresáři*<br>
*// Cesta může být absolutní nebo relativní. Relativní cesta se však vyhodnocuje relativně vůči aktuálnímu adresáři, což nemusí být adresář, ve kterém se nachází běžící skript. Nově přidané cesty se prohledávají před dříve přidanými.*<br>
**use lib(**{*"cesta"*}[**,** {*"další/cesta"*}]...**);**

*# hledat moduly i v adresáři hlavního skriptu/jeho podadresáři*<br>
**use lib((MAIN\_SCRIPT\_DIR));**<br>
**use lib((MAIN\_SCRIPT\_DIR) . "/**{*relativní/cesta*}**");**

*# hledat moduly i ve stejném adresáři, kde se nachází daný zdrojový soubor*<br>
**use lib(((\_\_FILE\_\_ =~ s/^\[<nic>^\\/]\*$/.\\/x/r) =~ s/\\/\[<nic>^\\/]\*$//r));**
<!--
[ ] TODO: Otestovat!
-->

*# podmíněně nahrát modul*<br>
*// Vynechání volání „import“ je ekvivalentní příkazu „use“ s prázdným seznamem (neimportuje nic). Volání „import“ s prázdným seznamem je ekvivalentní příkazu „use“ bez seznamu (importuje výchozí symboly).*<br>
**BEGIN {if (**{*podmínka*}**) \{**<br>
<odsadit1>**require** {*Název::Modulu*}**;**<br>
<odsadit1>[{*Název::Modulu*}**-&gt;import(**[{*"seznam", "symbolů"*}]**);**]<br>
**\}}**

*# načíst zdrojový soubor jako modul, bez importu symbolů*<br>
*// Uvedená cesta musí začínat „/“ (v případě absolutní cesty), nebo „./“ v případě relativní cesty. Soubor nemusí mít příponu „.pm“.*<br>
**BEGIN {require("**[**.**]**/**{*cesta/k/souboru*}**")}**

*# je modul dostupný?*<br>
*// Tento test je možno provést i v době překladu (např. v definici konstanty nebo v bloku BEGIN)*<br>
**eval("require** {*Název::Modulu*}**; 1")**

### Přístup do modulů

*# přístup k proměnným/funkcím v jiném modulu*<br>
*// Tuto syntaxi doporučuji používat jen u málo používaných symbolů; symboly, které používáte ve zdrojovém kódu často, doporučuji v příkazu „use“ importovat.*<br>
{*$@%*}{*Název::Modulu*}**::**{*identifikátor*}<br>
{*Název::Modulu*}**::**{*identifikátor*}**(**[{*parametry*}]**)**

*# přístup z modulu k proměnným/funkcím v hlavním skriptu*<br>
{*$@%*}**main::**{*identifikátor*}<br>
**main::**{*identifikátor*}**(**[{*parametry*}]**)**

<!--
### Jmenné prostory

*# **přepnout** do kontextu jiného jmenného prostoru*<br>
*// Poznámka: příkaz „package“ je přepínač fungující v době překladu. Jeho účinek trvá do dalšího příkazu „package“, do konce bloku (jmenný prostor lze uzavřít do složených závorek) nebo do konce zdrojového souboru.*<br>
**package** {*Název::Modulu*}**;**

*# přepnout do kontextu hlavního jmenného prostoru*<br>
*// Tento příkaz obvykle nepotřebujete, protože je praktičtější ne-hlavní jmenné prostory uzavřít do složených závorek.*<br>
**package main;**
-->
<!--
*# načíst zdrojový soubor (cestu k souboru určit automaticky)*<br>
**require** {*Název::Modulu*}**;**

<!- -
<br>
**BEGIN {require** {*Název::Modulu*}**}** // [ ] vyzkoušet
-->

### Třídy a metody

*# obvyklá definice **metody***<br>
**sub** {*název\_metody*} [**: lvalue**]<br>
**\{**<br>
<odsadit1>**my** [{*Název::Modulu*}] **$self = shift(@ARG);**<br>
<odsadit1>{*tělo metody*}<br>
**\}**

*# **zavolat metodu** přes ukazatel na objekt (obecně/příklad)*<br>
*// Při tomto způsobu volání dostane metoda jako dodatečný první parametr zadaný ukazatel.*<br>
{*ukazatel*}**-&gt;**{*název\_metody*}**(**{*seznam, parametrů*}**)**<br>
**my $hodnota = $objekt-&gt;jeho\_metoda(1, 2, "");**

*# zavolat metodu přes třídu (typické pro volání konstruktorů)(obecně/příklad)*<br>
*// Při tomto způsobu volání dostane metoda jako dodatečný první parametr řetězec obsahující název modulu.*<br>
{*Název::Modulu*}**-&gt;**{*název\_metody*}**(**{*seznam, parametrů*}**)**<br>
**my Můj::Test $můjtest = Můj::Test-&gt;new();**

*# zavolat metodu **cizího** modulu přes objekt (alternativy)*<br>
*// Tato syntaxe pouze obchází vyhledávání metody; volaná metoda dostane dodatečný první parametr jako normálně.*<br>
{*ukazatel*}**-&gt;**{*Název::Modulu*}**::**{*název\_metody*}**(**{*seznam, parametrů*}**)**<br>
{*Název::Modulu*}**::**{*název\_metody*}**(**{*ukazatel*}[**,** {*seznam, parametrů*}]**)**

*# zavolat funkci modulu neobjektově*<br>
*// Při tomto způsobu volání dostane funkce jen předané parametry, dodatečný první parametr nebude před vsunut.*<br>
{*Název::Modulu*}**::**{*název\_metody*}**(**{*seznam, parametrů*}**)**

*# **přiřadit** objektu třídu*<br>
*// Funkce bless() vrací předaný ukazatel beze změny, ale až poté, co odkazovanému objektu přiřadila modul. Pozor! Jednou vytvořené přiřazení u daného objektu nelze zrušit ani přepsat, nepřenáší se však při kopírování, takže stačí přiřadit objekt (ne ukazatel na něj) do nové proměnné a získáte „čistou“ kopii, bez přiřazeného modulu.*<br>
**bless(**{*ukazatel*}**,** {*Název::Modulu*}**)**

*# obvyklý tvar **konstruktoru** (kromě tříd s pevnou strukturou)*<br>
*// Název metody „new“ není závazný. Nový objekt může být voláním funkce „bless()“ vytvořen kdekoliv v programu.*<br>
**sub new**<br>
**\{**<br>
<odsadit1>**my** [{*Název::Modulu*}] **$self = bless({}, $ARG[0]);**<br>
<odsadit1>{*tělo konstruktoru*}<br>
<odsadit1>**return $self;**<br>
**\}**

*# obvyklá struktura **destruktoru***<br>
**sub DESTROY**<br>
**\{**<br>
<odsadit1>[**local ($NR, $ERRNO, $EVAL\_ERROR, $CHILD\_ERROR, $EXTENDED\_OS\_ERROR);**<br>
<odsadit1>**my** [{*Název::Modulu*}] **$self = shift(@ARG);**<br>
<odsadit1>{*příkazy*}...]<br>
**\}**

### Třída s pevnou strukturou (deklarace)

*# **deklarovat** seznam dovolených klíčů*<br>
!: V záhlaví modulu uvést:<br>
**use fields(**{*"seznam", "dovolených", "klíčů"*}**);**

*# obvyklý tvar **konstruktoru** (liší se od obecné třídy)*<br>
**sub new**<br>
**\{**<br>
<odsadit1>**my** {*Název::Modulu*} **$self = fields::new($ARG[0]);**<br>
<odsadit1>{*tělo konstruktoru*}<br>
<odsadit1>**return $self;**<br>
**\}**

*# vytvořit prázdný objekt třídy s pevnou strukturou*<br>
*// Příkaz „use fields();“ je potřeba jen v případě, že v záhlaví modulu není uveden jiný příkaz „use fields“.*<br>
^^**use fields();**<br>
**fields::new(**{*"Název::Třídy"*}**)**

*# vytvořit asociativní pole s dynamicky danou pevnou strukturou*<br>
^^**use Hash::Util;**<br>
[{*$ukazatel*} **=**] **Hash::Util::lock\_ref\_keys({},** {*seznam, dovolených, klíčů*}**);**

*# vytvořit typované asociativní pole s pevnou strukturou dynamicky*<br>
^^**use Hash::Util;**<br>
[{*$ukazatel*} **=**] **Hash::Util::lock\_ref\_keys(bless({},** {*"Název::Modulu"*}**),** {*seznam, dovolených, klíčů*}**);**

### Specializované proměnné

*# deklarovat **specializovanou** proměnnou*<br>
*// Specializace nepředstavuje pro proměnnou žádné zásadní omezení, stále může obsahovat jakýkoliv skalár. Pokud je ovšem specializovaná na třídu s pevnou strukturou, použití neplatného konstantního klíče způsobí chybu již před spuštěním programu, což se vyplatí (je to jedna z mála „statický“ kontrol v Perlu).*<br>
{*my\|state\|our*} {*Název::Modulu*} **$**{*identifikátor*} [**=** {*inicializace*}]**;**

### Zkoumání modulů a objektů

*# je cíli ukazatele **přiřazen** modul (třída)?*<br>
*// Poznámka: některým vestavěným typům Perlu je také přiřazena třída; např. regulární výrazy (vzniklé operátorem „qr//“) mají přiřazenu třídu „Regexp“.*<br>
^^**use Scalar::Util;**<br>
**defined(Scalar::Util::blessed(**{*ukazatel*}**))**

*# **která třída** je přiřazena cíli ukazatele?*<br>
*// Pokud předaný skalár není ukazatel na objekt s přiřazenou třídou, tato funkce vrátí undef.*<br>
^^**use Scalar::Util;**<br>
**Scalar::Util::blessed(**{*ukazatel*}**)**

*# je možno nad daným objektem zavolat metodu určitého názvu?*<br>
{*ukazatel*}**-&gt;can("**{*název\_metody*}**")**

<!--
*# obsahuje modul určitou funkci nebo konstantu?*<br>
*// Tuto funkci používejte opatrně; nemusí být úplně spolehlivá, protože Perl může definovat identifikátory, pro které bude vracet pravdu, přestože modul ve skutečnosti takovou funkci či konstantu neobsahuje.*<br>
{*Název::Modulu*}**-&gt;can("**{*identifikátor*}**")**
<!- -
[ ] Zděděné konstanty?
-->

*# je odkazovanému objektu přiřazen určitý modul nebo jeho potomek?*<br>
{*ukazatel*}**-&gt;isa("**{*Název::Modulu*}**")**

### Zkoumání tříd s pevnou strukturou a jejich objektů

*# **ukazuje** ukazatel na třídu s pevnou strukturou?*<br>
^^**use Hash::Util;**<br>
**Hash::Util::hashref\_locked(**{*ukazatel*}**)**

*# získat pole **dovolených klíčů** třídy s pevnou strukturou (z ukazatele/z třídy)*<br>
^^**require fields;**<br>
^^**use Hash::Util;**<br>
**Hash::Util::legal\_ref\_keys(**{*ukazatel*}**)**<br>
**Hash::Util::legal\_ref\_keys(fields::new("**{*Název::Modulu*}**"))**
<!--
[ ] Vyzkoušet.
-->

*# získat asociativní pole dovolených klíčů*<br>
^^**use Hash::Util;**<br>
[{*%asocPole*} **=**] **(map {($ARG, exists** {*ukazatel*}**-&gt;{$ARG} ? 1 : 0)} Hash::Util::legal\_ref\_keys(**{*ukazatel*}**))**

*# je klíč dovolený?*<br>
^^**use Hash::Util;**<br>
**alength(array(grep {$ARG eq** {*"klíč"*}**\} Hash::Util::legal\_ref\_keys(**{*ukazatel*}**)))**

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

<!--
## Parametry příkazů
<!- -
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)
-->

## Instalace na Ubuntu

Všechny použité nástroje jsou základní součástí Ubuntu, přítomnou i v minimální instalaci.

## Ukázka

### Hlavní skript (ukázka.pl)

*# *<br>
**# Jednoduchý testovací skript**<br>
**use lib((MAIN\_SCRIPT\_DIR));**<br>
**use Ukázka;**<br>
**use constant TEXT =&gt; "Hello, world.";**<br>
**my $výsledek = Ukázka::vypsat\_text(TEXT);**<br>
**printf("Návratová hodnota: %s\\n", $výsledek);**

### Modul (Ukázka.pm)

*# *<br>
**use utf8;**<br>
**package Ukázka;**<br>
**use strict; use warnings; use v5.26.0;**<br>
**use LinuxKnihaKouzel; use English;**<br>
**use Exporter("import");**<br>
**our @EXPORT\_OK = ("vypsat\_text");**<br>
**sub vypsat\_text**<br>
**\{**<br>
<odsadit1>**return 0 + printf("%s\\n", $ARG[0]);**<br>
**\}**<br>
**1;**

!ÚzkýRežim: zap

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
* Abyste se vyhnul/a problémům s názvy modulů, každá část názvu musí začínat velkým písmenem a obsahovat alespoň jedno malé písmeno. Např. názvy „Č7á“ nebo „Ay“ jsou vyhovující, názvy „xAb“ či „Z9“ ne.
* Někteří uživatelé příkazem „use lib(".");“ nastavují, aby Perl moduly vyhledával i v aktuálním adresáři. To však není vůbec dobrý nápad, protože aktuální adresář při spuštění skriptu může být zcela nečekaný. Proto doporučuji to nedělat a adresář pro vyhledávání modulů předávat jinak, nejlépe parametrem Perlu -I.
* V Perlu je zvykem nevyužívat výchozí import (proměnnou „@EXPORT“), pokud to nezbytně nepotřebujete. Nechte na uživateli, aby si vybral, které symboly bude chtít importovat.
* Jmenné prostory („package“) lze používat i v rámci jednoho souboru, tato kapitola se ale takovému použití záměrně vyhýbá, protože jsou s ním spojeny problémy — některé příkazy „use“ totiž účinkují na zdrojový soubor (a tedy nebudou účinkovat v tomtéž jmenném prostoru v jiných zdrojových souborech), zatímco jiné účinkují na jmenný prostor (a tedy zase nebudou účinkovat v tomtéž souboru v jiných jmenných prostorech), některé možná kombinují oba účinky.
* Některé moduly používají seznam importovaných symbolů k jiným účelům než jako seznam symbolů, např. k předání nastavení.

<!--
* Proměnné deklarované na úrovni jmenného prostoru klíčovým slovem „my“ jsou zamýšleny tak, že jsou omezeny jen na daný zdrojový soubor. Ve skutečnosti takto deklarovanou proměnnou můžete použít ve více zdrojových souborech, ale v takovém případě pro každý z nich vznikne samostatná proměnná!
-->


## Další zdroje informací

* [Root.cz: Perličky: přetěžování operátorů](https://www.root.cz/clanky/perlicky-pretezovani-operatoru/)
* [Root.cz: Perličky: pokročilé př. op.](https://www.root.cz/clanky/perlicky-pokrocile-pretezovani-operatoru/)
* [YouTube: Perl Session 13](https://www.youtube.com/watch?v=eR4uPY6UH0I) (anglicky)
* [YouTube: Perl: Packages and Modules](https://www.youtube.com/watch?v=UVlgFmg0UCs) (anglicky)
* [Dokumentace přetěžování operátorů v Perlu](https://perldoc.perl.org/5.30.0/overload) (anglicky)

## Zákulisí kapitoly
<!--
- Doplňte, pokud víte. Udržujte aktuální.
-->

V této verzi kapitoly chybí:

!KompaktníSeznam:
* export/import symbolů po skupinách

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* přetěžování operátorů (jsou s ním komplikované problémy)

!ÚzkýRežim: vyp
