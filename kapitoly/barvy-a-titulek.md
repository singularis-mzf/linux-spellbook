<!--

Linux Kniha kouzel, kapitola Barvy, titulek a výzva terminálu
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
ÚKOLY:

Poznámky:

Zobrazit větev gitu - složité řešení:
$(git branch 2>/dev/null | gawk "/^\\* /{print \" (git:\" substr(\$0,3) \")\";}")
Jednoduché řešení:
__git_ps1

-->

# Barvy, titulek a výzva terminálu

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->

Tato kapitola pokrývá ovládání barvy písma, barvy pozadí, použitého fontu, titulku terminálového okna a pozice a vlastností kurzoru. Rovněž pokrývá nastavování výzev interpretu bash (PS1 a dalších). Logicky by patřila do kapitoly o příkazovém interpretu bash, ale ta bude velmi rozsáhlá a náročná na zpracování, proto jsem toto téma vydělil/a do samostatné kapitoly.

Barvy a font se v příkazové řádce Linuxu nastavují pomocí takzvaných escape sekvencí, což jsou zvláštní řídicí sekvence bajtů, kterým daný terminál rozumí a místo jejich vypsání na obrazovku změní písmo, přesune kurzor nebo udělá jinou akci, která je v dané sekvenci zakódována. Abychom se tyto sekvence nemuseli učit, používáme místo nich moderní příkaz „tput“, který načte příslušnou sekvenci ze své databáze a vypíše ji na svůj standardní výstup. Pokud tento výstup směřuje přímo na terminál, požadovaná akce se ihned provede; častěji se ale sekvence ukládá do proměnné k pozdějšímu použití; k její aktivaci pak stačí danou proměnnou vypsat na terminál příkazem jako „printf“ či „echo“.

Tato verze kapitoly nepokrývá zvláštní schopnosti konkrétních terminálových programů (např. rozdíly mezi Terminatorem a Konsolí) a podporu šestnácti milionů barev, která zatím v terminálových programech není dostatečně rozšířena (ačkoliv některé už příslušné escape sekvence podporují).

Jedna z prvních věcí, která mě po otevření linuxového terminálu naštvala, bylo to, že neustále barevně zdůrazňoval moje uživatelské jméno a uváděl ho do titulku snad každého terminálového okna. Když si v Xubuntu ve výchozím nastavení poprvé otevřete Terminator a rozdělíte ho na čtyři podokna, svoje uživatelské jméno uvidíte na *deseti* místech a zopakuje se pokaždé, když máte zadat další příkaz. Mám z toho pocit, že toto nastavení musel navrhovat někdo s narcistickou poruchou osobnosti... Pokud si to chcete předělat, tato kapitola vám poradí jak.

## Definice
* **Výzva terminálu** (zkráceně „výzva“) je řetězec, který vypisuje interpret příkazového řádku před, během nebo po přijetí příkazu od uživatele (tzn. v interaktivním režimu). V interpretu „bash“ se rozeznávají tři druhy výzvy a jejich šablony jsou uloženy v proměnných PS0, PS1 a PS2: **hlavní výzva** (PS1) značí, že bash očekává příkaz, **vedlejší výzva** (PS2) značí, že bash očekává pokračování příkazu na dalším řádku, **potvrzující výzva** (PS0) se vypisuje po přijetí příkazu a před zahájením jeho vykonávání.
* **Escape sekvence** je řetězec bajtů, na který terminál zareaguje tak, že místo vypsání čehokoliv na obrazovku provede změnu nastavení (např. barvy písma) či nějakou akci. Escape sekvence začínají netisknutelným znakem „escape“ (ASCII kód 0x1b). V minulosti se escape sekvence zapisovaly ručně a děsily nezkušené uživatele; dnes se však obvykle generují moderním příkazem „tput“, který současně redukuje problémy s kompatibilitou jednotlivých typů terminálů.
* **Paleta** je v této kapitole pole barev, které daný terminál podporuje, *indexované od nuly*. Typicky se vyskytují pouze dvě palety: s 8 barvami a s 256 barvami, ačkoliv realizace konkrétních barev v těchto paletách se mohou v jednotlivých terminálech mírně lišit.

## Zaklínadla

### Pomocné funkce

*# bezp\_set()*<br>
**function bezp\_set () \{**<br>
**local f="$1" c="$(tput colors 2&gt;/dev/null \|\| true)" x=""**<br>
**shift**<br>
**for x in $@; do if test $x -lt $c; then tput $f $x; break; fi; done**<br>
**return 0**<br>
**\}**

### Titulek
*# nastavit titulek okna terminálu*<br>
*// Ve standardním nastavení nastavuje titulek terminálu jeho výzva PS1. Pro vyzkoušení si nastavte PS1="". Pro permanentní nastavení budete muset upravit soubor „~/.bashrc“.*<br>
**printf %s\\\\n "$TERM" \| egrep -isq ^xterm &amp;&amp; printf "\\\\e]2;%s\\\\a" "**{*nový titulek*}**"**

### Barvy

*# vypsat vzorník palety (barvy na pozadí)*<br>
**for I in $(seq 0 $(($(tput colors) - 1)))**<br>
**do**<br>
**printf "%s&blank;%3d&blank;%s" "$(tput bold;tput setab $I)" $I "$(tput sgr0)"**<br>
**test $(($I % 16)) -eq 15 &amp;&amp; printf \\\\n**<br>
**done**

*# vypsat vzorník palety (barvy textu)*<br>
**for I in $(seq 0 $(($(tput colors) - 1)))**<br>
**do**<br>
**printf "%s&blank;%3d&blank;%s" "$(tput bold;tput setaf $I)" $I "$(tput sgr0)"**<br>
**test $(($I % 16)) -eq 15 &amp;&amp; printf \\\\n**<br>
**done**

*# resetovat všechny atributy písma a barev*<br>
**tput sgr0**

*# nastavit barvu popředí/pozadí*<br>
*// Funkce „bezp\_set“ použije ze svých argumentů první podporované číslo barvy. Doporučuji jako první uvést číslo pro paletu s 256 barvami a jako druhé číslo náhradní barvy z osmibarevné palety.*<br>
**bezp\_set setaf** {*číslo-barvy*}...<br>
**bezp\_set setab** {*číslo-barvy*}...

*# ztmavit text (jen zapnout)*<br>
**tput dim**

*# inverzní režim (dočasně prohodí barvy popředí a pozadí; jen zapnout)*<br>
**tput rev**

*# neviditelný text (text barvou pozadí; jen zapnout)*<br>
**tput invis**

*# zvýrazněný mód (zapnout/vypnout)*<br>
*// Na některých terminálech je realizován jako inverzní text, na jiných jako tučné písmo.*<br>
**tput smso**<br>
**tput rmso**

*# blikající text (jen zapnout; málo podporovaný)*<br>
*// Používání blikajícího textu se výrazně nedoporučuje, protože je v různých terminálech málo a nejednotně podporován, má mnoho odpůrců a může uživateli způsobovat zdravotní potíže.*<br>
**tput blink**

*# vyplnit celý terminál barvou*<br>
**bezp\_set setab** {*číslo-barvy*} [{*náhradní-číslo-barvy*}]...**; tput clear; tput sgr0**

### Nastavení písma

*# vypnout všechny atributy písma a barev*<br>
**tput sgr0**

*# tučné písmo (jen zapnout)*<br>
**tput bold**

*# kurzíva (zapnout/vypnout)*<br>
**tput sitm**<br>
**tput ritm**

*# podtržení (zapnout/vypnout)*<br>
**tput smul**<br>
**tput rmul**

### Zjistit údaje o terminálu

*# počet sloupců/řádků terminálu*<br>
**tput cols**<br>
**tput lines**

*# počet podporovaných barev (velikost palety)*<br>
**tput colors**

*# aktuální sloupec/řádek kurzoru*<br>
?<br>
?

### Ovládání kurzoru

*# uložit/obnovit pozici kurzoru*<br>
**tput sc**<br>
**tput rc**

*# posun kurzoru na pozici*<br>
*// Řádky a sloupce jsou číslovány od nuly od levého horního rohu terminálu.*<br>
**tput cup** {*číslo-řádku*} {*číslo-sloupce*}

*# posun kurzoru nahoru/dolů/vlevo/vpravo*<br>
**tput cuu** {*posun*}<br>
**tput cud** {*posun*}<br>
**tput cub** {*posun*}<br>
**tput cuf** {*posun*}

*# posun kurzoru do určitého sloupce na aktuálním řádku/na začátek řádku*<br>
**tput hpa** {*index-sloupce*}<br>
**tput hpa 0**

*# přesunutí kurzoru do levého horního rohu/levého dolního rohu*<br>
**tput home**<br>
**tput cup $(tput lines) 0**

*# skrytí kurzoru/zrušení skrytí*<br>
**tput civis**<br>
**tput cnorm**

### Mazání obrazovky

*# smazat část řádku od kurzoru vlevo/vpravo*<br>
**tput el1**<br>
**tput el**

*# smazat celou obrazovku a kurzor přesunout na pozici 0 0 (levý horní roh)*<br>
**tput clear**

*# odstranit N řádků od aktuálního řádku (včetně) dolů*<br>
**tput hpa** {*N*}

## Zaklínadla (PS0, PS1 a PS2)
*# znak $ pro normálního uživatele a # pro uživatele „root“*<br>
**\\\\\\$**

*# provedení příkazu a vypsání jeho výstupu (vyhodnotit hned/vyhodnotit při každém vypsání dané výzvy)*<br>
*// V druhém případě musíte v uvedeném příkazu escapovat znaky ", \\, $ a !, aby se do proměnné PS1 (resp. PS0 či PS2) uložil tak, jak má být vykonán.*<br>
**$(**{*příkaz*}**)**<br>
**\\$(**{*příkaz*}**)**

*# návratový kód posledního příkazu*<br>
**\\$?**

*# cesta/název aktuálního adresáře (v obou případech se domovský adresář nahrazuje znakem „~“)*<br>
**\\\\w**<br>
**\\\\W**

*# číslo příkazu (podle historie/pořadové)*<br>
**\\\\!""**<br>
**\\\\\#**

*# expanze proměnné při každém vypsání výzvu*<br>
**\\\\\\$\{**{*název proměnné*}**\}**

*# aktuální datum ve formátu YYYY-MM-DD*<br>
**\\\\D{%F}**

*# aktuální čas ve formátu HH:MM/HH:MM:SS*<br>
**\\\\A**<br>
**\\\\t**

*# aktuální datum a čas ve vlastním formátu*<br>
*// Pro popis formátu viz „man strftime“.*<br>
**\\\\D\{**{*formát*}**\}**

*# název počítače (úplný/jen před první „.“)*<br>
**\\\\H**<br>
**\\\\h**

*# uživatelské jméno přihlášeného uživatele*<br>
**\\\\u**

*# cesta/název aktuálního adresáře (bez zkracování znakem „~“)*<br>
**\\$(pwd)**<br>
**\\$(basename \\$(pwd))**

*# znak „$“ pro všechny (i pro uživatele root)*<br>
**\\\\044\\\\[\\\\]**
<!--
Poznámka: závorky \[\] v předchozím zaklínadle nejsou nezbytné, ale bez nich
se někdy příkaz nezpracuje správně, např. „PS1="\\044a"“ nevypíše očekávanou
výzvu „$a“, zatímco „PS1="\\044\\[\\]a"“ ano.
-->

## Zaklínadla (příklady)

*# příkazy psát červeně na zeleném pozadí, výpisy příkazů tyrkysově na fialové pozadí*<br>
**PS1="\\\\[$(bezp\_set setaf 1)$(bezp\_set setab 2)$(tput el)\\\\]\\\$&blank;" PS0="$(bezp\_set setaf 6)$(bezp\_set setab 5)$(tput el)"**


## Parametry příkazů

*# nastavit šablonu hlavní výzvy/připojit k ní další text (analogicky platí i pro ostatní výzvy)*<br>
**PS1="**{*text*}**"**<br>
**PS1+="**{*další text*}**"**

*Poznámka:* Aby mohl bash správně zformátovat výzvu, potřebuje předem znát počet tisknutých znaků na každém jejím řádku. Bohužel bash nerozumí escape sekvencím, proto mu musíte napovědět a tyto sekvence uzavřít do zvláštních závorek „\\[“ a „\\]“ (ve dvojitých uvozovkách se zadávají „\\\\[“ a „\\\\]“), které znamenají, že jejich obsah bash nemá při výpočtu šířky řádků vůbec zohledňovat.

## Jak získat nápovědu

* Přehled syntaxe pro proměnné PS0, PS1 a PS2 najdete v sekci „PROMPTING“ v manuálové stránce „bash“ (anglicky).
* Různé další tipy se dají najít v článku Bash/Prompt customization (anglicky, viz Odkazy).

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->

* Výchozí nastavení výzev se nachází v souboru „~/.bashrc“. Umístěním svých definic na konec tohoto souboru můžete výchozí nastavení přepsat. Změna se projeví při dalším spuštění bashe.
* Konstrukci proměnné PS1 je vhodné pro přehlednost rozdělit do více řádků, kdy první řádek bude přiřazení a na dalších použijete operátor += k připojení hodnoty ke stávající hodnotě.
* Nenechte vyhodnocovat příkazy „tput“ při každém vypisování výzvy, není-li to nutné. Je to zbytečné plýtvání systémovými zdroji; toto je špatně:<br>„PS1="\\\\[\\$(bezp\_set setaf 4)\\\\]\\\\w\\\\[\\$(tput sgr0)\\\\]'“<br>a toto je správně: „PS1="\\\\[$(bezp\_set setaf 4)\\\\]\\\\w\\\\[$(tput sgr0)\\\\]'“.
* Tip: Před zkoušením nastavování barev a titulku terminálu nanečisto si vypněte výzvu příkazem „PS1=""“. Výchozí výzva obsahuje escape sekvence, které by kolidovaly s těmi, které se snažíte zadat a rušily by jejich účinek.

## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti − ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

*# *<br>
**PS1="\\[$(tput bold)Tato výzva je zbytečně rozsáhlá, abych vám ukázal/a spoustu možností.$(tput sgr0)\\]\\n"**
**PS1="čas(pevný=$(date +%T)|proměnný=\\$(date +%T))"**

## Instalace na Ubuntu

Všechny použité součásti jsou základními nástroji přítomnými v každé instalaci Ubuntu.

## Odkazy

* [Wikipedie: ANSI escape kód](https://cs.wikipedia.org/wiki/ANSI\_escape\_k%C3%B3d)
* [Bash/Prompt customization](https://wiki.archlinux.org/index.php/Bash/Prompt\_customization) (anglicky)
* [Command tput](http://www.linuxcommand.org/lc3\_adv\_tput.php) (anglicky)
* [Wikipedie: ANSI escape code](https://en.wikipedia.org/wiki/ANSI\_escape\_code) (anglicky)
* [xterm-256 Color Chart](http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html) (anglicky)
* [Manuálová stránka: bash](http://manpages.ubuntu.com/manpages/bionic/en/man1/bash.1.html) (anglicky)
* [Video: Customizing Your Terminal \| Linux Terminal Beautification](https://www.youtube.com/watch?v=iaXQdyHRL8M)
* [Balíček Bionic: ncurses-bin](https://packages.ubuntu.com/bionic/ncurses-bin) (anglicky)
* [Video: Customize the Bash Prompt](https://www.youtube.com/watch?v=wOUYzKrGZaA)
* [Video: Customize &amp; Colorize Your Bash Prompt/Terminal](https://www.youtube.com/watch?v=C92eaq\_bZR8)
* [Video: Color Variables BASH Shell Script Linux Tutorial](https://www.youtube.com/watch?v=N8pdAvIwj28) (anglicky)
