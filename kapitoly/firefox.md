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
[ ] https://www.userchrome.org/
[ ] https://www.youtube.com/watch?v=1mGhMBWmGDY

http://kb.mozillazine.org/About:config_entries
http://kb.mozillazine.org/Category:Preferences (novější volby)
https://github.com/pyllyukko/user.js/blob/master/user.js


Oficiální reference: https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/Preference_reference (ale značně neúplná)
about protocol:
https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/The_about_protocol


Poznámky:
- Od verze 80 volba privacy.resistFingerprinting blokuje použití rozšířených písem instalovaných v systému. Proto se některé znaky nezobrazují správně.
- user.js > přímo do adresáře profilu. Profil je obvykle .mozilla/firefox/*.default-release

browser.urlbar.richSuggestions.tail = false

Ve zdrojovém kódu:

modules/libpref/init/StaticPrefList.yaml – krátké komentáře k statickým volbám
 browser/app/profile/firefox.js – nestatické volby specifické pro Firefox na počítačích

Ke stažení:
https://archive.mozilla.org/pub/firefox/releases/{*verze*}/source/firefox-{*verze*}.source.tar.xz

„menší nebo rovno“ (≤), „větší nebo rovno“ (≥), „nerovno“ (≠)
-->

# Firefox

!Štítky: {program}{internet}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

!ÚzkýRežim: vyp

## Zaklínadla: user.js

### Doporučené volby

*# povolit přizpůsobení stránek a prohlížeče pomocí stylových předpisů*<br>
*// Přizpůsobení se provádí pomocí souborů userContent.css (stránky) a userChrome.css (rozhraní prohlížeče). V profilu Firefoxu musíte vytvořit nový adresář „chrome“ a umístit je tam.*<br>
**user\_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);**

*# zobrazovat „http://“ na začátku adres (https se zobrazuje vždy)*<br>
**user\_pref("browser.urlbar.trimURLs", false);**


### Panely a jejich úchytky

*# otevírat nové panely vždy úplně vpravo*<br>
**user\_pref("browser.tabs.insertAfterCurrent", false);**<br>
**user\_pref("browser.tabs.insertRelatedAfterCurrent", false);**

*# nově otevřený panel zobrazovat prázdný*<br>
**user\_pref("browser.newtabpage.enabled", false);**<br>
**user\_pref("browser.startup.homepage", "about:blank");**<br>
**user\_pref("browser.startup.page", 0);**

<!--
*# zakázat vytvoření nového okna tažením úchytky panelu*<br>
browser.tabs.allowTabDetach
-->

*# záložku otevřít v tomto panelu/v novém panelu*<br>
**user\_pref("browser.tabs.loadBookmarksInTabs", false);**<br>
**user\_pref("browser.tabs.loadBookmarksInTabs", true);**

*# chce-li odkaz otevřít stránku v novém okně, otevřít ji: v novém okně/v novém panelu/ve stejném panelu*<br>
*// Toto omezení normálně nezahrnuje situace, kdy skript chce otevřít nové okno s konkrétními vlastnostmi (např. bez nabídky); pokud chcete takto nastavené omezení uplatnit i v těchto případech, musíte přidat ještě volbu: „user\_pref("browser.link.open\_newwindow.restriction", 0);“*<br>
**user\_pref("browser.link.open\_newwindow", 2);**<br>
**user\_pref("browser.link.open\_newwindow", 3);**<br>
**user\_pref("browser.link.open\_newwindow", 1);**

*# nenačítat stránky na nově otevřených panelech v pozadí*<br>
?
<!--
**user\_pref("browser.tabs.loadBookmarksInBackground", true);**<br>
**user\_pref("browser.newtab.preload", false);**
<!- -
**user\_pref("browser.tabs.loadInBackground", true);**
-->

*# při zavření posledního panelu místo něj otevřít prázdný*<br>
**user\_pref("browser.tabs.closeWindowWithLastTab", false);**

### Adresní řádek

*# vypnout automatické doplňování při psaní*<br>
**user\_pref("browser.urlbar.autoFill", false);**

<!--
*# neotevírat ihned po kliknutí do adresního řádku nabídku (FF ≥ 75 nebo 76)*<br>
**user\_pref("browser.urlbar.openViewOnFocus", false);**
-->

*# neotevírat nabídku při psaní do adresního řádku (FF ≥ 83)*<br>
**user\_pref("browser.urlbar.maxRichResults", 0);**
<!--
možná vypne i automatické doplňování
-->

*# neotevírat nabídku při kliknutí do adresního řádku (FF ≥ 78)*<br>
**user\_pref("browser.urlbar.suggest.topsites", false);**

*# nenašeptávat: záložky/navštívené stránky/otevřené panely/vyhledávání/top stránky*<br>
**user\_pref("browser.urlbar.suggest.bookmark", false);**<br>
**user\_pref("browser.urlbar.suggest.history", false);**<br>
**user\_pref("browser.urlbar.suggest.openpage", false);**<br>
**user\_pref("browser.urlbar.suggest.topsites", false);**

*# nenašeptávat: vyhledávání*<br>
**user\_pref("browser.urlbar.suggest.searches", false);**<br>
**user\_pref("browser.search.suggest.enabled", false);**

*# adresu zadanou do adresní řádky otevírat v tomto panelu/novém panelu*<br>
**user\_pref("browser.urlbar.openintab", false);**<br>
**user\_pref("browser.urlbar.openintab", true);**

*# nezvětšovat adresní řádek po kliknutí*<br>
**user\_pref("ui.prefersReducedMotion", 1);**

### Záložky

*# při přidání nové záložky (např. zkratkou Ctrl+D) editor vyvolávat/nevyvolávat*<br>
**user\_pref("browser.bookmarks.editDialog.showForNewBookmarks", true);**<br>
**user\_pref("browser.bookmarks.editDialog.showForNewBookmarks", false);**

*# nastavit počet nabízených posledních složek záložek v editoru*<br>
**user\_pref("browser.bookmarks.editDialog.maxRecentFolders",** {*počet*}**);**

### Obecné volby

*# drastická opatření proti fingerprintingu*<br>
**user\_pref("privacy.resistFingerprinting", true);**<br>
**user\_pref("privacy.resistFingerprinting.autoDeclineNoUserInputCanvasPrompts", false);**

*# nezobrazovat varování při vstupu na stránku „about:config“*<br>
**user\_pref("browser.aboutConfig.showWarning", false);**

*# vypnout všechna varování při zavírání prohlížeče*<br>
**user\_pref("browser.warnOnQuit", false);**

*# nekopírovat výběr do „primární schránky“*<br>
*// Ve výchozím nastavení, když vyberete text, Firefox (jako jiné linuxové programy) ho okamžitě zkopíruje do takzvané „primární schránky“, odkud ho můžete vložit do jiných programů kliknutím prostředním tlačítkem myši. Tato schránka je nezávislá na hlavní schránce, kam se text zkopíruje až použitím klávesové zkratky nebo volbou z menu.*<br>
**user\_pref("clipboard.autocopy", false);**

*# při stahování kliknutím se zeptat, kam soubor uložit*<br>
**user\_pref("browser.download.useDownloadDir", false);**

*# preferovat webové stránky v angličtině (nehlásit skutečný jazyk prohlížeče)*<br>
**user\_pref("privacy.spoof\_english", 2);**

<!--
*# do schránky zkopírovat jen prostý text*<br>
**user\_pref("clipboard.plainTextOnly", true);**
// Nefunguje
-->


### Vypínání funkcí

*# vypnout otravování uživatele oznámením o nových funkcích*<br>
**user\_pref("browser.messaging-system.whatsNewPanel.enabled", false);**

*# vypnout **webové fonty** (stahované)*<br>
**user\_pref("gfx.downloadable\_fonts.enabled", false);**<br>
**user\_pref("layout.css.font-loading-api.enabled", false);**

*# vypnout **JavaScript***<br>
**user\_pref("javascript.enabled", false);**

*# vypnout **notifikace***<br>
**user\_pref("dom.webnotifications.enabled", false);**
<!--
https://support.mozilla.org/en-US/questions/1140439
-->

*# vypnout **„service workers“***<br>
**user\_pref("dom.serviceWorkers.enabled", false);**

*# vypnout **geolokaci** (Navigator.geolocation)*<br>
*// Tato volba vypne pouze vestavěné geolokační funkce Firefoxu; javascriptový kód může kontaktovat geolokační servery i jinými způsoby, a tak toto omezení obejít.*<br>
**user\_pref("geo.enabled", false);**

*# vypnout funkci „**obraz v obrazu**“*<br>
**user\_pref("media.videocontrols.picture-in-picture.enabled", false);**<br>
**user\_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);**

*# vypnout různé druhy **telemetrie***<br>
**user\_pref("toolkit.telemetry.archive.enabled", false);**<br>
**user\_pref("toolkit.telemetry.enabled", false);**<br>
**user\_pref("toolkit.telemetry.firstShutdownPing.enabled", false);**<br>
**user\_pref("toolkit.telemetry.shutdownPingSender.enabled", false);**<br>
**user\_pref("toolkit.telemetry.server", "https://localhost");**<br>
**user\_pref("toolkit.telemetry.server\_owner", "me");**<br>
**user\_pref("browser.urlbar.eventTelemetry.enabled", false);**<br>
**user\_pref("app.normandy.enabled", false);**<br>
**user\_pref("app.normandy.api\_url", "");**<br>
**user\_pref("app.shield.optoutstudies.enabled", true);**

*# vypnout odesílání dat o stavu Firefoxu (**health report**)*<br>
**user\_pref("datareporting.healthreport.uploadEnabled", false);**<br>
**user\_pref("datareporting.policy.dataSubmissionEnabled", false);**

*# vypnout odesílání analytických dat při uzavření stránky (**beacon**)*<br>
*// Poznámka: tato volba může způsobit, že vás některé weby zablokují; doporučuji ji používat jen přes Tor nebo při zcela vypnutém JavaScriptu.*<br>
**user\_pref("beacon.enabled", false);**
<!--
[ ] víc zkoušet...
-->

*# vypnout animace formátu **GIF***<br>
**user\_pref("image.animation\_mode", "none");**
<!--
http://kb.mozillazine.org/Animated_images
-->

*# vypnout „Firefox **Pocket**“*<br>
**user\_pref("extensions.pocket.enabled", false);**

*# zakázat zobrazování PDF ve Firefoxu (**pdfjs**)*<br>
**user\_pref("pdfjs.disabled", true);**

*# vypnout **historii** stránek*<br>
**user\_pref("places.history.enabled", false);**

*# zabránit skriptům reagovat na výběr textu*<br>
**user\_pref("dom.select\_events.enabled", false);**

*# zabránit skriptům použít lokální uložení dat*<br>
**user\_pref("dom.storage\_access.enabled", false);**

*# vypnout „**WebGL**“*<br>
**user\_pref("webgl.disabled", true);**<br>
**user\_pref("webgl.force-enabled", false);**

*# vypnout **MathML***<br>
**user\_pref("mathml.disabled", true);**

*# vypnout přesné sledování viditelnosti prvků stránky*<br>
*// Poznámka: skripty budou moci nadále sledovat pozici posuvníku a velikost okna.*<br>
**user\_pref("layout.framevisibility.enabled", false);**

*# zablokovat automatické obnovení stránky (**autorefresh**)*<br>
**user\_pref("accessibility.blockautorefresh", true);**

*# zcela vypnout odlišování navštívených odkazů*<br>
**user\_pref("layout.css.visited\_links\_enabled", false);**

*# vypnout „performance API“/„gamepad API“*<br>
**user\_pref("dom.enable\_performance", false);**<br>
**user\_pref("dom.gamepad.enabled", false);**

*# vypnout odesílání DNS požadavků*<br>
*// Po zapnutí této volby nedokáže Firefox přeložit ani adresy z /etc/hosts; naopak prý může používat adresy zapamatované z dřívějška.*<br>
**user\_pref("network.dns.disabled", true);**

### Vypínání mediálních formátů

*# zakázat formát MP4/WebM/AV1*<br>
**user\_pref("media.mp4.enabled", false);**<br>
**user\_pref("media.webm.enabled", false);**<br>
**user\_pref("media.av1.enabled", false);**

*# zakázat formát OGG/OPUS/WAV/FLAC*<br>
**user\_pref("media.ogg.enabled", false);**<br>
**user\_pref("media.opus.enabled", false);**<br>
**user\_pref("media.wave.enabled", false);**<br>
**user\_pref("media.flac.enabled", false);**

*# zakázat formát SVG/WebP/AVIF*<br>
*// Ve verzi Firefox 80 je formát AVIF ve výchozím nastavení vypnutý.*<br>
**user\_pref("svg.disabled", true);**<br>
**user\_pref("image.webp.enabled", false);**<br>
**user\_pref("image.avif.enabled", false);**

### Uživatelské rozhraní (kromě panelů a adresní řádky)

*# nezmenšovat samostatný obrázek, aby se vešel do okna prohlížeče*<br>
*// Tato volba se týká situace, kdy v prohlížeči otevřete přímo obrázek (tzn. ne stránku s obrázkem). Mezi zmenšením a stoprocentní velikostí lze v takovém případě přepnout kliknutím myší, tato volba nastavuje, který stav bude výchozí.*<br>
**user\_pref("browser.enable\_automatic\_image\_resizing", false);**

### Tisk

*# tisknout i barvu pozadí*<br>
**user\_pref("print.print\_bgcolor", true);**

*# tisknout i obrázky na pozadí*<br>
**user\_pref("print.print\_bgimages", true);**

*# při tisku nezobrazovat dialog s volbami, ale přímo tisknout*<br>
**user\_pref("print.always\_print\_silent", true);**

### Vyrovnávací paměť

*# vypnout vyrovnávací paměť na disku/v RAM*<br>
**user\_pref("browser.cache.disk.enable", false);**<br>
**user\_pref("browser.cache.memory.enable", false);**

*# velikost vyrovnávací paměti v RAM (dynamicky/pevná velikost/příklad)*<br>
**user\_pref("browser.cache.memory.capacity", -1);**<br>
**user\_pref("browser.cache.memory.capacity",** {*kilobajtů*}**);**<br>
**user\_pref("browser.cache.memory.capacity", 4096);** ⊨ 4 MB

*# v anonymním režimu zabrání ukládání videa a zvuku na disk*<br>
**user\_pref("browser.privatebrowsing.forceMediaMemoryCache", true);**

### Výchozí barvy

*# výchozí barva nenavštíveného/navštíveného/aktivního odkazu*<br>
**user\_pref("browser.anchor\_color", "#**{*RRGGBB*}**");**<br>
**user\_pref("browser.visited\_color", "#**{*RRGGBB*}**");**<br>
**user\_pref("browser.active\_color", "#**{*RRGGBB*}**");**

*# výchozí barva textu/pozadí*<br>
?<br>
?

*# zakázat stránkám nastavovat barvy textu a pozadí*<br>
**user\_pref("browser.display.document\_color\_use", 2);**

### Webrender

*# zapnout jádro Webrender namísto Gecko*<br>
**user\_pref("gfx.webrender.enabled", true);**<br>
**user\_pref("gfx.webrender.force-disabled", false);**<br>
**user\_pref("gfx.webrender.all", true);**

*# vypnout Webrender*<br>
**user\_pref("gfx.webrender.enabled", false);**<br>
[**user\_pref("gfx.webrender.force-disabled", true);**]

### Hlavička „Referer“

<!--
https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referer
-->

*# vypnout zasílání*<br>
**user\_pref("network.http.sendRefererHeader", 0);**

*# neposílat při načítání obrázků*<br>
**user\_pref("network.http.sendRefererHeader", 1);**

*# místo skutečné adresy stránky posílat cílové URL*<br>
**user\_pref("network.http.referer.spoofSource", true);**


### Ostatní

*# kopírovat do schránky jen text (ne obrázky, formátování apod.)*<br>
**user\_pref("clipboard.plainTextOnly", true);**

<!--


### Volby k prozkoumání (zatím nezkoušené)

<!- -
Další:

[ ] permissions.default.*
[ ] browser.discovery.enabled
- ->

*# vypnout uspávání neaktivních panelů*<br>
**user\_pref("dom.suspend\_inactive.enabled", false);**
<!- -
[ ] vyzkoušet
- ->

*# vynutit možnost zvětšovat či zmenšovat stránku (nezkoušeno)*<br>
**user\_pref("browser.ui.zoom.force-user-scalable", true);**

*# ?*<br>
**user\_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);**<br>
**user\_pref("browser.newtabpage.activity-stream.telemetry", false);**<br>
**user\_pref("device.sensors.enabled", false);**

*# WebVR API, obrázky AVIF*<br>
**user\_pref("dom.vr.enabled", false);**<br>
<!- -
na linuxu zatím ve výchozím stavu vypnuto
- ->

*# ?*<br>
**user\_pref("app.update.auto", false);**

*# výchozí barva pozadí(?)*<br>
**user\_pref("browser.display.background\_color", "#**{*RRGGBB*}**");**
// zatím se nezdá, že by fungovala

*# omezit styly jen na základní systémové fonty*<br>
**user\_pref("layout.css.font-visibility.level", 1);**

*# při ukončení prohlížeče automaticky exportovat záložky do formátu HTML (nezkoušeno)*<br>
**user\_pref("browser.bookmarks.autoExportHTML", true);**
<!- -
[ ] zjistit, kam se uloží
- ->

### Historické volby (pravděpodobně zastaralé)

*# vypnout otravnou výzvu k „Refresh Firefox“ (Firefox ≤ 74)*<br>
**user\_pref("browser.disableResetPrompt", true);**

*# vypnout přístup stránek ke stavu baterie (prý pro Firefox ≤ 52)*<br>
**user\_pref("dom.battery.enabled", false);**
<!- -
= disable Navigator.getBattery() API
- ->

-->

## Zaklínadla: userContent.css

### Uživatelský styl

*# nastavit styl pro určitou doménu*<br>
**@-moz-document domain(**{*doména.topleveldoména*}**) {<nic>**<br>
<odsadit1>{*selektor*} **{<nic>** {*pravidla s !important*} **<nic>}**<br>
<odsadit1>[{*další-selektor*} **{<nic>** {*pravidla s !important*} **<nic>}**]...<br>
**<nic>}**

*# nastavit styl pro určitou doménu (příklad)*<br>
**@-moz-document domain(idnes.cz) {<nic>**<br>
<odsadit1>**body {background:#999999 !important;}**<br>
**<nic>}**

*# nastavit barvu prázdného panelu (obecně/příklad)*<br>
**@-moz-document url(about:blank) {:root {background:** {*barva-pozadí*}**;<nic>}}**<br>
**@-moz-document url(about:blank) {:root {background: #999999;<nic>}}**

### Triky

*# zakázat všem webům omezit výběr textu*<br>
**\* {user-select: auto !important;}**

*# zakázat všem webům obrázky na pozadí*<br>
**\* {background-image: none !important;}**


## Zaklínadla: userChrome.css

### Ostatní

*# skrýt „hamburger menu“*<br>
**\#PanelUI-menu-button {display: none;}**

## Zaklínadla: Ostatní

*# zakázat na YouTube „obraz v obraze“*<br>
*// Nefunguje úplně spolehlivě, ale výrazně sníží pravděpodobnost, že se okno videa objeví.*<br>
!: Nainstalujte si rozšíření „Enhancer for YouTube(TM)“.<br>
!: V jeho nastavení odškrtejte všechna políčka, zejména „Pin the video player when scrolling down the page“.

## Parametry příkazů
![ve výstavbě](../obrázky/ve-výstavbě.png)


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
![ve výstavbě](../obrázky/ve-výstavbě.png)

* Nepodařilo se mi najít fungující způsob, jak nastavit výchozí barvu obyčejného textu a pozadí na webových stránkách; nastavení v Předvolbách (tlačítko „Barvy...“) nemají žádný efekt; pozadí je stále bílé. Nastavení v userContent.css se zase aplikuje i na SVG obrázky a velké množství ikon v rozhraní Firefoxu, což ho činí prakticky nepoužitelným.

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

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
