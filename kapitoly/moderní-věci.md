<!--

Linux Kniha kouzel, kapitola Moderní věci
Copyright (c) 2019-2021 Singularis <singularis@volny.cz>

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

# Moderní věci

!Štítky: {tematický okruh}{ostatní}
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

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

### QR kódy

*# vygenerovat QR kód (zadat text/ze standardního vstupu)*<br>
*// Typ obrázku může být PNG, SVG, ASCII a některé další. Výstupu na standardní výstup lze dosáhnout zadáním „-“ místo výstupního souboru.*<br>
**qrencode** [**-o** {*výstupní-soubor*}] <nic>[**-t** {*typ-obrázku*}] <nic>[**-s** {*rozměr-čtverečku*}] <nic>[**\-\-foreground=**{*barva*}] <nic>[**\-\-background=**{*barva*}] **"**{*text*}**"**<br>
**qrencode** [**-o** {*výstupní-soubor*}] <nic>[**-t** {*typ-obrázku*}] <nic>[**-s** {*rozměr-čtverečku*}] <nic>[**\-\-foreground=**{*barva*}] <nic>[**\-\-background=**{*barva*}]

*# přečíst QR kód (pro skript/pro člověka)*<br>
**zbarimg -q \-\-raw** {*vstupní-obrázek*}<br>
**zbarimg** {*vstupní-obrázek*}

*# vygenerovat QR kód (příklad)*<br>
**qrencode -o test.png -t PNG -s 4 "https://singularis-mzf.github.io"**

### EAN (čárové kódy)

*# přečíst EAN kód (pro skript/pro člověka)*<br>
*// Výstup obou příkazů je bez pomlček.*<br>
**zbarimg -q \-\-raw** {*vstupní-obrázek*}<br>
**zbarimg** {*vstupní-obrázek*}
<!--
Vyžaduje balíček „zbar-tools“.
-->

*# vygenerovat EAN kód*<br>
*// Zadané číslo musí být dlouhé 12 nebo 7 číslic, případně 13 nebo 8 číslic s platným kontrolním součtem. Šířka a výška mohou být libovolné, ale pro EAN kódy je vhodné, když jsou v poměru 5:4, např. „1024x819“. Výstupní obrázek bude ve skutečnosti ještě o něco větší, protože kromě samotného kódu zahrnuje i text a okraje.*<br>
**barcode -b** {*číslobezpomlček*} **-e EAN -E** [**-g** {*šířka-kódu*}**x**{*výška-kódu*}] **\| ps2pdf -dEPSCrop -** {*název-souboru.pdf*}
<!--
Vyžaduje balíček „barcode“ a povolit čtení formátu EPS.
Také možno „**epspdf** {*název-souboru*}**.eps**“ a umí konverzi na grayscale, ale vyžaduje balíček „texlive-pictures“.
-->

*# vygenerovat EAN kód pro ISBN*<br>
**barcode -b** {*ISBN-s-pomlčkami*} **-e ISBN -E** [**-g** {*šířka-kódu*}**x**{*výška-kódu*}] **\| ps2pdf -dEPSCrop -** {*název-souboru.pdf*}

### EXIF (metadata fotografií)

*# přečíst EXIF data z fotografie JPEG*<br>
**identify -verbose** {*cesta.jpg*} **\| sed -E '1,/^\\s\*Properties:$/d;/^\\s\*Artifacts:$/,$d;s/^\\s+//;s/:&blank;/\\t/'**

*# nastavit či změnit EXIF data*<br>
?

### Lorem Ipsum

Poznámka: generátor „lorem“ má velmi omezenou slovní zásobu (méně než 200 slov),
nemusí se proto hodit pro některé účely.

*# vygenerovat pseudolatinský odstavec o délce N vět*<br>
**lorem -s** {*N*} [**; echo**]

*# vygenerovat M odstavců o délce přibližně N vět*<br>
**for \_ in {1..**{*M*}**\}; do lorem -s** {*N*}**; printf '\\n\\n'; done**

*# vygenerovat N pseudolatinských slov, 1 slovo na řádek*<br>
**lorem -w** {*N*} **\| tr "&blank;" \\\\n**

*# stáhnout pseudoanglický odstavec o délce N vět*<br>
*// Vyžaduje připojení k internetu a závisí na vzdáleném serveru.*<br>
**wget -qO- http://metaphorsum.com/sentences/**{*N*} [**\| fmt**]

<!--
http://www.lipsum.cz/ (text v poměrně kvalitní češtině, ale věty se mohou opakovat)
https://cs.lipsum.com/ (stránka česky, text v pseudolatině)
-->

### UUID

*# vygenerovat UUID (náhodné/zahrnující místo a čas/kryptograficky bezpečné)*<br>
**uuid -v 4**<br>
**uuid**<br>
**uuidgen -r**

### Data URL

*# konvertovat obrázek na „data URL“*<br>
**printf "data:%s;base64," "$(file -b \-\-mime-type "**{*soubor*}**")"; base64 -w 0** {*soubor*}

*# konvertovat data URL na obrázek*<br>
**printf "%s\\n" "**{*data-url*}**" \| cut -d , -f 2- -s \| base64 -d &gt;** {*výstupní-soubor*}

### OCR (rozpoznání textu)


### Předčítání (syntéza hlasu)

<!--
[**-w** {*cíl.wav*}]
**espeak -v czech -f** {*soubor*}
**espeak -v czech \-\-stdin**

russian
french
spanish
german
-->

*# přečíst text česky/slovensky/anglicky/americkou angličtinou/v esperantu*<br>
**espeak -v czech** [{*další parametry*}] <nic>[**\-\-**] **"**{*Text.*}**"**<br>
**espeak -v slovak** [{*další parametry*}] <nic>[**\-\-**] **"**{*Text.*}**"**<br>
**espeak** [{*další parametry*}] <nic>[**\-\-**] **"**{*Text.*}**"**<br>
**espeak -v english-us** [{*další parametry*}] <nic>[**\-\-**] **"**{*Text.*}**"**<br>
**espeak -v esperanto** [{*další parametry*}] <nic>[**\-\-**] **"**{*Text.*}**"**

*# text číst ze souboru/ze standardního vstupu*<br>
**espeak** {*parametry*} **-f** {*soubor*}<br>
**espeak** {*parametry*} **\-\-stdin**

*# vypsat dostupné hlasy (pro člověka)*<br>
**espeak \-\-voices**

<!--
sudo apt-get install espeak
-->


### Metadata MP3

![ve výstavbě](../obrázky/ve-výstavbě.png)

*# odstranit veškerý cover art*<br>
**covertag -r** [**\-\-**] {*soubor.mp3*}...

*# vložit obrázek jako cover art*<br>
*// Obrázek by měl být ve formátu JPEG a mít maximální rozlišení 1200×1200 (obvyklé rozlišení je 300×300). Formát PNG lze použít také, ale nemusí mít tak dobrou podporu u přehravačů.*<br>
**covertag -r \-\-other-image** {*obrázek.jpg*} [**\-\-**] {*soubor.mp3*}...

*# vybalit cover art do adresáře*<br>
*// Cílový adresář nemusí existovat (neexistuje-li, bude vytvořen).*<br>
**coverdump -d** {*nová/cesta*} [**-p** {*prefix-názvu*}] <nic>[**-V quiet**] <nic>[**\-\-**] {*soubor.mp3*}

*# zobrazit cover art v GUI*<br>
?
<!--
coverview, ale vyžaduje PyGTK
-->

<!--
covertag, coverdump — balíček audiotools
-->

<!-- [ ] ID3 tagy -->

### URL encode

*# zakódovat konkrétní text (např. cestu)(silné kódování/slabé kódování)*<br>
**printf %s "**{*text*}**" \| perl -CSLA -n -l12 -0 -Mstrict -MEnglish -MURI::Escape -e 'print(uri\_escape\_utf8($ARG));'**<br>
?
<!--
**printf %s "**{*text*}**" \| perl -CSLA -n -l12 -0 -Mstrict -MEnglish -MURI::Escape -e 'print(uri\_escape\_utf8($ARG, "^][A-Za-z0-9._~:/?#-@!\\$&'\\''()\*+,;=-"));'**
-->

*# zakódovat vstup po řádkách*<br>
{*vstup*} **\| perl -CSLA -n -l12 -012 -Mstrict -MEnglish -MURI::Escape -e 'print(uri\_escape\_utf8($ARG));'**

*# zakódovat vstup po záznamech ukončených nulovým bajtem*<br>
{*vstup*} **\| perl -CSLA -n -l0 -0 -Mstrict -MEnglish -MURI::Escape -e 'print(uri\_escape\_utf8($ARG));'**

*# dekódovat konkrétní text*<br>
?

*# dekódovat po řádcích*<br>
?

*# dekódovat po záznamech ukončených nulovým bajtem*<br>
?

<!--
**urlencode \-\- "**{*text*}**" \| tail -c +6**
Nefunguje:
1. „urlencode "-m"“ nevypíše nic (mělo by konverzi „-m“)
2. ne-ASCII bajty vypisuje jako %FF, což zničí znaky UTF-8

*# dekódovat*<br>
**urlencode -d "**{*text*}**"**
-->

### Ostatní

*# změřit rychlost přijímání a odesílání dat do internetu*<br>
**speedtest**
<!--
Vyžaduje balíček speedtest-cli
-->

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

*# *<br>
**sudo apt-get install barcode qrencode zbar-tools libtext-lorem-perl**

## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

!ÚzkýRežim: zap

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

Co hledat:

* [Video: (QR kódy)](https://www.youtube.com/watch?v=6ov65LrL-Zg)

.

* [Článek na Wikipedii](https://cs.wikipedia.org/wiki/Hlavn%C3%AD_strana)
* Oficiální stránku programu
* Oficiální dokumentaci
* [Manuálovou stránku](http://manpages.ubuntu.com/)
* [Balíček](https://packages.ubuntu.com/)
* Online referenční příručky
* Různé další praktické stránky, recenze, videa, tutorialy, blogy, ...
* Publikované knihy
* [Stránky TL;DR](https://github.com/tldr-pages/tldr/tree/master/pages/common)

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
