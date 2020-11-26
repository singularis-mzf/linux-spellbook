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

-->

# Proměnné prostředí a interpretu

!Štítky: {tematický okruh}{bash}{systém}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola pokrývá veškerou práci s proměnnými a funkcemi interpretu Bash
a uvádí některé systémově důležité proměnné prostředí.
Rovněž pokrývá práci s parametry skriptů a funkcí v Bashi.

Proměnné se v bashi (zejména ve skriptech a funkcích) používají k dočasnému
uchování krátkých textových dat (popř. čísel) mezi příkazy. Většina proměnných
je viditelná pouze v rámci dané instance interpretu; pro práci s prostředím
se používají „exportované“ proměnné, které instance bashe vytvoří z proměnných
prostředí v momentě svého spuštění a ze kterých sestaví prostředí každého
procesu, který spustí.

Tato verze kapitoly nepokrývá zvláštní proměnné interpretu Bash,
které řídí jeho funkci, ale nebývají proměnnými prostředí;
nedostatečně pokrývá lokální proměnné ve funkcích;
nepokrývá možnosti přednastavení proměnných v souborech jako
/etc/environment, „.profile“ či „.bashrc“.
Do této kapitoly nespadají takzvané zvláštní parametry (jako např. $?, $! apod.).

GNU Bash je vyvíjen v rámci projektu GNU.

## Definice

* Bash rozeznává tři základní typy proměnných: **řetězcové proměnné**, **pole** (indexované celými čísly od nuly) a **asociativní pole** (indexované neprázdným řetězcem zvaným **klíč**).
* **Prostředí** je soubor řetězcových proměnných (tzv. **proměnných prostředí**), který má nejen bash, ale každý proces (s výjimkou jaderných démonů). Prostředí se kopíruje do každého nově spuštěného procesu a bash ho reprezentuje souborem **exportovaných proměnných**, což umožňuje prostředí nově vytvořených procesů měnit.
* **Funkce** je krátký skript, který se místo do souboru ukládá do paměti (stejně jako proměnná). Na rozdíl od skutečného skriptu se vždy spouští v rámci stávající instance bashe. Stejně jako skript lze funkci zavolat zadáním jejího názvu jako příkazu a má svoje poziční parametry. Funkce se často používají ve skriptech jako podprogramy, ale užitečné jsou i v interaktivním režimu.
* **Konstanta** je proměnná (jen zřídka exportovaná), které je jednorázově přidělena hodnota a dále již nemůže být změněna ani zrušena.
* **Parametry** (také **poziční parametry**) jsou v bashi přístupné jako zvláštní proměnné „1“, „2“ atd. Poziční parametry lze číst všemi způsoby, jakými lze číst obyčejné proměnné, ale přiřadit lze jen do všech najednou, a to voláním skriptu, volání funkce nebo příkazem „set“.
* **Celočíselné proměnné** jsou řetězcové proměnné a prvky polí či asociativních polí, kterým byl nastaven atribut „i“. Při každém přiřazení do takové proměnné (resp. prvku) se přiřazovaný text vyhodnotí jako celočíselný výraz a do proměnné/prvku se přiřadí výsledná celočíselná hodnota.

<!--
* **Parametr skriptu** je prvek příkazové řádky, se kterým byl volán skript či funkce.
[ ] Popsat celočíselné proměnné a konstanty.
-->

Názvy proměnných a funkcí jsou obvykle tvořeny jen velkými a malými písmeny anglické abecedy, podtržítky a číslicemi, přičemž nesmí začínat číslicí.

!ÚzkýRežim: vyp

## Zaklínadla: Proměnné v bashi

### Řetězcové proměnné

*# **přiřadit** proměnné hodnotu*<br>
{*název\_proměnné*}**="**{*nová-hodnota*}**"**

*# **zrušit** proměnnou*<br>
*// Pozor! Příkaz „unset“ uspěje i tehdy, pokud daná proměnná neexistuje.*<br>
**unset -v** {*název\_proměnné*}

*# vypsat **seznam** (s hodnotami/bez hodnot/s hodnotami ve formátu txtz)*<br>
**for \_ in $(compgen -v); do [[ ${!\_@a} = \*[aA]\* ]] \|\| declare -p "$\_"; done**<br>
**for \_ in $(compgen -v); do [[ ${!\_@a} = \*[aA]\* ]] \|\| printf '%s\\n' "$\_"; done**<br>
**for \_ in $(compgen -v); do [[ ${!\_@a} = \*[aA]\* ]] \|\| printf '%s=%s\\0' "$\_" "${!\_}"; done**
<!--
**lkk\_promenzkum \| sed -znE '/^\\S+\\s+[<nic>^aAx]+\\s+\\S+$/{s/^(\\S+)&blank;\\S+&blank;/\\1=/;p}' \| tr \\\\0 \\\\n**<br>
**lkk\_promenzkum \| sed -znE '/^\\S+\\s+[<nic>^aAx]+\\s+\\S+$/{s/\\s.\*//;p}' \| tr \\\\0 \\\\n**
-->

*# **připojit** text na začátek/konec proměnné*<br>
{*název\_proměnné*}**="**{*nová-hodnota*}**$**{*název\_proměnné*}**"**<br>
{*název\_proměnné*}**+="**{*nová-hodnota*}**"**

*# jde o **řetězcovou** proměnnou? (alternativy)*<br>
**[[ -v** {*název\_proměnné*} **&amp;&amp; $\{**{*název\_proměnné*}**@a} = \*([!aA]) ]]**<br>
**[[ -v** {*název\_proměnné*} **&amp;&amp; $\{**{*název\_proměnné*}**@a} =~ ^[<nic>^aA]\*$ ]]**

*# automatická konverze velikosti písmen při přiřazení (na velká písmena/na malá písmena/vypnout)*<br>
*// Pozor! Zapnutí této konverze nezmění stávající hodnotu proměnné, účinek nastane až při následujícím přiřazení!*<br>
**declare -u** {*název\_proměnné*}...<br>
**declare -l** {*název\_proměnné*}...<br>
**declare +lu** {*název\_proměnné*}...<br>

### Exportování proměnných

*# **exportovat**/neexportovat proměnnou*<br>
**export** {*název\_proměnné*}[**=**{*nová-hodnota*}]<br>
**export -n** {*název\_proměnné*}...

*# jde o **exportovanou**/neexportovanou proměnnou?*<br>
**[[ $\{**{*název\_proměnné*}**@a} = \*x\* ]]**<br>
**[[ -v** {*název\_proměnné*} **&amp;&amp; ! $\{**{*název\_proměnné*}**@a} = \*x\* ]]**
<!--
**[[ -v** {*název\_proměnné*} **&amp;&amp; $\{**{*název\_proměnné*}**@a} =~ ^[<nic>^x]\*$ ]]**
**[[ -v** {*název\_proměnné*} **&amp;&amp; $\{**{*název\_proměnné*}**@a} = \*([!x]) ]]**<br>
-->

*# **seznam** exportovaných proměnných (s hodnotami/bez hodnot)*<br>
**(set -o posix; declare -x)**<br>
**compgen -e**
<!--
Poznámka: příkaz „printenv“ z nějakého důvodu vypisuje kromě proměnných prostředí také
proměnnou „_“, ačkoliv tu ani jako proměnnou prostředí nastavit nelze.

**env -0 \| egrep -zv '^\_=' \| tr \\\\0 \\\\n**<br>
**env -0 \| egrep -zv '^\_='**
<br>
**for X in $(compgen -e); do printf '%s=%s\\0' "$X" "${!X}"; done**
-->

*# seznam neexportovaných proměnných (s hodnotami/bez hodnot)*<br>
**(set -o posix; declare +x)**<br>
**for \_ in $(compgen -v); do [[ ${!\_@a} = \*x\* ]] \|\| printf '%s\\n' "$\_"; done**
<!--
<br>
**for \_ in $(compgen -v); do [[ ${!\_@a} = \*x\* ]] \|\| printf '%s=%s\\0' "$\_" "${!\_}"; done**
-->
<!--
**lkk\_promenzkum \| sed -znE '/^\\S+\\s+[<nic>^x]+\\s+\\S+$/{s/^(\\S+)&blank;\\S+&blank;/\\1=/;p}' \| tr \\\\0 \\\\n**<br>
**lkk\_promenzkum \| sed -znE '/^\\S+\\s+[<nic>^x]+\\s+\\S+$/{s/.\*\\s//;p}' \| tr \\\\0 \\\\n**
-->

### Obecné

*# jde o proměnnou?*<br>
**test -v** {*název\_proměnné*}

*# **seznam** všech proměnných (s hodnotami/bez hodnot)*<br>
**(set -o posix; set)**<br>
**compgen -v**
<!--
<br>
**for \_ in $(compgen -v); do printf '%s=%s\\0' "$\_" "${!\_}"; done**

**lkk\_promenzkum \| sed -zE 's/^(\\S+)&blank;\\S+&blank;/\\1=/' \| tr \\\\0 \\\\n**<br>
-->

*# dosadit názvy všech proměnných, které začínají určitou předponou*<br>
*// Názvy proměnných se dosadí jako samostatné parametry (podobně jako u speciálního parametru $@).*<br>
**${!**{*předpona*}**@}** ⊨ PATH PIPESTATUS PPID PROMPT\_COMMAND PS1 PS2 PS4 PWD

### Pole (jako celek)

*# **vytvořit** či přepsat/**zrušit**/vyprázdnit*<br>
*// Prvky pole se zadávají stejně jako parametry příkazu, tzn. oddělují se mezerami; obsahují-li zvláštní znaky, budou interpretovány, pokud je neodzvláštníte (vhodné je umístění do uvozovek či apostrofů).*<br>
{*název\_pole*}**=(**[{*prvky*}]...**)**
**unset -v** {*název\_pole*}<br>
{*název\_pole*}**=()**

*# **seznam** polí (bez hodnot)*<br>
**compgen -A arrayvar**

*# dosadit **počet** prvků*<br>
**${#**{*názevpole*}**[@]}**

*# jde o **pole**?*<br>
**[[ $\{**{*název\_proměnné*}**@a} = \*a\* ]]**
<!--
<br>**compgen -A arrayvar \| fgrep -qx** {*název\_proměnné*}
-->

*# **zkopírovat** (celé pole/výřez)*<br>
{*cílové\_pole*}**=("$\{**{*zdrojové\_pole*}**[@]}")**<br>
{*cílové\_pole*}**=("$\{**{*zdrojové\_pole*}**[@]:**{*první-kopírovaný-index*}[**:**{*maximální-počet*}]**\}")**

*# **spojit** dvě pole*<br>
{*cílové\_pole*}**=("$\{**{*první\_pole*}**[@]}" "$\{**{*druhé\_pole*}**[@]}")**

*# **rozdělit** pole na poloviny*<br>
{*první\_cíl*}**=("$\{**{*názevpole*}**[@]:0:$((${#**{*název\_pole*}**[@]}/2+1))}")**<br>
{*druhý\_cíl*}**=("$\{**{*názevpole*}**[@]:$((${#**{*název\_pole*}**[@]}/2+1))}")**

*# **obrátit** pořadí prvků pole*<br>
*// V případě potřeby změňte názvy pomocných proměnných „i“, „j“ a „x“.*<br>
**i=-1 j=${#**{*název\_pole*}**[@]}**<br>
**while test $((++i)) -lt $((\-\-j))**<br>
**do**<br>
<odsadit1>**x=$\{**{*název\_pole*}**[i]}**<br>
<odsadit1>{*název\_pole*}**[i]=$\{**{*název\_pole*}**[j]}**<br>
<odsadit1>{*název\_pole*}**[j]=$x**<br>
**done**<br>
[**unset -v i j x**]

*# přiřadit do pole **parametry** skriptu či funkce*<br>
{*cílové\_pole*}**=("$@")**

### Pole (práce s prvky)

*# **přečíst** prvek na indexu N/**přiřadit** do něj*<br>
*// Je dovoleno přiřadit do prvku libovolně daleko za koncem pole; Bash v takovém případě pole automaticky prodlouží prázdnými řetězci, aby index byl platný.*<br>
**$\{**{*název\_pole*}**[**{*N*}**]**[**-**{*náhradní hodnota*}]**\}**<br>
{*název\_pole*}**[**{*N*}**]=**{*hodnota*}

*# **iterovat** přes prvky/přes indexy*<br>
**for** {*iterační\_proměnná*} **in "$\{**{*název\_pole*}**[@]}"; do** {*...*}**; done**<br>
**for** {*iterační\_proměnná*} **in "${!**{*název\_pole*}**[@]}"; do** {*...*}**; done**

*# dosadit **výřez** pole*<br>
*// Výřez se dosadí jako samostatné parametry (podobně jako u zvláštního parametru $@).*<br>
**"$\{**{*zdrojové\_pole*}**[@]:**{*první-kopírovaný-index*}[**:**{*maximální-počet*}]**\}"**

*# **vložit** nový prvek na začátek/konec*<br>
*// Pozor! Vkládání prvků na začátek je v případě rozsáhlého pole velmi pomalé! Snažte se mu vyhnout a vkládat prvky raději na konec. Pro vložení prvku doprostřed použijte spojování polí (které je ale také pomalé).*<br>
{*název\_pole*}**=("**{*nový prvek*}**" "$\{**{*název\_pole*}**[@]}")**<br>
{*název\_pole*}**+=("**{*nový prvek*}**")**

*# **odstranit** N prvků na začátku/konci*<br>
{*název\_pole*}**=("$\{**{*názevpole*}**[@]:**{*N*}**\}")**
{*název\_pole*}**=("$\{**{*názevpole*}**[@]:0:$((${#**{*název\_pole*}**[@]}-**{*N*}**))}")**

### Asociativní pole (jako celek)

<!--
https://www.artificialworlds.net/blog/2012/10/17/bash-associative-array-examples/
-->

*# **vytvořit** = vyprázdnit*<br>
**unset -v** {*název*} **&amp;&amp; declare -A** {*název*}

*# **zrušit***<br>
**unset -v** {*název*}

*# jde o **asociativní pole**?*<br>
**[[ $\{**{*název\_proměnné*}**@a} = \*A\* ]]**<br>

*# seznam asociativních polí (bez hodnot)*<br>
**for \_ in $(compgen -v); do [[ ! ${!\_@a} = \*A\* ]] \|\| printf '%s\\n' "$\_"; done**
<!--
**lkk\_promenzkum \| egrep -z '^\\S+&blank;\\S\*A\\S\*&blank;' \| cut -d '&blank;' -f 1 -z \| tr \\\\0 \\\\n**
-->

*# dosadit **počet** prvků*<br>
**${#**{*název*}**[@]}**

*# **zkopírovat***<br>
**unset -v** {*cílovépole*}<br>
**declare -A** {*cílovépole*}<br>
**for \_ in "${!**{*zdrojovépole*}**[@]}"; do cílovépole[$\_]=$\{**{*zdrojovépole*}**[$\_]}; done**
<!--
**lkk\_asockopirovat** {*zdrojovépole*} {*cílovépole*}
-->

*# **sloučit** dvě asociativní pole*<br>
**for \_ in "${!**{*zdrojovépole*}**[@]}"; do cílovépole[$\_]=$\{**{*zdrojovépole*}**[$\_]}; done**

### Asociativní pole (práce s klíči a prvky)

Pozor! Klíčem v asociativním poli může být pouze neprázdný řetězec!
Prázdný klíč způsobí chybu „chybný podskript pole“.

*# **přečíst** hodnotu prvku (klíč je řetězec/hodnota proměnné)*<br>
*// Tyto tvary uvádějte vždy ve dvojitých uvozovkách. Klíč se v tomto případě vyhodnocuje, jako by byl sám uvnitř samostatných dvojitých uvozovek, což umožňuje i vícenásobné vnoření této konstrukce, ačkoliv to je špatně čitelné.*<br>
[**"**{*...*}]**$\{**{*názevpole*}**["**{*klíč*}**"]\}**[{*...*}**"**]<br>
[**"**{*...*}]**$\{**{*názevpole*}**["$**{*klíč\_proměnná*}**"]\}**[{*...*}**"**]

*# **přiřadit** hodnotu prvku (klíč je: řetězec/hodnota proměnné)*<br>
*// Uvozovky kolem klíče slouží pouze k odzvláštnění znaků klíče, můžete je odzvláštnit i jinak, např. zpětným lomítkem či apostrofy.*<br>
{*názevpole*}**["**{*klíč*}**"]="**{*hodnota*}**"**<br>
{*názevpole*}**[$**{*klíč\_proměnná*}**]="**{*hodnota*}**"**

*# **obsahuje** prvek se zadaným klíčem? (klíč je hodnota proměnné)*<br>
**test -v "**{*názevpole*}**[$\{**{*proměnná\_s\_klíčem*}**@Q}]"**

*# obsahuje prvek se zadaným klíčem? (klíč je řetězec)*<br>
**: '**{*klíč*}**'** [**&amp;&amp;**]<br>
**test -v "**{*názevpole*}**[${\_@Q}]"**

*# dosadit **klíče**/**hodnoty***<br>
**"${!**{*název\_pole*}**[@]}"**<br>
**"$\{**{*název\_pole*}**[@]}"**

*# **iterovat** přes klíče/přes hodnoty*<br>
**for** {*iterační\_proměnná*} **in "${!**{*název\_pole*}**[@]}"; do** {*...*}**; done**<br>
**for** {*iterační\_proměnná*} **in "$\{**{*název\_pole*}**[@]}"; do** {*...*}**; done**

*# odstranit prvek podle klíče (klíč je hodnota proměnné)*<br>
**unset -v "**{*názevpole*}**[$\{**{*proměnná\_s\_klíčem*}**@Q}]"**

*# **odstranit** prvek podle klíče (klíč je řetězec)*<br>
**: "**{*klíč*}**"** [**&amp;&amp;**]<br>
**unset -v "**{*názevpole*}**[${\_@Q}]"**

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

*# **zavolat** funkci*<br>
{*název\_funkce*} [{*parametry*}]...

*# **seznam** funkcí (s těly/bez těl)*<br>
**declare -f**<br>
**compgen -A function**

*# **existuje** funkce?*<br>
**declare -f** {*název\_funkce*} **&gt;/dev/null**

*# **zrušit** funkci*<br>
**unset -f** {*název\_funkce*}

*# vypsat **definici** funkce*<br>
**declare -f** {*název\_funkce*}

*# exportovat/neexportovat funkci*<br>
*// Exportované funkce se uloží do zvláštních proměnných prostředí a další instance bashe, která je tímto způsobem „zdědí“, je opět načte jako funkce. Doporučuji exportování funkcí příliš nepoužívat, protože tak můžete snadno ztratit kontrolu nad tím, kam všude se vaše funkce dostanou.*<br>
**export -f** {*název\_funkce*}<br>
**export -fn** {*název\_funkce*}

### Celočíselné proměnné

*# jde o celočíselnou proměnnou?*<br>
*// Tento test odpoví kladně i v případě, že půjde o pole celočíselných hodnot či asociativní pole celočíselných hodnot.*<br>
**[[ $\{**{*název\_proměnné*}**@a} = \*i\* ]]**

*# **nastavit** řetězcovou proměnnou jako celočíselnou (obecně/příklady...)*<br>
*// Hodnoty přiřazené do celočíselných proměnných se automaticky vyhodnocují jako výrazy a konvertují na celé číslo. Místo každého druhého názvu proměnné v uvedeném příkazu pochopitelně můžete uvést novou hodnotu proměnné, a to i výrazem.*<br>
**declare -i** {*název\_proměnné*}**=$**{*název\_proměnné*} [{*další\_proměnná*}**=$**{*další\_proměnná*}]...<br>
**declare -i x=$x**<br>
**declare -i x=-1**<br>

*# nastavit pole či asociativní pole, že jeho prvky budou celočíselné*<br>
*// Pozor! Účinek této deklarace nastává až při následujícím přiřazení. Pokud tedy deklarované pole či asociativní pole již obsahuje neceločíselné hodnoty, zůstanou v původní podobě, dokud nebudou přepsány!*<br>
**declare -i** {*název\_pole\_či\_asoc\_pole*}...

*# **přičíst**/**odečíst** od celočíselné proměnné*<br>
**: $((**{*název\_proměnné*} **+=** {*číslo*}**))**<br>
**: $((**{*název\_proměnné*} **-=** {*číslo*}**))**

### Jmenné odkazy

*# **vytvořit** jmenný odkaz*<br>
*// Poznámka: jmenným odkazem nelze odkazovat na normální ani asociativní pole!*<br>
**declare -n** {*název\_odkazu*}**=**{*název\_odkazované\_proměnné*}

*# **zrušit** jmenný odkaz*<br>
**unset -n** {*název\_odkazu*}

*# je proměnná jmenný odkaz?*<br>
**test -R** {*název\_proměnné*}

*# **přečíst** jmenný odkaz místo odkazované proměnné (alternativy)*<br>
**if test -R** {*název\_odkazu*}**; then declare +n** {*název\_odkazu*}**; echo $**{*název\_odkazu*}**; declare -n** {*název\_odkazu*}**; else false; fi**<br>
**test -R** {*název\_odkazu*} **&amp;&amp; eval "$(declare -p** {*název\_odkazu*} **\| sed -E '1s/^[<nic>^=]\*=/echo&blank;/')"**

### Konstanty

*# **seznam** konstant (pro člověka/bez hodnot)*<br>
**readonly**<br>
**for \_ in $(compgen -v); do [[ ! ${!\_@a} = \*r\* ]] \|\| printf '%s\\n' "$\_"; done**

*# jde o konstantu?*<br>
**[[ $\{**{*název\_proměnné*}**@a} = \*r\* ]]**

*# **vytvořit** konstantu*<br>
*// Konstanta je proměnná interpretu (popř. prostředí), kterou nelze zrušit ani později změnit její hodnotu (bez použití opravdu škaredých a nespolehlivých hacků). Lze ji však změnit z proměnné interpretu na proměnnou prostředí a naopak. Jde-li o proměnnou prostředí, vytvořené procesy (včetně dalších instancí bashe) ji zdědí již jako obyčejnou (přiřaditelnou) proměnnou prostředí.*<br>
**readonly** {*název\_konstanty*}**="**{*hodnota*}**"** [{*další\_název\_konstanty*}**="**{*hodnota*}**"**]...

## Zaklínadla: Dosazování proměnných

### Jednoduché a nepřímé dosazení

*# **dosadit** hodnotu řetězcové proměnné (alternativy)*<br>
**$**{*název\_proměnné*} ⊨ Hello, world!
**$\{**{*název\_proměnné*}**\}**

*# dosadit hodnotu řetězcové proměnné s **odzvláštněním***<br>
*// Hodnota bude typicky v apostrofech či konstrukci „$''“. Konkrétní tvar se může lišit, ale vždy bude možno ho bezpečně dosadit do skriptu.*<br>
**$\{**{*název\_proměnné*}**@Q}** ⊨ 'Hello, world!'

*# **nepřímé** dosazení*<br>
*// Tuto konstrukci lze skombinovat s většinou ostatních druhů dosazení.*<br>
**${!**{*proměnná*}[{*zbytek výrazu*}]**\}**

*# dosadit prvky **pole** (všechny prvky/jeden prvek/výřez/poslední prvek)*<br>
**"$\{**{*název\_pole*}**[@]}"**<br>
**"$\{**{*název\_pole*}**[**{*index*}**]}"**<br>
**"$\{**{*název\_pole*}**[@]:**{*první-kopírovaný-index*}[**:**{*maximální-počet*}]**\}"**<br>
**"$\{**{*název\_pole*}**[-1]}"**

*# dosadit hodnotu z **asociativního pole** (klíč je řetězec/hodnota proměnné)*<br>
*// Tyto tvary uvádějte vždy ve dvojitých uvozovkách. Klíč se v tomto případě vyhodnocuje, jako by byl sám uvnitř samostatných dvojitých uvozovek, což umožňuje i vícenásobné vnoření této konstrukce, ačkoliv to je špatně čitelné.*<br>
**$\{**{*název\_asoc\_pole*}**["**{*klíč*}**"]\}**<br>
**$\{**{*název\_asoc\_pole*}**["$**{*klíč\_proměnná*}**"]\}**

*# dosadit všechny klíče/všechny hodnoty z asociativního pole*<br>
**"${!**{*název\_asoc\_pole*}**[@]}"**<br>
**"$\{**{*název\_asoc\_pole*}**[@]}"**

### Vlastnosti proměnné

*# dosadit **délku** hodnoty proměnné ve znacích*<br>
**${#**{*název\_proměnné*}**\}** ⊨ 0

*# dosadit znaky reprezentující zapnuté **atributy** dané proměnné*<br>
*// Nemá-li proměnná zapnutý žádný atribut, dosadí se prázdný řetězec.*<br>
**$\{**{*název\_proměnné*}**@a}** ⊨ x

*# dosadit **příkaz** bashe, který vytvoří danou proměnnou včetně atributů a hodnoty*<br>
**$\{**{*název\_proměnné*}**@A}** ⊨ declare -x HOME='/home/kalandira'

### Podmíněné dosazení

*# je-li proměnná definovaná/neprázdná, dosadit; jinak použít **náhradní řetězec***<br>
*// Pokud má náhradní řetězec obsahovat zvláštní znaky či znak „}“, doporučuji uzavřít jej do dvojitých uvozovek. To funguje i tehdy, pokud je dosazovací výraz jako celek použit uvnitř dvojitých uvozovek.*<br>
**$\{**{*název\_proměnné*}**-**[**"**]{*náhradní řetězec*}[**"**]**\}**<br>
**$\{**{*název\_proměnné*}**:-**[**"**]{*náhradní řetězec*}[**"**]**\}**

*# dosadit hodnotu proměnné, která **musí být** definovaná/neprázdná; jinak zobrazit chybové hlášení a ukončit skript*<br>
**$\{**{*název\_proměnné*}**?**[**"**]<nic>{*chybové hlášení*}]<nic>[**"**]**\}**<br>
**$\{**{*název\_proměnné*}**:?**[**"**]<nic>{*chybové hlášení*}]<nic>[**"**]**\}**

*# je-li proměnná definovaná/neprázdná, dosadit; jinak jí **přiřadit** náhradní hodnotu a dosadit*<br>
**$\{**{*název\_proměnné*}**=**[**"**]{*náhradní řetězec*}[**"**]**\}**<br>
**$\{**{*název\_proměnné*}**:=**[**"**]{*náhradní řetězec*}[**"**]**\}**

*# dosadit **řetězec**, jen pokud je proměnná definovaná/neprázdná*<br>
*// Nebude-li splněna podmínka dosazení, dosadí se prázdný řetězec.*<br>
**$\{**{*název\_proměnné*}**+**[**"**]{*řetězec*}[**"**]**\}**<br>
**$\{**{*název\_proměnné*}**:+**[**"**]{*řetězec*}[**"**]**\}**

### Dosazení podřetězce či se substitucí

*# dosadit **podřetězec** hodnoty proměnné*<br>
*// Tip: kolem indexu a délku mohou být mezery, kolem názvu proměnné ne.*<br>
**$\{**{*název\_proměnné*}**:** {*index-prvního-znaku-od-0*} **:** {*maximální-délka*} **\}**

*# dosadit hodnotu proměnné po odebrání nejkratší/nejdelší shody **začátku** hodnoty se vzorkem*<br>
**$\{**{*název\_proměnné*}**#**{*vzorek*}**\}**<br>
**$\{**{*název\_proměnné*}**##**{*vzorek*}**\}**

*# dosadit hodnotu proměnné po odebrání nejkratší/nejdelší shody **konce** hodnoty se vzorkem*<br>
**$\{**{*název\_proměnné*}**%**{*vzorek*}**\}**<br>
**$\{**{*název\_proměnné*}**%%**{*vzorek*}**\}**

*# dosadit hodnotu proměnné po **nahrazení** první/všech shod se vzorkem řetězcem náhrady*<br>
**$\{**{*název\_proměnné*}**/**{*vzorek*}[**/**{*řetězec náhrady*}]**\}**<br>
**$\{**{*název\_proměnné*}**//**{*vzorek*}[**/**{*řetězec náhrady*}]**\}**

*# dosadit hodnotu proměnné **velkými/malými písmeny***<br>
**$\{**{*název\_proměnné*}**^^}**<br>
**$\{**{*název\_proměnné*}**,,}**

*# interpretovat hodnotu jako by byla uvedena v konstrukci $'text' a výsledek dosadit*<br>
**$\{**{*název\_proměnné*}**@E}**<br>

### Parametry skriptu

*# dosadit N-tý **poziční parametr** (alternativy)*<br>
*// První variantu lze použít pouze pro parametry $0 až $9. Druhou variantu (tu se složenými závorkami) lze použít i pro ostatní parametry (např. ${10}) a lze ji skombinovat s pokročilými formami dosazení.*<br>
**$**{*N*}<br>
**$\{**{*N*}**\}**

*# dosadit **všechny parametry** od $1: do samostatných parametrů/jen oddělené mezerou*<br>
*// Dvojité uvozovky zde znamenají, že pro správnou funkci musí být $@ (resp. $\*) uvedeny uvnitř dvojitých uvozovek.*<br>
**"$@"**<br>
**"$\*"**

*# **nastavit** poziční parametry*<br>
*// Parametry lze nastavit pouze najednou, přičemž se všechny stávající parametry (kromě $0) ztratí.*<br>
**set \-\-** {*parametr*}...

*# dosadit **úsek** parametrů (samostatně/oddělené mezerou)*<br>
**"${@:** {*číslo-prvního-parametru*} [**:** {*maximální-počet*}] **\}"**<br>
**"${\*:** {*číslo-prvního-parametru*} [**:** {*maximální-počet*}] **\}"**

*# dosadit všechny parametry počínaje $0 (samostatně/oddělené mezerou)*<br>
**"${@:0}"**<br>
**"${\*:0}"**

### Aritmetické operace při dosazení

*# **inkrementovat**/dekrementovat a dosadit*<br>
**$((++**{*název\_proměnné*}**))**<br>
**$((\-\-**{*název\_proměnné*}**))**

*# přičíst/odečíst číslo, přiřadit a dosadit*<br>
**$((**{*název\_proměnné*} **+=** {*číslo*}**))**<br>
**$((**{*název\_proměnné*} **-=** {*číslo*}**))**

*# přičíst/odečíst číslo a dosadit (bez přiřazení)*<br>
**$((**{*název\_proměnné*} **+** {*číslo*}**))**<br>
**$((**{*název\_proměnné*} **-** {*číslo*}**))**

### Různé příklady

*# dosadit první neprázdnou z proměnných „a“, „b“ a „c“*<br>
**${a:-${b:-${c:-}}}**

*# dosadit proměnnou „abc“ s odstraněním všech konců řádků*<br>
**${abc//$'\\n'}**

*# dosadit proměnnou „abc“ s tím, že všechny číslice se nahradí nulami*<br>
**${abc//[0123456789]/0}**

*# z proměnné „abc“ dosadit jen číslice*<br>
**${abc//[!0123456789]}**

## Zaklínadla: Proměnné prostředí

### Spouštění programů s upraveným prostředím

*# **spustit** s upraveným prostředím (jednodušší varianta)*<br>
[[**/usr/bin/**]**env**] {*PROMĚNNÁ*}**=**{*hodnota*} [{*DALŠÍ\_PROMĚNNÁ*}**=**{*další-hodnota*}]... {*příkaz*} [{*parametr*}]...

*# spustit v jiném aktuálním **adresáři***<br>
**env -C** {*cesta*} {*příkaz*} [{*parametr*}]...

*# spustit s upraveným prostředím (**komplexní** varianta)*<br>
*// -i prostředí zcela vyprázdní; \-\-unset z něj odebírá uvedené proměnné, přiřazení proměnné prostředí nastavuje a parametr „-C“ změní aktuální adresář.*<br>
[[**/usr/bin/**]**env** <nic>[**-i**] <nic>[**\-\-unset=**{*PROMĚNNÁ*}]... [**-C** {*nový/aktuální/adresář*}]] [{*PROMĚNNÁ*}**=**{*hodnota*}]... {*příkaz*} [{*parametr*}]...

### Předdefinované proměnné

*# absolutní cesta **domovského adresáře***<br>
**$HOME** ⊨ /home/petr

*# vyhledávací cesty externích příkazů*<br>
*// Cesty jsou odděleny. Bývají absolutní, ale mohou být i relativní. Zahrnout aktuální adresář „.“ je možné, ale z bezpečnostních důvodů se to striktně nedoporučuje.*<br>
**$PATH** ⊨ /home/petr/bin:/usr/local/sbin:/usr/local/bin:<br>/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

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
**LC\_ALL=C.UTF-8**

*# preferovaná časová zóna*<br>
**TZ=UTC**<br>
**TZ=Europe/Prague**

*# nelokalizovat výpisy a hlášení*<br>
**LC\_MESSAGES=C.UTF-8**

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

*# vypsat **seznam** proměnných*<br>
**sed -zE 's/=.\*//' /proc/**{*PID*}**/environ \| tr \\\\0 \\\\n** [**\| sort**]

*# je proměnná **definovaná**/neprázdná?*<br>
**egrep -zq '^**{*název\_proměnné*}**=' /proc/**{*PID*}**/environ**<br>
**egrep -zq '^**{*název\_proměnné*}**=.' /proc/**{*PID*}**/environ**

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

<!--
## Parametry příkazů
<!- -
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)

### env
-->

## Instalace na Ubuntu

Všechny použité nástroje jsou základní součástí Ubuntu, přítomné i v minimální instalaci.

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

* Pozor! Kolem znaku „=“ při přiřazování do proměnných nesmí být žádné bílé znaky! Jedinou výjimkou je tzv. aritmetický kontext (tedy např. uvnitř konstrukce „$(( prom = 1 + 1 ))“).
* Náhradní řetězce a vzorky v pokročilých formách dosazení (např. „${X%.txt}“) vytvářejí nový kontext pro odzvláštnění, ve kterém můžete použít podle potřeby zpětná lomítka, uvozovky, apostrofy, a dokonce vnořené dosazení proměnných! Takže chcete-li např. dosadit hodnotu proměnné X po odebrání podřetězce „%\\}“ z jejího konce, použijte tvar "${X%'%\\}'}".
* Do řetězcových proměnných můžete ukládat jakékoliv znaky UTF-8 kromě nulového bajtu, takže konce řádek, tabulátory, Escape apod. nejsou žádný problém.
* Pokud potřebujete v asociativním poli použít jako klíč prázdný řetězec (což není dovoleno), pomůže upravit kód tak, aby před každý klíč vkládal konkrétní písmeno (např. „X“) a před výpisem toto písmeno zase odstraňoval (např. „${klíč#X}“).
* Velkými písmeny (např. *HOME* či *HISTSIZE*) se píšou názvy proměnných, které mají řídicí či systémový význam, ať už jde o proměnné prostředí či jen interpretu. Vaše uživatelské proměnné ve skriptech nazývejte malými písmeny (např. „cesta\_zpet“), popř. kombinací malých a velkých písmen (např. „CestaZpet“).
* Znak ~ se v bashi rozvíjí na hodnotu „${HOME}“, proto ho uvnitř dvojitých uvozovek (kde by se nerozvinul) můžete vždy snadno a bezpečně nahradit za „${HOME}“.
* Funkce se může jmenovat stejně jako proměnná.
* V bashi vznikají proměnné automaticky při prvním přiřazení, není tedy třeba je deklarovat. Ve výchozím nastavení navíc pokus o dosazení neexistující proměnné povede k dosazení prázdného řetězce bez jakékoliv chyby (toto lze změnit nastavením „set -u“).
* Při čtení prostředí ostatních procesů je třeba si dát pozor na to, že bash změny exportovaných proměnných nereflektuje do svého vlastního prostředí, ale až do prostředí procesů, které spustí (počítá se i spuštění příkazem „exec“).

## Další zdroje informací

* [YouTube: Programování v Shellu](https://www.youtube.com/watch?v=cv1V9GE2Ag0) (proměnných se týká začátek videa)
* [Linuxexpres: Proměnné prostředí](https://www.linuxexpres.cz/praxe/bash-4-dil)
* [YouTube: Fedora Linux Proměnné](https://www.youtube.com/watch?v=y\_j2H2wbSRg) (jen úplné základy)
* [Wikipedie: Proměnná](https://cs.wikipedia.org/wiki/Prom%C4%9Bnn%C3%A1\_(programov%C3%A1n%C3%AD\))
* [Ubuntu Documentation: EnvironmentVariables](https://help.ubuntu.com/community/EnvironmentVariables) (anglicky)
* [Bash Reference Manual: Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html) (anglicky)
* [TL;DR: env](https://github.com/tldr-pages/tldr/blob/master/pages/common/env.md) (anglicky)

!ÚzkýRežim: vyp

<!--
## Pomocné funkce

*# lkk\_promenzkum() – vypíše údaje o proměnných ve formátu vhodném pro další zpracování*<br>
**function lkk\_promenzkum() \{**<br>
<odsadit1>**for X in $(compgen -v)**<br>
<odsadit1>**do**<br>
<odsadit2>**declare -p $X**<br>
<odsadit2>**printf \\\\0**<br>
<odsadit1>**done \| sed -zE 's/^\\S+\\s+(\\S+)\\s+([<nic>^&blank;=]+)=/\\2&blank;\\1&blank;/;s/\\n$//'**<br>
**\}**
-->
