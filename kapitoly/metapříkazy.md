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
!OblíbenáZaklínadla:
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

## Spustit jako jiný uživatel/skupina

*# jako **superuživatel***<br>
**sudo** {*příkaz a parametry*}

*# jako **uživatel** (varianta pro všechny/varianta jen pro superuživatele)*<br>
*// Poznámka: „sudo“ u příkazu „runuser“ je pouze symbolické; ve skutečnosti se nezadává, protože příkaz „runuser“ spouští pouze root (resp. skripty běžící pod účtem root) a sudo by zde bylo zbytečné.*<br>
**sudo -u** {*uzivatel*} [**-g** {*skupina*}] {*příkaz a parametry*}<br>
**sudo runuser -u** {*uzivatel*} [**-g** {*skupina*}] {*"příkaz s parametry"*}

*# jako **skupina** (varianta pro všechny/varianta jen pro superuživatele)*<br>
*// Poznámka: „sudo“ u příkazu „runuser“ je pouze symbolické; ve skutečnosti se nezadává, protože příkaz „runuser“ spouští pouze root (resp. skripty běžící pod účtem root) a sudo by zde bylo zbytečné.*<br>
**sg** {*skupina*} {*"příkaz s parametry"*}<br>
**sudo runuser -g** {*skupina*} {*"příkaz s parametry"*}

## Interakce s interpretem

*# spustit proces **místo** aktuálního interpretu*<br>
*// Nový proces získá PID aktuálního interpretu a většinu jeho kontextu. Parametr „-c“ před vykonáním náhrady smaže všechny proměnné prostředí (dokonce i HOME, PATH apod., takže to možná není moc dobrý nápad).*<br>
**exec** [**-c**] {*příkaz a parametry*} [*přesměrování*]

*# interpretovat text a vykonat jako příkazovou řádku ve stávající instanci interpretu*<br>
**eval** {*"příkaz s parametry"*}

*# interpretovat a vykonat interpretem „sh“*<br>
[*sudo*] **sh -c** {*"příkaz a parametry"*}

*# interpretovat a vykonat interpretem „bash“*<br>
[*sudo*] **bash -c** {*"příkaz a parametry"*}

*# interpretovat příkaz, ale nevykonat ho*<br>
*// Hlavní smysl tohoto metapříkazu spočívá v situacích, kdy má interpretace příkazu očekávané vedlejší účinky (např. nastavení zvláštní proměnné $\_ nebo uložení do historie příkazů v interaktivním režimu interpretu).*<br>
**true** {*příkaz a parametry*}

## Vykonat příkazy hromadně

*# sestavit parametry příkazu ze záznamů ze vstupu, vykonat po dávkách*<br>
*// Neuvedete-li parametr „-n“, použije „xargs“ v každé dávce co nejvíc parametrů, kolik mu umožní systémové limity. Neuvedete-li parametr „-P“, výchozí hodnota je 1, což znamená, že další dávka se spustí, teprve až ta předchozí doběhne. Vstupní soubor (ve formátu TXTZ) použijte v případě, že vykonávaný příkaz potřebuje přístup ke standardnímu výstupu.*<br>
**xargs -r0** [**-a** {*vstupní-soubor*}] <nic>[**-n** {*max-parametrů-na-dávku*}] <nic>[**-P** {*úroveň-paralelismu*}] {*příkaz a počáteční parametry*}

*# pro každý vstupní záznam spustit příkaz a záznam dosadit do parametrů (obecně/příklad použití)*<br>
*// Obsah vstupního záznamu bude dosazen do parametrů vnořeného příkazu za všechny výskyty podřetězce „{}“. Pokud potřebujete tento podřetězec použít jinak, zvolte jiný podřetězec u parametru „-I“.*<br>
**xargs -r0 -I '{}'** [**-a** {*vstupní-soubor*}] <nic>[**-P** {*úroveň-paralelismu*}] {*příkaz a parametry*}<br>
**find . -maxdepth 1 -type f -print0 \| xargs -r0 -I '{}' -P 4 ln -frsTv "{}" "{}.odkaz"**

## Spustit jinak...

*# spustit příkaz s prázdným prostředím (obecně/příklad)*<br>
**env -i** {*příkaz a parametry*}<br>
**env -i printenv**

*# spustit příkaz s upraveným prostředím*<br>
**env** [**-C** {*nový/aktuální/adresář*}] <nic>[**-u** {*promenna\_k\_odebrani*}]... [{*promenna\_k\_nastaveni*}**=**{*hodnota*}]... {*příkaz a parametry*}

*# s nižší/vyšší **prioritou***<br>
*// Zvýšení/snížení se počítá relativně vůči prioritě interpretu, ve kterém je příkaz použit, a výsledek se omezí do intervalu 19 (nejnižší možná priorita) až -20 (nejvyšší možná priorita). Takže když zadáte „nice -n 10 bash“, dostanete interpret s prioritou „10“, a když v něm zadáte „nice -n 6 bash“, nový interpret bude mít prioritu 16. Když pak v něm zadáte ještě „nice -n 9 bash“, třetí interpret bude mít prioritu 19.*<br>
**nice -n** {*číslo 0 až 19*} {*příkaz a parametry*}<br>
**sudo nice -n** {*číslo -1 až -20*} {*příkaz a parametry*}

*# spustit proces jako démona (obecně/příklad)*<br>
*// Při použití příkazu „nohup“ důrazně doporučuji ručně přesměrovat standardní vstup a oba standardní výstupy mimo terminál; pokud to neuděláte, příkaz „nohup“ to udělá za vás, ale vypíše přitom rušivou zprávu „nohup: vstup ignoruji a výstup připojuji k 'nohup.out'“. Spuštěný proces by měl pokračovat i v případě uzavření terminálu, ze kterého byl spuštěn, nebo v případě odhlášení uživatele, který ho spustil, ale doporučuji to raději nejprve vyzkoušet s konkrétním programem.*<br>
**nohup** {*příkaz a parametry*} **&lt;**{*vstup*} **&gt;**{*kam/směřovat/výstup*} **2gt;**{*kam/směřovat/chybový/výstup*}<br>
**nohup sort &lt;můj-soubor.txt &gt;seřazený-soubor.txt 2&gt;/dev/null**

*# spustit proces s nebufferovaným standardním vstupem a výstupem*<br>
*// Užitečnost tohoto příkazu je velmi nízká, protože bude účinkovat jen na programy, které si nastavení bufferování svých vstupů nemění samy, a ani u nich nemusí výsledky odpovídat očekávání. Raději se podívejte do dokumentace příslušného programu, zda nepodporuje nějaký způsob zapnutí „nebufferovaného režimu“.*<br>
**stdbuf -i 0 -o 0** {*příkaz a parametry*}

*# spustit proces v prostředí s vypnutým účinkem operace „sync“ (obecně/příklad)*<br>
*// Potlačení účinku operace „sync“ tímto příkazem závisí na určitých proměnných prostředí, proto se rozšíří do všech procesů, které tyto proměnné zdědí.*<br>
**eatmydata** {*příkaz a parametry*}<br>
**sudo eatmydata bash**

### Pseudometapříkazy

Poznámka: V případě kombinace musejí být pseudometapříkazy uvedeny
na příkazové řádce před všemi ostatními metapříkazy a je nutno dodržet
toto pořadí: „&blank;“, „time“, „!“ (může být i víckrát), „\\“.

*# logicky obrátit hodnotu ukládanou do $?*<br>
*// Příkaz „!“ nemá vliv na pole PIPE\_STATUS, v něm najdete vždy původní návratové hodnoty všech procesů roury. Do proměnné $? se ale uloží 1 při nulovém návratovém kódu příkazu a 0 při nenulovém. Příkaz „!“ ovlivní zřetězení operátory „&amp;&amp;“ a „\|\|“, protože tyto operátory čtou proměnnou $?.*<br>
**!** {*příkaz a parametry*} [**\|** {*další příkaz a parametry*}]...

*# změřit **čas běhu** příkazu*<br>
*// Aby metapříkaz „time“ správně fungoval, musí být uveden před jakýmkoliv dalším metapříkazem a neměl by být zdvojen (výjimkou je metapříkaz „!“, ten lze uvést i před metapříkazem „time“, aniž by to ovlivnilo jeho funkčnost).*<br>
**time** [**-p**] {*příkaz a parametry*} [**\|** {*další příkaz a parametry*}]...

*# příkaz vykonat, ale neuložit do historie*<br>
*// Mezera musí prvním znakem příkazové řádky vůbec (tzn. před ní nesmí být žádný další příkaz ani jiný znak). Poznámka: aby tento způsob potlačení ukládání do historie fungovat, musí být proměnná HISTCONTROL nastavena na hodnotu „ignorespace“ nebo „ignoreboth“; ve výchozím nastavení v Ubuntu je toto v interaktivním režimu bashe splněno.*<br>
**&blank;**{*příkaz a parametry*}

*# při spouštění příkazu nerozvíjet aliasy (obecně/příklad)*<br>
**\\**{*příkaz a parametry*}<br>
**\\printenv PATH**

*# příklad kombinace všech pseudometapříkazů*<br>
**&blank;time ! ! \\ls**












## Běžné metapříkazy


*# spouštět příkaz pravidelně a jeho výstup zobrazovat na *<br>
**watch -x** [**\-\-no-title**] <nic>[**-n** {*interval-v-sekundách*}] {*příkaz a parametry*}

*# spouštět příkaz opakovaně, jeho výstup prezentovat uživateli a zvýrazňovat změny*<br>
**watch -dx** [**-**[**p**]**n** {*interval-v-sekundách*}] {*příkaz a parametry*}

*# nastavit příkaz jako obsluhu signálu v aktuálním interpretu*<br>
**trap** {*"příkaz s parametry"*} {*signál*}...

## Metapříkazy výhradně pro superuživatele


## Ostatní

*# spustit jedině vestavěný příkaz bashe*<br>
**builtin** {*příkaz a parametry*}

*# spustit jedině externí program*<br>
**command** {*příkaz a parametry*}

*# spustit jedině funkci*<br>
?

*# spustit jedině alias*<br>
?


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

Všechny použité příkazy jsou základními součástmi Ubuntu přítomnými i v minimální
instalaci; výjimkou je příkaz eatmydata, který je nutno doinstalovat:

*# *<br>
**sudo apt-get install eatmydata**

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

* Pro nízkou hodnotu „-n“ u příkazu „xargs“ se můžete celkem spolehnout na to, že xargs použije přesně takový počet parametrů v každé dávce kromě poslední (která může být kratší, pokud na ni nezbude dost záznamů na vstupu).


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
