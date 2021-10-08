<!--

Linux Kniha kouzel, kapitola Prohlížení textových souborů
Copyright (c) 2019-2021 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

⊨
-->

# Prohlížení textových souborů

!Štítky: {tematický okruh}{textové soubory}
!FixaceIkon: 1754
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod

Tato kapitola se specializuje na prohlížení
textových souborů (např. systémových záznamů), tedy zobrazování jejich obsahu
uživateli bez možnosti tento obsah měnit, ale s možností ho prohledávat
a filtrovat.

Pokud máte na práci se soubory větší požadavky, než co vám nabízejí
nástroje popsané v této kapitole, měli byste použít plnohodnotný editor,
např. vim.

Příkaz „less“ je vyvíjen v rámci projektu GNU, příkaz „more“ nikoliv.

## Definice

* **Řádek souboru** (resp. řádka souboru) je řádek, jak se nachází v prohlíženém souboru (tedy posloupnost znaků oddělená od ostatních řádků ukončovačem řádky).
* **Řádka obrazovky** (resp. řádek obrazovky) je řádka, jak je prohlížecím programem zobrazena na terminálu. Jeden řádek souboru se může zalomit na více řádek obrazovky.

!ÚzkýRežim: vyp

## Zaklínadla

### Prohlížení a sledování souborů

*# otevřít textový soubor v programu **less**/programu more*<br>
**less** [{*volby*}]... [**\-\-**] {*cesta/k/souboru*}<br>
**more** [**\-\-**] {*cesta/k/souboru*}

*# sledovat obsah **přibývající** na konci souboru (alternativy)*<br>
*// Příkaz „tail“ vypisuje nové řádky okamžitě, příkaz „less“ se zpožděním. Sledování v obou případech ukončíte Ctrl+C; příkaz „less“ pak musíte ještě navíc uzavřít klávesou „q“. less -N zobrazí čísla řádek.*<br>
**tail -f** [**\-\-**] {*soubor*}<br>
**less** [**-N**] **+F** [**\-\-**] {*soubor*}

*# otevřít textový soubor v režimu pro čtení editoru „**vim**“*<br>
**view** [**\-\-**] {*cesta/k/souboru*}

*# sledovat **měnící** se obsah krátkého souboru*<br>
*// Sledování ukončíte klávesovou zkratkou Ctrl+C. Náhradou příkazu „cat“ za „sed“ či „egrep“ můžete soubor před sledováním přefiltrovat.*<br>
**watch -d -n** {*interval-sekund*} **"cat** [**\-\-**] {*soubor*}...**"**

*# prohlížet text získaný přes rouru*<br>
{*zdroj*} **\| less** [**-N**] <nic>[**-R**] **-**

### Volby příkazu less

*# zachovat terminálové formátování vstupu (escape-sekvence)*<br>
**\-R**

*# zobrazit řádek č. N/konec souboru*<br>
**\+**{*N*}<br>
**\+G**

*# po spuštění vyhledat první shodu s regulárním výrazem*<br>
**'\+/**{*reg. výraz*}**'**

## Zaklínadla: less (ovládání)

### Základní ovládání

*# **ukončit** less*<br>
**q**

*# skok o **stránku** vpřed/vzad*<br>
{_PageDown_}<br>
{_PageUp_}

*# skok o **řádku** obrazovky vpřed/vzad*<br>
{_↓_}<br>
{_↑_}

*# skok o řádku souboru vpřed/vzad*<br>
**/^**{_Enter_}**n**<br>
?
<!--
Nefunguje na poslední řádce souboru:
**/^**{_Enter_}**nNN**
-->

*# skok na **začátek**/na **konec**/doprostřed souboru*<br>
{_Home_}<br>
{_End_}<br>
**50p**

*# zobrazit vestavěnou nápovědu*<br>
**h**

*# **skok** na řádek č. N*<br>
{*N*}**g**

*# znovunačíst obsah souboru*<br>
{_Shift_}**+**{_R_}

### Vyhledávání

*# **skákat** po řádcích obrazovky odpovídajících poslednímu hledání vpřed/zpět*<br>
[{*kolikrát*}]**n**<br>
[{*kolikrát*}]**N**

*# vyhledat vpřed řádku **obsahující** shodu s reg. výrazem*<br>
*// Vykřičník jako první znak má v tomto případě zvláštní význam, takže pokud jím začíná váš regulární výraz, musíte ho odzvláštnit zpětným lomítkem.*<br>
{_/_}<br>
{*regulární výraz*}<br>
{_Enter_}

*# vyhledat vpřed řádku **neobsahující** shodu s reg. výrazem*<br>
{_/_}<br>
{_Ctrl_}**+**{_N_}<br>
{*regulární výraz*}<br>
{_Enter_}

*# **zvýraznit** podřetězce odpovídající regulárnímu výrazu*<br>
{_/_}<br>
{_Ctrl_}**+**{_K_}<br>
{*regulární výraz*}<br>
{_Enter_}

*# přepnout (vypnout či zapnout) zvýraznění shod s r.v.*<br>
{_Esc_}<br>
{_U_}

### Filtrování

*# zobrazit jen řádky obsahující/neobsahující shodu s reg. výrazem*<br>
**&amp;**{*regulární výraz*}{_Enter_}<br>
**&amp;** {_Ctrl_}**+**{_N_} {*regulární výraz*}{_Enter_}

*# vypnout filtrování*<br>
**&amp;**{_Enter_}

### Pojmenované pozice

*# přepnout zobrazení sloupce s pojmenovanými pozicemi*<br>
**\-J**{_Enter_}

*# **pojmenovat** pozici*<br>
**m**{*pismeno*}

*# **skok** na pozici*<br>
**'**{*pismeno*}

### Ostatní příkazy

*# přepnout (vyp:zap) sloupec s čísly řádků*<br>
**\-N**{_Enter_}

*# nezalamovat řádky a umožnit pohyb doprava a doleva pomocí klávesových šipek*<br>
**\-\-shift**{_Enter_}**1**{_Enter_}**-S**{_Enter_}

*# zobrazit ve stavové řádce pozici v souboru (dočasně/do ukončení)*<br>
{_Ctrl_}**+**{_G_}<br>
**\-M**{_Enter_}

*# překreslit obsah terminálu*<br>
{_Ctrl_}**+**{_L_}

*# spustit Bash*<br>
**!bash**{_Enter_}

## Zaklínadla: more
### Ovládání „more“

*# **ukončit** more*<br>
**q**

*# skok o stránku vpřed*<br>
{_Space_}

*# skok o řádku obrazovky vpřed*<br>
{_Enter_}

*# skok o řádku souboru vpřed*<br>
?

*# zobrazit vestavěnou nápovědu*<br>
**h**

*# zobrazit číslo aktuální řádky (souboru, nebo obrazovky?)*<br>
**=**


<!--
## Parametry příkazů
<!- -
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)
-->

## Instalace na Ubuntu

Všechny použité příkazy jsou základními součástmi Ubuntu,
přítomnými i v minimální instalaci, jen není-li nainstalovaný „vim“,
použije se místo něj podobný editor „vi“.

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
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získal/a; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->

* Program „less“ se hodí na jednoduché prohlížení, pro komplikovanější úlohy použijte editor „vim“ nebo jiný textový editor, případně s předzpracováním prohlíženého souboru vhodným nástrojem pro zpracování textu.
* Prohlížíte-li si programem „less“ text z roury, jejíž zdrojový příkaz ještě nedoběhl, a pokusíte-li se přitom přejít za konec dosud načteného vstupu, program „less“ se zastaví a bude čekat na další vstup; z tohoto stavu ho můžete probrat zkratkou Ctrl+C.

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->

* [Wikipedie: less](https://cs.wikipedia.org/wiki/Less\_(Unix\))
* [man less](https://manpages.ubuntu.com/manpages/focal/en/man1/less.1.html) (anglicky)
* [Oficiální stránka programu less](https://www.greenwoodsoftware.com/less/) (anglicky)
* [TL;DR: less](https://github.com/tldr-pages/tldr/blob/master/pages/common/less.md) (anglicky)
* [balíček less](https://packages.ubuntu.com/focal/less) (anglicky)
* [YouTube: less for beginners](https://www.youtube.com/watch?v=hxvAEr9Q2A4) (anglicky)

## Zákulisí kapitoly
<!--
- Doplňte, pokud víte. Udržujte aktuální.
-->

V této verzi kapitoly chybí:

!KompaktníSeznam:
* nastavení velikosti tabulátoru (less -x)

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* nic

!ÚzkýRežim: vyp
