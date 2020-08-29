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

!Štítky: {tematický okruh}{kontrolní součet}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

Tato kapitola uvádí příkazy ke zpracování a editaci souborů bez jakéhokoliv ohledu na formát dat. Tyto soubory se zpracovávají jako celek, po bajtech, nebo po blocích pevné velikosti. Předmětem této kapitoly není archivace a šifrování dat, protože ty mají (nebo mají mít) svoje vlastní kapitoly.

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

* **Velikost-P** je počet bajtů, který může obsahovat (a často obsahuje) multiplikativní příponu K, M, G, T, P pro mocniny 1024 (kibibajty, mebibajty atd.) nebo kB, MB, GB, TB, PB (kilobajty, megabajty atd.) pro mocniny 1000. Takže máte-li do příkazu zadat {*velikost-P*}, čtyři mebibajty můžete zadat jako „4194304“ nebo jako „4M“ (což je podstatně snazší a přehlednější).

!ÚzkýRežim: vyp

## Zaklínadla: Soubor jako celek

### Kontrolní součty a heše

*# vypočítat hexidecimální haše souborů, každou hash na nový řádek (MD5/SHA1/SHA256/SHA512)*<br>
**md5sum** [**\-\-**] {*soubor*}... **\| sed -E 's/^\\\\?(\\S+)\\s.\*/\\1/'** ⊨ 8147f2a49ee708d9f7c20164cf48cfcf<br>
**sha1sum** [**\-\-**] {*soubor*}... **\| sed -E 's/^\\\\?(\\S+)\\s.\*/\\1/'** ⊨ c61d1871cf7d71f29e2cfeda9dd73abe18a8fb42<br>
**sha256sum** [**\-\-**] {*soubor*}... **\| sed -E 's/^\\\\?(\\S+)\\s.\*/\\1/'** ⊨ ea6c53b8ffae9d15408a14f1806e6813c4c92b32ee1e8fd05c39d76210755bb3<br>
**sha512sum** [**\-\-**] {*soubor*}... **\| sed -E 's/^\\\\?(\\S+)\\s.\*/\\1/'** ⊨ f7389d5b8264db3f0950a1e512dd00f335b0ec77db9b6d7e7b36905b31864ec3182fe0e70ae7458951396dfdadbe5f3e1a326af00f8212092b7f7530fb6d9b87

*# vypočítat/ověřit kontrolní součty (SHA256)*<br>
*// Analogicky můžete také použít příkazy „sha1sum“, „sha224sum“, „sha384sum“ a „sha512sum“. Existuje také obecný „shasum“.*<br>
**sha256sum** {*soubor*}... **&gt;** {*cílový-soubor.sha256*}<br>
**sha256sum** [**\-\-ignore-missing**] <nic>[**\-\-status**] **-c** {*soubor.sha256*}

*# vypočítat/ověřit kontrolní součty (MD5)*<br>
*// Heše souborů a jejich názvy (včetně cesty) se uloží do uvedeného souboru.*<br>
**md5sum** {*cesta*}... **&gt;** {*cílový-soubor.md5*}<br>
**md5sum** [**\-\-ignore-missing**] <nic>[**\-\-status**] **-c** {*soubor.md5*}

*# vypočítat heš CRC32 (hexadecimální/desítkovou)*<br>
*// Poznámka: Příkaz „crc32“ lze použít i s více soubory, ale v takovém případě vypisuje ke kontrolním součtům i názvy souborů bez odzvláštnění, což znamená, že nelze bezpečně zpracovat soubory jejichž cesta obsahuje znak konce řádku.*<br>
**crc32** {*soubor*}<br>
**printf %d\\n $(crc32 "**{*soubor*}**")**

*# vypočítat z jednoho souboru heše záznamů ukončených nulovým bajtem*<br>
?

### Určit formát dat a velikost

*# **popsat** typ dat souboru (zejména pro člověka)*<br>
**file** {*soubor*}...

*# vypsat **MIME typ** souboru (vhodné i pro skript)*<br>
**file** [**-b**] <nic>[**-L**] **\-\-mime-type** {*soubor*}...

*# určit **velikost** souboru v bajtech (alternativy)*<br>
**wc -c** [{*soubor*}]...<br>
**stat -c %s** {*soubor*}<br>
{*zdroj*} **\| wc -c**

### Vygenerovat data

*# prázdná data*<br>
**&gt;** {*soubor*} [**&gt;** {*další-soubor*}]...<br>
**: \|** {*zpracování*}

*# data tvořená **nulovými** bajty*<br>
**head -c** {*velikost-P*} **/dev/zero \|** {*zpracování*}

*# data tvořená **pseudonáhodnými** bajty (maximálně 2147483647 bajtů/bez omezení)*<br>
**openssl rand** {*počet-bajtů*} **\|** {*zpracování*}<br>
**while openssl rand 1073741824; do :; done \| head -c** {*velikost-P*} **\|** {*zpracování*}
<!--
openssl je i v minimální instalaci Ubuntu; /dev/urandom je již zbytečné.
<br>
**head -c** {*velikost-P*} **/dev/urandom \|** {*zpracování*}
-->

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
[**test \\! -e** {*soubor*} **\|\| rm** [**\-\-**] {*soubor*} **&amp;&amp;**] **truncate -s ** {*velikost-P*} [**\-\-**] {*soubor*}

### Spojování a dělení

*# spojit soubory*<br>
*// Tip: mezi soubory můžete vložit data ze standardního vstupu zadáním parametru minus („-“) místo jednoho souboru.*<br>
**cat** {*soubor*}... **&gt;**{*cíl*}

*# rozdělit soubor na díly po určitém blocích určité velikosti*<br>
*// Pro „-typ-počítadla“ viz popis příkazu „split“ v sekci Parametry příkazů. *<br>
**split** **-b** {*velikost-P-bloku*} [{*-typ-počítadla*}] <nic>[**-a**{*počet-znaků-počítadla*}] <nic>[**\-\-additional-suffix="**{*přípona-za-počítadlo*}**"**]  {*cesta/k/souboru*} {*předpona/cesty/výsledků*}

*# rozdělit soubor na N přibližně stejně velkých dílů*<br>
**split** **-n** {*počet-dílů*} [{*-typ-počítadla*}] <nic>[**-a**{*počet-znaků-počítadla*}] <nic>[**\-\-additional-suffix="**{*přípona-za-počítadlo*}**"**] <nic>[**-e**] {*cesta/k/souboru*} {*předpona/cesty/výsledků*}

### Srovnání souborů podle obsahu

*# jsou dva soubory po bajtech **shodné**?*<br>
**cmp** [**-s**] {*soubor1*} {*soubor2*}

*# jsou po bajtech shodné zadané úseky?*<br>
**cmp** [**-s**] **-n** {*bajtů-k-porovnání-P*} {*soubor1*} {*soubor2*} {*začátek1-P*} {*začátek2-P*}

*# který ze dvou souborů je **větší**?*<br>
*// Pokud příkaz uspěje, „soubor1“ je větší; jinak je nutno soubory otestovat ještě v opačném pořadí; pokud obě testování selžou, jsou soubory stejně velké.*<br>
**test $(stat -c %s "**{*soubor1*}**") -gt $(stat -c %s "**{*soubor2*}**")**

### Kódování (base64, uuencode, xor)

*# zakódovat do/dekódovat z base64*<br>
**base64 -w 0** [{*soubor*}]<br>
**base64 -d** [{*soubor*}] **\|** {*zpracování*}

*# zakódovat do/dekódovat z uuencode*<br>
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

### Jen čtení

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
**tail -c +**{*N*} {*soubor*} **\| tail -c +1**<br>
**tail -c +**{*N*}**K** {*soubor*} **\| tail -c +1**<br>
**tail -c +**{*N*}**M** {*soubor*} **\| tail -c +1**<br>
**tail -c +**{*N*}**G** {*soubor*} **\| tail -c +1**

*# **vynechat** prvních N bajtů/kilobajtů/megabajtů/gigabajtů*<br>
**tail -c +**{*N*} {*soubor*} **\| tail -c +1**<br>
**tail -c +**{*N*}**kB** {*soubor*} **\| tail -c +1**<br>
**tail -c +**{*N*}**MB** {*soubor*} **\| tail -c +1**<br>
**tail -c +**{*N*}**GB** {*soubor*} **\| tail -c +1**

*# příklad: vyjmout třetí mebibajt*<br>
**tail -c +2M soubor.dat \| tail -c +1 \| head -c 1M**

*# příklad: vynechat třetí mebibajt souboru*<br>
?

*# určit počet bajtů určité hodnoty v daném souboru*<br>
**tr -cd \\\\**{*osmičková-hodnota*} **&lt;**{*soubor*} **\| wc -c**

*# vypsat hexadecimálně (pro člověka)*<br>
**xxd** [**-c** {*bajtů-na-řádek*}] <nic>[**-g** {*bajtů-na-skupinu*}] <nic>[**-s** {*počáteční-adresa*}] <nic>[**-l** {*max-počet-bajtů*}] <nic>[**-u**] {*soubor*}


### I zápis

*# nastavit **bajt** na určité adrese*<br>
**printf %08x:%02x** {*adresa*} {*hodnota-bajtu*} **\| xxd -r -** {*soubor*}

*# přepsat úsek bajtů v souboru*<br>
?

*# obrátit po bajtech celý soubor*<br>
?

<!--
?
gawk -b 'BEGIN {RS="....";OFS=ORS="";} {print substr(RT, 4, 1), substr(RT, 3, 1), substr(RT, 2, 1), substr(RT, 1, 1), $0}'

[ ] Zkusit naprogramovat v Perlu.
-->

*# **nahradit** bajty jedné hodnoty bajty jiné hodnoty*<br>
{*zdroj*} **\| tr $(printf '\\\\%03o'** {původní-bajt}...**) $(printf '\\\\%03o'** {náhradní-bajt}...**) \|** {*zpracování*}

<!--
**tr '\\**{*osm.-původní1*}[**\\**{*osm.původníx*}]...**' '\\**{*osm.-nová1*}[**\\**{*osm.-nováx*}]...**' &lt;** {*zdroj*} **&gt;** {*cíl*}
-->

*# příklad: nahradit v souboru a.bin bajty 0x0a hodnotu 0x0c a zapsat do b.bin*<br>
**tr $(printf '\\\\%03o' 0x0a) $(printf '\\\\%03o' 0x0c) &lt;a.bin &gt;b.bin**


## Zaklínadla: Zpracování po blocích

*# obrátit každou dvojici/čtveřici/osmici bajtů*<br>
**dd** [**if=**{*vstupní-soubor*}] <nic>[**of=**{*výstupní-soubor*}] **conv=swab**<br>
**xxd -e -g 4** [{*soubor*}] **\| xxd -r &gt;** {*cíl*}<br>
**xxd -e -g 8** [{*soubor*}] **\| xxd -r &gt;** {*cíl*}



## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

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
**xxd**



## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíčků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

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
