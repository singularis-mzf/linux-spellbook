<!--

Linux Kniha kouzel, dodatek Základní znalosti
Copyright (c) 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Základní znalosti

!ÚzkýRežim: zap

## Úvod

Tato kapitola uvádí základní znalosti, které každý středně pokročilý uživatel bashe
(což je nejčastější a v Ubuntu výchozí interpret příkazové řádky) dobře zná a často používá.
Jejich znalost se vám může velmi vyplatit při přizpůsobování zaklínadel vašim potřebám,
takže vám doporučuji si tuto krátkou kapitolu projít.

## Vstupy, výstupy a přesměrování

Aby se terminálové příkazy v Linuxu daly snáze propojovat, nabízejí jednotné rozhraní svých vstupů
a výstupů; každý takový příkaz má **standardní vstup** (ze kterého může číst), **standardní výstup**
(kam může zapisovat) a **standardní chybový výstup** (kam obvykle vypisuje chybová hlášení, aby se nemíchaly
s normálními daty).

Všechny tyto vstupy a výstupy jsou ve výchozím stavu napojeny na terminál, ale můžete je
*přesměrovat* ze/do souboru:

*# *<br>
{*příkaz*} [{*parametr*}]... [**&lt;**{*soubor-pro-std-vstup*}] <nic>[**&gt;**{*soubor-pro-std-výstup*}] <nic>[**2&gt;**{*soubor-pro-std-chyb-výstup*}]

**Roura** je nástroj, který umožňuje připojit standardní výstup jednoho příkazu na standardní vstup druhého;
příkazy pak běží současně a předávájí si tímto kanálem data. Roura vypadá takto:

*# *<br>
{*první-příkaz*} **\|** {*druhý-příkaz*} [**\|** {*další-příkaz*}]...

## Minus místo názvu souboru

Řada příkazů po vás vyžaduje zadat název souboru, ze kterého budou číst nebo kam budou zapisovat.
Mnoho těchto příkazů vám dovoluje na místo názvu souboru zadat „-“ a program pak přečte data
ze svého standardního vstupu, který může přicházet přes rouru z jiného programu.
Jako příklad mohu uvést příkaz „cat“:

*# *<br>
**printf 'první řádek\\ndruhá řádka\\n' \| cat prvni-soubor.txt - druhy-soubor.txt**

Ne všechny příkazy to umožňují. Budete-li na pochybách, budete to muset vyzkoušet nebo hledat
v jejich nápovědě. V případě, že budete potřebovat takovému příkazu skutečně zadat,
aby pracoval se souborem, který se jmenuje „-“, je potřeba ho zadat jako „./-“.

## Oddělovač \-\-

Pokud ve skriptech pracujete se soubory, jejichž názvy začínají znakem minus,
některé příkazy mohou být zmatené a pochopit daný název jako přepínací volbu.
Řada příkazů proto umožňuje za poslední volbou uvést zvláštní parametr „\-\-“,
který znamená, že od něj dál už následují jen názvy souborů a žádné volby.

Ani tuto možnost nenabízejí všechny příkazy, mnoho příkazů však ano.
Obzvlášť důležité je to u příkazu *rm* (uvedený příklad smaže soubor „-f“):

*# *<br>
**rm \-\- -f**

## Kde najít nápovědu

Pokud objevíte nějaký příkaz a zajímá vás, co dělá, jak se používá a jaké přijímá volby,
zapomeňte na internet! Online zdroje, které na něm můžete nalézt, jsou totiž buď zastaralé,
nebo naopak příliš nové (a tedy nabízejí i možnosti, které verze příkazu ve vašem systému
nemá). Vždy nejprve zkuste následující standardní postup, jak se k nápovědě dostat:

1\. Pokud jde o interní příkaz bashe, zadáním příkazu „help {*příkaz*}“ se dostanete
ke stručné nápovědě. Nejste-li si jistý/á, zda jde o interní příkaz bashe,
napište do terminálu „builtin“ a dvakrát stiskněte klávesu {_Tab_}; vypíše se seznam
interních příkazů bashe. Tentýž seznam můžete získat příkazem „compgen -A builtin“.

2\. Pokud nejde o interní příkaz bashe, zkuste ho zavolat s parametrem „\-\-help“,
případně „-h“. Mnoho příkazů v takovém případě vypíše krátkou nápovědu a poradí,
kde sehnat podrobnější; některé (např. „youtube-dl“) rovnou vypíšou tu podrobnější.

3\. Podrobnější nápovědu k mnoha příkazům získáte příkazem „man {*příkaz*}“.
Manuálové stránky mají jednotnou strukturu, takže se v nich uživatel brzy naučí orientovat,
jen málo z nich je ale přeložených do češtiny.

4\. Poslední obvyklou možností je příkaz „info {*příkaz*}“. Ten je potřeba poměrně zřídka;
v praxi jsem ho potřeboval/a pouze u příkazu „date“.

V krajním případě se můžete vydat prozkoumat adresář „/usr/share/doc/{*příkaz*}“,
pokud existuje, ale informace tam bývají obvykle vhodné jen pro nejpokročilejší uživatele
a často nejsou dostupné, pokud si nenainstalujete příslušný dokumentační balíček.

Teprve pokud uvedené postupy selžou nebo neposkytnou dostatečně podrobné informace,
hledejte oficiální stránku daného programu nebo jiný dostatečně věrohodný online zdroj.
Online zdroje vám také mohou pomoci v případě, kdy potřebujete funkci, která ve verzi
příkazu dostupné ve vašem systému, není podporovaná. V takovém případě vám mohou poradit,
jakou verzi potřebujete a jak ji do vašeho systému nainstalovat.

## Odzvláštňování

Když v terminálu zadáte příkaz, interpret bash ho přečte znak po znaku od začátku do konce
a ke každému znaku přiřadí příznak, zda s ním bude zacházat jako s „obyčejným znakem“
nebo mu přisoudí nějaký zvláštní význam. Jako příklad uvedu příkaz:

*# *<br>
**cat a.txt**

V uvedeném příkazu jsou všechny znaky obyčejné, s výjimkou mezery – ta má zvláštní význam:
odděluje příkaz od jeho parametru. V bashi mají obvykle zvláštní význam tyto znaky:

**Konec řádku, mezera, " # $ &amp; ' ( ) \* ; &lt; &gt; ? [ \\ ] \` { \| } ~**

Znak **„!“** má zvláštní význam převážně jen tehdy, když je zapnutá historie,
tedy v interaktivním režimu; ve skriptech je naopak běžné ho používat jako obyčejný znak
i bez odzvláštnění.

Znak **„=“** má zvláštní význam převážně jen v místě, kde se očekává název příkazu
(tam se pak interpretuje jako přiřazení do proměnné); v ostatních místech s ním
lze zacházet jako s obyčejným znakem.

Naopak tyto znaky jsou v bashi v normálním kontextu vždy obyčejné (existují
zvláštní kontexty jako např. uvnitř vzorku nebo uvnitř regulárního výrazu,
kde platí zase jiná pravidla):

**% + , - . / : @ ^ \_**

Někdy ale potřebujete, aby se znak, kterému bash připisuje zvláštní význam,
zpracoval stejně jako obyčejné znaky, a právě k tomu slouží „odzvláštňování“.
Uvedu příklad:

*# *<br>
**cat Ahoj, světe.txt**

V uvedeném příkazu by bash mezeru mezi čárkou a písmenem „s“ pochopil jako oddělovač parametrů
a příkaz „cat“ by pak hledal dva různé soubory. Řešením je sdělit bashi, aby danou mezeru
přijal jako obyčejný znak, tedy tuto mezeru **odzvláštnit**,
a na to existují čtyři metody:

*# *<br>
**cat Ahoj,\\ světe.txt**<br>
**cat 'Ahoj, světe.txt'**<br>
**cat "Ahoj, světe.txt"**<br>
**cat $'Ahoj, světe.txt'**

Základní (ačkoliv ne nejpoužívanější) metodou odzvláštnění je umístění *zpětného lomítka*
před zvláštní znak. Tato metoda funguje se všemi zvláštními znaky kromě konce řádky
– ten se v takovém případě z příkazu úplně vypustí.

Často používaná je druhá metoda – uzavření do *apostrofů*. Když bash narazí při čtení příkazu
na apostrof, přepne se do kontextu, ve kterém považuje za zvláštní znak jen další apostrof
a všechny ostatní znaky *bez výjimky* (tzn. včetně konce řádku či zpětného lomítka)
považuje za znaky obyčejné. Pokud do takto odzvláštněného parametru potřebujeme
vložit apostrof, musíme ho nahradit konstrukcí:

*# *<br>
**'\\''**

Uzavření do *dvojitých uvozovek* je určitý kompromis. Uvnitř nich zůstává zvláštní význam
pouze znakům „!“, „"“, „$“, „\\“ a „\`“ a tyto znaky (kromě vykřičníku) lze i uvnitř
dvojitých uvozovek odzvláštnit zpětným lomítkem. Obzvlášť často se dvojité uvozovky
používají v kombinaci s dosazováním proměnných.

Poslední metodou jsou *apostrofy s dolarem*. Uvnitř nich zůstává zvláštní význam pouze
znakům „'“ a „\\“, přičemž oba lze odzvláštnit zpětným lomítkem a zpětné lomítko zde
navíc umožňuje zadat širokou škálu zvláštních sekvencí, které se přeloží
na řídící či jiné znaky; např. „\\n“ se zde přeloží na konec řádky
a „\\u2251“ zde vygeneruje znak Unicode s hexadecimálním kódem 0x2251.

### Prázdný parametr

Mezery normálně oddělují od sebe parametry příkazu. Pokud použijete víc mezer za sebou,
utvoří dohromady jen jeden oddělovač. Výjimkou je případ, kdy mezi mezery vložíte
prázdnou konstrukci z apostrofů, uvozovek či apostrofů s dolarem. V takovém případě
bash každou takovou konstrukci interpretuje jako *jeden* další (prázdný) parametr,
bez ohledu na to, jak je složitá.
Příklady:

*# *<br>
**printf '(%s)\\n' A    B** ⊨ 2 řádky<br>
**printf '(%s)\\n' A  ""  B** ⊨ 3 řádky<br>
**printf '(%s)\\n' A  ''""  B** ⊨ 3 řádky<br>
**printf '(%s)\\n' A  ""''$''  B** ⊨ 3 řádky<br>
**printf '(%s)\\n' A  "" $''  B** ⊨ 4 řádky

## Návratový kód a zřetězení

Mnoho příkazů, když selže, vypíše uživateli chybové hlášení. Bylo by ale nepraktické
taková hlášení zpracovávat ve skriptu, proto příkazy současně s tím
vracejí číselnou hodnotu 0 až 255, která signalizuje, zda daný příkaz uspěl nebo selhal.
Tato hodnota se po skončení každého příkazu uloží do zvláštního parametru „$?“.
Hodnota 0 znamená, že příkaz uspěl; hodnoty 1 až 255, že selhal.

Je-li příkazem několik příkazů spojených rourami, návratovým kódem je kód *posledního* uvedeného.
Návratové kódy všech částí roury pak lze získat z pole „PIPESTATUS“, ale to obvykle není potřeba.

Příkazy (popř. sestavy příkazů spojených rourami) lze zřetězit pomocí logických
operátorů &amp;&amp; a \|\|:

* &amp;&amp; – Po provedení příkazu vlevo se vyhodnotí jeho návratový kód. Pokud příkaz selhal (kód je vyšší než 0), příkaz vpravo se přeskočí (a návratový kód zůstane nenulový).
* \|\| – Po provedení příkazu vlevo se vyhodnotí jeho návratový kód. Pokud příkaz selhal, provede se příkaz vpravo; jinak se příkaz vpravo přeskočí (a návratový kód zůstane 0).

Tyto operátory se vyhodnocují vždy zleva doprava a neliší se prioritou.
Nejčastěji se používají v záhlaví příkazu „if“.

!ÚzkýRežim: vyp
