<!--

Linux Kniha kouzel, kapitola GAWK
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
ÚKOLY:
[ ] Vysvětlit použití znaku & v druhém parametru gsub(); viz https://www.gnu.org/software/gawk/manual/html_node/Gory-Details.html.
-->

# GNU awk

## Úvod
![ve výstavbě](../obrazky/ve-vystavbe.png)

GNU awk je univerzální, řádkově orientovaný nástroj pro jednoduché zpracování textových souborů.
Pracuje tak, že pro každý řádek vstupních souborů prochází od začátku do konce skript,
který se skládá z podmínek (tzv. vzorků) a jim příslušejících bloků příkazů.
Přitom vykonává příkazy z těch bloků, jejichž podmínky jsou daným řádkem splněny.

Z hlediska programování nabízí globální proměnné, lokální proměnné (pouze ve funkcích)
a asociativní pole. Prakticky má pouze dva datové typy: řetězec a pole, přičemž s řetězcem
se pracuje jako s číslem, kdykoliv se použije v číselném kontextu.

## Definice
![ve výstavbě](../obrazky/ve-vystavbe.png)

* **Vzorek** je...

## Zaklínadla
![ve výstavbě](../obrazky/ve-vystavbe.png)
### Pomocné funkce
*# escapovat()*<br>
**function escapovat(s) {gsub(/[\\\\\|.\*+?{}[\\]()\\/^$]/, "\\\\\\\\&amp;", s);return s;}**

*# escapovatknahrade()*<br>
**function escapovatknahrade(s) {gsub(/[\\\\&amp;]/, "\\\\\\\\&amp;", s);return s;}**

### Vzorky

*# vykonat jednou před prvním řádkem*<br>
**BEGIN** {*blok*}

*# vykonat po zpracování posledního řádku*<br>
**END** {*blok*}

*# vykonat pro každý řádek obsahující podřetězec vyhovující regulárnímu výrazu*<br>
**/**{*regulární výraz*}**/** {*blok*}

*# vykonat pro každý řádek neobsahující podřetězec vyhovující regulárnímu výrazu*<br>
**!/**{*regulární výraz*}**/** {*blok*}

*# zapínané vykonávání*<br>
*// zapnout před řádkem s podřetězcem vyhovujícím regulárnímu výrazu 1, vypnout za řádkem(...) výrazu 2*<br>
**/**{*reg-výraz-zapnout*}**/,/**{*reg-výraz-vypnout*}**/** {*blok*}

*# podmíněné vykonávání*<br>
{*podmínka*} {*blok*}

*# podmíněné vykonávání (příklad)*<br>
**PROMENNA == 1 &amp;&amp; /^X/ { print "Podmínka je splněna." }**

*# vypnout automatické vypsání řádku*<br>
**{}**

### Práce s proměnnými

*# získat hodnotu proměnné*<br>
{*název-proměnné*}

*# přiřadit hodnotu proměnné*<br>
{*název-proměnné*} **=** {*hodnota*}

*# získat hodnotu proměnné prostředí (přímý přístup/nepřímý přístup)*<br>
**ENVIRON["**{*název-proměnné*}**"]**<br>
**ENVIRON[**{*proměnná-s-názvem*}**]**

*# získat jméno vstupního souboru*<br>
**FILENAME**

*# získat číslo právě zpracovávaného řádku (v souboru/celkově)*<br>
**FNR + 1**<br>
**NR + 1**

*# získat počet „sloupců“ aktuálního řádku (dostupných jako $1, $2 atd.)*<br>
**NF**

*# nepřímý přístup k proměnné (příklad)*<br>
**PROMENNA = "hodnota";**<br>
**UKAZATEL = "PROMENNA";**<br>
**print SYMTAB[UKAZATEL];**<br>
**SYMTAB[UKAZATEL] = "nova hodnota"**



### Řetězcové funkce

*# získat podřetězec*<br>
*// Pozice v řetězci se v awk číslují od 1!*<br>
**substr(**{*řetězec*}**,** {*počáteční-pozice*}[**,** {*maximální-délka*}]**)**

*# nahradit všechny výskyty regulárního výrazu/starého řetězce v textu proměnné novým řetězcem*<br>
*// Výsledek přepíše původní hodnotu proměnné. V novém řetězci je nutno navíc escapovat znaky \\ a &amp;; neescapovaný znak &amp; se v něm nahradí nahrazovaným textem v řetězci.*<br>
**gsub(/**{*regulární výraz*}**/, escapovatknahrade(**{*nový-řetězec*}**)**[, {*proměnná*}]**)**<br>
**gsub(escapovat(**{*starý-řetězec*}**), escapovatknahrade(**{*nový řetězec*}**)**[, {*proměnná*}]**)**

*# nahradit N-tý výskyt (počítáno od 1) regulárního výrazu/starého řetězce v textu proměnné novým textem*<br>
{*proměnná*} **= gensub(/**{*regulární-výraz*}**/, escapovatknahrade(**{*nový-řetězec*}**),** {*kolikátý-výskyt*}**,** {*proměnná*}**)**<br>
{*proměnná*} **= gensub(escapovat(**{*starý-řetězec*}**), escapovatknahrade(**{*nový-řetězec*}**),** {*kolikátý-výskyt*}**,** {*proměnná*}**)**

*# zjistit délku řetězce*<br>
**length(**{*řetězec*}**)**

*# zjistit, zda řetězec obsahuje podřetězec vyhovující regulárnímu výrazu*<br>
{*řetězec*} **~ /**{*regulární-výraz*}**/**

*# načíst první podřetězec vyhovující regulárnímu výrazu (nejdelší možný); není-li takový, vrátit "NENALEZENO"*<br>
**vysledek = (match(**{*zkoumaný-řetězec*}**, /**{*regulární-výraz*}**/) != 0) ? substr(RSTART, RLENGTH) : "NENALEZENO";**

*# sekvence více výskytů téhož znaku v řetězci nahradit jeho jedním výskytem*<br>
?

*# všechna písmena konvertovat na velká/malá*<br>
**toupper(**{*řetězec*}**)**<br>
**tolower(**{*řetězec*}**)**

<!--

index(retezec, podretezec) => první pozice podřetězce v řetězci (0, pokud není)
length(retezec) => délka řetězce


-->

### Práce s poli

*# vytisknout hodnotu prvku pole*<br>
**print** {*pole*}**[**{*index*}**];**

*# přiřadit hodnotu prvku pole*<br>
{*pole*} **=** {*hodnota*}**;**

*# zjistit, zda prvek pole existuje*<br>
{*index*} **in** {*pole*}

*# projít a vytisknout všechny prvky pole (v nedefinovaném pořadí!)*<br>
**for (** {*iterační-proměnná*} **in** {*pole*} **) {**<br>
**print** {*pole*}**[**{*iterační-proměnná*}**];**<br>
**}**

*# vytisknout počet prvků pole*<br>
**print length(**{*pole*}**);**

*# odstranit z pole jeden prvek/všechny prvky*<br>
**delete** {*pole*}**[**{*index*}**];**
**delete** {*pole*}**;**

*# zjistit, zda je proměnná pole*<br>
**isarray(**{*proměnná*}**)**

### Uživatelsky definované funkce

*# definovat funkci (volitelně s lokálními proměnnými)*<br>
**function** {*název funkce*}**(**[{*první-parametr*}[**,**{*další-parametry*}]...][[{*bílé znaky navíc*}{*lokální proměnná*}**,**...]]**)** TODO: Dodělat...

### Číselné funkce

*# zaokrouhlit desetinné číslo na nejbližší celé číslo/k nule*<br>
{*číslo*} &gt;= 0 ? int({*číslo*} + 0.4999999) : int({*číslo*} - 0.4999999)<br>
**int(**{*hodnota*}**)**
<!--
TODO: Test.
-->

*# vygenerovat pseudonáhodné celé číslo 0 &lt;= y &lt; maximum*<br>
*// Vhodné jen pro maxima do 16 777 215. Pro vyšší maximum bude množina vrácených hodnot pravidelně přerušovaná, což pro některé druhy využití nemusí vadit. Správným řešením je bitová kombinace více volání funkce „rand()“.*<br>
**rand() \*** {*maximum*}

*# vygenerovat pseudonáhodné celé číslo 0 &lt;= y &lt; 4 294 967 296*<br>
**65356 \* int(65536 \* rand()) + int(65536 \* rand())**

*# nastavit počáteční „semínko“ generátoru pseudonáhodných čísel (na hodnotu/podle času)*<br>
**srand(**{*hodnota-semínka*}**)**<br>
**srand()**

*# vygenerovat pseudonáhodné desetinné číslo 0 &lt;= y &lt; 1*<br>
**rand()**

*# druhá odmocnina*<br>
**sqrt(**{*x*}**)**

*# arcus tangens y / x*<br>
**atan2(**{*y*}**,** {*x*}**)**

*# sinus/kosinus/tangens/contangens*<br>
**sin(**{*x*}**)**<br>
**cos(**{*x*}**)**<br>
**sin(**{*x*}**) / cos(**{*x*}**)**<br>
**cos(**{*x*}**) / sin(**{*x*}**)**

*# přirozený logaritmus / e na x-tou*<br>
**log(**{*x*}**)**<br>
**exp(**{*x*}**)**


### Řízení zpracování

*# opustit cyklus (for, while, do) nebo přepínač (switch)*<br>
**break;**

*# skočit na podmínku nejvnitřnějšího cyklu (for, while, do)*<br>
**continue;**

*# přejít na zpracování dalšího řádku (přeskočit zbytek zpracování tohoto)*<br>
**next;**

*# přejít na zpracování dalšího souboru z příkazové řádky awk (přeskočit zbytek tohoto)*<br>
**nextfile;**

*# přeskočit všechno zbylé zpracování; vykonat průchod END a ukončit program*<br>
**exit** [{*návratová-hodnota*}]**;**

*# vypsat chybovou zprávu a skončit s chybou*<br>
**print** {*chybová-zpráva-řetězec*} **| "cat &gt;&amp;2"**<br>
**exit 1;**

### Pokročilejší funkce

*# implementovat načítání řádků rozdělených znakem \\ před znakem konce řádku (tento kód vložit na začátek skriptu)*<br>
{*proměnná*} **!= "" {$0 =** {*proměnná*}**;** {*proměnná*} **= "";}**<br>
**/(^|[^\\\\])(\\\\\\\\)\*\\\\$/ {**{*proměnná*} **= substr($0, 1, length($0) - 1); next;}**

## Parametry příkazů
![ve výstavbě](../obrazky/ve-vystavbe.png)

* **-F** {*řetězec*} \-\- nastaví oddělovač vstupních polí (k rozdělení řádků na $1, $2 atd.)



## Jak získat nápovědu
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Tipy a zkušenosti
![ve výstavbě](../obrazky/ve-vystavbe.png)
* Pole jsou asociativní a indexy v polích jsou vždy řetězce; při indexování číslem se číslo nejprve převede na řetězec.
* Neexistující prvky...


## Instalace na Ubuntu
*# *<br>
**sudo apt-get install gawk**

## Odkazy
![ve výstavbě](../obrazky/ve-vystavbe.png)

Co hledat:

* [stránku na Wikipedii](https://cs.wikipedia.org/wiki/Hlavn%C3%AD_strana)
* oficiální stránku programu
* oficiální dokumentaci
* [manuálovou stránku](http://manpages.ubuntu.com/)
* [balíček Bionic](https://packages.ubuntu.com/)
* online referenční příručky
* různé další praktické stránky, recenze, videa, blogy, ...
* [oficiální manuál od GNU](https://www.gnu.org/software/gawk/manual/) (anglicky)
