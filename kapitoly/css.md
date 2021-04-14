<!--

Linux Kniha kouzel, kapitola CSS
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

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

# CSS

!Štítky: {tematický okruh}{syntaxe}
!FixaceIkon: 1754
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

* **Selektor** je...
* **Vlastnost** je...

### Flexbox

* **Kontejner** je HTML prvek s nastavením „display: flex“; takový prvek se chová jako blokový a prvky v něm bezprostředně vnořené (takzvané **prvky kontejneru**) také, a navíc se rozmísťují metodou „flexbox“ do logických řádků a případně i do logických sloupců.
* **Logický řádek** (zkratkou „l. ř.“): pokud je základní směr umísťování prvků po řádcích (zleva doprava nebo zprava doleva), je to každý řádek; pokud je základní směr umísťování prvků po sloupcích (shora dolů nebo zdola nahoru), je to každý sloupec.
* **Logický sloupec** (zkratkou „l. s.“) je doplněk k logickému řádku: jsou-li logickými řádky řádky, jsou logickými sloupci sloupce; naopak jsou-li logickými řádky sloupce, jsou logickými sloupci řádky. Pokud nedojde k zalomení logické řádky, bude mít flexbox jen jeden logický sloupec.

!ÚzkýRežim: vyp

## Zaklínadla: Selektory
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Zaklínadla: Vlastnosti

### Písmo

*# tučné*<br>
**font-weight: bold;**

*# kurzíva/skloněné*<br>
**font-style: italic;**<br>
**font-style: oblique;**

### Okraje

*# vnější/vnitřní okraj*<br>
*// Vnější okraj (margin) může být záporný.*<br>
**margin:** {*nahoře*} {*vpravo*} {*dole*} {*vlevo*}**;**<br>
**padding:** {*nahoře*} {*vpravo*} {*dole*} {*vlevo*}**;**

### Zaklínadla: Flexbox

*# zobrazit prvek a jeho bezprostřední potomky metodou „flexbox“*<br>
**display: flex;**

### Kontejner: orientace l. ř

*# zleva doprava, nezalamovat*<br>
**flex-flow: row nowrap;**

*# zleva doprava, další l. ř. pod stávajícím*<br>
**flex-flow: row wrap;**

*# zleva doprava, další l. ř. nad stávající*<br>
**flex-flow: row wrap-reverse;**

*# shora dolů, nezalamovat*<br>
**flex-flow: column nowrap;**

*# shora dolů, další l. ř. vpravo od stávajícího*<br>
**flex-flow: column wrap;**

*# shora dolů, další l. ř. vlevo od stávající*<br>
**flex-flow: column wrap-reverse;**

*# zprava doleva, nezalamovat*<br>
**flex-flow: row-reverse nowrap;**

*# zprava doleva, další l. ř. pod stávajícím*<br>
**flex-flow: row-reverse wrap;**

*# zprava doleva, další l. ř. nad stávající*<br>
**flex-flow: row-reverse wrap-reverse;**

*# zespodu nahoru, nezalamovat*<br>
**flex-flow: column-reverse nowrap;**

*# zespodu nahoru, další l. ř. vpravo od stávajícího*<br>
**flex-flow: column-reverse wrap;**

*# zespodu nahoru, další l. ř. vlevo od stávající*<br>
**flex-flow: column-reverse wrap-reverse;**

<!--
flex-flow: row nowrap;
flex-flow: row wrap;
flex-flow: row wrap-reverse;
flex-flow: column nowrap;
flex-flow: column wrap;
flex-flow: column wrap-reverse;
flex-flow: row-reverse nowrap;
flex-flow: row-reverse wrap;
flex-flow: row-reverse wrap-reverse;
flex-flow: column-reverse nowrap;
flex-flow: column-reverse wrap;
flex-flow: column-reverse wrap-reverse;
-->

### Kontejner: kam umístit přebytečné místo l. ř.

Poznámka: toto nastavení je ignorováno, pokud má kterýkoliv prvek na logickém
řádku nastaveno nenulové roztažení (vlastnost „flex-grow“, resp. „flex“).

*# za poslední prvek kontejneru (výchozí)*<br>
**justify-content: flex-start;**

*# rozložit na začátek a konec l.ř.*<br>
**justify-content: center;**

*# před první prvek kontejneru*<br>
**justify-content: flex-end;**

*# rozložit do mezer mezi prvky; na začátek a konec žádnou/polovinu mezery*<br>
**justify-content: space-between;**<br>
**justify-content: space-around;**

*# roztáhnout prvky, aby přebytečné místo zabraly*<br>
!: Nastavte prvkům (ne kontejneru):<br>
**flex: 1 1 auto;**

### Kontejner: kam umístit přebytečné místo l. s.

*# za poslední l. ř. (výchozí)*<br>
**align-content: flex-start;**

*# rozložit před první a za poslední l. ř.*<br>
**align-content: center;**

*# před první l. ř.*<br>
**align-content: flex-end;**

*# rozložit do mezer mezi logickými řádky; na začátek a konec žádnou/polovinu mezery*<br>
**align-content: space-between;**<br>
**align-content: space-around;**

### Prvek kontejneru: ortogonální zarovnání v l. ř.

*# roztáhnout na celou výšku (resp. šířku) l. ř. (výchozí)*<br>
**align-self: stretch;**

*# zarovnat k přímce předchozím a tímto/tímto a následujícím logickým řádkem*<br>
**align-self: flex-start;**

*# zarovnat účaří*<br>
**align-self: baseline;**

### Prvek kontejneru: další vlastnosti

*# nastavit chování délky prvku na logickém řádku (obecně/výchozí nastavení)*<br>
*// „Roztažení“ je nezáporné celé číslo; výchozí je 0, která znamená, že se prvek neroztahuje. Má-li kterýkoliv prvek na logické řádce nenulové roztažení, zbylé volné místo na l. ř. se rozdělí na tolik dílů, kolik je potřeba, a všechny prvky se roztáhnou o tolik dílů, kolik udává jejich „roztažení“. Pouze v případě, že mají všechny prvky roztažení nulové, rozmístí se volné místo podle vlastnosti kontejneru „justify-content“.*<br>
*// „Smrštění“ je nezáporné celé číslo; výchozí je 1. Není-li na logické řádce dostatek místa pro všechny prvky, chybějící místo se rozdělí na tolik dílů, kolik je potřeba, a délka každého prvku se zmenší o tolik dílů, kolik udává jeho „smrštění“. Nastavením smrštění na 0 lze zmenšení délky prvku zabránit.*<br>
*// „Výchozí-délka“ je buď „auto“ (výchozí hodnota, která znamená přirozenou šířku prvku), konkrétní délka (např. „10em“) nebo hodnota v procentech (např. „50%“).*<br>
**flex:** {*roztažení*} {*smrštění*} {*výchozí-délka*}<br>
**flex: 0 1 auto;**

*# stanovit **pořadí** prvku v kontejneru*<br>
*// Výchozí pořadí je 0.*<br>
**order:** {*celé-číslo*}

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

!ÚzkýRežim: vyp
