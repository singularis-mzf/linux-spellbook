<!--

Linux Kniha kouzel, kapitola Bash
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

[ ] + alias/unalias
[ ] koprocesy https://www.gnu.org/software/bash/manual/html_node/Coprocesses.html#Coprocesses
[ ] trap

Zvláštní návratové kódy ( https://tldp.org/LDP/abs/html/exitcodes.html ):

126 — příkaz nelze spustit (program nalezen, ale není spustitelný)
127 — příkaz nenalezen
128..165 — příkaz ukončen signálem $(($? - 128))
130 — příkaz ukončen Ctrl + C (SIGINT)
148 — příkaz přerušen Ctrl + Z (SIGTSTP)

⊨
-->

# Bash

!Štítky: {program}{bash}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

GNU Bash...

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

* **Deskriptor** je číselné označení vstupu či výstupu interpretu, případně jím spouštěných programů. Deskriptor 0 se nazývá **standardní vstup**, deskriptor 1 **standardní výstup** a deskriptor 2 **standardní chybový výstup**. Deskriptory 0 až 9 jsou pro volné využití uživatelem; deskriptory 10 až 255 jsou vyhrazeny pro vnitřní použití interpretem.
* **Podprostředí** (subshell) je oddělené prostředí pro vykonávání příkazů. Příkazy v podprostředí získají kopii všech proměnných, deskriptorů a nastavení, ale změny, které provedou, se vrátí do původního stavu, jakmile bude podprostředí opuštěno. Podprostředí má jako celek svůj návratový kód a jako na celek na něj mohou být aplikována přesměrování.

!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

### Roura

*# přesměrovat std. výstup příkazu A na std. vstup příkazu B*<br>
{*příkaz-A včetně přesměrování*} **\|** {*příkaz-B včetně přesměrování*}

*# přesměrovat std. výstup a std. chyb. výstup příkazu A na std. vstup příkazu B*<br>
{*příkaz-A včetně přesměrování*} **\|&amp;** {*příkaz-B včetně přesměrování*}

### Přesměrování vstupu (čtení)

*# vstup z existujícího souboru*<br>
[{*deskriptor*}]**&lt;** {*cesta*}

*# prázdný vstup*<br>
[{*deskriptor*}]**&lt; /dev/null**

*# na vstup příkazu zapsat zadaný text a znak konce řádky „\\n“ (obecně/příklady)*<br>
*// Poznámka: znak „\\n“ bude na konec přidán i v případě, že už jím zadaný text končí.*<br>
[{*deskriptor*}]**&lt;&lt;&lt;** {*parametr*}<br>
**sort &lt;&lt;&lt; $'zoo\\nahoj\\nseminář'**<br>
**sort &lt;&lt;&lt; "A$(echo BC)D"**

*# na vstup příkazu zapsat blok řádek*<br>
*// Zadaný ukončovač musí být neprázdný řetězec. Bash na přesměrovávaný vstup zapíše všechny řádky počínaje první řádkou po aktuálním příkazu a konče poslední řádkou, která se přesně neshoduje s ukončovačem (musí odpovídat i odsazení).*<br>
[{*deskriptor*}]**&lt;&lt; '**{*ukončovač*}**'**

*# vstup z pojmenovaného deskriptoru*<br>
{*příkaz a parametry*} [{*cílový-deskriptor*}]**&lt;&amp;$**{*identifikator-pojm-desk*}

*# zduplikovat deskriptor*<br>
*// Zduplikování deskriptoru čtoucího ze souboru není totéž jako dvojité otevření téhož souboru; duplikáty téhož deskriptoru totiž sdílí stejnou pozici, takže čtením z jednoho se posouvá i pozice pro čtení z ostatních. Naproti tomu při otevření téhož souboru na dva různé deskriptory bude každý z nich mít samostatnou pozici čtení, která nebude ovlivňována čtením z toho druhého.*<br>
[{*cílový-deskriptor*}]**&lt;&amp;**{*zdrojový-deskriptor*}

*# vstup ze standardního výstupu bloku příkazů (obecně/příklad)*<br>
[{*deskriptor*}]**&lt;&blank;&lt;(**{*příkazy...*}**)**<br>
**sort &lt;(echo Zoo; echo Abeceda)**

*# přečíslovat („přesunout“) deskriptor*<br>
[{*cílový-deskriptor*}]**&gt;&amp;**{*zdrojový-deskriptor*}**-**

*# zavřít deskriptor*<br>
{*deskriptor*}**&lt;&amp;-**

*# na vstup zapsat blok řádek po rozvoji*<br>
*// Pozor! Při použití tohoto zaklínadla nesmí být žádný znak v identifikátoru odzvláštněn (tzn. používejte jen znaky, které pro Bash nemají zvláštní význam). Bash na přesměrovávaný vstup zapíše všechny řádku počínaje první řádkou po aktuálním příkazu a konče poslední řádkou, která se přesně neshoduje se zadaným identifikátorem (shoda musí být přesná, ani bílé znaky na začátku či konci nejsou dovoleny). Před jejich použitím je Bash intepretuje, přičemž za zvláštní považuje znaky „$“, „\\“ a „\`“ (s výjimkou apostrofů s dolarem, ty tam přímo použít nelze), můžete tam tedy vkládat hodnoty proměnných a výstupy příkazů.*<br>
[{*deskriptor*}]**&lt;&lt;-** {*identifikátor*}

### Přesměrování výstupu (zápis/přepis)

*# výstup do souboru (vytvořit prázdný nebo zkrátit existující)*<br>
*// Znak „\|“ má význam pouze v případě, že máte nastavenou volbu „noclobber“. V takovém případě umožní přepsání existujícího souboru.*<br>
[{*deskriptor*}]**&gt;**[**\|**] {*cesta*}

*# výstup připojit výstup za konec souboru (pokud neexistuje, vytvořit prázdný)*<br>
[{*deskriptor*}]**&gt;&gt;**[**\|**] {*cesta*}

*# výstup **nikam***<br>
[{*deskriptor*}]**&gt; /dev/null**

*# zduplikovat deskriptor*<br>
[{*cílový-deskriptor*}]**&gt;&amp;**{*zdrojový-deskriptor*}

*# výstup na standardní vstup bloku příkazů (obecně/příklad)*<br>
[{*deskriptor*}]**&gt;&blank;&gt;(**{*příkaz*}...**)**<br>
**df -h &gt;&blank;&gt;(sed -u 1q; sort)**

*# přečíslovat („přesunout“) deskriptor*<br>
[{*cílový-deskriptor*}]**&gt;&amp;**{*zdrojový-deskriptor*}**-**

*# zavřít deskriptor*<br>
{*deskriptor*}**&gt;&amp;-**

*# **přepis** souboru (čtení i zápis, bez zkrácení) (obecně/příklad příkazu)*<br>
*// Vyžaduje právo soubor číst i do něj zapisovat; neexistující soubor bude vytvořen, existující soubor nebude zkrácen a zápis začne bajt po bajtu přepisovat jeho obsah od začátku souboru.*<br>
{*cílový-deskriptor*}**&lt;&gt;**{*cesta*}<br>
**echo ABC 2&gt;&amp;1 1&lt;&gt; můj-soubor.txt**

*# výstup do pojmenovaného deskriptoru*<br>
{*příkaz a parametry*} [{*cílový-deskriptor*}]**&gt;&amp;$**{*identifikator-pojm-desk*}

### Otevírání a zavírání pojmenovaných deskriptorů

*# otevřít existující soubor pro vstup (čtení) (obecně/příklad)*<br>
**exec \{**{*identifikator*}**\}&gt;** {*cesta/k/souboru*}<br>
**exec {mujdesk}&lt; můj-soubor.txt**

*# otevřít soubor pro výstup (zápis či přepis) (obecně/příklad)*<br>
*// „Režim“ může být „&gt;“, „&gt;\|“, „&gt;&gt;“ nebo „&lt;&gt;“ s významem odpovídajícím přesměrování u číslovaného deskriptoru.*<br>
**exec \{**{*identifikator*}**\}&gt;** {*cesta/k/souboru*}<br>
**exec {mujdesk}&gt; můj-soubor.txt**

*# zavřít pojmenovaný deskriptor pro vstup/pro výstup*<br>
**exec \{**{*identifikator*}**\}&lt;&amp;-**<br>
**exec \{**{*identifikator*}**\}&gt;&amp;-**

*# příklad použití*<br>
**exec {mujd}&gt;&gt;můj-log.txt**<br>
**date "+%F %T" &gt;&amp;$mujd**<br>
**printf 'Skript spuštěn (deskriptor %d)\\n' "$mujd" &gt;&amp;$mujd**<br>
**exec {mujd}&gt;&amp;-**

### Spouštění příkazů a metapříkazy

*# spustit příkaz na pozadí*<br>
*// Za znakem „&amp;“ již nesmí následovat další oddělovač příkazů jako „;“, „&amp;&amp;“ nebo „\|\|“. Spuštění příkazu na pozadí nezmění návratový kód uložený v „$?“. PID nově spuštěného procesu bude přiřazeno do zvláštní proměnné „$!“.*<br>
{*příkaz s parametry nebo sestava s rourou*} **&amp;**

*# spustit příkazy v podprostředí*<br>
**(** {*příkazy*}... **)** [{*přesměrování pro podprostředí*}] <nic>[**&amp;**]



### Řízení běhu

*# cyklus „while“*<br>
*// Cyklus se opakuje, dokud testovací příkazy skončí úspěchem (s kódem 0).*<br>
**while** {*testovací-příkazy*}<br>
**do** {*příkazy; cyklu*}<br>
**done**

*# cyklus „foreach“*<br>
**for** {*identifikator\_promenne*} **in** {*parametry*}<br>
**do** {*příkazy; cyklu*}<br>
**done**

*# cyklus „for“*<br>
**for** {*identifikator\_promenne*} **in \{**{*počáteční-hodnota*}**..**{*poslední-hodnota*}**\}**<br>
**do** {*příkazy; cyklu*}<br>
**done**

*# skok za/před konec cyklu*<br>
**break** [{*o-kolik-úrovní*}]<br>
**continue** [{*o-kolik-úrovní*}]

*# podmínka if-else-if*<br>
**if** {*testovací-příkazy*}<br>
**then** {*příkazy větve*}<br>
[**elif** {*testovací-příkazy*}
**then** {*příkazy větve*}]...<br>
[**else** {*příkazy větve else*}]<br>
**fi**

*# větvení podle shody se vzorkem*<br>
*// Text je (po provedení rozvoje) testován proti jednomu vzorku za druhým. Je-li nalezen vzorek, se kterým se text shoduje, provedou se příkazy příslušné větve a zbytek vzorků se netestuje. Ukončovač větve „;;“ je možno umístit na konec příkazu nebo na samostatnou řádku. Tip: části vzorků můžete podle potřeby odzvláštnit běžnými způsoby (zpětným lomítkem, dvojitými uvozovkami apod.).*<br>
**case "**{*text*}**" in**<br>
<odsadit1>**(**{*vzorek*}[**\|**{*alternativní-vzorek*}]...**)** {*příkazy větve*}... **;;**<br>
<odsadit1>[**(**{*vzorek*}[**\|**{*alternativní-vzorek*}]...**)** {*příkazy větve*}... **;;**]...<br>
**esac**

*# cyklus s menu*<br>
*// Pokud není seznam „parametry“ prázdný, vypíše uživateli (na standardní chybový výstup) číslované menu, přečte od něj odpověď a text vybraného parametru uloží do proměnné. Uživatel může požádat o znovuvypsání menu stisknutím „Enter“ bez odpovědi. Zadá-li uživatel neplatnou odpověď, do proměnné se uloží prázdný řetězec. Cyklus se opakuje, dokud není seznam parametrů prázdný (ale je obvyklé ho přerušit příkazem „break“).*<br>
**select** {*identifikator\_promenne*} **in** {*parametry*}<br>
**do** {*příkazy; cyklu*}<br>
**done**

### Funkce

*# definovat funkci*<br>
**function** {*identifikator*} **\{**<br>
<odsadit1>{*příkazy funkce*}...<br>
**\}** [{*přesměrování pro funkci*}]

*# ukončit funkci s určitým návratovým kódem*<br>
**return** {*kód*}

*# deklarovat ve funkci lokální proměnné*<br>
**local** {*identifikator*}[**=**{*hodnota*}] <nic>[{*identifikator*}[**=**{*hodnota*}]]...

### Rozvoje na příkazové řádce

*# kartézský součin alternativ (obecně/příklad)*<br>
[{*předpona*}]**\{**{*alternativa1*}[**,**{*další-alternativa*}]...**\}**[{*přípona*}]<br>
?

*# sekvence celých čísel (obecně/příklad)*<br>
**\{**{*počáteční-hodnota*}**..**{*limit*}[**..**{*skok*}]**\}**<br>
?

*# dosadit standardní výstup bloku příkazů*<br>
*// Uvedené příkazy se spouštějí v podprostředí; návratová hodnota podprostředí je ignorována (neuloží se do $?). Pozor: jakkoliv dlouhá sekvence znaků „\\n“ na konci dosazovaného výstupu bude při dosazení vynechána.*<br>
**$(**{*příkazy*}**)**

*# dosadit výsledek celočíselného výrazu*<br>
**$((**{*výraz*}**))**

*# dosadit pojmenovanou rouru vedoucí na vstup/výstup bloku příkazů*<br>
**&gt;(**{*příkazy*}**)**<br>
**&lt;(**{*příkazy*}**)**

### Aktuální adresář

*# přejít do daného adresáře/na předchozí aktuální adresář*<br>
**cd** [**\-\-**] {*cesta*}<br>
**cd -**

*# zjistit aktuální adresář*<br>
**pwd** ⊨ /home/aneta

*# přejít do domovského adresáře*<br>
**cd**

*# přejít o úroveň výš*<br>
**cd ..**

*# přejít do kořenového adresáře*<br>
**cd /**

*# přejít do předchozího aktuálního adresáře dané instance interpretu*<br>
**cd -**



### Ostatní vestavěné příkazy

*# ignorovat parametry a uspět*<br>
**true** [{*libovolné parametry*}]

*# ignorovat parametry a selhat s kódem 1*<br>
**false** [{*libovolné parametry*}]

*# načíst příkazy ze souboru/ze standardního vstupu a vykonat je v této instanci interpretu*<br>
**source** [**\-\-**] {*cesta*}<br>
**source -**

*# vykonat příkazy v této instanci interpretu*<br>
**eval "**{*příkazy*}**"**

<!--
[ ] pokračovat příkazem „exec“
-->


### Testy souborů a adresářů: typ a existence

*Poznámka:* V bashi můžete všechny uvedené varianty příkazu „test“ nahradit konstrukcí [[ {*parametry*} ]], opačně to však neplatí. V interpretu „sh“ ho můžete nahradit konstrukcí „[ {*parametry*} ]“.

*# existuje položka adresáře?*<br>
**test -e** {*cesta*}

*# je to **soubor**?*<br>
**test -f "**{*cesta*}**"**

*# je to adresář?*<br>
**test -d "**{*cesta*}**"**

*# je to neprázdný soubor?*<br>
**test -s "**{*cesta*}**"**

*# je to symbolický odkaz?*<br>
**test -L "**{*cesta*}**"**

*# je to pojmenovaná roura?*<br>
**test -p "**{*cesta*}**"**

*# je to blokové zařízení/znakové zařízení/soket?*<br>
**test -b "**{*cesta*}**"**<br>
**test -c "**{*cesta*}**"**<br>
**test -S "**{*cesta*}**"**

### Testy souborů a adresářů: práva

*# můžeme ji/ho číst?*<br>
**test -r "**{*cesta*}**"**

*# můžeme do ní/něj zapisovat?*<br>
**test -w "**{*cesta*}**"**

*# můžeme ji/ho spouštět, resp. vstoupit do adresáře?*<br>
**test -x "**{*cesta*}**"**

*# má nastavený „sticky“/„set-user-id“ bit?*<br>
**test -k "**{*cesta*}**"**<br>
**test -u "**{*cesta*}**"**

### Testy souborů a adresářů: datum

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


### Ostatní testy

*# je proměnná definovaná? (jen bash)*<br>
**[[ -v** {*název\_proměnné*} **]]**

<!--
*# je proměnná jmenný odkaz na jinou proměnnou? (jen bash)*<br>
**[[ -R** {*název\_proměnné*} **]]**
-->

*# vede na terminál (popř. z terminálu) standardní výstup/standardní chybový výstup/deskriptor N*<br>
**test -t 1**<br>
**test -t 2**<br>
**test -t** {*N*}

*# znamenají dvě adresářové položky tutéž entitu?*<br>
*// Pokud některá z cest vede na symbolický odkaz, před provedením testu se nahradí odkazovanou položkou. Typicky se tento test používá k odhalení pevných odkazů, ale odpoví správně i ve speciálních situacích, kdy skutečnou adresářovou cestu nelze zjistit.*<br>
**test** {*cesta1*} **-ef** {*cesta2*}


## Testy řetězců

*# je řetězec neprázdný?*<br>
**test -n "**{*řetězec*}**"**

*# je řetězec prázdný?*<br>
**test -z "**{*řetězec*}**"**

*# jsou si dva řetězce po rozvoji rovny/liší se?*<br>
**test "**{*řetězec 1*}**" = "**{*řetězec 2*}**"**<br>
**test "**{*řetězec 1*}**" != "**{*řetězec 2*}**"**<br>

*# odpovídá hodnota proměnné regulárnímu výrazu? (bash/sh)*<br>
*// Název proměnné „regvyraz“ zde nemá žádný speciální význam, je zvolen jen pro přehlednost; můžete použít jakoukoliv proměnnou. Jednoduchý regulární výraz (takový, který neobsahuje mezery, uvozovky, zpětná lomítka ani hranaté závorky) můžete dokonce zadat přímo, pro zadání složitějšího výrazu je ale striktně doporučeno jej předem uložit do proměnné, protože pravidla odzvláštňování v tomto kontextu jsou složitá a neintuitivní.*<br>
**regvyraz='**{*regulární výraz*}**'**<br>
**[[ $**{*název\_proměnné*} **=~ $regvyraz ]]**<br>
{*název\_proměnné*}**=$**{*název\_proměnné*} **regvyraz='**{*regulární výraz*}**' bash -c '[[ $**{*název\_proměnné*} **=~ $regvyraz ]]'**

*# je pořadí řetězce v seřazeném seznamu menší/větší/shodné (jen bash)*<br>
**[[ "**{*řetězec 1*}**" &lt; "**{*řetězec 2*}**" ]]**<br>
**[[ "**{*řetězec 1*}**" &gt; "**{*řetězec 2*}**" ]]**<br>
**[[ !("**{*řetězec 1*}**" &lt; "**{*řetězec 2*}**" || "**{*řetězec 1*}**" &gt; "**{*řetězec 2*}**") ]]**

*# má hodnota proměnné alespoň N znaků?*<br>
**test ${#**{*název\_proměnné*}**\} -ge** {*N*}


## Testy čísel

*# =*<br>
**test** {*číslo1*} **-eq** {*číslo2*}

*# &lt;*<br>
**test** {*číslo1*} **-lt** {*číslo2*}

*# &gt;*<br>
**test** {*číslo1*} **-lt** {*číslo2*}

*# ≤*<br>
**test** {*číslo1*} **-le** {*číslo2*}

*# ≥*<br>
**test** {*číslo1*} **-ge** {*číslo2*}

*# ≠*<br>
**test** {*číslo1*} **-ne** {*číslo2*}

## Zaklínadla: Nastavení

### Vypisování příkazů (např. pro ladění)

*# vypisovat příkazy před vykonáním tak, jak byly zadány (zapnout/vypnout)*<br>
**set -v**<br>
**set +v**

*# vypisovat příkazy před vykonáním tak, jak budou vykonány (zapnout/vypnout)*<br>
**set -x**<br>
**set +x**

### Zapnout/vypnout rozvoje

*# provádět rozvoj historie (zapnout/vypnout)*<br>
**set -H**<br>
**set +H**

*# provádět rozvoj složených závorek {} (zapnout/vypnout)*<br>
**set -B**<br>
**set +B**

*# provádět rozvoj cest (zapnout/vypnout)*<br>
**set +f**<br>
**set -f**

*# provádět rozvoje ve výzvě bashe: zapnout (výchozí)/vypnout*<br>
**shopt -s promptvars**<br>
**shopt -u promptvars**

### Nastavení rozvoje cest a proměnných

*# velká a malá písmena při rozvoji cest: rozlišovat/nerozlišovat*<br>
**shopt -s nocaseglob**<br>
**shopt -u nocaseglob**

*# konstrukci „\*\*“ při rozvoji cest interpretovat jako libovolnou (i prázdnou) posloupnost adresářů (zapnout/vypnout)*<br>
**shopt -s globstar**<br>
**shopt -u globstar**

*# pokud vzorek při rozvoji cest neodpovídá žádné cestě: selhat s chybou/předat vzorek tak, jak je (výchozí chování)/předat prázdný řetězec*<br>
**shopt -s failglob**<br>
**shopt -u failglob nullglob**<br>
**shopt -s nullglob; shopt -u failglob**

*# rozvoj neexistující proměnné: považovat za kritickou chybu/tiše ignorovat*<br>
**set -u**<br>
**set +u**

*# rozsahy ve vzorcích při rozvoji cest (např. „[A-Z]“) intepretovat: podle locale „C“/podle aktuálního locale*<br>
**shopt -s globasciiranges**<br>
**shopt -u globasciiranges**

*# zahnout do rozvoje cest i skryté soubory a adresáře (zapnout/vypnout)*<br>
**shopt -s dotglob**<br>
**shopt -u dotglob**

### Zpracování návratových kódů

*# návratový kód vícenásobné roury se vezme: z prvního příkazu, který selhal/vždy z posledního příkazu roury*<br>
**set -o pipefail**<br>
**set +o pipefail**

*# při chybě ukončit interpret (zapnout/vypnout)*<br>
**set -e**<br>
**set +e**

*# v případě selhání příkazu „exec“ v neinteraktivním režimu: pokračovat ve skriptu/skončit*<br>
**shopt -s execfail**<br>
**shopt -u execfail**

*# uplatnit ukončení při chybě i na příkazy uvnitř substituce $() (zapnout/vypnout)*<br>
**shopt -s inherit\_errexit**<br>
**shopt -u inherit\_errexit**

### Historie

*# nastavit maximální počet příkazů uložených v historii v paměti/na disku*<br>
**HISTSIZE=**{*počet*}<br>
**HISTFILESIZE=**{*počet*}

*# byl-li v interaktivním režimu proveden rozvoj historie, příkaz: vrátit na příkazovou řádku ke kontrole či úpravě/okamžitě provést*<br>
**shopt -s histverify**<br>
**shopt -u histverify**

*# vypnout historii příkazů*<br>
**set +o history**<br>
**history -c**

*# zapnout historii příkazů*<br>
**set -o history**

*# víceřádkové příkazy ukládat do historie: najednou/po řádcích*<br>
**shopt -s cmdhist**<br>
**shopt -u cmdhist**

*# ukládání historie při ukončení bashe: připojit na konec/přepsat*<br>
**shopt -s histappend**<br>
**shopt -u histappend**

*# nastavit způsob ukládání řádek do historie (obecně/příklad)*<br>
*// Rozeznávané volby jsou: „ignorespace“ (neukládat řádky začínající bílým znakem), „ignoredups“ (neukládat stejný řádek znovu) a „erasedups“ (před uložením řádky smazat všechny stejné řádky z celé historie – pozor, tato volba mění pořadová čísla řádek v historii). Volba „ignoreboth“ (což je v Ubuntu výchozí chování) je synonymum pro „ignorespace:ignoredups“.*<br>
**HISTCONTROL="**[{*volba*}[**:**{*další-volba*}]...]**"**<br>
**HISTCONTROL="ignorespace:erasedups"**

*# nastavit, kam se ukládá historie (obecně/příklad)*<br>
**HISTFILE="**{*/absolutní/cesta-k-souboru*}**"**<br>
**HISTFILE="/home/aneta/.bash\_history"**

*# neukládat do historie příkazy začínající určitými řetězci/obsahující určité řetězce na první řádce*<br>
*// Poznámka: řetězce jsou zde ve skutečnosti vzorky, takže se vyvarujte jakýchkoliv zvláštních znaků, nebo si nastudujte v manuálové stránce bashe, jak proměnná HISTIGNORE ve skutečnosti funguje.*<br>
**HISTIGNORE="**{*řetězec*}**\***[**:**{*další řetězec*}**\***]...**"**<br>
**HISTIGNORE="\***{*řetězec*}**\***[**:\***{*další řetězec*}**\***]...**"**

*# ručně přidat do historie příkaz*<br>
**history -s '**{*příkaz s parametry*}**'**

*# smazat z historie poslední příkaz*<br>
?

### Ostatní

*# symbolické odkazy v cestě k aktuálnímu adresáři: jednorázově rozvinout/pamatovat si*<br>
**set -P**<br>
**set +P**

*# kontrolovat velikost okna a aktualizovat zvláštní proměnné COLUMNS a LINES (zapnout/vypnout)*<br>
**shopt -s checkwinsize**<br>
**shopt -u checkwinsize**

*# snažit se opravit překlepy v parametru příkazu „cd“ (zapnout/vypnout)*<br>
**shopt -s cdspell**<br>
**shopt -u cdspell**

*# aliasy: používat/ignorovat*<br>
**shopt -s expand\_aliases**<br>
**shopt -u expand\_aliases**

*# nerozlišovat velká a malá písmena ve většině kontextů (zapnout/vypnout)*<br>
**shopt -s nocasematch**<br>
**shopt -u nocasematch**

*# příkazy „.“ a „source“ budou při hledání svého argumentu prohledávat také cesty v proměnné PATH (zapnout/vypnout)*<br>
**shopt -s sourcepath**<br>
**shopt -u sourcepath**

*# příkaz „echo“ bez parametrů „-e“ a „-E“ sekvence se zpětným lomítkem: interpretuje/neinterpretuje*<br>
**shopt -s xpkg\_echo**<br>
**shopt -u xpkg\_echo**

*# při každém vytvoření či přiřazení proměnné či funkce z ní učinit proměnnou prostředí (zapnout/vypnout)*<br>
**set -a**<br>
**set +a**

*# řízení úloh příkazy „fg“ a „bg“ a zkratkou Ctrl+Z (zapnout/vypnout)*<br>
**set -m**<br>
**set +m**

*# už nenačítat další řádek příkazů; po vykonání příkazů z této řádky skončit (zapnout/vypnout)*<br>
**set -t**<br>
**set +t**

*# přepsání existujícího souboru obyčejným přesměrováním výstupu (zakázat/povolit)*<br>
**set -C**<br>
**set +C**

*# pokud není argument příkazu cd nalezen jako adresář, zkusit dereferencovat proměnnou téhož názvu (zapnout/vypnout)*<br>
**shopt -s cdable\_vars**<br>
**shopt -u cdable\_vars**

<!--
*# nastavit poziční parametry bashe*<br>
**set \-\-** [{*parametr*}]...
-->

## Zaklínadla: Interaktivní ovládání

*# zopakovat poslední příkaz*<br>
{_↑_}<br>
{_Enter_}

*# vyhledávat v historii*<br>
{_Ctrl_}**+**{_R_}<br>
!: Zadat vyhledávaný podřetězec. Další ovládání: {_Enter_}, {_Esc_}, {_↑_}, {_↓_}.

*# vyjmout text od začátku řádku/slova před aktuální znak*<br>
{_Ctrl_}**+**{_U_}<br>
{_Ctrl_}**+**{_W_}

*# vyjmout text od aktuálního znaku do konce řádky/slova*<br>
{_Ctrl_}**+**{_K_}<br>
{_Alt_}**+**{_K_}

*# vložit naposledy vyjmutý text*<br>
{_Ctrl_}**+**{_Y_}

*# smazat terminál (ponechat aktuální řádku)*<br>
{_Ctrl_}**+**{_L_}

*# pozastavit výpis na terminál/pokračovat*<br>
*// Tyto klávesové zkratky lze (velmi výhodně) použít i tehdy, když bash není na popředí!*<br>
{_Ctrl_}**+**{_S_}<br>
{_Ctrl_}**+**{_Q_}

*# posun terminálu o stránku nahoru/dolu*<br>
{_Shift_}**+**{_PageUp_}<br>
{_Shift_}**+**{_PageDown_}

*# vložit na příkazovou řádku tabulátor*<br>
{_Ctrl_}**+**{_V_}<br>
{_Tab_}

*# otevřít zadávaný příkaz v editoru jako skript a po uzavření editoru vykonat*<br>
{_Ctrl_}**+**{_X_}<br>
{_Ctrl_}**+**{_E_}

*# vrátit řádek načtený z historie do původního stavu*<br>
{_Alt_}**+**{_R_}

*# vložit poslední slovo z poslední řádky v historii*<br>
*// Opakovaným stiskem lze vložit poslední slovo z předposlední řádky, před-předposlední atd.*<br>
{_Alt_}**+**{_._}

## Zaklínadla: Automatické doplňování

### Základní příkazy
*# nastavit doplňování pro příkaz*<br>
**complete** {*nastavení*} {*příkaz*}...

*# vypsat možná doplnění podle nastavení*<br>
**compgen** {*nastavení*} [**\-\-** {*doplňované-slovo*}]

### Nastavení (complete/compgen)

*# doplňovat názvy **souborů** a adresářů/jen adresářů*<br>
**-A file**<br>
**-A directory**

*# doplňovat konkrétní slova*<br>
**-W "**{*slovo*} [{*další-slovo*}]...**"**

*# použit uživatelskou řídicí funkci*<br>
*// Řídicí funkce dostane tři parametry: $1 bude název doplňovaného příkazu, $2 doplňované slovo a $3 přechozí slovo. Může také využít pole*<br>
**-F** {*funkce*}

*# doplňovat názvy **příkazů** (všech druhů)*<br>
**-A command**

*# doplňovat názvy **signálů** (např. „SIGKILL“)*<br>
**-A signal**

*# doplňovat jména **uživatelů**/skupin uživatelů*<br>
**-A user**<br>
**-A group**

*# doplňovat názvy **vestavěných příkazů** (jen zapnutých/všech/jen vypnutých)*<br>
**-A enabled**<br>
**-A builtin**<br>
**-A disabled**

*# doplňovat názvy **proměnných** interpretu a prostředí/jen proměnných prostředí/jen polí interpretu*<br>
**-A variable**<br>
**-A export**<br>
**-A arrayvar**

*# doplňovat názvy **definovaných funkcí***<br>
**-A function**

*# doplňovat názvy **aliasů***<br>
**-A alias**

*# doplňovat známé názvy počítačů v síti (např. „localhost“)*<br>
**-A hostname**

<!--
https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#Programmable-Completion-Builtins
-->

### Vstupní údaje (jen v řídicí funkci doplňování)

*# zjistit doplňované slovo*<br>
**$2**

*# zjistit předcházející slovo*<br>
**$3**

*# zjistit název doplňovaného příkazu*<br>
**$1**

*# nastavit jako odpověď sekvenci slov*<br>
**COMPREPLY=($(compgen -W "**{*slovo*} [{*další slovo*}]...**"** [**-P** {*dodatečná-předpona*}] <nic>[**-S** {*dodatečná-přípona*}] **\-\- "**{*doplňované-slovo*}**"))**

*# nastavit prázdnou odpověď*<br>
**COMPREPLY=()**

*# přidat další možná slova*<br>
**COMPREPLY+=(**[{*slovo*}]...**)**

*# index doplňovaného parametru*<br>
*// 1 pro první parametr, 2 pro druhý parametr atd.*<br>
**$COMP\_CWORD**

*# zjistit obsah konkrétního parametru doplňovaného příkazového řádku*<br>
**$COMP\_WORDS[**{*index*}**]**

*# celá doplňovaná příkazová řádka*<br>
**$COMP\_LINE**

## Zaklínadla: Ostatní

*# běží bash v interaktivním režimu?*<br>
**[[ $- == \*i\* ]]**

*# běží bash v režimu „login-shell“?*<br>
?

## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

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

### Rozvoj složených závorek

Pokud parametr příkazového řádku obsahuje slova uvnitř složených závorek oddělených čárkami, ... (DOPSAT)


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
