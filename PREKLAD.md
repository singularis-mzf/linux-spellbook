# Návod k sestavení

Existují dva druhy sestavení tohoto projektu − „malé sestavení“, kde vzniknou
jen výstupní formáty HTML a LOG, a „úplné sestavení“. Malé sestavení je
popsáno v souboru [README.md](README.md), úplné sestavení je popsáno zde.

## Předpoklady a potřebný software

K úplnému sestavení *Linuxu: Knihy kouzel* ze zdrojového kódu budete potřebovat:

* Git
* GNU make
* GNU awk
* ImageMagick
* rsvg-convert (kvůli konverzi SVG na PDF)
* XeLaTeX
* qrencode
* české locale „cs\_CZ.UTF-8“ (musí fungovat české řazení příkazem „sort“) − nemusí být aktivní, stačí nainstalované a funkční

Také budete potřebovat písma:

* DejaVu Sans
* Latin Modern Math
* Latin Modern Mono Slanted
* Latin Modern Mono Light Cond
* TeX Gyre Schola
* TeX Gyre Heros
* TeX Gyre Cursor
* Free Helvetica

Ověřil/a jsem, že v Ubuntu 20.04 LTS, Ubuntu 18.04 LTS a Linuxu Mint 20 můžete všechny potřebné nástroje a písma nainstalovat příkazem:

> ``sudo apt-get install git make gawk imagemagick librsvg2-bin qrencode texlive-xetex texlive-lang-czechslovak fonts-texgyre t1-cyrillic``

V budoucnu pravděpodobně sestavování přejde na Ubuntu 20.04, ale zatím je stále plně podporován i překlad na Ubuntu 18.04.

## Postup sestavení

Pak budete potřebovat stáhnout si repozitář:

> ``git clone https://github.com/singularis-mzf/linux-spellbook.git``

A nakonec stačí spustit make:

> ``make -j4 -C linux-spellbook``

Pro urychlení můžete programu „make“ předat parametr **„-j4“**.

Výstup ve všech podporovaných formátech najdete v adresáři ``vystup_prekladu``.

## Ověření českého locale

Pokud používáte jinou než českou lokalizaci Vašeho systému (i slovenskou),
ověřte prosím před sestavením, že Váš systém zvládne správně české řazení.
Zadejte do terminálu příkaz:

> `printf %s\\n žába čádor tábor chalupa | LC_ALL="cs_CZ.UTF-8" sort`

a zkontrolujte, že vypsal řádky v tomto pořadí:

> čádor<br>chalupa<br>tábor<br>žába

Bude-li pořadí odlišné, sestavení sice bude fungovat, ale pořadí kapitol a štítků v přehledech může být chybné.

## Další poznámky

* Varování „*fontspec warning: "only-xetex-feature"*“ ignorujte; jde o chybu v balíčku „fontspec“, které již [byla nahlášena](https://github.com/wspr/fontspec/issues/382).
* Na Debianu 10 funguje podobný postup jako v Ubuntu, ale narazil/a jsem na problém s aktivací řazení podle českého locale, pokud nebylo zvoleno již při instalaci systému. Proto překlad na Debianu přímo nepodporuji.
* Formát „log“ slouží k ladění mechanismu překladu. Jeho výstupní soubory obsahují přeložený zdrojový kód v podobě, která přesně odpovídá sekvenci volání ve skriptu „[skripty/preklad/hlavni.awk](skripty/preklad/hlavni.awk)“.

## Konfigurace

### Výběr a pořadí kapitol

Vytvoříte-li v adresáři *linux-spellbook* soubor „poradi-kapitol.lst“
(např. jako kopii souboru „poradi-kapitol.vychozi.lst“), můžete jím ovlivnit,
které kapitoly a v jakém pořadí budou zařazeny na výstup. Každý řádek
představuje jednu kapitolu či dodatek (uvádí se název souboru v adresáři
„kapitoly“ či „dodatky“ bez přípony „.md“). Alespoň jedna kapitola musí
být uvedena a žádná kapitola se nesmí opakovat. Prázdné řádky a řádky
začínající znakem „#“ jsou ignorovány.

### Označení a jméno verze

Sestavená verze se normálně označuje jako „Sid“ s datem překladu.
Chcete-li verzi pojmenovat a označit jinak, musíte při překladu příkazu
„make“ předat parametr JMENO, jehož syntaxe je následující:

> make JMENO='(označení distribuce) (číslo verze), (jméno verze)' (další parametry...)

Např.:

> make JMENO='borůvková příchuť 2010.04, Šílený švec'

Kde:

* „borůvková příchuť“ je označení distribuce
* „2010.04“ je číslo verze
* „Šílený švec“ je jméno verze

Označení distribuce a jméno verze jsou nepovinné části; neuvádíte-li jméno verze, vynechte i čárku, např. takto:

> make JMENO='2010.04'

Označení distribuce a jméno verze by měly obsahovat pouze písmena a mezery. Při použití jiných znaků riskujete,
že je mechanismus překladu nezpracuje správně. Číslo verze musí být tvořeno neprázdnými sekvencemi číslic
oddělenými jednotlivými tečkami.

### Zpracování obrázků

V souboru „konfig.ini“ jsou uvedena nastavení pro předzpracování obrázků a jejich umístění do PDF verze.
