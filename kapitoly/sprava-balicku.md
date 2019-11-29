<!--

Linux Kniha kouzel, kapitola Správa balíčků
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:
[ ] Pokračovat v dpkg-*
-->

# Správa balíčků

!Štítky: {tematický okruh}{systém}

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

<!--
Offline instalací se rozumí stažení balíčků, jejich přenesení na počítač nepřipojený k síti a instalace tam.
-->

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

*# aktualizovat informace o dostupných balíčcích*<br>
**sudo apt-get update**

*# aktualizovat všechny aktualizovatelné balíčky*<br>
**sudo apt-get upgrade** [**-y**] [**\-\-autoremove** [**\-\-purge**]]

*# nainstalovat nový balíček (včetně závislostí)*<br>
**sudo apt-get install** [**-y**] [**\-\-no-install-recommends**] [**\-\-install-suggests**] [**-V**] {*balíček*}...

*# aktualizovat jen konkrétní balíčky a jejich závislosti*<br>
**sudo apt-get install \-\-only-upgrade \-\-with-new-pkgs** {*balíček*}...
<!--
[ ] vyzkoušet
-->

*# pokusit se napravit poškozené závislosti*<br>
**sudo apt-get install \-\-fix-broken**


*# zjistit hodnotu konfigurační volby APT*<br>
**apt-config dump** {*volba*}...

*# vypsat podrobné informace o balíku*<br>
**apt-cache show** {*balík*}...

*# vypsat všechny známé (nainstalované nebo dostupné) balíčky*<br>
**apt-cache pkgnames**
<!--
[ ] nevypíše i nainstalované, ale nedostupné balíčky?
Problém: nevypíše balíčky pro každou architekturu; nahradit za apt-cache search ""
-->

*# vypsat všechny dostupné balíčky*<br>
**egrep -h ^Package: /var/lib/apt/lists/\*\_Packages \| cut -d " " -f 2- \| LC\_ALL=C sort -u**

*# vypsat všechny nainstalované balíčky (pro člověka/pro skript)*<br>
**apt list \-\-installed**<br>
**(apt-mark showauto; apt-mark showmanual) \| LC\_ALL=C sort -u**

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


*# vypsat závislosti balíčku*<br>
**apt-cache depends** {*balík*}...

*# přidat do zdrojů nový repozitář/odebrat repozitář*<br>
**sudo add-apt-repository 'deb** {*adresa*} {*jméno-repozitáře*} {*sekce*}...**'**<br>
?

*# přidat do zdrojů nový PPA/odebrat PPA*<br>
**sudo add-apt-repository -y ppa://**{*ppa-uživatel*}**/**{*ppa-repozitář*}<br>
**sudo add-apt-repository -ry ppa://**{*ppa-uživatel*}**/**{*ppa-repozitář*}

*# vypsat balíčky předinstalované nebo instalované ručně*<br>
**apt-mark showmanual**

*# vypsat balíčky instalované jen jako závislosti jiných balíčků*<br>
**apt-mark showauto**

*# označit balíček jako instalovaný ručně*<br>
**sudo apt-mark auto** {*balíček*}...

*# označit balíček jako instalovaný automaticky*<br>
**sudo apt-mark manual** {*balíček*}...

*# zakázat instalaci či aktualizaci balíčku*<br>
**sudo apt-mark hold** {*balíček*}...

*# zrušit zákaz instalace či aktualizace balíčku*<br>
**sudo apt-mark unhold** {*balíček*}...

*# vypsat zákazy instalace či aktualizace balíčků*<br>
**apt-mark showhold**


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

### Flatpak

<!--
https://flatpak.org/setup/Ubuntu/

Offline instalace:
https://unix.stackexchange.com/questions/404905/offline-install-of-a-flatpak-application

Single file bundle:
http://docs.flatpak.org/en/latest/single-file-bundles.html
-->

*# instalovat balíček*<br>
**sudo flatpak install \-\-system** [{*server*}] {*balíček*}

*# instalovat balíček jen pro tohoto uživatele*<br>
**flatpak install \-\-user** [{*server*}] {*balíček*}

*# vypsat všechny dostupné balíčky*<br>
**flatpak search ""**

### Snap

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

*# Aptitude*<br>
**sudo apt-get install aptitude**

*# Flatpak*<br>
**sudo add-apt-repository ppa:alexlarsson/flatpak**<br>
**sudo aptitude update**<br>
**sudo apt-get install flatpak** [**gnome-software-plugin-flatpak**]<br>
**sudo flatpak remote-add \-\-if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo**<br>
!: Restartujte operační systém.

Snap je základní součástí Ubuntu přítomnou v každé nové instalaci. Je možno ho odinstalovat tímto příkazem:

*# *<br>
**sudo apt-get purge snapd**

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

*# *<br>
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
