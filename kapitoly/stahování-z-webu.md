<!--

Linux Kniha kouzel, kapitola Stahování z webu
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

[ ] Vyzkoušet většinu zaklínadel
[ ] curl
[ ] wkhtmltopdf

⊨
-->

# Stahování z webu

!Štítky: {tematický okruh}{internet}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

GNU Wget je vyvíjen v rámci projektu GNU.

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Zaklíndla: wget

### Stahování souborů

*# stáhnout soubor do adresáře/na standardní výstup*<br>
*// Cílový adresář nemusí existovat.*<br>
**wget -nd** [**-P** {*cílový/adresář*}] <nic>[**\-\-no-use-server-timestamps**] <nic>[**\-\-restrict-file-names=windows,ascii**] <nic>[{*další parametry*}] <nic>[**\-\-**] {*protokol://adresa*}
**wget -O -** <nic>[{*další parametry*}] <nic>[**\-\-**] {*protokol://adresa*}...

*# stáhnout soubory ze seznamu do adresáře/na standardní výstup*<br>
*// Seznam musí být ve formátu TXT (tzn. jedna URI na řádku). Při stažení více souborů na standardní výstup se vypíšou postupně.*<br>
**wget -i** {*seznam.txt*} **-nd** [**-P** {*cílový/adresář*}] <nic>[**\-\-no-use-server-timestamps**] <nic>[**\-\-restrict-file-names=windows,ascii**] <nic>[{*další parametry*}]
**wget -i** {*seznam.txt*} **-O -** <nic>[{*další parametry*}]

*# stáhnout soubory odkazované z HTML dokumentu*<br>
*// Původní adresa je nutná v případě, že dokument obsahuje relativní odkazy.*<br>
**wget -F -i** {*dokument.htm*} [**\-\-base="**{*protokol://původní/adresa*}**"**]

### Stahování webů pro místní prohlížení

*# stáhnout **jednu** HTML stránku*<br>
**wget -p -k -x -E -H '**{*http://adresa*}**'**
<!--
[ ] Konvertovat odkazy tak, aby samotný HTML soubor byl mimo a měl k sobě adresář se závislostmi?
-->

*# stáhnout **podstrom** webu počínaje uvedenou stránkou*<br>
**wget -r -p -l inf -E -x -np '**{*http://adresa*}**'**

*# stáhnout celý webový **server***<br>
**wget -r -p -l inf -E -x** [**-Q** {*MiB-limit*}**M**] **'**{*http://adresa*}**'**

*# rekurzívně postahovat odkazované stránky do určité maximální hloubky*<br>
**wget -r -p -H -l** {*max-hloubka*} **-E -x** [**-Q** {*MiB-limit*}**M**] **'**{*http://adresa*}**'**

*# stáhnout celý webový server do aktuálního/zvoleného adresáře*<br>
**wget -r -p -l inf -E -nd -P .** [**-Q** {*MiB-limit*}**M**] **'**{*http://adresa*}**'**<br>
**wget -r -p -l inf -E -nd -P** {*adresář*} [**-Q** {*MiB-limit*}**M**] **'**{*http://adresa*}**'**

### Kontrola existence

*# zkontrolovat existenci souborů ze seznamu URI/najít neexistující*<br>
**wget -i** {*seznam.txt*} **\-\-spider -nv** [**2&gt;&amp;1 \| cut -d "&blank;" -f 4-**]
**wget -i** {*seznam.txt*} **\-\-spider -nv 2&gt;&amp;1 \| cut -d "&blank;" -f 4- \| egrep -v '200&blank;OK$'**

*# zkontrolovat existenci souborů odkazovaných z HTML dokumentu*<br>
**wget -F -i** {*soubor.htm*} [**\-\-base="**{*protokol://původní/adresa*}**"**] **\-\-spider**

### Volby ovlivňující chování programu

*# po spuštění se hned přepnout na pozadí*<br>
**-b**

*# úroveň podrobnosti výpisu: žádný výstup/jen chybová hlášení/indikace postupu/podrobný ladicí výpis*<br>
**\-q**<br>
**\-nv**<br>
**\-nv \-\-show-progress**<br>
**\-d**

*# logovat do souboru místo na terminál*<br>
**2&gt;**{*soubor*}

*# nečíst konfigurační soubor*<br>
**\-\-no-config**

*# kromě stažení také vypsat uživateli hlavičky z HTTP/FTP odpovědi*
**\-S**

*# přestat stahovat další soubory, pokud ty stažené již zabraly víc než N mebibajtů*<br>
**\-Q** {*N*}**M**

*# mezi každými dvěma pokusy o stahování počkat N sekund/minut/hodin*<br>
**\-\-wait=**{*N*}<br>
**\-\-wait=**{*N*}**m**<br>
**\-\-wait=**{*N*}**h**

*# mezi každými dvěma pokusy o stahování počkat v průměru N sekund/minut/hodin*<br>
**\-\-wait=**{*N*} **\-\-random-wait**<br>
**\-\-wait=**{*N*}**m \-\-random-wait**<br>
**\-\-wait=**{*N*}**h \-\-random-wait**

### Volby ovlivňující chování ke staženým souborům

*# stáhnout jen zbytek*<br>
*// Pokud stažený soubor existuje a na serveru je větší, wget se pokusí stáhnout jen chybějící zbytek, pokud mu to server umožní. V tomto případě wget nekontroluje, zda stávající obsah odpovídá tomu na serveru, takže pokud se soubor na serveru změnil, dostanete nekonzistentní výsledek.*<br>
**\-c**

*# zachovat předem existující soubory pod názvem s příponou .1, .2 atd.*<br>
*// Pro N=0, což je výchozí nastavení, se předem existující soubor zachová pod původním názvem a nově stahovaný se uloží do souboru s číslovanou příponou. Přepsat existující soubor wget nedovoluje.*<br>
**\-\-backups=**{*N*}

*# případný existující soubor smazat a začít stahování od začátku*<br>
*// GNU wget přepisování souborů neumožňuje. Nejvíc se mu lze přiblížit nastavením „\-\-backups=1“.*<br>
?

*# uložit URI do datové položky „user.xdg.origin.url“ (jen při stahování do adresáře)*<br>
**\-\-xattr**

*# v případě úspěšného stažení stažený soubor odstranit*<br>
*// V případě, že stahování bylo přerušeno, wget částečně stažený soubor ponechá.*<br>
**\-\-delete-after**


### Volby ovlivňující síťové spojení

*# stahovat omezenou rychlostí (v bajtech/kibibajtech/mebibajtech za sekundu)*<br>
*// Poznámka: Omezení rychlosti začne platit teprve jednu až dvě sekundy po zahájení spojení; to znamená, že při stahování velkého množství malých souborů může být neúčinné.*<br>
**\-\-limit-rate=**{*N*}<br>
**\-\-limit-rate=**{*N*}**K**<br>
**\-\-limit-rate=**{*N*}**M**

*# používat ke spojení pouze IPv4/pouze IPv6*<br>
**-4**<br>
**-6**

### Volby HTTP/HTTPS/FTP

*# před stažením se přihlásit*<br>
**\-\-user=**{*uživatelskéjméno*} **\-\-password="**{*heslo*}**"**

*# do HTTP požadavku přidat hlavičky*<br>
**\-\-header="**{*Název-Hlavičky*}**:&blank;**{*obsah hlavičky*}**"** [**\-\-header="**{*Další-Hlavička*}**:&blank;**{*obsah*}**"**]...

*# nastavit hlavičku Referer*<br>
**\-\-referer="**{*adresa*}**"**

*# do staženého souboru z odpovědi uložit i HTTP hlavičky*<br>
**\-\-save-headers**

*# nastavit/neposílat hlavičku User-Agent*<br>
**\-\-user-agent="**{*řetězec*}**"**<br>
**\-\-user-agent=""**

*# při stahování z HTTPS nekontrolovat certifikát*<br>
**\-\-no-check-certificate**
<!--
[ ] vyzkoušet
[ ] --ca-certificate
-->

*# cookies načíst ze souboru/uložit do souboru*<br>
*// Bez použití těchto parametrů si wget pamatuje cookies jen po dobu svého běhu.*<br>
**\-\-load-cookies** {*soubor*}<br>
**\-\-save-cookies** {*soubor*}

### Opakované pokusy

*# kolikrát se pokusit o stažení (jen jednou/N-krát/neomezeně)*<br>
*// Podle manuálové stránky je výchozí nastavení 5 pokusů.*<br>
**\-t 1**<br>
**\-t** {*N+1*}<br>
**\-t 0**
















<!--
[ ] --post-data/--post-file
[ ] -r --https-only


-->

*# získat seznam souborů v FTP adresáři (bez vnoření/rekurzívně)*
?<br>
?

*# při stahování z FTP zachovat souborům mód (přístupová práva)*<br>
?


## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíčků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Příkaz „wget“ má velké množství neužitečných funkcí a jiné zásadní naopak chybějí (např. možnost stáhnout v rámci jednoho spojení soubory do dvou nezávislých adresářů nebo stahovat jen soubory určitých velikostí nebo určitých typů). Proto doporučuji používat jen velmi omezené množství jeho parametrů a stahovat vždy do prázdného adresáře a po stažení soubory přejmenovat a přesunout, jak potřebujete.

<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

<!--
Nedostatky příkazu wget:

[ ] Neumožňuje přepsat existující soubory novým stahováním.
[ ] Poskytuje malou kontrolu nad přesným umístěním a pojmenováním stažených souborů při rekurzívním stahování. Neumožňuje si např. naprogramovat uživatelskou konverzi jmen.
[ ] Neumožňuje vypsat seznam stahovaných URI místo jejich stahování.
-->

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

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

## Pomocné funkce a skripty

*# lkk vycist-odkazy – vypíše odkazy z HTML vstupu ve zpracovatelném formátu*<br>
**#!/bin/bash -e**<br>
**adresa=$1 perl -CSLA -MEnglish -MHTML::LinkExtor -0777 -n -e 'my $le = HTML::LinkExtor-&gt;new(\\&amp;telo, $ENV{"adresa"}); sub alength {return scalar(@ARG);} sub telo {my @odkazy = @ARG; my $prvek = shift(@odkazy); while (alength(@odkazy) &gt;= 2) {printf("%s\\t%s\\t%s\\n", $prvek, $odkazy[0], $odkazy[1]); shift(@odkazy); shift(@odkazy);}} $le-&gt;parse($ARG);'**
<!--
Vyžaduje balíček: libhtml-linkextractor-perl
-->

!ÚzkýRežim: vyp
