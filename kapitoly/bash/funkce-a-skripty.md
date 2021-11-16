<!--

Linux Kniha kouzel, kapitola Bash: Funkce a skripty
Copyright (c) 2019-2021 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
⊨
-->

# Funkce a skripty

!Štítky: {program}{bash}{programování}{automatizace}
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod

Funkce a skripty jsou základními prostředky pro automatizaci a umožňují opakovaně
vykonávat komplikované operace pomocí jednoduchých příkazů. Tato kapitola
pokrývá jejich vytváření a používání v Bashi a uvádí také nástroje Bashe
používané především ve skriptech a funkcích (ačkoliv většinu z nich lze použít
i v interaktivním režimu).

Funkce či skript je vždy tvořen uloženou posloupností příkazů, která může být „zavolána“
a přitom jí mohou být předány textové parametry.
Hlavní rozdíl mezi funkcí a skriptem je, že funkce se ukládají do paměti
konkrétní instance interpretu (podobně jako proměnné), zatímco skript
je uložen v souboru (popř. se načítá z roury).

Interpret Bash je vyvíjen v rámci projektu GNU.

## Definice

* **Funkce** je posloupnost příkazů k vykonání uložená v paměti interpretu (podobně jako proměnná). Spouští se zadáním jejího názvu jako příkazu a vykonává se v tomtéž interpretu (tzn. změny proměnných a nastavení provedené ve funkci zůstanou v platnosti i po návratu z ní).
* **Skript** je posloupnost příkazů k vykonání uložená v souboru (popř. načítaná z roury). Skript lze spustit několika způsoby (budou probrány níže). Skript se obvykle spustí v nové instanci interpretu (ve stejné instanci ho lze spustit příkazem „source“).
* **Poziční parametry** jsou zvláštní číslované proměnné dostupné jako „$1“, „$2“, ..., „$9“, „${10}“ atd. Při volání funkce či skriptu se tyto proměnné na dobu jejího/jeho běhu „překryjí“ textovými hodnotami parametrů, se kterými byla funkce či skript volán; ručně je lze nastavit příkazem „set“, ale pouze všechny najednou.
* **Překryvná proměnná** je dočasná proměnná ve funkci, která existuje jen do ukončení jejího volání. Pokud v momentě vytvoření překryvné proměnné již existovala (globální nebo překryvná) proměnná stejného názvu, nová proměnná tu původní na dobu své existence překryje (a tím pádem dočasně znepřístupní); čtení i přiřazení budou pracovat s překryvnou proměnnou a teprve po jejím zániku bude předchozí proměnná znovu zpřístupněna. Překryvné proměnné nejsou lokální — po dobu své existence jsou bez jakékoliv kvalifikace dostupné z celého skriptu, a dokonce mohou být exportovány (jako proměnné prostředí), aniž by to narušilo jejich dočasnost. Pozor, překryvné proměnné nejsou dovoleny mimo funkce (ani ve skriptu).

!ÚzkýRežim: vyp

## Zaklínadla: Základní

### Logické řetězení příkazů

Poznámka: „příkazem“ se v těchto zaklínadlech rozumí příkaz včetně všech parametrů, přesměrování, rour apod., dokonce to může být i celý blok příkazů ve složených závorkách.

*# vykonat příkaz A a **po něm** příkaz B*<br>
{*příkaz A*}**;** {*příkaz B*}

*# „**a**“: vykonat příkaz A, a pokud skončil úspěšně ($? = 0), vykonat příkaz B*<br>
{*příkaz A*} **&amp;&amp;** {*příkaz B*}

*# „**nebo**“: vykonat příkaz-A, a pokud skončil neúspěšně ($? ≠ 0), vykonat příkaz B*<br>
{*příkaz A*} **\|\|** {*příkaz B*}

### Řízení běhu

*# cyklus „**while**“*<br>
*// Cyklus se opakuje, dokud testovací příkazy skončí úspěchem (s kódem 0).*<br>
**while** {*testovací-příkazy*}<br>
**do** {*příkazy; cyklu*}<br>
**done** [{*přesměrování*}]

*# cyklus „**foreach**“*<br>
**for** {*identifikator\_promenne*} **in** {*parametry*}<br>
**do** {*příkazy; cyklu*}<br>
**done** [{*přesměrování*}]

*# cyklus „**for**“*<br>
**for** {*identifikator\_promenne*} **in \{**{*počáteční-hodnota*}**..**{*poslední-hodnota*}[**..**{*skok*}]**\}**<br>
**do** {*příkazy; cyklu*}<br>
**done** [{*přesměrování*}]

*# skok za/před konec cyklu*<br>
**break** [{*o-kolik-úrovní*}]<br>
**continue** [{*o-kolik-úrovní*}]

*# podmínka if-else-if*<br>
**if** {*testovací-příkazy*}<br>
**then** {*příkazy větve*}<br>
[**elif** {*testovací-příkazy*}<br>
**then** {*příkazy větve*}]...<br>
[**else** {*příkazy větve else*}]<br>
**fi** [{*přesměrování*}]

*# větvení podle shody se vzorkem*<br>
*// Text je (po provedení rozvoje) testován proti jednomu vzorku za druhým. Je-li nalezen vzorek, se kterým se text shoduje, provedou se příkazy příslušné větve a zbytek vzorků se netestuje. Ukončovač větve „;;“ je možno umístit na konec příkazu nebo na samostatnou řádku. Tip: části vzorků můžete podle potřeby odzvláštnit běžnými způsoby (zpětným lomítkem, dvojitými uvozovkami apod.).*<br>
**case "**{*text*}**" in**<br>
<odsadit1>**(**{*vzorek*}[**\|**{*alternativní-vzorek*}]...**)** {*příkazy větve*}... **;;**<br>
<odsadit1>[**(**{*vzorek*}[**\|**{*alternativní-vzorek*}]...**)** {*příkazy větve*}... **;;**]...<br>
**esac** [{*přesměrování*}]

*# cyklus s **menu***<br>
*// Pokud není seznam „parametry“ prázdný, vypíše uživateli (na standardní chybový výstup) číslované menu, přečte od něj odpověď a text vybraného parametru uloží do proměnné. Uživatel může požádat o znovuvypsání menu stisknutím „Enter“ bez odpovědi. Zadá-li uživatel neplatnou odpověď, do proměnné se uloží prázdný řetězec. Cyklus se opakuje, dokud není seznam parametrů prázdný (ale je obvyklé ho přerušit příkazem „break“).*<br>
**select** {*identifikator\_promenne*} **in** {*parametry*}<br>
**do** {*příkazy; cyklu*}<br>
**done** [{*přesměrování*}]

*# ukončit interpret*<br>
*// Poznámka: hranice funkce či skriptu příkaz „exit“ neomezují, hranice podprostředí však ano — „exit“ dokáže ukončit podprostředí a vrátit návratovou hodnotu z něj, ne však ukončit obalující interpet.*<br>
**exit** [{*návratový-kód*}]

### Zvláštní proměnné

*# **návratová hodnota** posledního vykonaného příkazu*<br>
*// Tato hodnota může být negována metapříkazem „!“, viz kapitolu Metapříkazy.*<br>
**$?**

*# pole návratových hodnot příkazů z poslední vykonané roury*<br>
*// Poznámka: jednoduchý příkaz toto pole přepíše jednoprvkovým polem; obsah tohoto pole není nikdy ovlivněn metapříkazem „!“.*<br>
**${PIPESTATUS[**{*index*}**]}**

*# text **posledního parametru** posledního jednoduchého příkazu vykonaného na popředí*<br>
*// Poznámka: roury se dvěma a více členy, příkazy spuštěné na pozadí operátorem „&amp;“ a příkazy dosazené operátorem $() ponechávají této zvláštní proměnné její hodnotu (tzn. nezmění ji).*<br>
**$\_**

*# **PID**/PPID probíhajícího interpretu*<br>
**\$\$**<br>
**$PPID**

*# **náhodné** číslo v rozsahu 0 až 255/32767/65535/2147483647/4294967295*<br>
**$((RANDOM &amp; 255))**<br>
**$RANDOM**<br>
**$((RANDOM &lt;&lt; 1 \| RANDOM &amp; 1))**<br>
**$((RANDOM &lt;&lt; 16 \| RANDOM &lt;&lt; 1 \| RANDOM &amp; 1))**<br>
**$((RANDOM &lt;&lt; 17 \| RANDOM &lt;&lt; 2 \| RANDOM &amp; 3))**

*# aktuální počet sloupců/řádek terminálu*<br>
**$COLUMNS** ⊨ 80<br>
**$LINES** ⊨ 25

*# **počet sekund** od startu této instance interpretu*<br>
**$SECONDS** ⊨ 7051

*# počet sekund od 1. 1. 1970 00:00:00 UTC (celé číslo/desetinné číslo s přesností na mikrosekundy)*<br>
*// Pozor na skutečnost, že formát čísla u proměnné „EPOCHREALTIME“ závisí na nastaveném národním prostředí. K získání zpracovatelného formátu lze použít podprostředí s nastavením „LC\_ALL=C“.*<br>
**$EPOCHSECONDS** ⊨ 1620459769<br>
**$EPOCHREALTIME** ⊨ 1620459769,984485

*# číslo řádku (jen ve skriptu)*<br>
*// Jde o číslo řádku, na které se nachází první znak jednotlivého příkazu; pokud příkaz pokračuje přes několik řádků, hodnota proměnné LINENO je na všech těchto řádcích jednotná.*<br>
**$LINENO** ⊨ 137

*# verze Bashe (hlavní/vedlejší číslo)*<br>
**${BASH\_VERSINFO[0]}** ⊨ 5<br>
**${BASH\_VERSINFO[1]}** ⊨ 0

### Poziční parametry (skriptů i funkcí)

*# dosadit N-tý **poziční parametr** (alternativy)*<br>
*// První variantu lze použít pouze pro parametry $0 až $9. Druhou variantu (tu se složenými závorkami) lze použít i pro ostatní parametry (např. ${10}) a lze ji skombinovat s pokročilými formami dosazení.*<br>
**$**{*N*}<br>
**$\{**{*N*}**\}**

*# dosadit **všechny parametry** od $1: do samostatných parametrů/jen oddělené mezerou*<br>
*// Dvojité uvozovky zde znamenají, že pro správnou funkci musí být $@ (resp. $\*) uvedeny uvnitř dvojitých uvozovek.*<br>
**"$@"**<br>
**"$\*"**

*# dosadit **počet** pozičních parametrů*<br>
**$#** ⊨ 0

*# smazat N pozičních parametrů počínaje od $1, zbytek přečíslovat*<br>
*// Výchozí N je 1. Pokud je pozičních parametrů méně než N, příkaz selže s návratovým kódem 1 a poziční parametry zůstanou nezměněné.*<br>
**shift** [{*N*}]

*# **nastavit** poziční parametry*<br>
*// Parametry lze nastavit pouze najednou, přičemž se všechny stávající parametry (kromě $0) ztratí.*<br>
**set \-\-** {*parametr*}...

*# dosadit **úsek** parametrů (samostatně/oddělené mezerou)*<br>
**"${@:** {*číslo-prvního-parametru*} [**:** {*maximální-počet*}] **\}"**<br>
**"${\*:** {*číslo-prvního-parametru*} [**:** {*maximální-počet*}] **\}"**

*# dosadit všechny parametry počínaje $0 (samostatně/oddělené mezerou)*<br>
**"${@:0}"**<br>
**"${\*:0}"**

### Funkce „zvenku“

*# **vytvořit** (resp. předefinovat) funkci*<br>
*// Závorku „{“ můžete oddělit na samostatnou řádku, pokud vám to připadne přehlednější; je-li uzavírací závorka „}“ na stejné řádce jako poslední příkaz těla funkce, musí být od něj oddělená středníkem nebo „&amp;“.*<br>
[**function**] {*nazev\_funkce*} **\{**<br>
<odsadit1>{*příkazy funkce*}...<br>
**\}** [{*přesměrování pro funkci*}]

*# **zavolat** funkci*<br>
{*nazev\_funkce*} [{*poziční parametry*}]

*# **seznam** funkcí (s těly/bez těl)*<br>
**declare -f**<br>
**compgen -A function**

*# **existuje** funkce?*<br>
**declare -f** {*nazev\_funkce*} **&gt;/dev/null**

*# **zrušit** funkci*<br>
**unset -f** {*nazev\_funkce*}

*# vypsat **definici** funkce*<br>
**declare -f** {*nazev\_funkce*}

*# exportovat/neexportovat funkci*<br>
*// Exportované funkce se uloží do zvláštních proměnných prostředí a další instance bashe, která je tímto způsobem „zdědí“, je opět načte jako funkce. Doporučuji exportování funkcí příliš nepoužívat, protože tak můžete snadno ztratit kontrolu nad tím, kam všude se vaše funkce dostanou.*<br>
**export -f** {*nazev\_funkce*}<br>
**export -fn** {*nazev\_funkce*}

### Funkce „uvnitř“

*# vytvořit **překryvnou proměnnou***<br>
**local** {*identifikator*}[**=**{*hodnota*}] <nic>[{*identifikator*}[**=**{*hodnota*}]]...

*# uvnitř funkce ve skriptu vypsat „**stack-trace**“ (jen volání této funkce/všechny úrovně)*<br>
**caller 1**<br>
**(i=0; while caller $((i++)); do true; done)**

*# úroveň zanoření funkce (proměnná)*<br>
**$FUNCNEST** ⊨ 1

### Skript „zvenku“

*# spustit skript v nové instanci interpretu (alternativy)*<br>
*// Druhá a třetí varianta vyžadují, abyste měl/a k danému souboru právo „x“ (spouštění).*<br>
**bash** [{*-volby -Bashe*}] {*cesta/ke/skriptu*} [{*poziční parametry*}]<br>
{*cesta/ke/skriptu*} [{*poziční parametry*}]<br>
**./**{*relativní/cesta/ke/skriptu*} [{*poziční parametry*}]

*# spustit skript v této instanci interpretu*<br>
*// Pozor! Pokud cesta ke skriptu neobsahuje lomítko „/“, Bash bude skript hledat jako externí příkaz (tzn. s použitím proměnné PATH). Pro spuštění skriptu z aktuálního adresáře tedy před název souboru uveďte „./“!*<br>
**source** {*cesta/ke/skriptu*} [{*poziční parametry*}]

*# spustit v nové/této instanci interpretu skript ze standardního vstupu*<br>
*// Poznámka: *<br>
**bash** [{*-volby -Bashe*}] **/dev/stdin** [{*poziční parametry*}]<br>
**source -** [{*poziční parametry*}]

*# spustit v nové instanci „předskript“ a po něm hlavní skript*<br>
*// Poziční parametry jsou dostupné již v předskriptu a jejich případná změna se zachová do hlavního skriptu. To vám umožňuji použít předskript k „předzpracování“ pozičních parametrů.*<br>
**BASH\_ENV=**{*cesta/předskriptu*} [**bash** [{*-volby -Bashe*}]] {*cesta/ke/skriptu*} [{*poziční parametry*}]

### Vykonání kódu

*# vykonat řetězec jako příkazy v této instanci interpretu*<br>
**eval** {*"řetězec"*}

*# vyhodnotit celočíselný výraz kvůli vedlejším efektům*<br>
**true $((**{*výraz*}**))**
















### Obsluha signálů a zvláštních situací

*# nastavit obsluhu signálu (obecně/příklad)*<br>
**trap** [**\-\-**] **'**{*příkazy*}...**'** {*signál*}...

*# nastavit prázdnou/výchozí obsluhu signálu*<br>
**trap ""** {*signál*}...<br>
**trap -** {*signál*}...

*# vypsat nastavené obsluhy všech signálů (přikazy trap)*<br>
**trap**

*# vypsat obsluhu určitého signálu (příkaz „trap“/text obsluhy)*<br>
**trap -p** {*signál*}...<br>
**(function f { test "$1" '!=' trap \|\| shift; test "$1" '!=' \-\- \|\| shift; printf %s\\\\n "$1"; }; eval "$(trap -p** {*signál*} **\| sed -E 's/trap/f/')")**

*# nastavit/zrušit obsluhu ukončení interpretu*<br>
**trap '**{*příkazy*}**' EXIT**<br>
**trap - EXIT**

<!--
[ ] vyzkoušet
*# nastavit/zrušit obsluhu chyby (účinkuje jen při nastavení „set -e“)*<br>
**trap '**{*příkazy*}**' ERR**<br>
**trap - ERR**
-->

<!--
DEBUG: před každým jednoduchým příkazem
RETURN: při ukončení funkce nebo „source“ skriptu
ERR: místo ukončení interpretu při -e
-->

### Skript „uvnitř“

*# číslo řádky skriptu*<br>
*// Jde o číslo řádky, na které se nachází první znak jednotlivého příkazu; pokud příkaz pokračuje přes několik řádek, hodnota proměnné LINENO je na všech těchto řádkách jednotná.*<br>
**$LINENO** ⊨ 137

*# verze Bashe (hlavní/vedlejší číslo)*<br>
**${BASH\_VERSINFO[0]}** ⊨ 5<br>
**${BASH\_VERSINFO[1]}** ⊨ 0

*# běží tato instance interpretu v interaktivním režimu?*<br>
**[[ $- == \*i\* ]]**

## Zaklínadla: Testy pro podmínky

### Typ a existence adresářových položek

*Poznámka:* V Bashi můžete všechny uvedené varianty příkazu „test“ nahradit konstrukcí \[\[ {*parametry*} \]\], opačně to však neplatí. V interpretu „sh“ je můžete nahradit konstrukcí „[ {*parametry*} ]“.

*Poznámka 2:* Příkaz „test“ s výjimkou volby „-L“ následuje symbolické odkazy; pro vyloučení symbolických odkazů přidejte negovanou volbu „-L“.

*# příklad: vytvořit adresář „x“, ledaže taková adresářová položka již existuje*<br>
**test -e x \|\| mkdir x**

*# existuje položka adresáře?*<br>
**test -e** {*cesta*}

*# je to **soubor**/neprázdný soubor?*<br>
**test -f "**{*cesta*}**"**<br>
**test -f "**{*cesta*}**" -a -s "**{*cesta*}**"**

*# je to **adresář**?*<br>
**test -d "**{*cesta*}**"**

*# je to symbolický odkaz?*<br>
**test -L "**{*cesta*}**"**

*# je to pojmenovaná roura?*<br>
**test -p "**{*cesta*}**"**

*# je to blokové zařízení/znakové zařízení/soket?*<br>
**test -b "**{*cesta*}**"**<br>
**test -c "**{*cesta*}**"**<br>
**test -S "**{*cesta*}**"**

### Textové řetězce (testy)

*# je řetězec **neprázdný**/prázdný?*<br>
**test -n "**{*řetězec*}**"**<br>
**test -z "**{*řetězec*}**"**

*# jsou si dva řetězce rovny/liší se?*<br>
**test "**{*řetězec 1*}**" = "**{*řetězec 2*}**"**<br>
**test "**{*řetězec 1*}**" \\!= "**{*řetězec 2*}**"**

*# shoduje se text proměnné se **vzorkem** Bashe? (obecně/příklad)*<br>
**[[ $**{*název\_proměnné*} **=** {*vzorek*} **]]**<br>
**[[ $data = "Ahoj, "\*'!' ]]**

*# je **pořadí** řetězce v seřazeném seznamu menší/větší/shodné*<br>
*// Bash uvažuje řazení podle aktuálně platné lokalizace. Pro binární řazení použijte „LC\_ALL=C“.*<br>
**[[ "**{*řetězec 1*}**" &lt; "**{*řetězec 2*}**" ]]**<br>
**[[ "**{*řetězec 1*}**" &gt; "**{*řetězec 2*}**" ]]**<br>
**[[ !("**{*řetězec 1*}**" &lt; "**{*řetězec 2*}**" || "**{*řetězec 1*}**" &gt; "**{*řetězec 2*}**") ]]**

*# má text proměnné alespoň N znaků?*<br>
**test ${#**{*název\_proměnné*}**\} -ge** {*N*}

### Regulární výrazy (testy a extrakce)

*# obsahuje text proměnné shodu s **regulárním výrazem**? (bash/sh)*<br>
*// Název proměnné „regvyraz“ zde nemá žádný speciální význam, je zvolen jen pro přehlednost; můžete použít jakoukoliv proměnnou. Jednoduchý regulární výraz (takový, který neobsahuje mezery, uvozovky, zpětná lomítka ani hranaté závorky) můžete dokonce zadat přímo, pro zadání složitějšího výrazu je ale striktně doporučeno jej předem uložit do proměnné, protože pravidla odzvláštňování v tomto kontextu jsou složitá a neintuitivní.*<br>
**regvyraz='**{*regulární výraz*}**'**<br>
**[[ $**{*název\_proměnné*} **=~ $regvyraz ]]**<br>
{*název\_proměnné*}**=$**{*název\_proměnné*} **regvyraz='**{*regulární výraz*}**' bash -c '[[ $**{*název\_proměnné*} **=~ $regvyraz ]]'**

*# text první shody po úspěšném testu „[[ text =~ výraz ]]“*<br>
**${BASH\_REMATCH[0]}**

*# text N-tého záchytu první shody (1, 2, ...) po úspěšném testu „[[ text =~ výraz ]]“*<br>
**${BASH\_REMATCH[**{*N*}**]}**

*# pozice první shody po úspěšném testu*<br>
?

### Celá čísla (testy)

*# =*<br>
**((**{*číslo1*} **=** {*číslo2*}**))**

*# &lt;*<br>
**((**{*číslo1*} **&lt;** {*číslo2*}**))**

*# &gt;*<br>
**((**{*číslo1*} **&gt;** {*číslo2*}**))**

*# ≤*<br>
**((**{*číslo1*} **&lt;=** {*číslo2*}**))**

*# ≥*<br>
**((**{*číslo1*} **&gt;=** {*číslo2*}**))**

*# ≠*<br>
**((**{*číslo1*} **!=** {*číslo2*}**))**

### Čas „změněno“ u souborů a adresářů

*# je soubor1 **novější** než soubor2? (&gt;)*<br>
**test "**{*soubor1*}**" -nt "**{*soubor2*}**"**

*# je soubor1 stejně starý nebo novější než soubor2? (≥)*<br>
**test ! "**{*soubor1*}**" -ot "**{*soubor2*}**"**

*# je soubor1 stejně starý jako soubor2? (=)*<br>
**test ! "**{*soubor1*}**" -ot "**{*soubor2*}**" -a ! "**{*soubor1*}**" -ot "**{*soubor2*}**"**

*# je soubor1 stejně starý nebo starší než soubor2 (≤)*<br>
**test ! "**{*soubor1*}**" -nt "**{*soubor2*}**"**

*# je soubor1 **starší** než soubor2? (&lt;)*<br>
**test "**{*soubor1*}**" -ot "**{*soubor2*}**"**

### Práva adresářových položek

Poznámka: testy -r, -w a -x netestují nastavená přístupová práva, ale faktickou
proveditelnost dané operace; proto „w“ vrátí „nepravdu“ u souboru s právem „w“,
který se nachází na oddílu připojeném jen pro čtení, a test „r“ provedený
superuživatelem vrátí „pravdu“ u souboru, který nesmí číst nikdo „chmod a-r“.

*# můžeme ji/ho číst?*<br>
**test -r "**{*cesta*}**"**

*# můžeme do ní/něj zapisovat?*<br>
**test -w "**{*cesta*}**"**

*# můžeme ji/ho spouštět, resp. vstoupit do adresáře?*<br>
**test -x "**{*cesta*}**"**

*# má nastavený „sticky“/„set-user-id“ bit?*<br>
**test -k "**{*cesta*}**"**<br>
**test -u "**{*cesta*}**"**

### Ostatní testy

*# znamenají dvě adresářové položky tutéž entitu? (následuje symbolické odkazy)*<br>
*// Typicky se tento test používá k odhalení pevných odkazů nebo synonym vytvořených např. pomocí „mount \-\-bind“.*<br>
**test** {*cesta1*} **-ef** {*cesta2*}

*# je proměnná definovaná? (jen bash)*<br>
**[[ -v** {*název\_proměnné*} **]]**

<!--
*# je proměnná jmenný odkaz na jinou proměnnou? (jen bash)*<br>
**[[ -R** {*název\_proměnné*} **]]**
-->

<!--
## Parametry příkazů

<!- -
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)
-->

## Instalace na Ubuntu

Bash a všechny příkazy použité v této kapitole jsou základními součástmi
Ubuntu přítomnými i v minimální instalaci.

<!--
## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)
-->

!ÚzkýRežim: zap

## Tipy a zkušenosti
<!--
<!- -
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)
-->

* Klávesové zkratky Ctrl+C a Ctrl+C se chovají nečekaným způsobem při provádění cyklu nebo volání funkce z interaktivního interpretu. Pokud se tomu chcete vyhnout, uzavřete při volání funkci či cyklus do podprostředí.
* Funkce na rozdíl od aliasů nemají ochranu proti rekurzi, takže funkce může volat sama sebe. Pokud chcete funkcí nahradit nějaký externí příkaz a pak ho z ní volat, použijte vestavěný příkaz „command“.
* Bash nabízí několik možných syntaxí k definici funkce. Definice s příkazem „function“ je dle mého názoru nejsnáze čitelná, ale není příliš běžná.

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->

* [GNU Bash Shell Functions](https://www.gnu.org/software/bash/manual/html_node/Shell-Functions.html#Shell-Functions) (anglicky)

## Zákulisí kapitoly
<!--
- Doplňte, pokud víte. Udržujte aktuální.
-->

V této verzi kapitoly chybí:

!KompaktníSeznam:
* getopt
* proměnná SHLVL

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* Práci s proměnnými (viz kapitolu Proměnné příkazy a interpretu)

Další poznámky:

!KompaktníSeznam:
* Nastavení proměnné BASH\_ENV umožňuje spustit „před-skript“ při spouštění skriptu.

!ÚzkýRežim: vyp
