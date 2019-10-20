<!--

Linux Kniha kouzel, kapitola Obrázky
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Obrázky

## Úvod
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Definice
* **Barva** je barevná vlastnost pixelu. ImageMagick pravděpodobně podporuje všechny syntaxe CSS, zejména vyjádření názvem (např. „green“), #RRGGBB, #RRGGBBAA, rgb(r,g,b) a rgba(r,g,b,a). Pro bližší referenci viz dokumentaci kaskádových stylů.
* **Seznam** je druh pracovního zásobníku, se kterým pracuje příkaz „convert“. Obrázky v seznamu jsou číslovány nezápornými čísly od začátku do konce (0, 1, 2 atd.) a současně zápornými čísly od konce do začátku (-1, -2, -3 atd.). Nové obrázky se vždy ukládají na konec seznamu a poslední obrázek („vrchol zásobníku“) má v některých operacích zvláštní postavení. Většina operátorů pracuje se všemi obrázky v seznamu současně. Při práci s animovanými GIFy odpovídá seznam jednotlivým polím animace.

## Zaklínadla

### Škálování (scale)
*# vynutit šířku (WIDTH)/výšku (HEIGHT)*<br>
**\-resize** {*šířka*}<br>
**\-resize x**{*výška*}

*# vynutit oba rozměry (FORCE) − jediná varianta, která v případě potřeby změní poměr stran obrázku*<br>
**\-resize** {*šířka*}**x**{*výška*}**\\!**

*# vyplnit (CONTAIN)/a doplnit pozadím na přesný rozměr*<br>
**\-resize** {*šířka*}**x**{*výška*}<br>
**\-resize** {*šířka*}**x**{*výška*} **-background** {*barva*} **-compose Copy -gravity Center -extent** {*šířka*}**x**{*výška*}

*# pokrýt (COVER)/a oříznout na přesný rozměr*<br>
**\-resize** {*šířka*}**x**{*výška*}**\^**<br>
**\-resize** {*šířka*}**x**{*výška*}**\^ -gravity Center -crop** {*šířka*}**x**{*výška*}**+0+0 +repage**

*# jen zmenšit (SHRINK)/a doplnit pozadím na přesný rozměr*<br>
**\-resize** {*šířka*}**x**{*výška*}**\\&gt;**<br>
**\-resize** {*šířka*}**x**{*výška*}\\&gt; **-background** {*barva*} **-compose Copy -gravity Center -extent** {*šířka*}**x**{*výška*}

*# jen zvětšit (ENLARGE)/nebo doplnit pozadím na přesný rozměr (Pozor! Viz poznámku.)*<br>
*// Druhá varianta je poměrně komplikovaná a aplikuje požadovanou operaci pouze na poslední obrázek v seznamu, ne na všechny obrázky v seznamu jako ostatní operace!*<br>
**\-resize** {*šířka*}**x**{*výška*}**\\&lt;**<br>
**\-resize** {*šířka*}**x**{*výška*}**\\&lt; \\( -size** {*šířka*}**x**{*výška*} **-background** {*barva*} **-gravity Center -compose Copy -clone -1 -alpha transparent xc:none -mosaic -clone -1 -composite \\) -delete -2**

*# zvětšit každý rozměr na dvojnásobek/zmenšit na polovinu*<br>
**\-resize 200%**<br>
**\-resize 50%**

*# škálovat animovaný GIF (prefix pro všechny varianty)*<br>
**\-coalesce** {*parametry-podle-zvolené-varianty*}

### Rotace a překlopení
*# převrátit (horizontálně/vertikálně)*<br>
?<br>
?

*# otočit obraz o +90° (o 90° proti směru hodinových ručiček)*<br>
?

*# otočit obraz o 180°*<br>
?

*# otočit obraz o -90° (o 90° po směru hodinových ručiček)*<br>
?

*# otočit obraz o obecný úhel (ve stupních) proti/po směru hodinových ručiček*<br>
?

*# otočit obraz o obecný úhel (ve stupních) proti směru hodinových ručiček a zvětšit rozlišení na obdelník opsaný otočenému snímku; nevyplněné rohy ponechat průhledné*<br>
?


### Konverze formátů

*# konvertovat na PNG (obecně/příklad)*<br>
**convert** {*vstupní-soubor*} [**-define png:compression-level=**{*úroveň-komprese-1-až-9*}] {*výstupní-název*}**.png**<br>
**convert vstup.jpg -define png:compression-level=9 vystup.png**

*# konvertovat na PNG-8 s optimální paletou*<br>
?

*# konvertovat na JPEG (obecně/příklad)*<br>
*// Parametr „-quality“ nastaví výstupní kvalitu, „-strip“ odstraní EXIF data a „-interlace Line“ zapne progresivní formát.*<br>
**convert** {*vstupní-soubor*} [**-quality** {*procenta*}**%**] [**-strip**] [**-interlace Line**] {*výstupní-název*}**.jpg**<br>
**convert vstup.png -quality 80% -strip vystup.jpg**

*# konvertovat na (neanimovaný) GIF*<br>
**convert** {*vstupní-soubor*} {*výstupní-název*}**.gif**

*# složit obrázky do animovaného GIFu*<br>
**convert** {*vstupní-soubor*}... {*výstupní-název*}**.gif**

*# rozložit animovaný GIF na sérii obrázků PNG*<br>
**convert** {*vstupní-název*}**.gif** {*výstupní-název-obsahující-„%03d“*}**.png**

*# konvertovat na TIFF*<br>
**convert** {*vstupní-soubor*} {*výstupní-název*}**.tiff**



### Operace se seznamem

*# načíst nový obrázek a přidat na konec seznamu (obecný/konkrétní formát)*<br>
*// Formát může být např.: gif, jpeg, png, tiff, bmp. Z animovaného gifu načte všechny jeho snímky v příslušném pořadí.*<br>
{*jméno-souboru*}<br>
{*formát*}**:**{*jméno-souboru*}

*# načíst konkétní snímek z animovaného gifu*<br>
**\\( -scene 0** {*jméno-souboru*} **-swap 0,**{*číslo-snímku*} **-delete 1--1 \\)**

*# odstranit ze seznamu poslední obrázek/čtyři poslední obrázky/všechny obrázky/všechny kromě předposledního/libovolné obrázky*<br>
*// Místo indexů lze v operátoru -delete použít i rozsahy, např. 3-5 značí obrázky na indexech 3, 4 a 5; 3--2 značí obrázky na indexech 3, 4 a tak dále až po předposlední obrázek včetně; -3--1 značí tři poslední obrázky.*<br>
**\-delete -1**<br>
**\-delete -4\-\-1**<br>
**\-delete 0\-\-1**<br>
**\-delete 0\-\-3,\-1**<br>
**\-delete** {*první-index-nebo-rozsah*}[**,**{*další-index-nebo-rozsah*}]...

*# vykonat sekvenci příkazů s novým, odděleným seznamem (prázdným/sestaveným z kopií obrázků na indexech 3, 3 a 5 původního seznamu/sestaveným jako kopie původního seznamu/sestaveným jen z posledního obrázku původního seznamu) a ten pak připojit na konec původního seznamu*<br>
**\\(** {*sekvence příkazů*} **\\)**<br>
**\\( -clone 3,3,5** {*sekvence příkazů*} **\\)**<br>
**\\( -clone 0--1** {*sekvence příkazů*} **\\)**<br>
**\\( +clone** {*sekvence příkazů*} **\\)**

*# přesunout poslední obrázek na určitou pozici v seznamu*<br>
**\-insert** {*pozice*}

*# vyměnit první a poslední obrázek/obrázky na určitých pozicích*<br>
**\-swap 0,-1**<br>
**\-swap** {*první-pozice*}**,**{*druhá-pozice*}

*# obrátit pořadí celého seznamu*<br>
**\-reverse**

*# přesunout obrázek z určité pozice na konec seznamu*<br>
**\-duplicate 1,**{*pozice*} **-delete **{*pozice*}

*# přidat na konec seznamu kopie obrázků z určitých pozic/kopie obrázků z pozic 3, 3, 1 a 5*<br>
**\-duplicate 1,**{*první-pozice-nebo-rozsah*}[**,**{*další-pozice-nebo-rozsah*}]...<br>
**\-duplicate 1,3,3,1,5**


### Překrývání a skládání obrázků (compose)

*# překrýt dva obrázky ze seznamu*<br>
*// Operace „-composite“ vezme předposlední obrázek ze seznamu (-2) a přes něj překryje poslední obrázek (-1); oba odstraní a výsledek překrytí přidá na konec seznamu místo nich.*<br>
**\-compose Over -geometry** {*posun-x*}**x**{*posun-y*} **-composite**

*# naskládat obrázky vedle sebe (zleva)*<br>
**\+append**

*# naskládat obrázky nad sebe (shora)*<br>
**\-append**

*# zploštit obrázek*<br>
*// Vytvořit plátno barvy pozadí („-background“) a postupně na něj překrýt všechny obrázky v seznamu a zpracované obrázky ze seznamu odstranit.*<br>
**\-flatten**

<!--
-mosaic: podobné jako -flatten, ale...
-->

*# vytvořit rekurzivní obrázek (1 úroveň/N úrovní)*<br>
*// Poznámka: Tento postup se aplikuje pouze na poslední obrázek, ne na všechny obrázky v seznamu!*<br>
**\-compose Over -background none -duplicate 1,-1 -geometry** {*šířka-podokna*}**x**{*výška-podokna*}**+**{*posun-x*}**+**{*posun-y*} **-composite**<br>
**\-compose Over -background none $(yes \-\- -duplicate 1,-1 -geometry** {*šířka-podokna*}**x**{*výška-podokna*}**+**{*posun-x*}**+**{*posun-y*} **-composite \| head -n **{*N*}**)**


### Ořezávání (crop)

*# oříznout obrázek (vyříznout podobrázek)*<br>
**\-crop** {*šířka*}**x**{*výška*}[**+**{*posun-x*}**+**{*posun-y*}] **+repage**

*# oříznout obrázek z každé strany*<br>
[**\-crop +**{*px-zleva*}**+**{*px-shora*}] [**-crop -**{*px-zprava*}**-**{*px-zdola*}] **+repage**

*# rozřezat obrázek do mřížky (všechny obrázky se uloží do seznamu!)*<br>
**\-crop** {*sloupců*}**x**{*řádků*}**@ +repage**

### Rámečky a nadstavování (border+padding)

*# přidat kolem obrázku jednobarevný rámeček/průhledný rámeček*<br>
**\-bordercolor** {*barva*} **-compose Copy -border** {*šířka-každého-rámečku*}[**x**{*výška-každého-rámečku*}]<br>
?

*# nadstavit obrázek na zadanou velikost*<br>
?


### Operace s barvami a průhledností
*# převést barevný obrázek na černobílý (alternativy)*<br>
**\-colorspace Gray**<br>
**\-modulate 100,0**

*# invertovat barvy*<br>
*// Invertuje kanály R, G a B; kanál A ponechá beze změny.*<br>
**\-negate**

*# změnit jas, sytost a odstín*<br>
*// Hodnoty jsou v rozsahu 0 až 200, kde 100 odpovídá původní hodnotě.*<br>
**\-modulate** {*jas*}[**,**{*sytost*}[**,**{*odstín*}]]

*# nahradit všechny pixely jednou barvou*<br>
?

*# barva do průhlednosti („maskování“)*<br>
?

*# odstranit průhlednost; překrýt obrázkem jednobarevné plátno*<br>
**\-bordercolor** {*barva-pozadí*} **-compose Over -border 0**


### Generátory obrázků
*# jednobarevný obrázek/bílý obrázek/transparentní obrázek/poloprůhledný červený obrázek*<br>
**\-size** {*šířka*}**x**{*výška*} **xc:**{*barva*}<br>
**\-size** {*šířka*}**x**{*výška*} **xc:**<br>
**\-size** {*šířka*}**x**{*výška*} **xc:none**<br>
**\-size** {*šířka*}**x**{*výška*} **xc:#FF000080**

*# vertikální/kruhový barevný gradient*<br>
**\-size** {*šířka*}**x**{*výška*} **gradient:**{*barva-nahoře*}**-**{*barva-dole*}
**\-size** {*šířka*}**x**{*výška*} **radial-gradient:**{*barva-středu*}**-**{*barva-okraje*}

*# plazma-gradient (náhodný)*<br>
**\-size** {*šířka*}**x**{*výška*} **plasma:**[{*barva-1*}**-**{*barva-2*}]<br>
**\-size** {*šířka*}**x**{*výška*} **plasma:fractal**

*# obrázek z náhodně vygenerovaných pixelů*<br>
**\-size** {*šířka*}**x**{*výška*} **xc: +noise Random**

*# vytvořit transparentní obrázek právě tak velký, aby se na něj vešel kterýkoliv obrázek ze seznamu*<br>
**\\( \-clone 0--1 -mosaic -alpha transparent \)**

### Dělení obrázků
*# rozřezat obrázek na pravidelnou mřížku podobrázků*<br>
?

### Ostatní a speciální
*# uložit poslední obrázek do souboru*<br>
**\\( +clone** [{*předzpracování*}] **-write** {*název-souboru*} **-delete 1\-\-1 \\)**

*# vyříznout (vynechat) z obrázku vodorovný pruh/svislý pruh/vodorovný a svislý pruh*<br>
**\+gravity -chop 0x**{*výška*}[**+0+**{*posun-y*}]<br>
**\+gravity -chop** {*šířka*}**x0**[**+**{*posun-x*}]<br>
**\+gravity -chop** {*výška*}**x**{*šířka*}[**+**{*posun-x*}[*+*{*posun-y*}]]

*# přeškálovat obrázek na rozměry dané jiným obrázkem v seznamu*<br>
?



### Kreslení a text
*# obdelník*<br>
?

*# kružnice/kruh*<br>
?<br>
?

*# text*<br>
?


## Parametry příkazů
![ve výstavbě](../obrazky/ve-vystavbe.png)

*# zapsat jeden soubor*<br>
{*název-souboru*}

*# zapsat jen poslední obrázek*<br>
**\-delete 0--2** {*název-souboru*}

*# zapsat všechny obrázky v seznamu do souborů obr000.png, obr001.png atd./do jinak pojmenovaných souborů*<br>
*// Soubory jsou číslovány celými čísly vždy od 0! Místo %03d lze použít jakoukoliv formátovací sekvenci, kterou v jazyce C dovoluje funkce printf() pro argument typu int.*<br>
**obr%03d.png**<br>
{*název-souboru-obsahující-„%03d“*}

## Jak získat nápovědu
Jediným zdrojem, který se mi osvědčil, je web „Examples of ImageMagick Usage“ (v angličtině). Jeho obsah je ale komplexní a studium pracné a příkaz „convert“ není přátelský k nováčkům. Mnohdy s ním není možné dosáhnout požadovaného výsledku bez detailní znalosti problematiky a způsobu, jakým dochází ke zpracování obrázků. Proto doporučuji začátečníkům, kteří nestojí o podrobné znalosti, aby se raději drželi příkladů uvedených v této kapitole a kontrolovali, zda udělaly to, co od nich očekávali.

## Tipy a zkušenosti
* Některé operátory (např. „-crop“ či „-resize“) se chovají výrazně odlišně od toho, co by začátečník očekával.
* ImageMagick podporuje i typy .pdf, .ps, .eps, .xps, ale je nutno je zapnout v globálním konfiguračním souboru „/etc/ImageMagick-6/policy.xml“: Najděte prvek &lt;policy&gt; s atributem „pattern“ obsahujícím např. PDF a atribut „rights“ změňte z hodnoty **"none"** na hodnotu **"read\|write"**. Účinek změny je okamžitý. Důvodem, proč je zpracování těchto formátů ve výchozím nastavení vypnuto, jsou bezpečnostní díry; podrobný popis na [webové stránce](https://cromwell-intl.com/open-source/pdf-not-authorized.html).

## Ukázka
![ve výstavbě](../obrazky/ve-vystavbe.png)
<!--
Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
-->

## Instalace na Ubuntu

*# *<br>
**sudo apt-get install imagemagick**

## Odkazy
* [Stránka na Wikipedii](https://cs.wikipedia.org/wiki/ImageMagick)
* [Examples of ImageMagick Usage](https://www.imagemagick.org/Usage/) (anglicky)
* [Referenční příručka](https://www.imagemagick.org/Usage/reference.html) (anglicky)
* [Oficiální stránka ImageMagick](https://imagemagick.org/) (anglicky)
* [Balíček Bionic](https://packages.ubuntu.com/bionic/imagemagick) (anglicky)
