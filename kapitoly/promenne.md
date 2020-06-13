<!--

Linux Kniha kouzel, kapitola Proměnné prostředí a interpretu
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

⊨
☐
○ ◉


[ ] Přednastavování proměnných prostředí (.profile, /etc/environment apod.)
[ ] Pattern matching (možná spíš do jiné kapitoly): https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html#Pattern-Matching
[ ] Proměnné jen pro čtení (a další atributy „declare“).
[ ] Zvláštní proměnné interpretu?

-->

# Proměnné prostředí a interpretu

!Štítky: {tematický okruh}{bash}{systém}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola pokrývá veškerou práci s proměnnými prostředí v Linuxu
a dále také veškerou práci s proměnnými a funkcemi interpretu Bash.
Rovněž uvádí některé důležité proměnné prostředí, kterými lze ovlivnit funkci programů
a systému, a pokrývá také práci s parametry skriptů a funkcí v Bashi.

<!--
- Obecně popište základní principy, na kterých fungují používané nástroje.
?
-->

Tato verze kapitoly nepokrývá proměnné interpretu bash, které řídí jeho funkci,
ale normálně nejsou proměnnými prostředí a nešíří se do nově vytvořených procesů.
Do této kapitoly nespadají takzvané zvláštní parametry (jako např. $?, $! apod.).

## Definice

* **Prostředí** je soubor pojmenovaných textových proměnných, který má v Linuxu každý proces. Prostředí nového procesu většinou vzniká jako kopie prostředí rodičovského procesu. Je-li proces spuštěn příkazem „exec“, nově spuštěný program převezme prostředí bashe beze změny.
* **Proměnná prostředí** je jedna z proměnných v prostředí (např. „HOME“). Názvy proměnných prostředí se obvykle zapisují velkými písmeny.
* **Proměnná interpretu** je proměnná vytvořená interpretem Bash (popř. jiným) za účelem použití ve funkcích a skriptech. Může být **řetězcová**, **pole** (indexované celými čísly od 0) či **asociativní pole** (indexované neprázdným řetězcem zvaným **klíč**). Proměnné interpretu nejsou přístupné z jiných procesů, nešíří se do nově spuštěných instancí a ukončením dané instance bashe zanikají, proto jsou vhodné i k ukládání hesel a jiných citlivých údajů.
* **Funkce** je v bashi krátký skript, který se ukládá stejným způsobem jako proměnná interpretu. Funkci lze zavolat zadáním jejího názvu jako příkazu a podobně jako skript má svoje poziční parametry.

<!--
* **Parametr skriptu** je prvek příkazové řádky, se kterým byl volán skript či funkce.
-->

Názvy proměnných a funkcí jsou obvykle tvořeny jen velkými a malými písmeny anglické abecedy, podtržítky a číslicemi, přičemž nesmí začínat číslicí.

Kde používám označení „proměnná“, platí to pro proměnné prostředí i interpretu bez rozdílu.

!ÚzkýRežim: vyp

## Zaklínadla: Bash


### Testy proměnných

*# jde o proměnnou?*<br>
**test -v** {*název\_proměnné*}

*# jde o proměnnou interpretu? (alternativy)*<br>
**[[ -v** {*název\_proměnné*} **&amp;&amp; $\{**{*název\_proměnné*}**@a} = \*([!x]) ]]**<br>
**[[ -v** {*název\_proměnné*} **&amp;&amp; $\{**{*název\_proměnné*}**@a} =~ ^[<nic>^x]\*$ ]]**<br>

*# jde o proměnnou prostředí?*<br>
**[[ $\{**{*název\_proměnné*}**@a} = \*x\* ]]**

*# jde o řetězcovou proměnnou (interpretu nebo prostředí) (alternativy)?*<br>
**[[ -v** {*název\_proměnné*} **&amp;&amp; $\{**{*název\_proměnné*}**@a} = \*([!aA]) ]]**<br>
**[[ -v** {*název\_proměnné*} **&amp;&amp; $\{**{*název\_proměnné*}**@a} =~ ^[<nic>^aA]\*$ ]]**<br>

*# jde o pole? (alternativy)*<br>
**[[ $\{**{*název\_proměnné*}**@a} = \*a\* ]]**<br>
**compgen -A arrayvar \| fgrep -qx** {*název\_proměnné*}

*# jde o asociativní pole?*<br>
**[[ $\{**{*název\_proměnné*}**@a} = \*A\* ]]**<br>

### Seznamy proměnných

*# seznam všech proměnných (s hodnotami pro člověka/bez hodnot)*<br>
**(set -o posix; set)**<br>
**compgen -v**

<!--
**promenzkum \| sed -zE 's/^(\\S+)&blank;\\S+&blank;/\\1=/' \| tr \\\\0 \\\\n**<br>
-->

*# seznam všech proměnných interpretu (s hodnotami/bez hodnot)*<br>
**promenzkum \| sed -znE '/^\\S+\\s+[<nic>^x]+\\s+\\S+$/{s/^(\\S+)&blank;\\S+&blank;/\\1=/;p}' \| tr \\\\0 \\\\n**<br>
**promenzkum \| sed -znE '/^\\S+\\s+[<nic>^x]+\\s+\\S+$/{s/.\*\\s//;p}' \| tr \\\\0 \\\\n**

*# seznam proměnných prostředí (s hodnotami/bez hodnot/s hodnotami ve formátu txtz)*<br>
**env -0 \| egrep -zv '^\_=' \| tr \\\\0 \\\\n**<br>
**compgen -e**<br>
**env -0 \| egrep -zv '^\_='**
<!--
Poznámka: příkaz „printenv“ z nějakého důvodu vypisuje kromě proměnných prostředí také
proměnnou „_“, ačkoliv tu ani jako proměnnou prostředí nastavit nelze.
-->

*# seznam řetězcových proměnných interpretu (s hodnotami/bez hodnot)*<br>
**promenzkum \| sed -znE '/^\\S+\\s+[<nic>^aAx]+\\s+\\S+$/{s/^(\\S+)&blank;\\S+&blank;/\\1=/;p}' \| tr \\\\0 \\\\n**<br>
**promenzkum \| sed -znE '/^\\S+\\s+[<nic>^aAx]+\\s+\\S+$/{s/\\s.\*//;p}' \| tr \\\\0 \\\\n**

*# seznam polí (bez hodnot)*<br>
**compgen -A arrayvar**

*# seznam asociativních polí (bez hodnot)*<br>
**promenzkum \| egrep -z '^\\S+&blank;\\S\*A\\S\*&blank;' \| cut -d '&blank;' -f 1 -z \| tr \\\\0 \\\\n**

### Řetězcové proměnné interpretu

*# přiřadit proměnné hodnotu*<br>
{*název\_proměnné*}**="**{*nová-hodnota*}**"**

*# připojit novou hodnotu na začátek/konec proměnné*<br>
{*název\_proměnné*}**="**{*nová-hodnota*}**$**{*název\_proměnné*}**"**<br>
{*název\_proměnné*}**+="**{*nová-hodnota*}**"**

*# zrušit proměnnou*<br>
*// Pozor! Příkaz „unset“ uspěje i tehdy, pokud daná proměnná neexistuje.*<br>
**unset -v** {*název\_proměnné*}

### Pole

*# **vytvořit** či přepsat/**zrušit**/vyprázdnit*<br>
*// Prvky pole se zadávají stejně jako parametry příkazu, tzn. oddělují se mezerami; obsahují-li zvláštní znaky, budou interpretovány, pokud je neodzvláštníte (vhodné je umístění do uvozovek či apostrofů).*<br>
{*název\_pole*}**=(**[{*prvky*}]...**)**
**unset** {*název\_pole*}<br>
{*název\_pole*}**=()**

*# **zkopírovat** (celé pole/výřez)*<br>
{*cílové\_pole*}**=("$\{**{*zdrojové\_pole*}**[@]}")**<br>
{*cílové\_pole*}**=("$\{**{*zdrojové\_pole*}**[@]:**{*první-kopírovaný-index*}[**:**{*maximální-počet*}]**}")**

*# zjistit **počet** prvků*<br>
**${#**{*názevpole*}**[@]}**

*# **přečíst** prvek na indexu N/**přiřadit** do něj*<br>
*// Je dovoleno přiřadit do prvku libovolně daleko za koncem pole; Bash v takovém případě pole automaticky prodlouží prázdnými řetězci, aby index byl platný.*<br>
**${**{*název\_pole*}**[**{*N*}**]**[**-**{*náhradní hodnota*}]**\}**<br>
{*název\_pole*}**[**{*N*}**]=**{*hodnota*}

*# **iterovat** přes prvky/přes indexy*<br>
**for** {*iterační\_proměnná*} **in "$\{**{*název\_pole*}**[@]}"; do** {*...*}**; done**<br>
**for** {*iterační\_proměnná*} **in "${!**{*název\_pole*}**[@]}"; do** {*...*}**; done**

*# **vložit** nový prvek na začátek/konec*<br>
{*název\_pole*}**=("**{*nový prvek*}**" "$\{**{*název\_pole*}**[@]}")**<br>
{*název\_pole*}**+=("**{*nový prvek*}**")**

*# **odstranit** N prvků na začátku/konci*<br>
{*název\_pole*}**=("${**{*názevpole*}**[@]:**{*N*}**\}")**
{*název\_pole*}**=("${**{*názevpole*}**[@]:0:$((${#**{*název\_pole*}**[@]}-**{*N*}**))}")**

*# přiřadit do pole parametry této instance bashe*<br>
{*cílové\_pole*}**=("$@")**

*# spojit dvě pole*<br>
{*cílové\_pole*}**=("$\{**{*první\_pole*}**[@]}" "$\{**{*druhé\_pole*}**[@]}")**

*# rozdělit pole na poloviny*<br>
{*první\_cíl*}**=("${**{*názevpole*}**[@]:0:$((${#**{*název\_pole*}**[@]}/2+1))}")**<br>
{*druhý\_cíl*}**=("${**{*názevpole*}**[@]:$((${#**{*název\_pole*}**[@]}/2+1))}")**

### Asociativní pole

<!--
https://www.artificialworlds.net/blog/2012/10/17/bash-associative-array-examples/
-->

Pozor! Klíčem v asociativním poli může být pouze neprázdný řetězec!
Prázdný klíč způsobí chybu „chybný podskript pole“.

*# **vytvořit** = vyprázdnit*<br>
**unset** {*název*}<br>
**declare -A** {*název*}

*# **zrušit***<br>
**unset -v** {*název*}

*# **přečíst** hodnotu prvku (klíč je řetězec/hodnota proměnné)*<br>
*// Tyto tvary uvádějte vždy ve dvojitých uvozovkách. Klíč se v tomto případě vyhodnocuje, jako by byl sám uvnitř samostatných dvojitých uvozovek, což umožňuje i vícenásobné vnoření této konstrukce, ačkoliv to je špatně čitelné.*<br>
[**"**{*...*}]**$\{**{*názevpole*}**["**{*klíč*}**"]\}**[{*...*}**"**]<br>
[**"**{*...*}]**$\{**{*názevpole*}**["$**{*klíč\_proměnná*}**"]\}**[{*...*}**"**]

*# **přiřadit** hodnotu prvku (klíč je: řetězec/hodnota proměnné)*<br>
*// Uvozovky kolem klíče slouží pouze k odzvláštnění znaků klíče, můžete je odzvláštnit i jinak, např. zpětným lomítkem či apostrofy.*<br>
{*názevpole*}**["**{*klíč*}**"]="**{*hodnota*}**"**<br>
{*názevpole*}**[$**{*klíč\_proměnná*}**]="**{*hodnota*}**"**

*# obsahuje prvek se zadaným klíčem? (alternativy)*<br>
**asocexist** {*názevpole*} **"**{*klíč*}**"**<br>
**test -v '**{*názevpole*}[**{*klíč*}**]**'**<br>
**test -v "**{*názevpole*}**[$\{**{*proměnná\_s\_klíčem*}**@Q}]"**

*# **iterovat** přes klíče/přes hodnoty*<br>
**for** {*iterační\_proměnná*} **in "${!**{*název\_pole*}**[@]}"; do** {*...*}**; done**<br>
**for** {*iterační\_proměnná*} **in "$\{**{*název\_pole*}**[@]}"; do** {*...*}**; done**

*# odstranit prvek podle klíče (klíč je hodnota proměnné)*<br>
**unset -v "**{*názevpole*}**[$\{**{*proměnná\_s\_klíčem*}**@Q}]"**

*# **odstranit** prvek podle klíče (klíč je řetězec)*<br>
**: "**{*klíč*}**"**<br>
**unset -v "**{*názevpole*}**[${\_@Q}]"**

*# zjistit **počet** prvků*<br>
**${#**{*název*}**[@]}**

*# **zkopírovat***<br>
**asockopirovat** {*zdrojovépole*} {*cílovépole*}

*# **sloučit** dvě asociativní pole*<br>
?

*# příklady: přiřadit do proměnné „x“ hodnotu z asociativního pole „a“, kde klíčem je: zpětné lomítko/dvě zpětná lomítka/apostrof/dvojitá uvozovka/„A B“/„} }“*<br>
**x="${a["\\\\"]}"**<br>
**x="${a["\\\\\\\\"]}"**<br>
**x="${a["'"]}"**<br>
**x="${a["\\""]}"**<br>
**x="${a["A B"]}"**<br>
**x="${a["} }"]}"**

### Funkce

*# **vytvořit**/přepsat funkci*<br>
*// Pokud je uzavírací závorka „}“ na stejném řádku jako poslední příkaz těla funkce, musí být od příkazu oddělená středníkem.*<br>
[**function**] {*název\_funkce*}**() \{**<br>
[{*tělo-funkce*}]<br>
**\}**

*# zavolat funkci*<br>
{*název\_funkce*} [{*parametry*}]...

*# **zrušit** funkci*<br>
**unset -f** {*název\_funkce*}

*# vypsat definici funkce*<br>
**declare -f** {*název\_funkce*}

*# existuje funkce?*<br>
**declare -f** {*název\_funkce*} **&gt;/dev/null**

*# seznam funkcí (s těly/bez těl)*<br>
**declare -f**<br>
**compgen -A function**

*# exportovat/neexportovat funkci*<br>
*// Exportované funkce se uloží do zvláštních proměnných prostředí a další instance bashe, která je tímto způsobem „zdědí“, je opět načte jako funkce. Doporučuji příliš nepoužívat, protože tak můžete snadno ztratit kontrolu nad tím, kam všude se vaše funkce dostanou.*<br>
**export -f** {*název\_funkce*}<br>
**export -fn** {*název\_funkce*}

### Pokročilé dosazování proměnných

*# dosadit hodnotu proměnné (alternativy)*<br>
**$**{*název\_proměnné*}
**$\{**{*název\_proměnné*}**\}**

*# dosadit hodnotu proměnné, jejíž název je v jiné proměnné*<br>
*// Tuto konstrukci lze skombinovat s většinou ostatních druhů dosazení.*<br>
**${!**{*název\_jiné\_proměnné*}[{*zbytek výrazu*}]**\}**

*# dosadit hodnotu proměnné, která musí být definovaná/neprázdná; jinak zobrazit chybové hlášení a ukončit skript*<br>
**$\{**{*název\_proměnné*}**?**[**"**]<nic>{*chybové hlášení*}]<nic>[**"**]**\}**<br>
**$\{**{*název\_proměnné*}**:?**[**"**]<nic>{*chybové hlášení*}]<nic>[**"**]**\}**

*# je-li proměnná definovaná/neprázdná, dosadit; jinak použít náhradní řetězec*<br>
*// Pokud má náhradní řetězec obsahovat zvláštní znaky či znak „}“, doporučuji uzavřít jej do dvojitých uvozovek. To funguje i tehdy, pokud je dosazovací výraz jako celek použit uvnitř dvojitých uvozovek.*<br>
**$\{**{*název\_proměnné*}**-**[**"**]{*náhradní řetězec*}[**"**]**\}**<br>
**$\{**{*název\_proměnné*}**:-**[**"**]{*náhradní řetězec*}[**"**]**\}**

*# je-li proměnná definovaná/neprázdná, dosadit; jinak jí přiřadit náhradní hodnotu a dosadit*<br>
**$\{**{*název\_proměnné*}**=**[**"**]{*náhradní řetězec*}[**"**]**\}**<br>
**$\{**{*název\_proměnné*}**:=**[**"**]{*náhradní řetězec*}[**"**]**\}**

*# dosadit náhradní řetězec, jen pokud je proměnná definovaná/neprázdná; jinak dosadit prázdný řetězec*<br>
**$\{**{*název\_proměnné*}**+**[**"**]{*náhradní řetězec*}[**"**]**\}**<br>
**$\{**{*název\_proměnné*}**:+**[**"**]{*náhradní řetězec*}[**"**]**\}**

*# dosadit **délku** hodnoty proměnné ve znacích*<br>
**${#**{*název\_proměnné*}**\}**

*# dosadit **podřetězec** hodnoty proměnné*<br>
*// Tip: kolem indexu a délku mohou být mezery, kolem názvu proměnné ne.*<br>
**$\{**{*název\_proměnné*}**:** {*index-prvního-znaku-od-0*} **:** {*maximální-délka*} **\}**

*# dosadit hodnotu proměnné po odebrání nejkratší/nejdelší shody začátku hodnoty se vzorkem*<br>
**$\{**{*název\_proměnné*}**#**{*vzorek*}**\}**<br>
**$\{**{*název\_proměnné*}**##**{*vzorek*}**\}**

*# dosadit hodnotu proměnné po odebrání nejkratší/nejdelší shody konce hodnoty se vzorkem*<br>
**$\{**{*název\_proměnné*}**%**{*vzorek*}**\}**<br>
**$\{**{*název\_proměnné*}**%%**{*vzorek*}**\}**

*# dosadit hodnotu proměnné po nahrazení první/všech shod se vzorkem náhradním řetězcem*<br>
**$\{**{*název\_proměnné*}**/**{*vzorek*}[**/**{*náhradní řetězec*}]**\}**<br>
**$\{**{*název\_proměnné*}**//**{*vzorek*}[**/**{*náhradní řetězec*}]**\}**

*# dosadit hodnotu proměnné velkými/malými písmeny*<br>
**$\{**{*název\_proměnné*}**^^}**<br>
**$\{**{*název\_proměnné*}**,,}**

*# dosadit názvy všech definovaných proměnných, které začínají určitou předponou*<br>
**${!**{*předpona*}**@}**

*# dosadit hodnotu proměnné s odzvláštněním*<br>
*// Hodnota bude typicky v apostrofech či konstrukci „$''“. Konkrétní tvar se může lišit, ale vždy bude možno ho bezpečně dosadit do skriptu.*<br>
**$\{**{*název\_proměnné*}**@Q}**<br>

*# interpretovat hodnotu jako by byla uvedena v konstrukci $'' a výsledek dosadit*<br>
**$\{**{*název\_proměnné*}**@E}**<br>

*# dosadit znaky reprezentující zapnuté atributy dané proměnné*<br>
**$\{**{*název\_proměnné*}**@a}**

*# dosadit příkaz bashe, který vytvoří danou proměnnou včetně atributů a hodnoty*<br>
**$\{**{*název\_proměnné*}**@A}**


<!--
[ ] Parametry skriptu $0, $1, $*, $@, ...
+ nastavit příkazem „set“
-->

### Dosazování parametrů skriptu

*# dosadit N-tý parametr skriptu (alternativy)*<br>
**$**{*číslice-N*}<br>
**$\{**{*N*}**\}**

*# dosadit všechny parametry od $1: do samostatných parametrů/jen oddělené mezerou*<br>
*// Dvojité uvozovky zde znamenají, že pro správnou funkci musí být tyto konstrukce použity ve dvoji.*<br>
**"$@"**<br>
**"$\*"**

*# dosadit úsek parametrů (samostatně/oddělené mezerou)*<br>
**"${@:** {*číslo-prvního-parametru*} [**:** {*maximální-počet*}] **\}"**<br>
**"${\*:** {*číslo-prvního-parametru*} [**:** {*maximální-počet*}] **\}"**

*# dosadit všechny parametry od $0 (samostatně/oddělené mezerou)*<br>
**"${@:0}"**<br>
**"${\*:0}"**

### Jmenné odkazy

*# vytvořit jmenný odkaz*<br>
*// Poznámka: jmenným odkazem nelze odkazovat na normální ani asociativní pole!*<br>
**declare -n** {*název\_odkazu*}**=**{*název\_odkazované\_proměnné*}

*# zrušit jmenný odkaz*<br>
**unset -n** {*název\_odkazu*}

*# je proměnná jmenný odkaz?*<br>
**test -R** {*název\_proměnné*}

*# přečíst jmenný odkaz*<br>
**if test -R** {*název\_odkazu*}**; then declare +n** {*název\_odkazu*}**; echo $**{*název\_odkazu*}**; declare -n** {*název\_odkazu*}**; else false; fi**
<!--
[ ] Vyzkoušet.
-->




## Zaklíndla: Proměnné prostředí

### Spouštění programů s upraveným prostředím

*# **spustit** s upraveným prostředím (jednodušší varianta)*<br>
[[**/usr/bin/**]**env**] {*PROMÉNNÁ*}**=**{*hodnota*} [{*DALŠÍ\_PROMÉNNÁ*}**=**{*další-hodnota*}]... {*příkaz*} [{*parametr*}]...

*# spustit v jiném aktuálním **adresáři***<br>
**env -C** {*cesta*} {*příkaz*} [{*parametr*}]...

*# spustit s upraveným prostředím (**komplexní** varianta)*<br>
*// -i prostředí zcela vyprázdní; \-\-unset z něj odebírá uvedené proměnné, přiřazení proměnné prostředí nastavuje a parametr „-C“ změní aktuální adresář.*<br>
[[**/usr/bin/**]**env**] <nic>[**-i**] <nic>[**\-\-unset=**{*PROMÉNNÁ*}]... [{*PROMÉNNÁ*}**=**{*hodnota*}]... [**-C** {*nový/aktuální/adresář*}] {*příkaz*} [{*parametr*}]...

### Základní operace

*# **přiřadit** proměnné hodnotu*<br>
{*název\_proměnné*}**="**{*nová-hodnota*}**"**

*# **připojit** novou hodnotu na začátek/konec proměnné*<br>
{*název\_proměnné*}**="**{*nová-hodnota*}**$**{*název\_proměnné*}**"**<br>
{*název\_proměnné*}**+="**{*nová-hodnota*}**"**

*# změnit proměnnou interpretu na proměnnou prostředí/naopak*<br>
**export** {*název\_proměnné*}[**=**{*nová-hodnota*}]<br>
**export -n** {*název\_proměnné*}...

*# **zrušit** proměnnou*<br>
*// Pozor! Příkaz „unset“ uspěje i tehdy, pokud daná proměnná neexistuje.*<br>
**unset -v** {*název\_proměnné*}...

### Předdefinované proměnné

*# absolutní cesta **domovského adresáře***<br>
**$HOME** ⊨ /home/petr

*# vyhledávací cesty externích příkazů*<br>
*// Cesty jsou odděleny. Bývají absolutní, ale mohou být i relativní. Zahrnout aktuální adresář „.“ je možné, ale z bezpečnostních důvodů se to striktně nedoporučuje.*<br>
**$PATH** ⊨ /home/petr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

*# označení příslušného grafického zobrazovacího rozhraní*<br>
**$DISPLAY** ⊨ :0.0

*# typ terminálu*<br>
*// Pro textovou konzoli je to „linux“. Další hodnoty, se kterými se lze setkat, jsou „xterm“ a „rxvt“.*<br>
**$TERM** ⊨ xterm-256color

*# typ sezení*<br>
*// Jde-li o X-server, hodnota je „x11“, pro Wayland je to „wayland“, v textové konzoli je to „tty“.*<br>
**$XDG\_SESSION\_TYPE** ⊨ x11

*# jazyk/lokalizace systému*<br>
**$LANGUAGE** ⊨ cs\_CZ<br>
**$LANG** ⊨ cs\_CZ.UTF-8

*# výchozí interpret příkazové řádky*<br>
**$SHELL** ⊨ /bin/bash

*# uživatelské jméno*<br>
*// Poznámka: proměnnou prostředí lze snadno podvrhnout. Pro bezpečné zjištění uživatelského jména použijte příkaz „id -un“.*<br>
**$USER** ⊨ petr

*# adresář pro dočasné soubory*<br>
**${TMPDIR-/tmp}**

### Proměnné ovládající programy a systém

*# vypnout lokalizaci a podporu Unicode*<br>
*// Tato volba se zapíná především při řazení, kdy způsobí, že soubor se seřadí podle kódových hodnot bajtů. Hodí se také pro dosažení vyššího výkonu některých skriptovacích nástrojů, ale tam je potřeba, aby uživatel věděl, co dělá.*<br>
**LC\_ALL=C**

*# vypnout lokalizaci, ale ponechat kódování UTF-8*<br>
**LC\_ALL=C.utf8**

*# preferovaná časová zóna*<br>
**TZ=UTC**<br>
**TZ=Europe/Prague**

*# nelokalizovat výpisy a hlášení*<br>
**LC\_MESSAGES=C.utf8**

*# požádat aplikaci o použití určitého dočasného adresáře*<br>
**TMPDIR=**{*/absolutní/cesta*}

### Preferované aplikace

Poznámka: proměnné prostředí EDITOR, VISUAL a PAGER se obvykle nastavují v souboru „~/.bashrc“.

*# výchozí textový editor (terminálový/grafický)*<br>
**EDITOR=/bin/nano**
**VISUAL=/usr/bin/gedit**

*# výchozí terminálový stránkovač*<br>
**PAGER=/usr/bin/less**

### Prostředí jiných procesů

*# **mohu** číst prostředí daného procesu?*<br>
**test -r /proc/**{*PID*}**/environ**

*# vypsat **seznam***<br>
**sed -zE 's/=.\*//' /proc/**{*PID*}**/environ \| tr \\\\0 \\\\n** [**\| sort**]

*# je proměnná **definovaná**/neprázdná?*<br>
**egrep -q '^**{*název\_proměnné*}**=' /proc/**{*PID*}**/environ**<br>
**egrep -q '^**{*název\_proměnné*}**=.' /proc/**{*PID*}**/environ**

*# **přečíst** hodnotu*<br>
**sed -znE 's/^**{*název\_proměnné*}**=//;T;p' /proc/**{*PID*}**/environ \| tr -d \\\\0**

### Proměnné pro programátory

*# cesty pro vyhledávání sdílených knihoven*<br>
*// Když spuštěný program požádá systém o nahrátí sdílené knihovny, systém ji obvykle vyhledává v několika standardních adresářích. Má-li však program v prostředí proměnnou „LD\_LIBRARY\_PATH“, systém nejprve prohledává adresáře uvedené zde. V každém případě nahraje první nalezenou knihovnu a případné další knihovny téhož jména ignoruje.*<br>
**LD\_LIBRARY\_PATH=**{*cesta*}[**:**{*další/cesta*}]...

*# vypsat ladicí informace ohledně sdílených knihoven*<br>
*// Nápovědu k proměnné LD\_DEBUG si můžete zobrazit příkazem „env LD\_DEBUG=help cat“. Bez proměnné LD\_DEBUG\_OUTPUT se ladicí údaje vypíšou na standardní výstup; s ní se k jejímu obsahu připojí tečka a PID procesu a výpis se provede do daného souboru.*<br>
**LD\_DEBUG=libs**[**,symbols**] <nic>[**LD\_DEBUG\_OUTPUT=**{*předpona/výstupní/cesty*}]
<!--
man 8 ld.so
-->

*# vynutit načtení funkcí ze zadané sdílené knihovny do aplikace (nezkoušeno, bez záruky).*<br>
**LD\_PRELOAD=/home/petr/moje.so**




## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Instalace na Ubuntu

Všechny použité nástroje jsou základní součástí Ubuntu, přítomné i v minimální instalaci.

## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

!ÚzkýRežim: zap

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

* Pokud potřebujete v asociativním poli použít jako klíč prázdný řetězec, pomůže upravit kód tak, aby před každý klíč vkládal konkrétní písmeno (např. „X“).
* Identifikátory proměnných, které mají řídicí či systémový význam (jako např. *HOME* či *PATH*) se obvykle píšou velkými písmeny, bez ohledu na to, zda jde o proměnné interpretu nebo prostředí. Identifikátory „obyčejných“ proměnných (různé dočasné a výpočetní hodnoty) ve skriptech pište malými.
* Znak ~ se v bashi rozvíjí na hodnotu „${HOME}“, proto ho uvnitř dvojitých uvozovek můžete snadno a bezpečně nahradit za „$HOME“.


## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

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

* [Ubuntu Documentation: EnvironmentVariables](https://help.ubuntu.com/community/EnvironmentVariables) (anglicky)

!ÚzkýRežim: vyp

## Pomocné funkce

*# asocexist() – testuje, zda v asociativním poli $1 existuje prvek $2*<br>
**function asocexist() { test -v "$1[${2@Q}]"; }**

*# asockopirovat() – kopií asociativního pole $1 přepíše proměnnou $2*<br>
**function kopirovatasocpole() \{**
<odsadit1>**declare -p "$1" &gt;/dev/null \|\| return $?**<br>
<odsadit1>**: '^declare -\\S\*A'**<br>
<odsadit1>**if [[ $(declare -p "$1") =~ $\_ ]]**<br>
<odsadit1>**then**<br>
<odsadit2>**unset "$2" &amp;&amp;**<br>
<odsadit2>**declare -Ag "$2" &amp;&amp;**<br>
<odsadit2>**eval "for \_ in \\"\\${!$1[@]}\\"; do $2[\\$\_]=\\${$1[\\$\_]}; done"**<br>
<odsadit1>**else**<br>
<odsadit2>**printf 'kopirovatasocpole: Není asociativní pole: %s\\n' "$1" &gt;&amp;2**<br>
<odsadit2>**false**<br>
<odsadit1>**fi**<br>
**\}**

*# promenzkum() – vypíše údaje o proměnných ve formátu vhodném pro další zpracování*<br>
**function promenzkum() \{**
<odsadit1>**for X in $(compgen -v)**
<odsadit1>**do**<br>
<odsadit2>**declare -p $X**<br>
<odsadit2>**printf \\\\0**<br>
<odsadit1>**done \| sed -zE 's/^\\S+\\s+(\\S+)\\s+([<nic>^&blank;=]+)=/\\2&blank;\\1&blank;/;s/\\n$//'**<br>
**\}**
