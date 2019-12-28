<!--

Linux Kniha kouzel, kapitola Zpracování textových souborů
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Zpracování textových souborů

!Štítky: {tematický okruh}
!ÚzkýRežim: zap

## Úvod
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Definice
![ve výstavbě](../obrazky/ve-vystavbe.png)

* **Záznam** je...
* **Pole** je...

!ÚzkýRežim: vyp

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

*# seřadit řádky souboru*<br>
**sort** [{*soubor*}]...<br>
**LC\_ALL=C sort** [{*soubor*}]...

*# seřadit a vyloučit duplicity*<br>
**LC\_ALL=C sort -u** [{*soubor*}]...

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

*# donekonečna opakovat obsah souboru (krátkého/dlouhého)*<br>
**yes \-\- "$(cat** {*soubor*} **)"**<br>
?

*# rozdělit vstupní soubor na díly o uvedené maximální velikosti, s uvedeným prefixem, číslováním a suffixem*<br>
**split -d -a** {*počet-číslic*} **-b** {*velikost-dílu*} [**\-\-additional-suffix='**{*suffix-výstupních-souborů*}**'**] {*vstupní-soubor*} {*prefix-výstupních-souborů*}

*# zapsat vstup do více souborů*<br>
**tee** [**-a**] {*soubor*}... [**&gt;/dev/null**]

*# zakódovat vstup algoritmem UUENCODE*<br>
?


### Množinové operace nad řádky souborů

*# množinové sjednocení (OR)*<br>
**cat** {*soubor*}... **\| LC\_ALL=C sort \| LC\_ALL=C uniq**

*# množinový průnik (AND)*<br>
?

*# množinový rozdíl dvou souborů (AND NOT)*<br>
?

*# exkluzivní sjednocení dvou souborů (XOR)*<br>
?

## Parametry příkazů
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíků k instalaci vycházejte z minimální instalace Ubuntu.
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

* [https://cs.wikipedia.org/wiki/Hlavn%C3%AD_strana](stránku na Wikipedii)
* oficiální stránku programu
* oficiální dokumentaci
* [http://manpages.ubuntu.com/](manuálovou stránku)
* [https://packages.ubuntu.com/](balíček Bionic)
* online referenční příručky
* různé další praktické stránky, recenze, videa, blogy, ...

!ÚzkýRežim: vyp

## Pomocné funkce a skripty

*# propustit\_radku() − Propustí N řádků přímo a zbytek nechá projít zadaným příkazem*<br>
**function propustit\_radku() \{**<br>
**sed -u "$1q"**<br>
**shift**<br>
**"$@"**<br>
**\}**
