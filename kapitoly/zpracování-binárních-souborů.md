<!--

Linux Kniha kouzel, kapitola Zpracování binárních souborů
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

[ ] Šifrování z https://www.sallyx.org/sally/linux/prikazy/binary-files

⊨
-->

# Zpracování binárních souborů

!Štítky: {tematický okruh}{hešovací funkce}{kódování}{data}{bajty}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola uvádí příkazy k analýze, zpracování a úpravě souborů bez jakéhokoliv ohledu
na formát jejich obsahu. Jde o zpracování souboru jako celek, zpracování po jednotlivých bajtech
nebo po blocích pevné velikosti.

Předmětem této kapitoly není šifrování dat, elektronické podepisování, komprese ani ukládání souborů
do archivů či vybalování z nich.

Nástroje od, strings, \*sum, split a některé další jsou vyvíjeny v rámci projektu GNU. Nástroj xxd není vyvíjen v rámci projektu GNU.

## Definice

* **Velikost-P** je počet bajtů, který může obsahovat (a často obsahuje) multiplikativní příponu K, M, G, T, P pro mocniny 1024 (kibibajty, mebibajty atd.) nebo kB, MB, GB, TB, PB (kilobajty, megabajty atd.) pro mocniny 1000. Takže máte-li do příkazu zadat {*velikost-P*}, čtyři mebibajty můžete zadat jako „4194304“ nebo jako „4M“ (což je podstatně snazší a přehlednější).
* **Heš** („hash“, „hash code“, někdy méně přesně „kontrolní součet“) je číslo (obvykle v hexadecimálním tvaru) vypočítané z určitých binárních dat pomocí hešovací funkce.
<!--
Používá se pro srovávání a ověřování, protože pravděpodobnost, že hešovací funkce pro dva různé soubory vrátí stejnou heš, je extrémně nízká, zatímco pro stejné soubory vrátí vždy stejnou heš.
-->

!ÚzkýRežim: vyp

## Zaklínadla: Soubor jako celek

### Vypsat obsah souboru pro člověka

*# vypsat **hexadecimálně***<br>
**xxd** [**-c** {*bajtů-na-řádek*}] <nic>[**-g** {*bajtů-na-skupinu*}] <nic>[**-s** {*počáteční-adresa*}] <nic>[**-l** {*max-počet-bajtů*}] <nic>[**-u**] {*soubor*} [**\| less**]

*# vypsat **binárně***<br>
**xxd -b** [**-c** {*bajtů-na-řádku*}] <nic>[**-s** {*počáteční-adresa*}] <nic>[**-l** {*max-počet-bajtů*}] {*soubor*} [**\| less**]

*# najít v binárním souboru čitelné textové řetězce a vypsat je*<br>
**strings** [**-f**] <nic>[**-n** {*minimální-délka-řetězce*}] <nic>[**\-\-**] {*soubor*}...

*# vypsat **osmičkově***<br>
**od -A x -t o1z** [**-w**{*bajtů-na-řádku*}] <nic>[**-j** {*počáteční-adresa*}] <nic>[**-N** {*max-počet-bajtů*}] {*\-\-*} [{*soubor*}] <nic>[**\| less**]

*# vypsat hodnoty bajtů **desítkově***<br>
**od -A x -t u1z** [**-w**{*bajtů-na-řádku*}] <nic>[**-j** {*počáteční-adresa*}] <nic>[**-N** {*max-počet-bajtů*}] {*\-\-*} [{*soubor*}] <nic>[**\| less**]

### Vypočítat a ověřit heš

*# vypočítat hexidecimální **haše** souborů, každou hash na nový řádek (MD5/SHA1/SHA256/SHA512)*<br>
**md5sum** [**\-\-**] {*soubor*}... **\| sed -E 's/^\\\\?(\\S+)\\s.\*/\\1/'** ⊨ 8147f2a49ee708d9f7c20164cf48cfcf<br>
**sha1sum** [**\-\-**] {*soubor*}... **\| sed -E 's/^\\\\?(\\S+)\\s.\*/\\1/'** ⊨ c61d1871cf7d71f29e2cfeda9dd73abe18a8fb42<br>
**sha256sum** [**\-\-**] {*soubor*}... **\| sed -E 's/^\\\\?(\\S+)\\s.\*/\\1/'**<br>
<!--
⊨ ea6c53b8ffae9d15408a14f1806e6813c4c92b32ee1e8fd05c39d76210755bb3<br>
-->
**sha512sum** [**\-\-**] {*soubor*}... **\| sed -E 's/^\\\\?(\\S+)\\s.\*/\\1/'**

*# vypočítat/ověřit heše (**SHA256**)*<br>
*// Analogicky můžete také použít příkazy „sha1sum“, „sha224sum“, „sha384sum“ a „sha512sum“. Existuje také obecný „shasum“.*<br>
**sha256sum** {*soubor*}... **&gt;** {*cílový-soubor.sha256*}<br>
**sha256sum** [**\-\-ignore-missing**] <nic>[**\-\-status**] **-c** {*soubor.sha256*}

*# vypočítat/ověřit heše (**MD5**)*<br>
*// Heše souborů a jejich názvy (včetně cesty) se uloží do uvedeného souboru.*<br>
**md5sum** {*cesta*}... **&gt;** {*cílový-soubor.md5*}<br>
**md5sum** [**\-\-ignore-missing**] <nic>[**\-\-status**] **-c** {*soubor.md5*}

*# vypočítat kontrolní součet **CRC32** (v hexadecimální soustavě/v desítkové)*<br>
*// Poznámka: Příkaz „crc32“ lze použít i s více soubory, ale v takovém případě vypisuje ke kontrolním součtům i názvy souborů bez odzvláštnění, což znamená, že nelze bezpečně zpracovat soubory jejichž cesta obsahuje znak konce řádky.*<br>
**crc32** {*soubor*}<br>
**printf %d\\\\n $((0x$(crc32 "**{*soubor*}**")))**

*# vypočítat z jednoho souboru heše (MD5) záznamů ukončených nulovým bajtem*<br>
?

### Určit formát dat a velikost souboru

*# **popsat** typ dat souboru (zejména pro člověka)*<br>
**file** {*soubor*}...

*# vypsat **MIME typ** souboru (vhodné i pro skript)*<br>
**file** [**-b**] <nic>[**-L**] **\-\-mime-type** {*soubor*}...

*# určit **velikost** souboru v bajtech (alternativy)*<br>
**wc -c** [{*soubor*}]...<br>
**stat -c %s** {*soubor*}<br>
{*zdroj*} **\| wc -c**

### Vygenerovat data

*# data tvořená **nulovými** bajty*<br>
**head -c** {*velikost-P*} **/dev/zero \|** {*zpracování*}

*# data tvořená **pseudonáhodnými** bajty (maximálně 2 147 483 647 bajtů/bez omezení)*<br>
**openssl rand** {*počet-bajtů*} **\|** {*zpracování*}<br>
**while openssl rand 1073741824; do :; done \| head -c** {*velikost-P*} **\|** {*zpracování*}
<!--
openssl je i v minimální instalaci Ubuntu; /dev/urandom je již zbytečné.
<br>
**head -c** {*velikost-P*} **/dev/urandom \|** {*zpracování*}
-->

*# prázdná data*<br>
**&gt;** {*soubor*} [**&gt;** {*další-soubor*}]...<br>
**: \|** {*zpracování*}

*# data tvořená bajty konkrétní hodnoty*<br>
*// Hodnotu bajtu můžete zadat dekadicky (např. „127“), hexadecimálně (např. „0x7f“) nebo osmičkově (např.  „0177“).*<br>
**head -c** {*velikost-P*} **/dev/zero \| tr \\\\0 $(printf '\\\\%03o'** {*hodnota-bajtu*} **) \|** {*zpracování*}

*# bajty 0 až 255*<br>
**printf %02x {0..255} \| xxd -r -p \|** {*zpracování*}

*# příklad: vytvořit soubor o velikosti 2 MiB, tvořený bajty s hodnotu 37 (0x25)*<br>
**head -c 2M /dev/zero \| tr \\\\0 $(printf '\\\\%03o' 0x25) \|** {*zpracování*}

### Vytvořit/prodloužit/zkrátit soubor na disku

*# **zkrátit** či **prodloužit** soubor na uvedenou velikost (obecně/příklady...)*<br>
*// Prodlužuje se vždy nulovými bajty, zkracuje se zprava (tzn. od konce). Pokud soubor neexistuje, vytvoří se.*<br>
**truncate -s** {*nová-velikost-P*} {*soubor*}...<br>
**truncate -s 0 soubory/k-vyprazdneni.dat**<br>
**truncate -s 4M soubory/na-4-mebibajty.dat soubory/dalsi-na-4-mebibajty.dat**

*# vytvořit prázdný soubor (vyprázdnit, pokud existuje)(alternativy)*<br>
**truncate -s 0** [**\-\-**] {*soubor*} [{*další-soubor*}]...<br>
**&gt;** {*soubor*} [**&gt;** {*další-soubor*}]...

*# vytvořit soubor tvořený nulovými bajty (alternativy)*<br>
**truncate -s 0** [**\-\-**] {*soubor*} **&amp;&amp; truncate -s** {*velikost-P*} [**\-\-**] {*soubor*}<br>
**head -c** {*velikost-P*} **/dev/zero &gt;**{*soubor*}

### Spojování a dělení souborů

*# spojit soubory*<br>
*// Tip: mezi soubory můžete vložit data ze standardního vstupu zadáním parametru minus („-“) místo jednoho souboru.*<br>
**cat** {*soubor*}... **&gt;**{*cíl*}

*# rozdělit soubor na díly po blocích určité velikosti (obecně/příklad)*<br>
*// Pro „-typ-počítadla“ viz popis příkazu „split“ v sekci Parametry příkazů. Pro kontrolu vřele doporučuji použít parametr „\-\-verbose“.*<br>
**split** [**\-\-verbose**] **-b** {*velikost-bloku-P*} [{*-typ-počítadla*}] <nic>[**-a**{*počet-znaků-počítadla*}] <nic>[**\-\-additional-suffix="**{*přípona-za-počítadlo*}**"**]  {*cesta/k/souboru*} {*předpona/cesty/výsledků*}<br>
**split \-\-verbose -b 4M -d -a 5 \-\-additional-suffix=".část" "původní soubor.jpg" ""**

*# rozdělit soubor na N přibližně stejně velkých dílů (obecně/příklad)*<br>
**split** [**\-\-verbose**] **-n** {*počet-dílů*} [{*-typ-počítadla*}] <nic>[**-a**{*počet-znaků-počítadla*}] <nic>[**\-\-additional-suffix="**{*přípona-za-počítadlo*}**"**] <nic>[**-e**] {*cesta/k/souboru*} {*předpona/cesty/výsledků*}<br>
**split \-\-verbose -n 7 -d -a 3 \-\-additional-suffix=".část" "původní soubor.jpg" "část-"**

### Srovnání souborů podle obsahu

*# jsou dva soubory po bajtech **shodné**?*<br>
**cmp** [**-s**] {*soubor1*} {*soubor2*}

*# jsou po bajtech shodné zadané úseky?*<br>
**cmp** [**-s**] **-n** {*bajtů-k-porovnání-P*} {*soubor1*} {*soubor2*} {*začátek1-P*} {*začátek2-P*}

*# který ze dvou souborů je **větší**?*<br>
*// Pokud příkaz uspěje, „soubor1“ je větší; jinak je nutno soubory otestovat ještě v opačném pořadí; pokud obě testování selžou, jsou soubory stejně velké.*<br>
**test $(stat -c %s "**{*soubor1*}**") -gt $(stat -c %s "**{*soubor2*}**")**

### Hexadecimální editory

*# grafické rozhraní (GUI)*<br>
*// Když otevřete nové okno příkazem „View“/„Add View“, nové okno nebude mít sloupec s adresami, bez něhož je obtížně použitelné. Vyřešit se to dá tak, že zvolíte „Edit“/„Preferences“ a na kartě „Editing“ odškrtnete a zaškrtnete pole „Show offset columns“; pak se sloupec s adresami zobrazí ve všech oknech editoru.*<br>
**ghex** {*soubor*}

*# textové rozhraní (TUI)*<br>
**hexcurse** [**-r** {*bajtů-na-řádku*}] {*soubor*}

### Transformace souboru

*# obrátit po bajtech celý soubor*<br>
*// Při obracení velkých souborů se ujistěte, že se do paměti RAM a odkládacího souboru vejde dvojnásobek celého souboru! To znamená, že např. pro obrácení souboru o velikosti 4 GiB potřebujete 8 GiB prostoru.*<br>
**perl -MEnglish -0777 -n -e 'print(scalar(reverse($ARG)))' &lt;**{*vstupní-soubor*} **&gt;**{*výstupní-soubor*}

*# obrátit každou dvojici/čtveřici/osmici bajtů*<br>
**dd** [**if=**{*vstupní-soubor*}] <nic>[**of=**{*výstupní-soubor*}] **conv=swab**<br>
**xxd -e -g 4** [{*soubor*}] **\| xxd -r &gt;** {*cíl*}<br>
**xxd -e -g 8** [{*soubor*}] **\| xxd -r &gt;** {*cíl*}

### Kódování (base64, uuencode, xor)

*# zakódovat do/dekódovat z **base64***<br>
**base64 -w 0** [{*soubor*}]<br>
**base64 -d** [{*soubor*}] **\|** {*zpracování*}

*# zakódovat do/dekódovat z **uuencode***<br>
**uuencode /dev/stdout &lt;** {*soubor*} **\| sed -n 'x;3,$p'**<br>
**sed $'1i\\\\\\nbegin 644 /dev/stdout\\n$a\\\\\\nend' temp.dat \| uudecode &gt;** {*cíl*}

*# symetrické kódování operátorem „xor“*<br>
?

### Záplatování

<!--
Možnosti:
- bsdiff (jen pro malé soubory)
- rdiff
- xdelta (selhala na zkušebním vstupu)
-->

*# vytvořit záplatu*<br>
**rdiff \-\- signature** {*původní-soubor*} **- \| rdiff** [**-s**] **\-\- delta -** {*nový-soubor*} **- \| gzip -9 &gt;**{*cíl-záplata.gz*}

*# aplikovat záplatu*<br>
**zcat** {*záplata.gz*} **\| rdiff** [**-s**] **\-\- patch** {*původní-soubor*} **- - &gt;**{*cíl-soubor*}


## Zaklínadla: Zpracování po bajtech

### Vyjmout úsek bajtů

*# **vzít** prvních N bajtů/kibibajtů/mebibajtů/gibibajtů*<br>
**head -c** {*N*} {*soubor*}<br>
**head -c** {*N*}**K** {*soubor*}<br>
**head -c** {*N*}**M** {*soubor*}<br>
**head -c** {*N*}**G** {*soubor*}

*# vzít prvních N bajtů/kilobajtů/megabajtů/gigabajtů*<br>
**head -c** {*N*} {*soubor*}<br>
**head -c** {*N*}**kB** {*soubor*}<br>
**head -c** {*N*}**MB** {*soubor*}<br>
**head -c** {*N*}**GB** {*soubor*}

<!--
Poznámka: tail -c +1K přeskočí jen 1023 bajtů!
-->

*# **vynechat** prvních N bajtů/kibibajtů/mebibajtů/gibibajtů*<br>
**tail -c +**{*N*} {*soubor*} **\| tail -c +2**<br>
**tail -c +**{*N*}**K** {*soubor*} **\| tail -c +2**<br>
**tail -c +**{*N*}**M** {*soubor*} **\| tail -c +2**<br>
**tail -c +**{*N*}**G** {*soubor*} **\| tail -c +2**

*# **vynechat** prvních N bajtů/kilobajtů/megabajtů/gigabajtů*<br>
**tail -c +**{*N*} {*soubor*} **\| tail -c +2**<br>
**tail -c +**{*N*}**kB** {*soubor*} **\| tail -c +2**<br>
**tail -c +**{*N*}**MB** {*soubor*} **\| tail -c +2**<br>
**tail -c +**{*N*}**GB** {*soubor*} **\| tail -c +2**

*# příklad: vzít třetí mebibajt souboru*<br>
**tail -c +2M soubor.dat \| tail -c +2 \| head -c 1M**

*# příklad: vynechat třetí mebibajt souboru*<br>
**(head -c 2M soubor.dat &amp;&amp; tail -c +3M soubor.dat \| tail -c +2) \|** {*zpracování*}

### Analyzovat po bajtech

*# určit počet bajtů určité hodnoty v daném souboru (obecně/určit počet bajtů 0xa9)*<br>
**tr -cd \\\\$(printf %o** {*hodnota-bajtu*}**) &lt;**{*soubor*} **\| wc -c**
**tr -cd \\\\$(printf %o 0xa9) &lt;**{*soubor*} **\| wc -c**

### Konverze na/z číselné reprezentace

Poznámka: Následující zaklínadla generují/přijímají jednu číselnou hodnotu na každou řádku.

*# bajty **hexadecimálně** „00“ až „FF“ (na čísla/z čísel)*<br>
{*zdroj*} **\| xxd -p -u -c 1 \|** {*zpracování*}<br>
{*zdroj*} **\| xxd -r -p \|** {*zpracování*}

*# bajty **desítkově** „0“ až „255“ (na čísla/z čísel)*<br>
{*zdroj*} **\| od -A n -t u1 -v -w1 \| tr -d "&blank;" \|** {*zpracování*}<br>
{*zdroj*} **\| sed $'1i\\\\\\nobase=16' \| bc \| sed -E 's/^.$/0&amp;/' \| xxd -r -p \|** {*zpracování*}

*# bajty **binárně** „00000000“ až „11111111“ (na čísla/z čísel)*<br>
{*zdroj*} **\| xxd -b -c 1 \| cut -d "&blank;" -f 2 \|** {*zpracování*}<br>
{*zdroj*} **\| sed $'1i\\\\\\nobase=16\\\\\\nibase=2' | bc | sed -E 's/^.$/0&amp;/' | xxd -r -p \|** {*zpracování*}

*# bajty **osmičkově** „000“ až „377“ (na čísla/z čísel)*<br>
{*zdroj*} **\| od -A n -t o1 -v -w1 \| tr -d "&blank;" \|** {*zpracování*}<br>
{*zdroj*} **\| sed $'1i\\\\\\nobase=16\\\\\\nibase=8' | bc | sed -E 's/^.$/0&amp;/' | xxd -r -p \|** {*zpracování*}

<!--
{*zdroj*} **\| (printf 'ibase=16\\n'; xxd -p -u -c 1) \| bc \|** {*zpracování*}<br>
{*zdroj*} **\| xxd -r -p \|** {*zpracování*}<br>
-->

### Přepsat/nahradit/vynechat/vložit bajty

*# nastavit **bajt** na určité adrese*<br>
*// Adresy nemusejí být v pořadí, dokonce se mohou opakovat; xxd zapíše jeden bajt po druhém.*<br>
**printf '%08x:%02x\\n'** {*adresa*} {*hodnota-bajtu*} [{*další-adresa*} {*hodnota-bajtu*}]... **\| xxd -r -c 1 -** {*soubor*}

*# **přepsat** úsek bajtů v souboru*<br>
*// Hodnota „kam-zapsat“ je obyčejné dekadické číslo v bajtech od nuly, tzn. např. 3 znamená, že první přepsaný má být čtvrtý bajt výstupního souboru. Pokud leží výstupní adresa za koncem souboru, soubor se doplní nulami; pokud má zápis pokračovat za konec existujících dat, soubor bude podle potřeby prodloužen.*<br>
{*zdroj*} **\| xxd -p \| xxd -p -r** [**\-\-seek** {*kam-zapsat*}] **-** {*soubor-k-zapsání*}

*# vypustit bajty uvedených hodnot/všechny kromě bajtů uvedených hodnot*<br>
{*zdroj*} **\| tr $(printf -d '\\\\%03o'** {*bajt*}...**) \|** {*zpracování*}<br>
{*zdroj*} **\| tr $(printf -cd '\\\\%03o'** {*bajt*}...**) \|** {*zpracování*}

*# tabulkový překlad bajtů*<br>
*// Počet „původních bajtů“ musí přesně odpovídat počtu náhradních bajtů, jinak výsledek nemusí odpovídat očekávání.*<br>
{*zdroj*} **\| tr $(printf '\\\\%03o'** {*původní-bajt*}...**) $(printf '\\\\%03o'** {*náhradní-bajt*}...**) \|** {*zpracování*}

<!--
**tr '\\**{*osm.-původní1*}[**\\**{*osm.původníx*}]...**' '\\**{*osm.-nová1*}[**\\**{*osm.-nováx*}]...**' &lt;** {*zdroj*} **&gt;** {*cíl*}
-->

*# příklad: nahradit v souboru a.bin bajty 0x0a hodnotou 0x0c a výsledek zapsat do b.bin*<br>
**tr $(printf '\\\\%03o' 0x0a) $(printf '\\\\%03o' 0x0c) &lt;a.bin &gt;b.bin**

*# vynechat úsek mezi dvěma adresami*<br>
?

*# nahradit úsek mezi dvěma adresami vstupem*<br>
?

*# **vložit** nový úsek dat na zadanou adresu (obecně/příklad)*<br>
{*zdroj-nového-úseku*} **\| cat &lt;(head -c** {*adresa-desítkově*} [**\-\-**] {*soubor*}**) - &lt;(tail -c +$((**{*adresa-desítkově*}**+1))** [**\-\-**] {*soubor*}**) \|** {*zpracování*}<br>
**cat novy-usek.dat \| cat &lt;(head -c 21734 puvodni.dat) - &lt;(tail -c +$((21734+1)) puvodni.dat) &gt;novy-soubor.dat**

## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->

**Důležitý tip:** v každém příkazu, kde je „\| {*zpracování*}“, můžete místo něj uvést přesměrování do souboru.

### split

*# *<br>
**split** {*-typ-dělení*} {*-typ-počítadla*} [{*-další -parametry*}] {*vstupní-soubor*} {*předpona/výstupu*}

Typ dělení může být:

* -b {*velikost-P*} :: dělení na bloky pevné velikosti
* -C {*velikost-P*} :: dělení po záznamech; do každého dílu zapíše jen tolik záznamů, aby nepřekročil uvedenou velikost // [ ] vyzkoušet!
* -l {*počet-záznamů*} :: dělení po záznamech; do každého dílu zapíše pevný počet záznamů (poslední díl jich může obsahovat méně) // [ ] vyzkoušet!
* -n {*počet-výstupních-souborů*} :: pokusí se rozdělit vstup na daný počet přibližně stejně velkých souborů.

Při dělení po záznamech je možno uvést parametr -t, který specifikuje ukončovač záznamů; např.:

* -t \\\\0 :: nulový bajt
* -t $'\\t' :: tabulátor
* -t $'\\n' :: konec řádky (výchozí hodnota)
* -t $'\\xa0' :: bajt o hodnotě 0xa0

<!--
[ ] Vyzkoušet, zda jde o oddělovač, nebo ukončovač záznamů!
[ ] Vyzkoušet, zda lze použít \xa0
-->

Typ počítadla může být:

* (neuvedený) :: použijí se malá písmena anglické abecedy (aa, ab, ac, ...)
* -d :: použijí se desítkové číslice (00, 01, 02, ...)
* -x :: použijí se šestnáctkové číslice (00, 01, ..., 09, 0a, 0b, 0c, 0d, 0e, 0f, 10, ...)
* \-\-numeric-suffixes={*hodnota*} :: použijí se desítkové číslice počínaje uvedenou hodnotou (např. 12, 13, ...)

<!--
* \-\-hex-suffixes={*hodnota*} :: použijí se šestnáctkové číslice počínaje uvedenou hodnotou
Nefunguje. Pro "-a 5 --hex-suffixes=a" generuje nesmyslné hodnoty počítadla.
-->

Další parametry mohou být:

* -a{*číslo*} :: počet „číslic“ počítadla (výchozí hodnota: 2)
* \-\-additional-suffix={*řetězec*} :: řetězec k připojení za počítadlo (Poznámka: nesmí obsahovat „/“.) Výchozí hodnotou je prázdný řetězec.
* \-\-verbose :: oznámí vytvoření každého výstupního souboru

Tip: Místo vstupního souboru může být „-“; příkaz pak čte ze standardního vstupu.

### xxd

*# *<br>
**xxd** [{*parametry*}] {*vstupní-soubor*}<br>
{*zdroj*} **\| xxd -r** [{*parametry*}] **-** {*soubor-k-přepsání*}
{*zdroj*} **\| xxd -r** [{*parametry*}] **- \|** {*zpracování*}

!parametry:

* -p :: použije „holý“ hexadecimální formát bez adres (výchozí chování: čitelný formát s adresami)
* -u :: v hexadecimálních číslech použije velká písmena (výchozí chování: malá písmena)
* -c {*bajtů*} :: počet bajtů na řádek výstupu
* -s {*adresa*} :: začne vypisovat od zadané adresy (např. „0x80“)
* -l {*počet-bajtů*} :: vypíše nejvýše zadaný počet bajtů

*# *<br>
{*zdroj*} **\| xxd -r** [{*parametry*}] **\|** {*zpracování*}<br>
{*zdroj*} **\| xxd -r** [{*parametry*}] **-** {*soubor-k-editaci*}

!parametry:

* -c {*bajtů*} :: počet bajtů na řádku vstupu (nemá smysl v kombinaci s parametrem „-p“)
* -p :: očekává „holý“ hexadecimální formát bez adres; bílé znaky jsou ignorovány
* -seek {*posun*} :: před každým zápisem k adrese *přičte* uvedený posun (např „0x80“)

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíčků k instalaci vycházejte z minimální instalace Ubuntu.
-->

*# rdiff, xxd, ghex, hexcurse*<br>
**sudo apt-get install rdiff xxd ghex hexcurse**

*# crc32*<br>
**sudo apt-get install libarchive-zip-perl**

*# uudecode, uuencode*<br>
**sudo apt-get install sharutils**

Ostatní použité příkazy jsou přítomny i v minimální instalaci Ubuntu.

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
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->

* Příkaz „cmp“ je nejrychleji čtoucí příkaz, který znám, lze jej použít např. pro výkonnostní test SSD disku.

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->

* [man 1 split](http://manpages.ubuntu.com/manpages/focal/en/man1/split.1.html)
* [man 1 xxd](http://manpages.ubuntu.com/manpages/focal/en/man1/xxd.1.html)
* [man 1 od](http://manpages.ubuntu.com/manpages/focal/en/man1/od.1.html)
* [balíček xxd](https://packages.ubuntu.com/focal/xxd)
* [TL;DR: split](https://github.com/tldr-pages/tldr/blob/master/pages/common/split.md)
* [TL;DR: xxd](https://github.com/tldr-pages/tldr/blob/master/pages/common/xxd.md)

!ÚzkýRežim: vyp
