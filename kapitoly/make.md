<!--

Linux Kniha kouzel, kapitola GNU make
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
# GNU make

## Úvod
GNU make je nástroj k automatizaci procesu sestavování určitých cílových souborů ze souborů zdrojových. Vykonává podobnou úlohu jako např. skript napsaný v bashi, ale na rozdíl od něj umí:

* Kompilovat pouze ty části programu, které jsou potřeba (jejichž cílové soubory neexistují nebo se jejich zdrojové soubory změnily).
* Spouštět procesy paralelně, aniž by to narušilo definované závislosti.

Vztahy mezi zdrojovými a cílovými soubory a kompilační příkazy jsou popsány
v tzv. Makefilu (souboru jménem „Makefile“),
jemuž se bude věnovat většina této kapitoly.

## Definice
* **Pravidlo** je definice v Makefilu, která instruuje program make, na kterých dalších souborech určitý soubor závisí a jakými příkazy jej z nich vytvořit či aktualizovat.
* **Cíl** je název souboru k vytvoření či akce k vykonání.
* **Zdroj** (často nazýváný „závislost“) je název souboru, na kterém určitý cíl závisí. Příkazy stanovené pravidlem se vykonají jen tehdy, pokud cíl neexistuje nebo je alespoň jeden jeho z jeho zdrojů novější. (Vychází se z času poslední změny souborů.) Zdrojem může být také název akce.
* **Slovo** je posloupnost nebílých znaků v řetězci. Jednotlivá slova v řetězci jsou od sebe oddělena bílými znaky, nejčastěji jednotlivou mezerou.
* **%-vzor** je řetězec sloužící k filtrování, vyhledávání a nahrazování slov. Jde o velice praktickou věc. Může obsahovat nejvýše jeden znak **%**, který slouží jako náhrada za libovolné množství znaků (včetně lomítek oddělujících adresáře). (Např. %-vzoru **a%** odpovídají právě ta slova, která začínají malým písmenem **a**.) Slouží-li %-vzor k záměně, slova, která mu neodpovídají, projdou záměnou nezměněna. %-vzor nemusí obsahovat znak %; v takovém případě mu odpovídají pouze slova, která se s ním přesně shodují.

## Zaklínadla (v souboru Makefile)
### Nastavení proměnných
*# nastavit proměnnou (expandovat v místě definice)*<br>
{*NÁZEV\_PROMĚNNÉ*} **:=** {*hodnota včetně mezer*}

*# připojit obsah na konec proměnné (expanze stejně jako v původní definici)*<br>
{*NÁZEV\_PROMĚNNÉ*} **\+=** {*hodnota včetně mezer*}

*# nastavit proměnnou (expandovat v každém místě použití)*<br>
{*NÁZEV\_PROMĚNNÉ*} **=** {*hodnota včetně mezer*}

*# přiřadit do proměnné mezeru (trik)*<br>
**PRAZDNA :=**<br>
{*NÁZEV\_PROMĚNNÉ*} **:= $(PRAZDNA)&blank;$(PRAZDNA)**

*# nastavit/připojit víceřádkový obsah*<br>
*// „endef“ musí být na samostatném řádku; operátor může být „=“, „:=“ nebo „+=“.*<br>
**define** {*NÁZEV\_PROMĚNNÉ*} [{*operátor*}]<br>
{*víceřádkový obsah*}<br>
**endef**

### Rozvoj proměnných
*# rozvinout proměnnou*<br>
**$(**{*NÁZEV\_PROMĚNNÉ*}**)**

*# při rozvinutí proměnné nahradit v každém slově prefix/suffix/obojí*<br>
*// Třetí uvedená varianta provede náhradu jen ve slovech, kde odpovídá prefix i suffix. Slova, u kterých odpovídá jen prefix nebo jen suffix, projdou bez náhrady.*<br>
**$(**{*NÁZEV\_PROMĚNNÉ*}**:**[{*původní-prefix*}]**%=**[{*nový-prefix*}]**%)**<br>
**$(**{*NÁZEV\_PROMĚNNÉ*}**:%**[{*původní-suffix*}]**=%**[{*nový-suffix*}]**)**<br>
**$(**{*NÁZEV\_PROMĚNNÉ*}**:**[{*původní-prefix*}]**%**[{*původní-suffix*}]**=**[{*nový-prefix*}]**%**[{*nový-suffix*}]**)**

*# rozvinout proměnnou prostředí či příkazového interpretu (ne proměnnou Makefilu)(alternativy)*<br>
**\$\$**{*NÁZEV\_PROMĚNNÉ*}<br>
**\$\${**{*NÁZEV\_PROMĚNNÉ*}**}**

*# rozvinout proměnnou, jejíž název je uložený v jiné proměnné*<br>
**$($(**{*NÁZEV\_PROMĚNNÉ*}**))**

*# příklad záměny při rozvoji − vypíše: bbeceda.cpp hlavicka.h bbakus.cpp ostatni.cc*<br>
**TEST := abeceda.cc hlavicka.h abakus.cc ostatni.cc**<br>
**all:**<br>
<tab>**@echo $(TEST:a%.cc=b%.cpp)**

### Automatické a předdefinované proměnné
*# cíl pravidla (alternativy)*<br>
**$@**<br>
**$(@)**

*# první zdroj pravidla (alternativy)*<br>
**$&lt;**<br>
**$(&lt;)**

*# všechny zdroje (alternativy)*<br>
**$\^**<br>
**$(\^)**

*# mazání souborů (typicky „rm -f“)*<br>
**$(RM)**

*# program make*<br>
**$(MAKE)**

*# v generovaném a implicitním pravidle posloupnost znaků odpovídající znaku % v %-vzoru cíle (alternativy)*<br>
**$\***<br>
**$(\*)**

### Obecný tvar pravidel
*# normální (pevné) pravidlo*<br>
{*cíle oddělené mezerami*}**:** [{*zdroje oddělené mezerami*}] [**;**{*příkaz*}]<br>
[<tab>[{*prefix-příkazu*}]{*příkaz*}]...

*# zobecněné (generované) pravidlo (zdroje lze odvodit od cíle)*<br>
{*cíle oddělené mezerami*}**:** {*%-vzor-pro-cíle*}: {*cesta-nebo-%-vzor-zdroje*}... [**;**{*příkaz*}]<br>
[<tab>[{*prefix-příkazu*}]{*příkaz*}]...

*# obecné (implicitní) pravidlo (zdroje lze odvodit od cíle)*<br>
*// Obecné pravidlo má nižší prioritu než všechna pevná a generovaná pravidla. Navíc je tiše ignorováno, pokud chybí nekterý ze zdrojů. Má-li uvedeno víc cílů, považují se po jeho provedení všechny uvedené cíle za vygenerované, a tedy se pravidlo nevolá pro překlad dalších zdrojů znovu.*<br>
{*%-vzor cíle*}...**:** {*cesta-nebo-%-vzor-zdroje*}... [**;**{*příkaz*}]<br>
[<tab>[{*prefix-příkazu*}]{*příkaz*}]...

*# označit, že určité cíle jsou akce, ne soubory*<br>
**.PHONY:** [{*akce oddělené mezerami*}]

*# přeložit soubory uvedené v proměnné ZDROJE, které se nacházejí v adresáři „kod“ a jeho podadresářích a mají příponu „.cc“, na objektové soubory do adresáře obj*<br>
*// Uvedený příklad předpokládá předdefinované proměnné CXX a CXXFLAGS, které GNU make předdefinovává, takže je nemusíte sami nastavovat.*<br>
**$(patsubst kod/%.cc,obj/%.o,$(filter kod/%.cc,$(ZDROJE))): obj/%.o: kod/%.cc**<br>
**<tab>$(CXX) $(CXXFLAGS) -c -o $@ $&lt;**

### Textové funkce
*# připojit text před/za každé slovo v řetězci/v rozvoji proměnné*<br>
*// Při použití poslední uvedené varianty nesmějí text-před a text-za obsahovat znak %.*<br>
**$(addprefix** {*text-před*},{*řetězec slov*}**)**<br>
**$(addsuffix** {*text-za*},{*řetězec slov*}**)**<br>
**$(**{*proměnná*}**:%=**{*text-před*}**%**{*text-za*}**)**

*# provést náhradu (záměnu) ve slovech pomocí %-vzoru*<br>
**$(patsubst** {*co-nahradit-%-vzor*}**,**{*čím-nahradit-%-vzor*}**,**{*řetězec slov*}**)**

*# vybrat slova odpovídající/neodpovídající kterémukoliv ze zadaných %-vzorů*<br>
**$(filter** {*%-vzory oddělené mezerou*}...,{*řetězec slov*}**)**<br>
**$(filter-out** {*%-vzory oddělené mezerou*}...,{*řetězec slov*}**)**

*# nahradit všechny výskyty podřetězce*<br>
**$(subst** {*co nahradit*}**,**{*čím nahradit*}**,**{*původní text*}**)**

*# normalizovat bílé znaky (posloupnosti nahradit jednou mezerou, na začátku a konci odstranit)*<br>
**$(strip** {*řetězec*}**)**

*# získat počet slov v řetězci*<br>
**$(words** {*řetězec*}**)**

*# první/poslední/n-té slovo z řetězce*<br>
**$(firstword** {*řetězec*}**)**<br>
**$(lastword** {*řetězec*}**)**<br>
**$(word** {*n*}**,**{*řetězec*}**)**

*# předposlední/před-předposlední slovo z řetězce*<br>
**$(if $(word 2,**{*řetězec*}**),$(word $(shell expr $(words** {*řetězec*} **) - 1),**{*řetězec*}**),)**<br>
**$(if $(word 3,**{*řetězec*}**),$(word $(shell expr $(words** {*řetězec*} **) - 2),**{*řetězec*}**),)**

*# seřadit slova a odstranit duplicity*<br>
**$(sort** {*řetězec*}**)**

*# obrátit pořadí slov v řetězci*<br>
**$(shell printf %s\\\\n '$(strip** {*řetězec slov*}**)' \| tr '&blank;' \\\\n \| tac)**

### Analýza adresářových cest (pro každé slovo zvlášť)
*# získat adresářovou cestu (např. „../a/“)*<br>
*// Neobsahuje-li slovo žádné „/“, vrací pro něj $(dir) „./“.*<br>
**$(dir** {*řetězec slov*}**)**

*# získat samotný název souboru včetně přípony/bez přípony (např. „b.o“, resp. „b“)*<br>
**$(notdir** {*řetězec slov*}**)**<br>
**$(basename $(notdir** {*řetězec slov*}**))**

*# získat příponu souboru (např. „.o“)*<br>
*// Pozor! Slova, která takovou příponu neobsahují, budou touto funkcí vynechána bez náhrady, což sníží počet slov ve výsledném řetězci.*<br>
**$(suffix** {*řetězec slov*}**)**

*# získat adresářovou cestu (je-li uvedena) + název souboru bez přípony (např. „../a/b“)*<br>
**$(basename** {*řetězec slov*}**)**

*# získat úplnou kanonickou cestu existujících souborů a adresářů (např. „/home/elli/test/a/b.o“)*<br>
**$(realpath** {*řetězec slov*}**)**

*# získat seznam existujících souborů a adresářů odpovídajících vzorku interpretu*<br>
*// Vzorek příkazového interpretu může obsahovat znaky ? a \* s významem obvyklým v bashi. Pokud vzorku neodpovídá žádný soubor ani adresář, vzorek se potichu přeskočí. Toho je možno použít k vynechání neexistujících souborů z proměnné.*<br>
**$(wildcard** {*vzorek*}...**)**

### Logické funkce

*# podmíněný výraz*<br>
**$(if** {*podmínkový řetězec*}**,**{*je-li neprázdný*}[**,**{*jinak*}]**)**

*# získat první neprázdný řetězec*<br>
**$(or** {*řetězec*}[**,**{*další řetězec*}]...**)**

*# získat první prázdný řetězec, nebo jsou-li všechny neprázdné, poslední z nich*<br>
**$(and** {*řetězec*}[**,**{*další řetězec*}]...**)**

*# pro každé slovo ze seznamu toto slovo nastavit do proměnné a rozvinout podvýraz*<br>
**$(foreach** {*proměnná*}**,**{*seznam*}**,**{*podvýraz*}**)**

*# vrátí podřetězec, pokud se vyskytuje v řetězci; jinak vrátí prázdný řetězec*<br>
**$(findstring** {*podřetězec*}**,**{*řetězec*}**)**

*# příklad − vrátí: aa bb cc cc bb aa*<br>
**$(foreach PROM,a b c c b a,$(PROM)$(PROM))**

### Příkazy v pravidlech
*# vykonat příkaz bez vypsání*<br>
<tab>**@**{*příkaz*}

*# vykonat příkaz a ignorovat návratovou hodnotu*<br>
<tab>**\-**{*příkaz*}

### Podmíněný překlad a include

*# podmíněný překlad*<br>
*// Vybere první z alternativ, kde jsou si uvedené výrazy po rozvinutí rovny. Doporučuji alternativy v Makefilu odsadit, ale není to vyžadováno.*<br>
**ifeq "**{*výraz 1*}**" "**{*výraz 2*}**"**<br>
{*první alternativa*}<br>
[**else ifeq "**{*výraz 1*}**" "**{*výraz 2*}**"**<br>
{*další alternativa*}]...<br>
[**else**<br>
{*poslední alternativa*}]<br>
**endif**

*# načíst kód Makefilu z jiných souborů, jako by byl zde*<br>
**include** {*soubory*}...

### Ostatní funkce

*# vykonat příkaz v aktuálním shellu (typicky bash) a rozvinout se na jeho výstup; konce řádků se nahradí mezerami*<br>
**$(shell** {*příkaz shellu*}**)**

*# vyvolat chybu a ukončit zpracování Makefile*<br>
*// Tip: Popis chyby v parametru funkce $(error) může obsahovat rozvoj proměnných a volání funkcí.*<br>
**$(error** {*popis chyby*}**)**

*# vypsat varování/zprávu*<br>
*// Výsledkem expanze funkcí $(warning) a $(info) je prázdný řetězec.*<br>
**$(warning** {*popis varování*}**)**<br>
**$(info** {*zpráva*}**)**

## Parametry příkazů
*# make*<br>
**make** [{*parametry*}] [{*cíl*}]...<br>
**$(MAKE)** [{*parametry*}] [{*cíl*}]...

* **\-j** {*počet*} \:\: umožní paralelní běh více úloh najednou
* **\-C** {*adresář*} \:\: před děláním čehokoliv (dokonce i hledání Makefilu) vstoupí do zadaného adresáře
* **\-n** \:\: nespouští příkazy, pouze je vypíše
* **\-s** \:\: nevypisuje příkazy, pouze je spouští
* Není-li cíl zadán, použije se první cíl v Makefile (tradičně akce „all“).

## Instalace na Ubuntu
*# *<br>
**sudo apt-get install make**

## Ukázka
*# /home/elli/test/Makefile:*<br>
**\# Komentář**<br>
**SHELL := /bin/sh**<br>
**CXX := g++**<br>
**CXXFLAGS := -Wall \\**<br>
**&nbsp;&nbsp;-pedantic -DHOME=\\"\$\$HOME\\"**<br>
**OBJS := main.o second.o**<br>
**OBJS += hello.o**<br>
**SOURCES := $(OBJS:%.o=%.cc)**<br>
**.PHONY: all clean**<br>
<br>
**all: main**<br>
**clean:**<br>
**<tab>$(MAKE) -C lib clean**<br>
**<tab>$(RM) $(OBJS)**<br>
**main: $(OBJS)**<br>
**<tab>@echo "Koncové sestavení:"**<br>
**<tab>$(CXX) $(CXXFLAGS) -o $@ $\^**<br>
**main.o second.o: %.o: %.cc lib/hello.h**<br>
**<tab>$(CXX) $(CXXFLAGS) -c -o $@ $&lt;**<br>
**hello.o:**<br>
**<tab>$(MAKE) -C lib hello.o**<br>
**<tab>cp lib/hello.o $@**

*# /home/elli/test/lib/Makefile:*<br>
**.PHONY: clean**<br>
**hello.o: hello.cc hello.h**<br>
**<tab>g++ -o $@ -c -Wall -pedantic hello.cc**<br>
**clean:**<br>
**<tab>$(RM) hello.o**

## Tipy a zkušenosti
* Dlouhé řádky Makefilu můžete rozdělit, pokud před každý konec řádku, který má make ignorovat, vložíte zpětné lomítko. Rozdělíte-li řádek s příkazem, make toto rozdělení předá volanému interpretu příkazové řádky, což však u běžně používaných „sh“ a „bash“ nezpůsobí problémy.
* Nebojte se definovat více cílů v jednom pravidle. Funguje to stejně jako definovat stejné pravidlo pro každý uvedený cíl zvlášť a ušetří vám to spoustu práce s údržbou. Ze stejného důvodu se vyplatí naučit se syntaxi pravidla s %-vzorem.
* Pro jeden cíl můžete definovat více pravidel, pokud nejvýše jedno z nich bude deklarovat příkazy; v takovém případě se automaticky sloučí zdroje ze všech odpovídajících pravidel.
* Program make v příkazech pravidel interpretuje znak $. Má-li se předat shellu, je třeba jej zdvojit, např. **\$\$PATH** nebo **\$\$\$\$**. To platí i při uzavření do apostrofů.
* Některé textové editory mohou v závislosti na svém nastavení nahrazovat tabulátory mezerami či naopak. Pokud takovým editorem upravíte Makefile, přestane fungovat, protože na začátku každého příkazu v pravidle musí být tabulátor, ne posloupnost mezer.
* Obvyklé názvy akcí jsou např.: all, clean, install.
* Každý příkaz pravidla se při kompilaci spouští ve vlastní instanci interpretu příkazové řádky!
* Použitý interpret v příkazech a volání funkce $(shell) určuje proměnná **SHELL**. Kvůli přenositelnosti se doporučuje ji na začátku Makefile výslovně nastavit: **SHELL := /bin/sh** nebo **SHELL := /bin/bash**.
* Akce může mít jako zdroje soubory a další akce; ty budou přeloženy před vykonáním vlastní akce.

## Jak získat nápovědu
* **make \-\-help**
* Online GNU manuál (viz sekce Odkazy) (anglicky)
* **man make** (anglicky)

## Odkazy
### Česky
* [Makefile na sallyx.org](https://www.sallyx.org/sally/c/linux/makefile)
* [Stránka na Wikipedii](https://cs.wikipedia.org/wiki/Make)
* [Rychlo-školička pro Makefile](http://www.linux.cz/noviny/1999-0304/clanek12.html)
* [Správa projektů pomocí programu Make](http://www.fit.vutbr.cz/~martinek/clang/make.html)

### Anglicky
* [Oficiální manuál GNU make](https://www.gnu.org/software/make/manual/make.html) (anglicky)
* [Manuálová stránka](http://manpages.ubuntu.com/manpages/bionic/en/man1/make.1.html) (anglicky)
* [Balíček Ubuntu Bionic Beaver](https://packages.ubuntu.com/bionic/make) (anglicky)
* [Oficiální stránka GNU make](https://www.gnu.org/software/make/) (anglicky)

## Snímek obrazovky

![(snímek obrazovky)](../obrazky/make.png)
