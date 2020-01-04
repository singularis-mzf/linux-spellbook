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

*# vypočítat číslo pí na N desetinných míst*<br>
**printf '%s\\n' 'scale = 1 +** {*počet-desetinných-míst*}**' '4\*a(1)' \| bc -l \| tr -d '\\n\\\\' \| head -c -1**[**; echo**]

*# vygenerovat UUID (náhodné/zahrnující místo a čas/kryptograficky bezpečné)*<br>
**uuid -v 4**<br>
**uuid**<br>
**uuidgen -r**

*# konvertovat obrázek na „data URL“/z „data URL“*<br>
**printf "data:%s;base64," "$(file -b \-\-mime-type "**{*soubor*}**")"; base64 -w 0** {*soubor*}<br>
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
**notify-send** [**-i** {*ikona*}] <nic>[**-u** {*význam*}] **"**{*Titulek oznámení*}**"** [**"**{*Text oznámení*}**"**]

<!--
Kategorie: http://www.galago-project.org/specs/notification/0.9/x211.html
-->

*# vypsat banán*<br>
**printf \\\\U0001f34c\\\\n**

### date

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


### QR a EAN kódy

*# vygenerovat QR kód (zadat text/ze standardního vstupu)*<br>
*// Typ obrázku může být PNG, SVG, ASCII a některé další. Výstupu na standardní výstup lze dosáhnout zadáním „-“ místo výstupního souboru.*<br>
**qrencode** [**-o** {*výstupní-soubor*}] <nic>[**-t** {*typ-obrázku*}] <nic>[**-s** {*rozměr-čtverečku*}] <nic>[**\-\-foreground=**{*barva*}] <nic>[**\-\-background=**{*barva*}] **"**{*text*}**"**<br>
**qrencode** [**-o** {*výstupní-soubor*}] <nic>[**-t** {*typ-obrázku*}] <nic>[**-s** {*rozměr-čtverečku*}] <nic>[**\-\-foreground=**{*barva*}] <nic>[**\-\-background=**{*barva*}]
<!--
Vyžaduje balík: qrencode
-->

*# přečíst QR kód (pro skript/pro člověka)*<br>
**zbarimg -q \-\-raw** {*vstupní-obrázek*}<br>
**zbarimg** {*vstupní-obrázek*}
<!--
Vyžaduje balík „zbar-tools“.
-->

*# vygenerovat EAN kód*<br>
*// Zadané číslo musí být dlouhé 12 nebo 7 číslic, případně 13 nebo 8 číslic s platným kontrolním součtem. Šířka a výška mohou být libovolné, ale pro EAN kódy je vhodné, když jsou v poměru 5:4, např. „1024x819“. Výstupní obrázek bude ve skutečnosti ještě o něco větší, protože kromě samotného kódu zahrnuje i text a okraje.*<br>
**barcode -b** {*číslobezpomlček*} **-e EAN -E** [**-g** {*šířka-kódu*}**x**{*výška-kódu*}] **\| ps2pdf -dEPSCrop -** {*název-souboru.pdf*}
<!--
Vyžaduje balík „barcode“ a povolit čtení formátu EPS.
Také možno „**epspdf** {*název-souboru*}**.eps**“ a umí konverzi na grayscale, ale vyžaduje balík „texlive-pictures“.
-->

*# vygenerovat EAN kód pro ISBN*<br>
**barcode -b** {*ISBN-s-pomlčkami*} **-e ISBN -E** [**-g** {*šířka-kódu*}**x**{*výška-kódu*}] **\| ps2pdf -dEPSCrop -** {*název-souboru.pdf*}


*# přečíst EAN kód (pro skript/pro člověka)*<br>
*// Výstup obou příkazů je bez pomlček.*<br>
**zbarimg -q \-\-raw** {*vstupní-obrázek*}<br>
**zbarimg** {*vstupní-obrázek*}
<!--
Vyžaduje balík „zbar-tools“.
-->

<!--
Viz csvquote:
https://github.com/dbro/csvquote
-->


<!--
...
-->


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

