<!--

Linux Kniha kouzel, dokumentace
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
# Dokumentace mechanismu překladu

Zdrojový kód kapitol a dodatků knihy *Linux: Kniha kouzel* je v omezeném
(a na druhou stranu mírně rozšířeném) Markdownu. Kompletní a aktuální přehled
*všech* podporovaných konstrukcí najdete ve speciální kapitole
[Ukázka](../kapitoly/_ukazka.md). Zvlášť je třeba upozornit, že není
podporovaná kompletní sada znaků Unicode, ale jen podmnožina daná striktním
výčtem (která však bude podle potřeby rozšiřována).

Tento dokument si klade za cíl stručně popsat mechanismy, na nichž je
založen překlad těchto zdrojových kódů do všech podporovaných výstupních
formátů. Podrobnější (a možná aktuálnější) přehled si o těchto mechanismech
můžete udělat studiem souboru [Makefile](../Makefile) a odkazovaných skriptů
(většina z nich je v jazyce GNU awk).

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

To, které kapitoly a v jakém pořadí budou vygenerovány, se určuje v souboru
„kapitoly.lst“. Pokud tento soubor chybí, vytvoří se z „kapitoly.lst.vychozi“;
pokud chybí i ten, vytvoří se jako seznam všech kapitol a dodatků z Makefilu.

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
4. ID nové kapitoly doplňte jako nový řádek do souboru „kapitoly.lst“, aby se kapitola generovala na výstup.
5. Zkuste vše přeložit příkazem „make“ a zkontrolujte, že se nová kapitola přeložila.

Pak už můžete novou kapitolu začít plnit obsahem.

## Jak přidat podporu nového znaku

1. Zjistěte, jak daný znak vysázet v LaTeXu.
2. Ve skriptu [do\_latexu.awk](../skripty/do_latexu.awk) ve funkci ZpracujZnak() přidejte novou větev přepínače pro obsluhu vámi zvoleného znaku.
3. Pokud daný znak vyžaduje zvláštní zacházení ve formátu HTML, učiňte totéž i ve skriptu [do\_html.awk](../skripty/do_html.awk), většinu znaků však bude možno do HTML zkopírovat přímo.
4. Do speciální kapitoly [\_ukazka](../kapitoly/_ukazka.md) doplňte nový znak do seznamu podporovaných znaků.
5. Pokud kapitola „\_ukazka“ není uvedena v souboru „kapitoly.lst“, doplňte ji tam.
6. Zkuste přeložit všechny výstupní formáty příkazem „make“ a zkontrolujte překlad kapitoly „Ukázka“, zda v každém výstupním formátu, kromě formátu LOG, obsahuje korektně vysázený nový znak.

Pokud má být nový znak zadávaný HTML entitou nebo jiným nestandardním způsobem,
budete muset navíc navštívit skript [hlavni.awk](../skripty/hlavni.awk)
a doplnit interpretaci nové entity do funkce FormatovatRadek(), případně
i do funkce ZpracujZnaky(), pokud má být entita interpretována v kontextech
nepodporujících formátování jako např. URL adresy.
