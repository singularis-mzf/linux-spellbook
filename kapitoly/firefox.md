<!--

Linux Kniha kouzel, kapitola Firefox
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--

http://kb.mozillazine.org/About:config_entries

Oficiální reference: https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/Preference_reference (ale značně neúplná)
about protocol:
https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/The_about_protocol


-->

# Firefox

!Štítky: {program}
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

## Zaklínadla (about:config)
![ve výstavbě](../obrazky/ve-vystavbe.png)

*# drastická opatření proti fingerprintingu*<br>
**privacy.resistFingerprinting = TRUE**<br>
**privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts = FALSE**

*# vypnout cache na disku (paměť stačí)*<br>
**browser.cache.disk.enable = FALSE**

*# vypnout otravnou výzvu k „Refresh Firefox“*<br>
*// Nutno vytvořit jako novou hodnotu typu BOOLEAN.*<br>
**browser.disableResetPrompt = TRUE**

*# otevírat nové taby vždy úplně vpravo*<br>
**browser.tabs.insertAfterCurrent = FALSE**<br>
**browser.tabs.insertRelatedAfterCurrent = FALSE**

*# povolit přizpůsobení stránek a prohlížeče pomocí stylových předpisů*<br>
*// Přizpůsobení se provádí pomocí souborů userContent.css (stránky) a userChrome.css (rozhraní prohlížeče). V profilu Firefoxu musíte vytvořit nový adresář „chrome“ a umístit je tam.*<br>
**toolkit.legacyUserProfileCustomizations.stylesheets = TRUE**

### Vypínání
*# vypnout webové fonty (stahované)*<br>
**gfx.downloadable\_fonts.enabled = FALSE**

*# vypnout JavaScript*<br>
**javascript.enabled = FALSE**

*# vypnout „obraz v obrazu“*<br>
**media.videocontrols.picture-in-picture.enabled = FALSE**

### Jsou v GUI
*# nenašeptávat otevřené panely*<br>
**browser.urlbar.suggest.openpage = FALSE**

## Parametry příkazů
![ve výstavbě](../obrazky/ve-vystavbe.png)


## Instalace na Ubuntu

Běžná aktuální verze Firefoxu je ve většině variant Ubuntu předinstalovaná. Kde není, je možné ji snadno doinstalovat:

**sudo apt-get install firefox** [**firefox-locale-cs**]

<!--
[ ] Prozkoumat transplantaci Firefoxu ESR z Debianu.
-->

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
