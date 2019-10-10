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


## Parametry příkazů
...

## Odkazy
...
