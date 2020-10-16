<!--

Linux Kniha kouzel, kapitola Ostatní
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Ostatní

!Štítky: {interní kapitola}{ostatní}
!ÚzkýRežim: zap

## Úvod
Tato kapitola slouží jako „skládka“ pro dosud nezařazené příklady.
Neměla by být součástí výsledné knihy.

!ÚzkýRežim: vyp

## Zaklínadla

*# počkat určitou dobu/1 minutu/1 milisekundu*<br>
**sleep** {*čas-v-sekundách*}<br>
**sleep 1m**<br>
**sleep 0.001**

*# zobrazit využití (volné a zaplněné místo) souborových systémů*<br>
**df -h -x devtmpfs -x squashfs -x vboxsf**
<!--
TODO: Vylepšit řazení; první pokus: | LC_ALL=C sort -k 6
-->

*# zobrazit „oznámení“ operačního systému*<br>
*// Vhodné ikony jsou např.: dialog-warning, dialog-error, dialog-information, ale můžete použít jakékoliv ikony nainstalované v systému (např. ikony nainstalovaných aplikací, zkuste „-i firefox“).*<br>
**notify-send** [**-i** {*ikona*}] <nic>[**-u** {*význam*}] **"**{*Titulek oznámení*}**"** [**"**{*Text oznámení*}**"**]

<!--
Kategorie: http://www.galago-project.org/specs/notification/0.9/x211.html
-->

*# vypsat banán*<br>
**printf \\\\U0001f34c\\\\n**

### Matematika

*# rozložit číslo na prvočísla*<br>
**factor** [{*kladnéceléčíslo*}]...

*# vyhledat prvočísla*<br>
**primes** [{*minumum*}] {*maximum*}
<!--
sudo apt-get install libmath-prime-util-perl
-->

*# vypočítat číslo pí na N desetinných míst*<br>
**printf '%s\\n' 'scale = 1 +** {*počet-desetinných-míst*}**' '4\*a(1)' \| bc -l \| tr -d '\\n\\\\' \| head -c -1**[**; echo**]

### Síť

*# ruční překlad doménového jména na IP adresu (pro člověka)*<br>
**host** {*doménové.jméno*}

*# ruční překlad IP adresy na doménové jméno (pro člověka)*<br>
**host** {*ip-adresa*}

### Jádro

*# vypsat načtené moduly (pro člověka/pro skript)*<br>
**lsmod**<br>
**cut -d "&blank;" -f 1 /proc/modules**

*# odpojit načtený jaderný modul*<br>
**sudo rmmod** {*název\_modulu*}

*# připojit jaderný modul*<br>
*// Jaderné moduly se nacházejí v podadresářích adresáře /lib/modules/(verze jádra).*<br>
**sudo insmod** {*/cesta/modul.ko*}

*# vypsat dostupné jaderné moduly*<br>
**find /lib/modules/$(uname -r) -type f -name '\*.ko' -printf '%f\\n'**<br>
**find /lib/modules/$(uname -r) -type f -name '\*.ko' \| sort \| sed -E 's!^(/[<nic>^/]\*){3}/(.\*)/([<nic>^/]+)\\.ko$!\\3\\t\\2!'**

### Metapříkazy

*# spustit příkaz jako superuživatel/jiný uživatel*<br>
**sudo** {*příkaz*} [{*parametry*}]...<br>
**sudo -u** {*uživatel*} {*příkaz*} [{*parametry*}]...

*# spustit příkaz místo aktuální instance příkazového interpretu*<br>
**exec** {*příkaz*} {*parametry*}

*# spustit příkaz a po jeho skončení vypsat, kolik času spotřeboval (kvůli ladění)*<br>
**time** {*příkaz*} {*parametry*}

*# spustit příkaz a ignorovat přitom aliasy, funkce a vestavěné příkazy*<br>
**command** {*příkaz*} {*parametry*}

*# spustit příkaz v odlišném prostředí a s jiným aktuálním adresářem*<br>
**env** [**-C** {*nový/aktuální/adresář*}] <nic>[**-i**] <nic>[**-u** {*PROMĚNNÁ*}]... [{*PROMĚNNÁ*}**='**{*nová hodnota*}**'**]... {*příkaz*}

*# spustit příkaz jako superuživatel/jiný uživatel (varianta pro GUI)*<br>
**pkexec** {*příkaz*} {*parametry*}<br>
**pkexec \-\-user** {*uživatel*} {*příkaz*} {*parametry*}

*# spustit příkaz na pozadí, který neskončí s volajícím shellem*<br>
*// Pokud výstup nepřesměrujete mimo terminál či konzoli, „nohup“ jej automaticky přesměruje do souboru „nohup.out“, popř. „~/nohup.out“.*
**nohup** {*příkaz*} {*parametry*}... [**&gt;/dev/null**] **&amp;**

*# spustit příkaz s jiným efektivním ID skupiny*<br>
**sg** {*skupina*} **'**{*příkaz*} [{*parametry*}]...**'**


<!--
Viz csvquote:
https://github.com/dbro/csvquote
-->


<!--
...
-->


### Koš

*# vysypat koš (nezkoušeno, install trash-cli)*<br>
**trash-empty**

*# vyhodit soubory do koše (nezkoušeno, install trash-cli)*<br>
**trash** {*soubor*}...
<!--
adresáře?
-->

### Jádro

*# seznam nainstalovaných jader*<br>
**linux-version list**

*# právě běžící jádro*<br>
**uname -r**



## Parametry příkazů
...

!ÚzkýRežim: zap

## Další zdroje informací
...

!ÚzkýRežim: vyp

<!--
How to Add Swap Space:
https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-16-04

-->

## Pomocné funkce a skripty

*# lkk\_strlen() – vypíše počet znaků v řetězcích předaných jako parametry*<br>
**function lkk\_strlen() \{**<br>
<odsadit1>**test $# -eq 0 &amp;&amp; return 1**<br>
<odsadit1>**while printf %s\\\\n "${#1}" &amp;&amp; shift &amp;&amp; test $# -gt 0**<br>
<odsadit1>**do :**<br>
<odsadit1>**done**<br>
**\}**
