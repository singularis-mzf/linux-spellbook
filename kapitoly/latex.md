<!--

Linux Kniha kouzel, kapitola LaTeX
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# LaTeX

!Štítky: {program}{typografie}
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

!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

*# základní struktura dokumentu*<br>
*// Užitečné třídy: book, article; užitečné volby: 10pt, draft.*<br>
**\\documentclass**[**[**{*volby*}**]**]**\{**{*třída*}**\}**

*# prázdné záhlaví i zápatí (nastavit/jen pro tuto stránku)*<br>
**\\pagestyle{empty}**<br>
**\\thispagestyle{empty}**

*# výchozí styl (jen číslo stránky v zápatí)(nastavit/jen pro tuto stránku)*<br>
**\\pagestyle{plain}**<br>
**\\thispagestyle{plain}**

*# změnit číslo stránky*<br>
**\\setcounter{page}\{**{*číslo*}**\}**

*# řádkování (1/1,5/2/obecně)*<br>
?<br>
?<br>
?

*# odsazení první řádky odstavce*<br>
?

*# mezera mezi odstavci*<br>
?

<!--
*# šířka/výška textové části stránky*<br>
\\textwidth<br>
\\textheight
-->

*# horizontální mezera (ne na okraji/vždy/jako znak)*<br>
**\\hspace\{**{*délka*}**\}**<br>
**\\hspace\*\{**{*délka*}**\}**<br>
**\\rule\{**{*délka*}**\}{0pt}**

*# vertikální mezera (za koncem řádku nebo odstavce)(střední/menší/větší/ne na okraji/vždy)*<br>
**\\medskip**<br>
**\\bigskip**<br>
**\\smallskip**<br>
**\\vspace\{**{*délka*}**\}**<br>
**\\vspace\*\{**{*délka*}**\}**

*# formát papíru A4 (alternativy)*<br>
**\\usepackage[**[**showframe,**]**a4paper,inner=top=**{*horní-okraj*}**,bottom=**{*spodní-okraj*}**,inner=**{*vnitřní-okraj*}**,outer=**{*vnější-okraj*}**]{geometry}**

*# deklarovat rodinu písma*<br>
<!--
\\usepackage{fontspec}
-->
**\\newfontfamily\{**{*\\novýpříkaz*}**\}**[**[**{*vlastnosti,písma*}**]**]**\{**{*Název písma*}**\}**

*# nastavit výchozí písma dokumentu (\\rmfamily, \\sffamily, \\ttfamily)*<br>
**\\setmainfont\{**{*Název písma*}**\}**[**[**{*vlastnosti,písma*}**]**]<br>
**\\setsansfont\{**{*Název písma*}**\}**[**[**{*vlastnosti,písma*}**]**]<br>
**\\setmonofont\{**{*Název písma*}**\}**[**[**{*vlastnosti,písma*}**]**]

*# jednorázově přepnout na nedeklarované písmo*<br>
**\\fontspec\{**{*Název písma*}**\}**[**[**{*vlastnosti,písma*}**]**]

*# je písmo dostupné?*<br>
**\\IfFontExistsTF\{**{*Název písma*}**\}\{**{*kód, pokud je*}**\}\{**{*kód, pokud není*}**\}**
<!--
[ ] Vyzkoušet!
-->

<!--
Nejčastější vlastnosti písma:
- Scale=MatchLowercase
-->

### Křížové odkazy

*# uložit pozici pro křížový odkaz*<br>
**\\label\{**{*identifikator*}**\}**

*# vložit číslo počítadla (nejčastěji označení sekce)*<br>
**\\ref\{**{*identifikator*}**\}**

*# vložit číslo stránky z křížového odkazu*<br>
**\\pageref\{**{*identifikator*}**\}**

### Členění dokumentu

*# část/kapitola (jen v třídě „book“)*<br>
**\\part\{**{*Název části*}**\}**<br>
**\\chapter\{**{*Název kapitoly*}**\}**

<!--
[ ] \chapter[titulek]{Název} ?
-->

*# sekce/podsekce*<br>
**\\section\{**{*Název sekce*}**\}**<br>
**\\subsection\{**{*Název podsekce*}**\}**

*# označení odstavce*<br>
**\\paragraph\{**{*Titulek odstavce*}**\}** {*Text odstavce.*}

<!--
\\subparagraph
-->

<!--
*# příkazy pro členění knihy*<br>
**\\frontmatter \\mainmatter \\appendix \\backmatter**
-->

### Konec řádku

*# okamžitý/přikázaný/doporučený*<br>
*// Důležitost je číslo 0 (nejmenší) až 4 (největší).*<br>
**\\\\**[**[**{*délka (mezera navíc)*}**]**][*\\relax*]<br>
**\\newline**<br>
**\\linebreak[**{*důležitost*}**]**

*# vysázet text se zakázaným zalomením řádky*<br>
**\\mbox\{**{*text*}**\}**

### Konec stránky

*# s vyprázdněním/přikázaný/doporučený*<br>
**\\clearpage**<br>
**\\newpage**<br>
**\\pagebreak[**{*důležitost*}**]**

*# začít další lichou stránku*<br>
**\\cleardoublepage**

<!--
\raggedbottom
\showhyphens{slova...}
-->

### Formát textu

*# zvýraznit (alternativy)*<br>
**\\emph\{**{*text*}**\}**<br>
**\\em** {*text*}

<!--
*# velikosti písma od nejmenší po největší*<br>
**\\tiny \\scriptsize \\footnotesize \\small \\normalsize \\large \\Large \\LARGE \\huge \\Huge**
-->


### Přepínače

*# deklarovat nový přepínač/jen pokud neexistuje*<br>
*// Výchozí hodnota nového přepínače je nepravda.*<br>
^^**\\usepackage{etoolbox}**<br>
**\\newtoggle{<nic>**{*názevpřepínače*}**<nic>}**<br>
**\\providetoggle{<nic>**{*názevpřepínače*}**<nic>}**

*# přepnout do stavu pravda/nepravda*<br>
^^**\\usepackage{etoolbox}**<br>
**\\toggletrue{<nic>**{*názevpřepínače*}**<nic>}**<br>
**\\togglefalse{<nic>**{*názevpřepínače*}**<nic>}**

*# přepnout do opačného stavu*<br>
^^**\\usepackage{etoolbox}**<br>
**\\iftoggle{<nic>**{*názevpřepínače*}**<nic>}{\\togglefalse}{\\toggletrue}{<nic>**{*názevpřepínače*}**<nic>}**

### Podmíněný překlad

*# je řetězec prázdný?*<br>
^^**\\usepackage{etoolbox}**<br>
**\\ifstrempty{<nic>**{*řetězec*}**<nic>}**{*tělo*}

*# jsou dva řetězce shodné?*<br>
^^**\\usepackage{etoolbox}**<br>
**\\ifstrequal{<nic>**{*jeden řetězec*}**<nic>}{<nic>**{*druhý řetězec*}**<nic>}**{*tělo*}

*# porovnání číselných výrazů*<br>
*// Výrazy mohou obsahovat: uzávorkování, čeločíselné konstanty, operátory +, -, \*, /, příkaz \\value{} k získání hodnoty počítadla.*<br>
^^**\\usepackage{etoolbox}**<br>
**\\ifnumcomp{<nic>**{*levý výraz*}**<nic>}{<nic>**{*operátor-&lt;-=-nebo-&gt;*}**<nic>}{<nic>**{*pravý výraz*}**<nic>}**{*tělo*}

*# je číslo sudé?*<br>
^^**\\usepackage{etoolbox}**<br>
**\\ifnumodd{<nic>**{*celočíselný výraz*}**<nic>}**{*tělo*}

*# porovnání délek*<br>
*// Výrazy mohou obsahovat: uzávorkování, délkové konstanty (např. „0.5pt“) a jejich součty a rozdíly, násobení či dělení číslem (např. „\* 2.5“), délkové registry (např. „\\parskip“).*<br>
^^**\\usepackage{etoolbox}**<br>
**\\ifdimcomp{ **{*levý výraz*}** }{<nic>**{*operátor-&lt;-=-nebo-&gt;*}**<nic>}{ **{*pravý výraz*}** }**{*tělo*}

*# je přepínač ve stavu „pravda“/„nepravda“?*<br>
**\\iftoggle{<nic>**{*názevpřepínače*}**<nic>}**{*tělo*}<br>
**\\nottoggle{<nic>**{*názevpřepínače*}**<nic>}**{*tělo*}



<!--
Příkazy \ifnumcomp a \ifdimcomp prý fungují i ve vyhodnocovaném kontextu.
-->

### Obecný podmíněný překlad

*# obecný tvar*<br>
*// Logický výraz může obsahovat: uzávorkování a operátory uvedené níže.*<br>
^^**\\usepackage{etoolbox}**<br>
**\\ifboolexpr{ **{*logický výraz*}** }**{*tělo*}

*# opakovat kód, dokud je/není podmínka splněna*<br>
**\\whileboolexpr{ **{*logický výraz*}** }{<nic>**{*kód*}**<nic>}**

*# operátor pro přečtení přepínače*<br>
**togl{<nic>**{*názevpřepínače*}**<nic>}**

*# operátor logické negace*<br>
**not** {*negovaný test*}

*# operátor logického součinu/součtu*<br>
{*jeden logický výraz*} **and** {*druhý logický výraz*}<br>
{*jeden logický výraz*} **or** {*druhý logický výraz*}

*# vnořený test*<br>
**test{<nic>** {*vnořený test s parametry, ale bez těla*} **<nic>}**


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

* [stránku na Wikipedii](https://cs.wikipedia.org/wiki/Hlavn%C3%AD_strana)
* oficiální stránku programu
* oficiální dokumentaci
* [manuálovou stránku](http://manpages.ubuntu.com/)
* [balíček Bionic](https://packages.ubuntu.com/)
* online referenční příručky
* různé další praktické stránky, recenze, videa, tutorialy, blogy, ...
* [DeTeXify](http://detexify.kirelabs.org/classify.html) (anglicky) – pomůcka k nalezení symbolů LaTeXu podle ruční kresby
* publikované knihy

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
