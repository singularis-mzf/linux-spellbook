# Mechanismus překladu

Zdrojový kód kapitol a dodatků knihy *Linux: Kniha kouzel* je v omezeném
(a na druhou stranu mírně rozšířeném) Markdownu. Kompletní přehled všech
podporovaných konstrukcí najdete v kapitole [Ukázka](../kapitoly/_ukazka.md).
Tento dodatek si klade za cíl stručně popsat mechanismy, na nichž je
založen překlad těchto zdrojových kódů do všech podporovaných výstupních
formátů. Podrobnější přehled si o těchto mechanismech můžete udělat
studiem souboru Makefile a odkazovaných skriptů (většina z nich je v jazyce
GNU awk).

Jsou podporovány tři hlavní skupiny výstupních formátů:

* Formáty PDF (pdf-a4, pdf-a5) jsou určeny pro tisk. Skripty v jazyce GNU awk převedou zdrojový text kapitol a dodatků do formátu LaTeXu, spojí kapitoly a doplní hlavičku a patičku a výsledný soubor přeloží pomocí nástroje pdflatex. Paralelně s tím jsou zpracovány obrázky pomocí nástroje ImageMagick.
* Formát HTML (html) je určený pro integraci do statických webových stránek. Skripty v jazyce GNU awk převedou zdrojový text každé kapitoly do podoby HTML dokumentu. Paralelně s tím jsou zpracovány obrázky a jako stylový předpis se použije obsah souboru „formaty/html/sablona.css“.
* Formát LOG (log) je určen pouze pro ladění lexikálně syntaktického analyzátoru, který se nachází ve skriptu „skripty/hlavni.awk“.

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
