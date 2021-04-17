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

!Štítky: {tematický okruh}{systém souborů}{soubory}{adresáře}
!FixaceIkon: 1754
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod

**Pevný odkaz** je pojmenovaný odkaz na soubor z adresáře.
Většina nelinuxových typů souborových systémů dovoluje mít na každý soubor
pouze jeden pevný odkaz, takže umístění i pojmenování souboru je pak jednoznačné;
linuxové souborové systémy vás ale takto omezují pouze v umísťování adresářů.
Na každý soubor vám však dovolují zřídit až tisíce rovnocenných pevných odkazů,
takže tentýž soubor se pak v souborovém systému nachází pod více názvy,
případně i v různých adresářích a nezáleží na tom, přes který z těchto názvů
k němu přistupujete. Zatímco všechny ostatní vlastnosti souboru
jsou jednoznačně uloženy v jeho metadatech, název a příslušnost k adresáři
určuje každý pevný odkaz samostatně.
Pevné odkazy jsou (na rozdíl od symbolických) vždy platné, protože data a metadata
souboru se nesmažou, dokud na ně nějaký pevný odkaz odkazuje.

**Symbolický odkaz** je něco docela jiného – je to malý zvláštní soubor,
který obsahuje pouze určitou relativní či absolutní cestu a programy
s ním pak většinou zachází tak, jako by se na daném místě nacházel soubor
či adresář touto cestou odkazovaný – jde-li o adresář, můžeme do něj vstoupit
příkazem „cd“; jde-li o spustitelný program, můžeme ho spustit atd.
Pokud ovšem na odkazované cestě nic neleží, symbolický odkaz je neplatný
a programy se s tím musejí nějak vyrovnat.

Příkazy ln, readlink, stat a některé další jsou vyvíjeny v rámci projektu GNU.

## Definice

* **Pevný odkaz** je, obecně vzato každá položka v adresáři; pro účely této kapitoly se však omezíme na definici, že pevným odkazem je pouze adresářová položka reprezentující obyčejný soubor. Součástí pevného odkazu je pouze název a umístění v adresáři, *všechny* ostatní údaje o souboru jsou vlastnostmi souboru jako takového.
* **Symbolický odkaz** je malý zvláštní soubor, který obsahuje relativní či absolutní cestu k cílovému souboru či adresáři. Symbolické odkazy se dělí na **absolutní** (obsahující absolutní cestu) a **relativní** (obsahující relativní cestu). Symbolický odkaz odkazující na neexistující cestu se označuje jako **neplatný**.
* **Následovat** symbolický odkaz (follow) znamená chovat se, jako by se na jeho místě a pod jeho názvem skutečně nacházel odkazovaný soubor či adresář. Oproti tomu **nenásledovat** symbolický odkaz znamená chovat se k němu jen jako k adresářové položce. V linuxu je obvyklé, že při práci s jednotlivým souborem či adresářem se symbolické odkazy následují (např. pokusíte-li se spustit symbolický odkaz na program, spustí se program), zatímco při rekurzivním průchodu adresářovou strukturou (např. příkazy „find“, „cp -R“, „chmod -R“ apod.) se nenásledují. Ve většině případů však toto chování můžete změnit určitým parametrem příkazu.

!ÚzkýRežim: vyp

## Zaklínadla

### Pevné odkazy

*# **vytvořit** pevný odkaz na soubor*<br>
**ln -T**[**f**]<nic>[**v**] <nic>[**\-\-**] {*cesta/k/souboru*} {*cesta/výsl/odkazu*}

*# vytvořit pevné odkazy hromadně*<br>
**ln -t**[**f**]<nic>[**v**] <nic>[**\-\-**] {*cílový/adresář*} {*cesta/k/souboru*}...

*# přejmenovat či **přesunout** pevný odkaz (alternativy)*<br>
**mv -T**[**i**] {*původní/cesta*} {*nová/cesta*}<br>
**mv -T**[**f**] {*původní/cesta*} {*nová/cesta*}

*# **smazat** pevný odkaz*<br>
**rm** [**\-\-**] {*cesta/k/odkazu*}...

*# vypsat **počítadlo odkazů***<br>
*// Parametr „-L“ vypne následování symbolických odkazů. Bez něj se vypíše počítadlo odkazovaného souboru či adresáře, s ním se vypíše počítadlo samotného symbolického odkazu.*<br>
**stat -c %h** [**-L**] <nic>[**\-\-**] {*cesta-k-odkazu*}

*# vypsat **kanonickou** (absolutní) cestu (bez/s následováním)*<br>
**realpath -se** {*cesta-k-odkazu*} ⊨ /home/petr/odkaz-na-passwd<br>
**realpath -e** {*cesta-k-odkazu*} ⊨ /etc/passwd

*# odkazují dva odkazy na **tentýž** soubor? (s následováním/bez něj)*<br>
**test** {*cesta1*} **-ef** {*cesta2*}<br>
**test "$(stat -c %d/%i -L** [**\-\-**] {*cesta1*} **)" = "$(stat -c %d/%i -L** [**\-\-**] {*cesta2*}**)"**

<!--
[ ] Vyzkoušet stat -c %d/%i na FAT32 a NTFS.
-->

*# osamostatnit pevný odkaz od ostatních odkazů*<br>
**f="**{*název-souboru*}**"**<br>
**test "$(stat -L -c %h "$f")" -le 1 \|\| if test -L "$f"; then ln -sfT "$(readlink \-\- "$1")"; elif test -f "$f"; then cp -Tai \-\- "$f" "${f}.nový" &amp;&amp; mv -Tf \-\- "${f}.nový" "$f"; fi**

*# vypsat kanonickou cestu adresáře obsahujícího pevný odkaz (s následováním)*<br>
**dirname \-\- "$(realpath -e** {*cesta-k-odkazu*}**)"** ⊨ /etc

<!--
*# vytvořit dočasný, zdánlivý, nerekurzivní pevný odkaz na adresář*<br>
**mkdir -p** {*nová-cesta*}<br>
**mount** [**-o ro**] **\-\-bind** {*původní-cesta*} {*nová-cesta*}

není dobrý nápad
-->

### Symbolické odkazy (vytvořit)

*# **vytvořit** relativní/absolutní (bez následování)*<br>
**ln -sT**[**f**] **"$(realpath -s "\-\-relative-to=$(dirname** [**\-\-**] {*cesta/výsl/odkazu*}**)"** [**\-\-**] {*cesta/k/cíli*}**)"** [**\-\-**] {*cesta/výsl/odkazu*}<br>
**ln -sT**[**f**] **"$(realpath -s** [**\-\-**] {*cesta/k/cíli*}**)"** [**\-\-**] {*cesta/výsl/odkazu*}

*# vytvořit relativní/absolutní (s následováním)*<br>
**ln -rsT**[**f**] <nic>[**\-\-**] {*cesta/k/cíli*} {*cesta/výsl/odkazu*}<br>
**ln -sT**[**f**] **"$(realpath -e** [**\-\-**] {*cesta/k/cíli*}**)"** [**\-\-**] {*cesta/výsl/odkazu*}

*# **hromadné** vytvoření relativních (s následováním)*<br>
*// Názvy vytvářených symbolických odkazů se odvodí od názvů v „cestě/k/cíli“.*<br>
**ln -rs -t** {*cílový/adresář*} [**\-\-**] {*cesta/k/cíli*}...

*# vytvořit **obecný***<br>
*// Obsah odkazů musí mít délku 1 až 4095 bajtů, jinak však v tomto případě neprovádí příkaz „ln“ žádnou kontrolu smysluplnosti obsahu odkazu. Toto je tedy preferovaný způsob vytváření symbolických odkazů na dosud neexistující soubory a adresáře.*<br>
**ln -sT**[**f**] **"**{*obsah-odkazu*}**"** {*cesta/výsl/odkazu*}

### Symbolické odkazy (ostatní operace)

*# přejmenovat či **přesunout** (alternativy)*<br>
*// Relativní symbolický odkaz si při přesunutí zachová svůj obsah doslovně, de facto se tedy přesune se odpovídajícím způsobem i to, kam ukazuje. Pokud chcete, aby i po přesunutí odkazoval na původní cíl, budete ho muset „opravit“. Toto se netýká absolutních symbolických odkazů.*<br>
**mv -T**[**i**] {*původní/cesta*} {*nová/cesta*}<br>
**mv -T**[**f**] {*původní/cesta*} {*nová/cesta*}

*# **smazat***<br>
**rm** [**\-\-**] {*cesta/k/odkazu*}...

*# je adresářová položka symbolický odkaz?*<br>
**test -L** {*cesta/k/položce*}

*# je absolutní/relativní?*<br>
**[[** [**-L** {*cesta/k/odkazu*} **&amp;&amp;**] **$(readlink** [**\-\-**] {*cesta/k/odkazu*} **) = /\* ]]**<br>
**[[** [**-L** {*cesta/k/odkazu*} **&amp;&amp;**] **$(readlink** [**\-\-**] {*cesta/k/odkazu*} **) != /\* ]]**

*# odkazuje na soubor/na adresář/na pojmenovanou rouru?*<br>
**test** [**-L** {*cesta/k/odkazu*} **-a**] **-f** {*cesta/k/odkazu*}<br>
**test** [**-L** {*cesta/k/odkazu*} **-a**] **-d** {*cesta/k/odkazu*}<br>
**test** [**-L** {*cesta/k/odkazu*} **-a**] **-p** {*cesta/k/odkazu*}

*# je neplatný?*<br>
*// Pozor! Pokud nemáte přístup do adresáře, kam symbolický odkaz vede, bude se vám vždy jevit jako neplatný! V případě pochybností raději hledejte neplatné odkazy s použitím „sudo“ nebo obsah vyhledaných odkazů kontrolujte.*<br>
**!&blank;readlink -e \-\-** {*cesta/k/odkazu*} **&gt;/dev/null &amp;&amp; test -L** {*cesta/k/odkazu*}

*# vypsat obsah (doslovně)*<br>
**readlink** [**\-\-**] {*cesta/k/odkazu*}... ⊨ ../../etc/passwd

*# vypsat kanonickou (absolutní) cestu cíle*<br>
**realpath -e** {*cesta-k-odkazu*} ⊨ /etc/passwd

*# nahradit symbolický odkaz pevným odkazem na tentýž soubor*<br>
**ln -Tf**[**v**] <nic>[**\-\-**] **"$(readlink -e** {*cesta/k/odkazu*}**)" "**{*cesta/k/odkazu*}**"**

### Rekurzivní operace

*# **okopírovat** adresáře, ale na soubory místo kopírování vytvořit pevné odkazy*<br>
[**sudo**] **cp -TRl**[**v**] <nic>[**\-\-**] {*původní/adresář*} {*nový/adresář*}

*# kopírovat s následováním symbolických odkazů*<br>
[**sudo**] **cp -TRL**[**v**] <nic>[**\-\-**] {*původní/adresář*} {*nový/adresář*}

*# **nahradit předponu** v symbolických odkazech*<br>
**find** {*adresář*}... **-type l -printf '=%p\\0=%l\\0\\0' \| gawk -b -v "puv=**{*co-nahradit*}**" -v "nov=**{*čím-nahradit*}**" -v 'FS=\\0' -v 'RS=\\0\\0' -v 'OFS=' -v apo=\\' 'function f(s) {return gensub(apo, apo "\\\\" apo apo, "g", s)} substr($2, 2, length(puv)) == puv {print "ln -Tfsv ", apo, f(nov substr($2, 2 + length(puv))), apo, " ", apo, f(substr($1, 2)), apo}' \| bash** [**-e**]

*# kde je to možné, konvertovat symbolické odkazy na pevné*<br>
**find** {*adresář*}... **-type l ! -xtype d,l -exec sh -c 'exec ln -Tfv \-\- "$(readlink -e \-\- "$1")" "$1"' \-\- '{}' \\;** [**2&gt;/dev/null**]

*# symbolické odkazy konvertovat na relativní/absolutní*<br>
**find** {*adresář*}... **-type l ! -xtype l -lname '/\*' -exec ln -Trsf \-\- '{}' '{}' \\;**<br>
**find** {*adresář*}... **-type l ! -xtype l ! -lname '/\*' -exec sh -c 'exec ln -Tsf \-\- "$(readlink -e \-\- "$1")" ""' \-\- '{}' \\;**

*# odstranit všechny symbolické odkazy*<br>
**find** {*adresář*}... **-type l** [**-print**] **-delete**

*# najít duplicitní soubory a sloučit je pomocí pevných odkazů*<br>
?
<!--
Toto je velice komplikovaný úkol, protože musí fungovat i v případech, kdy oba duplicitní soubory mají mnoho pevných odkazů, např.:

duplicitní soubory: 1 2

pevné odkazy:
- adresář/a -> 1
- adresář/b -> 2
- adresář/c -> 1
- adresář/d -> 2
- jiný-adresář/x -> 1

V uvedeném případě musí být výsledkem, že v „adresáři“ odkazují pevné odkazy a, b, c i d na jeden (ale tentýž) ze souborů 1 a 2,
přičemž odkaz v „jiném-adresáři“ se změnit nesmí, protože se nachází mimo oblast zadanou pro slučování duplicitních souborů.
Toho je s dostupnými nástroji (např. fdupes) obtížné dosáhnout.
-->


<!--
*# kopírovat adresářovou strukturu bez souborů*<br>
**env -C** {*cesta/zdroje*} **find . -type d -print0 \| env -C** {*cesta/cíle*} **xargs -r0**[**t**] **mkdir -p**[**v**]
[ ] Vyzkoušet.
[ ] Problém: nezachovává datové položky.

Oblíbené rsync parametry:

-aviA
--progress
--noatime
--delete
--backup --backup-dir=...
--exclude=''
-->

## Parametry příkazů

### ln

*# *<br>
**ln** [{*parametry*}] <nic>[**\-\-**] {*zdroj*}... {*cíl*}<br>
**ln** [{*parametry*}] **-t** {*cílový/adresář*} [**\-\-**] {*zdroj*}...

!parametry:

* ○ -s ◉ :: Vytváří symbolické odkazy/pevné odkazy.
* ☐ -v :: Vypíše každý vytvořený odkaz.
* ○ -f ○ -i ◉ :: Pokud cíl existuje: přepíše ho bez ptaní/zeptá se uživatele/selže.
* ☐ -r :: V kombinaci s -s vytváří platné relativní symbolické odkazy. Výchozí chování: vytváří obecné symbolické odkazy.
* ☐ -P :: Nenásleduje symbolické odkazy uvedené jako „zdroj“. Nemá smysl v kombinaci s „-s“.

### readlink

*# *<br>
**readlink** [{*parametry*}] <nic>[**\-\-**] {*cesta*}...<br>
**readlink -n** [**\-\-**] {*cesta*}

!parametry:

* ○ -e ◉ :: Vypíše obsah jako kanonickou absolutní cestu (pokud cíl existuje)/tak, jak je.
* ○ -z ◉ :: Jednotlivé obsahy ukončuje nulovým bajtem/znakem „\\n“.
* -n :: Vypíše obsah symbolického odkazu bez dodatečného ukončovače.

## Instalace na Ubuntu

Všechny použité nástroje jsou základní součástí Ubuntu přítomnou i v minimální instalaci.
Výjimkou je jen příkaz „gawk“, který je nutno doinstalovat:

**sudo apt-get install gawk**

## Ukázka

*# *<br>
**echo A1 &gt;a; echo B1 &gt;b**<br>
**ln -Tv a c**<br>
**stat -c %h a**<br>
**echo A2 &gt;a; cat c**<br>
**mkdir o; ln -rsT a o/a**<br>
**readlink \-\- o/a**<br>
**readlink -e \-\- o/a**<br>
**cat o/a**<br>
**test a -ef c; echo $?**<br>
**test a -ef o/a; echo $?**<br>
**stat -c %h o/a**<br>
**stat -c %h -L o/a**
**find o -type l -print -delete**<br>
**rmdir -v o; rm -fv a b c**

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Častou začátečnickou chybou je příkaz typu „ln -s soubory/a odkazy/na-a“. Uvedený příkaz totiž vytvoří symbolický odkaz s obsahem „soubory/a“ a relativní symbolické odkazy se vždy vyhodnocují relativně vůči adresáři, ve kterém se nacházejí, takže faktickým cílem vytvořeného odkazu bude ve skutečnosti „odkazy/soubory/a“, který nejspíš neexistuje. Proto při vytváření relativních symbolických odkazů vždy používejte parametr „-r“, který cesty automaticky opraví. (Toto se nijak netýká absolutních ani pevných odkazů.)
* Méně častou začátečnickou chybou je příkaz typu „ln -sf /etc/passwd odkaz-na-passwd“. Pokud by se totiž stalo, že „odkaz-na-passwd“ je existující symbolický odkaz na adresář, příkaz „ln“ uváží, že chcete vytvořit odkaz uvnitř odkazovaného adresáře, ne že chcete přepsat existující symbolický odkaz. Proto v kombinaci s parametrem „-f“ vždy používejte také parametr „-T“, nebo „-t“. (Tyto parametry se může vyplatit používat i v ostatních případech.)
* Pokud symbolický odkaz odkazuje někam dovnitř adresáře, kam uživatel nemá právo vstoupit, bude se odkaz jevit uživateli jako neplatný, i když to ve skutečnosti nebude pravda.
* Symbolický odkaz má vlastnictví a skupinu, ale nemá vlastní přístupová práva. Přístup k odkazovanému souboru či adresáři se vždy řídí přístupovými právy odkazovaného souboru či adresáře.
* Maximální počet pevných odkazů na jeden soubor je omezený souborovým systémem; v souborových systémech typu ext4 je to 65000, u btrfs 65535 a u tmpfs podstatně víc (podařilo se mi jich vytvořit i víc než milion, aniž by to spotřebovalo příliš mnoho paměti).
* Symbolický odkaz sám o sobě je „nezapisovatelný“; pokud ho chceme změnit, musíme ho nejprve smazat a pak znovu vytvořit. To také znamená, že ke změně obsahu symbolického odkazu potřebuje uživatel právo zápisu do adresáře, kde se odkaz nachází.
* Symbolický odkaz může odkazovat na jiný symbolický odkaz, ale maximální počet zanoření symbolických odkazů je 40 (pravděpodobně jde změnit).
* Maximální délka obsahu symbolického odkazu je 4095 bajtů.
* Soubor bude odstraněn z disku v momentě, kdy už na něj neexistují žádné pevné odkazy, není spuštěný jako proces a není otevřený žádným deskriptorem žádného procesu.

### Jaký typ odkazu zvolit?

Při rozhodování mezi absolutním a relativním symbolickým odkazem je zasadní otázka, zda se bude odkaz přesouvat společně s cílem, nebo samostatně.

Pokud se bude přesouvat spíše samostatně, je vhodnější *absolutní symbolický odkaz*, protože ten je možno volně přesouvat kamkoliv a stále bude odkazovat na stejný cíl. Tím pádem s ním i v grafických správcích souborů můžete zacházet víceméně jako se souborem samotným. Pokud by přece jen došlo k přesunutí či přejmenování cíle, je nutno všechny absolutní odkazy na cíl vyhledat a opravit.

Pokud se bude odkaz přesouvat spolu s cílem, což je typické pro „blízké“ odkazy a odkazy v rámci výměnných médií, je vhodnější *relativní symbolický odkaz*, protože ten v takových případech zůstane platný.

Pokud se bude přesouvat cíl, vytvořte zvláštní symbolický odkaz na adresář cíle a přes něj směrujte na cíl (bez následování) absolutní symbolické odkazy. Po přesunutí cíle pak bude stačit opravit pouze tento jeden odkaz a ostatní odkazy zůstanou platné beze změny.

*Pevné odkazy* se vyplácí spíš pro dočasné nebo technicky přesně vymezené účely, protože je u nich vždy riziko rozpojení a není snadné si toho všimnout. Většinou se rozpojí při kopírování, při ukládání do archivu nebo když nějaký program soubor smaže a ihned znovu vytvoří. Také se může stát, že původní soubor přejmenujete a místo něj vytvoříte pod původním názvem nový; v takovém případě zůstane pevný odkaz navázaný na původní soubor. K rozpojení také dojde, pokud soubor přesunete příkazem „mv“ přes hranici souborového systému a nazpět.

Asi nejužitečnější způsob využití pevných odkazů je, když příkazem „cp -Rl“ vytvoříte kopii adresářové struktury, v ní pak budete soubory volně přesouvat, mazat apod. a později s ní nahradíte původní adresářovou strukturu. Podobný postup můžete s určitými omezeními použít k napodobnení klonů pododdílů btrfs.

Pevné odkazy se také vyplatí pro různé dočasné účely, kdy mohou být jejich technické vlastnosti výhodné. Vždy je ale třeba mít na paměti riziko rozpojení.

## Další zdroje informací

* [Wikipedie: Symbolický odkaz](https://cs.wikipedia.org/wiki/Symbolick%C3%BD\_odkaz)
* [Wikipedie: Pevný odkaz](https://cs.wikipedia.org/wiki/Pevn%C3%BD\_odkaz)
* [YouTube: MicroNuggets: Hard Links versus Soft Links Explained](https://www.youtube.com/watch?v=lW\_V8oFxQgA) (anglicky)
<!--
* [YouTube: Chris Titus Tech: Symbolic Links in Linux](https://www.youtube.com/watch?v=mA08E59-zo8) (anglicky)
-->
* [LBRY: Chris Titus Tech: Symbolic Links in Linux](https://lbry.tv/@christitustech:5/symbolic-links-in-linux-use-symlinks-for:f) (anglicky)
* man readlink (anglicky)
* man realpath (anglicky)
* man ln (anglicky)
* [YouTube: BeginLinux Guru: Hard Links and Symbolic Links](https://www.youtube.com/watch?v=rQpT0bRpV3Y) (anglicky)

## Zákulisí kapitoly
<!--
- Doplňte, pokud víte. Udržujte aktuální.
-->

V této verzi kapitoly chybí:

!KompaktníSeznam:
* nic

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* nic

!ÚzkýRežim: vyp
