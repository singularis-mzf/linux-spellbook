<!--

Linux Kniha kouzel, dokumentace: Syntaxe kapitol
Copyright (c) 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
# Syntaxe kapitol

**STAV TEXTU:** aktuální

Zdrojový kód jednotlivých kapitol je v jazyce, který je silně založený na Markdownu (byť s omezenými možnostmi formátování). Tento dokument uvádí především rozdíly syntaxe oproti běžnému Markdownu. Důležité je rozlišovat formátování vně zaklínadel a uvnitř zaklínadel, protože formátování uvnitř zaklínadel je víc omezené.

## Formátování mimo zaklínadla

### Komentáře

Mechanismus překladu podporuje pouze dva druhy komentářů: jednořádkový a víceřádkový.

*Jednořádkový komentář* musí tvořit celý řádek. Tento řádek musí (bez odsazení) začínat „`<!--`“ a končit „`-->`“ a mezi nimi nesmí obsahovat dvě pomlčky za sebou „--“.

Příklad:

``<!-- Správný komentář.-->``

*Víceřádkový komentář* musí začínat samostatným řádkem „`<!--`“ a pokračovat až po samostatný řádek „`-->`“.

Příklad:

``<!--``<br>Správný komentář.<br>``-->``

Chybný (nepodporovaný) příklad:

``Nějaký text. <!-- ??? --> Další text.``

Chybný (nepodporovaný) příklad:

``xyz <!-- Chybný komentář.-->``

Chybný (nepodporovaný) příklad:

``<!-- Chybný -- komentář.-->``

### Odstavce

Odstavce mohou být tří typů:

* Obyčejné odstavce jsou odděleny jedním nebo více prázdnými řádky. První řádek každého odstavce, který nenásleduje po nadpisu nebo seznamu bude vizuálně odsazen zarážkou.
* Odstavce bez zarážky se vyznačují tím, že před prvním znakem je uvedena značka „`<neodsadit>`“. U těchto odstavců není zarážka generována nikdy.
* Odsazený odstavec je tvořen řádky, které na začátku obsahují jeden až šest znaků „`>`“ a mezeru (podle požadované úrovně odsazení). Takový odstavec bude odsazen celý a zarážka se u něj negeneruje. Každá řádka daného odstavce musí začínat stejným počtem znaků „`>`“.

Příklady:

``Obyčejný odstavec může``<br>
``pokračovat na další řádce.``<br><br>
``> Odsazený odstavec také může``<br>
``> pokračovat na další řádce, ale musí se zopakovat značka „&gt;“.``<br><br>
``<neodsadit>A takto vypadá odstavec bez zarážky;``<br>
``i ten může pokračovat na další řádce.``

### Seznamy

Je dovolen pouze jednoduchý odrážkovaný seznam, kde každá položka začíná hvězdičkou a mezerou a seznam je od zbytku kódu z obou stran oddělen prázdnými řádkami:

``* Položka seznamu může``<br>
``pokračovat na další řádce, ale nesmí obsahovat prázdnou řádku.``<br>
``* Toto je druhá položka seznamu.``

### Formátování textu

Ve všech druzích odstavců a seznamů je povoleno toto formátování:

* tučně „`**obsah**`“ (lze kombinovat)
* kurzívou „`*obsah*`“ (lze kombinovat)
* doplň „`{*obsah*}`“ (nesmí se kombinovat)
* klávesa „`{_obsah_}`“ (nesmí se kombinovat)
* hypertextový odkaz „`[text](adresa)`“ (nesmí se kombinovat)
* značka `<br>` způsobí vynucený zlom řádky (lze kombinovat)

Pozor! Formátovací značka musí být uzavřena na tomtéž řádku zdrojového kódu,
kde byla otevřena. Následující příklad je tedy chybný:

``Tento příklad je *chybný,``<br>
``protože kurzíva* měla být ukončena už na předchozí řádce.``

### Obrázky

Obrázky je dovoleno vkládat pouze jako samostatné odstavce, např. takto:

``![alternativní text](../obrazky/cesta.přípona)``

V současnosti jsou podporovány pouze obrázky typu png a svg
(příslušné soubory je nutno před použitím uvést do Makefile
a je vhodné doplnit jejich konfiguraci do „konfig.ini“).
Údržba obrázků je ale pracná a tisk nákladný, proto se obrázkům spíš vyhýbám.

### Nadpisy

Jsou dovoleny jen tří úrovně nadpisů:

``# Nadpis kapitoly`` může být v souboru zdrojového kódu pouze jeden a musí to být první nadpis vůbec.<br>
``## Nadpis sekce``<br>``### Nadpis podsekce``

## Zaklínadla

Příklad zdrojového kódu zaklínadla:

> ``*# titulek s **tučným** slovem*<br>``<br>
> ``*// První poznámka pod čarou.*<br>``<br>
> ``*// Druhá poznámka pod čarou.*<br>``<br>
> ``^^**#include <stdio.h>**<br>``<br>
> ``**printf("Hello, world.\\\\n");** ⊨ Hello, world.<br>``<br>
> ``!: Pro přehlednost vynechejte několik prázdných řádků.<br>``<br>
> ``**return 0;**``

Zaklínadla jsou tvořena posloupností neprázdných řádek následujících typů:

* titulek zaklínadla (povinný, vždy právě 1 řádek)
* poznámky pod čarou (volitelné)
* řádky inicializace
* obyčejné řádky
* odsazené řádky
* pokyny uživateli

**Každý** řádek zaklínadla kromě posledního musí končit značkou „`<br>`“, poslední řádek zaklínadla touto značkou končit nesmí (podle toho se pozná, že je poslední). Za posledním řádkem zaklínadla musí následovat alespoň jedna prázdná řádka.

### Titulek zaklínadla

Titulek zaklínadla je povinný a musí to být první řádka zdrojového kódu zaklínadla. Má tvar:

* Hvězdička „`*`“
* Mřížka „`#`“
* Mezera (obyčejná)
* Text titulku (volitelný – u zaklínadel bez titulku se neuvádí). Text titulku může obsahovat tučně zvýrazněné podřetězce (obklopené znaky „`**`“), a to i na začátku nebo na konci. Jiné formátování není dovoleno.
* hvězdička „`*`“

### Poznámky pod čarou

Poznámky pod čarou jsou nepovinné, ale jsou-li uvedeny, musí být uvedeny v bloku bezprostředně pod titulkem zaklínadla. Poznámka pod čarou má tvar:

* Hvězdička „`*`“
* Dvojí lomítko „`//`“
* Mezera (obyčejná)
* Text poznámky pod čarou (povinný). (Pozor, nesmí obsahovat konec řádku; i velmi dlouhou poznámku pod čarou musíte zapsat jako jednu řádku zdrojového kódu.)
* Hvězdička „`*`“

V textu poznámky pod čarou není dovoleno formátování. Pozor! V zaklínadlech „bez titulku“ nejsou poznámky pod čarou dovoleny.

### Řádky inicializace

Řádky inicializace vypadají stejně jako obyčejné řádky (viz níže), jen navíc začínají zvláštní značkou „`^^`“ (dvě stříšky). U takovýchto řádků se vygeneruje značka, která informuje uživatele, že tyto řádky patří do „preambule“, případně jde o globální nastavení, které musí být před použitím zaklínadla provedeno.

Přesný význam této instrukce závisí na konkrétním jazyce, ale podstatné je, že v případě opakovaného použití zaklínadla se tyto řádky již neopakují. Příkladem je, že v jazyce C musíme uvést „`#include <stdio.h>`“, abychom mohli použít funkci „printf()“; pokud však potřebujeme použít funkci „printf()“ vícekrát, stačí hlavičkový soubor „stdio.h“ vložit pouze jednou.

Řádky inicializace se obvykle uvádějí na začátku zaklínadla (pod titulek a poznámky pod čarou, ale není to striktně vyžadováno).

### Obyčejné řádky

Obyčejné řádky obsahují samotný obsah zaklínadla a platí v nich jednoduché pravidlo: všechny znaky, které má uživatel zadat doslova, musejí být naformátovány tučně (což se v Markdownu dělá uzavřením do dvojitých hvězdiček). Naopak znaky (kromě bílých), které uvnitř dvojitých hvězdiček uzavřeny nejsou, musí mít nějaký zvláštní význam pro mechanismus překladu, jinak vznikne syntaktická chyba.

V obyčejných řádcích se mohou vyskytnout tyto druhy formátování (s výjimkou hranatých závorek je nelze zanořovat):

* „`**obsah**`“ — Úseky uzavřené do dvojitých hvězdiček obsahují znaky, které má uživatel zadat tak, jak jsou. Na výstupu se zobrazí neproporcionálním písmem.
* „`{*obsah*}`“ — Takto uzavřená značka označuje obsah, který má uživatel doplnit; na výstupu se zobrazí jako podtržený text.
* „`{_Klávesa_}`“ — Takto uzavřená značka vygeneruje symbol klávesy. Např. klávesovou zkratku Ctrl+C zapíšeme: „`{_Ctrl_}**+**{_C_}`“.
* značky „`[`“ a „`]`“ – Tyto značky vymezují nepovinné úseky zaklínadla; uvádějí se mimo úseky uzavřené do dvojitých hvězdiček, protože uvnitř dvojitých hvězdiček znamenají závorky „[“ a „]“, že je má uživatel doslovně napsat. Nemusejí být spárovány (ačkoliv obvykle budou) a nevytvářejí žádné omezení ohledně toho, co může být uvnitř nich.
* značka „...“ se uvádí za konec slova, `{*doplnění*}` nebo nepovinného bloku a vyznačuje, že daný parametr či úsek lze zadat opakovaně.

Pozor na rozdíl:

„`**test [**{*název*}**]**`“ znamená, že uživatel má napsat „test“ a za něj název v hranatých závorkách, tedy např. „test [abc.txt]“

Naopak „`**test** [{*název*}]`“ znamená, že uživatel má napsat „test“ a za něj může volitelně napsat název; správnými vstupy jsou pak tedy: „`test`“, „`test abc.txt`“.

A třetí možnost je „`**test** [**[**{*název*}**]**]`“; ta znamená, že uživatel má napsat „test“ a za něj může volitelně napsat název uzavřený v hranatých závorkách (všiměte si, že pouze vnitřní hranaté závorky jsou „tučně“).

Na konci obyčejného řádku může být připojen takzvaný „příklad“, který je tvořen následujícím kódem:

* Mezera (obyčejná)
* Znak „⊨“
* Mezera (obyčejná)
* Text příkladu k vypsání. Tento text může obsahovat vnořené tučné formátování (dvojitými hvězdičkami) nebo kurzívu (jednoduchými hvězdičkami), ale obvykle to není dobrý nápad.

### Odsazené řádky

Odsazené řádky vypadají stejně jako obyčejné řádky, jen navíc začínají zvláštní značkou „`<odsadit1>`“ až „`<odsadit8>`“ podle požadované úrovně odsazení.
Používají se pro zpřehlednění víceřádkových zaklínadel.

Příklad:

`**int main() {<nic>**<br>`<br>
`<odsadit1>**printf("Hello, world.\\n");**<br>`<br>
`<odsadit1>**return 0;**<br>`<br>
`**<nic>}**`

Pozor! Odsazené řádky se uživateli vykopírují bez odsazení. Pokud má obsah řádku skutečně začínat mezerami či tabulátory, je potřeba to výslovně uvést příslušnými značkami („`&blank;` resp. „`<tab8>`“).

### Pokyny uživateli

Pokyny uživateli (ve zdrojovém kódu někdy zvané „akce“) jsou neformální pokyny, co má uživatel v dané chvíli dělat. Používáme je jen v případě nutnosti. Neslouží k uvedení dodatečných informací (k tomu slouží poznámky pod čarou).

Pokyn uživateli má tvar:

* Vykřičník „!“
* Dvojtečka „:“
* Mezera (obyčejná)
* Text pokynu. (Může obsahovat vnořené formátování, zejména formu „`{_Klávesa_}`“).

## Další podporované značky

* Značky `&lt;`, `&gt;` a `&amp;` je povinné používat k nahrazení znaků „`<`“, „`>`“ a „`&`“, které mají v Markdownu zvláštní význam.
* Značka „`&blank;`“ se přeloží na takzvanou viditelnou mezeru. Používá se zejména uvnitř zaklínadel, odkud se vykopíruje jako obyčejná mezera a kde znamená zdůraznění, že na dané pozici musí být právě jedna mezera.
* Podporovány jsou také značky `&amp;`, `&quot;` a `&nbsp;`, ale jejich použití není nutné, protože odpovídající znaky lze zadat přímo.
* Značka „`<nic>`“ se z kódu tiše vypouští a nic negeneruje, jejím účelem je přerušit kombinace znaků, které by jinak měly zvláštní význam.
* Značky „`<tab1>`“, „`<tab2>`“, ..., „`<tab8>`“ generují tabulátor (každá značka se vykopíruje jako jeden tabulátor); mechanismus překladu však vyžaduje výslovně uvést, jakou skutečnou šířku bude daný tabulátor mít (1 až 8 znaků, proto je k dispozici těchto 8 značek).

## Direktivy

Direktivy představují instrukce pro mechanismus překladu. Direktiva je zvláštní řádek, který má tvar:

* vykřičník „!“
* alfanumerické znaky (např. „FixaceIkon“ nebo „Štítky“)
* dvojtečka „:“

A zde může končit, nebo pokračovat:

* mezera (obyčejná)
* parametr (text do konce řádky)

Nejdůležitější podporované direktivy jsou:

* `!Štítky: {štítek 1}{štítek 2}...` — Deklaruje štítky pro danou kapitolu.
* `!ÚzkýRežim: zap-nebo-vyp` — Přepíná mezi normálním a úzkým režimem sazby. V úzkém režimu se ve formátu A4 tiskne text do dvou sloupců a nejsou dovolena zaklínadla s titulky (jen ta bez titulků).
* `!FixaceIkon: číslo-nebo-*` — Vytváří ukotvení pro výpočet ikon. V některé z budoucích verzí možná bude odstraněna.

## Další poznámky

Je podporována pouze daná podmnožina znaků Unicode. Při výskytu znaku, který není podporován, dojde k chybě při překladu do PDF. Podporu nových znaků lze sice snadno přidávat, ale kvůli ochraně před překlepy je toto omezení ponecháváno. Kompletní seznam podporovaných znaků najdete ve zvláštní kapitole [_ukázka](../kapitoly/_ukázka.md).

Rovněž pravidla odzvláštňování jsou uvedena v kapitole [_ukázka](../kapitoly/_ukázka.md). (Bohužel jsou poměrně složitá.)
