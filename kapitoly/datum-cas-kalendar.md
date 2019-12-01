<!--

Linux Kniha kouzel, kapitola Datum, čas a kalendář
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

-->

# Datum, čas a kalendář

!Štítky: {tematický okruh}{čas}

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

## Zaklínadla (formát příkazu „date“)
<!--
TODO: Zamyslet se nad formátováním.
-->
*# den v týdnu (alternativy)*<br>
**%A = Úterý (plný název, lokalizovaný)**<br>
**%a = Út (zkratka, lokalizovaná)**<br>
**%u = 2 (číslo 1..7, kde 1 je pondělí)**<br>
**%w = 2 (číslo 0..6, kde 0 je neděle)**

*# rok (alternativy)*<br>
**%Y = 2010 (4 číslice)**<br>
**%C = 20 (století)**<br>
**%y = 10 (dvojčíslí roku)**

*# čtvrtletí*<br>
**%q = 3 (číslo 1..4)**

*# měsíc (alternativy)*<br>
**%m = 03 (číslo)**<br>
**%B = listopad (plný název, lokalizovaný)**<br>
**%b = lis (zkratka, lokalizovaná)**

*# den v měsíci (alternativy)*<br>
**%d = 03 (číslo)**<br>
**%e = &blank;3 (číslo zarovnané mezerou)**

*# hodina + období dne (alternativy)*<br>
**%H = 15 (číslo 00..23)**<br>
**%I = 03 (číslo 01..12)**<br>
**%p = AM/PM (lokalizovaně)**<br>
**%P = am/pm (lokalizovaně)**

*# minuta*<br>
**%M = 59 (číslo 00..59)**

*# sekunda*<br>
**%S = 59 (číslo 00..61)**

*# nanosekundy*<br>
**%N = 123456789 (počítadlo nanosekund)**

*# časová zóna*<br>
**%Z = CET (zkratka časové zóny)**<br>
**%z = +0100**<br>
**%:z = +01:00**<br>
**%::z = +01:00:00**<br>
**%:::z = +01 (nejkratší přesné vyjádření)**<br>

*# číslo týdne podle ISO normy (týden začíná pondělím)*<br>
**%G = 2010 (celé číslo roku)**<br>
**%g = 10 (dvojčíslí roku)**<br>
**%V = 03 (číslo týdne 01..53)**

*# číslo týdne v roce*<br>
**%W = 07 (00..53, týden začíná pondělím)**<br>
**%U = 07 (00..53, týden začíná nedělí)**

*# escapované znaky (alternativy)*<br>
**%% = %**<br>
**%n = konec řádku**<br>
**%t = tabulátor**

*# počet sekund od 00:00:00 1. ledna 1970 UTC*<br>
**%s**

*# číslo dne v roce*<br>
**%**[**-**]**j**

*# lokalizované celky*<br>
**%x = datum**<br>
**%X = čas (24hodinový)**<br>
**%r = čas (12hodinový)**<br>
**%c = datum a čas (24hodinový)**

*# nelokalizované celky*<br>
**%D = %m/%d/%y**<br>
**%F = %Y-%m-%d**<br>
**%R = %H:%M**<br>
**%T = %H:%M:%S**

## Zaklínadla

### Čekání

*# počkat určitou dobu*<br>
*// Počet sekund může být i necelé číslo, např. 0.12 počká 120 milisekund. Pro hodnoty pod 100 milisekund ale neočekávejte velkou přesnost.*<br>
**sleep** {*sekund*}...

### Kalendář

*# zobrazit kalendář měsíce a dvou okolních*<br>
**ncal -M3**[**b**][**w**][**J**] [{*měsíc-1-až-12*} {*rok*}]

*# zobrazit kalendář měsíce*<br>
**ncal -M**[**b**][**w**][**J**] [{*měsíc-1-až-12*}] {*rok*}

*# zobrazit kalendář všech měsíců v roce*<br>
**ncal -Mb**[**w**][**J**] {*rok*}

*# zobrazit kalendář měsíce a N následujících*<br>
**ncal -M**[**b**][**w**][**J**] **-A** {*N*} [{*měsíc-1-až-12*}] {*rok*}

### Aktuální čas a datum

*# vypsat aktuální čas (resp. datum): lokální/UTC/v určité časové zóně*<br>
**date** [**+**{*formát*}]<br>
**date -u** [**+**{*formát*}]<br>
**TZ="**{*časová/zóna*}**" date** [**+**{*formát*}]

*# zobrazit kalendář aktuálního měsíce a dvou okolních*<br>
**ncal -M3**[**b**][**w**][**J**]

### Časové zóny
*# konverze z UTC na lokální čas/z lokálního času na UTC*<br>
**date -d "TZ=\\"UTC\\"** {*čas-UTC*}**" "+%F %T"**<br>
**date -ud "@$(date -d "**{*čas*}**" +%s)" "+%F %T"**

*# konverze z jedné časové zóny do druhé (obecně/příklad)*<br>
**TZ="**{*cílová/časová/zóna*}**" date -d 'TZ="**{*zdrojová/časová/zóna*}**"&blank;**{*čas*}**' "+%F %T**[**&blank;%z**]**"**<br>
**TZ="America/New\_York" date -d 'TZ="Asia/Vladivostok" 2019-01-01 12:35:57' "+%F %T %z"**

*# vypsat seznam rozumných podporovaných časových zón, seřazený podle jejich aktuální odchylky od UTC*<br>
**vypsat-casove-zony \| sed 's/.\*/TZ="&amp;" date +%z; echo &amp;/' \| bash \| xargs -rd \\\\n -n 2 printf "%s\\\\t%s\\\\n" \| LC\_ALL=C sort \| sort -ns**

*# vypsat seznam podporovaných časových zón (rozumný/naprosto úplný)*<br>
**vypsat-casove-zony**<br>
**vypsat-casove-zony vsechny**

### Aritmetika s datem
*# konverze data na „číslo dne“/zpět*<br>
**printf %s\\\\n $(($(date -ud** {*datum*} **+%s) / 86400))**<br>
**date -ud "@$((**{*číslo-dne*}** \* 86400))" +%F**

*# přičíst k datu N dní/odečíst od data N dní*<br>
**date -ud @$((**{*N*} **\* 86400 + $(date -ud "**{*datum*}**" +%s))) +%F**<br>
**date -ud @$((-**{*N*} **\* 86400 + $(date -ud "**{*datum*}**" +%s))) +%F**

*# rozdíl dvou dat ve dnech*<br>
**printf %s\\\\n $((($(date -ud** {*datum*} **+%s) - $(date -ud** {*odečítané-datum*} **+%s)) / 86400))**

*# je rok přestupný?*<br>
**test 61 -eq $(date -d** {*rok*}**-03-01 +%-j)**

### Artimetika s časem
*# konverze lokálního/UTC času na „časovou známku“*<br>
**date -d "**{*čas*}**" +%s**<br>
**date -ud "**{*čas*}**" +%s**

*# konverze „časové známky“ na lokální čas/UTC*<br>
**date -d %**{*časová-známka*} **"+%F %T**[**&blank;%z**]**"**<br>
**date -ud %**{*časová-známka*} **"+%F %T"**

*# přičíst/odečíst N sekund (v UTC)*<br>
**date -ud @$(($(date -ud "**{*datum čas*}**" +%s) +** {*N*} **)) "+%F %T"**<br>
**date -ud @$(($(date -ud "**{*datum čas*}**" +%s) -** {*N*} **)) "+%F %T"**

*# rozdíl UTC časů v sekundách*<br>
**printf %s\\\\n $(($(date -ud** {*čas*} **+%s) - $(date -ud** {*odečítaný-čas*} **+%s)))**

### Svátky
*# zjistit datum Velikonoční neděle*<br>
**date -d "$(LC\_ALL=C ncal -e** [{*rok*}]**)" +%F**

### Synchronizace času

*# ručně synchronizovat systémový čas*<br>
?


## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti − ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Jak získat nápovědu
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje (ale neuvádějte konkrétní odkazy, ty patří do sekce „Odkazy“).
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Pomocné funkce a skripty

*# \~/bin/vypsat-casove-zony − vypíše seznam podporovaných časových zón*<br>
**#!/bin/bash -e**<br>
**find -L /usr/share/zoneinfo -type f \| cut -d / -f 5- \| (if test "$1" = "vsechny"**<br>
**then**<br>
<odsadit1>**exec cat**<br>
**fi**<br>
**exec egrep "^($(echo Africa America Antarctica Asia Atlantic Australia Etc Europe Indian Pacific \| tr "&blank;" \\\|))") \| LC\_ALL=C sort -i**

## Odkazy
![ve výstavbě](../obrazky/ve-vystavbe.png)

Co hledat:

* [stránku na Wikipedii](https://cs.wikipedia.org/wiki/Hlavn%C3%AD_strana)
* oficiální stránku programu
* oficiální dokumentaci
* [manuálovou stránku](http://manpages.ubuntu.com/)
* [balíček Bionic](https://packages.ubuntu.com/)
* online referenční příručky
* různé další praktické stránky, recenze, videa, tutorialy, blogy, ...
* publikované knihy
* [TL;DR stránka „date“](https://github.com/tldr-pages/tldr/blob/master/pages/common/date.md)
