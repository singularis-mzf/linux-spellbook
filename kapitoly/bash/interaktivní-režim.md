<!--

Linux Kniha kouzel, kapitola Bash/Interaktivní režim
Copyright (c) 2019-2021 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--

⊨
-->

# Interaktivní režim

!Štítky: {program}{bash}
!FixaceIkon: 1754
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod

Tato kapitola se věnuje využití vlastností interpretu Bash
specifických pro jeho interaktivní režim, tedy režim, kdy interpret
přijímá příkazy přímo od uživatele (na rozdíl od vykonávání skriptů).

Interpret Bash je vyvíjen v rámci projektu GNU.

## Definice

* **Alias** je pokyn intepretu, aby kdykoliv na místě názvu příkazu narazí na určitý název, nahradil tento název předem nastaveným textem (text náhrady obvykle obsahuje příkaz s parametry, ale může to být jakýkoliv text).
* **Historie** je číslovaný seznam textových řetězců, kam Bash ukládá příkazové řádky zadané v interaktivním režimu, aby je uživatel mohl později snadno opakovaně vyvolat nebo v nich vyhledávat.

!ÚzkýRežim: vyp

## Zaklínadla

### Ovládání: editace příkazové řádky

*# „**zpět**“: vrátit poslední provedenou úpravu příkazového řádku*<br>
{_Ctrl_}**+**{_X_}{_U_}

*# vyjmout text **od začátku** řádku/slova před aktuální znak*<br>
{_Ctrl_}**+**{_U_}<br>
{_Ctrl_}**+**{_W_}

*# **vložit** naposledy vyjmutý text*<br>
{_Ctrl_}**+**{_Y_}

*# vyjmout text od aktuálního znaku **do konce** řádky/slova*<br>
{_Ctrl_}**+**{_K_}<br>
{_Alt_}**+**{_K_}

*# přejít na začátek/konec příkazové řádky*<br>
{_Home_}<br>
{_End_}

*# otevřít zadávaný příkaz v editoru jako skript a po uzavření editoru vykonat*<br>
*// Použitý editor je určený proměnnou prostředí EDITOR; ve výchozím nastavení je to na Ubuntu „nano“.*<br>
{_Ctrl_}**+**{_X_}{_E_}

*# vložit na příkazový řádek **tabulátor***<br>
{_Ctrl_}**+**{_V_}<br>
{_Tab_}

### Ovládání: práce s historií

*# zopakovat poslední příkaz*<br>
{_↑_}<br>
{_Enter_}

*# posouvat se v historii po jednotlivých příkazech zpět/vpřed*<br>
{_↑_}<br>
{_↓_}

*# vyhledávat v historii směrem zpět*<br>
{_Ctrl_}**+**{_R_}<br>
!: Zadat vyhledávaný podřetězec. Další ovládání: {_Enter_}, {_Esc_}, {_↑_}, {_↓_}, {_Shift_}**+**{_Alt_}**+**{_._}.

*# návrat na konec historie (zpravidla po nepovedeném vyhledávání)*<br>
{_Shift_}**+**{_Alt_}**+**{_._}

*# vrátit řádek načtený z historie do původního stavu*<br>
{_Alt_}**+**{_R_}

<!--
Přemapovat Ctrl+S pro vyhledávání vpřed...
-->

*# vložit poslední slovo z poslední řádky v historii*<br>
*// Opakovaným stiskem lze vložit poslední slovo z předposlední řádky, před-předposlední atd.*<br>
{_Alt_}**+**{_._}

### Ovládání: ostatní

*# pokusit se doplnit parametr nalevo od kurzoru*<br>
{_Tab_}

*# smazat terminál (ponechat aktuální řádku)*<br>
{_Ctrl_}**+**{_L_}

*# posun terminálu o stránku nahoru/dolu*<br>
{_Shift_}**+**{_PageUp_}<br>
{_Shift_}**+**{_PageDown_}

*# pozastavit výpis na terminál/pokračovat*<br>
*// Tyto klávesové zkratky lze (velmi výhodně) použít i tehdy, když Bash není na popředí! Program vypisující na terminál dál poběží (pokud ho chcete přerušit, použijte Ctrl+Z).*<br>
{_Ctrl_}**+**{_S_}<br>
{_Ctrl_}**+**{_Q_}

### Aliasy (včetně zapnutí/vypnutí)

*# vypsat přehled aliasů*<br>
**alias**

*# nastavit alias (obecně/příklad)*<br>
**alias** {*identifikator*}**=**{*"text"*} [{*dalsiidentifikator*}**=**{*"text"*}]...<br>
**alias ls='printf %s\\n "Výpis souborů:"; ls -l'**

*# smazat alias*<br>
*// Pozor na rozdíl oproti příkazu „unset“ — mazaný alias musí existovat, jinak příkaz „unalias“ selže.*<br>
**unalias** {*identifikator*} [**2&gt;/dev/null \|\| true**]

*# test: je identifikátor alias?*<br>
**alias** {*identifikator*} **&amp;&gt;/dev/null**

*# vypnout/zapnout aliasy*<br>
**shopt -u expand\_aliases**<br>
**shopt -s expand\_aliases**

### Nápověda k příkazům

*# vypsat nápovědu pro vestavěný příkaz/všechny vestavěné příkazy*<br>
**help** [**-m**] {*příkaz*}<br>
**help** [**-m**] **"\*"**

*# určit typ příkazu*<br>
**type** [**-t**] {*název\_příkazu*}

### Nastavení historie

*# **vypnout rozvoj** historie (doporučuji)*<br>
**set +H**

*# **maximální počet** záznamů v historii v paměti/na disku*<br>
**HISTSIZE=**{*počet*}<br>
**HISTFILESIZE=**{*počet*}

*# byl-li proveden rozvoj historie, zobrazit příkaz před provedením ke kontrole*<br>
**shopt -s histverify**

*# vypnout historii příkazů úplně/zapnout ji*<br>
**set +o history; history -c**<br>
**set -o history**

*# nastavit, kam se ukládá historie (obecně/příklad)*<br>
**HISTFILE="**{*/absolutní/cesta-k-souboru*}**"**<br>
**HISTFILE="/home/aneta/.bash\_history"**

*# víceřádkové příkazy ukládat do historie: najednou/po řádcích*<br>
**shopt -s cmdhist**<br>
**shopt -u cmdhist**

*# nastavit způsob ukládání řádek do historie (obecně/příklad)*<br>
*// Rozeznávané volby jsou: „ignorespace“ (neukládat řádky začínající bílým znakem), „ignoredups“ (neukládat stejný řádek znovu) a „erasedups“ (před uložením řádky smazat všechny stejné řádky z celé historie – pozor, tato volba mění pořadová čísla řádek v historii). Volba „ignoreboth“ (což je v Ubuntu výchozí chování) je synonymum pro „ignorespace:ignoredups“.*<br>
**HISTCONTROL="**[{*volba*}[**:**{*další-volba*}]...]**"**<br>
**HISTCONTROL="ignorespace:erasedups"**

*# neukládat do historie příkazy začínající určitými řetězci/obsahující určité řetězce na první řádce*<br>
*// Pozor: řetězce jsou zde ve skutečnosti vzorky, takže se vyvarujte jakýchkoliv zvláštních znaků, nebo si nastudujte v manuálové stránce bashe, jak proměnná HISTIGNORE ve skutečnosti funguje.*<br>
**HISTIGNORE="**{*řetězec*}**\***[**:**{*další řetězec*}**\***]...**"**<br>
**HISTIGNORE="\***{*řetězec*}**\***[**:\***{*další řetězec*}**\***]...**"**

*# ukládání historie při ukončení bashe: připojit na konec/přepsat soubor*<br>
**shopt -s histappend**<br>
**shopt -u histappend**

### Historie (kromě nastavení)

*# vypsat posledních N záznamů*<br>
**history** {*N*}

*# ručně přidat do historie příkaz*<br>
**history -s '**{*příkaz s parametry*}**'**

*# smazat z historie poslední záznam (viz poznámku)*<br>
*// Pozor! Tento příkaz bude fungovat, pokud *<br>
**history -d -1**

*# smazat z historie poslední záznam/konkrétní záznam/všechny záznamy*<br>
*// Poznámka k příkazu „history -d -2“: tento příkaz ve skutečnosti maže předposlední záznam, ale když takový příkaz zadáte, vámi zadaný řádek se uloží do historie ještě před smazáním  předpokládá, že se vámi zadaný příkazový řádek do historie před provedením uloží. (Příkaz „history -d -1“ by totiž v takovém případě smazal právě ten nově uložený řádek, namísto řádky, která už v historii byla. )*<br>
**history -d -1**<br>
**history -d** {*číslo-záznamu*}<br>
**history -c**

### Nastavení (kromě historie a aliasů)

*# nastavit/zrušit **časový limit** na zadání příkazu *<br>
*// Pozor, limit se počítá od zobrazení výzvy a když doběhne, intepret se ukončí, a to i v případě, že příkaz teprve zadáváte. Poznámka: Uvedená hodnota se prý aplikuje také na vestavěný příkaz „read“, pokud ten nemá zadán vlastní časový limit.*<br>
**TMOUT=**{*N*}<br>
**unset TMOUT**

*# snažit se opravit překlepy v parametru příkazu „cd“ (zapnout/vypnout)*<br>
**shopt -s cdspell**<br>
**shopt -u cdspell**

*# nerozlišovat velká a malá písmena ve většině kontextů (zapnout/vypnout)*<br>
**shopt -s nocasematch**<br>
**shopt -u nocasematch**

<!--
## Parametry příkazů
<!- -
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)
-->

## Instalace na Ubuntu

GNU Bash a všechny příkazy použité v této kapitole jsou základními součástmi
Ubuntu přítomnými i v minimální instalaci.

<!--
## Ukázka
<!- -
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)
-->

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Bash se o rozvoj aliasů snaží opakovaně, ale s ochranou proti nekonečné rekurzi — u každého názvu příkazu si pamatuje, z rozvoje jakých aliasů vznikl a ty už znovu nerozvine. Proto je bezpečné nastavit např. „alias ls='ls -R'“.
* Častá začátečnická chyba je „alias ls=ls -l“; název a text aliasu je nutno předat v jednom parametru a všechny zvláštní znaky je třeba odzvláštnit, jinak se vyhodnotí okamžitě a ne až po rozvinutí aliasu.
* Doporučuji všem uživatelům vypnout v souboru „.bashrc“ rozvoj historie příkazem „set +H“. Ovládání pomocí klávesových šipek, Ctrl+R, příkazu „fc“ apod. je pro přístup do historie mnohem praktičtější a vypnutí rozvoje historie vám umožní používat znaky „!“ a „^“ v interaktivním režimu bez nutnosti odzvláštnění (stejně jako ve skriptech).
* Rozvoj aliasů se provádí ještě před jakýmkoliv dalším zpracováním příkazového řádku; dokonce můžete nastavit „alias x="echo '" a pak zadat „x Proměnná $PATH'“ a bude to fungovat — $PATH se nerozvine!
* Vyhledávání Ctrl+R má nevýhodnou vlastnost, že v případě překlepu můžete přesáhnout za hledanou pozici a zpět se nemůžete vrátit bez smazání již zadaných písmen. Bash sice nabízí i funkci pro vyhledávání bez této nepříjemné vlastnosti, ale nepodařilo se mi ho zprovoznit.
* Klávesovou zkratku Ctrl+XE můžete využít pro zadání komplikovanějšího příkazu i v momentě, kdy je příkazová řádka ještě prázdná.

## Další zdroje informací

* BRANDEJS, Michal. *Linux: Praktický průvodce.* Brno: Konvoj, 2003. 2. vyd. (v Konvoji 1.) ISBN 80-7302-050-5. Kapitola 4.
* [Bash History Builtins](https://www.gnu.org/software/bash/manual/html_node/Bash-History-Builtins.html) (anglicky)
* [TL;DR: history](https://github.com/tldr-pages/tldr/blob/master/pages/common/history.md) (anglicky)

## Zákulisí kapitoly
<!--
- Doplňte, pokud víte. Udržujte aktuální.
-->

V této verzi kapitoly chybí:

!KompaktníSeznam:
* bind (mapování kláves)
* fc (vykonání příkazu z historie)

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* Nastavení terminálu a výzvy (viz kapitolu Terminál)

!ÚzkýRežim: vyp
