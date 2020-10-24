<!--

Linux Kniha kouzel, kapitola Kalkulace
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:
- Výpočet pí: s každým zdvojnásobením počtu desetinných míst se doba výpočtu zvýší šestinásobně.

Úkoly:


⊨
-->

# Kalkulace

!Štítky: {tematický okruh}{čísla}{matematika}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola se věnuje matematickým výpočtům s celými čísly, reálnými čísly, komplexními čísly,
prvočísly a maticemi a konverzím nezáporných celých čísel mezi číselnými soustavami.

Ačkoliv k matematickým výpočtům můžeme použít prakticky jakýkoliv programovací jazyk,
který v linuxu najdeme, tato kapitola se zaměřuje především na tři nástroje:

* Aritmetický kontext interpretu bash (který je vhodný pro celočíselné a bitové výpočty).
* Interpret „bc“, který je vhodný pro základní aritmetiku s racionálními čísly libovolné (zvolené) přesnosti a pro aritmetiku s mimořádně vysokými celými čísly.
* Okrajově na specializovaný program Octave, který lze použít např. k výpočtům s komplexními čísly a maticemi.

Tato kapitola se nezabývá aritmetikou s datem a časem, ta spadá do kapitoly „Datum, čas a kalendář“.

GNU Bash a interpret „bc“ jsou vyvíjeny v rámci projektu GNU.

## Definice

* **Aritmetický kontext bashe** je zvláštní kontext v bashi, kde lze provádět celočíselné(!) operace a přistupovat k proměnným pouhým uvedením jejich jména (tzn. bez znaku „$“).

<!--
* **Triviální operátory** jsou operátory plus („+“), minus („-“), krát („\*“) a děleno („/“).
-->

!ÚzkýRežim: vyp

## Zaklínadla: Konverze číselných soustav (bash)

Následující zaklínadla kromě hromadných konverzí platí jen pro celá čísla v rozsahu 0 až 9 223 372 036 854 775 807 včetně.

### Z desítkové soustavy

*# na hexadecimální s velkými/malými písmeny*<br>
**$(printf %**[**0**{*min-délka*}]**X** {*číslo*}**)**<br>
**$(printf %**[**0**{*min-délka*}]**x** {*číslo*}**)**

*# na binární (doplěné nulami/nejkratší)*<br>
**$(printf %**[{*min-délka*}]**s $(bc &lt;&lt;&lt;"obase=2;**{*číslo*}**") \| tr '&blank;' 0)**
**$(bc &lt;&lt;&lt;"obase=2;**{*číslo*}**")**

*# na osmičkovou*<br>
**$(printf %**[**0**{*min-délka*}]**o** {*číslo*}**)**

### Z hexadecimální soustavy

*# na desítkovou*<br>
**$((16#**{*číslo*}**))**

*# na binární (doplněné nulami/nejkratší)*<br>
**$(printf %**{*min-délka*}**s $(bc &lt;&lt;&lt;"obase=2;$((16#**{*číslo*}**))") \| tr '&blank;' 0)**<br>
**$(bc &lt;&lt;&lt;"obase=2;$((16#**{*číslo*}**))")**

*# na osmičkovou*<br>
**$(printf %**[**0**{*min-délka*}]**o 0x**{*číslo*}**)**

### Z binární soustavy

*# na desítkovou*<br>
**$((2#**{*číslo*}**))**

*# na hexadecimální s velkými/malými písmeny)*<br>
**$(printf %**[**0**{*min-délka*}]**X $((2#**{*číslo*}**)))**<br>
**$(printf %**[**0**{*min-délka*}]**x $((2#**{*číslo*}**)))**

*# na osmičkovou*<br>
**$(printf %**[**0**{*min-délka*}]**o $((2#**{*číslo*}**)))**

### Z osmičkové soustavy

*# na desítkovou*<br>
**$((8#**{*číslo*}**))**<br>

*# na hexadecimální (s velkými/malými písmeny)*<br>
**$(printf %**[**0**{*min-délka*}]**X $((8#**{*číslo*}**)))**<br>
**$(printf %**[**0**{*min-délka*}]**x $((8#**{*číslo*}**)))**

*# na binární (doplněné nulami/nejkratší)*<br>
**$(printf %**{*min-délka*}**s $(bc &lt;&lt;&lt;"obase=2;$((8#**{*číslo*}**))") \| tr '&blank;' 0)**<br>
**$(bc &lt;&lt;&lt;"obase=2;$((8#**{*číslo*}**))")**

### Hromadná konverze (po řádcích)

*# ze soustavy o základu X (2, 8, nebo 10) na soustavu o základu Y (2, 8, nebo 10)*<br>
{*zdroj*} **\| sed -E**[**u**]** '1s/^/obase=**{*Y*}**;ibase=**{*X*}**;/' \| bc \|** {*zpracování*}

*# ze soustavy o základu X (2, 8, nebo 10) na hexadecimální soustavu s malými/velkými písmeny*<br>
{*zdroj*} **\| sed -E**[**u**]** '1s/^/obase=16;ibase=**{*X*}**;/' \| bc \| tr ABCDEF abcdef \|** {*zpracování*}<br>
{*zdroj*} **\| sed -E**[**u**]** '1s/^/obase=16;ibase=**{*X*}**;/' \| bc \|** {*zpracování*}

*# z hexadecimální soustavy na soustavu o základu Y (2, 8, nebo 10)*<br>
{*zdroj*} **\| sed -E**[**u**]** 'y/abcdef/ABCDEF/;1s/^/obase=**{*Y*}**;ibase=16;/' \| bc \|** {*zpracování*}

<!--
Úkol: [ ] doplnění nulami na požadovanou délku
-->

## Zaklínadla: Aritmetický kontext v bashi

<!--
https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html
-->

V aritmetickém kontextu bashe jsou dostupné tyto celočíselné operátory:
!,
!=,
% (zbytek po celočíselném dělení),
&amp;,
&amp;&amp;,
\*,
\*\* (umocňování),
\+,
\+\+,
čárka „,“,
\-,
\-\-
/,
&lt;,
&lt;&lt;,
&lt;=,
= (a složená přiřazení jako např. „+=“),
==,
&gt;,
&gt;=,
&gt;&gt;,
ternární operátor „?:“,
^ (bitový xor),
\|,
\|\|,
~.

### Různé

*# zvýšit hodnotu proměnné o jedničku (vrátit novou/původní hodnotu)(**inkrement**)*<br>
**\+\+**{*název\_proměnné*}<br>
{*název\_proměnné*}**\+\+**

*# snížit hodnotu proměnné o jedničku (vrátit novou/původní hodnotu)(**dekrement**)*<br>
**\-\-**{*název\_proměnné*}<br>
{*název\_proměnné*}**\-\-**

*# **zvýšit** hodnotu proměnné o 16 (vrátit novou/původní hodnotu)*<br>
{*název\_proměnné*} **+= 16**<br>
**(**{*název\_proměnné*} **+= 16) - 16**

*# dvě na N-tou*<br>
**2 \*\*** {*N*}

*# pseudonáhodné číslo 0≤x&lt;N (pro N≤32768/pro N≤2 na 30-tou)*<br>
**RANDOM %** {*N*}<br>
**(RANDOM &lt;&lt; 15 \| RANDOM) %** {*N*}

*# absolutní hodnota proměnné*<br>
{*proměnná*} **&gt; 0 ?** {*proměnná*} **: -**{*proměnná*}

*# výběr výsledku podle hodnoty*<br>
{*proměnná*} **==** {*hodnota-1*} **?** {*výsledek-1*} **:** [{*proměnná*} **==** {*další-hodnota*} **?** {*další-výsledek*} **:**]... {*náhradní-výsledek*}

## Zaklínadla: bc

V „bc“ jsou dostupné tyto operátory:
!,
!=,
% (při scale = 0 zbytek po celočíselném dělení),
&amp;&amp;,
\*,
\+ (jen se dvěma operandy!),
\+\+,
\-,
\-\-
/,
&lt;,
&lt;=,
= (a složená přiřazení jako např. „+=“),
==,
&gt;,
&gt;=,
^ (umocňování),
\|\|.

### Nastavení

*# přesnost výpočtů*<br>
*// Hodnota „scale“ musí být v rozsahu 0 až 2 147 483 647 (tzn. 2 na 31 minus 1).*<br>
**scale =** {*počet-míst-za-desetinnou-tečkou*}

*# číselná soustava na vstupu/na výstupu (např. 2, 8, 10, 16)*<br>
*// Pozor! Nastavení proměnné „ibase“ ovlivňuje intepretaci VŠECH následujících čísel na vstupu, tedy např. i hodnoty nastavované do proměnné obase! Proto nastavením „ibase=16;obase=10“ nastavujete ibase i obase na hodnotu 16 (hodnota 10 je již interpretována jako hexadecimální)!*<br>
*// Parametry „ibase“ a „obase“ nikdy neměňte uvnitř uživatelských funkcí. Podle manuálové stránky bude taková změna účinkovat až po návratu z funkce.*<br>
**ibase =** {*základ*}<br>
**obase =** {*základ*}

### Výpisy

*# vypsat **hodnotu** výrazu (zakončí se \\n)*<br>
*// Poznámka: výraz se nevypíše, pokud hlavním operátorem výrazu bude přiřazení nebo složené přiřazení; v těchto případech pomůže výraz uzavřít do závorek – např. „a += 12“ nic nevypíše, ale „(a += 12)“ ano. Je-li výrazem volání funkce, vypíše se její návratové hodnota.*<br>
{*výraz*}

*# vypsat řetězec/uvozovku (bez zakončení \\n)*<br>
*// Řetězec v první řádce zaklínadla může obsahovat jakékoliv znaky kromě nulového bajtu „\\0“ a uvozovky „"“. Může obsahovat konce řádků, tabulátory, apostrofy i zpětná lomítka bez nutnosti odzvláštnění!*<br>
**"**{*řetězec*}**"**<br>
**print "\\q"**

*# vypsat víc řetězců a hodnot (bez zakončení \\n)(obecně/příklad)*<br>
*// Znak „\\“ se v řetězci musí zapsat jako „\\\\“ a znak „"“ jako „\\q“, ostatní znaky (včetně konce řádky) mohou být v řetězci použity doslovně. Konec řádky lze zapsat také jako „\\n“.*<br>
**print** {*"řetězec"-nebo-výraz*}[**,** {*další-"řetězec"-nebo-výraz*}]<br>
**print "x = ", x, "  ", "y = ", y, "součin = ", x \* y, "\\n"**

### Matematické funkce (nevyžadující parametr -l)

*# **mocnina** s nezáporným celočíselným exponentem*<br>
{*základ*} **^** {*exponent*}

*# druhá/čtvrtá **odmocnina***
**sqrt(**{*x*}**)**<br>
**sqrt(sqrt(**{*x*}**))**

*# **zaokrouhlit** na nejbližší celé číslo*<br>
^^**define zaokr(x) \{**<br>
^^**auto puvodni; puvodni = scale\+\+**<br>
^^**if (x &gt;= 0) {x += .5} else {x -= .5}**<br>
^^**scale = 0; x /= 1; scale = puvodni**<br>
^^**return x**<br>
^^**\}**<br>
**zaokr(**{*číslo*}**)**

*# **absolutní hodnota***<br>
^^**define abs(x) \{**<br>
^^**if (x &gt;= 0) {return x} else {return -x}**<br>
^^**\}**<br>
**abs(x)**

*# zaokrouhlit k nule*<br>
^^**scale = 0**<br>
{*výraz*} **/ 1**

### Matematické funkce (vyžadují parametr -l)

Poznámka: Následující zaklínadla v „bc“ spuštěném bez parametru „-l“
skončí s chybou „Function not defined“.

*# **mocnina**/odmocnina (obecná)*<br>
**e(l(**{*základ*}**) \*** {*exponent*}**)**<br>
**e(l(**{*základ*}**) /** {*exponent*}**)**

*# funkce **exp***<br>
**e(**{*x*}**)**

*# **logaritmus** (přirozený/o základu B/o základu 10)*<br>
**l(**{*x*}**)**<br>
**l(**{*x*}**) / l(**{*B*}**)**<br>
**l(**{*x*}**) / l(10)**<br>

*# hodnota **pí***<br>
*// Toto zaklínadlo vyžaduje spuštění „bc“ s parametrem „-l“ a je vhodné pro výpočet pí na malé množství desetinných míst (řádově do 1000).*<br>
**4 \* a(1)**

*# **arkustangens** (vrací radiány)*<br>
**a(**{*x*}**)**

*# **sinus**/**kosinus**/**tangens** (x v radiánech)*<br>
**s(**{*x*}**)**<br>
**c(**{*x*}**)**<br>
**s(**{*x*}**) / c(**{*x*}**)**

<!--
j() - Besselova funkce (netuším, k čemu by mohla být)
-->

### Proměnné

*# **přiřadit** do proměnné (výraz/číslo)*<br>
*// U jednoduchého výrazu můžete závorky kolem výrazu vynechat, ale dejte si pozor na prioritu operátorů!*<br>
{*nazev\_promenne*} **= (**{*výraz*}**)**<br>
{*nazev\_promenne*} **= **{*číslo*}

*# **přečíst** hodnotu proměnné*<br>
{*nazev\_promenne*}

### Podmínky a cykly

*# podmíněné vykonání (**if**)*<br>
**if (**{*podmínka*}**) \{**<br>
<odsadit1>[{*příkaz*}]...<br>
**\}** [**else**<br>
<odsadit1>[{*příkaz*}]...<br>
**\}**]

*# cyklus „**while**“*<br>
**while (**{*podmínka*}**) \{**<br>
<odsadit1>[{*příkaz*}]...<br>
**\}**

*# cyklus „**for**“*<br>
**for (**[{*inicializace*}]**;**[{*podmínka*}]**;**[{*posun*}]**) \{**<br>
<odsadit1>[{*příkaz*}]...<br>
**\}**

*# skočit před/za konec cyklu*<br>
**continue**<br>
**break**

### Uživatelské funkce

*# **definovat** funkci*<br>
*// Identifikátor funkce musí začínat malým písmenem anglické abecedy a pokračovat malými písmeny anglické abecedy nebo podtržítky. Velká písmena nejsou dovolena.*<br>
**define** {*identifikator\_funkce*} **(** [{*parametr*}[**,**{*další-parametr*}]...]**) \{**<br>
<odsadit1>[**auto** {*lokální\_proměnná*}[**,**{*další\_lok\_prom*}]...]<br>
<odsadit1>[{*příkaz*}]...<br>
**\}**

*# **zavolat** funkci (ve výrazu)*<br>
{*nazev\_funkce*}**(**{*parametry-jsou-li-vyžadovány*}**)**

*# **vrátit** z funkce hodnotu*<br>
*// Příkaz „return“ také ukončí provádění funkce (stejně jako stejnojmenný příkaz v jazyce C).*<br>
**return** {*hodnota*}

### Ostatní

*# **komentář** (jednořádkový/obecný)*<br>
[{*normální obsah řádky*}] **#**{*text komentáře*}<br>
**/\*** {*obsah komentáře, i více řádek*} **\*/**

*# ukončit skript*<br>
**halt**

## Zaklínadla: Prvočísla a pí

*# vypočítat pí na N desetinných míst*<br>
*// Tento příkaz je vhodný pouze k výpočtu pí na maximálně cca 32 000 desetinných míst (a i to může trvat podle výkonu počítače půl hodiny až hodinu). Nepoužívá nejefektivnější známé algoritmy a podle mého měření se s každým zdvojnásobením požadovaného počtu desetinných míst výpočetní čas zvýší přibližně na šestinásobek.*<br>
**bc -l &lt;&lt;&lt;'scale = 1 +** {*N*}**; 4 \* a(1)' \| tr -d \\\\\\\\\\\\n \| sed -E 's/.$/\\n/'**

*# prvočíselný rozklad (obecně/příklad)*<br>
**factor** [{*kladnéceléčíslo*}]...<br>
**factor 126** ⊨ 126: 2 3 3 7

*# vyhledat prvočísla (obecně/příklad)*<br>
*// Poznámka: příkaz „primes“ vypisuje každé prvočíslo na samostatnou řádku.*<br>
**primes** [{*minumum*}] {*maximum*}<br>
**primes 127 139**  ⊨ 127\\n131\\n137\\n139

## Zaklínadla: Octave

### Výstup

*# vypsat hodnotu výrazu*<br>
**disp(**{*výraz*}**)**

*# vypsat řetězec na samostatnou řádku*<br>
**disp(**{*"řetězec*}**)**

### Proměnné

*# přiřadit do proměnné*<br>
*// Výraz může být libovolného typu: reálné číslo, komplexní číslo, matice, ...*<br>
{*nazev\_promenne*} **=** {*výraz*}

*# přečíst proměnnou*<br>
{*nazev\_promenne*}

### Výpočty s komplexními čísly

*# příklady, jak zadat komplexní číslo*<br>
**0**<br>
**\-i**<br>
**(\-0.123 - 0.234i)**

*# příklad, jak komplexní číslo umocnit na komplexní exponent*<br>
**(\-0.123 - 0.234i) ^ (\-3.998 + 12.234i)** ⊨ -3.4832e+12 - 1.6512e+13i

*# získat absolutní hodnotu/argument (v radiánech) kompletního čísla*<br>
*// Argument je v rozsahu -pí až +pí.*<br>
**abs(**{*výraz*}**)**<br>
**arg(**{*výraz*}**)**

*# komplexně sdružené číslo*<br>
**conj(**{*výraz*}**)**

### Výpočty s maticemi

*# matice (obecně/příklad)*<br>
**[** {*hodnoty první řádky*} [**;** {*hodnoty další řádky*}]... **]**<br>
**[ 1 2 3 ; 4 5 6 ; 7i (8.1 - 2.3i) (-0.123 - 0.234i) ]**

*# maticové násobení*<br>
{*levá-matice*} **\*** {*pravá-matice*}

### Ostatní

*# ukončit interpret*<br>
**quit**

## Parametry příkazů

### Aritmetický kontext bashe

Aritmetický (celočíselný) kontext se v bashi vyskytuje ve třech situacích:

1\. Uvnitř konstrukce $((...)), např.: printf %s\\\\n "$((a + 12))". Vypočtená hodnota se dosadí za konstrukci $((...)).

2\. V parametrech příkazu „let“, ty jsou neprve vyhodnoceny jako řetězec a tento řetězec se pak interpretuje v aritmetickém kontextu. Vypočtená hodnota se zahodí, ale pokud je vypočtená hodnota posledního parametru 0, příkaz „let“ vrátí návratový kód 1 (selhání), čehož lze využít v příkazu „if“.

3.\ Při přiřazení do celočíselných proměnných; zde platí totéž, co u příkazu let, až na návratovou hodnotu. Pozor, za celočíselnou proměnnou se považuje pouze proměnná s atributem „-i“. Takže např. výraz „a=b++“ inkrementuje proměnnou *b*, pokud je proměnná *a* celočíselná (jinak by se do proměnné *a* přiřadil řetězec „b++“ a proměnná *b* by se nezměnila).

### bc

*# bc (alternativy)*<br>
{*zdroj*} **\| bc** [**-l**] <nic>[{*bc-skript*}]...
**bc** [**-l**] <nic>[{*bc-skript*}]...

### octave

*# octave (alternativy)*<br>
**octave -W \-\-eval '**{*příkazy*}**'**<br>
**octave -W** {*skript*}<br>
**octave**<br>
{*zdroj příkazů*} **\|** {*octave*} **-W**


## Instalace na Ubuntu

Většina použitých příkazů je součástí minimální instalace Ubuntu. Doinstalovat je potřeba:

*# primes*<br>
**sudo apt-get install libmath-prime-util-perl**

*# octave*<br>
**sudo apt-get install octave**

Poznámka: GNU Octave je poměrně velký balíček se spoustou závislostí; doporučuji ho instalovat,
jen pokud ho opravdu potřebujete.

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

### bc

* Před výpočty s reálnými čísly vždy nastavte parametr „scale“ na rozumnou hodnotu (např. 20), samotný příkaz „bc &lt;&lt;&lt;"sqrt(2)"“ vypíše „1“, protože výchozí nastavení je „scale = 0“ (parametr „-l“ nastaví „scale“ na hodnotu 20 již před spuštěním skriptu).
* Čísla, která začínají „0.“ nebo „-0.“ vypíše bc bez nuly (např. „-.123“), to je nepříjemný kosmetický nedostatek, který musíte napravit dodatečným filtrováním výstupu.
* Na rozdíl od „bc“, jehož výstup je vhodný pro strojové zpracování, výstup Octave není ke strojovému zpracování určen, takže při použití ve skriptech doporučuji opatrnost.

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

### Pí

* [10 tisíc desetinných míst](http://www.subidiom.com/pi/pi_10k.txt)
* [10 milionů desetinných míst](https://introcs.cs.princeton.edu/java/data/pi-10million.txt)
* [výřezy z 2 miliard desetinných míst](http://www.subidiom.com/pi/) (umí zobrazit až 250 číslic ze zadané pozice)

!ÚzkýRežim: vyp
