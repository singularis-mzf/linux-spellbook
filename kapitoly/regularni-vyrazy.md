<!--

Linux Kniha kouzel, kapitola Regulární výrazy
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

Náměty k vylepšení:
[ ] Pro každou syntaxi vypsat, které znaky vyžaduje escapovat.
[ ] Perl: vyřešit problémy s UTF-8.

-->

# Regulární výrazy

!Štítky: {syntaxe}{zpracování textu}
!ÚzkýRežim: zap

## Úvod
Regulární výraz je řetězec speciálních a obyčejných znaků, který slouží
k formálnímu popsání množiny textových řetězců splňujících určité
syntaktické parametry. Např. celá čísla můžeme popsat výrazem
„0|-?[1-9][0-9]\*“ a poštovní směrovací čísla výrazem „[0-9]{3} [0-9]{2}“.

Regulární výrazy se používají při vyhledávání, filtrování, zpracování textu
a kontrole syntaxe; objevují se ve většině programovacích jazyků,
ale neprogramátoři je využijí např. při nastavení filtrování e-mailů
či při vyhledávání komplikovanějších konstrukcí v textových editorech.

V Linuxu se bohužel vyskytují tři různé syntaxe regulárních výrazů − základní
regulární výrazy, rozšířené regulární výrazy a regulární výrazy jazyka Perl.
Z praktických důvodů považuji za nejdůležitější rozšířené regulární výrazy,
a proto kdykoliv napíšu „regulární výraz“ bez dalšího upřesnění, mám na mysli
rozšířený regulární výraz. Kde se od sebe syntaxe liší, bude to u zaklínadel
upřesněno; kde není uvedena samostatná varianta pro Perl, platí pro Perl
varianta pro rozšířený regulární výraz.

## Definice
* Jako **atom** z praktických důvodů označuji nejkratší část regulárního výrazu, která končí na dané pozici a tvořila by syntakticky správný regulární výraz sama o sobě. Atomem je např. „a“, „[abc]“, „(a|b)?“ či „\\s+“, ale ne „a|b“, protože „b“ je kratší a samo o sobě tvoří syntakticky platný regulární výraz.
* **Kvantifikátor** je speciální podřetězec, který se zapisuje za atom a určuje dovolený počet opakování.
* **Kotva** a **hranice** jsou speciální atomy k testování pozice, např. „^“ nebo „\\&lt;“. Odpovídají fiktivnímu prázdnému podřetězci na jednoznačné pozici (u kotvy) nebo na všech pozicích splňujících dané podmínky (u hranice). Zvláštním případem hranice je **vyhlížení**.
* **Shoda** (match) je podřetězec testovaného řetězce, který celý vyhovuje požadavkům daného regulárního výrazu. Pokud na stejné pozici řetězce začíná víc takových podřetězců, shodou s regulárním výrazem je pouze ten nejdelší z nich. Proto např. regulární výraz „.\*“ má v každém testovaném řetězci pouze jedinou shodu − celý řetězec, přestože by jeho požadavkům odpovídal i jakýkoliv podřetězec.
* Řetězec **odpovídá** regulárnímu výrazu, pokud s ním má alespoň jednu shodu, a to i tehdy, pokud jako celek požadavky regulárního výrazu nesplňuje. Tzn. řetězec „abc“ regulárnímu výrazu „b“ odpovídá. Prázdnému regulárnímu výrazu odpovídá každý řetězec.

!ÚzkýRežim: vyp

## Zaklínadla

### Jednotlivé znaky

*# konkrétní znak*<br>
*// Některé znaky musejí být v regulárních výrazech pro zbavení svého speciálního významu escapovány zpětným lomítkem.*<br>
{*znak*}

*# **libovolný znak***<br>
**.**

*# kterýkoliv **z uvedených znaků***<br>
*// Uvnitř těchto hranatých závorek se speciální znaky neescapují zpětným lomítkem, ale uvedením na určitou pozici.*<br>
**[**{*znaky*}**]**

*# libovolný znak **kromě uvedených***<br>
**[^**{*znaky*}**]**

*# všechny znaky po první výskyt některého z uvedených/případně až do konce řetězce*<br>
**[^**{*znaky*}**]\*[**{*znaky*}**]**<br>
**[^**{*znaky*}**]\***

*# **bílý znak**/nebílý znak*<br>
**\\s**<br>
**\\S**

*# desítková **číslice** (rozšířený/základní/Perl)*<br>
**[0-9]**<br>
**[0-9]**<br>
**\\d**

*# jiný znak než desítková číslice (rozšířený/základní/Perl)*<br>
**[^0-9]**<br>
**[^0-9]**<br>
**\\D**

*# závorky „()[]{}“ (rozšířený/ základní)*<br>
**[(][)]\\[\\]\\{\\}**
**[(][)]\\[\\]{}**

*# libovolný alfanumerický znak, i národní abecedy (rozšířený/základní/Perl)*<br>
**[[:alnum:]]**<br>
**[[:alnum:]]**<br>
**\\w**

*# libovolný znak kromě alfanumerických (rozšířený/základní/Perl)*<br>
**[^[:alnum:]]**<br>
**[^[:alnum:]]**<br>
**\\W**

*# libovolné malé/velké písmeno, i národní abecedy*<br>
**[[:lower:]]**<br>
**[[:upper:]]**

### Kvantifikátory (operátory opakování)

*# **jednou nebo vůbec** (≤ 1)(rozšířený/základní)*<br>
{*atom*}**?**<br>
{*atom*}**\\?**

*# **libovolněkrát** (≥ 0)(rozšířený/základní)*<br>
{*atom*}**\***<br>
{*atom*}**\***

*# **jednou nebo víckrát** (≥ 1)(rozšířený/základní)*<br>
{*atom*}**+**<br>
{*atom*}**\\+**

*# přesně N-krát (= N)(rozšířený/základní)*<br>
{*atom*}**\{**{*N*}**\}**<br>
{*atom*}**\\\{**{*N*}**\\\}**

*# M- až N-krát včetně (M ≤ počet ≤ N)(rozšířený/základní)*<br>
{*atom*}**\{**{*M*}**,**{*N*}**\}**<br>
{*atom*}**\\\{**{*M*}**,**{*N*}**\\\}**

*# M- nebo víckrát (≥ M)(rozšířený/základní)*<br>
{*atom*}**\{**{*M*}**,}**<br>
{*atom*}**\\\{**{*M*}**,\\}**

*# maximálně N-krát (≤ N)(rozšířený/základní)*<br>
{*atom*}**{,**{*N*}**\}**<br>
{*atom*}**\\{,**{*N*}**\\\}**

*# snažit se opakovat co nejméně (non-greedy)(jen Perl)*<br>
{*atom*}{*kvantifikátor*}**?**

### Operátor „nebo“

*# některý z podvýrazů (rozšířený/základní)*<br>
{*výraz 1*}[**\|**{*další výraz*}]...<br>
{*výraz 1*}[**\\\|**{*další výraz*}]...

### Kotvy a hranice (pozice)

Kotvy a řetězce odpovídají fiktivnímu prázdnému řetězci na určité pozici.

*# začátek/konec testovaného řetězce (rozšířený i základní, mimo víceřádkový režim)*<br>
**^**<br>
**$**

*# začátek/konec testovaného řetězce (ve víceřádkovém režimu)*<br>
*// Podpora těchto kotev v programech je omezená, ale gawk, sed i perl je podporují.*<br>
**\\\`**<br>
**\\'**

*# začátek/konec řádku (rozšířený i základní, ve víceřádkovém režimu)*<br>
**^**<br>
**$**

*# začátek slova (rozšířený a základní/Perl)*<br>
**\\&lt;**<br>
**\\b(?=\\w)**

*# konec slova (rozšířený a základní/Perl)*<br>
**\\&gt;**<br>
**\\b(?&lt;=\\w)**

*# začátek nebo konec slova (rozšířený/základní/Perl)*<br>
**(\\&lt;\|\\&gt;)**<br>
**\\(\\&lt;\\\|\\&gt;\\)**<br>
**\\b**

### Seskupení

*# seskupení (rozšířený/základní)*<br>
**(**{*podvýraz*}**)**<br>
**\\(**{*podvýraz*}**\\)**

*# seskupení bez zapamatování (jen Perl)*<br>
**(?:**{*podvýraz*}**)**

### Paměť (omezená podpora)

*# původní podřetězec odpovídající celému regulárnímu výrazu (rozšířený a základní/Perl)*<br>
*// Tato konstrukce je v programech „gawk“ a „perl“ rozeznávána jako speciální pouze v řetězci pro náhradu, nikoliv přímo v regulárním výrazu.*<br>
**&amp;**<br>
**$&amp;**

*# podřetězec původního řetězce odpovídající seskupení (rozšířený i základní/Perl)*<br>
*// Poznámka: gawk tuto funkci nepodporuje vůbec. V Perlu se syntaxe liší mezi regulárním výrazem (\\číslo) a řetězcem pro náhradu ($číslo), v sedu se v obou případech používá jen syntaxe „\\číslo“.*<br>
**\\**{*pořadové-číslo-1-až-9*}<br>
**$**{*pořadové-číslo-1-až-9*}

*# totéž, ale první písmeno malé/velké*<br>
*// Tuto variantu podporuje pravděpodobně jen Perl a sed a smí se vyskytnout pouze v řetězci pro náhradu, nikoliv přímo ve vlastním regulárním výrazu.*<br>
**\\l\\**{*pořadové-číslo-1-až-9*}**\\E**<br>
**\\u\\**{*pořadové-číslo-1-až-9*}**\\E**

*# totéž, ale celý text malými/velkými písmeny*<br>
*// Viz poznámku k předchozímu zaklínadlu.*<br>
**\\L\\**{*pořadové-číslo-1-až-9*}**\\E**<br>
**\\U\\**{*pořadové-číslo-1-až-9*}**\\E**

### Vyhlížení (jen Perl)

*# ověřit, že za aktuální pozicí **následuje** shoda s daným regulárním podvýrazem*<br>
**(?=**{*podvýraz*}**)**

*# ověřit, že za aktuální pozicí **nenásleduje** shoda s daným regulárním podvýrazem*<br>
**(?!**{*podvýraz*}**)**

*# ověřit, že aktuální pozici **předchází** shoda s daným regulárním podvýrazem*<br>
**(?&lt;=**{*podvýraz*}**)**

*# ověřit, že aktuální pozici **nepředchází** shoda s daným regulárním podvýrazem*<br>
**(?&lt;!**{*podvýraz*}**)**

## Parametry příkazů

### egrep

*# *<br>
**egrep** {*parametry*} [**-e**] **'**{*regulární výraz*}**'** [{*soubor*}]...

!parametry:

* -v :: Logická negace; hledat řádky, které nevyhovují výrazu.
* -x :: Regulárnímu výrazu musí odpovídat celá řádka (výchozí chování: jakýkoliv podřetězec řádku).
* -q :: Žádný normální výstup, jen otestuje, zda by našel alespoň jeden vyhovující řádek. Parametr **-s** zase potlačí chybová hlášení.
* -i :: Nerozlišovat velká a malá písmena.
* -C {*počet*} :: „kontext“ Kromě vyhovujícího řádku vypíše zadaný počet předchozích a následujících. (Samostatně lze tyto počty nastavit parametry **-A** a **-B**.)
* -o :: Místo celých řádků vypisuje jednotlivé podřetězce vyhovující výrazu, každý podřetězec na samostatný řádek.
* -h :: Vyhledává-li se ve více souborech, neuvede se jako prefix řádky název souboru.
* -H :: Vždy uvede jako prefix řádku název souboru.
* -n :: Jako prefix bude vypisovat číslo řádky.
* -m {*N*} :: Ukončí hledání po nalezení N vyhovujících řádků.
* -z :: Řádky vstupních souborů jsou ukončeny nulovým bajtem; znak \\n bude považovat za za normální znak.

Poznámka: příkaz „grep“ má tytéž parametry jako „egrep“, ale pracuje se základními regulárními výrazy.

### gawk

*# *<br>
**gawk** [{*parametry*}] **'/**{*regulární výraz*}**/**[**\{**{*příkazy*}**\}**]**'** {*soubor*}...

!parametry:

* -F {*hodnota*} :: Nastaví systémovou proměnnou „FS“ (field separator) na uvedenou hodnotu.
* -v {*proměnná*}**=**{*hodnota*} :: Nastaví proměnnou na uvedenou hodnotu.
* -S :: Spustí skript v „bezpečném režimu“, kdy nemůže volat příkazy bashe, spouštět jiné programy ani otevírat další soubory.

### perl

*# *<br>
**perl -nwe 'if ($\_ =~ /**{*regulární výraz Perlu*}**/) {print $\_}' &lt;**{*vstupní-soubor*}<br>
**perl -pwe 's/**{*regulární výraz Perlu*}**/**{*výraz náhrady*}**/**[**g**]**' &lt;**{*vstupní-soubor*}

!parametry:

* -n :: Vykoná program v cyklu pro každý řádek vstupu.
* -p :: Vykoná program v cyklu pro každý řádek vstupu a na konci každého cyklu vypíše proměnnou „$\_“.
* -w :: Zapne užitečná varování. (**-W** zapne všechna varování.)
* -e {*program*} :: Vykoná tento program místo načtení programu ze souboru.
* -X :: Vypne všechna varování.

### sed

*# *<br>
**sed** {*parametry*} [[**-e** {*příkazy*}]...  **-e**] {*příkazy*} [{*vstupní-soubor*}]...

!parametry:

* -E :: Používá rozšířené regulární výrazy místo základních.
* -i :: „in-place“ Výstupem přepíše původní soubor.
* -z :: Řádek končí nulovým bajtem, ne znakem \\n.
* -u :: „unbuffered“ Čte a zapisuje data po jednotlivých řádcích. (Normálně je kvůli výkonu načítá po delších blocích.)

## Instalace na Ubuntu

Příkazy „egrep“, „grep“, „perl“ a „sed“ jsou základními součástmi
Ubuntu. Příkaz „gawk“ je nutné doinstalovat, nebo místo něj použít méně
schopný příkaz „awk“, který je základní součástí Ubuntu.

*# *<br>
**sudo apt-get install gawk**

Regulární výrazy jsou používány i v mnoha dalších programech.

<!--
## Ukázka
<!- -
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti − ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
- ->

// Je pro mě příliš obtížné vymyslet vhodnou ukázku, tak tuto sekci vynechávám.
-->

## Tipy a zkušenosti

* V Perlu se k označení desítkové číslice běžně používá podvýraz „\\d“; v jiných syntaxích regulárních výrazů ovšem není podporován, proto doporučuji zvyknout si na podvýraz „[0-9]“, který je čitelnější a je podporovaný opravdu všude.
* Parametr -o u příkazu „egrep“ lze efektivně využít při počítání ne-ASCII znaků. Počet znaků č, š a ž v textu zjistíte příkazem „egrep -o '[čšž]' \| wc -l“.
* Regulární výrazy jsou přezdívány „write-only language“, protože bývá výrazně snazší je napsat než přečíst a pochopit. Než začnete rozumět cizím regulárním výrazům, musíte získat značné zkušenosti s psaním svých vlastních.
* Ve výrazech typu „"[^"]\*"“ často zapomínám kvantifikátor + či \*.

!ÚzkýRežim: zap

## Další zdroje informací

Pro samotné regulární výrazy je k dispozici velké množství webových stránek (viz Odkazy),
ale většinou jsou zbytečné, protože s referenční příručkou (resp. s touto kapitolou)
budete pravděpodobně schopen/a požadovaný regulární výraz vymyslet sám/a.

Pro zmíněné programy:

*# *<br>
**egrep \-\-help**<br>
**man gawk**<br>
**perl \-\-help**

* [Web regularnivyrazy.info](https://www.regularnivyrazy.info/)
* [Přednáška Lukáše Bařinky: Bash a regulární výrazy vs shellovské vzory](https://youtu.be/dOKydwMDYUU)
* [Seriál Regulární výrazy v PHP (Perl-compatible)](https://www.regularnivyrazy.info/serial-php-pcre-perl-compatible.html)
* [Seriál článků na Root.cz](https://www.root.cz/serialy/regularni-vyrazy/)
* [Článek Regulární výraz na Wikipedii](https://cs.wikipedia.org/wiki/Regul%C3%A1rn%C3%AD_v%C3%BDraz)
* Kniha: GOYVAERTS, Jan a Steven LEVITHAN. *Regulární výrazy: kuchařka programátora.* Brno: Computer Press, 2010. ISBN 978-80-251-1935-8.
* [Online tester regulárních výrazů](http://www.regexp.cz/index.php)
* [Přednáška Milana Davídka: Regulární výrazy](https://youtu.be/HHh-U0dZcOc)
* [Článek na blogu Miroslava Pecky](https://miroslavpecka.cz/blog/regularni-vyrazy-vse-co-jste-o-nich-chteli-vedet/)
* [Web Regular-Expressions.info](https://www.regular-expressions.info/) (anglicky)
* [Web RexEgg](https://www.rexegg.com/) (anglicky)
* [Online příručka GNU awk](https://www.gnu.org/software/gawk/manual/) (anglicky)
* [Online příručka GNU sed](https://www.gnu.org/software/sed/manual/) (anglicky)
* [Online příručka modulu perlre](https://perldoc.perl.org/perlre.html) (anglicky)
* [Manuálová stránka: grep](http://manpages.ubuntu.com/manpages/bionic/en/man1/grep.1.html) (anglicky)
* [Manuálová stránka: pcrepattern](http://manpages.ubuntu.com/manpages/bionic/en/man3/pcrepattern.3.html) (anglicky)
* [Balíček „gawk“](https://packages.ubuntu.com/bionic/gawk) (anglicky)
* [Balíček „perl“](https://packages.ubuntu.com/bionic/perl) (anglicky)
* [Balíček „sed“](https://packages.ubuntu.com/bionic/sed) (anglicky)

!ÚzkýRežim: vyp
