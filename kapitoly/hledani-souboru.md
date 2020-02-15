<!--

Linux Kniha kouzel, kapitola Hledání souborů
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

⊨
-->

# Hledání souborů

!Štítky: {tematický okruh}
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

## Zaklínadla (find: testy)
### Typ (soubor, adresář, odkaz....)

*# obyčejný soubor*<br>
**\-type f**

*# adresář*<br>
**\-type d**

*# symbolický odkaz (jakýkoliv/na soubor/na adresář/absolutní/relativní)*<br>
**\-type l**<br>
**\-type l \-xtype f**<br>
**\-type l \-xtype d**<br>
**\-lname "/\*"**<br>
**\-type l \\! -lname "/\*"**

*# speciální zařízení (blokové/znakové/jakékoliv)*<br>
**\-type b**<br>
**\-type c**<br>
**\-type b,c**

*# pojmenovaná roura*<br>
**\-type p**

*# soket*<br>
**\-type s**

### Název souboru a cesta

Písmeno „i“ vypne rozlišování mezi velkými a malými písmeny.

*# **název** položky*<br>
**\-**[**i**]**name "**{*vzorek*}**"**

*# **cesta** položky*<br>
**\-**[**i**]**path "**{*vzorek*}**"**

*# cesta položky se shoduje s **regulárním výrazem***<br>
**\-**[**i**]**regex '**{*regulární výraz*}**'**

*# hodnota symbolického odkazu*<br>
**\-**[**i**]**lname "**{*vzorek*}**"**

### Velikost souboru

*# **M až N** gibibajtů/mebibajtů/kibibajtů/bajtů*<br>
**\-size +$((**{*M*}**\*2\*\*30-1))c -size -$((**{*N*}**\*2\*\*30+1))c**<br>
**\-size +$((**{*M*}**\*2\*\*20-1))c -size -$((**{*N*}**\*2\*\*20+1))c**<br>
**\-size +$((**{*M*}**\*2\*\*10-1))c -size -$((**{*N*}**\*2\*\*10+1))c**<br>
**\-size +$((**{*M*}**-1))c -size -$((**{*N*}**+1))c**

*# **M až N** gigabajtů/megabajtů/kilobajtů/bajtů*<br>
**\-size +$((**{*M*}**\*10\*\*9-1))c -size -$((**{*N*}**\*10\*\*9+1))c**<br>
**\-size +$((**{*M*}**\*10\*\*6-1))c -size -$((**{*N*}**\*10\*\*6+1))c**<br>
**\-size +$((**{*M*}**\*10\*\*3-1))c -size -$((**{*N*}**\*10\*\*3+1))c**<br>
**\-size +$((**{*M*}**-1))c -size -$((**{*N*}**+1))c**

*# **minimálně** N gibibajtů/mebibajtů/kibibajtů/bajtů*<br>
**\-size +$((**{*N*}**\*2\*\*30-1))c**<br>
**\-size +$((**{*N*}**\*2\*\*20-1))c**<br>
**\-size +$((**{*N*}**\*2\*\*10-1))c**<br>
**\-size +$((**{*N*}**-1))c**<br>

*# **maximálně** N gibibajtů/mebibajtů/kibibajtů/bajtů*<br>
**\-size -$((**{*N*}**\*2\*\*30+1))c**<br>
**\-size -$((**{*N*}**\*2\*\*20+1))c**<br>
**\-size -$((**{*N*}**\*2\*\*10+1))c**<br>
**\-size -$((**{*N*}**+1))c**<br>

*# **minimálně** N gigabajtů/megabajtů/kilobajtů*<br>
**\-size +$((**{*N*}**\*10\*\*9-1))c**<br>
**\-size +$((**{*N*}**\*10\*\*6-1))c**<br>
**\-size +$((**{*N*}**\*10\*\*3-1))c**<br>
**\-size +$((**{*N*}**-1))c**<br>

*# **maximálně** N gigabajtů/megabajtů/kilobajtů*<br>
**\-size -$((**{*N*}**\*10\*\*9+1))c**<br>
**\-size -$((**{*N*}**\*10\*\*6+1))c**<br>
**\-size -$((**{*N*}**\*10\*\*3+1))c**<br>
**\-size -$((**{*N*}**+1))c**<br>

*# **přesně** N gibibajtů/mebibajtů/kibibajtů/bajtů*<br>
**\-size $((**{*N*}**\*2\*\*30))c**<br>
**\-size $((**{*N*}**\*2\*\*20))c**<br>
**\-size $((**{*N*}**\*2\*\*10))c**<br>
**\-size** {*N*}**c**<br>

*# **přesně** N gigabajtů/megabajtů/kilobajtů/bajtů*<br>
**\-size $((**{*N*}**\*10\*\*9))c**<br>
**\-size $((**{*N*}**\*10\*\*6))c**<br>
**\-size $((**{*N*}**\*10\*\*3))c**<br>
**\-size** {*N*}**c**<br>

*# **prázdný** soubor*<br>
**\-size 0**

### Čas („změněno“, „poslední přístup“)

*# změněno/poslední přístup v rozsahu dnů*<br>
*// Dny zadejte ve formátu %F (YYYY-MM-DD).*<br>
**-newermt "**{*první-den-intervalu*} **00:00:00" \\! -newermt "**{*poslední-den-intervalu*} **23:59:59"**<br>
**-newerat "**{*první-den-intervalu*} **00:00:00" \\! -newerat "**{*poslední-den-intervalu*} **23:59:59"**
<!--
[ ] VYZKOUŠET!
-->

<!--
-amin {} :: poslední přístup
-mmin {} :: změněno
-newer[am]t '{čas}'

Operátory:
( xxx )
xxx xxx
xxx -o xxx # nižší priorita
xxx , xxx # priorita?

-->

### Vlastnictví

*# vlastník souboru (názvem/UID)*<br>
**\-user** {*uživatel*}<br>
**\-uid** {*UID*}

*# skupina (názvem/GID)*<br>
**\-group** {*skupina*}<br>
**\-gid** {*GID*}

### Přístupová práva

*# soubor je přístupný pro **čtení***<br>
**\-readable**

*# soubor je přístupný pro **zápis***<br>
**\-writable**

*# soubor je fakticky **spustitelný***<br>
**\-executable**

*# vlastník (u), skupina (g) či ostatní (o) mají právo (jedno z r, w, x)*<br>
**\-perm /**{*kdo*}**=**{*právo*}<br>
**\\! -perm /**{*kdo*}**=**{*právo*}

*# všichni mají určité právo*<br>
**\-perm -ugo=**{*právo*}

*# vlastník (u), skupina (g) či ostatní (o) mají všechna práva*<br>
**\-perm -**{*kdo*}**=rwx**

<!--
-perm /{...} = „nebo“ − mezi uvedenými musí existovat právo, které je položkou splněno
-perm -{...} = „a“ − všechna uvedená práva musejí být položkou splněna
-->

### Ostatní

*# prázdný adresář*<br>
**\-type d -empty**

*# pevné odkazy konkrétního souboru*<br>
**\-samefile** {*soubor*}

*# test, který vždy uspěje/selže*<br>
**\-true**<br>
**\-false**

*# počet pevných odkazů (přesně/minimálně/maximálně N)*<br>
**\-links** {*N*}<br>
**\-links +$((**{*N*}**-1))**<br>
**\-links -$((**{*N*}**+1))**

*# obsah symbolického odkazu odpovídá vzorku*<br>
**\-lname** {*vzorek*}

*# vlastník nebo skupina souboru neexistuje*<br>
**\\( -nogroup -o -nouser \\)**

*# typ souborového systému*<br>
*// Např. „ext4“, „tmpfs“, „ntfs“, „vfat“.*<br>
**\-fstype** {*typ*}

*# čislo **inode***<br>
**\-inum** {*inode*}



## Zaklínadla (find: akce)

*# smazat soubor či prázdný adresář*<br>
*// Akce uspěje, pokud se soubor či adresář podaří smazat.*<br>
**\-delete**

<!--
[ ] -depth?
[ ] -prune − Jde-li o adresář, nezkoumat jeho obsah.
-->

*# spustit příkaz po dávkách*<br>
*// Tato varianta je prakticky ekvivalentem volání příkazu xargs. Použije co největší dávky.*<br>
**\-exec** {*příkaz*} [{*parametry příkazu*}] **'{}' +**

*# spustit příkaz po dávkách*<br>
*// Tato akce vždy uspěje. Přitom shromáždí položky z jednotlivých adresářů a najednou je předá ke zpracování uvedenému příkazu. Pouze pokud je souborů velké množství, může je rozdělit na několik dávek. Příkaz se spouští v adresáři, kde jsou vyhledané položky.*<br>
**\-execdir** {*příkaz*} [{*parametry příkazu*}] **'{}' +**


*# spustit příkaz pro každou cestu zvlášť*<br>
*// Každý výskyt řetězce „{}“ v parametrech příkazu bude při volání nahrazen cestou testované položky. Akce uspěje, pokud uspěje příkaz.*<br>
**\-exec** {*příkaz*} [{*parametry příkazu*}] **\\;**



*# spustit příkaz pro každý soubor zvlášť*<br>
*// Každý výskyt řetězce „{}“ v parametrech příkazu bude při volání nahrazen řetězcem „./název souboru“ a příkaz bude spuštěn v adresáři, kde se soubor nachází. Akce uspěje, pokud uspěje příkaz.*<br>
**\-execdir** {*příkaz*} [{*parametry příkazu*}] **\\;**



*# zapsat cestu jako záznam do souboru (txt/txtz)*<br>
?<br>
**\-fprint0** {*soubor*}

<!--
-fprint {soubor}
-fprint0 {soubor}
-fprintf {soubor} {formát}
-print0
-printf {formát}

fprintf:
%fhlpP − quoted

-ok[dir] {příkaz} [parametry] ; − jako exec[dir], ale zeptá se uživatele

-->

*# ukončit načítání dalších položek*<br>
**\-quit**

## Zaklínadla (printf a fprintf)

*# cíl symbolického odkazu*<br>
**%l**
<!--
[ ] Pokud není s. odkaz, prázdný řetězec?
-->

*# počet pevných odkazů*<br>
**%n**

*# velikost souboru v bajtech*<br>
**%s**

*# vlastník (jméno/UID)*<br>
**%u**<br>
**%U**

*# hloubka prohledávání*<br>
**%d**

## Zaklínadla (celé příkazy)

*# najít a odstranit prázdné adresáře/soubory/soubory i adresáře*<br>
**find** {*kde*}... **-type d -empty -delete**<br>
**find** {*kde*}... **-type f -empty -delete**<br>
**find** {*kde*}... **-empty -delete**

## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

### find

*# *<br>
**find** {*globální parametry*} {*cesta*}... {*testy-a-akce*}

<neodsadit>Globální parametry:

!parametry:

* ◉ -P ○ -L ○ -H :: Kdy se k symbolickým odkazům chovat, jako by to byly odkazované soubory či adresáře: P = nikdy (výchozí stav); L = vždy; H = jen, jsou-li přímo uvedeny jako „cesta“.
* ☐ -depth :: Adresář zpracuje až „na odchodu“, tzn. teprve po zpracování veškerého jeho obsahu. Normálně se adresář zpracuje jako první a pak se teprve testuje jeho obsah.
* ☐ -maxdepth {*číslo*} :: Sestoupí maximálně do uvedené hloubky. 0 znamená testovat jen cesty uvedené na příkazovém řádku; 1 znamená testovat i položky v adresářích uvedených na příkazovém řádku; 2 znamená testovat i položky v podadresářích těchto adresářů atd.
* ☐ -mindepth {*číslo*} :: Na položky v hloubce nižší než „číslo“ se nebudou aplikovat žádné testy ani akce a nebudou vypsány.
* ☐ -xdev :: Po každou „cestu“ na příkazové řádce omezí prohledávání jen na jeden souborový systém.



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
