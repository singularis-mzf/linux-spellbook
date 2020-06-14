<!--

Linux Kniha kouzel, kapitola Základy Perlu
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

[ ] Naprogramovat funkci, která vrátí pole všech shod regulárního výrazu.

[ ] Zpracovat tutorial začínající na: https://www.perltutorial.org/perl-syntax/
[ ] Zpracovat referenční příručku funkcí:
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

Perl je zákeřný skriptovací jazyk, v němž se proměnné deklarují
nejčastěji klíčovým slovem „my“, modul Perlu musí končit příkazem „1;“,
podmínka „if (false)“ je splněna (ačkoliv generuje varování)
a příkaz náhrady „s/.$/&amp;/g“ provedený nad řetězcem "X\\n\\n\\n" nikdy
neskončí výsledkem "X\\n\\n&amp;" jako v *sedu* (kde je nutno ampresand odzvláštnit),
ale výsledkem "X\\n\\n\\n", popř. pokud přidáte ještě modifikátor „s“,
výsledkem "X\\n&amp;&amp;"; ke stejnému chování jako v sedu ho však nedonutíte.

Úspěšné použití takového jazyka vyžaduje buď hlubokou znalost,
nebo se omezit na úzkou, konzervativně zvolenou podmnožinu jeho
funkcionality. Tato kapitola volí druhou uvedenou cestu, a navíc nabízí modul
s pomocnými funkcemi, které vám pomohou některé svévolné a zákeřné pasti Perlu překonat.
Budete-li v Perlu programovat delší dobu, pravděpodobně se je časem naučíte
znát a podaří se vám zvýšit svoji efektivitu využitím ezoterických syntaktických zkratek.
Do té doby vám tato kapitola pomůže se pastem vyhýbat, a přesto z moci Perlu
vytěžit co nejvíc.

## Definice

Perl rozeznává tři základní datové typy (existují i další):

* **Skalár**, což je dynamicky typovaná proměnná, která může obsahovat řetězec, číslo, ukazatel na nějaký objekt nebo zvláštní **nehodnotu undef**, která je výchozí hodnotou skalárů (a lze ji také považovat za „ukazatel nikam“). Přístup ke skaláru se značí znakem „$“. (Poznámka: v Perlu mohou existovat i skaláry, které mají nesouvisející číselnou a řetězcovou hodnotu, např. mají řetězcovou hodnotu "Hello" a číselnou hodnotu 13. Doufejte však, že na takové zrůdnosti při svém programování nenarazíte.)
* **Pole**, což je uspořádaný kontejner skalárů indexovaný celými čísly 0, 1, 2 atd. Přístup k poli se značí znakem „@“ a pole se indexuje hranatými závorkami „[]“. Výchozí hodnotou objektu typu pole je prázdné pole.
* **Asociativní pole** (hash), což je neuspořádaný kontejner skalárů (**hodnot**) indexovaný jinými skaláry (**klíči**). Přístup k asociativnímu poli se značí znakem „%“ a tato pole se indexují složenými závorkami „{}“. Výchozí hodnotou je prázdné asociativní pole. Asociativní pole se inicializují poli či seznamy se sudým počtem prvků (lichý počtu prvků generuje varování), kde se první prvek interpretuje jako klíč, druhý jako odpovídající hodnota, třetí jako klíč a tak dále.

Proměnné každého z těchto typů mají svůj vlastní jmenný prostor, takže je v pořádku mít vedle sebe např. pole „@x“ a asociativní pole „%x“.

* **Ukazatel** (reference, v češtině obvykle nazývaný „odkaz“) je skalár, který odkazuje na nějaký objekt v paměti (pole, funkci, regulární výraz apod.). **Dereferencí** ukazatele můžeme získat přístup k odkazovanému objektu pro čtení i přiřazení. Tím se ukazatel liší od skutečného **odkazu**, který poskytuje přístup k odkazovanému objektu bez dereference – přiřazení odkazu je přímo přiřazením odkazovanému objektu, zatímco ukazatel musíme nejprve dereferencovat.
* **Seznam** je dočasný objekt příbuzný poli; zadává se výčtem prvků v kulatých závorkách, např. „(1, 2, 3)“ nebo „($a, $b, $c)“. Seznam a pole se liší pouze několika drobnostmi: Pole je nositelem hodnot svých prvků, takže přiřazením do prvku pole se přiřadí pouze tomuto prvku a nikam jinam; oproti tomu seznam je nositelem odkazů na svoje prvky, takže když přiřadíte „($a, $b, $c) = (1, 2, 3)“, přiřadíte tím hodnoty z druhého seznamu odkazovaným proměnným, ne prvkům seznamu. Pole má proměnný počet prvků, lze do něj prvky vkládat či je vyjímat; seznam má oproti tomu pevný počet prvků, který se určuje znovu při každém vyhodnocení výrazu, v němž se seznam nachází.
* Důležitou vlastností seznamů je **zplošťování** — pokaždé, když v seznamu uvedete vnořený seznam, rozvine se na všechny prvky v odpovídajícím pořadí, jako byste je uvedli přímo. Totéž platí pokud v seznamu uvedete pole (rozvine se na posloupnost odkazů na své prvky) nebo asociativní pole (rozvine se na posloupnost dvojic prvků klíč, odkaz na odpovídající hodnotu, klíč, odkaz na odpovídající hodnotu a tak dále). Pokud potřebujete do seznamu vložit pole či asociativní pole jako takové, vložte ukazatel na něj.

!ÚzkýRežim: vyp

## Zaklínadla

### Skaláry
<!--
Sem nepatří zaklínadla specifická pro jednotlivé typy skalárů (čísla, řetězce, ukazatele); výjimkou jsou zaklínadla pro nehodnotu undef, ta sem patří.
-->

*# deklarovat skalární proměnnou viditelnou v bloku*<br>
**my $**{*identifikátor*} [**=** {*hodnota*}]**;**

*# přečíst proměnnou/**přiřadit** do proměnné*<br>
**$**{*identifikátor*}<br>
**$**{*identifikátor*} **=** {*hodnota*}

*# má skalár hodnotu? (tzn. není undef)*<br>
**defined(**{*$skalár*}**)**

*# přiřadit proměnné nehodnotu **undef***<br>
**$**{*identifikátor*} **= undef**

*# zjistit typ skaláru*<br>
**typy(**{*$skalár*}**)**

*# získat ukazatel na regulární výraz (obecně/příklad)*<br>
**qr/**{*regulární výraz*}**/**<br>
**qr/^ab\\.c/**

*# deklarovat skalární proměnnou viditelnou i z jiných modulů*<br>
**our $**{*identifikátor*} [**=** {*hodnota*}]**;**

### Pole a seznamy (literály)

*# **seznam***<br>
*// Prvky seznamu mohou být skaláry (každý utvoří jeden prvek seznamu) nebo pole a vnořené seznamy (každé pole a vnořený seznam se za běhu rozloží na všechny svoje prvky v náležitém pořadí). Tip: skalárem v seznamu může být i nehodnota undef.*<br>
**(**[{*prvek seznamu*}[**,** {*další prvek seznamu*}]...]**)**<br>

*# seznam **ze slov** (alternativy)*<br>
*// Slovo je každá neprázdná posloupnost nebílých znaků oddělená od ostatních slov alespoň jedním bílým znakem (což může být i tabulátor či konec řádky). Uvnitř operátoru qw má zvláštní význam pouze odpovídající uzavírací závorka; odzvláštnění není možné, i zpětné lomítko se zde považuje za obyčejný znak.*<br>
**qw(**{*slova*}**)**<br>
**qw\{**{*slova*}**\}**

*# anonymní **pole** (vrací ukazatel!)*<br>
*// Pozor, seznam s hranatými závorkami vrací ukazatel na vytvořené pole a ten se ukládá do skaláru, ne do pole! Pro inicializaci proměnné typu pole použijte seznam s kulatými závorkami.*<br>
**[**[{*prvek seznamu*}[**,** {*další prvek seznamu*}]...]**]**<br>

*# zopakovat seznam (obecně/příklad)*<br>
{*seznam*} **x** {*počet*}<br>
**("a", undef) x 2** ⊨ ("a", undef, "a", undef)

*# zopakovat obsah pole (obecně/příklad)*<br>
**(**{*@pole*}**) x** {*počet*}<br>
**(@test) x 5**

*# seznam celých čísel v daném rozsahu (obecně/příklady)*<br>
**(**{*celé-číslo*}**..**{*celé-číslo*}**)**<br><br>
**(-1..4)** ⊨ (-1, 0, 1, 2, 3, 4)<br>
**(2..5, -3..-1)** ⊨ (2, 3, 4, 5, -3, -2, -1)

*# seznam znaků UCS v daném kódovém rozsahu*<br>
?

*# seznam prvků pole podle indexů z jiného pole*<br>
?
<!--
### Pole (operace)
-->


### Asociativní pole

*# literál asociativního pole (jako hodnotu/jako ukazatel na asociativní pole)*<br>
**(**[{*klíč*}**,** {*hodnota*}[**,** {*další klíč*}**,** {*další hodnota*}]...]**)**<br>
**\{**[{*klíč*}**,** {*hodnota*}[**,** {*další klíč*}**,** {*další hodnota*}]...]**\}**

*# **smazat** prvek/všechny prvky*<br>
**delete $**{*id\_pole*}**\{**{*klíč*}**\};**<br>
{*%pole*} **= ();**
<!--
Problém: co když pracuji s referencí?
-->

*# **obsahuje** prvek?*<br>
**exists($**{*id\_pole*}**\{**{*klíč*}**\})**

*# **přidat** či přepsat prvek*<br>
**$**{*id\_pole*}**{"**{*klíč*}**"} =** {*hodnota*}

*# získat pole klíčů/hodnot*<br>
**keys(**{*%pole*}**)**<br>
**values(**{*%pole*}**)**

*# získat počet dvojic v asociativním poli*<br>
**alength(keys(**{*%pole*}**))**


### Funkce

*# zavolat uživatelskou funkci*<br>
{*identifikátor\_funkce*}**(**{*parametry,oddělené,čárkami*}**)**

*# zavolat uživatelskou funkci přijímající blok příkazů*<br>
*// Ačkoliv Perl dovoluje zapsat volání s blokem příkazů na jednu řádku, pro přehlednost této už tak dost odpudivé syntaxe vždy oddělujte příkazy bloku od volání funkce a používejte náležité odsazení, i když bude příkaz jen jeden a velmi jednoduchý, jako třeba „$ARG &gt;= 0“. Návratovou hodnotou předaného bloku bude hodnota posledního provedeného příkazu.*<br>
**(**{*identifikátor\_funkce*} **\{**<br>
<odsadit1>{*příkaz bloku;*}...<br>
**\}** [{*parametry, funkce*}]...**)**

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

*# definovat uživatelskou funkci přijímající blok příkazů*<br>
*// Předaný blok zavoláte jako funkci příkazem „$název-&gt;()“, kde název je zvolený identifikátor proměnné.*<br>
^**sub** {*identifikátor\_funkce*} **(&amp;@);**<br>
**sub** {*identifikátor\_funkce*} **(&amp;@)**<br>
**\{**<br>
<odsadit1>**my $**{*název*} **= shift(@ARG);**<br>
<odsadit1>[{*příkazy*}]...<br>
**\}**

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

### Ostatní

*# získat hodnotu proměnné prostředí (obecně/příklad)*<br>
**$ENV\{"**{*názevproměnné*}**\}**<br>
**$ENV{"PATH"}**

*# přiřadit hodnotu proměnné prostředí*<br>
**$ENV\{"**{*názevproměnné*}**\} =** {*hodnota*}

## Zaklínadla (pole)

<!--
https://metacpan.org/pod/List::MoreUtils
-->

### Základní operace

*# **přečíst** hodnotu prvku pole*<br>
**$**{*identifikátor\_pole*}**[**{*index*}**]**

*# **přiřadit** hodnotu prvku pole*<br>
**$**{*identifikátor\_pole*}**[**{*index*}**] =** {*skalární hodnota*}

*# deklarovat proměnnou typu pole (obecně/příklady)*<br>
**my @**{*identifikátor\_pole*} [**=** {*seznam*}]**;**<br>
**my @pole = qw(5 6 7);**<br>
**my @pole = ("a", "bc", "d");**

*# rozložit pole do nových skalárních proměnných*<br>
*// Přebytečné prvky pole se zahazují. Přebytečné proměnné se vyplní nehodnotou undef.*<br>
**my ($**{*id*}[**,** {*další\_id*}]...**) =** {*@pole*}**;**

*# přiřadit celé pole (alternativy)*<br>
**@**{*cílové\_pole*} **= @**{*zdrojové\_pole*}<br>
**@**{*cílové\_pole*} **=** {*(seznam)*}

### Přístup k prvkům

*# podle indexu*<br>
**$**{*identifikátor\_pole*}**[**{*index*}**]**

*# první/poslední prvek*<br>
**$**{*identifikátor\_pole*}**[0]**<br>
**$**{*identifikátor\_pole*}**[-1]**

### Analýza pole (logické testy)

*# **existuje** prvek pole?*<br>
{*index*} **&lt; alength(**{*@pole*}**) &amp;&amp;** {*index*} **&gt;= 0**

*# **existuje** prvek splňující podmínku?*<br>
^**use List\:\:MoreUtils;**<br>
**(any \{**<br>
<odsadit1>{*podmínka;*}<br>
**\}** {*@pole*}**)**

*# platí podmínka pro **všechny** prvky?*<br>
^**use List\:\:MoreUtils;**<br>
**(all \{**<br>
<odsadit1>{*podmínka;*}<br>
**\}** {*@pole*}**)**

*# platí podmínka právě pro **jeden** z prvků?*<br>
^**use List\:\:MoreUtils;**<br>
**(one \{**<br>
<odsadit1>{*podmínka;*}<br>
**\}** {*@pole*}**)**


### Velikost pole

*# zjistit **počet prvků** pole*<br>
**alength(**{*@pole*}**)**

*# je pole **prázdné**?*<br>
?

### Průchod a zpracování pole

*# transformovat po prvcích*<br>
*// Operátor „map“ funguje přesně jako cyklus „foreach (@pole)“ (tzn. v uvedeném bloku je $ARG odkaz na právě zpracovávaný prvek pole), až na to, že jeho návratovou hodnotou je seznam hodnot posledního provedeného příkazu bloku v každém cyklu. Protože je $ARG odkaz, můžete ho využít k modifikaci prvků původního pole.*<br>
**(map \{**<br>
<odsadit1>{*příkaz*}...<br>
**\}** {*@pole*}**)**

*# vybrat prvky*<br>
*// Výsledkem je seznam prvků, pro které se poslední příkaz v bloku vyhodnotí jako logická pravda.*<br>
**(grep \{**<br>
<odsadit1>{*příkaz*}...<br>
**\}** {*@pole*}**)**

*# zpracovat po dvojicích*<br>
?

*# zpracovat po N-ticích*<br>
^**use List\:\:MoreUtils;**<br>
**foreach (natatime(**{*N*}**,** {*prvky, seznamu*}...**)) \{**<br>
<odsadit1>**my @**{*pole*} **= $ARG-&gt;();**<br>
<odsadit1>{*příkaz;*}...<br>
**\}**

### Filtrování

*# vynechat prvky, které se již vyskytly*<br>
*// Funkce provádí řetězcové porovnání prvků, ne číselné. Zachovává pořadí prvků.*<br>
^**use List\:\:MoreUtils;**<br>
**distinct(**{*prvky*}...**)**

*# vybrat prvky, které se vyskytují právě jednou*<br>
^**use List\:\:MoreUtils;**<br>
**singleton(**{*prvky*}...**)**


### Vyhledávání

<!--
*# najít první prvek vyhovující podmínce (hodnotu/index)*<br>
^**use List\:\:MoreUtils;**<br>
-->

### Transformace


### Vkládání/vyjímání prvků

*# **vložit** prvek na začátek pole/konec pole/určitý index*<br>
**unshift(**{*@pole*}**,** {*skalár*}**);**<br>
**push(**{*@pole*}**,** {*skalár*}**);**<br>
**splice(**{*@pole*}**,** {*index*}**, 0,** {*skalár*}**);**

*# **vyjmout** první/poslední/určitý prvek pole*<br>
*// Obě uvedené funkce vracejí vyjmutý prvek.*<br>
**shift(**{*@pole*}**)**<br>
**pop(**{*@pole*}**)**<br>
**splice(**{*@pole*}**,** {*index*}**, 1);**

*# **smazat** všechny prvky/úsek*<br>
{*@pole*} **= ();**<br>
**splice(**{*@pole*}**,** {*první-smaz-index*}**,** {*počet-ke-smazání*}**);**






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

## Pomocné funkce a skripty (Perl)

*# lkk perl – spouštěč, který spustí skript Perlu s doporučenými parametry*<br>
**#!/bin/bash**<br>
**exec perl -CSDAL -Mv5.26.0 -Mstrict -Mwarnings -Mutf8 -MEnglish "$@"**

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
