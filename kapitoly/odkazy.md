<!--

Linux Kniha kouzel, kapitola Pevné a symbolické odkazy
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Pevné a symbolické odkazy

## Úvod
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Definice
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Zaklínadla
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Pevné odkazy

*# vytvořit pevný odkaz na soubor*<br>
**ln** {*cesta-k-souboru*}... {*cesta-k-odkazu*}<br>
**ln -t** {*adresář-kde-vytvořit-odkaz*} {*cesta-k-souboru*}...

*# smazat pevný odkaz*<br>
**rm** {*cesta-k-odkazu*}...

*# vypsat počet referencí pevného odkazu*<br>
*// bude-li cílem symbolický odkaz, L umožní vypsat jeho vlastní počítadlo; jinak se vypíše počítadlo odkazovaného souboru či adresáře*<br>
**ln -ld**[**L**] {*cesta-k-odkazu*}

*# vypsat kanonickou cestu pevného odkazu*<br>
**readlink -f** {*cesta-k-odkazu*}

*# vypsat kanonickou cestu adresáře obsahujícího pevný odkaz*<br>
?

*# přejmenovat/přesunout pevný odkaz*<br>
**mv** {*původní-cesta*} {*nová-cesta*}

*# vytvořit dočasný, zdánlivý, nerekurzivní pevný odkaz na adresář*<br>
**mkdir -p** {*nová-cesta*}<br>
**mount** [**-o ro**] **\-\-bind** {*původní-cesta*} {*nová-cesta*}

### Symbolické odkazy

*# vytvořit symbolický odkaz*<br>
**ln -s** {*obsah-odkazu*} {*cesta-k-odkazu*}

*# vytvořit symbolický odkaz s absolutní (kanonickou) cestou*<br>
**ln -s "$(readlink -f** {*cesta-k-souboru-či-adresáři*}**)"** {*cesta-k-odkazu*}

*# vytvořit symbolický odkaz s relativní cestou*<br>
?

### Kopírování

*# kopírovat: zachovat symbolické odkazy doslovně*<br>
?

*# kopírovat: opravit symbolické odkazy (zachovat jejich smysl)*<br>
?

*# kopírovat: následovat symbolické odkazy (chovat se, jako by byly pevné)*<br>
?

*# kopírovat: vynechat symbolické odkazy*<br>
?

*# kopírovat: symbolické odkazy nahradit prázdnými soubory*<br>
?

*# kopírovat adresáře; na soubory místo toho vytvořit v cíli pevné odkazy*<br>
?

*# kopírovat adresářovou strukturu bez souborů*<br>
?

*# najít duplicitní soubory v adresářové struktuře a sloučit je pomocí pevných odkazů*<br>
?

## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
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

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Jak získat nápovědu
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje (ale neuvádějte konkrétní odkazy, ty patří do sekce „Odkazy“).
-->
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
