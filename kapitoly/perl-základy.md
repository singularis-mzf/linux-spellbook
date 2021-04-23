<!--

Linux Kniha kouzel, kapitola Perl: základy
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Perl: základy

!Štítky: {program}{zpracování textu}{syntaxe}{Perl}{programování}
!FixaceIkon: 1754
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod

Perl je skriptovací jazyk určený především pro zpracování textu.
Mezi programátory je velmi oblíbený a rozšířený, má však špatnou pověst,
protože je multisyntaktický a pro neodborníka velmi špatně čitelný.
Přesto je velmi užitečný a při využití jen malé podmnožiny jeho vlastností
je snadné v něm začít programovat.

Perl je ale také zákeřný programovací jazyk, v němž je podmínka „if (false)“
splněna, funkce length() aplikovaná na osmnáctiprvkové pole vrací
hodnotu 2, připojovaný zdrojový soubor musí končit příkazem „1;“,
proměnné se nejčastěji deklarují klíčovým slovem „my“
a příkaz náhrady „s/.$/@/“ provedený nad řetězcem "X\\n\\n\\n"
nikdy neskončí výsledkem "X\\n\\n@" jako v GNU Sedu,
ale jedním z výsledků "X\\n\\n\\n" (bez modifikátoru),
"X\\n@\\n" (s modifikátorem „s“) nebo „X\\n@@“ (s modifikátory „gs“);
ke stejnému chování jako v Sedu ho však nedonutíte.

Kapitoly vanilkové příchuti Linuxu: Knihy kouzel zaměřené na Perl
se omezují na bezpečnou podmnožinu jeho funkcionality, čímž vám umožní začít
z jeho moci těžit velmi rychle a s minimem nutných znalostí a vyhýbat se
přitom většině zákeřných pastí. (Pronikat do „hlubin Perlu“ můžete později.
Nejdřív naprogramujte, co potřebujete.)

Tato kapitola nepokrývá moduly, objektově orientované programování
a velkou část užitečných knihovních funkcí (např. práci s databázemi).

*Poznámka:* Všechna zaklínadla v této kapitole předpokládají,
že máte nainstalovaný balíček DEB Linuxu: Knihy kouzel
a skripty budete spouštět výhradně příkazem „lkk perl“.
Informace, jak takové skripty zprovoznit bez něj, najdete v repozitáři
Linuxu: Knihy kouzel na GitHubu.

## Definice

* **Skalár** je dynamicky typovaná hodnota, která může být řetězec, číslo, ukazatel na nějaký objekt nebo zvláštní **nehodnota undef**. Výchozí hodnotou skalárů je undef. Jednotlivé skaláry se symbolizují znakem „$“.
* **Pole** (array, list) je uspořádaný kontejner skalárů indexovaný celými čísly 0, 1, 2 atd. Pole se symbolizují znakem „@“ a pro přístup k jejich prvkům se používá index (či seznam indexů) v hranatých závorkách „[]“. (Na rozdíl od GNU awk, v Perlu se prvky polí číslují vždy od nuly.) Výchozí hodnotou je prázdné pole.
* **Asociativní pole** (hash) je neuspořádaný kontejner skalárů (**hodnot**) indexovaný libovolnými řetězci (**klíči**). Symbolizuje se znakem „%“. Přístup k prvkům pole se vyznačuje použitím klíče (či seznamu klíčů) ve složených závorkách „{}“. Asociativní pole se inicializují poli či seznamy se sudým počtem prvků, kde se první prvek každé dvojice interpretuje jako klíč a druhý jako odpovídající hodnota. V seznamech se pak asociativní pole na takový seznam rozloží. Výchozí hodnotou je prázdné asociativní pole.

<neodsadit>Je v pořádku mít vedle sebe proměnné „$x“, „@x“ a „%x“ a funkci „x()“, jsou to čtyři nezávislé věci. Konstanty však sdílejí „jmenný prostor“ s funkcemi.

* **Ukazatel** (reference, v češtině obvykle nazývaný „odkaz“) je skalár, který odkazuje na nějaký objekt v paměti (skalár, pole, funkci, regulární výraz atd.). Přístup k odkazovanému objektu se získává **dereferencí** ukazatele. Operace, při kterých ukazatel není výslovně dereferencován, se týkají ukazatele jako takového.
* **Seznam** je dočasný objekt příbuzný poli; zadává se výčtem prvků v kulatých závorkách, např. „(1, $b, 3)“. Kulaté závorky se nepoužijí, pokud je seznam bezprostředně obalen dalšími kulatými nebo hranatými závorkami. V téměř všech kontextech je seznam zaměnitelný s polem — kde se očekává pole, můžete uvést seznam, a naopak kde se očekává seznam, můžete uvést pole.
* Důležitou vlastností seznamů je **zplošťování** — když v seznamu uvedete vnořený seznam, pole nebo asociativní pole, to se obvykle rozvine na všechny svoje prvky v odpovídajícím pořadí, jako byste je uvedl/a přímo. Nespoléhejte se však na zplošťování při volání systémových a knihovních funkcí (může být ovlivněno tzv. prototypem funkce) a v seznamech stojících na levé straně operátoru přiřazení (tam funguje trochu jinak).
* **Proud** je objekt reprezentující soubor na disku nebo rouru vedoucí do jiného procesu. Umožňuje číst či zapisovat data, a to v textovém nebo binárním režimu.
* **Řetězec bajtů** je každý řetězec, který obsahuje jen znaky s kódovou hodnotou 0 až 255. Takový řetězec může být bez konverze zapsán do souboru v binárním režimu. Všechny řetězce načtené v binárním režimu jsou řetězce bajtů.

!ÚzkýRežim: vyp

<!--
==================================================================================
-->
## Zaklínadla: Základní

### Proměnné a konstanty

*# **deklarovat** místní proměnnou typu skalár/pole/asociativní pole*<br>
*// „Místní proměnná“ je viditelná v bloku, kde je deklarována. Inicializuje se při každém průchodu znovu a opuštěním bloku zaniká. Místní proměnná není nikdy viditelná z jiných zdrojových souborů.*<br>
**my $**{*identifikátor*} [**=** {*inicializace*}]**;**<br>
**my @**{*identifikátor*} [**=** {*inicializace*}]**;**<br>
**my %**{*identifikátor*} [**=** {*inicializace*}]**;**

*# deklarovat **trvanlivou** proměnnou*<br>
*// „Trvanlivá proměnná“ je stejně jako místní proměnná viditelná v bloku (popř. zdrojovém souboru), kde je deklarována. Inicializuje se však pouze při prvním průchodu a trvá až do ukončení programu.*<br>
**state** {*$@%*}{*identifikátor*} [**=** {*inicializace*}]**;**

*# deklarovat globální proměnnou*<br>
*// „Globální proměnná“ je viditelná v celém programu (ve všech zdrojových souborech, a to i v případě, že je deklarovaná uvnitř definice funkce), inicializuje se při prvním průchodu a trvá až do ukončení programu.*<br>
**our** {*$@%*}{*identifikátor*} [**=** {*inicializace*}]**;**

*# deklarovat **konstantu** typu skalár/seznam*<br>
*// Poznámka: kvůli omezením Perlu je každá konstanta globální v rámci jmenného prostoru a viditelná i z ostatních zdrojových souborů. V její inicializaci může být obecný výraz, ale bude vyhodnocován v době překladu, takže je omezeno, co může obsahovat. Může však obsahovat již dříve definované konstanty.*<br>
**use constant** {*identifikátor*} **=&gt;** {*inicializace*}**;**<br>
**use constant** {*identifikátor*} **=&gt; (**{*inicializace*}**);**

*# do konce bloku **překrýt** globální proměnnou*<br>
*// Příkaz „local“ způsobí, že v paměti vznikne nový objekt příslušného typu a uvedená globální proměnná se na něj dočasně „přesměruje“, takže veškeré odkazy na danou globální proměnnou (i uvnitř volaných knihovních funkcí) budou přistupovat k novému objektu místo k tomu původnímu. Do původního stavu se proměnná vrátí po opuštění bloku kódu, v němž byla deklarací „local“ překryta.*<br>
**local** {*$@%*}{*identifikátor*} **=** {*nová-hodnota*}**;**

### Skaláry a undef

*# má skalár hodnotu? (tzn. **není undef**)*<br>
**defined(**{*$skalár*}**)**

*# **přečíst** skalární proměnnou*<br>
**$**{*identifikátor*}

*# **přiřadit** skalární proměnné hodnotu/undef*<br>
**$**{*identifikátor*} **=** {*hodnota*}<br>
**$**{*identifikátor*} **= undef**

*# přečíst skalární **konstantu** (obecně/příklady)*<br>
*// Závorky kolem identifikátoru konstanty můžete vynechat tehdy, když je obalený jinými kulatými závorkami; nesmíte je vynechat v případě, že je obalený složenými či hranatými závorkami!*<br>
**(**{*identifikátor*}**)**<br>
**printf("Hodnota konstanty je: %d\\n", (konstanta));**<br>
**print(konstanta);**<br>
**printf("V asoc. poli je %s\\n", $asocPole{(konstanta)});**

*# zjistit **typ** skaláru*<br>
*// Vracené typy jsou: u = undef, s = číslo či řetězec, S = ukazatel na skalár, A = ukazatel na pole, H = ukazatel na asociativní pole, C = ukazatel na funkci („kód“), R = ukazatel na regulární výraz, F = ukazatel na vstupně/výstupní proud a "&lt;Název::Třídy&gt;" pro ukazatele na objekty tříd (dosadí se název třídy).*<br>
**typy(**{*$skalár*}**)** ⊨ "s"

*# vrátit první ze skalárů, který má hodnotu*<br>
*// Operátor „//“ se vyhodnocuje postupně. To znamená, že pokud výraz na jeho levé straně není undef, výraz na pravé straně se již nevyhodnotí. To umožňuje ho využít v kombinaci např. s funkcí „die()“.*<br>
{*skalár*} [**//** {*další-skalár*}]...

### Volání funkcí

*# **zavolat** funkci (obecně/příklady)*<br>
*// Poznámka: při volání uživatelské funkce se závorky interpretují jako seznam, proto v něm dochází ke zplošťování. Tomu lze zabránit pomocí tzv. prototypů, proto k němu u vestavěných a některých knihovních funkcí nedochází. To vám umožňuje např. funkci „push“ předat přímo pole, aniž by se zploštilo.*<br>
{*identifikátor\_funkce*}**(**{*seznam,parametrů*}**)**<br>
**funkce()**<br>
**funkce(1, $b, undef, 3)**

*# zavolat funkci přijímající blok příkazů (obecně)*<br>
*// Pozor! Předávaný blok příkazů se chová jako samostatná funkce (dostává parametry v poli @ARG a vrací hodnotu), až na příkaz „return“. Ten v tomto bloku NIKDY nepoužívejte! Návratovou hodnotou bloku bude hodnota posledního provedeného příkazu. Pokud blok obsahuje jen jeden krátký příkaz, můžete volání zapsat na jednu řádku.*<br>
**(**{*identifikátor\_funkce*} **\{**<br>
<odsadit1>{*příkaz bloku;*}...<br>
**\}** [{*seznam,parametrů*}]...**)**

*# zavolat funkci přijímající blok příkazů (příklad)*<br>
**my @hodnoty = (map \{**<br>
<odsadit1>**$ARG + 1;**<br>
**\} @část1, -1, @část2);**

*# předat řízení do funkce*<br>
*// Tento příkaz předá řízení přímo na začátek uvedené funkce, jako by byla volána místo funkce právě prováděné. Všechny lokální proměnné jsou před voláním zrušeny a pole @ARG bude předáno tak, jak právě je (včetně případných změn, které v něm stávající funkce provedla).*<br>
**goto &amp;**{*identifikátor\_funkce*}**;**

### Definice funkcí

*# **definovat** funkci*<br>
*// Funkce nemusí být definovaná před prvním použitím, ale pokud má prototyp, ten musí být před prvním použitím znám.*<br>
**sub** {*identifikátor\_funkce*} [**(**{*prototyp*}**)**]<br>
**\{**<br>
<odsadit1>[**typy(@ARG) =~ /\\A**{*regulární-výraz*}**\\z/ or croak(**{*"chybové hlášení"*}**);**]<br>
<odsadit1>[{*příkazy*}]...<br>
**\}**

*# definovat funkci vracející přiřaditelný objekt*<br>
*// Funkce definovaná s modifikátorem „lvalue“ musí vrátit přiřaditelný skalár (proměnnou, prvek pole či hodnotu v asociativním poli). Nemůže vracet pole, undef apod.*<br>
**sub** {*identifikátor\_funkce*} [**(**{*prototyp*}**)**] **: lvalue**<br>
**\{**<br>
<odsadit1>[**typy(@ARG) =~ /\\A**{*regulární-výraz*}**\\z/ or croak(**{*"chybové hlášení"*}**);**]<br>
<odsadit1>[{*příkazy*}]...<br>
**\}**

*# pole **parametrů** uvnitř definice funkce*<br>
*// Na rozdíl od normálních polí, prvky tohoto speciálního pole se do funkce předávají odkazem. To znamená, že přímým přiřazením do prvků tohoto pole můžete změnit proměnné (popř. prvky pole či hodnoty asociativního pole), které byly při volání funkce zadány. Pokud bylo daným parametrem funkce něco nepřiřaditelného, takové přiřazení se bude tiše ignorovat.*<br>
**@ARG**

*# deklarovat prototyp funkce před definicí*<br>
**sub** {*identifikátor\_funkce*} **(**{*prototyp*}**);**

*# definovat funkci přijímající blok příkazů*<br>
*// Předaný blok zavoláte jako funkci příkazem „$id-&gt;(parametry)“, kde id je zvolený identifikátor proměnné. Parametry (volitelné) předané volání bloku jsou v definici předaného bloku přístupné v poli @ARG.*<br>
^^**sub** {*identifikátor\_funkce*} **(&amp;@);**<br>
**sub** {*identifikátor\_funkce*} **(&amp;@)**<br>
**\{**<br>
<odsadit1>[**typy(@ARG) =~ /\\AC**{*regulární-výraz*}**\\z/ or croak(**{*"chybové hlášení"*}**);**]<br>
<odsadit1>**my $**{*id*} **= shift(@ARG);**<br>
<odsadit1>[{*příkazy*}]...<br>
**\}**

### Komentáře

*# **komentář** do konce řádku*<br>
[{*normální obsah řádky*}] **#** {*obsah komentáře*}

*# víceřádkový komentář*<br>
*// Pozor, před znakem „=“ na uvedených speciálních řádcích nesmí být žádný jiný znak, ani odsazení! Víceřádkové komentáře nelze zanořovat.*<br>
**=begin&blank;comment**<br>
{*obsah komentáře (i víc řádků)*}<br>
**=end&blank;comment**<br>
**=cut**

### Volání příkazů /bin/sh

*# zavolat **příkaz** interpretu /bin/sh (obecně/příklad)*<br>
*// Část „&gt;&gt; 8“ je nutná v případě, kdy vás zajímá návratový kód procesu. Ten je totiž v návratové hodnotě funkce vynásoben hodnotou 256 (tedy bitově posunut o 8 bitů doleva). Poznámka: funkce „system()“ vám neumožňuje zapisovat na vstup procesu nebo číst z jeho výstupu. K těmto účelům použijte roury popsané v sekci „Zaklínadla: Vstup/výstup“.*<br>
**system(**{*"text příkazů"*}**);**<br>
**system("x=3; x=\\$((x + 1)); echo \\$x");**<br>
!: Návratový kód procesu získáte jako „($CHILD\_ERROR &gt;&gt; 8)“.

*# \+ zachytit jeho std. výstup **po řádkách** do pole*<br>
[**my** {*@výstup*} **=**] **do {use open("IN", ":utf8"); local $RS = "\\n"; my @x = array(readpipe(**{*"text příkazů"*}**)); chomp(@x); @x;};**<br>
!: Návratový kód procesu získáte jako „($CHILD\_ERROR &gt;&gt; 8)“.

*# \+ zachytit jeho std. výstup do **jednoho řetězce***<br>
[**my** {*$výstup*} **=**] **do {use open("IN", ":utf8"); local $RS = undef; scalar(readpipe(**{*"text příkazů"*}**));};**<br>
!: Návratový kód procesu získáte jako „($CHILD\_ERROR &gt;&gt; 8)“.

*# \+ zachytit jeho std. výstup **binárně** do řetězce bajtů*<br>
[**my** {*$výstup*} **=**] **do {use open("IN", ":raw"); local $RS = undef; scalar(readpipe(**{*"text příkazů"*}**));};**<br>
!: Návratový kód procesu získáte jako „($CHILD\_ERROR &gt;&gt; 8)“.

*# \+ zachytit jeho std. výstup textově po záznamech ukončených „\\0“ do pole*<br>
[**my** {*@výstup*} **=**] **do {use open("IN", ":utf8"); local $RS = "\\x{0}"; my @x = array(readpipe(**{*"text příkazů"*}**)); chomp(@x); @x;};**<br>
!: Návratový kód procesu získáte jako „($CHILD\_ERROR &gt;&gt; 8)“.

*# \+ zachytit jeho std. výstup do pole **obecně***<br>
*// Ohledně nastavení oddělovače — viz poznámku pod čarou týkající se speciální proměnné $RS.*<br>
[**my** {*@výstup*} **=**] **do {use open("IN",** {*":režim-čtení"*} **); local $RS =** {*nastavení-oddělovače*}**; my @x = array(readpipe(**{*"text příkazů"*}**)); chomp(@x); @x;};**<br>
!: Návratový kód procesu získáte jako „($CHILD\_ERROR &gt;&gt; 8)“.

### Operace s čísly

*# **dělení** (celočíselné/reálné/příklad celočíselného)*<br>
*// Funkce „div“ (z balíčku LinuxKnihaKouzel.pl) provede celočíselné dělení absolutních hodnot zadaných čísel a vrací dvojici (výsledek, zbytek); výsledek z ní získáte přečtením prvku s indexem 0.*<br>
**(div(**{*dělenec*}**,** {*dělitel*}**))[0]**<br>
{*dělenec*} **/** {*dělitel*}<br>
**my ($podíl, $zbytek) = div(5, 2);** ⊨ (2, 1)

*# absolutní hodnota*<br>
**abs(**{*skalár*}**)**

*# **zaokrouhlit** na nejbližší celé číslo*<br>
^^**use POSIX;**<br>
{*x*} **&gt;= 0 ? POSIX::floor(0.5 +** {*x*}**) : -POSIX::floor(0.5 -** {*x*}**)**

*# zaokrouhlit k nule*<br>
**int(**{*skalár*}**)**

*# vygenerovat **pseudonáhodné** celé číslo 0 ≤ y &lt; maximum*<br>
**int(rand() \*** {*maximum*}**)**

*# vygenerovat pseudonáhodné celé číslo 0 ≤ y &lt; 4 294 967 296*<br>
**int(rand() \* 4294967296)**

*# nastavit počáteční „semínko“ generátoru pseudonáhodných čísel (na hodnotu/podle času)*<br>
**srand(**{*x*}**);**<br>
**srand(time());**

*# druhá **odmocnina**/druhá mocnina*<br>
**sqrt(**{*x*}**)**<br>
{*x*} **\*\* 2**

*# arcus tangens y / x*<br>
**atan2(**{*y*}**,** {*x*}**)**

*# sinus/konsinus/tangens/cotangens*<br>
**sin(**{*x*}**)**<br>
**cos(**{*x*}**)**<br>
**sin(**{*x*}**) / cos(**{*x*}**)**<br>
**cos(**{*x*}**) / sin(**{*x*}**)**

*# přirozený logaritmus/e na x-tou*<br>
**log(**{*x*}**)**<br>
**exp(**{*x*}**)**

### Speciální proměnné

*# řetězec vkládaný funkcí „**print**“ mezi argumenty/za poslední argument*<br>
*// Výchozí hodnota obou proměnných je nehodnota undef, která zde má stejný význam jako prázdný řetězec.*<br>
**$OFS** ⊨ undef<br>
**$ORS** ⊨ undef

*# vstupní **ukončovač** záznamu*<br>
*// Jako ukončovač lze nastavit libovolný řetězec. Existují dva zvláštní případy: nastavení na prázdný řetězec způsobí, že jako ukončovač bude rozpoznána jakákoliv posloupnost dvou nebo více znaků \\n; nehodnota undef způsobí, že vstup nebude dělený na záznamy a rovnou se načte celý zbytek vstupního souboru.*<br>
**$RS** ⊨ "\\n"

*# **verze** Perlu (jen čtení)*<br>
**$PERL\_VERSION** ⊨ "v5.30.0"

*# pole parametrů skriptu (obecně/příklad použití)*<br>
*// Na rozdíl od Bashe toto pole neobsahuje nultý parametr (název skriptu). Jsou to opravdu jen parametry předané skriptu na příkazové řádce.*<br>
**@ARGV**<br>
**my $parametr1 = $ARGV[0];**

*# pole proměnných **prostředí** (obecně/příklad použití)*<br>
*// Přiřazením je možno proměnné prostředí vytvářet a měnit.*<br>
**%ENV**<br>
**$ENV{"HOME"}** ⊨ "/home/petr"

*# **PID**/PPID procesu (jen čtení)*<br>
**$PID** ⊨ 4485<br>
**getppid()** ⊨ 3010

*# návratová hodnota procesu (jen čtení)*<br>
*// Podle dokumentace se hodnota této proměnné nastavuje při uzavření roury funkcí „close()“, při úspěšném ukončení funkcí „wait()“ a „waitpid()“ a při ukončení funkcí „readpipe()“ a „system()“.*<br>
**$CHILD\_ERROR &gt;&gt; 8**

*# Označení souboru se zdrojovým kódem (jen čtení)*<br>
*// Tato proměnná je určena především pro ladění; raději se příliš nespoléhejte na konkrétní tvar, který vám vrátí.*<br>
**\_\_FILE\_\_** ⊨ "soubor.pl"

*# Číslo řádky ve zdrojovém kódu (jen čtení)*<br>
**\_\_LINE\_\_** ⊨ 351

*# UID uživatele (jen čtení)*<br>
**$UID** ⊨ 1000

*# časová známka okamžiku spuštění skriptu (jen čtení)*<br>
**$BASETIME** ⊨ 1605871925

<!--
==================================================================================
-->
## Zaklínadla: Řízení toku

### Podmínky

*# provést blok příkazů, je-li **podmínka** pravdivá/nepravdivá*<br>
**if (**{*podmínka*}**) \{** [{*příkazy*}] **\}** [**elsif (**{*další podmínka*}**) \{** [{*příkazy*}] **\}**]... [**else \{** [{*příkazy*}] **\}**]<br>
**unless (**{*podmínka*}**) \{** [{*příkazy*}] **\}** [**elsif (**{*další podmínka*}**) \{** [{*příkazy*}] **\}**]... [**else \{** [{*příkazy*}] **\}**]

*# provést **příkaz**, je-li podmínka pravdivá (alterantivy)*<br>
{*podmínka*} **and** {*příkaz*}**;**<br>
{*příkaz*} **if (**{*podmínka*}**);**

*# provést příkaz, je-li podmínka nepravdivá (alterantivy)*<br>
{*podmínka*} **or** {*příkaz*}**;**<br>
{*příkaz*} **unless (**{*podmínka*}**);**

### Cykly

*# cyklus **for** (s definicí vlastní proměnné/obecný)*<br>
[{*návěští*}**:**] **for (my $**{*identifikátor*} **=** {*výraz*}**;** [{*podmínka*}]**;** [{*výraz-iterace*}]**) \{** [{*příkazy*}] **\}**<br>
[{*návěští*}**:**] **for (**[{*výraz-inicializace*}]**;** [{*podmínka*}]**;** [{*výraz-iterace*}]**) \{** [{*příkazy*}] **\}**

*# cyklus **foreach** (obecně/příklady)*<br>
[{*návěští*}**:**] **foreach** [**my**] **$**{*identifikátor*} **(**{*seznam*}**) \{** [{*příkazy*}] **\}** [**continue \{** [{*další příkazy*}] **\}**]<br>
**foreach my $x (1, 2, 3) { printf("Číslo %d.\\n", $x); }**<br>
**foreach my $x (@ARG) { printf("%s\\n", $x); }**

*# cyklus typu **while** (s pozitivní podmínkou/negovanou podmínkou)*<br>
[{*návěští*}**:**] **while (**{*podmínka*}**) \{** [{*příkazy*}] **\}** [**continue \{** [{*další příkazy*}] **\}**]<br>
[{*návěští*}**:**] **until (**{*podmínka*}**) \{** [{*příkazy*}] **\}** [**continue \{** [{*další příkazy*}] **\}**]

*# cyklus s podmínkou uprostřed*<br>
[{*návěští*}**:**] **\{**<br>
<odsadit1>[{*příkazy*}]<br>
<odsadit1>**last** [{*návěští*}] **unless (**{*podmínka pokračování*}**);**<br>
<odsadit1>[{*příkazy*}]<br>
<odsadit1>**redo;**<br>
**\}**

*# cyklus typu **do...while** (s pozitivní podmínkou/negovanou podmínkou)*<br>
**do \{** [{*příkazy*}] **\} while (**{*podmínka*}**);**<br>
**do \{** [{*příkazy*}] **\} while (!(**{*podmínka*}**));**

*# **nekonečný** cyklus*<br>
[{*návěští*}**:**] **\{**<br>
<odsadit1>[{*příkazy*}]<br>
<odsadit1>**redo;**<br>
**\}**

### Skoky

Poznámka k příkazům „last“, „next“ a „redo“: neoznačený blok příkazů „{}“
se v Perlu považuje za cyklus a tyto příkazy se na něj vztahují!

*# vyskočit z funkce a **vrátit** návratovou hodnotu*<br>
*// Příkaz „return“ v Perlu není povinný. Při jeho nepoužití vrátí Perl hodnotu posledního provedeného příkazu ve funkci.*<br>
**return** {*návratová hodnota*}**;**

*# vyskočit za **konec cyklu***<br>
**last** [{*návěští*}]**;**

*# **ukončit** program*<br>
**exit(**[{*návratový-kód*}]**);**

*# ukončit program s hlášením kritické chyby v tomto místě/ve volající funkci*<br>
**die("**{*text*}**");**<br>
**croak("**{*text*}**");**

*# skočit těsně před uzavírací závorku cyklu*<br>
**next** [{*návěští*}]**;**

*# **pozdržet** program o daný počet sekund*<br>
**my $**{*pomocnáProměnná*} **=** {*N*}**;**<br>
**while (($**{*pomocnáProměnná*} **-= sleep($**{*pomocnáProměnná*}**)) &gt; 0) {}**

*# skočit přímo za otevírací závorku cyklu*<br>
**redo** [{*návěští*}]**;**

*# skočit na návěští (**goto**)(pevně dané/dynamicky určené)*<br>
**goto** {*návěští*}**;**<br>
**goto** {*skalární\_výraz*}**;**

*# návěští pro příkaz goto*<br>
*// Poznámka: jeden příkaz může být označen více návěštími.*<br>
{*identifikátor*}**:** {*návěštím označený příkaz*}

### Přepínač typu switch

Poznámka: Perl nenabízí žádnou konstrukci, která by fungovala jako plnohodnotný přepínač
s propadáním přes větve, použitím jedné větve pro více hodnot a větví „default“
a vynucovala konstantnost a jedinečnost hodnot pro jednotlivé větve.
Nabízí sice několik možností, jak dosáhnout
stejného chování, ale všechny kromě asociativního pole ukazatelů na funkce
se vnitřně chovají jako sekvence if-else-if. Většina použití příkazu „switch“
však může být rozumně nahrazena inteligentním použitím asociativních polí.

*# přepínač bez propadání (řetězcové porovnání)*<br>
**my %switch;**<br>
[**$switch\{**{*hodnota*}**\} = sub \{**{*kód*}**\};**]...<br>
[**$switch\{**{*hodnota*}**\} = $switch\{**{*dříve-definovaná-hodnota*}**\};**]...<br>
**my $default = sub \{**{*blok-default*}**\};**<br>
**\{**<br>
<odsadit1>**my $switch =** {*testovaný výraz*}**;**<br>
<odsadit1>**($switch{$switch} // $default)-&gt;($switch);**<br>
**\}**

*# příklad použití*<br>
**my $stdin = \\\*STDIN;**<br>
**my $s = scalar(readline($stdin));**<br>
**chomp($s);**<br>
**my %switch;**<br>
**$switch{"abc"} = sub {printf("Bylo ABC.\\n")};**<br>
**$switch{"xyz"} = sub {printf("Bylo XYZ.\\n")};**<br>
**$switch{"ABC"} = $switch{"abc"};**<br>
**$switch{"XYZ"} = $switch{"xyz"};**<br>
**my $default = sub {printf("Nebylo nic z toho.\\n")};**<br>
**\{**<br>
<odsadit1>**my $switch = $s;**<br>
<odsadit1>**($switch{$switch} // $default)-&gt;($switch);**<br>
**\}**

<!--
*# simulovat přepínač s propadáním, bez větve default*<br>
[{*návěští*}**:**] **\{**<br>
<odsadit1>**my $příznak = 0;**<br>
<odsadit1>**my $switch =** {*testovaný výraz*}**;**<br>
[[**$příznak = $příznak \|\| $switch eq** {*hodnota*}**;**]...<br>
[**if ($příznak) \{** [{*příkazy*}] <nic>[**last;**] **\}**]...]...<br>
**\}**

*# simulovat přepínač s propadáním a větví default*<br>
[{*návěští*}**:**] **\{**<br>
<odsadit1>**my $příznak = 0;**<br>
<odsadit1>**my $switch =** {*testovaný výraz*}**;**<br>
<odsadit1>[[**$příznak = $příznak \|\| $switch eq** {*hodnota*}**;**]...<br>
<odsadit1>[**default:**]<br>
<odsadit1>[**if ($příznak) \{** [{*příkazy*}] <nic>[**last;**] **\}**]...]...<br>
<odsadit1>**unless ($příznak) {$příznak = 1; goto default;}**<br>
**\}**

*# **příklad***<br>
**můjswitch: \{**<br>
<odsadit1>**my $příznak = 0;**<br>
<odsadit1>**my $switch = $s;**<br>
<odsadit1>**$příznak = $příznak \|\| $switch eq "ABC";**<br>
<odsadit1>**$příznak = $příznak \|\| $switch eq "abc";**<br>
<odsadit1>**if·($příznak)·\{**<br>
<odsadit2>**printf("Bylo to ABC.\\n");**<br>
<odsadit2>**last;**<br>
<odsadit1>**\}**<br>
<odsadit1>**$příznak = $příznak \|\| $hodnota eq "xyz";**<br>
<odsadit1>**if ($příznak) \{**<br>
<odsadit2>**printf("Bylo to XYZ.\\n");**<br>
<odsadit2>**last;**<br>
<odsadit1>**\}**<br>
**\}**
-->

<!--
==================================================================================
-->
## Zaklínadla: Řetězce a regulární výrazy

### Základní operace

*# **spojit** řetězce/pole na řetězec*<br>
{*$řetězec*} **.** {*$další\_řetězec*} [**.** {*$ještě\_další\_řetězec*}]<br>
**join("**[{*oddělovač*}]**",** {*pole-a-seznamy*}**)**

*# zjistit **délku** řetězce ve znacích*<br>
**length(**{*$skalár*}**)** ⊨ 12

*# jsou/nejsou si řetězce **rovny**?*<br>
{*řetězec1*} **eq** {*řetězec2*}<br>
{*řetězec1*} **ne** {*řetězec2*}

*# formátovat parametry na řetězec funkcí **sprintf**()*<br>
**sprintf(**{*formát*}**,** {*seznam, parametrů*}**)**

*# jsou si řetězce rovny až na velikost písmen?*<br>
**fc(**{*řetězec1*}**) eq fc(**{*řetězec2*}**)**

*# **kódové** číslo Unicode prvního/N-tého znaku řetězce*<br>
**ord(**{*řetězec*}**)** ⊨ 382<br>
**ord(substr(**{*řetězec*}**,** {*N-1*}**, 1))**

*# **zopakovat** řetězec (obecně/příklad)*<br>
{*řetězec*} **x** {*počet*}<br>
**"abc" x 3** ⊨ "abcabcabc"

*# řetězec na malá/velká písmena*<br>
**lc(**{*řetězec*}**)** ⊨ "žluťoučký kůň"<br>
**uc(**{*řetězec*}**)** ⊨ "ŽLUŤOUČKÝ KŮŇ"

*# obrátit pořadí znaků v řetězci*<br>
**scalar(reverse(**{*řetězec*}**))** ⊨ adeceba

*# zjistit počet bajtů po zakódování do UTF-8*<br>
^^**use Encode;**<br>
**length(Encode::encode("UTF-8",** {*řetězec*}**))**

### Dělení na podřetězce

*# získat **podřetězec** (obecně/max. délka zleva/max. délka zprava)*<br>
*// Počáteční index může být i záporný; v takovém případě se k němu před použitím přičte délka řetězce. Výsledný interval daný počátečním indexem a maximální délkou se musí s pozicemi existujícími v řetězci alespoň dotýkat, pokud bude zcela mimo řetězec, funkce vypíše varování a vrátí undef. Maximální délka se vždy počítá od zadané pozice, ne od skutečného začátku řetězce, proto např. „substr("AB", -3, 2)“ vrátí pouze "A".*<br>
**substr(**{*řetězec*}**,** {*počáteční-index*}[**,** {*maximální-délka*}]**)**<br>
**substr(**{*řetězec*}**, 0,** {*maximální-délka*}**)**<br>
{*maximální-délka*} **&gt; 0 ? substr(**{*řetězec*}**, -**{*maximální-délka*}**) : ""**

*# odebrat z proměnné ukončovač záznamu*<br>
*// Odebere z konce řetězce v proměnné ukončovač podle nastavení speciální proměnné $RS. Velmi často se používá po načtení řádky. Pokud řetězec ukončovačem nekončí, proměnná zůstane nezměněná.*<br>
**chomp(**{*$proměnná*}**);**

*# **rozdělit** řetězec na pole (obecně/příklady)*<br>
*// Pozor: pokud regulární výraz oddělovače obsahuje záchyty, příkaz „split“ pro každý záchyt vloží na dané místo výstupního pole navíc řetězec s textem záchytu; pokud daný záchyt nebyl použit, vloží se tam undef. Podrobnější vysvětlení v dokumentaci funkce „split“.*<br>
[{*@pole*} **=**] **split(/**{*reg-výraz-oddělovač*}**/,** {*dělený-řetězec*}[**,** {*maximální-počet-dílů*}]**)**<br>
**@pole = split(/:/, $s);**<br>
**@pole = split(/[:;]/, $s);**<br>
**my $odd = "@\*\\\\"; @pole = split(/\\Q${odd}\\E/, $s);**

*# vyjmout z řetězce v proměnné **poslední znak** (obecně/příklad)*<br>
*// Pro prázdný řetězec vrací funkce chop() prázdný řetězec a proměnnou nezmění. Podle dokumentace funkce „chop()“ nevyžaduje okopírování celého řetězce, takže může být použita v cyklu pro zpracování řetězce znak po znaku.*<br>
**chop(**{*$proměnná*}**)**<br>
**my $x = "abe"; printf("1: %s ", chop($x)); printf("2: %s\\n", chop($x));** ⊨ 1: e 2: b

*# rozdělit řetězec na **poloviny***<br>
**(substr(**{*$skalár*}**, 0, length(**{*$skalár*}**) / 2), substr(**{*$skalár*}**, length(**{*$skalár*}**) / 2))**

*# rozdělit řetězec na pole **jednotlivých** znaků*<br>
[{*@pole*} **=**] **split("",** {*řetězec*}**)**

### Literály řetězců

*# řetězcový **literál** (alternativy)*<br>
*// Ve dvojitých uvozovkách jsou zvláštními znaky „\\“, „$“, „@“ a „"“, všechny lze odzvláštnit zpětným lomítkem. Navíc se tam intepretují některé sekvence začínající zpětným lomítkem a písmenem (např. „\\n“).  V apostrofech je zvláštním znakem pouze apostrof a odzvláštnění není možné. Konec řádky může být obsažen v obou druzích literálů bez odzvláštnění.*<br>
**"**{*text*}**"**<br>
**'**{*text*}**'**

*# řetězec: dvojitá uvozovka, tabulátor a \\n*<br>
**"**{*...*}**\\"\\t\\n**{*...*}**"**

*# nulový bajt*<br>
*// Můžete sice použít i „\\0“, ale ne, pokud by za ním měla následovat číslice. „\\01“ totiž vygeneruje bajt s hodnotou 1, ne nulový bajt a číslici 1.*<br>
**"**{*...*}**\\x{0}**{*...*}**"**

*# znak Unicode podle kódového čísla (obecně/příklady)*<br>
**"**{*...*}**\\x\{**{*hexčíslo*}**\}**{*...*}**"**<br>
**"\\x{017e}"** ⊨ "ž"<br>
**"\\x{1f642}"**

*# prázdný řetězec*<br>
**""**

*# získat ukazatel na skalární objekt (obecně/příklad)*<br>
**\\(**{*řetězec*}**)**<br>
**my $ukazatel = \\("Hello, world.\\n");**

*# interpolovat skalární proměnnou*<br>
**"**{*...*}**$\{**{*identifikátor*}**\}**{*...*}**"**

*# interpolovat prvky pole*<br>
*// Pozor, výchozí oddělovač je mezera. Chcete-li interpolovat prvky pole bez oddělení, musíte do proměnné $LIST\_SEPARATOR nastavit prázdný řetězec.*<br>
[[**local**] **$LIST\_SEPARATOR = "**{*oddělovač*}**";**]<br>
**"**{*...*}**@\{**{*identifikátor*}**\}**{*...*}**"**

### Literály regulárních výrazů

*# získat ukazatel na regulární výraz*<br>
**qr/**{*regulární výraz*}**/**[{*příznaky*}]

*# regulární výraz přímo (jen v určitých kontextech)*<br>
**/**{*regulární výraz*}**/**

*# interpolovat do regulárního výrazu: dynamický regulární výraz/doslovný řetězec/reg. výraz z ukazatele*<br>
**qr/**{*...*}**$\{**{*identifikátor\_skalární\_proměnné*}**\}**{*...*}**/**<br>
**qr/**{*...*}**\\Q$\{**{*identifikátor\_skalární\_proměnné*}**\}\\E**{*...*}**/**<br>
**qr/**{*...*}**$\{**{*identifikátor\_skalární\_proměnné*}**\}**{*...*}**/**

### Najít (regulární výrazy a podřetězce)

Poznámka: funkce next\_match\_\*() hledají shodu s regulárním výrazem v podřetězci vymezeném parametry „počáteční-index“ a „délka-hledání“ (jsou-li zadány); všechny indexy vracené těmito funkcemi jsou ale platné v původním prohledávaném řetězci. Pokud další shodu nenajdou, vrátí místo každého indexu či délky nehodnotu undef.

*# **má/nemá** shodu s regulárním výrazem?*<br>
{*řetězec*} **=~** {*/regulární výraz/*}[**i**]<nic>[**m**]<br>
{*řetězec*} **!~** {*/regulární výraz/*}[**i**]<nic>[**m**]

*# index začátku prvního/posledního výskytu **podřetězce***<br>
*// Nebyl-li podřetězec nalezen, funkce vrací -1. Limit u funkce „rindex()“ znamená, že budou ignorovány výskyty podřetězce, které začínají na vyšším indexu, než je uvedený limit.*<br>
**index(**{*řetězec*}**,** {*podřetězec*} [**,**{*index-začátku-vyhledávání*}]**)**<br>
**rindex(**{*řetězec*}**,** {*podřetězec*} [**,**{*limit*}]**)**

*# najít následující shodu s regulárním výrazem (ze shody vrátit: začátek a délku/index začátku/index za koncem/text/délku)*<br>
*// Pokud další shoda nebyla nalezena, funkce vrací undef, resp. next\_match() vrací (undef, undef).*<br>
[**(**{*$začátek*}**,** {*$délka*}**) =**] **next\_match(**{*řetězec*}**, qr/**{*regulární výraz*}**/**[**,** {*počáteční-index*}[**,** {*délka-hledání*}]]**)**<br>
**next\_match\_begin(**{*řetězec*}**, qr/**{*regulární výraz*}**/**[**,** {*počáteční-index*}[**,** {*délka-hledání*}]]**)**<br>
**next\_match\_end(**{*řetězec*}**, qr/**{*regulární výraz*}**/**[**,** {*počáteční-index*}[**,** {*délka-hledání*}]]**)**<br>
**next\_match\_text(**{*řetězec*}**, qr/**{*regulární výraz*}**/**[**,** {*počáteční-index*}[**,** {*délka-hledání*}]]**)**<br>
**next\_match\_length(**{*řetězec*}**, qr/**{*regulární výraz*}**/**[**,** {*počáteční-index*}[**,** {*délka-hledání*}]]**)**

*# získat číslované **záchyty** následující shody s regulárním výrazem*<br>
*// Nebyla-li další shoda nalezena, vráceno bude prázdné pole. V ostatních případech je záchytem [0] shoda jako celek a počínaje indexem [1] jednotlivé záchyty ze závorek. Všechny záchyty se vracejí ve formě ukazatele na dvouprvkové pole (index začátku, délka záchytu).*<br>
[{*@pole*} **=**] **next\_match\_captures(**{*řetězec*}**, qr/**{*regulární výraz*}**/**[**,** {*počáteční-index*}[**,** {*délka-hledání*}]]**)**

*# **počet** shod*<br>
**alength(matches(**{*řetězec*}**, qr/**{*regulární výraz*}**/**[**,** {*počáteční-index*}[**,** {*délka-hledání*}]]**))** ⊨ 0

*# najít **pole** všech shod s regulárním výrazem*<br>
*// Shody se vracejí ve formě ukazatele na dvouprvkové pole (index začátku, délka shody).*<br>
[{*@pole*} **=**] **matches(**{*řetězec*}**, qr/**{*regulární výraz*}**/**[**,** {*počáteční-index*}[**,** {*délka-hledání*}]]**)**

*# **příklad**: vypsat všechny shody v řetězci*<br>
**my $řetězec = "abcxyzabcxyz-axc";**<br>
**my $i = 0;**<br>
**my @x;**<br>
**while (defined((@x = next\_match($řetězec, qr/a.c/, $i))[0])) \{**<br>
<odsadit1>**printf("(%d, %d) = \\"%s\\"\\n", @x, substr($řetězec, $x[0], $x[1]));**<br>
<odsadit1>**$i = $x[0] + max(1, $x[1]);**<br>
**\}**

*# **odzvláštnit** řetězec pro použití v dynamickém regulárním výrazu*<br>
*// Poznámka: tuto funkci obvykle nepotřebujete, protože do regulárního výrazu můžete interpolovat řetězec bez interpretace pomocí dvojice „\\Q“ a „\\E“.*<br>
**quotemeta(**{*řetězec*}**)**
<!--
{*$proměnná*} **=** {*řetězec*}**;**
{*$proměnná*} **=~ s/[.^\\$\*+?(){\\\\\|[]/\\\\$&amp;/g;**<br>
!: Použít $proměnnou...
-->

### Najít a nahradit v řetězcové proměnné

*# provést **náhradu** pomocí regulárního výrazu (výsledek: přiřadit zpět/vrátit jako hodnotu)*<br>
*// Podrobnější informace o syntaxi najdete v sekci „Regulární výraz a řetězec náhrady“.*<br>
{*$proměnná*} **=~ s/**{*regulární výraz*}**/**{*řetězec náhrady*}**/**[**g**]<nic>[**i**]<nic>[**m**]<nic>[**s**]**;**<br>
{*$řetězec*} **=~ s/**{*regulární výraz*}**/**{*řetězec náhrady*}**/r**[**g**]<nic>[**i**]<nic>[**m**]<nic>[**s**]

*# nahradit **všechny** výskyty podřetězce v textu proměnné*<br>
*// Pro nahrazení jen prvního výskytu vypusťte „g“ na konci druhého řádku zaklínadla.*<br>
[{*$proměnná\_podřetězec*} **=** {*podřetězec*}**;**]<br>
{*$proměnná*} **=~ s/\\Q$\{**{*proměnná\_podřetězec*}**\}\\E/**{*řetězec náhrady*}**/g;**

*# přeložit znaky pomocí překladové tabulky*<br>
*// Poznámka: výsledek překladu přepíše původní proměnnou, ale není návratovou hodnotou výrazu!*<br>
{*$proměnná*} **=~ y/**{*původní-znaky*}**/**{*nové-znaky*}**/;**

*# nahradit podřetězec podle indexů (původní podřetězec zahodit/získat jako návr. hodnotu)*<br>
**substr(**{*$proměnná*}**,** {*index*}[**,** {*max-délka*}]**) =** {*nový-podřetězec*}**;**<br>
**substr(**{*$proměnná*}**,** {*index*}**,** {*max-délka*}**,** {*nový-podřetězec*}**)**
<!--
[ ] vyzkoušet
-->

<!--
sort()?

m//g
s///
tr///

$MATCH, $PREMATCH, $ARG, $POSTMATCH

match\_text
match\_begin($řetězec, $reg.výraz[, $počáteční-index[, $max-délka]]) -> index || undef
match\_length
match\_end

next\_match($řetězec, $reg.výraz[, $počáteční-index[, $max-délka]]) -> (text, začátek, konec, délka) || (undef, undef, undef, undef)

-->

<!--
use feature 'state';
-->

### Konverze čísel na řetězce a naopak

*# hexadecimální/desítkový/oktalový řetězec na číslo*<br>
**hex(**{*řetězec*}**)** ⊨ 1015<br>
{*řetězec*} **+ 0** ⊨ 1015<br>
**oct(**{*řetězec*}**)** ⊨ 1015

*# celé číslo na hexadecimální řetězec s malými/velkými písmeny*<br>
**sprintf("%x",** {*číslo*}**)** ⊨ "3f7"<br>
**sprintf("%X",** {*číslo*}**)** ⊨ "3F7"

*# celé číslo na oktalový řetězec*<br>
**sprintf("%o",** {*číslo*}**)** ⊨ "1767"

### Heše

<!-- Ukázkový řetězec: "Hello, world!" -->

*# získat číselnou heš řetězce*<br>
^^**use Digest::MD5;**<br>
^^**use Encode;**<br>
**unpack("L", substr(Digest::MD5::md5(Encode::encode("UTF-8", **{*řetězec*}**)), 0, 4))** ⊨ "1834341228"

*# **MD5** heš řetězce bajtů*<br>
^^**use Digest::MD5;**<br>
**Digest::MD5::md5\_hex(**{*řetězec-bajtů*}**)** ⊨ "6cd3556deb0da54bca060b4c39479839"

*# **SHA256** heš řetězce bajtů*<br>
^^**use Digest::SHA;**<br>
**Digest::SHA::sha256\_hex(**{*řetězec-bajtů*}**)** ⊨ "315f5bdb76d078c43b8ac0064e4a0164612b1f (...)"
<!--ce77c869345bfc94c75894edd3-->

*# **SHA1** heš řetězce bajtů*<br>
^^**use Digest::SHA;**<br>
**Digest::SHA::sha1\_hex(**{*řetězec-bajtů*}**)** ⊨ "943a702d06f34599aee1f8da8ef9f7296031d699"

*# **SHA512** heš řetězce bajtů*<br>
^^**use Digest::SHA;**<br>
**Digest::SHA::sha512\_hex(**{*řetězec-bajtů*}**)** ⊨ "c1527cd893c124773d811911970c8fe6e857d6 (...)"
<!--df5dc9226bd8a160614c0cd963a4ddea2b94bb7d36021ef9d865d5cea294a82dd49a0bb269f51f6e7a57f79421-->














<!--
==================================================================================
-->
## Zaklínadla: Pole

<!--
https://metacpan.org/pod/List::MoreUtils
-->

### Literály (vytvořit pole z prvků)

*# **seznam** (obecně/příkady)*<br>
*// Prvky seznamu mohou být skaláry (každý utvoří jeden prvek seznamu) nebo pole a vnořené seznamy (každé pole a vnořený seznam se za běhu rozloží na všechny svoje prvky v náležitém pořadí). Tip: skalárem v seznamu může být i nehodnota undef.*<br>
**(**[{*prvek seznamu*}[**,** {*další prvek seznamu*}]...]**)**<br>
**(1, "", undef)**<br>
**(1 + 1, (2 + 2, 3 + 3), array("", undef, ""))**

*# seznam **ze slov** (alternativy)*<br>
*// Slovo je v tomto případě každá neprázdná posloupnost nebílých znaků oddělená od ostatních slov alespoň jedním bílým znakem. Uvnitř operátoru qw není možné odzvláštnění a zvláštní význam má pouze odpovídající uzavírací závorka a bílé znaky. Forma se složenými závorkami je vhodnější při víceřádkovém použití.*<br>
**qw(**{*slova*}**)**<br>
**qw\{**{*slova*}**\}**

*# získat **ukazatel** na anonymní **pole***<br>
**[**[{*prvek seznamu*}[**,** {*další prvek seznamu*}]...]**]**

*# seznam celých čísel v daném **rozsahu** (obecně/příklady)*<br>
**(**{*celé-číslo*}**..**{*celé-číslo*}**)**<br>
**(-1..4)** ⊨ (-1, 0, 1, 2, 3, 4)<br>
**(2..5, -3..-1)** ⊨ (2, 3, 4, 5, -3, -2, -1)

*# **zopakovat** seznam (obecně/příklad použití)*<br>
{*(seznam)*} **x** {*počet*}<br>
**my @dvanáct\_undefů = (undef) x 12;**

*# přečíst **konstantu** typu seznam (obecně)*<br>
**(**{*identifikátor*}**)**

*# přečíst konstantu typu seznam (příklad)*<br>
**use constant můjseznam =&gt; (1, 2, 3, 4);**<br>
**my @mojepole = (-1, 0, (můjseznam), 5, 6);**

*# seznam znaků UCS v daném kódovém rozsahu (alternativy)*<br>
**(map {chr($ARG)}** {*první-kód*}**..**{*poslední-kód*}**)**<br>
**(map {chr($ARG)} ord("**{*první-znak*}**")..ord("**{*poslední-znak*}**"))**

### Základní operace

*# zjistit **počet prvků** pole*<br>
**alength(**{*@pole*}**)**

*# **přečíst** prvek pole (obecně/příklady)*<br>
*// Pokud přistupujete k prvku pole vráceného z volání funkce, musíte celé volání obalit ještě do další úrovně kulatých závorek, např. „(f(1, 2))[5]“. U „f(1, 2)[5]“ Perl ohlásí syntaktickou chybu.*<br>
**$**{*identifikátor\_pole*}**[**{*index*}**]**<br>
**$mojepole[12]**<br>
**my $prvek = (získej\_pole(1))[$i];**

*# **přiřadit** prvku pole (obecně/příklad)*<br>
**$**{*identifikátor\_pole*}**[**{*index*}**] =** {*skalár*}<br>
**$mojepole[12] = undef**

*# **přiřadit** celé pole (alternativy)*<br>
**@**{*cílové\_pole*} **= @**{*zdrojové\_pole*}<br>
**@**{*cílové\_pole*} **=** {*(seznam)*}

*# **rozložit** pole do nových skalárních proměnných*<br>
*// Přebytečné prvky pole se zahazují. Přebytečné proměnné se vyplní nehodnotou undef.*<br>
**my ($**{*id*}[**,** {*$další\_id*}]...**) =** {*@pole*}**;**

<!--
*# deklarovat proměnnou typu pole (obecně/příklady)*<br>
**my @**{*identifikátor\_pole*} [**=** {*inicializace*}]**;**<br>
**my @pole = qw(5 6 7);**<br>
**my @pole = ("a", "bc", "d");**
-->

*# je pole **prázdné**?*<br>
**alength(**{*@pole*}**) == 0**

*# zjistit **typy prvků** pole*<br>
*// Funkce typy() s více parametry vrací řetězec, který je konkatenací návratových hodnot pro jednotlivé prvky. Význam jednotlivých částí řetězce je popsán v poznámce pod čarou k příkazu pro zjištění typu skaláru.*<br>
**typy(**{*@pole*}**)** ⊨ "ssuRuA"

*# **zopakovat** seznam či obsah pole (obecně/příklady)*<br>
{*seznam*} **x** {*počet*}<br>
**("a", undef) x 2** ⊨ ("a", undef, "a", undef)<br>
**(@test) x 5**

*# první/poslední prvek pole*<br>
**$**{*identifikátor\_pole*}**[0]**<br>
**$**{*identifikátor\_pole*}**[-1]**

### Vkládání/vyjímání prvků

*# **vyjmout** první/poslední/určitý prvek pole*<br>
*// Funkce shift() a pop() vracejí vyjmutý prvek.*<br>
**shift(**{*@pole*}**)**<br>
**pop(**{*@pole*}**)**<br>
**splice(**{*@pole*}**,** {*index*}**, 1);**

*# **vložit** prvek na začátek pole/konec pole/určitý index*<br>
*// Poznámka: vkládání na určitý index může být pomalé.*<br>
**unshift(**{*@pole*}**,** {*skalár*}**);**<br>
**push(**{*@pole*}**,** {*skalár*}**);**<br>
**splice(**{*@pole*}**,** {*index*}**, 0,** {*skalár*}**);**

*# **smazat** všechny prvky/úsek*<br>
{*@pole*} **= ();**<br>
**splice(**{*@pole*}**,** {*první-smaz-index*}**,** {*počet-ke-smazání*}**);**

### Filtrování

*# vybrat prvky **podle indexu** (obecně/příklady)*<br>
{*@pole*}**[**{*seznam, indexů*}**]**<br>
**my @x = (array(0, 10, 20, 30, 40, 50))[1..3];** ⊨ (10, 20, 30)<br>
**my @x = (array(0, 10, 20, 30, 40, 50))[3, 2, 3];** ⊨ (30, 20, 30)<br>
**my @a = @pole\_prvků[@pole\_indexů];**

*# vybrat prvky **splňující podmínku***<br>
*// Výsledkem je seznam prvků, pro které se poslední příkaz v bloku vyhodnotí jako logická pravda.*<br>
**array(grep \{**<br>
<odsadit1>{*příkaz*}...<br>
**\}** {*@pole*}**)**

*# vybrat prvních/posledních N prvků*<br>
*// Pokud je seznam kratší než N prvků, funkce ho vrátí nezměněný.*<br>
^^**use List::Util;**<br>
**List::Util::head(**{*N*}**,** {*seznam*}**)**<br>
**List::Util::tail(**{*N*}**,** {*seznam*}**)**

*# vybrat sudé/liché prvky z pole o sudém počtu prvků*<br>
^^**use List::Util;**<br>
**List::Util::pairkeys(**{*seznam*}**)**<br>
**List::Util::pairvalues(**{*seznam*}**)**

<!--
// příliš specializované

*# vynechat prvky, které se již vyskytly*<br>
*// Funkce provádí řetězcové porovnání prvků, ne číselné. Zachovává pořadí prvků.*<br>
^^**use List\:\:MoreUtils;**<br>
**distinct(**{*prvky*}...**)**

*# vybrat prvky, které se v poli vyskytují právě jednou*<br>
*// Funkce provádí řetězcové porovnání prvků, ne číselné.*<br>
^^**use List\:\:MoreUtils;**<br>
**List::MoreUtils::singleton(**{*prvky*}...**)**
-->


<!--
### Analýza pole (logické testy)

*# **existuje** prvek pole?*<br>
{*index*} **&lt; alength(**{*@pole*}**) &amp;&amp;** {*index*} **&gt;= 0**

*# **existuje** prvek splňující podmínku?*<br>
^^**use List\:\:MoreUtils;**<br>
**(any \{**<br>
<odsadit1>{*podmínka;*}<br>
**\}** {*@pole*}**)**

*# platí podmínka pro **všechny** prvky?*<br>
^^**use List\:\:MoreUtils;**<br>
**(all \{**<br>
<odsadit1>{*podmínka;*}<br>
**\}** {*@pole*}**)**

*# platí podmínka právě pro **jeden** z prvků?*<br>
^^**use List\:\:MoreUtils;**<br>
**(one \{**<br>
<odsadit1>{*podmínka;*}<br>
**\}** {*@pole*}**)**
-->

### Transformace a zpracování pole

*# transformovat **po prvcích***<br>
*// Operátor „map“ funguje přesně jako cyklus „foreach (@pole)“ (tzn. v uvedeném bloku je $ARG odkaz na právě zpracovávaný prvek pole), až na to, že jeho návratovou hodnotou je seznam hodnot posledního provedeného příkazu bloku v každém cyklu. Protože je $ARG odkaz, můžete ho využít k modifikaci prvků původního pole.*<br>
**(map \{**<br>
<odsadit1>{*příkaz*}...<br>
**\}** {*@pole*}**)**

<!--
*# transformovat po dvojicích*<br>
^^**use List\:\:Util;**<br>
**(map \{**<br>
<odsadit1>{*příkaz*}...<br>
**\} pairs(**{*@pole*}**))**
-->

*# zpracovat pole po N-ticích (destruktivně)*<br>
*// Tip: místo uložení do pole můžete získanou N-tici rovnou rozložit do proměnných, nebo můžete místo funkce splice() použít opakované volání funkce shift(). Poslední N-tice může být neúplná. Pokud chcete přebytečné prvky zahodit, nahraďte podmínku „!= 0“ za „&gt;= N“.*<br>
**while (alength(**{*@pole*}**) != 0) \{**<br>
<odsadit1>**my @ntice = array(splice(**{*@pole*}**, 0, N));**<br>
<odsadit1>{*zpracování*}<br>
**\}**

*# sečíst/vynásobit prvky pole*<br>
^^**use List\:\:Util;**<br>
**List::Util::sum0(**{*seznam*}**)**<br>
**List::Util::product(**{*seznam*}**)**

*# příklad: ze seznamu celých čísel sudá čísla zdvojit a lichá vynechat*<br>
**my @čísla = (1, 2, 3, 14, 15);**<br>
**@čísla = (map {$ARG % 2 == 0 ? ($ARG, $ARG) : ()} @čísla);** ⊨ (2, 2, 14, 14)

*# vytvořit pole ukazatelů na pole dvojic ([a, b], [c, d], ...)*<br>
*// Má-li vstup lichý počet prvků, funkce vypíše varování a k utvoření poslední dvojice doplní „undef“.*<br>
^^**use List::Util;**<br>
**List::Util::pairs(**{*seznam*}**)**

### Řazení a přeskládání prvků v poli

*Poznámka*: volání funkce „sort“ nemůžete použít v kontextu, kde jsou viditelné vámi deklarované
proměnné $a nebo $b. Proto se deklaraci takových proměnných vyhněte, nebo volání funkce „sort()“
odsuňte do samostatné funkce.

*# seřadit řetězce podle aktuální **lokalizace** (vzestupně/sestupně)*<br>
*// Poznámka: většina lokalizací nerozlišuje velikost písmen a toto rozlišování u nich nelze zapnout; v češtině např. neexistují pravidla pro odlišné řazení „ch“, „CH“, „cH“ a „Ch“.*<br>
[{*@pole*} **=**] **do { use locale; array(sort {$a cmp $b}** {*seznam*}**); }**<br>
[{*@pole*} **=**] **do { use locale; array(sort {$b cmp $a}** {*seznam*}**); }**

*# seřadit řetězce podle **kódové hodnoty** znaků (vzestupně/sestupně)*<br>
[{*@pole*} **=**] **do { no locale; array(sort {$a cmp $b}** {*seznam*}**); }**<br>
[{*@pole*} **=**] **do { no locale; array(sort {$b cmp $a}** {*seznam*}**); }**

*# **obrátit** pořadí*<br>
**array(reverse(**{*seznam*}**))**

*# **náhodně** přeskládat*<br>
^^**use List::Util;**<br>
[{*@pole*} **=**] **List::Util::shuffle(**{*@pole*}**)**

*# seřadit **čísla** (vzestupně/sestupně)*<br>
*// Pokud si nejste stoprocentně jistý/á, že všechny prvky seznamu (resp. pole) jsou čísla (nebo řetězce vypadající přesně jako čísla), uvažte možnost předběžného přefiltrování seznamu funkcí „grep“ nebo konverzi na čísla funkcí „map“. Porovnávací operátor &lt;=&gt; se může chovat podivně, když se setká s ne-číslem; může vypsat chybové hlášení nebo prvek poslat na konec pole; pravděpodobně však nezpůsobí pád programu.*<br>
[{*@pole*} **=**] **array(sort {$a &lt;=&gt; $b}** {*seznam*}**)**<br>
[{*@pole*} **=**] **array(sort {$b &lt;=&gt; $a}** {*seznam*}**)**

*# seřadit podle **uživatelské** porovnávací funkce*<br>
*// Řadicí blok dostane odkazy na porovnávané skaláry ve speciálních proměnných $a a $b a musí vrátit číslo větší než 0, pokud $a &gt; $b; číslo menší než 0, pokud $a &lt; $b a nulu jinak.*<br>
[{*@pole*} **=**] **array(sort \{**<br>
<odsadit1>{*příkaz*}...<br>
**\}** {*seznam*}**)**

*# seřadit řetězce podle jednotných pravidel **Unicode** vzestupně (velikost písmen nerozlišovat)*<br>
*// Úroveň řazení 2 nerozlišuje velikost písmen; úroveň řazení 3 rozlišuje velikost písmen, ale ne znaky se stejnou řadicí váhou; úroveň řazení 4 rozliší i znaky se stejnou řadicí váhou. Tip 1: pro řazení sestupně prohoďte parametry $a a $b. Tip 2: pro proměnnou $porovnávač můžete zvolit jiný identifikátor.*<br>
^^**use Unicode::Collate;**<br>
^^**my $porovnávač = Unicode::Collate-&gt;new("level",** {*úroveň-řazení*}**);**<br>
[{*@pole*} **=**] **array(sort {$porovnávač-&gt;cmp($a, $b)}** {*seznam*}**)**

<!--
[ ] https://perldoc.perl.org/Unicode::Collate
[ ] https://perldoc.perl.org/Unicode::Collate::Locale

*# stabilní řazení*<br>
**use sort("stable");**<br>
[ ] vyzkoušet!

-->

### Vyhledávání a testování

*# najít první prvek vyhovující podmínce (hodnotu/index)*<br>
*// Podmínka je jeden nebo více příkazů, kde výsledek posledního příkazu je otestován na logickou hodnotu. Testovaný prvek (resp. index) se předává pomocí speciální proměnné $ARG. Pokud prvek nebude nalezen, funkce vrátí undef.*<br>
^^**use List\:\:Util;**<br>
**(List::Util::first \{** {*podmínka*} **\}** {*seznam*}**)**<br>
**(List::Util::first \{** {*podmínka*} **\} 0..(alength(**{*@pole*}**) - 1))**

*# najít minimální/maximální číselnou hodnotu*<br>
^^**use List\:\:Util;**<br>
**List::Util::min(**{*seznam*}**)**<br>
**List::Util::max(**{*seznam*}**)**


<!--
[ ] all()
[ ] any()
[ ] head()
[ ] tail()
-->




<!--
==================================================================================
-->
## Zaklínadla: Asociativní pole

### Jako celek

*# **literál** asociativního pole (jako seznam/jako ukazatel na asociativní pole)*<br>
**(**[{*klíč*}**,** {*hodnota*}[**,** {*další klíč*}**,** {*další hodnota*}]...]**)**<br>
**\{**[{*klíč*}**,** {*hodnota*}[**,** {*další klíč*}**,** {*další hodnota*}]...]**\}**

*# získat **počet** dvojic v asociativním poli*<br>
**alength(keys(**{*%pole*}**))** ⊨ 3

*# získat **pole** klíčů/hodnot*<br>
*// Podle dokumentace je pořadí prvků v polích vrácených těmito funkcemi stejné, dokud se dané asociativní pole nezmění. Naopak každá jako změna pravděpodobně změní pořadí prvků vracené oběma funkcemi.*<br>
**keys(**{*%pole*}**)** ⊨ (1, 2, 3)<br>
**values(**{*%pole*}**)** ⊨ ("", undef, "xyz")

*# **transpozice** (klíče na hodnoty a hodnoty na klíče)*<br>
?
<!--
^^**use List::Util;**<br>
[{*%pole*} **=**]
-->

### Prvky

*# **přečíst** prvek asociativního pole/**přiřadit** do něj/příklad*<br>
*// Pokud prvek neexistuje, čtení vrací undef a přiřazení prvek vytvoří.*<br>
**$**{*identifikátor*}**\{**{*klíč*}**\}**<br>
**$**{*identifikátor*}**\{**{*klíč*}**\}** **=** {*hodnota*}<br>
**$apole{"abc"} = "def";**

*# **smazat** prvek/všechny prvky*<br>
*// Pokus o smazání neexistujícího prvku je tiše ignorován.*<br>
**delete $**{*id\_pole*}**\{**{*klíč*}**\};**<br>
{*%pole*} **= ();**

*# **obsahuje** prvek?*<br>
**exists($**{*identifikátor*}**\{**{*klíč*}**\})**

*# **přidat** či přepsat prvek*<br>
**$**{*identifikátor*}**\{**{*klíč*}**\} =** {*hodnota*}

*# přiřadit hodnoty více prvkům najednou (obecně/příklady)*<br>
**@**{*identifikátor*}**\{**{*seznam, klíčů*}**\} =** {*(seznam, hodnot)*}**;**<br>
**@apole{"a", "b"} = ("A", "B");**<br>
**@apole{@klíče} = @hodnoty;**<br>
**@apole{@klíče} = ("xyz") x alength(@klíče);**

*# smazat prvky splňující podmínku*<br>
?
<!--
**delete @**{*identifikátor*}**\{**array(grep \{**<br>
<odsadit1>{*příkaz*}...<br>
**\} keys(%**{*identifikátor*}**))};**
-->

*# vytvořit pole výběrem prvků z asoc. pole (přímo/přes ukazatel)*<br>
[{*@pole*} **=**] **@**{*identifikátor*}**\{**{*seznam, klíčů*}**\}**<br>
?

*# smazat více prvků najednou (přímo/přes ukazatel)*<br>
**delete @**{*identifikátor*}**\{**{*seznam, klíčů*}**\};**<br>
?
<!--
**delete @**{*ukazatel*}**-&gt;\{**{*seznam, klíčů*}**\};** // nefunguje
-->

*# smazat prvek přes ukazatel na asociativní pole*<br>
**delete** {*$ukazatel*}**-&gt;\{**{*klíč*}**\};**

<!--
==================================================================================
-->
## Zaklínadla: Ukazatelé

### Ukazatelé obecně

*# je skalár ukazatel?*<br>
**defined(ref(**{*$skalár*}**))**

*# zjistit typ odkazovaného objektu (alternativy)*<br>
*// Pro interpretaci návratové hodnoty funkce typy() vyhledejte poznámku pod čarou k zaklínadlu „zjistit typ skaláru“ v této kapitole. Pro interpretaci návratové hodnoty funkce ref() hledejte v dokumentaci Perlu.*<br>
**typy(**{*$skalár*}**)**<br>
**ref(**{*$skalár*}**)**

*# odkazují dva ukazatelé na tentýž objekt?*<br>
^^**use Scalar::Util;**<br>
**Scalar::Util::refaddr(**{*$a*}**) == Scalar::Util::refaddr(**{*$b*}**)**
<!--
[ ] Vyzkoušet pro undef a různé kombinace.
-->

### Získat ukazatel

*# získat ukazatel na **proměnnou**: skalár/pole/asociativní pole*<br>
**\\$**{*identifkátor\_skalární\_proměnné*}<br>
**\\@**{*identifkátor\_pole*}<br>
**\\%**{*identifkátor\_asociativního\_pole*}

*# získat ukazatel na pojmenovanou **funkci**/anonymní funkci*<br>
*// Analogicky můžete ukazatel na anonymní funkci předat jako parametr jiné funkci. Poznámka: raději se nesnažte získávat ukazatele na vestavěné funkce Perlu; pravděpodobně to nebude fungovat.*<br>
**\\&amp;**{*identifkátor\_funkce*}<br>
**sub \{**[{*příkazy*}]...**\}**

*# získat ukazatel na **regulární výraz** (obecně/příklad)*<br>
**qr/**{*regulární výraz*}**/**<br>
**$můjVýraz = qr/^ab\\.c/**

*# získat ukazatel na **prvek pole**/hodnotu v asociativním poli*<br>
*// Poznámka: klíče v asociativním poli jsou nepřiřaditelné, proto ukazatel na ně nelze získat.*<br>
**\\$**{*identifkátor\_pole*}**[**{*index*}**]**<br>
**\\$**{*identifkátor\_asociativního\_pole*}**\{**{*klíč*}**\}**

*# získat ukazatel na **anonymní objekt**: skalár/pole/asociativní pole*<br>
**\\(**{*hodnota-nebo-undef*}**)**<br>
**[**{*seznam*}**]**<br>
**\{**{*seznam,dvojic*}**\}**

*# získat ukazatel na hodnotu v asociativním poli dostupném přes ukazatel*<br>
**\\$**{*ukazatel-na-asoc-pole*}**-&gt;\{**{*klíč*}**\}**

### Dereferencovat ukazatel

*# **přistoupit** přes ukazatel ke skaláru/poli/asociativnímu poli/funkci*<br>
*// Uvnitř složených závorek zde nemusí být jen proměnná, ale může to být jakýkoliv výraz, který vrátí příslušný ukazatel (např. volání funkce).*<br>
**\${\$**{*identifikátor\_ukazatele*}**\}**<br>
**@{$**{*identifikátor\_ukazatele*}**\}**<br>
**%{$**{*identifikátor\_ukazatele*}**\}**<br>
**&amp;{$**{*identifikátor\_ukazatele*}**\}**

*# zavolat přes ukazatel **funkci***<br>
{*$ukazatel*}**-&gt;(**{*seznam, parametrů*}...**)**

*# přistoupit k prvku pole/asociativního pole dostupného přes ukazatel*<br>
{*$ukazatel*}**-&gt;[**{*index*}**]**<br>
{*$ukazatel*}**-&gt;\{**{*klíč*}**\}**

### Slabé ukazatele

*# **změnit** ukazatel na slabý*<br>
^^**use Scalar::Util;**<br>
**Scalar::Util::weaken(**{*$ukazatel*}**);**

*# je ukazatel slabý?*<br>
^^**use Scalar::Util;**<br>
**Scalar::Util::isweak(**{*$ukazatel*}**)**

*# změnit slabý ukazatel zpět na silný*<br>
^^**use Scalar::Util;**<br>
**Scalar::Util::unweaken(**{*$ukazatel*}**);**


<!--
==================================================================================
-->
## Zaklínadla: Vstup/výstup

### Otevřít/zavřít

*# **zavřít** proud*<br>
**close(**{*$proud*}**)** [**or die(**{*zpráva*}**)**]**;**

*# získat **standardní** vstup/standardní výstup/standardní chybový výstup*<br>
**my **{*$proud*} **= \\\*STDIN;** [**binmode(**{*$proud*}**, ":raw");**]<br>
**my **{*$proud*} **= \\\*STDOUT;** [**binmode(**{*$proud*}**, ":raw");**]<br>
**my **{*$proud*} **= \\\*STDERR;** [**binmode(**{*$proud*}**, ":raw");**]

*# otevřít soubor jako **textový** (normálně/se striktními kontrolami)*<br>
*// Režim je jeden z: „&lt;“: otevřít existující soubor pro čtení; „&gt;“: vytvořit nový/přepsat existující soubor a otevřít pro zápis; „&gt;&gt;“: otevřít pro zápis na konec souboru.*<br>
**open(my **{*$proud*}**, "**{*režim*}**:utf8",** {*"cesta/k/souboru"*}**)** [**or die(**{*"chybová zpráva"*}**)**]**;**<br>
**open(my **{*$proud*}**, "**{*režim*}**:encoding(UTF-8)",** {*"cesta/k/souboru"*}**)** [**or die(**{*"chybová zpráva"*}**)**]**;**

*# otevřít soubor jako **binární***<br>
*// Režim je jeden z: „&lt;“: otevřít existující soubor pro čtení; „+&lt;“: otevřít existující soubor pro čtení i zápis; „&gt;“: vytvořit nový/přepsat existující soubor a otevřít jen pro zápis; „+&gt;“: totéž, ale pro zápis i čtení; „&gt;&gt;“: otevřít soubor pro zápis na konec.*<br>
**open(my **{*$proud*}**, "**{*režim*}**:raw",** {*"cesta/k/souboru"*}**)** [**or die(**{*"chybová zpráva"*}**)**]**;**

*# otevřít **rouru** pro zápis/pro čtení*<br>
**open(my **{*$proud*}**, "\|-", "**{*název-příkazu*}**"**[**,** {*parametr-příkazu*}]...**)** [**or die(**{*zpráva*}**)**]**;** [**binmode(**{*$proud*}**, ":raw");**]<br>
**open(my **{*$proud*}**, "-\|", "**{*název-příkazu*}**"**[**,** {*parametr-příkazu*}]...**)** [**or die(**{*zpráva*}**)**]**;** [**binmode(**{*$proud*}**, ":raw");**]

*# otevřít číslovaný vstup či výstup*<br>
*// Deskriptory jsou číslované proudy, které typicky otevírá bash před spuštěním každého procesu. Deskriptory číslo 0, 1 a 2 se nazývají „standardní vstup“, „standardní výstup“ a „standardní chybový výstup. Režim je v tomto případě buď „&lt;“ pro čtení z deskriptoru, nebo „&gt;“ pro zápis do deskriptoru.“*<br>
**open(my **{*$proud*}**, "**{*režim*}**&amp;=**{*číslo*}**")** [**or die(**{*"chybová zpráva"*}**)**]**;** [**binmode(**{*$proud*}**, ":raw");**]

*# **přepnout režim** proudu na binární/textový*<br>
*// Tento příkaz nesmí být použit poté, co už bylo s proudem od otevření manipulováno (např. čtením, zápisem, přesouváním apod.) Proto ho doporučuji používat jen okamžitě po otevření proudu.*<br>
**binmode(**{*$proud*}**, ":raw");**<br>
**binmode(**{*$proud*}**, ":utf8");**

### Standardní výstup a chybová hlášení

*# vypsat **položky seznamu** oddělené hodnotou $OFS a zakončené hodnotou $ORS*<br>
**print(**{*položky, seznamu*}**);**

*# **printf()***<br>
**printf(**{*"formátovací řetězec"*}[**,** {*parametry*}...]**);**

*# vypsat **řetězec***<br>
**printf("%s",** {*výraz-typu-řetězec*}**);**

*# vypsat datovou strukturu pro člověka (zejména pro účely ladění)*<br>
^^**use Data::Dumper;**<br>
**printf("%s", Dumper(**{*seznam*}**));**

*# vypsat **varování** ohedně tohoto místa/místa ve volající funkci na standardní chybový výstup*<br>
*// Perl doplní chybové hlášení o označení zdrojového kódu a číslo řádku.*<br>
**warn(**{*"zpráva"*}**);**<br>
**carp(**{*"zpráva"*}**);**

### Čtení (vstup) v textovém režimu

*# načíst řádek bez ukončovače*<br>
*// Při čtení za koncem souboru se do proměnné $cíl uloží nehodnota undef.*<br>
{*$cíl*} **= scalar(readline(**{*$proud*}**));**<br>
**chomp(**{*$cíl*}**) if (defined(**{*$cíl*}**));**

*# načíst všechny zbývající řádky bez ukončovačů do pole*<br>
{*@cíl*} **= array(readline(**{*$f*}**));**<br>
**chomp(**{*@cíl*}**);**

*# načíst N znaků (N≥1)/1 znak*<br>
*// Podle manuálu tyto funkce nejsou příliš efektivní; je vhodnější raději načítat po řádcích s ukončovačem a každou řádku rozdělit po znacích. Při čtení za koncem souboru funkce vracejí undef.*<br>
{*$cíl*} **= do {local $RS = \\(**{*N*}**); scalar(readline(**{*$proud*}**));}**<br>
{*$cíl*} **= getc(**{*$proud*}**);**

*# načíst celý zbytek souboru do řetězce*<br>
{*$cíl*} **= do {local $RS = undef; scalar(readline(**{*$proud*}**));}**

*# načíst řádku/všechny zbývající řádky s ukončovačem*<br>
{*$cíl*} **= scalar(readline(**{*$proud*}**));**<br>
{*@cíl*} **= array(readline(**{*$f*}**));**

*# načíst a zahodit všechny zbývající řádky*<br>
**while (defined(scalar(readline(**{*$proud*}**)))) {}**

### Zápis (výstup) v textovém režimu

*# vypsat **položky seznamu** oddělené hodnotou $OFS a zakončené hodnotou $ORS*<br>
**fprint(**{*$proud*}**,** {*položky, seznamu*}**);**

*# **printf()***<br>
**fprintf(**{*$proud*}**,** {*"formátovací řetězec"*}[**,** {*parametry*}...]**);**

*# vypsat **řetězec***<br>
**fprintf(**{*$proud*}**, "%s",** {*řetězec*}**);**

### Čtení (vstup) v binárním režimu

*# načíst pevný **maximální počet bajtů***<br>
**read(**{*$proud*}**,** {*$proměnná-cíl*}**,** {*max-bajtů*}[**,** {*počáteční-index-do-cíle*}]**)**

*# načíst jeden **bajt***<br>
{*$cíl*} **= getc(**{*$proud*}**);**

*# načíst celý **zbytek souboru** do řetězce bajtů*<br>
{*$cíl*} **= do {local $RS = undef; scalar(readline(**{*$proud*}**));}**

*# konvertovat bajty z řetězce na pole číselných hodnot*<br>
{*@cíl*} **= unpack("C\*",** {*$řetězec*}**);**

### Zápis a ostatní operace v binárním režimu

*# zapsat bajty (z řetězce bajtů/z pole čísel)*<br>
**fprintf(**{*$proud*}**, "%s",** {*řetězec*}**);**<br>
**fprintf(**{*$proud*}**, "%s", pack("C\*",** {*řetězec*}**));**

*# zapsat bajt (znak/z číselné hodnoty)*<br>
**fprintf(**{*$proud*}**, "%s",** {*$znak*}**);**<br>
**fprintf(**{*$proud*}**, "%c",** {*$číslo*}**);**

*# přesun na pozici N bajtů od začátku/od konce/od akt. pozice vpřed/od akt. poz. vzad (nepoužívat na roury)*<br>
**seek(**{*$f*}**,** {*N*}**, 0);**<br>
**seek(**{*$f*}**, -**{*N*}**, 2);**<br>
**seek(**{*$f*}**,** {*N*}**, 1);**<br>
**seek(**{*$f*}**, -**{*N*}**, 1);**
<!--
[ ] Vyzkoušet.
-->

*# zjistit pozici v bajtech od začátku souboru (nepoužívat na roury)*<br>
**tell(**{*$f*}**)** ⊨ 737

*# **zkrátit** soubor otevřený pro zápis (nepoužívat na roury)*<br>
**truncate(**{*$proud*}**,** {*délka-v-bajtech*}**)** [**&amp;&amp; seek(**{*$f*}**,** {*nová-pozice*}**,** {*odkud*}**)**]

### Operace se soubory a pevnými a symbolickými odkazy

<!--
[ ] Chybí obsluha chyb.
-->

*# nastavit **mód** (přístupová práva)(obecně/příklad)*<br>
*// Pozor! Mód je zde interpretován v oktalové soustavě, proto ho tak zpravidla musíte zadat. Pokud ho zadáte v desítkové soustavě (např. „777“), nebude fungovat.*<br>
**chmod(**{*číslo*}**,** {*cesta*}...**);**<br>
**chmod(04777, "../a.txt", "b.txt");**

*# **přejmenovat** soubor*<br>
**rename(**{*"původní název"*}**,** {*"nový název"*}**)** [**or die(**{*"chybové hlášení"*}**)**]**;**

*# vytvořit **pevný odkaz** na soubor*<br>
**link(**{*"$původní/cesta"*}**,** {*"nová/cesta"*}**)** [**or die(**{*"chybové hlášení"*}**)**]**;**

*# vytvořit **symbolický odkaz** (obecně/příklad)*<br>
**symlink(**{*"obsah odkazu"*}**,** {*"cesta/k/odkazu"*}**)** [**or die(**{*"chybové hlášení"*}**)**]**;**

*# **odstranit** soubor či symbolický odkaz*<br>
**unlink(**{*cesta*}**)** [**or** {*zpracovat chybu*}]

### Operace s adresáři

*# získat pole **názvů položek** v adresáři*<br>
*// Pozor, získané pole bude obsahovat i zvláštní položky „.“ a „..“ a všechny skryté soubory a adresáře. Možná budete vrácené pole chtít přefiltrovat funkcí grep() a seřadit.*<br>
**if (opendir(my $**{*identifikátor*}**,** {*$cesta*}**)) \{**<br>
<odsadit1>{*@pole*} **= array(readdir($**{*identifikátor*}**));**<br>
<odsadit1>**closedir($**{*identifikátor*}**);**<br>
**\}**

*# změnit aktuální adresář*<br>
**chdir(**{*cesta*}**)** [**or die(**{*...*}**)**]**;**

*# **zjistit** aktuální adresář*<br>
^^**use Cwd;**<br>
**getcwd()** ⊨ "/home/alena/linux-spellbook"

*# **vytvořit** adresář*<br>
**mkdir(**{*$cesta*}**)** [**or** {*zpracovat chybu*}]

*# **odstranit** prázdný adresář*<br>
**rmdir(**{*$cesta*}**)** [**or** {*zpracovat chybu*}]

*# **přejmenovat** adresář*<br>
**rename(**{*"původní název"*}**,** {*"nový název"*}**)** [**or die(**{*"chybové hlášení"*}**)**]**;**

<!--

https://www.tutorialspoint.com/perl/perl_special_variables.htm
-> používat „use English;“!
-->

### Zjistit informace o adresářové položce

Poznámka: v případě, že funkce stat() selže, vrátí prázné pole; proto čtení jeho kteréhokoliv prvku vrátí undef. Mód a typ adresářové položky budou v takovém případě 0.

*# **typ** adresářové položky (s následováním symb. odkazů/bez následování)*<br>
*// Typ je: 1 pro pojmenovanou rouru; 2 pro znakové zařízení; 4 pro adresář; 6 pro blokové zařízení; 8 pro soubor; 10 pro symbolický odkaz (jen u funkce „lstat“!) a 12 pro soket.*<br>
**((stat(**{*"cesta"*}**))[2] // 0) &gt;&gt; 12** ⊨ 8<br>
**((lstat(**{*"cesta"*}**))[2] // 0) &gt;&gt; 12** ⊨ 10

*# **velikost** v bajtech*<br>
**(stat(**{*"cesta"*}**))[7]** ⊨ 15543

*# **čas** změněno/čteno*<br>
*// Čas se vrací jako celočíselná časová známka Unixu.*<br>
**(stat(**{*"cesta"*}**))[9]** ⊨ 1607766627<br>
**(stat(**{*"cesta"*}**))[8]** ⊨ 1607766627
<!--
[ ] Jak získat přesnější čas?
-->

*# **mód***<br>
*// Mód se vrací jako číslo. Pravděpodobně ho budete chtít vypsat v čitelné podobě funkcí „printf()“ s formátem "%04o".*<br>
**(stat(**{*"cesta"*}**))[2] // 0 &amp; 07777** ⊨ 436

*# vlastník/skupina (obojí číselně)*<br>
**(stat(**{*"cesta"*}**))[4]** ⊨ 1000<br>
**(stat(**{*"cesta"*}**))[5]** ⊨ 1000

*# počet pevných odkazů*<br>
**(stat(**{*"cesta"*}**))[3]** ⊨ 1

*# číslo zařízení/i-uzlu*<br>
**(stat(**{*"cesta"*}**))[0]** ⊨ 47<br>
**(stat(**{*"cesta"*}**))[1]** ⊨ 4

## Parametry příkazů

*# *<br>
**lkk perl** [{*parametry Perlu*}] {*soubor-skriptu.pl*} [{*parametry skriptu*}]<br>
**lkk perl -ne** {*'skript'*}

!parametry:

* '-M{*kód*}' :: Na začátek hlavního skriptu před čtením vloží příkaz „use {*kód*};“ Toho je možné využít k připojení modulů, importu identifikátorů z nich, nastavení direktiv apod. Lze použít opakovaně.
* ○ -0 ○ -0777 ◉ -0x0A ○ -0x017D :: Nastavit $RS na: "\\x{0}"/undef (celý soubor jako jeden záznam)/"\\n"/"Ž" (uvádí se kód hexadecimálně).
* ☐ -C0 :: Vypne implicitní podporu Unicode. (Zatím jsem nezkoušel/a.)
* ○ -n ○ -p :: Režim připomínající GNU awk. Parametry skriptu jsou interpretovány jako cesty k souborům, které mají být čteny. Celý program se pak obalí do implictní smyčky, která z těchto souborů načítá záznamy ukončené $RS do proměnné $ARG. (Na rozdíl od GNU awk ukončovač záznamu není odebrán, k tomu je potřeba použít „chomp($ARG);“.) Hodnota $ARG se na konci každého cyklu: zahodí/vypíše. Tyto volby se obvykle používají v kombinaci s volbou -e, u delšího skriptu je totiž výhodnější čtecí cyklus napsat ručně.
* ☐ -e {*'skript'*} :: Uvede skript na příkazové řádce namísto jeho čtení ze souboru.
* -I {*cesta*} :: Vloží uvedenou cestu na začátek seznamu adresářů pro vyhledávání modulů (ekvivalent příkazu „use lib“ nebo parametru „'-Mlib("{*cesta*}")'“). Lze použít opakovaně. Seznam se prohledává od začátku, takže nově vložená cesta bude mít přednost před všemi předchozími.

<neodsadit>*Varování:* Nikdy do svých skriptů Perlu neuvádějte direktivu interpretu „#!“
(např. „#!/usr/bin/perl“)! Není snadné to udělat správně a neopatrné použití
této direktivy může způsobit, že skript nepůjde spustit vůbec nebo se místo
něj spustí něco úplně jiného.

## Instalace na Ubuntu

Všechny použité nástroje jsou základními součástmi Ubuntu přítomnými i v minimální instalaci
(jen balíček Linuxu: Knihy kouzel si musíte nainstalovat, aby vám fungoval spouštěč „lkk“
a aby byl dostupný modul LinuxKnihaKouzel.pm).

## Ukázka

*# Ukázka 1: Zpracování binárního souboru *<br>
**use Digest::MD5;**<br>
**use constant konec\_řádku =&gt; "\\n";**<br>
**my $vstup = \\\*STDIN; # standardní vstup**<br>
**binmode($vstup, ":raw"); # binární režim**<br>
**$RS = "\\x{0}"; $ORS = (konec\_řádku); # speciální proměnné**<br>
**my $s;**<br>
**while (defined($s = scalar(readline($vstup)))) \{**<br>
<odsadit1>**chomp($s); # zahodit ukončovač \\0**<br>
<odsadit1>**print(Digest::MD5::md5\_hex($s));**<br>
**\}**

*# Ukázka 2: Zpracování textového souboru*<br>
**my $vstup = \\\*STDIN;**<br>
**my @řádky = array(readline($vstup)); # všechny řádky najednou**<br>
**chomp(@řádky);**<br>
**printf("Na vstupu je %d řádků.\\n", alength(@řádky));**<br>
**my ($původní, $nový) = ('.\*\*$x@y%z', '&amp;z$y.\*@x');**<br>
**for my $i (0..(alength(@řádky) - 1)) \{**<br>
<odsadit1>**$řádky[$i] =~ s/\\Q${původní}\\E/($&amp;)=&gt; ${nový}/g;**<br>
**\}**<br>
**print("&lt;", join("&gt;\\n&lt;", @řádky), "&gt;\\n");**

!ÚzkýRežim: zap

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->

* *Autovivifikace:* Operátory („-&gt;[]“ a „-&gt;{}“) lze bezpečně použít i v případech, kdy na jejich levé straně stojí neexistující prvek asociativního pole či pole nebo neinicializovaná proměnná. Perl totiž hodnotu na levé straně zkontroluje, a pokud je undef, automaticky tam přiřadí ukazatel na nové, prázdné pole (resp. asociativní pole). Tato funkce se nazývá *autovivifikace* a výrazně usnadňuje práci s vnořenými asociativními poli. Dejte si ale pozor na skutečnost, že k ní dojde při každé dereferenci, nejen při takové, do které pak přiřazujete! To znamená, že i příkaz „delete $p-&gt;{"x"}“ způsobí, že se do $p (pokud je undef) přiřadí ukazatel na prázdné asociativní pole.
* *Předávání parametrů do funkcí:* Přiřaditelné skaláry se do funkcí předávají vždy odkazem; přiřazením do prvků zvláštního pole „@ARG“ lze přiřadit do skalárních proměnných, které byly předány funkci jako parametry. Pole se při předávání do funkce (pokud tomu nebrání její prototyp) rozloží na všechny svoje prvky v náležitém pořadí a ty se předají odkazem. Asociativní pole se rozloží na posloupnost dvojic „klíč,hodnota“, příčemž klíče se předají hodnotou (jsou nepřiřaditelné), zatímco hodnoty se předají odkazem. Perl neprovádí žádnou automatickou kontrolu počtu, typu či hodnoty předaných parametrů; ta je výhradně zodpovědností volané funkce. Je výhodné při ní použít funkci „typy()“ a regulární výraz.
* *Vnořené datové struktury:* Vnořené datové struktury se v Perlu realizují téměř výhradně pomocí ukazatelů. Příklad: my @vnořená\_pole = ([1, 2], [3, 4]);
* *print() a printf():* Dokumentace Perlu radí upřednostňovat funkci „print“ před „printf“, protože je rychlejší a snáze se píše. To první je nejspíš pravda, ale pokud ji chcete použít korektně, musíte mít kontrolu nad hodnotami globálních proměnných $OFS a $ORS, protože funkce „print“ je vypisuje, a budou-li nastaveny na nečekané hodnoty z jiné části programu, bude výstup vaší funkce nekorektní. Napsat "%s" do printf je obvykle mnohem jednodušší než neustále přiřazovat $OFS a $ORS.
* *Funkce map():* Návratovou hodnotou posledního příkazu v bloku funkce „map()“ nemusí být skalár; může to být i seznam či pole. V takovém případě se jeho obsah do výsledného pole zploští, díky čemuž nemusí funkce map() vrátit stejný počet prvků jako obržela; může jich být víc i méně.
* *Blok kódu:* Blok kódu předávaný funkci jako zvláštní první parametr (což se týká především vestavěných funkcí grep(), map() a sort() *nesmí* obsahovat příkaz „return“, jinak tento příkaz ukončí obalující funkci a vrátí návratovou hodnotu z ní! To neplatí v případě, kdy se blok předává ukazatelem na anonymní funkci (s klíčovým slovem „sub“), tam je naopak příkaz „return“ vhodný.
* *Správa paměti a slabé ukazatele:* Správa paměti v Perlu je založená na počítání odkazů. Jakýkoliv objekt bude zrušen (včetně případného volání destruktoru) v momentě, kdy počítadlo odkazů na něj klesne na nulu. Slabí ukazatelé se do počtu odkazů nepočítají, a pokud bude objekt zrušen v době jejich existence, automaticky přitom získají nehodnotu undef. Podle dokumentace je slabost ukazatele typová vlastnost objektu, která se nekopíruje (jakákoliv kopie slabého ukazatele je opět silný odkaz) a přepíše se přiřazením, pokud nejde o přiřazení slabého ukazatele téže hodnoty.

<!--
(Poznámka: v Perlu mohou existovat i skaláry, které mají nesouvisející číselnou a řetězcovou hodnotu, např. mají řetězcovou hodnotu "Hello" a číselnou hodnotu 13. Doufejte však, že na takové zrůdnosti při svém programování nenarazíte.)
-->

### Regulární výraz a řetězec náhrady

Uvnitř regulárních výrazů v Perlu můžete použít interpolaci skalární proměnné, např. takto:

*# *<br>
**if ("abc" =~ /a${proměnná}c/) \{**{*...*}**\}**

Proměnná může obsahovat buď ukazatel na regulární výraz (ten se pak zakomponuje
do nového regulárního výrazu), nebo textový řetězec – ten se za běhu
interpretuje jako regulární výraz a také se zakomponuje.

Pokud proměnná obsahuje text a chcete ho vložit bez intepretace zvláštních znaků,
použijte tento zvláštní druh interpolace do regulárního výrazu:

*# *<br>
**if ("abc" =~ /a\\Q${proměnná}\\Ec/) \{**{*...*}**\}**

Uvnitř řetězců náhrady platí stejná pravidla odzvláštňování jako v řetězcových literálech
obklopených dvojitými uvozovkami, až na to, že „"“ je obyčejný znak a „/“ je na místo toho
zvláštní. Uvnitř řetězce náhrady můžete použít speciální proměnné $&amp;
(nahradí se za text shody) a $1, $2, ..., $9, ${10}, ... (nahradí se za text odpovídajícího
záchytu). Také tam můžete použít interpolaci obyčejné proměnné, její text se použije doslova,
bez interpretace zvláštních znaků.

## Další zdroje informací

Poznámka č. 1: Pro spuštění příkazu „perldoc“ si musíte doinstalovat balíček „perl-doc“:

*# *<br>
**sudo apt-get install perl-doc**

Poznámka č. 2: Webové tutorialy a oficiální dokumentace obsahují značné množství dalších konstrukcí,
které v Linuxu: Knize kouzel nejsou zmíněny (např. operátor „&lt;&gt;“ nebo příkaz „given“).
U řady z nich má jejich vynechání dobrý důvod a jejich použití může vést k nezamýšlenému
chování programu, kterému budete moci porozumět jen po nastudování obrovského množství
dokumentace v angličtině. Pokud se tomu chcete vyhnout, používejte jen jazykové konstrukce
z kapitol Linuxu: Knihy kouzel.

* [Wikipedie: Perl](https://cs.wikipedia.org/wiki/Perl)
* SATRAPA, Pavel. *Perl pro zelenáče.* 3. aktualizované a rozšířené vydání. Praha: CZ.NIC, z.s.p.o., 2018. CZ.NIC. ISBN 978-80-88168-35-5.
* [Root.cz: seriál Perličky](https://www.root.cz/serialy/perlicky/)
* [Kompletní oficiální dokumentace](https://perldoc.perl.org/5.30.3/perl) (anglicky — velmi dobrý zdroj)
* perldoc perlrun; perldoc perlvar; perldoc perlfunc; perldoc perlop (vše anglicky)
* [YouTube: Perl Tutorial](https://www.youtube.com/watch?v=WEghIXs8F6c) (anglicky)
* [YouTube: Perl Online Training](https://www.youtube.com/playlist?list=PLWPirh4EWFpE0UEJPQ2PUeXUfvJDhPqSD) (anglicky)
* [Oficiální stránka jazyka](https://www.perl.org/) (anglicky)
* [Balíček](https://packages.ubuntu.com/focal/perl) (anglicky)
* [perltutorial.org](https://www.perltutorial.org/) (anglicky)
* [Perl Tutorial for Beginners: Learn in 1 Day](https://www.guru99.com/perl-tutorials.html) (anglicky)
* [TL;DR: perl](https://github.com/tldr-pages/tldr/blob/master/pages/common/perl.md) (anglicky)

!ÚzkýRežim: vyp

## Pomocné funkce a skripty

*# lkk perl – spouštěč, který spustí skript Perlu s doporučenými parametry*<br>
**#!/bin/bash**<br>
**exec perl -CSDAL -I/usr/share/lkk/perl -Mv5.26.0 -Mstrict -Mwarnings -Mutf8 -MEnglish -MLinuxKnihaKouzel "$@"**

!ÚzkýRežim: zap

## Zákulisí kapitoly
<!--
- Doplňte, pokud víte. Udržujte aktuální.
-->

V této verzi kapitoly chybí:

!KompaktníSeznam:
* pack/unpack
* exec()
* zpracovat [tutorial](https://www.perltutorial.org/perl-syntax/)

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* nic

!ÚzkýRežim: vyp
