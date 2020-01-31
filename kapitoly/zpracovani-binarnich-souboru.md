<!--

Linux Kniha kouzel, kapitola Zpracování binárních souborů
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

⊨
-->

# Zpracování binárních souborů

!Štítky: {tematický okruh}{kontrolní součet}

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

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Kontrolní součty a heše

*# vypočítat hexidecimální haše souborů, každou hash na nový řádek (CRC32/MD5/SHA1/SHA256)*<br>
**crc32** {*soubor*}... **\| cut -c -8**<br>
**md5sum** {*soubor*}... **\| cut -c -32**<br>
**sha1sum** {*soubor*}... **\| cut -c -40**<br>
**sha256sum** {*soubor*}... **\| cut -c -64**

*# vypočítat/ověřit kontrolní součty (MD5)*<br>
*// Heše souborů a jejich názvy (včetně cesty) se uloží do uvedeného souboru.*<br>
**md5sum** {*soubor*}... **&gt;** {*cílový-soubor.md5*}<br>
**md5sum -c** {*soubor.md5*}

*# vypočítat/ověřit kontrolní součty (SHA256)*<br>
*// Analogicky můžete také použít příkazy „sha1sum“, „sha224sum“, „sha384sum“ a „sha512sum“. Existuje také obecný „shasum“.*<br>
**sha256sum** {*soubor*}... **&gt;** {*cílový-soubor.sha256*}<br>
**sha256sum -c** {*soubor.sha256*}

### Vytváření souboru

*# vytvořit prázdný soubor*<br>
**&gt;** {*soubor*} [**&gt;** {*další-soubor*}]...

*# vytvořit soubor tvořený nulovými/jinými bajty*<br>
**head -c** {*velikost-P*} **/dev/zero &gt;** {*soubor*}
**head -c** {*velikost-P*} **/dev/zero \| tr \\\\0 \\\\**{*osmičková-hodnota*} **&gt;** {*soubor*}

*# pseudonáhodná data (libovolné bajty/bajty v určitém rozsahu)*<br>
**head -c** {*velikost-P*} **/dev/urandom &gt;** {*soubor*}<br>
**tr -cd '\\**{*osm.-min*}**-\\**{*osm.-max*}**' &lt; /dev/urandom \| head -c** {*velikost-P*} **&gt;** {*soubor*}

*# soubor s bajty 0 až 255*<br>
**printf %02x {0..255} \| xxd -r -p &gt;~/ram/bytes.dat**



### Kódování

*# zakódovat do/dekódovat z base64*<br>
**base64 -w 0** [{*soubor*}]<br>
**base64 -d** [{*soubor*}] **&gt;** {*cíl*}

*# zakódovat do/dekódovat z uuencode*<br>
**uuencode /dev/stdout &lt;** {*soubor*} **\| sed -n 'x;3,$p'**<br>
**sed $'1i\\\\\\nbegin 644 /dev/stdout\\n$a\\\\\\nend' temp.dat \| uudecode &gt;** {*cíl*}

### Srovnání souborů podle obsahu

*# jsou dva soubory po bajtech **shodné**?*<br>
**cmp** [**-s**] {*soubor*} {*soubor*}

*# jsou po bajtech shodné zadané úseky?*<br>
**cmp** [**-s**] **-n** {*bajtů-k-porovnání-P*} {*soubor1*} {*soubor2*} {*začátek1-P*} {*začátek2-P*}


*# který ze dvou souborů je větší?*<br>
?

### Ostatní

*# zkrátit či prodloužit soubor na uvedenou velikost (obecně/příklady...)*<br>
*// Prodlužuje se nulovými bajty.*<br>
**truncate -s** {*velikost*} {*soubor*}...<br>
?

*# nastavit bajt na určité adrese*<br>
**printf %08x:%02x** {*adresa*} {*hodnota-bajtu*} **\| xxd -r -** {*soubor*}

*# spojit soubory*<br>
**cat** {*soubor*}... **&gt;**{*cíl*}

*# rozdělit soubor na díly po určitém počtu bajtů*<br>
?

*# rozdělit soubor na N přibližně stejně velkých dílů*<br>
?

*# vzít/vynechat prvních N bajtů*<br>
?<br>
?

*# vyjmout úsek bajtů*<br>
?

*# přepsat úsek bajtů v souboru*<br>
?

*# určit MIME typ souboru*<br>
**file** [**-b**] <nic>[**-L**] **\-\-mime-type** {*soubor*}...

*# určit typ souboru (zejména pro člověka*<br>
**file** {*soubor*}...

*# určit velikost souboru v bajtech*<br>
**wc -c** [{*soubor*}]...

*# určit počet bajtů určité hodnoty v daném souboru*<br>
**tr -cd \\\\**{*osmičková-hodnota*} **&lt;**{*soubor*} **\| wc -c**

*# vypsat hexadecimálně (pro člověka)*<br>
**xxd** [**-c** {*bajtů-na-řádek*}] <nic>[**-g** {*bajtů-na-skupinu*}] <nic>[**-s** {*počáteční-adresa*}] <nic>[**-l** {*max-počet-bajtů*}] <nic>[**-u**] {*soubor*}

*# obrátit každou dvojici/čtveřici/osmici bajtů*<br>
**dd** [**if=**{*vstupní-soubor*}] <nic>[**of=**{*výstupní-soubor*}] **conv=swab**<br>
**xxd -e -g 4** [{*soubor*}] **\| xxd -r &gt;** {*cíl*}<br>
**xxd -e -g 8** [{*soubor*}] **\| xxd -r &gt;** {*cíl*}

*# obrátit po bajtech celý soubor*<br>
?

<!--
?
gawk -b 'BEGIN {RS="....";OFS=ORS="";} {print substr(RT, 4, 1), substr(RT, 3, 1), substr(RT, 2, 1), substr(RT, 1, 1), $0}'
-->

*# nahradit bajty jedné hodnoty bajty jiné hodnoty*<br>
**tr '\\**{*osm.-původní1*}[**\\**{*osm.původníx*}]...**' '\\**{*osm.-nová1*}[**\\**{*osm.-nováx*}]...**' &lt;** {*zdroj*} **&gt;** {*cíl*}



<!--

Délka je nezáporný počet bajtů, případně s násobící příponou „K“ (2^10), „M“ (2^20), „G“ (2^30), „T“ (2^40) či „P“ (2^50).

-->

## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

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
