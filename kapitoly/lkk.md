<!--

Linux Kniha kouzel, kapitola Linux: Kniha kouzel
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

# Linux: Kniha kouzel

!Štítky: {ostatní}
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

* **Kapitola** je textová část projektu vymezená jedním zdrojovým souborem v adresáři „kapitoly“. Název tohoto souboru bez přípony „.md“ je *id kapitoly*, text hlavního nadpisu v daném souboru je **název kapitoly**.
* **Sekce** je oddíl kapitoly vymezený druhou úrovní nadpisu. Sekce se může dále dělit na **podsekce**.
* **Zaklínadlo** je...
* Zaklínadlo se skládá z **řádek zaklínadla**, které mohou být třech typů: základní (uvádí text, který má uživatel zadat, či klávesy, které má stisknout), **akce** (slovy popisuje, co má uživatel udělat) či **do hlavičky** (stejná jako základní, ale jde o deklaraci určenou k umístění do záhlaví zdrojového kódu, typickými příklady jsou direktiva #include v jazyce C, příkaz „&lt;meta&gt;“ v jazyce HTML, příkaz „use“ v jazyce Perl či příkaz \\usepackage v jazyce LaTeX). Zaklínadlo může mít také jednu nebo více poznámek pod čarou.

!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

### Zaklínadlo

Obecně platí, že všechny nebílé znaky, které má uživatel zadat tak, jak jsou, se v Markdownu
v zaklínadlech zapisují tak, aby při běžném zobrazení byly tučné – to znamená, že se zapisují
dovnitř dvojic \*\*{*text*}\*\*. To platí i pro jednoznakové úseky jako \*\*.\*\* či
\*\*"\*\*. Všechny netučné znaky jsou pak řídicí.

*# obecný tvar zaklínadla*<br>
**\*#&blank;**[{*titulek*}]**\*&lt;br&gt;**<br>
[**\*//&blank;**{*text poznámky pod čarou*}**\*&lt;br&gt;**]...<br>
{*řádka zaklínadla*}...

*# obecný tvar řádky zaklínadla (základní/akce/do hlavičky)*<br>
*// U poslední řádky zaklínadla se vždy vynechává uzavírající &lt;br&gt;! U akce se text do hvězdiček neuzavírá!*<br>
[{*text*}]**&lt;br&gt;**<br>
**!:&blank;**{*text*}**&lt;br&gt;**<br>
**^^**{*text*}**&lt;br&gt;**

*# příklady základních řádek zaklínadla*<br>
?

*# příklady akcí*<br>
**!: Klikněte na záhlaví okna.**

### Základní řádky zaklínadla

### Akce

### Řádky zaklínadla do záhlaví a odsazené řádky

### Formátování

*# pole, za které má uživatel něco doplnit (obecně/příklad/jak to vypadá)*<br>
**\{\***{*popis*}**\*\}**<br>
**\{\*název souboru\*\}**<br>
{*název souboru*}

*# klávesa (obecně/příklad/jak to vypadá)*<br>
**\{\_**{*text*}**\_\}**<br>
**\{\_Esc\_\}**<br>
{_Esc_}

*# hlavní nadpis (název kapitoly)*<br>
**\#&blank;**{*Název kapitoly*}

*# nadpis sekce (obecně/příklad)*<br>
**\#\#&blank;**{*Název sekce*}<br>
**\#\# Definice**

*# nadpis podsekce (obecně/příklad)*<br>
**\#\#\#&blank;**{*Název podsekce*}<br>
**\#\#\# Podrobné výpisy**



## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíčků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

!ÚzkýRežim: zap

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

* Chyba při překladu „Formátovací značka neuzavřena do konce řádku“ je velmi běžná. Při psaní nové kapitoly se mi běžně stává i třikrát na každý překlad. Buďte na ni připraveni a naučte se ji rychle a efektivně opravovat.

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
