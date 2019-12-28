<!--

Linux Kniha kouzel, kapitola Systém
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:
[ ] Stane se proces spuštěný pomocí nohup démonem?
[ ] Automatické přihlašování (GDM/SDDM/Lightdm)
[ ] Synchronizace času (zapnout/vypnout/ručné provést)

- machinectl ovládá kontejnery, ale musí se doinstalovat.

Při přechodu na vyšší verzi Ubuntu nutno otestovat zkratky pro přepínání mezi
virtuálními konzolemi a X.
-->

# Systém

!Štítky: {tematický okruh}{systém}{démoni}{klávesnice}
!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

Tato verze kapitoly nepokrývá nastavení automatického přihlašování do X
a nastavení synchronizace systémového času s NTP servery. Rovněž nepokrývá
ovládání kontejnerů příkazem „machinectl“ a zjišťování informací o systému (uname, lsb\_release, neofetch, hostname).

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

* **Systemd** čili **král démonů** (také známý jako první proces či proces číslo 1) je ústřední proces systému, který řídí jeho start, restart či vypnutí a spouští a zastavuje démony. V některých linuxových komunitách má špatnou pověst, protože jeho předchůdce Upstart kdysi nevybíravě převzal „vládu“ od tehdy oblíbeného procesu „init“ (zvaného také „sysvinit“) a systemd pak pod svoji kontrolu sjednotil mnoho do té doby nezávisle řešených funkcí systému. Jako uživatele vás však od něj nečeká žádné nebezpečí, pokud mu nebudete překážet.
* **Démon** je systémový proces, který běží či čeká na pozadí bez přímého uživatelského rozhraní a je přímým potomkem systemd.
* **Systémová jednotka** (unit) je datová struktura krále démonů. Systemd rozeznává jedenáct druhů systémových jednotek, z nichž nejznámější a nejdůležitější jsou **služby** („service“), reprezentující démony. Další významné jsou **časovače** („timer“, v nastavený čas probouzejí a ruší démony) a **cíle** („target“, cosi jako seznamy, co všechno je potřeba udělat).
* **Sezení** je instance přihlášení uživatele k systému ve víceuživatelském režimu; vzniká přihlášením uživatele a zaniká jeho odhlášením, resp. ukončením všech procesů daného sezení.

!ÚzkýRežim: vyp

## Zaklínadla

### Restart a vypnutí počítače

*# restartovat počítač (normálně/drasticky/velmi drasticky)*<br>
**reboot**<br>
**sudo systemctl reboot \-\-force**<br>
**sudo systemctl reboot \-\-force \-\-force**

*# vypnout počítač (normálně/drasticky/velmi drasticky)*<br>
**poweroff**<br>
**sudo systemctl poweroff \-\-force**<br>
**sudo systemctl poweroff \-\-force \-\-force**

*# přepnout do jednouživatelského režimu (záchranného/nouzového)*<br>
*// Podle dokumentace poskytuje záchranný režim základní služby a připojené souborové systémy pro pohodlnou práci, zatímco nouzový režim nespustí nic a očekává od uživatele, že si spustí služby, které potřebuje, a připojí potřebné souborové systémy. Ovšem při přechodu z běžícího systému těmito příkazy jsem tento rozdíl nepozoroval/a. Souborové systémy zůstaly i v nouzovém režimu normálně připojené.*<br>
**sudo systemctl rescue**<br>
**sudo systemctl emergency**

*# uspat systém*<br>
**systemctl suspend**

*# hibernovat systém*<br>
**sudo systemctl hibernate**

*# **zastavit** systém bez vypnutí počítače (normálně/drasticky/velmi drasticky)*<br>
**sudo systemctl halt**<br>
**sudo systemctl halt \-\-force**<br>
**sudo systemctl halt \-\-force \-\-force**

### Ovládání systémových jednotek

*# zjistit stav systémové jednotky (pro člověka/pro skript)*<br>
**systemctl status** {*jednotka.typ*}<br>
**systemctl show** {*jednotka.typ*}
<!--
**systemctl show** {*jednotka.typ*} **\| egrep '^((Active|Load|Sub)State|Description|Id|Names)='**<br>
-->

*# spustit neběžící*<br>
**sudo systemctl start** {*jednotka.typ*}...

*# zastavit běžící*<br>
**sudo systemctl stop** {*jednotka.typ*}...

*# restartovat běžící*<br>
**sudo systemctl restart** {*jednotka.typ*}...

*# nastavit automatické spouštění jednotky/zrušit toto nastavení*<br>
*// U většiny služeb (ne úplně u všech) znamená automatické spouštění jejich spuštění při startu systému. Systémová jednotka s vypnutým automatickým spouštěním (disabled) stále může být spuštěna automaticky, pokud na ní závisí (jiná) automaticky spouštěná jednotka.*<br>
**sudo systemctl enable** [**\-\-now**] {*jednotka.typ*}...<br>
**sudo systemctl disable** [**\-\-now**] {*jednotka.typ*}...

*# zcela **zakázat** spouštění systémové jednotky/zrušit tento zákaz*<br>
*// Je-li zakázáno spouštění systémové jednotky, nemůže být žádným způsobem spuštěna ani restartována. Zákaz vypne případné automatické spouštění jednotky a to nepůjde znovu nastavit. Pokud ale daná systémová jednotka právě běží, samotný zákaz ji nechá běžet.*<br>
**sudo systemctl mask** {*jednotka.typ*}...<br>
**sudo systemctl unmask** {*jednotka.typ*}...

### Informace o systémových jednotkách

*# vypsat jednotky všech typů*<br>
**systemctl list-units** [**\-\-all**] <nic>[{*filtrovací-vzorek*}]

*# vypsat časovače*<br>
**systemctl list-timers** [**\-\-all**]

*# vypsat služby*<br>
**systemctl list-units \-\-all -t service**

*# vypsat cíle*<br>
**systemctl list-units \-\-all -t target**

*# zjistit, zda jednotka běží*<br>
*// Je-li zadáno víc jednotek, uspěje, pokud běží kterákoliv z nich.*<br>
**systemctl is-running** [**\-\-quiet**] {*jednotka.typ-nebo-vzorek*}...

*# zjistit PID příslušné dané jednotce (je-li definováno)*<br>
**systemctl show \-\-property=MainPID** {*jednotka.typ*} **\| sed -E 's/.\*=//'**

*# vypsat manuálovou stránku příslušnou jednotce, je-li známa*<br>
**systemctl help** {*jednotka.typ*}

*# vypsat dynamické závislosti jednotky (na kterých jednotka závisí/které závisí na jednotce)*<br>
*// Poznámka: dynamické závislosti mezi jednotkami jsou obtížně pochopitelná věc, protože mohou vznikat a zanikat za běhu v reakci na změnu stavu systému.*<br>
**systemctl list-dependencies**<br>
**systemctl list-dependencies \-\-reverse**

### Logy

*# vypsat log krále démonů*<br>
**journalctl** [{*parametry*}]<br>

*# vypsat log jádra (pro skript/pro člověka)*<br>
**dmesg** [**\-\-time-format iso**]<br>
**dmesg -H**[**x**] <nic>[**\-\-time-format iso**]

*# sledovat log krále démonů/log jádra*<br>
**journalctl -fqn 0** [{*parametry*}]<br>
**dmesg -w**[**H**]<nic>[**x**]<nic>[**\-\-time-format iso**]

*# vypsat seznam časů posledních nabootování*<br>
**journalctl \-\-list-boots \| sed -E $'s/.\*([A-Z]<nic>[a-z]{2}.\*)\\u2014.\*/\\\\1/' \| date -f - "+%F %T %z"**

*# zjistit, kolik místa na disku zabírají logy krále démonů*<br>
**journalctl \-\-disk-usage**

*# vyprázdnit log krále démonů/log jádra*<br>
?<br>
**sudo dmesg \-\-clear**

### Odkládací oddíly a soubory

*# **připojit** odkládací oddíl/soubor*<br>
**sudo swapon** {*/dev/oddíl*}...<br>
**sudo swapon** {*/cesta/název-souboru*}...

*# připojit odkládací oddíl identifikovaný jmenovkou/UUID*<br>
**sudo swapon LABEL=**{*jmenovka*}<br>
**sudo swapon UUID=**{*UUID*}

*# **odpojit** odkládací oddíl/soubor/všechny odkládací oddíly a soubory*<br>
**sudo swapoff** {*/dev/oddíl*}...<br>
**sudo swapoff** {*/cesta/soubor*}...<br>
**sudo swapoff -a**[**v**]

*# **vypsat** aktivní odkládací oddíly a soubory*<br>
*// Bez sudo vynechá jmenovky a UUID.*<br>
[**sudo**] **swapon \-\-show**[**=NAME,USED,SIZE,PRIO,LABEL,UUID**] <nic>[**\-\-noheadings**] <nic>[**\-\-bytes**]

*# **vytvořit** odkládací soubor*<br>
*// Velikost můžete zadat také v megabajtech (s příponou „M“) či gigabajtech (s příponou „G“).*<br>
[**sudo**] **fallocate -l** {*velikost-v-bajtech*} {*název-souboru*}<br>
[**sudo**] **chmod 600** {*název-souboru*}<br>
[**sudo**] **mkswap** {*název-souboru*}<br>
**sudo chown root:root** {*název-souboru*}

*# **smazat** odpojený odkládací soubor*<br>
**sudo rm** {*název-souboru*}

*# **naformátovat** odkládací oddíl*<br>
**sudo mkswap** [**-L** {*jmenovka*}] <nic>[**-U** {*požadované-UUID*}] {*/dev/oddíl*}

### Sezení

*# vypsat seznam sezení/přihlášených uživatelů*<br>
**loginctl** [**list-sessions**]<br>
**loginctl list-users**

*# vypsat informace o sezení/přihlášeném uživateli*<br>
**loginctl show-session** {*ID-sezení*}<br>
**loginctl show-user** {*uživatel*}

*# přepnout na uvedené sezení*<br>
*// Poznámka: tento příkaz dokáže přepnout i mezi X a virtuální konzolí!*<br>
**loginctl activate** {*ID-sezení*}

*# násilně ukončit sezení/všecha sezení uživatele*<br>
**loginctl terminate-session** {*ID-sezení*}<br>
**loginctl terminate-user** {*uživatel*}


### Ostatní

*# který cíl je výchozí?*<br>
**systemctl get-default**

*# nastavit výchozí cíl startu systému*<br>
**sudo systemctl set-default** {*cíl.target*}

*# nastavit proměnnou prostředí krále démonů/smazat ji*<br>
**sudo systemctl set-environment** {*PROMĚNNÁ*}**="**{*hodnota*}**"** [{*DALŠÍ\_PROMĚNNÁ*}**="**{*její hodnota*}**"**]...<br>
**sudo systemctl unset-environment** {*PROMĚNNÁ*}...

<!--
sudo systemctl daemon-reload
systemctl is-system-running
sudo? systemctl hibernate
sudo? systemctl suspend
-->



## Zaklínadla (klávesnice)

### Ovládání počítače klávesnicí

*# **nouzový restart** počítače*<br>
*// Ne, opravdu to není Ctrl+Alt+Delete...*<br>
*// Poznámka: Skutečně důležitá je pouze poslední klávesa „B“; ty předchozí pouze vykonávají operace, díky nimž nebude restart tak drastický. Pokud chcete opravdu drastický reset, stačí na to klávesová zkratka „Alt“+„PrintScreen“+„B“.*<br>
!: Stiskněte a držte stisknuté klávesy {_Alt_} + {_PrtScr_}.<br>
!: Na klávesnici s krátkými přestávkami vyťukejte: {_R_}, {_E_}, {_I_}, {_S_}, {_U_}, {_B_}.<br>
!: Uvolněte {_PrtScr_} a {_Alt_}.

*# drastické **nouzové vypnutí** počítače*<br>
!: {_Alt_} + {_PrtScr_} + {_O_}.

*# vypsat nápovědu k nouzovým klávesovým zkratkám jádra*<br>
*// Poznámka: Většina vypsaných operací je v jádru Ubuntu zakázána. Po stisknutí příslušné kombinace kláves se v takovém případě vypíše na konzoli zpráva, že operace je zakázána.*<br>
!: Jste-li v grafickém režimu, přepněte se na textovou virutální konzoli zkratkou {_Ctrl_} + {_Alt_} + {_F2_}.<br>
!: Stiskněte {_Alt_} + {_PrtScr_} + {_H_}. Měla by se vypsat nápověda.<br>
!: Zpět do grafického režimu se vrátíte {_Alt_} + {_F7_} (pouze ve variantách Ubuntu a Kubuntu je to místo toho {_Alt_} + {_F1_}).

<!--
*# přímý příkaz jádru systému k vyprázdnění vyrovnávací paměti zápisu (**flush**)*<br>
!: Klávesová zkratka „Alt“+„PrintScreen“+„S“
-->

### Ovládání klávesnice počítačem

Poznámka: příkazy v této sekci jsou určeny výhradně pro X; téméř jistě nebudou fungovat v textových virtuálních konzolích ani na Waylandu.

*# zapnout/vypnout/přepnout Num Lock*<br>
**numlockx on**<br>
**numlockx off**<br>
**numlockx toggle**

*# zapnout/vypnout/přepnout Caps Lock*<br>
?<br>
?<br>
**xdotool key Caps\_Lock**

*# zapnout/vypnout/přepnout Scroll Lock*<br>
?<br>
?<br>
**xdotool key Scroll\_Lock**

*# vypnout/znovu zapnout klávesnici*<br>
**xinput \-\-disable $(xinput \-\-list \-\-short \| egrep '\\[.\*keyboard.\*\\]' \| egrep -iv 'virtual\|(power\|sleep)&blank;button' \| tail -n 1 \| sed -E 's/.\*id=([0-9]+)[<nic>^0-9].\*/\\1/')**<br>
**xinput \-\-enable $(xinput \-\-list \-\-short \| egrep '\\[.\*keyboard.\*\\]' \| egrep -iv 'virtual\|(power\|sleep)&blank;button' \| tail -n 1 \| sed -E 's/.\*id=([0-9]+)[<nic>^0-9].\*/\\1/')**



### Rozložení klávesnice

*# změnit systémové rozložení*<br>
**sudo dpkg-reconfigure keyboard-configuration**<br>
**sudoedit /etc/default/keyboard**<br>
!: Zkontrolujte hodnoty XKBLAYOUT a XKBVARIANT, zda jsou nastaveny podle vaších představ; pokud ne, opravte je a uložte soubor.<br>
!: Ukončete editor.<br>
!: Restartujte operační systém.
<!--
sudo systemctl restart keyboard-setup.service
?
-->

*# dočasně nastavit okamžité rozložení klávesnice (jen v X)(obecně/příklady...)*<br>
**setxkbmap** {*rozložení*} [{*varianta*}]<br>
**setxkbmap cz**<br>
**setxkbmap cz qwerty**<br>
**setxkbmap ru**

*# vypsat seznam dostupných rozložení klávesnice a jejich variant*<br>
?
<!--
[ ] Vycházet ze souboru:
/usr/share/X11/xkb/rules/xorg.lst
-->
<!--
*# vypsat seznam definic variant rozložení klávesnice*<br>
*// Poznámka: ačkoliv můžete v příkazu „setxkbmap“ použít kteroukoliv vypsanou kombinaci, mnoho z nich nebylo zamýšleno jako rozložení klávesnice a učiní klávesnici obtížně použitelnou. Seznam skutečně použitelných rozložení hledejte např. v manuálové stránce: „man 7 xkeyboard-config“ v sekci „LAYOUTS“.*<br>
**cd /usr/share/X11/xkb/symbols; egrep -H '^\\s\*xkb\_symbols\\s+"[<nic>^"]\*"\\s\*\\{.\*$' \* 2&gt;/dev/null \| sed -E 's/^([<nic>^:]\*):[<nic>^"]\*"([<nic>^"]\*)".\*/\\1 \\2/'**

[ ] Vycházet ze souboru:
/usr/share/X11/xkb/rules/xorg.lst
-->


## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

### journalctl

*# *<br>
**journalctl** [{*parametry*}]

!parametry:

* ○ --output=short-iso ○ --output=json-pretty ◉ --output=short :: Různé formáty výstupu (podporovány i další).
* ☐ -f :: Bude čekat na nové položky a vypisovat je, jakmile se v logu objeví.
* ☐ -n {*počet-záznamů*}  :: Omezí počet nejnovějších záznamů k vypsání (jinak vypíše všechny).
* ☐ -p {*priorita*} :: Vypíše pouze záznamy s alespoň uvedenou prioritou (debug, info, notice, warning, err, crit, alert, emerg). Lze zadat i přesný rozsah operátorem .., např. „-p notice..crit“.
* ☐ --since "{*YYYY-mm-dd HH:mm:ss*}" :: Vypíše pouze záznamy z uvedeného času a pozdější.
* ☐ -r :: Seřadí log od nejnovějších záznamů místo od nejstarších.
* -u {*jednotka*} :: Omezí výpis na záznamy související s uvedenou jednotkou; lze uvést víckrát, v takovém případě se zahrnou záznamy související s kteroukoliv z uvedených jednotek. Místo přesného názvu lze uvést i vzorek.
* ☐ -a :: Vypíše přesně a úplně i zprávy obsahující netisknutelné znaky či zprávy mimořádně dlouhé (nezkoušeno).

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

*# *<br>
**sudo apt-get install numlockx xdotool**


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
<!--
systemd Basics
(anglicky)
https://www.youtube.com/watch?v=AtEqbYTLHfs

Creating systemd Service Files
(anglicky)
https://www.youtube.com/watch?v=fYQBvjYQ63U
-->
