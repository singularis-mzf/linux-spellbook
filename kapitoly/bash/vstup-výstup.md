<!--

Linux Kniha kouzel, kapitola Bash/Vstup, výstup a přesměrování
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

# Vstup, výstup a přesměrování

!Štítky: {program}{bash}
!FixaceIkon: 1754
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod

Tato kapitola pokrývá nástroje interpretu GNU Bash k ovládání vstupu a výstupu
spouštěných příkazů i samotného intepretu. Rovněž pokrývá nástroje ke čtení
textových řetězců z terminálu, ze souboru či z výstupu spouštěného programu
a nástroje k zápisu textových řetězců na terminál, do souboru nebo na vstup
spouštěného programu.

## Definice

* **Deskriptor** je (nejen v Bashi, ale samostatně pro každý proces v systému) číslovaný vstup nebo výstup. Základní deskriptory jsou „**standardní vstup**“ (číslo 0, „stdin“, budu zkracovat jako „s.vstup“), „**standardní výstup**“ (číslo 1, „stdout“, budu zkracovat jako „s.výstup“) a „**standardní chybový výstup**“ (číslo 2, „stderr“, budu zkracovat jako „s.ch. výstup“). Deskriptory 3 až 9 jsou určeny pro libovolné přesměrování; deskriptory 10 až 255 pro vnitřní použití interpretem. (Některé deskriptory mohou být současně vstupní i výstupní, ale jejich použití je pak poměrně komplikované.)
* **Vstup** je deskriptor, ze kterého může proces číst data.
* **Výstup** je deskriptor, do kterého může proces zapisovat data.
* **Roura** (v některých příručkách také nazývaná „kolona“) je spojení dvou nebo více jednoduchých příkazů operátorem „\|“. Bash pak tyto příkazy spustí paralelně a připojí standardní výstup příkazu nalevo od \| na standardní vstup příkazu napravo od \|. Díky tomu pak data „protékají“ přímo z jednoho procesu do druhého. Návratovým kódem roury je ve výchozím nastavení návratový kód posledního uvedeného jednoduchého příkazu.
* **Přesměrování deskriptorů** (či jen **přesměrování**) je úkon, při kterém Bash něco provede s deskriptory vznikajícího procesu (nebo svými vlastními). Přesměrování se provádí jedno po druhém zleva doprava, jak jsou zadána na příkazové řádce.

*Užitečná poznámka ke spouštění příkazů*: kdykoliv z Bashe spustíte jakýkoliv nový proces, ten nejprve zdědí *všechny* deskriptory od interpretu (ne jen ty tři základní), pak pro něj Bash provede přesměrování deskriptorů specifikovaná na příkazovém řádku (včetně propojení procesů rour) a pak se teprve pokusí program spustit. To znamená, že vedlejší účinky přesměrování (např. vytvoření souborů) se projeví i v případě, že se Bashi program spustit nepodaří.

!ÚzkýRežim: vyp

## Zaklínadla

### Roura

*# přesměrovat s.výstup příkazu A na s.vstup příkazu B*<br>
*// Varianta „\|&amp;“ přesměruje navíc i s.ch. výstup.*<br>
{*příkaz-A včetně přesměrování*} [**\|**[**&amp;**] {*příkaz-B včetně přesměrování*}]...

*# totéž, ale příkaz B přitom neuzavřít do podprostředí*<br>
{*příkaz-B včetně přesměrování*} **&lt; &lt;(**{*příkaz-A včetně přesměrování*}**)**

### Přesměrování vstupu (čtení odněkud)

*# čtení z existujícího **souboru** (obecně/příklad)*<br>
[{*deskriptor*}]**&lt;** {*cesta*}<br>
**&lt; "../můj soubor.txt"**

*# čtení ze zadaného **textu** (obecně/příklady)*<br>
*// Poznámka: Bash za konec zadaného textu vždy připojí znak „\\n“, i v případě, že už tam je!*<br>
[{*deskriptor*}]**&lt;&lt;&lt;** {*parametr*}<br>
**sort &lt;&lt;&lt; $'zoo\\nahoj\\nseminář'**<br>
**sort &lt;&lt;&lt; "A$(echo BC)D"**

*# čtení z **prázdného** vstupu*<br>
[{*deskriptor*}]**&lt; /dev/null**

*# čtení ze s.výstupu bloku **příkazů** (obecně/příklad)*<br>
[{*deskriptor*}]**&lt;&blank;&lt;(**{*příkazy...*}**)**<br>
**sort &lt;&blank;&lt;(echo Zoo; echo Abeceda)**

*# zduplikovat/přečíslovat deskriptor pro čtení*<br>
<!--
*// Zduplikování deskriptoru čtoucího ze souboru není totéž jako dvojité otevření téhož souboru; duplikáty téhož deskriptoru totiž sdílí stejnou pozici, takže čtením z jednoho se posouvá i pozice pro čtení z ostatních. Naproti tomu při otevření téhož souboru na dva různé deskriptory bude každý z nich mít samostatnou pozici čtení, která nebude ovlivňována čtením z toho druhého.*<br>
-->
[{*cílový-deskriptor*}]**&lt;&amp;**{*zdrojový-deskriptor*}<br>
[{*cílový-deskriptor*}]**&lt;&amp;**{*zdrojový-deskriptor*}**-**

*# zduplikovat **pojmenovaný deskriptor** pro čtení*<br>
{*příkaz a parametry*} [{*cílový-deskriptor*}]**&lt;&amp;$**{*identifikator-pojm-desk*}

*# čtení z **bloku řádek***<br>
*// Zadaný ukončovač musí být neprázdný řetězec. Bash na přesměrovávaný vstup zapíše všechny řádky počínaje první řádkou po aktuálním příkazu a konče poslední řádkou, která se přesně neshoduje s ukončovačem (není dovolena odlišnost ani v bílých znacích na začátku či konci řádky!).*<br>
[{*deskriptor*}]**&lt;&lt; '**{*ukončovač*}**'**<br>
{*řádky textu*}<br>
{*ukončovač*}

*# **zavřít** deskriptor*<br>
{*deskriptor*}**&lt;&amp;-**

*# čtení z bloku řádek po rozvoji*<br>
*// Pozor! Při použití tohoto zaklínadla nesmí být žádný znak v identifikátoru odzvláštněn (tzn. používejte jen znaky dovolené v názvu proměnné). Bash na přesměrovávaný vstup zapíše všechny řádky počínaje první řádkou po aktuálním příkazu a konče poslední řádkou, která se přesně neshoduje se zadaným identifikátorem (shoda musí být přesná, není dovolena odlišnost ani v bílých znacích na začátku či konci). Před použitím Bash celý blok řádek intepretuje, přičemž za zvláštní považuje pouze znaky „$“, „\\“ a „\`“ (s výjimkou apostrofů s dolarem, ty tam přímo použít nelze), můžete tam tedy dosazovat hodnoty proměnných a výstupy příkazů.*<br>
[{*deskriptor*}]**&lt;&lt;-** {*identifikátor*}<br>
{*řádky textu*}<br>
{*identifikátor*}

### Přesměrování výstupu (zápis někam)

*# zápis do souboru; existuje-li: zkrátit na prázdný/připojit za konec*<br>
*// Varianta „&gt;\|“ dovolí přepsání existujícího souboru i v případě, že je nastavena volba „noclobber“.*<br>
[{*deskriptor*}]**&gt;**[**\|**] {*cesta*}<br>
[{*deskriptor*}]**&gt;&gt;** {*cesta*}

*# zápis **nikam***<br>
[{*deskriptor*}]**&gt; /dev/null**

*# zápis na s.vstup bloku příkazů (obecně/příklad)*<br>
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

### Některá obvyklá přesměrování

*# **zahodit** s.výstup i s.ch. výstup (alternativy)*<br>
**&amp;&gt; /dev/null**<br>
**&gt;/dev/null 2&gt;/dev/null**

*# s.ch. výstup nasměrovat na s.výstup (alternativy)*<br>
**2&gt;&amp;1**<br>
**2&gt; /dev/stdout**

*# s.výstup nasměrovat na s.ch. výstup (alternativy)*<br>
**&gt; /dev/stderr**<br>
**&gt;&amp;2**

*# s.výstup a s.ch. výstup připojit za konec souboru (pokud neexistuje, vytvořit prázdný)(alternativy)*<br>
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

### Ostatní aplikace přesměrování

*# aplikovat přesměrování na skupinu příkazů*<br>
*// Složené závorky můžete umístit i na stejnou řádku jako příkazy uvnitř, ale v takovém případě je musíte oddělit mezerami a poslední příkaz musí být ukončen operátorem „;“ nebo „&amp;“! Proto doporučuji raději oddělovat složené závorky od příkazů koncem řádku.*<br>
**\{**<br>
<odsadit1>{*příkazy*}...<br>
**\}** {*přesměrování*}

*# aplikovat přesměrování permanentně (na všechny následující příkazy)*<br>
**exec** {*přesměrování*}

## Zaklínadla: Čtení a zápis z Bashe

### Čtení z terminálu

*# načíst od uživatele **heslo***<br>
*// Parametr „-s“ potlačí výstup psaných znaků na terminál.*<br>
[**if**] **IFS= read -rs** [**-p** {*"Text výzvy:"*}] {*promenna*} **&amp;&amp; echo** [**then** {*...*} **fi**]

### Zápis na terminál

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

### Nastavení související s deskriptory a rourami

*# návratový kód vícenásobné roury se vezme: z prvního příkazu, který selhal/vždy z posledního příkazu roury*<br>
**set -o pipefail**<br>
**set +o pipefail**

*# přepsání existujícího souboru obyčejným přesměrováním výstupu (zakázat/povolit)*<br>
**set -C**<br>
**set +C**

<!--
## Parametry příkazů
<!- -
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)
-->

### Použití přesměrování deskriptorů

Přesměrování deskriptorů se obvykle uvádějí na konec příkazu, za poslední
parametr; např. takto:

*# *<br>
**printf %s\\\\n "Chyba!" &gt;&amp;2**

Ale Bash je dovoluje uvést kamkoliv, dokonce i před příkaz nebo mezi parametry, např.:

*# *<br>
**&gt;&amp;2 LC\_ALL=C sort &lt;&lt;&lt; $'P\\nC\\nA' -**

Přesměrování je možno aplikovat i na celý blok příkazů, na cykly (např. „while“) apod.

Zvláštní pozornost je potřeba věnovat použití „bloku řádků“ jako vstupu;
definice ukončovače se totiž uvádí za značku &lt;&lt;, ale číst vstup začne
Bash až *od následující řádky*, což umožňuje tento druh vstupu skombinovat
např. s rourou:

*# *<br>
**LC\_ALL=C sort &lt;&lt; "KONEC" \| tr A \_**<br>
**ZAHRADA**<br>
**Abeceda**<br>
**KONEC**

## Instalace na Ubuntu

GNU Bash a všechny příkazy použité v této kapitole jsou základními součástmi
Ubuntu přítomnými i v minimální instalaci.

<!--
## Ukázka
<!- -
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)
-->

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Při práci s deskriptory je třeba mít na paměti, že „pozice“ čtení či zápisu není vlastností samotného deskriptoru. Otevřením souboru přesměrováním deskriptoru vznikne nová „čtecí pozice“ i v případě, že stejný soubor je již otevřen přes jiný deskriptor; pokud ale stávající deskriptor zduplikujete nebo ho zdědí nový proces, nová pozice nevznikne a čtení z obou deskriptorů bude posouvat tutéž čtecí pozici (existující pravděpodobně někde v jádře).

### Časté chyby s rourou

Pozor na implicitní vznik podprostředí v některých situacích! Bash automaticky obklopí podprostředím každý příkaz roury a také i jednoduchý příkaz spouštěný na pozadí nebo v operátoru „$()“. To znamená, že např. tento blok kódu vypíše „12“ a „19“, protože přiřazení z konstrukce „:=“ zůstalo izolované v podprostředí:

*# *<br>
**unset a**<br>
**true "${a:=12}" &amp;**<br>
**wait $!**<br>
**printf %s\\n "${a:=19}"**

Nejčastěji se tato chyba vyskytuje ve formě pokusu o použití příkazu „read“ s rourou:

*# *<br>
**unset a**<br>
**printf 99\\n \| IFS= read -r a**<br>
**printf %s\\n "$a"**

V uvedeném příkladu zůstane hodnota „a“ nedefinovaná, protože ho Bash uzavře do
samostatného podprostředí.

## Další zdroje informací

* [TL;DR: read](https://github.com/tldr-pages/tldr/blob/master/pages/common/read.md) (anglicky)

## Zákulisí kapitoly
<!--
- Doplňte, pokud víte. Udržujte aktuální.
-->

V této verzi kapitoly chybí:

!KompaktníSeznam:
* koprocesy
<!-- https://www.gnu.org/software/bash/manual/html_node/Coprocesses.html#Coprocesses -->
* více „dalších zdrojů informací“

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* nic

<!--
Další poznámky:

!KompaktníSeznam:
* x
-->

!ÚzkýRežim: vyp
