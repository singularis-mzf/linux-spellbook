<!--

Linux Kniha kouzel, kapitola Soubory a adresáře
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

+ atributy
+ rsync
+ který soubor je větší/novější/...
+ touch

⊨
-->

# Soubory a adresáře

!Štítky: {tematický okruh}{adresáře}{soubory}

!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

Tato kapitola se zabývá prací s adresáři a jejich položkami (soubory, podadresáři apod.) včetně jejich metadat (např. přístupových práv či velikosti souborů).
Nepokrývá činnosti, kde záleží na konkrétním obsahu souborů (tzn. ani určování skutečného typu souborů).

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

* **Adresářová položka** je pojmenovaná položka v adresáři; obvykle je to soubor (přesněji − pevný odkaz na soubor), další adresář či symbolický odkaz, méně často zařízení (např. „/dev/null“), pojmenovaná roura apod. Název každé adresářové položky v jednom adresáři je jedinečný a může obsahovat jakékoliv znaky UTF-8 kromě nulového bajtu a znaku „/“.
* Adresářová položka je **skrytá**, pokud její název začíná znakem „.“.

!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Zjistit údaje o adresářových položkách

*# typ adresářové položky (písmeno/čitelně pro člověka)*<br>
?<br>
**stat -c %F** {*cesta*}...

*# přístupová práva (číselně/textově)*<br>
**stat -c %a** {*cesta*}...<br>
**stat -c %A** {*cesta*}...

*# počet pevných odkazů*<br>
**stat -c %h** {*cesta*}...

*# vlastník (název/UID)*<br>
**stat -c %U** {*cesta*}...<br>
**stat -c %u** {*cesta*}...

*# skupina (název/GID)*<br>
**stat -c %G** {*cesta*}...<br>
**stat -c %g** {*cesta*}...

*# celková velikost (v bajtech/čitelně pro člověka)*<br>
**stat -c %s** {*cesta*}...<br>
**stat -c %s** {*cesta*}... **\| numfmt \-\-to iec**

*# skutečně zabraný prostor na disku (v bajtech/čitelně pro člověka)*<br>
**stat -c '%b\*%B'**  {*cesta*}... **\| bc**<br>
?

*# datum a čas poslední změny (pro člověka/časová známka Unixu)*<br>
**stat -c %y** {*cesta*}...<br>
**stat -c %Y** {*cesta*}...

*# příslušný přípojný bod (kořenový adresář souboru systémů, na kterém se položka nachází)*<br>
**stat -c %m** {*cesta*}...

*# číslo inode*<br>
**stat -c %i** {*cesta*}...



### ...

*# přejmenovat adresářovou položku*<br>
**mv** [{*parametry*}]

*# smazat adresářovou položku (kromě adresáře)*<br>
**rm** [**-f**] {*cesta*}...

*# smazat prázdný adresář*<br>
**rmdir** {*cesta*}

*# smazat adresář rekurzívně*<br>
**rm -r**[**f**]<nic>[**v**] {*cesta*}...

*# vytvořit adresář*<br>
**mkdir** [**-v**] {*cesta*}...

*# vytvořit adresář a všechny jemu nadřazené, jen pokud neexistují*<br>
**mkdir -p**[**v**] {*cesta*}...

*# přepnout aktuální adresář*<br>
**cd** {*cesta*}

*# zjistit aktuální adresář*<br>
**pwd**

*# přejít do domovského adresáře*<br>
**cd**

### Kopírování adresářů

### Přístupová práva a vlastnictví

*# zjistit přístupová práva souboru či adresáře (symbolicky/číselně)*<br>
?<br>
?

*# nastavit/zrušit práva r, w nebo x u souboru či adresáře*<br>
?<br>
?

*# změnit skupinu souboru či adresáře*<br>
[**sudo**] **chgrp** [**-R**] <nic>[**-c**] {*nová-skupina*} {*cesta*}...

*# změnit **vlastníka** souboru či adresáře*<br>
**sudo chown** [**-R** [**-L**]] <nic>[**-c**] <nic>[**\-\-from=**[{*původní-vlastník*}]**:**[{*původní-skupina*}]] {*nový-vlastník*}[**:**{*nová-skupina*}] {*cesta*}...

### Zvláštní restrikce ext4

<!--
Následující zvláštní restrikce se podobají přístupovým právům, ale lze je použít
pouze na souborových systémech ext2 až ext4 (nezkoumal/a jsem ZFS, btrfs apod.,
ale tmpfs je nepodporuje). Na rozdíl od přístupových práv účinkují i na superuživatele a brání nejen obsah souboru či adresáře, ale také většinu jeho metadat a spolehlivě chrání soubor či adresář před smazáním.
-->

*# nastavit/zrušit zvláštní restrikci zakazující změny souboru či adresáře*<br>
*// Je-li tato restrikce nastavena na adresář, není možno v něm vytvářet či mazat soubory, je však možno do souborů zapisovat a měnit jejich metadata.*<br>
**sudo chattr** [**-R**] **+i** {*cesta*}...<br>
**sudo chattr** [**-R**] **-i** {*cesta*}...

*# nastavit/zrušit zvláštní restrikci změn dovolující jen připojování na konec souboru*<br>
**sudo chattr** [**-R**] **+a** {*cesta*}...<br>
**sudo chattr** [**-R**] **-a** {*cesta*}...

### Zjistit

*# místo zabrané souborem na disku*<br>
?

## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

### mv

*# *<br>
**mv** [{*parametry*}] {*zdroj*}... {*cíl*}<br>
**mv** [{*parametry*}] **-t** {*cílový-adresář*} {*zdroj*}...

!Parametry:

* ◉ -f ○ -i ○ -n ○ -b ○ -u :: Existující cílový soubor: přepsat bez ptaní/zeptat se/nepřesouvat/přejmenovat a nahradit/přepsat, pokud je starší.
* ☐ -v :: Vypisovat provedené operace.
* ☐ -T :: Cíl musí být soubor; je-li to existující adresář, selže s chybou.

### mkdir

!Parametry:

* ☐ -p :: Vytvoří adresář, pokud ještě neexistuje. Je-li to třeba, vytvoří i nadřazené adresáře.
* ☐ -v :: Vypisovat provedené operace.
* ☐ --mode {*mód*} :: Vytvořenému adresáři nastaví uvedený mód. Ten může být zadán symbolicky (např. „u=rwx,g=rx,o=“) nebo číselně (např. „755“).


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
