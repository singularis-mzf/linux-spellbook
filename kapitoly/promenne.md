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
-->

# Proměnné prostředí a interpretu

!Štítky: {tematický okruh}{bash}{systém}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

Tato kapitola pokrývá veškerou práci s proměnnými prostředí v Linuxu a dále také veškerou
práci s proměnnými interpretu Bash. Rovněž uvádí některé důležité proměnné prostředí,
kterými lze ovlivnit funkci programů a systému.

## Definice

* **Prostředí** je soubor pojmenovaných textových proměnných, který má v Linuxu každý proces. Nově vytvořený proces nejčastěji získá svoje prostředí jako kopii prostředí svého rodičovského procesu. Je-li proces spuštěn příkazem „exec“, proměnné prostředí se zachovají do nově spuštěného procesu.
* **Proměnná prostředí** je jedna z proměnných v prostředí (např. „HOME“).
* **Proměnná interpretu** je proměnná vytvořená interpretem Bash (popř. jiným) za účelem použití ve funkcích a skriptech. Není přístupná z jiných procesů, nešíří se do nich a ukončením dané instance bashe zaniká. Proměnné interpretu nemusejí být textové, mohou to být také pole, asociativní pole či funkce.

<!--

Důležité proměnné prostředí:

* HOME – Uvádí cestu do domovského adresáře přihlášeného uživatele. Řada dalších cest se od ní odvozuje. \~ se v bashi rozvíjí na hodnotu $HOME.
* PATH – Uvádí seznam adresářů prohledávaných při vyhledávání spustitelných souborů. Cesty v seznamu jsou odděleny dvojtečkou a prohledávají se od první k poslední.
* DISPLAY – Uvádí označení displeje, na kterém budou grafické programy otevírat svoje okna. Na většině systémů je to „:0.0“.
* TERM – Uvádí označení typu terminálu, ze kterého lze odvodit podporu barev a escape-sekvencí. Často to bývá „xterm-256color“, „linux“ či „rxvt“.
* XDG\_SESSION\_TYPE — Uvádí „x11“, pokud program běží v grafickém prostředí X-serveru.

Důležité proměnné prostředí, které lze nastavit:

* LC\_ALL – Používá se k nastavení místních zvyklostí. (...)

Méně důležité:

* LOGNAME – Obvykle obsahuje jméno aktuálního uživatele (ale není stoprocentně spolehlivá).

-->

!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Testy

*# je proměnná definovaná?*<br>
**test -v** {*název\_proměnné*}

*# jde o proměnnou interpretu?*<br>
?

*# jde o proměnnou prostředí?*<br>
**printenv** {*název\_proměnné*} **&gt;/dev/null**

*# jde o funkci?*<br>
?

### Proměnné prostředí

*# změnit proměnnou interpretu na proměnnou prostředí*<br>
**export** {*název\_proměnné*}[**=**{*nová-hodnota*}]

*# změnit proměnnou prostředí na proměnnou interpretu*<br>
?

*# vypsat všechny proměnné prostředí (txt/txtz)*<br>
**printenv**<br>
**printenv -0**


### Pole

### Asociativní pole

*# **vytvořit***<br>
**unset** {*název*}<br>
**declare -A** {*název*}

*# **zrušit***<br>
**unset** {*název*}

*# **zkopírovat***<br>
**asockopirovat** {*zdrojovépole*} {*cílovépole*}

*# **přiřadit** hodnotu prvku*<br>
*// Přiřazujete-li hodnotu jiné proměnné, nejsou uvozovky nutné.*<br>
{*názevpole*}**[**{*klíč*}**]="**{*hodnota*}**"**

*# zjistit **počet** prvků*<br>
**${#**{*název*}**[@]}**

*# obsahuje prvek se zadaným klíčem? (alternativy)*<br>
**asocexist** {*názevpole*} **"**{*klíč*}**"**<br>
**test -v '**{*názevpole*}[**{*klíč*}**]**'**<br>
**test -v "**{*názevpole*}**[$\{**{*proměnná\_s\_klíčem*}**@Q}]"**

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

## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíčků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

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
