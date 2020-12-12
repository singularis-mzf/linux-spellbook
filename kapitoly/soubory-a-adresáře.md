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
- [ ] možná přidat kopírování (ale pro to bude možná samostatná kapitola).
- [ ] duperemove (pevné odkazy/btrfs klony)
⊨
-->

# Soubory a adresáře

!Štítky: {tematický okruh}{adresáře}{soubory}{přístupová práva}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola se zabývá prací s adresáři a jejich položkami (soubory, podadresáři apod.),
včetně jejich velikosti, vlastnictví, přístupových práv, příznaků a datových položek.
Nepokrývá však zacházení s konkrétním obsahem souborů (analýzu, kopírování, zálohování apod.).

Pevnými a symbolickými odkazy se tato kapitola zabývá velmi okrajově,
bude jim věnována samostatná kapitola.

Tato kapitola se nezabývá připojováním souborových systémů ani prací s pododdíly btrfs.

Příkazy chmod, find, stat a některé další jsou vyvíjeny v rámci projektu GNU.

## Definice

* **Adresářová položka** je jednoznačně pojmenovaná položka v adresáři; obvykle je to soubor (přesněji – pevný odkaz na soubor), další adresář či symbolický odkaz, méně často zařízení (např. „/dev/null“), pojmenovaná roura apod. Adresářové položky se v daném adresáři identifikují svým **názvem**, který může obsahovat jakékoliv znaky UTF-8 kromě nulového bajtu a znaku „/“. V každém adresáři se nacházejí dva zvláštní adresářové odkazy „.“ (na sebe) a „..“ (na nadřazený adresář), které se ale nepočítají a většina nástojů je ignoruje (bohužel ne všechny).
* Adresářová položka je **skrytá**, pokud její název začíná znakem „.“.
* **Přístupová práva** jsou nastavení souboru či adresáře, která určují, kteří uživatelé budou moci s daným souborem či adresářem zacházet. Nastavení přístupových práv se dělí na tři **základní nastavení**, která jsou přítomna vždy, a **rozšířená nastavení** (ACL, access control list), která lze přidávat či odebírat. (Vedle toho existují ještě „výchozí“ nastavení, ale těmi se pro jejich neintuitivnost a zřídkavé využití budu zabývat jen okrajově.)
* **Zvláštní příznaky** jsou příznaky, které mohou být nastaveny souborům a adresářům a mají na ně zvláštní účinky; dělí se na tři **základní zvláštní příznaky** (u+s, g+s, +t) a mnoho **rozšířených zvláštních příznaků**. Zatímco ty základní jsou podporované na všech nativně linuxových typech souborových systémů, podpora těch rozšířených se liší.
* **Mód** (mode) je standardizované číselné vyjádření základních přístupových práv a základních zvláštních příznaků v osmičkové soustavě.
* **Uživatelské datové položky** (user xattrs, user extended attributes) umožňují k souborům a adresářům ukládat další obecná data v podobě dvojic klíč–hodnota. Nejčastěji se používají k uložení krátkých čísel či textových řetězců, např. URL, ze kterého byl daný soubor stažen. Mají řadu nevýhod – jsou před uživatelem poměrně skryté (příkazy „ls“ ani „find“ s nimi neumí pracovat), při kopírování či zálohování se obvykle ztratí a nejsou příliš využívány. Proto doporučuji se jim raději vyhýbat a dodatečná data ukládat do samostatných, skrytých souborů.
<!--
* **Kanonická cesta** je absolutní cesta k adresářové položce od kořenového adresáře, která neobsahuje symbolické odkazy ani žádné zbytečné prvky.
-->

### Přístupová práva

V linuxu se u souborů a adresářů povolují či zakazují tři přístupová práva:

Právo **čtení** (r, číselná hodnota „4“, read) znamená:

* U souboru právo otevřít soubor pro čtení a přečíst jeho obsah, a to jak sekvenčně, tak na přeskáčku.
* U adresáře právo přečíst seznam názvů položek v adresáři včetně jejich typu (soubor či adresář), ale už bez dalších údajů.

Právo **zápisu** (w, číselná hodnota „2“, write) znamená:

* U souboru právo otevřít daný soubor pro zápis, zkrátit ho (i na nulovou velikost), přepisovat existující bajty souboru a zapisovat nové na jeho konec.
* U adresáře právo vytvářet nové adresářové položky, měnit názvy stávajících a stávající mazat.

Právo **spouštění** (x, číselná hodnota „1“, execute) znamená:

* U souboru právo daný soubor spustit jako proces. Toto právo stačí, pokud se jedná o program v přímo spustitelném binárním formátu; jde-li ve skutečnosti o interpretovaný skript, je potřeba také právo „r“, aby ho příslušný interpret mohl číst.
* U adresáře právo do daného adresáře vstoupit, zjistit podrobnější informace o jeho položkách (např. přístupová práva) a dál k nim přistupovat. Nezahrnuje však možnost přečíst seznam názvů položek, takže pokud máte k adresáři samotné právo „x“, musíte znát názvy jeho položek, abyste s nimi mohli zacházet. (Samotné právo „r“ bez práva „x“ zase umožní programu vypsat seznam položek v adresáři, ale už o nich nebude moci nic zjistit.

Každá adresářová položka má vlastníka (což je některý uživatel, např. „root“) a příslušnou skupinu.
Přístupová práva může měnit pouze vlastník položky nebo superuživatel.

Existují tři základní nastavení přístupových práv: pro vlastníka („u“), pro skupinu („g“) a pro ostatní („o“),
vždy v tomto pořadí. Rozšířená nastavení přístupových práv jsou seznam dalších položek,
které mohou stanovovat dodatečná práva konkrétním uživatelům a skupinám.
Tento seznam však může být (a také obvykle bývá) prázdný.

Nastavení přístupových práv se uplatňují následovně:

* Když k položce přistupuje její vlastník, uplatní se jen a pouze základní nastavení přístupových práv pro vlastníka („u“); žádné jiné nastavení se neuplatní, dokonce ani rozšířené nastavení přístupových práv, které vlastníka výslovně jmenuje.
* Jinak se vezme základní nastavení pro skupinu („g“) a všechny položky rozšířeného nastavení. Pokud bude mezi nimi nalezena alespoň jedna „odpovídající“ položka, tedy např. skupina, jejíž je uživatel členem, uživatel dostane všechna práva garantovaná alespoň některou odpovídající položkou. (To znamená, že když např. bude adresář „adr“ mít nastavena pro skupinu „askup“ práva „r\-\-“ a pro skupinu „bskup“ práva „\-\-x“, uživatel, který je členem obou skupin, ale není vlastníkem daného adresáře, má k adresáři „adr“ práva „r-x“.)
* Jedině pokud nebyla v druhém kroku nalezena žádná odpovídající položka, uplatní se nastavení pro ostatní („o“).

### Základní zvláštní příznaky

Vedle přístupových práv může mít každý soubor či adresář nastaveny ještě tři základní zvláštní příznaky:

**Příznak zmocnění vlastníka** (u+s, číselná hodnota „4“, set-uid bit):

* U souboru má význam pouze v kombinaci s právem „x“. Je-li takový soubor spuštěn, vzniklý proces získá EUID (a tedy i práva) vlastníka souboru, a to i v případě, že ho spustil jiný uživatel. Nejčastějším použitím je spuštění určitého programu s právy superuživatele.
* U adresáře nemá žádný význam.

**Příznak zmocnění skupiny** (g+s, číselná hodnota „2“ set-gid bit):

* U souboru funguje analogicky jako příznak zmocnění vlastníka – vzniklý proces získá EGID (tedy skupinová práva) skupiny souboru.
* U adresáře znamená, že všechny nově vytvořené adresářové položky v adresáři s tímto příznakem budou při vytvoření přiřazeny stejné skupině jako adresář, ve kterém byly vytvořeny. (Normálně by získaly skupinu podle procesu, který je vytvořil.) Takto vytvořené podadresáře navíc získají také příznak zmocnění pro skupinu, což znamená, že tento příznak se automaticky rozšíří i do všech nově vytvořených podadresářů, pokud u nich nebude výslovně zrušen.

**Příznak omezení smazání** (+t, číselná hodnota „1“, sticky-bit):

* U souboru nemá žádný význam.
* U adresáře omezuje výkon práva „w“ – brání ve smazání či přejmenování „cizích položek“, tedy přesněji – zabrání ve smazání či přejmenování adresářové položky každému uživateli, který není vlastníkem dané položky či vlastníkem samotného adresáře. Hlavním smyslem této kombinace je, že uživatelé mohou v daném adresáři vytvářet nové položky a ty jsou pak chráněny před zásahy jiných uživatelů, kteří mají k témuž adresáři také právo zápisu. Tento příznak je typicky nastaven na adresáři „/tmp“. Poznámka: vzniklé podadresáře tento příznak nedědí.

### Superuživatel

Na **superuživatele** se nevztahují žádná přístupová práva a příznaky zmocnění vlastníka a omezení smazání. Ostatní zvláštní příznaky (zejména ty rozšířené) se vztahují i na superuživatele.

### Mód

Mód se vyjadřuje čtyřmístným číslem v osmičkové soustavě (0000 až 7777),
kde jednotlivé číslice zleva doprava znamenají: **Příznaky, práva vlastníka, práva skupiny, práva ostatních.**
První číslice vyjadřující příznaky je nepovinná, mód tedy lze zadat i trojmístným číslem; místo chybějící úvodní číslice se pak uvažuje nula.

Každou číslici vypočteme jako součet číselných hodnot příznaků,
které *mají* být nastaveny, a práv, která *mají* být přidělena.
(Číselné hodnoty příznaků a práv jsou uvedeny výše.)

Příklad: chceme-li adresáři nastavit příznak omezení smazání (číselná hodnota 1)
a nastavit, že vlastník bude mít všechna práva (4 + 2 + 1), skupina jen právo čtení (4)
a ostatní nebudou mít žádná práva (0), výsledný mód bude: „1740“.

Pro čtení módu si musíme zapamatovat význam jednotlivých číslic v pořadí
a číselné hodnoty příznaků a práv. Pak můžeme mód snadno přečíst následujícím postupem:

* Pokud je číslice 4, 2 nebo 1, výsledkem je právě jeden příznak/právo této číselné hodnoty.
* Pokud je číslice 7, výsledkem jsou všechny příznaky/práva.
* Pokud je číslice 0, výsledkem jsou žádné příznaky/práva.
* U zbylých číslic (6, 5 nebo 3) budou výsledkem dva příznaky/práva; u nich zkoušíme postupně odečíst 4 a 2; pokud se nám to podaří, aniž bychom se dostali pod nulu, zapíšeme příznak/právo odpovídající číslici, kterou jsme odečetli, a druhý příznak/právo odpovídající číslici, která nám po odečtení zbyla. 6 = 4 + 2, 5 = 4 + 1, 3 = 2 + 1.

Příklad: mějme mód 3571. První číslice: 4 odečíst nejde, takže odečteme 2 a zbude nám jedna; zapíšeme tedy příznak zmocnění skupiny (hodnota 2) a příznak omezení smazání (hodnota 1). Druhá číslice: 4 odečíst jde a zbude nám 1, zapíšeme tedy práva čtení (4) a spouštění (1). Třetí číslice: 7 znamená pro skupinu všechna práva, tedy čtení, zápis i spouštění. Čtvrtá číslice: 1 znamená pro ostatní jen právo spouštění.

### Rozšířené zvláštní příznaky

Rozšířené zvláštní příznaky jsou relativně málo významné, málo uživtečné a jejich podpora je omezená typem souborového systému. Mezi užitečné z nich patří:

* Příznak „**a**“ (ext4: ano, btrfs: ano, tmpfs: ne) – Poskytne souboru či adresáři silnou ochranu před zápisem a jinými změnami, ale na rozdíl od příznaku „i“ umožňuje zápis za konec souboru a u adresáře vytvoření nové adresářové položky (její přejmenování či smazání už ne). Nově vytvářené podadresáře tento příznak nedědí.
* Příznak „**i**“ (ext4: ano, btrfs: ano, tmpfs: ne) – Poskytne souboru či adresáři silnou ochranu před zápisem a jinými změnami. Pozor, na soubor s tímto příznakem nelze ani vytvořit nový pevný odkaz, přejmenovat ho nebo změnit jeho vlastnictví či přístupová práva!
* Příznak „**S**“ (ext4: ano, btrfs: ano, tmpfs: ne) – Změny se zapisují okamžitě na disk. (Normálně čekají nějakou dobu v paměti.) Nově vytvořené soubory a adresáře tento příznak dědí.
* Příznak „**C**“ (ext4: ne, btrfs: ano, tmpfs: ne) – Byl-li tento příznak nastaven prázdnému souboru, jeho později alokované datové bloky na disku nebudou sdíleny s jinými soubory (např. klony). Je-li tento příznak nastaven adresáři, nově vytvořené soubory a podadresáře ho zdědí.
* Příznak „**A**“ (ext4: ano, btrfs: ano, tmpfs: ne) – Čas posledního přístupu („atime“) nebude aktualizován. (Nezkoušel/a jsem.)

<!--
* Příznak „F“ (ext4: ne, btrfs: ne, tmpfs: ne) – U názvů položek v adresáři se nebudou rozlišovat velká a malá písmena. Tento příznak smí být nastaven nebo zrušen pouze u prázdného adresáře.
* Příznak „c“ (ext4: ne, btrfs: ?, tmpfs: ne) – Je-li nastaven prázdnému souboru, systém se na něj pokusí aplikovat transparentní kompresi i v případě, že je v daném souborovém systému vypnuta. Je-li nastaven adresáři, všechny nově vytvořené soubory a adresáře v něm tento příznak zdědí.
<!- -
Poznámka: příznak „c“ na ext4 lze nastavit, ale nic nedělá, transparentní komprese není podporována.
-->

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
**tree -d**[**L** {*úrovní*}]<br>
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

*# je adresářová položka \{**soubor**/adresář/pojmenovaná roura} nebo symbolický odkaz na ni/něj?*<br>
**test -f** {*cesta*}<br>
**test -d** {*cesta*}<br>
**test -p** {*cesta*}

*# je adresářová položka **soubor**/adresář/symbolický odkaz/pojmenovaná roura?*<br>
**test -f** {*cesta*} **-a ! -L** {*cesta*}<br>
**test -d** {*cesta*} **-a ! -L** {*cesta*}<br>
**test -L** {*cesta*} **-a ! -L** {*cesta*}<br>
**test -p** {*cesta*} **-a ! -L** {*cesta*}

*# je adresářová položka symbolický odkaz (jakýkoliv/relativní/absolutní)*<br>
**test -L** {*cesta*}<br>
**test -L** {*cesta*} **&amp;&amp; readlink** [**\-\-**] {*cesta*} **\| egrep -qv ^/**<br>
**test -L** {*cesta*} **&amp;&amp; readlink** [**\-\-**] {*cesta*} **\| egrep -q ^/**

*# je soubor neprázdný/**prázdný**?*<br>
**test -f** {*cesta*} **-a -s** {*cesta*}<br>
**test -f** {*cesta*} **-a ! -s** {*cesta*}

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
**test !** {*položka1*} **-nt** {*položka2*} **-a !** {*položka1*} **-ot** {*položka2*}

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

*# datum a čas poslední **změny** (pro člověka či skript/časová známka Unixu)*<br>
**stat -c %y** {*cesta*}... ⊨ 2020-03-01 05:30:59.280255271 +0100<br>
**stat -c %Y** {*cesta*}... ⊨ 1583037059

*# **kanonická cesta** adresářové položky (v případě symb. odkazu vzít: odkaz/odkazovanou položku)*<br>
**realpath -s** [**\-\-**] {*cesta*}<br>
**realpath** [**\-\-**] {*cesta*}

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

*# nastavené rozšířené zvláštní příznaky (pro člověka/pro skript)*<br>
*// Poznámka: některé rozšířené zvláštní příznaky jsou pouze informativní a nemohou být přímo změněny žádným příkazem.*<br>
**lsattr -d** [**\-\-**] {*cesta*}...<br>
**lsattr -d** [**\-\-**] {*cesta*} **\| sed -zE 's/-//g;s/\\s.\*/\\n/'**

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

*# přejít do kořenového adresáře*<br>
**cd /**

*# přejít do předchozího aktuálního adresáře dané instance interpretu*<br>
**cd -**

### Vytvořit adresářovou položku

*# vytvořit prázdný **adresář** (alternativy)*<br>
*// Parametr „-p“: vytvořit adresář, jen pokud ještě neexistuje; a v případě potřeby nejdřív vytvořit adresáře jemu nadřazené.*<br>
*// Znak „=“ u módu má význam pouze v případě, že chcete zabránit, aby vytvořený adresář zdědil od nadřazeného adresáře příznak zmocnění skupiny. Bez = se totiž v takovém případě tento příznak zdědí i v případě, že ho uvedený mód nemá nastavený. Pokud „=“ uvedete, dědění se tím zabrání a příznak se nastaví výhradně podle uvedeného módu.*<br>
**mkdir** [**-v**] <nic>[**-m** {*práva*}] <nic>[**-p**] {*název*}<br>
**mkdir** [**-v**] **-m** [**=**]{*mód*} [**-p**] {*název*}

*# vytvořit prázdný **soubor***<br>
**touch** {*název*}

*# vytvořit symbolický odkaz*<br>
**ln -s "**{*obsah/odkazu*}**"** {*název*}

*# vytvořit soubor vyplněný **nulami** (velikost zadat/odvodit)*<br>
*// Poznámka: Je-li to možné, příkaz „truncate“ vytvoří takzvaný „řídký soubor“, tedy soubor, který ve skutečnosti zprvu nezabírá žádné místo na disku a jeho datové bloky se alokují teprve při zápisu. Tím pádem také umožňuje vytvořit soubor větší než je velikost souborového systému. Pokud chcete pro soubor rovnou vyhradit i prostor na disku, místo „truncate -s“ použijte „fallocate -l“.*<br>
**rm -f** [**\-\-**] {*cesta/k/souboru*}... **&amp;&amp; truncate -s** {*velikost*} {*cesta/k/souboru*}...<br>
**rm -f** [**\-\-**] {*cesta/k/souboru*}... **&amp;&amp; truncate -r** {*cesta/ke/vzorovému/souboru*} {*cesta/k/souboru*}...

*# vytvořit pojmenovanou rouru*<br>
**mkfifo** [**-m** {*práva*}] {*název*}...

### Přejmenovat či smazat adresářovou položku

*# **přejmenovat** adresářovou položku*<br>
**mv** [{*parametry*}] <nic>[**\-\-**] {*původní-název*} {*nový-název*}

*# smazat **neadresář***<br>
**rm** [**-f**] <nic>[**\-\-**] {*cesta*}...

*# smazat prázdný adresář*<br>
**rmdir** [**\-\-**] {*cesta*}<br>

*# smazat rekurzivně veškerý obsah adresáře a nakonec i samotný adresář*<br>
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

*# nastavit mód (základní přístupová práva a základní zvláštní příznaky)*<br>
*// Mód můžete zadat i bez znaku „=“, ale v takovém případě by tento příkaz neodstranil ze souborů a adresářů příznaky zmocnění vlastníka a skupiny; příznak omezení smazání by se odstranil i v takovém případě.*<br>
[**sudo**] **chmod** [**-R**] **=**{*mód*} [**\-\-**] {*cesta*}...

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

*# nastavit čas poslední změny („mtime“) na aktuální čas*<br>
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

*# zapnout/vypnout současně všechny tři základní zvláštní příznaky*<br>
[**sudo**] **chmod** [**-R**] **ug+s,+t** [**\-\-**] {*cesta*}...<br>
[**sudo**] **chmod** [**-R**] **ug-s,-t** [**\-\-**] {*cesta*}...

*# zapnout/vypnout rozšířené zvláštní příznaky*<br>
*// Pozor! Tímto příkazem nemůžete měnit základní zvláštní příznaky! Obzvlášť nebezpečná záměna hrozí u příznaku „t“, protože existuje základní příznak „+t“ a současně i nesouvisející rozšířený zvláštní příznak „t“.*<br>
**sudo chattr** [**-R**] **+**{*příznak*}[{*dalšípříznak*}]... [**\-\-**] {*cesta*}...<br>
**sudo chattr** [**-R**] **-**{*příznak*}[{*dalšípříznak*}]... [**\-\-**] {*cesta*}...
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

## Zaklínadla: Uživatelské datové položky

<!--
Poznámka: Dvojice parametrů „-m -“ znamená zahrnutí i systémových atributů do výpisu.
-->

Poznámka: Znaky „\\r“, „\\n“, „=“ a „\\“ se v klíčích atributů při použití
následujících zaklínadel nahrazují sekvencemi „\\015“ (\\r), „\\012“ (\\n), „\\075“ (=),
resp. „\\134“(„\\“). Příkaz „getfattr“ je již automaticky nahrazuje ve výpisech a příkaz „setfattr“ očekává klíč s nahrazenými znaky. Buď se použití těchto znaků vyhněte,
nebo jim zajistěte odpovídající konverzi. Nulový bajt „\\0“ se v klíči vyskytovat
nemůže.

Podle manuálové stránky je délka klíče omezena na 256 bajtů a délka hodnoty na 64 kibibajtů.

### Vypsat položky

*# vypsat klíče všech souborů a podadresářů (spíš pro člověka)*<br>
[**sudo**] **getfattr -PR \-\-absolute-names** [**\-\-**] {*cesta/adresáře*}

*# **vypsat** klíče i hodnoty pro člověka (řetězcově/hexadecimálně)*<br>
[**sudo**] **getfattr \-\-dump** [**-m -**] <nic>[**\-\-**] {*cesta*}...<br>
[**sudo**] **getfattr \-\-dump -e hex** [**-m -**] <nic>[**\-\-**] {*cesta*}...

*# vypsat klíče (pro člověka)*<br>
[**sudo**] **getfattr** [**\-\-**] {*cesta*}...

*# vypsat klíče (pro skript, ukončovač „\\n“)*<br>
[**sudo**] **getfattr** [**\-\-**] {*cesta*} **\| sed -E '1d;$d'**

*# má datové položky (uživatelské/uživatelské nebo systémové)?*<br>
[**sudo**] **getfattr** [**\-\-**] {*cesta*} **\| egrep -zq .**<br>
[**sudo**] **getfattr -m -** [**\-\-**] {*cesta*} \| **egrep -zq .**

*# počet klíčů (jen číslo/číslo a adresářová cesta)*<br>
[**sudo**] **getfattr** [**-m -**] <nic>[**\-\-**] {*adr/položka*} **\| sed -E '1d;$d' \| wc -l**<br>
?

### Smazat položku

*# smazat všechny*<br>
*// Poznámka: mám podezření, že tento příkaz nedokáže odstranit některé datové položky, jejichž názvy obsahují sekvence bajtů neplatné v UTF-8. Pro potvrzení nebo vyvrácení tohoto podezření by bylo potřeba další náročné experimentování.*<br>
**jmeno=$(realpath** [**\-\-**] {*cesta*}**)**<br>
[*sudo*] **getfattr** [**\-\-**] **"$jmeno" \| sed -E $'1d;$d' \| (export LC\_ALL=C; while read -r klic; do setfattr -x "$klic" \-\- "$jmeno"; done)**

*# **smazat***<br>
[**sudo**] **setfattr -x** {*klíč*} [**\-\-**] {*adr/položka*}...
<!--
*# smazat*<br>
[**sudo**] **xattr -d** {*user.klíč*} [**\-\-**] {*cesta*}...
-->

### Přečíst položku

*# **získat** hodnotu datové položky*<br>
*// Poznámka: hodnotou mohou obecná binárná data. Nepředpokládejte, že obsahuje text v kódování UTF-8 nebo že neobsahuje nulové bajty!*<br>
[**sudo**] **getfattr \-\-only-values -n** {*klíč*} [**\-\-**] {*adr/položka*} **\|** {*zpracování*}<br>
<!--
[**sudo**] **xattr -p**[**z**] {*user.klíč*} [**\-\-**] {*cesta*}...
-->

*# načíst klíče a hodnoty do asociativního pole bashe (nulové bajty nahradit za „\\n“)*<br>
?

*# načíst klíče do pole bashe*<br>
?
<!--
**eval "$(**[**sudo**] **getfattr** [**\-\-**] {*adr/položka*} **\| tr \\\\n \\\\0 \| LC\_ALL=C sed -zE '1d;$d;s/\\012/\\n/g;s/\\\\015/\\r/g;s/\\\\075/=/g;s/\\\\134/\\\\/g' \| (readarray -d ''** {*název\_pole*}**; declare -p** {*název\_pole*}**))"**
-->

*# délka hodnoty v **bajtech***<br>
[**sudo**] **getfattr \-\-only-values -n** {*klíč*} [**\-\-**] {*adr/položka*} **\| wc -c**

### Vytvořit či přepsat položku

*# **nastavit** datovou položku (hodnota je text/binární data)*<br>
[**sudo**] **setfattr -n** {*klíč*} **-v "0x$(printf %s "**{*text*}**" \| xxd -p -c 1 \| tr -d \\\\n)"** [**\-\-**] {*adr/položka*}...<br>
[**sudo**] **setfattr -n** {*klíč*} **-v "0x$(**{*zdroj*} **\| xxd -p -c 1 \| tr -d \\\\n)"** [**\-\-**] {*adr/položka*}...
<!--
[**sudo**] **xattr -w**[**z**] {*user.klíč*} **"**{*hodnota*}**"** [**\-\-**] {*cesta*}...
-->
<!--
### Robustní zpracování skriptem

*# **seznam** klíčů ve formátu TXTZ (uživatelských/i systémových)*<br>
[**sudo**] **getfattr** [**-m -**] <nic>[**\-\-**] {*adr/položka*} **\| LC\_ALL=C sed -E '1d;$d;s/\\012/\\n/g;s/\\\\015/\\r/g;s/\\\\075/=/g;s/\\\\134/\\\\/g'**

*# seznam klíčů a hodnot oddělených tabulátorem, pro skript,  ve formátu TXT (uživatelské/i systémové)*<br>
[**sudo**] **getfattr \-\-dump -e text** [**\-\-**] {*adr/položka*} **\| LC\_ALL=C sed -E '1d;$d;s/^([<nic>^=]\*)="/\\1\\t/;s/"$//**<br>
**sudo getfattr \-\-dump -e text -m -** [**\-\-**] {*adr/položka*} **\| LC\_ALL=C sed -E '1d;$d;s/^([<nic>^=]\*)="/\\1\\t/;s/"$//**

*# **smazat** atribut podle klíče*<br>
[**sudo**] **setfattr -x** {*klíč*} [**\-\-**] {*adr/položka*}...<br>

*# **nastavit** atribut podle klíče*<br>
[**sudo**] **setfattr -n** {*klíč*} **-v** {*hodnota*} [**\-\-**] {*adr/položka*}...<br>

*# **vypsat** hodnotu atributu podle klíče*<br>
*// Poznámka: Bez dodatečného příkazu „echo“ nepřidává na konec hodnoty žádný ukončovač.*<br>
[**sudo**] **getfattr \-\-only-values -n** {*klíč*} [**\-\-**] {*adr/položka*}[**; echo**]<br>


<!- -
Poznámka:
- v názvech odzvláštňuje příkaz „getfattr“ znaky: \r \n \ =
- v hodnotách odzvláštňuje znaky: \0 \r \n \
  a před znak uvozovka (") umísťuje zpětné lomítko

Tyto příkazy fungují spolehlivě, pokud názvy rozšířených atributů neobsahují znaky „\\0“, „\\n“, „"“, „#“, „=“, „\\“.

Všechny klíče uživatelských rozšířených atributů *musejí* začínat „user.“ a pokračovat alespoň jedním znakem. Žádný klíč nemůže obsahovat nulový bajt „\\0“.
- ->

*# vypsat **seznam klíčů** pro člověka (uživatelských/i systémových)*<br>
[**sudo**] **getfattr** [**\-\-**] {*adr/položka*} **\| sed -E ''**
**sudo getfattr -m - \-\-** [**\-\-**] {*adr/položka*}

*# vypsat seznam klíčů pro skript (formát TSVZ)(uživatelských/i systémových)*<br>
[**sudo**] **getfattr** [**\-\-**] {*adr/položka*} **\| tr \\\\n \\\\0 \| sed -zE '1d;$d;s/\\\\012/\\n/g;s/\\\\015/\\r/g;s/\\\\075/=/g;s/\\\\134/\\\\/g'** [**\|** {*zpracování*}]<br>
[**sudo**] **getfattr** [**\-\-**] {*adr/položka*} **\| tr \\\\n \\\\0 \| sed -zE '1d;$d;s/\\\\012/\\n/g;s/\\\\015/\\r/g;s/\\\\075/=/g;s/\\\\134/\\\\/g'** [**\|** {*zpracování*}]

*# smazat atribut podle klíče (klíč znaky „\\r“, „\\n“, „\\“ či „=“ neobsahuje/může obsahovat)*<br>
[**sudo**] **setfattr -x** {*klíč*} [**\-\-**] {*adr/položka*}...<br>
[**sudo**] **setfattr -x "$(sed -E 's/\\\\/\\\\134/g;s/=/\\\\075/g;s/\\n/\\\\012/g;s/\\r/\\\\015/g' &lt;&lt;&lt; "**{*klíč*}**")** [**\-\-**] {*adr/položka*}...<br>
-->

## Parametry příkazů

### chmod

*# *<br>
**chmod** [{*parametry*}] <nic>[**=**]{*mód*} [**\-\-**] {*cesta*}...<br>
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

Všechny použité nástroje jsou základními součástmi Ubuntu, s výjimkou příkazů
„tree“, „getfattr“ a „setfattr“, které můžete doinstalovat takto:

*# *<br>
**sudo apt-get install tree attr**

<!--
## Ukázka
<!- -
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)
-->

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Vlastníci a skupiny jsou v souborovém systému uloženy ve formě čísel UID a GID. Proto když uložíte soubor na USB flash disk a přenesete ho na jiný počítač, kde pracujete jako uživatel s jiným UID, může se stát, že tam k souborům na flash disku nebudete mít dostatečná přístupová práva.
* Symbolické odkazy mají vlastníka a skupinu, ale nemají vlastní přístupová práva. Přístup k odkazované položce se vždy řídí jejími přístupovými právy, čtení symbolického odkazu je bez omezení a zápis do něj není dovolen (je nutno místo toho odkaz smazat a vytvořit nový).
* Příznaky zmocnění vlastníka a skupiny jsou u souboru (vždy oba) automaticky odebrány, kdykoliv se změní jeho vlastník či skupina. U adresáře jsou v takové situaci ponechány.
* V linuxu existují také „výchozí přístupová práva“, což je nastavení přístupových práv na adresáři, které (je-li nastaveno) ovlivňuje přístupová práva nově vyvářených položek; bohužel nelze říci „stanovuje“, ale platí pouze „ovlivňuje“ – na výsledných právech se podílejí i další faktory, nelze rozlišit práva pro soubory a pro adresáře a celé je to dost komplikované a neintuitivní. Zatím jsem naštěstí nanarazil/a na případ, kdy by tuto vlastnost skutečně nějaký program použil.

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
