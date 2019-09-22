<!--

Linux Kniha kouzel, kapitola Markdown
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Markdown

## Úvod
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Definice
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Zaklínadla (formátování)
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Nadpisy

*# nadpis první/druhé/třetí/čtvrté/páté/šesté úrovně*<br>
**\#** {*nadpis*}<br>
**\##** {*nadpis*}<br>
**\###** {*nadpis*}<br>
**\####** {*nadpis*}<br>
**\#####** {*nadpis*}<br>
**\######** {*nadpis*}<br>

### Základní formátování

*# tučný text*<br>
**\*\***{*text*}**\*\***

*# kurzíva*<br>
**\***{*text*}**\***

*# podtržení*<br>
**&lt;u&gt;**{*text*}**&lt;/u&gt;**

*# vložený kód v rámci řádku*<br>
*// Uvnitř kódu se neinterpretují formátovací sekvence, takže je není nutno escapovat.*<br>
**\`**{*kód*}**\`**

*# víceřádkový kód*<br>
**&nbsp;&nbsp;&nbsp;&nbsp;**{*první řádek*}<br>
[**&nbsp;&nbsp;&nbsp;&nbsp;**{*další řádek*}]...

### Seznamy

*# odrážkovaný seznam*<br>
**\*** {*položka seznamu*}<br>
[**\*** {*další položka seznamu*}]...

*# automaticky číslovaný seznam*<br>
**1.** {*položka seznamu*}<br>
[**1.** {*další položka seznamu*}]...

### Ostatní

*# hypertextový odkaz*<br>
*// Některé interprety markdownu automaticky převádějí úplné URL adresy na hypertextové odkazy bez zjevné možnosti escapování.*<br>
**[**{*text odkazu*}**\](**{*adresa-odkazu*}**)**

*# vložit obrázek (jako znak)*<br>
**![**{*text odkazu*}**\](**{*adresa-odkazu*}**)**

*# výrazné odsazení odstavce zleva (první úroveň)*<br>
**&gt;** {*začátek textu*}<br>
[**&gt;** {*pokračování*}]...

*# výrazné odsazení odstavce zleva (druhá úroveň)*<br>
**&gt;&gt;** {*začátek textu*}<br>
[**&gt;&gt;** {*pokračování*}]...


## Parametry příkazů
![ve výstavbě](../obrazky/ve-vystavbe.png)

*# převod Markdownu na HTML*<br>
**markdown** [**\-\-html4tags**] [**\-\-**] [{*vstupní-soubor*}]...

## Jak získat nápovědu
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Tipy a zkušenosti
![ve výstavbě](../obrazky/ve-vystavbe.png)

* Asi nejhorším problémem v Markdownu je escapování. Speciální znaky se totiž escapují zpětným lomítkem pouze tehdy, když mají speciální význam; v ostatních případech se zpětné lomítko před takovým znakem exportuje jako normální znak. Problém však je, že inteprety Markdownu se velmi značně liší v tom, které znaky a v jakých kontextech považují za speciální. Proto nelze dosáhnout zcela jednotných výsledků.

## Ukázka
![ve výstavbě](../obrazky/ve-vystavbe.png)
<!--
Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
-->

## Snímek obrazovky
![ve výstavbě](../obrazky/ve-vystavbe.png)
<!--
Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
-->

## Instalace na Ubuntu
*# příkaz...*<br>
**sudo apt-get install markdown**

*# editor (grafický)*<br>
**sudo apt-get install retext**

## Odkazy
![ve výstavbě](../obrazky/ve-vystavbe.png)

Co hledat:

* [?](http://daringfireball.net/projects/markdown/)
* [stránku na Wikipedii](https://cs.wikipedia.org/wiki/Hlavn%C3%AD_strana)
* oficiální stránku programu
* oficiální dokumentaci
* [manuálovou stránku](http://manpages.ubuntu.com/)
* [balíček Bionic](https://packages.ubuntu.com/)
* online referenční příručky
* různé další praktické stránky, recenze, videa, tutorialy, blogy, ...
* publikované knihy
