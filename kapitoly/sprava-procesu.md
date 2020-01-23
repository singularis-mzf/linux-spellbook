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
/proc/PID

PID v Linuxu neznamená Pražská integrovaná doprava...

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
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

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
**ps -p** {*PID*} **-o tty:1=** ⊨ pts/1

*# aktuální **adresář***<br>
[**sudo**] **readlink /proc/**{*PID*}**/cwd** ⊨ /home/pavel

*# efektivní **uživatel** (jméno/EUID)*<br>
?<br>
?

*# efektivní **skupina** (jméno/EGID)*<br>
?<br>
?

*# čas od spuštění procesu (v sekundách/ve formátu [[DD-]hh:]mm:ss)*<br>
**ps -p** {*PID*} **-o etimes:1=** ⊨ 271<br>
**ps -p** {*PID*} **-o etime:1=** ⊨ 04:31

*# čas, od kdy proces existuje*<br>
**date -d "$(ps -p** {*PID*} **-o lstart=)" "+%F %T %z"**

*# spotřebovaný čas procesoru*<br>
**ps -p** {*PID*} **-o cputime:1=** ⊨ 00:01:13

*# % zatížení CPU*<br>
**ps -p** {*PID*} **-o %cpu=  \| tr -d "&blank;"** ⊨ 10.1

*# % paměti RAM*<br>
**ps -p** {*PID*} **-o %mem= \| tr -d "&blank;"** ⊨ 0.1

*# množství paměti RAM*<br>
?

*# seznam otevřených deskriptorů (jen čísla/s cestami k souborům)*<br>
?<br>
?

*# vypsat prostředí procesu ve formátu txtz*<br>
*// Každý záznam začíná názvem proměnné prostředí a znakem „=“, za ním následuje obsah proměnné.*<br>
[**sudo**] **cat /proc/**{*PID*}**/environ** [**\|** {*zpracování*}]

*# označení sezení podle systemd*<br>
**ps -p** {*PID*} **-o lsession:1=** ⊨ 00:01:13


*# přihlášený (reálný) uživatel (jméno/RUID)*<br>
?<br>
?

*# přihlašovací skupina (jméno/RGID)*<br>
?<br>
?

*# číslo přiděleného procesoru*<br>
?

### TUI

*# procesy nejvíc zatěžující CPU*<br>
?

*# procesy zabírající nejvíc paměti RAM*<br>
?

*# procesy nejvíc vytěžující pevný disk*<br>
?

*# procesy spotřebovávající nejvíc elektřiny*<br>
?


## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíčků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

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
