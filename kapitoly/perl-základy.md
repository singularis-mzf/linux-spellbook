<!--

Linux Kniha kouzel, kapitola Perl: základy
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

[ ] Zpracovat tutorial začínající na: https://www.perltutorial.org/perl-syntax/
[ ] Zpracovat referenční příručku funkcí:
- Referenční příručka: https://perldoc.perl.org/5.30.0/index-functions-by-cat.html
[ ] Zpracovat řazení čísel, řetězců a obecných objektů (funkce sort).
[ ] stat, lstat
[ ] pack/unpack

-->

# Perl: základy

!Štítky: {program}{zpracování textu}{syntaxe}{Perl}{programování}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Perl je skriptovací jazyk určený především pro zpracování textu.
Mezi programátory je velmi oblíbený a rozšířený, má však špatnou pověst,
protože je multisyntaktický a pro neodborníka velmi špatně čitelný.
Přesto je velmi užitečný a při využití jen malé podmnožiny jeho vlastností
je snadné v něm začít programovat.

Perl je ale také zákeřný programovací
jazyk, v němž se proměnné nejčastěji deklarují klíčovým slovem „my“,
podmínka „if (false)“ je splněna (ačkoliv generuje varování),
připojovaný zdrojový soubor musí končit příkazem „1;“
a příkaz náhrady „s/.$/@/“ provedený nad řetězcem "X\\n\\n\\n"
nikdy neskončí výsledkem "X\\n\\n@" jako v GNU Sedu, ale výsledkem "X\\n\\n\\n",
popř. pokud přidáte ještě modifikátor „s“, výsledkem "X\\n@@";
ke stejnému chování jako v Sedu ho však nedonutíte.
Úspěšné použití takového jazyka vyžaduje buď hlubokou znalost,
nebo se omezit na bezpečnou podmnožinu jeho funkcionality.
Tato kapitola volí druhou uvedenou cestu, a než se naučíte znát
pokročilé vlastnosti Perlu, pomůže vám vyhýbat se jeho zákeřným pastem,
a přesto z jeho moci vytěžit co nejvíc.

Tato kapitola nepokrývá jmenné prostory, objektově orientované programování
a velkou část užitečných knihovních funkcí, ty budou v budoucnu
předmětem samostatné kapitoly.

*Poznámka:* Všechna zaklínadla v této kapitole předpokládají,
že máte nainstalovaný balíček DEB Linuxu: Knihy kouzel
a skripty budete spouštět příkazem „lkk perl“.

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

*# **deklarovat** proměnnou typu skalár/pole/asociativní pole viditelnou v bloku, kde je deklarována*<br>
**my $**{*identifikátor*} [**=** {*inicializace*}]**;**<br>
**my @**{*identifikátor*} [**=** {*inicializace*}]**;**<br>
**my %**{*identifikátor*} [**=** {*inicializace*}]**;**

*# deklarovat proměnnou viditelnou i v jiných modulech*<br>
**our** {*symbol*}{*identifikátor*} [**=** {*inicializace*}]**;**

*# deklarovat **konstantu** typu skalár/seznam*<br>
*// Poznámka: kvůli omezením Perlu je každá konstanta globální v rámci jmenného prostoru a viditelná i z ostatních zdrojových souborů. V její inicializaci může být obecný výraz, ale bude vyhodnocován v době překladu, takže je omezeno, co může obsahovat. Může však obsahovat již dříve definované konstanty.*<br>
**use constant** {*identifikátor*} **=&gt;** {*inicializace*}**;**<br>
**use constant** {*identifikátor*} **=&gt; (**{*inicializace*}**);**

*# do konce bloku **překrýt** globální proměnnou*<br>
*// Příkaz „local“ způsobí, že uvedená globální proměnná se „odloží“ a místo ní se vytvoří nová pod tímtéž názvem. Nová proměnná zanikne teprve po opuštění bloku, v němž byla příkazem „local“ překryta; do té doby ji nová proměnná zastupuje ve všech ohledech (i uvnitř volaných knihovních funkcí). Tato konstrukce se obvykle používá pro dočasné nastavení hodnot speciálních proměnných (např. „$ORS“).*<br>
**local** {*symbol*}{*identifikátor*} [**=** {*nová-hodnota*}]**;**

### Skaláry a undef

*# má skalár hodnotu? (tzn. **není undef**)*<br>
**defined(**{*$skalár*}**)**

*# přečíst skalární proměnnou/**přiřadit** do ní/přiřadit do ní **undef***<br>
**$**{*identifikátor*}<br>
**$**{*identifikátor*} **=** {*hodnota*}<br>
**$**{*identifikátor*} **= undef**

*# přečíst skalární **konstantu** (obecně/příklady)*<br>
**(**{*identifikátor*}**)**<br>
**printf("Hodnota konstanty je: %d\\n", (konstanta));**<br>
**print(konstanta);**<br>
**printf("V asoc. poli je %s\\n", $asocPole{(konstanta)});**

*# zjistit **typ** skaláru*<br>
*// Vracené typy jsou: u = undef, s = číslo či řetězec, S = ukazatel na skalár, A = ukazatel na pole, H = ukazatel na asociativní pole, C = ukazatel na funkci („kód“), R = ukazatel na regulární výraz, F = ukazatel na strukturu reprezentující vstup/výstup a ":text:" pro ukazatele na ostatní typy (např. různé třídy), kde za text se dosadí název daného typu podle Perlu.*<br>
**typy(**{*$skalár*}**)** ⊨ "s"

*# vrátit první ne-undef skalár*<br>
{*skalár*} [**//** {*další-skalár*}]...

### Funkce

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

*# **definovat** funkci*<br>
*// Funkce nemusí být definovaná před prvním použitím, ale pokud má prototyp, musí být před prvním použitím buď definována, nebo alespoň deklarována s prototypem, ale bez těla. Pokud funkci s prototypem použijete před prvním uvedením jejího prototypu, nebude prototyp na dané volání fungovat.*<br>
**sub** {*identifikátor\_funkce*} [{*prototyp*}]<br>
**\{**<br>
<odsadit1>[**typy(@ARG) =~ /\\A**{*regulární-výraz*}**\\z/ or die(**{*"chybové hlášení"*}**);**]<br>
<odsadit1>[{*příkazy*}]...<br>
**\}**

*# definovat funkci vracející přiřaditelný objekt*<br>
*// Funkce definovaná s modifikátorem „lvalue“ musí vrátit přiřaditelný skalár (proměnnou, prvek pole či hodnotu v asociativním poli). Nemůže vracet pole, undef apod.*<br>
**sub** {*identifikátor\_funkce*} [{*prototyp*}] **: lvalue**<br>
**\{**<br>
<odsadit1>[**typy(@ARG) =~ /\\A**{*regulární-výraz*}**\\z/ or die(**{*"chybové hlášení"*}**);**]<br>
<odsadit1>[{*příkazy*}]...<br>
**\}**

*# pole **parametrů** uvnitř definice funkce*<br>
*// Na rozdíl od normálních polí, prvky tohoto speciálního pole se do funkce předávají odkazem. To znamená, že přímým přiřazením do prvků tohoto pole můžete změnit proměnné (popř. prvky pole či hodnoty asociativního pole), které byly při volání funkce zadány. Pokud bylo daným parametrem funkce něco nepřiřaditelného, takové přiřazení se bude tiše ignorovat.*<br>
**@ARG**

*# získat ukazatel na **anonymní funkci***<br>
*// Na rozdíl od bloku příkazů předávanému funkci zvláštním prvním parametrem, v těle anonymní funkce můžete používat příkaz „return“.*<br>
**sub \{**[{*příkazy*}]...**\}**

*# definovat funkci přijímající blok příkazů*<br>
*// Předaný blok zavoláte jako funkci příkazem „$id-&gt;(parametry)“, kde id je zvolený identifikátor proměnné. Parametry (volitelné) předané volání bloku jsou v definici předaného bloku přístupné v poli @ARG.*<br>
^^**sub** {*identifikátor\_funkce*} **(&amp;@);**<br>
**sub** {*identifikátor\_funkce*} **(&amp;@)**<br>
**\{**<br>
<odsadit1>[**typy(@ARG) =~ /\\AC**{*regulární-výraz*}**\\z/ or die(**{*"chybové hlášení"*}**);**]<br>
<odsadit1>**my $**{*id*} **= shift(@ARG);**<br>
<odsadit1>[{*příkazy*}]...<br>
**\}**

### Komentáře

*# **komentář** do konce řádku*<br>
**#** {*obsah komentáře*}

*# víceřádkový komentář*<br>
*// Pozor, před znakem „=“ na uvedených speciálních řádcích nesmí být žádný jiný znak, ani odsazení!*<br>
**=begin&blank;comment**<br>
{*obsah komentáře (i víc řádků)*}<br>
**=end&blank;comment**<br>
**=cut**

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

*# cyklus typu **do...while** (s pozitivní podmínkou/negovanou podmínkou)*<br>
**do \{** [{*příkazy*}] **\} while (**{*podmínka*}**);**<br>
**do \{** [{*příkazy*}] **\} while (!(**{*podmínka*}**));**

*# nekonečný cyklus*<br>
[{*návěští*}**:**] **for (;;) \{** [{*příkazy*}] **\}**

### Řízení toku (skoky)

*# vyskočit z funkce a **vrátit** návratovou hodnotu*<br>
*// Příkaz „return“ v Perlu není povinný. Při jeho nepoužití vrátí Perl hodnotu posledního provedeného příkazu ve funkci.*<br>
**return** {*návratová hodnota*}**;**

*# vyskočit za **konec cyklu***<br>
**last** [{*návěští*}]**;**

*# **ukončit** program*<br>
**exit(**[{*návratový-kód*}]**);**

*# ukončit program s hlášením kritické chyby (obecně/příklad)*<br>
**die("**{*text*}**"**[**,** {*pokračování textu*}]**);**<br>
**die("Nastala chyba číslo&blank;", $čísloChyby, "!");**

*# skočit těsně před uzavírací závorku cyklu*<br>
**next** [{*návěští*}]**;**

*# **pozdržet** program o daný počet sekund*<br>
**my $**{*pomocnáProměnná*} **=** {*N*}**;**<br>
**while (($**{*pomocnáProměnná*} **-= sleep($**{*pomocnáProměnná*}**)) &gt; 0) {}**

*# skočit přímo za otevírací závorku cyklu*<br>
**redo** [{*návěští*}]**;**

*# skočit na **návěští***<br>
**goto** {*návěští*}**;**

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

*# přepínač „**switch**“*<br>
*// V případě zanoření změňte ve vnořeném kódu identifkátory „$hodnota“ a „$příznak“. Větev „default“ můžete realizovat podmínkou „unless ($příznak)“ na konci bloku, v případě potřeby využijte příkaz „goto“. Poznámka: příkaz „next“ používejte uvnitř této konstrukce pouze s návěštím.*<br>
[{*návěští*}**:**] **\{**<br>
**my ($příznak, $hodnota) = (0, scalar(**{*testovaný výraz*}**));**<br>
[**$příznak = $příznak \|\| $hodnota eq** {*hodnota*}**;**]...<br>
[**if ($příznak) \{** [{*příkazy*}] <nic>[**last;**] **\}**]...<br>
**\}**

<!--
*# přepínač **switch** (příklad)*<br>
**můjswitch: \{**<br>
<odsadit1>**my ($příznak, $hodnota) = (0, scalar($s));**<br>
<odsadit1>**$příznak = $příznak \|\| $hodnota eq "ABC";**<br>
<odsadit1>**$příznak = $příznak \|\| $hodnota eq "abc";**<br>
<odsadit1>**if·($příznak)·\{**<br>
<odsadit2>**printf("Bylo to ABC.\\n");**<br>
<odsadit2>**last;**<br>
<odsadit1>**\}**<br>
<odsadit1>**$příznak = $příznak || $hodnota eq "xyz";**<br>
<odsadit1>**if ($příznak) \{**<br>
<odsadit2>**printf("Bylo to XYZ.\\n");**<br>
<odsadit2>**last;**<br>
<odsadit1>**\}**<br>
**\}**
-->

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
*// Na rozdíl od Bashe toto pole neobsahuje nultý parametr (název skriptu). Jsou to opravdu jen parametry předané skriptu na příkazovém řádku.*<br>
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
*// Podle dokumentace se hodnota této proměnné nastavuje při uzavření roury funkcí „close()“, při úspěšném ukončení funkcí „wait()“ a „waitpid()“ a při ukončení funkce „system()“.*<br>
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

### Ostatní

<!--
[ ] Přesunout na správné místo.
-->

*# formátovat funkcí sprintf()*<br>
**sprintf(**{*formát*}**,** {*seznam, parametrů*}**)**



<!--
[ ] Funkce exec()
[ ] Funkce system()
-->





<!--
==================================================================================
-->
## Zaklínadla: Řetězce a regulární výrazy

### Základní operace

*# **spojit** řetězce/pole na řetězec*<br>
{*$řetězec*} **.** {*$další\_řetězec*} [**.** {*$ještě\_další\_řetězec*}]<br>
**join("**[{*oddělovač*}]**",** {*pole-a-seznamy*}**)**<br>

*# zjistit **délku** řetězce ve znacích*<br>
**length(**{*$skalár*}**)** ⊨ 12

*# jsou/nejsou si řetězce **rovny**?*<br>
{*řetězec1*} **eq** {*řetězec2*}<br>
{*řetězec1*} **ne** {*řetězec2*}

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
*// Oddělovač může být buď skalár (např. řetězec), nebo literál regulárního výrazu v lomítkách. Pozor na pasti! Past č. 1: Řetězec "&blank;" se zde interpretuje jako regulární výraz „\\s+“. Pokud chcete jako oddělovač uvést mezeru, použijte místo řetězce regulární výraz „&blank;“ zadaný jako „/&blank;/“. Past č. 2: pokud regulární výraz obsahuje záchyty, příkaz „split“ pro každý záchyt vloží na dané místo výstupního pole navíc řetězec s textem záchytu; pokud daný záchyt nebyl použit, vloží se tam undef. Podrobnější vysvětlení v dokumentaci funkce „split“.*<br>
[{*@pole*} **=**] **split(**{*oddělovač*}**,** {*dělený-řetězec*}[**,** {*maximální-počet-dílů*}]**)**<br>
**@pole = split(":", $s);**<br>
**@pole = split(/[:;]/, $s);**

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
*// Ve dvojitých uvozovkách jsou zvláštními znaky „\\“, „$“ a „@“, všechny lze odzvláštnit zpětným lomítkem. Navíc se tam intepretují některé sekvence začínající zpětným lomítkem a písmenem (např. „\\n“).  V apostrofech je zvláštním znakem pouze apostrof a odzvláštnění není možné. Konec řádky může být obsažen v obou druzích literálů bez odzvláštnění.*<br>
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
**rindex(**{*řetězec*}**,** {*podřetězec*} [**,**{*limit*}]**)**<br>

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
*// Pro nahrazení jen prvního výskytu vypusťte „g“ na konci druhé řádky zaklínadla.*<br>
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
**unpack("L", substr(Digest::MD5::md5(Encode::encode("UTF-8", **{*řetězec*}**)), 0, 4))** ⊨ 1834341228

*# **MD5** heš řetězce bajtů*<br>
^^**use Digest::MD5;**<br>
**Digest::MD5::md5\_hex(**{*řetězec-bajtů*}**)** ⊨ 6cd3556deb0da54bca060b4c39479839

*# **SHA256** heš řetězce bajtů*<br>
^^**use Digest::SHA;**<br>
**Digest::SHA::sha256\_hex(**{*řetězec-bajtů*}**)** ⊨ 315f5bdb76d078c43b8ac0064e4a0164612b1f (...)
<!--ce77c869345bfc94c75894edd3-->

*# **SHA1** heš řetězce bajtů*<br>
^^**use Digest::SHA;**<br>
**Digest::SHA::sha1\_hex(**{*řetězec-bajtů*}**)** ⊨ 943a702d06f34599aee1f8da8ef9f7296031d699

*# **SHA512** heš řetězce bajtů*<br>
^^**use Digest::SHA;**<br>
**Digest::SHA::sha512\_hex(**{*řetězec-bajtů*}**)** ⊨ c1527cd893c124773d811911970c8fe6e857d6 (...)
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
*// Pozor, seznam s hranatými závorkami vrací ukazatel na vytvořené pole a ten se ukládá do skaláru, ne do pole! Pro inicializaci proměnné typu pole použijte seznam s kulatými závorkami.*<br>
**[**[{*prvek seznamu*}[**,** {*další prvek seznamu*}]...]**]**<br>

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

*# zopakovat seznam či obsah pole (obecně/příklady)*<br>
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
**my @x = (array(0, 10, 20, 30, 40, 50))[2..3];** ⊨ (20, 30)<br>
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

### Transformace pole

*# transformovat po prvcích*<br>
*// Operátor „map“ funguje přesně jako cyklus „foreach (@pole)“ (tzn. v uvedeném bloku je $ARG odkaz na právě zpracovávaný prvek pole), až na to, že jeho návratovou hodnotou je seznam hodnot posledního provedeného příkazu bloku v každém cyklu. Protože je $ARG odkaz, můžete ho využít k modifikaci prvků původního pole.*<br>
**(map \{**<br>
<odsadit1>{*příkaz*}...<br>
**\}** {*@pole*}**)**

*# vytvořit pole ukazatelů na pole dvojic ([a, b], [c, d], ...)*<br>
^^**use List::Util;**<br>
**List::Util::pairs(**{*seznam*}**)**

<!--
*# transformovat po dvojicích*<br>
^^**use List\:\:Util;**<br>
**(map \{**<br>
<odsadit1>{*příkaz*}...<br>
**\} pairs(**{*@pole*}**))**
-->

*# zpracovat pole po N-ticích (destruktivně)*<br>
*// Tip: místo uložení do pole můžete získanou N-tici rovnou rozložit do proměnných, nebo můžete místo funkce splice() použít opakované volání funkce shift(). Poslední N-tice může být neúplná. Pokud chcete přebytečné prvky zahodit, nahraďte podmínku „!= 0“ za „&gt;= N“.*<br>
**while (alength(**{*@pole*}**) != 0) \{**
<odsadit1>**my @ntice = array(splice(**{*@pole*}**, 0, N));**<br>
<odsadit1>{*zpracování*}<br>
**\}**

### Řazení a přeskládání prvků v poli

<!--
[ ] https://perldoc.perl.org/Unicode::Collate
[ ] https://perldoc.perl.org/Unicode::Collate::Locale

Poznámka: takto zapsané řadicí funkce nemůžete použít v kontextu, kde máte deklarovanou proměnnou
$a nebo $b. Proto se v kontextu, kde funkci „sort()“ používáte, deklaracím proměnných
těchto názvů vyhněte!

*# seřadit pole řetězců podle číselné hodnoty znaků*<br>
?
<!- -
no locale;
sort { $a cmp $b }
[ ] vyzkoušet!

*# seřadit pole řetězců jednotně (s ohledem/bez ohledu na velikost písmen)*<br>
?<br>
?

*# stabilní řazení*<br>
**use sort("stable");**<br>
[ ] vyzkoušet!

-->

*# obrátit pořadí*<br>
**array(reverse(**{*seznam*}**))**

*# náhodně přeskládat*<br>
^^**use List::Util;**<br>
[{*@pole*} **=**] **List::Util::shuffle(**{*@pole*}**)**

*# seřadit čísla (vzestupně/sestupně)*<br>
[{*@pole*} **=**] **array(sort {$a &lt;=&gt; $b}** {*seznam*}**)**<br>
[{*@pole*} **=**] **array(sort {$b &lt;=&gt; $a}** {*seznam*}**)**
<!--
Pozor na ne-čísla!
[ ] vyzkoušet!
-->

*# seřadit řetězce podle kódové hodnoty znaků*<br>
?
<!--
[{*@pole*} **=**] **do { no locale; array(sort {$a cmp $b}** {*seznam*}**); }**
[ ] vyzkoušet!
-->

*# seřadit řetězce podle aktuální lokalizace (velikost písmen nerozlišovat/rozlišovat)*<br>
?<br>
?
<!--
*// Znaky, které mají v lokálních pravidlech řazení stejnou váhu, se při tomto způsobu řazení rozliší podle kódové hodnoty znaků, což může způsobit problémy při řazení některých řetězců.*<br>
[{*@pole*} **=**] **do { use locale; array(sort {fc($a) cmp fc($b)}** {*seznam*}**); }**<br>
[{*@pole*} **=**] **do { use locale; array(sort {$a cmp $b}** {*seznam*}**); }**
[ ] vyzkoušet!
-->

*# seřadit řetězce podle jednotných pravidel Unicode (velikost písmen nerozlišovat/rozlišovat)*<br>
?<br>
?
<!--
[ ] https://perldoc.perl.org/Unicode::Collate
[ ] https://perldoc.perl.org/Unicode::Collate::Locale
-->

*# seřadit podle uživatelské porovnávací funkce*<br>
*// Řadicí blok dostane odkazy na porovnávané skaláry ve speciálních proměnných $a a $b a musí vrátit číslo větší než 0, pokud $a &gt; $b; číslo menší než 0, pokud $a &lt; $b a nulu jinak. Pozor: Toto nefunguje, pokud jsou v bloku, kde funkci sort() voláte, viditelné jiné proměnné $a či $b!*<br>
[{*@pole*} **=**] **array(sort \{**<br>
<odsadit1>{*příkaz*}...<br>
**\}** {*seznam*}**)**

### Číselné operace

*# sečíst/vynásobit prvky pole*<br>
^^**use List\:\:Util;**<br>
**List::Util::sum0(**{*seznam*}**)**<br>
**List::Util::product(**{*seznam*}**)**

### Vyhledávání

<!--
*# najít první prvek vyhovující podmínce (hodnotu/index)*<br>
^^**use List\:\:MoreUtils;**<br>
-->

*# najít minimální/maximální číselnou hodnotu*<br>
^^**use List\:\:Util;**<br>
**List::Util::min(**{*seznam*}**)**<br>
**List::Util::max(**{*seznam*}**)**














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

*# vytvořit pole výběrem prvků (přímo/přes ukazatel)*<br>
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

*# získat ukazatel na proměnnou: skalár/pole/asociativní pole*<br>
**\\$**{*identifkátor\_skalární\_proměnné*}<br>
**\\@**{*identifkátor\_pole*}<br>
**\\%**{*identifkátor\_asociativního\_pole*}

*# získat ukazatel na pojmenovanou funkci/**anonymní funkci***<br>
*// Analogicky můžete ukazatel na anonymní funkci předat jako parametr jiné funkci. Poznámka: raději se nesnažte získávat ukazatele na vestavěné funkce Perlu; pravděpodobně to nebude fungovat.*<br>
**\\&amp;**{*identifkátor\_funkce*}<br>
{*$proměnná*} **= sub \{**[{*příkazy*}]...**\};**

*# získat ukazatel na **regulární výraz** (obecně/příklad)*<br>
**qr/**{*regulární výraz*}**/**<br>
**$můjVýraz = qr/^ab\\.c/**

*# získat ukazatel na prvek pole/hodnotu v asociativním poli*<br>
*// Poznámka: klíče v asociativním poli jsou nepřiřaditelné, proto ukazatel na ně nelze získat.*<br>
**\\$**{*identifkátor\_pole*}**[**{*index*}**]**<br>
**\\$**{*identifkátor\_asociativního\_pole*}**\{**{*klíč*}**\}**<br>

*# získat ukazatel na anonymní objekt: skalár/pole/asociativní pole*<br>
**\\(**{*hodnota*}**)**<br>
**[**{*seznam*}**]**<br>
**\{**{*seznam,dvojic*}**\}**

*# získat ukazatel na hodnotu v asociativním poli dostupném přes ukazatel*<br>
**\\$**{*ukazatel-na-asoc-pole*}**-&gt;\{**{*klíč*}**\}**

### Dereferencovat ukazatel

*# přistoupit přes ukazatel ke skaláru/poli/asociativnímu poli/funkci*<br>
**\${\$**{*identifikátor\_ukazatele*}**\}**<br>
**@{$**{*identifikátor\_ukazatele*}**\}**<br>
**%{$**{*identifikátor\_ukazatele*}**\}**<br>
**&amp;{$**{*identifikátor\_ukazatele*}**\}**

*# přistoupit přes ukazatel k prvku pole/asociativního pole*<br>
{*$ukazatel*}**-&gt;[**{*index*}**]**<br>
{*$ukazatel*}**-&gt;\{**{*klíč*}**\}**

*# zavolat přes ukazatel funkci*<br>
{*$ukazatel*}**-&gt;(**{*seznam, parametrů*}...**)**






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

*# otevřít rouru pro zápis/pro čtení*<br>
**open(my **{*$proud*}**, "\|-", "**{*název-příkazu*}**"**[**,** {*parametr-příkazu*}]...**)** [**or die(**{*zpráva*}**)**]**;** [**binmode(**{*$proud*}**, ":raw");**]<br>
**open(my **{*$proud*}**, "-\|", "**{*název-příkazu*}**"**[**,** {*parametr-příkazu*}]...**)** [**or die(**{*zpráva*}**)**]**;** [**binmode(**{*$proud*}**, ":raw");**]

*# otevřít číslovaný vstup či výstup*<br>
*// Deskriptory jsou číslované proudy, které typicky otevírá bash před spuštěním každého procesu. Deskriptory číslo 0, 1 a 2 se nazývají „standardní vstup“, „standardní výstup“ a „standardní chybový výstup. Režim je v tomto případě buď „&lt;“ pro čtení z deskriptoru, nebo „&gt;“ pro zápis do deskriptoru.“*<br>
**open(my **{*$proud*}**, "**{*režim*}**&amp;=**{*číslo*}**")** [**or die(**{*"chybová zpráva"*}**)**]**;** [**binmode(**{*$proud*}**, ":raw");**]

*# **přepnout režim** proudu na binární/textový*<br>
*// Tento příkaz nesmí být použit poté, co už bylo s proudem od otevření manipulováno (např. čtením, zápisem, přesouváním apod.) Proto ho doporučuji používat jen okamžitě po otevření proudu.*<br>
**binmode(**{*$proud*}**, ":raw");**<br>
**binmode(**{*$proud*}**, ":utf8");**<br>

### Standardní výstup a chybová hlášení

*# vypsat **položky seznamu** oddělené hodnotou $OFS a zakončené hodnotou $ORS*<br>
**print(**{*položky, seznamu*}**);**

*# **printf()***<br>
**printf(**{*"formátovací řetězec"*}[**,** {*parametry*}...]**);**

*# vypsat **řetězec***<br>
**printf("%s",** {*řetězec*}**);**

*# vypsat **varování** na standardní chybový výstup*<br>
*// Perl doplní chybové hlášení o označení zdrojového kódu a číslo řádky.*<br>
**warn(**{*"zpráva"*}[**,** {*"pokračování zprávy"*}]**);**

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
{*$cíl*} **= do {local $RS = \\**{*N*}**; scalar(readline(**{*$proud*}**));}**
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
**fprintf(**{*$proud*}**, "%s", pack("C\*",** {*řetězec*}**));**<br>

*# zapsat bajt (znak/z číselné hodnoty)*<br>
**fprintf(**{*$proud*}**, "%s",** {*$znak*}**);**<br>
**fprintf(**{*$proud*}**, "%c",** {*$číslo*}**);**

*# přesun na pozici N bajtů od začátku/od konce/od akt. pozice vpřed/od akt. poz. vzad (nepoužívat na roury)*<br>
**seek(**{*$f*}**,** {*N*}**, 0);**<br>
**seek(**{*$f*}**, -**{*N*}**, 2);**
**seek(**{*$f*}**,** {*N*}**, 1);**
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

### Zjistit informace o adresářové položce*<br>

Poznámka: v případě, že funkce stat() selže, vrátí prázné pole; proto čtení jeho kteréhokoliv prvku vrátí undef. Mód a typ adresářové položky budou v takovém případě 0.

*# **typ** adresářové položky (s následováním symb. odkazů/bez následování)*<br>
*// Typ je: 1 pro pojmenovanou rouru; 2 pro znakové zařízení; 4 pro adresář; 6 pro blokové zařízení; 8 pro soubor; 10 pro symbolický odkaz (jen u funkce „lstat“!) a 12 pro soket.*<br>
**(stat(**{*"cesta"*}**))[2] // 0 &gt;&gt; 12** ⊨ 8<br>
**(lstat(**{*"cesta"*}**))[2] // 0 &gt;&gt; 12** ⊨ 10

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
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

*# *<br>
**lkk perl** [{*parametry Perlu*}] {*soubor-skriptu.pl*} [{*parametry skriptu*}]

*Varování:* Nikdy do svých skriptů Perlu neuvádějte direktivu interpretu „#!“
(např. „#!/usr/bin/perl“)! Není snadné to udělat správně a neopatrné použití
této direktivy může způsobit, že skript nepůjde spustit vůbec nebo se místo
něj spustí něco úplně jiného.

<!--
### Jak vytvářet a spouštět skripty


Skript pak spustíte příkazem „lkk perl“:

-->

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíčků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

!ÚzkýRežim: zap

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

* *Předávání parametrů do funkcí:* Parametry se do funkce předají pomocí pole „@\_“, které má tu speciální vlastnost, že ty jeho prvky, které byly v místě předání *přiřaditelnými* hodnotami (včetně např. prvků jiných polí) se do něj předají odkazem. To znamená, že skalární proměnné se do všech funkcí předávají odkazem, nikdy hodnotou. Pole (včetně seznamů) se při předávání do funkce rozloží na všechny svoje prvky v náležitém pořadí a ty se předají odkazem. Asociativní pole se rozloží na posloupnost dvojic „klíč,hodnota“, příčemž klíče se předají hodnotou (jsou nepřiřaditelné), zatímco hodnoty se předají odkazem. Perl neprovádí žádnou automatickou kontrolu počtu, typu či hodnoty předaných parametrů; ta je výhradně zodpovědností volané funkce.
* Seznam (na rozdíl od pole) obsahuje svoje prvky odkazem (pozor, neplést s ukazatelem) a přiřazuje se do něj po prvcích; to znamená, že např. výrazem **($a, $b) = (1, 2)** přiřadíte do proměnné **$a** hodnotu 1 a do proměnné **$b** hodnotu 2; podobně výrazem „($a, $b) = @x“ načtete do proměnných $a a $b první dva prvky pole @x. Uvedete-li do seznamu pole nebo vnořený seznam, ten se „rozbalí“ na svoje prvky, proto např. výrazem „(@x) = (1, 2)“ přiřadíte hodnoty do prvních dvou prvků pole, aniž byste ho zkrátili; oproti tomu příkazem „@x = (1, 2)“ přiřadíte do proměnné „@x“ nové, dvouprvkové pole.
* Dokumentace Perlu radí upřednostňovat funkci „print“ před „printf“, protože je rychlejší a snáze se píše. To první je nejspíš pravda, ale pokud ji chcete použít korektně, musíte před každým voláním nastavit proměnné $OFS a $ORS, protože funkce „print“ je vypisuje, a budou-li nastaveny na nečekané hodnoty z jiné části programu, bude výstup vaší funkce nekorektní, pokud jejich hodnoty nebudete mít pod kontrolou. Napsat "%s" do printf je mnohem jednodušší než neustále přiřazovat $OFS a $ORS.
* Blok kódu předávaný funkci jako zvláštní první parametr (což se týká především vestavěných funkcí „map“ a „grep“) *nesmí* obsahovat příkaz „return“, jinak tento příkaz ukončí obalující funkci a vrátí návratovou hodnotu z ní! To neplatí v případě, kdy se blok předává ukazatelem na anonymní funkci (s klíčovým slovem „sub“), tam je naopak příkaz „return“ vhodný.

<!--
(Poznámka: v Perlu mohou existovat i skaláry, které mají nesouvisející číselnou a řetězcovou hodnotu, např. mají řetězcovou hodnotu "Hello" a číselnou hodnotu 13. Doufejte však, že na takové zrůdnosti při svém programování nenarazíte.)
-->

### Regulární výraz a řetězec náhrady

Uvnitř regulárních výrazů v Perlu můžete použít interpolaci skalární proměnné, např. takto:

*# *<br>
**if ("abc" =~ /a${proměnná}c/) \{**{*...*}**\}**

Proměnná může obsahovat buď ukazatel na regulární výraz (ten se pak zakomponuje do nového regulárního výrazu), nebo řetězec – ten se za běhu interpretuje jako regulární výraz a také se zakomponuje.

Pokud proměnná obsahuje text a chcete ho vložit bez intepretace zvláštních znaků, použijte tento zvláštní druh interpolace do regulárního výrazu:

*# *<br>
**if ("abc" =~ /a\\Q${proměnná}\\Ec/) \{**{*...*}**\}**

Uvnitř řetězců náhrady platí stejná pravidla odzvláštňování jako v řetězcových literálech obklopených dvojitými uvozovkami, až na to, že „"“ je obyčejný znak a „/“ je na místo toho zvláštní. Uvnitř řetězce náhrady můžete použít speciální proměnné $&amp; (nahradí se za text shody) a $1, $2, ..., $9, ${10}, ... (nahradí se za text odpovídajícího záchytu). Také tam můžete použít interpolaci obyčejné proměnné, její text se použije doslova, bez interpretace zvláštních znaků.

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

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

<!--
https://perldoc.perl.org/5.30.3/functions
https://perldoc.perl.org/5.30.3/perlvar
-->

!ÚzkýRežim: vyp

## Pomocné funkce a skripty

*# lkk perl – spouštěč, který spustí skript Perlu s doporučenými parametry*<br>
**#!/bin/bash**<br>
**exec perl -CSDAL -I/usr/share/lkk/perl -Mv5.26.0 -Mstrict -Mwarnings -Mutf8 -MEnglish -MLinuxKnihaKouzel "$@"**
