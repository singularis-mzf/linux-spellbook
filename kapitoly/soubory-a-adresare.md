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

⊨
-->

# Soubory a adresáře

!Štítky: {tematický okruh}{adresáře}{soubory}{přístupová práva}

!ÚzkýRežim: zap

## Úvod

Tato kapitola se zabývá prací s adresáři a jejich položkami (soubory, podadresáři apod.),
včetně jejich vlastnictví, přístupových práv a speciálních atributů.
Patří sem rovněž zjišťování velikosti souborů.
Tato kapitola však nepokrývá činnosti, kde záleží na konkrétním obsahu souborů.
(Tyto činnosti budou předmětem kapitol Zpracování binárních souborů a zpracování textových souborů.)

Pevnými a symbolickými odkazy se tato kapitola zabývá velmi okrajově, bude jim věnována
samostatná kapitola.

## Definice

* **Adresářová položka** je jednoznačně pojmenovaná položka v adresáři; obvykle je to soubor (přesněji − pevný odkaz na soubor), další adresář či symbolický odkaz, méně často zařízení (např. „/dev/null“), pojmenovaná roura apod. Adresářové položky se v daném adresáři identifikují svým **názvem**, který může obsahovat jakékoliv znaky UTF-8 kromě nulového bajtu a znaku „/“.
* Adresářová položka je **skrytá**, pokud její název začíná znakem „.“.
* **Přístupová práva** jsou nastavení souboru či adresáře (ne symbolického odkazu) uložená v souborovém systému, která určují, kteří uživatelé budou moci s daným souborem či adresářem zacházet.
* **Uživatelské rozšířené atributy** (URA) jsou mechanismus souborového systému ext4 k ukládání doplňujících údajů k souborům a adresářům. Tyto položky se ukládají v podobě dvojic klíč-hodnota a při kopírování se obvykle ztratí; navíc většinou nejsou dostupné uživatelům.
<!--
* **Kanonická cesta** je absolutní cesta k adresářové položce od kořenového adresáře, která neobsahuje symbolické odkazy ani žádné zbytečné prvky.
-->

### Vlastnictví souborů a adresářů

Každá adresářová položka, která představuje soubor či adresář, má vlastníka (což je některý uživatel, např. „root“) a příslušnou skupinu. Tyto údaje obvykle získá podle procesu, který ji vytvořil, mohou však být změněny.

### Přístupová práva souborů a adresářů

V linuxovém souborovém systému existují tři základní práva, která se u adresářové položky nastavují:

Právo *čtení* (r, read) znamená:

* U souboru právo otevřít soubor pro čtení a přečíst jeho obsah, a to jak sekvenčně, tak na přeskáčku.
* U adresáře právo přečíst seznam názvů položek v adresáři bez dalších údajů. Nic víc.

Právo *zápisu* (w, write) znamená:

* U souboru právo otevřít daný soubor pro zápis, zkrátit ho (i na nulovou velikost), přepisovat existující bajty souboru a zapisovat nové na jeho konec.
* U adresáře právo vytvářet nové adresářové položky, měnit názvy stávajících a mazat stávající adresářové položky. Toto právo není potřeba k nastavení přístupových práv a dalších atributů souborů a poadresářů, protože ta jsou vlastnostmi odkazovaných souborů a adresářů, nikoliv součástí adresáře.

Právo *spouštění* (x, execute) znamená:

* U souboru právo daný soubor spustit jako proces. Toto právo stačí, pokud se jedná o zkompilovaný program; jde-li ve skutečnosti o interpretovaný skript, je potřeba také právo „r“, jinak se spuštěný interpret k obsahu skriptu nedostane a nebude ho moci vykonat.
* U adresáře právo do daného adresáře vstoupit, zjistit informace o jeho položkách (např. typ položky či přístupová práva) a dál přistupovat k jeho souborům a podadresářům. Nezahrnuje však možnost přečíst seznam názvů položek, takže pokud máte k adresáři samotné právo „x“, musíte znát názvy jeho položek, abyste s nimi mohli zacházet. (Samotné právo „r“ bez práva „x“ zase umožní programu vypsat seznam položek v adresáři, ale už o nich nebude moci nic zjistit, dokonce ani zda je daná položka soubor či adresář.

Tato tři základní práva se nastavují samostatně pro vlastníka („u“), skupinu („g“)
a ostatní („o“); navíc je lze také nastavit pro jednotlivé konkrétní uživatele
či konkrétní skupiny, ovšem toto „rozšířené nastavení“ se nikdy neuplatní na vlastníka.
Přesná pravidla jsou značně komplikovaná, proto je tu nebudu vysvětlovat.

Vedle přístupových práv může mít každá adresářová položka nastaveny ještě tři speciální příznaky:

*Příznak zmocnění vlastníka* (u+s, set-uid bit) má význam pouze u souborů
a pouze v kombinaci s právem „x“. Je-li takový soubor spuštěn, vzniklý proces
získá EUID (a tedy i práva) vlastníka souboru, a to i v případě, že ho spustil jiný uživatel.
Nejčastějším použitím je spuštění určitého program u s právy superuživatele.

*Příznak zmocnění skupiny* (g+s, set-gid bit) funguje u souborů analogicky
− spustí-li daný soubor kterýkoliv uživatel, vzniklý proces získá EGID (tedy skupinová práva)
skupiny souboru. Navíc ovšem funguje i u adresářů − všechny nově vytvořené adresářové položky
v adresáři s příznakem zmocnění pro skupinu budou při vytvoření přiřazeny stejné skupině
jako adresář, ve kterém byly vytvořeny. (Normálně by získaly skupinu podle procesu,
který je vytvořil.) Podadresáře navíc získávají také příznak zmocnění pro skupinu,
což znamená, že tento příznak se automaticky rozšíří i do všech nově vytvořených poadresářů,
pokud u nich nebude včas zrušen.

Třetí speciální příznak je *příznak omezení smazání* (+t, sticky-bit).
Ten má význam pouze u adresářů a pouze v kombinaci s právem „w“ − v adresáři s tímto příznakem
může adresářové položky smazat či přejmenovat jen vlastník dané položky nebo vlastník adresáře.
Tento příznak je typicky nastaven na adresáři „/tmp“. Poznámka: vzniklé poadresáře tento
příznak nedědí.

### Superuživatel

Na superuživatele se z běžných přístupových práv vztahuje pouze právo spouštění
u souborů a příznak zmocnění pro skupinu. Ostatní nastavení běžných přístupových práv
na něj nemají vliv. (Existují ale další, speciální přístupová práva, která na něj vliv mají.)

!ÚzkýRežim: vyp

## Zaklínadla

### Vypsat seznam adresářových položek (pro člověka)

*# všech kromě skrytých*<br>
**ls** [**-lh**] <nic>[{*adresář*}]

*# všech kromě „.“ a „..“*<br>
**ls -A**[**lh**] <nic>[{*adresář*}]

*# jen adresářů (a symbolických odkazů na ně)(kromě/včetně skrytých)*<br>
**tree -dL 1**<br>
**tree -daL 1**

*# jen souborů*<br>
?

*# adresářů a podadresářů včetně symbolických odkazů na adresáře (kromě/včetně skrytých)*<br>
**tree -d**[**a**]<nic>[**L** {*úrovní*}]<br>
**tree -da**[**L** {*úrovní*}]

*# úplně všech*<br>
**ls -a**[**lh**] <nic>[{*adresář*}]

### Vypsat seznam adresářových položek (pro skript)

*# všech kromě „.“ a „..“ (txt/txtz)*<br>
*// Poznámka: příkaz „find“ escapuje svůj výstup, pokud je veden na terminál. Je-li toto chování nežádoucí, nechte jeho výstup ještě projít dalším filtrem, např. „cat“.*<br>
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -printf %P\\n**<br>
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -printf %P\\0**

*# jen souborů (txt/txtz)*<br>
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -type f -printf %P\\n**<br>
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -type f -printf %P\\0**

*# jen adresářů (txt/txtz)*<br>
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -type d -printf %P\\n**<br>
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -type d -printf %P\\0**

*# všech kromě skrytých (txt/txtz)*<br>
?<br>
?

*# úplně všech (txt/txtz)*<br>
**{ printf %s\\n . ..; find** {*adresář*} **-mindepth 1 -maxdepth 1 -printf %P\\n }**<br>
**{ printf %s\\0 . ..; find** {*adresář*} **-mindepth 1 -maxdepth 1 -printf %P\\0 }**
<!--
[ ] Vyzkoušet!
-->

### Testy

*# existuje adresářová položka?*<br>
**test -e** {*cesta*}

*# je adresářová položka soubor/adresář/symbolický odkaz/pojmenovaná roura?*<br>
**test -f** {*cesta*}<br>
**test -d** {*cesta*}<br>
**test -L** {*cesta*}<br>
**test -p** {*cesta*}

*# je soubor neprázdný/**prázdný**?*<br>
**test -f** {*cesta*} **-a -s** {*cesta*}<br>
**test -f** {*cesta*} **-a \\! -s** {*cesta*}

### Srovnání adresářových položek

*# je položka1 **novější** než položka2? (z hlediska času poslední úpravy)*<br>
**test** {*položka1*} **-nt** {*položka2*}

*# je soubor1 **větší** než soubor2?*<br>
?

*# odkazují dvě položky na tutéž entitu (soubor, adresář apod.)?*<br>
**test** {*položka1*} **-ef** {*položka2*}

*# jsou obě položky stejně staré?*<br>
**test** \\! {*položka1*} **-nt** {*položka2*} **-a** \\! {*položka1*} **-ot** {*položka2*}

### Zjistit údaje o adresářových položkách

*# kompletní přístupová **práva** (kompletní/základní číselně/základní textově pro člověka)*<br>
**getfacl -ac** [**\-\-**] {*cesta*}... ⊨ user\:\:rw- (výstup má víc řádků)<br>
**stat -c %**[**04**]**a** [**\-\-**] {*cesta*}... ⊨ -rwxrwxr-t<br>
**stat -c %A** [**\-\-**] {*cesta*}... ⊨ 1775

*# celková **velikost** (v bajtech/čitelně pro člověka)*<br>
**stat -c %s** {*cesta*}...<br>
**stat -c %s** {*cesta*}... **\| numfmt \-\-to iec**

*# skutečně zabraný prostor na disku (v bajtech/čitelně pro člověka)*<br>
**stat -c '%b\*%B'**  {*cesta*}... **\| bc**<br>
**stat -c '%b\*%B'**  {*cesta*}... **\| bc \| numfmt \-\-to iec**

*# **vlastník** (jméno/UID)*<br>
**stat -c %U** {*cesta*}...<br>
**stat -c %u** {*cesta*}...

*# **skupina** (název/GID)*<br>
**stat -c %G** {*cesta*}...<br>
**stat -c %g** {*cesta*}...

*# datum a čas poslední změny (pro člověka či skript/časová známka Unixu)*<br>
**stat -c %y** {*cesta*}...<br>
**stat -c %Y** {*cesta*}...

*# počet pevných odkazů*<br>
**stat -c %h** {*cesta*}...

*# číslo **inode***<br>
**stat -c %i** {*cesta*}...

*# typ adresářové položky (písmeno/čitelně pro člověka)*<br>
?<br>
**stat -c %F** {*cesta*}...

*# příslušný přípojný bod (kořenový adresář souboru systémů, na kterém se položka nachází)*<br>
**stat -c %m** {*cesta*}...

### Aktuální adresář

*# přejít do daného adresáře/na předchozí aktuální adresář*<br>
**cd** {*cesta*}<br>
**cd -**

*# zjistit aktuální adresář*<br>
**pwd**

*# přejít do domovského adresáře*<br>
**cd**

*# přejít o úroveň výš*<br>
**cd ..**

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

### Změnit/smazat adresářovou položku

*# **přejmenovat** adresářovou položku*<br>
**mv** [{*parametry*}] <nic>[**\-\-**] {*původní-název*} {*nový-název*}

*# smazat **neadresář***<br>
**rm** [**-f**] <nic>[**\-\-**] {*cesta*}...

*# smazat prázdný adresář*<br>
**rmdir** [**\-\-**] {*cesta*}<br>

*# smazat rekurzívně veškerý obsah adresáře a nakonec i samotný adresář*<br>
*// Tuto variantu můžete použít i na jednotlivé soubory.*<br>
**rm -r**[**f**]<nic>[**v**] <nic>[**\-\-**] {*cesta*}...

### Změnit čas, vlastnictví a skupinu

*# nastavit čas poslední změny na aktuální čas*<br>
[**sudo**] **touch -c** [**\-\-**] {*cesta*}...

*# změnit **vlastníka** souboru či adresáře (volitelně i skupinu)*<br>
**sudo chown** [**-R** [**-L**]] <nic>[**-c**] <nic>[**\-\-from=**[{*původní-vlastník*}]**:**[{*původní-skupina*}]] {*nový-vlastník*}[**:**{*nová-skupina*}] <nic>[**\-\-**] {*cesta*}...

*# změnit skupinu souboru či adresáře*<br>
[**sudo**] **chgrp** [**-R**] <nic>[**-c**] {*nová-skupina*} [**\-\-**] {*cesta*}...

*# nastavit čas poslední změny (obecně/příklady...)*<br>
*// Pozor! Příkaz „touch“ při tomto použití tiše ignoruje neexistující soubory!*<br>
[**sudo**] **touch -cd "**{*datum-čas*}**"** [**\-\-**] {*cesta*}...<br>
**sudo touch -cd "2019-04-21 23:59:58" \-\- /root/mujsoubor.txt**<br>
**touch -cd "2019-04-21 23:59:58.123456789" \-\- ~/mujsoubor.txt**<br>

### Změnit přístupová práva

*# nastavit práva „rwx“ pro vlastníka, „rx“ pro skupinu a nic pro ostatní (alternativy)*<br>
[**sudo**] **chmod** [**-R**] **u=rwx,g=rx,o=-** [**\-\-**] {*cesta*}...<br>
[**sudo**] **setfacl** [**-R**] **u\:\:rwx,g\:\:rx,o\:\:-** [**\-\-**] {*cesta*}...

*# odebrat všem všechna práva*<br>
[**sudo**] **setfacl** [**-R**] **-bm** **u\:\:-,g\:\:-,o\:\:-** [**\-\-**] {*cesta*}...

*# přidat/odebrat vlastníkovi právo „x“*<br>
[**sudo**] **chmod** [**-R**] **u+x** [**\-\-**] {*cesta*}...<br>
[**sudo**] **chmod** [**-R**] **u-x** [**\-\-**] {*cesta*}...

*# přidat/odebrat vlastníkovi a skupině právo „x“*<br>
[**sudo**] **chmod** [**-R**] **ug+x** [**\-\-**] {*cesta*}...<br>
[**sudo**] **chmod** [**-R**] **ug-x** [**\-\-**] {*cesta*}...

*# přidat/odebrat všem práva „r“ a „x“*<br>
[**sudo**] **chmod** [**-R**] **a+rx** [**\-\-**] {*cesta*}...<br>
[**sudo**] **chmod** [**-R**] **a-rx** [**\-\-**] {*cesta*}...

*# nastavit práva „rwx“ pro vlastníka a „rx“ pro ostatní, práva pro skupinu neměnit (alternativy)*<br>
[**sudo**] **chmod** [**-R**] **u=rwx,o=rx** [**\-\-**] {*cesta*}...<br>
[**sudo**] **setfacl** [**-R**] **u\:\:rwx,g\:\:rx,o\:\:-** [**\-\-**] {*cesta*}...

*# nastavit samostatná práva „rx“ uživateli „filip“*<br>
[**sudo**] **setfacl** [**-R**] **-m u:filip:rx** [**\-\-**] {*cesta*}...

*# zrušit samostatná práva uživatele „filip“*<br>
[**sudo**] **setfacl** [**-R**] **-x u:filip** [**\-\-**] {*cesta*}...

*# zrušit samostatná práva všech uživatelů a skupin*<br>
[**sudo**] **setfacl** [**-R**] **-b** [**\-\-**] {*cesta*}...

<!--
[**sudo**] **chmod** [**-R**] **750** [**\-\-**] {*cesta*}...<br>
-->

### Speciální příznaky (změny)

*# zapnout/vypnout příznak omezení smazání (**+t**)*<br>
[**sudo**] **chmod** [**-R**] **+t** [**\-\-**] {*cesta*}...<br>
[**sudo**] **chmod** [**-R**] **-t** [**\-\-**] {*cesta*}...

*# zapnout/vypnout příznak zmocnění skupiny (**g+s**)*<br>
[**sudo**] **chmod** [**-R**] **g+s** [**\-\-**] {*cesta*}...<br>
[**sudo**] **chmod** [**-R**] **g-s** [**\-\-**] {*cesta*}...

*# zapnout/vypnout příznak zmocnění vlastníka (**u+s**)*<br>
[**sudo**] **chmod** [**-R**] **u+s** [**\-\-**] {*cesta*}...<br>
[**sudo**] **chmod** [**-R**] **u-s** [**\-\-**] {*cesta*}...

*# zapnout/vypnout současně všechny tři speciální příznaky*<br>
[**sudo**] **chmod** [**-R**] **ug+s,+t** [**\-\-**] {*cesta*}...<br>
[**sudo**] **chmod** [**-R**] **ug-s,-t** [**\-\-**] {*cesta*}...

### Výchozí přístupová práva

<!--
d:
-->

### Uživatelské rozšířené atributy ext4 (URA)

Poznámka: Tyto příkazy jsou vhodné pro zpracování běžných textových hodnot rozšířených atributů;
pokud potřebujete zpracovávat atributy obsahující kódováná binární data, budete muset prozkoumat
příkazy „getfattr“ a „setfattr“ z balíčku „attr“.

Poznámka 2: Všechny klíče uživatelských rozšířených atributů musejí začínat „user.“.

*# vypsat **seznam klíčů***<br>
[**sudo**] **xattr** [**\-\-**] {*cesta*}...

*# vypsat **hodnotu***<br>
[**sudo**] **xattr -p**[**z**] {*user.klíč*} [**\-\-**] {*cesta*}...

*# smazat konkrétní URA-dvojici*<br>
[**sudo**] **xattr -d** {*user.klíč*} [**\-\-**] {*cesta*}...

*# smazat všechny URA-dvojice na daném souboru či adresáři*<br>
?
<!--
[ ] vyzkoušet
**for \_ in "$(xattr \-\-** {*cesta*} **\| sed -E "s/'/'\\''/g;s/.*/'\\\\1'/")"; do xattr -d "$\_"** {*cesta*}**; done**
-->

*# nastavit atribut*<br>
[**sudo**] **xattr -w**[**z**] {*user.klíč*} **"**{*hodnota*}**"** [**\-\-**] {*cesta*}...

### Zvláštní restrikce ext4

<!--
Následující zvláštní restrikce se podobají přístupovým právům, ale lze je použít
pouze na souborových systémech ext2 až ext4 (nezkoumal/a jsem ZFS, btrfs apod.,
ale tmpfs je nepodporuje). Na rozdíl od přístupových práv účinkují i na superuživatele a brání nejen obsah souboru či adresáře, ale také většinu jeho metadat a spolehlivě chrání soubor či adresář před smazáním.
-->

Pozor! Následující zvláštní restrikce jsou dostupné výhradně na souborovém systému ext4
(a pravděpodobně také na ext3, popř. ext2); mohou být k dispozici i na jiných souborových
systémech, ale většinou nejsou (dokonce ani na „tmpfs“). Účinkují i na superuživatele,
ten je však může v případě potřeby zrušit.

*# nastavit/zrušit zvláštní restrikci zakazující změny*<br>
*// Tato restrikce je silnější negací práva „w“; navíc ovšem účinkuje i na superuživatele a zakazuje i přejmenování, smazání či přesunutí samotné adresářové položky (omezuje tedy i právo „w“ na nadřazeném adresáři) a změnu jejího vlastnictví či přístupových práv.*<br>
**sudo chattr** [**-R**] **+i** {*cesta*}...<br>
**sudo chattr** [**-R**] **-i** {*cesta*}...

*# nastavit/zrušit zvláštní restrikci změn dovolující jen připojování na konec souboru*<br>
**sudo chattr** [**-R**] **+a** {*cesta*}...<br>
**sudo chattr** [**-R**] **-a** {*cesta*}...

<!--
Pokus o použití na tmpfs vede k chybovému hlášení:
„chattr: Pro toto zařízení nevhodné ioctl při čtení příznaků a“
-->

## Parametry příkazů

### chmod



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

### setfacl



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

* Uživatelé a skupiny jsou v souborovém systému uloženy ve formě čísel UID a GID. To je důležité především na přenosných médiích jako jsou např. USB flashdisky, protože po připojení k jinému počítači budou tato čísla interpretována jako uživatelé na daném systému. To znamená, že je-li na jednom počítači vlastníkem souboru na flash disku uživatel „vlasta“ s UID 1000 a na druhém počítači má UID 1000 uživatel „filip“, bude po připojení flash disku ke druhému počítači za vlastníka daného souboru považován „filip“, a to i tehdy, pokud v systému existuje uživatel „vlasta“ s jiným UID (např. 1002). Totéž platí analogicky pro skupiny a jejich GID.

### Přístupová práva a speciální příznaky číselně

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
