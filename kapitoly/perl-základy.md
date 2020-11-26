<!--

Linux Kniha kouzel, kapitola Základy Perlu
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

# Základy Perlu

!Štítky: {program}{zpracování textu}{syntaxe}{Perl}{programování}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Perl je skriptovací jazyk určený především pro zpracování textu.
Mezi programátory je velmi oblíbený a rozšířený, má však špatnou pověst,
protože je multisyntaktický a pro neodborníka velmi špatně čitelný.
Přesto je velmi užitečný a při využití jen malé podmnožiny jeho vlastností
je snadné v něm začít programovat. Perl je ale také zákeřný programovací
jazyk, v němž se proměnné nejčastěji deklarují klíčovým slovem „my“,
podmínka „if (false)“ je splněna (ačkoliv generuje varování),
modul Perlu musí končit příkazem „1;“ a příkaz náhrady „s/.$/@/“
provedený nad řetězcem "X\\n\\n\\n" nikdy neskončí výsledkem
"X\\n\\n@" jako v GNU Sedu, ale výsledkem "X\\n\\n\\n", popř. pokud
přidáte ještě modifikátor „s“, výsledkem "X\\n@@"; ke stejnému chování
jako v sedu ho však nedonutíte.

Úspěšné použití takového jazyka vyžaduje buď hlubokou znalost,
nebo se omezit na bezpečnou podmnožinu jeho funkcionality.
Tato kapitola druhou uvedenou cestu a než se naučíte znát
pokročilé vlastnosti Perlu, tato kapitola vám pomůže vyhýbat
se jeho zákeřným pastem, a přesto z jeho moci vytěžit co nejvíc.

Tato kapitola nepokrývá moduly, objekty a část užitečných
knihovních funkcí, ty budou v budoucnu předmětem samostatné kapitoly.

*Poznámka:* Všechna zaklínadla v této kapitole předpokládají,
že máte nainstalovaný balíček DEB Linuxu: Knihy kouzel,
svoje skripty budete spouštět příkazem „lkk perl“ (viz sekci „Parametry příkazů“)
a na jejich začátek uvedete následující řádku:

*# *<br>
**require "/usr/share/lkk/LinuxKnihaKouzel.pl";**<br>

## Definice

* **Skalár** je dynamicky typovaná proměnná, která může obsahovat řetězec, číslo, ukazatel na nějaký objekt nebo zvláštní **nehodnotu undef**, která je výchozí hodnotou skalárů (a lze ji také považovat za „ukazatel nikam“). Přístup ke skaláru se značí znakem „$“.
* **Pole** (array, list) je uspořádaný kontejner skalárů indexovaný celými čísly 0, 1, 2 atd. Přístup k poli jako celku se značí znakem „@“, pro přístup k jeho prvku se použije znak „$“ (protože jeho prvek je skalár) a index v hranatých závorkách „[]“. Výchozí hodnotou je prázdné pole.
* **Asociativní pole** (hash) je neuspořádaný kontejner skalárů (**hodnot**) indexovaný libovolnými řetězci (**klíči**). Přístup k asociativnímu poli jako celku se značí znakem „%“, pro přístup k jeho prvku se použije znak „$“ a klíč (skalár) ve složených závorkách „{}“. Asociativní pole se inicializují poli či seznamy se sudým počtem prvků, kde se první prvek každé dvojice interpretuje jako klíč a druhý jako odpovídající hodnota. Výchozí hodnotou je prázdné asociativní pole.

<neodsadit>Proměnné každého z těchto typů mají svůj vlastní jmenný prostor, takže je v pořádku mít vedle sebe proměnné „$x“, „@x“ a „%x“, jsou to tři nezávislé proměnné.

* **Ukazatel** (reference, v češtině obvykle nazývaný „odkaz“) je skalár, který odkazuje na nějaký objekt v paměti (pole, funkci, regulární výraz atd.). **Dereferencí** ukazatele získáváme přímý přístup k odkazovanému objektu, bez ní se operace vždy týkají ukazatele jako takového.
* **Seznam** je dočasný objekt příbuzný poli; zadává se výčtem prvků v kulatých závorkách, např. „(1, $b, 3)“. Kulaté závorky se nepoužijí, pokud je seznam bezprostředně obalen dalšími kulatými nebo hranatými závorkami.
* Důležitou vlastností seznamů je **zplošťování** — když v seznamu uvedete vnořený seznam, pole nebo asociativní pole, obvykle se rozvine na všechny svoje prvky v odpovídajícím pořadí, jako byste je uvedl/a přímo. Nespoléhejte se však na zplošťování při volání systémových a knihovních funkcí (může být ovlivněno tzv. prototypem funkce) a v seznamech stojících na levé straně operátoru přiřazení (tam funguje trochu jinak).

!ÚzkýRežim: vyp

<!--
==================================================================================
-->
## Zaklínadla: Základní

### Proměnné

*# **deklarovat** proměnnou typu skalár/pole/asociativní pole viditelnou v bloku*<br>
**my $**{*identifikátor*} [**=** {*inicializace*}]**;**<br>
**my @**{*identifikátor*} [**=** {*inicializace*}]**;**<br>
**my %**{*identifikátor*} [**=** {*inicializace*}]**;**

*# deklarovat proměnnou viditelnou i v jiných modulech*<br>
**our** {*symbol*}{*identifikátor*} [**=** {*inicializace*}]**;**

*# do konce bloku překrýt globální proměnnou*<br>
*// Příkaz „local“ způsobí, že uvedená globální proměnná se „odloží“ a místo ní se vytvoří nová pod tímtéž názvem. Po opuštění bloku překryvná proměnná zanikne a původní proměnná se vrátí. Tato konstrukce se běžně používá pro překrytí speciálních proměnných jako např. „$ORS“, jimž umožňuje nastavit místní hodnotu platnou jen do konce bloku, ale platnou i ve volaných funkcích.*<br>
**local** {*symbol*}{*identifikátor*} [**=** {*nová-hodnota*}]**;**

### Skaláry a undef

*# má skalár hodnotu? (tzn. není undef)*<br>
**defined(**{*$skalár*}**)**

*# přečíst skalární proměnnou/**přiřadit** do ní/přiřadit do ní **undef***<br>
**$**{*identifikátor*}<br>
**$**{*identifikátor*} **=** {*hodnota*}<br>
**$**{*identifikátor*} **= undef**

*# zjistit typ skaláru*<br>
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

*# zavolat funkci přijímající blok příkazů*<br>
*// Ačkoliv Perl dovoluje zapsat volání s blokem příkazů na jednu řádku, pro přehlednost této už tak dost odpudivé syntaxe vždy oddělujte příkazy bloku od volání funkce a používejte náležité odsazení, i když bude příkaz jen jeden a velmi jednoduchý, jako třeba „$ARG &gt;= 0“. Návratovou hodnotou předaného bloku bude hodnota posledního provedeného příkazu, nepoužívejte v bloku příkaz „return“!*<br>
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
<odsadit1>[{*příkazy*}]...<br>
**\}**

*# pole parametrů uvnitř funkce*<br>
*// Na rozdíl od normálních polí, prvky tohoto speciálního pole se do funkce předávají odkazem. To znamená, že přiřazením do prvků tohoto pole můžete změnit proměnné (popř. prvky pole či hodnoty asociativního pole), které byly při volání funkce zadány. Pokud bylo daným parametrem funkce něco nepřiřaditelného, takové přiřazení se bude tiše ignorovat.*<br>
**@ARG**

*# získat ukazatel na **anonymní funkci***<br>
**sub \{**[{*příkazy*}]...**\}**

*# definovat funkci přijímající blok příkazů*<br>
*// Předaný blok zavoláte jako funkci příkazem „$id-&gt;()“, kde id je zvolený identifikátor proměnné.*<br>
^^**sub** {*identifikátor\_funkce*} **(&amp;@);**<br>
**sub** {*identifikátor\_funkce*} **(&amp;@)**<br>
**\{**<br>
<odsadit1>**my $**{*id*} **= shift(@ARG);**<br>
<odsadit1>[{*příkazy*}]...<br>
**\}**

### Komentáře

*# komentář do konce řádku*<br>
**#** {*obsah komentáře*}

*# víceřádkový komentář*<br>
*// Pozor, před znakem „=“ na uvedených speciálních řádcích nesmí být žádný jiný znak, ani odsazení!*<br>
**=begin&blank;comment**<br>
{*obsah komentáře (i víc řádků)*}<br>
**=end&blank;comment**<br>
**=cut**

### Cykly

*# cyklus **for** (s definicí vlastní proměnné/obecný)*<br>
[{*návěští*}**:**] **for (my $**{*identifikátor*} **=** {*výraz*}**;** [{*podmínka*}]**;** [{*výraz-iterace*}]**)** {*blok příkazů*}
[{*návěští*}**:**] **for (**[{*výraz-inicializace*}]**;** [{*podmínka*}]**;** [{*výraz-iterace*}]**)** {*blok příkazů*}

*# cyklus **foreach***<br>
*// „Prvky“ zde mohou být jak jednotlivé skaláry, tak i pole a asociativní pole, která se rozloží, stejně jako při volání funkcí.*<br>
[{*návěští*}**:**] **foreach** [**my**] **$**{*identifikátor*} **(**{*prvky*}**)** {*blok příkazů*} [**continue** {*další blok příkazů*}]

*# cyklus typu **while** (s pozitivní podmínkou/negovanou podmínkou)*<br>
[{*návěští*}**:**] **while (**{*podmínka*}**)** {*blok příkazů*} [**continue** {*další blok příkazů*}]<br>
[{*návěští*}**:**] **until (**{*podmínka*}**)** {*blok příkazů*} [**continue** {*další blok příkazů*}]

*# cyklus typu **do...while** (s pozitivní podmínkou/negovanou podmínkou)*<br>
**do** {*blok příkazů*} **while (**{*podmínka*}**);**<br>
**do** {*blok příkazů*} **while (!(**{*podmínka*}**));**

*# nekonečný cyklus*<br>
[{*návěští*}**:**] **for (;;)** {*blok příkazů*}

### Řízení toku (skoky)

*# vyskočit z funkce a **vrátit** návratovou hodnotu*<br>
*// Příkaz „return“ v Perlu není povinný. Při jeho nepoužití vrátí Perl hodnotu posledního provedeného příkazu ve funkci.*<br>
**return** {*návratová hodnota*}**;**

*# vyskočit za konec cyklu*<br>
**last** [{*návěští*}]**;**

*# skočit těsně před uzavírací závorku cyklu*<br>
**next** [{*návěští*}]**;**

*# skočit přímo za otevírací závorku cyklu*<br>
**redo** [{*návěští*}]**;**

*# skočit na návěští*<br>
**goto** {*návěští*}**;**

*# ukončit program*<br>
**exit(**[{*návratový-kód*}]**);**

*# pozdržet program o daný počet sekund*<br>
**my $**{*pomocnáProměnná*} **=** {*N*}**;**<br>
**while (($**{*pomocnáProměnná*} **-= sleep($**{*pomocnáProměnná*}**)) &gt; 0) {}**

*# ukončit program s hlášením kritické chyby (obecně/příklad)*<br>
**die("**{*text*}**"**[**,** {*pokračování textu*}]**);**<br>
**die("Nastala chyba číslo&blank;", $čísloChyby, "!");**

### Podmínky

*# provést blok příkazů, je-li podmínka pravdivá/nepravdivá*<br>
**if (**{*podmínka*}**) \{** [{*příkazy*}] **\}** [**elsif (**{*další podmínka*}**) \{** [{*příkazy*}] **\}**]... [**else \{** [{*příkazy*}] **\}**]<br>
**unless (**{*podmínka*}**) \{** [{*příkazy*}] **\}** [**elsif (**{*další podmínka*}**) \{** [{*příkazy*}] **\}**]... [**else \{** [{*příkazy*}] **\}**]

*# provést příkaz, je-li podmínka pravdivá (alterantivy)*<br>
{*podmínka*} **and** {*příkaz*}**;**<br>
{*příkaz*} **if (**{*podmínka*}**);**

*# provést příkaz, je-li podmínka nepravdivá (alterantivy)*<br>
{*podmínka*} **or** {*příkaz*}**;**<br>
{*příkaz*} **unless (**{*podmínka*}**);**

*# přepínač „**switch**“ bez větve „default“*<br>
*// V případě zanoření změňte ve vnořeném kódu identifkátory „hodnota“ a „příznak“. Poznámka: příkaz „next“ používejte uvnitř této konstrukce pouze s návěštím.*<br>
[{*návěští*}**:**] **foreach my $hodnota (** {*skalární-výraz*}**) \{**<br>
**my $příznak = 0;**<br>
[**if ($příznak || ($příznak = $hodnota eq** {*hodnota*}**))** {*blok příkazů*}]...<br>
**\}**

*# přepínač „**switch**“ s větví „default“*<br>
*// Použijete-li tuto konstrukci v programu víckrát, při každém použití změňte identifkátor „default“! V případě zanoření změňte ve vnořeném kódu také identifkátory „hodnota“ a „příznak“.*<br>
[{*návěští*}**:**] **foreach my $hodnota (** {*skalární-výraz*}**) \{**<br>
**my $příznak = 0;**<br>
[**if ($příznak || ($příznak = $hodnota eq** {*hodnota*}**))** {*blok příkazů*}]...<br>
!: Někam do těla konstrukce umístěte před některý příkaz návěští „default:“.<br>
**unless ($příznak) {$příznak = 1; goto default;}**
**\}**

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

*# řetězec vkládaný funkcí „print“ mezi argumenty/za poslední argument*<br>
*// Výchozí hodnota obou proměnných je nehodnota undef, která zde má stejný význam jako prázdný řetězec.*<br>
**$OFS** ⊨ undef<br>
**$ORS** ⊨ undef

*# vstupní ukončovač záznamu*<br>
*// Jako ukončovač lze nastavit libovolný řetězec. Existují dva zvláštní případy: nastavení na prázdný řetězec způsobí, že jako ukončovač bude rozpoznána jakákoliv posloupnost dvou nebo více znaků \\n; nehodnota undef způsobí, že vstup nebude dělený na záznamy a rovnou načte celý zbytek vstupního souboru.*<br>
**$RS** ⊨ "\\n"

*# verze Perlu (jen čtení)*<br>
**$PERL\_VERSION** ⊨ "v5.30.0"

*# pole parametrů skriptu (obecně/příklad použití)*<br>
*// Na rozdíl od Bashe toto pole neobsahuje nultý parametr (název skriptu). Jsou to opravdu jen parametry předané skriptu na příkazovém řádku.*<br>
**@ARGV**<br>
**my $parametr1 = $ARGV[0];**

*# pole proměnných prostředí (obecně/příklad použití)*<br>
*// Přiřazením je možno proměnné prostředí vytvářet a měnit.*<br>
**%ENV**<br>
**$ENV{"HOME"}** ⊨ "/home/petr"

*# PID/PPID procesu (jen čtení)*<br>
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

*# číslo na hexadecimální řetězec s malými/velkými písmeny/opačná konverze*<br>
**sprintf("%x",** {*číslo*}**)** ⊨ "3f7"<br>
**sprintf("%x",** {*číslo*}**)** ⊨ "3F7"<br>
**hex(**{*řetězec*}**)** ⊨ 1015

*# číslo na oktalový řetězec s malými/velkými písmeny/opačná konverze*<br>
**sprintf("%x",** {*číslo*}**)** ⊨ "1767"<br>
**sprintf("%x",** {*číslo*}**)** ⊨ "1767"<br>
**oct(**{*řetězec*}**)** ⊨ 1015

*# změnit aktuální adresář*<br>
**chdir(**{*cesta*}**)** [**or die(**{*...*}**)**]**;**

*# zjistit aktuální adresář*<br>
^^**use Cwd;**<br>
**getcwd()** ⊨ "/home/alena/linux-spellbook"


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

*# kódové číslo Unicode prvního znaku řetězce*<br>
**ord(**{*řetězec*}**)** ⊨ 382

*# **zopakovat** řetězec (obecně/příklad)*<br>
{*$řetězec*} **x** {*$počet*}<br>
**"abc" x 3** ⊨ "abcabcabc"

*# řetězec na malá/velká písmena*<br>
**lc(**{*řetězec*}**)** ⊨ "žluťoučký kůň"<br>
**uc(**{*řetězec*}**)** ⊨ "ŽLUŤOUČKÝ KŮŇ"

*# obrátit pořadí znaků v řetězci*<br>
**scalar(reverse(**{*řetězec*}**))** ⊨ adeceba

*# zjistit počet bajtů UTF-8*<br>
^^**use Encode;**<br>
**length(Encode::encode("UTF-8",** {*řetězec*}**))**

### Podřetězce a dělení

*# získat **podřetězec***<br>
*// Poznámka: kladný počáteční index musí ležet uvnitř řetězce; k zápornému se přičte délka řetězce a uvnitř řetězce ležet nemusí, takže např. „substr($s, -1)“ vrátí poslední znak řetězce, ale pro prázdný řetězec vrátí jen prázdný řetězec.*<br>
**substr(**{*$skalár*}**,** {*počáteční-index*}[**,** {*maximální-délka*}]**)**

*# odebrat z řetězce v proměnné ukončovač záznamu*<br>
*// Odebere z proměnné ukončovač podle nastavení speciální proměnné $RS. Velmi často se používá po načtení řádky. Pokud řetězec ukončovačem nekončí, proměnná zůstane nezměněná.*<br>
**chomp(**{*$proměnná*}**);**

*# rozdělit řetězec na pole (obecně/příklady)*<br>
*// Oddělovač může být buď skalár (např. řetězec), nebo literál regulárního výrazu v lomítkách.*<br>
[{*@pole*} **=**] **split(**{*oddělovač*}**,** {*dělený-řetězec*}[**,** {*maximální-počet-dílů*}]**)**<br>
**@pole = split(":", $s);**<br>
**@pole = split(/[:;]/, $s);**
<!--
[ ] Split podrobněji!
-->

<!--
*# spojit pole na řetězec (obecně/příklady)*<br>
**my $v = join("", @pole);**<br>
**my $v = join(",", @pole, ":", @pole2);**
-->

*# vyjmout z řetězce v proměnné poslední znak (obecně/příklad)*<br>
*// Pro prázdný řetězec vrací funkce chop() prázdný řetězec a proměnnou nezmění.*<br>
**chop(**{*$proměnná*}**)**<br>
**my $x = "abe"; printf("1: %s ", chop($x)); printf("2: %s\\n", chop($x));** ⊨ 1: e 2: b

*# rozdělit řetězec na poloviny*<br>
**(substr(**{*$skalár*}**, 0, length(**{*$skalár*}**) / 2), substr(**{*$skalár*}**, length(**{*$skalár*}**) / 2))**

### Literály řetězců

*# řetězcový **literál** (alternativy)*<br>
*// V apostrofech je zvláštním znakem pouze apostrof a odzvláštnění není možné (můžete jedině apostrof nahradit za nečitelnou konstrukci „'."'".'“ a pak si musíte dát pozor na prioritu operátorů). Ve dvojitých uvozovkách jsou zvláštní následující znaky: „"$@%\\“, všechny lze odzvláštnit zpětným lomítkem. Navíc se tam intepretují některé sekvence začínající zpětným lomítkem jako např. „\\n“, ale ne všechny. V obou případech však může literál obsahovat konec řádky bez odzvláštnění.*<br>
**"**{*text*}**"**<br>
**'**{*text*}**'**

*# prázdný řetězec*<br>
**""**

*# interpolovat skalární proměnnou*<br>
**"**{*...*}**$\{**{*identifikátor*}**\}**{*...*}**"**

*# znak Unicode podle kódového čísla (obecně/příklady)*<br>
**chr(**{*číslo*}**)**<br>
**chr(0x017e)** ⊨ "ž"<br>
**chr(0x1f642)**


### Hledání shod s regulárním výrazem

*# má/nemá shodu s regulárním výrazem?*<br>
{*řetězec*} **=~ /**{*regulární výraz*}**/**[**i**]<nic>[**m**]<br>
{*řetězec*} **!~ /**{*regulární výraz*}**/**[**i**]<nic>[**m**]

*# najít index na začátku/za koncem první shody s regulárním výrazem*<br>
**(**{*řetězec*} **=~ /**{*regulární výraz*}**/**[**i**]<nic>[**m**] **? $LAST\_MATCH\_START[0] : undef)**<br>
**(**{*řetězec*} **=~ /**{*regulární výraz*}**/**[**i**]<nic>[**m**] **? $LAST\_MATCH\_END[0] : undef)**

### Hledání podřetězců

*# index začátku prvního/posledního výskytu podřetězce*<br>
*// Nebyl-li podřetězec nalezen, funkce vrací -1. Limit u funkce „rindex()“ znamená, že budou ignorovány výskyty podřetězce, které začínají na vyšším indexu, než je uvedený limit.*<br>
**index(**{*řetězec*}**,** {*podřetězec*} [**,**{*index-začátku-vyhledávání*}**)**<br>
**rindex(**{*řetězec*}**,** {*podřetězec*} [**,**{*limit*}**)**<br>

### Náhrady v řetězcové proměnné

*# provést náhradu pomocí regulárního výrazu (výsledek: přiřadit zpět/vrátit jako hodnotu)*<br>
{*$proměnná*} **=~ s/**{*regulární výraz*}**/**{*řetězec náhrady*}**/**[**g**]<nic>[**i**]<nic>[**m**]<nic>[**s**]<br>
{*$řetězec*} **=~ s/**{*regulární výraz*}**/**{*řetězec náhrady*}**/r**[**g**]<nic>[**i**]<nic>[**m**]<nic>[**s**]

*# přeložit znaky pomocí překladové tabulky*<br>
*// Poznámka: výsledek překladu přepíše původní proměnnou, ale není návratovou hodnotou výrazu!*<br>
{*$proměnná*} **=~ y/**{*původní-znaky*}**/**{*nové-znaky*}**/**

*# nahradit podřetězec v proměnné (původní podřetězec zahodit/získat jako návr. hodnotu)*<br>
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

### Ostatní operace

*# formátovat funkcí sprintf()*<br>
**sprintf(**{*formát*}**,** {*seznam, parametrů*}**)**

*# získat číselnou **heš** řetězce*<br>
^^**use Digest::MD5;**<br>
**unpack("L", substr(Digest::MD5::md5(**{*řetězec*}**), 0, 4))**

<!--
Digest::MD5::md5_hex(s) vrací hexadecimální tvar (32 znaků, malá písmena)
-->

*# získat MD5 řetězce (hexadecimální)*<br>
^^**use Digest::MD5;**<br>
**Digest::MD5::md5\_hex(**{*řetězec*}**)**


<!--
==================================================================================
-->
## Zaklínadla: Pole a asociativní pole

<!--
https://metacpan.org/pod/List::MoreUtils
-->

### Literály polí a asociativních polí

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

*# seznam celých čísel v daném rozsahu (obecně/příklady)*<br>
**(**{*celé-číslo*}**..**{*celé-číslo*}**)**<br>
**(-1..4)** ⊨ (-1, 0, 1, 2, 3, 4)<br>
**(2..5, -3..-1)** ⊨ (2, 3, 4, 5, -3, -2, -1)

*# **zopakovat** seznam (obecně/příklad použití)*<br>
{*(seznam)*} **x** {*počet*}<br>
**my @dvanáct\_undefů = (undef) x 12;**

*# seznam znaků UCS v daném kódovém rozsahu (alternativy)*<br>
**(map {chr($ARG)}** {*první-kód*}**..**{*poslední-kód*}**)**<br>
**(map {chr($ARG)} ord("**{*první-znak*}**")..ord("**{*poslední-znak*}**"))**

### Asociativní pole

*# literál asociativního pole (jako hodnotu/jako ukazatel na asociativní pole)*<br>
**(**[{*klíč*}**,** {*hodnota*}[**,** {*další klíč*}**,** {*další hodnota*}]...]**)**<br>
**\{**[{*klíč*}**,** {*hodnota*}[**,** {*další klíč*}**,** {*další hodnota*}]...]**\}**

*# **smazat** prvek/všechny prvky*<br>
**delete $**{*id\_pole*}**\{**{*klíč*}**\};**<br>
{*%pole*} **= ();**
<!--
Problém: co když pracuji s referencí?
-->

*# **obsahuje** prvek?*<br>
**exists($**{*id\_pole*}**\{**{*klíč*}**\})**

*# **přidat** či přepsat prvek*<br>
**$**{*id\_pole*}**\{**{*klíč*}**\} =** {*hodnota*}

*# získat pole klíčů/hodnot*<br>
**keys(**{*%pole*}**)** ⊨ (1, 2, 3)<br>
**values(**{*%pole*}**)** ⊨ ("", undef, "xyz")

*# získat počet dvojic v asociativním poli*<br>
**alength(keys(**{*%pole*}**))** ⊨ 3


### Základní operace

*# **přečíst** prvek pole (obecně/příklad)*<br>
**$**{*identifikátor\_pole*}**[**{*index*}**]**<br>
**$mojepole[12]**

*# **přiřadit** prvku pole (obecně/příklad)*<br>
**$**{*identifikátor\_pole*}**[**{*index*}**] =** {*skalár*}<br>
**$mojepole[12] = undef**

*# přečíst prvek asociativního pole/přiřadit do něj/příklad*<br>
*// Klíč je řetězec, resp. skalární proměnná. Spr*<br>
**$**{*identifikátor*}**\{**{*klíč*}**\}**<br>
**$**{*identifikátor*}**\{**{*klíč*}**\}** **=** {*hodnota*}<br>
**$apole{"abc"} = "def";**

*# první/poslední prvek pole*<br>
**$**{*identifikátor\_pole*}**[0]**<br>
**$**{*identifikátor\_pole*}**[-1]**

*# deklarovat proměnnou typu pole (obecně/příklady)*<br>
**my @**{*identifikátor\_pole*} [**=** {*inicializace*}]**;**<br>
**my @pole = qw(5 6 7);**<br>
**my @pole = ("a", "bc", "d");**

*# zopakovat seznam (obecně/příklad)*<br>
{*seznam*} **x** {*počet*}<br>
**("a", undef) x 2** ⊨ ("a", undef, "a", undef)

*# zopakovat obsah pole (obecně/příklad)*<br>
**(**{*@pole*}**) x** {*počet*}<br>
**(@test) x 5**


*# rozložit pole do nových skalárních proměnných*<br>
*// Přebytečné prvky pole se zahazují. Přebytečné proměnné se vyplní nehodnotou undef.*<br>
**my ($**{*id*}[**,** {*další\_id*}]...**) =** {*@pole*}**;**

*# přiřadit celé pole (alternativy)*<br>
**@**{*cílové\_pole*} **= @**{*zdrojové\_pole*}<br>
**@**{*cílové\_pole*} **=** {*(seznam)*}

*# seznam prvků pole podle indexů z jiného pole*<br>
?

*# obrátit pořadí prvků v poli*<br>
**array(reverse(**{*seznam*}**))**

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


### Velikost pole

*# zjistit **počet prvků** pole*<br>
**alength(**{*@pole*}**)**

*# je pole **prázdné**?*<br>
**alength(**{*@pole*}**) == 0**

### Průchod a zpracování pole

*# transformovat po prvcích*<br>
*// Operátor „map“ funguje přesně jako cyklus „foreach (@pole)“ (tzn. v uvedeném bloku je $ARG odkaz na právě zpracovávaný prvek pole), až na to, že jeho návratovou hodnotou je seznam hodnot posledního provedeného příkazu bloku v každém cyklu. Protože je $ARG odkaz, můžete ho využít k modifikaci prvků původního pole.*<br>
**(map \{**<br>
<odsadit1>{*příkaz*}...<br>
**\}** {*@pole*}**)**

*# vybrat prvky*<br>
*// Výsledkem je seznam prvků, pro které se poslední příkaz v bloku vyhodnotí jako logická pravda.*<br>
**array(grep \{**<br>
<odsadit1>{*příkaz*}...<br>
**\}** {*@pole*}**)**

*# zpracovat po dvojicích*<br>
?

*# zpracovat po N-ticích*<br>
^^**use List\:\:MoreUtils;**<br>
**foreach (natatime(**{*N*}**,** {*prvky, seznamu*}...**)) \{**<br>
<odsadit1>**my @**{*pole*} **= $ARG-&gt;();**<br>
<odsadit1>{*příkaz;*}...<br>
**\}**

### Filtrování

*# vynechat prvky, které se již vyskytly*<br>
*// Funkce provádí řetězcové porovnání prvků, ne číselné. Zachovává pořadí prvků.*<br>
^^**use List\:\:MoreUtils;**<br>
**distinct(**{*prvky*}...**)**

*# vybrat prvky, které se vyskytují právě jednou*<br>
^^**use List\:\:MoreUtils;**<br>
**singleton(**{*prvky*}...**)**


### Vyhledávání

<!--
*# najít první prvek vyhovující podmínce (hodnotu/index)*<br>
^^**use List\:\:MoreUtils;**<br>
-->

### Vkládání/vyjímání prvků

*# **vložit** prvek na začátek pole/konec pole/určitý index*<br>
**unshift(**{*@pole*}**,** {*skalár*}**);**<br>
**push(**{*@pole*}**,** {*skalár*}**);**<br>
**splice(**{*@pole*}**,** {*index*}**, 0,** {*skalár*}**);**

*# **vyjmout** první/poslední/určitý prvek pole*<br>
*// Obě uvedené funkce vracejí vyjmutý prvek.*<br>
**shift(**{*@pole*}**)**<br>
**pop(**{*@pole*}**)**<br>
**splice(**{*@pole*}**,** {*index*}**, 1);**

*# **smazat** všechny prvky/úsek*<br>
{*@pole*} **= ();**<br>
**splice(**{*@pole*}**,** {*první-smaz-index*}**,** {*počet-ke-smazání*}**);**















<!--
==================================================================================
-->
## Zaklínadla: Ukazatelé

### Ukazatelé obecně

*# je skalár ukazatel?/zjistit typ odkazovaného objektu*<br>
**defined(ref(**{*$skalár*}**))**<br>
**ref(**{*$skalár*}**)**

*# získat ukazatel na skalár/pole/asociativní pole/funkci/prvek pole/hodnotu v asociativním poli*<br>
*// Poznámka: klíče v asociativním poli jsou nepřiřaditelné, proto ukazatel na ně nelze získat.*<br>
**\\$**{*identifkátor\_skalární\_proměnné*}<br>
**\\@**{*identifkátor\_pole*}<br>
**\\%**{*identifkátor\_asociativního\_pole*}<br>
**\\&amp;**{*identifkátor\_funkce*}<br>
**\\$**{*identifkátor\_pole*}**[**{*index*}**]**<br>
**\\$**{*identifkátor\_asociativního\_pole*}**\{**{*klíč*}**\}**<br>

*# přistoupit přes ukazatel ke skaláru/poli/asociativnímu poli/funkci*<br>
**\$\$**{*identifikátor\_ukazatele*}<br>
**@$**{*identifikátor\_ukazatele*}<br>
**%$**{*identifikátor\_ukazatele*}<br>
**&amp;$**{*identifikátor\_ukazatele*}

### Ukazatel na skalár

### Ukazatel na pole

*# přistoupit k prvku pole přes ukazatel*<br>
**\$\$**{*identifikátor\_ukazatele*}**-&gt;[**{*index*}**]**

### Ukazatel na asociativní pole

*# přistoupit k prvku asociativního pole přes ukazatel*<br>
**\$\$**{*identifikátor\_ukazatele*}**-&gt;\{**{*klíč*}**\}**

### Ukazatel na funkci

*# získat ukazatel na funkci*<br>
**\\&amp;**{*identifikátor*}

*# zavolat funkci přes ukazatel*<br>
{*$ukazatel*}**-&gt;(**{*seznam, parametrů*}**)**

*# přiřadit do proměnné ukazatel na **anonymní funkci***<br>
*// Analogicky můžete ukazatel na anonymní funkci předat jako parametr jiné funkci.*<br>
{*$proměnná*} **= sub \{**[{*příkazy*}]...**\};**

### Ukazatel na regulární výraz

*# získat ukazatel na regulární výraz (obecně/příklad)*<br>
**qr/**{*regulární výraz*}**/**<br>
**$můjVýraz = qr/^ab\\.c/**


<!--
==================================================================================
-->
## Zaklínadla: Vstup/výstup

### Otevřít/zavřít

*# zavřít soubor či rouru*<br>
**close(**{*$f*}**)** [**or die(**{*zpráva*}**)**]**;**

*# otevřít textový soubor (normálně/se striktními kontrolami)*<br>
*// Režim je jeden z: „&lt;“: otevřít existující soubor pro čtení; „&gt;“: vytvořit nový/přepsat existující soubor a otevřít pro zápis; „&gt;&gt;“: otevřít pro zápis na konec souboru.*<br>
**open(my $**{*identifikátor*}**, "**{*režim*}**:utf8",** {*"cesta/k/souboru"*}**)** [**or die(**{*"chybová zpráva"*}**)**]**;**<br>
**open(my $**{*identifikátor*}**, "**{*režim*}**:encoding(UTF-8)",** {*"cesta/k/souboru"*}**)** [**or die(**{*"chybová zpráva"*}**)**]**;**

*# otevřít binární soubor*<br>
*// Režim je jeden z: „&lt;“: otevřít existující soubor pro čtení; „+&lt;“: otevřít existující soubor pro čtení i zápis; „&gt;“: vytvořit nový/přepsat existující soubor a otevřít jen pro zápis; „+&gt;“: totéž, ale pro zápis i čtení; „&gt;&gt;“: otevřít soubor pro zápis na konec.*<br>
**open(**{*$f*} **= undef, "**{*režim*}**:raw",** {*"cesta/k/souboru"*}**)** [**or die(**{*"chybová zpráva"*}**)**]**;**

*# otevřít rouru pro zápis*<br>
**open(**{*$f*} **= undef, "\|-", "**{*název-příkazu*}**"**[**,** {*parametr-příkazu*}]...**)** [**or die(**{*zpráva*}**)**]**;**

*# otevřít rouru pro čtení*<br>
**open(**{*$f*} **= undef, "-\|", "**{*název-příkazu*}**"**[**,** {*parametr-příkazu*}]...**)** [**or die(**{*zpráva*}**)**]**;**

*# otevřít vstup či výstup podle čísla*<br>
**open(my $**{*identifikátor*}**, "**{*režim*}**&amp;=**{*číslo*}**:**{*utf-8-nebo-raw*}**")** [**or die(**{*"chybová zpráva"*}**)**]**;**
<!--
[ ] Vyzkoušet!
-->

### Číst (textový soubor)

*# načíst řádek bez ukončovače*<br>
*// Při čtení za koncem souboru se do proměnné $cíl uloží nehodnota undef.*<br>
{*$cíl*} **= readline(**{*$f*}**);**<br>
**chomp(**{*$cíl*}**) if (defined(**{*$cíl*}**))**

*# načíst jeden znak*<br>
*// Podle manuálu tato funkce není příliš efektivní. Doporučuji raději načíst řádku s ukončovačem a rozdělit po znacích. Při čtení za koncem souboru tato funkce vrací undef.*<br>
{*$cíl*} **= getc(**{*$f*}**);**

*# načíst všechny zbývající řádky bez ukončovače*<br>
{*@cíl*} **= array(readline(**{*$f*}**));**<br>
**chomp(**{*@cíl*}**);**

*# načíst všechny zbývající řádky s ukončovačem/zahodit*<br>
{*@cíl*} **= array(readline(**{*$f*}**));**<br>
**array(readline(**{*$f*}**));**

*# načíst celý soubor do řetězce*<br>
{*$cíl*} **= "";**<br>
**while (read(**{*$f*}**,** {*$cíl*}**, 4096, length(**{*$cíl*}**))) {}**

### Číst (binární soubor)

*# načíst pevný maximální počet bajtů*<br>
**read(**{*$f*}**,** {*$cíl*}**,** {*max-bajtů*}[**,** {*počáteční-index-do-cíle*}]**)**

*# načíst jeden bajt*<br>
{*$cíl*} **= getc(**{*$f*}**);**

*# načíst všechny zbývající bajty*<br>
{*$cíl*} **= "";**<br>
**while (read(**{*$f*}**,** {*$cíl*}**, 4096, length(**{*$cíl*}**))) {}**

*# konvertovat bajty z řetězce na pole číselných hodnot*<br>
{*@cíl*} **= unpack("C\*",** {*$řetězec*}**);**

### Zapisovat (textový soubor)

*# zapsat řetězec*<br>
**printf(**[{*$f*}**&blank;**]**"%s",** {*$řetězec*}**);**

*# zapsat znak (alternativy)*<br>
**printf(**[{*$f*}**&blank;**]**%s",** {*$znak*}**);**<br>
**{local $ORS = ""; print(**[{*$f*}**&blank;**]{*$znak*}**);}**

*# zapsat položky seznamu oddělené hodnotou $OFS a zakončené hodnotou $ORS*<br>
**print(**[{*$f*}**&blank;**]{*položky, seznamu*}**);**

### Zapisovat (binární soubor)

*# zapsat bajty (z řetězce/z pole čísel)*<br>
**printf(**[{*$f*}**&blank;**]**"%s",** {*$řetězec*}**);**<br>
?

*# zapsat bajt (znakově/z číselné hodnoty)*<br>
**printf(**[{*$f*}**&blank;**]**"%s",** {*$znak*}**);**<br>
**printf(**[{*$f*}**&blank;**]**"%c",** {*$číslo*}**);**

### Ostatní operace (binární soubor)

*# přesun na pozici N bajtů od začátku/od konce/od akt. pozice vpřed/od akt. poz. vzad*<br>
**seek(**{*$f*}**,** {*N*}**, 0);**<br>
**seek(**{*$f*}**, -**{*N*}**, 2);**
**seek(**{*$f*}**,** {*N*}**, 1);**
**seek(**{*$f*}**, -**{*N*}**, 1);**
<!--
[ ] Vyzkoušet.
-->

*# zjistit pozici v bajtech od začátku souboru*<br>
**tell(**{*$f*}**)** ⊨ 737

*# **zkrátit** soubor otevřený pro zápis*<br>
**truncate(**{*$f*}**,** {*délka-v-bajtech*}**)** [**&amp;&amp; seek(**{*$f*}**,** {*nová-pozice*}**,** {*odkud*}**)**]

### Ostatní

*# vypsat chybové hlášení*<br>
**warn(**{*"zpráva"*}[**,** {*"pokračování zprávy"*}]**);**

### Operace se soubory

*# nastavit mód (přístupová práva)(obecně/příklad)*<br>
*// Pozor! Mód je zde interpretován v oktalové soustavě; pokud ho zadáte v desítkové (např. „777“), nebude fungovat.*<br>
**chmod(**{*číslo*}**,** {*cesta*}...**);**<br>
**chmod(04777, "../a.txt", "b.txt");**

<!--
[ ] if(link(old, new)) => pevný odkaz?
-->

*# vytvořit symbolický odkaz (obecně/příklad)*<br>
**if (symlink(**{*obsah*}**,** {*cesta/k/odkazu*}**)) \{**{*...*}**\}**<br>
**symlink("../a.txt", "adresář/nový-odkaz.txt");**
<!--
[ ] vyzkoušet
-->

*# odstranit soubor*<br>
**unlink(**{*cesta*}**)** [**or** {*zpracovat chybu*}]


### Operace s adresáři

*# získat pole názvů položek v adresáři*<br>
*// Pozor, získané pole bude obsahovat i zvláštní položky „.“ a „..“ a všechny skryté soubory a adresáře.*<br>
**if (opendir(my $**{*identifikátor*}**,** {*$cesta*}**)) \{**<br>
<odsadit1>{*@pole*} **= array(readdir($**{*identifikátor*}**));**<br>
<odsadit1>**closedir($**{*identifikátor*}**);**<br>
**\}**

*# vytvořit adresář*<br>
**mkdir(**{*$cesta*}**)**

## Zaklínadla: Ostatní

### Práce s časem

*# získat aktuální časovou známku*<br>
**time()** ⊨ 1605876988

*# získat aktuální čas: lokální/UTC*<br>
**array(localtime(**{*časznámka*}**))** ⊨ (59, 58, 13, 20, 10, 120, 5, 324, 0)<br>
**array(gmtime(**{*časznámka*}**))** ⊨ (59, 58, 12, 20, 10, 120, 5, 324, 0)

*# tvar pole vraceného funkcemi localtime() a gmtime()*<br>
*// Den v týdnu je: 0=neděle, 1=pondělí, ..., 6=sobota. isdst je logická pravda pro letní čas, jinak logická nepravda. Dny v roce se počítají od nuly!*<br>
**(**{*sekund*}**,** {*minut*}**,** {*hodin*}**,** {*den-v-měsíci*}**,** {*měsíc*}**,** {*rok-1900*}**,** {*den-v-týdnu*}**,** {*den-v-roce*}**,** {*isdst*}**)**

*# časová známka na řetězec formátu "yyyy-MM-dd HH:mm:ss" (lokální/UTC)*<br>
^^**use POSIX;**<br>
**POSIX::strftime(**{*$formát*}**, localtime(**{*časznámka*}**))**<br>
**POSIX::strftime(**{*$formát*}**, gmtime(**{*časznámka*}**))**

<!--
[ ] zjistit posun lokální časové zóny oproti UTC!
-->

<!--

https://www.tutorialspoint.com/perl/perl_special_variables.htm
-> používat „use English;“!
-->


## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

*# doporučený způsob volání Perlu*<br>
**perl**


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

!ÚzkýRežim: vyp

## Pomocné funkce a skripty

*# lkk perl – spouštěč, který spustí skript Perlu s doporučenými parametry*<br>
**#!/bin/bash**<br>
**exec perl -CSDAL -Mv5.26.0 -Mstrict -Mwarnings -Mutf8 -MEnglish "$@"**
