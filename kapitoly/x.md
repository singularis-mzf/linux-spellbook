<!--

Linux Kniha kouzel, kapitola X (správce oken)
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

# X (správce oken)

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

Velké písmeno „X“ odpradávna označovalo cosi záhadného a tajuplného. Toho si pravděpodobně
byli vědomi vývojáři, když v roce 1984 pojmenovali grafické rozhraní X Window System;
pravděpodobně znali především příkazovou řádku a děrné štítky a grafické rozhraní jim
bylo něčím novým, záhadným a tajuplným. Netušili, že o padesát let později na tom budou
uživatelé-začátečníci přesně naopak.
<!--
Zdroj roku: https://en.wikipedia.org/wiki/X_Window_System#Release_history
-->

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

*# simulovat stisknutí kláves*<br>
**xdotool key** [**\-\-clearmodifiers**] [**\-\-delay** {*milisekundy*}] {*klávesa*}...

### Noční osvětlení

*# spustit automatické noční osvětlení pro západ ČR/východ ČR/východ Slovenska*<br>
**redshift -l 50:14** [**-t** {*bar-tepl-ve-dne*}**:**{*v-noci*}] [**-b** {*jas-ve-dne*}**:**{*v-noci*}]<br>
**redshift -l 50:17** [**-t** {*bar-tepl-ve-dne*}**:**{*v-noci*}] [**-b** {*jas-ve-dne*}**:**{*v-noci*}]<br>
**redshift -l 49:21** [**-t** {*bar-tepl-ve-dne*}**:**{*v-noci*}] [**-b** {*jas-ve-dne*}**:**{*v-noci*}]

*# jednorázové noční osvětlení*<br>
**redshift -o -l** {*zem-šířka*}**:**{*délka*}** [**-t** {*bar-tepl-ve-dne*}**:**{*v-noci*}] [**-b** {*jas-ve-dne*}**:**{*v-noci*}]

*# jednorázové ruční nastavení barevné teploty a jasu (obecně/na noc/na den)*<br>
**redshift -O** {*teplota*} [**-b** {*jas*}**:**{*jas*}]<br>
**redshift -O 3500K -b 0.65:0.65**<br>
**redshift -O 5500K -b 1:1**

*# jednorázově zrušit noční osvětlení*<br>
**redshift -x**

### Ostatní

*# zjistit, zda program běží na X-serveru (tzn. ne např. Waylandu nebo v konzoli)*<br>
*// Uvedený příkaz uspěje (vrátí kód 0), pouze pokud je spušten v prostředí X-serveru.*<br>
**test "$XDG\_SESSION\_TYPE" = "x11"**

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


## Jak získat nápovědu
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje (ale neuvádějte konkrétní odkazy, ty patří do sekce „Odkazy“).
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti − ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfiguraované a připravené k práci.
- Ve výčtu balíků k instalaci vycházejte z minimální instalace Ubuntu.
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

- xwininfo
- xclip
- xdotool
- xprop
- xkill
- xdpyinfo
- xhost
- xrandr, xgamma, xvidtune
- xset
- xrefresh
- xeyes, xcalc
- notify-send
- dbus-run-session

Úlohy ke zpracování:
+ zamknout obrazovku/odhlásit se
+ spusit spořič obrazovky
+ spustit program minimalizovaný/maximalizovaný/skrytý/nemaximalizovaný
+ rozdíly mezi podporovanými okenními prostředí
-->
