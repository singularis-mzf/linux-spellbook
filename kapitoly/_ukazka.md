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

## Úvod
Tato kapitola je jen ukázka dovoleného formátování. Je zatím poměrně omezené.
Běžné odstavce mohou pokračovat na dalším řádku.
Mohou také obsahovat vynucený<br>konec řádku a omezené formátování:
**tučně**, *kurzívou*, nebo {*doplň*}, do **tučného textu lze vnořit *kurzívu*,**
a do *kurzívy lze vnořit **tučný text**,* ale „doplň“ s nimi nelze kombinovat.
Dovolený je i [hypertextový odkaz](http://www.seznam.cz/).

* Takto vypadají seznamy.
Položka seznamu může pokračovat na dalším řádku a obsahovat text **tučně**, *kurzívou*, nebo {*na doplnění*}.
* Další položka seznamu. Může obsahovat také [hypertextový odkaz](http://www.seznam.cz/) a vynucený<br>konec řádku.

### Příklady

*# zvláštním typem záznamu je takzvaný příklad*<br>
*// může mít poznámku pod čarou, která vypadá takto*<br>
**tučné části v řádcích příkladu má uživatel zadat tak, jak jsou** {*toto-má-doplnit*} [**nepovinná část**]...<br>
**příklad může mít i víc řádků**

*# druhý příklad, který...*<br>
*// má dvě poznámky pod čarou, z toho první je velmi velmi dlouhá, aby se ukázalo, jak se bude v okně prohlížeče, na papíře nebo v jiném výstupním formátu zalamovat do více řádků; pro tento účel by se hodil text Lorem Ipsum, ale tento text je také dost dobrý*<br>
*// a toto je ta druhá*<br>
{*doplnit*} **a musí mít i nějaký řádek**

*# třetí příklad má:*<br>
*// jednu*<br>
*// druhou*<br>
*// třetí poznámku pod čarou*<br>
**<tab>řádek začínající tabulátorem**<br>
**<tab8><tab8>a řádek začínající dvěma tabulátory**<br>
!: Akce (tzn. popis, co udělat − musí být na jednom řádku).<br>
**&blank;řádek odsazený jednou mezerou**<br>
**&blank;&blank;..dvěma mezerami**<br>
**&nbsp;řádek odsazený jednou nezlomitelnou mezerou**<br>
**&nbsp;&nbsp;řádek odsazený dvěma nezlomitelnými mezerami**
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
*pro samostatné ukázky kódu je také podporován příklad bez záhlaví*<br>
*takový příklad nemůže mít poznámky pod čarou*

## Obrázky

Obrázky je dovoleno vkládat pouze jako samostatné odstavce:

![alternativní text](../obrazky/ve-vystavbe.png)

## Zvláštní znaky a jejich escapování

„Escapování“ znamená zapsání speciálního znaku za dodatečné zpětné lomítko
(nebo jiným alternativním způsobem). Jeho účelem je zbavit znak nechtěného
speciální významu a nechat ho vypsat do výstupního formátu jako obyčejný znak.
Pravidla escapování ve zdrojových kódech tohoto projektu jsou následující:

* (&lt;), (&amp;), (&gt;)<br>se zadávají vždy jako odpovídající entity.
* (\\), (\`), (\*), (\_)<br>se ve zdrojovém kódu escapují zpětným lomítkem vždy.
* (\#), ($), (+), (-), (:), ([), (|), (~)<br>se escapují před prvním alfanumerickým znakem na řádku nebo jsou-li zdvojeny. Příklad: \\#\\#, \\$\\$, \\+\\+, \\-\\-, \\:\\:, \\[\\[, \\|\\|, \\~\\~.
* (!)<br>se escapuje, má-li za ním stát „[“.
* (])<br>se escapuje, je-li zdvojena nebo má-li za ní stát „(“ nebo „[“.
* ({), (})<br>se escapují, jen utvořily-li by nechtěnou formátovací sekvenci „\{\*“ či „\*\}“. Příklad: \\\{\*text kurzívou\*\\}
* ())<br>se escapuje jen uvnitř adresy hypertextového odkazu. Příklad: [X\](http:⫽pism.cz/Pismeno\\\_(X\\))
* (.)<br>se escapuje za sekvencí desítkových číslic, které na řádce zdrojového kódu nepředchází žádné bílé nebílé znaky, a to jen v případě, že za danou tečkou následuje mezera.
* ("), (%), ('), ((), (,), (/), (;), (=), (?), (@), (^)<br>se neescapují nikdy.
* Nezlomitelnou mezeru lze zadat jak přímo, tak odpovídající entitou &amp;nbsp;.

Potřebujete-li zapsat URL adresu, která nemá být nikde (ani na GitHubu) formátována jako odkaz,
nahraďte v ní // speciálním znakem \⫽ (UCS operátor U+2AFD). Do výstupních formátů bude tento
znak přeložen na obyčejnou sekvenci //.

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
* „n-dash“ (−), „times“ (×), „degree“ (°)
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
