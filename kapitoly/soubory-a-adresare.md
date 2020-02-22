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

Tato kapitola se zabývá prací s adresáři a jejich položkami (soubory, podadresáři apod.) včetně jejich metadat (např. přístupových práv či velikosti souborů).
Nepokrývá činnosti, kde záleží na konkrétním obsahu souborů (tzn. ani určování skutečného typu souborů).

## Definice

* **Adresářová položka** je pojmenovaná položka v adresáři; obvykle je to soubor (přesněji − pevný odkaz na soubor), další adresář či symbolický odkaz, méně často zařízení (např. „/dev/null“), pojmenovaná roura apod. Adresářové položky se identifikují svým **názvem**, který je v daném adresáři jedinečný a může obsahovat jakékoliv znaky UTF-8 kromě nulového bajtu a znaku „/“.
* Adresářová položka je **skrytá**, pokud její název začíná znakem „.“.

### Přístupová práva souborů a adresářů

Každá adresářová položka má vlastníka (což je některý uživatel, např. „root“), příslušnou skupinu (skupinu uživatelů) a nastavení přístupových práv. Přístupová práva se dělí do tří skupin: první skupina („u“) definuje práva vlastníka, druhá („g“) práva členů skupiny (případně kromě vlastníka) a třetí („o“) práva ostatních uživatelů. Pro pohodlnější nastavení práv všem třem skupinám se používá zkratka „a“.

Právo *čtení* (r, read) znamená:

* U souboru právo otevřít soubor pro čtení a přečíst jeho obsah, a to jak sekvenčně, tak přímým přístupem k částem souboru.
* U adresáře právo přečíst seznam názvů položek v adresáři bez dalších údajů. Nic víc.

Právo *zápisu* (w, write) znamená:

* U souboru právo otevřít daný soubor pro zápis, zkrátit ho (i na nulovou velikost), prodloužit ho, přepisovat existující bajty souboru a zapisovat nové na jeho konec.
* U adresáře právo vytvářet nové adresářové položky, měnit názvy stávajících a mazat stávající adresářové položky (při dodržení ostatních pravidel souborového systému).

Právo *spouštění* (x, execute) znamená:

* U souboru právo daný soubor spustit jako proces. Jde-li o samostatný binární program, toto právo ke spuštění stačí; jde-li o skript vyžadující interpret, je k jeho spuštění fakticky potřeba ještě právo „r“, protože jinak interpret nedostane přístup k instrukcím skriptu.
* U adresáře právo do daného adresáře vstoupit, zjistit informace o jeho položkách (např. typ položky či přístupová práva) a přistupovat k jeho souborům a podadresářům. Nezahrnuje však možnost přečíst seznam názvů položek, takže samotné právo „x“ k adresáři vyžaduje, aby program znal názvy položek, se kterými bude chtít pracovat. Samotné právo „r“ bez práva „x“ zase umožní programu vypsat seznam položek v adresáři, ale už k nim nemůže nijak přistoupovat, dokonce ani zjistit, zda je daná položka soubor či adresář.

Právo *zmocnění* (s, set-uid a set-gid) se uplatňuje pouze pro vlastníka a skupinu (tzn. ne pro „ostatní“) a v obou případech má mírně pozměněný význam:

* U souboru má právo zmocnění pro vlastníka (u+s) význam pouze v kombinaci s právem „x“ pro skupinu či ostatní a znamená, že proces vzniklý spuštěním daného souboru jiným uživatelem než vlastníkem dostane EUID vlastníka souboru a s ním i jeho práva. Nejčastějším použitím je získání práv superuživatele pro určitý program bez nutnosti zadávat jeho heslo.
* Analogicky funguje u souboru právo zmocnění pro skupinu − proces vzniklý po spuštění daného souboru dostane EGID skupiny souboru.
* U adresáře má význam pouze právo zmocnění pro skupinu − nově vytvořené adresářové položky v takovém adresáři budou příslušet skupině adresáře, ne skupině procesu, který je vytvořil. Toto právo automaticky dědí nově vzniklé podadresáře.

Právo *omezení smazání* (t, sticky-bit) se uplatňuje pouze pro „ostatní“ a má v současnosti význam pouze u adresářů, kde omezuje výkon práva „w“:

* V adresáři s nastaveným právem „t“ smí smazat nebo přejmenovat adresářovou položku jen vlastník této položky nebo vlastník celého adresáře. Vzniklé podadresáře toto právo automaticky nedědí!

Práva „s“ a „t“ se normálně vyskytují pouze v kombinaci s právem „x“, proto je příkaz „ls“ zobrazuje místo x; vyskytnou-li se bez práva „x“, zobrazí je příkaz „ls“ velkým písmenem − „S“ a „T“.

Pro superuživatele většina uvedených práv neplatí, výjimkou jsou jen právo „x“ u souborů a právo „s“ u adresářů.

!ÚzkýRežim: vyp

## Zaklínadla

### Testy adresářových položek

*# je položka2 novější než položka1? (z hlediska času poslední úpravy)*<br>
**test** {*položka2*} **-nt** {*položka1*}

*# odkazují dvě položky na tutéž entitu (soubor, adresář apod.)?*<br>
**test** {*položka1*} **-ef** {*položka2*}

*# je položka2 větší než položka1?*<br>
?

### Zjistit údaje o adresářových položkách

*# existuje adresářová položka?*<br>
**test -e** {*cesta*}

*# je adresářová položka soubor/adresář/symbolický odkaz/pojmenovaná roura?*<br>
**test -f** {*cesta*}<br>
**test -d** {*cesta*}<br>
**test -L** {*cesta*}<br>
**test -p** {*cesta*}

*# přístupová **práva** (číselně/textově)*<br>
**stat -c %a** {*cesta*}...<br>
**stat -c %A** {*cesta*}...

*# počet pevných odkazů*<br>
**stat -c %h** {*cesta*}...

*# **vlastník** (jméno/UID)*<br>
**stat -c %U** {*cesta*}...<br>
**stat -c %u** {*cesta*}...

*# **skupina** (název/GID)*<br>
**stat -c %G** {*cesta*}...<br>
**stat -c %g** {*cesta*}...

*# celková **velikost** (v bajtech/čitelně pro člověka)*<br>
**stat -c %s** {*cesta*}...<br>
**stat -c %s** {*cesta*}... **\| numfmt \-\-to iec**

*# skutečně zabraný prostor na disku (v bajtech/čitelně pro člověka)*<br>
**stat -c '%b\*%B'**  {*cesta*}... **\| bc**<br>
**stat -c '%b\*%B'**  {*cesta*}... **\| bc \| numfmt \-\-to iec**

*# datum a čas poslední změny (pro člověka/časová známka Unixu)*<br>
**stat -c %y** {*cesta*}...<br>
**stat -c %Y** {*cesta*}...

*# číslo **inode***<br>
**stat -c %i** {*cesta*}...

*# typ adresářové položky (písmeno/čitelně pro člověka)*<br>
?<br>
**stat -c %F** {*cesta*}...

*# příslušný přípojný bod (kořenový adresář souboru systémů, na kterém se položka nachází)*<br>
**stat -c %m** {*cesta*}...

### Změny adresářových položek

*# **přejmenovat** adresářovou položku*<br>
**mv** [{*parametry*}] {*původní-název*} {*nový-název*}

*# **smazat** adresářovou položku (jakoukoliv kromě adresáře/prázdný adresář/adresář rekurzívně)*<br>
**rm** [**-f**] {*cesta*}...<br>
**rmdir** {*cesta*}<br>
**rm -r**[**f**]<nic>[**v**] {*cesta*}...

### Aktuální adresář

<!--
?
-->
*# přepnout aktuální adresář na zadanou cestu/na předchozí aktuální adresář*<br>
**cd** {*cesta*}<br>
**cd -**

*# zjistit aktuální adresář*<br>
**pwd**

*# přejít do domovského adresáře*<br>
**cd**

### Vytvořit adresářovou položku

*# vytvořit prázdný **adresář***<br>
*// Parametr „-p“: vytvořit adresář, jen pokud ještě neexistuje; a v případě potřeby nejdřív vytvořit adresáře jemu nadřazené.*<br>
**mkdir** [**-v**] <nic>[**-m** {*práva*}] <nic>[**-p**] {*název*}

*# vytvořit prázdný **soubor***<br>
**touch** {*název*}

*# vytvořit symbolický odkaz*<br>
**ln -s "**{*obsah/odkazu*}**"** {*název*}

*# vytvořit pojmenovanou rouru*<br>
**mkfifo** [**-m** {*práva*}] {*název*}...

<!--
### Kopírování adresářů
-->

### Změnit přístupová práva a vlastnictví

*# zjistit přístupová práva souboru či adresáře (symbolicky/číselně)*<br>
*// Symbolické vyjádření práv zde odpovídá tomu, jak je vypisuje „ls“!*<br>
**stat -c %A** {*cesta*}... ⊨ -rwxrwxr-t<br>
**stat -c %a** {*cesta*}... ⊨ 1775

*# nastavit/zrušit práva r, w nebo x u souboru či adresáře*<br>
*// Tip: místo znaku „+“ můžete použít také „=“. V takovém případě se v dané kategorii uvedená práva nastaví (jako u „+“) a neuvedená se smažou (jako u „-“).*<br>
[**sudo**] **chmod** [**-R**] {*kdo-[ugoa]*}**+**{*práva-[rwxst]*} {*cesta*}...<br>
[**sudo**] **chmod** [**-R**] {*kdo-[ugoa]*}**-**{*práva-[rwxst]*} {*cesta*}...

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

## Parametry příkazů
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
* ☐ -m {*práva*} :: Vytvořenému adresáři nastaví uvedený mód. Ten může být zadán symbolicky (např. „u=rwx,g=rx,o=“) nebo číselně (např. „755“).


## Instalace na Ubuntu

Všechny použité nástroje jsou základními součástmi Ubuntu.

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
