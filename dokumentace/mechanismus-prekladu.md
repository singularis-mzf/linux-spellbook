<!--

Linux Kniha kouzel, dokumentace
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
# Dokumentace mechanismu překladu

**(Dokumentace je rozepsaná; počkejte prosím na finální verzi...)**

## Vstup

Vstupem pro mechanismus překladu jsou zdrojové soubory kapitol (v adresáři
*kapitoly*) a dodatků (v adresáři *dodatky*). Tyto zdrojové kódy jsou
v upraveném Markdownu. Kompletní a aktuální přehled všech podporovaných
konstrukcí se nachází ve speciální kapitole [Ukázka](../kapitoly/_ukazka.md).

## Výstup

Mechanismus překladu dodržuje „čistotu stromu zdrojového kódu“ − zapisuje pouze
do dvou zvláštních adresářů, které si v případě potřeba vytvoří:

* „soubory\_prekladu“ − obsahuje dočasné, pomocné a pracovní soubory potřebné při překladu.
* „vystup\_prekladu“ − obsahuje koncový výsledek překladu − Linux: Knihu kouzel v různých výstupních formátech.

Oba uvedené adresáře je možné kdykoliv bezpečně smazat a vygenerovat ze zbytku stromu.

## Formáty

* Formáty PDF se spadávkami (*pdf-a4*, *pdf-b5*, *pdf-b5-na-a4*) jsou určeny pro tisk v profesionálních tiskárnách, kde následně proběhne ořez podle ořezovných značek a vazba.
* Formáty PDF bez spadávek (*pdf-a4-bez*, *pdf-b5-bez*) jsou určeny pro domácí tisk.
* Formát HTML s kaskádovými styly pro různé barevné motivy (*html*) je určen pro zobrazení na stolním počítači, případně laptopu. Jeho primární funkce je podpůrná − má umožnit pohodlně vykopírovat zaklínadla, a eliminovat tak vznik chyb při opisování.
* Formát „log“ je určen k ladění mechanismu překladu. Jeho výstupní soubory obsahují čitelnou textovou reprezentaci proudu volání funkcí při překladu, což umožňuje odhalit případné chyby.
* Formát „deb“ z kapitol shromáždí pouze pomocné funkce, skripty a výstřižky a sestaví balíček ve formátu „deb“ obsahující spouštěč „lkk“. (Podrobněji viz samostatná sekce.)

## Obsah adresáře „soubory\_prekladu“, společná část

### fragmenty.tsv

Soubor „fragmenty.tsv“ je tabulka ve formátu TSV, kterou generuje skript
[skripty/extrakce/fragmenty.awk](../skripty/extrakce/fragmenty.awk).
Každý záznam představuje kapitolu či dodatek k vygenerování a zařazení na výstup
(viz „poradi-kapitol.lst“). Tímto souborem je určeno pořadí kapitol a dodatků na výstupu.

Sloupce jsou následující:

* \[1\] Adresář („dodatky“ nebo „kapitoly“).
* \[2\] ID dodatku či kapitoly (název souboru bez přípony).
* \[3\] Název dodatku či kapitoly (podle zdrojového souboru).
* \[4\] Předchozí ID, nebo „NULL“.
* \[5\] Předchozí název, nebo „NULL“.
* \[6\] Následující ID, nebo „NULL“.
* \[7\] Následující název, nebo „NULL“.
* \[8\] Pořadové číslo.
* \[9\] Štítky uzavřené v závorkách {}, nebo „NULL“. Např. „{barvy}{čas}“. Extrahují se ze zdrjového souboru a zde jsou již abecedně seřazené.
* \[10\] Zjednodušené ID sestávající jen z písmen anglické abecedy.
* \[11\] Odkaz na ikonu kapitoly (soubor s obrázkem).

Kapitoly a dodatky, které na výstup nebudou zapsány, se do tabulky „fragmenty.tsv“ neuvádí.

### postprocess.dat

Soubor „postprocess.dat“ v adresáři „soubory\_prekladu“ vzniká kopií stejnojmenného souboru
v hlavním adresáři a obsahuje definice pro postprocessing zdrojového kódu pro formáty PDF.

Jako záznam o samotném postprocessingu zde vzniká také soubor „postprocess.log“.

### stitky.tsv

Tabulka ve formátu TSV, vzniká jako vedlejší produkt skriptu
[skripty/extrakce/fragmenty.awk](../skripty/extrakce/fragmenty.awk).
Jde o abecedně řazený seznam štítků a jim odpovídajících kapitol.

Sloupce jsou následující:

* \[1\] Text štítku.









<!--

Jsou podporovány tři hlavní skupiny výstupních formátů:

* Formáty PDF (pdf-a4, pdf-b5, pdf-a5) jsou určeny pro tisk.
Skript [do\_pdf.awk](../skripty/do_pdf.awk) převede zdrojový kód kapitoly
či dodatku do formátu LaTeXu. Skript [kapitola.awk](../skripty/kapitola.awk)
ho má „obalit“ do šablony, ale v současnosti tato operace nic nedělá.
Skript [postprocess.awk](../skripty/postprocess.awk) na přeloženou kapitolu
aplikuje předtiskové korekce, jsou-li definovány.
Skript [kniha.awk](../skripty/kniha.awk) pak kapitoly složí do jednoho
zdrojového souboru ve formátu LaTeX, jehož celková podoba je definovaná
v souboru [formaty/pdf/sablona.tex](../formaty/pdf/sablona.tex).
Nakonec se zavolá pdflatex a přeloží tento zdrojový kód do PDF.
Souběžně s tím jsou zpracovány obrázky pomocí nástroje ImageMagick.
* Formát HTML (html) je určený pro zobrazení na počítači a jeho hlavním účelem
je, abyste mohl/a snadno vykopírovat úseky kódu a přímo je použít bez rizika
překlepů. Skript [do\_html.awk](../skripty/do_html.awk) převede zdrojový kód
kapitoly či dodatku do formátu HTML, skript [kapitola.awk](../skripty/kapitola.awk)
pak zpracuje pouze kapitoly, které mají být vygenerovány, a vytvoří z nich
finální HTML soubory. Současně s tím se překopíruje
[sablona.css](../formaty/html/sablona.css) a požadované obrázky.
Součástí tohoto procesu je i shromáždění licenčních informací k obrázkům
ze souboru [COPYING](../COPYING) a ke kapitolám z jejich zdrojových kódů
a jejich sepsání pomocí skriptu [kapitola.awk](../skripty/kapitola.awk).
Pomocí skriptu [generovat-index-html.awk](../skripty/generovat-index-html.awk)
se pak vygeneruje hlavní HTML stránka s přehledem kapitol.
* Formát LOG (log) je určen především pro ladění lexikálně syntaktického
analyzátoru, který se nachází ve skriptu [hlavni.awk](skripty/hlavni.awk).
Tento analyzátor je společný pro všechny formáty a ve výstupu ve formátu
LOG můžete dohledat, které funkce byly volány pro zpracování jednotlivých
částí každé kapitoly. Druhou podstatnou úlohou překladu do tohoto formátu
je poměrně striktní kontrola některých požadavků a předpokladů,
která se u ostatních formátů nevyskytuje.

U každého formátu je prvním krokem překlad zdrojového textu po jednotlivých kapitolách
do základní podoby kapitol v daném formátu. Tento krok dělá skript
„skripty/do\_{*formát*}u.awk“ a u formátu LOG je to jediný krok.
Společným jádrem skriptů pro všechny formáty je lexikálně syntaktický analyzátor
ve skriptu „skripty/hlavni.awk“. Skripty pro jednotlivé formáty definují pouze
konkrétní funkce, které pak analyzátor volá. Velmi podstatná je funkce
*ZpracujZnak()*, která se volá pro každý nebílý znak textu po
odstranění escapování a všech řídicích konstrukcí. Např. nezlomitelnou mezeru
přeloží ve formátu PDF na „\~“ a ve formátu HTML na „&amp;nbsp;“.

U formátu HTML probíhá současně s tím zpracování obrázků a zkopírování stylového předpisu.

Překlad do formátů PDF je nejsložitější. Výsledkem prvního kroku jsou části
kódu ve formátu LaTeX, které se pak skriptem „skripty/kniha.awk“ spojí do jednoho
velkého zdrojového kódu a ten se příkazem „pdflatex“ přeloží do formátu PDF.

Při překladu se používají dva adresáře: Adresář „soubory\_prekladu“ slouží pro
pomocné a nehotové soubory vznikající během překladu; adresář „vystup\_prekladu“
pak obsahuje pouze požadované výstupní soubory.

## Interní soubory

### soubory\_prekladu/osnova/\*.tsv

Do těchto souborů se sepisují záznamy o sekcích a podsekcích v jednotlivých
kapitolách. Slouží především ke generování křížových odkazů ve formátu HTML.

Význam sloupců je následující:

1. Typ záznamu (KAPITOLA, SEKCE či PODSEKCE; v budoucnu přibudou další).
2. ID (např. číslo kapitoly)
3. číslo řádku, ze kterého záznam pochází
4. text (např. název kapitoly)
5. středník (jen pro ukončení a kontrolu korektního zpracování)

### soubory\_prekladu/fragmenty.tsv

Do tohoto souboru se zapisuje seznam kapitol a dodatků v pořadí, v jakém mají
být zapsány na výstup.

Význam sloupců je následující:

1. Typ („kapitoly“ nebo „dodatky“).
2. ID kapitoly či dodatku.
3. Název kapitoly či dodatku.
4. ID předchozí kapitoly či dodatku (nebo „NULL“).
5. Název předchozí kapitoly či dodatku (nebo „NULL“).
6. ID následující kapitoly či dodatku (nebo „NULL“).
7. Název následující kapitoly či dodatku (nebo „NULL“).
8. Číslo kapitoly či dodatku (odpovídá číslu řádku).
9. Seřazený výčet štítků ve formátu „{a}{b}...“, nebo „NULL“, pokud kapitola štítky nemá.

### soubory\_prekladu/postprocess.tsv

Předtiskové korekce, které mají být aplikovány. Korekce se aplikují formou
úplné náhrady původního řádku za nový a jsou specifické pouze pro jeden
výstupní formát (tzn. korekce pro výstup na papír formátu A5 se neuplatní
při výstupu na papír formátu A4).

Význam sloupců je následující.

1. ID náhrady (jedinečné číslo)
2. ID formátu (např. „pdf-b5“; musí přesně odpovídat)
3. ID kapitoly (např. „make“)
4. původní řádek
5. nový řádek

### soubory\_prekladu/postprocess.log

Do tohoto souboru se zapisuje seznam proběhlých korekcí s počtem provedených
náhrad. Má umožnit odhalit zastaralé korekce či korekce, které omylem zasáhly
nechtěný řádek.

## Konfigurace

To, které kapitoly a v jakém pořadí budou vygenerovány, se zaznamená do souboru
„soubory\_prekladu/poradi-kapitol.lst“; tento soubor se získá následovně:

1. Existuje-li soubor poradi-kapitol.lst, zkopíruje se ten.
2. Existuje-li soubor poradi-kapitol.vychozi.lst, zkopíruje se ten.
3. Jinak se seřadí podle abecedy všechny kapitoly a za ně všechny dodatky podle Makefile, s výjimkou předmluvy, která se umístí jako první, a použije se výsledek.

Druhým místem ke konfiguraci je soubor „konfig.ini“, který v současnosti
obsahuje pouze sekci [Obrázky], která určuje šířku vložených obrázků
ve formátu PDF. (Zadává se ve formátu, v jakém ji přijme zdrojový kód LaTeXu.)

### Předtiskové korekce

Zmínit je potřeba také předtiskové korekce. Ty se zapisují do souboru
„postprocess.tsv“, kde jsou následující sloupce:


Při překladu se pak u dané kapitoly v daném formátu vyhledají řádky,
které se *přesně* shodují s uvedeným „původním řádkem“ a ty se nahradí
uvedeným „novým řádkem“.

Pozor! Mechanismus překladu přijme soubor „postprocess.tsv“ jen poprvé;
pokud ho změníte, musíte smazat soubor „soubory\_prekladu/postprocess.tsv“,
aby se uplatnily nové korekce.

## Jak přidat novou kapitolu

Toto je poměrně snadný úkol.

1. Vytvořte ze šablony [\_sablona.md](../kapitoly/_sablona.md) nový zdrojový soubor v adresáři „kapitoly“. Jeho název bez přípony „.md“ bude sloužit jako ID kapitoly.
2. Doplňte do souboru název kapitoly (na 2 místa) a vlastní copyright do hlavičky (původní ponechejte).
3. ID nové kapitoly doplňte v Makefilu do proměnné „VSECHNY\_KAPITOLY“.
4. ID nové kapitoly doplňte jako nový řádek do souboru „poradi-kapitol.lst“, aby se kapitola generovala na výstup.
5. Zkuste vše přeložit příkazem „make“ a zkontrolujte, že se nová kapitola přeložila.

Pak už můžete novou kapitolu začít plnit obsahem.

## Jak přidat podporu nového znaku

1. Zjistěte, jak daný znak vysázet v LaTeXu.
2. Ve skriptu [do\_latexu.awk](../skripty/do_latexu.awk) ve funkci ZpracujZnak() přidejte novou větev přepínače pro obsluhu vámi zvoleného znaku.
3. Pokud daný znak vyžaduje zvláštní zacházení ve formátu HTML, učiňte totéž i ve skriptu [do\_html.awk](../skripty/do_html.awk), většinu znaků však bude možno do HTML zkopírovat přímo.
4. Do speciální kapitoly [\_ukazka](../kapitoly/_ukazka.md) doplňte nový znak do seznamu podporovaných znaků.
5. Pokud kapitola „\_ukazka“ není uvedena v souboru „poradi-kapitol.lst“, doplňte ji tam.
6. Zkuste přeložit všechny výstupní formáty příkazem „make“ a zkontrolujte překlad kapitoly „Ukázka“, zda v každém výstupním formátu, kromě formátu LOG, obsahuje korektně vysázený nový znak.

Pokud má být nový znak zadávaný HTML entitou nebo jiným nestandardním způsobem,
budete muset navíc navštívit skript [hlavni.awk](../skripty/hlavni.awk)
a doplnit interpretaci nové entity do funkce FormatovatRadek(), případně
i do funkce ZpracujZnaky(), pokud má být entita interpretována v kontextech
nepodporujících formátování jako např. URL adresy.
-->
