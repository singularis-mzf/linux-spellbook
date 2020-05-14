<!--

Linux Kniha kouzel, kapitola Systém
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

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
[ ] Chybí ukázka.

- machinectl ovládá kontejnery, ale musí se doinstalovat.

Při přechodu na vyšší verzi Ubuntu nutno otestovat zkratky pro přepínání mezi
virtuálními konzolemi a X.



-->

# Systém

!Štítky: {tematický okruh}{systém}{démoni}{klávesnice}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola se zabývá vybranými aspekty běhu operačního systému a jeho ovládání,
zejména ovládáním démonů, systémovými logy, restartem či vypnutím počítače.
Také se zabývá rozložením klávesnice.

Když zavaděč GRUB spustí jádro systému, to pak vytvoří dva první procesy: systemd (PID 1)
a kthreadd (PID 2). Systemd pak na základě tzv. výchozího cíle a dalších nastavení
spustí další démony a také správce příhlášení, kteří umožní uživatelům přihlašovat
se do systému (popř. automaticky přihlásí výchozího uživatele). Když se uživatel přihlásí,
vznikne takzvané „sezení“, které zanikne, až se uživatel odhlásí
(včetně případů, kdy je odhlášení součástí restartu či vypnutí počítače).

Tato kapitola se nezabývá samotným zaváděním operačního systému a diskovými oddíly.
Rovněž se nezabývá zjišťováním informací o hardwaru počítače (s výjimkou procesoru).

Tato verze kapitoly nepokrývá nastavení automatického přihlašování do X,
nastavování cílů, nastavení synchronizace systémového času s NTP servery
ani vytváření vlastních služeb a démonů.
Rovněž nepokrývá ovládání kontejnerů příkazem „machinectl“.

Poznámka: práce s odkládacím prostorem byla přesunuta do kapitoly *Diskové oddíly*.

<!--
Poznámka: jádro si ponechává možnost spouštět svoje vlastní, nezávislé procesy prostřednictvím
svého vlastního démona „kthreadd“ (PID 2).

Proces kthreadd je první jaderný démon, který slouží jádru k zakládání dalších jaderných démonů;
jaderní démoni jsou nedotknutelní a mimo kontrolu uživatele (i krále démonů),
zodpovídají se pouze přímo jádru.

Poznámka: správci přihlášení se nepočítají mezi démony, protože mají přímé uživatelské rozhraní.
-->

## Definice

* **Systemd** čili **král démonů** (také známý jako první proces či proces číslo 1) je ústřední démon systému, který řídí jeho start, restart či vypnutí a spouští a zastavuje ostatní démony (kromě tzv. jaderných). V některých linuxových komunitách má špatnou pověst, protože jeho předchůdce Upstart kdysi nevybíravě převzal „vládu“ od tehdy oblíbeného procesu „init“ (zvaného také „sysvinit“) a systemd pak pod svoji kontrolu sjednotil mnoho do té doby nezávisle řešených funkcí systému. Jako uživatele vás však od něj nečeká žádné nebezpečí, pokud mu nebudete překážet.
* **Démon** je systémový proces, který čeká (popř. běží) na pozadí bez přímého uživatelského rozhraní a má hodnotu PPID rovnu 0, 1 nebo 2. (Pozor – nespleťte si PPID s PID!)
* **Systémová jednotka** (unit) je datová struktura krále démonů. Systemd rozeznává jedenáct druhů systémových jednotek, z nichž nejznámější a nejdůležitější jsou **služby** („service“), reprezentující démony. Další významné jsou **sokety** („socket“, souvisí se službami a umožňují démonům nabízet svoje služby ostatním démonům), **cíle** („target“, seskupení jednotek pro určité situace) a **časovače** („timer“, pravidelně probouzejí a ruší démony).
* **Sezení** je instance přihlášení uživatele k systému ve víceuživatelském režimu; vzniká přihlášením uživatele a zaniká jeho odhlášením, resp. ukončením všech procesů daného sezení. Sezení může být grafické či textové a může být místní nebo vzdálené.

!ÚzkýRežim: vyp

## Zaklínadla

### Informace o systému (zjistit)

*# obecné informace (pro člověka)(alternativy)*<br>
**neofetch**<br>
**inxi**

*# verze a varianta **jádra***<br>
**uname -r** ⊨ 5.0.0-37-generic

*# čas od spuštění systému (**uptime**)*<br>
**uptime \-\-pretty**

*# počet logických procesorů/fyzických jader*<br>
**nproc \-\-all**<br>
?

*# jméno procesoru*<br>
**LC\_ALL=C lscpu \| egrep '^Model name:' | sed -E 's/^[<nic>^:]\*:\\s\*//'**

*# informace o **frekvenci procesoru** (pro člověka)*<br>
**LC\_ALL=C lscpu \| egrep '^CPU[<nic>^:]+MHz:'**

*# informace o velikosti a využití **paměti** a odkládacího prostoru*<br>
**free -h**

*# zjistit druh počítače (stolní počítač, nebo **notebook**?)*<br>
*// Návratový kód je 0 pro notebook, 1 pro stolní počítač a 2, pokud to nelze zjistit. Ve virtuálním počítači dle mých zkušeností, tento přikaz zjistí druh fyzického počítače, na kterém virtuální počítač běží.*<br>
**laptop-detect**

*# kódové jméno verze **distribuce***<br>
**lsb\_release -sc** ⊨ bionic

*# jméno/verze **distribuce***<br>
**lsb\_release -si** ⊨ Ubuntu<br>
**lsb\_release -sr** ⊨ 18.04

*# **jméno počítače***<br>
**hostname** ⊨ mojepc

*# jméno jádra/druh operačního systému*<br>
**uname -n** ⊨ Linux<br>
**uname -o** ⊨ GNU/Linux

*# architektura systému*<br>
**arch** ⊨ x86\_64

### Restart a vypnutí počítače

*# **restartovat** počítač (normálně/drasticky/velmi drasticky)*<br>
**reboot**<br>
**sudo systemctl reboot \-\-force**<br>
**sudo systemctl reboot \-\-force \-\-force**

*# **vypnout** počítač (normálně/drasticky/velmi drasticky)*<br>
**poweroff**<br>
**sudo systemctl poweroff \-\-force**<br>
**sudo systemctl poweroff \-\-force \-\-force**

*# přepnout do jednouživatelského režimu (záchranného/nouzového)*<br>
*// Podle dokumentace poskytuje záchranný režim základní služby a připojené souborové systémy pro pohodlnou práci, zatímco nouzový režim nespustí nic a očekává od uživatele, že si spustí služby, které potřebuje, a připojí potřebné souborové systémy. Ovšem při přechodu z běžícího systému těmito příkazy jsem tento rozdíl nepozoroval/a. Souborové systémy zůstaly i v nouzovém režimu normálně připojené.*<br>
**sudo systemctl rescue**<br>
**sudo systemctl emergency**

*# **uspat** systém*<br>
**systemctl suspend**

*# **hibernovat** systém*<br>
**sudo systemctl hibernate**

*# **zastavit** systém bez vypnutí počítače (normálně/drasticky/velmi drasticky)*<br>
**sudo systemctl halt**<br>
**sudo systemctl halt \-\-force**<br>
**sudo systemctl halt \-\-force \-\-force**

*# **vypnout** počítač za N minut/zrušit naplánované vypnutí*<br>
**sudo shutdown -P** [**\-\-no-wall**] {*N*}<br>
**sudo shutdown -c**

### Ovládání systémových jednotek

*# **spustit** neběžící*<br>
**sudo systemctl start** {*jednotka.typ*}...

*# **zastavit** běžící*<br>
**sudo systemctl stop** {*jednotka.typ*}...

*# **restartovat** běžící*<br>
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

*# **zjistit stav** (pro člověka/pro skript)*<br>
**systemctl status** {*jednotka.typ*}<br>
**systemctl show** {*jednotka.typ*}
<!--
**systemctl show** {*jednotka.typ*} **\| egrep '^((Active|Load|Sub)State|Description|Id|Names)='**<br>
-->

*# zjistit, zda jednotka běží*<br>
*// Pro každou zadanou systémovou jednotku vypíše řádek „active“ nebo „inactive“; uspěje, pokud alespoň jeden řádek bude „active“.*<br>
**systemctl is-active** [**\-\-quiet**] {*jednotka.typ-nebo-vzorek*}...

*# **vypsat** jednotky všech typů*<br>
**systemctl list-units** [**\-\-all**] <nic>[{*filtrovací-vzorek*}]

*# vypsat časovače*<br>
**systemctl list-timers** [**\-\-all**]

*# vypsat služby*<br>
**systemctl list-units \-\-all -t service**

*# vypsat cíle*<br>
**systemctl list-units \-\-all -t target**

*# zjistit **PID** příslušné dané jednotce (je-li definováno)*<br>
*// Poznámka: pokud dané jednotce neodpovídá žádný běžící démon, vypíše tento příkaz „0“.*<br>
**systemctl show \-\-property=MainPID** {*jednotka.typ*} **\| sed -E 's/.\*=//'**

*# vypsat **manuálovou stránku** příslušnou jednotce, je-li známa*<br>
**systemctl help** {*jednotka.typ*}

*# vypsat dynamické závislosti jednotky (na kterých jednotka závisí/které závisí na jednotce)*<br>
*// Poznámka: dynamické závislosti mezi jednotkami jsou obtížně pochopitelná věc, protože mohou vznikat a zanikat za běhu v reakci na změnu stavu systému. Nepředpokládejte, že je chápete, pokud jste podrobně nestudovali dokumentaci systemd.*<br>
**systemctl list-dependencies**<br>
**systemctl list-dependencies \-\-reverse**

### Logy

*# **vypsat log** krále démonů*<br>
**journalctl** [{*parametry*}]<br>

*# **vypsat log** jádra (pro skript/pro člověka)*<br>
**dmesg** [**\-\-time-format iso**]<br>
**dmesg -H**[**x**] <nic>[**\-\-time-format iso**]

*# **sledovat** log krále démonů/log jádra*<br>
**journalctl -fqn 0** [{*parametry*}]<br>
**dmesg -w**[**H**]<nic>[**x**]<nic>[**\-\-time-format iso**]

*# vypsat seznam **časů posledních nabootování***<br>
**journalctl \-\-list-boots \| sed -E $'s/.\*([A-Z]<nic>[a-z]{2}.\*)\\u2014.\*/\\\\1/' \| date -f - "+%F %T %z"**

<!--
Podrobnější informace: příkaz „uptimes“ z balíčku „uptimed“.
-->

*# zjistit, kolik místa na disku zabírají logy krále démonů*<br>
**journalctl \-\-disk-usage**

*# vyprázdnit log krále démonů/log jádra*<br>
?<br>
**sudo dmesg \-\-clear**

### Sezení

*# vypsat **seznam sezení**/přihlášených uživatelů*<br>
**loginctl** [**list-sessions**]<br>
**loginctl list-users**

*# vypsat informace o sezení/přihlášeném uživateli*<br>
**loginctl show-session** {*ID-sezení*}<br>
**loginctl show-user** {*uživatel*}

*# **přepnout** na uvedené sezení*<br>
*// Poznámka: tento příkaz dokáže přepnout i mezi X a virtuální konzolí!*<br>
**loginctl activate** {*ID-sezení*}

*# **násilně ukončit** sezení/všechna sezení uživatele*<br>
**loginctl terminate-session** {*ID-sezení*}<br>
**loginctl terminate-user** {*uživatel*}


### Ostatní

*# nastavit jméno počítače*<br>
**sudo sed -i -E "s/(\\\\s)$(hostname)\\$/\\\\1**{*novéjméno*}**/" /etc/hosts &amp;&amp; sudo hostname** {*novéjméno*}<br>
!: Restartujte počítač.

*# nastavit proměnnou prostředí krále démonů/smazat ji*<br>
**sudo systemctl set-environment** {*PROMĚNNÁ*}**="**{*hodnota*}**"** [{*DALŠÍ\_PROMĚNNÁ*}**="**{*její hodnota*}**"**]...<br>
**sudo systemctl unset-environment** {*PROMĚNNÁ*}...

*# který cíl je pro start systému výchozí?*<br>
**systemctl get-default**

*# nastavit výchozí cíl*<br>
**sudo systemctl set-default** {*cíl.target*}
<!--
[ ] Zjistit, jak lze použít k nastavení systému, aby naběhl do textového prostředí místo grafického...
-->

*# dočasně vypnout automatické připojování výměnných jednotek *<br>
?

<!--
**sudo systemctl stop udisks2**
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

Poznámka: Někde jsem četl/a, že na některých noteboocích může být nutné ke kombinaci
Alt+PrintScreen držet navíc i klávesu Fn; je-li to pravda, výrobci takových notebooků
museli mít podivnou představu o tom, kolik mají jejich uživatelé rukou.
-->

### Ovládání klávesnice počítačem

Poznámka: příkazy v této sekci jsou určeny výhradně pro X; téméř jistě nebudou fungovat v textových virtuálních konzolích ani na Waylandu.

*# zapnout/vypnout/přepnout **Num Lock***<br>
**numlockx on**<br>
**numlockx off**<br>
**numlockx toggle**

*# zapnout/vypnout/přepnout **Caps Lock***<br>
?<br>
?<br>
**xdotool key Caps\_Lock**

*# zapnout/vypnout/přepnout **Scroll Lock***<br>
?<br>
?<br>
**xdotool key Scroll\_Lock**

*# vypnout/znovu zapnout klávesnici*<br>
**xinput \-\-disable $(xinput \-\-list \-\-short \| egrep '\\[.\*keyboard.\*\\]' \| egrep -iv 'virtual\|(power\|sleep)&blank;button' \| tail -n 1 \| sed -E 's/.\*id=([0-9]+)[<nic>^0-9].\*/\\1/')**<br>
**xinput \-\-enable $(xinput \-\-list \-\-short \| egrep '\\[.\*keyboard.\*\\]' \| egrep -iv 'virtual\|(power\|sleep)&blank;button' \| tail -n 1 \| sed -E 's/.\*id=([0-9]+)[<nic>^0-9].\*/\\1/')**

### Rozložení klávesnice

*# trvale změnit systémové rozložení*<br>
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

Většina použitých příkazů je základní součástí Ubuntu, pouze příkazy numlockx, xdotool, inxi a neofetch si musíte doinstalovat, chcete-li je použít:

*# *<br>
**sudo apt-get install numlockx xdotool neofetch inxi**

<!--
## Ukázka
<!- -
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
- ->
![ve výstavbě](../obrazky/ve-vystavbe.png)
-->

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Systemd se ve výpisech procesů představuje jako „/sbin/init“, což je ve skutečnosti symbolický odkaz na „/lib/systemd/systemd“.
* Volba „enable“/„disable“ je nezávislá na tom, zda démon právě běží. Nastavení na „enable“ ho okamžitě nespustí a nastavení na „disable“ neukončí (ledaže uvedete parametr „\-\-now“).

## Další zdroje informací

* [Článek na Wikipedii](https://cs.wikipedia.org/wiki/Systemd)
* [Seriál článků na ABC Linuxu](http://www.abclinuxu.cz/serialy/systemd)
* [Video: The Magic SysRQ Key on the Keyboard](https://www.youtube.com/watch?v=ZiX327d8Ys0)
* [Systemd cheat sheet](https://www.thegeekdiary.com/centos-rhel-7-systemd-command-line-reference-cheat-sheet/) (anglicky)
* [Oficiální stránka systemd pro uživatele](https://www.freedesktop.org/wiki/Software/systemd/) (anglicky)
* [Oficiální stránka systemd pro vývojáře](https://systemd.io/) (anglicky)
* [Repozitář systemd na GitHubu](https://github.com/systemd/systemd) (anglicky)
* [Video Creating systemd Service Files](https://www.youtube.com/watch?v=fYQBvjYQ63U) (anglicky)
* [Video systemd Basics](https://www.youtube.com/watch?v=AtEqbYTLHfs) (anglicky)
* *man 1 systemctl* (anglicky)
* *man 5 systemd.service* (anglicky)
* [Balíček systemd](https://packages.ubuntu.com/bionic/systemd) (anglicky)
* [TL;DR systemctl](https://github.com/tldr-pages/tldr/blob/master/pages/linux/systemctl.md) (anglicky)

!ÚzkýRežim: vyp
<!--
sudo systemctl daemon-reload
systemctl is-system-running
-->
