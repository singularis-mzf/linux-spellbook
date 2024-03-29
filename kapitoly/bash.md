<!--

Linux Kniha kouzel, kapitola Bash
Copyright (c) 2019-2021 Singularis <singularis@volny.cz>

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
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
Bash je výchozí interpret příkazového řádku v Ubuntu (a většině dalších
linuxů). Tato kapitola se zabývá jeho funkcemi, které nejsou pokryty
v jiných kapitolách, zejména přepínači nastavení, prací s návratovým kódem
příkazů a některými užitečnými rozvoji. Ostatní vlastnosti Bashe najdete
v podkapitolách této kapitoly, popř. ve zcela samostatných kapitolách.

Interpret Bash je vyvíjen v rámci projektu GNU.

## Definice

* **Návratový kód** (exit status) je celočíselný kód (0 až 255) vracený každým příkazem (s výjimkou přiřazení do proměnné či definice funkce), který indikuje, zda příkaz ve své činnosti uspěl (0) nebo ne (1 až 255).
* **Podprostředí** (subshell) je částečně izolované prostředí pro vykonávání příkazů. Příkazy v podprostředí se chovají, jako by byly spuštěny v novém, odděleném procesu, až na to, že získají kopii všech proměnných (tzn. nejen exportovaných), deskriptorů a nastavení interpretu. Jakékoliv změny proměnných či nastavení interpretu, které provedou, však nemají účinek mimo podprostředí (na to je třeba si dát pozor zvlášť u příkazu „read“). Podprostředí má jako celek svůj návratový kód a jako na celek na něj mohou být aplikována přesměrování.

!ÚzkýRežim: vyp

## Zaklínadla

### Aktuální adresář

*# přejít do **uvedeného** adresáře*<br>
**cd** [**\-\-**] {*cesta*}

*# přejít o úroveň **výš***<br>
**cd ..**

*# přejít do **domovského adresáře***<br>
**cd**

*# **zjistit** aktuální adresář*<br>
**pwd** ⊨ /home/aneta

*# přejít do **předchozího** aktuálního adresáře*<br>
**cd -** [**&gt;/dev/null**]

### Spouštění a řetězení příkazů

*# spustit příkaz **na pozadí** (obecně/příklad)*<br>
*// Spuštění příkazu na pozadí nezmění „$?“ PID spuštěného procesu můžete přečíst ze zvláštní proměnné „$!“. Bezprostředně za znakem „&amp;“ nesmí následovat další oddělovač příkazů jako „;“, „&amp;&amp;“ nebo „\|\|“.*<br>
{*příkaz s parametry nebo sestava s rourou*} **&amp;** [{*promenna*}**=$!**]<br>
**sleep 5 \| wc -c &amp; sleeppid=$!**

*# spustit příkazy v **podprostředí***<br>
**(** {*příkazy*}... **)** [{*přesměrování pro podprostředí*}] <nic>[**&amp;** [{*promenna*}**=$!**]]<br>
**(LC\_ALL=C; sort a.txt &gt;seřazené-a.txt; sort b.txt &gt;seřazené-b.txt)**

*# spuštěným příkazem **nahradit** tuto instanci interpretu*<br>
*// Příkaz „exec“ nelze použít s vestavěnými příkazy Bashe či s rourami.*<br>
**exec** {*příkaz a parametry*}

### Rozvoje (dosazení) na příkazové řádce

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

### Zvláštní proměnné užitečné i v interaktivním režimu

*# **návratová hodnota** posledního vykonaného příkazu*<br>
*// Metapříkaz „!“ umí negovat návratový kód při ukládání do $?, viz kapitolu Metapříkazy.*<br>
**$?**

*# text **posledního parametru** posledního jednoduchého příkazu vykonaného na popředí*<br>
**$\_**

*# **PID** probíhajícího interpretu*<br>
**\$\$**

*# pole návratových hodnot příkazů z poslední vykonané roury*<br>
*// Poznámka: jednoduchý příkaz toto pole přepíše jednoprvkovým polem; obsah pole PIPESTATUS není nikdy ovlivněn metapříkazem „!“.*<br>
**${PIPESTATUS[**{*index*}**]}**

### true a false

*# **vyhodnotit** celočíselný výraz (kvůli vedlejším efektům)(obecně/příklad)*<br>
**true $((**{*celočíselný výraz*}**))**<br>
**true $((++i))**

*# ignorovat parametry a **uspět***<br>
**true** [{*libovolné parametry*}]

*# ignorovat parametry a selhat s kódem 1*<br>
**false** [{*libovolné parametry*}]

## Zaklínadla: Nastavení Bashe

### Vypisování příkazů (např. pro ladění)

*# vypisovat příkazy před vykonáním tak, **jak byly zadány** (zapnout/vypnout)*<br>
**set -v**<br>
**set +v**

*# vypisovat příkazy před vykonáním tak, **jak budou vykonány** (zapnout/vypnout)*<br>
*// Pozor, tato varianta vypisuje i jednotlivé příkazy vykonávané při dosazování operátorem $(), což může vyprodukovat velké množství rušivého výstupu.*<br>
**set -x**<br>
**set +x**

### Nastavení rozvoje cest a proměnných

*# pokud vzorek při rozvoji cest neodpovídá žádné cestě: selhat s chybou (doporučuji)/předat vzorek tak, jak je (výchozí chování, nedoporučuji)/předat prázdný řetězec*<br>
**shopt -s failglob**<br>
**shopt -u failglob nullglob**<br>
**shopt -s nullglob; shopt -u failglob**

*# konstrukci „\*\*“ při rozvoji cest interpretovat jako libovolnou (i prázdnou) posloupnost adresářů (zapnout/vypnout)*<br>
**shopt -s globstar**<br>
**shopt -u globstar**

*# rozsahy ve vzorcích při rozvoji cest (např. „[A-Z]“) intepretovat: podle locale „C“/podle aktuálního locale*<br>
**shopt -s globasciiranges**<br>
**shopt -u globasciiranges**

*# zahrnout do rozvoje cest i skryté soubory a adresáře (zapnout/vypnout)*<br>
*// Zvláštní položky „.“ a „..“ stále nebudou zahrnuty, pokud vzorek nezačíná tečkou.*<br>
**shopt -s dotglob**<br>
**shopt -u dotglob**

*# velká a malá písmena při rozvoji cest: rozlišovat/nerozlišovat*<br>
**shopt -s nocaseglob**<br>
**shopt -u nocaseglob**

*# rozvoj neexistující proměnné: považovat za kritickou chybu/tiše ignorovat*<br>
*// Nedoporučuji používat nastavení „-u“ v interaktivním režimu, protože kód pro doplňování příkazové řádky obsahuje velké množství chyb v adresaci proměnných, a když na ně narazíte, příjdete o celou řádku, kterou jste se pokusil/a doplnit.*<br>
**set -u**<br>
**set +u**

### Zapnout/vypnout rozvoje

*# provádět rozvoj **historie** (zapnout/vypnout)*<br>
**set -H**<br>
**set +H**

*# provádět rozvoj **složených závorek** {} (zapnout/vypnout)*<br>
**set -B**<br>
**set +B**

*# provádět rozvoj **cest** (zapnout/vypnout)*<br>
**set +f**<br>
**set -f**

*# provádět rozvoje $-konstrukcí ve výzvě Bashe: zapnout (výchozí)/vypnout*<br>
*// Poznámka: vypnutí těchto rozvojů nevypne nativní rozvoje specifické pro výzvu interpretu (tzn. např. za „\\w“ se i nadále bude dosazovat aktuální adresář), ale nebudou se rozvíjet vnořené proměnné apod.*<br>
**shopt -s promptvars**<br>
**shopt -u promptvars**

### Zpracování návratových kódů

*# při chybě ukončit interpret (zapnout/vypnout)*<br>
**set -e**<br>
**set +e**

*# návratový kód vícenásobné roury se vezme: z prvního příkazu, který selhal/vždy z posledního příkazu roury*<br>
**set -o pipefail**<br>
**set +o pipefail**

*# uplatnit ukončení při chybě i na příkazy uvnitř substituce $() (zapnout/vypnout)*<br>
**shopt -s inherit\_errexit**<br>
**shopt -u inherit\_errexit**

*# v případě selhání příkazu „exec“ v neinteraktivním režimu: pokračovat ve skriptu/skončit*<br>
**shopt -s execfail**<br>
**shopt -u execfail**

### Ostatní

*# symbolické odkazy v cestě k aktuálnímu adresáři: jednorázově rozvinout/pamatovat si (výchozí)*<br>
**set -P**<br>
**set +P**

*# kontrolovat velikost okna a aktualizovat zvláštní proměnné COLUMNS a LINES (zapnout/vypnout)*<br>
**shopt -s checkwinsize**<br>
**shopt -u checkwinsize**

*# příkazy „.“ a „source“ budou při hledání svého argumentu prohledávat: cesty v PATH a nakonec aktuální adresář (výchozí chování)/jen aktuální adresář*<br>
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

*# už nenačítat další řádek příkazů; po vykonání příkazů z tohoto řádku skončit (zapnout/vypnout)*<br>
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

<!--
## Parametry příkazů
<!- -
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)
-->

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
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.

* Bash umí sám pracovat pouze s textovými daty; obecná binární data, pokud neobsahují nulový bajt, můžete poměrně úspěšně zpracovat po nastavení LC\_ALL=C, kdy bude Bash považovat každý bajt větší než 0 za jeden znak (ale vzdáte se tím lokalizace a podpory UTF-8); pro zpracování binárních dat jsou vhodnější jiné nástroje.
* Normálně klávesová zkratka Ctrl+C přeruší probíhající program či skript. Některé programy se sice dobrovolně ukončí, ale přitom příslušný signál obslouží a nedají vědět skriptu, který je zavolal, takže ten pak pokračuje dalšími příkazy.
-->

### Časté chyby

Pozor na implicitní vznik podprostředí v některých situacích! Bash automaticky obklopí podprostředím každý příkaz dvou- či vícečlenné roury a také i jednoduchý příkaz spouštěný na pozadí. To znamená, že např. tento blok kódu vypíše „19“, protože přiřazení z konstrukce „:=“ zůstalo izolované v podprostředí:

*# *<br>
**unset a**<br>
**true "${a:=12}" &amp;**<br>
**wait $!**<br>
**printf %s\\\\n "${a:=19}"**

Častěji se tato chyba vyskytuje ve formě pokusu o použití příkazu „read“ s rourou:

*# *<br>
**unset a**<br>
**printf 99\\\\n \| IFS= read -r a**<br>
**printf %s\\\\n "$a"**

V uvedeném příkladu zůstane hodnota „a“ nedefinovaná, protože ho Bash uzavře do
samostatného podprostředí.

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

## Další zdroje informací

* [Wikipedie: Bash](https://cs.wikipedia.org/wiki/Bash)
* [Oficiální manuál](https://www.gnu.org/software/bash/manual/html\_node/index.html) (anglicky)
* man 1 bash (anglicky)
* [Oficiální stránka](https://www.gnu.org/software/bash/) (anglicky)
* [Balíček: bash](https://packages.ubuntu.com/focal/bash) (anglicky)

## Zákulisí kapitoly
<!--
- Doplňte, pokud víte. Udržujte aktuální.
-->

V této verzi kapitoly chybí:

!KompaktníSeznam:
* koprocesy
<!-- https://www.gnu.org/software/bash/manual/html_node/Coprocesses.html#Coprocesses -->
* ulimit
* enable (zakazování vestavěných příkazů)
* některé varianty příkazu „trap“

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* Práci s proměnnými (viz kapitolu Proměnné příkazy a interpretu)
* Nastavení terminálu a výzvy (viz kapitolu Terminál)

Další poznámky:

!KompaktníSeznam:
* Nastavení proměnné BASH\_ENV umožňuje spustit „před-skript“ při spouštění skriptu.

!ÚzkýRežim: vyp
