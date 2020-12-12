<!--

Linux Kniha kouzel, kapitola Perl: Standardní knihovna
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

# Perl: Standardní knihovna

!Štítky: {program}{Perl}{programování}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola z programovacího jazyka Perl pokrývá funkce dostupné
v modulech distribuovaných běžně spolu se samotným interpretem.

<!--
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->

## Definice

...

!ÚzkýRežim: vyp

## Zaklínadla: Ostatní

### Práce s časem

*# získat aktuální časovou známku*<br>
**time()** ⊨ 1605876988

*# získat aktuální čas: lokální/UTC*<br>
**array(localtime(**{*časznámka*}**))** ⊨ (59, 58, 13, 20, 10, 120, 5, 324, 0)<br>
**array(gmtime(**{*časznámka*}**))** ⊨ (59, 58, 12, 20, 10, 120, 5, 324, 0)

*# tvar pole vraceného funkcemi localtime() a gmtime()*<br>
*// Den v týdnu je: 0=neděle, 1=pondělí, ..., 6=sobota. isdst je logická pravda pro letní čas, jinak logická nepravda. Dny v roce se počítají od nuly!*<br>
**(**{*sekund*}**,** {*minut*}**,** {*hodin*}**,** {*den-v-měsíci*}**,** {*měsíc*}**,** {*rok-1900*}**,** {*den-v-týdnu*}**,** {*den-v-roce*}**,** {*isdst*}**)**

*# časová známka na řetězec formátu "yyyy-MM-dd HH:mm:ss" (lokální/UTC)*<br>
^^**use POSIX;**<br>
**POSIX::strftime(**{*$formát*}**, localtime(**{*časznámka*}**))**<br>
**POSIX::strftime(**{*$formát*}**, gmtime(**{*časznámka*}**))**

<!--
[ ] zjistit posun lokální časové zóny oproti UTC!
-->


## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíčků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

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

* Abyste se vyhnuli problémům s názvy modulů, nazývejte svoje moduly (a jejich adresáře) tak, aby název začínal velkým písmenem a obsahoval alespoň jedno malé písmeno.
* Proměnné deklarované na úrovni modulu klíčovým slovem „my“ jsou zamýšleny tak, že jsou omezeny jen na daný zdrojový soubor. Ve skutečnosti takto deklarovanou proměnnou můžete použít ve více zdrojových souborech, ale v takovém případě pro každý z nich vznikne samostatná proměnná!

Příkaz „require“ způsobí


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

!ÚzkýRežim: vyp
