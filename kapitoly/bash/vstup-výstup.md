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
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod

Tato kapitola pokrývá nástroje interpretu Bash k ovládání vstupů a výstupů
spouštěných příkazů i vstupů a výstupů samotného interpretu.
Rovněž pokrývá nástroje ke čtení textových řetězců ze souborů, terminálu či
výstupu spoustěného programu a nástroje k zápisu textových řetězců
do souboru, na terminál, do souboru nebo na vstup spouštěného programu.

Interpret Bash je vyvíjen v rámci projektu GNU.

## Definice

* **Deskriptor** je (nejen v Bashi, ale pro každý jednotlivý proces v systému) číslovaný vstup nebo výstup. Základní deskriptory jsou „**standardní vstup**“ (číslo 0, „stdin“, budu zkracovat jako „s.vstup“), „**standardní výstup**“ (číslo 1, „stdout“, budu zkracovat jako „s.výstup“) a „**standardní chybový výstup**“ (číslo 2, „stderr“, budu zkracovat jako „s.ch. výstup“). Deskriptory 3 až 9 jsou určeny pro libovolné použití, deskriptory 10 až 255 pro vnitřní použití interpretem.
* **Vstup** je deskriptor, ze kterého může proces číst data.
* **Výstup** je deskriptor, do kterého může proces zapisovat data.
* **Roura** („pipeline“, v některých příručkách také nazývaná „kolona“) je spojení dvou nebo více jednoduchých příkazů operátorem „\|“. Bash pak tyto příkazy spustí paralelně a připojí standardní výstup příkazu nalevo od \| na standardní vstup příkazu napravo od \|. Díky tomu pak data „protékají“ přímo z jednoho procesu do druhého. Návratovým kódem roury je ve výchozím nastavení návratový kód posledního uvedeného jednoduchého příkazu.
* **Přesměrování deskriptorů** (či jen **přesměrování**) je úkon, při kterém Bash něco provede s deskriptory vznikajícího procesu (nebo svými vlastními). Přesměrování se provádí jedno po druhém zleva doprava, jak jsou zadána na příkazové řádce.

*Užitečná poznámka ke spouštění příkazů*: kdykoliv z Bashe spustíte jakýkoliv nový proces, ten nejprve zdědí *všechny* deskriptory od interpretu (ne jen ty tři základní), pak pro něj Bash provede přesměrování deskriptorů specifikovaná na příkazovém řádku (včetně propojení procesů rour) a pak se teprve pokusí program spustit. To znamená, že vedlejší účinky přesměrování (např. vytvoření souborů) se projeví i v případě, že se Bashi program spustit nepodaří (např. proto, že program takového názvu neexistuje).

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

*# čtení z **bloku řádků***<br>
*// Zadaný ukončovač musí být neprázdný řetězec. Bash na přesměrovávaný vstup zapíše všechny řádky počínaje prvním řádkem po aktuálním příkazu a konče poslední řádkou, která se přesně neshoduje s ukončovačem (není dovolena odlišnost ani v bílých znacích na začátku či konci řádky!).*<br>
[{*deskriptor*}]**&lt;&lt; '**{*ukončovač*}**'**<br>
{*řádky textu*}<br>
{*ukončovač*}

*# **zavřít** deskriptor*<br>
{*deskriptor*}**&lt;&amp;-**

*# čtení z bloku řádků po rozvoji*<br>
*// Pozor! Při použití tohoto zaklínadla nesmí být žádný znak v identifikátoru odzvláštněn (tzn. používejte jen znaky dovolené v názvu proměnné). Bash na přesměrovávaný vstup zapíše všechny řádky počínaje prvním řádkem po aktuálním příkazu a konče poslední řádkou, která se přesně neshoduje se zadaným identifikátorem (shoda musí být přesná, není dovolena odlišnost ani v bílých znacích na začátku či konci). Před použitím Bash celý blok řádek intepretuje, přičemž za zvláštní považuje pouze znaky „$“, „\\“ a „\`“ (s výjimkou apostrofů s dolarem, ty tam přímo použít nelze), můžete tam tedy dosazovat hodnoty proměnných a výstupy příkazů.*<br>
[{*deskriptor*}]**&lt;&lt;-** {*identifikátor*}<br>
{*řádky textu*}<br>
{*identifikátor*}

### Přesměrování výstupu (zápis někam)

*# zápis do **souboru**; existuje-li: zkrátit na prázdný/připojit za konec*<br>
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
*// Složené závorky můžete umístit i na stejný řádek jako příkazy uvnitř, ale v takovém případě je musíte oddělit mezerami a poslední příkaz musí být ukončen operátorem „;“ nebo „&amp;“! Proto doporučuji raději oddělovat složené závorky od příkazů koncem řádku.*<br>
**\{**<br>
<odsadit1>{*příkazy*}...<br>
**\}** {*přesměrování*}...

*# aplikovat přesměrování permanentně (na všechny následující příkazy)*<br>
**exec** {*přesměrování*}...

## Zaklínadla: Čtení a zápis z Bashe

### Zápis (výstup)

*# formátovaný výstup*<br>
**printf** [**\-\-**] {*'formátovací řetězec'*} [{*parametry*}]... [{*přesměrování*}]

*# zapsat **text***<br>
**printf %s**[**\\\\n**] {*"text"*} [{*přesměrování*}]

*# zapsat **bajty***<br>
*// AB a CD reprezentují dvoumístný hexadecimální zápis bajtů k zapsání*<br>
**printf '\\x**{*AB*}[**\\x**{*CD*}]...**'** [{*přesměrování*}]

*# zapsat „\\0“ (nulový bajt)*<br>
**printf \\\\0** [{*přesměrování*}]

### Čtení (vstup)

Před použitím zaklínadel z této podsekce si prosím přečtěte podsekci
„Jak funguje příkaz read“!

*# přečíst do proměnné **záznam** ukončený znakem „\\n“/„\\0“/zadaným ASCII znakem*<br>
**IFS= read -r**[**u** {*deskriptor*}] {*promenna*}<br>
**IFS= read -r**[**u** {*deskriptor*}] **-d ""** {*promenna*}<br>
**IFS= read -r**[**u** {*deskriptor*}] **-d** {*"ASCII-znak"*} {*promenna*}

*# přečíst do proměnné N znaků/1 znak*<br>
**IFS= read -r**[**u** {*deskriptor*}] **-N** {*N*} {*promenna*}<br>
**IFS= read -r**[**u** {*deskriptor*}] **-N 1** {*promenna*}

*# načíst záznam a **rozložit** ho do pole*<br>
**IFS=**{*"oddělovače"*} **read -r**[**u** {*deskriptor*}] <nic>[**-d** {*"ASCII-ukončovač-záznamu"*}] **-a** {*pole*}...<br>
**IFS=":" read -r -a data &lt; /etc/passwd &amp;&amp; printf %s\\\\n "${data[4]}"**

*# načíst záznam a **rozložit** ho do proměnných (obecně/příklad)*<br>
**IFS=**{*"oddělovače"*} **read -r**[**u** {*deskriptor*}] <nic>[**-d** {*"ASCII-ukončovač-záznamu"*}] {*promenna*}...<br>
**IFS=":" read -r a b c d e &lt; /etc/passwd**

*# načíst všechny záznamy do **nového pole** (alternativy)*<br>
**readarray -t** [**-d** {*"ukončovač"*}] <nic>[**-s** {*kolik-z-přeskočit*}] <nic>[**-n** {*kolik-max-načíst*}] <nic>[**-u** {*deskriptor*}] {*pole*}<br>
**IFS=**{*"ukončovače"*} **read -r**[**u** {*deskriptor*}] **-d "" -a** {*pole*} **\|\| true**

*# načíst všechny záznamy do existujícího pole*<br>
*// „index“ je index v poli, kam má začít příkaz zapisovat. Pro zápis od začátku pole uveďte index „0“.*<br>
**readarray -t -O** {*index*} [**-d** {*"ukončovač"*}] <nic>[**-s** {*kolik-z-přeskočit*}] <nic>[**-n** {*kolik-max-načíst*}] <nic>[**-u** {*deskriptor*}] {*pole*}

*# načíst celý zbytek vstupu do proměnné*<br>
**IFS= read -rd ""** {*promenna*} **&lt;&blank;&lt;(tr -d \\\\0)**

### Interakce s uživatelem (jen při čtení z terminálu)

*# načíst **heslo***<br>
*// Parametr „-s“ potlačí výstup psaných znaků na terminál. Při načítání hesel si dejte velký pozor na to, aby použitá proměnná nebyla exportovaná, jinak se totiž heslo objeví v prostředí nově spuštěných procesů, odkud může být šikovnými hackery odposlechnuto.*<br>
[**if**] **IFS= read -rs** [**-p** {*"Text výzvy:"*}] {*promenna*} **&amp;&amp; echo** [**then** {*...*} **fi**]

*# nabídnout uživateli řádku k **úpravě** (obecně/příklad)*<br>
*// Pozor! V případě selhání příkazu (např. vypršení časového limitu) zůstane v cílové proměnné prázdný řetězec, ať už uživatel mezitím nějaké úpravy provedl nebo ne.*<br>
**IFS=** [**TMOUT=**[{*časový-limit-sek*}]] **read -r** [**-p** {*"Text výzvy"*}] **-ei** {*"Výchozí text řádky"*} {*promenna*}

### Je deskriptor připojený na terminál?

*# je s.vstup připojený na terminál?*<br>
**test -t 0**

*# je s.výstup/s.ch. výstup připojený na terminál?*<br>
**test -t 1**<br>
**test -t 2**

*# je deskriptor N připojený na terminál?*<br>
**test -t** {*N*}

### Nastavení Bashe související s deskriptory a rourami

*# návratový kód vícenásobné roury se vezme: z prvního příkazu, který selhal/vždy z posledního příkazu roury (výchozí nastavení)*<br>
**set -o pipefail**<br>
**set +o pipefail**

*# zkrácení existujícího souboru obyčejným přesměrováním výstupu (zakázat/povolit)*<br>
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

## Další poznámky

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

### Jak funguje příkaz read

*# *<br>
**IFS=**{*"oddělovače"*} **read -r**[**u** {*deskriptor*}] <nic>[**-d** {*"ukončovač"*}] {*promenna*}...<br>
**IFS=**{*"oddělovače"*} **read -r**[**u** {*deskriptor*}] <nic>[**-d** {*"ukončovač"*}] **-a** {*pole*}<br>
**read -r**[**u** {*deskriptor*}] <nic>**-N** {*počet-znaků*} {*promenna*}<br>

* Před zahájením čtení „read“ do všech uvedených proměnných přiřadí prázdný řetězec. (Jde-li o čtení do pole, pole se vyprázdní.)
* Čte ze zadaného deskriptoru (výchozí je s.vstup, tedy 0) znak po znaku a přidává je na konec první zadané proměnné (resp. prvního prvku pole).
* Když na vstupu narazí na *oddělovač* (kterýkoliv znak z hodnoty proměnné IFS), přeskočí na další proměnnou/další prvek pole, s výjimkou případu, kdy se oddělovač nachází bezprostředně před ukončovačem záznamu; v takovém případu je oddělovač ignorován. Do poslední zadané proměnné se pak načte celý zbytek záznamu (tam už je hodnota proměnné IFS ignorována).
* Když „read“ na vstupu narazí na ukončovač záznamu (výchozí je „\\n“), *úspěšně* tím skončí čtení (tzn. návratový kód 0).
* Když „read“ narazí na konec vstupu (nebo hardwarovou chybu), skončí čtení s návratovým kódem 1. Již načtené znaky budou v proměnných ponechány.

<neodsadit>*Postřehy:*

* Ne-ASCII znaky lze použít v proměnné IFS (tzn. jako oddělovače záznamů), ale ne v parametru „-d“ (tzn. nemohou sloužit jako ukončovače záznamů).
* Nulový bajt lze použít jako ukončovač záznamu (tvar parametru je pak „-d ""“), ale ne jako oddělovač záznamů (nelze ho uložit do proměnné IFS).
* V případě, že „read“ narazí na konec vstupu, skončí s návratovým kódem 1, ale již přečtené znaky ponechá v příslušných proměnných.
* Nastavíte-li časový limit, v případě jeho vypršení skončí „read“ s kódem 142 a načítané proměnné budou vyprázdněny.

### Jak funguje příkaz printf

*# *<br>
**printf** [**-v** {*promenna*}] <nic>[**\-\-**] {*'formátovací řetězec'*} [{*parametr*}]...

Ve formátovacím řetězci jsou interpretovány formátovací značky (uvozené znakem „%“)
a lomítkové sekvence (začínající zpětným lomítkem „\\“), oba případy lze odzvláštnit
zdvojením (tzn. „%%“ se interpretuje jako obyčejný znak % a „\\\\“ jako obyčejné
zpětné lomítko). Netriviální formátovací řetězce doporučuji uzavřít do apostrofů,
aby nedocházelo ke konfliktům se zvláštním významem některých znaků
na příkazovém řádku.

Algoritmus příkazu printf:

* 1. Vzít formátovací řetězec a nahradit v něm všechny lomítkové sekvence odpovídajícími znaky či řetězci.
* 2. Projít všechny formátovací značky ve formátovacím řetězci zleva doprava; pro každou načíst jeden parametr z parametrů za formátovacím řetězcem (pokud chybí, použít místo něj prázdný řetězec), zformátovat podle značky a dosadit místo ní.
* 3. Výsledný řetězec vypsat na standardní výstup.
* 4. Pokud zbyl alespoň jeden parametr, vzít řetězec, který byl výstupem kroku 1 a jít na krok 2 se zbylými parametry.

V případě použití parametru „-v“ se řetězce místo vypsání ukládají do zadané proměnné
a nesmí obsahovat nulový bajt (jinak může být chování nepředvídatelné).

## Instalace na Ubuntu

Bash a všechny příkazy použité v této kapitole jsou základními součástmi
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

Pozor na implicitní vznik podprostředí v některých situacích! Bash automaticky obklopí podprostředím každý jednoduchý příkaz roury a také i jednoduchý příkaz spouštěný na pozadí nebo v operátoru „$()“. To znamená, že např. tento blok kódu vypíše „19“, protože přiřazení z konstrukce „:=“ zůstalo izolované v podprostředí:

*# *<br>
**unset a**<br>
**true "${a:=12}" &amp;**<br>
**wait $!**<br>
**printf %s\\\\n "${a:=19}"**

Nejčastěji se tato chyba vyskytuje ve formě pokusu o použití příkazu „read“ s rourou:

*# *<br>
**unset a**<br>
**printf 99\\\\n \| IFS= read -r a**<br>
**printf %s\\\\n "$a"**

V uvedeném příkladu zůstane hodnota „a“ nedefinovaná, protože Bash uzavře příkaz
„read“ do samostatného podprostředí.

### Problémy s nulovým bajtem

Bash obecně neumí pracovat s nulovým bajtem „\\0“; umí ho však vygenerovat (příkazem printf) a přečíst jako ukončovač záznamu (příkazy read a readarray) a rovněž může být předáván rourou z příkazu do příkazu (což probíhá mimo Bash, ten rouru jen vytváří). Celkově je třeba při jakémkoliv pokusu o prácí
s nulovým bajtem nástroji Bashe dát velký pozor, zejména ho
*nelze uložit do proměnných* ani použít uvnitř textu parametru jakéhokoliv příkazu.

<!-- (příkazy read a readarray ho v takovém případě při ukládání přeskočí, dosazovací operátor $() ho také přeskočí, ale vypíše přitom varování). ; samotné vstupy, výstupy a roury jsou ale binární, takže pokud data proudí mimo Bash, nulový bajt nepředstavuje problém. -->

## Další zdroje informací

* [TL;DR: printf](https://github.com/tldr-pages/tldr/blob/master/pages/common/printf.md) (anglicky)
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
* podrobnější výklad o „printf“

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* nic

<!--
Další poznámky:

!KompaktníSeznam:
* x
-->

!ÚzkýRežim: vyp
