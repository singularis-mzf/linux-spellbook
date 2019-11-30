<!--

Linux Kniha kouzel, kapitola X (ovládání oken)
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

-->

# X (ovládání oken)

!Štítky: {tematický okruh}{GUI}{automatizace}{klávesnice}{myš}

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

Velké písmeno „X“ odpradávna označovalo cosi záhadného a tajuplného. Toho si pravděpodobně
byli vědomi vývojáři, když v roce 1984 pojmenovali grafické rozhraní X Window System;
pravděpodobně znali především příkazovou řádku a děrné štítky, zatímco grafické rozhraní jim
bylo něčím novým, záhadným a tajuplným. Netušili však, že o padesát let později na tom budou
uživatelé-začátečníci přesně naopak.
<!--
Zdroj roku: https://en.wikipedia.org/wiki/X_Window_System#Release_history
-->

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

* Okno (+ titulek + pozice(počítá se od levého horního rohu plochy)) Zmínit také speciální okna jako plochu, panely, doky apod.
* Virtuální plocha
* Zaměřené okno

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Okna (najít ID)

*# získat seznam ID oken (výpis pro člověka/jen ID pro skript)*<br>
*// Sloupce: ID okna, číslo virtuální plochy, PID (jen s „-p“); s „-G“ pozice-x, pozice-y, šířka a výška; zbytek řádku obsahuje titulek okna.*<br>
**wmctrl -l** [**-p**] [**-G**]<br>
**wmctrl -l \| cut -d "&blank;" -f 1**

*# získat ID právě zaměřeného okna*<br>
**xdotool getactivewindow**

*# ID oken, jejichž titulek vyhovuje regulárnímu výrazu*<br>
**wmctrl -l \| egrep** [**-i**] [**-v**] **"^([^&blank;]+&blank;+){3}**{*regulární výraz*}**\\$" \| cut -d "&blank;" -f 1**

*# ID oken příslušných k určitému PID*<br>
**wmctrl -lp \| egrep "^([^&blank;]+&blank;+){2}**{*PID*}**&blank;" \| cut -d "&blank;" -f 1**

### Práce s okny

*# zaměřit okno*<br>
**wmctrl -ia** {*id-okna*}

*# přesunout okno a nastavit velikost/vypsat pozici a velikost okna v pixelech*<br>
**wmctrl -ir** {*id-okna*} **-e 0,**{*posun-x*}**,**{*posun-y*}**,**{*šířka*}**,**{*výška*}<br>
**xwininfo -id** {*id-okna*} **\| egrep "^&blank;&blank;-geometry"**

*# nastavit/vypsat titulek okna*<br>
**wmctrl -ir** {*id-okna*} **-T "**{*nový titulek*}**"**<br>
**xdotool getwindowname** {*id-okna*}

*# zavřít okno („křížkem“/násilně ukončit celý program)*<br>
*// Pozor, má-li daný proces otevřených víc oken (typické např. pro webové prohlížeče), po provedení „xkill“ zmizí všechna, protože xkill nezavírá okno, ale ukončuje proces!*<br>
**wmctrl -ic** {*id-okna*}
**xkill -id** {*id-okna*}

*# vypsat PID příslušné k oknu*<br>
**xdotool getwindowpid** {*id-okna*}

*# vypsat kompletní příkaz, kterým byl spuštěn proces, který otevřel okno*<br>
**ps -o command= -p $(xdotool getwindowpid** {*id-okna*}**)**

*# přesunout okno bez změny velikosti*<br>
**wmctrl -ir** {*id-okna*} **-e 0,**{*posun-x*}**,**{*posun-y*}**,$(xwininfo -id** {*id-okna*} **\| egrep "^&blank;&blank;-geometry" \| egrep -o [0-9]+x[0-9]+ \| tr x ,)**

*# vypsat oknem dovolené akce*<br>
*// Známé akce jsou: minimize, maximize\_horz, maximize\_vert, fullscreen, close, move, change\_desktop, above, below, stick, shade a další.*<br>
**xprop -id** {*id-okna*} **\_NET\_WM\_ALLOWED\_ACTIONS \| sed -E -e 's/.\*=\| \*\_NET\_WM\_ACTION\_//g' -e 's/.\*/\\L&amp;/g'**


### Binární vlastnosti okna

*# maximalizované (nastavit/zrušit)*<br>
**wmctrl -ir** {*id-okna*} **-b add,maximized\_horz,maximized\_vert**<br>
**wmctrl -ir** {*id-okna*} **-b remove,maximized\_horz,maximized\_vert**

*# minimalizované (nastavit)*<br>
**xdotool windowminimize \-\-sync** {*id-okna*}

*# minimalizované (zrušit)*<br>
?

*# okno vždy nahoře (nastavit/zrušit)*<br>
**wmctrl -ir** {*id-okna*} **-b add,above**<br>
**wmctrl -ir** {*id-okna*} **-b remove,above**

*# okno na celou obrazovku (nastavit/zrušit)*<br>
**wmctrl -ir** {*id-okna*} **-b add,fullscreen**<br>
**wmctrl -ir** {*id-okna*} **-b remove,fullscreen**

*# okno vždy pod ostatními okny (nastavit/zrušit)*<br>
**wmctrl -ir** {*id-okna*} **-b add,below**<br>
**wmctrl -ir** {*id-okna*} **-b remove,below**

*# vždy na viditelné ploše (sticky)(nastavit/zrušit)*<br>
**wmctrl -ir** {*id-okna*} **-b add,sticky**<br>
**wmctrl -ir** {*id-okna*} **-b remove,sticky**

*# zarolovat/odrolovat okno*<br>
**wmctrl -ir** {*id-okna*} **-b add,shaded**<br>
**wmctrl -ir** {*id-okna*} **-b remove,shaded**

*# zrušit oknu modální status*<br>
**wmctrl -ir** {*id-okna*} **-b remove,modal**

*# vypsat aktivní binární vlastnosti okna*<br>
*// Poznámka: normální okno nemá žádné binární vlastnosti, proto pro ně uvedený příkaz vrátí prázdný řádek.*<br>
**xprop -id** {*id-okna*} **\_NET\_WM\_STATE \| sed -E -e 's/.\*=\| \*\_NET\_WM\_STATE\_//g' -e 's/.\*/\\L&amp;/g'**


### Noční osvětlení

*# spustit automatické noční osvětlení pro západ ČR/východ ČR/východ Slovenska*<br>
**redshift -l 50:14** [**-t** {*bar-tepl-ve-dne*}**:**{*v-noci*}] [**-b** {*jas-ve-dne*}**:**{*v-noci*}]<br>
**redshift -l 50:17** [**-t** {*bar-tepl-ve-dne*}**:**{*v-noci*}] [**-b** {*jas-ve-dne*}**:**{*v-noci*}]<br>
**redshift -l 49:21** [**-t** {*bar-tepl-ve-dne*}**:**{*v-noci*}] [**-b** {*jas-ve-dne*}**:**{*v-noci*}]

*# jednorázové noční osvětlení*<br>
**redshift -o -l** {*zem-šířka*}**:**{*délka*} [**-t** {*bar-tepl-ve-dne*}**:**{*v-noci*}] [**-b** {*jas-ve-dne*}**:**{*v-noci*}]

*# jednorázové ruční nastavení barevné teploty a jasu (obecně/na noc/na den)*<br>
**redshift -O** {*teplota*} [**-b** {*jas*}**:**{*jas*}]<br>
**redshift -O 3500K -b 0.65:0.65**<br>
**redshift -O 5500K -b 1:1**

*# jednorázově zrušit noční osvětlení*<br>
**redshift -x**

### Virtuální plochy

*# zjistit počet virtuálních ploch*<br>
**xdotool get\_num\_desktops**

*# nastavit počet virtuálních ploch*<br>
**xdotool set\_num\_desktops** {*počet*}

*# vypsat informace o virtuálních plochách*<br>
**wmctrl -d**

*# přejít na určitou virtuální plochu/o N ploch vpřed/o N ploch vzad*<br>
*// Virtuální plochy se číslují od nuly!*<br>
**xdotool set\_desktop** {*číslo-plochy*}<br>
**xdotool set\_desktop \-\-relative** {*N*}<br>
**xdotool set\_desktop \-\-relative -**{*N*}

*# zjistit, na které virtuální ploše je okno*<br>
**xdotool get\_desktop\_for\_window** {*id-okna*}

*# přesunout okno na virtuální plochu*<br>
**xdotool set\_desktop\_for\_window** {*id-okna*} {*číslo-plochy*}

### Ověření přítomnosti X-serveru

*# zjistit, zda program běží na X-serveru (tzn. ne např. Waylandu nebo v konzoli)*<br>
*// Uvedený příkaz uspěje (vrátí kód 0), pouze pokud je spušten v prostředí X-serveru.*<br>
**test "$XDG\_SESSION\_TYPE" = x11**

### Automatizace klávesnice a myši

*# stisknutí kláves*<br>
**xdotool key** [**\-\-clearmodifiers**] [**\-\-delay** {*milisekundy*}] {*klávesa*}...

*# pohyb myši (relativně k obrazovce/relativně k oknu/relativně k aktuální pozici)*<br>
**xdotool mousemove** {*x*} {*y*}<br>
**xdotool mousemove \-\-window** {*id-okna*} {*x*} {*y*}<br>
**xdotool mousemove\_relative** {*x*} {*y*}

*# kliknutí myši*<br>
*// „Tlačítko-myši“ je 1 pro levé tlačítko, 2 pro prostřední tlačítko a 3 pro pravé tlačítko.*<br>
**xdotool click** {*tlačítko-myši*}

*# dvojklik myší*<br>
**xdotool click \-\-repeat 2** {*tlačítko-myši*}

*# rolovat kolečkem myši nahoru/dolu*<br>
**xdotool click \-\-repeat** {*počet-kroků*} **4**<br>
**xdotool click \-\-repeat** {*počet-kroků*} **5**

*# posunout kurzor myši (relativně k obrazovce/relativně k oknu/relativně k aktuální pozici), kliknout a vrátit ji na původní pozici*<br>
**xdotool mousemove** {*x*} {*y*} **click** {*tlačítko-myši*} **mousemove restore**<br>
**xdotool mousemove \-\-window** {*id-okna*} {*x*} {*y*} **click** {*tlačítko-myši*} **mousemove restore**<br>
**xdotool mousemove\_relative** {*x*} {*y*} **click** {*tlačítko-myši*} **mousemove restore**

*# tažení myší*<br>
**xdotool mousemove** {*výchozí-x*} {*výchozí-y*} **mousedown** {*tlačítko-myši*} **mousemove** {*cílové-x*} {*cílové-y*} **mouseup** {*tlačítko-myši*} [**mousemove restore**]

*# získat pozice myši, číslo obrazovky a decimální id okna do proměnných X, Y, SCREEN a WINDOW*<br>
**eval "$(xdotool getmouselocation \-\-shell)"**

*# uložit pozici myši, počkat 1,5 sekundy a vrátit její kurzor na uloženou pozici*<br>
**(eval "$(xdotool getmouselocation \-\-shell)"; xdotool sleep 1.5 mousemove \-\-screen $SCREEN $X $Y)**

### Odposlouchávání klávesnice a myši

*# zjistit ID klávesnice*<br>
**xinput list \| egrep -iv "virtual\|power button" \| egrep -im 1 '\\[.\*keyboard.\*\\]' \| sed -E 's/.\*id=([0-9]+).\*/\\1/'**

*# zjistit ID myši*<br>
**xinput list \| egrep -iv "virtual\|power button" \| egrep -im 1 '\\[.\*pointer.\*\\]' \| sed -E 's/.\*id=([0-9]+).\*/\\1/'**
<!--
k: 9 m: 8
-->

*# vypnout/zapnout zařízení*<br>
**xinput disable** {*id-zařízení*}<br>
**xinput enable** {*id-zařízení*}

*# odposlouchávat události zařízení*<br>
*// Čísla, která přikaz vypisuje při odposlouchávání klávesnice, jsou fyzické kódy kláves. Určit podle nich konkrétní stisknuté klávesy je možné, ale obtížné.*<br>
**xinput test** {*id-zařízení*}
<!--
https://github.com/Wh1t3Rh1n0/xinput-keylog-decoder
-->

## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

*# *<br>
**redshift** {*parametry*}

* **\-l** {*zem-šířka*}**:**{*zem-délka*} \:\: Ruční určení zeměpisné polohy. Potlačí automatické zjišťování.
* **\-t** {*teplota-ve-dne*}**:**{*teplota-v-noci*} \:\: Ruční nastavení barevné teploty; výchozí hodnoty jsou „5500K:3500K“; normální hodnota (bez redshiftu) je „6500K“.
* **\-o** \:\: Jednorázový režim. Nastaví barevnou teplotu a jas a skončí. Vhodné pro automatické spouštění jako naplánovaná úloha.
* **\-r** \:\: Zakáže plynulý přechod teploty a jasu; nastavení se změní skokově.

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfiguraované a připravené k práci.
- Ve výčtu balíků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

*# *<br>
**sudo apt-get install redshift wmctrl xdotool**

## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti − ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)


## Jak získat nápovědu
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje (ale neuvádějte konkrétní odkazy, ty patří do sekce „Odkazy“).
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)


## Odkazy
![ve výstavbě](../obrazky/ve-vystavbe.png)

Co hledat:

* [stránku na Wikipedii](https://cs.wikipedia.org/wiki/Hlavn%C3%AD_strana)
* oficiální stránku programu
* oficiální dokumentaci
* [manuálovou stránku](http://manpages.ubuntu.com/)
* [balíček Bionic](https://packages.ubuntu.com/)
* online referenční příručky
* různé další praktické stránky, recenze, videa, tutorialy, blogy, ...
* publikované knihy

<!--
Příkazy ke zpracování:

[0] xwininfo
[ ] xclip
[x] xdotool
[0] xprop
[ ] xkill
[ ] xdpyinfo
[ ] xhost
[ ] xrandr, xgamma, xvidtune
[ ] xset
[ ] xrefresh
[ ] xeyes, xcalc
[ ] notify-send
[ ] dbus-run-session

Úlohy ke zpracování:
+ zamknout obrazovku/odhlásit se
+ spusit spořič obrazovky
+ spustit program minimalizovaný/maximalizovaný/skrytý/nemaximalizovaný
+ rozdíly mezi podporovanými okenními prostředí
-->
<!--
Alternativní řešení:
Vypsat PID:
**xprop -id** {*id-okna*} **\_NET\_WM\_PID**<br>
**xprop -id** {*id-okna*} **\_NET\_WM\_PID \| egrep -o [0-9]+**
-->
<!--
Alternativní řešení:
Zaměřit okno:
**xdotool windowactivate** {*id-okna*}
-->
<!--
Alternativní řešení:
Vypsat titulek okna:
**xprop -id** {*id-okna*} **\_NET\_WM\_NAME WM\_NAME \| egrep -m 1 -v 'not found\\.$'**<br>
**xprop -id** {*id-okna*} **\_NET\_WM\_NAME WM\_NAME \| gawk '!/not found\\.$/ { gsub(/^[^"]\*"\|"$/, ""); gsub(/\\\\\\"/, "\\""); gsub(/\\\\\\\\/, "\\\\"); gsub(/\\t/, "\\\\t"); print; exit;}'**
-->
<!--
Původní řešení:
Získat seznam ID oken:
*// Okna jsou v seznamu v pořadí podle poslední „aktivace“ od nejnovějšího po nejstarší.*<br>
**xwininfo -root -tree \| egrep -o '^&blank;+0x[^&blank;]+&blank;"' \| tr -s " " \| cut -d " " -f 2 \| oknogrep**

*# skript ~/bin/oknogrep*<br>
**#!/usr/bin/gawk -f**<br>
**/^[0-9]+$/ { $0 = sprintf("0x%x", $0); }**<br>
**/^0x[0-9a-fA-F]+$/ \{**<br>
**<tab8>id = $0;**<br>
**<tab8>prikaz = "xprop -id " id " \_NET\_WM\_WINDOW\_TYPE \_NET\_WM\_ALLOWED\_ACTIONS";**<br>
**<tab8>if ((prikaz \| getline) &amp;&amp; $0 ~ /= \_NET\_WM\_WINDOW\_TYPE\_NORMAL$/ &amp;&amp; (prikaz | getline) &amp;&amp; $0 !~ /not found\\.$/) print id;**<br>
**<tab8>close(prikaz);**<br>
**\}**

-->
<!--
https://specifications.freedesktop.org/wm-spec/1.3/ar01s05.html
-->

