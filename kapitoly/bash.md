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

⊨
-->

# Bash

!Štítky: {program}{bash}

!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Rozvoj proměnných

*# obsah proměnné (pokud neexistuje, prázdný řetězec) *<br>
**$\{**{*název\_proměnné*}**\}**

*# obsah s nahrazením prvního/každého výskytu vzorku novým podřetězcem*<br>
**$\{**{*název\_proměnné*}**/**{*vzorek*}**/**{*řetězec náhrady*}**\}**

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
*// Název proměnné „regvyraz“ zde nemá žádný speciální význam, je zvolen jen pro přehlednost; můžete použít jakoukoliv proměnnou. Jednoduchý regulární výraz (takový, který neobsahuje mezery, escapování ani hranaté závorky) můžete dokonce zadat přímo, pro zadání složitějšího výrazu je ale striktně doporučeno jej předem uložit do proměnné, protože pravidla escapování v tomto kontextu jsou složitá a neintuitivní.*<br>
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
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti − ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
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
