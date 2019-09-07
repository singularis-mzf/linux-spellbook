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
**<tab><tab>a řádek začínající dvěma tabulátory**<br>
**&nbsp;řádek odsazený jednou mezerou**<br>
**&nbsp;&nbsp;..dvěma mezerami**

*# *<br>
*pro samostatné ukázky kódu je také podporován příklad bez záhlaví*<br>
*takový příklad nemůže mít poznámky pod čarou*

## Zvláštní znaky

Lze zadat nejrůznější zvláštní znaky.

* Znaky &lt;, &amp; a &gt; vždy nahraďte odpovídajícími entitami &amp;lt;, &amp;amp; a &amp;gt;.
* Znaky \\, \`, \*, \_, \^ a \~ vždy escapujte zpětným lomítkem.
* Znaky #, $, +, -, : a | escapujte zpětným lomítkem, jsou-li zdvojeny nebo před prvním alfanumerickým znakem na řádku. \#\#, \+\+, \-\-, \$\$, \:\:, \|\|.
* Znaky !, ", %, ', (, ), ,, ., /, ;, =, ?, @, [ zadávejte přímo, bez escapování, a to i v případě, že jsou zdvojeny: !!, "", %%, '', ((, )), ,,, .., //, ;;, ==, ??, @@, [[.
* Znak ] escapujte zpětným lomítkem, pokud bezprostředně za ním ve zdrojovém kódu následuje otevírací kulatá závorka. \](
* Znak { escapujte zpětným lomítkem, pokud bezprostředně za ním ve zdrojovém kódu následuje neescapovaná \*. (\{*kurzívou*)
* Potřebujete-li zapsat URL adresu, která nemá být formátována jako odkaz, nahraďte v ní // speciálním znakem \⫽. Při jiném použití (což je nepravděpodobné) musíte tento znak rovněž escapovat zpětným lomítkem.
* Nezlomitelnou mezeru můžete zadat buď přímo, nebo jako entitu &amp;nbsp;.

## Podporované znaky

* ( ) (ASCII 0x20)
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
* 0 (ASCII 0x30)
* 1 (ASCII 0x31)
* 2 (ASCII 0x32)
* 3 (ASCII 0x33)
* 4 (ASCII 0x34)
* 5 (ASCII 0x35)
* 6 (ASCII 0x36)
* 7 (ASCII 0x37)
* 8 (ASCII 0x38)
* 9 (ASCII 0x39)
* \: (ASCII 0x3a)
* ; (ASCII 0x3b)
* &lt; (ASCII 0x3c)
* = (ASCII 0x3d)
* &gt; (ASCII 0x3e)
* ? (ASCII 0x3f)
* @ (ASCII 0x40)
* A (ASCII 0x41)
* B (ASCII 0x42)
* C (ASCII 0x43)
* D (ASCII 0x44)
* E (ASCII 0x45)
* F (ASCII 0x46)
* G (ASCII 0x47)
* H (ASCII 0x48)
* I (ASCII 0x49)
* J (ASCII 0x4a)
* K (ASCII 0x4b)
* L (ASCII 0x4c)
* M (ASCII 0x4d)
* N (ASCII 0x4e)
* O (ASCII 0x4f)
* P (ASCII 0x50)
* Q (ASCII 0x51)
* R (ASCII 0x52)
* S (ASCII 0x53)
* T (ASCII 0x54)
* U (ASCII 0x55)
* V (ASCII 0x56)
* W (ASCII 0x57)
* X (ASCII 0x58)
* Y (ASCII 0x59)
* Z (ASCII 0x5a)
* [ (ASCII 0x5b)
* \\ (ASCII 0x5c)
* ] (ASCII 0x5d)
* \^ (ASCII 0x5e)
* \_ (ASCII 0x5f)
* \` (ASCII 0x60)
* a (ASCII 0x61)
* b (ASCII 0x62)
* c (ASCII 0x63)
* d (ASCII 0x64)
* e (ASCII 0x65)
* f (ASCII 0x66)
* g (ASCII 0x67)
* h (ASCII 0x68)
* i (ASCII 0x69)
* j (ASCII 0x6a)
* k (ASCII 0x6b)
* l (ASCII 0x6c)
* m (ASCII 0x6d)
* n (ASCII 0x6e)
* o (ASCII 0x6f)
* p (ASCII 0x70)
* q (ASCII 0x71)
* r (ASCII 0x72)
* s (ASCII 0x73)
* t (ASCII 0x74)
* u (ASCII 0x75)
* v (ASCII 0x76)
* w (ASCII 0x77)
* x (ASCII 0x78)
* y (ASCII 0x79)
* z (ASCII 0x7a)
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
* nezlomitelná mezera: "&nbsp;"
* české uvozovky: „“
