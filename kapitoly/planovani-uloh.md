<!--

Linux Kniha kouzel, kapitola Plánování úloh
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Plánování úloh

!Štítky: {tematický okruh}{čas}
!ÚzkýRežim: zap

## Úvod
V této kapitole se dozvíte, jak spouštět příkazy automaticky v určený čas.
Linux na tento účel poskytuje dva oddělené mechanismy: prastarý démon „cron“
slouží k pravidelnému (opakovanému) spouštění příkazů, zatímco méně věhlasný
„at“ slouží k naplánování jednorázových úkolů, které budou spuštěny
a zapomenuty. V praxi se ale ke spouštění opakovaných úloh používá i at,
jen je potřeba v rámci každého spuštění úlohy naplánovat její další spuštění.

Mezi cronem a atem je ještě jeden podstatný rozdíl: pokud v době,
kdy má naplánovaná úloha proběhnout, počítač neběží, cron dané spuštění
jednoduše vynechá, zatímco at spustí naplánovanou úlohu,
hned jak to bude možné.

Oběma mechanismům je také společné omezení přesnosti − spuštění lze nastavit
jen s přesností na minuty. Potřebujete-li přesnější zacílení, je třeba,
aby si přesný čas ohlídal až spuštěný proces.

Poznámka: Každý uživatel má vlastní seznam úloh a ty se spouštějí
pod jeho uživatelským účtem. Vedle toho existují i systémové úlohy,
spouštěné pod účtem superuživatele, ty však nejsou touto verzí kapitoly pokryty.

## Definice

* **Úloha** je příkaz naplánovaný k jednorázovému spuštění, jde-li o **jednorázovou úlohu**, nebo k pravidelnému spouštění, jde-li o **pravidelnou úlohu**. Tímto příkazem bývá nejčastěji volání uživatelem definovaného skriptu.

!ÚzkýRežim: vyp

## Zaklínadla

### Pravidelné úlohy (obecně)

Plán − viz podsekci „Pravidelné úlohy (plány)“.

*# **přidat** nebo **nahradit** úlohu (spustit na pozadí/spustit v grafickém prostředí)*<br>
**pridat\_ulohu** {*id-úlohy*} {*plán*} **'**{*příkaz a parametry*}**'**<br>
**pridat\_ulohu** {*id-úlohy*} {*plán*} **'\~/bin/spustit-v-x** {*příkaz a parametry*}**'**

*# **vypsat** seznam úloh (id je na konci řádku, za znakem „#“)/vypsat konkrétní úlohu*<br>
*// Poznámka: Znaky „\\“ a „%“ jsou ve výpisu escapovány, protože mají pro crontab speciální význam.*<br>
**crontab -l**<br>
**crontab -l \| egrep '#**{*id-úlohy*}**$'**

*# **zrušit** úlohu/všechny úlohy*<br>
**crontab -l \| egrep -v '#**{*id-úlohy*}**$' \| crontab -**<br>
**crontab -r**

*# **změnit** plán úlohy*<br>
*// Vyžaduje nainstalovat balíček „gawk“.*<br>
**crontab -l \| gawk '{ if (/#**{*id-úlohy*}**$/ &amp;&amp; match($0, /^(([^&blank;]+&blank;){5}\|@[a-z]+&blank;)/)) {print** {*nový-plán*} **substr($0, RLENGTH)} else {print}}' \| crontab -**

*# uložit tabulku úloh do souboru/načíst ze souboru*<br>
**crontab -l &gt;** {*soubor*}<br>
**crontab** {*soubor*}

*# vypsat cizí seznam pravidelných úloh*<br>
**sudo crontab -l -u** {*cílový-uživatel*}


### Pravidelné úlohy (systémové)

*# vypsat seznam systémových pravidelných úloh*<br>
?

### Pravidelné úlohy (plány)

*# spouštět každou **hodinu**/každou hodinu od 10.00 do 15.59*<br>
**"**{*číslo-minuty*} **\* \* \* \*"**<br>
**"**{*číslo-minuty*} **10-15 \* \* \*"**

*# spouštět každou **minutu***<br>
**"\* \* \* \* \*"**

*# spouštět každých pět minut (alternativy)*<br>
**"\*/5 \* \* \* \*"**<br>
**"0,5,10,15,20,25,30,35,40,45,50,55 \* \* \* \*"**

*# spouštět hned po startu systému/spouštět po přihlášení*<br>
**"@reboot"**<br>
?

*# spouštět **denně**/denně, ale jen od pondělí do pátku*<br>
**"**{*číslo-minuty*} {*číslo-hodiny*} **\* \* \*"**<br>
**"**{*číslo-minuty*} {*číslo-hodiny*} **\* \* 1-5"**

*# spouštět **týdně**, každé pondělí/každou neděli*<br>
**"**{*číslo-minuty*} {*číslo-hodiny*} **\* \* 1"**<br>
**"**{*číslo-minuty*} {*číslo-hodiny*} **\* \* 7"**

*# spouštět **měsíčně** v N-tý den měsíce*<br>
**"**{*číslo-minuty*} {*číslo-hodiny*} {*N*} **\* \*"**

*# spouštět v druhé a čtvrté pondělí od května do září včetně (celý příkaz)*<br>
*// Rozsahy dnů pro N-tý den týdne v měsíci jsou: první: 1-7, druhý: 8-14, třetí: 15-21, čtvrtý: 22-28, pátý: 29-31.*<br>
**pridat\_ulohu** {*id-úlohy*} **"**{*číslo-minuty*} {*číslo-hodiny*} **8-14,22-28 5-9 \*" 'test $(date +%u) -eq 1 &amp;&amp;** {*příkaz*}**'**

*# spouštět jednou ročně v určitý den*<br>
**"**{*číslo-minuty*} {*číslo-hodiny*} {*číslo-dne-v-měsíci*} {*číslo-měsíce*} **\*"**

*# spouštět v poledne 29. února každého přestupného roku*<br>
**"0 12 29 2 \*"**

*# spouštět v poledne každou adventní neděli (celý příkaz)*<br>
*// Uvedený příkaz využívá skutečnost, že adventní neděle se vyskytují pouze v období 27. listopadu až 24. prosince včetně.*<br>
**pridat\_ulohu** {*id-úlohy*} **"0 12 \* 11-12 7" 'test 1127 -le $(date +%m%d) -a $(date +%m%d) -le 1224 &amp;&amp;** {*příkaz*}**'**

### Jednorázové úlohy

Plán − viz sekci „Jednorázové úlohy (plány)“. Plán se zde neuzavírá do uvozovek!

*# **přidat** úlohu*<br>
**printf "%s\\\\n" '**{*příkaz*}**'**... **\| at** {*plán*}

*# **vypsat** úlohy (číslo úlohy je v prvním sloupci)*<br>
**atq**

*# **zrušit** úlohu/všechny úlohy*<br>
**atrm** {*číslo-úlohy*}<br>
**atq \| cut -f 1 \| xargs -r atrm**

*# **změnit** plán úlohy*<br>
?

*# vypsat obsah úlohy*<br>
**at -c** {*číslo-úlohy*}

### Jednorázové úlohy (plány)

*# spustit v přesně zadaný čas/31. prosince 2030 ve 2 hodiny a 3 minuty*<br>
*// Hodina, minuta, měsíc a den musí být zadány dvěma číslicemi.*<br>
{*hodina*}**:**{*minuta*} [{*rok*}**-**{*měsíc*}**-**{*den*}]<br>
**02:03 2030-12-31**

*# spustit při příštím startu systému/při příštím přihlášení*<br>
?<br>
?

*# spustit dnes/zítra v 15.30*<br>
**15:30 today**<br>
**15:30 tomorrow**

*# spustit příští úterý ve 12.00*<br>
**12:00 next tuesday**

*# spustit v poledne druhého dne příštího měsíce*<br>
?


## Parametry příkazů

*# *<br>
**crontab -**<br>
**crontab** {*soubor*}<br>
**crontab** {*parametry*}

* **-l** \:\: Vypíše tabulku úloh.
* **-u** {*uživatel*} \:\: Bude pracovat s tabulkou úloh zadaného uživatele (vyžaduje „sudo“).
* **-r** \:\: Smaže tabulku úloh.

*# *<br>
**at** {*plán*}<br>
**atq**<br>
**atrm** {*číslo-úlohy*}...<br>
**at -c** {*číslo-úlohy*}...

Poznámka: Příkaz „at“ očekává na standardním vstupu skript k provedení.

## Instalace na Ubuntu
*# *<br>
**sudo apt-get install at gawk**

Démon „cron“ je základní systémovou součástí Ubuntu a mnoha linuxových
distribucí, proto zpravidla není třeba ho instalovat.

## Ukázka
*# *<br>
**mkdir -pv \~/moje\_ulohy**<br>
**cd ~/moje\_ulohy**<br>
**printf %s\\\\n \\**<br>
<odsadit1>**'cd' \\**<br>
<odsadit1>**'sleep 7' \\**<br>
<odsadit1>**'mplayer /usr/share/sounds/sound-icons/piano-3.wav &amp;' \\**<br>
<odsadit1>**'sleep 0.5' \\**<br>
<odsadit1>**'notify-send -i dialog-information "Další minuta uplynula."' &gt;uloha-minuta**<br>
**function pridat\_ulohu () \{**<br>
**(tmp="$2 %s #$1\\\\n"; crontab -l 2&gt;/dev/null \| egrep -v "#$1\\$"; shift 2; printf "$tmp" "$@" \| sed -e 's/\\\\/\\\\\\\\/g' -e 's/%/\\\\%/g') \| crontab -**<br>
**\}**<br>
**pridat\_ulohu minuta "\* \* \* \* \*" "~/bin/spustit-v-x bash ~/moje\_ulohy/uloha-minuta"**

Poznámka: ukázka vyžaduje nainstalovaný balíček „mplayer“ (a pochopitelně nainstalovaný pomocný skript „~/bin/spustit-v-x“).

!ÚzkýRežim: zap

## Tipy a zkušenosti
* Pro jakoukoliv netriviální pravidelnou úlohu doporučuji vytvořit samostatný skript a funkci „pridat\_ulohu“ předat volání tohoto skriptu místo vlastních příkazů. Má to celou řadu výhod, např. možnost obsah úlohy editovat, možnost mít víc řádků a použít bash místo /bin/sh. Další výhodou je, že definice se v případě smazání úlohy neztratí a je ji možno použít opakovaně.
* Naplánované úlohy jsou spouštěny mimo terminál a mimo grafické prostředí, což komplikuje jejich ladění.
* Ačkoliv mi sekundy u příkazu „at“ nefungují, skript se spouští velmi přesně v nultou sekundu požadované minuty, což vybízí k použití příkazu „sleep“ na začátku spouštěného skriptu k dosažení spuštění v určitou sekundu minuty. Cron tak přesný není.
* Cron spustí další instanci úlohy i v případě, že předchozí instance ještě běží.
* Pokud se pravidelná úloha nespustila, zkuste prozkoumat logy, které zobrazíte příkazem:<br>„fgrep CRON /var/log/syslog“. Mohou obsahovat odpovídající chybové hlášení.

## Další zdroje informací
*# *<br>
**man 5 crontab**<br>
**man 1 crontab**<br>
**man at**

* [Stránka na Wikipedii: Cron](https://cs.wikipedia.org/wiki/Cron)
* [Stránka na Wikipedii: At](https://cs.wikipedia.org/wiki/At\_(Unix\))
* [Článek na Root.cz: Cron: naplánovanie opakujúcich sa procesov](https://www.root.cz/clanky/cron-naplanovanie-opakujucich-sa-procesov/) (slovensky)
* [Článek Cron − správca úloh](https://www.linuxexpres.cz/praxe/cron-spravca-uloh) (slovensky)
* [Video „Linux/Mac Tutorial: Cron Jobs“](https://www.youtube.com/watch?v=QZJ1drMQz1A) (anglicky)
* [Video „Crontab Command − 15 Cronjob Scheduling Examples in Linux“](https://www.youtube.com/watch?v=6dJlp133iYg) (anglicky)
* [Manuálová stránka „at“](http://manpages.ubuntu.com/manpages/bionic/en/man1/at.1posix.html) (anglicky)
* [Bionic: balíček „at“](https://packages.ubuntu.com/bionic/at) (anglicky)
* [Bionic: balíček „bcron-run“](https://packages.ubuntu.com/bionic/bcron-run) (anglicky)
* [TL;DR stránka „crontab“](https://github.com/tldr-pages/tldr/blob/master/pages/common/crontab.md) (anglicky)

!ÚzkýRežim: vyp

## Pomocné funkce a skripty

*# pridat\_ulohu() − přidá nebo nahradí pravidelnou úlohu*<br>
*// Vyžadovaná pro přidávání pravidelných úloh.*<br>
*// Poznámka: Příkazy zadávané pomocí této funkce nesmějí obsahovat znak konce řádku. Vyžaduje-li vaše úloha více příkazů nebo komplikovanější konstrukce, zapište ji do skriptu a z úlohy spouštějte daný skript.*<br>
**function pridat\_ulohu () \{**<br>
**(tmp="$2 %s #$1\\\\n"; crontab -l 2&gt;/dev/null \| egrep -v "#$1\\$"; shift 2; printf "$tmp" "$@" \| sed -e 's/\\\\/\\\\\\\\/g' -e 's/%/\\\\%/g') \| crontab -**<br>
**\}**

*# lkk spustit-v-x − slouží ke spouštění grafických aplikací z naplánovaných úloh*<br>
*// Tento skript je vyžadován pro spouštění grafických aplikací z naplánovaných úloh. Pro správný běh takto spuštěných aplikací může být nutno doplnit do seznamu u příkazu „egrep“ mnoho dalších proměnných.*<br>
**#!/bin/bash -e**<br>
**function f () \{**<br>
**local xpid="$(pgrep -u "$(whoami)" '^[A-Za-z0-9]\*-session$' \| head -n 1)"**<br>
**test -n "$xpid" || exit 1**<br>
**eval "$(egrep -z '^(DBUS\_SESSION\_BUS\_ADDRESS\|DISPLAY\|XDG\_[A-Z\_]+)=' /proc/$xpid/environ \| tr \\\\0 \\\\n \| sed -e s/=/\\\\n/ -e s/\\'/\\'\\\\\\\\\\'\\'/g \| xargs -rd \\\\n printf "export %s='%s'\\\\n")"**<br>
**\}**<br>
**f**<br>
**exec "$@"**
