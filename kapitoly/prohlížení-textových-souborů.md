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

Tato kapitola se specializuje na prohlížení textových souborů
(např. systémových záznamů), tedy zobrazování jejich obsahu uživateli
bez možnosti tento obsah měnit, ale s možností ho prohledávat
a filtrovat.

Pokud máte na práci se soubory práci větší požadavky, než co vám nabízejí
nástroje popsané v této kapitole, měli byste použít plnohodnotný editor,
např. vim.

Příkaz „less“ je vyvíjen v rámci projektu GNU, příkaz „more“ nikoliv.

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

* **Řádek souboru** (resp. řádka souboru) je řádek, jak se nachází v prohlíženém souboru (tedy posloupnost znaků oddělená od ostatních řádků ukončovačem řádky).
* **Řádka obrazovky** (resp. řádek obrazovky) je řádka, jak je prohlížecím programem zobrazena na terminálu. Jeden řádek souboru se může zalomit na více řádek obrazovky.

!ÚzkýRežim: vyp

## Zaklínadla

### Prohlížení souborů

*# otevřít textový soubor v programu less/programu more*<br>
**less** [{*volby*}]... [**\-\-**] {*cesta/k/souboru*}<br>
**more** [**\-\-**] {*cesta/k/souboru*}

*# otevřít textový soubor v režimu pro čtení editoru „vim“*<br>
**view** [**\-\-**] {*cesta/k/souboru*}
<!--
[ ] Není požadován nějaký balíček?
-->

### Sledování měnících se souborů



## Zaklínadla: less

### Základní ovládání

*# **ukončit** less*<br>
**q**

*# skok o stránku vpřed/vzad*<br>
{_PageDown_}<br>
{_PageUp_}

*# skok o řádku obrazovky vpřed/vzad*<br>
{_↓_}<br>
{_↑_}

*# skok o řádku souboru vpřed/vzad*<br>
?<br>
?

*# skok na začátek/konec souboru*<br>
{_Home_}<br>
{_End_}

*# zobrazit vestavěnou nápovědu*<br>
**h**

### Vyhledávání

*# vyhledat vpřed řádku **obsahující** shodu s reg. výrazem*<br>
*// Vykřičník jako první znak má v tomto případě zvláštní význam, takže pokud jím začíná váš regulární výraz, musíte ho odzvláštnit zpětným lomítkem.*<br>
{_/_}<br>
{*regulární výraz*}<br>
{*Enter*}

*# vyhledat vpřed řádku **neobsahující** shodu s reg. výrazem*<br>
{_/_}<br>
{_Ctrl_}**+**{_N_}<br>
{*regulární výraz*}<br>
{*Enter*}

*# skákat po řádcích obrazovky se shodami s vyhledaným regulárním výrazem vpřed/zpět*<br>
[{*kolikrát*}]**n**<br>
[{*kolikrát*}]**N**

*# zvýraznit podřetězce odpovídající regulárnímu výrazu*<br>
{_/_}<br>
{_Ctrl_}**+**{_K_}<br>
{*regulární výraz*}<br>
{*Enter*}

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

*# přepnout (vyp:zap) sloupec s čísly řádek*<br>
**\-N**{_Enter_}

*# nezalamovat řádky a umožnit pohyb doprava a doleva pomocí klávesových šipek*<br>
**\-\-shift**{_Enter_}**1**{_Enter_}**-S**

*# skok na řádek č. N*<br>
{*N*}**G**

*# znovunačíst obsah souboru*<br>
**R**

*# zobrazit ve stavové řádce pozici v souboru (dočasně/do ukončení)*<br>
{_Ctrl_}**+**{_G_}<br>
**\-M**{_Enter_}

*# spustit Bash*<br>
**!bash**{_Enter_}

## Ovládání „more“

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
[ ] tail -f
-->


<!--
## Parametry příkazů
<!- -
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)
-->

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíčků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

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
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

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

## Zákulisí kapitoly
<!--
- Doplňte, pokud víte. Udržujte aktuální.
-->

V této verzi kapitoly chybí:

!KompaktníSeznam:
* nic

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* nic

!ÚzkýRežim: vyp
