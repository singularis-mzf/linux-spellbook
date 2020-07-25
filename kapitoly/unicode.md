<!--

Linux Kniha kouzel, kapitola Unicode, emoji a další zvláštní znaky
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

https://unix.stackexchange.com/questions/198849/how-can-i-find-the-common-name-for-a-particular-glyph

-->

# Unicode a emotikony

!Štítky: {tematický okruh}{emotikony}{znaky}
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

*# získat kód znaku (desítkový/hexadecimální)*<br>
*// Poznámka: díky použitému odzvláštnění by tento tvar měl fungovat pro všechny znaky s výjimkou apostrofu (znak č. 39, resp. 0027).*<br>
**printf %d\\\\n \\''**{*znak*}**'**<br>
**printf %04x\\\\n \\''**{*znak*}**'**

*# vypsat znak podle kódu (desítkového/hexadecimálního)*<br>
**printf \\\\U$(printf %08x** {*desítkový-kód*}**)**[**\\\\n**]<br>
**printf \\\\U$(printf %08x 0x**{*hexadecimální-kód*}**)**[**\\\\n**]<br>

*# rozdělit řetězec po znacích a ke každému vypsat desítkový a hexadecimální kód*<br>
?

### Znamení zvěrokruhu

*# všechna (**vzorník**)*<br>
**printf '\\u2648\\u2649\\u264a\\u264b\\u264c\\u264d\\u264e\\u264f\\u2650\\u2651\\u2652\\u2653\\n'**

*# beran*<br>
**printf '\\u2648\\n'**

*# býk*<br>
**printf '\\u2649\\n'**

*# blíženci*<br>
**printf '\\u264a\\n'**

*# rak*<br>
**printf '\\u264b\\n'**

*# lev*<br>
**printf '\\u264c\\n'**

*# panna*<br>
**printf '\\u264d\\n'**

*# váhy*<br>
**printf '\\u264e\\n'**

*# štír*<br>
**printf '\\u264f\\n'**

*# střelec*<br>
**printf '\\u2650\\n'**

*# kozoroh*<br>
**printf '\\u2651\\n'**

*# vodnář*<br>
**printf '\\u2652\\n'**

*# ryby*<br>
**printf '\\u2653\\n'**

### Jídlo

*# hot dog*<br>
**printf '\\U0001f32d\\n'**

*# taco (mexická topinka)*<br>
**printf '\\U0001f32e\\n'**

*# burrito*<br>
**printf '\\U0001f32f\\n'**

### Ovoce a zelenina, plody

*# jablko (červené/zelené)*<br>
**printf '\\U0001f34e\\n'**<br>
**printf '\\U0001f34f\\n'**

*# třešně*<br>
**printf '\\U0001f352\\n'**

*# jahoda*<br>
**printf '\\U0001f353\\n'**

*# rajče*<br>
**printf '\\U0001f345\\n'**

*# banán*<br>
**printf '\\U0001f34c\\n'**

*# pomeranč*<br>
**printf '\\U0001f34a\\n'**

*# citrón*<br>
**printf '\\U0001f34b\\n'**

*# hruška*<br>
**printf '\\U0001f350\\n'**

*# broskev*<br>
**printf '\\U0001f351\\n'**

*# ananas*<br>
**printf '\\U0001f34d\\n'**

*# meloun (rozkrojený/malý)*<br>
**printf '\\U0001f349\\n'**<br>
**printf '\\U0001f348\\n'**

*# hroznové víno (tmavé)*<br>
**printf '\\U0001f347\\n'**

*# kukuřice*<br>
**printf '\\U0001f33d\\n'**

*# kaštan*<br>
**printf '\\U0001f330\\n'**

*# lilek*<br>
**printf '\\U0001f346\\n'**

*# feferonka (pálivá paprika)*<br>
**printf '\\U0001f336\\n'**

### Květiny a květy

*# sedmikráska*<br>
**printf '\\U0001f33c\\n'**

*# růže (červená)*<br>
**printf '\\U0001f339\\n'**

*# tulipán (červený)*<br>
**printf '\\U0001f337\\n'**

*# květ třešně*<br>
**printf '\\U0001f338\\n'**

*# slunečnice*<br>
**printf '\\U0001f33b\\n'**

*# ibišek*<br>
**printf '\\U0001f33a\\n'**

### Stromy, listy a houby

*# muchomůrka červená*<br>
**printf '\\U0001f344\\n'**

*# listnatý strom*<br>
**printf '\\U0001f333\\n'**

*# jehličnatý strom*<br>
**printf '\\U0001f332\\n'**

*# palma*<br>
**printf '\\U0001f334\\n'**

*# list javoru*<br>
**printf '\\U0001f341\\n'**

*# opadané listy*<br>
**printf '\\U0001f342\\n'**

*# listy ve větru*<br>
**printf '\\U0001f343\\n'**


### Byliny, traviny, sukulenty a sazenice

*# kaktus*<br>
**printf '\\U0001f335\\n'**

*# čtyřlístek*<br>
**printf '\\U0001f340\\n'**

*# sazenice*<br>
**printf '\\U0001f331\\n'**

*# bylina*<br>
**printf '\\U0001f33f\\n'**

<!--
Není lepší název?
-->
*# rýžové trsy*<br>
**printf '\\U0001f33e\\n'**

### Šachové figury

*# král (bílý/černý)*<br>
**printf '\\u265a\\n'**<br>
**printf '\\u2654\\n'**

*# dáma (bílá/černá)*<br>
**printf '\\u265b\\n'**<br>
**printf '\\u2655\\n'**

*# věž (bílá/černá)*<br>
**printf '\\u265c\\n'**<br>
**printf '\\u2656\\n'**

*# střelec (bílý/černý)*<br>
**printf '\\u265d\\n'**<br>
**printf '\\u2657\\n'**

*# jezdec (bílý/černý)*<br>
**printf '\\u265e\\n'**<br>
**printf '\\u2658\\n'**

*# pěšec (bílý/černý)*<br>
**printf '\\u265f\\n'**<br>
**printf '\\u2659\\n'**


*# šachové pole (bílé/černé)*<br>
?<br>
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
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
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
