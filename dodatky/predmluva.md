<!--

Linux Kniha kouzel, předmluva
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Předmluva

> *„Prostě příkazový řádek v Linuxu je něco úchvatného, a kdo se neumí v tomto prostředí pohybovat, přichází*
> *o hodně.“*<br>— KAMENÍK, Pavel. *Příkazový řádek v Linuxu: praktická řešení.* Brno: Computer Press, 2011. ISBN 978-80-251-2819-0.

<neodsadit>Vážený/á čtenáři/ko,

v České republice začíná v letech 2020 až 2024 pracovat s Linuxem obrovské
množství uživatelů a tito lidé svůj nový systém poznávají převážně
třemi nejběžnějšími způsoby:

Většina z nich spoléhá na webové online zdroje v angličtině, a protože
nic jiného neznají, věří, že se z nich dozví vše podstatné. V tomto si
s nimi dovolím nesouhlasit, protože znám především dva druhy
online zdrojů a každý má svůj zásadní nedostatek: pokud hledáte
odpovědi na svoje otázky použitím webového vyhledavače,
dozvíte se zpravidla jen to, na co se ho „zeptáte“ (tzn. co si
necháte vyhledat). Problém je, že ač si to nejspíš neuvědomujete,
na mnoho podstatného se nezeptáte, protože vás to nenapadne,
takže i když webové stránky tuto podstatnou informaci obsahuji,
vy se ji stejně nedozvíte. Druhým typem online zdroje je podrobná
dokumentace konkrétního programu. Tento druh bývá kvalitní,
ale trpí jiným nedostatkem – pokud daný program pro vámi
řešený problém není vhodný nebo je již zastaralý a překonaný,
jeho dokumentace vám to nepoví a neporadí vám, kde jinde hledat.
(Nemluvě o tom, že bývá velmi rozsáhlá.)

O mnoho lépe na tom nejsou ani ti, kdo se s Linuxem učí zacházet
z nejnovějších knih na českém knižním trhu. Ty nejnovější, které se věnují
Linuxu, jsou totiž z let 2008 až 2012, a ačkoliv některé z nich naučí uživatele
opravdu dobře zacházet s bashem (snad až na asociativní pole), do praxe si
z nich uživatelé odnesou také mnohé zastaralé a překonané postupy,
protože se o těch nových a vylepšených, které jsou dostupné teprve
několik let, prostě nedozvědí, což mě mrzí.

Třetí skupina uživatelů si se svým systémem hraje a experimentuje.
Tito uživatelé se zpravidla o novějších postupech, příkazech a funkcích
dozvědí jako první, ale stojí je to neúměrné množství času a úsilí
a ne každého/ou takové experimentování baví.

Já sám/a jsem Linux jako svůj hlavní operační systém začal/a používat
v roce 2018 a patřím do té druhé skupiny – v začátcích mi nesmírně pomáhaly
vynikající příručky z let 1999 až 2010. V praxi jsem však opakovaně objevoval/a,
že některé věci už jsou na dnešním Linuxu jinak, viz třeba ACL, LVM
nebo asociativní pole v Bashi. Takové věci prostě ve starých příručkách nenajdete.

Cílem Linuxu: Knihy kouzel je tuto situaci změnit a formou
sbírky řešených příkladů připomínající knihu zaklínadel
či konverzační slovník cizího jazyka kvalitně a detailně představit,
co nejlepšího ve vybraných oblastech vám může nabídnout
linuxový operační systém, který máte nainstalovaný na svém počítači.

Máte-li na počítači nainstalovaný Linux, máte na disku gigabajty nesmírně mocných
nástrojů jako bash, Perl či TeX, které v sobě skrývají desítky let práce špičkových
programátorů, a nemusíte nezbytně pochopit, jak fungují, abyste s nimi dokázal/a
velké věci. Pokud vás zajímá, co s nimi tedy můžete udělat, a konkrétní postup,
jak toho dosáhnout, je toto kniha pro vás.

Linux: Kniha kouzel klade důraz na skutečné použití uvedených postupů,
funkcí a nástrojů, takže teoretický výklad je omezen na minimum
a poznámky uvádějí především praktické zkušenosti či technická omezení.
Smyslem používání této knihy není, abyste se nějaký příkaz *naučil/a* používat,
ale abyste ho s minimem nutného úsilí úspěšně *použil/a*.
Pokud se o použitém nástroji chcete dozvědět víc a opravdu se
naučit ho používat, je to určitě dobře, ale v takovém případě
budete muset vyhledat i další informační zdroje, např. manuálové stránky
či webové online zdroje. Samotný Linux: Kniha kouzel vám k tomu stačit nebude.

Pokud už používáte linuxový terminál delší dobu, napadlo vás někdy,
že když mu zadáváte příkazy, v mnoha aspektech se to podobá sesílání kouzel
ve fantasy světech? Tento příměr je o to děsivější, že zatímco fantasy kouzla
ovlivňují jen životy smyšlených postav, vaše příkazy budou mít reálné důsledky
ve vašem vlastním počítači! Linux: Kniha kouzel je na tomto příměru založena,
a proto v ní jednotlivé příklady nazývám *„zaklínadla“*. Pokud jste nadán/a
dostatečnou dávkou fantazie, můžete si při čtení představovat, že jste
začínající čaroděj ve fantasy světě a v rukou držíte lexikon kouzel
pro pokročilé. Při sesílání kouzel přesahujících vaši kvalifikaci se sice můžete
snadno „spálit“ a to se vám může stát i při zadávání příkazů do terminálu,
protože ten je velmi náročný na přesnost a i pouhá záměna jediné dvojtečky
za středník nebo dvojité uvozovky za jednoduchou bude mít zcela jistě
nečekané následky. Přesto se vám to vyplatí mnohem víc než omezit se
jen na to málo příkazu, které bezpečně ovládáte. (Pokud znáte příběhy
Harryho Pottera od J. K. Rowling, zamyslete se, jak by dopadl on,
kdyby se omezil jen na kouzla odpovídající jeho školnímu ročníku.
Moje odpověď – byl by mnohem víc závislý na Hermioně Grangerové.)

Zaklínadla v jednotlivých sekcích a podsekcích jsou vždy řazena
od těch nejčastějších a nejdůležitějších k těm méně obvyklým.
Díky tomu vám stačí z každé sekce přečíst jen několik prvních zaklínadel
a skončit třeba uprostřed kapitoly, a přesto už to nejdůležitější budete vědět.
(Do budoucna počítám s rozdělením kapitol na „základní“ a „rozšířenou“ verzi,
ale zatím jsem nevymyslel/a, jak to technicky provést, aby se neplýtvalo papírem.)

## Je tato kniha pro můj systém?

> *„Když dojdete na místo, kde má být podle mapy studánka, a najdete tam místo ní supermarket, neznamená to, že je mapa chybná, jen je určena pro jinou verzi lesa.“*<br>– Singularis

Verze řady „vanilková příchuť“ 2.x (k nimž patří i tato verze knihy)
jsou určeny především pro **Ubuntu 20.04 Focal Fossa** a jeho varianty
(drtivá většina zaklínadel by měla fungovat i na Linuxu Mint 20).
Řada vanilková příchuť 2.x je v době vydání této verze knihy aktivně vyvíjena
a do jejího vývoje můžete přispět na GitHubu.

To, že je verze „určena především“ znamená, že na Ubuntu 20.04 jsou zaklínadla
zkoušena a pokud tam některé nefunguje, je to chyba, kterou je nutno opravit.
Na jiných distribucích, pokud mají odpovídající nebo novější verze
příslušných programů, bude stále fungovat drtivá většina zaklínadel
(až na výjimky). Na systémech se staršími verzemi programů bude fungovat
menší část zaklínadel, ale přesto má smysl to zkusit.

Také je třeba upozornit, že řada postupů vyžaduje nainstalovat nějaký
balíček, který ve výchozí instalaci není přítomen, nebo změnit nějaké
systémové nastavení. Proto postupy z této knihy nemusí být vhodné
pro uživatele sdílených systémů (např. firemních či školních),
protože ti zpravidla nemohou instalovat balíčky či měnit nastavení
systému.

<!--
Ačkoliv drtivá většina uvedených zaklínadel bude fungovat
(po doinstalaci příslušných balíčků) na většině aktivně vyvíjených
linuxových distribucích, především na Linuxu Mint,
svobodný software se neustále prudce vyvíjí a každá nová verze
každého programu přináší změny, které je potřeba reflektovat.

Ačkoliv drtivá většina uvedených zaklínadel bude bez problémů fungovat i na mnoha
jiných současných linuxových distribucích, především na Linuxu Mint
(začátečníkům nedoporučuji pokoušet Debian, kde může být jejich zprovoznění obtížnější),
vztáhnout verzi knihy na konkrétní verzi konkrétní distribuce je nutné,
protože linuxové programy se prudce vyvíjejí, a co v jedné jejich verzi funguje,
v příští již může fungovat jinak.
-->

## Musím umět programovat?

K použití Linuxu: Knihy kouzel sice přímo nemusíte aktivně programovat,
ale měli byste znát pojmy ze základů programování jako např. „funkce“, „příkaz“
či „skript“ a určitě vám prospěje, pokud máte na programování talent.

## Pomocné skripty a funkce

Některé úkoly, přestože zní jednoduše, jsou pro terminál ve skutečnosti dost složité,
takže je ve výchozí instalaci není možné vykonat krátkým příkazem. Tradičním a stále
efektivním linuxovým řešením takových situací je vytvoření skriptů a funkcí,
které lze zavolat jednoduchým příkazem a vykonají za vás automaticky mnoho,
často i velmi složitých příkazů, které danou úlohu vyřeší.

Každá kapitola, která tyto pomocné či funkce skripty vyžaduje, obsahuje jejich
úplný zdrojový kód, což vám umóžňuje si je vytvořit sám/a pouhým zkopírováním
či ručním přepsáním (což nedoporučuji kvůli riziku překlepů);
pro vaše pohodlí je ovšem ke každé vydané verzi knihy online cestou
distribuován balíček ve formátu „.deb“, který si můžete nainstalovat na svůj systém.
Tento balíček obsahuje aktuální verze pomocných skriptů a funkcí
a příkaz „lkk“, kterým můžete spouštět pomocné skripty nebo importovat
pomocné funkce (příkazem „source &lt;(lkk \-\-funkce)“).
Podrobnosti a další možnosti zjistíte příkazem „lkk \-\-help“
(manuálovou stránku spouštěč *lkk* zatím nemá).

## Licence

*„Linux: Kniha kouzel“* je dílem svobodné kultury; můžete ho/ji šířit a upravovat
pod podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

&nbsp;

<neodsadit>**https://creativecommons.org/licenses/by-sa/4.0/**

&nbsp;

<neodsadit>Zdrojové soubory a návod k sestavení by měly být k dispozici na GitHubu na adrese:

&nbsp;

<neodsadit>**https://github.com/singularis-mzf/linux-spellbook**

&nbsp;

<neodsadit>Všechen software potřebný k sestavení projektu je svobodný.
Pokud některá kapitola odkazuje na nesvobodný software, vždy na to výslovně upozorní.

<!--
Uživatele, který Linux: Knihu kouzel neprostudoval, poznáte např. takto:

* Používá příkaz „mount“ k vypsání připojených souborových systémů.
* Používá filtr „grep test.r“ a diví se, proč propustil řádku „tester.c“, když ta přece „test.r“ neobsahuje.
* Zkouší odstraňovat diakritiku příkazem „tr“ a pak se diví, proč příkaz „tr ž z“ ze vstupu „zdražil“ udělal „zdrazzil“ a ne „zdrazil“. A hlavně – neví, jak to udělat správně!
* Používá k vypsání hexadecimálně kódovaných znaků Unicode „echo -e“ a pak se diví, že je musí ručně kódovat do UTF-8.


* K vytváření archivů používá kryptické příkazové řádky jako „tar cvzf“.
* Myslí si, že příkaz „apt list gimp*“ vypíše seznam balíčků začínajících „gimp“ (v tomto případě se musí hlavně naučit pravidla odzvláštňování).
-->

## Aktuální poznámka k verzi „vanilková příchuť 2.0 Chranislav Charbulový“

Verze 2.0, jménem Chranislav Charbulový, je první verze vanilkové příchuti Linuxu: Knihy kouzel
určená především pro Ubuntu 20.04 Focal Fossa.

Ve srovnání s předchozí verzí byly z vydání vypuštěny kapitoly „Docker“ a „Plánování úloh“.
Kapitola „Barvy a titulek terminálu“ byla přejmenována na „Terminál“ a rozšířena o vybrané emotikony.

V HTML verzi je nově jako výchozí tmavý motiv a byl vylepšen design rámu „okna“.

Vydání verze 2.1, jménem Iveta Ivanovická, očekávám v průběhu listopadu 2020.

Verze řady „vanilková příchuť 1.x“ jsou ve stádiu dlouhodobé pasivní podpory do 1. března 2023.

&nbsp;

<neodsadit>– Singularis
