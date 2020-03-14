<!--

Linux Kniha kouzel, kapitola Základy Perlu
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

[ ] Naprogramovat funkci, která vrátí pole všech shod regulárního výrazu.

- Referenční příručka: https://perldoc.perl.org/5.30.0/index-functions-by-cat.html

-->

# Základy Perlu

!Štítky: {program}{zpracování textu}{syntaxe}{Perl}{programování}
!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

Perl je programovací jazyk pro zpracování textu, který je mezi programátory
velmi oblíbený a rozšířený, ale má špatnou pověst, protože je multisyntaktický
a pro neodborníka velmi špatně čitelný. Přesto je velmi užitečný
a je snadné v něm začít programovat i při využití jen malé,
konzervativně zvolené, podmnožiny jeho vlastností. (Většinu vlastností
Perlu totiž tvoří syntaktické zkratky, které expertům pomáhají psát programy
rychle a efektivně, ale nepřidávají nic k funkčnosti jazyka.)

Perl je záludný skriptovací jazyk, v němž se proměnné deklarují
nejčastěji klíčovým slovem „my“, velikost pole se určuje funkcí „scalar()“,
modul Perlu musí končit příkazem „1;“ a podmínka „if (false)“ je splněna...
Úspěšné použití takového jazyka vyžaduje buď hlubokou znalost,
nebo se omezit na úzkou, konzervativně zvolenou podmnožinu jeho
funkcionality. Tato kapitola volí druhou uvedenou cestu. Budete-li
v Perlu programovat delší dobu, pravděpodobně se časem naučíte
znát jeho svévolné a zákeřné pasti a využít jeho ezoterické syntaktické
zkratky. Do té doby vám tato kapitola pomůže se jim vyhnout,
a přesto z moci Perlu vytěžit co nejvíc.

## Definice

Perl rozeznává čtyři základní datové typy:

* **Skalár**, což je vlastně řetězec, se kterým pouze číselné operátory a funkce zacházejí jako s číslem. Přístup ke skaláru se značí znakem „$“ a výchozí hodnotou skalárních objektů je speciální **nehodnota undef**.
* **Pole**, což je uspořádaný kontejner skalárů indexovaný celými čísly 0, 1, 2 atd. Přístup k poli se značí znakem „@“ a pole se indexuje hranatými závorkami „[]“. Výchozí hodnotou objektu typu pole je prázdné pole.
* **Asociativní pole** (hash), což je neuspořádaný kontejner skalárů (hodnot) indexovaný jinými skaláry (klíči). Přístup k asociativnímu poli se značí znakem „%“ a tato pole se indexují složenými závorkami „{}“. Výchozí hodnotou objektu tohoto typu je prázdné asociativní pole.
* **Funkce**, což je prostě funkce, která přebírá parametry a vrací návratovou hodnotu.

Proměnné každého z těchto typů mají svůj vlastní jmenný prostor, takže je v pořádku mít vedle sebe např. pole „@x“ a asociativní pole „%x“.

* **Ukazatel** (reference, v češtině obvykle nazývaný „odkaz“) je skalár, který odkazuje na nějaký objekt v paměti. **Dereferencí** ukazatele můžeme získat přístup k odkazovanému objektu pro čtení i přiřazení.
* **Seznam** je literál pole zadaný do kulatých závorek, např. „(1, 2, 3)“ nebo „($a, $b, $c)“. Má-li sudý počet prvků, lze s ním inicializovat i asociativní pole.

!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Skaláry
<!--
Sem nepatří zaklínadla specifická pro jednotlivé typy skalárů (čísla, řetězce, ukazatele); výjimkou jsou zaklínadla pro nehodnotu undef, ta sem patří.
-->

*# deklarovat proměnnou (lokální v bloku či souboru/globální, viditelnou všemi moduly)*<br>
*// V rámci deklarace proměnné nemůžete deklarovat víc než jednu proměnnou; toto omezení se však běžně obchází pomocí syntaxe pro rozklad pole do proměnných. Viz sekci „Pole“.*<br>
**my $**{*identifikátor*} [**=** {*hodnota*}]**;**<br>
**our $**{*identifikátor*} [**=** {*hodnota*}]**;**

*# přečíst proměnnou/přiřadit do proměnné*<br>
**$**{*identifikátor*}<br>
**$**{*identifikátor*} **=** {*hodnota*}

*# neobsahuje skalár nehodnotu undef?*<br>
**defined(**{*$skalár*}**)**

*# přiřadit proměnné nehodnotu **undef***<br>
**undef($**{*identifikátor*}**)**

### Pole

*# literál pole (jako hodnota/jako ukazatel na pole)*<br>
**(**[{*skalár*}[**,** {*další skalár*}]...]**)**<br>
**[**[{*skalár*}[**,** {*další skalár*}]...]**]**

*# získat prvek pole na indexu I*<br>
**$**{*identifikátor\_pole*}**[**{*index*}**]**

*# deklarovat pole*<br>
**my @**{*identifikátor\_pole*} [**= (**{*prvky, pole*}**)**]**;**

*# rozložit pole do nových skalárních proměnných*<br>
**my ($**{*id*}[**,** {*další\_id*}]...**) =** {*@pole*}**;**

*# zjistit **počet prvků** pole*<br>
**scalar(**{*@pole*}**)**

*# **přidat** prvek na začátek/konec pole*<br>
**unshift(**{*@pole*}**,** {*skalár*}**)**<br>
**push(**{*@pole*}**,** {*skalár*}**)**

*# **vyjmout** první/poslední prvek pole*<br>
*// Obě uvedené funkce vracejí vyjmutý prvek.*<br>
**shift(**{*@pole*}**)**<br>
**pop(**{*@pole*}**)**

*# smazat všechny prvky*<br>
{*@pole*} **= ();**

*# vytvořit pole s posloupností celých čísel/znaků*<br>
**(**{*celé-číslo*}**..**{*celé-číslo*}**)**<br>
**(**{*znak*}**..**{*znak*}**)**

<!--
splice()?
-->

### Asociativní pole

*# literál asociativního pole (jako hodnotu/jako ukazatel na asociativní pole)*<br>
**(**[{*klíč*}**,** {*hodnota*}[**,** {*další klíč*}**,** {*další hodnota*}]...]**)**<br>
**\{**[{*klíč*}**,** {*hodnota*}[**,** {*další klíč*}**,** {*další hodnota*}]...]**\}**

*# smazat prvek/všechny prvky*<br>
**delete** {*%pole*}**\{**{*klíč*}**\};**<br>
{*%pole*} **= ();**
<!--
Problém: co když pracuji s referencí?
-->

*# obsahuje prvek?*<br>
**exists(**{*%pole*}**\{**{*klíč*}**\})**

*# přidat či přepsat prvek*<br>
?

*# získat pole klíčů/hodnot*<br>
**keys(**{*%pole*}**)**<br>
**values(**{*%pole*}**)**

*# získat počet dvojic v asociativním poli*<br>
**scalar(keys(**{*%pole*}**))**


### Funkce

*# zavolat uživatelskou funkci*<br>
{*identifikátor\_funkce*}**(**{*parametry,oddělené,čárkami*}**)**

*# definovat uživatelskou funkci*<br>
**sub** {*identifikátor\_funkce*} {*blok příkazů*}

*# vrátit se z funkce a vrátit návratovou hodnotu*<br>
**return** {*návratová hodnota*}**;**

### Komentáře

*# komentář do konce řádku*<br>
**#** {*obsah komentáře*}

*# víceřádkový komentář*<br>
*// Pozor, před znakem „=“ na uvedených speciálních řádcích nesmí být žádný jiný znak, ani odsazení!*<br>
**=begin&blank;comment**<br>
{*obsah komentáře (i víc řádků)*}<br>
**=end&blank;comment**<br>
**=cut**

### Cykly

*# cyklus **for** (s definicí vlastní proměnné/obecný)*<br>
[{*návěští*}**:**] **for (my $**{*identifikátor*} **=** {*výraz*}**;** [{*podmínka*}]**;** [{*výraz-iterace*}]**)** {*blok příkazů*}
[{*návěští*}**:**] **for (**[{*výraz-inicializace*}]**;** [{*podmínka*}]**;** [{*výraz-iterace*}]**)** {*blok příkazů*}

*# cyklus **foreach***<br>
*// „Prvky“ zde mohou být jak jednotlivé skaláry, tak i pole a asociativní pole, která se rozloží, stejně jako při volání funkcí.*<br>
[{*návěští*}**:**] **foreach** [**my**] **$**{*identifikátor*} **(**{*prvky*}**)** {*blok příkazů*} [**continue** {*další blok příkazů*}]

*# cyklus typu **while** (s pozitivní podmínkou/negovanou podmínkou)*<br>
[{*návěští*}**:**] **while (**{*podmínka*}**)** {*blok příkazů*} [**continue** {*další blok příkazů*}]<br>
[{*návěští*}**:**] **until (**{*podmínka*}**)** {*blok příkazů*} [**continue** {*další blok příkazů*}]

*# cyklus typu **do...while** (s pozitivní podmínkou/negovanou podmínkou)*<br>
**do** {*blok příkazů*} **while (**{*podmínka*}**);**<br>
**do** {*blok příkazů*} **while (!(**{*podmínka*}**));**

*# nekonečný cyklus*<br>
[{*návěští*}**:**] **for (;;)** {*blok příkazů*}

### Řízení cyklů a jiné skoky

*# vyskočit za konec cyklu*<br>
**last** [{*návěští*}]**;**

*# skočit těsně před uzavírací závorku cyklu*<br>
**next** [{*návěští*}]**;**

*# skočit přímo za otevírací závorku cyklu*<br>
**redo** [{*návěští*}]**;**

*# skočit na návěští*<br>
**goto** {*návěští*}**;**


### Podmínky

*# provést blok příkazů, je-li podmínka pravdivá/nepravdivá*<br>
**if (**{*podmínka*}**)** {*blok příkazů*} [**elsif (**{*podmínka*}**)** {*blok příkazů*}]... [**else** {*blok příkazů*}]<br>
**unless (**{*podmínka*}**)** {*blok příkazů*} [**elsif (**{*podmínka*}**)** {*blok příkazů*}]... [**else** {*blok příkazů*}]

*# provést příkaz, je-li podmínka pravdivá (alterantivy)*<br>
{*podmínka*} **and** {*příkaz*}**;**<br>
{*příkaz*} **if (**{*podmínka*}**);**

*# provést příkaz, je-li podmínka nepravdivá (alterantivy)*<br>
{*podmínka*} **or** {*příkaz*}**;**<br>
{*příkaz*} **unless (**{*podmínka*}**);**

*# přepínač „**switch**“ bez větve „default“*<br>
*// V případě zanoření změňte ve vnořeném kódu identifkátory „hodnota“ a „priznak“. Poznámka: příkaz „next“ používejte uvnitř této konstrukce pouze s návěštím.*<br>
[{*návěští*}**:**] **foreach my $hodnota (** {*skalární-výraz*}**) \{**<br>
**my $priznak = 0;**<br>
[**if ($priznak || ($priznak = $hodnota eq** {*hodnota*}**))** {*blok příkazů*}]...<br>
**\}**

*# přepínač „**switch**“ s větví „default“*<br>
*// Použijete-li tuto konstrukci v programu víckrát, při každém použití změňte identifkátor „default“! V případě zanoření změňte ve vnořeném kódu také identifkátory „hodnota“ a „priznak“.*<br>
[{*návěští*}**:**] **foreach my $hodnota (** {*skalární-výraz*}**) \{**<br>
**my $priznak = 0;**<br>
[**if ($priznak || ($priznak = $hodnota eq** {*hodnota*}**))** {*blok příkazů*}]...<br>
!: Někam do těla konstrukce umístěte před některý příkaz návěští „default:“.<br>
**unless ($priznak) {$priznak = 1; goto default;}**
**\}**

### Skaláry: řetězce


*# zjistit délku řetězce*<br>
**length(**{*$skalár*}**)**

*# spojit řetězce*<br>
{*$řetězec*} **.** {*$další\_řetězec*} [**.** {*$ještě\_další\_řetězec*}]

*# zopakovat řetězec*<br>
{*$řetězec*} **x** {*$počet*}

*# rozdělit řetězec na pole*<br>
[{*@pole*} **=**] **split(**{*oddělovač*}**,** {*dělený-řetězec*}[**,** {*maximální-počet-dílů*}]**)**

*# spojit pole na řetězec*<br>
[{*$řetězec*} **=**] **join(**{*oddělovač*}**,** {*@pole*}**)**

*# má shodu s regulárním výrazem?*<br>
{*řetězec*} **=~ /**{*regulární výraz*}**/**[**i**][**m**]

*# najít pozitici první shody s regulárním výrazem*<br>
?

*# provést náhradu pomocí regulárního výrazu (destruktivní/nedestruktivní)*<br>
*// Destruktivní varianta uloží výsledek náhrady do uvedené proměnné a vrátí jen, zda k nahrazení došlo. Nedestruktivní varianta vrátí řetězec po provedení náhrady (nedošlo-li k náhradě, vrací původní řetězec).*<br>
{*$proměnná*} **=~ s/**{*regulární výraz*}**/**{*náhrada*}**/**[**g**][**i**][**m**][**s**]<br>
{*$řetězec*} **=~ s/**{*regulární výraz*}**/**{*náhrada*}**/r**[**g**][**i**][**m**][**s**]
<!--
Problém: konstrukce [a][b] má v současnosti odlišný speciální význam v Markdownu a v těchto
zdrojových kódech. Tuto situaci je třeba vyřešit.
-->

*# přeložit znaky (analogie příkazu **tr**)*<br>
*// Poznámka: výsledek překladu přepíše původní proměnnou, ale není návratovou hodnotou výrazu!*<br>
{*$proměnná*} **=~ y/**{*původní-znaky*}**/**{*nové-znaky*}**/**

<!--
sort()?

m//g
s///
tr///

$MATCH, $PREMATCH, $ARG, $POSTMATCH
-->

<!--
use feature 'state';
-->

### Operátory

*# vrátit první definovanou hodnotu*<br>
{*skalár*} [**//** {*další-skalár*}]...


### Skaláry: ukazatelé

*# je skalár ukazatel?/zjistit odkazovaného objektu*<br>
**defined(ref(**{*$skalár*}**))**<br>
**ref(**{*$skalár*}**)**

*# získat ukazatel na skalár/pole/asociativní pole/funkci/prvek pole/hodnotu v asociativním poli*<br>
*// Poznámka: klíče v asociativním poli jsou nepřiřaditelné, proto ukazatel na ně nelze získat.*<br>
**\\$**{*identifkátor\_skalární\_proměnné*}<br>
**\\@**{*identifkátor\_pole*}<br>
**\\%**{*identifkátor\_asociativního\_pole*}<br>
**\\&amp;**{*identifkátor\_funkce*}<br>
**\\$**{*identifkátor\_pole*}**[**{*index*}**]**<br>
**\\$**{*identifkátor\_asociativního\_pole*}**\{**{*klíč*}**\}**<br>

*# přistoupit přes ukazatel ke skaláru/poli/asociativnímu poli/funkci*<br>
**\$\$**{*identifikátor\_ukazatele*}<br>
**@$**{*identifikátor\_ukazatele*}<br>
**%$**{*identifikátor\_ukazatele*}<br>
**&amp;$**{*identifikátor\_ukazatele*}

*# přistoupit k prvku pole/asociativního pole přes ukazatel*<br>
**\$\$**{*identifikátor\_ukazatele*}**-&gt;[**{*index*}**]**<br>
**\$\$**{*identifikátor\_ukazatele*}**-&gt;\{**{*klíč*}**\}**

*# zavolat funkci přes ukazatel*<br>
**&amp;**{*$skalár*}**(**[{*parametr*}[**,** {*další parametr*}]...]**)**

### Moduly

*# načíst modul*<br>
**use** [{*adresář*}**\:\:**]...{*název\_souboru\_bez\_přípony*}**;**

*# hledat moduly i ve stejném adresáři, kde se nachází daný zdrojový soubor*<br>
**use lib (((\_\_FILE\_\_ =~ s/^\[^\\/]\*$/.\\/x/r) =~ s/\\/\[^\\/]\*$//r));**
<!--
TODO: Otestovat!
-->

*# obecná struktura souboru modulu*<br>
**package** {*NázevSouboruBezPřípony*}**;**<br>
{*blok příkazů „use“*}<br>
{*definice proměnných a funkcí*}<br>
**1;**



## Zaklínadla (práce se soubory)

### Otevřít/zavřít

*# zavřít soubor či rouru*<br>
**close(**{*$f*}**)** [**or die(**{*zpráva*}**)**]

*# otevřít soubor*<br>
*// Mód může být „&lt;“... [ ] TODO!*<br>
**undef(**{*$f*}**);**<br>
**open(**{*$f*}**, "**{*mód*}**",** {*"cesta/k/souboru"*}**)** [**or die(**{*zpráva*}**)**]

*# otevřít rouru pro zápis*<br>
**undef(**{*$f*}**);**<br>
**open(**{*$f*}**, "\|-", "**{*název-příkazu*}**"**[**,** {*parametr-příkazu*}]...**)** [**or die(**{*zpráva*}**)**]

*# otevřít rouru pro čtení*<br>
**undef(**{*$f*}**);**<br>
**open(**{*$f*}**, "-\|", "**{*název-příkazu*}**"**[**,** {*parametr-příkazu*}]...**)** [**or die(**{*zpráva*}**)**]


### Číst

*# načíst řádek*<br>
*// Funkci spusťte v kontextu, kde se očekává skalár; vrací načtený řádek včetně znaku konce řádku (lze odstranit funkcí „chomp()“); bylo-li dosaženo konce souboru, vrací „undef“.*<br>
{*$cíl*} **= readline(**{*$f*}**);**<br>
[**chomp(**{*$cíl*}**);**]

*# načíst znak*<br>
*// Podle manuálu tato funkce není příliš efektivní. Pravděpodobně by mohlo být rychlejší načíst řádek funkcí „readline()“ a rozdělit po znacích funkcí „substr()“.*<br>
{*$cíl*} **= getc(**{*$f*}**);**

*# načíst všechny (zbývající) řádky*<br>
{*@cíl*} **= readline(**{*$f*}**);**<br>
[**chomp(**{*@cíl*}**);**]

*# načíst celý soubor najednou*<br>
{*$cíl*} **= "";**<br>
**while (read(**{*$f*}**,** {*$cíl*}**, 4096, length(**{*$cíl*}**))) {}**

### Zapisovat
<!--

https://www.tutorialspoint.com/perl/perl_special_variables.htm
-> používat „use English;“!
-->

*# zapsat záznam (položky oddělené hodnotou „$OFS“ a zakončené hodnotou „$ORS“)*<br>
*// Vynecháte-li $f, použije se „STDOUT“ (standardní výstup). Pozor na zvláštní syntaxi − za označením výstupního souboru se zde píše mezera bez čárky!*<br>
**print(**[{*$f*}**&blank;**]{*první položka*}[**,** {*další položka*}]**)**

*# zapsat řetězec*<br>
**printf(**[{*$f*}**&blank;**]**"%s",** {*$řetězec*}**)**



## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

*# doporučený způsob volání Perlu*<br>
**perl**


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

!ÚzkýRežim: zap

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

* *Předávání parametrů do funkcí:* Parametry se do funkce předají pomocí pole „@\_“, které má tu speciální vlastnost, že ty jeho prvky, které byly v místě předání *přiřaditelnými* hodnotami (včetně např. prvků jiných polí) se do něj předají odkazem. To znamená, že skalární proměnné se do všech funkcí předávají odkazem, nikdy hodnotou. Pole (včetně seznamů) se při předávání do funkce rozloží na všechny svoje prvky v náležitém pořadí a ty se předají odkazem. Asociativní pole se rozloží na posloupnost dvojic „klíč,hodnota“, příčemž klíče se předají hodnotou (jsou nepřiřaditelné), zatímco hodnoty se předají odkazem. Perl neprovádí žádnou automatickou kontrolu počtu, typu či hodnoty předaných parametrů; ta je výhradně zodpovědností volané funkce.
* Seznam (na rozdíl od pole) obsahuje svoje prvky odkazem (pozor, neplést s ukazatelem) a přiřazuje se do něj po prvcích; to znamená, že např. výrazem **($a, $b) = (1, 2)** přiřadíte do proměnné **$a** hodnotu 1 a do proměnné **$b** hodnotu 2; podobně výrazem „($a, $b) = @x“ načtete do proměnných $a a $b první dva prvky pole @x. Uvedete-li do seznamu pole nebo vnořený seznam, ten se „rozbalí“ na svoje prvky, proto např. výrazem „(@x) = (1, 2)“ přiřadíte hodnoty do prvních dvou prvků pole, aniž byste ho zkrátili; oproti tomu příkazem „@x = (1, 2)“ přiřadíte do proměnné „@x“ nové, dvouprvkové pole.

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

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

## Pomocné funkce (Perl)

*# lkk -p perl-vzorek-parametru − xxx*<br>
**sub vzorek\_parametru \{**<br>
<odsadit1>**return join("", map \{**<br>
<odsadit2>**my $r;**<br>
<odsadit2>**!defined($ARG) ? "u" :**<br>
<odsadit2>**!($r = ref($ARG)) ? "s" :**<br>
<odsadit2>**$r =~ /^(SCALAR\|ARRAY\|HASH\|Regexp)$/ ? substr($r, 0, 1) :**<br>
<odsadit2>**":".$r.":";**<br>
<odsadit1>**\} @\_);**<br>
**\}**
