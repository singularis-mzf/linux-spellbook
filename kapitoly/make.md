<!--

Linux Kniha kouzel, kapitola Make
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
# Make

![ve výstavbě](../obrazky/ve-vystavbe.png)

## Úvod
GNU make je nástroj k automatizaci procesu kompilace. Vykonává podobnou úlohu jako např.
skript napsaný v bashi, ale na rozdíl od něj umí:
* Kompilovat pouze ty části programu, které jsou potřeba (jejichž cílové soubory neexistují
nebo se jejich zdrojové soubory změnily)
* Spouštět kompilace paralelně, aniž by to narušilo definované závislosti.

Vztahy mezi soubory a kompilační příkazy jsou popsány v tzv. Makefilu,
jemuž se bude věnovat většina této kapitoly.

## Definice
* **pravidlo** je definice v Makefilu, která instruuje program make,
na kterých dalších souborech určitý soubor závisí a jakými příkazy
jej z nich vytvořit či aktualizovat.

* **cíl** je název souboru k vytvoření či akce k vykonání.

* **zdroj** (často nazýváný „závislost“) je název souboru, na kterém určitý cíl závisí.
Příkazy stanovené pravidlem se vykonají jen tehdy, pokud cíl neexistuje
nebo je alespoň jeden jeho z jeho zdrojů novější.

* **slovo** je posloupnost nebílých znaků v řetězci. Jednotlivá slova v řetězci
jsou od sebe oddělena bílými znaky, nejčastěji jednotlivou mezerou.

## Zaklínadla (v souboru Makefile)
### Pravidla
*# obecná syntaxe normálního pravidla*<br>
{*cíle oddělené mezerami*}**:** [{*zdroje oddělené mezerami*}] [**;**{*příkaz*}]<br>
[{*tabulátor*}[{*prefix-příkazu*}]{*příkaz*}{*konec řádku*}]...

*# obecná syntaxe pravidla se vzorkem*<br>
{*cíle oddělené mezerami*}**:** {*vzorek-obsahující-znak-%*}: {*definice zdrojů obsahující %*}
[{*tabulátor*}[{*prefix-příkazu*}]{*příkaz*}{*konec řádku*}]...

*# označit, že určité cíle jsou akce, ne soubory*<br>**.PHONY:** [{*akce oddělené mezerami*}]

### Příkazy v pravidlech
*# vykonat příkaz bez vypsání*<br>{*tabulátor*}**@**{*příkaz*}

*# vykonat příkaz a ignorovat návratovou hodnotu*<br>{*tabulátor*}**\-**{*příkaz*}

### Nastavení proměnných
*# nastavit proměnnou (expandovat v místě definice)*<br>{*NÁZEV\_PROMĚNNÉ*} **:=** {*hodnota včetně mezer*}

*# nastavit proměnnou (expandovat v místě použití)*<br>{*NÁZEV\_PROMĚNNÉ*} **=** {*hodnota včetně mezer*}

*# přiřadit do proměnné mezeru (trik)*<br>
**EMPTY :=**<br>
{*NÁZEV\_PROMĚNNÉ*} **:= $(EMPTY) $(EMPTY)**

*# připojit obsah na konec proměnné (expanze stejně jako v původní definici)*<br>{*NÁZEV\_PROMĚNNÉ*} **\+=** {*hodnota včetně mezer*}

*# nastavit/připojit víceřádkový obsah (endef musí být na samostatném řádku; operátor může být =, := nebo +=)*<br>
**define** {*NÁZEV\_PROMĚNNÉ*} [{*operátor*}]<br>{*víceřádkový obsah*}<br>**endef**

### Rozvoj proměnných
*# rozvinout proměnnou*<br>**$(**{*NÁZEV\_PROMĚNNÉ*}**)**

*# rozvinout proměnnou, jejíž název je uložený v jiné proměnné*<br>**$($(**{*NÁZEV\_PROMĚNNÉ*}**))**

*# při rozvinutí proměnné nahradit v každém slově (odděleném mezerou) prefix a suffix*<br>
**$(**{*NÁZEV\_PROMĚNNÉ*}**:**[{*původní-prefix*}]**%**[{*původní-suffix*}]**=**[{*nový-prefix*}]**%**[{*nový-suffix*}]**)**

*# vypíše: bbeceda.cpp hlavicka.h bbakus.cpp ostatni.cc*<br>
**TEST := abeceda.cc hlavicka.h abakus.cc ostatni.cc**<br>
**all:**<br>
{*tabulátor*}**@echo $(TEST:a%.cc=b%.cpp)**

### Automatické proměnné
*# cíl pravidla*<br>**$@**<br>**$(@)**

*# první zdroj pravidla*<br>**$&lt;**<br>**$(&lt;)**

*# všechny zdroje*<br>**$\^**<br>**$(\^)**

*# ?*<br>**$\***<br>**$(\*)**

### Předdefinované proměnné

*# program make*<br>**$(MAKE)**

*# mazání souborů (typicky „rm -f“)*<br>**$(RM)**

### Analýza adresářových cest
*# získat adresářovou cestu (z každého slova; neobsahuje-li slovo „/“, vrací „./“)*<br>
**$(dir** {*řetězec slov*}**)**

*# získat samotný název souboru včetně přípony (z každého slova)*<br>
**$(notdir** {*řetězec slov*}**)**

*# získat příponu (z každého slova, které obsahuje „.“,
po které nenásleduje „/“; ostatní slova jsou vynechána)*<br>
**$(suffix** {*řetězec slov*}**)**

*# získat adresářovou cestu (je-li uvedena) + název souboru bez přípony
z každého slova v řetězci*<br>
**$(basename** {*řetězec slov*}**)**

*# získat úplnou kanonickou cestu existujících souborů a adresářů odkazovaných slovy řetězce*<br>
**$(realpath** {*řetězec slov*}**)**

### Textové funkce
*# nahradit všechny výskyty podřetězce*<br>
**$(subst** {*co nahradit*}**,**{*čím nahradit*}**,**{*původní text*}**)**

*# připojit text před/za každé slovo v řetězci*<br>
**$(addprefix** {*text*},{*řetězec slov*}**)**<br>
**$(addsuffix** {*text*},{*řetězec slov*}**)**

*# normalizovat bílé znaky (posloupnosti nahradit jednou mezerou, na začátku a konci odstranit)*<br>
**$(strip** {*řetězec*}**)**

*# vybrat slova odpovídající/neodpovídající kterémukoliv ze zadaných %-vzorů*<br>
**$(filter** {*vzory oddělené mezerou*}...,{*řetězec slov*}**)**
**$(filter-out** {*vzory oddělené mezerou*}...,{*řetězec slov*}**)**

*# seřadit slova a odstranit duplicity*<br>
**$(sort** ${*řetězec*}**)**

*# první/poslední/n-té slovo z řetězce (pro první slovo n = 1)*<br>
**$(firstword** {*řetězec*}**)**<br>
**$(lastword** {*řetězec*}**)**<br>
**$(word** {*n*}**,**{*řetězec*}**)**

### Logické funkce

*# podmíněný výraz*<br>
**$(if** {*podmínkový řetězec*}**,**{*výsledek pro
neprázdný řetězec*}[**,**{*výsledek pro prázdný řetězec*}]**)**

*# získat první neprázdný řetězec*<br>
**$(or** {*řetězec*}[**,**{*další řetězec*}]...**)**

*# získat první prázdný řetězec, nebo jsou-li všechny neprázdné, poslední z nich*<br>
**$(and** {*řetězec*}[**,**{*další řetězec*}]...**)**

*# pro každé slovo ze seznamu toto slovo nastavit do proměnné a rozvinout podvýraz*<br>
**$(foreach** {*proměnná*}**,**{*seznam*}**,**{*podvýraz*}**)**

*#* vrátí: aa bb cc cc bb aa<br>
**$(foreach PROM,a b c c b a,$(PROM)$(PROM))**

### Řízení načítání Makefile

*# podmíněný překlad (vybrat první z alternativ, kde jsou si uvedené výrazy po rozvinutí rovny)*<br>
**ifeq "**{*výraz 1*}**" "**{*výraz 2*}**"**<br>
{*první alternativa*}<br>
[**else ifeq "**{*výraz 1*}**" "**{*výraz 2*}**"**<br>
{*další alternativa*}]...<br>
[**else**<br>
{*poslední alternativa*}]<br>
**endif**

*# načíst kód Makefilu z jiných souborů, jako by byl zde*<br>**include** {*soubory*}...

### Ostatní funkce

*# vykonat příkaz v aktuálním shellu (typicky bash) a rozvinout se na jeho výstup;
konce řádků se nahradí mezerami*<br>
**$(shell** {*příkaz shellu*}**)**

*# vyvolat chybu a ukončit zpracování Makefile (popis chyby může obsahovat proměnné
a další funkce)*<br>
**$(error** {*popis chyby*}**)**

*# vypsat varování/zprávu (výsledkem expanze těchto funkcí je prázdný řetězec)*<br>
**$(warning** {*popis varování*}**)**<br>
**$(info** {*zpráva*}**)**

## Parametry příkazů
### make
**make** [{*parametry*}] [{*cíl*}]<br>
**$(MAKE)** [{*parametry*}] [{*cíl*}]

* **\-j** {*počet*} :: umožní paralelní běh více úloh najednou
* **\-C** {*adresář*} :: před děláním čehokoliv vstoupí do zadaného adresáře
* **\-n** :: nespouští příkazy, pouze je vypíše
* **\-s** :: nevypisuje příkazy, pouze je spouští
* Není-li cíl zadán, použije se první cíl v Makefile (tradičně akce „all“).

## Jak získat nápovědu
* online GNU manuál (viz sekce Odkazy) (anglicky)
* **make --help**
* **man make**

## Tipy a zkušenosti
* Program make ignoruje konec řádku, pokud ho escapujete zpětným lomítkem.
To umožňuje bezpečně rozdělit dlouhé řádky.
* Nebojte se definovat více cílů v jednom pravidle. Funguje to stejně jako definovat
stejné pravidlo pro každý uvedený cíl zvlášť. Pravděpodobně budete muset použít
něco jako **$(@:%.c=out/%.o)**.
* Pro jeden cíl můžete definovat více pravidel,
pokud nejvýše jedno z nich bude deklarovat příkazy;
v takovém případě se sloučí zdroje ze všech odpovídajících pravidel.
* Program make v příkazech pravidel interpretuje znak $.
Má-li se předat shellu, je třeba jej zdvojit, např. *$$PATH* nebo *$$$$*.
* Některé textové editory mohou v závislosti na svém nastavení nahrazovat tabulátory
mezerami či naopak. Pokud takovým editorem upravíte Makefile, přestane fungovat,
protože na začátku každého příkazu v pravidle musí být tabulátor, ne posloupnost mezer.
* Obvyklé názvy akcí jsou např.: all, clean, install.
* Každý příkaz pravidla se při kompilaci spouští ve vlastním shellu!
* Na začátku Makefile se doporučuje explicitně uvést **SHELL := /bin/sh**,
případně uvést jako prerekvizitu kompilace bash a uvést **SHELL := /bin/bash**.

## Ukázka
**\# Komentář**
**SHELL := /bin/sh**

![ve výstavbě](../obrazky/ve-vystavbe.png)

## Instalace na Ubuntu
**sudo apt-get install make**

## Odkazy
* [Makefile na sallyx.org](https://www.sallyx.org/sally/c/linux/makefile)
* [oficiální manuál GNU make](https://www.gnu.org/software/make/manual/make.html) (anglicky)
* [balíček Ubuntu](https://packages.ubuntu.com/bionic/make) (anglicky)
