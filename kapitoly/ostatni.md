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

## Úvod
Tato kapitola slouží jako „skládka“ pro dosud nezařazené příklady.
Neměla by být součástí výsledné knihy.

## Zaklínadla

*# vypočítat číslo pí na N desetinných míst*<br>
**printf '%s\\n' 'scale = 1 +** {*počet-desetinných-míst*}**' '4\*a(1)' \| bc -l \| tr -d '\\n\\\\' \| head -c -1**[**; echo**]

*# vygenerovat UUID (náhodné/zahrnující místo a čas/kryptograficky bezpečné)*<br>
**uuid -v 4**<br>
**uuid**<br>
**uuidgen -r**

*# vypočítat hexidecimální hashe souborů, každý hash na nový řádek (CRC32/MD5/SHA1/SHA256)*<br>
**crc32** {*soubor*}... **\| cut -d '&blank;' -f 1**<br>
**md5sum** {*soubor*}... **\| cut -d '&blank;' -f 1**<br>
**sha1sum** {*soubor*}... **\| cut -d '&blank;' -f 1**<br>
**sha256sum** {*soubor*}... **\| cut -d '&blank;' -f 1**

*# vypočítat/ověřit kontrolní součty (MD5)*<br>
*// Hashe souborů a jejich názvy se uloží do souboru „soubory.md5“.*<br>
**md5sum** {*soubor*}... **&gt; soubory.md5**<br>
**md5sum -c soubory.md5**

*# vypočítat/ověřit kontrolní součty (SHA256)*<br>
*// Analogicky můžete také použít příkazy „sha1sum“, „sha224sum“, „sha384sum“ a „sha512sum“. Existuje také obecný „shasum“.*<br>
**sha256sum** {*soubor*}... **&gt; soubory.sha256**<br>
**sha256sum -c soubory.sha256**

*# zkrátit či prodloužit soubor na uvedenou velikost*<br>
*// Prodlužuje se nulovými bajty.*<br>
**truncate -s** {*velikost*} {*soubor*}...

*# konvertovat obrázek na „data URL“/z „data URL“*<br>
**printf "data:%s;base64," "$(file -b --mime-type "**{*soubor*}**")"; base64 -w 0** {*soubor*}<br>
**printf "%s\\n" "**{*data-url*}**" \| cut -d , -f 2- -s \| base64 -d &gt;** {*výstupní-soubor*}

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
**notify-send** [**-i** {*ikona*}] [**-u** {*význam*}] "{*Titulek oznámení*}" ["{*Text oznámení*}"]

<!--
Kategorie: http://www.galago-project.org/specs/notification/0.9/x211.html
-->

*# vytvořit použitelný odkládací soubor*<br>
[**sudo**] **fallocate -vl** {*velikost*} {*odkládací-soubor*}<br>
**sudo chown root:root** {*odkládací-soubor*}<br>
**sudo chmod 600** {*odkládací-soubor*}<br>
**sudo mkswap** {*odkládací-soubor*}

*# zapnout existující odkládací soubor (platí jen do restartu)*<br>
**sudo swapon** {*odkládací-soubor*}

*# vypnout existující odkládací soubor*<br>
**sudo swapoff** {*odkládací-soubor*}

*# smazat vypnutý odkládací soubor*<br>
**sudo rm** {*odkládací-soubor*}

*# konverze časové zóny*<br>
**TZ="**{*cílová-zóna*}**" date -d 'TZ="**{*zdrojová-zóna*}**"** {*zdrojový-čas*}**'** [**"+**{*formát*}**"**]

*# konverze na/z časovou známku Unixu*<br>
**date -d '**[**TZ=**{*časová-zóna*}**&blank;**]{*čas*}**' +%s**<br>
[**TZ="**{*časová-zóna*}**"**] **date -d @**{*časová-známka-Unixu*} [**+**{*formát*}]

### date
<!--
TODO: Zamyslet se nad formátováním.
-->
*# den v týdnu (alternativy)*<br>
**%A = Úterý (plný název, lokalizovaný)**<br>
**%a = Út (zkratka, lokalizovaná)**<br>
**%u = 2 (číslo 1..7, kde 1 je pondělí)**<br>
**%w = 2 (číslo 0..6, kde 0 je neděle)**

*# rok (alternativy)*<br>
**%Y = 2010 (4 číslice)**<br>
**%C = 20 (století)**<br>
**%y = 10 (dvojčíslí roku)**

*# čtvrtletí*<br>
**%q = 3 (číslo 1..4)**

*# měsíc (alternativy)*<br>
**%m = 03 (číslo)**<br>
**%B = listopad (plný název, lokalizovaný)**<br>
**%b = lis (zkratka, lokalizovaná)**

*# den v měsíci (alternativy)*<br>
**%d = 03 (číslo)**<br>
**%e = &blank;3 (číslo zarovnané mezerou)**

*# hodina + období dne (alternativy)*<br>
**%H = 15 (číslo 00..23)**<br>
**%I = 03 (číslo 01..12)**<br>
**%p = AM/PM (lokalizovaně)**<br>
**%P = am/pm (lokalizovaně)**

*# minuta*<br>
**%M = 59 (číslo 00..59)**

*# sekunda*<br>
**%S = 59 (číslo 00..61)**

*# nanosekundy*<br>
**%N = 123456789 (počítadlo nanosekund)**

*# časová zóna*<br>
**%Z = CET (zkratka časové zóny)**<br>
**%z = +0100**<br>
**%:z = +01:00**<br>
**%::z = +01:00:00**<br>
**%:::z = +01 (nejkratší přesné vyjádření)**<br>

*# číslo týdne podle ISO normy (týden začíná pondělím)*<br>
**%G = 2010 (celé číslo roku)**<br>
**%g = 10 (dvojčíslí roku)**<br>
**%V = 03 (číslo týdne 01..53)**

*# číslo týdne v roce*<br>
**%W = 07 (00..53, týden začíná pondělím)**<br>
**%U = 07 (00..53, týden začíná nedělí)**

*# escapované znaky (alternativy)*<br>
**%% = %**<br>
**%n = konec řádku**<br>
**%t = tabulátor**

*# počet sekund od 00:00:00 1. ledna 1970 UTC*<br>
**%s**

*# číslo dne v roce*<br>
**%j**

*# lokalizované celky*<br>
**%x = datum**<br>
**%X = čas (24hodinový)**<br>
**%r = čas (12hodinový)**<br>
**%c = datum a čas (24hodinový)**

*# nelokalizované celky*<br>
**%D = %m/%d/%y**<br>
**%F = %Y-%m-%d**<br>
**%R = %H:%M**<br>
**%T = %H:%M:%S**

<!--
...
-->


## Parametry příkazů
...

## Odkazy
...

<!--
How to Add Swap Space:
https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-16-04

-->

