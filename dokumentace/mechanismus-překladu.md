<!--

Linux Kniha kouzel, dokumentace: Mechanismus překladu
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
# Mechanismus překladu

**STAV TEXTU:** zastaralý (nutno aktualizovat fragmenty a osnovu)

## Vstup

Vstupem pro mechanismus překladu jsou zdrojové soubory kapitol a dodatků
v adresářích **kapitoly** a **dodatky** a jejich bezprostředních
poadresářích, které jsou jmenované v seznamech
[dodatky.seznam](seznamy/dodatky.seznam) a [kapitoly.seznam](seznamy/kapitoly.seznam).
Tyto zdrojové kódy jsou v upraveném Markdownu. Referenční přehled
všech podporovaných konstrukcí se nachází ve speciální kapitole
[Ukázka](../kapitoly/x-ukázka.md)
a uživatelsky přívětivý popis v souboru [syntaxe-kapitol.md](syntaxe-kapitol.md).

## Výstup

Mechanismus překladu dodržuje „čistotu stromu zdrojového kódu“ — zapisuje pouze
do dvou zvláštních adresářů, které si v případě potřeby vytvoří
a které lze vždy znovu vygenerovat:

* „soubory\_překladu“ — obsahuje dočasné, pomocné a pracovní soubory potřebné při překladu.
* „výstup\_překladu“ — obsahuje koncový výsledek překladu – Linux: Knihu kouzel v různých výstupních formátech.

## Formáty

* Formáty PDF se spadávkami (*pdf-a4*, *pdf-b5*, *pdf-b5-na-a4*) jsou určeny pro tisk v profesionálních tiskárnách, kde následně proběhne ořez podle ořezových značek a vazba.
* Formáty PDF bez spadávek (*pdf-a4-bez*, *pdf-b5-bez*) jsou určeny pro domácí tisk.
* Formát HTML s kaskádovými styly pro různé barevné motivy (*html*) je určen pro zobrazení na stolním počítači, případně laptopu. Jeho primární funkce je podpůrná – má umožnit pohodlně vykopírovat zaklínadla, a eliminovat tak vznik chyb při opisování. Rovněž do určité míry umožňuje textové vyhledávání.
* Formát „log“ je určen k ladění mechanismu překladu. Jeho výstupní soubory obsahují čitelnou textovou reprezentaci proudu volání funkcí při překladu, což umožňuje odhalit případné chyby.
* Formát „deb“ z kapitol shromáždí pouze pomocné funkce, skripty a výstřižky a sestaví balíček ve formátu „deb“ obsahující spouštěč „lkk“. (Podrobněji viz samostatná sekce.)
* Formát „pdf-výplach“ slouží k vygenerování „výplachu repozitáře“, který bude prohlížen na počítači.

## Obsah adresáře „soubory\_překladu“, společná část

### \*-Makefile

Soubory „Makefile“ pro překlad jednotlivých formátů; tyto soubory jsou generovány
skripty „[skripty/makegen](skripty/makegen)/\*.awk“.

### fragmenty.tsv

Soubor „fragmenty.tsv“ je tabulka ve formátu TSV, kterou generuje skript
[skripty/extrakce/fragmenty.pl](../skripty/extrakce/fragmenty.pl).
Uvádí informace o všech fragmentech (kapitolách, podkapitolách i dodatcích).
Každý záznam představuje jeden fragment.

Sloupce *fragmenty.tsv* jsou následující:

| # | Identifikátor | Popis | Příklad |
| ---: | --- | :--- | :--- |
| 1 | *není* | Číslo fragmentu. U fragmentů určených na výstup odpovídá jejich pořadovému číslu na výstupu (&gt; 0); fragmenty neurčené na výstup zde mají „0“. | 7 |
| 2 | plné-id | ID fragmentu včetně případné nadkapitoly | diskové-oddíly/softwarový-raid |
| 3 | ploché-id | Plné ID, kde je lomítko nahrazeno pomlčkou | diskové-oddíly-softwarový-raid |
| 4 | holé-id | ID fragmentu bez identifikace nadkapitoly | softwarový-raid |
| 5 | název-podkapitoly | Název bez nadkapitoly | Softwarový RAID |
| 6 | adresář | Adresář („dodatky“ nebo „kapitoly“). | kapitoly |
| 7 | příznaky | Příznaky fragmentu (viz níže). | zN |
| 8 | omezid | Omezené ID kapitoly. Používá se především ve formátu PDF. Začíná prefixem „kap“ a obsahuje pouze malá písmena anglické abecedy. | kapxstahovniwebovchstrnek |
| 9 | id-nadkapitoly | Je-li fragment podkapitolou, je zde uvedeno ID jeho nadkapitoly; jinak je toto pole prázdné (NULL). | diskové-oddíly |
| 10 | *není* | Název nadkapitoly (není-li, je pole prázdné, tedy NULL) | Diskové oddíly |
| 11 | štítky | Štítky kapitoly ve složených závorkách bez oddělovačů. | \{internet\}\{tematický okruh\} |
| 12 | ikkap | Ikona kapitoly (obrázek ve formátu „png“; cesta je relativní k adresáři „obrázky“). Pokud kapitola nemá vlastní ikonu, uvede se generická. | ik/diskové-oddíly.png |
| 13 | ploché-id-bez-diakr | Ploché ID po odstranění diakritiky. Používá se v názvech souborů HTML verze. | diskove-oddily-softwarovy-raid |

Id *celý-název* se ve skriptech rozvine na název s názvem nadkapitoly i podkapitoly (např. „Diskové oddíly / Softwarový RAID“).

Příznaky:

* **d** — Dodatek.
* **N** — Nadkapitola kapitoly určené na výstup (bez ohledu na to, zda je sama na výstup určena).
* **p** — Prémiová kapitola (jen tehdy, jsou-li prémiové kapitoly zapnuty).
* **v** — Vydaný fragment (bez ohledu na to, zda patří na výstup).
* **z** — Fragment určený na výstup (má v první sloupci kladné číslo).

### postprocess.dat a postprocessing

Soubor **postprocess.dat** v adresáři „soubory\_překladu“ vzniká kopií stejnojmenného souboru
v hlavním adresáři a obsahuje definice pro postprocessing zdrojového kódu pro formáty PDF.
Postprocessing slouží k doladění sazby pro jednotlivé formáty. Umožňuje např. vložit nucené
zalomení řádky jen ve formátu A4, které se neuplatní ve formátu B5.

Do souboru **postprocess.log** se zapisuje seznam proběhlých korekcí s počtem provedených náhrad,
což umožňuje odhalit zastaralé (již nefunkční) korekce nebo korekce,
které omylem zasáhly nechtěný řádek.

Záznamy v postprocess.dat jsou odděleny sekvencí prázdných řádek (obvykle jedna prázdná řádka); sloupce v záznamech jsou odděleny znakem konce řádku (\\n). Záznam, který začíná znakem „#“ je komentář a celý se ignoruje.

Sloupce *postprocess.dat* mají následující význam:

| # | Popis | Příklad |
| ---: | :--- | :--- |
| 1 | Číslo opravy (nezáporné celé číslo jednoznačně identifikující záznam). | 110 |
| 2 | Regulární výraz určující, na které formáty bude oprava uplatněna. Oprava může být uplatněna i na více formátu, pokud všechny jejich identifikátory odpovídají uvedenému regulárnímu výrazu. | pdf-a4.\* |
| 3 | ID dodatku či kapitoly, na kterou bude oprava uplatněna. Jedna oprava může být uplatněna pouze na jeden dodatek či kapitolu. | stahovani-web |
| 4 | Původní znění opravované řádky v souboru „soubory\_překladu/\{formát\}/\{id\}.kap“. | test \\textbf\{něčeho\} |
| 5 | Opravené znění opravované řádky. | test \\emph\{něčeho\} |

Mechanismus postprocessingu se spouští samostatně nad každou kapitolou, pro každý jednotlivý PDF formát.
Funguje tak, že vyhledá výskyt řádky podle čtvrtého sloupce záznamu a nahradí ho textem pátého sloupce téhož záznamu.

### štítky.tsv

Tabulka ve formátu TSV, generovaná spolu s *fragmenty.tsv*, která uvádí seznam
vyskytujících se štítků a ke každému seznam příslušných kapitol.

Sloupce *štítky.tsv* jsou následující:

| # | Popis | Příklad |
| ---: | :--- | :--- |
| 1 | Text štítku. | zpracování textu |
| 2 | Omezené ID štítku. Začíná písmenem „s“. | szprcovnitextu |
| 3 atd. | Celá ID kapitol a podkapitol, které mají daný štítek. |

U každého štítku musí být uvedena alespoň jedna kapitola či podkapitola
a všechny uvedené fragmenty musí být určeny na výstup (tzn. mít kladné
pořadové číslo).
Štítky, které by neměly žádnou příslušnou kapitolu na výstupu, se neuvádí.

### ucs\_ikony.dat

Textový soubor v kódování UTF-8, který vzniká skriptem [skripty/extrakce/ikony-zaklínadel.awk](../skripty/extrakce/ikony-zaklínadel.awk) ze souboru [ucs\_ikony/ikony.txt](../ucs\_ikony/ikony.txt) po přefiltrování podle [ucs\_ikony/povolene-ikony.tsv](../ucs\_ikony/povolene-ikony.tsv).
Je tvořen dvěma dlouhými řádky. První řádka obsahuje znaky UTF-8 používané jako ikony zaklínadel, druhá udává jednopísmennými zkratkami na odpovídající pozici, jaké písmo se má použít k jejich vypsání (D znamená „DejaVu Sans“, L znamená „Latin Modern Math“).

### osnova/\{ploché-id\}.tsv

Soubory v adresáři „osnova“, vznikající spolu s *fragmenty.tsv*,
obsahují záznamy odkazující na konkrétní místa jednotlivých kapitol.
V této verzi jsou to jen záznamy sekcí a podsekcí.
Tyto soubory se generují pro všechny překládané fragmenty; i ty,
které nejsou určeny na výstup.

Sloupce *osnova/\*.tsv* jsou následující:

| # | Popis | Příklad |
| ---: | :--- | :--- |
| 1 | Typ záznamu (KAPITOLA, SEKCE, PODSEKCE, nebo ZAKLINADLO). | PODSEKCE |
| 2 | Identifikátor záznamu (formát se liší podle typu záznamu). | 5x4 |
| 3 | Číslo řádky ve vstupním zdrojovém kódu (slouží výhradně k ladění). | 374 |
| 4 | Text (např. název kapitoly). | Ostatní |
| 5 | Text v UTF-16BE (viz poznámku) | \\uFEFF\\u004f\\u0073\\u0074\\u0061\\u0074\\u006E\\u00ED |
| 6 | Středník (vyhrazeno pro budoucí použití). | ; |

Formáty identifikátoru záznamu jsou následující:

| Typ záznamu | Popis formátu | Příklad |
| --- | :--- | --- |
| KAPITOLA | Prázdný řetězec. | |
| SEKCE | Pořadové číslo sekce v kapitole. | 3 |
| PODSEKCE | Číslo sekce, „x“ a pořadové číslo podsekce v sekci. | 3x2 |
| ZAKLINADLO | Není implementováno. | |

Sloupec 5 vzniká následovně: text je konvertován do kódování „UTF-16BE“;
znaky s kódem „\\uFEFF“ nebo vyšším se vynechají a před celek se vloží znak
s kódem „\\uFEFF“.
Pokud je výsledek delší než 32 znaků, zkrátí se na 29 znaků a doplní na konci „...“.
Výsledek se vypíše hexadecimálně ve tvaru „\\uXXXX“, tzn. předpona „\\u“,
čtyři hexadecimální číslice na každý znak, velká písmena.

### symboly/\*

Podadresář soubory\_překladu/symboly slouží k tomu, aby program „make“
provedl nový překlad v případě, že se změní jedno z podstatných nastavení
(datum sestavení, jméno sestavení nebo verze balíčku DEB).
Obvykle se ale tímto adresářem nemusíte zabývat.

## Obsah adresáře „soubory\_překladu/deb“ (balíček DEB)

### DEBIAN/control

Vygenerované údaje o balíčku pro balíčkovací systém „dpkg“.

### DEBIAN/md5sums

Vygenerované kontrolní součty MD5 pro soubory zařazené do balíčku.

### usr/bin/lkk

Spouštěč „lkk“, skript, který vzniká kopií [skripty/lkk/lkk](../skripty/lkk/lkk).

### usr/share/bash-completion/completions/lkk

Definice automatického doplňování pro příkaz „lkk“. Soubor vzniká kopií [skripty/lkk/bash-doplnovani.sh](../skripty/lkk/bash-doplnovani.sh).

### usr/share/doc/lkk/copyright

Licenční informace pro balíček. Soubor vzniká kopií [COPYRIGHT-DEB](../COPYRIGHT-DEB).

### usr/share/lkk/awkvolby.awk

Vnitřní pomocný skript pro analýzu voleb zadaných na příkazové řádce. Soubor vzniká kopií [skripty/lkk/awkvolby.awk](../skripty/lkk/awkvolby.awk) a používá se v lkk.awk.

### usr/share/lkk/lkk.awk

Vnitřní pomocný skript, který vykonává hlavní činnost spouštěče lkk. Soubor vzniká z [skripty/lkk/lkk.awk](../skripty/lkk/lkk.awk), kde se značka „\{\{JMÉNO VERZE\}\}“ nahradí za jméno sestavení.

### usr/share/lkk/skripty/\*

Pomocné skripty vyextrahované ze zdrojových kódů kapitol skriptem [skripty/extrakce/pomocné-funkce.awk](../skripty/extrakce/pomocné-funkce.awk). Zvláštním případem je skript „pomocné-funkce“, který jako jediný není přímo spustitelný, ale obsahuje definice pomocných funkcí.

## Obsah adresáře „soubory\_překladu/html“ (formát HTML)

### \* (soubory bez přípony)

Tyto mezisoubory vznikají překladem zdrojových kódů jednotlivých kapitol skriptem [skripty/překlad/do_html.awk](../skripty/překlad/do_html.awk) a později se z nich sestavují úplné HTML soubory pomocí skriptu [skripty/plnění-šablon/kapitola.awk](../skripty/plnění-šablon/kapitola.awk) a šablony [formáty/html/šablona.htm](../formáty/html/šablona.htm).

### kap-copys.htm

Obsahuje licenční hlavičky kapitol, ve formátu HTML. Generuje se skriptem [skripty/extrakce/copyrighty.awk](../skripty/extrakce/copyrighty.awk) ze zdrojových souborů kapitol a dodatků.

### obr-copys.htm

Obsahuje licenční informace k obrázkům, ve formátu HTML. Generuje se skriptem [skripty/extrakce/copykobr.awk](../skripty/extrakce/copykobr.awk) ze souboru [COPYRIGHT](../COPYRIGHT).

## Obsah adresáře „soubory\_překladu/log“ (formát LOG)

Tento adresář obsahuje pro každou kapitolu či dodatek dva soubory:

* Soubor bez přípony (např. „awk“) vzniká skriptem [skripty/překlad/do\_logu.awk](../skripty/překlad/do\_logu.awk) ze zdrojového kódu kapitoly či dodatku. Obsahuje čitelný záznam o volání jednotlivých funkcí při překladu, což umožňuje pohodlné ladění mechanismu překladu.
* Soubor s příponou „kap“ (např. „awk.kap“) vzniká ze souboru bez přípony, jeho obalením pomocí šablony [formáty/log/šablona](../formáty/log/šablona), které provede skript [skripty/plnění-šablon/kapitola.awk](../skripty/plnění-šablon/kapitola.awk).

## Obsah adresáře „soubory\_překladu/pdf-spolecne“ (formáty PDF)

### \*.kap

Obsahuje jednotlivé kapitoly a dodatky přeložené skriptem [skripty/překlad/do\_pdf.awk](../skripty/překlad/do\_pdf.awk) ze zdrojového kódu kapitoly či dodatku do mezistavu, který projde postprocessingem a bude spojen do kompletního zdrojového kódu knihy ve formátu LaTeX (pro každý formát papíru zvlášť).

### qr.eps

Obsahuje QR kód pro použití v knize. Generuje se v Makefile příkazem „qrencode“.

### \_obrázky/\*

Obsahuje soubory obrázků pro použití v knize, předzpracované podle konfigurace.
V této verzi předzpracování spočívá především v převodu do stupňů šedi a převodu
vektorových obrázků z SVG do PDF (XeLaTeX vložit SVG přímo neumí).

## Obsah adresáře „soubory\_překladu/pdf-\*“ (PDF, konkrétní formáty papíru)

### \*.kap

Obsahuje jednotlivé kapitoly a dodatky po průchodu postprocessingem.

### \_all.kap

Obsahuje soubory \*.kap pospojované za sebe v pořadí podle *fragmenty.tsv*.

### kniha.tex

Vznikne z \_all.kap pomocí skriptu [skripty/plnění-šablon/speciální.awk](../skripty/plnění-šablon/speciální.awk) a šablony [formáty/pdf/šablona.tex](../formáty/pdf/šablona.tex).

Dále tento adresář obsahuje pomocné soubory XeLaTeXu a výstup ve formátu PDF („kniha.pdf“).

### skripty

Symbolický odkaz na adresář „skripty“. Kvůli spouštění některých skriptů.

## Konfigurační soubory

### seznamy/\*.seznam

Tyto soubory uvádějí seznamy používané při překladu:

| seznam | Popis |
| --- | :--- |
| css-motivy.seznam | Jen pro formát HTML. Uvádí seznam generovaných CSS motivů kromě motivu „hlavni“. |
| dodatky.seznam | Seznam úplných ID všech dodatků. |
| kapitoly.seznam | Seznam úplných ID všech kapitol. |
| obrázky-ik.seznam | Seznam PNG ikon pro kapitoly v adresáři [obrázky/ik](obrázky/ik). |
| obrázky-jpeg.seznam | Seznam JPEG ikon (s příponou „.jpg“) v adresáří [obrázky](obrázky). |
| obrázky-png.seznam | Seznam PNG ikon v adresáří [obrázky](obrázky). |
| obrázky-svg.seznam | Seznam SVG ikon v adresáří [obrázky](obrázky). |
| vydané-fragmenty.seznam | Aktualizovaný seznam vydaných kapitol a dodatků. Všechny uvedené položky musí být uvedeny také v dodatky.seznam nebo kapitoly.seznam. |

### konfigurace/pořadí-kapitol.seznam a konfigurace/pořadí-kapitol.výchozí.seznam

Tyto soubory určují výběr a pořadí kapitol a dodatků na výstupu.

Poznámka: jako první by měla být v každém případě Předmluva („predmluva“);
není to sice vyžadováno, ale překlad bez splnění tohoto předpokladu jsem nikdy netestoval/a.

### konfigurace/konfig.ini

Soubor v klasickém formátu „ini“. Dělí se na tři sekce:

*\[Filtry\]*

* **../obrázky/***název* – Určuje filtry příkazu „convert“, které se použijí při předzpracování daného bitmapového obrázku pro vložení do PDF. Nelze aplikovat na vektorové obrázky.

*\[Obrázky\]*

* **../obrázky/***název* – Určuje šířku obrázku při vložení do formátu PDF. Šířka se uvádí v takovém formátu, aby ji bylo možno použít v LaTeXu v příkazu \\includegraphics; může obsahovat i délkové registry (např. \\textwidth).

*\[Adresy\]*

* **do-qr** – Text, který se má zakódovat do QR kódu.
