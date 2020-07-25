<!--

Linux Kniha kouzel, kapitola Pevné a symbolické odkazy
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Pevné a symbolické odkazy

!Štítky: {tematický okruh}{systém souborů}
!ÚzkýRežim: zap

## Úvod
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Definice
![ve výstavbě](../obrazky/ve-vystavbe.png)

* Každá adresářová položka reprezentující obyčejný soubor je **pevný odkaz**. Na jeden soubor může odkazovat více pevných odkazů, ale vždy jen v rámci toho souborového systému, kde je soubor fyzicky uložen. Součástí pevného odkazu je pouze název, všechny ostatní údaje o souboru (vlastnictví, přístupová práva, velikost, čas poslední změny, umístění na disku atd.) jsou uloženy na příslušném místě mimo adresář (v tzv. i-uzlu). Soubor nemůže být odstraněn ze souborového systému, dokud na něj existuje alespoň jeden pevný odkaz, proto jsou pevné odkazy vždy platné.
* **Symbolický odkaz** je adresářová položka, která obsahuje cestu k souboru či adresáři. Symbolické odkazy dělíme na **absolutní** (které obsahují absolutní cestu) a **relativní** (obsahující relativní cestu). Symbolický odkaz, který odkazuje na neexistující cestu, se označuje jako **neplatný**.
* **Následovat** symbolický odkaz znamená chovat se, jako by se na jeho místě a pod jeho názvem skutečně nacházel odkazovaný soubor či adresář. Většina operací a programů symbolické odkazy následuje – pokusíte-li se spustit symbolický odkaz na program, spustí se program; pokusíte-li se symbolický odkaz otevřít v textovém editoru, otevře se odkazovaný soubor. Pokusíte-li se přejít do symbolického odkazu příkazem „cd“, přejdete do odkazovaného adresáře, atd.

!ÚzkýRežim: vyp

## Zaklínadla
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Pevné odkazy

*# vytvořit pevný odkaz na soubor*<br>
**ln** {*cesta-k-souboru*}... {*cesta-k-odkazu*}<br>
**ln -t** {*adresář-kde-vytvořit-odkaz*} {*cesta-k-souboru*}...

*# smazat pevný odkaz*<br>
**rm** {*cesta-k-odkazu*}...

*# vypsat počet referencí pevného odkazu*<br>
*// bude-li cílem symbolický odkaz, L umožní vypsat jeho vlastní počítadlo; jinak se vypíše počítadlo odkazovaného souboru či adresáře*<br>
**stat -c %h** [**\-\-**] {*cesta-k-odkazu*}

<!--
**ln -ld**[**L**] {*cesta-k-odkazu*}
-->

*# vypsat kanonickou cestu pevného odkazu*<br>
**readlink -f** {*cesta-k-odkazu*}

*# vypsat kanonickou cestu adresáře obsahujícího pevný odkaz*<br>
?

*# přejmenovat/přesunout pevný odkaz*<br>
**mv** {*původní-cesta*} {*nová-cesta*}

*# vytvořit dočasný, zdánlivý, nerekurzivní pevný odkaz na adresář*<br>
**mkdir -p** {*nová-cesta*}<br>
**mount** [**-o ro**] **\-\-bind** {*původní-cesta*} {*nová-cesta*}

### Symbolické odkazy

*# vytvořit symbolický odkaz*<br>
**ln -s** {*obsah-odkazu*} {*cesta-k-odkazu*}

*# vytvořit symbolický odkaz s absolutní (kanonickou) cestou*<br>
**ln -s "$(readlink -f** {*cesta-k-souboru-či-adresáři*}**)"** {*cesta-k-odkazu*}

*# vytvořit symbolický odkaz s relativní cestou*<br>
?

### Kopírování

*# kopírovat: zachovat symbolické odkazy doslovně*<br>
?

*# kopírovat: opravit symbolické odkazy (zachovat jejich smysl)*<br>
?

*# kopírovat: následovat symbolické odkazy (chovat se, jako by byly pevné)*<br>
?

*# kopírovat: vynechat symbolické odkazy*<br>
?

*# kopírovat: symbolické odkazy nahradit prázdnými soubory*<br>
?

*# kopírovat adresáře; na soubory místo toho vytvořit v cíli pevné odkazy*<br>
?

*# kopírovat adresářovou strukturu bez souborů*<br>
?

*# najít duplicitní soubory v adresářové struktuře a sloučit je pomocí pevných odkazů*<br>
?

<!--
Oblíbené rsync parametry:

-aviA
--progress
--noatime
--delete
--backup --backup-dir=...
--exclude=''

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

Všechny použité nástroje jsou základní součástí Ubuntu přítomnou i v minimální instalaci.

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

* Upřednostňujte relativní symbolické odkazy; jsou o trochu odolnější proti přesouvání a přejmenovávání adresářů. Absolutní symbolické odkazy mají svoje místo při odkazování na soubory, které mají ze systémových důvodů svou pevnou absolutní cestu (např. /etc/passwd), nebo pokud je odkaz a cíl v různých podstromech kořenového adresáře (např. při odkazování z /etc do /home); ve všech ostatních případech se vyplatí relativní symbolické odkazy, zejména při odkazování se v rámci USB flash disku. Stačí totiž když ho připojí jiný uživatel a už cesta k souborům začíná „/home/katka/WWW/“ místo „/home/petr/WWW“. Relativní odkazy mezi soubory na flash disku pak budou fungovat, ale absolutní ne.
* Symbolický odkaz má vlastnictví a skupinu, ale nemá vlastní přístupová práva. Přístup k odkazovanému souboru či adresáři se i při přístupu přes symbolický odkaz řídí přístupovými právy odkazované položky.
* Pokud uživatel nemá právo vstoupit do adresáře, kam symbolický odkaz odkazuje, bude se mu jevit jako neplatný, přestože ve skutečnosti neplatný nebude.
* Maximální počet pevných odkazů na jeden soubor je omezený souborovým systémem; v souborových systémech typu ext4 je to 65000.
* Soubor bude odstraněn z disku v momentě, kdy už na něj neexistují žádné pevné odkazy, není spuštěný jako proces a není otevřený žádným deskriptorem žádného procesu.

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->
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

!ÚzkýRežim: vyp
