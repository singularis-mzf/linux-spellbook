<!--

Linux Kniha kouzel, kapitola Správa balíčků
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Správa balíčků

!Štítky: {tematický okruh}{systém}

## Úvod
Tématem této kapitoly jsou balíčkovací systémy dpkg, apt, PPA, snap a Flatpak používáné
k instalaci a aktualizaci aplikací, knihoven a systémových součástí v distribuci Ubuntu.

Systém „dpkg“ (Debian PacKaGe manager) instaluje do systému balíčky typu .deb,
hlídá, aby byly splněny závislosti mezi instalovanými balíčky,
a eviduje, které soubory v systému patří ke kterému balíčku. Nekomunikuje online.

Systém „apt“ je nadstavbou dpkg, která komunikuje se vzdáleným repozitářem
balíčků typu .deb, stahuje potřebné balíčky a ověřuje jejich pravost.
K instalaci je ovšem předává systému dpkg.

PPA je rozšíření „apt“, které umožňuje pohodlně přidávat mezi vzdálené zdroje apt
repozitáře vývojářů hostované firmou Canonical pro použití v distribuci Ubuntu.
Balíčky z PPA jdou přímo od vývojářů a nejsou po cestě nikým dalším prověřovány,
takže je vhodné používat pouze PPA velmi důvěryhodných vývojářů.

Snap je nový balíčkovací systém firmy Canonical, exkluzivně pro Ubuntu.
Není dobře přijímán linuxovou komunitou.

Flatpak je nový balíčkovací systém založený na sandboxingu a systému práv.
Je primárně určený k online instalaci nejnovějších verzí distribuovaných
programů bez rizika konfiktů mezi různými verzemi knihoven.

Tato kapitola se nezabývá vytvářením balíčků, vytvářením repozitářů ani jejich zrcadel.
Rovněž se (pochopitelně) nezabývá sestavováním programů ze zdrojového kódu
nebo instalací balíčků jiného typu (.rpm, .tar.xz apod.). Do budoucna však možná
pokryje instalaci balíčků typu .rpm s použitím nástroje „alien“.

Tato verze kapitoly nepokrývá offline instalaci Flatpaku.

## Definice

* **Balíček** je soubor obsahující neměnná data aplikace, knihovny apod. a metadata včetně případných závislostí na ostatních balíčcích.
* **Repozitář** je ucelený sklad souvisejících balíčků. Může být dostupný buď online, nebo může být umístněný v systému souborů.

<!--
Offline instalací se rozumí stažení balíčků, jejich přenesení na počítač nepřipojený k síti a instalace tam.
-->

## Zaklínadla (DPKG a APT)

### Instalace a odinstalace
*# aktualizovat informace o dostupných balíčcích (alternativy)*<br>
**sudo aptitude update**<br>
**sudo apt-get update**

*# aktualizovat všechny aktualizovatelné balíčky (normálně/drasticky)*<br>
**sudo apt-get upgrade** [**-y**] [**\-\-autoremove** [**\-\-purge**]]<br>
**sudo apt-get dist-upgrade** [**-y**] [**\-\-autoremove** [**\-\-purge**]]

*# nainstalovat nový balíček (včetně závislostí)*<br>
**sudo apt-get install** [**-y**] [**\-\-no-install-recommends**] [**\-\-install-suggests**] [**-V**] {*balíček*}...

*# aktualizovat jen konkrétní balíčky a jejich závislosti*<br>
**sudo apt-get install \-\-only-upgrade** {*balíček*}...

*# pokusit se napravit poškozené závislosti*<br>
**sudo apt-get install \-\-fix-broken**

### Informace o balíčcích

*# vypsat všechny dostupné balíčky*<br>
**egrep -h ^Package: /var/lib/apt/lists/\*\_Packages \| cut -d " " -f 2- \| LC\_ALL=C sort -u**

*# vypsat všechny nainstalované balíčky (pro člověka/pro skript)*<br>
**apt list \-\-installed**<br>
**(apt-mark showauto; apt-mark showmanual) \| LC\_ALL=C sort -u**

*# vypsat podrobné informace o balíčku*<br>
**apt-cache show** {*balík*}...

*# vypsat všechny známé (nainstalované nebo dostupné) balíčky*<br>
**apt-cache pkgnames**
<!--
[ ] nevypíše i nainstalované, ale nedostupné balíčky?
Problém: nevypíše balíčky pro každou architekturu; nahradit za apt-cache search ""
-->

*# vypsat závislosti balíčku*<br>
**apt-cache depends** {*balík*}...






*# vypsat balíčky předinstalované nebo instalované ručně*<br>
**apt-mark showmanual**

*# vypsat balíčky instalované jen jako závislosti jiných balíčků*<br>
**apt-mark showauto**




*# označit balíček jako instalovaný ručně*<br>
**sudo apt-mark auto** {*balíček*}...

*# označit balíček jako instalovaný automaticky*<br>
**sudo apt-mark manual** {*balíček*}...


### Zákaz aktualizace

*# zakázat instalaci či aktualizaci balíčku*<br>
**sudo apt-mark hold** {*balíček*}...

*# vypsat zákazy instalace či aktualizace balíčků*<br>
**apt-mark showhold**

*# zrušit zákaz instalace či aktualizace balíčku*<br>
**sudo apt-mark unhold** {*balíček*}...

### Ostatní

*# zjistit hodnotu konfigurační volby APT*<br>
**apt-config dump** {*volba*}...



<!--
Viz https://askubuntu.com/questions/99834/how-do-you-see-what-packages-are-available-for-update
Viz https://www.debian.org/doc/manuals/aptitude/ch02s04s05.en.html
Zejm.:
aptitude search --disable-columns -F %p "?upgradable"
-->

*# vypsat balíčky, pro které je dostupný upgrade (pro člověka/pro skript)*<br>
**apt list \-\-upgradable**<br>
**aptitude search \-\-disable-columns -F %p "?upgradable"**
<!--
[ ] I pokud jsou zablokované?
-->


*# přidat do zdrojů nový repozitář/odebrat repozitář*<br>
**sudo add-apt-repository '**{*řádek sources.list*}**'**<br>
**sudo add-apt-repository -r '**{*řádek sources.list*}**'**


### PPA

*# přidat do zdrojů nové PPA/odebrat PPA*<br>
**sudo add-apt-repository** [**-y**] **ppa:**{*id-vývojáře*}**/**{*id-repozitáře*}<br>
**sudo add-apt-repository -r** [**-y**] **ppa:**{*id-vývojáře*}**/**{*id-repozitáře*}

*# vypsat seznam aktivních PPA*<br>
**egrep -shx '\\s\*deb(\\\[\[^\]\]\*\\\])?\\s\*http://ppa.launchpad.net/.\*' /etc/apt/sources.list /etc/apt/sources.list.d/\*.list \| cut -d / -f 4,5 \| sed 's/.\*/ppa:&amp;/' \| LC\_ALL=C sort -u**

*# vypsat seznam balíčků dostupných z určitého PPA*<br>
?

### Správá důvěryhodných klíčů

*# přidat klíč jako důvěryhodný (ze souboru/ze standardního vstupu)*<br>
**sudo apt-key add** {*soubor*}<br>
**sudo apt-key add -**

*# odstranit klíč ze seznamu důvěryhodných*<br>
**sudo apt-key del** {*id-klíče*}

*# vypsat seznam důvěryhodných klíčů (pro člověka, ne pro skript)*<br>
**apt-key list**

### Offline provoz APT

*# updatovat databázi (poprvé)*<br>
*// Příkazy „get“ se provádějí na online počítači a stáhnout vše, co je potřeba, do uvedeného archivu typu zip, příkazy „set“ a „install“ se spouštějí na offline počítači.*<br>
**sudo apt-offline set pozadavek.sig \-\-update**<br>
**sudo apt-offline get pozadavek.sig \-\-generate-changelog \-\-bundle pozadavek.zip**<br>
**sudo apt-offline install pozadavek.zip**

*# provést „upgrade“*<br>
**sudo apt-offline set pozadavek.sig**<br>
**sudo apt-offline get pozadavek.sig \-\-generate-changelog \-\-bundle pozadavek.zip**<br>
**sudo apt-offline install pozadavek.zip**

*# nainstalovat balíčky*<br>
**sudo apt-offline set pozadavek.sig \-\-install-packages** {*balíček*} [{*další-balíček*}]...<br>
**sudo apt-offline get pozadavek.sig \-\-generate-changelog \-\-bundle pozadavek.zip**<br>
**sudo apt-offline install pozadavek.zip**<br>
**sudo apt-get install** {*balíček*} [{*další-balíček*}]...

### Odklonění

*# odklonit soubor do nového umístění*<br>
**sudo dpkg-divert \-\-local** [**\-\-move**] **\-\-divert** {*/nové/umístění*} {*/původní/umístění*}

*# zrušit odklon souboru*<br>
**sudo dpkg-divert \-\-remove** {*/původní*}

*# vypsat seznam odklonů*<br>
**dpkg-divert \-\-list \\\***

*# odklonit soubor pro všechny balíky kromě zadaného*<br>
**sudo dpkg-divert \-\-package** {*balík*} [**\-\-move**] **\-\-divert** {*/nové/umístění*} {*/původní/umístění*}

### ...

*# vypsat seznam nainstalovaných balíků včetně verzí (pro člověka/pro skript)*<br>
**dpkg-query -l** [**\| less**]<br>
**dpkg-query -Wf '${Package}:${Architecture}/${Version}/${db:Status-Status}\n'** [**'**{*vzorek*}**'**] **\| egrep '/installed$'**

*# vypsat seznam souborů a adresářů v systému, které kontroluje daný balíček*<br>
*// Poznámka: Ve výpisu se typicky objevují také společné adresáře jako /etc či /usr; není příliš spolehnutí na to, že jde pouze o soubory příslušné danému balíku.*<br>
**dpkg-query -L** {*balíček*}
<!--
[ ] Otestovat, jak reaguje na odklonění.
-->

*# vypsat seznam balíčků, kterým přísluší soubory s cestami odpovídající danému vzorku*<br>
**dpkg-query -S** {*vzorek*}

*# vypsat balíček (popř. balíčky) vlastnící určitý příkaz*<br>
**test -e "$(which **{*příkaz*}**)" &amp;&amp; (dpkg-query -S "$(which **{*příkaz*}**)" \| cut -d : -f 1)**
echi
## Zaklínadla (Flatpak)

<!--
https://flatpak.org/setup/Ubuntu/

Offline instalace:
https://unix.stackexchange.com/questions/404905/offline-install-of-a-flatpak-application

Single file bundle:
http://docs.flatpak.org/en/latest/single-file-bundles.html
-->

*# spustit program z balíčku*<br>
**flatpak run** {*balíček*} {*parametry*}

*# instalovat balíček*<br>
**flatpak install** [{*server*}] {*balíček*}

*# odinstalovat balíček*<br>
**flatpak uninstall** {*balíček*}

*# vypsat nainstalované balíčky*<br>
**flatpak list**

*# vypsat výchozí práva aplikace*<br>
**flatpak info \-\-show-permissions** {*balíček*}

*# vypsat podrobnější informace o balíčku (nainstalovaném/dostupném)*<br>
*// Uvedení verze k balíčku je povinné, pokud je v repozitáři víc verzí téhož balíčku. Bez něj v takovém případě příkaz „flathub remote-info“ selže a vypíše dostupné verze.*<br>
**flatpak info** {*balíček*}<br>
**flatpak remote-info flathub** {*balíček*}[**//**{*verze*}]

*# hledat dostupné balíčky podle podřetězce*<br>
**flatpak search** {*podřetězec*}

*# vypsat všechny dostupné balíčky aplikací/úplně všechny dostupné balíčky*<br>
**flatpak remote-ls \-\-app flathub**<br>
**flatpak remote-ls \-\-all flathub**

*# spustit program z balíčku bez přístupu k síti*<br>
**flatpak run \-\-unshare=network** {*balíček*}

*# spustit GIMP s přístupem jen ke čtení k většině systému souborů*<br>
*// K provedení tohoto příkazu musíte mít daný balíček nainstalovaný.*<br>
**flatpak run \-\-nofilesystem=host \-\-filesystem=host:ro org.gimp.GIMP**

<!--
### Flatpak (offline instalace)

*# příprava (online počítač)*<br>
**sudo flatpak remote-modify \-\-collection-id=org.flathub.Stable flathub**<br>
**wget "https://flathub.org/repo/flathub.flatpakrepo"**

*# příprava (offline počítač)*<br>
**


*# stáhnout balíček*<br>
**flatpak update**<br>
**flatpak create-usb ./docasny** {*balíček*}<br>
**flatpak build-bundle ./docasny** {*jméno-souboru*}**.flatpak** {*balíček*}

*# nainstalovat balíček*<br>
?
-->

### Flatpak (správa vzdálených repozitářů)

*# přidat FlatHub*<br>
**flatpak remote-add \-\-if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo**

*# přidat repozitář*<br>
**flatpak remote-add** [**\-\-if-not-exists**] {*id-pro-repozitář*} {*URL*}

*# odebrat repozitář*<br>
**flatpak remote-delete** {*id-repozitáře*}

*# vypsat seznam repozitářů*<br>
**flatpak remotes**

## Zaklínadla (snap)

*# spustit program z balíčku*<br>
**snap run** {*balíček*}

*# instalovat balíček*<br>
**sudo snap install** [**\-\-**{*kanál*}] {*balíček*}...

*# odinstalovat balíček*<br>
**sudo snap remove** {*balíček*}...

*# vypsat nainstalované balíčky*<br>
**snap list**

*# vypsat podrobnější informace o balíčku*<br>
**snap info** {*balíček*}

*# deaktivovat balíček/znovu ho aktivovat*<br>
**sudo snap disable** {*balíček*}<br>
**sudo snap enable** {*balíček*}

*# ručně připojit konektor balíčku do slotu jiného balíčku/rozpojit spojení*<br>
**sudo snap connect** {*balíček*}**:**{*jeho-konektor*} {*jiný-balíček*}**:**{*jeho-slot*}<br>
**sudo snap disconnect** {*balíček*}**:**{*konektor-nebo-slot*}

*# stáhnout balíček k offline instalaci*<br>
*// Kanál může být: edge, beta, candidate nebo stable.*<br>
*// Poznámka: tento příkaz stáhne pouze uvedený balíček, ne však jeho závislosti.*<br>
**snap download** [**\-\-**{*kanál*}] {*balíček*}

*# nainstalovat balíček offline*<br>
*// Pokud má balíček závislosti na dalších balíčcích, je potřeba nejprve nainstalovat je, jinak se je bude se snap-démon nainstalovat online.*<br>
**sudo snap ack** {*soubor\_s\_balíčkem.assert*}<br>
**sudo snap install** {*soubor\_s\_balíčkem.snap*}

*# vypsat seznam všech dostupných balíčků*<br>
*// Poznámka: provedení tohoto příkazu může trvat i několik minut a vzhledem k velkému rozsahu vypsaných informací doporučuji výstup přesměrovat do souboru.*<br>
**(for X in {a..z} {0..9}; do snap find** [**\-\-narrow**] **$X \| sed 1d; done) \| tr -s "&blank;" \| sort -iu \| sed "$(printf "%s/&blank;/\\\\\|/\\\\n" s s s)" \| column -ts \\\|** [**&gt;** {*soubor*}]

*# vypsat spojení konektorů a slotů (všech/jen spojených)*<br>
**snap connections \-\-all**<br>
**snap connections**

*# vrátit balíček do stavu před posledním upgradem na novou verzi (neověřeno)*<br>
**sudo snap revert** {*balíček*}

<!--
## Parametry příkazů
<!- -
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
- ->
![ve výstavbě](../obrazky/ve-vystavbe.png)
-->

## Instalace na Ubuntu

*# Příkaz „aptitude“*<br>
**sudo apt-get install aptitude**

*# Flatpak*<br>
**sudo add-apt-repository ppa:alexlarsson/flatpak**<br>
**sudo aptitude update**<br>
**sudo apt-get install flatpak** [**gnome-software-plugin-flatpak**]<br>
**flatpak remote-add \-\-if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo**<br>
!: Restartujte operační systém.

*# Pro umožnění uživatelské instalace (parametr \-\-user) spusťte z účtu příslušného uživatele navíc:*<br>
**flatpak remote-add \-\-user \-\-if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo**


Snap je základní součástí Ubuntu přítomnou v každé nové instalaci. Je možno ho odinstalovat tímto příkazem:

*# *<br>
**sudo apt-get purge \-\-autoremove snapd**

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

* Co je špatně na snapu: 1) Automatické updatování balíčků, které nelze vypnout. 2) Zatímco klientská část je svobodný software, serverová část je proprietární a může ji provozovat pouze firma Canonical, takže není možné vytvářet zrcadla repozitáře snapů a při instalaci programů jste závislí na připojení do USA.
* Stalo se mi, že u některých snapů nebyla správně vyplněna licence.
* Flatpak přistupuje poměrně benevolentně k přístupovým právům uživatelů. Umožňuje instalovat a odinstalovávat balíčky systémové instalace bez zadání hesla nejen superuživateli, ale také všem uživatelům, kteří jsou členy skupin admin a sudo. Ostatní uživatelům to umožní po zadání hesla administrujícího uživatele, dokonce i přesto, že sami nemají právo používat sudo.

## Jak získat nápovědu
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje (ale neuvádějte konkrétní odkazy, ty patří do sekce „Odkazy“).
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

*# *<br>
**snap \-\-help**<br>
**snap help** {*podpříkaz*}

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
* [stránky TL;DR](https://github.com/tldr-pages/tldr/tree/master/pages/common)
