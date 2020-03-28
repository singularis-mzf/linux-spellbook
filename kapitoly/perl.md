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
!FixaceIkon: 1754
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

* **Skalár**, což je dynamicky typovaná proměnná, která může obsahovat řetězec, číslo, ukazatel na nějaký objekt nebo zvláštní **nehodnotu undef**, která je výchozí hodnotou skalárů (a lze ji také považovat za „ukazatel nikam“). Přístup ke skaláru se značí znakem „$“ a výchozí hodnotou skalárních objektů je speciální **nehodnota undef**. (Poznámka: v Perlu existují i skaláry, které mají současně nesouvisející číselnou a řetězcovou hodnotu, např. mají řetězcovou hodnotu "Hello" a číselnou hodnotu 13. Doufejte však, že na takové zrůdnosti při svém programování nenarazíte.)
* **Pole**, což je uspořádaný kontejner skalárů indexovaný celými čísly 0, 1, 2 atd. Přístup k poli se značí znakem „@“ a pole se indexuje hranatými závorkami „[]“. Výchozí hodnotou objektu typu pole je prázdné pole.
* **Asociativní pole** (hash), což je neuspořádaný kontejner skalárů (hodnot) indexovaný jinými skaláry (klíči). Přístup k asociativnímu poli se značí znakem „%“ a tato pole se indexují složenými závorkami „{}“. Výchozí hodnotou objektu tohoto typu je prázdné asociativní pole.
* **Funkce** je pojmenovaný či nepojmenovaný podprogram, který přebírá parametry a vrací návratovou hodnotu.

Proměnné každého z těchto typů mají svůj vlastní jmenný prostor, takže je v pořádku mít vedle sebe např. pole „@x“ a asociativní pole „%x“.

* **Ukazatel** (reference, v češtině obvykle nazývaný „odkaz“) je skalár, který odkazuje na nějaký objekt v paměti (pole, funkci, regulární výraz apod.). **Dereferencí** ukazatele můžeme získat přístup k odkazovanému objektu pro čtení i přiřazení.
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

*# deklarovat proměnnou (lokální v bloku či souboru/viditelnou všemi moduly)*<br>
*// V rámci deklarace proměnné nemůžete deklarovat víc než jednu proměnnou; toto omezení se však běžně obchází pomocí syntaxe pro rozklad pole do proměnných. Viz sekci „Pole“.*<br>
**my $**{*identifikátor*} [**=** {*hodnota*}]**;**<br>
**our $**{*identifikátor*} [**=** {*hodnota*}]**;**

*# přečíst proměnnou/**přiřadit** do proměnné*<br>
**$**{*identifikátor*}<br>
**$**{*identifikátor*} **=** {*hodnota*}

*# neobsahuje proměnná nehodnotu undef?*<br>
**defined(**{*$skalár*}**)**

*# přiřadit proměnné nehodnotu **undef***<br>
**$**{*identifikátor*} **= undef**

*# získat hodnotu proměnné prostředí (obecně/příklad)*<br>
**$ENV\{"**{*názevproměnné*}**\}**<br>
**$ENV{"PATH"}**

*# přiřadit hodnotu proměnné prostředí*<br>
**$ENV\{"**{*názevproměnné*}**\} =** {*hodnota*}

### Pole

*# literál pole (vrací seznam/vrací ukazatel)*<br>
**(**[{*skalár*}[**,** {*další skalár*}]...]**)**<br>
**[**[{*skalár*}[**,** {*další skalár*}]...]**]**

*# **přečíst** hodnotu prvku pole*<br>
**$**{*identifikátor\_pole*}**[**{*index*}**]**

*# **přiřadit** hodnotu prvku pole*<br>
**$**{*identifikátor\_pole*}**[**{*index*}**] =** {*hodnota*}

*# **existuje** prvek pole?*<br>
{*index*} **lt; scalar(**{*@pole*}**) &amp;&amp;** {*index*} **&gt;= 0**

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

*# **smazat** všechny prvky/úsek*<br>
{*@pole*} **= ();**<br>
**splice(**{*@pole*}**,** {*první-smaz-index*}**,** {*počet-ke-smazání*}**);**

*# **zkopírovat** celé pole*<br>
{*@cílové\_pole*} **=** {*@zdrojové\_pole*}**;**

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

*# **smazat** prvek/všechny prvky*<br>
**delete** {*%pole*}**\{**{*klíč*}**\};**<br>
{*%pole*} **= ();**
<!--
Problém: co když pracuji s referencí?
-->

*# **obsahuje** prvek?*<br>
**exists(**{*%pole*}**\{**{*klíč*}**\})**

*# **přidat** či přepsat prvek*<br>
**$**{*idpole*}**{"**{*klíč*}**"} =** {*hodnota*}

*# získat pole klíčů/hodnot*<br>
**keys(**{*%pole*}**)**<br>
**values(**{*%pole*}**)**

*# získat počet dvojic v asociativním poli*<br>
**scalar(keys(**{*%pole*}**))**


### Funkce

*# zavolat uživatelskou funkci*<br>
{*identifikátor\_funkce*}**(**{*parametry,oddělené,čárkami*}**)**

*# definovat uživatelskou funkci*<br>
**sub** {*identifikátor\_funkce*} [{*prototyp*}]<br>
**\{**<br>
<odsadit1>[{*příkazy*}]...<br>
**\}**

*# vrátit se z funkce a vrátit návratovou hodnotu*<br>
**return** {*návratová hodnota*}**;**

*# přiřadit do proměnné ukazatel na anonymní funkci*<br>
*// Analogicky můžete ukazatel na anonymní funkci předat jako parametr jiné funkci.*<br>
{*$proměnná*} **= sub \{**[{*příkazy*}]...**\};**

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

### Řízení toku

*# vyskočit za konec cyklu*<br>
**last** [{*návěští*}]**;**

*# skočit těsně před uzavírací závorku cyklu*<br>
**next** [{*návěští*}]**;**

*# skočit přímo za otevírací závorku cyklu*<br>
**redo** [{*návěští*}]**;**

*# skočit na návěští*<br>
**goto** {*návěští*}**;**

*# ukončit program*<br>
**exit(**[{*návratový-kód*}]**);**

*# ukončit program s hlášením kritické chyby*<br>
**die("**{*text*}**");**

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

*# rozdělit řetězec na pole (obecně/příklady)*<br>
[{*@pole*} **=**] **split(**{*oddělovač*}**,** {*dělený-řetězec*}[**,** {*maximální-počet-dílů*}]**)**<br>
**@pole = split(":", $s);**<br>
**@pole = split(/[:;]/, $s);**
<!--
Split podrobněji!
-->

*# spojit pole na řetězec*<br>
[{*$řetězec*} **=**] **join("**{*oddělovač (řetězec)*}**",** {*@pole*}**)**

*# má/nemá shodu s regulárním výrazem?*<br>
{*řetězec*} **=~ /**{*regulární výraz*}**/**[**i**]<nic>[**m**]<br>
{*řetězec*} **!~ /**{*regulární výraz*}**/**[**i**]<nic>[**m**]

*# najít pozici první shody s regulárním výrazem*<br>
?

*# provést náhradu pomocí regulárního výrazu (výsledek: přiřadit zpět/vrátit)*<br>
{*$proměnná*} **=~ s/**{*regulární výraz*}**/**{*náhrada*}**/**[**g**]<nic>[**i**]<nic>[**m**]<nic>[**s**]<br>
{*$řetězec*} **=~ s/**{*regulární výraz*}**/**{*náhrada*}**/r**[**g**]<nic>[**i**]<nic>[**m**]<nic>[**s**]

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

*# vrátit první ne-undef skalár*<br>
{*skalár*} [**//** {*další-skalár*}]...


### Skaláry: ukazatelé

*# je skalár ukazatel?/zjistit typ odkazovaného objektu*<br>
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
**use lib (((\_\_FILE\_\_ =~ s/^\[<nic>^\\/]\*$/.\\/x/r) =~ s/\\/\[<nic>^\\/]\*$//r));**
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
**close(**{*$f*}**)** [**or die(**{*zpráva*}**)**]**;**

*# otevřít textový soubor (normálně/se striktními kontrolami)*<br>
*// Mód je jeden z: „&lt;“: otevřít existující soubor pro čtení; „&gt;“: vytvořit nový/přepsat existující soubor a otevřít pro zápis; „&gt;&gt;“: otevřít pro zápis na konec souboru.*<br>
**open(**{*$f*} **= undef, "**{*mód*}**:utf8",** {*"cesta/k/souboru"*}**)** [**or die(**{*"chybová zpráva"*}**)**]**;**<br>
**open(**{*$f*} **= undef, "**{*mód*}**:encoding(UTF-8)",** {*"cesta/k/souboru"*}**)** [**or die(**{*"chybová zpráva"*}**)**]**;**

*# otevřít binární soubor*<br>
*// Mód je jeden z: „&lt;“: otevřít existující soubor pro čtení; „+&lt;“: otevřít existující soubor pro čtení i zápis; „&gt;“: vytvořit nový/přepsat existující soubor a otevřít jen pro zápis; „+&gt;“: totéž, ale pro zápis i čtení; „&gt;&gt;“: otevřít soubor pro zápis na konec.*<br>
**open(**{*$f*} **= undef, "**{*mód*}**:raw",** {*"cesta/k/souboru"*}**)** [**or die(**{*"chybová zpráva"*}**)**]**;**

*# otevřít rouru pro zápis*<br>
**open(**{*$f*} **= undef, "\|-", "**{*název-příkazu*}**"**[**,** {*parametr-příkazu*}]...**)** [**or die(**{*zpráva*}**)**]**;**

*# otevřít rouru pro čtení*<br>
**open(**{*$f*} **= undef, "-\|", "**{*název-příkazu*}**"**[**,** {*parametr-příkazu*}]...**)** [**or die(**{*zpráva*}**)**]**;**

### Číst (textový soubor)

*# načíst řádek bez ukončovače*<br>
*// Při čtení za koncem souboru se do proměnné $cíl uloží nehodnota undef.*<br>
{*$cíl*} **= readline(**{*$f*}**);**<br>
**chomp(**{*$cíl*}**) if (defined(**{*$cíl*}**))**

*# načíst jeden znak*<br>
*// Podle manuálu tato funkce není příliš efektivní. Doporučuji raději načíst řádku s ukončovačem a rozdělit po znacích. Při čtení za koncem souboru tato funkce vrací undef.*<br>
{*$cíl*} **= getc(**{*$f*}**);**

*# načíst všechny zbývající řádky bez ukončovače*<br>
{*@cíl*} **= array(readline(**{*$f*}**));**<br>
**chomp(**{*@cíl*}**);**

*# načíst všechny zbývající řádky s ukončovačem/zahodit*<br>
{*@cíl*} **= array(readline(**{*$f*}**));**<br>
**array(readline(**{*$f*}**));**

*# načíst celý soubor do řetězce*<br>
{*$cíl*} **= "";**<br>
**while (read(**{*$f*}**,** {*$cíl*}**, 4096, length(**{*$cíl*}**))) {}**

### Číst (binární soubor)

*# načíst pevný maximální počet bajtů*<br>
**read(**{*$f*}**,** {*$cíl*}**,** {*max-bajtů*}[**,** {*počáteční-index-do-cíle*}]**)**

*# načíst jeden bajt*<br>
{*$cíl*} **= getc(**{*$f*}**);**

*# načíst všechny zbývající bajty*<br>
{*$cíl*} **= "";**<br>
**while (read(**{*$f*}**,** {*$cíl*}**, 4096, length(**{*$cíl*}**))) {}**

*# konvertovat bajty z řetězce na pole číselných hodnot*<br>
{*@cíl*} **= unpack("C\*",** {*$řetězec*}**);**

### Zapisovat (textový soubor)

*# zapsat řetězec*<br>
**printf(**[{*$f*}**&blank;**]**"%s",** {*$řetězec*}**);**

*# zapsat znak (alternativy)*<br>
**printf(**[{*$f*}**&blank;**]**%s",** {*$znak*}**);**<br>
**{local $ORS = ""; print(**[{*$f*}**&blank;**]{*$znak*}**);}**

*# zapsat položky seznamu oddělené hodnotou $OFS a zakončené hodnotou $ORS*<br>
**print(**[{*$f*}**&blank;**]{*položky, seznamu*}**);**

### Zapisovat (binární soubor)

*# zapsat bajty (z řetězce/z pole čísel)*<br>
**printf(**[{*$f*}**&blank;**]**"%s",** {*$řetězec*}**);**<br>
?

*# zapsat bajt (znakově/z číselné hodnoty)*<br>
**printf(**[{*$f*}**&blank;**]**"%s",** {*$znak*}**);**<br>
**printf(**[{*$f*}**&blank;**]**"%c",** {*$číslo*}**);**


<!--

https://www.tutorialspoint.com/perl/perl_special_variables.htm
-> používat „use English;“!
-->


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
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
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
* Dokumentace Perlu radí upřednostňovat funkci „print“ před „printf“, protože je rychlejší a snáze se píše. To první je nejspíš pravda, ale pokud ji chcete použít korektně, musíte před každým voláním nastavit proměnné $OFS a $ORS, protože funkce „print“ je vypisuje, a budou-li nastaveny na nečekané hodnoty z jiné části programu, bude výstup vaší funkce nekorektní, pokud jejich hodnoty nebudete mít pod kontrolou. Napsat "%s" do printf je mnohem jednodušší než neustále přiřazovat $OFS a $ORS.

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

*# lkk perl – spouštěč, který spustí skript Perlu s doporučenými parametry*<br>
**#!/bin/bash**<br>
**exec perl -CSDAL "-Mv5.26.0" -Mstrict -Mwarnings -Mutf8 -MEnglish "$@"**

*# lkk -p perl-vzorek-parametru – xxx*<br>
**sub vzorek\_parametru \{**<br>
<odsadit1>**return join("", map \{**<br>
<odsadit2>**my $r;**<br>
<odsadit2>**!defined($ARG) ? "u" :**<br>
<odsadit2>**!($r = ref($ARG)) ? "s" :**<br>
<odsadit2>**$r =~ /^(SCALAR\|ARRAY\|HASH\|Regexp)$/ ? substr($r, 0, 1) :**<br>
<odsadit2>**":".$r.":";**<br>
<odsadit1>**\} @\_);**<br>
**\}**

*# lkk -p perl-alength – délka pole, resp. počet členů seznamu*<br>
**sub alength {return scalar(@ARG)}**
<!--
Poznámka: funkce alength je nutná kvůli tomu, že některé standardní funkce se při volání ve skalárním kontextu chovají jinak, takže funkci „scalar“ není možné použít pro zjištění velikosti vráceného pole.
Např. scalar(readline($f)) nevrátí počet načtených řádek souboru, ale alength(readline($f)) už ano.
-->

*# lkk -p perl-array – vrátí pole ze zadaných parametrů (lze využít k přetypování skaláru či asociativního pole)*<br>
**sub array {return @ARG}**

*# lkk -p perl-vypis – zavolá funkci „print“ s prázdnými hodnotami $OFS a $ORS*<br>
**sub vypis \{**<br>
<odsadit1>**local $OFS = "";**<br>
<odsadit1>**local $ORS = "";**<br>
<odsadit1>**return print(@ARG);**<br>
**\}**

*# lkk -p perl-fprintf – ...*<br>
**sub fprintf {my $soubor = shift(@ARG); return printf($soubor @ARG);}**

*# lkk -p perl-printn – ...*<br>
**sub printn {local $OFS = ""; local $ORS = ""; return print(@ARG);}**

*# lkk -p perl-fprintn – ...*<br>
**sub fprintn {local $OFS = ""; local $ORS = ""; my $soubor = shift(@ARG); return print($soubor @ARG);}**
