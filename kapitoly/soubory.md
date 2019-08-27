<!--

Linux Kniha kouzel, kapitola [DOPLNIT NÁZEV]
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Název

## Úvod
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Definice
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Zaklínadla
![ve výstavbě](../obrazky/ve-vystavbe.png)

*# vytvořit prázdný soubor (existuje-li, vyprázdnit)*<br>
**&gt;** {*soubor*} [**&gt;** {*další-soubor*}]...

*# vytvořit prázdný soubor (existuje-li, jen aktualizovat čas změny)*<br>
**touch** {*soubor*}...

*# smazat soubor*<br>
**rm** [**-f**] [**-v**] {*soubor*}...

*# vzít maximálně N prvních řádků*<br>
**head -**{*N*} [{*soubor*}]...<br>
**head -n **{*N*} [{*soubor*}]...

*# vzít maximálně N posledních řádků*<br>
**tail -**{*N*} [{*soubor*}]...

*# vynechat N prvních řádků, zbytek vzít*<br>
**tail -n +**{*N*} [{*soubor*}]...

*# vzít všechny řádky kromě N posledních*<br>
**head -n -**{*N*} [{*soubor*}]...

*# vzít řádky obsahující podřetězec vyhovující regulárnímu výrazu*<br>
**grep** [**-e**]  **'**{*regulární-výraz*}**'** [{*soubor*}]...

*# vzít řádky vyhovující regulárnímu výrazu*<br>
**grep -x** [**-e**]  **'**{*regulární-výraz*}**'** [{*soubor*}]...

*# vzít řádky nevyhovující regulárnímu výrazu*<br>
**grep -vx** [**-e**]  **'**{*regulární-výraz*}**'** [{*soubor*}]...

*# vypsat ty ze souborů, které neobsahují řádek s podřetězcem vyhovujícím danému regulárnímu výrazu*<br>
**grep -L** [**-e**]  **'**{*regulární-výraz*}**'** {*soubor*}...

*# seřadit řádky souboru**<br>
**sort** [{*soubor*}]...<br>
**LC_ALL=C sort** [{*soubor*}]...

*# seřadit a vyloučit duplicity*<br>
**LC_ALL=C sort -u** [{*soubor*}]...

<!--
-r : opačné pořadí
-->

*# náhodně permutovat řádky*<br>
**sort -R** [{*soubor*}]...

*# obrátit pořadí znaků na každém řádku*<br>
**rev**

*# obrátit pořadí řádků v každém souboru*<br>
**tac** [{*soubor*}]...


*# spojit řádky z více souborů do sloupců vedle sebe*<br>
*// je-li některý soubor kratší, program ho nadstaví prázdnými řádky*<br>
**paste** [**-d** {*oddělovací-znaky*}] {*soubor*}...

*# generovat soubor s nekonečně se opakujícím řádkem*<br>
*// výchozí text řádeku je "y"*<br>
**yes** [{*text-řádku*}]

*# donekonečna opakovat obsah souboru*<br>
**yes -- "$(cat** {*soubor*} **)"**

*# rozdělit vstupní soubor na díly o uvedené maximální velikosti, s uvedeným prefixem, číslováním a suffixem*<br>
**split -d -a** {*počet-číslic*} **-b** {*velikost-dílu*} [**--additional-suffix='**{*suffix-výstupních-souborů*}**'**] {*vstupní-soubor*} {*prefix-výstupních-souborů*}

*# zapsat vstup do více souborů*<br>
**tee** [**-a**] {*soubor*}... [**>/dev/null**]

*# zakódovat vstup algoritmem UUENCODE*<br>
?


### Množinové operace nad řádky souborů

*# množinové sjednocení (OR)*<br>
**cat** {*soubor*}... **| LC_ALL=C sort | LC_ALL=C uniq**

*# množinový průnik (AND)*<br>
?

*# množinový rozdíl dvou souborů (AND NOT)*<br>
?

*# exkluzivní sjednocení dvou souborů (XOR)*<br>
?

## Parametry příkazů
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Jak získat nápovědu
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Tipy a zkušenosti
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Instalace na Ubuntu
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Odkazy
![ve výstavbě](../obrazky/ve-vystavbe.png)

Co hledat:

* [https://cs.wikipedia.org/wiki/Hlavn%C3%AD_strana](stránku na Wikipedii)
* oficiální stránku programu
* oficiální dokumentaci
* [http://manpages.ubuntu.com/](manuálovou stránku)
* [https://packages.ubuntu.com/](balíček Bionic)
* online referenční příručky
* různé další praktické stránky, recenze, videa, blogy, ...
