<!--

Linux Kniha kouzel, kapitola Firefox
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--

http://kb.mozillazine.org/About:config_entries
https://github.com/pyllyukko/user.js/blob/master/user.js


Oficiální reference: https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/Preference_reference (ale značně neúplná)
about protocol:
https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/The_about_protocol

Poznámky:
- Od verze 80 volba privacy.resistFingerprinting blokuje použití rozšířených písem instalovaných v systému. Proto se některé znaky nezobrazují správně.
- user.js > přímo do adresáře profilu. Profil je obvykle .mozilla/firefox/*.default-release

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

*# vypnout otravnou výzvu k „Refresh Firefox“ (ve Firefoxu 75 už není)*<br>
*// Nutno vytvořit jako novou hodnotu typu BOOLEAN.*<br>
**browser.disableResetPrompt = TRUE**

*# otevírat nové taby vždy úplně vpravo*<br>
**browser.tabs.insertAfterCurrent = FALSE**<br>
**browser.tabs.insertRelatedAfterCurrent = FALSE**

*# neotevírat ihned po kliknutí do adresního řádku nabídku*<br>
**browser.urlbar.openViewOnFocus = FALSE**
<!--
(od Firefoxu 75, možná 76)
-->

*# povolit přizpůsobení stránek a prohlížeče pomocí stylových předpisů*<br>
*// Přizpůsobení se provádí pomocí souborů userContent.css (stránky) a userChrome.css (rozhraní prohlížeče). V profilu Firefoxu musíte vytvořit nový adresář „chrome“ a umístit je tam.*<br>
**user\_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);**

### Vypínání
*# vypnout webové fonty (stahované)*<br>
**user\_pref("gfx.downloadable\_fonts.enabled", false);**

*# vypnout JavaScript*<br>
**user\_pref("javascript.enabled", false);**

### Jsou v GUI
*# nenašeptávat otevřené panely*<br>
**browser.urlbar.suggest.openpage = FALSE**

*# vypnout „obraz v obrazu“*<br>
**media.videocontrols.picture-in-picture.enabled = FALSE**<br>
**media.videocontrols.picture-in-picture.video-toggle.enabled = FALSE**

### Ostatní

*# vypnout „navigator.sendBeacon()“ (slouží k odeslání analytických dat při uzavření stránky)*<br>
**user\_pref("beacon.enabled", false);**
<!--
TODO: [ ] TEST
-->

*# výchozí barva nenavštíveného/navštíveného/aktivního odkazu*<br>
**user\_pref("browser.anchor\_color", "#**{*RRGGBB*}**");**<br>
?<br>
**user\_pref("browser.active\_color", "#**{*RRGGBB*}**");**

*# vypnout kešování na disk/do paměti*<br>
**user\_pref("browser.cache.disk.enable", false);**<br>
**user\_pref("browser.cache.memory.enable", false);**

*# velikost keše v paměti (dynamicky/pevná velikost/příklad)*<br>
**user\_pref("browser.cache.memory.capacity", -1);**<br>
**user\_pref("browser.cache.memory.capacity",** {*kilobajtů*}**);**<br>
**user\_pref("browser.cache.memory.capacity", 4096);** ⊨ 4 MB


*# výchozí barva pozadí(?)*<br>
**user\_pref("browser.display.background\_color", "#**{*RRGGBB*}**");**

*# zakázat stránkám nastavovat barvy textu a pozadí*<br>
**user\_pref("browser.display.document\_color\_use", 2);**

*# zapnout WebRender místo Gecko*<br>
**user\_pref("gfx.webrender.enabled", true);**<br>
**user\_pref("gfx.webrender.all", true);**

## Parametry příkazů
![ve výstavbě](../obrazky/ve-vystavbe.png)


## Instalace na Ubuntu

Běžná aktuální verze Firefoxu je ve většině variant Ubuntu předinstalovaná. Kde není, je možné ji snadno doinstalovat:

**sudo apt-get install firefox** [**firefox-locale-cs**]

<!--
[ ] Prozkoumat transplantaci Firefoxu ESR z Debianu.

sudo add-apt-repository ppa:mozillateam/ppa && sudo apt-get update && sudo apt-get install firefox-esr firefox-esr-locale-cs

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
