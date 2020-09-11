<!--

Linux Kniha kouzel, kapitola Markdown
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--

ÚKOLY:
[ ] Pokrýt GFM (podle https://github.github.com/gfm/).

-->

# Markdown

!Štítky: {syntaxe}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod
Markdown je jednoduchý a praktický značkovací jazyk pro pohodlné psaní i čtení textů s jednoduchým formátováním v editorech prostého textu. Je primárně určen k převodu do HTML, kde se na výsledek aplikují kaskádové styly.

Bohužel existuje řada ne zcela kompatibilních implementací Markdownu. Proto se tato kapitola zaměřuje především na původní (standardní) Markdown, který je základem pro všechny ostatní varianty, a poměrně značně rozšířenou variantu Markdown Extra.

Tato verze kapitoly nepokrývá GFM (GitHub Flavoured Markdown), nicméně všechna uvedená zaklínadla na GitHubu fungují.

<!--
-- Definice nejsou v této kapitole třeba.
## Definice
-->

!ÚzkýRežim: vyp

## Zaklínadla: Markdown

### Nadpisy

*# nadpis první/druhé/třetí/čtvrté/páté/šesté úrovně*<br>
**\#** {*nadpis*}<br>
**\##** {*nadpis*}<br>
**\###** {*nadpis*}<br>
**\####** {*nadpis*}<br>
**\#####** {*nadpis*}<br>
**\######** {*nadpis*}<br>

### Základní formátování

*# dva **odstavce***<br>
{*první odstavec*}<br>
{*prázdná řádka*}<br>
{*druhý odstavec*}

*# **tučný** text*<br>
**\*\***{*text*}**\*\***

*# **kurzíva***<br>
**\***{*text*}**\***

*# vložený **kód** v rámci řádku (obecně/příklad)*<br>
*// Ve vloženém kódu se neinterpretují žádné formátovací sekvence ani odzvláštnění (dokonce i zpětné lomítko si tam zachovává význam obyčejného znaku), proto je potřeba zvláštní přístup, pokud má vložený kód obsahovat zpětné apostrofy. K otevření a uzavření vloženého kódu můžete použít libovolný počet zpětných apostrofů, ale musí být stejný pro otevření i pro uzavření a vyšší než maximální počet zpětných apostrofů vyskytujících se ve formátovaném kódu vedle sebe.*<br>
**\`**{*kód*}**\`**<br>
**\`\`\`\`PRIKLAD="\*\`\`\`\*"\`\`\`\`**

*# víceřádkový **kód***<br>
**&blank;&blank;&blank;&blank;**{*první řádek*}<br>
[**&blank;&blank;&blank;&blank;**{*další řádka*}]...

### Odkazy a obrázky

*# hypertextový **odkaz** (normální/zjednodušený)*<br>
*// Některé interprety markdownu automaticky převádějí úplné URL adresy na hypertextové odkazy bez zjevné možnosti odzvláštnění.*<br>
**[**{*text odkazu*}**\](**{*adresa-odkazu*}[**&blank;"**{*titulek*}**"**]**)**<br>
**&lt;**{*adresa-odkazu*}**&gt;**

*# předdefinovaný hypertextový odkaz (definice/použití)*<br>
*// Definice se uvádí pro každý identifikátor pouze jednou a může být kdekoliv v dokumentu (ale na samostatné řádce). Definovaný identifikátor může být použit na více místech, a to i s různými texty odkazů. Identifikátor může začínat číslem a obsahovat mezery a není citlivý na velikost písmen!*<br>
**[**{*identifikátor*}**]:&blank;**[{*bílé znaky*}]{*adresa-odkazu*}[**&blank;"**{*titulek*}**"**]<br>
**[**{*text odkazu*}**\][**{*identifikátor*}**]**

*# vložit **obrázek** (jako znak)*<br>
**![**{*alternativní text*}**\](**{*adresa-odkazu*}[**&blank;"**{*titulek*}**"**]**)**

*# předdefinovaný obrázek (definice/použití)*<br>
**[**{*identifikátor*}**]:&blank;**[{*bílé znaky*}]{*adresa-obrázku*}[**&blank;"**{*titulek*}**"**]<br>
**![**{*alternativní text*}**\][**{*identifikátor*}**]**

### Seznamy a odsazení

*# **odrážkovaný** seznam*<br>
**\*** {*položka seznamu*}<br>
[**\*** {*další položka seznamu*}]...<br>
{*prázdný řádek*}

*# automaticky **číslovaný** seznam*<br>
**1.** {*položka seznamu*}<br>
[**1.** {*další položka seznamu*}]...<br>
{*prázdná řádka*}

<!--
-- Nefunguje?

*# odrážkovaný seznam s odstavci*<br>
**\*&blank;&blank;&blank;**{*text prvního odstavce*}<br>
[**&blank;&blank;&blank;&blank;**{*pokračování*}]<br>
<br>
**&blank;&blank;&blank;&blank;**{*text druhého odstavce*}<br>
[**&blank;&blank;&blank;&blank;**{*pokračování*}]<br>
<br>
**\*&blank;&blank;&blank;**{*druhá položka*}<br>
{*prázdná řádka*}

*# automaticky číslovaný seznam s odstavci*<br>
**1.&blank;&blank;**{*text prvního odstavce*}<br>
[**&blank;&blank;&blank;&blank;**{*pokračování*}]<br>
<br>
**&blank;&blank;&blank;&blank;**{*text druhého odstavce*}<br>
[**&blank;&blank;&blank;&blank;**{*pokračování*}]<br>
<br>
**1.&blank;&blank;**{*druhá položka*}
-->

*# výrazné **odsazení** odstavce zleva (první úroveň)*<br>
**&gt;** {*začátek textu*}<br>
[**&gt;** {*pokračování*}]...

*# výrazné odsazení odstavce zleva (druhá úroveň)*<br>
**&gt; &gt;** {*začátek textu*}<br>
[**&gt; &gt;** {*pokračování*}]...

## Zaklínadla: Markdown Extra

*# **tabulka***<br>
*// Zarovnání je „:\-\-\-“ vlevo, „\-\-\-“ na střed nebo „\-\-\-:“ vpravo. Řádek se záhlavím a řádka se zarovnáními jsou povinné, ostatní řádky tabulky jsou nepovinné. Buňky tabulky mohou obsahovat formátování.*<br>
**\|** {*záhlaví 1*} [**\|** {*další záhlaví*}]...<br>
**\|** {*zarovnání 1*} [**\|** {*další zarovnání*}]...<br>
[**\|** {*buňka 1*} [**\|** {*další buňka*}]...]...

*# **poznámka pod čarou** (odkaz na poznámku/text poznámky)*<br>
*// Omezení: Na jednu poznámku pod čarou lze odkazovat tímto způsobem pouze jednou!*<br>
**\[<nic>^**{*id*}**]**<br>
**\[<nic>^**{*id*}**]:&blank;**{*text poznámky*}

*# **seznam definic** se dvěma definicemi (druhá má dva pojmy)*<br>
{*první pojem*}<br>
**:**&blank;{*odstavec popisující první pojem*}<br>
{*prázdný řádek*}<br>
{*druhý pojem*}<br>
{*třetí pojem*}<br>
**:**&blank;{*odstavec popisující druhý a třetí pojem*}

*# víceřádkový **kód***<br>
*// Pro tuto syntaxi můžete použít i více než tři znaky \~, ale jejich počet v zahajující a ukončující řádce se musí shodovat.*<br>
**\~\~\~**[&blank;**.**{*CSS-třída*}]<br>
{*řádka kódu*}...<br>
**\~\~\~**

*# nadpis s kotvou/odkaz na takový nadpis*<br>
{*nadpis*} [{*bílé znaky*}]**\{\#**{*id*}**}**<br>
**\[**{*text odkazu*}**\](#**{*id*}[**&blank;"**{*titulek*}**"**]**)**

*# zkratky (&lt;abbr&gt;)(definice/použití)*<br>
**\*[**{*zkratka*}**]:** {*vysvětlení*}<br>
{*zkratka*}

### Ostatní

*# **komentář***<br>
**&lt;!\-\-** {*obsah komentáře, i víc řádek*} **\-\-&gt;**

*# horizontální čára*<br>
**\*\*\***

## Zaklínadla: Nestandardní

*# **podtržení***<br>
**&lt;u&gt;**{*text*}**&lt;/u&gt;**

*# **přeškrtnutý** text*<br>
**\~\~**{*text*}**\~\~**

*# **kód** se zvýrazněním syntaxe*<br>
**\`\`\`**{*syntaxe*}<br>
{*řádka kódu*}...<br>
**\`\`\`**

## Parametry příkazů
*# převod Markdownu na HTML5*<br>
**pandoc -f gfm -t html5 -o** {*výstupní-soubor*} {*vstupní-soubor*}

## Instalace na Ubuntu
*# příkaz pandoc pro konverzi na HTML a jiné formáty*<br>
**sudo apt-get install pandoc**

*# editor (grafický)*<br>
**sudo apt-get install retext**

Existuje i modernější a propracovanější editor [Remarkable](https://remarkableapp.github.io/linux.html) (licence MIT) zaměřený především na Arch Linux, ale je možno ho nainstalovat i v Ubuntu.

## Ukázka

*# *<br>
**\# Ukázka Markdownu**<br>
**\## Nadpis druhé úrovně**<br>
**Text prvního**<br>
**odstavce obsahuje část \*\*tučně\*\*, část \*kurzívou\* a část &lt;u&gt;podtrženou&lt;/u&gt; a také \`\`vložený kód se zpětným apostrofem (\`)\`\`.**<br>
<br>
**Text druhého odstavce. [Odkaz s&amp;nbsp;textem\](http:⫽www.slovnik-synonym.cz/), [s&nbsp;id\][Slovník synonym], [znovu s&nbsp;id\][Slovník synonym] a &lt;http:⫽www.slovnik-synonym.cz/&gt;.**<br>
<br>
**Obrázky: ![tento\][ve výstavbě] a ![tento\](../obrazky/ve-vystavbe.png).**<br>
<br>
**\[Slovník synonym]: http://www.slovnik-synonym.cz/**<br>
**\[ve výstavbě]: ../obrazky/ve-vystavbe.png**<br>
**\[^pozn-pod-carou]: S poznámkou pod čarou.**<br>
<br>
**&gt; Odstavec odsazený**<br>
**na první úroveň\[^pozn-pod-carou].**<br>
<br>
**&gt; &gt; Odstavec odsazený**<br>
**na druhou úroveň.**<br>
**\### Tabulka (Markdown Extra)**<br>
**\| Sloupec 1 \| Sloupec 2 \| Sloupec 3**<br>
**\| :\-\-\- \| \-\-\- \| \-\-\-:**<br>
**\| vlevo \| na střed \| vpravo**

!ÚzkýRežim: zap

## Tipy a zkušenosti
* Asi nejhorším problémem v Markdownu je odzvláštňování. Speciální znaky se totiž odzvláštňují zpětným lomítkem pouze tehdy, když mají speciální význam; v ostatních případech se zpětné lomítko před takovým znakem exportuje jako normální znak. Problém však je, že inteprety Markdownu se velmi značně liší v tom, které znaky a v jakých kontextech považují za speciální. Proto nelze dosáhnout zcela jednotných výsledků. Standardní Markdown však zaručuje možnost zpětným lomíkem odzvláštnit: \!, \#, \*, \+, \-, \., \\, \_, \` a všechny tři druhy závorek. Markdown Extra k tomu přidává znaky \: a \|.
* Identifikátory předdefinovaných odkazů a obrázků jsou prakticky obecné řetězce. Vhodný identifikátor je i např. „3.12;Dobrý den/Žlutoučký kůň\*“. Jejich maximální délka je ale omezena implementací.
* V Markdownu můžete přímo používat inline prvky HTML (např. &lt;br&gt; či &lt;strong&gt;). Při konverzi na jiný formát než HTML však tyto prvky pravděpodobně nebudou podporovány.
* Markdown (standardní) umožňuje vložit zalomení řádky pomocí dvou či více mezer na konci řádky. Osobně to nedoporučuji, protože některé textové editory (např. vim) bílé znaky na konci řádku nezobrazují a některé nástroje je mohou považovat za překlep a automaticky odstranit. Doporučuji místo toho používat HTML značku &lt;br&gt;, případně &lt;br&nbsp;/&gt;.
* Markdown neumožňuje vloženému obrázku definovat rozměry. Toto můžete učinit buď pomocí CSS, nebo místo syntaxe Markdownu přímo použít značku &lt;img&gt;.
* Po prvním spuštění ReTextu doporučuji otevřít Úpravy / Nastavení a zaškrtnout políčka „Vždy použít živý náhled“, „Zvýrazňovat aktuální řádek“ a „Zobrazovat čísla řádků“ a restartovat ReText. S těmito nastaveními mi připadne práce pohodlnější.

## Další zdroje informací

Doporučuji prohledat online zdroje nebo prostě experimentovat.
Velmi obsáhlým a formálně přesným zdrojem je „Specifikace GitHub Flavored Markdown“.

* [Stránka na Wikipedii](https://cs.wikipedia.org/wiki/Markdown)
* [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) (anglicky)
* [Oficiální stránky: Markdown Syntax](https://daringfireball.net/projects/markdown/syntax) (anglicky)
* [GitHub Help: Basic writing and formatting syntax](https://help.github.com/en/articles/basic-writing-and-formatting-syntax) (anglicky)
* [Markdown Extra Syntax](https://catalog.olemiss.edu/help/markdown/extra) (anglicky)
* [Video: Markdown Syntax Cheat Sheet](https://www.youtube.com/watch?v=bpdvNwvEeSE) (anglicky)
* [Video: Markdown Tutorial](https://www.youtube.com/watch?v=6A5EpqqDOdk) (anglicky)
* [Video: How to Write MarkDown](https://www.youtube.com/watch?v=eJojC3lSkwg) (anglicky)
* [Specifikace GitHub Flavored Markdown](https://github.github.com/gfm/) (anglicky)
* [Manuálová stránka o Markdownu](http://manpages.ubuntu.com/manpages/focal/en/man7/markdown.7.html) (anglicky)
* [Manuálová stránka příkazu markdown](http://manpages.ubuntu.com/manpages/focal/en/man1/markdown.1.html) (anglicky)
* [Balíček pandoc](https://packages.ubuntu.com/focal/pandoc) (anglicky)
* [Balíček retext](https://packages.ubuntu.com/focal/retext) (anglicky)
* [Balíček Remarkable v ALUR](https://aur.archlinux.org/packages/remarkable/) (anglicky)

!ÚzkýRežim: vyp
