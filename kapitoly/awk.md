<!--

Linux Kniha kouzel, AWK
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
ÚKOLY:
[ ] Vysvětlit použití znaku & v druhém parametru gsub(); viz https://www.gnu.org/software/gawk/manual/html_node/Gory-Details.html.

[ ] Tip: používat mawk -W sprintf=2123456789
[ ] Poznámka: mawk pracuje po bajtech a neumí zpracovat nulový bajt (končí řetězec), což je závažné omezení.
-->

# AWK

!Štítky: {program}{syntaxe}{zpracování textu}
!ÚzkýRežim: zap

## Úvod

AWK je univerzální, řádkově orientovaný skriptovací nástroj pro jednoduché zpracování
textových souborů. Jeho syntaxe vychází ze syntaxe bashe a jazyka C, navíc přidává
literály regulárních výrazů v obyčejných lomítkách. (Ve srovnání s příbuzným perlem
je tedy jeho syntaxe velmi umírněná a jeho schopnosti omezené.)

Skript AWK se skládá ze sekvence takzvaných „vzorků“ (podmínek)
a k nim příslušejících bloků příkazů. Provádí se tak, že AWK pro každý řádek
každého vstupního souboru („záznam“) prochází vzorky od začátku skriptu,
testuje je, a když vzorek vyhoví, vykoná jeho blok příkazů. Celý skript si tak lze
představit jako sérii podmínek „if“ v cyklu „foreach“.

V Ubuntu najdeme dvě hlavní implementace jazyka AWK: gawk, který pracuje se soubory
v kódování UTF-8, ale je ve srovnání s jinými nástroji poněkud pomalý, a mawk,
který je sice rychlý, ale pracuje v osmibitovém kódování, má některá vestavěná omezení,
a navíc nedokáže správně zpracovat vstupní soubory obsahující nulový bajt.

## Definice

* **Vzorek** (pattern) je podmínka, která určuje, zda se daný blok příkazů má v dané iteraci skriptu provést. Na celý skript tak můžete pohlížet jako na sérii příkazů „if“ v cyklu „while“. Kromě obecného logického výrazu interpretuje awk i další typy vzorků.
* **Záznam** (record) je typicky řádek vstupního souboru. Nastavením speciální proměnné „RS“ (record separator) na jiný oddělovač lze pracovat s jinak definovaným záznamem.
* Záznam se po načtení rozdělí do **sloupců** (fields) $1, $2 atd. Ve výchozím nastavení se za oddělovač sloupců považuje jakákoliv sekvence bílých znaků, lze to však změnit nastavením speciální proměnné „FS“ (field separator).
* Regulární výraz může být zadán buď jako **literál** do lomítek, např. „/^a/“, nebo jako **dynamický regulární výraz**, kterým může být jakýkoliv řetězec či řetězcový výraz (např. "^a"). Ve většině kontextu jsou tyto dva způsoby zadání rovnocenné, ale liší se v detailech (např. v dynamickém regulárním výrazu není nutno escapovat obyčejná lomítka).

!ÚzkýRežim: vyp

## Zaklínadla

### Vzorky

*# podmíněné vykonávání (obecně/příklady...)*<br>
{*podmínka*}<br>
**PROMENNA == 1 &amp;&amp; /^X/**<br>
**$1 ~ /ABC/**<br>
**PRIZNAK**<br>
**$0 == ""**<br>
**!/^#/**

*# zvláštní průchody: po spuštění skriptu/před ukončením skriptu*<br>
**BEGIN**<br>
**END**

*# zvláštní průchody: před otevřením souboru/po zpracování posledního řádku souboru (jen gawk)*<br>
**BEGINFILE**<br>
**ENDFILE**

*# zapínané vykonávání*<br>
*// Zapne příznak před řádkem, který splní „podmínku zapnout“, a vypne příznak za řádkem, který splní „podmínku vypnout“. Blok příkazů se provede, pokud je příznak zapnutý.*<br>
{*podmínka zapnout*}**,**{*podmínka vypnout*}

### Skalární proměnné

*# získat hodnotu proměnné*<br>
{*název-proměnné*}

*# přiřadit hodnotu proměnné*<br>
{*název-proměnné*} **=** {*hodnota*}

*# nepřímý přístup k proměnné (jen gawk, příklad)*<br>
**PROMENNA = "hodnota";**<br>
**UKAZATEL = "PROMENNA";**<br>
**print SYMTAB[UKAZATEL];**<br>
**SYMTAB[UKAZATEL] = "nova hodnota"**

### Pole

*# přečíst hodnotu prvku pole*<br>
{*pole*}**[**{*index*}**]**

*# přiřadit hodnotu prvku pole*<br>
{*pole*}**[**{*index*}**] =** {*hodnota*}

*# zjistit, zda prvek pole existuje*<br>
{*index*} **in** {*pole*}

*# smazat z pole jeden prvek/všechny prvky*<br>
**delete** {*pole*}**[**{*index*}**];**
**delete** {*pole*}**;**

*# přečíst počet prvků pole (jen gawk)*<br>
**length(**{*pole*}**)**

*# zjistit, zda je proměnná pole (jen gawk)*<br>
**isarray(**{*proměnná*}**)**


### Podmínky, cykly a přepínač

*# podmínka **if***<br>
**if (**{*podmínka*}**)** {*příkaz-nebo-blok*} [**else** {*příkaz-nebo-blok*}]

*# cyklus **while***<br>
**while (**{*podmínka*}**)** {*příkaz-nebo-blok*}

*# cyklus **for***<br>
**for (**[{*inicializace*}]**;** [{*podmínka*}]**;** [{*iterace*}]**)** {*příkaz-nebo-blok*}

*# cyklus **foreach***<br>
*// Poznámka: cyklus přiřazuje proměnné hodnoty INDEXŮ daného pole v LIBOVOLNÉM pořadí! Pro přístup k hodnotám v poli je musíte indexovat.*<br>
**for (**{*proměnná*} **in** {*pole*}**)** {*příkaz-nebo-blok*}

*# příkaz **switch** (jen gawk)*<br>
*// Přepínač switch pracuje v gawk stejně jako v jazyce C, včetně implicitního „propadání větví“.*<br>
**switch (**{*výraz*}**) \{**<br>
[[**case** {*hodnota*}**:**] <nic>[**default:**] {*příkazy*}]...
**\}**

*# cyklus **do-while** (alternativy)*<br>
**do {** {*příkazy*} **} while (**{*podmínka*}**)**<br>
**do** {*příkaz*}**; while (**{*podmínka*}**)**

### Řízení toku

*# opustit nejvnitřnější cyklus (for, while, do) nebo přepínač (switch)*<br>
**break;**

*# skočit na podmínku nejvnitřnějšího cyklu (for, while, do)*<br>
**continue;**

*# přejít na zpracování **dalšího řádku***<br>
**next;**

*# přejít na zpracování **dalšího souboru** (jen gawk)*<br>
*// Poznámka: tento příkaz přeskočí odpovídající průchod ENDFILE!*<br>
**nextfile;**

*# přejít na průchod END (přeskočí všechno zbylé zpracování)*<br>
**exit** [{*návratová-hodnota*}]**;**

*# vypsat chybovou zprávu a skončit s chybou*<br>
**print** {*chybová-zpráva-řetězec*} **&gt; "/dev/stderr"**<br>
**exit 1;**

### Speciální proměnné

*# počet souborů, které mají být načteny jako vstupní*<br>
**ARGC - 1**

*# N-tý (od 1) vstupní soubor, jak je zadán na příkazovém řádku*<br>
**ARGV[**{*N*}**]**

*# získat hodnotu proměnné prostředí (obecně/příklad)*<br>
**ENVIRON[**{*řetězec-s-názvem-proměnné*}**]**<br>
**ENVIRON["PATH"]**

*# nastavit vstupní oddělovač záznamu (na jeden znak/na regulární výraz)*<br>
*// Výchozí hodnotou je konec řádku „\\n“.*<br>
**RS = "**{*znak*}**"**<br>
**RS = "**{*regulární výraz*}**"**

*# nastavit vstupní oddělovač pole (na jeden znak/na regulární výraz)*<br>
*// Zvláštní hodnota " " (mezera), která je navíc výchozí, odpovídá chováním regulárnímu výrazu „\\s+“.*<br>
**FS = "**{*znak*}**"**<br>
**FS = "**{*regulární výraz*}**"**

*# nastavit výstupní oddělovač pole*<br>
**// Výchozí hodnota je „ “ (mezera); může být přednastaven také parametrem příkazové řádky „-F“.**<br>
**OFS = "**[{*řetězec*}]**"**

*# nastavit výstupní oddělovač záznamu*<br>
**ORS = "**[{*řetězec*}]**"**

*# počet sloupců v aktuálním řádku*<br>
*// Počet sloupců lze i nastavit.*<br>
**NF**

*# název/index právě zpracovávaného souboru (mimo bloky BEGIN a END)*<br>
*// ARGIND jen v gawk, FILENAME i v mawk.*<br>
**FILENAME**<br>
**ARGIND**

*# **číslo řádku** v souboru (číslo záznamu od 1)/číslo záznamu celkově*<br>
**FNR**<br>
**NR**

*# načtený řádek*<br>
*// Oddělovač záznamu je z načteného řádku před uložením do $0 odebrán.*<br>
**$0**

*# pole načteného řádku (obecně/příklad)*<br>
**$**{*číslo-pole*}<br>
**$12**

### Ostatní

*# spustit příkaz interpretu „sh“ a vrátit návratovou hodnotu*<br>
**system(**{*řetězec*}**)**

*# komentář*<br>
*// Znak # není interpretován jako začátek komentáře uvnitř řetězců ani literálů regulárních výrazů.*<br>
**#**{*libovolný obsah až do konce řádky*}

## Zaklínadla (výstup, vstup a interakce)

### Příkazy výstupu

**printf(**{*formátovací-řetězec*}[**,**{*parametr*}]...**)** [{*přesměrování-výstupu*}]**;**
**print** [{*přesměrování-výstupu*}]**;**<br>
**print** {*hodnota*}[**,** {*další-hodnota*}]... [{*přesměrování-výstupu*}]**;**

### Uzavření

*# uzavřít soubor otevřený ke čtení či zápisu*<br>
**close(**{*"řetězec/reprezentující/soubor"*}**)**

*# uzavřít čtení výstupu příkazu*<br>
**close(**{*"příkaz"*}**)**



### Výstup (přesměrování)

Poznámky k přesměrování výstupu: Prvním zápisem do souboru, který ještě není otevřen, se tento soubor automaticky otevře pro zápis a zůstane otevřený pro další zápisy, dokud ho neuzavřete funkcí close() nebo do konce programu. Pokud chcete, aby se soubor otevřel pro přidávání na konec (místo aby se původní obsah smazal), použijte místo operátoru „&gt;“ operátor „&gt;&gt;“ (princip je stejný jako v bashi).

*# výstup do souboru (print/printf)*<br>
*// Pro zápis na standardní chybový výstup použijte speciální název souboru "/dev/stderr".*<br>
**print "A:", A &gt; "../seznam.txt";**<br>
**printf("%s: %d\\n", I, POLE[I]) &gt; "hodnoty.txt";**

*# poslat na (standardní) vstup jiného příkazu (print/printf)*<br>
*// Odkazovaný příkaz se spustí v interpretu /bin/sh a svoje vstupy a výstupy zdědí od instance GNU awk, kterou byl spuštěn, pokud je výslovně nepřesměrujete.*<br>
**print** {*parametr*}[**,** {*další parametr*}]... **\|** {*"řetězec s příkazem"*} **;**<br>
**printf(**{*formátovací-řetězec*}[**,**{*parametr*}]...**) \|** {*"řetězec s příkazem"*} **;**<br>

*# poslat na vstup jiného příkazu (příklad)*<br>
**print I, S, "." \| "sort -n";**

*# zapsat do souboru jeden znak (přepsat/připojit)*<br>
**printf("** {*znak*} **") &gt;** {*"řetězec/s/cestou/souboru"*}**)**

### Vstup

*# přečíst řádek ze souboru (do zadané proměnné/do proměnné $0)*<br>
[**if (**]**getline** {*PROMĚNNÁ*} &lt; {*"řetězec/s/cestou/souboru"*}**)** {*tělo příkazu if*}<br>
[**if (**]**getline** &lt; {*"řetězec/s/cestou/souboru"*}**)** {*tělo příkazu if*}

*# přečíst jeden znak ze souboru*<br>
?

*# přečíst celý soubor do zadané proměnné*<br>
**normalni\_RS = RS; RS = "^$";** {*PROMĚNNÁ*} **= "";**<br>
**getline** {*PROMĚNNÁ*} &lt; {*"řetězec/s/cestou/souboru"*}**;**<br>
**RS = normalni\_RS;**<br>
[**close(**{*"řetězec/s/cestou/souboru"*}**);**]

*# načíst řádek z výstupu příkazu*<br>
[**if (**]{*"příkaz"*} **\| getline** [{*PROMĚNNÁ*}]**)** {*tělo příkazu if*}

### Koprocesy


*# zapsat na standardní vstup koprocesu (alternativy)*<br>
{*příkaz print*} **\|&amp;** {*koproces*}**;**

*# přečíst řádek z výstupu koprocesu*<br>
[**if (**]{*koproces*} **\|&amp; getline** [{*PROMĚNNÁ*}]**)** {*tělo příkazu if*}

*# uzavřít jen vstup koprocesu*<br>
*// Po uzavření vstupu koprocesu můžete pouze číst z jeho výstupu. Pokus o další zápis před úplným ukončením koprocesu je fatální chyba.*<br>
**close(**{*koproces*}**, "to");**

*# vyčkat na ukončení koprocesu*<br>
*// Funkce close() v tomto případě vrátí návratovou hodnotu koprocesu vynásobenou 256.*<br>
**close(**{*koproces*}**)**

### Bash

*# vykonat příkaz interpretem „sh“ a vrátit jeho návratovou hodnotu*<br>
**system(**{*řetězec*}**)**

## Zaklínadla (funkce)

### Uživatelské funkce

*# definovat funkci (volitelně s lokálními proměnnými)*<br>
**function** {*název funkce*}**(**[{*první-parametr*}[**,**{*další-parametry*}]...][[**,&blank;&blank;&blank;**{*lokální-proměnná*}[**,** {*další-lokální-proměnná*}]...]]**)** {*blok příkazů*}

### Řetězcové funkce (základní)

*# získat **podřetězec** podle pozice*<br>
*// Pozice v řetězci se v awk číslují od 1!*<br>
**substr(**{*řetězec*}**,** {*počáteční-pozice*}[**,** {*maximální-délka*}]**)**

*# **nahradit** jeden výskyt/N-tý výskyt/všechny výskyty regulárního výrazu*<br>
*V „řetězci k náhradě“ se rozeznává speciální znak „&amp;“, za který se při náhradě dosadí podřetězec, který vyhověl regulárnímu výrazu. Proto je zde nutno znaky \\ a &amp; escapovat zpětnými lomítky.*<br>
**sub(**{*regulární výraz*}**,** {*řetězec-k-náhradě*}[**,** {*proměnná*}]**);**<br>
**gensub(**{*regulární výraz*}**,** {*řetězec-k-náhradě*}**,** {*N*}[**,** {*proměnná*}]**);**<br>
**gsub(**{*regulární výraz*}**,** {*řetězec-k-náhradě*}[**,** {*proměnná*}]**);**

*# najít pozici prvního výskytu **podřetězce***<br>
*// Vrátí 0, nebyl-li podřetězec nalezen; jinak vrátí pozici podřetězce (číslovanou od 1).*<br>
**index(**{*řetězec*}**,** {*hledaný-podřetězec*}**)**

*# zjistit **délku řetězce***<br>
**length(**{*řetězec*}**)**

*# vyhovuje/nevyhovuje regulárnímu výrazu?*<br>
{*řetězec*} **~** {*regulární-výraz*}<br>
{*řetězec*} **!~** {*regulární-výraz*}

*# vyhovuje $0 regulárnímu výrazu?*<br>
*// Tato interpretace se uplatní všude, kde není syntaxí očekávan regulární výraz.*<br>
{*literál-regulárního-výrazu*}

*# najít podřetězec pomocí regulárního výrazu*<br>
*// Vrátí 0, nebyl-li vyhovující podřetězec nalezen. Jinak vrátí pozici podřetězce a nastaví proměnné RSTART a RLENGTH na pozici a délku nalezeného podřetězce. Vždy vrací nejlevější a nejdelší vyhovující podřetězec.*<br>
**match(**{*řetězec*}**,** {*regulární-výraz*}**)**

*# rozdělit řetězec do pole (podle FS/určitým znakem/regulárním výrazem)*<br>
**split(**{*řetězec*}**,** {*pole*}**)**<br>
**split(**{*řetězec*}**,** {*pole*}[**, "**{*znak*}**"**]**)**<br>
**split(**{*řetězec*}**,** {*pole*}[**,** {*regulární-výraz*}]**)**

*# naformátovat řetězec (funkce **sprintf** známá z jazyka C)*<br>
**sprintf(**{*formátovací-řetězec*}[**,** {*parametr*}]...**)**

*# převod na malá písmena/velká písmena*<br>
*// V gawk tyto funkce rozpoznávají znaky národní abecedy (pravděpodobně podle „locale“), v mawk účinkují pouze na ASCII znaky.*<br>
**tolower(**{*řetězec*}**)**<br>
**toupper(**{*řetězec*}**)**

*# sekvence více výskytů téhož znaku v řetězci nahradit jeho jedním výskytem*<br>
?

### Číselné funkce

*# absolutní hodnota*<br>
{*x*} **&gt;= 0 ?** {*x*} **: -**{*x*}

*# zaokrouhlit desetinné číslo na nejbližší celé číslo/k nule/jen oříznout desetinnou část*<br>
{*číslo*} **&gt;= 0 ? int(**{*číslo*} **+ 0.4999999) : int(**{*číslo*} **- 0.4999999)**<br>
{*číslo*} **&gt;= 0 ? int(**{*číslo*}**) : -int(-**{*číslo*}**)**<br>
**int(**{*hodnota*}**)**
<!--
TODO: Test.
-->

*# vygenerovat pseudonáhodné celé číslo 0 &lt;= y &lt; maximum*<br>
*// Vhodné jen pro maxima do 16 777 215. Pro vyšší maximum bude množina vrácených hodnot pravidelně přerušovaná, což pro některé druhy využití nemusí vadit. Správným řešením je bitová kombinace více volání funkce „rand()“.*<br>
**rand() \*** {*maximum*}

*# vygenerovat pseudonáhodné celé číslo 0 &lt;= y &lt; 4 294 967 296*<br>
**65356 \* int(65536 \* rand()) + int(65536 \* rand())**

*# nastavit počáteční „semínko“ generátoru pseudonáhodných čísel (na hodnotu/podle času)*<br>
*// Funkci „srand()“ není nutno volat; počítační semínko je při spuštění gawk či mawk již nastaveno podle času.*<br>
**srand(**{*hodnota-semínka*}**)**<br>
**srand()**

*# vygenerovat pseudonáhodné desetinné číslo 0 &lt;= y &lt; 1*<br>
**rand()**

*# druhá odmocnina/druhá mocnina*<br>
**sqrt(**{*x*}**)**<br>
{*x*}**^2**

*# arcus tangens y / x*<br>
**atan2(**{*y*}**,** {*x*}**)**

*# sinus/kosinus/tangens/contangens*<br>
**sin(**{*x*}**)**<br>
**cos(**{*x*}**)**<br>
**sin(**{*x*}**) / cos(**{*x*}**)**<br>
**cos(**{*x*}**) / sin(**{*x*}**)**

*# přirozený logaritmus / e na x-tou*<br>
**log(**{*x*}**)**<br>
**exp(**{*x*}**)**

### Pokročilé konstrukce

*# implementovat načítání řádků rozdělených znakem \\ před znakem konce řádku (tento kód vložit na začátek skriptu)*<br>
{*proměnná*} **!= "" {$0 =** {*proměnná*}**;** {*proměnná*} **= "";}**<br>
**/(^|[<nic>^\\\\])(\\\\\\\\)\*\\\\$/ {**{*proměnná*} **= substr($0, 1, length($0) - 1); next;}**

## Parametry příkazů
![ve výstavbě](../obrazky/ve-vystavbe.png)

* **-F** {*řetězec*} \:\: nastaví oddělovač vstupních polí (k rozdělení řádků na $1, $2 atd.)
* **-v** {*proměnná*}**=**{*hodnota*} \:\: Před spuštěním nastaví uvedenou proměnnou.


## Instalace na Ubuntu
*# *<br>
**sudo apt-get install gawk**

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
* Pole jsou asociativní a indexy v polích jsou vždy řetězce; při indexování číslem se číslo nejprve převede na řetězec.
* Neexistující prvky...
* Použijete-li literál regulárního výrazu v kontextu, kde není syntaxí přímo očekáván regulární výraz, bude se interpretovat jako test proměnné $0 vůči danému výrazu (tzn. /^a/ jako vzorek je ve skutečnosti zkratkou z „$0 ~ /^a/“). Tato „zkratka“ je velmi často využívána.
* Jak vzorek, tak blok příkazů jsou nepovinné. Uvedete-li vzorek bez bloku příkazů, implicitně se k němu doplní „{print}“; uvedete-li blok příkazů bez vzorku, provede se pro každý řádek.
* Konec řádku normálně končí příkaz; chcete-li pokračovat na dalším řádku, vložte před konec řádku „\\“.
* Hodnoty ARGC a ARGV je možno za běhu skriptu měnit, a tím ovlivňovat, které další soubory gawk či mawk otevře. Na již otevřené soubory to ale nemá vliv.
* Skalární proměnné se do funkcí předávají hodnotou, pole odkazem. Pole však nelze přiřazovat do jiných polí.
* Vstupní i výstupní soubory a příkazy jsou v GNU awk identifikovány řetězci, kterými byly zadány. Soubor otevřete prvním zápisem do něj a uzavře se automaticky po skončení programu, nebo ho můžete uzavřít dřív funkcí „close()“. Uzavřete-li soubor funkcí close(), můžete ho dalším zápisem znovu otevřít, jako byste ho předtím otevřený neměli. Totéž platí u příkazů, ale pozor − funkce close() je u nich blokující, takže GNU awk počká s vykonáváním programu, dokud takto uzavíraný příkaz skutečně neskončí.
* Používání koprocesů vyžaduje pečlivou synchronizaci mezi procesy. Existuje dvě situace, které vedou k zamrznutí programu a musíte se jim vyhnout: 1) Pokus o přečtení řádku z výstupu koprocesu, zatímco koproces nezapisuje, ale sám čeká na další vstup. 2) Zapsání velkého množství dat (cca od desítek kilobajtů) na vstup koprocesu, která koproces nenačte. (V takovém případě se naplní buffer roury.)


## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

Co hledat:

* [stránku na Wikipedii](https://cs.wikipedia.org/wiki/Hlavn%C3%AD_strana)
* oficiální stránku programu
* oficiální dokumentaci
* [manuálovou stránku](http://manpages.ubuntu.com/)
* [balíček Bionic](https://packages.ubuntu.com/)
* online referenční příručky
* různé další praktické stránky, recenze, videa, blogy, ...
* [oficiální manuál od GNU](https://www.gnu.org/software/gawk/manual/) (anglicky)
* [TL;DR stránka](https://github.com/tldr-pages/tldr/blob/master/pages/common/awk.md) (anglicky)

!ÚzkýRežim: vyp

## Pomocné funkce

*# \~/bin/nabufferuj − načte všechny řádky vstupu do paměti a po uzavření vstupu je vypíše nezměněné*<br>
*// Poznámka: má poměrně značnou spotřebu paměti. Vyžaduje cca 8x víc paměti, než kolik dat má uchovat. Pro velké soubory je vhodnější implementace v C++.*<br>
**#!/usr/bin/mawk -f**<br>
**BEGIN {i = 0}**<br>
**{A[++i] = $0}**<br>
**END {for (j = 1; j &lt;= i; ++j) print A[j]}**

<!--
### Pomocné funkce
*# escapovat()*<br>
**function escapovat(s) {gsub(/[\\\\\|.\*+?{}[\\]()\\/^$]/, "\\\\\\\\&amp;", s);return s;}**

*# escapovatknahrade()*<br>
**function escapovatknahrade(s) {gsub(/[\\\\&amp;]/, "\\\\\\\\&amp;", s);return s;}**

Poznámka:
- mawk neumí syntaxi {} v rozšířených regulárních výrazech.
-->
