<!--

Linux Kniha kouzel, kapitola Regulární výrazy
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

Náměty k vylepšení:
[ ] Pro každou syntaxi vypsat, které znaky vyžaduje odzvláštnit.
[ ] Perl: vyřešit problémy s UTF-8.

-->

# Regulární výrazy

!Štítky: {syntaxe}{zpracování textu}{bash}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Regulární výrazy představují velmi silný nástroj k vyhledávání, analýze,
filtrování, kontrole syntaxe, extrakci a transformaci textů a textových dat.
Slouží k formálnímu popisu (obvykle nekonečné) množiny řetězců a následné
vyhledávání řetězců z této množiny v textu. S takto vyhledanými řetězci
(tzv. výskyty či shodami) můžeme dále pracovat.

Regulární výrazy se objevují se ve většině programovacích jazyků,
ale také v textových editorech či manuálním nastavení e-mailových filtrů.

V linuxu se bohužel vyskytují tři různé syntaxe regulárních výrazů – základní
regulární výrazy, rozšířené regulární výrazy a regulární výrazy jazyka Perl.
Z praktických důvodů považuji za nejdůležitější rozšířené regulární výrazy,
a proto kdykoliv napíšu „regulární výraz“ bez dalšího upřesnění, mám na mysli
rozšířený regulární výraz. Kde se od sebe syntaxe liší, bude to u zaklínadel
upřesněno; kde není uvedena samostatná varianta pro Perl, platí pro Perl
varianta pro rozšířený regulární výraz.

## Definice
* Řetězec se **shoduje** s daným regulárním výrazem, pokud patří do množiny řetězců, kterou regulární výraz definuje, tedy pokud odpovídá požadavkům regulárního výrazu jako celek, od začátku do konce. Např. s regulárním výrazem „a.c“ se shoduje řetězec „abc“, protože „a“ v regulárním výrazu přijímá „a“ z řetězce; tečka z regulárního výrazu přijímá jakýkoliv znak, tedy i „b“ v řetězci a „c“ v regulárním výrazu přijme „c“ z řetězce. S tímtéž regulárním výrazem se už ale neshodují řetězce „Abc“ (pokud nevypnete rozlišování velkých a malých písmen), „abb“, „abbc“ či „abcc“ (protože k poslednímu „c“ už v regulárním výrazu není nic, co by ho přijalo).
* **Shoda** (match) je nejlevější a nejdelší (u tzv. „nehladového prohledávání“ naopak nejkratší) podřetězec prohledávaného řetězce, který se shoduje s daným regulárním výrazem, a totéž rekurzívně pro zbytek řetězce za koncem shody. Takže shody jsou vlastně podřetězce shodující se s regulárním výrazem, ale jen tak, aby se nepřekrývaly. Shodou může být i celý prohledávaný řetězec (protože každý řetězec je sám svým podřetězcem).
* Řetězec **odpovídá** danému regulárnímu výrazu, pokud s ním má nějakou shodu. Takže regulárnímu výrazu „a.c“ odpovídají např. řetězce „*abc*“, „a*abc*“, „x*axc*x“, „x*axc*x*axc*x“ apod., ale ne „xaxbxc“.
* Jako **atom** označuji nejkratší část (podřetězec) regulárního výrazu, která končí na dané pozici a tvořila by syntakticky správný regulární výraz sama o sobě. Atomem je např. „a“, „[abc]“, „(a|b)?“ či „\\s+“, ale ne „a|b“, protože „b“ je kratší a samo o sobě tvoří syntakticky správný regulární výraz.
* **Kvantifikátor** je speciální podřetězec, který se zapisuje za atom a určuje dovolený počet opakování.
* **Kotva** a **hranice** jsou speciální atomy k testování pozice, např. „^“ nebo „\\&lt;“. Z prohledávaného řetězce přijímají fiktivní prázdný podřetězec na jednoznačné pozici (u kotvy) nebo na všech pozicích splňujících určité podmínky (u hranice). Zvláštním případem hranice je **vyhlížení**.
* **Vzorek bashe** (také **vzorek**) je regulární výraz v interpretu bash zapsaný jeho zvláštní syntaxí; slouží nejčastěji k filtrování názvů souborů. Při testování vzorků se obvykle vyžaduje úplná shoda.

!ÚzkýRežim: vyp

## Zaklínadla: Regulární výrazy

### Jednotlivé znaky

*# konkrétní znak*<br>
*// Některé znaky musejí být v regulárních výrazech pro zbavení svého speciálního významu odzvláštněny zpětným lomítkem.*<br>
{*znak*}

*# **libovolný znak** (rozšířený i základní/Perl)*<br>
**.**<br>
**(?:.\|\\n)**

*# kterýkoliv **z uvedených znaků***<br>
*// Uvnitř těchto hranatých závorek se speciální znaky neodzvláštňují zpětným lomítkem, ale uvedením na určitou pozici.*<br>
**[**{*znaky*}**]**

*# libovolný znak **kromě uvedených***<br>
**[<nic>^**{*znaky*}**]**

*# všechny znaky po první výskyt některého z uvedených/případně až do konce řetězce*<br>
**[<nic>^**{*znaky*}**]\*[**{*znaky*}**]**<br>
**[<nic>^**{*znaky*}**]\***

*# **bílý znak**/nebílý znak*<br>
**\\s**<br>
**\\S**

*# desítková **číslice** (rozšířený/základní/Perl)*<br>
**[0-9]**<br>
**[0-9]**<br>
**\\d**

*# jiný znak než desítková číslice (rozšířený/základní/Perl)*<br>
**[<nic>^0-9]**<br>
**[<nic>^0-9]**<br>
**\\D**

*# závorky „()[]{}“ (rozšířený/ základní)*<br>
**[(][)]\\[\\]\\{\\}**
**[(][)]\\[\\]{}**

*# libovolný alfanumerický znak, i národní abecedy (rozšířený/základní/Perl)*<br>
**[[:alnum:]]**<br>
**[[:alnum:]]**<br>
**\\w**

*# libovolný znak kromě alfanumerických (rozšířený/základní/Perl)*<br>
**[<nic>^[:alnum:]]**<br>
**[<nic>^[:alnum:]]**<br>
**\\W**

*# libovolné písmeno, i národní abecedy*<br>
**[[:alpha:]]**

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

*# přesně **N-krát** (= N)(rozšířený/základní)*<br>
{*atom*}**\{**{*N*}**\}**<br>
{*atom*}**\\\{**{*N*}**\\\}**

*# M- až N-krát včetně (M ≤ počet ≤ N)(rozšířený/základní)*<br>
{*atom*}**\{**{*M*}**,**{*N*}**\}**<br>
{*atom*}**\\\{**{*M*}**,**{*N*}**\\\}**

*# **minimálně** M-krát (≥ M)(rozšířený/základní)*<br>
{*atom*}**\{**{*M*}**,}**<br>
{*atom*}**\\\{**{*M*}**,\\}**

*# **maximálně** N-krát (≤ N)(rozšířený/základní)*<br>
{*atom*}**{,**{*N*}**\}**<br>
{*atom*}**\\{,**{*N*}**\\\}**

*# snažit se opakovat co nejméně (**nehladové** prohledávání)(jen Perl)*<br>
{*atom*}{*kvantifikátor*}**?**

### Operátor „nebo“

*# některý z podvýrazů (rozšířený/základní)*<br>
{*výraz 1*}[**\|**{*další výraz*}]...<br>
{*výraz 1*}[**\\\|**{*další výraz*}]...

### Kotvy a hranice (pozice)

*# začátek testovaného řetězce (rozšířený i základní/víceřádkový režim/Perl)*<br>
**^**<br>
**\\\`**<br>
**\\A**

*# konec testovaného řetězce (rozšířený i základní/víceřádkový režim/Perl)*<br>
**$**<br>
**\\'**<br>
**\\z**

<!--
*# začátek/konec testovaného řetězce (ve víceřádkovém režimu)*<br>
*// Podpora těchto kotev v programech je omezená, ale gawk, sed i perl je podporují.*<br>
**\\\`**<br>
**\\'**
-->

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

*# začátek/konec řádku*<br>
?<br>
?

### Seskupení

*# seskupení (rozšířený/základní)*<br>
**(**{*podvýraz*}**)**<br>
**\\(**{*podvýraz*}**\\)**

*# seskupení bez zapamatování (jen Perl)*<br>
**(?:**{*podvýraz*}**)**

*# pojmenované seskupení (jen Perl)*<br>
**(?&lt;**{*název*}**&gt;**{*podvýraz*}**)**

### Paměť (omezená podpora)

*# původní podřetězec odpovídající celému regulárnímu výrazu (rozšířený a základní/Perl)*<br>
*// Platí jen v rámci řetězce náhrady, ne v samotném regulárním výrazu.*<br>
**&amp;**<br>
**$&amp;**

*# **záchyt** – podřetězec původního řetězce odpovídající seskupení (varianty)*<br>
*// Zdvojení zpětného lomítka v GNU awk vyplývá ze skutečnosti, že ho (obvykle) zadáváte jako řetězec v programovacím jazyce. Pokud byste náhodou např. načítali řetězec náhrady ze souboru, bude tam zpětné lomítko patřit pouze jedno!*<br>
**\\**{*pořadové-číslo-1-až-9*} ⊨ v reg. výrazu: GNU sed a Perl; v řetězci náhrady: GNU sed<br>
**\\\\**{*pořadové-číslo-1-až-9*} ⊨ v řetězci náhrady: GNU awk (jen funkce gensub())<br>
**$**{*pořadové-číslo-1-až-9*} ⊨ v řetězci náhrady: Perl

*# totéž, ale první písmeno malé/velké*<br>
*// Tuto variantu podporuje pravděpodobně jen Perl a sed a smí se vyskytnout pouze v řetězci pro náhradu, nikoliv přímo ve vlastním regulárním výrazu.*<br>
**\\l\\**{*pořadové-číslo-1-až-9*}**\\E**<br>
**\\u\\**{*pořadové-číslo-1-až-9*}**\\E**

*# totéž, ale celý text malými/velkými písmeny*<br>
*// Viz poznámku k předchozímu zaklínadlu.*<br>
**\\L\\**{*pořadové-číslo-1-až-9*}**\\E**<br>
**\\U\\**{*pořadové-číslo-1-až-9*}**\\E**

*# záchyt v Perlu v rámci regulárního výrazu (číslovaný/pojmenovaný)*<br>
**\\g\{**{*pořadové-číslo*}**\}**<br>
**\\g\{**{*název*}**\}**


### Vyhlížení (jen Perl)

*# ověřit, že za aktuální pozicí **následuje** shoda s daným regulárním podvýrazem*<br>
**(?=**{*podvýraz*}**)**

*# ověřit, že za aktuální pozicí **nenásleduje** shoda s daným regulárním podvýrazem*<br>
**(?!**{*podvýraz*}**)**

*# ověřit, že aktuální pozici **předchází** shoda s daným regulárním podvýrazem*<br>
**(?&lt;=**{*podvýraz*}**)**

*# ověřit, že aktuální pozici **nepředchází** shoda s daným regulárním podvýrazem*<br>
**(?&lt;!**{*podvýraz*}**)**

## Zaklínadla: Vzorky bashe

### Základní

*# konkrétní znak*<br>
*// Znaky, které mají pro bash zvláštní význam, je nutno ve vzorku odzvláštnit, nejčastěji zpětným lomítkem.*<br>
{*znak*}

*# žádný či více libovolných znaků/jeden libovolný znak*<br>
*// V bashi tyto znaky nepokrývají tečku jako první znak skrytých souborů a adresářů.*<br>
**\***<br>
**?**

*# kterýkoliv z uvedených znaků*<br>
*// Znaky „!“, „^“ a „-“ mají uvnitř těchto závorek zvláštní význam a při použití jako znaky je nutno je odzvláštnit! V bashi tato konstrukce nepokrývá tečku jako první znak skrytých souborů a adresářů.*<br>
**[**{*znaky*}**]**

*# kterýkoliv kromě uvedených znaků*<br>
*// Znaky „!“, „^“ a „-“ mají uvnitř těchto závorek zvláštní význam a při použití jako znaky je nutno je odzvláštnit! V bashi tato konstrukce nepokrývá tečku jako první znak skrytých souborů a adresářů.*<br>
**[<nic>^**{*znaky*}**]**

*# **bílý znak**/nebílý znak*<br>
**[[:space:]]**<br>
**[^[:space:]]**

*# desítková **číslice***<br>
**[0-9]**

*# jiný znak než desítková číslice*<br>
**[<nic>^0-9]**

*# závorky „()[]{}“*<br>
**\\(\\)\\[\\]\\{\\}**

*# libovolný alfanumerický znak, i národní abecedy*<br>
**[[:alnum:]]**

*# libovolný znak kromě alfanumerických*<br>
**[<nic>^[:alnum:]]**

*# libovolné písmeno, i národní abecedy*<br>
**[[:alpha:]]**

*# libovolné malé/velké písmeno, i národní abecedy*<br>
**[[:lower:]]**<br>
**[[:upper:]]**

### Rozšířené (s kvantifikací)

Podvzorek v následujících zaklínadlech je jakýkoliv vzorek, který by byl platný sám o sobě.

*# některý z podvzorků*<br>
**// Vnořený operátor @() lze skombinovat s obklopujícím operátorem, takže např. místo „+(@(A\|B))“ stačí napsat „+(A\|B)“, což má tentýž význam.**<br>
**@(**{*podvzorek*}[**\|**{*další-podvzorek*}]...**)**

*# podvzorek **jednou nebo vůbec** (≤ 1)*<br>
**?(**{*podvzorek*}**)**

*# podvzorek **libovolněkrát** (≥ 0)*<br>
**\*(**{*podvzorek*}**)**

*# podvzorek **jednou nebo víckrát** (≥ 1)*<br>
**+(**{*podvzorek*}**)**

*# žádný z podvzorků (negovaný test)*<br>
**!(**{*podvzorek*}[**\|**{*další-podvzorek*}]...**)**

*# všechny znaky po první výskyt některého z uvedených/případně až do konce řetězce*<br>
**\*([<nic>^**{*znaky*}**])[**{*znaky*}**]**<br>
**\*([<nic>^**{*znaky*}**])**<br>

*# přesně **N-krát** (= N)*<br>
?

*# M- až N-krát včetně (M ≤ počet ≤ N)*<br>
?

*# **minimálně** M-krát (≥ M)*<br>
?

*# **maximálně** N-krát (≤ N)*<br>
?

## Parametry příkazů

### bash

*# *<br>
**[[** {*řetězec*} **=~** {*regulární-výraz*} **]]**

*Poznámka:* Protože pravidla odzvláštňování regulárního výrazu v této konstrukci jsou neintuitivní a nepraktická,
striktně doporučuji zadávat regulární výraz jako proměnnou, např. takto:

*# *<br>
**if [[ "$1/$2" =~ $regex ]]**

*Pozor!* Proměnnou s regulárním výrazem v této konstrukci nikdy neuzavírejte do uvozovek!
Pokud to uděláte, bash ji bude interpretovat jako obyčejný řetězec, ne jako regulární výraz!

Existuje ještě druhý přiměřeně funkční způsob:

**[[** {*řetězec*} **=~ $(printf %s "**{*regulární výraz*}**") ]]**

Ale v tomto případě nesmí regulární výraz končit znakem nového řádku \\n, protože ten by se při rozvoji ztratil; pokud tímto znakem končit musí, pomůže uzavřít ho do hranatých závorek („[\\n]“).

*# *<br>
**[[** {*řetězec*} **=** {*vzorek*} **]]**

Příklad:

*# *<br>
**[[ $prom = A@(0\|1\|2)C ]]**

### egrep

*# *<br>
**egrep** {*parametry*} [**-e**] **'**{*regulární výraz*}**'** [{*soubor*}]...

!parametry:

* -v :: Logická negace; hledat řádky, které nevyhovují výrazu.
* -x :: Regulárnímu výrazu musí odpovídat celá řádka (výchozí chování: jakýkoliv podřetězec řádku).
* -z :: Řádky vstupních souborů jsou ukončeny nulovým bajtem; znak \\n bude považovat za za normální znak.
* -C {*počet*} :: „kontext“ Kromě vyhovujícího řádku vypíše zadaný počet předchozích a následujících. (Samostatně lze tyto počty nastavit parametry **-A** a **-B**.)
* -o :: Místo celých řádek vypisuje jednotlivé podřetězce vyhovující výrazu, každý podřetězec na samostatnou řádku.
* -h :: Vyhledává-li se ve více souborech, neuvede se jako prefix řádky název souboru.
* -H :: Vždy uvede jako prefix řádku název souboru.
* -n :: Jako prefix bude vypisovat číslo řádky.
* -q :: Žádný normální výstup, jen otestuje, zda by našel alespoň jeden vyhovující řádek. Parametr **-s** zase potlačí chybová hlášení.
* -m {*N*} :: Ukončí hledání po nalezení N vyhovujících řádek.
* -i :: Nerozlišovat velká a malá písmena.

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

* -n :: Vykoná program v cyklu pro každou řádku vstupu.
* -p :: Vykoná program v cyklu pro každý řádek vstupu a na konci každého cyklu vypíše proměnnou „$\_“ ($ARG).
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

Rozšířené vzorky bashe jsou ve výchozím nastavení zapnuty; v případě, kdy jsou vypnuty, lze je zapnout příkazem:

*# *<br>
**shopt -s extglob**

<!--
## Ukázka
<!- -
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
- ->

// Je pro mě příliš obtížné vymyslet vhodnou ukázku, tak tuto sekci vynechávám.
-->

## Tipy a zkušenosti

* V Perlu se k označení desítkové číslice běžně používá podvýraz „\\d“; v jiných syntaxích regulárních výrazů ovšem není podporován, proto doporučuji zvyknout si na podvýraz „[0-9]“, který je čitelnější a je podporovaný opravdu všude.
* Parametr -o u příkazu „egrep“ lze efektivně využít při počítání ne-ASCII znaků. Počet znaků č, š a ž v textu zjistíte příkazem „egrep -o '[čšž]' \| wc -l“.
* Regulární výrazy jsou přezdívány „write-only language“, protože bývá výrazně snazší je napsat než přečíst a pochopit. Než začnete rozumět cizím regulárním výrazům, musíte získat značné zkušenosti s psaním svých vlastních.
* Ve výrazech typu „"[<nic>^"]\*"“ často zapomínám kvantifikátor + či \*.
* Příručka varuje, že testování komplikovaných rozšířených vzorků může být pomalé. Pokud na to narazíte, může váš skript urychlit, když je přepíšete na regulární výrazy a k jejich testování použijete externí příkaz jako např. „egrep“.
* Vzorky začínající „?“, „\*“ nebo „[znaky]“ ignorují skryté soubory! Pravidlo říká, že obecné znaky jako „?“, „\*“ a „[]“ nepokrývají tečku, která je prvním znakem názvu souboru. Toto chování lze vypnout nastavením „shopt -s dotglob“. Všechny názvy souborů a adresářů včetně „.“ a „..“ pokrývá rozšířený vzorek „?(.)\*“.

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
* [Manuálová stránka: grep](http://manpages.ubuntu.com/manpages/focal/en/man1/grep.1.html) (anglicky)
* [Manuálová stránka: pcrepattern](http://manpages.ubuntu.com/manpages/focal/en/man3/pcrepattern.3.html) (anglicky)
* [Balíček „gawk“](https://packages.ubuntu.com/focal/gawk) (anglicky)
* [Balíček „perl“](https://packages.ubuntu.com/focal/perl) (anglicky)
* [Balíček „sed“](https://packages.ubuntu.com/focal/sed) (anglicky)

!ÚzkýRežim: vyp
