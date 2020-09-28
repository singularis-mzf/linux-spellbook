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

V Linuxu existují dva zcela rozdílné mechanismy na odkazování na soubory či adresáře
v jiné části adresářové struktury. Tato kapitola se zabývá oběma.

Pevný odkaz je název a umístění souboru v adresářové struktuře; většina nelinuxových
souborových systémů vám umožňuje zřídit souboru pouze jeden pevný odkaz, linuxové souborové
systémy vám ale dovolují zřídit až tisíce rovnocenných pevných odkazů na každý soubor
(v rámci toho souborového systému, kde je uložen). Pevné odkazy jsou vázány na soubor
jako takový a jsou vždy platné; data a metadata souboru se smažou až po smazání
posledního pevného odkazu na daný soubor. Nelze ručně vytvářet pevné odkazy na adresáře.

Symbolický odkaz je místo toho zvláštní soubor, který systém interpretuje jako cestu
(k souboru či adresáři) a takový odkaz pak můžeme používat v příkazech místo souboru
či adresáře, na který odkazuje – odkazuje-li na adresář, můžeme do něj „vstoupit“ příkazem „cd“
nebo použitím v adresářové cestě; odkazuje-li na soubor, můžeme ze souboru přes odkaz
číst nebo do něj zapisovat atd.; odkazuje-li na program či spustitelný skript,
můžeme ho přes symbolický odkaz spustit.

Nevýhodou symbolického odkazu je, že stále vede na stejné místo adresářové struktury,
a to i v případě, kdy byl jeho cíl přejmenován, smazán či nahrazen; symbolický odkaz tedy
nemá vazbu se souborem či adresářem jako takovým, ale s jeho pevným odkazem (umístěním
v adresářové struktuře) a může se stát neplatným, když jeho cíl přestane existovat.

## Definice

* **Pevný odkaz** je každá adresářová položka reprezentující obyčejný soubor. Součástí pevného odkazu je pouze název a umístění v adresáři, všechny ostatní údaje o souboru jsou vlastnostmi souboru jako takového.
* **Symbolický odkaz** je adresářová položka, která obsahuje cestu k souboru či adresáři. Symbolické odkazy dělíme na **absolutní** (které obsahují absolutní cestu) a **relativní** (obsahující relativní cestu). Symbolický odkaz, který odkazuje na neexistující cestu, se označuje jako **neplatný**.
* **Následovat** symbolický odkaz (follow) znamená chovat se, jako by se na jeho místě a pod jeho názvem skutečně nacházel odkazovaný soubor či adresář. Většina operací a programů symbolické odkazy následuje – pokusíte-li se spustit symbolický odkaz na program, spustí se program; pokusíte-li se symbolický odkaz otevřít v textovém editoru, otevře se odkazovaný soubor. Pokusíte-li se přejít do symbolického odkazu příkazem „cd“, přejdete do odkazovaného adresáře, atd.

!ÚzkýRežim: vyp

## Zaklínadla
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Pevné odkazy

*# **vytvořit** pevný odkaz na soubor (alternativy)*<br>
**ln** [**\-\-**] {*cesta-k-souboru*}... {*cesta-k-odkazu*}<br>
**ln -t** [**\-\-**] {*adresář-kde-vytvořit-odkaz*} {*cesta-k-souboru*}...

*# **smazat** pevný odkaz*<br>
**rm** [**\-\-**] {*cesta/k/odkazu*}...

*# vypsat **počet referencí** pevného odkazu*<br>
*// Uvedete-li cestu k symbolickému odkazu, parametr „-L“ způsobí vypsání jeho vlastního počítadla pevných odkazů; jinak se vypíše počítadlo odkazovaného souboru či adresáře.*<br>
**stat -c %h** [**-L**] <nic>[**\-\-**] {*cesta-k-odkazu*}

*# vypsat **kanonickou** (absolutní) cestu pevného odkazu*<br>
**readlink -f** {*cesta-k-odkazu*} ⊨ /etc/passwd

*# vypsat kanonickou cestu adresáře obsahujícího pevný odkaz*<br>
**readlink -f** {*cesta-k-odkazu*} **\| sed -E 's!((.)/?)[<nic>^/]+$!\\2!'** ⊨ /etc

*# přejmenovat/**přesunout** pevný odkaz*<br>
**mv** [**-i**] <nic>[**-f**] {*původní/cesta*} {*nová/cesta*}

<!--
*# vytvořit dočasný, zdánlivý, nerekurzivní pevný odkaz na adresář*<br>
**mkdir -p** {*nová-cesta*}<br>
**mount** [**-o ro**] **\-\-bind** {*původní-cesta*} {*nová-cesta*}

není dobrý nápad
-->

### Symbolické odkazy

*# **vytvořit** relativní/absolutní/obecný symbolický odkaz*<br>
*// Při vytváření obecného symbolického odkazu neprovádí příkaz „ln“ žádnou kontrolu obsahu odkazu; bez jakékoliv chyby vytvoří i odkaz, jehož obsah nedává žádný smysl!*<br>
**ln -rs**[**f**]<nic>[**T**] {*cesta/k/cíli*} {*cesta/k/odkazu*}<br>
**ln -s**[**f**]<nic>[**T**] **"$(readlink -f** {*cesta/k/cíli*}**)"** {*cesta/k/odkazu*}<br>
**ln -s**[**f**]<nic>[**T**]** "**{*obsah-odkazu*}**"** {*cesta/k/odkazu*}

*# **smazat** symbolický odkaz*<br>
**rm** [**\-\-**] {*cesta/k/odkazu*}...

*# odkazuje odkaz na soubor/na adresář/na pojmenovanou rouru?*<br>
?<br>
?<br>
?

*# je odkaz neplatný?*<br>
*// Pozor! Pokud nemáte přístup do adresáře, kam symbolický odkaz vede, bude se vám vždy jevit jako neplatný! V případě pochybností raději hledejte neplatné odkazy s použitím „sudo“.*<br>
?

*# vypsat obsah symbolického odkazu*<br>
**readlink** [**\-\-**] {*cesta/k/odkazu*}...

*# přejmenovat/**přesunout** symbolický odkaz*<br>
**mv** [**-i**] <nic>[**-f**] {*původní/cesta*} {*nová/cesta*}

### Ostatní

*# je adresářová položka symbolický odkaz?*<br>
**test -L** {*cesta/k/položce*}

*# osamostatnit pevný odkaz od ostatních odkazů*<br>
**test -f** {*název-souboru*} **-a -r** {*název-souboru*} **&amp;&amp; test "$(stat -c %h** {*název-souboru*}**)" -le 1 \|\| {&blank;cp \-\-preserve=all -iT \-\-** {*název-souboru*} {*název-souboru*}**~ &amp;&amp; mv -f** {*název-souboru*}**~** {*název-souboru*}**;&blank;}**
<!--
[ ] Otestovat!
-->


### Kopírování

*# kopírovat: zachovat symbolické odkazy doslovně*<br>
?

*# kopírovat: následovat symbolické odkazy*<br>
?

*# kopírovat: vynechat symbolické odkazy*<br>
?

*# kopírovat: symbolické odkazy nahradit prázdnými soubory*<br>
?

*# kopírovat adresáře; na soubory místo toho vytvořit v cíli pevné odkazy*<br>
?

*# kopírovat adresářovou strukturu bez souborů*<br>
**env -C** {*cesta/zdroje*} **find . -type d -print0 \| env -C** {*cesta/cíle*} **xargs -r0**[**t**] **mkdir -p**[**v**]
<!--
[ ] Vyzkoušet.
[ ] Problém: nezachovává atributy.
-->

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
* Symbolický odkaz sám o sobě je „nezapisovatelný“; pokud ho chceme změnit, musíme ho nejprve smazat a pak znovu vytvořit; to také znamená, že pokud se odkaz nachází v adresáři, kam nemáme právo zápisu, nemůžeme ani změnit obsah symbolického odkazu.
* Symbolický odkaz může odkazovat na jiný symbolický odkaz, ale maximální počet zanoření symbolických odkazů je 40.
* Maximální délka obsahu symbolického odkazu je 4095 bajtů; některé souborové systémy mohou mít přísnější omezení.

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
