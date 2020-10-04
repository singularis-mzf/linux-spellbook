<!--

Linux Kniha kouzel, kapitola Hledání souborů
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

[ ] + hledání a řešení duplicit (finddup)

⊨
-->

# Hledání souborů

!Štítky: {tematický okruh}{adresáře}{hledání}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola se zabývá vyhledáváním adresářových položek (souborů a adresářů).
Převážně se zabývá příkazem „find“, který strukturu adresářů skutečně prochází
a prohledává, ale zahrnuje také vyhledávání spustitelných souborů (programů)
a na databázi založený příkaz „locate“.

## Definice

* **Výchozí bod** je cesta (relativní či absolutní) zadaná příkazu „find“, ze které tento příkaz zahajuje vyhledávání. Může být absolutní i relativní. Nejčastěji se jedná o adresář (např. „.“), ale může jít i o soubor či symbolický odkaz na adresář či soubor. Příkaz find výchozí bod nezkracuje, vždy ho zpracovává tak, jak je zadán.
* **Hloubka** je celé číslo, které vyjadřuje počet adresářů od výchozího bodu k právě testované adresářové položce. Hloubku 0 mají pouze výchozí body; hloubku 1 soubory a podadresáře v nich, hloubku 2 ty další atd. Je-li např. „/usr/share“ výchozí bod, pak adresář „/usr/share“ má hloubku 0, soubor „/usr/share/.lock“ by měl hloubku 1, soubor „/usr/share/test/copyright.gz“ hloubku 2 atd.
* Průchod adresářovou strukturou může být **do šířky** (výchozí stav – každý adresář je nejprve zpracován sám o sobě (provedou se nad ním testy a v případě úspěchu se vykonají akce) a teprve poté do něj find vstoupí a prozkoumá jeho obsah) nebo **do hloubky** (v tom případě find pokaždé nejprve vstoupí do adresáře a zpracuje veškerý jeho obsah a teprve „na odchodu“ zpracuje i samotný adresář). Výchozí je průchod do šířky. Průchod do hloubky se aplikuje pouze tehdy, je-li zadán globální parametr „-depth“ nebo je-li použita akce „-delete“. Při průchodu do hloubky nelze použít akci „-prune“.
* **Názvem položky** se u příkazu „find“ rozumí samotný název adresářové položky (bez cesty).
* **Cestou položky** se u příkazu „find“ rozumí výchozí bod (tak, jak byl zadaný) a za ním adresářová cesta k položce včetně jejího názvu. Je-li např. výchozí bod „.“, je cestou položky např. „./test.sh“.

!ÚzkýRežim: vyp

## Zaklínadla: find: testy

### Typ adresářové položky (soubor, adresář, odkaz...)

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

### Název položky a cesta

Poznámka: Písmeno „i“ v následujících parametrech vypne rozlišování mezi velkými a malými písmeny.

*# **název** položky*<br>
**\-**[**i**]**name "**{*vzorek*}**"**

*# **cesta** položky*<br>
**\-**[**i**]**path "**{*vzorek*}**"**

*# cesta položky se shoduje s **regulárním výrazem***<br>
[**\-regextype posix-extended**] **-**[**i**]**regex '**{*regulární výraz*}**'**

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

### Čas („změněno“, „čteno“)

*# změněno/čteno v rozsahu dnů*<br>
*// Dny zadejte ve formátu %F (YYYY-MM-DD).*<br>
**-newermt "**{*první-den-intervalu*} **00:00:00" \\! -newermt "**{*poslední-den-intervalu*} **23:59:59"**<br>
**-newerat "**{*první-den-intervalu*} **00:00:00" \\! -newerat "**{*poslední-den-intervalu*} **23:59:59"**
<!--
[ ] VYZKOUŠET!
-->

*# čteno od poslední změny*<br>
?

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

### Operátory testů

*# oba testy musejí být splněny (**a také**)*<br>
{*test1*} {*test2*}

*# test nesmí být splněn (**ne-**)*<br>
**\\!** {*test*}

*# závorky (**seskupení** testů a akcí)*<br>
**\\(** {*testy a akce*} **\\)**

*# některý z testů musí být splněn (**nebo**)*<br>
{*test1*} **-o** {*test2*}

### Vlastnictví a skupina položky

*# vlastník souboru (názvem/UID)*<br>
**\-user** {*uživatel*}<br>
**\-uid** {*UID*}

*# skupina (názvem/GID)*<br>
**\-group** {*skupina*}<br>
**\-gid** {*GID*}

### Přístupová práva (ACL)

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

*# kdokoliv má určité právo*<br>
?

*# nikdo nemá právo „w“*<br>
?
<!--
**\! \-perm /ugo=w**
-->

<!--
-perm /{...} = „nebo“ – mezi uvedenými musí existovat právo, které je položkou splněno
-perm -{...} = „a“ – všechna uvedená práva musejí být položkou splněna
-->

### Obsah souboru

<!--
[ ] Vyzkoušet!
-->
*# některý řádek obsahuje/žádný řádek neobsahuje shodu s regulárním výrazem*<br>
**\\! \( -type d -o \( -type l -xtype d \) \) -readable \-exec egrep -q** [**\-\-**] **'**{*regulární výraz*}**' \\;**
**\\! \( -type d -o \( -type l -xtype d \) \) -readable \\! \-exec egrep -q** [**\-\-**] **'**{*regulární výraz*}**' \\;**

<!--
[ ] Vyzkoušet!
-->
*# některá řádka obsahuje/žádná řádka neobsahuje podřetězec*<br>
**\\! \( -type d -o \( -type l -xtype d \) \) -readable \-exec fgrep -q** [**\-\-**] **'**{*podřetězec*}**' \\;**
**\\! \( -type d -o \( -type l -xtype d \) \) -readable \\! \-exec fgrep -q** [**\-\-**] **'**{*podřetězec*}**' \\;**

### Velikost adresáře

*# prázdný adresář*<br>
**\-type d -empty**

*# adresář s alespoň N položkami/právě N položkami/nejvýše N položkami*<br>
**\-type d -exec sh -c 'test $(ls -1AbU \-\- "$1" \| wc -l) -ge** {*N*}**' \-\- '{}' \\;** [**\-\-print**]<br>
**\-type d -exec sh -c 'test $(ls -1AbU \-\- "$1" \| wc -l) -eq** {*N*}**' \-\- '{}' \\;** [**\-\-print**]<br>
**\-type d -exec sh -c 'test $(ls -1AbU \-\- "$1" \| wc -l) -le** {*N*}**' \-\- '{}' \\;** [**\-\-print**]

### Ostatní

*# pevné odkazy konkrétního souboru*<br>
**\-samefile** {*soubor*}

*# neplatné symbolické odkazy*<br>
**\-type l \-xtype l**

*# počet pevných odkazů (přesně/minimálně/maximálně N)*<br>
**\-links** {*N*}<br>
**\-links +$((**{*N*}**-1))**<br>
**\-links -$((**{*N*}**+1))**

*# test, který vždy uspěje/selže*<br>
**\-true**<br>
**\-false**

*# má uživatelské rozšířené atributy*<br>
?

*# vlastník nebo skupina souboru neexistuje*<br>
**\\( -nogroup -o -nouser \\)**

*# typ souborového systému*<br>
*// Např. „ext4“, „tmpfs“, „ntfs“, „vfat“.*<br>
**\-fstype** {*typ*}
<!--
[ ] Znovu otestovat. Mám podezření, že někdy nefunguje.
-->

*# čislo **inode***<br>
**\-inum** {*inode*}

*# **hloubka** prohledávání*<br>
*// K omezení hloubky prohledávání se obvykle používají globální parametry „-mindepth“ a „-maxdepth“. Nejsou sice tak univerzální jako samostatný test, ale pro většinu účelů stačí.*<br>
?

## Zaklínadla: find: akce

### Vypsat údaje

*# cestu položky na standardní výstup (txt/txtz)*<br>
*// Znaky takto vypsané cesty nejsou nijak odzvláštněny, což vadí jen v případě, že použijete „-print“ a cesta obsahuje znak konce řádky. Pokud s takovým vzácným případem chcete počítat, použijte místo toho „-print0“.*<br>
**\-print**<br>
**\-print0**

*# vypsat údaje podle formátu na standardní výstup/do souboru*<br>
**\-printf '**{*formát*}**'**<br>
**\-fprintf** {*soubor*} **'**{*formát*}**'**

*# zapsat cestu položky jako záznam do souboru (txt/txtz)*<br>
**\-fprint** {*soubor*}<br>
**\-fprint0** {*soubor*}

<!--
-fprint {soubor}
-fprint0 {soubor}
-fprintf {soubor} {formát}
-print0
-printf {formát}

fprintf:
%fhlpP – quoted

-ok[dir] {příkaz} [parametry] ; – jako exec[dir], ale zeptá se uživatele

-->


### Ostatní akce

*# **spustit** příkaz po dávkách (vždy uspěje)*<br>
*// Tato varianta je prakticky pohodlnějším ekvivalentem volání příkazu xargs. Použije co největší dávky. Vždy uspěje.*<br>
**\-exec** {*příkaz*} [{*parametry příkazu*}] **'{}' +**

*# spustit příkaz po dávkách po adresářích (vždy uspěje)*<br>
*// Tato varianta vždy uspěje. Shromáždí položky z jednotlivého adresáře a po velkých dávkách (obvykle najednou) je předá ke zpracování uvedenému příkazu. Příkaz se spouští v adresáři, kde jsou vyhledané položky, a dostává pouze název položky s cestou „./“.*<br>
**\-execdir** {*příkaz*} [{*parametry příkazu*}] **'{}' +**

*# spustit příkaz pro **každou** položku (s cestou/bez cesty)*<br>
*// Každý výskyt řetězce „{}“ v parametrech příkazu bude při volání nahrazen: v případě první varianty cestou testované položky od výchozího bodu, v případě varianty bez cesty jen názvem souboru s cestou „./“ (příkaz bude spuštěn ve stejném adresáři, kde se položka nachází). Akce uspěje, pokud uspěje příkaz.*<br>
**\-exec** {*příkaz*} [{*parametry příkazu*}] **\\;**<br>
**\-execdir** {*příkaz*} [{*parametry příkazu*}] **\\;**

*# **smazat** soubor či prázdný adresář*<br>
*// Akce uspěje, pokud se soubor či adresář podaří smazat.*<br>
**\-delete**

*# je-li položka adresář, **nevstupovat** do něj a ignorovat jeho obsah*<br>
*// Tato akce funguje jen při průchodu do šířky. Proto lze použít jen tehdy, pokud v celém příkazu není použity ani jeden z paramterů „-delete“ a „-depth“.*<br>
**\-prune**

*# smazat soubor či jakýkoliv (i neprázdný) adresář*<br>
*// Tato akce funguje jen při průchodu do šířky. Proto lze použít jen tehdy, pokud v celém příkazu není použity ani jeden z paramterů „-delete“ a „-depth“.*<br>
**-exec rm -R**[**v**] <nic>[**\-\-**] **'{}' \\; -prune**

*# **ukončit** načítání dalších položek*<br>
**\-quit**

## Zaklínadla: Akce -printf a -fprintf

*# název položky/cesta položky/cesta položky bez výchozího bodu*<br>
**%f** ⊨ test.txt<br>
**%p** ⊨ ./testdir/test.txt<br>
**%P** ⊨ testdir/test.txt

*# typ adresářové položky (písmeno)*<br>
**%y** ⊨ f

*# cesta položky bez názvu*<br>
**%h** ⊨ ./testdir

*# přístupová práva symbolicky/číselně*<br>
**%M** ⊨ -rw-r\-\-r\-\-<br>
**%#m** ⊨ 0644

*# vlastník (jméno/UID)*<br>
**%u** ⊨ milada<br>
**%U** ⊨ 1000

*# skupina (jméno/GID)*<br>
**%g** ⊨ milada<br>
**%G** ⊨ 1000

*# velikost souboru v bajtech*<br>
**%s** ⊨ 3

*# čas „změněno“(normálně/časová známka Unixu)*<br>
*// V obou případech se bohužel vypíše s desetinnou částí.*<br>
**%Ty-%Tm-%Td %TT** ⊨ 2020-03-13 22:03:00.9467889490<br>
**%T@** ⊨ 1584133380.9467889490

*# čas posledního přístupu (normálně/časová známka Unixu)*<br>
*// V obou případech se bohužel vypíše s desetinnou částí.*<br>
**%Ay-%Am-%Ad %AT** ⊨ 2020-03-13 22:03:00.9467889490<br>
**%A@** ⊨ 1584133380.9467889490

*# počet pevných odkazů*<br>
**%n** ⊨ 1

*# výchozí bod*<br>
**%H** ⊨ .

*# hloubka prohledávání*<br>
**%d** ⊨ 1

*# typ souborového systému*<br>
**%F** ⊨ ext4

*# cíl (obsah) symbolického odkazu*<br>
*// Pokud položka není symbolický odkaz, %l vypisuje prázdný řetězec.*<br>
**%l** ⊨

*# číslo „inode“*<br>
**%i** ⊨ 2758499


## Zaklínadla: Celé příkazy

### Hledání textových souborů podle obsahu

*# najít soubory, jejichž některá řádka obsahuje/žádný řádek neobsahuje shodu s regulárním výrazem*<br>
**find** {*kde*}... **-type f -readable** [{*další podmínky*}]... **-exec egrep -l '**{*regulární výraz*}**' '{}' +**<br>
**find** {*kde*}... **-type f -readable** [{*další podmínky*}]... **-exec egrep -L '**{*regulární výraz*}**' '{}' +**

*# najít soubory, jejichž některá řádka obsahuje/žádný řádek neobsahuje podřetězec*<br>
**find** {*kde*}... **-type f -readable** [{*další podmínky*}]... **-exec fgrep -l '**{*regulární výraz*}**' '{}' +**<br>
**find** {*kde*}... **-type f -readable** [{*další podmínky*}]... **-exec fgrep -L '**{*regulární výraz*}**' '{}' +**

*# najít symbolické **smyčky**, tzn. symbolické odkazy, které přímo či nepřímo odkazují samy na sebe*<br>
**find** {*kde*} **-type l -printf '%Y%p\\0' \| sed -zE 's/^L//;t;d'** [**\| tr \\\\0 \\\\n**]

### Hledání programů

*# najít úplnou cestu podle názvu příkazu*<br>
*// Poznámka: tento příkaz (pochopitelně) ignoruje vestavěné příkazy bashe, aliasy, funkce apod. Řídí se pouze proměnnou prostředí PATH.*<br>
**which** {*název-příkazu*}...

*# najít manuálové stránky (jako soubory/název a sekce)*<br>
**find -L /usr/share/man -type f -name '**{*název*}**.\*.gz'** [**\| sort**]<br>
**find -L /usr/share/man -type f -name '**{*název*}**.\*.gz' \| sed -E 's/.\*\\/(.\*)\\.([<nic>^.]+)\\.gz$/\\1(\\2)/' \| sort -u**

### Obecné hledání

*# najít a odstranit **prázdné** adresáře/soubory/soubory i adresáře*<br>
**find** {*kde*}... **-type d -empty -delete**<br>
**find** {*kde*}... **-type f -empty -delete**<br>
**find** {*kde*}... **-empty -delete**

*# najít **neplatné** symbolické odkazy (pro člověka/pro skript)*<br>
*// Pozor! Příkaz nemůže správně určit, zda je symbolický odkaz neplatný, pokud nemá přístupová práva k adresáři, na který symbolický odkaz odkazuje! Příkaz „symlinks“ v takovém případě hlásí odkaz jako neplatný, uvedená podoba příkazu „find“ vypíše chybové hlášení „Permission denied“, ale odkaz do seznamu neplatných nezahrne.*<br>
[**sudo**] **find** {*kde*}... **-type d -exec symlinks '{}' + \| egrep '^dangling:&blank;'**
[**sudo**] **find** {*kde*}... **-type l -xtype l** [**-print0**]

*# najít adresářové položky, jejichž název/celá cesta obsahují shodu s regulárním výrazem (pomoc databáze „mlocate“)*<br>
[**sudo**] **locate \-\-regex -b** [**-e**] <nic>[**-i**] **-r '**{*regulární výraz pro název položky*}**'**<br>
[**sudo**] **locate \-\-regex** [**-e**] <nic>[**-i**] **-r '**{*regulární výraz pro celou cestu*}**'**

## Parametry příkazů

### find

*# *<br>
[**sudo**] **find** [**-P**] {*cesta*}... {*globální parametry*} {*testy-a-akce*}<br>
[**sudo**] **find -L** {*cesta*}... {*globální parametry*} {*testy-a-akce*}<br>
[**sudo**] **find -H** {*cesta*}... {*globální parametry*} {*testy-a-akce*}

Chování k symbolickým odkazům: **-P**: nikdy nenásledovat (interpretovat každý odkaz jen jako adresářovou položku); **-L**: vždy následovat (chovat se, jako by na místě symbolického odkazu byl odkazovaný soubor, adresář apod.; vstupovat do takových adresářů); **-H**: následovat jen symbolické odkazy, které jsou přímo uvedeny jako „cesta“ na příkazové řádce.

<neodsadit>Globální parametry:

!parametry:

* ☐ -xdev :: Po každou „cestu“ na příkazové řádce omezí prohledávání jen na jeden souborový systém.
* ☐ -depth :: Adresář zpracuje až „na odchodu“, tzn. teprve po zpracování veškerého jeho obsahu. Normálně se adresář zpracuje jako první a pak se teprve testuje jeho obsah.
* ☐ -maxdepth {*číslo*} :: Sestoupí maximálně do uvedené hloubky. 0 znamená testovat jen cesty uvedené na příkazové řádce; 1 znamená testovat i položky v adresářích uvedených na příkazovém řádku; 2 znamená testovat i položky v podadresářích těchto adresářů atd.
* ☐ -mindepth {*číslo*} :: Na položky v hloubce nižší než „číslo“ se nebudou aplikovat žádné testy ani akce a nebudou vypsány. Pozor, to znamená, že na ně nebude účinkovat akce -prune! Příkaz find se pokusí vstoupit do každého adresáře s hloubkou menší než „mindepth“.


<neodsadit>Testy a akce jsou uvedeny jako zaklínadla v předchozí části kapitoly.

## Instalace na Ubuntu

Většina uvedených příkazů je základními součástmi Ubuntu. Pouze příkaz „symlinks“ musíte v případě potřeby doinstalovat:

*# *<br>
**sudo apt-get install symlinks**

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
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->

* Naučte se s příkazem „find“ používat parametr „-exec“, zejména jeho hromadnou variantu „po dávkách“. Jeho použití je většinou mnohem pohodlnější než tradiční kombinace s příkazem „xargs“. Jedinou výjimkou je případ, kdy chcete příkazy vykonávat paralelně.
* Příkaz „find“ cesty na svém výstupu nijak neřadí.
* Příkaz „locate“ respektuje přístupová práva a najde pouze adresářové položky, ke kterým má uživatel v dané chvíli přístup.

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->

* [Wikipedie: find](https://cs.wikipedia.org/wiki/Find)
* [Oficiální dokumentace balíčku „findutils“](https://www.gnu.org/software/findutils/manual/html\_node/find\_html/) (anglicky)
* [YouTube: Linux Find Command Tutorial](https://www.youtube.com/watch?v=f3KwmOb42j4) (anglicky)
* [YouTube: Find Files in Linux (find, whereis)](https://www.youtube.com/watch?v=O9lNYhz8amY) (anglicky)
* man find (anglicky)
* [Balíček findutils](https://packages.ubuntu.com/focal/findutils) (anglicky)
* [TL;DR: find](https://github.com/tldr-pages/tldr/blob/master/pages/common/find.md) (anglicky)
* [TL;DR: locate](https://github.com/tldr-pages/tldr/blob/master/pages/linux/locate.md) (anglicky)
* [TL;DR: which](https://github.com/tldr-pages/tldr/blob/master/pages/common/which.md) (anglicky)

<!--
https://www.youtube.com/watch?v=zmlNuMKJSkc – Dobré video, ale dělá chybu *.log bez uvozovek.
-->

!ÚzkýRežim: vyp
