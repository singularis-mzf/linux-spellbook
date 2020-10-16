<!--

Linux Kniha kouzel, kapitola Správa balíčků
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
[x] dpkg-deb (!)
[ ] dpkg-reconfigure
[ ] snap saved
[ ] snap forget <balíček>
[ ] snap remove <balíček> --purge
[ ] snap changes
[ ] sudo snap set refresh.hold='...'
[ ] sudo snap get refresh.hold
[ ] prozkoumat „apt search“ a „apt-cache search“
-->

# Správa balíčků

!Štítky: {tematický okruh}{systém}{apt}{Snap}{Flatpak}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tématem této kapitoly jsou balíčkovací systémy dpkg, apt, PPA, Flatpak a Snap, používáné
k instalaci a aktualizaci aplikací, knihoven a systémových součástí v distribuci Ubuntu.

Systém „dpkg“ (Debian PacKaGe manager) instaluje do systému balíčky typu .deb,
hlídá, aby byly splněny závislosti mezi nimi, a eviduje, které soubory v systému
patří ke kterému balíčku; díky tomu je umí také odinstalovat. Nekomunikuje online.

Systém „apt“ (Advanced Packaging Tool) je nadstavbou dpkg, která komunikuje se vzdáleným
repozitářem balíčků typu .deb, stahuje potřebné balíčky a ověřuje jejich pravost.
K instalaci je ovšem předává systému dpkg.

PPA je rozšíření „apt“, které umožňuje pohodlně přidávat mezi vzdálené zdroje apt
repozitáře konkrétních vývojářů hostované firmou Canonical pro použití v distribuci Ubuntu.
Balíčky z PPA jdou přímo od vývojářů a nejsou po cestě nikým dalším prověřovány,
takže je vhodné používat pouze PPA velmi důvěryhodných vývojářů.

Flatpak je nový, moderní balíčkovací systém založený na sandboxingu a systému práv.
Představuje dobrý, bezpečný a pohodlný způsob, jak na staré, ověřené verzi systému
provozovat nejnovější verze vybraných programů.

Snap je nový balíčkovací systém firmy Canonical. Není dobře přijímán linuxovou komunitou
z mnoha důvodů, především proto, že serverová část systému (repozitář) je proprietární
(nesvobodná) a výhradně závislá na firmě Canonical; není možné vytvářet jiné repozitáře
Snapu ani Snap nastavit tak, aby s firmou Canonical nekomunikoval.

Tato kapitola se nezabývá vytvářením balíčků, vytvářením repozitářů ani jejich zrcadel
(pro zrcadla zkuste např. [aptly](https://www.aptly.info/)) (anglicky).
Rovněž se (pochopitelně) nezabývá sestavováním programů ze zdrojového kódu
nebo instalací balíčků jiného typu (.rpm, .tar.xz apod.).

Tato verze kapitoly nepokrývá offline instalaci balíčků Flatpaku a až na výjimky
nepokrývá uživatelské nastavení práv aplikací ve Flathubu (výchozí nastavení práv
určuje dodavatel aplikace, ale uživatel může práva aplikace zúžit nebo rozšířit).

## Definice

* **Balíček** je soubor obsahující neměnná data tvořící aplikaci, knihovnu apod. a metadata včetně případných závislostí na ostatních balíčcích.
* **Repozitář** je ucelený sklad souvisejících balíčků. Může být dostupný buď online, nebo může být umístěný v systému souborů. Repozitář APT má svůj **název** (v Ubuntu typicky „ubuntu“) a dělí se na **archivy** („focal“, „focal-updates“, „focal-security“ atd.) a ty se dělí na **sekce** („main“, „universe“, „restricted“ a „multiverse“). Sekce main obsahuje svobodný software přímo podporovaný jsou součást Ubuntu, sekce „universe“ obsahuje svobodný software udržovaný pouze komunitou, sekce „restricted“ obsahuje nesvobodný software považovaný za podporovanou součást Ubuntu (typicky proprietární ovladače) a sekce „multiverse“ obsahuje nesvobodný software neudržovaný komunitou. Sekce se dále dělí na **podsekce** podle druhu softwaru.
* Balíček je **dostupný**, pokud kterýkoliv v systému nakonfigurovaný repozitář nabízí balíček daného názvu a architektury. Balíček je **známý**, pokud je dostupný nebo v systému nainstalovaný.

<!--
Offline instalací se rozumí stažení balíčků, jejich přenesení na počítač nepřipojený k síti a instalace tam.
-->

!ÚzkýRežim: vyp

## Zaklínadla: DPKG a APT

### Aktualizace

*# aktualizovat informace o **dostupných** balíčcích (alternativy)*<br>
**sudo aptitude update**<br>
**sudo apt-get update**

*# **aktualizovat** všechny aktualizovatelné balíčky (alternativy)*<br>
*// Tyto příkazy při aktualizaci vynechají balíčky, které by svou aktualizací způsobily odstranění jiných balíčků. Pokud chcete aktualizovat i takové balíčky, použijte „drastickou aktualizaci“.*<br>
**sudo apt-get upgrade** [**-y**] <nic>[**\-\-autoremove** [**\-\-purge**]]<br>
**sudo aptitude** [**-y**] <nic>[**\-\-no-new-installs**] **safe-upgrade**

*# drasticky **aktualizovat** všechny aktualizovatelné balíčky (alternativy)*<br>
**sudo apt-get dist-upgrade** [**-y**] <nic>[**\-\-autoremove** [**\-\-purge**]]<br>
**sudo aptitude** [**-y**] **full-upgrade**

*# aktualizovat jen konkrétní balíčky a jejich závislosti*<br>
**sudo apt-get install \-\-only-upgrade** {*balíček*}...

*# pokusit se napravit poškozené závislosti*<br>
**sudo apt-get install \-\-fix-broken**

### Instalace a odinstalace

*# **nainstalovat** nový balíček včetně závislostí (vzdálený balíček/lokální soubor)*<br>
**sudo apt-get install** [**-y**] <nic>[**\-\-no-install-recommends**] <nic>[**\-\-install-suggests**] <nic>[**-V**] {*balíček*}...<br>
**sudo apt-get install** [**-y**] <nic>[**\-\-no-install-recommends**] <nic>[**\-\-install-suggests**] <nic>[**-V**] **./**{*balíček.deb*}...

*# **odinstalovat** balíček (celosystémové konfigurační soubory smazat/ponechat)*<br>
*// Ponechat celosystémové konfigurační soubory má smysl v případě, že chcete zachovat konfiguraci balíčku pro případ, že byste ho v budoucnu znovu nainstaloval/a. Uživatelskou konfiguraci programů (uloženou v domovských adresářích) APT ani DPKG odstranit neumí.*<br>
**sudo apt-get purge** [**\-\-autoremove**] {*balíček*}...<br>
**sudo apt-get remove** [**\-\-autoremove**] {*balíček*}...

*# přeinstalovat (**opravit**) již nainstalovaný balíček*<br>
**sudo apt-get reinstall** {*balíček*}...

*# nainstalovat či aktualizovat zvolené balíčky a současně aktualizovat ostatní*<br>
**sudo apt-get upgrade** [**-y**] **&amp;&amp; sudo apt-get install** [**-y**] <nic>[**\-\-autoremove** [**\-\-purge**]] {*balíček*}...

*# **stáhnout** balíčky do lokálních souborů .deb (bez závislostí/se závislostmi)*<br>
**apt-get download** {*balíček*}...<br>
?

### Seznamy balíčků

*# vypsat **známé** balíčky (pro člověka)*<br>
**apt list**

*# vypsat všechny známé balíčky pro všechny architektury*<br>
**aptitude search '?true'**

*# vypsat známé balíčky, filtrovat na základě kritérií*<br>
**aptitude** [**-F** {*formát*}] **search '**{*vyhledávací podmínka*}**'** [**'**{*další vyhledávací podmínka*}**'**]...

*# vypsat **všechny dostupné balíčky** (včetně dostupných verzí, pouze pro hlavní architekturu)*<br>
**aptitude search \-\-disable-columns -F $'%p\\t%V' '?true' \| egrep -v $'[^\\t]\*:[<nic>^\\t]|[<nic>^\\t]\*\\t&lt;[<nic>^\\t]\*&gt;(\\t\|$)'**

*# vypsat seznam **nainstalovaných balíčků** včetně verzí (pro člověka – alternativy)*<br>
**apt list \-\-installed**<br>
**dpkg-query -l** [**\| less**]<br>

*# vypsat seznam **nainstalovaných balíčků** (pro skript – alternativy)*<br>
**dpkg-query -Wf '${Package}:${Architecture}/${Version}/${db:Status-Status}\\n'** [**'**{*vzorek*}**'**] **\| egrep '/installed$'**<br>
**(apt-mark showauto; apt-mark showmanual) \| LC\_ALL=C sort -u**<br>
**aptitude \-\-disable-columns -F** {*formát*} **search '?installed'**

*# vypsat seznam nainstalovaných balíčků podle místa zabraného na disku; od největšího po nejmenší (pro člověka)*<br>
*// Velikosti jsou uvedeny v kilobajtech.*<br>
**dpkg-query -Wf '${Installed-Size}\\t${Package}:${Architecture}\\n' | sort -nr | less**

*# vypsat balíčky, pro které je dostupný upgrade (pro člověka/pro skript)*<br>
*// Poznámka: vypíše i balíčky, jejichž upgrade není možný např. kvůli konfliktu s jiným balíčkem.*<br>
**apt list \-\-upgradable**<br>
**aptitude search \-\-disable-columns -F %p "?upgradable"**
<!--
Viz https://askubuntu.com/questions/99834/how-do-you-see-what-packages-are-available-for-update
Viz https://www.debian.org/doc/manuals/aptitude/ch02s04s05.en.html
Zejm.:
aptitude search --disable-columns -F %p "?upgradable"
-->

*# vypsat balíčky, které by se skutečně upgradovaly*<br>
**sudo apt-get upgrade \-\-simulate \| egrep "^Inst&blank;"**

*# vypsat nainstalovaný balíček vlastnící určitý příkaz*<br>
**test -e "$(which **{*příkaz*}**)" &amp;&amp; (dpkg-query -S "$(which **{*příkaz*}**)" \| cut -d : -f 1)**

*# vypsat seznam balíčků (nainstalovaných/dostupných), kterým přísluší určitý soubor*<br>
**dpkg-query -S** {*vzorek*}<br>
**apt-file search -F "**{*/celá/cesta*}**"**

### Podrobné informace o balíčku

*# vypsat podrobné informace o balíčku (dostupném/staženém)*<br>
**apt-cache show** {*balíček*}...<br>
**dpkg-deb \-\-info** {*cesta/balíček.deb*}

*# vybalit z balíčku soubory/řídicí soubory*<br>
*// Tip: k manipulaci se soubory v balíčku můžete také použít parametr \-\-fsys-tarfile, který na standardní výstup příkazu vypíše soubory balíčku ve formátu „tar“, který můžete předat rourou příkazu „tar“.*<br>
**dpkg-deb -x** {*cesta/balíček.deb*} {*adresář/k/vytvoření*}<br>
**dpkg-deb -e** {*cesta/balíček.deb*} {*adresář/k/vytvoření*}

*# kolik místa na disku zabírá balíček? (pro člověka)*<br>
**aptitude search -F %I '?name(**{*balíček*}**)' \| head -n1**

*# vypsat seznam souborů a adresářů v systému, které kontroluje daný (nainstalovaný/dostupný/stažený) balíček*<br>
*// Poznámka: Ve výpisu „dpkg-query -L“ se typicky objevují také společné adresáře jako /etc či /usr; není příliš spolehnutí na to, že jde pouze o soubory příslušné danému balíčku.*<br>
**dpkg-query -L** {*balíček*}<br>
**apt-file list** {*balíček*}...<br>
**dpkg-deb -c** {*cesta/balíček.deb*}
<!--
[ ] Otestovat, jak dpkg-query reaguje na odklonění.
-->

*# vypsat závislosti balíčku*<br>
**apt-cache depends** {*balíček*}...

### Zákaz aktualizace a označení „automaticky“

*# vypsat zákazy instalace či aktualizace balíčku*<br>
**apt-mark showhold**

*# vypsat balíčky předinstalované nebo instalované ručně*<br>
**apt-mark showmanual**

*# vypsat balíčky instalované jen jako závislosti jiných balíčků*<br>
**apt-mark showauto**

*# zakázat instalaci či aktualizaci balíčku/zrušit tento zákaz*<br>
**sudo apt-mark hold** {*balíček*}...<br>
**sudo apt-mark unhold** {*balíček*}...

*# označit balíček jako instalovaný ručně/automaticky*<br>
**sudo apt-mark manual** {*balíček*}...<br>
**sudo apt-mark auto** {*balíček*}...

### PPA

*# **přidat** do zdrojů nové PPA/odebrat PPA*<br>
**sudo add-apt-repository** [**-y**] **ppa:**{*id-vývojáře*}**/**{*id-repozitáře*}<br>
**sudo add-apt-repository -r** [**-y**] **ppa:**{*id-vývojáře*}**/**{*id-repozitáře*}

*# **vypsat** seznam aktivních PPA*<br>
**egrep -shx '\\s\*deb(\\\[\[<nic>^\]\]\*\\\])?\\s\*http://ppa.launchpad.net/.\*' /etc/apt/sources.list /etc/apt/sources.list.d/\*.list \| cut -d / -f 4,5 \| sed -E 's/.\*/ppa:&amp;/' \| LC\_ALL=C sort -u**

*# vypsat seznam balíčků dostupných z určitého PPA*<br>
?

### Jádra

*# vypsat seznam **nainstalovaných** jader*<br>
**linux-version list**

*# vypsat seznam dostupných jader*<br>
?

### Správa důvěryhodných klíčů

*# **přidat** klíč jako důvěryhodný (ze souboru/ze standardního vstupu)*<br>
**sudo apt-key add** {*soubor*}<br>
**sudo apt-key add -**

*# **odstranit** klíč ze seznamu důvěryhodných*<br>
**sudo apt-key del** {*id-klíče*}

*# **vypsat** seznam důvěryhodných klíčů (pro člověka, ne pro skript)*<br>
**apt-key list**

### Offline provoz APT

*# aktualizovat údaje o dostupných balíčcích (poprvé)*<br>
*// Příkazy „get“ se provádějí na online počítači a stáhnout vše, co je potřeba, do uvedeného archivu typu zip, příkazy „set“ a „install“ se spouštějí na offline počítači.*<br>
**sudo apt-offline set pozadavek.sig \-\-update**<br>
**sudo apt-offline get pozadavek.sig \-\-generate-changelog \-\-bundle pozadavek.zip**<br>
**sudo apt-offline install pozadavek.zip**

*# **aktualizovat** všechny balíčky*<br>
**sudo apt-offline set pozadavek.sig**<br>
**sudo apt-offline get pozadavek.sig \-\-generate-changelog \-\-bundle pozadavek.zip**<br>
**sudo apt-offline install pozadavek.zip**<br>
**sudo apt-get upgrade** [**-y**]

*# **nainstalovat** nové balíčky*<br>
**sudo apt-offline set pozadavek.sig \-\-install-packages** {*balíček*} [{*další-balíček*}]...<br>
**sudo apt-offline get pozadavek.sig \-\-generate-changelog \-\-bundle pozadavek.zip**<br>
**sudo apt-offline install pozadavek.zip**<br>
**sudo apt-get install** {*balíček*} [{*další-balíček*}]...

### Odklonění

*# **odklonit** soubor do nového umístění*<br>
**sudo dpkg-divert \-\-local** [**\-\-rename**] **\-\-divert** {*/nové/umístění*} {*/původní/umístění*}

*# **zrušit** odklon souboru*<br>
**sudo dpkg-divert \-\-remove** {*/původní/umístění*}

*# **vypsat** seznam odklonů*<br>
**dpkg-divert \-\-list \\\***

*# odklonit soubor pro všechny balíčky kromě zadaného*<br>
**sudo dpkg-divert \-\-package** {*balíček*} [**\-\-rename**] **\-\-divert** {*/nové/umístění*} {*/původní/umístění*}

### Ostatní

*# vybalit z balíčku DEB soubory programu/řídicí soubory*<br>
*// Pokud zadaný adresář neexistuje, bude vytvořen.*<br>
**dpkg-deb -x** {*balíček.deb*} {*cílový-adresář*}<br>
**dpkg-deb -e** {*balíček.deb*} {*cílový-adresář*}

*# přidat do zdrojů nový repozitář/odebrat repozitář*<br>
**sudo add-apt-repository '**{*řádek sources.list*}**'**<br>
**sudo add-apt-repository -r '**{*řádek sources.list*}**'**

*# zjistit hodnotu konfigurační volby APT*<br>
**apt-config dump** {*volba*}...

*# „velikonoční vajíčko“ v APT*<br>
**apt-get moo**

## Zaklínadla (aptitude)

### Vyhledávací podmínky

*# hledání podle jména balíčku (alternativy)*<br>
**?name("**{*regulární-výraz*}**")**<br>
**?exact-name(**{*přesné-jméno*}**)**

*# hledání podle krátkého popisu balíčku*<br>
**?description("**{*regulární výraz*}**")**

*# hledání podle **architektury***<br>
**?architecture(**{*architektura*}**)**

*# hledání podle archivu balíčku v repozitáři*<br>
**?archive("**{*regulární-výraz*}**")**

*# hledání podle sekce a podsekce v repozitáři*<br>
**?section("**{*regulární-výraz*}**")**

*# jen balíčky instalované ručně/automaticky*<br>
**?and(?installed,?not(?automatic))**<br>
**?automatic**

*# jen nainstalované balíčky*<br>
**?installed**

*# logické operace mezi vzorky*<br>
**?and(**{*vzorek1*}**,**{*vzorek2*}**)**<br>
**?or(**{*vzorek1*}**,**{*vzorek2*}**)**<br>
**?not(**{*vzorek*}**)**

*# balíčky, které by byly odstraněny operací „autoremove“*<br>
**\~g**

*# balíčky, pro které je dostupná novější verze/které mohou být upgradovány*<br>
*// Pozor! Tento filtr zahrne i balíčky, které nemohou být aktualizovány, protože tomu brání konflikt mezi balíčky nebo zákaz jejich instalace! Naopak nezahrnuje balíčky, které budou nově instalovány pouze pro splnění nově vzniklých závislostí. Proto tento filtr není tak praktický, jak by se mohl zdát.*<br>
**?upgradable**<br>
?

*# jen „nové“ balíčky*<br>
**?new**

*# jen „virtuální“ balíčky*<br>
**?virtual**

<!--
?origin(původ) – jen balíčky určitého původu
-->

### Formát -F

Za znakem „=“ následuje příklad hodnoty pro balíček „gimp“.

*# **název** balíčku*<br>
*// Název balíčku jiné než výchozí architektury bude doplněn o architekturu, např. „gimp:i386“.*<br>
**%p = gimp**

*# krátký **popis** balíčku*<br>
**%d = GNU Image Manipulation Program**

*# **architektura***<br>
**%E = amd64**

*# **verze** (instalovaná/dostupná)*<br>
*// Je-li dostupných víc verzí balíčku, parametr %V vybere tu, která by se nejspíš instalovala.*<br>
*// Není-li instalovaná, resp. dostupná žádná verze, tyto parametry vypíšou „&lt;žádná&gt;“ a ignorují snahu o změnu lokalizace. Pro přenositelnost je proto doporučuji ve skriptech testovat proti regulárnímu výrazu „&lt;.\*&gt;“ místo porovnání s konkrétní hodnotou.*<br>
**%v = 2.10.18-1**<br>
**%V = 2.10.18-1**

*# **archiv** balíčku v repozitáři*<br>
*// Je-li dostupných víc verzí balíčku, tento parametr zohledňuje pouze nejnovější verzi. Je-li dostupná ve více archivech, vypíše parametr %t všechny dané archivy oddělené čárkou, typicky např. „focal-security,focal-updates“.*<br>
**%t = focal**

*# **sekce a podsekce** balíčku*<br>
**%s = universe/graphics**

*# velikost balíčku/velikost instalovaných souborů*<br>
**%D = 4 286 kB**<br>
**%I = 20,1 MB**

*# popis původu balíčku*<br>
**%O = Ubuntu:20.04/focal [amd64]**

*# příznak automatické instalace*<br>
*// Pro balíčky instalované jen pro splnění závislosti jiného balíčku vypíše „A“, jinak vypíše prázdný řetězec.*<br>
**%M =**

## Zaklínadla: Flatpak
<!--
https://flatpak.org/setup/Ubuntu/
-->

### Časté úkony

Poznámka: „server“ je v uvedených příkazech zpravidla „flathub“.

*# **spustit** program z balíčku*<br>
**flatpak run** {*balíček*} {*parametry*}

*# **aktualizovat** všechny nainstalované balíčky/jen konkrétní*<br>
**flatpak update**<br>
**flatpak update** {*balíček*}...

*# **instalovat** balíček*<br>
**flatpak install** [{*server*}] {*balíček*}

*# **odinstalovat** balíček*<br>
**flatpak uninstall** {*balíček*}

*# **vypsat** nainstalované balíčky*<br>
**flatpak list**

*# **hledat** dostupné balíčky podle podřetězce*<br>
**flatpak search** {*podřetězec*}

*# vypsat výchozí práva aplikace*<br>
**flatpak info \-\-show-permissions** {*balíček*}

*# vypsat podrobnější informace o balíčku (nainstalovaném/dostupném)*<br>
*// Uvedení verze k balíčku je povinné, pokud je v repozitáři víc verzí téhož balíčku. Bez něj v takovém případě příkaz „flathub remote-info“ selže a vypíše dostupné verze.*<br>
**flatpak info** {*balíček*}<br>
**flatpak remote-info** {*server*} {*balíček*}[**//**{*verze*}]

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

Offline instalace:
https://unix.stackexchange.com/questions/404905/offline-install-of-a-flatpak-application

Single file bundle:
http://docs.flatpak.org/en/latest/single-file-bundles.html
-->

### Správa vzdálených repozitářů

*# přidat **FlatHub***<br>
**flatpak remote-add \-\-if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo**

*# **přidat** repozitář*<br>
**flatpak remote-add** [**\-\-if-not-exists**] {*id-pro-repozitář*} {*URL*}

*# **odebrat** repozitář*<br>
**flatpak remote-delete** {*id-repozitáře*}

*# **vypsat** seznam repozitářů*<br>
**flatpak remotes**

### Offline instalace

*# příprava (na online počítači)*<br>
?

*# instalace (na offline počítači)*<br>
?

## Zaklínadla: Snap

### Instalace, spuštění a odinstalace

*# **spustit** program z balíčku*<br>
**snap run** {*balíček*}

*# **instalovat** balíček*<br>
**sudo snap install** [**\-\-**{*kanál*}] {*balíček*}...

*# **odinstalovat** balíček*<br>
**sudo snap remove** {*balíček*}...

*# vrátit balíček do stavu před posledním upgradem na novou verzi (neověřeno)*<br>
**sudo snap revert** {*balíček*}

### Vypsat balíčky a informace o nich
*# **vypsat** nainstalované balíčky*<br>
**snap list**

*# vypsat seznam všech **dostupných** balíčků*<br>
*// Poznámka: provedení tohoto příkazu může trvat i několik minut a vzhledem k velkému rozsahu vypsaných informací doporučuji výstup přesměrovat do souboru.*<br>
**for x in {a..z} {0..9}; do snap find** [**\-\-narrow**] **$X \| sed 1d; done \| tr -s "&blank;" \| sort -iu \| sed "$(printf '%s/&blank;/\\\\\|/\\n' s s s)" \| column -nt -s $'\\t'** [**&gt;** {*soubor*}]

*# vypsat podrobnější **informace** o balíčku*<br>
**snap info** {*balíček*}

*# vypsat spojení konektorů a slotů (všech/jen spojených)*<br>
**snap connections \-\-all**<br>
**snap connections**

### Ostatní

*# **deaktivovat** balíček/znovu ho **aktivovat***<br>
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

<!--
## Parametry příkazů
<!- -
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)
-->

## Instalace na Ubuntu

*# Příkaz „aptitude“ (doporučuji)*<br>
**sudo apt-get install aptitude**

*# Příkaz „apt-file“*<br>
**sudo apt-get install apt-file &amp;&amp;sudo apt-file update**

Poznámka: Neinstalujte balíček apt-file, pokud ho nevyužijete. Výrazně zvyšuje objem dat přednášených při každé aktualizaci (při každém „sudo apt-get update“)!

*# Příkaz „apt-offline“*<br>
*// *<br>
**sudo apt-get install apt-offline**

*# Flatpak*<br>
**sudo apt-get install flatpak** [**gnome-software-plugin-flatpak**]<br>
**sudo flatpak remote-add \-\-if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo**<br>
!: Restartujte operační systém.

*# Pro umožnění uživatelské instalace (parametr \-\-user) spusťte z účtu příslušného uživatele navíc:*<br>
**flatpak remote-add \-\-user \-\-if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo**

Snap je základní součástí Ubuntu přítomnou v každé nové instalaci.
Je možno ho odinstalovat tímto příkazem:

*# *<br>
**sudo apt-get purge \-\-autoremove snapd**

Ale začátečníkům to nedoporučuji, protože není zaručeno, že nová verze některé systémové
součásti nebude Snap vyžadovat. Začátečníkům doporučuji Snap v systému ponechat,
ale nepoužívat.

## Ukázka

Instalace, spuštění a odinstalování GIMPu různými způsoby:

*# *<br>
**sudo apt-get update**<br>
**sudo apt-get install -y gimp**<br>
**gimp**<br>
!: Ukončete Gimp.<br>
**sudo apt-get remove -y gimp**<br>
**apt-get download gimp**<br>
**sudo apt-get install ./gimp\*.deb**<br>
!: Odpovězte „a“.<br>
**gimp**<br>
!: Ukončete Gimp.<br>
**sudo apt-get remove -y gimp**<br>
**sudo snap install gimp**<br>
**snap run gimp**<br>
!: Ukončete Gimp.<br>
**sudo snap remove gimp**<br>
**flatpak install flathub org.gimp.GIMP**<br>
!: Odpovězte kladně na všechny dotazy.<br>
**flatpak run org.gimp.GIMP**<br>
!: Ukončete Gimp.<br>
**flatpak remove org.gimp.GIMP**<br>
!: Potvrďte.

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Co je špatně na Snapu: 1) Automatické updatování balíčků, které nelze vypnout. 2) Zatímco klientská část je svobodný software dostupný pro mnoho linuxových distribucí, serverová část je proprietární a může ji provozovat pouze firma Canonical, takže není možné vytvářet zrcadla repozitáře a při instalaci programů je uživatel závislý na firmě Canonical a připojení do USA. 3) Vzhledem k použítí SquashFS připojené snapy zaplevelují výpisy příkazů jako „mount“ a „df“ (Flatpak tímto netrpí).
* Flatpak přistupuje poměrně benevolentně k přístupovým právům uživatelů. Umožňuje instalovat a odinstalovávat balíčky systémové instalace bez zadání hesla nejen superuživateli, ale také všem uživatelům, kteří jsou členy skupin admin a sudo. Ostatní uživatelům to umožní po zadání hesla administrujícího uživatele, dokonce i přesto, že sami nemají právo používat sudo.
* Flatpak neprovádí automatickou aktualizaci balíčků.
<!--
4) Stalo se mi, že u některých snapů nebyla správně vyplněna licence. – Vrátit
jen v případě ověření.
-->

## Další zdroje informací

Pro APT: „man apt-get“ apod. (ale není příliš přehledná) Pro Flatpak: „man flatpak“ a všechny odtud odkazované manuálové stránky, např. „man flatpak-install“. Pro Snap: „snap \-\-help“ a „snap help {*podpříkaz*}“.

* [Wikipedie: APT](https://cs.wikipedia.org/wiki/Advanced_Packaging_Tool)
* [Příspěvek na fóru od „Sešívaného“](https://forum.ubuntu.cz/index.php/topic,83160.msg560223.html#msg560223)
* [Wikipedie: aptitude](https://cs.wikipedia.org/wiki/Aptitude)
* [Wikipedie: dpkg](https://cs.wikipedia.org/wiki/Dpkg)
* [Video „How to Use Flatpak“ (Chris Titus Tech)](https://youtu.be/bvybMVRaND0?t=75) (anglicky)
* [Flathub (oficiální repozitář Flatpaku)](https://flathub.org/) (anglicky)
* [Manuál aptitude: formátovací značky](https://www.debian.org/doc/manuals/aptitude/ch02s05s01.en.html) (anglicky)
* [Manuál aptitude: vyhledávací podmínky](https://www.debian.org/doc/manuals/aptitude/ch02s04s05.en.html) (anglicky)
* [TL;DR „flatpak“](https://github.com/tldr-pages/tldr/blob/master/pages/linux/flatpak.md) (anglicky)
* [TL;DR „snap“](https://github.com/tldr-pages/tldr/blob/master/pages/linux/snap.md) (anglicky)
* [Balíček „flatpak“](https://packages.ubuntu.com/focal/flatpak) (anglicky)
* [Balíček „snapd“](https://packages.ubuntu.com/focal/snapd) (anglicky)
* [Oficiální stránka „Flatpak“](https://flatpak.org/) (anglicky)
* [TL;DR „aptitude“](https://github.com/tldr-pages/tldr/blob/master/pages/linux/aptitude.md) (anglicky)
* [TL;DR „apt“](https://github.com/tldr-pages/tldr/blob/master/pages/linux/apt.md) (anglicky)
* [TL;DR „apt-key“](https://github.com/tldr-pages/tldr/blob/master/pages/linux/apt-key.md) (anglicky)
* [Video „Flatpak, a technical walkthrough“](https://www.youtube.com/watch?v=K0bkapSpzzk) (anglicky)

<!--
Podrobněji o aptitude, včetně TUI:
https://www.youtube.com/watch?v=xca3Ywf54N0
-->

!ÚzkýRežim: vyp
