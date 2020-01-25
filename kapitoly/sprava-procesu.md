<!--

Linux Kniha kouzel, kapitola Správa procesů
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

ps
pgrep
pstree
kill
lsof
/proc/PID

PID v Linuxu neznamená Pražská integrovaná doprava...

[ ] Stav běhu procesu?

⊨
-->

# Správa procesů

!Štítky: {tematický okruh}

!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Definice

* **Proces** je instance počítačového programu v paměti, identifikovaná systémově jedinečným číslem **PID** (obvykle v rozsahu 1 až 32768). Procesy v Linuxu mají rodinnou strukturu s jedním **rodičem** (PID rodiče je **PPID** jeho zrozenců). Když proces spustí nový proces, nový proces se automaticky stane jeho zrozencem a zdědí řadu jeho vlastností. (Poznámka: proces není vázaný na konkrétní program. Příkazem „exec“ lze spustit nový program bez vytvoření nového procesu − spuštěný program prostě přepíše stávající program se všemi důsledky.)
* **Démoni** jsou dva prvotní démoni „systemd“ (PID 1) a „kthreadd“ (PID 2) a ti jejich přímí potomci, kteří nemají textové ani grafické uživatelské rozhraní, a tedy běží na pozadí, bez kontaktu s uživatelem. (Poznámka: dva prvotní démoni jako procesy nemají rodiče, jsou zřízeni přímo jádrem a jejich PPID je 0.)
* **Zombie** je proces, který skončil, ale jeho rodič dosud nepřevzal jeho návratovou hodnotu. Převzetím návratové hodnoty rodičem je zombie **pohřbena** a její PID se uvolní pro přidělení dalšímu procesu.
* **Název** procesu je identifikátor přiřazený mu jádrem; odvozuje se od jména spuštěného programu, ale je zkrácený na maximálně 15 znaků.

<!--
[ ] Zjistit, zda těch 15 znaků platí i pro UTF-8 názvy.
-->

!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Zjistit informace o procesu podle PID

*# spuštěný **proces** (zkrácený název/plná cesta)*<br>
**ps -o comm:1= -p** {*PID*} ⊨ bash<br>
[**sudo**] **readlink /proc/**{*PID*}**/exe** ⊨ /bin/bash

*# **příkazový řádek** (pro člověka/txtz pro skript)*<br>
**tr \\\\0 \\\\40 &lt;/proc/**{*PID*}**/cmdline \| sed -E '$s/ ?$/\\n/' | cat -v**<br>
**cat /proc/**{*PID*}**/cmdline** [**\|** {*zpracování*}]

*# ARGV[0]*<br>
**head -zn1 /proc/**{*PID*}**/cmdline \| tr \\\\0 \\\\n**

*# **PPID***<br>
*// Pro procesy zřízené jádrem (systemd a kthreadd) vrací „0“.*<br>
**ps -o ppid:1= -p** {*PID*} ⊨ 3077

*# příslušný **terminál***<br>
*// Nepříluší-li proces žádnému terminálu ani konzoli, vypíše „?“.*<br>
**ps -o tty:1= -p** {*PID*} ⊨ pts/1

*# aktuální **adresář***<br>
[**sudo**] **readlink /proc/**{*PID*}**/cwd** ⊨ /home/pavel

*# **uživatel** vlastnící proces (jméno/UID)*<br>
**ps -o ruser:1= -p** {*PID*}  ⊨ root<br>
**ps -o ruid:1= -p** {*PID*}  ⊨ 0

*# **skupina** vlastnící proces (jméno/GID)*<br>
**ps -o rgroup:1= -p** {*PID*}  ⊨ root<br>
**ps -o rgid:1= -p** {*PID*}  ⊨ 0

*# čas od spuštění procesu (v sekundách/ve formátu [[DD-]hh:]mm:ss)*<br>
**ps -o etimes:1= -p** {*PID*} ⊨ 271<br>
**ps -o etime:1= -p** {*PID*} ⊨ 04:31

*# čas, od kdy proces existuje*<br>
**date -d "$(ps -o lstart= -p** {*PID*}**)" "+%F %T %z"**

*# spotřebovaný čas procesoru*<br>
**ps -p** {*PID*} **-o cputime:1=** ⊨ 00:01:13

*# počet bajtů přečtených z disku/**zapsaných na disk***<br>
[**sudo**] **sed -E 's/read\_bytes:\\s+//;t;d' /proc/**{*PID*}**/io**<br>
[**sudo**] **sed -E 's/write\_bytes:\\s+//;t;d' /proc/**{*PID*}**/io**

*# **priorita** procesu*<br>
**ps -o ni:1= -p** {*PID*} ⊨ 0

*# seznam otevřených deskriptorů (jen čísla/s cestami k souborům)*<br>
[**sudo**] **ls -U1 /proc/**{*PID*}**/fd**<br>
[**sudo**] **find /proc/**{*PID*}**/fd -type l -printf '%f\\t%l\\n'**

*# vypsat prostředí procesu ve formátu txtz*<br>
*// Každý záznam začíná názvem proměnné prostředí a znakem „=“, za ním následuje obsah proměnné.*<br>
[**sudo**] **cat /proc/**{*PID*}**/environ** [**\|** {*zpracování*}]

*# označení sezení podle systemd*<br>
**ps -o lsession:1= -p** {*PID*} ⊨ 00:01:13

*# efektivní uživatel (jméno/EUID)*<br>
**ps -o euser:1= -p** {*PID*}  ⊨ root<br>
**ps -o euid:1= -p** {*PID*}  ⊨ 0

*# efektivní skupina (jméno/EGID)*<br>
**ps -o egroup:1= -p** {*PID*}  ⊨ root<br>
**ps -o egid:1= -p** {*PID*} ⊨ 0

*# počet vláken *<br>
**sed -E 's/^Threads:\\s+//;t;d' /proc/**{*PID*}**/status**

*# číslo přiděleného logického procesoru (od nuly)*<br>
**ps -o psr:1= -p** {*PID*} ⊨ 0


### Zjistit okamžité zatížení procesoru, RAM apod.

*# % zatížení procesoru*<br>
**ps -o pcpu:1= -p** {*PID*} ⊨ 10.1

*# počet kiB **RAM** zabrané procesem*<br>
**ps -o rss:1= -p** {*PID*}

*# % RAM zabrané procesem*<br>
**ps -o pmem:1= -p** {*PID*} ⊨ 0.1

*# velikost virtuální paměti procesu v kiB*<br>
**ps -o vsz:1= -p** {*PID*}

*# počet kiB virtuální paměti zabrané kódem/daty*<br>
**ps -o trs:1= -p** {*PID*}<br>
**ps -o drs:1= -p** {*PID*}

*# procesy, které nejvíc zatěžují procesor/RAM*<br>
**ps -e -o pcpu=,pid=,comm= \| sort -rn \| head**<br>
**ps -e -o rss=,pid=,comm= \| sort -rn \| head**<br>

*# procesy, které nejvíc pracují s diskem*<br>
**sudo egrep -H '^(read\|write)\_bytes:' /proc/[1-9]\*/io &gt;**{*dočasný/soubor/1*}<br>
**sleep 1;sudo egrep -H '^(read\|write)\_bytes:' /proc/[1-9]\*/io &gt;**{*dočasný/soubor/2*}<br>
**gawk 'BEGIN {FS="/\|: ?"; OFS = "\\t";} ARGIND == 1 {A[$3] += $6} ARGIND == 2 {B[$3] += $6} END {for (pid in A) {if (pid in B) {print B[pid] - A[pid], pid}}}'** {*dočasný/soubor/1*} {*dočasný/soubor/2*} **\| sort -rn \| head**

### TUI

*# procesy nejvíc zatěžující CPU*<br>
**top**

*# procesy zabírající nejvíc paměti RAM*<br>
?

*# procesy nejvíc vytěžující pevný disk*<br>
**sudo iotop**

*# procesy spotřebovávající nejvíc elektřiny*<br>
?

### Ovládání procesů

*# požádat o ukončení/násilně ukončit*<br>
[**sudo**] **kill** {*PID*}...<br>
[**sudo**] **kill -9** {*PID*}...

*# zaslat procesu signál*<br>
[**sudo**] **kill -**[{*signál*}] {*PID*}...

*# spustit proces s nastavenou prioritou (ne vyšší/libovolnou)*<br>
**nice -n $((**{*priorita*} **- $(nice)))** {*příkaz*} [{*parametry příkazu*}]...
**sudo nice -n $((**{*priorita*} **- $(nice))) sudo -u "$(id -nu)" -g "$(id -ng)"** {*příkaz*} [{*parametry příkazu*}]...

*# změnit prioritu běžícího procesu*<br>
*// Priorita je číslo v rozsahu -20 (nejvyšší) až 19 (nejnižší); normální priorita je 0. Obyčejný uživatel (tzn. bez sudo) může pouze snižovat prioritu vlastních procesů.*<br>
[**sudo**] **renice** {*priorita*} {*PID*}...

### Najít procesy

*# všechny procesy*<br>
**ps -o pid:1= -e**

*# potomci určitého procesu*<br>
**ps -o pid:1= \-\-ppid** {*ID-předka*}

*# všichni předci určitého procesu po prvotního démona*<br>
?

*# všechny procesy určitého uživatele/určité skupiny*<br>
**ps -o pid:1= -U** {*uživatel*}[**,**{*další-uživatel*}]...<br>
**ps -o pid:1= -G** {*skupina*}[**,**{*další-skupina*}]...

## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

### ps

*# *<br>
**ps** {*parametry*}

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíčků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

Příkazy ps, kill, nice, renice a podpůrné příkazy egrep, sed, ... jsou základními součástmi Ubuntu.

V kapitole je použit také příkaz gawk:

*# *<br>
**sudo apt-get install gawk**

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

* Pokud rodič zanikne dřív než samotný proces, „adoptuje“ proces systemd.

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
