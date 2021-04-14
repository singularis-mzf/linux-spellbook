<!--

Linux Kniha kouzel, kapitola Správa procesů
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--

⊨

[ ] lkk procesy přepsat do Perlu

-->

# Správa procesů

!Štítky: {tematický okruh}{systém}{procesy}{bash}
!FixaceIkon: 1754
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod

Tato kapitola pokrývá vyhledávání, zkoumání, sledování a ukončování procesů
a omezeně také jejich spouštění. Rovněž se zabývá sledováním, jak jednotlivé procesy
využívají systémové zdroje jako výkon procesoru, paměť RAM či pevný disk.
Ne všechny uvedené postupy však fungují pro zacházení s démony;
hodláte-li zacházet s démony, navštivte kapitolu Systém.

Když v linuxu spustíte program, vznikne tzv. proces – jakási „schránka“ pro program,
která mu umožňuje běžet na procesoru a využívat systémové zdroje.
Většina příkazů, které v terminálu zadáte, vytvoří nový proces.
Pouze malá část spuštěných procesů si otevře také grafické uživatelské rozhraní.

Procesy jsou v linuxu identifikovány čísly PID (což neznamená „Pražská integrovaná doprava“)
a jsou uspořádány do „rodinné“ struktury, kde každý proces s výjimkou
dvou prvotních démonů má právě jednoho rodiče. PID rodiče je u vlastního procesu uvedeno
jako vlastnost „PPID“. (Pozor – nepleťte si PID a PPID!)

Tato verze kapitoly nepokrývá sledování systémových volání procesů (ptrace, strace)
ani zjišťování, které systémové knihovny jsou procesy využívány.

Tato kapitola se nezabývá správou systémových zdrojů z celkového hlediska,
ani používáním kvót, kontejnerů či izolačních a virtualizačních technik
jako chroot či cgroups.

## Definice

* **Proces** je instance počítačového programu v paměti, v dané chvíli jednoznačně identifikovaná kladným celým číslem **PID** (obvykle v rozsahu 1 až 4 194 304). PID procesu se za jeho běhu nemůže změnit; může se však změnit **PPID** (pokud je rodič pohřben dřív než zrozenec) nebo to, který program v rámci daného procesu ve skutečnosti běží.
* **Démon** je systémový proces bez uživatelského rozhraní, konkrétně jsou to dva **prvotní démoni** („systemd“ – PID 1 a „kthreadd“ – PID 2) a ti jejich přímí potomci, kteří nemají textové ani grafické uživatelské rozhraní. Prvotní démoni jako procesy nemají rodiče, jsou zřízeni přímo jádrem a jejich PPID je 0.
* **Zombie** je proces, který skončil, ale jeho rodič dosud nepřevzal jeho návratovou hodnotu. Převzetím návratové hodnoty rodičem je zombie **pohřbena** a její PID se uvolní pro přidělení dalšímu procesu.
* **Název procesu** je textový identifikátor přiřazený procesu jádrem. Není jednoznačný a vzniká (asi) tak, že se z ARGV[0] vezme jen název souboru (bez cesty) a zkrátí se na prvních 15 bajtů (obsahuje-li vícebajtové znaky, může dojít ke vzniku neplatné sekvence).
* **Úloha bashe** je proces spuštěný z bashe, který byl spuštěn na pozadí nebo alespoň jednou na pozadí odsunut. Takový proces dostane od dané instance bashe vedle PID ještě druhý identifikátor – „číslo úlohy“. Číslo úlohy je pak pro daný proces jedinečné, ale pouze v rámci dané instance bashe.

!ÚzkýRežim: vyp

## Zaklínadla

### Hledání procesů (najít PID)

*# procesy **podle názvu** procesu (obecně/příklad)*<br>
**pgrep** [**-x**] **'**{*regulární výraz*}**'**<br>
**pgrep '^gimp'**

*# **všechny** procesy*<br>
**pgrep .**

*# přímí/všichni **potomci** určitého procesu*<br>
**pgrep -P** {*PID*}<br>
**lkk procesy \| sed -E 's/^([0-9]+)(:[0-9]+)\*:(**{*PID*}**):.\*/\\1/;t;d'**

*# proces a všichni jeho předci v pořadí, až po prvotního démona*<br>
**lkk procesy \| sed -nE '/^(**{*PID*}**):/{s/:/\\n/g;p}'**

*# procesy, které mají otevřený konkrétní soubor*<br>
**sudo fuser** {*cesta*}... **2&gt;/dev/null \| sed -E 's/^\\s+//;s/\\s+\|\\s?$/\\n/g'**

*# všechny procesy určitého **uživatele**/určité skupiny*<br>
**pgrep -U** {*uid-nebo-uživatel*}[**,**{*další*}]...<br>
**pgrep -G** {*gid-nebo-skupina*}[**,**{*další*}]...

*# sourozenci určitého procesu (včetně procesu samotného)*<br>
**pgrep -P $(ps h -o ppid** {*PID-procesu*}**)**

*# procesy spuštěné později či společně se zadaným procesem*<br>
**ps h -eo etimes,pid \-\-sort -etimes \| gawk '$1 &lt;= '"$(ps h -o etimes:1** {*PID*}**)"' {print $2}'**

*# procesy spuštěné dříve či společně se zadaným procesem*<br>
**ps h -eo etimes,pid \-\-sort -etimes \| gawk '$1 &gt;= '"$(ps h -o etimes:1** {*PID*}**)"' {print $2}'**

*# procesy, které mají otevřený konkrétní adresář*<br>
**sudo fuser** {*cesta*}... **2&gt;/dev/null \| sed -E 's/^\\s+//;s/\\s+\|\\s?$/\\n/g'**

### Zjistit obecné informace o procesu

*# **příkazový řádek** (pro člověka/txtz pro skript)*<br>
**tr \\\\0 \\\\40 &lt;/proc/**{*PID*}**/cmdline \| sed -E '$s/ ?$/\\n/' | cat -v**<br>
**cat /proc/**{*PID*}**/cmdline** [**\|** {*zpracování*}]

*# ARGV[0]*<br>
**head -zn1 /proc/**{*PID*}**/cmdline \| tr \\\\0 \\\\n** ⊨ /bin/bash

*# **PPID***<br>
*// Pro procesy zřízené jádrem (systemd a kthreadd) vrací „0“.*<br>
**ps h -o ppid:1 -p** {*PID*} ⊨ 3077

*# název procesu*<br>
**ps h -o comm:1 -p** {*PID*} ⊨ bash

*# spuštěný soubor (na disku)*<br>
[**sudo**] **readlink /proc/**{*PID*}**/exe** ⊨ /bin/bash

*# příslušný **terminál***<br>
*// Nepříluší-li proces žádnému terminálu ani konzoli, vypíše „?“.*<br>
**ps h -o tty:1 -p** {*PID*} ⊨ pts/1

*# aktuální **adresář** (pro člověka/pro skript)*<br>
[**sudo**] **pwdx** {*PID*}... ⊨ 2343: /home/nana<br>
[**sudo**] **readlink /proc/**{*PID*}**/cwd** ⊨ /home/nana

*# **uživatel** vlastnící proces (jméno/UID)*<br>
**ps h -o ruser:1 -p** {*PID*}  ⊨ root<br>
**ps h -o ruid:1 -p** {*PID*}  ⊨ 0

*# **skupina** vlastnící proces (jméno/GID)*<br>
**ps h -o rgroup:1 -p** {*PID*}  ⊨ root<br>
**ps h -o rgid:1 -p** {*PID*}  ⊨ 0

*# **priorita** procesu*<br>
**ps h -o ni:1 -p** {*PID*} ⊨ 0

*# označení sezení podle systemd*<br>
**ps h -o lsession:1 -p** {*PID*} ⊨ c2

### Zjistit okamžité využití zdrojů

*# % zatížení procesoru*<br>
**ps h -o pcpu:1 -p** {*PID*} ⊨ 10.1

*# počet kiB **RAM** zabrané procesem*<br>
**ps h -o rss:1 -p** {*PID*} ⊨ 6028

*# % RAM zabrané procesem*<br>
**ps h -o pmem:1 -p** {*PID*} ⊨ 0.1

*# velikost virtuální paměti procesu v kiB*<br>
**ps h -o vsz:1 -p** {*PID*} ⊨ 32024

*# počet kiB virtuální paměti zabrané kódem/daty*<br>
**ps h -o trs:1 -p** {*PID*} ⊨ 1037<br>
**ps h -o drs:1 -p** {*PID*} ⊨ 30986

*# procesy, které nejvíc zatěžují procesor/RAM*<br>
**ps h -e -o pcpu,pid,comm \| sort -rn \| head**<br>
**ps h -e -o rss,pid,comm \| sort -rn \| head**

*# číslo přiděleného logického procesoru (od nuly)*<br>
**ps h -o psr:1 -p** {*PID*} ⊨ 0

*# počet vláken *<br>
**sed -E 's/^Threads:\\s+//;t;d' /proc/**{*PID*}**/status** ⊨ 1

*# procesy, které nejvíc pracují s diskem*<br>
**sudo egrep -H '^(read\|write)\_bytes:' /proc/[1-9]\*/io &gt;**{*dočasný/soubor/1*}<br>
**sleep 1;sudo egrep -H '^(read\|write)\_bytes:' /proc/[1-9]\*/io &gt;**{*dočasný/soubor/2*}<br>
**gawk 'BEGIN {FS="/\|: ?"; OFS = "\\t";} ARGIND == 1 {A[$3] += $6} ARGIND == 2 {B[$3] += $6} END {for (pid in A) {if (pid in B) {print B[pid] - A[pid], pid}}}'** {*dočasný/soubor/1*} {*dočasný/soubor/2*} **\| sort -rn \| head**

### Zjistit historii využití zdrojů

*# čas od spuštění procesu (v sekundách/ve formátu [[DD-]hh:]mm:ss)*<br>
**ps h -o etimes:1 -p** {*PID*} ⊨ 271<br>
**ps h -o etime:1 -p** {*PID*} ⊨ 04:31

*# čas, od kdy proces existuje*<br>
**ps h -o lstart -p** {*PID*} **\| date -f - "+%F %T %z"** ⊨ 2020-02-07 13:42:13 +0100

*# spotřebovaný čas procesoru*<br>
**ps h -o cputime:1 -p** {*PID*} ⊨ 00:01:13

*# počet bajtů přečtených z disku/**zapsaných na disk***<br>
[**sudo**] **sed -E 's/^read\_bytes:\\s+//;t;d' /proc/**{*PID*}**/io** ⊨ 1503232<br>
[**sudo**] **sed -E 's/^write\_bytes:\\s+//;t;d' /proc/**{*PID*}**/io** ⊨ 1724416

### Zjistit ostatní údaje

*# seznam otevřených deskriptorů (jen čísla/s cestami k souborům)*<br>
[**sudo**] **ls -U1 /proc/**{*PID*}**/fd**<br>
[**sudo**] **find /proc/**{*PID*}**/fd -type l -printf '%f\\t%l\\n'**

*# vypsat prostředí procesu ve formátu txtz*<br>
*// Každý záznam začíná názvem proměnné prostředí a znakem „=“, za ním následuje obsah proměnné.*<br>
[**sudo**] **cat /proc/**{*PID*}**/environ** [**\|** {*zpracování*}]

*# efektivní uživatel (jméno/EUID)*<br>
**ps h -o euser:1 -p** {*PID*}  ⊨ root<br>
**ps h -o euid:1 -p** {*PID*}  ⊨ 0

*# efektivní skupina (jméno/EGID)*<br>
**ps h -o egroup:1 -p** {*PID*}  ⊨ root<br>
**ps h -o egid:1 -p** {*PID*} ⊨ 0

## Zaklínadla: TUI a stromové zobrazení

### Stromové zobrazení

*# proces a jeho potomci*<br>
**pstree -pT**[**h**]<nic>[**l**] {*PID*}...

*# proces a jeho předkové*<br>
**pstree -ps**[**h**]<nic>[**l**] {*PID*}

*# všechny procesy bez parametrů/s parametry*<br>
**pstree -pT**[**h**]<nic>[**l**]<br>
**pstree -paT**[**h**]<nic>[**l**]

### TUI
<!--
[ ] Možná použít „nmon“.
-->

*# procesy nejvíc zatěžující CPU*<br>
**top**

*# procesy zabírající nejvíc paměti RAM*<br>
**top**<br>
{_Shift_} **+** {_M_}

*# procesy nejvíc vytěžující pevný disk*<br>
**sudo iotop**

*# procesy spotřebovávající nejvíc elektřiny*<br>
*// Funguje především na notebooku, nemám příliš vyzkoušené.*<br>
**sudo powertop**
<!--
Viz také: příkaz „tlp“ z balíčku „tlp“.
-->

## Zaklínadla: Spouštění a ovládání procesů

### Spouštění procesů

*# spustit příkaz s právy **superuživatele**/jiného uživatele*<br>
**sudo** {*příkaz*} [{*parametr-příkazu*}]...<br>
**sudo -u** {*uživatel*} {*příkaz*} {*parametr-příkazu*}...

*# spustit příkaz s právy jiné **skupiny***<br>
**sg "**{*příkaz*} [{*parametr-příkazu*}]...**"**

*# spustit příkaz a po skončení vypsat spotřebovaný **čas***<br>
*// Jde o vestavěnou konstrukci bashe, která dovoluje na místo jednoduchého příkazu zadat také více příkazů spojených rourou, např. „time seq 10000 \| wc -l“. Účinek příkazu „time“ se pak vztahuje na všechny procesy spojené rourou.*<br>
**time** {*příkaz*} [{*parametr-příkazu*}]...

*# spustit příkaz a jeho programem **nahradit** volající bash či sh*<br>
**exec** {*příkaz*} [{*parametr-příkazu*}]...

*# spustit proces s nastavenou prioritou (ne vyšší/libovolnou)*<br>
**nice -n $((**{*priorita*} **- $(nice)))** {*příkaz*} [{*parametry příkazu*}]...<br>
**sudo nice -n $((**{*priorita*} **- $(nice))) sudo -u "$(id -nu)" -g "$(id -ng)"** {*příkaz*} [{*parametry příkazu*}]...

<!--
*# spustit příkaz na pozadí, bez uživatelského rozhraní a bez příslušného terminálu*<br>
*// Poznámka: tento příkaz nemám příliš vyzkoušený, doporučuji používat opatrně; možná se nechová vždy podle očekávání.*<br>
**nohup** {*příkaz*} [{*parametr-příkazu*}]... **&amp;**
-->

### Ukončování procesů

*# požádat o ukončení více procesů podle názvu (obecně/příklad)*<br>
[**sudo**] **pkill '**{*regulární-výraz*}**'**<br>
**pkill '^gimp'**

*# požádat o ukončení/násilně **ukončit***<br>
[**sudo**] **kill** {*PID*}...<br>
[**sudo**] **kill -9** {*PID*}...

### Čekání, signály, priorita

*# **počkat** na ukončení*<br>
**while test -e /proc/**{*PID*}**; do IFS="" read -t 0.1 \|\| :; done &lt;&gt; &lt;(:)**

*# zaslat procesu **signál***<br>
[**sudo**] **kill -**[{*signál*}] {*PID*}...

*# **pozastavit** proces/nechat ho pokračovat*<br>
[**sudo**] **kill -SIGSTOP** {*PID*}...<br>
[**sudo**] **kill -SIGCONT** {*PID*}...

*# **změnit prioritu** běžícího procesu*<br>
*// Priorita je číslo v rozsahu -20 (nejvyšší) až 19 (nejnižší); normální priorita je 0. Obyčejný uživatel (tzn. bez sudo) může pouze snižovat prioritu vlastních procesů.*<br>
[**sudo**] **renice** {*priorita*} {*PID*}...

### Úlohy bashe

*# spustit příkaz na pozadí*<br>
{*příkaz*} [{*parametr-příkazu*}]... **&amp;**

*# požádat proces v popředí o ukončení*<br>
{_Ctrl_} **+** {_C_}

*# pozastavit proces v popředí a odsunout ho jako úlohu bashe*<br>
{_Ctrl_} **+** {_Z_}

*# přenést úlohu na popředí*<br>
*// Byla-li úloha pozastavená, tento příkaz ji nechá pokračovat.*<br>
**fg** [**%**{*číslo-úlohy*}]

*# vypsat seznam úloh*<br>
**jobs**

*# nechat pozastavenou úlohu pokračovat v pozadí*<br>
**bg** [**%**{*číslo-úlohy*}]

*# požádat úlohu o ukončení/násilně ji ukončit*<br>
**kill %**{*číslo-úlohy*}

*# počkat na dokončení úlohy běžící v pozadí*<br>
**wait %**{*číslo-úlohy*} [**%**{*číslo-další-úlohy*}]...

## Parametry příkazů

### ps

*# *<br>
**ps** {*parametry*} [**-e**]
**ps** {*parametry*} {*PID*}...

!Parametry:

* ☐ --no-headers :: Potlačí zobrazení hlavičky na začátku výpisu.
* ☐ -o {*sloupce*} :: Určí, které sloupce se vypíšou. Seznam platných hodnot najdete v manuálové stránce příkazu ps.
* ○ -e :: Zobrazit všechny procesy v systému. (Výchozí chování: zobrazí jen procesy příslušné témuž terminálu.)
* ☐ -H :: Odsadí názvy příkazů pro zdůraznění struktury stromu procesů.
* ☐ --sort {*klíče*} :: Nastaví řazení výpisu.

### pgrep

*# *<br>
**pgrep** [{*volby*}] **'**{*regulární výraz*}**'**<br>
**pgrep** [{*volby a kritéria*}] <nic>[**'**{*regulární výraz*}**'**]

**Volby:**

!Parametry:

* ☐ -x :: U regulárního výrazu požadovat přesnou shodu.
* ○ -o ○ -n ○ -v :: Z nalezených procesů vybrat: jen nejstarší proces/jen nejnovější proces/všechny procesy, které *nevyhovují* kritériím. (Výchozí: všechny procesy vyhovující kritériím.) Poznámka: staří procesu se zde posuzuje podle času spuštění.
* ☐ -f :: Regulární výraz testovat proti celé příkazové řádce procesu. (Normálně jen proti názvu procesu.)
* ☐ -d {*řetězec*} :: Nastavit oddělovač výpisu nalezených PID.
* ○ -c ○ -l ○ -a :: Vypsat: jen počet nalezených PID; PID a název procesu; PID a příkazový řádek procesu.
* ☐ -i :: Při testu regulárního výrazu nerozlišovat velká a malá písmena.

**Kritéria:**

!Parametry:

* ☐ -G {*gid-nebo-skupina*}... :: Vybrat podle skupiny (RGID).
* ☐ -P {*PPID*}... :: Vybrat podle PPID.
* ☐ -t {*terminál*}... :: Vybrat podle příslušného terminálu (např. „pts/1“).
* ☐ -u {*uid-nebo-uživatel*}... :: Vybrat podle EUID.
* ☐ -U {*uid-nebo-uživatel*}... :: Vybrat podle RUID.

## Instalace na Ubuntu

Většina uvedených příkazů je základními součástmi Ubuntu.
Pouze některé konkrétní příkazy ve stejnojmenných balíčcích je potřeba doinstalovat,
pokud je chcete použít:

*# *<br>
**sudo apt-get install iotop powertop**

V kapitole je použit také příkaz gawk:

*# *<br>
**sudo apt-get install gawk**

<!--
## Ukázka
<!- -
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)
-->

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Existuje také příkaz „pkill“, který kombinuje většinu schopností příkazu „pgrep“ s příkazem „kill“ – tzn. vyhledaným procesům rovnou zašle signál.
* Pokud rodič zanikne dřív než samotný proces, „adoptuje“ proces systemd.

## Další zdroje informací

* [Wikipedie: Proces](https://cs.wikipedia.org/wiki/Proces\_(informatika\))
* [Wikipedie: Vlákno](https://cs.wikipedia.org/wiki/Vl%C3%A1kno\_(informatika\))
* [Video: Linux in the Shell: pgrep and pkill](https://www.youtube.com/watch?v=6KIO4mkSz4w) (anglicky)
* [Video: Process Management Commands](https://www.youtube.com/watch?v=P8GrPOpD8Sk) (anglicky)
* [Video: Killing process in Linux](https://www.youtube.com/watch?v=AEp9YfKBV1c) (anglicky)
* [Video: How to use lsof command](https://www.youtube.com/watch?v=fsfquzq5Efo) (anglicky)
* [Tutorialspoint: pgrep, pkill](https://www.tutorialspoint.com/unix_commands/pgrep.htm) (anglicky)
* [A guide to the Linux „top“ command](https://www.booleanworld.com/guide-linux-top-command/) (anglicky)
* [Manual Page: pgrep, pkill](http://manpages.ubuntu.com/manpages/focal/en/man1/pgrep.1.html) (anglicky)
* [Manual Page: ps](http://manpages.ubuntu.com/manpages/focal/en/man1/ps.1.html) (anglicky)
* [TL;DR: ps](https://github.com/tldr-pages/tldr/blob/master/pages/common/ps.md) (anglicky)
* [Tutorialspoint: Process Management](https://www.tutorialspoint.com/unix/unix-processes.htm) (anglicky)
* [TL;DR: pgrep](https://github.com/tldr-pages/tldr/blob/master/pages/common/pgrep.md) (anglicky)

!ÚzkýRežim: vyp

## Pomocné funkce a skripty

*# lkk\_limit\_jobs() – počká, než počet úloh běžících na pozadí klesne na požadovanou úroveň nebo pod ni*<br>
**function lkk\_limit\_jobs() \{**<br>
<odsadit1>**local j r=0**<br>
<odsadit1>**while j=($(jobs -pr)); ((${#j[@]} &gt; ${1:-0}))**<br>
<odsadit1>**do wait -n; r=$?**<br>
<odsadit1>**done**<br>
<odsadit1>**return $r**<br>
**\}**

*# lkk procesy – vypíše přehled procesů ve snadno zpracovatelném tvaru*<br>
*// Procesy realizující samotný skript se nevypíšou, proto můžete při opakovaném volání dostat stejný výsledek.*<br>
**#!/bin/bash**<br>
**x=$(ps h -e -o pid,ppid)**<br>
**x=$(perl -MEnglish -e '**<br>
**my $stdin = \\\*STDIN; my $s; my %p;**<br>
**while (defined($s = scalar(readline($stdin)))) \{**<br>
<odsadit1>**my ($ppid, $pid) = split("\\x{0}", $s =~ s/^\\s\*(\\S+)\\s+(\\S+)\\s\*$/$2\\x{0}$1/r);**<br>
<odsadit1>**$p{$pid + 0} = $ppid + 0 if ($pid != $PID);**<br>
**\}**<br>
**c: foreach my $k (keys(%p)) \{**<br>
<odsadit1>**$s = $k;**<br>
<odsadit1>**while ($k &gt; 2) \{**<br>
<odsadit2>**next c if ($k == '\$\$');**<br>
<odsadit2>**$s = $s . ":" . ($k = $p{$k});**<br>
<odsadit1>**\}**<br>
<odsadit1>**print $s, "\\n";**<br>
**\}' &lt;&lt;&lt; "$x")**<br>
**sort -n &lt;&lt;&lt; "$x"**

<!--
**ps h -e -o pid,ppid \| perl -MEnglish -e '**<br>
**my $stdin = \\\*STDIN; my $s; my %p;**<br>
**while (defined($s = scalar(readline($stdin)))) \{**<br>
<odsadit1>**my ($ppid, $pid) = split("\\x{0}", $s =~ s/^\\s\*(\\S+)\\s+(\\S+)\\s\*$/$2\\x{0}$1/r);**<br>
<odsadit1>**$p{$pid + 0} = $ppid + 0 if ($pid != $PID);**<br>
**\}**<br>
**foreach my $k (keys(%p)) \{**<br>
<odsadit1>**print $k; while ($k &gt; 2) {print ":", $k = $p{$k}} print "\\n";**<br>
**\}' \| sort -n**
-->
