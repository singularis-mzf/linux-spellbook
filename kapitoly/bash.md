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
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

GNU Bash je výchozí interpret příkazového řádku v Ubuntu (a většině dalších
linuxů). Tato kapitola se zabývá jeho funkcemi, které nejsou pokryty
v jiných kapitolách, zejména ovládáním vstupů a výstupů spouštěných příkazů,
interaktivním ovládáním a příkazy potřebnými k psaní skriptů a funkcí.

## Definice

* **Deskriptor** je (samostatně pro každý proces v systému) číslovaný vstup nebo výstup. Základní deskriptory jsou „**standardní vstup**“ (číslo 0, „stdin“, budu zkracovat jako „std. vstup“), „**standardní výstup**“ (číslo 1, „stdout“, budu zkracovat jako „std. výstup“) a „**standardní chybový výstup**“ (číslo 2, „stderr“, budu zkracovat jako „std. ch. výstup“). Deskriptory 3 až 9 jsou určeny pro užití uživatelem; deskriptory 10 až 255 pro vnitřní použití interpretem.
* **Návratový kód** (exit status) je celočíselný kód (0 až 255) vracený každým příkazem (s výjimkou přiřazení do proměnné či definice funkce), který indikuje, zda příkaz ve své činnosti uspěl (0) nebo ne (1 až 255).
* **Podprostředí** (subshell) je oddělené prostředí pro vykonávání příkazů. Příkazy v podprostředí získají kopii všech proměnných (tzn. nejen exportovaných), deskriptorů a nastavení interpretu, ale změny, které v nich provedou, nemají účinek mimo podprostředí. Podprostředí má jako celek svůj návratový kód a jako na celek na něj mohou být aplikována přesměrování. Bash pro vykonání podprostředí může, ale nemusí vytvořit nový proces.
* **Skript** je textový soubor obsahující posloupnost příkazů pro Bash tak, jak by je uživatel mohl zadat příkazovému interpretu přímo (s drobnými odchylkami způsobenými odlišným výchozím nastavením skriptů oproti interaktivnímu režimu). Hlavním účelem skriptu je automatizace úkolů, které by jinak uživatel prováděl zadáváním příkazů do terminálu. Pro vykonání skriptu se spustí nová instance interpretu, kromě případu, kdy byl skript vyvolán příkazem „source“.
* **Funkce** je v podstatě skript uložený v paměti interpretu (jako proměnná). Na rozdíl od skriptu se funkce normálně vykoná v téže instanci, odkud je volaná, proto je možno ji využít např. k nastavování proměnných.
* **Alias** je nastavení, které instruuje interpret v interaktivním režimu nahradit při čtení příkazové řádky určitý název příkazu určitým textem (text náhrady obvykle obsahuje název příkazu a nějaké parametry).
* **Překryvná proměnná** je dočasná proměnná ve funkci, která existuje jen do ukončení funkce a po tuto dobu je schopna překrýt dříve existující (globální nebo překryvnou) proměnnou stejného jména. Překryvné proměnné nejsou lokální — po dobu své existence jsou bez jakékoliv kvalifikace dostupné z celého skriptu, a dokonce mohou být exportovány (jako proměnné prostředí).

!ÚzkýRežim: vyp

## Zaklínadla: Vstup, výstup a roury

### Roura

*# přesměrovat std. výstup/std. výstup a std. ch. výstup příkazu A na std. vstup příkazu B*<br>
{*příkaz-A včetně přesměrování*} [**\|** {*příkaz-B včetně přesměrování*}]...<br>
{*příkaz-A včetně přesměrování*} [**\|&amp;** {*příkaz-B včetně přesměrování*}]...

### Přesměrování vstupu (čtení odněkud)

*# čtení z existujícího **souboru***<br>
[{*deskriptor*}]**&lt;** {*cesta*}

*# čtení ze zadaného **textu** + znak konce řádky „\\n“ (obecně/příklady)*<br>
*// Poznámka: znak „\\n“ bude na konec přidán i v případě, že už jím zadaný text končí.*<br>
[{*deskriptor*}]**&lt;&lt;&lt;** {*parametr*}<br>
**sort &lt;&lt;&lt; $'zoo\\nahoj\\nseminář'**<br>
**sort &lt;&lt;&lt; "A$(echo BC)D"**

*# čtení z **prázdného** vstupu*<br>
[{*deskriptor*}]**&lt; /dev/null**

*# čtení ze std. výstupu bloku **příkazů** (obecně/příklad)*<br>
[{*deskriptor*}]**&lt;&blank;&lt;(**{*příkazy...*}**)**<br>
**sort &lt;(echo Zoo; echo Abeceda)**

*# zduplikovat/přečíslovat deskriptor pro čtení*<br>
*// Zduplikování deskriptoru čtoucího ze souboru není totéž jako dvojité otevření téhož souboru; duplikáty téhož deskriptoru totiž sdílí stejnou pozici, takže čtením z jednoho se posouvá i pozice pro čtení z ostatních. Naproti tomu při otevření téhož souboru na dva různé deskriptory bude každý z nich mít samostatnou pozici čtení, která nebude ovlivňována čtením z toho druhého.*<br>
[{*cílový-deskriptor*}]**&lt;&amp;**{*zdrojový-deskriptor*}<br>
[{*cílový-deskriptor*}]**&gt;&amp;**{*zdrojový-deskriptor*}**-**

*# zduplikovat **pojmenovaný deskriptor** pro čtení*<br>
{*příkaz a parametry*} [{*cílový-deskriptor*}]**&lt;&amp;$**{*identifikator-pojm-desk*}

*# čtení z **bloku řádek***<br>
*// Zadaný ukončovač musí být neprázdný řetězec. Bash na přesměrovávaný vstup zapíše všechny řádky počínaje první řádkou po aktuálním příkazu a konče poslední řádkou, která se přesně neshoduje s ukončovačem (musí odpovídat i odsazení).*<br>
[{*deskriptor*}]**&lt;&lt; '**{*ukončovač*}**'**<br>
{*řádky textu*}<br>
{*ukončovač*}

*# **zavřít** deskriptor*<br>
{*deskriptor*}**&lt;&amp;-**

*# čtení z bloku řádek po rozvoji*<br>
*// Pozor! Při použití tohoto zaklínadla nesmí být žádný znak v identifikátoru odzvláštněn (tzn. používejte jen znaky, které pro Bash nemají zvláštní význam). Bash na přesměrovávaný vstup zapíše všechny řádky počínaje první řádkou po aktuálním příkazu a konče poslední řádkou, která se přesně neshoduje se zadaným identifikátorem (shoda musí být přesná, ani bílé znaky na začátku či konci nejsou dovoleny). Před použitím Bash celý blok řádek intepretuje, přičemž za zvláštní považuje znaky „$“, „\\“ a „\`“ (s výjimkou apostrofů s dolarem, ty tam přímo použít nelze), můžete tam tedy dosazovat hodnoty proměnných a výstupy příkazů.*<br>
[{*deskriptor*}]**&lt;&lt;-** {*identifikátor*}

### Přesměrování výstupu (zápis někam)

*# zápis do souboru; existuje-li: zkrátit na prázdný/připojit za konec*<br>
*// Znak „\|“ má význam pouze v případě, že máte nastavenou volbu „noclobber“. V takovém případě umožní přepsání existujícího souboru.*<br>
[{*deskriptor*}]**&gt;**[**\|**] {*cesta*}<br>
[{*deskriptor*}]**&gt;&gt;** {*cesta*}

*# zápis **nikam***<br>
[{*deskriptor*}]**&gt; /dev/null**

*# zápis na std. vstup bloku příkazů (obecně/příklad)*<br>
[{*deskriptor*}]**&gt;&blank;&gt;(**{*příkaz*}...**)**<br>
**df -h &gt;&blank;&gt;(sed -u 1q; sort)**

*# zduplikovat/přečíslovat deskriptor pro zápis*<br>
[{*cílový-deskriptor*}]**&gt;&amp;**{*zdrojový-deskriptor*}<br>
[{*cílový-deskriptor*}]**&gt;&amp;**{*zdrojový-deskriptor*}**-**

*# zduplikovat **pojmenovaný deskriptor** pro zápis*<br>
{*příkaz a parametry*} [{*cílový-deskriptor*}]**&gt;&amp;$**{*identifikator-pojm-desk*}

*# **zavřít** deskriptor*<br>
{*deskriptor*}**&gt;&amp;-**

*# **přepis** souboru (čtení i zápis, bez zkrácení) (obecně/příklad příkazu)*<br>
*// Vyžaduje právo soubor číst i do něj zapisovat; neexistující soubor bude vytvořen, existující soubor nebude zkrácen a zápis začne bajt po bajtu přepisovat jeho obsah od začátku souboru.*<br>
{*cílový-deskriptor*}**&lt;&gt;**{*cesta*}<br>
**echo ABC 2&gt;&amp;1 1&lt;&gt; můj-soubor.txt**

### Obvyklé duplikace deskriptorů

*# std. ch. výstup nasměrovat na std. výstup (alternativy)*<br>
**2&gt;&amp;1**<br>
**2&gt;/dev/stdout**

*# std. výstup nasměrovat na std. ch. výstup (alternativy)*<br>
**&gt;&amp;/dev/stderr**<br>
**&gt;&amp;2**

*# std. výstup a std. chyb. výstup připojit za konec souboru (pokud neexistuje, vytvořit prázdný)(alternativy)*<br>
**&gt;&gt;** {*cesta*} **2&gt;&amp;1**<br>
**&amp;&gt;&gt;** {*cesta*}

### Pojmenované deskriptory

*# **otevřít** (obecně/příklad)*<br>
*// „Režim“ může být pro čtení „&lt;“, pro zápis „&gt;“, „&gt;\|“, „&gt;&gt;“ a pro přepis „&lt;&gt;“ s významem jako u odpovídajícího přesměrování.*<br>
**exec \{**{*identifikator*}**\}**{*režim*} {*cesta/k/souboru*}<br>
**exec {mujdesk}&lt; můj-soubor.txt**

*# **zavřít** pro vstup/pro výstup/pro přepis*<br>
**exec \{**{*identifikator*}**\}&lt;&amp;-**<br>
**exec \{**{*identifikator*}**\}&gt;&amp;-**<br>
**exec \{**{*identifikator*}**\}&lt;&amp;- \{**{*identifikator*}**\}&gt;&amp;-**

*# příklad použití*<br>
**exec {mujd}&gt;&gt;můj-log.txt**<br>
**date "+%F %T" &gt;&amp;$mujd**<br>
**printf 'Skript spuštěn (deskriptor %d)\\n' "$mujd" &gt;&amp;$mujd**<br>
**exec {mujd}&gt;&amp;-**

### Ostatní

*# aplikovat přesměrování permanentně (na všechny následující příkazy)*<br>
**exec** {*přesměrování*}

*# načíst od uživatele **heslo***<br>
*// Parametr „-s“ potlačí výstup psaných znaků na terminál.*<br>
[**if**] **IFS= read -rs** [**-p** {*"Text výzvy:"*}] {*promenna*} **&amp;&amp; echo** [**then** {*...*} **fi**]

### Načíst jeden záznam do jedné proměnné

Poznámka: vyskytnou-li se ve vstupu bajty \\0, příkaz „read“ je tiše ignoruje.

*# oddělovač je \\n*<br>
[**if**] **IFS= read -r**[**u** {*deskriptor*}] {*promenna*} [**then** {*...*} **fi**]

*# načíst N znaků*<br>
[**if**] **IFS= read -r**[**u** {*deskriptor*}] **-N** {*N*} {*promenna*} [**then** {*...*} **fi**]

*# oddělovač je \\0*<br>
?
<!-- [{*zdroj*} **\|**] **readarray -td '' -n 1** [**-u** {*deskriptor*}] **&amp;&amp;** {*promenna*}**=${MAPFILE[0]} -->

*# oddělovač je znak*<br>
[**if**] **IFS= read -r**[**u** {*deskriptor*}] **-d** {*"oddělovač"*} [**then** {*...*} **fi**]

### Načíst vše do indexovaného pole

*# oddělovač je \\n*<br>
{*zdroj*} **\| readarray -t**[**u** {*deskriptor*}] <nic>[**-s** {*kolik-zázn-přeskočit*}] <nic>[**-n** {*kolik-zázn-max-přečíst*}] {*identifikator\_pro\_pole*}

*# oddělovač je \\0*<br>
{*zdroj*} **\| readarray -t**[**u** {*deskriptor*}] **-d ''** <nic>[**-s** {*kolik-zázn-přeskočit*}] <nic>[**-n** {*kolik-zázn-max-přečíst*}] {*identifikator\_pro\_pole*}

*# oddělovač je ASCII znak*<br>
{*zdroj*} **\| readarray -td** {*"znak"*} [**-u** {*deskriptor*}] <nic>[**-s** {*kolik-zázn-přeskočit*}] <nic>[**-n** {*kolik-zázn-max-přečíst*}] {*identifikator\_pro\_pole*}

*# zapsat do existujícího pole (obecně/příklad)*<br>
{*příkaz readarray s parametry*} **-O** {*počáteční-index*}<br>
**readarray -t pole &lt; &lt;(echo A); readarray -t -O 1 pole &lt; &lt;(echo B)**

### Vypsat text

*# formátovaný výstup*<br>
**printf** [**\-\-**] {*'formátovací řetězec'*} [{*parametry*}]... [{*přesměrování*}]

*# výstup textu*<br>
**printf %s**[**\\\\n**] {*"Text"*} [{*přesměrování*}]

### Testy

*# vede na terminál (popř. z terminálu) std. výstup/std. ch. výstup/deskriptor N*<br>
**test -t 1**<br>
**test -t 2**<br>
**test -t** {*N*}

## Ostatní

### Aktuální adresář

*# přejít o úroveň výš*<br>
**cd ..**

*# přejít do daného adresáře/předchozího aktuálního adresáře*<br>
**cd** [**\-\-**] {*cesta*}<br>
**cd -**

*# přejít do domovského adresáře*<br>
**cd**

*# zjistit aktuální adresář*<br>
**pwd** ⊨ /home/aneta

### Spouštění příkazů a metapříkazy

*# spustit příkaz na pozadí*<br>
*// Spuštění příkazu na pozadí nezmění „$?“ PID spuštěného procesu můžete přečíst ze zvláštní proměnné „$!“. Bezprostředně za znakem „&amp;“ nesmí následovat další oddělovač příkazů jako „;“, „&amp;&amp;“ nebo „\|\|“.*<br>
{*příkaz s parametry nebo sestava s rourou*} **&amp;** [{*promenna*}**=$!**]

*# spustit příkazy v **podprostředí***<br>
**(** {*příkazy*}... **)** [{*přesměrování pro podprostředí*}] <nic>[**&amp;** [{*promenna*}**=$!**]]

*# aplikovat přesměrování na skupinu příkazů*<br>
*// Složené závorky můžete umístit i na stejnou řádku jako příkazy uvnitř, ale v takovém případě je musíte oddělit mezerami a poslední příkaz musí být ukončen operátorem „;“ nebo „&amp;“! Proto doporučuji raději oddělovat složené závorky od příkazů koncem řádku.*<br>
**\{**<br>
<odsadit1>{*příkazy*}...<br>
**\}** {*přesměrování*}

### Řetězení příkazů

*# vykonat příkaz-A a po něm příkaz B*<br>
{*příkaz A*}**;** {*příkaz B*}

*# vykonat příkaz-A, a pokud skončil úspěšně ($? = 0), vykonat příkaz B*<br>
{*příkaz A*} **&amp;&amp;** {*příkaz B*}

*# vykonat příkaz-A, a pokud skončil neúspěšně ($? ≠ 0), vykonat příkaz B*<br>
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

*# cyklus s menu*<br>
*// Pokud není seznam „parametry“ prázdný, vypíše uživateli (na standardní chybový výstup) číslované menu, přečte od něj odpověď a text vybraného parametru uloží do proměnné. Uživatel může požádat o znovuvypsání menu stisknutím „Enter“ bez odpovědi. Zadá-li uživatel neplatnou odpověď, do proměnné se uloží prázdný řetězec. Cyklus se opakuje, dokud není seznam parametrů prázdný (ale je obvyklé ho přerušit příkazem „break“).*<br>
**select** {*identifikator\_promenne*} **in** {*parametry*}<br>
**do** {*příkazy; cyklu*}<br>
**done** [{*přesměrování*}]

*# ukončit interpret*<br>
**exit** [{*návratový-kód*}]

### Funkce

*# definovat funkci*<br>
**function** {*identifikator*} **\{**<br>
<odsadit1>{*příkazy funkce*}...<br>
**\}** [{*přesměrování pro funkci*}]

*# ukončit funkci s určitým návratovým kódem/s návratovým kódem $?*<br>
**return** {*kód*}<br>
**return**

*# vytvořit ve funkci **překryvnou proměnnou***<br>
**local** {*identifikator*}[**=**{*hodnota*}] <nic>[{*identifikator*}[**=**{*hodnota*}]]...

*# uvnitř funkce ve skriptu vypsat „**stack-trace**“ (jen volání této funkce/všechny úrovně)*<br>
**caller 1**<br>
**(i=0; while caller $((i++)); do true; done)**

*# úroveň zanoření funkce (proměnná)*<br>
**$FUNCNEST**

### Rozvoje na příkazové řádce

*# **kartézský součin** alternativ (obecně/příklad)*<br>
*// Viz podrobnější vysvětlení v podsekci „Kartézský součin“.*<br>
[{*předpona*}]**\{**{*alternativa1*}**,**{*alternativa2*}[**,**{*další-alternativa*}]...**\}**[{*přípona*}]<br>
**\\"{Nazdar,ahoj}\\&blank;{světe,'dva&blank;světy'}\\"** ⊨ "Nazdar světe" "Nazdar dva světy" "ahoj světe" "ahoj dva světy"

*# **sekvence** celých čísel (obecně/příklady)*<br>
*// Výchozí skok je 1, resp. -1; nové parametry se generují, dokud je vygenerovaná hodnota ≤ (pro záporný skok ≥) zadanému „limitu“. Pokud se počáteční hodnota a limit rovnají, výsledkem bude jedno číslo (tzn. jeden parametr).*<br>
**\{**{*počáteční-hodnota*}**..**{*limit*}[**..**{*skok*}]**\}**<br>
**{-5..3}** ⊨ -5 -4 -3 -2 -1 0 1 2 3<br>
**{1..-1}** ⊨ 1 0 -1<br>
**{3..7..3}** ⊨ 3 6<br>
**{3..7..2}** ⊨ 3 5 7

*# dosadit standardní výstup bloku příkazů*<br>
*// Uvedené příkazy se spouštějí v podprostředí; návratová hodnota podprostředí je ignorována (neuloží se do $? a neovlivní proměnnou PIPESTATUS). Pozor: jakkoliv dlouhá sekvence znaků „\\n“ na konci dosazovaného výstupu bude při dosazení vynechána!*<br>
**$(**{*příkazy*}**)**

*# dosadit výsledek celočíselného výrazu*<br>
**$((**{*výraz*}**))**

*# dosadit **pojmenovanou rouru** vedoucí na vstup/výstup bloku příkazů*<br>
**&gt;(**{*příkazy*}**)**<br>
**&lt;(**{*příkazy*}**)**

*# dosadit jako parametry cesty neskrytých souborů a adresářů podle vzorků*<br>
*// Vzorkem se rozumí parametr, který obsahuje jako zvláštní znak „?“, „\*“ nebo konstrukci „[]“ tvořící syntakticky platný vzorek bashe. Skryté soubory a adresáře jsou normálně ignorovány, pokud vzorek pro odpovídající část cesty nezačíná tečkou. Výsledný seznam parametrů se seřadí podle abecedy podle aktuální lokalizace.*<br>
[{*název-nebo-vzorek*}**/**]...{*vzorek*}[**/**{*název-nebo-vzorek*}]...

### Zvláštní proměnné

*# **návratová hodnota** posledního vykonaného příkazu*<br>
*// Tato hodnota může být negována metapříkazem „!“, viz kapitolu Metapříkazy.*<br>
**$?**

*# pole návratových hodnot příkazů z poslední vykonané roury*<br>
*// Poznámka: jednotlivý příkaz se považuje za rouru tvořenou jedním příkazem, proto jeho vykonání toto pole přepíše také.*<br>
**${PIPESTATUS[**{*index*}**]}**

*# **náhodné** číslo v rozsahu 0 až 255/32767/65535/2147483647/4294967295*<br>
**$((RANDOM &amp; 255))**<br>
**$RANDOM**<br>
**$((RANDOM &lt;&lt; 1 \| RANDOM &amp; 1))**<br>
**$((RANDOM &lt;&lt; 16 \| RANDOM &lt;&lt; 1 \| RANDOM &amp; 1))**<br>
**$((RANDOM &lt;&lt; 17 \| RANDOM &lt;&lt; 2 \| RANDOM &amp; 3))**

*# text **posledního parametru** posledního jednoduchého příkazu vykonaného na popředí*<br>
**$\_**

*# **PID**/PPID probíhajícího interpretu*<br>
**\$\$**<br>
**$PPID**

*# aktuální počet sloupců/řádek terminálu*<br>
**$COLUMNS** ⊨ 80<br>
**$LINES** ⊨ 25

*# **počet sekund** od startu této instance interpretu*<br>
**$SECONDS** ⊨ 7051

*# počet sekund od 1. 1. 1970 00:00:00 UTC (celé číslo/desetinné číslo s přesností na mikrosekundy)*<br>
*// Pozor na skutečnost, že formát čísla u proměnné „EPOCHREALTIME“ závisí na nastaveném národním prostředí. K získání zpracovatelného formátu lze použít podprostředí s nastavením „LC\_ALL=C“.*<br>
**$EPOCHSECONDS** ⊨ 1620459769<br>
**$EPOCHREALTIME** ⊨ 1620459769,984485

*# číslo řádky (ve skriptu)*<br>
*// Jde o číslo řádky, na které se nachází první znak jednotlivého příkazu; pokud příkaz pokračuje přes několik řádek, hodnota proměnné LINENO je na všech těchto řádkách jednotná.*<br>
**$LINENO** ⊨ 137

*# verze Bashe (hlavní/vedlejší číslo)*<br>
**${BASH\_VERSINFO[0]}** ⊨ 5<br>
**${BASH\_VERSINFO[1]}** ⊨ 0

### Ostatní vestavěné příkazy

*# vyhodnotit celočíselný výraz (kvůli vedlejším efektům)(obecně/příklad)*<br>
**true $((**{*celočíselný výraz*}**))**<br>
**true $((++i))**

*# ignorovat parametry a uspět*<br>
**true** [{*libovolné parametry*}]

*# ignorovat parametry a selhat s kódem 1*<br>
**false** [{*libovolné parametry*}]

*# vykonat příkazy v této instanci interpretu*<br>
**eval "**{*příkazy*}**"**

*# spuštěným příkazem nahradit tuto instanci interpretu*<br>
**exec** {*příkaz a parametry*}

*# načíst příkazy ze souboru/ze standardního vstupu a vykonat je v této instanci interpretu*<br>
**source** [**\-\-**] {*cesta*}<br>
**source -**

*# vypsat nápovědu pro vestavěný příkaz/všechny vestavěné příkazy*<br>
**help** [**-m**] {*příkaz*}<br>
**help** [**-m**] **"\*"**

*# vypsat typ příkazu*<br>
**type** [**-t**] {*příkaz*}

*# vyprázdnit keš cest k programům*<br>
**hash -r**

























## Testy

### Typ a existence adresářových položek

*Poznámka:* V Bashi můžete všechny uvedené varianty příkazu „test“ nahradit konstrukcí \[\[ {*parametry*} \]\], opačně to však neplatí. V interpretu „sh“ ho můžete nahradit konstrukcí „[ {*parametry*} ]“.

*Poznámka 2:* Příkaz „test“ s výjimkou volby „-L“ následuje symbolické odkazy; pro vyloučení symbolických odkazů přidejte negovanou volbu „-L“.

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

### Testy řetězců

*# je řetězec **neprázdný**/prázdný?*<br>
**test -n "**{*řetězec*}**"**<br>
**test -z "**{*řetězec*}**"**

*# jsou si dva řetězce rovny/liší se?*<br>
**test "**{*řetězec 1*}**" = "**{*řetězec 2*}**"**<br>
**test "**{*řetězec 1*}**" != "**{*řetězec 2*}**"**

*# shoduje se text proměnné se **vzorkem** Bashe? (obecně/příklad)*<br>
**[[ $**{*název\_proměnné*} **=** {*vzorek*} **]]**<br>
**[[ $data = "Ahoj, "\*'!' ]]**

*# je pořadí řetězce v seřazeném seznamu menší/větší/shodné*<br>
**[[ "**{*řetězec 1*}**" &lt; "**{*řetězec 2*}**" ]]**<br>
**[[ "**{*řetězec 1*}**" &gt; "**{*řetězec 2*}**" ]]**<br>
**[[ !("**{*řetězec 1*}**" &lt; "**{*řetězec 2*}**" || "**{*řetězec 1*}**" &gt; "**{*řetězec 2*}**") ]]**

*# má text proměnné alespoň N znaků?*<br>
**test ${#**{*název\_proměnné*}**\} -ge** {*N*}

### Testy řetězců: regulární výrazy

*# obsahuje text proměnné shodu s **regulárním výrazem**? (bash/sh)*<br>
*// Název proměnné „regvyraz“ zde nemá žádný speciální význam, je zvolen jen pro přehlednost; můžete použít jakoukoliv proměnnou. Jednoduchý regulární výraz (takový, který neobsahuje mezery, uvozovky, zpětná lomítka ani hranaté závorky) můžete dokonce zadat přímo, pro zadání složitějšího výrazu je ale striktně doporučeno jej předem uložit do proměnné, protože pravidla odzvláštňování v tomto kontextu jsou složitá a neintuitivní.*<br>
**regvyraz='**{*regulární výraz*}**'**<br>
**[[ $**{*název\_proměnné*} **=~ $regvyraz ]]**<br>
{*název\_proměnné*}**=$**{*název\_proměnné*} **regvyraz='**{*regulární výraz*}**' bash -c '[[ $**{*název\_proměnné*} **=~ $regvyraz ]]'**

*# text první shody po úspěšném testu „[[ text =~ výraz ]]“*<br>
**${BASH\_REMATCH[0]}**

*# text N-tého záchytu první shody (1, 2, ...) po úspěšném testu „[[ text =~ výraz ]]“*<br>
**${BASH\_REMATCH[**{*N*}**]}**

### Testy celých čísel

*# =*<br>
**((** {*číslo1*} **=** {*číslo2*}**))**

*# &lt;*<br>
**((** {*číslo1*} **&lt;** {*číslo2*}**))**

*# &gt;*<br>
**((** {*číslo1*} **&gt;** {*číslo2*}**))**

*# ≤*<br>
**((** {*číslo1*} **&lt;=** {*číslo2*}**))**

*# ≥*<br>
**((** {*číslo1*} **&gt;=** {*číslo2*}**))**

*# ≠*<br>
**((** {*číslo1*} **!=** {*číslo2*}**))**

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

*# běží Bash v interaktivním režimu?*<br>
**[[ $- == \*i\* ]]**








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

### Řídicí proměnné

Popis proměnných PS0, PS1 a PS2 najdete v kapitole „Terminál“.

*# pokud název příkazu neobsahuje lomítko a neodpovídá identifiátoru aliasu, funkce či vestavěného příkazu, hledat program ke spuštění v těchto adresářích*<br>
**PATH="**{*/cesta*}[**:**{*/další/cesta*}]...**"**

*# domovský adresář uživatele*<br>
**HOME=**{*/cesta*}

*# pokud parametr příkazu „cd“ neobsahuje lomítko a neexistuje jako adresář v aktuálním adresáři, zkusit prohledat ještě tyto další adresáře*<br>
**CDPATH="**{*/cesta*}[**:**{*/další/cesta*}]...**"**

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


## Zaklínadla: Interaktivní režim

### Ovládání

*# zopakovat poslední příkaz*<br>
{_↑_}<br>
{_Enter_}

*# pokusit se doplnit parametr nalevo od kurzoru*<br>
{_Tab_}

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

*# vrátit poslední provedenou úpravu příkazového řádku*<br>
{_Ctrl_}**+**{_X_}{_U_}

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

### Aliasy

*# vypsat přehled aliasů*<br>
**alias**

*# nastavit alias (obecně/příklad)*<br>
**alias** {*identifikator*}**=**{*"text"*} [{*dalsiidentifikator*}**=**{*"text"*}]...<br>
**alias ls='printf %s\\n "Výpis souborů:"; ls -l'**

*# smazat alias*<br>
*// Pozor na rozdíl oproti příkazu „unset“ — mazaný alias musí existovat, jinak příkaz „unalias“ selže.*<br>
**unalias** {*identifikator*} [**2&gt;/dev/null \|\| true**]

*# test: je identifikátor alias?*<br>
**alias** {*identifikator*} **&amp;&gt;/dev/null**

### Nastavení interaktivního režimu

*# nastavit časový limit na zadání příkazu *<br>
*// Pozor, limit se počítá od zobrazení výzvy a když doběhne, intepret se ukončí, a to i v případě, že příkaz teprve zadáváte. Poznámka: Uvedená hodnota se prý aplikuje také na vestavěný příkaz „read“, pokud ten nemá zadán vlastní časový limit.*<br>
**TMOUT=**{*N*}

<!--
// Oddělit do samostatné kapitoly
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

<!- -
https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#Programmable-Completion-Builtins
- ->

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

-->

<!--
## Zaklínadla: Ostatní

*# běží bash v režimu „login-shell“?*<br>
?
-->

## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

### Použití přesměrování deskriptorů

Přesměrování deskriptorů se obvykle uvádí na konec příkazu (tzn. za poslední
parametr), např. takto:

*# *<br>
**printf %s\\\\n "Chyba!" &gt;&amp;2**

Ale Bash dovoluje ho uvést i před příkaz nebo kamkoliv mezi parametry, např.:

**&gt;&amp;2 LC\_ALL=C sort &lt;&lt;&lt; $'P\\nC\\nA' -**

Přesměrování je možno aplikovat i na blok příkazů uzavřený ve složených
či kulatých závorkách, na cykly (např. „while“) a řadu dalších konstrukcí.

Zvláštní pozornost je potřeba věnovat použití „bloku řádků“ jako vstupu;
definice ukončovače se totiž uvádí za značku &lt;&lt;, ale číst vstup začne
Bash až od následující řádky, což umožňuje tento druh vstupu skombinovat
např. s rourou:

*# *<br>
**LC\_ALL=C sort &lt;&lt; "KONEC" \| tr A \_**<br>
**ZAHRADA**<br>
**Abeceda**<br>
**KONEC**

### Kartézský součin (složené závorky)

*# *<br>
[{*předpona*}]**\{**{*alternativa-1*}**,**{*alternativa-2*}[**,**{*další-alternativa*}]...**\}**[{*přípona*}]

Operátor kartézského součinu slouží ke generování parametrů, kde se
na určené místo textu parametru postupně dosazují zadané podřetězce
v uvedeném pořadí, např.:

*# *<br>
**abe{ce,sa,,}da** ⊨ abeceda abesada abeda abeda

Podřetězce mohou být prázdné a mohou se opakovat; jejich zadané pořadí bude
při generování vždy dodrženo. Rovněž předpona a přípona generovaného parametru
mohou být prázdné, takže např. „""{,,}“ vygeneruje tři prázdné parametry.

Vyskytuje-li se v jednom parametru víc operátorů kartézského součinu,
zpracují se jako zleva doprava vnořené cykly, např. takto:

*# *<br>
**abe{00x,10y}da{20x,30y}da**<br>
**abe00xda{20x,30y}da abe10yda{20x,30y}da**<br>
**abe00xda20xda abe00xda30yda abe10yda20xda abe10yda30yda**

Uvnitř operátoru kartézského součinu můžete použít obvyklé způsoby odzvláštnění,
nejčastěji budete potřebovat potlačit zvláštní význam znaku „,“, který zde
normálně odděluje dosazované alternativy, a znaku *mezera*, který by jako
oddělovač parametrů celý operátor přerušil.

*# *<br>
**printf %s\\\\n {"Ahoj, ","{}/"}{světe,"2 světy!"}**

## Instalace na Ubuntu

GNU Bash a všechny příkazy použité v této kapitole jsou základními součástmi
Ubuntu přítomnými i v minimální instalaci.

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

* Bash umí sám pracovat pouze s textovými daty; obecná binární data, pokud neobsahují nulový bajt, můžete poměrně úspěšně zpracovat po nastavení LC\_ALL=C, kdy bude Bash považovat každý bajt větší než 0 za jeden znak (ale vzdáte se tím lokalizace a podpory UTF-8); pro zpracování binárních dat jsou vhodnější jiné nástroje.
* Normálně klávesová zkratka Ctrl+C přeruší probíhající program či skript. Některé programy se sice dobrovolně ukončí, ale přitom příslušný signál obslouží a nedají vědět skriptu, který je zavolal, takže ten pak pokračuje dalšími příkazy.

### Časté chyby

Pozor na implicitní vznik podprostředí v některých situacích! Bash automaticky obklopí podprostředím každý příkaz dvou- či vícečlenné roury a také i jednoduchý příkaz spouštěný na pozadí. To znamená, že např. tento blok kódu vypíše „12“ a „19“, protože přiřazení z konstrukce „:=“ zůstalo izolované v podprostředí:

*# *<br>
**unset a**<br>
**true "${a:=12}" &amp;**<br>
**wait $!**<br>
**printf %s\\n "${a:=19}"**

Častěji se tato chyba vyskytuje ve formě pokusu o použití příkazu „read“ s rourou:

*# *<br>
**unset a**<br>
**printf 99\\n \| IFS= read -r a**<br>
**printf %s\\n "$a"**

V uvedeném příkladu zůstane hodnota „a“ nedefinovaná, protože ho Bash uzavře do
samostatného podprostředí.

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

## Zákulisí kapitoly
<!--
- Doplňte, pokud víte. Udržujte aktuální.
-->

V této verzi kapitoly chybí:

!KompaktníSeznam:
* koprocesy
<!-- https://www.gnu.org/software/bash/manual/html_node/Coprocesses.html#Coprocesses -->
* getopt
* bind (mapování kláves)
* ulimit
* enable (zakazování vestavěných příkazů)
* proměnná SHLVL

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* Práci s proměnnými (viz kapitolu Proměnné příkazy a interpretu)
* Nastavení terminálu a výzvy (viz kapitolu Terminál)

Další poznámky:

!KompaktníSeznam:
* Nastavení proměnné BASH\_ENV umožňuje spustit „před-skript“ při spouštění skriptu.

!ÚzkýRežim: vyp
