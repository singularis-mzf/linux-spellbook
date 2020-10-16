<!--

Linux Kniha kouzel, kapitola Terminál
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

Původní název kapitoly: Barvy, titulek a výzva terminálu

-->
<!--
ÚKOLY:

Poznámky:

Zobrazit větev gitu - složité řešení:
$(git branch 2>/dev/null | gawk "/^\\* /{print \" (git:\" substr(\$0,3) \")\";}")
Jednoduché řešení:
__git_ps1

-->

# Terminál

!Štítky: {tematický okruh}{bash}{barvy}{Unicode}{emotikony}
!FixaceIkon: 1754
!ÚzkýRežim: ZAP

## Úvod

Tato kapitola pokrývá způsoby, kterými můžete učinit okno emulátoru terminálu
praktičtější, barevnější a méně jednotvárné, aniž byste musel/a opustit
příkazový interpret bash – v linuxu můžete nastavit barvu písma či pozadí, titulek,
výzvu intepretu, přidat emotikony či vypsat ozdobné nápisy.

Barva písma a pozadí se ve skutečnosti nastavuje vypsáním takzvaných *escape sekvencí*,
což jsou zvláštní řídicí sekvence bajtů, kterým daný terminál rozumí
a místo vypsání něčeho na obrazovku vykoná akci, která je v sekvenci zakódovaná.
Abychom se tyto sekvence nemuseli učit, používáme místo nich moderní příkaz „tput“,
který načte příslušnou sekvenci ze své databáze a vypíše ji na svůj standardní výstup.
Tento výstup můžeme buď uložit do proměnné pro pozdější použití, nebo vypsat
na terminál přímo. Uložení do souboru není vhodné, protože v jiném terminálu
by se mohla sekvence lišit.

Tato verze kapitoly se omezuje na sekvence široce podporované většinou
emulátorů terminálu. Kde není dostupná podpora v textovém režimu,
bude to zmíněno. Dále nepokrývá podporu šestnácti milionů barev.

## Definice

* **Výzva terminálu** (zkráceně „výzva“) je řetězec, který interpret příkazové řádky (v našem případě bash) vypisuje před, během nebo po přijetí příkazu od uživatele (tzn. v interaktivním režimu). V interpretu „bash“ se rozeznávají tři druhy výzvy a jejich šablony jsou uloženy v proměnných PS0, PS1 a PS2: **hlavní výzva** (PS1) značí, že bash očekává příkaz, **vedlejší výzva** (PS2) značí, že bash očekává pokračování příkazu na dalším řádku, **potvrzující výzva** (PS0) se vypisuje po přijetí příkazu a před zahájením jeho vykonávání.
* **Escape sekvence** je posloupnost ASCII znaků se zvláštním významem pro terminál, která začíná netisknutelným znakem „\\e“. V minulosti se tyto sekvence zapisovaly ručně a děsily nezkušené uživatele; dnes je však většinou můžeme pohodlně generovat moderním příkazem „tput“ a jejich děsivou úlohu zaujaly sekvence znaků Unicode.
* **Paleta** je (v této kapitole) pole barev, které daný terminál podporuje, *indexované od nuly*. Běžně se vyskytují pouze dvě palety: s 8 barvami a s 256 barvami, ačkoliv realizace konkrétních barev v těchto paletách se mohou v jednotlivých emulátorech mírně lišit (často jdou nastavit).
* **Emotikona** je znak kódování Unicode, který je obvykle reprezentován vícebarevným obrázkem se symbolickým významem.

!ÚzkýRežim: VYP

## Zaklínadla: obecná

### Titulek
*# nastavit **titulek** okna emulátoru terminálu*<br>
*// Poznámka: Protože ve výchozím nastavení nastavuje titulek terminálu výzva PS1, před jakýmkoliv experimentováním ji musíte vypnout nebo změnit (např. příkazem „PS=""“), jinak vám vaše nové nastavení hned přepíše, takže se vám bude zdát, že nefunguje.*<br>
**printf %s\\\\n "$TERM" \| egrep -isq "^(xterm|rxvt)" &amp;&amp; printf "\\\\e]2;%s\\\\a" "**{*nový titulek*}**"**

### Barvy

*# vypsat **vzorník palety** (barvy na pozadí)*<br>
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

*# **resetovat** všechny atributy písma a barev*<br>
**tput sgr0**

*# nastavit **barvu popředí/pozadí***<br>
*// Funkce „lkk\_bezp\_set“ použije ze svých argumentů první podporované číslo barvy. Není-li žádné z uvedených čísel podporováno, žádná barva se nanastaví. Při volání doporučuji jako první uvést číslo pro paletu s 256 barvami a jako druhé číslo náhradní barvy z osmibarevné palety.*<br>
^^**source &lt;(lkk \-\-funkce)**<br>
**lkk\_bezp\_set setaf** {*číslo-barvy*}...<br>
**lkk\_bezp\_set setab** {*číslo-barvy*}...

*# **ztmavit** text (jen zapnout)*<br>
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
^^**source &lt;(lkk \-\-funkce)**<br>
**lkk\_bezp\_set setab** {*číslo-barvy*} [{*náhradní-číslo-barvy*}]...**; tput clear; tput sgr0**

### Nastavení písma

*# **vypnout všechny atributy** písma a barev*<br>
**tput sgr0**

*# **tučné** písmo (jen zapnout)*<br>
**tput bold**

*# **kurzíva** (zapnout/vypnout)*<br>
**tput sitm**<br>
**tput ritm**

*# **podtržení** (zapnout/vypnout)*<br>
**tput smul**<br>
**tput rmul**

### Ozdoby (nápisy a matrix)

*# spustit simulaci „Matrixu“ (zelený spořič obrazovky/růžový spoříč obrazovky/interaktivní režim)*<br>
*// V interaktivním režimu program ukončíte klávesou „q“, další klávesové zkratky najdete v manuálové stránce. Rychlost je od 0 (nejrychlejší) po 9 (nejpomalejší).*<br>
**cmatrix -bs -C green** [**-u** {*rychlost*}]<br>
**cmatrix -b -C magenta** [**-u** {*rychlost*}]<br>
**cmatrix -b**

*# vypsat **nápis** ozdobným písmem (alternativy)*<br>
*// Pro český text s háčky a čárky se bohužel dobře hodí jen písma „ascii9“, „smmono9“ a „standard“; čárky zvládají i některá další; písmena anglické abecedy zvládají všechna. Z filtrů mohu doporučit „gay“ a „border“, méně „metal“, „180“ a „flip“.*<br>
**toilet -t -f** {*písmo-pro-toilet*} [**-F** {*filtr*}[**:**{*další-filtr*}]...] <nic>[**\-\-**]<nic> **"**{*nápis*}**"**<br>
{*zdroj*} **\| toilet -t -f** {*písmo-pro-toilet*} [**-F** {*filtr*}[**:**{*další-filtr*}]...]

*# vypsat seznam dostupných písem/filtrů/výstupních formátů pro „toilet“*<br>
**find /usr/share/figlet -maxdepth 1 -type f -printf %f\\\\n \| sed -nE 's/\\.(flf|tlf)$//;T;p' \| sort**<br>
**toilet -F list**<br>
**toilet -E list**

*# vypsat vzorník ozdobných nápisů různými písmy*<br>
**find /usr/share/figlet -maxdepth 1 -type f -printf %f\\\\n \| sed -nE 's/\\.(flf|tlf)$//;T;p' \| sort \| while read -r pismo; do printf %s:\\\\n "$pismo"; toilet -f "$pismo" \-\-gay -t \-\- "Žluťoučký kůň"; done** [**\| less -r**]

*# příklady ozdobných nápisů*<br>
**toilet -t -f slant -F gay "Formule 1"**<br>
**toilet -t -f standard -F gay:border "Žďár nad Sázavou"**<br>
**tput setaf 6; tput setab 4; tput bold; tput el; toilet -t -f standard -F border "Test"; tput sgr0; tput el**

### Zjistit údaje o terminálu

Zde uvedené příkazy nevypisují escape sekvence, ale konkrétní hodnoty.

*# počet sloupců/řádků terminálu*<br>
**tput cols** ⊨ 98<br>
**tput lines** ⊨ 30

*# počet podporovaných barev (velikost palety)*<br>
**tput colors** ⊨ 256

*# aktuální sloupec/řádka kurzoru/obojí do proměnných $Y (řádek) a $X (sloupec)*<br>
**read -rsd R -p $'\\e[6n' &lt;/dev/tty &amp;&amp; printf %s\\\\n $\(\($(printf %s\\\\n "$REPLY" \| sed -E 's/.\*\\[([0-9]+);([0-9]+)/\\1/') - 1\)\)**<br>
**read -rsd R -p $'\\e[6n' &lt;/dev/tty &amp;&amp; printf %s\\\\n $\(\($(printf %s\\\\n "$REPLY" \| sed -E 's/.\*\\[([0-9]+);([0-9]+)/\\2/') - 1\)\)**<br>
**read -rsd R -p $'\\e[6n' &lt;/dev/tty &amp;&amp; eval "$(printf %s\\\\n "$REPLY" \| sed -E 's/.\*\\[([0-9]+);([0-9]+)/Y=$\(\(\\1-1\)\);X=$\(\(\\2-1\)\);/')"**

### Ovládání kurzoru

*# **uložit/obnovit** pozici kurzoru*<br>
**tput sc**<br>
**tput rc**

*# posun kurzoru **na pozici***<br>
*// Řádky a sloupce jsou číslovány od nuly od levého horního rohu terminálu.*<br>
**tput cup** {*číslo-řádku*} {*číslo-sloupce*}

*# posun kurzoru nahoru/dolů/vlevo/vpravo*<br>
**tput cuu** {*posun*}<br>
**tput cud** {*posun*}<br>
**tput cub** {*posun*}<br>
**tput cuf** {*posun*}

*# posun kurzoru **do určitého sloupce** na aktuální řádce/na začátek řádku*<br>
**tput hpa** {*index-sloupce*}<br>
**tput hpa 0**

*# posun kurzoru do levého horního rohu/levého dolního rohu*<br>
**tput home**<br>
**tput cup $(tput lines) 0**

*# skrytí kurzoru/zrušení skrytí*<br>
**tput civis**<br>
**tput cnorm**

### Mazání obrazovky

*# smazat **část řádky** od kurzoru vlevo/vpravo*<br>
**tput el1**<br>
**tput el**

*# smazat **celou obrazovku** a kurzor přesunout na pozici 0 0 (levý horní roh)*<br>
**tput clear**

*# odstranit N řádků od aktuální řádky (včetně) dolů*<br>
?

## Zaklínadla: PS0, PS1 a PS2

Poznámka: znění zaklínadel v této sekci je upraveno pro uvedení uvnitř dvojitých uvozovek. Při uvedení jiným způsobem (např. v jednoduchých uvozovkách nebo při načítání ze souboru) je tomu nutno uzpůsobit umístění zpětných lomítek.

### Častá
*# **znak $** pro normálního uživatele a # pro uživatele „root“*<br>
**\\\\\\$** ⊨ $

*# provedení příkazu a vypsání jeho výstupu (vyhodnotit hned/vyhodnotit při každém vypsání dané výzvy)*<br>
*// U druhé varianty (vyhodnotit při každém vypsání výzvy) musíte v příkazu odzvláštnit znaky ", \\, $ a !, aby se do příslušné proměnné uložil přesně tak, jak má být vykonán.*<br>
**$(**{*příkaz*}**)**<br>
**\\$(**{*příkaz*}**)**

*# **návratový kód** posledního příkazu (viz poznámka!)*<br>
*// Poznámka: Aby tento výraz fungoval, musíte do proměnné PROMPT\_COMMAND (ideálně na začátek) přidat příkaz „navr\_hodn=$?“, např. příkazem „PROMPT\_COMMAND="navr\_hodn=\\$?;$PROMPT\_COMMAND"“.*<br>
**\\${navr\_hodn}** ⊨ 0

*# cesta/název **aktuálního adresáře** (v obou případech se domovský adresář nahrazuje znakem „~“)*<br>
**\\\\w** ⊨ ~/Dokumenty<br>
**\\\\W** ⊨ Dokumenty

*# aktuální **čas** ve formátu HH:MM/HH:MM:SS*<br>
**\\\\A** ⊨ 15:35<br>
**\\\\t** ⊨ 15:35:38

*# aktuální **datum** ve formátu YYYY-MM-DD/ve vlastním formátu*<br>
*// Pro popis vlastního formátu viz „man strftime“ nebo kapitolu „Datum, čas a kalendář“.*<br>
**\\\\D{%F}** ⊨ 2020-01-29<br>
**\\\\D\{**{*formát*}**\}**

*# **název počítače** (úplný/jen do první „.“)*<br>
**\\\\H** ⊨ mars.podnik<br>
**\\\\h** ⊨ mars

*# konec řádku/tabulátor*<br>
**\\\\n**<br>
**$(printf \\\\t)**

*# **hodnota proměnné** při každém vypsání výzvy*<br>
**\\\\\\$\{**{*název proměnné*}**\}**

*# **uživatelské jméno** přihlášeného uživatele/jeho celé jméno*<br>
**\\\\u** ⊨ novakova<br>
**$(getent passwd $UID \| cut -d : -f 5 \| cut -d , -f 1)** ⊨ Jarmila Nováková

### Méně častá

*# **číslo příkazu** (podle historie/pořadové)*<br>
**\\\\!""** ⊨ 1984<br>
**\\\\\#** ⊨ 9

*# označení **terminálu** (alternativy)*<br>
**\\\\l** ⊨ 3 (pro textovou konzoli např. „tty3“)<br>
**$(ps h -o tty:1 -p \$\$)** ⊨ pts/3 (pro textovou konzoli např. „tty3“)

*# **PID** příkazového interpretu*<br>
**\\${\\$}** ⊨ 3338

*# počet úloh běžících na pozadí (těch, které lze vypsat příkazem „jobs“)*<br>
**\\\\j** ⊨ 0

*# počet řádek/sloupců terminálu*<br>
**\\${LINES}**<br>
**\\${COLUMNS}**

*# cesta/název aktuálního adresáře (bez zkracování znakem „~“)*<br>
**\\$(pwd)** ⊨ /home/novakova/Dokumenty<br>
**\\$(basename \\$(pwd))** ⊨ Dokumenty

*# znak „$“ pro všechny (i pro uživatele root)*<br>
**\\$(printf \\$)** ⊨ $
<!--
Další možnost: \\044\\[\\]
-->

## Zaklínadla: Vybrané emotikony

### Elektronika

*# disketa (symbol „uložit“)*<br>
[**printf**] **$'\\U0001f4be**[**\\u200b**]**'**

*# optický disk (stříbrný/zlatý)*<br>
[**printf**] **$'\\U0001f4bf**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f4c0**[**\\u200b**]**'**

*# fotoaparát*<br>
[**printf**] **$'\\U0001f4f7**[**\\u200b**]**'**

*# videokamera*<br>
*// Vyžaduje světlé pozadí.*<br>
[**printf**] **$'\\U0001f3a5**[**\\u200b**]**'**

*# budík*<br>
[**printf**] **$'\\U000023f0**[**\\u200b**]**'**

*# satelitní anténa*<br>
[**printf**] **$'\\U0001f4e1**[**\\u200b**]**'**

*# žárovka*<br>
[**printf**] **$'\\U0001f4a1**[**\\u200b**]**'**

### Zvířata

*# králík (tvář)*<br>
[**printf**] **$'\\U0001f430**[**\\u200b**]**'**

*# prase (tvář)*<br>
[**printf**] **$'\\U0001f437**[**\\u200b**]**'**

*# žába (tvář)*<br>
[**printf**] **$'\\U0001f438**[**\\u200b**]**'**

*# tučňák*<br>
*// Vhodný spíše na světlé pozadí.*<br>
[**printf**] **$'\\U0001f427**[**\\u200b**]**'**

*# pták*<br>
[**printf**] **$'\\U0001f426**[**\\u200b**]**'**

*# kuře*<br>
[**printf**] **$'\\U0001f424**[**\\u200b**]**'**

*# kůň/jednorožec*<br>
[**printf**] **$'\\U0001f434**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f984**[**\\u200b**]**'**

*# slon*<br>
[**printf**] **$'\\U0001f418**[**\\u200b**]**'**

*# myš*<br>
[**printf**] **$'\\U0001f401**[**\\u200b**]**'**

*# nosorožec*<br>
[**printf**] **$'\\U0001f98f**[**\\u200b**]**'**

### Rostliny (včetně květin) a houby

*# kaktus*<br>
[**printf**] **$'\\U0001f335**[**\\u200b**]**'**

*# vánoční stromeček*<br>
[**printf**] **$'\\U0001f384**[**\\u200b**]**'**

*# strom (jehličnatý/listnatý/palma)*<br>
[**printf**] **$'\\U0001f332**[**\\u200b**]**'**<br>
?<br>
[**printf**] **$'\\U0001f334**[**\\u200b**]**'**

*# slunečnice*<br>
[**printf**] **$'\\U0001f33b**[**\\u200b**]**'**

*# tulipán*<br>
[**printf**] **$'\\U0001f337**[**\\u200b**]**'**

*# heřmánek (květ)*<br>
[**printf**] **$'\\U0001f33c**[**\\u200b**]**'**
<!--
Testováno na fontu noto...
-->

*# muchomůrka*<br>
[**printf**] **$'\\U0001f344**[**\\u200b**]**'**

*# vykotlaná dýně na Halloween*<br>
[**printf**] **$'\\U0001f383**[**\\u200b**]**'**

### Ovoce a zelenina, plody

*# jablko (červené/zelené)*<br>
[**printf**] **$'\\U0001f34e**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f34f**[**\\u200b**]**'**

*# třešně*<br>
[**printf**] **$'\\U0001f352**[**\\u200b**]**'**

*# jahoda*<br>
[**printf**] **$'\\U0001f353**[**\\u200b**]**'**

*# rajče*<br>
[**printf**] **$'\\U0001f345**[**\\u200b**]**'**

*# banán*<br>
[**printf**] **$'\\U0001f34c**[**\\u200b**]**'**

*# pomeranč*<br>
[**printf**] **$'\\U0001f34a**[**\\u200b**]**'**

*# citrón*<br>
[**printf**] **$'\\U0001f34b**[**\\u200b**]**'**

*# hruška*<br>
[**printf**] **$'\\U0001f350**[**\\u200b**]**'**

*# broskev*<br>
[**printf**] **$'\\U0001f351**[**\\u200b**]**'**

*# ananas*<br>
[**printf**] **$'\\U0001f34d**[**\\u200b**]**'**

*# meloun (rozkrojený/malý)*<br>
[**printf**] **$'\\U0001f349**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f348**[**\\u200b**]**'**

*# hroznové víno (tmavé)*<br>
[**printf**] **$'\\U0001f347**[**\\u200b**]**'**

*# kukuřice*<br>
[**printf**] **$'\\U0001f33d**[**\\u200b**]**'**

*# kaštan*<br>
[**printf**] **$'\\U0001f330**[**\\u200b**]**'**

*# lilek*<br>
[**printf**] **$'\\U0001f346**[**\\u200b**]**'**

*# feferonka (pálivá paprika)*<br>
[**printf**] **$'\\U0001f336**[**\\u200b**]**'**

*# mrkev*<br>
[**printf**] **$'\\U0001f955**[**\\u200b**]**'**

*# brambora*<br>
[**printf**] **$'\\U0001f954**[**\\u200b**]**'**

*# avokádo*<br>
[**printf**] **$'\\U0001f951**[**\\u200b**]**'**


### Znamení zvěrokruhu
*# všechna (**vzorník**)*<br>
**printf $'\\u2648\\u2649\\u264a\\u264b\\u264c\\u264d\\u264e\\u264f\\u2650\\u2651\\u2652\\u2653\\n'**

*# beran*<br>
[**printf**] **$'\\u2648**[**\\u200b**]**'**

*# býk*<br>
[**printf**] **$'\\u2649**[**\\u200b**]**'**

*# blíženci*<br>
[**printf**] **$'\\u264a**[**\\u200b**]**'**

*# rak*<br>
[**printf**] **$'\\u264b**[**\\u200b**]**'**

*# lev*<br>
[**printf**] **$'\\u264c**[**\\u200b**]**'**

*# panna*<br>
[**printf**] **$'\\u264d**[**\\u200b**]**'**

*# váhy*<br>
[**printf**] **$'\\u264e**[**\\u200b**]**'**

*# štír*<br>
[**printf**] **$'\\u264f**[**\\u200b**]**'**

*# střelec*<br>
[**printf**] **$'\\u2650**[**\\u200b**]**'**

*# kozoroh*<br>
[**printf**] **$'\\u2651**[**\\u200b**]**'**

*# vodnář*<br>
[**printf**] **$'\\u2652**[**\\u200b**]**'**

*# ryby*<br>
[**printf**] **$'\\u2653**[**\\u200b**]**'**

### Smajíci (tvářičky)

*# úsměv (otevřená/zavřená ústa/zavřená ústa, tvář vzhůru nohama)*<br>
[**printf**] **$'\\U0001f600**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f642**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f643**[**\\u200b**]**'**

*# úsměv, sluneční brýle*<br>
[**printf**] **$'\\U0001f60e**[**\\u200b**]**'**

*# červená tvář (hněv)*<br>
[**printf**] **$'\\U0001f621**[**\\u200b**]**'**

*# vyděšená tvář*<br>
[**printf**] **$'\\U0001f631**[**\\u200b**]**'**

*# tvář s rouškou*<br>
[**printf**] **$'\\U0001f637**[**\\u200b**]**'**

*# lebka*<br>
[**printf**] **$'\\U0001f480**[**\\u200b**]**'**

*# mimozemšťan*<br>
[**printf**] **$'\\U0001f47d**[**\\u200b**]**'**

### Počasí a obloha

*# duha*<br>
[**printf**] **$'\\U0001f308**[**\\u200b**]**'**

*# měsíc (úplněk/nov)*<br>
[**printf**] **$'\\U0001f315**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f311**[**\\u200b**]**'**

*# měsíc couvající (fáze 1/2/3)*<br>
[**printf**] **$'\\U0001f316**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f317**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f318**[**\\u200b**]**'**

*# měsíc dorůstající (fáze 1/2/3)*<br>
[**printf**] **$'\\U0001f312**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f313**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f314**[**\\u200b**]**'**

*# blesk (symbol vysokého napětí)*<br>
[**printf**] **$'\\U000026a1**[**\\u200b**]**'**

### Symboly

*# symbol spánku*<br>
[**printf**] **$'\\U0001f4a4**[**\\u200b**]**'**

*# symbol polibku*<br>
[**printf**] **$'\\U0001f48b**[**\\u200b**]**'**

*# symbol řetězu (symbolický odkaz?)*<br>
[**printf**] **$'\\U0001f517**[**\\u200b**]**'**

*# symbol „poznámky“*<br>
[**printf**] **$'\\U0001f4dd**[**\\u200b**]**'**

*# symbol srdce (červený/fialový/modrý/zelený/žlutý)*<br>
?<br>
[**printf**] **$'\\U0001f49c**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f499**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f49a**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f49b**[**\\u200b**]**'**

*# symbol WC*<br>
[**printf**] **$'\\U0001f6be**[**\\u200b**]**'**

*# symbol zvonku*<br>
[**printf**] **$'\\U0001f514**[**\\u200b**]**'**

### Části těla

*# oči*<br>
[**printf**] **$'\\U0001f440**[**\\u200b**]**'**

*# palec nahoru/dolů*<br>
[**printf**] **$'\\U0001f44d**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f44e**[**\\u200b**]**'**

### Ostatní

*# lupa (vlevo/vpravo)*<br>
[**printf**] **$'\\U0001f50d**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f50e**[**\\u200b**]**'**

*# složka (otevřená/zavřená)*<br>
[**printf**] **$'\\U0001f4c2**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f4c1**[**\\u200b**]**'**

*# balíček*<br>
[**printf**] **$'\\U0001f4e6**[**\\u200b**]**'**

*# kniha (zelená/modrá/oranžová/nedefinované barvy)*<br>
[**printf**] **$'\\U0001f4d7**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f4d8**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f4d9**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0001f4d3**[**\\u200b**]**'**

*# zámek (zamykací)*<br>
[**printf**] **$'\\U0001f512**[**\\u200b**]**'**

*# hvězda (žlutá)*<br>
[**printf**] **$'\\U0002b50**[**\\u200b**]**'**

*# přesýpací hodiny (běžící/stojící)*<br>
[**printf**] **$'\\U000023f3**[**\\u200b**]**'**<br>
[**printf**] **$'\\U0000231b**[**\\u200b**]**'**

*# odpadkový koš*<br>
[**printf**] **$'\\U0001f5d1**[**\\u200b**]**'**

*# klíč*<br>
[**printf**] **$'\\U0001f511**[**\\u200b**]**'**

*# drahokam*<br>
[**printf**] **$'\\U0001f48e**[**\\u200b**]**'**

*# **zákaz** (zákaz vjezdu do jednosměrné ulice)*<br>
[**printf**] **$'\\U00026d4**[**\\u200b**]**'**

## Zaklínadla: Příklady

*# návratová hodnota, čas, aktuální adresář a dolar*<br>
^^**source &lt;(lkk \-\-funkce)**<br>
**PROMPT\_COMMAND="navr\_hodn=\\$?"**<br>
**PS1="$(lkk\_pstput sgr0)\\$navr\_hodn $(lkk\_pstput setaf 6)\\A "**<br>
**PS1+="$(lkk\_pstput sgr0; lkk\_pstput bold; lkk\_pstput setaf 2)\\w$(lkk\_pstput sgr0)\\\\\\$&blank;"**

*# vedlejší výzva: zelené svislítko*<br>
^^**source &lt;(lkk \-\-funkce)**<br>
**PS2="\\\\[$(lkk\_bezp\_set setaf 2)\\\\]\|$(lkk\_pstput sgr0)&blank;"**

*# příkazy psát červeně na zeleném pozadí, výpisy příkazů tyrkysově na fialové pozadí*<br>
^^**source &lt;(lkk \-\-funkce)**<br>
**PS1="\\\\[$(lkk\_bezp\_set setaf 1; lkk\_bezp\_set setab 2; tput el)\\\\]\\\$&blank;"**<br>
**PS0="$(lkk\_bezp\_set setaf 6; lkk\_bezp\_set setab 5; tput el)"**


## Parametry příkazů

*# nastavit šablonu hlavní výzvy/připojit k ní další text (analogicky platí i pro ostatní výzvy)*<br>
**PS1="**{*text*}**"**<br>
**PS1+="**{*další text*}**"**

*Důležitá poznámka:* Aby mohl bash správně zformátovat hlavní a vedlejší výzvu (PS1 a PS2), potřebuje předem znát počet tisknutých znaků na každém řádku. Bohužel bash nerozumí escape sekvencím, proto mu musíte napovědět a tyto sekvence uzavřít do zvláštních závorek „\\[“ a „\\]“ (ve dvojitých uvozovkách se zadávají „\\\\[“ a „\\\\]“), které znamenají, že jejich obsah bash nemá při výpočtu šířky řádků vůbec zohledňovat. Tyto závorky se bohužel naopak nesmějí používat v proměnné PS0, tam by vypsaly škaredé paznaky na terminál. V ukázce a v některých zaklínadlech lze tento problém vyřešit tak, že místo přímého zadání příkazu tput použijete pomocnou funkci lkk\_pstput.

*Poznámka k emotikonám:* Při použití emotikon ve výzvách PS1 a PS2 je vhodné za ně zařadit znak „\\u200b“ (mezera nulové šířky), protože většina emotikon zabírá v emulátoru terminálu dva textové sloupce a bash by jinak chybně odhadl délku dané řádky výzvy. Pokud použijete emotikonu, která zabírá tři sloupce, použijte mezery nulové šířky dvě; pokud emotikona zabírá jen jeden sloupec, nevkládejte žádnou.

## Instalace na Ubuntu

Pokud chcete použít emotikony, aby v terminálu vypadaly dobře, musíte nainstalovat
jedno z emotikonových písem, jinak se zobrazí nevzhledně a černobíle:

*# (alternativy)*<br>
**sudo apt-get install fonts-noto-color-emoji**<br>
**sudo apt-get install fonts-emojione**

Příkaz cmatrix, pokud ho potřebujete, je nutno doinstalovat:

**sudo apt-get install cmatrix**

Pokud potřebujete příkaz „toilet“, vždy ho instalujte v kombinaci s balíčkem „figlet“, který obsahuje potřebná písma:

**sudo apt-get install toilet figlet**

## Ukázka
*# *<br>
**source &lt;(lkk \-\-funkce)**<br>
**PROMPT\_COMMAND="navr\_hodn=\\$?;$PROMPT\_COMMAND"**<br>
**PS1="$(printf $'\\U0001f4d7\\u200b')\\\\[$(lkk\_bezp\_set setab 65 2)\\\\]$(printf $'\\U0001f427\\u200b'; lkk\_pstput sgr0; printf $'\\U0001f4d7\\u200b') "**<br>
**PS1+="\\\\[$(printf %s\\\\n "$TERM" \| egrep -isq "^(xterm|rxvt)" &amp;&amp; printf "\\\\e]2;%s\\\\a" "Bude příkaz č. \\\\#")\\\\]"**<br>
**PS1+="Tato $(lkk\_pstput smul)výzva je $(lkk\_pstput sitm)zbytečně$(lkk\_pstput rmul) rozsáhlá, aby ukázala $(lkk\_pstput bold)spoustu$(lkk\_pstput sgr0) možností.\\\\n"**<br>
**PS1+="$(lkk\_pstput dim)Velikost terminálu: \\$(tput cols)x\\$(tput lines) Volné místo: $(lkk\_pstput smul)\\$(df -h \-\-output=avail . \| tail -n 1 \| tr -d \\" \\")$(lkk\_pstput sgr0)\\\\n"**<br>
**PS1+="Návr.kód:\\\\[\\$(lkk\_barvapronh \\${navr\_hodn})\\\\]\\${navr\_hodn}$(lkk\_pstput sgr0)&blank;(\\\\[$(lkk\_bezp\_set setaf 87 6)\\\\]\\\\t$(lkk\_pstput sgr0)) !""\\\\!&blank;"**<br>
**PS1+="\\\\[$(lkk\_bezp\_set setaf 220 3; tput bold)\\\\]\\\\w$(lkk\_pstput sgr0)&blank;\\\\$&blank;"**<br>
**PS2="\\\\[$(lkk\_bezp\_set setaf 10 2; tput bold)\\\\]\|&blank;$(lkk\_pstput sgr0)"**

!ÚzkýRežim: zap

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->

* Výchozí nastavení výzev se nachází v souboru „~/.bashrc“. Umístěním svých definic na konec tohoto souboru můžete výchozí nastavení přepsat. Změna se projeví při dalším spuštění bashe.
* Konstrukci proměnné PS1 je vhodné pro přehlednost rozdělit do více řádek, kdy první řádka bude přiřazení a na dalších použijete operátor += k připojení hodnoty ke stávající hodnotě.
* Tip: Před zkoušením nastavování barev a titulku terminálu si vypněte výzvu příkazem „PS1=""“. Výchozí výzva obsahuje escape sekvence, které by kolidovaly s těmi, které se snažíte zadat a rušily by jejich účinek.
* Bash podporuje proměnnou „PROMPT\_COMMAND“. Je-li nastavena, je vykonána jako příkaz těsně před vypsáním hlavní výzvy. Toho lze využít k nastavení proměnných, které pak ve výzvě použijeme. Proměnná PROMPT\_COMMAND může obsahovat i více příkazů oddělených středníky. Podle manuálové stránky by příkazy uvedené v této proměnné neměly generovat žádný výstup na terminál! (Ale výstup do souboru je pravděpodobně v pořádku.)
* Emotikony fungují pouze v emulátorech terminálu v grafickém prostředí; v textové konzoli se místo nich zobrazí jednobarevné kosočtverce, při připojení přes SSH jsem je nezkoušel/a.

## Další zdroje informací

Přehled syntaxe pro proměnné PS0, PS1 a PS2 najdete v sekci „PROMPTING“ v manuálové stránce „bash“ (anglicky).

Různé další tipy se dají najít v článku Bash/Prompt customization (anglicky).

* [Wikipedie: ANSI escape kód](https://cs.wikipedia.org/wiki/ANSI\_escape\_k%C3%B3d)
* [Bash/Prompt customization](https://wiki.archlinux.org/index.php/Bash/Prompt\_customization) (anglicky)
* [Command tput](http://www.linuxcommand.org/lc3\_adv\_tput.php) (anglicky)
* [Wikipedie: ANSI escape code](https://en.wikipedia.org/wiki/ANSI\_escape\_code) (anglicky)
* [xterm-256 Color Chart](http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html) (anglicky)
* [Unicode Full Emoji List](http://unicode.org/emoji/charts/full-emoji-list.html) (anglicky)
* [Manuálová stránka: bash](http://manpages.ubuntu.com/manpages/focal/en/man1/bash.1.html) (anglicky)
* [Video: Customizing Your Terminal \| Linux Terminal Beautification](https://www.youtube.com/watch?v=iaXQdyHRL8M)
* [Oficiální příručka příkazu tput](https://www.gnu.org/software/termutils/manual/termutils-2.0/html\_chapter/tput\_1.html) (anglicky)
* [Balíček: ncurses-bin](https://packages.ubuntu.com/focal/ncurses-bin) (anglicky)
* [Video: Customize the Bash Prompt](https://www.youtube.com/watch?v=wOUYzKrGZaA) (anglicky)
* [Video: Customize &amp; Colorize Your Bash Prompt/Terminal](https://www.youtube.com/watch?v=C92eaq\_bZR8) (anglicky)
* [Video: Color Variables BASH Shell Script Linux Tutorial](https://www.youtube.com/watch?v=N8pdAvIwj28) (anglicky)
* [Video: How to Install Emojis on Linux](https://lbry.tv/@christitustech:5/how-to-install-emojis-on-linux:7) (anglicky)

!ÚzkýRežim: vyp

## Pomocné funkce

*# lkk\_bezp\_set() – nastaví písmo či pozadí na první podporovanou barvu*<br>
**function lkk\_bezp\_set () \{**<br>
<odsadit1>**local f="$1" c="$(tput colors 2&gt;/dev/null \|\| printf 0)" x=""**<br>
<odsadit1>**shift**<br>
<odsadit1>**for x in $@; do if test $x -lt $c; then tput $f $x; break; fi; done**<br>
<odsadit1>**return 0**<br>
**\}**

*# lkk\_barvapronh() – nastaví barvu písma podle hodnoty parametru*<br>
**function lkk\_barvapronh () \{**<br>
<odsadit1>**test $1 -gt 0 &amp;&amp; tput bold**<br>
<odsadit1>**test $1 -eq 1 &amp;&amp; lkk\_bezp\_set setaf 1**<br>
<odsadit1>**test $1 -gt 1 &amp;&amp; lkk\_bezp\_set setaf 2**<br>
**\}**

*# lkk\_pstput() – vypíše escape sekvenci uzavřenou pro použití v proměnných PS1 a PS2*<br>
**function lkk\_pstput () \{**<br>
<odsadit1>**printf \\\\[; tput "$@" &amp;&amp; printf \\\\]**<br>
**\}**
