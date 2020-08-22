<!--

Linux Kniha kouzel, kapitola Soubory a adresáře
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

- Kdo má právo nastavovat příslušnou skupinu?
- [ ] Přidat fallocate, truncate a možná kopírování (ale pro to bude možná samostatná kapitola).

⊨
-->

# Soubory a adresáře

!Štítky: {tematický okruh}{adresáře}{soubory}{přístupová práva}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola se zabývá prací s adresáři a jejich položkami (soubory, podadresáři apod.),
včetně jejich velikosti, vlastnictví, přístupových práv, příznaků a rozšířených atributů.
Nepokrývá však zacházení s konkrétním obsahem souborů (analýzu, kopírování, zálohování apod.).

Pevnými a symbolickými odkazy se tato kapitola zabývá velmi okrajově, bude jim věnována
samostatná kapitola.

Tato kapitola se nezabývá připojováním souborových systémů.

Tato verze kapitoly dostatečně nepokrývá „mód“ (číselné vyjádření základních přístupových práv a zvláštních příznaků).

## Definice

* **Adresářová položka** je jednoznačně pojmenovaná položka v adresáři; obvykle je to soubor (přesněji – pevný odkaz na soubor), další adresář či symbolický odkaz, méně často zařízení (např. „/dev/null“), pojmenovaná roura apod. Adresářové položky se v daném adresáři identifikují svým **názvem**, který může obsahovat jakékoliv znaky UTF-8 kromě nulového bajtu a znaku „/“. V každém adresáři se nacházejí dva zvláštní adresářové odkazy „.“ (na sebe) a „..“ (na nadřazený adresář), které se ale nepočítají a většina nástojů je ignoruje (bohužel ne všechny).
* Adresářová položka je **skrytá**, pokud její název začíná znakem „.“.
* **Přístupová práva** jsou nastavení souboru či adresáře, která určují, kteří uživatelé budou moci s daným souborem či adresářem zacházet. Nastavení přístupových práv se dělí na **základní**, které je přítomno vždy, a **rozšířená** (ACL, access control list), jejichž nastavení lze přidávat či odebírat. (Vedle toho existují ještě „výchozí“ přístupová práva, ale těmi se pro jejich neintuitivnost a zřídkavé využití budu zabývat jen okrajově.)
* **Zvláštní příznaky** jsou tři příznaky (u+s, g+s, +t), které mohou být nastaveny souborům a adresářům a mají na ně zvláštní účinky. Jim příbuzné jsou **zvláštní restrikce ext4**, které jsou ale dostupné pouze na souborovém systému ext4 (a částečně ext2 a ext3).
* **Mód** (mode) je číselné vyjádření v osmičkové soustavě, které shrnuje základní nastavení přístupových práv a nastavení zvláštních příznaků.
* **Uživatelské rozšířené atributy** (URA, user xattrs) umožňují ukládat k souborům a adresářům další obecná data v podobě dvojic klíč–hodnota; jsou však k dispozici pouze na souborovém systému ext4, jsou poměrně skryté, při jakémkoliv kopírování se obvykle ztratí a nejsou příliš využívány. Proto doporučuji se jim raději vyhýbat.
<!--
* **Kanonická cesta** je absolutní cesta k adresářové položce od kořenového adresáře, která neobsahuje symbolické odkazy ani žádné zbytečné prvky.
-->

### Přístupová práva souborů a adresářů

V linuxovém souborovém systému existují tři přístupová práva, která lze u adresářové položky dovolit či zakázat:

Právo **čtení** (r, read) znamená:

* U souboru právo otevřít soubor pro čtení a přečíst jeho obsah, a to jak sekvenčně, tak na přeskáčku.
* U adresáře právo přečíst seznam názvů položek v adresáři včetně jejich typu (soubor či adresář), ale už bez dalších údajů.

Právo **zápisu** (w, write) znamená:

* U souboru právo otevřít daný soubor pro zápis, zkrátit ho (i na nulovou velikost), přepisovat existující bajty souboru a zapisovat nové na jeho konec.
* U adresáře právo vytvářet nové adresářové položky, měnit názvy stávajících a stávající mazat.

Právo **spouštění** (x, execute) znamená:

* U souboru právo daný soubor spustit jako proces. Toto právo stačí, pokud se jedná o program v přímo spustitelném binárním formátu; jde-li ve skutečnosti o interpretovaný skript, je potřeba také právo „r“.
* U adresáře právo do daného adresáře vstoupit, zjistit podrobnější informace o jeho položkách (např. přístupová práva) a dál k nim přistupovat. Nezahrnuje však možnost přečíst seznam názvů položek, takže pokud máte k adresáři samotné právo „x“, musíte znát názvy jeho položek, abyste s nimi mohli zacházet. (Samotné právo „r“ bez práva „x“ zase umožní programu vypsat seznam položek v adresáři, ale už o nich nebude moci nic zjistit.

Každá adresářová položka má vlastníka (což je některý uživatel, např. „root“) a příslušnou skupinu.
Přístupová práva může měnit pouze vlastník položky nebo superuživatel.

Z historických důvodů existují dvě nastavení přístupových práv – základní (mode)
a rozšířené (ACL). Základní nastavení je vždy přítomno a dělí se na nastavení
pro vlastníka („u“), skupinu („g“) a ostatní („o“). Rozšířené nastavení je pak tvořeno
seznamem dalších položek, které mohou stanovovat dodatečná práva konkrétním
uživatelům a skupinám. Tento seznam však může být (a také obvykle bývá) prázdný.

Nastavení přístupových práv se uplatňují následovně:

* Když k položce přistupuje její vlastník, uplatní se jen a pouze základní nastavení přístupových práv pro vlastníka („u“); žádné jiné nastavení se neuplatní, dokonce ani rozšířené nastavení přístupových práv, které vlastníka výslovně jmenuje.
* Jinak se vezme základní nastavení pro skupinu („g“) a všechny položky rozšířeného nastavení. Pokud bude mezi nimi nalezena alespoň jedna „odpovídající“ položka, tedy např. skupina, jejíž je uživatel členem, uživatel dostane všechna práva garantovaná alespoň některou odpovídající položkou. (To znamená, že když např. bude adresář „adr“ mít nastavena pro skupinu „askup“ práva „r\-\-“ a pro skupinu „bskup“ práva „\-\-x“, uživatel, který je členem obou skupin, ale není vlastníkem daného adresáře, má k adresáři „adr“ práva „r-x“.)
* Jedině pokud nebyla v druhém kroku nalezena žádná odpovídající položka, uplatní se nastavení pro ostatní („o“).

### Zvláštní příznaky

Vedle přístupových práv může mít každý soubor či adresář nastaveny ještě tři zvláštní příznaky:

**Příznak zmocnění vlastníka** (u+s, set-uid bit) má význam pouze u souborů
a pouze v kombinaci s právem „x“. Je-li takový soubor spuštěn, vzniklý proces
získá EUID (a tedy i práva) vlastníka souboru, a to i v případě, že ho spustil jiný uživatel.
Nejčastějším použitím je spuštění určitého program u s právy superuživatele.

**Příznak zmocnění skupiny** (g+s, set-gid bit) funguje u souborů analogicky
– spustí-li daný soubor kterýkoliv uživatel, vzniklý proces získá EGID (tedy skupinová práva)
skupiny souboru. Navíc ovšem funguje i u adresářů – všechny nově vytvořené adresářové položky
v adresáři s příznakem zmocnění pro skupinu budou při vytvoření přiřazeny stejné skupině
jako adresář, ve kterém byly vytvořeny. (Normálně by získaly skupinu podle procesu,
který je vytvořil.) Takto vytvořené podadresáře navíc získají také příznak zmocnění pro skupinu,
což znamená, že tento příznak se automaticky rozšíří i do všech nově vytvořených podadresářů,
pokud u nich nebude výslovně zrušen.

Třetí speciální příznak je **příznak omezení smazání** (+t, sticky-bit).
Ten má význam pouze u adresářů, kde omezuje výkon práva „w“ – brání ve smazání či přejmenování
„cizích položek“, tedy přesněji – zabrání ve smazání či přejmenování adresářové položky
každému uživateli, který není vlastníkem dané položky či vlastníkem samotného adresáře.
Hlavním smyslem této kombinace je, že uživatelé mohou v daném adresáři vytvářet nové
položky a ty jsou pak chráněny před zásahy jiných uživatelů, kteří mají k témuž adresáři
také právo zápisu. Tento příznak je typicky nastaven na adresáři „/tmp“.
Poznámka: vzniklé podadresáře tento příznak nedědí.

### Superuživatel

Na **superuživatele** se z přístupových práv a příznaků vztahuje pouze právo spouštění
u souborů a příznak zmocnění pro skupinu. Ostatní nastavení přístupových práv ani příznaků
ho nijak neomezují a nemají na něj vliv.

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

*# jen souborů (a symbolických odkazů na ně)(kromě/včetně skrytých)*<br>
**find -L** {*adresář*} **-mindepth 1 -maxdepth 1 -type f -name '[!.]\*' -printf %f\\\\n** [**\| sort -f**]<br>
**find -L** {*adresář*} **-mindepth 1 -maxdepth 1 -type f -printf %f\\\\n** [**\| sort -f**]

*# adresářů a podadresářů včetně symbolických odkazů na adresáře (kromě/včetně skrytých)*<br>
**tree -d**[**a**]<nic>[**L** {*úrovní*}]<br>
**tree -da**[**L** {*úrovní*}]

*# všech včetně „.“ a „..“*<br>
**ls -a**[**lh**] <nic>[{*adresář*}]

### Vypsat seznam adresářových položek (pro skript)

*# **všech** (txt/txtz)*<br>
*// Poznámka: příkaz „find“ odzvláštňuje speciální znaky na svém výstupu, pokud je veden na terminál. Je-li toto chování nežádoucí, nechte jeho výstup ještě projít dalším filtrem, např. „cat“.*<br>
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -printf %P\\n**<br>
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -printf %P\\0**

*# jen **souborů** (txt/txtz)*<br>
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -type f -printf %P\\n**<br>
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -type f -printf %P\\0**

*# jen **adresářů** (txt/txtz)*<br>
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -type d -printf %P\\n**<br>
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -type d -printf %P\\0**

*# všech kromě skrytých (txt/txtz)*<br>
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -name '[!.]\*' -printf %P\\n**<br>
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -name '[!.]\*' -printf %P\\0**

*# všech včetně „.“ a „..“ (txt/txtz)*<br>
**{ printf %s\\n . ..; find** {*adresář*} **-mindepth 1 -maxdepth 1 -printf %P\\n; }**<br>
**{ printf %s\\0 . ..; find** {*adresář*} **-mindepth 1 -maxdepth 1 -printf %P\\0; }**

### Testy

*# **existuje** adresářová položka?*<br>
**test -e** {*cesta*}

*# je adresářová položka **soubor**/adresář/symbolický odkaz/pojmenovaná roura?*<br>
**test -f** {*cesta*}<br>
**test -d** {*cesta*}<br>
**test -L** {*cesta*}<br>
**test -p** {*cesta*}

*# je soubor neprázdný/**prázdný**?*<br>
**test -f** {*cesta*} **-a -s** {*cesta*}<br>
**test -f** {*cesta*} **-a \\! -s** {*cesta*}

*# má položka nastavený zvláštní příznak u+s/u+g/+t?*<br>
**[[ $(stat -c %04a** [**\-\-**] {*cesta*}**) =~ ^[4567] ]]**<br>
**[[ $(stat -c %04a** [**\-\-**] {*cesta*}**) =~ ^[2367] ]]**<br>
**[[ $(stat -c %04a** [**\-\-**] {*cesta*}**) =~ ^[1357] ]]**

### Srovnání

Poznámka: srovnávané položky nemusejí být v tomtéž adresáři; můžete je zadat i s relativní či absolutní cestou.

*# je položka1 **novější** než položka2? (z hlediska času poslední úpravy)*<br>
**test** {*položka1*} **-nt** {*položka2*}

*# je soubor1 **větší**/větší nebo stejně velký než soubor2?*<br>
**test $(stat -c %s "**{*soubor1*}**") -gt $(stat -c %s "**{*soubor2*}**")**<br>
**test $(stat -c %s "**{*soubor1*}**") -ge $(stat -c %s "**{*soubor2*}**")**

*# odkazují dvě položky na tutéž entitu (soubor, adresář apod.)?*<br>
**test** {*položka1*} **-ef** {*položka2*}

*# jsou obě položky stejně staré?*<br>
**test \\!** {*položka1*} **-nt** {*položka2*} **-a \\!** {*položka1*} **-ot** {*položka2*}

### Zjistit údaje

*# prostor zabraný na disku adresářem a celým jeho podstromem (v bajtech/čitelně pro člověka)*<br>
**du -s0**[**x**] **-B 1** {*adresář*}... **\| sed -zE 's/\\s.\*/\\n/' \| tr -d \\\\0** ⊨ 16404<br>
**du -sh**[**x**] {*adresář*}... ⊨ 28K .

*# přístupová **práva** (kompletní/základní číselně/základní textově pro člověka)*<br>
**getfacl -ac** [**\-\-**] {*cesta*}... ⊨ user\:\:rw- (výstup má víc řádek)<br>
**stat -c %**[**04**]**a** [**\-\-**] {*cesta*}... ⊨ 1775<br>
**stat -c %A** [**\-\-**] {*cesta*}... ⊨ -rwxrwxr-t

*# celková **velikost** (v bajtech/čitelně pro člověka)*<br>
**stat -c %s** {*cesta*}... ⊨ 15132<br>
**stat -c %s** {*cesta*}... **\| numfmt \-\-to iec** ⊨ 15K

*# **vlastník** (jméno/UID)*<br>
**stat -c %U** {*cesta*}... ⊨ filip<br>
**stat -c %u** {*cesta*}... ⊨ 1000

*# **skupina** (název/GID)*<br>
**stat -c %G** {*cesta*}... ⊨ www-data<br>
**stat -c %g** {*cesta*}... ⊨ 33

*# datum a čas poslední změny (pro člověka či skript/časová známka Unixu)*<br>
**stat -c %y** {*cesta*}... ⊨ 2020-03-01 05:30:59.280255271 +0100<br>
**stat -c %Y** {*cesta*}... ⊨ 1583037059

*# počet pevných odkazů*<br>
**stat -c %h** {*cesta*}... ⊨ 1

*# číslo **inode***<br>
**stat -c %i** {*cesta*}... ⊨ 403723

*# typ adresářové položky (písmeno/čitelně pro člověka)*<br>
**stat -c %A \| cut -c 1 \| tr - f** ⊨ f<br>
**stat -c %F** {*cesta*}... ⊨ běžný soubor

*# příslušný přípojný bod (kořenový adresář systému souborů, na kterém se položka nachází)*<br>
**stat -c %m** {*cesta*}... ⊨ /

*# prostor skutečně zabraný na disku souborem (v bajtech/čitelně pro člověka)*<br>
**stat -c '%b\*%B'**  {*cesta*}... **\| bc** ⊨ 16384<br>
**stat -c '%b\*%B'**  {*cesta*}... **\| bc \| numfmt \-\-to iec** ⊨ 16K

### Aktuální adresář

*# přejít do daného adresáře/na předchozí aktuální adresář*<br>
**cd** [**\-\-**] {*cesta*}<br>
**cd -**

*# zjistit aktuální adresář*<br>
**pwd** ⊨ /home/aneta

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

### Přejmenovat či smazat adresářovou položku

*# **přejmenovat** adresářovou položku*<br>
**mv** [{*parametry*}] <nic>[**\-\-**] {*původní-název*} {*nový-název*}

*# smazat **neadresář***<br>
**rm** [**-f**] <nic>[**\-\-**] {*cesta*}...

*# smazat prázdný adresář*<br>
**rmdir** [**\-\-**] {*cesta*}<br>

*# smazat rekurzívně veškerý obsah adresáře a nakonec i samotný adresář*<br>
*// Tuto variantu můžete použít i na jednotlivé soubory.*<br>
**rm -r**[**f**]<nic>[**v**] <nic>[**\-\-**] {*cesta*}...

### Nastavit přístupová práva

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

*# nastavit rozšířená práva „rx“ uživateli „filip“*<br>
[**sudo**] **setfacl** [**-R**] **-m u:filip:rx** [**\-\-**] {*cesta*}...

*# zrušit rozšířená práva uživatele „filip“*<br>
[**sudo**] **setfacl** [**-R**] **-x u:filip** [**\-\-**] {*cesta*}...

*# zrušit rozšířená práva všech uživatelů a skupin*<br>
[**sudo**] **setfacl** [**-R**] **-b** [**\-\-**] {*cesta*}...

<!--
[**sudo**] **chmod** [**-R**] **750** [**\-\-**] {*cesta*}...<br>
-->

### Změnit čas, vlastnictví a skupinu

*# nastavit čas poslední změny na aktuální čas*<br>
[**sudo**] **touch -c** [**\-\-**] {*cesta*}...

*# změnit **vlastníka** souboru či adresáře (volitelně i skupinu)(obecně/příklad)*<br>
**sudo chown** [**-R** [**-L**]] <nic>[**-c**] <nic>[**\-\-from=**[{*původní-vlastník*}]**:**[{*původní-skupina*}]] {*nový-vlastník*}[**:**{*nová-skupina*}] <nic>[**\-\-**] {*cesta*}...<br>
**sudo chown root:root soubor.txt**

*# změnit skupinu souboru či adresáře*<br>
[**sudo**] **chgrp** [**-R**] <nic>[**-c**] {*nová-skupina*} [**\-\-**] {*cesta*}...

*# nastavit čas poslední změny (obecně/příklady...)*<br>
*// Pozor! Příkaz „touch“ při tomto použití tiše ignoruje neexistující soubory!*<br>
[**sudo**] **touch -cd "**{*datum-čas*}**"** [**\-\-**] {*cesta*}...<br>
**sudo touch -cd "2019-04-21 23:59:58" \-\- /root/mujsoubor.txt**<br>
**touch -cd "2019-04-21 23:59:58.123456789" \-\- ~/mujsoubor.txt**<br>


### Přenést přístupová práva

*# nastavit skupině („g“) a ostatním („o“) přístupová práva, jaká má vlastník („u“) (alternativy)*<br>
[**sudo**] **chmod** [**-R**] **go=u** [**\-\-**] {*cesta*}...<br>
[**sudo**] **getfacl** [**\-\-**] {*cesta*} **\| sed -E 's/^user::/other::/;t;d' \|** [**sudo**] **setfacl -M-** {*cesta*}

### Zvláštní příznaky (nastavit)

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

### Uživatelské rozšířené atributy ext4 (URA)

Poznámka: Tyto příkazy jsou vhodné pro zpracování běžných textových hodnot rozšířených atributů;
pokud potřebujete zpracovávat atributy obsahující obecná binární data, budete muset prozkoumat
komplikovanější příkazy „getfattr“ a „setfattr“ z balíčku „attr“ (nutno doinstalovat).

Poznámka 2: Všechny klíče uživatelských rozšířených atributů *musejí* začínat „user.“.

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

*# **nastavit** atribut*<br>
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
*// Tato zvláštní restrikce zakazuje změny jak v obsahu souboru či adresáře, tak i v jeho vlastní adresářové položce (není možné ji přejmenovat či smazat). Zakazuje i změnu vlastnictví či přístupových práv.*<br>
**sudo chattr** [**-R**] **+i** {*cesta*}...<br>
**sudo chattr** [**-R**] **-i** {*cesta*}...

*# nastavit/zrušit zvláštní restrikci změn dovolující jen připojování na konec souboru*<br>
**sudo chattr** [**-R**] **+a** {*cesta*}...<br>
**sudo chattr** [**-R**] **-a** {*cesta*}...

*# vypsat všechny nastavené zvláštní restrikce ext4*<br>
[**sudo**] **lsattr** {*adresář-popř.-soubor*}...

<!--
Pokus o použití na tmpfs vede k chybovému hlášení:
„chattr: Pro toto zařízení nevhodné ioctl při čtení příznaků a“
-->

### Ostatní

*# kolik je v adresáři položek?*<br>
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -printf \\0 \| wc -c**

*# kolik je v adresáři neskrytých souborů/adresářů (bez symbolických odkazů)?*<br>
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -type f -name '[!.]\*' -printf \\0 \| wc -c**
**find** {*adresář*} **-mindepth 1 -maxdepth 1 -type d -name '[!.]\*' -printf \\0 \| wc -c**

*# kolik je v adresáři neskrytých souborů/adresářů (včetně symbolických odkazů)?*<br>
**find -L** {*adresář*} **-mindepth 1 -maxdepth 1 -type f -name '[!.]\*' -printf \\0 \| wc -c**
**find -L** {*adresář*} **-mindepth 1 -maxdepth 1 -type d -name '[!.]\*' -printf \\0 \| wc -c**

## Parametry příkazů

### chmod

*# *<br>
**chmod** [{*parametry*}] {*mód*} [**\-\-**] {*cesta*}...<br>
**chmod** [{*parametry*}] {*nastavení,práv,a,příznaků*} [**\-\-**] {*cesta*}...

Příklady, jak může vypadat nastavení práv a příznaků najdete v zaklínadlech.
Mód je číselné vyjádření základních práv a zvláštních příznaků v osmičkové soustavě.

!Parametry:

* ☐ -R :: Je-li argumentem adresář, provede stejné nastavení i na všech jeho položkách, položkách všech podadresářů a tak dále.
* ☐ -v :: Vypisovat provedené operace.

<!--
### mv

*# *<br>
**mv** [{*parametry*}] {*zdroj*}... {*cíl*}<br>
**mv** [{*parametry*}] **-t** {*cílový-adresář*} {*zdroj*}...

!Parametry:

* ◉ -f ○ -i ○ -n ○ -b ○ -u :: Existující cílový soubor: přepsat bez ptaní/zeptat se/nepřesouvat/přejmenovat a nahradit/přepsat, pokud je starší.
* ☐ -v :: Vypisovat provedené operace.
* ☐ -T :: Cíl musí být soubor; je-li to existující adresář, selže s chybou.
-->

### mkdir

!Parametry:

* ☐ -p :: Vytvoří adresář, pokud ještě neexistuje. Je-li to třeba, vytvoří i nadřazené adresáře.
* ☐ -v :: Vypisovat provedené operace.
* ☐ -m {*práva*} :: Vytvořenému adresáři nastaví uvedený mód. Ten může být zadán symbolicky (např. „u=rwx,g=rx,o=“) nebo číselně (např. „755“).

### setfacl

*# *<br>
**setfacl** [{*parametry*}] **-m "**{*nastavení práv*}**"** [**\-\-**] {*cesta*}...<br>
**setfacl** [{*parametry*}] **-M** {*soubor*} [**\-\-**] {*cesta*}...<br>
**setfacl** [{*parametry*}] **-x "**{*práva ke zrušení*}**"** [**\-\-**] {*cesta*}...<br>
**setfacl** [{*parametry*}] **-X** {*soubor*} [**\-\-**] {*cesta*}...<br>
**setfacl** [{*parametry*}] **-M-** [**\-\-**] {*cesta*}...<br>
**setfacl \-\-restore=**{*soubor*}

!Parametry:

* ☐ -b ☐ -k :: Odstraní všechna rozšířená/výchozí přístupová práva.
* ☐ -d :: Uvedená normální přístupová práva nastaví jako „výchozí“.
* ☐ -R :: Je-li argumentem adresář,  provede stejné nastavení i na všech jeho položkách, položkách všech podadresářů a tak dále.

## Instalace na Ubuntu

Všechny použité nástroje jsou základními součástmi Ubuntu, s výjimkou příkazů „tree“ a „xattr“,
které můžete doinstalovat takto:

*# *<br>
**sudo apt-get install tree xattr**

<!--
## Ukázka
<!- -
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
- ->
![ve výstavbě](../obrazky/ve-vystavbe.png)
-->

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Uživatelé a skupiny jsou v souborovém systému uloženy ve formě čísel UID a GID. Proto když uložíte soubor na USB flash disk a přenesete ho na jiný počítač, kde pracujete jako uživatel s jiným UID, může se stát, že tam k souborům na flash disku nebudete mít dostatečná přístupová práva.
* V Linuxu existují také „výchozí přístupová práva“, což je nastavení přístupových práv na adresáři, které (je-li nastaveno) ovlivňuje přístupová práva nově vyvářených položek; bohužel nelze říci „stanovuje“, ale platí pouze „ovlivňuje“ – na výsledných právech se podílejí i další faktory, nelze rozlišit práva pro soubory a pro adresáře a celé je to dost komplikované a neintuitivní. Zatím jsem naštěstí nanarazil/a na případ, kdy by tuto vlastnost skutečně nějaký program použil.
* Symbolické odkazy mají vlastníka a skupinu, ale nemají vlastní přístupová práva. Přístup k odkazované položce se vždy řídí jejími přístupovými právy, čtení symbolického odkazu je bez omezení a zápis do něj není dovolen (je nutno místo toho odkaz smazat a vytvořit nový).

<!--
### Přístupová práva a speciální příznaky číselně (mód)
-->

## Další zdroje informací

* [Wikipedie: Přístupová práva v Unixu](https://cs.wikipedia.org/wiki/P%C5%99%C3%ADstupov%C3%A1\_pr%C3%A1va\_v\_Unixu)
* [Wikipedie: Access Control List](https://cs.wikipedia.org/wiki/Access\_Control\_List)
* [Wikipedie: setuid](https://cs.wikipedia.org/wiki/Setuid)
* [Tutorialspoint: setfacl](https://www.tutorialspoint.com/unix\_commands/setfacl.htm) (anglicky)
* man chmod (anglicky)
* man getfacl (anglicky)
* man setfacl (anglicky)
* man 5 acl (anglicky)
* man chattr (anglicky)
* [Článek o getfacl a setfacl](https://www.zyxware.com/articles/2955/how-to-use-getfacl-and-setfacl-to-get-and-set-access-control-lists-acls-on) (anglicky)
* [YouTube: Basic Linux Access Control](https://www.youtube.com/watch?v=WhCIuGjhH-0) (anglicky)
* [TL;DR: setfacl](https://github.com/tldr-pages/tldr/blob/master/pages/linux/setfacl.md) (anglicky)
* [TL;DR: chattr](https://github.com/tldr-pages/tldr/blob/master/pages/linux/chattr.md) (anglicky)
* [TL;DR: getfacl](https://github.com/tldr-pages/tldr/blob/master/pages/linux/getfacl.md) (anglicky)

!ÚzkýRežim: vyp
