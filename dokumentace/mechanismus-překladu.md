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

**STAV TEXTU:** aktuální

## Vstup

Vstupem pro mechanismus překladu jsou zdrojové soubory kapitol (v adresáři
*kapitoly*) a dodatků (v adresáři *dodatky*). Tyto zdrojové kódy jsou
v upraveném Markdownu. Referenční přehled všech podporovaných
konstrukcí se nachází ve speciální kapitole [Ukázka](../kapitoly/_ukázka.md)
a uživatelsky přívětivý popis v souboru [syntaxe-kapitol.md](syntaxe-kapitol.md).

## Výstup

Mechanismus překladu dodržuje „čistotu stromu zdrojového kódu“ – zapisuje pouze
do dvou zvláštních adresářů, které si v případě potřeby vytvoří
a které lze vždy znovu vygenerovat:

* „soubory\_překladu“ – obsahuje dočasné, pomocné a pracovní soubory potřebné při překladu.
* „výstup\_překladu“ – obsahuje koncový výsledek překladu – Linux: Knihu kouzel v různých výstupních formátech.

## Formáty

* Formáty PDF se spadávkami (*pdf-a4*, *pdf-b5*, *pdf-b5-na-a4*) jsou určeny pro tisk v profesionálních tiskárnách, kde následně proběhne ořez podle ořezovných značek a vazba.
* Formáty PDF bez spadávek (*pdf-a4-bez*, *pdf-b5-bez*) jsou určeny pro domácí tisk.
* Formát HTML s kaskádovými styly pro různé barevné motivy (*html*) je určen pro zobrazení na stolním počítači, případně laptopu. Jeho primární funkce je podpůrná – má umožnit pohodlně vykopírovat zaklínadla, a eliminovat tak vznik chyb při opisování. Rovněž do určité míry umožňuje textové vyhledávání.
* Formát „log“ je určen k ladění mechanismu překladu. Jeho výstupní soubory obsahují čitelnou textovou reprezentaci proudu volání funkcí při překladu, což umožňuje odhalit případné chyby.
* Formát „deb“ z kapitol shromáždí pouze pomocné funkce, skripty a výstřižky a sestaví balíček ve formátu „deb“ obsahující spouštěč „lkk“. (Podrobněji viz samostatná sekce.)

## Obsah adresáře „soubory\_překladu“, společná část

### kapitoly.tsv

Soubor „kapitoly.tsv“ obsahuje základní údaje o všech dodacích a kapitolách v pořadí seřazeném podle ID.

Sloupce *kapitoly.tsv* jsou následující:

| # | Identifikátor | Popis | Příklad |
| ---: | --- | :--- | :--- |
| 1 | nadid | Jde-li o podkapitolu, ID její nadkapitoly; jinak prázdné pole. | diskové-oddíly |
| 2 | id | ID dodatku či kapitoly (název souboru bez přípony). | diskové-oddíly/lvm |
| 3 | nadnazev | Jde-li o podkapitolu, název nadkapitoly; jinak prázdné pole. | Diskové oddíly |
| 4 | nazev | Název dodatku či kapitoly. U podkapitoly jen název podkapitoly. | LVM |
| 5 | adr | Adresář („dodatky“ nebo „kapitoly“). | kapitoly |
| 6 | omezid | Takzvané omezené ID. Používá se především ve formátu PDF. Začíná prefixem „kap“ a obsahuje pouze malá písmena anglické abecedy. | kapxdiskovoddllvm |
| 7 | ikkap | Ikona kapitoly (obrázek ve formátu „png“; cesta je relativní k adresáři „obrázky“). Pokud kapitola nemá vlastní ikonu, uvede se generická. | ik/diskové-oddíly.png |
| 8 | stitky | Štítky kapitoly či podkapitoly ve složených závorkách bez oddělovačů; nejsou-li, hodnota „NULL“. | \{internet\}\{tematický okruh\} |
| 9 | radek | Počet řádek zdrojového kódu |

### fragmenty.tsv

Soubor „fragmenty.tsv“ je tabulka ve formátu TSV, kterou generuje skript
[skripty/extrakce/fragmenty.awk](../skripty/extrakce/fragmenty.awk).
Uvádí dodatky a kapitoly určené k zařazení na výstup (vychází se
z „pořadí-kapitol.lst“). Každý záznam představuje jednu kapitolu či dodatek.
Ostatní kapitoly a dodatky (podle Makefile) se překládají
(především kvůli kontrole syntaxe), ale na výstup se nedostanou.
Tento soubor udává pořadí kapitol a dodatků na výstupu.

Sloupce *fragmenty.tsv* jsou následující:

| # | Identifikátor | Popis | Příklad |
| ---: | --- | :--- | :--- |
| 1 | *není* | Pořadové číslo (od 1). Vždy odpovídá číslu záznamu. | 7 |
| 2 | id | ID dodatku či kapitoly (název souboru bez přípony). | stahovani-web |
| 3 | nazev | Název dodatku či kapitoly (extrahuje se ze zdrojového souboru). | Stahování webových stránek |
| 4 | adr | Adresář („dodatky“ nebo „kapitoly“). | kapitoly |
| 5 | omezid | Takzvané omezené ID kapitoly. Používá se především ve formátu PDF. Začíná prefixem „kap“ a obsahuje pouze malá písmena anglické abecedy. | kapxstahovniwebovchstrnek |
| 6 | ikkap | Ikona kapitoly (obrázek ve formátu „png“; cesta je relativní k adresáři „obrázky“). Pokud kapitola nemá vlastní ikonu, uvede se generická. | ik/ik-kap.png |
| 7 | stitky | Štítky kapitoly ve složených závorkách bez oddělovačů; nejsou-li, hodnota „NULL“. | \{internet\}\{tematický okruh\} |

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

Tabulka ve formátu TSV, která uvádí seznam vyskytujících se štítků a ke každému seznam příslušných kapitol.
Vzniká jako vedlejší produkt skriptu [skripty/extrakce/fragmenty.awk](../skripty/extrakce/fragmenty.awk).

Sloupce *štítky.tsv* jsou následující:

| # | Popis | Příklad |
| ---: | :--- | :--- |
| 1 | Text štítku. | zpracování textu |
| 2 | Omezené ID štítku. Začíná písmenem „s“. | szprcovnitextu |
| 3 atd. | ID kapitol, které mají daný štítek. |

U každého štítku musí být uvedena alespoň jedna kapitola a každá uvedená kapitola
musí být určena na výstup (tzn. musí mít záznam ve *fragmenty.tsv*).
Štítky, které by neměly žádnou příslušnou kapitolu na výstupu, se neuvádí.

### ucs\_ikony.dat

Textový soubor v kódování UTF-8, který vzniká skriptem [skripty/extrakce/ikony-zaklínadel.awk](../skripty/extrakce/ikony-zaklínadel.awk) ze souboru [ucs\_ikony/ikony.txt](../ucs\_ikony/ikony.txt) po přefiltrování podle [ucs\_ikony/povolene-ikony.tsv](../ucs\_ikony/povolene-ikony.tsv).
Je tvořen dvěma dlouhými řádky. První řádka obsahuje znaky UTF-8 používané jako ikony zaklínadel, druhá udává jednopísmennými zkratkami na odpovídající pozici, jaké písmo se má použít k jejich vypsání (D znamená „DejaVu Sans“, L znamená „Latin Modern Math“).

### osnova/\{id\}.tsv

Soubory v adresáři „osnova“ obsahují záznamy odkazující na konkrétní místa jednotlivých kapitol.
V této verzi jsou to jen záznamy sekcí a podsekcí. Vstupem jsou pro ně zdrojové kódy kapitol
a dodatků a generuje je skript [skripty/extrakce/osnova.awk](../skripty/extrakce/osnova.awk).

Pro kapitoly, které nejsou určeny na výstup, se tyto soubory vygenerují prázdné.
Jinak obsahují údaje o sekcích a podsekcích v dané kapitole:

Sloupce *osnova/\*.tsv* jsou následující:

| # | Popis | Příklad |
| ---: | :--- | :--- |
| 1 | Typ záznamu (KAPITOLA, SEKCE, PODSEKCE, nebo ZAKLINADLO). | PODSEKCE |
| 2 | Identifikátor záznamu, jehož formát se liší podle typu záznamu. | 5x4 |
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

Sloupec 5 vzniká následovně: před text (ze sloupce 4) se vloží znak „\\uFEFF“ a celek se konvertuje
do kódování „UTF-16BE“.
Pokud je výsledek delší než 32 znaků, zkrátí se na 29 znaků a doplní „...“.
Výsledek se vypíše hexadecimálně ve tvaru „\\u006F“, tzn. předpona „\\u“, čtyři číslice na každý znak,
velká písmena. Text v současnosti nesmí obsahovat znaky s kódem vyšším než „\\uFFFF“;
do budoucna počítám s vynecháním nebo výměnou takových znaků.

### symboly/\*

Podadresář soubory\_překladu/symboly slouží k tomu, aby program „make“
provedl nový překlad v případě, že se změní jedno z podstatných nastavení
(datum sestavení nebo jeho jméno). Podrobnosti najdete v souboru Makefile;
obvykle se ale tímto adresářem nemusíte zabývat.

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

### pořadí-kapitol.lst a pořadí-kapitol.výchozí.lst

Úplný seznam překládaných kapitol a dodatků je uveden v proměnných
*VSECHNY\_KAPITOLY* a *VSECHNY\_DODATKY* v [Makefile](../Makefile).
Mechanismus překladu však potřebuje vědět, které z nich a v jakém pořadí
patří na výstup. To se určí jedním ze tří způsobů:

* Pokud v hlavním adresáři existuje soubor „poradi-kapitol.lst“, vezmou se z něj neprázdné řádky nezačínající znakem „#“ a každý se interpretuje jako ID dodatku či kapitoly. (Tento soubor je uvedený v .gitignore, takže se nedostane do repozitáře.)
* Jinak, pokud v hlavním adresáři existuje soubor „poradi-kapitol.vychozi.lst“, zpracuje se stejným způsobem. (Tento soubor se na rozdíl od předchozího do repozitáře ukládá.)
* Jinak se vezmou všechny dodatky a kapitoly podle Makefile.

Poznámka: jako první by měla být v každém případě Předmluva („predmluva“);
není to sice vyžadováno, ale překlad bez splnění tohoto předpokladu jsem nikdy netestoval/a.

### konfig.ini

Soubor v klasickém formátu „ini“. Dělí se na tři sekce:

*\[Filtry\]*

* **../obrázky/***název* – Určuje filtry příkazu „convert“, které se použijí při předzpracování daného bitmapového obrázku pro vložení do PDF. Nelze aplikovat na vektorové obrázky.

*\[Obrázky\]*

* **../obrázky/***název* – Určuje šířku obrázku při vložení do formátu PDF. Šířka se uvádí v takovém formátu, aby ji bylo možno použít v LaTeXu v příkazu \\includegraphics; může obsahovat i délkové registry (např. \\textwidth).

*\[Adresy\]*

* **do-qr** – Text, který se má zakódovat do QR kódu.
