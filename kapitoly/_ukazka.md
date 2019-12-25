<!--

Linux Kniha kouzel, kapitola Ukázka
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Ukázka

!Štítky: {ostatní}{ukázka}

## Úvod
Tato kapitola je jen ukázka dovoleného formátování. Je zatím poměrně omezené.
Běžné odstavce mohou pokračovat na dalším řádku.
Mohou také obsahovat vynucený<br>konec řádku a omezené formátování:
**tučně**, *kurzívou*, {*doplň*} nebo {_Klávesa_}, do **tučného textu lze vnořit *kurzívu*,**
a do *kurzívy lze vnořit **tučný text**,* ale „doplň“ s nimi nelze kombinovat.
Dovolený je i [hypertextový odkaz](http://www.seznam.cz/).

Normálně se odstavce v PDF verzi odsazují, kromě odstavců, které následují po nadpisu.

<neodsadit>Značkou &lt;neodsadit&gt; ale toto odsazení můžete pro konkrétní odstavec vypnout.

Mezi normálními odstavci může být:

> Odsazený odstavec. Text odsazeného odstavce může ve zdrojovém kódu
> pokračovat na dalším řádku. Je dovolena pouze jedna úroveň odsazení
> a může obsahovat<br>konec řádku a omezené formátování:
> **tučně**, *kurzívou*, nebo {*doplň*}, do **tučného textu lze vnořit *kurzívu*,**
> a do *kurzívy lze vnořit **tučný text**,* ale „doplň“ s nimi nelze kombinovat.
> Dovolený je i [hypertextový odkaz](http://www.seznam.cz/).

> Toto je další odsazený odstavec,
> následující po tom prvním.

>> Odstavec může být odsazený o dvě úrovně. V každém případě se odsazuje
>> současně zleva i zprava.

>>> Nebo o tři úrovně.

>>>> Nebo o čtyři úrovně.

>>>>> Nebo o pět úrovní.

>>>>>> Maximum je šest úrovní. Do takového odstavce se už skoro nic nevejde.

A toto už je obyčejný odstavec.

* Takto vypadají seznamy.
Položka seznamu může pokračovat na dalším řádku a obsahovat text **tučně**, *kurzívou*, nebo {*na doplnění*}.
* Další položka seznamu. Může obsahovat také [hypertextový odkaz](http://www.seznam.cz/) a vynucený<br>konec řádku.

### Zaklínadlo

*# zvláštním typem záznamu je takzvané zaklínadlo; to může obsahovat tučně zvýrazněná **klíčová slova**, a to i **na konci***<br>
*// může mít poznámku pod čarou, která vypadá takto*<br>
**tučné části v řádcích zaklínadla má uživatel zadat tak, jak jsou** {*toto-má-doplnit*} [**nepovinná část**] {_Klávesa_}...<br>
**příklad může mít i víc řádků**

*# druhé zaklínadlo, které...*<br>
*// má dvě poznámky pod čarou, z toho první je velmi velmi dlouhá, aby se ukázalo, jak se bude v okně prohlížeče, na papíře nebo v jiném výstupním formátu zalamovat do více řádků; pro tento účel by se hodil text Lorem Ipsum, ale tento text je také dost dobrý*<br>
*// a toto je ta druhá*<br>
{*doplnit*} **a musí mít i nějaký řádek**

*# třetí zaklínadlo má řádky patřící do preambule:*<br>
^^**#include &lt;stdio.h&gt;**<br>
^^**tento tam patří také (kdo by to řekl?)**<br>
**a tento už ne**

*# čtvrté zaklínadlo má:*<br>
*// jednu*<br>
*// druhou*<br>
*// třetí poznámku pod čarou*<br>
**<tab>řádek začínající tabulátorem**<br>
**<tab8><tab8>a řádek začínající dvěma tabulátory**<br>
!: Akce (tzn. popis, co udělat − musí být na jednom řádku).<br>
**&blank;řádek odsazený jednou mezerou**<br>
**&blank;&blank;..dvěma mezerami**<br>
**&nbsp;řádek odsazený jednou nezlomitelnou mezerou**<br>
**&nbsp;&nbsp;řádek odsazený dvěma nezlomitelnými mezerami**<br>
**neinterpretovaný netučný nebílý znak v řádku zaklínadla je chybný jako tato tečka:** .<br>
<odsadit1>**řádek odsazený o 1 úroveň**<br>
<odsadit2>**řádek odsazený o 2 úrovně**<br>
<odsadit3>**řádek odsazený o 3 úrovně**<br>
<odsadit4>**řádek odsazený o 4 úrovně**<br>
<odsadit5>**řádek odsazený o 5 úrovní**<br>
<odsadit6>**řádek odsazený o 6 úrovní**<br>
<odsadit7>**řádek odsazený o 7 úrovní**<br>
<odsadit8>**řádek odsazený o 8 úrovní (což je maximum)**
<!--
Poznámka: ve Firefoxu se nezlomitelné mezery zkopírují do schránky jako obyčejné mezery.
-->

*# různé šířky tabulátoru*<br>
**<tab8>8**<br>
**0<tab7>7**<br>
**01<tab6>6**<br>
**012<tab5>5**<br>
**0123<tab4>4**<br>
**01234<tab3>3**<br>
**012345<tab2>2**<br>
**0123456<tab1>1**<br>
**012345670**

*# *<br>
**pro samostatné ukázky kódu je také podporován příklad bez záhlaví**<br>
**takový příklad nemůže mít poznámky pod čarou,**<br>
^^**ale může mít řádky určené do záhlaví**<br>
!: A také může obsahovat akce.


## Obrázky

Obrázky je dovoleno vkládat pouze jako samostatné odstavce:

![alternativní text](../obrazky/ve-vystavbe.png)

## Parametry příkazů

Pro parametry příkazů existuje zvláštní režim zapnutý metapříkazem:

!parametry:

* -a :: Krátký parametr bez hodnoty. V těchto textech lze použít formátování: **tučně**, *kurzívou*, {*doplň*}.
* -b {*hodnota*} :: Krátký parametr s hodnotou.
* --dlouhy :: Dlouhý parametr bez hodnoty.
* --dlouhy {*hodnota*} :: Dlouhý parametr s hodnotou.

Každý řádek tohoto zvláštního režimu musí obsahovat oddělovač \:\: a před tímto oddělovačem nemusí být escapován znak -, a to ani když se opakuje.

## Zvláštní znaky a jejich escapování

„Escapování“ znamená zapsání speciálního znaku za dodatečné zpětné lomítko
(nebo jiným alternativním způsobem). Jeho účelem je zbavit znak nechtěného
speciálního významu a nechat ho vypsat do výstupního formátu jako obyčejný znak.
Pravidla escapování ve zdrojových kódech tohoto projektu jsou následující:

* (&lt;), (&amp;), (&gt;)<br>se zadávají vždy jako odpovídající entity &amp;lt;, &amp;amp; a &amp;gt;.
* (\\), (\`), (\*), (\_)<br>se ve zdrojovém kódu escapují zpětným lomítkem vždy.
* (\#), ($), (+), (-), (:), ([), (|), (~)<br>se escapují před prvním alfanumerickým znakem na řádku nebo jsou-li zdvojeny. Příklad: \\#\\#, \\$\\$, \\+\\+, \\-\\-, \\:\\:, \\[\\[, \\|\\|, \\~\\~.
* (!)<br>se escapuje, má-li za ním stát „[“.
* (])<br>se escapuje, je-li zdvojena nebo má-li za ní stát „(“ nebo „[“.
* ({), (})<br>se escapují, jen utvořily-li by nechtěnou formátovací sekvenci „\{\*“ či „\*\}“. Příklad: \\\{\*text kurzívou\*\\}
* ())<br>se escapuje jen uvnitř adresy hypertextového odkazu. Příklad: [X\](http:⫽pism.cz/Pismeno\\\_(X\\))
* (.)<br>se escapuje za sekvencí desítkových číslic, které na řádce zdrojového kódu nepředchází žádné nebílé znaky, a to jen v případě, že za danou tečkou následuje mezera.
* ("), (%), ('), ((), (,), (/), (;), (=), (?), (@), (^)<br>se neescapují nikdy.
* Nezlomitelnou mezeru lze zadat jak přímo, tak odpovídající entitou &amp;nbsp;.

Potřebujete-li zapsat URL adresu, která nemá být nikde (ani na GitHubu) formátována jako odkaz,
nahraďte v ní // speciálním znakem \⫽ (UCS operátor U+2AFD). Do výstupních formátů bude tento
znak přeložen na obyčejnou sekvenci //, a to i v URL adresách.

<!--
Unicode Character 'DOUBLE SOLIDUS OPERATOR' (U+2AFD)
https://www.fileformat.info/info/unicode/char/2afd/index.htm
-->

## Podporované znaky

Všechny tisknutelné znaky ASCII jsou podporovány a uvedeny v následujícím výčtu. Není podporován tabulátor
(ve zdrojovém kódu je třeba jej zadat jednou ze značek &lt;tab1&gt; až &lt;tab8&gt;) a konec řádku má takový význam jako v HTML.
(Explicitní konec řádku se zadává značkou &lt;br&gt;.)

* mezera ( ) (ASCII 0x20) a zvýrazněná mezera &amp;blank; (&blank;, lze zadat i přímo znakem:␣; lze zadat i opakovaně:␣␣␣␣)
* (!), ("), (\#), (\$), (%), (&amp;), ('), ((), ()), (\*), (\+), (,), (\-), (.), (/) (ASCII 0x21 až 0x2f)
* (0), (1), (2), (3), (4), (5), (6), (7), (8), (9) (ASCII 0x30 až 0x39)
* (\:), (;), (&lt;), (=), (&gt;), (?), (@) (ASCII 0x3a až 0x40)
* (A), (B), (C), (D), (E), F), (G), (H), (I), (J), (K), (L), (M), (N), (O), (P), (Q), (R), (S), (T), (U), (V), (W), (X), (Y), (Z) (ASCII 0x41 až 0x5a)
* ([), (\\), (]), (^), (\_), (\`) (ASCII 0x5b až 0x60)
* (a), (b), (c), (d), (e), (f), (g), (h), (i), (j), (k), (l), (m), (n), (o), (p), (q), (r), (s), (t), (u), (v), (w), (x), (y), (z) (ASCII 0x61 až 0x7a)
* ({), (|), (}), (~) (ASCII 0x7b až 0x7e)
* (á), (č), (ď), (é), (ě), (í), (ň), (ó), (ř), (š), (ť), (ú), (ů), (ý), (ž); příklad: „žluťoučký kůň příšerně úpěl ďábelské ódy“
* (Á), (Č), (Ď), (É), (Ě), (Í), (Ň), (Ó), (Ř), (Š), (Ť), (Ú), (Ů), (Ý), (Ž); příklad: „ŽLUŤOUČKÝ KŮŇ PŘÍŠERNĚ ÚPĚL ĎÁBELSKÉ ÓDY“
* „m-dash“ (—), „n-dash“ (−), „times“ (×), „degree“ (°), „menší nebo rovno“ (≤), „větší nebo rovno“ (≥)
* „neaktivní přepínač“ (○), „aktivní přepínač“ (◉), „nezaškrtnuté políčko“ (☐), „zatržené políčko“ (☑), „škrtnuté políčko“ (☒)
* „nezlomitelná mezera“ (&nbsp;)
* „české uvozovky“ („) a (“)

## Podporované HTML entity

* &amp;amp; (&amp;)
* &amp;apo; (&apo;) (Lze zadat i přímo: „'“)
* &amp;blank; (&blank;)
* &amp;gt; (&gt;)
* &amp;lt; (&lt;)
* &amp;nbsp; (&nbsp;) (Lze zadat i přímo: „ “.)
* &amp;quot; (&quot;) (Lze zadat i přímo: „"“.)
