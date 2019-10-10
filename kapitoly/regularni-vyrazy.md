<!--

Linux Kniha kouzel, kapitola Regulární výrazy
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Regulární výrazy

## Úvod

Regulární výraz je řetězec popisující množinu řetězců. (...)

## Definice
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Zaklínadla
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Jednotlivé znaky

*# libovolný znak*<br>
**.**

*# kterýkoliv z uvedených znaků*<br>
**[**{*znaky*}**]**

*# jakýkoliv, kromě uvedených znaků*<br>
**[^**{*znaky*}**]**

*# bílý znak/nebílý znak*<br>
**\\s**<br>
**\\S**

*# číslice*<br>
**[0-9]**

*# libovolný alfanumerický znak*<br>
?

### Operátory opakování
*# nejvýše jednou (&lt;= 1)*<br>
{*výraz*}**?**

*# libovolný počet (&gt;= 0)*<br>
{*výraz*}**\***

*# alespoň jednou (&gt;= 1)*<br>
{*výraz*}**+**

*# přesný počet výskytů*<br>
{*výraz*}**\{**{*počet*}**\}**

*# minimálně M výskytů, maximálně N výskytů*<br>
{*výraz*}**\{**{*M*}**,**{*N*}**\}**

*# minimálně M výskytů/maximálně N výskytů*<br>
{*výraz*}**\{**{*M*}**,}**<br>
{*výraz*}**{,**{*N*}**\}**

### Pozice (prázdný řetězec na určité pozici)
*# začátek/konec řetězce*<br>
?

*# začátek/konec řádku*<br>
**^**<br>
**$**

*# začátek/konec/kterákoliv hranice slova*<br>
**\\&lt;**<br>
**\\&gt;**<br>
**\\b**

### Seskupení

*# seskupení*<br>
**(**{*podvýraz*}**)**

### Operátor „nebo“

*# některý z podvýrazů (operátor „nebo“)*<br>
{*výraz 1*}[**\|**{*další výraz*}]...


## Parametry příkazů
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Jak získat nápovědu
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Tipy a zkušenosti
![ve výstavbě](../obrazky/ve-vystavbe.png)

<!--
Základní versus rozšířený regulární výraz...
?, +, {, |, (, and )
-->

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
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Odkazy
![ve výstavbě](../obrazky/ve-vystavbe.png)

Co hledat:

* [stránku na Wikipedii](https://cs.wikipedia.org/wiki/Hlavn%C3%AD_strana)
* oficiální stránku programu
* oficiální dokumentaci
* [manuálovou stránku](http://manpages.ubuntu.com/)
* [balíček Bionic](https://packages.ubuntu.com/)
* online referenční příručky
* různé další praktické stránky, recenze, videa, tutorialy, blogy, ...
* publikované knihy
