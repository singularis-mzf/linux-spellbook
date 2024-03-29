<!--

Linux Kniha kouzel, dokumentace: Malé sestavení
Copyright (c) 2019-2021 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
# Malé sestavení

**STAV TEXTU:** aktuální

## Předpoklady a potřebný software

K sestavení formátů „html“, „log“ a „deb“ *Linuxu: Knihy kouzel* ze zdrojového kódu budete potřebovat:

* Git
* GNU awk 5.0 nebo novější
* GNU make
* GNU sed
* ImageMagick
* Perl 5.26 nebo novější
* qrencode, iconv, xxd
* české locale „cs\_CZ.UTF-8“ (musí fungovat české řazení příkazem „sort“) − nemusí být aktivní, stačí nainstalované a funkční
* pro balíček DEB také příkaz dpkg-deb (v Debianu a Ubuntu předinstalovaný)

V Ubuntu 20.04 LTS a Linuxu Mint 20 můžete tyto nástroje nainstalovat příkazem:

> ``sudo apt-get install git make gawk imagemagick qrencode xxd locales language-pack-cs perl perl-modules``

Ověřit dostupnost těchto nástrojů můžete příkazem „make kontrola“ ve staženém zdrojovém kódu
(viz níže). Výpis vám řekne, které z požadovaných nástrojů máte na systému dostupné, které ne
a k sestavení kterých výstupních formátů dostupné nástroje stačí.

## Postup sestavení

Prvním krokem je stáhnout si a nastavit repozitář:

> ``git clone --branch stabilní https://github.com/singularis-mzf/linux-spellbook.git``<br>
> ``cd linux-spellbook``<br>
> ``git config --local core.quotePath false``

V druhém kroku si vyberte kapitoly, které mají být součástí sestavení:

> ``cp -ivT konfigurace/pořadí-kapitol.výchozí.seznam konfigurace/pořadí-kapitol.seznam``

Otevřete nově vytvořený soubor „pořadí-kapitol.seznam“ v obyčejném textovém
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

Pak můžete spustit make (pokud některý formát nechcete sestavovat, můžete ho z příkazu vynechat):

> ``make -j4 html log deb``

Výstup ve všech sestavených formátech najdete v adresáři ``výstup_překladu``.
Očekávaná doba malého sestavení je několik sekund.

Pro sestavení formátů PDF pro tisk musíte využít [velké sestavení](velké-sestavení.md), které požaduje víc nástrojů.

## Přizpůsobení

Vaše sestavení si můžete přizpůsobit předáním dalších parametrů příkazu make při sestavení:

* Parametrem „JMENO“ můžete nastavit jméno a verzi sestavení. Doporučená syntaxe je ``JMENO='(označení distribuce) (číslo verze), (jméno verze)'``, kde jen číslo verze je povinná část (číslo verze se skládá z neprázdných sekvencí desítkových číslic oddělených tečkami).

Příklady:

> ``make JMENO='borůvková příchuť 2010.04, Šílený švec' html``<br>
> ``make JMENO='1.0' html deb``<br>
> ``make JMENO='Moje vlastní sestavení 1' html``

Překlad pravděpodobně bude fungovat i při nedodržení doporučené syntaxe, ale v takovém případě mohou nastat nečekané problémy.

* Parametrem „PREMIOVE\_KAPITOLY=1“ můžete zapnout generování přehledu vydaných, ale nezařazených kapitol.

*Příklad:*

``make PREMIOVE_KAPITOLY=1 -j4 html``

* Parametrem „REKLAMNI\_PATY=1“ můžete zapnout generování „reklamních“ pat kapitol ve formátu HTML. Texty pat se nastavují v souboru „[konfig.ini](../konfigurace/konfig.ini)“ v sekci [Reklamní-Paty].

*Příklad:*

``make REKLAMNI_PATY=1 -j4 html``

* Nastavením proměnné prostředí „PORADI\_KAPITOL“ na zvláštní hodnotu „\_\_VŠE\_\_“ můžete vynutit automatické přeložení všech kapitol a dodatků zapsaných v Makefile (tato funkce je používána při sestavování „výplachu repozitáře“):

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
Zadejte do terminálu příkaz:

> `printf %s\\n žába čádor tábor chalupa | LC_ALL="cs_CZ.UTF-8" sort`

a zkontrolujte, že vypsal řádky v tomto pořadí:

> čádor<br>chalupa<br>tábor<br>žába

Bude-li pořadí odlišné, sestavení sice bude fungovat, ale pořadí kapitol a štítků v přehledech může být chybné.

## Další poznámky

* Formát „log“ slouží k ladění mechanismu překladu. Jeho výstupní soubory obsahují přeložený zdrojový kód v podobě, která přesně odpovídá sekvenci volání ve skriptu „[skripty/překlad/hlavní.awk](../skripty/překlad/hlavní.awk)“.
* Formát „html“ by mělo být možno sestavit i v prostředí Cygwin. Při překladu v Cygwinu si však dejte pozor, abyste se zdrojovým kódem nepracovali pomocí programů systému Windows; ty by totiž do nich mohly vnést windowsí konce řádek (CR+LF) a překlad by pak nefungoval.
