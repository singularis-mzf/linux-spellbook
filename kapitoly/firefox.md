<!--

Linux Kniha kouzel, kapitola Firefox
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Firefox

!Štítky: {program}

## Úvod
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Definice
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Zaklínadla (about:config)
![ve výstavbě](../obrazky/ve-vystavbe.png)

*# drastická opatření proti fingerprintingu*<br>
**privacy.resistFingerprinting = TRUE**<br>
**privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts = FALSE**

*# vypnout cache na disku (paměť stačí)*<br>
**browser.cache.disk.enable = FALSE**

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

## Tipy a zkušenosti
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Jak získat nápovědu
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
