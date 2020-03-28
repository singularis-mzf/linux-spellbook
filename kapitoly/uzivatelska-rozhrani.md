<!--

Linux Kniha kouzel, kapitola Uživatelská rozhraní skriptů
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

# Uživatelská rozhraní skriptů

!Štítky: {tematický okruh}{programování}{skripty}{bash}{GUI}{TUI}

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

*# okno se zprávou a tlačítkem OK (TUI/GUI)*<br>
?<br>
?

*# zadání **řádky textu** (TUI/GUI)*<br>
?<br>
**zenity \-\-entry** [**\-\-title "**{*titulek*}**"**] **\-\-text "**{*Text výzvy*}**"** [**\-\-entry-text "**{*Výchozí text*}**"**] <nic>[**\-\-hide-text**]<nic>[{*obecné parametry zenity*}]

*# vybrat **soubor** ke čtení (TUI/GUI)*<br>
*// „Filtr“ je zde buď konkrétní jméno souboru, vzorek nebo vzorky oddělené mezerami.*<br>
?<br>
**zenity \-\-file-selection** [**\-\-title "**{*titulek*}**"**] <nic>[**\-\-file-filter=**{*filtr*}] <nic>[**\-\-multiple** [**\-\-separator** {*řetězec*}]]

*# vybrat **soubor** k zápisu (TUI/GUI)*<br>
?<br>
**zenity \-\-file-selection \-\-save** [**\-\-confirm-overwrite**] <nic>[**\-\-title "**{*titulek*}**"**]

*# vybrat **adresář** (TUI/GUI)*<br>
?<br>
**zenity \-\-file-selection \-\-directory** [**\-\-title "**{*titulek*}**"**] <nic>[**\-\-multiple** [**\-\-separator** {*řetězec*}]]

*# vybrat **barvu** (TUI/GUI)*<br>
?<br>
**zenity \-\-color-selection \-\-title "**{*Titulek*}**"** [**\-\-show-palette**] <nic>[**\-\-color "**{*výchozí-barva*}**"**]
<!--
Barva např. rgb(1,2,3) nebo #aabbcc
-->

*# zadat heslo (TUI/GUI)*<br>
?<br>
**zenity \-\-password** [**\-\-username**]


## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

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

<!--
Obecné parametry zenity:
--window-icon={error|info|question|warning|/cesta/k/obrázku}
--width={px}
--height={px}
--timeout={sec}

(+ --title, ale ten je důležitý)

Návratový kód zenity:
0 – úspěch, uživatel zadal hodnotu, vypsána na standardní výstup.
1 – storno; uživatel odmítl zadat hodnotu
5 – čas vypršel (byl-li zadán parametrem --timeout)

-->

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
