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
a do *kurzívy lze vnořit **tučný text**,* ale doplň s nimi nelze kombinovat.
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

## Zvláštní znaky

Lze zadat nejrůznější zvláštní znaky.

* Znaky &lt;, &amp; a &gt; vždy nahraďte odpovídajícími entitami &amp;lt;, &amp;amp; a &amp;gt;.
* Znaky \\, \`, \*, \_, \^ a \~ vždy escapujte zpětným lomítkem.
* Znaky #, $, +, -, : a | escapujte zpětným lomítkem, jsou-li zdvojeny nebo před prvním alfanumerickým znakem na řádku. \#\#, \+\+, \-\-, \$\$, \:\:, \|\|.
* Znaky !, ", %, ', (, ), ,, /, ;, =, ? a @ zadávejte přímo, bez escapování, a to i v případě, že jsou zdvojeny: !!, "", %%, '', ((, )), ,,, //, ;;, ==, ??, @@.
* Znak [ escapujte zpětným lomítkem, pokud je to první tisknutý (tzn. ne-řidící) znak na řádku. V ostatních případech ho zadávejte přímo, a to i v případě, že je zdvojený. [[
* Znak ] escapujte zpětným lomítkem, pokud bezprostředně za ním ve zdrojovém kódu následuje znak „(“ nebo „[“. \]( \][
* Znak { escapujte zpětným lomítkem, pokud bezprostředně za ním ve zdrojovém kódu následuje neescapovaná \*. (\{*kurzívou*)
* Znak . escapujte zpětným lomítkem pouze za sekvencí desítkových číslic, které na řádku nepředchází žádné nebílé znaky, a to pouze v případě, že za danou tečkou následuje mezera. (Jinak by totiž tato sekvence utvořila číslovaný seznam.) V ostatních případech zadávejte tečku přímo, a to i tehdy, je-li zdvojená: ..
* Potřebujete-li zapsat URL adresu, která nemá být formátována jako odkaz, nahraďte v ní // speciálním znakem \⫽. Při jiném použití (což je nepravděpodobné) musíte tento znak rovněž escapovat zpětným lomítkem.
* Nezlomitelnou mezeru můžete zadat buď přímo, nebo jako entitu &amp;nbsp;.

## Podporované znaky

* mezera ( ) (ASCII 0x20) a zvýrazněná mezera &amp;blank; (&blank;, lze zadat i přímo znakem:␣; lze zadat i opakovaně:␣␣␣␣)
* ! (ASCII 0x21)
* " (ASCII 0x22)
* \# (ASCII 0x23)
* \$ (ASCII 0x24)
* % (ASCII 0x25)
* &amp; (ASCII 0x26)
* ' (ASCII 0x27)
* ( (ASCII 0x28)
* ) (ASCII 0x29)
* \* (ASCII 0x2a)
* \+ (ASCII 0x2b)
* , (ASCII 0x2c)
* \- (ASCII 0x2d)
* . (ASCII 0x2e)
* / (ASCII 0x2f)
* 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 (ASCII 0x30 až 0x39)
* \: (ASCII 0x3a)
* ; (ASCII 0x3b)
* &lt; (ASCII 0x3c)
* = (ASCII 0x3d)
* &gt; (ASCII 0x3e)
* ? (ASCII 0x3f)
* @ (ASCII 0x40)
* A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z (ASCII 0x41 až 0x5a)
* [ (ASCII 0x5b)
* \\ (ASCII 0x5c)
* ] (ASCII 0x5d)
* \^ (ASCII 0x5e)
* \_ (ASCII 0x5f)
* \` (ASCII 0x60)
* a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z (ASCII 0x61 až 0x7a)
* { (ASCII 0x7b)
* \| (ASCII 0x7c)
* } (ASCII 0x7d)
* ~ (ASCII 0x7e)
* á, Á
* č, Č
* ď, Ď
* é, É
* ě, Ě
* í, Í
* ň, Ň
* ó, Ó
* ř, Ř
* š, Š
* ť, Ť
* ú, Ú
* ů, Ů
* ý, Ý
* ž, Ž
* −
* ×
* °
* nezlomitelná mezera: "&nbsp;"
* české uvozovky: „“
