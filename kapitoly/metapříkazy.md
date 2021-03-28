<!--

Linux Kniha kouzel, kapitola Metapříkazy
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

[ ] pkexec

⊨
-->

# Metapříkazy

!Štítky: {tematický okruh}{bash}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Běžné metapříkazy

*# spustit příkaz s právy superuživatele*<br>
**sudo** {*příkaz a parametry*}

*# spustit příkaz s právy konkrétního uživatele (a případně skupiny)*<br>
**sudo -u** {*uzivatel*} [**-g** {*skupina*}] {*příkaz a parametry*}

*# spustit příkaz s právy konkrétního uživatele (pro superuživatele)*<br>
*// Poznámka: „sudo“ v tomto zaklínadle má pouze symbolický význam — značí, že příkaz „runuser“ se musí spouštět s právy superuživatele. Při skutečném použití se ale na příkazovou řádku „sudo“ obvykle nepíše, protože příkaz „runuser“ se obvykle spouští v kontextech, které již práva superuživatele mají.*<br>
**sudo runuser -u** {*uzivatel*} [**-g** {*skupina*}] {*"příkaz s parametry"*}

*# spustit příkaz s právy konkrétní skupiny*<br>
**sg** {*skupina*} {*"příkaz s parametry"*}

*# spustit proces místo aktuálního interpretu*<br>
*// Poznámka: nový proces získá PID a PPID aktuálního interpretu a interpret vykonáním tohoto příkazu přestane existovat, aniž by vrátil jakoukoliv návratovou hodnotu (rodič interpretu ji bude očekávat od nově spuštěného procesu).*<br>
**exec** [**-c**] {*příkaz a parametry*} [*přesměrování*]

*# nastavit příkaz jako obsluhu signálu v aktuálním interpretu*<br>
**trap** {*"příkaz s parametry"*} {*signál*}...

*# spustit příkaz s prázdným prostředím*<br>
**env -i** {*příkaz a parametry*}

*# spustit příkaz s upraveným prostředím*<br>
**env** [**-C** {*nový/aktuální/adresář*}] <nic>[**-u** {*promenna\_k\_odebrani*}]... [{*promenna\_k\_nastaveni*}**=**{*hodnota*}]... {*příkaz a parametry*}

*# spustit proces s nižší prioritou*<br>
*// Snížení se počítá relativně vůči prioritě interpretu, ve kterém je příkaz použit, s limitem 19 (nejnižší možná priorita). Takže když zadáte „nice -n 10 bash“, dostanete interpret s prioritou „10“, když pak zadáte „nice -n 6 bash“, nový interpret bude mít prioritu 16, a když zadáte ještě „nice -n 9 bash“, třetí interpret bude mít prioritu 19.*<br>
**nice -n** {*číslo 0 až 19*} {*příkaz a parametry*}

*# spustit proces s vyšší prioritou*<br>
*// Zvýšení se počítá relativně vůči prioritě interpretu, ve kterém je příkaz použit, s limitem -20 (nejvyšší možná priorita nejaderného procesu).*<br>
**sudo nice -n** {*číslo -1 až -20*} {*příkaz a parametry*}

*# interpretovat příkaz interpretem „sh“*<br>
[*sudo*] **sh -c** {*"příkaz a parametry"*}

*# interpretovat příkaz interpretem „bash“*<br>
[*sudo*] **bash -c** {*"příkaz a parametry"*}

*# analyzovat příkaz, ale nevykonat ho*<br>
*// Hlavní smysl tohoto metapříkazu spočívá v situacích, kdy analýza příkazů má očekávané vedlejší účinky (např. nastavení zvláštní proměnné $\_ nebo uložení do historie v interaktivním režimu interpretu).*<br>
**true** {*příkaz a parametry*}

## Zvláštní metapříkazy

*# logicky obrátit hodnotu uloženou do zvláštní proměnné $?*<br>
*// Příkaz „!“ nemá vliv na pole PIPE\_STATUS, v něm najdete vždy původní návratové hodnoty procesů. Do proměnné $? se ale uloží 1 při nulovém návratovém kódu příkazu a 0 při nenulovém. Příkaz „!“ ovlivní zřetězení operátory „&amp;&amp;“ a „\|\|“, protože tyto operátory čtou proměnnou $?.*<br>
**!** {*příkaz a parametry*} [**\|** {*další příkaz a parametry*}]...

*# změřit čas běhu příkazu*<br>
*// Aby metapříkaz „time“ správně fungoval, musí být uveden před jakýmkoliv dalším metapříkazem a neměl by být zdvojen (výjimkou je metapříkaz „!“, ten lze uvést i před metapříkazem „time“, aniž by to ovlivnilo jeho funkčnost).*<br>
**time** [**-p**] {*příkaz a parametry*} [**\|** {*další příkaz a parametry*}]...

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
