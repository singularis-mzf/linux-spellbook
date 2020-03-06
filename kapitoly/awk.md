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

>> Ve verzi 5.0 prý jsou „namespaces“.

Tip pro mawk: používat mawk -W sprintf=2123456789
Poznámka: mawk pracuje po bajtech a neumí zpracovat nulový bajt (končí řetězec), což je závažné omezení.
-->

# AWK

!Štítky: {program}{syntaxe}{zpracování textu}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

AWK je skriptovací nástroj pro jednoduché řádkově orientované zpracování textových souborů.
Jeho syntaxe vychází z bashe a jazyka C a navíc přidává literály regulárních výrazů
v obyčejných lomítkách. Ve srovnání s jemu příbuzným Perlem je syntaxe AWK
velmi umírněná a elegantní a jeho schopnosti omezené, což ho činí vhodným pro začátečníky,
ale nedostačujícím pro rozsáhlé projekty nebo projekty vyžadující specializovanou
funkcionalitu. GNU awk také není vhodné v situacích, kdy je nezbytný vysoký výkon
a nízká spotřeba paměti.

Skript AWK se skládá ze sekvence takzvaných „vzorků“ (podmínek)
a k nim příslušejících bloků příkazů. Jeho provádění si lze dobře představit,
jako by šlo o sérii podmínek „if“ v cyklu „foreach“. AWK dělí vstupní soubory
po řádcích (záznamech) a každý záznam rozdělí na sloupce a postupně testuje jeden
vzorek po druhém. Když vzorek vyhoví, příslušný blok příkazů se vykoná, jinak se přeskočí.
Navíc provádí AWK několik dalších, speciálních iterací, které vykonávají pouze bloky
příkazů označené určitým klíčovým slovem (např. BEGIN).

Vzorek nebo blok příkazů je dovoleno vynechat; vynecháme-li vzorek, blok příkazů se
vykoná pro každou řádku (ale ne ve speciálních iteracích); vynecháme-li blok příkazů,
automaticky se doplní „{print $0}“.

Nejčastějším tvarem vzorku je podmínka tvořená pouze literálem regulárního výrazu
(např. „/^a/“), taková podmínka se (nejen v tomto kontextu) automaticky rozšíří na
výraz „($0 ~ /^a/)“, tedy porovnání načteného řádku s uvedeným regulárním výrazem.

Pozor! V AWK se řádky v souboru, indexy sloupců v záznamu, indexy čísly indexovaných polí i pozice znaků v řetězci počítají vždy od 1, nikdy od nuly!

## Definice

* **Vzorek** (pattern) je podmínka, která určuje, zda se daný blok příkazů má v dané iteraci skriptu provést. Podmínkou může být obecný výraz, nebo jedno z klíčových slov, která identifikují speciální iterace.
* **Záznam** (record) je typicky řádka vstupního souboru. Způsob ukončení záznamu ve vstupních souborech lze změnit nastavením speciální proměnné „RS“ (record separator) na jiný než výchozí oddělovač (výchozí oddělovač je "\\n").
* Záznam se po načtení rozdělí do **sloupců** (fields). Způsob oddělení záznamů se nastavuje speciální proměnnou „FS“ (field separator); její výchozí hodnotou je mezera, která má speciální význam a považuje za oddělovač sloupců jakoukoliv neprázdnou posloupnost bílých znaků (odpovídá regulárnímu výrazu „\\s+“).
* Regulární výraz může být zadán buď jako **literál** do lomítek, např. „/^a/“, nebo jako **dynamický regulární výraz**, kterým může být jakýkoliv řetězec či řetězcový výraz (např. "^a"). Tyto dva způsoby zadání jsou většinou víceméně rovnocenné, liší se escapováním (v literálu musíte escapovat všechny výskyty znaku „/“, a to i uvnitř hranatých závorek) a tím, že dynamický regularní výraz se nikdy automaticky nedoplní o prefix „$0&blank;~“, zatímco literál to dělá skoro vždy.

!ÚzkýRežim: vyp

## Zaklínadla

### Vzorky a bloky příkazů

*# podmíněné vykonávání (obecně)*<br>
{*podmínka*} [{*{blok příkazů}*}]

*# podmíněné vykonávání (příklady)*<br>
**PROMENNA == 1 &amp;&amp; /^X/ {ZAJIMAVY\_RADEK = $0}**<br>
**$1 ~ /ABC/ {print $2}**<br>
**priznak {next}**<br>
**$0 != "xyz" {print "ne-XYZ:";print $0;}**<br>
**!/^#/**<br>
**length($0) &gt; 5 \|\| /^%/ {print "Řádka " FNR " podmínku splnila."}**

*# vykonat blok příkazů pro každou řádku*<br>
{*{blok příkazů}*}

*# před otevřením prvního souboru*<br>
**BEGIN** {*{blok příkazů}*}

*# před definitivním ukončením skriptu*<br>
*// Pozor: zvláštní průchod END se vykoná i tehdy, je-li skript ukončován příkazem „exit“!*<br>
**END** {*{blok příkazů}*}

*# po otevření souboru (ale před načtením prvního řádku)*<br>
**BEGINFILE** {*{blok příkazů}*}

*# po zpracování poslední řádky souboru*<br>
*// Pozor: zvláštní průchod ENDFILE se nevykoná, pokud je zpracování souboru předčasně ukončeno, např. příkazem „nextfile“ či „exit“.*<br>
**ENDFILE** {*{blok příkazů}*}

*# řádky „od“ až „do“ včetně hranic*<br>
{*podmínka od*}**,**{*podmínka do*} [{*{blok příkazů}*}]

*# řádky „od“ až „do“ kromě hranic*<br>
**{if (!**{*pomocná\_proměnná*}**) \{**{*pomocná\_proměnná*} **=** {*podmínka od*}**\} else if (**{*podmínka do*}**) \{**{*pomocná\_proměnná*} **= 0} else** {*{blok příkazů}*}**\}**


### Skalární proměnné

*# **přečíst** hodnotu proměnné*<br>
{*název\_proměnné*}

*# **přiřadit** hodnotu proměnné*<br>
{*název\_proměnné*} **=** {*hodnota*}

*# získat hodnotu proměnné prostředí (obecně/příklad)*<br>
**ENVIRON[**{*řetězec-s-názvem-proměnné*}**]**<br>
**ENVIRON["PATH"]**

*# přiřadit hodnotu proměnné prostředí*<br>
?

*# nepřímý přístup k proměnné (příklad)*<br>
**PROMENNA = "hodnota";**<br>
**UKAZATEL = "PROMENNA";**<br>
**print SYMTAB[UKAZATEL];**<br>
**SYMTAB[UKAZATEL] = "nova hodnota"**

### Asociativní pole

*# **přečíst** hodnotu prvku pole*<br>
{*pole*}**[**{*index*}**]**

*# **přiřadit** hodnotu prvku pole*<br>
{*pole*}**[**{*index*}**] =** {*hodnota*}

*# **existuje** prvek pole?*<br>
{*index*} **in** {*pole*}

*# **smazat** z pole jeden prvek/všechny prvky*<br>
**delete** {*pole*}**[**{*index*}**];**
**delete** {*pole*}**;**

*# **počet prvků***<br>
**length(**{*pole*}**)**

*# zkopírovat celé pole*<br>
**delete** {*cílové\_pole*}**;**<br>
**for (**{*pomocná\_proměnná*} **in** {*pole*}**) \{**{*cílové\_pole*}**[**{*pomocná\_proměnná*}**] =** {*pole*}**[**{*pomocná\_proměnná*}**]\}**

*# je proměnná pole?*<br>
*// Tato funkce je nejužitečnější u parametrů funkcí; díky ní může funkce ověřit, že jí v určitém parametru bylo předáno pole, nebo naopak skalární hodnota.*<br>
**isarray(**{*proměnná*}**)**

### Asociativní pole: řazení

Poznámka k řazení asociativních polí: výsledkem řazení asociativního pole je vždy pole indexované celými čísly od 1 do návratové hodnoty řadicí funkce.

<!--
Poznámka 2: GNU awk řadí řetězce výhradně podle číselné hodnoty znaků (v kódování Unicode).
Poznámka 3: Pořadí: čísla, řetězce, vnořená pole.
-->

V následujících příkazech: „**typ**“ může být „num“ (řadit jako čísla) nebo „str“ (řadit jako řetězce, ale podle pozice znaků ve znakové sadě Unicode); „**pořadí**“ může být „asc“ (vzestupně) nebo „desc“ (sestupně).

*# seřadit **hodnoty** podle klíčů/podle hodnot/uživatelskou funkcí*<br>
*// Při řazení uživatelskou funkcí musíte zadat funkci, která přijme parametry „klíč-L“, „hodnota-L“, „klíč-R“ a „hodnota-R“ v tomto pořadí a vrátí záporné číslo, je-li L-strana menší než R-strana; kladné číslo, je-li větší; a nulu, jsou-li si obě strany rovny.*<br>
**asort(**{*pole*}**,** {*cílové\_pole*}**, "@ind\_**{*typ*}**\_**{*pořadí*}**")**<br>
**asort(**{*pole*}**,** {*cílové\_pole*}**, "@val\_**{*typ*}**\_**{*pořadí*}**")**<br>
**asort(**{*pole*}**,** {*cílové\_pole*}**, "**{*jméno\_funkce*}**")**

*# seřadit **klíče** podle klíčů/podle hodnot/uživatelskou funkcí*<br>
**asorti(**{*pole*}**,** {*cílové\_pole*}**, "@ind\_**{*typ*}**\_**{*pořadí*}**")**<br>
**asorti(**{*pole*}**,** {*cílové\_pole*}**, "@val\_**{*typ*}**\_**{*pořadí*}**")**<br>
**asorti(**{*pole*}**,** {*cílové\_pole*}**, "**{*jméno\_funkce*}**")**

*# **příklad** řazení*<br>
**pocet\_jmen = asort(jmena, serazena\_jmena, "@val\_str\_asc");**

<!--
nevyzkoušeno

*# příklad řazení pomocí koprocesu*<br>
^^**RS = '\\0';**<br>
**for (i in pole) \{**<br>
<odsadit1>**printf("%s\\0", pole[i]) \|&amp; "sort -z";**<br>
**\}**<br>
**close("sort -z", "to");**<br>
**i = 0;**<br>
**while (getline s) \{**<br>
<odsadit1>**cilove\_pole[++i] = s;**<br>
**\}**<br>
**close("sort -z");**

-->

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

*# přepínač **switch***<br>
*// Přepínač switch pracuje v gawk stejně jako v jazyce C, ovšem pracuje s řetězci místo celých čísel.*<br>
**switch (**{*skalární-výraz*}**) \{**<br>
[[**case** {*konstantní-hodnota*}**:**]... <nic>[**default:**] {*příkazy*}]...
**\}**

*# cyklus **do-while** (alternativy)*<br>
**do {** {*příkazy*} **} while (**{*podmínka*}**);**<br>
**do** {*příkaz*}**; while (**{*podmínka*}**);**

### Řízení toku

*# opustit nejvnitřnější cyklus (for, while, do) nebo přepínač (switch)*<br>
**break;**

*# skočit na podmínku nejvnitřnějšího cyklu (for, while, do)*<br>
**continue;**

*# přejít na zpracování **dalšího řádku***<br>
**next;**

*# přejít na zpracování **dalšího souboru***<br>
*// Poznámka: tento příkaz přeskočí odpovídající průchod ENDFILE!*<br>
**nextfile;**

*# přejít na průchod END („**ukončit skript**“)*<br>
**exit** [{*návratová-hodnota-programu*}]**;**

*# vypsat chybovou zprávu a skončit s chybou*<br>
**print** {*chybová-zpráva-řetězec*} **&gt; "/dev/stderr"**<br>
**exit 1;**

### Dělení záznamů na sloupce

*# dělit sloupce libovolnou sekvencí **bílých znaků***<br>
**FS = "&blank;";**

*# dělit sloupce tabulátorem*<br>
**FS = "\\t";**

*# dělit sloupce regulárním výrazem*<br>
**FS =** {*"regulární výraz"*}**;**

*# zapnout/vypnout režim **sloupců pevné šířky***<br>
**FIELDWIDTHS = "**{*šířka-prvního-sloupce*}[&blank;{*šířka-dalšího-sloupce*}]...**"**<br>
**FIELDWIDTHS = ""**

<!--
Od verze 4.2 může být před každým polem „šířka k přeskočení“ oddělená :
a na konci může být sloupec „*“, který přijme libovolné množství dalších znaků.
-->

*# režim sloupců pevné šířky (příklad)*<br>
**FIELDWIDTHS = "5 2 7"** ⊨ $1 = „12345“ $2 = „67“ $3 = „8901234“

*# **vypnout** dělení na sloupce*<br>
**FS = RS;**

*# každý znak jako samostatný sloupec*<br>
**FS = "";**

*# dělit sloupce výhradně mezerou*<br>
**FS = "[&blank;]";**

*# sloupce ze shod s regulárním výrazem (zapnout/vypnout)*<br>
**FPAT =** {*"neprázdný regulární výraz"*}**;**<br>
**FPAT = "";**

### Speciální proměnné

*# **načtená řádka** (bez oddělovače záznamu/s oddělovačem záznamu)*<br>
**$0**<br>
**$0 RT**

*# **číslo řádky** v souboru/celkově*<br>
*// Do obou uvedených proměnných můžete také přiřadit novou hodnotu, a změnit tak číslování řádku pro zbytek souboru (resp. veškerého vstupu)*<br>
**FNR**<br>
**NR**

*# **sloupec** načtené řádky (obecně/příklady...)*<br>
**$**{*číselný-výraz*}<br>
**$2**<br>
**$12**<br>
**$(NF - 1)**

*# název/index právě načítaného **souboru***<br>
*// Nelze použít v blocích BEGIN a END.*<br>
**FILENAME**<br>
**ARGIND**

*# **počet sloupců** v načteném řádku*<br>
*// Počet sloupců lze i nastavit.*<br>
**NF**

*# **výstupní oddělovač** sloupců/záznamů příkazu print*<br>
*// Výchozí hodnota je „ “ (mezera); může být přednastaven také parametrem příkazové řádky „-F“.*<br>
**OFS = "**[{*řetězec*}]**"**<br>

*# vstupní oddělovač záznamu (jeden znak/regulární výraz)*<br>
*// Výchozí hodnotou je konec řádku „\\n“.*<br>
**RS = "**{*znak*}**"**<br>
**RS = "**{*regulární výraz*}**"**

*# hodnota posledního sloupce načteného řádku*<br>
**$NF**

*# počet souborů, které mají být (podle příkazové řádky) načteny jako vstupní*<br>
*// Poznámka: vrací-li 0, stejně má být čten standardní vstup.*<br>
**ARGC - 1**

*# N-tý (od 1) vstupní soubor, jak je zadán na příkazovém řádku*<br>
**ARGV[**{*N*}**]**


### Ostatní

*# komentář*<br>
*// Znak # není interpretován jako začátek komentáře uvnitř řetězců ani literálů regulárních výrazů.*<br>
**#**{*libovolný obsah až do konce řádky*}

## Zaklínadla (výstup, vstup a interakce s bashem)

### Příkazy výstupu

*# příkaz **print***<br>
*// Příkaz print zapíše na výstup svoje parametry, oddělené obsahem proměnné „OFS“ (výchozí hodnotou je "&blank;"), a za poslední parametr přidá navíc hodnotu proměnné „ORS“ (výchozí hodnota je "\\n").*<br>
**print** {*výraz*}[**,** {*další-výraz*}]... [{*přesměrování-výstupu*}]**;**

*# funkce **printf***<br>
*// Funkce printf() funguje stejně jako v jazyce C, až na to, že parametr %c dokáže vypisovat UTF-8 znaky v rozsahu 0 až cca 55000 (ale např. místo znaku č. 55339 vypíše „+“). *<br>
**printf(**{*formátovací-řetězec*}[**,**{*výraz*}]...**)** [{*přesměrování-výstupu*}]**;**

### Uzavření vstupu/výstupu

*# uzavřít soubor otevřený ke čtení či zápisu*<br>
*// Tato varianta funkce „close()“ vrací 0 v případě úspěchu, jiná hodnota značí chybu.*<br>
**close(**{*"řetězec/reprezentující/soubor"*}**)**

*# uzavřít čtení výstupu příkazu*<br>
**close(**{*"řetězec reprezentující příkaz"*}**)**

*# uzavřít zápis na vstup příkazu*<br>
**close(**{*"řetězec reprezentující příkaz"*}**)**

### Bash

*# vykonat příkaz interpretem „/bin/sh“ a vrátit jeho návratovou hodnotu*<br>
**system(**{*řetězec*}**)**

### Přesměrování výstupu

Poznámky k přesměrování výstupu: Prvním zápisem do souboru, který ještě není otevřen, se tento soubor automaticky otevře pro zápis a zůstane otevřený pro další zápisy, dokud ho neuzavřete funkcí close() nebo do konce programu. Analogicky platí, že prvním zápisem na vstup dosud nespuštěného příkazu se tento příkaz spustí a další zápisy směřují na vstup téže instance příkazu, dokud spojení neuzavřete funkcí „close()“.

Pokud soubor existuje, při otevření se jeho obsah smaže; pokud chcete přidávat na konec souboru, použijte místo operátoru „&gt;“ operátor „&gt;&gt;“ (princip je stejný jako v bashi).

*# výstup do souboru (příklad)(print/printf)*<br>
**print "A:", A &gt; "../seznam.txt";**<br>
**printf("%s: %d\\n", I, POLE[I]) &gt; "hodnoty.txt";**

*# poslat na (standardní) vstup jiného příkazu (print/printf)*<br>
*// Odkazovaný příkaz se spustí v interpretu /bin/sh a svoje vstupy a výstupy zdědí od instance GNU awk, kterou byl spuštěn, pokud je výslovně nepřesměrujete.*<br>
**print** {*parametr*}[**,** {*další parametr*}]... **\|** {*"řetězec s příkazem"*} **;**<br>
**printf(**{*formátovací-řetězec*}[**,**{*parametr*}]...**) \|** {*"řetězec s příkazem"*} **;**<br>

*# zapsat na vstup jiného příkazu (příklad)*<br>
**print I, S, "." \| "sort -n";**

*# zapsat na standardní chybový výstup*<br>
**print** {*parametry*} **&gt; "/dev/stderr";**<br>
**printf(**{*parametry*}**) &gt; "/dev/stderr";**

*# zapsat do souboru jeden znak (přepsat/připojit)*<br>
**printf("%s", "**{*znak*}**") &gt;** {*"řetězec/s/cestou/souboru"*}**)**

### Přesměrování vstupu

Poznámky k přesměrování vstupu: Prvním čtením ze souboru, který ještě není otevřen, se tento soubor automaticky otevře pro čtení a zůstané otevřený pro čtení dalších řádků, dokud ho neuzavřete funkcí close(). Analogicky platí, že čtení z příkazu, který ještě nebyl spuštěn, ho spustí a další čtení čtou z výstupu téže instance, dokud spojení neuzavřete funkcí „close()“.

*# přečíst řádku ze souboru*<br>
[**if (**]**getline** [{*PROMĚNNÁ*}] **&lt;** {*"řetězec/s/cestou/souboru"*}[**)** {*tělo příkazu if*}]

*# přečíst jeden znak ze souboru*<br>
*// Poznámka: po použití této konstrukce pravděpodobně budete muset obnovit hodnoty proměnných RS, $0, RT, NR a FNR.*<br>
**RS = "(.)";**<br>
**if (getline &lt;** {*"řetězec/s/cestou/souboru"*}**) {{*proměnná*} = RT}**

*# přečíst celý soubor do zadané proměnné*<br>
**normalni\_RS = RS; RS = "^$";** {*PROMĚNNÁ*} **= "";**<br>
**getline** {*PROMĚNNÁ*} &lt; {*"řetězec/s/cestou/souboru"*}**;**<br>
**RS = normalni\_RS;**<br>
[**close(**{*"řetězec/s/cestou/souboru"*}**);**]

*# načíst řádku z výstupu příkazu*<br>
[**if (**]{*"příkaz"*} **\| getline** [{*PROMĚNNÁ*}]**)** {*tělo příkazu if*}

### Koprocesy

*# zapsat na standardní vstup koprocesu (alternativy)*<br>
{*příkaz print*} **\|&amp;** {*koproces*}**;**

*# přečíst řádek z výstupu koprocesu*<br>
[**if (**]{*koproces*} **\|&amp; getline** [{*PROMĚNNÁ*}]<nic>[**)** {*tělo příkazu if*}]

*# uzavřít jen vstup koprocesu*<br>
*// Po uzavření vstupu koprocesu můžete pouze číst z jeho výstupu. Pokus o další zápis před úplným ukončením koprocesu je fatální chyba.*<br>
**close(**{*koproces*}**, "to");**

*# vyčkat na ukončení koprocesu*<br>
*// Funkce close() v tomto případě vrátí návratovou hodnotu koprocesu vynásobenou 256.*<br>
**close(**{*koproces*}**)**

<!--
Nevyzkoušeno:

*# nastavit maximální dobu čekání na data od koprocesu*<br>
**PROCINFO[**{*koproces*}**, "READ\_TIMEOUT"] =** {*milisekundy*}**;**<br>
**PROCINFO[**{*koproces*}**, "RETRY"] = 1;**
+ při vypršení časovače prý funkce getline vrátí -2
-->

### Informace o procesu AWK

*# PID procesu gawk/rodičovského procesu*<br>
**PROCINFO["pid"]** ⊨ 7034<br>
**PROCINFO["ppid"]** ⊨ 4052

*# verze GNU awk*<br>
**PROCINFO["version"]** ⊨ 4.1.4

## Zaklínadla (funkce)

### Uživatelské funkce

*# definovat funkci (volitelně s lokálními proměnnými)*<br>
**function** {*název funkce*}**(**[{*první-parametr*}[**,**{*další-parametry*}]...][**,&blank;&blank;&blank;**{*lokální-proměnná*}[**,** {*další-lokální-proměnná*}]...]**)** {*blok příkazů*}

*# volání funkce*<br>
{*název\_funkce*}**(**[{*parametr*}[**,** {*další parametr*}]]**)**

*# nepřímé volání funkce*<br>
**@**{*proměnná*}**(**[{*parametr*}[**,** {*další parametr*}]]**)**

### Řetězcové funkce (regulární výrazy)

Poznámka k řetězci náhrady: V tomto řetězci je nutno escapovat znaky „\\“ a „&amp;“, protože mají speciální význam: Funkce sub(), gensub() a gsub() za neescapovaný znak „&amp;“ dosadí text shody s nahrazovaným regulárním výrazem. Funkce „gensub()“ navíc za značky „\\1“ až „\\9“ (do řetězce nutno zadávat jako "\\\\1" atd.) dosadí text číslovaného záchytu (podřetězec odpovídající seskupení v regulárním výrazu).

*# **vyhovuje**/nevyhovuje regulárnímu výrazu?*<br>
{*řetězec*} **~** {*regulární-výraz*}<br>
{*řetězec*} **!~** {*regulární-výraz*}

*# **nahradit** první výskyt/N-tý výskyt/všechny výskyty regulárního výrazu v proměnné*<br>
**sub(**{*regulární výraz*}**,** {*řetězec-náhrady*}**,** {*proměnná*}**)** ⊨ počet náhrad (0, nebo 1)<br>
{*proměnná*} **= gensub(**{*regulární výraz*}**,** {*řetězec-náhrady*}**,** {*N*}**,** {*proměnná*}**)** ⊨ řetězec po náhradě (nezměněný, pokud k náhradě nedošlo)<br>
**gsub(**{*regulární výraz*}**,** {*řetězec-náhrady*}**,** {*proměnná*}**)** ⊨ počet náhrad

*# nahradit první výskyt/N-tý výskyt/všechny shody v $0*<br>
**sub(**{*regulární výraz*}**,** {*řetězec-náhrady*}**)** ⊨ počet náhrad (0, nebo 1)<br>
**$0 = gensub(**{*regulární výraz*}**,** {*řetězec-náhrady*}**,** {*N*}**)** ⊨ řetězec po náhradě (nezměněný, pokud k náhradě nedošlo)<br>
**gsub(**{*regulární výraz*}**,** {*řetězec-náhrady*}**)** ⊨ počet náhrad

*# nahradit první výskyt/N-tý výskyt/všechny výskyty regulárního výrazu v řetězci*<br>
**gensub(**{*regulární výraz*}**,** {*řetězec-náhrady*}**, 1,** {*řetězec*}**)**<br>
**gensub(**{*regulární výraz*}**,** {*řetězec-náhrady*}**,** {*N*}*,* {*řetězec*}**)**<br>
**gensub(**{*regulární výraz*}**,** {*řetězec-náhrady*}**, "g",** {*řetězec*}**)**

*# najít a vypsat **první shodu** s regulárním výrazem*<br>
*// Nebyla-li shoda s regulárním výrazem nalezena, funkce match() vrací 0; jinak nastaví proměnné RSTART a RLENGTH na pozici a délku nalezeného podřetězce a vrátí hodnotu RSTART. Vždy vybírá nejlevější a nejdelší shodu.*<br>
**if (match(**{*řetězec*}**,** {*regulární-výraz*}**)) \{**<br>
<odsadit1>**print substr(**{*řetězec*}**, RSTART, RLENGTH);**<br>
**\}**

*# najít **všechny shody** s regulárním výrazem a sestavit z nich číslované pole*<br>
*// Funkce „patsplit()“ vyhledá všechny shody řetězce s regulárním výrazem a vrátí jejich počet (N). Předané pole pak smaže a naplní těmito shodami. Zadáte-li i pole pro oddělovače, pak ho tato funkce vyplní podřetězci, které zbyly mezi jednotlivými shodami, přičemž řetězec před první shodou bude umístěn na indexu 0 a řetězec za poslední shodou na indexu N.*<br>
**patsplit(**{*řetězec*}**,** {*pole*}**,** {*regulární-výraz*} [**,**{*pole-pro-oddělovače*}]**)** ⊨ počet shod (např. „3“)

*# **rozdělit** řetězec do pole, oddělovač je definovaný regulárním výrazem*<br>
**split(**{*řetězec*}**,** {*pole*}**,** {*regulární-výraz*}<nic>[**,**{*pole\_pro\_oddělovače*}]**)**

*# příklad: v řetězci „a=15:b=79“ v proměnné „x“ vyměnit čísla*<br>
**x = gensub(/^a=([0-9]+):b=([0-9]+)$/, "a=\\\\2:b=\\\\1", 1, x);** ⊨ a=79:b=15

### Řetězcové funkce (základní)

*# spojit dva řetězce (**konkatenace**)*<br>
{*jeden-řetězec*} {*druhý-řetězec*}

*# získat **podřetězec** podle pozice*<br>
**substr(**{*řetězec*}**,** {*počáteční-pozice*}[**,** {*maximální-délka*}]**)**

*# najít pozici prvního výskytu **podřetězce***<br>
*// Vrátí 0, nebyl-li podřetězec nalezen; jinak vrátí pozici podřetězce (číslovanou od 1).*<br>
**index(**{*řetězec*}**,** {*hledaný-podřetězec*}**)**

*# zjistit **délku řetězce***<br>
**length(**{*řetězec*}**)**

*# **rozdělit** řetězec do pole (podle FS/určitým znakem)*<br>
**split(**{*řetězec*}**,** {*pole*}**)**<br>
**split(**{*řetězec*}**,** {*pole*}**, "**{*znak*}**"**[**,**{*pole\_pro\_oddělovače*}]**)**

*# naformátovat řetězec (funkce **sprintf** známá z jazyka C)*<br>
**sprintf(**{*formátovací-řetězec*}[**,** {*parametr*}]...**)**

*# převod na **malá písmena/velká písmena***<br>
*// V gawk tyto funkce rozpoznávají znaky národní abecedy (pravděpodobně podle „locale“), v mawk účinkují pouze na ASCII znaky.*<br>
**tolower(**{*řetězec*}**)**<br>
**toupper(**{*řetězec*}**)**

*# sekvence více výskytů téhož znaku v řetězci nahradit jeho jedním výskytem*<br>
?

### Konverze číselných soustav

*# desítkové číslo na hexadecimální/hexadecimální na desítkové*<br>
**sprintf("**[**0x**]**%x",** {*číslo*}**)**<br>
**strtonum("0x**{*hex-číslo*}**)**

*# desítkové číslo na osmičkové/osmičkové na desítkové*<br>
**sprintf("**[**0**]**%o",** {*číslo*}**)**<br>
**strtonum("0**{*osmičkové-číslo*}**)**

### Číselné funkce

*# **absolutní hodnota***<br>
{*x*} **&gt;= 0 ?** {*x*} **: -**{*x*}

*# **zaokrouhlit** desetinné číslo na nejbližší celé číslo/k nule/jen oříznout desetinnou část*<br>
{*číslo*} **&gt;= 0 ? int(**{*číslo*} **+ 0.4999999) : int(**{*číslo*} **- 0.4999999)**<br>
{*číslo*} **&gt;= 0 ? int(**{*číslo*}**) : -int(-**{*číslo*}**)**<br>
**int(**{*hodnota*}**)**
<!--
TODO: Test.
-->

*# vygenerovat **pseudonáhodné** celé číslo 0 &lt;= y &lt; maximum*<br>
*// Vhodné jen pro maxima do 16 777 215. Pro vyšší maximum bude množina vrácených hodnot pravidelně přerušovaná, což pro některé druhy využití nemusí vadit. Správným řešením je bitová kombinace více volání funkce „rand()“.*<br>
**int(rand() \*** {*maximum*}**)**

*# vygenerovat pseudonáhodné celé číslo 0 &lt;= y &lt; 4 294 967 296*<br>
**65356 \* int(65536 \* rand()) + int(65536 \* rand())**

*# nastavit počáteční „semínko“ generátoru pseudonáhodných čísel (na hodnotu/podle času)*<br>
**srand(**{*hodnota-semínka*}**)**<br>
**srand()**

*# vygenerovat pseudonáhodné desetinné číslo 0 &lt;= y &lt; 1*<br>
**rand()**

*# druhá **odmocnina**/druhá mocnina*<br>
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

### Práce s časem

*# aktuální čas (jako časová známka Unixu)*<br>
**systime()**

*# zformátovat čas*<br>
*// Bez parametru „1“ vypíše lokální čas, s ním vypíše UTC. Pro „formát“ − viz kapitolu „Datum, čas a kalendář“.*<br>
**strftime(**{*formát*}**,**{*časová-známka-Unixu*}[**, 1**]**)**

### Pokročilé konstrukce

*# načíst jiný zdrojový soubor, jako by jeho obsah byl zapsán zde*<br>
**@include "**{*cesta/k/souboru.awk*}**"**

*# implementovat načítání řádek rozdělených znakem \\ před znakem konce řádku (tento kód vložit na začátek skriptu)*<br>
{*proměnná*} **!= "" {$0 =** {*proměnná*}**;** {*proměnná*} **= "";}**<br>
**/(^|[<nic>^\\\\])(\\\\\\\\)\*\\\\$/ {**{*proměnná*} **= substr($0, 1, length($0) - 1); next;}**

## Parametry příkazů

*# *<br>
**gawk** {*parametry-gawk*} [[**\-\-**] {*vstupní-soubory*}]...<br>
**gawk** {*parametry-gawk*} [[**\-\-**] {*parametry-skriptu*}]...<br>
**gawk** {*parametry-kromě-e-f-i*} {*program*} [[**\-\-**] {*vstupní-soubory*}]...<br>
**gawk \-\-version**

!parametry:

* -F {*hodnota*} :: Přednastaví hodnotu proměnné FS (vstupního oddělovače sloupců).
* -v {*proměnná*}={*hodnota*} :: Přednastaví hodnotu určité proměnné.
* -f {*soubor*} :: Načte kód ke spuštění z daného souboru.
* -e {*kód*} :: Vezme uvedený kód ke spuštění.
* -b :: Vstup a výstup realizuje po bajtech, ne v UTF-8.
* --profile={*soubor*} :: Shromáždí „profilovací“ data a po skončení programu je zapíše do uvedeného souboru. (Nezkoušeno.)
* --sandbox :: Vypne všechny funkce, které by mohl skript použít k přístupu k jiným souborům než těm, které mu byly předány na příkazovém řádku; to zahrnuje např. funkci „system()“, přesměrování výstupů apod.

Poznámka: Parametry -f a -e můžete kombinovat a zadávat opakovaně. Každý další takový parametr přidá takový kód k již načtenému, takže se nakonec všechny spojí do jednoho programu.

## Instalace na Ubuntu
*# *<br>
**sudo apt-get install gawk**

<!--

## Ukázka
<!- -
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti − ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
- ->
![ve výstavbě](../obrazky/ve-vystavbe.png)

-->

!ÚzkýRežim: zap

## Tipy a zkušenosti

* V AWK jsou všechna pole asociativní (včetně těch indexovaných celými čísly), a tedy neuspořádaná. Při indexování pole číslem se číslo nejprve převede na řetězec.
* Je velmi často využívána syntaktická zkratka, že literál regulárního výrazu (např. /^a/) se automaticky rozšířít na test načteného řádku (např. „($0 ~ /^a/)“).
* V AWK je středník potřeba jen k oddělení příkazů na jednom řádku, přesto z důvodu přehlednosti doporučuji ho psát na konci příkazu s výjimkou případu, kdy jde o jediný příkaz v bloku, k němuž těsně přiléhají složené závorky, např. „{print $0}“.
* Skalární proměnné se do funkcí předávají hodnotou, pole odkazem.
* Hodnoty ARGC a ARGV je možno za běhu skriptu bez omezení měnit, a tím ovlivňovat, které další soubory gawk či mawk otevře. Na již otevřené soubory to ale nemá vliv.
* Používání koprocesů vyžaduje pečlivou synchronizaci mezi procesy. Existuje dvě situace, které vedou k zamrznutí programu a musíte se jim vyhnout: 1) Pokus o přečtení řádku z výstupu koprocesu, zatímco koproces nezapisuje, ale sám čeká na další vstup. 2) Zapsání velkého množství dat (cca od desítek kilobajtů) na vstup koprocesu, která koproces nenačte. (V takovém případě se naplní buffer roury.)
* V literálech regulárních výrazů je nutno escapovat obyčejná lomítka, a to dokonce i uvnitř hranatých závorek, např. „a\*[x\\/y]+“, v dynamických regulárních výrazech je není nutno escapovat.
* Chcete-li příkaz pokračovat na další řádce, vložte před konec řádky „\\“.
* Obsahuje-li skript pouze vzorky BEGIN a žádné jiné, AWK nebude otevírat vstupní soubory a po vykonání průchodu BEGIN okamžitě skončí. Toho lze využít k napsání programu, který vstup nezpracovává.
* Nestojí-li za sekvencí zpětných lomítek v řetězci náhrady funkcí sub() a gsub() „&amp;“, chová se toto escapování nelogicky − méně než tři zpětná lomítka se použijí tak, jak jsou, a každá čtveřice zpětných lomítek se zredukuje na dvě zpětná lomítka a zbytek sekvence se bere jako od začátku, takže např. 6 zpětných lomítek (v řetězci zapsaných jako 12) zapíše při náhradě čtyři zpětná lomítka, protože první čtyři lomítka se zredukovala na dvě a zbylá dvě se vzala tak, jak jsou. Toto neplatí ve funkci gensub(), ta se chová konzistentně a každou dvojici zpětných lomítek zredukuje na jedno, ať za ní následuje ampresand nebo ne. Pokud tedy potřebujete nahrazovat shody regulárního výrazu zpětnými lomítky, doporučuji vždy řetězec náhrady předem otestovat a pamatovat, že funkce sub() a gsub() zachází se zpětnými lomítky, za kterými nenásleduje ampresand, jinak než funkce gensub().

## Další zdroje informací

* [Článek na Wikipedii](https://cs.wikipedia.org/wiki/AWK)
* [Přednáška Lukáše Bařinky „(g)awk in a nutshell“](https://www.youtube.com/watch?v=y8klNyswPfo)
* [Článek na ABC Linuxu](http://www.abclinuxu.cz/clanky/unixove-nastroje-21-awk)
* [Oficiální manuál: Řetězcové funkce (reference)](https://www.gnu.org/software/gawk/manual/html_node/String-Functions.html) (anglicky)
* [Oficiální manuál od GNU](https://www.gnu.org/software/gawk/manual/) (anglicky)
* *man 1 gawk* (anglicky)
* [Balíček gawk](https://packages.ubuntu.com/bionic/gawk)
* [Video „Using AWK to filter Data from Fields in Linux“](https://www.youtube.com/watch?v=i67fbJNfihU) (anglicky)
* [Video „Controlling Array Sorting in AWK“](https://www.youtube.com/watch?v=88oVSJMm8xI) (anglicky)
* [Awk tutorial](https://www.grymoire.com/Unix/Awk.html) (anglicky)
* [Video „awk command \| Powerful Text Manipulation Tool“](https://www.youtube.com/watch?v=7qaBKueySg0) (anglicky)
* [Video: UNIX − awk explained](https://www.youtube.com/watch?v=7p-P0mMzc1E) (anglicky)
* [TL;DR stránka](https://github.com/tldr-pages/tldr/blob/master/pages/common/awk.md) (anglicky)

!ÚzkýRežim: vyp

## Pomocné funkce a skripty

*# lkk retence − načte celý standardní vstup do paměti a po uzavření vstupu jej vypíše na výstup*<br>
**#!/bin/bash**<br>
**exec gawk -b -e 'BEGIN {RS = FS = "^$"; ORS = "";} {print}'**

<!--
### Pomocné funkce
*# escapovat()*<br>
**function escapovat(s) {gsub(/[\\\\\|.\*+?{}[\\]()\\/^$]/, "\\\\\\\\&amp;", s);return s;}**

*# escapovatknahrade()*<br>
**function escapovatknahrade(s) {gsub(/[\\\\&amp;]/, "\\\\\\\\&amp;", s);return s;}**

Poznámka:
- mawk neumí syntaxi {} v rozšířených regulárních výrazech.
-->
