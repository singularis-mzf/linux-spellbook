<!--

Linux Kniha kouzel, dokumentace: Velké sestavení
Copyright (c) 2019-2021 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Velké (úplné) sestavení a tisk

**STAV TEXTU:** aktuální

## Předpoklady a potřebný software

K úplnému sestavení *Linuxu: Knihy kouzel* ze zdrojového kódu budete potřebovat:

* Git
* GNU awk 5.0 nebo novější
* GNU make
* GNU sed
* ImageMagick
* Perl 5.26 nebo novější
* GhostScript
* rsvg-convert (kvůli konverzi SVG na PDF)
* XeLaTeX
* qrencode
* iconv
* xxd
* české locale „cs\_CZ.UTF-8“ (musí fungovat české řazení příkazem „sort“) − nemusí být aktivní, stačí nainstalované a funkční

Také budete potřebovat písma:

* DejaVu Sans
* Latin Modern Math
* Latin Modern Mono Slanted
* Latin Modern Mono Light
* Latin Modern Mono Light Cond
* Latin Modern Roman
* Latin Modern Sans

Ověřil/a jsem, že v Ubuntu 20.04 LTS a Linuxu Mint 20 můžete všechny potřebné nástroje a písma nainstalovat příkazem:

> ``sudo apt-get install git make gawk xxd imagemagick librsvg2-bin qrencode locales language-pack-cs  perl perl-modules texlive-xetex texlive-lang-czechslovak t1-cyrillic lmodern``

Ověřit dostupnost těchto nástrojů můžete příkazem „make kontrola“ ve staženém zdrojovém kódu
(viz níže). Výpis vám řekne, které z požadovaných nástrojů máte na systému dostupné, které ne
a k sestavení kterých výstupních formátů dostupné nástroje stačí.

Pokud plánujete nechat si výsledek vytisknout, před samotným sestavením vyhledejte ve vašem městě copy-centrum nebo profesionální tiskárnu a zjistěte o ní následující údaje:

* Nabízí k tisku i kroužkovou nebo knižní vazbu (1 kus)?
* Nabízí tisk *do kraje* (s ořezovými značkami), nebo při tisku vyžaduje zachování nějakého minimálního odstupu od okraje papíru?
* Na jaké formáty papíru tiskne? (Možná nabízí i různé druhy papíru – kancelářský, recyklovaný apod.)
* A samozřejmě – kolik jednotlivé varianty (orientačně) stojí.

U Linuxu: Knihy kouzel máte na výběr mezi formáty B5 a A4. A4 bývá levnější a mně osobně vyhovuje více, ale většina uživatelů dává přednost „knižnějšímu“ formátu B5, který se lépe přenáší a lépe se drží v rukou.

Podle zjištěných údajů se rozhodněte pro jeden z nabízených formátů: **pdf-a4** a **pdf-b5** jsou s ořezovými značkami, zatímco **pdf-a4-bez** a **pdf-b5-bez** dodržují odstup obsahu od okraje. V případě tisku na domácí tiskárně potřebujete téměř jistě formát **pdf-a4-bez**.

## Postup sestavení

Prvním krokem je stáhnout si a nastavit repozitář:

> ``git clone --branch stabilní https://github.com/singularis-mzf/linux-spellbook.git``<br>
> ``cd linux-spellbook``<br>
> ``git config --local core.quotePath false``

V druhém kroku si vyberte kapitoly, které mají být součástí sestavení:

> ``cp -ivT konfigurace/pořadí-kapitol.výchozí.seznam konfigurace/pořadí-kapitol.seznam``

Otevřete nově vytvořený soubor „pořadí-kapitol.lst“ v obyčejném textovém
editoru (např. vim, nano, Gedit, Kate, Mousepad, Leafpad apod.,
ne LibreOffice Writer!) a upravte pořadí či výběr kapitol.
Tento soubor bude určovat, které kapitoly či dodatky a v jakém pořadí
budou zařazeny do sestavení.

Prázdné řádky a řádky začínající znakem „#“ jsou ignorovány a lze je použít
jako komentáře. Ostatní řádky jsou názvy souborů v podadresářích „dodatky“
a „kapitoly“ bez přípony „.md“. Přitom musejí být splněna tato pravidla:

* První by měla být „předmluva“ (při nesplnění tohoto požadavku nemusí sestavení fungovat).
* Žádná kapitola či dodatek se nesmí opakovat.
* Podkapitoly se mohou objevit jen v souvislé řadě po sobě příslušné hlavní kapitole (ale na pořadí podkapitol nezáleží).

Pokud budete vaše sestavení šířit ostatním osobám, doporučuji ponechat
dodatek „licence“.

Pak můžete spustit make (místo „pdf-a4-bez“ uveďte označení formátu, který chcete přeložit;
můžete uvést i více různých formátů oddělených mezerami):

> ``make -j4 pdf-a4-bez``

Pokud nedojde k chybě, hotové soubory najdete v adresáři ``výstup_překladu``.
Pokud při překladu narazíte na nečekané problémy, se kterými si nebudete vědět rady,
zkuste smazat adresáře ``soubory_překladu`` a ``výstup_překladu`` a zkuste překlad
znovu z větve gitu „stabilní“. Pokud se chyba objeví i tam, můžete mi napsat
a pokusím se vám poradit. (V takovém případě budu potřebovat vědět, s jakou chybou
Vám překlad skončil a na jaké verzi jaké distribuce se o překlad pokoušíte.)

Při překladu můžete uvést i více formátů (oddělených mezerami); podporovány jsou následují formáty:

* **deb** *(sestaví balíček pomocných skriptů a funkcí)*
* **log** *(jen pro účely ladění)*
* **html**
* **pdf-a4**
* **pdf-a4-bez**
* **pdf-b5**
* **pdf-b5-bez**
* **pdf-b5-na-a4**
* **pdf-výplach** *(zvláštní formát pro „výplach repozitáře“)*

## Přizpůsobení

Vaše sestavení si můžete přizpůsobit předáním dalších parametrů příkazu make při sestavení:

* Parametrem „JMENO“ můžete nastavit jméno a verzi sestavení. Doporučená syntaxe je ``JMENO='(označení distribuce) (číslo verze), (jméno verze)'``, kde jen číslo verze je povinná část (číslo verze se skládá z neprázdných sekvencí desítkových číslic oddělených tečkami).

Příklady:

> ``make JMENO='borůvková příchuť 2010.04, Šílený švec' html pdf-a4``<br>
> ``make JMENO='1.0' html``<br>
> ``make JMENO='Moje vlastní sestavení 1' pdf-b5 html``

Překlad pravděpodobně bude fungovat i při nedodržení doporučené syntaxe, ale v takovém případě mohou nastat nečekané problémy.

* Parametrem „PDF\_ZALOZKY=0“ můžete vypnout generování „záložek“ v PDF.

*Příklad:*

``make PDF_ZALOZKY=0 -j4 html pdf-a4``

* Parametrem „PREMIOVE\_KAPITOLY=1“ můžete zapnout generování přehledu vydaných, ale nezařazených kapitol.

*Příklad:*

``make PREMIOVE_KAPITOLY=1 -j4 html pdf-a4``

* Parametrem „REKLAMNI\_PATY=1“ můžete zapnout generování „reklamních“ pat kapitol ve formátu HTML. Texty pat se nastavují v souboru „[konfig.ini](../konfigurace/konfig.ini)“ v sekci [Reklamní-Paty].

*Příklad:*

``make REKLAMNI_PATY=1 -j4 html``

* Nastavením proměnné prostředí „PORADI\_KAPITOL“ na zvláštní hodnotu „\_\_VŠE\_\_“ můžete vynutit automatické přeložení všech kapitol a dodatků zapsaných v Makefile (tato funkce je používána při sestavování „výplachu repozitáře“):

*Příklad:*

``PORADI_KAPITOL='__VŠE__' make -j4 html``

* Parametrem „JE_UKAZKA=1“ můžete zapnout vodoznak s textem „UKÁZKA“ v HTML formátu.

``make JE_UKAZKA=1 -j4 html``

### Oblíbená zaklínadla

Oblíbená zaklínadla se vypisují ve formátech HTML a PDF navíc na začátku každé
kapitoly. Vypnout je můžete vyprázdněním souboru
[oblíbená-zaklínadla.seznam](../konfigurace/oblíbená-zaklínadla.seznam).

Abyste mohli přidat zaklínadlo mezi oblíbené, musíte nejprve zjistit
*ID kapitoly* a *x-heš zaklínadla*.

ID kapitoly je cesta ke zdrojovému
souboru kapitoly z adresáře „kapitoly“, ale bez přípony „.md“;
tedy např. „diskové-oddíly“ nebo „diskové-oddíly/btrfs“.

X-heš zaklínadla je jeho vygenerované hexadecimální označení. To zjistíte
nejlépe z formátu HTML: Najděte příslušné zaklínadlo.
Ikona vlevo od něj slouží jako permanentní odkaz;
vezměte adresu tohoto odkazu a odstraňte z ní vše až po výskyt kombinace „#z“.
To, co zbude, je x-heš daného zaklínadla.

V souboru „oblíbená-zaklínadla.seznam“ vyhledejte (nebo vytvořte) sekci
pojmenovanou ID kapitoly (např. „*\[diskové-oddíly]*“).
Do této sekce pak na novou řádku přidejte získanou x-heš.
Chcete-li použít vlastní titulek místo původního (což doporučuji),
uveďte za x-heš mezeru a text vašeho titulku.

Ve vlastním titulku můžete použít písmena, číslice, mezery
(obyčejné nebo nezlomitelné) a omezený sortiment interpunkce;
z formátování můžete použít pouze tučné písmo pomocí „\*\*“ jako v Markdownu.

Vyřadit jednotlivá oblíbená zaklínadla lze vypuštěním nebo zakomentováním řádku s jejich x-heší.

Poznámky:

* Na pořadí x-heší v seznamu nezáleží; uvedení neexistující x-heše (za předpokladu, že má správný formát) není chyba a bude tiše ignorováno.
* Řádky seznamu začínající znakem „#“ jsou komentáře a budou ignorovány.
* Každá kapitola (resp. podkapitola) by měla mít v seznamu oblíbených zaklínadel nejvýše jednu sekci. (Bude-li jich mít víc, současná implementace zpracuje pouze tu první, ale v budoucnu se to může změnit.)
* Stejná x-heš se nesmí opakovat u jedné kapitoly, může však být uvedena u více různých kapitol (což má smysl, pokud víc kapitol obsahuje totéž zaklínadlo).
* Je dovoleno uvést sekci pojmenovanou ID neexistující kapitoly. Taková se na výstupu neprojeví.

## Ověření české lokalizace systému

Pokud používáte jinou než českou lokalizaci Vašeho systému (i slovenskou),
ověřte prosím před sestavením, že Váš systém zvládne správně české řazení.
Toto ověření je součástí skriptu prováděného příkazem „make kontrola“;
ručně ho můžete provést tak, že do terminálu zadáte příkaz:

> `printf %s\\n žába čádor tábor chalupa | LC_ALL="cs_CZ.UTF-8" sort`

a zkontrolujete, že vypsal řádky v tomto pořadí:

> čádor<br>chalupa<br>tábor<br>žába

Bude-li pořadí odlišné, sestavení sice bude fungovat, ale pořadí štítků může být chybné.

## Další poznámky

* Varování „*fontspec warning: "only-xetex-feature"*“ ignorujte; jde o chybu v balíčku „fontspec“, které již [byla nahlášena](https://github.com/wspr/fontspec/issues/382).
* Na Debianu 10 funguje podobný postup jako v Ubuntu, ale narazil/a jsem na problém s aktivací řazení podle českého locale, pokud nebylo zvoleno již při instalaci systému. Proto překlad na Debianu přímo nepodporuji.
* Formát „log“ slouží k ladění mechanismu překladu. Jeho výstupní soubory obsahují přeložený zdrojový kód v podobě, která přesně odpovídá sekvenci volání ve skriptu „[skripty/překlad/hlavní.awk](../skripty/překlad/hlavní.awk)“.
