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
