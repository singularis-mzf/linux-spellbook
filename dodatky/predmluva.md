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

## Neznalost a potřeba orientace

> *„Prostě příkazový řádek v Linuxu je něco úchvatného, a kdo se neumí v tomto prostředí pohybovat, přichází*
> *o hodně.“*<br>— KAMENÍK, Pavel. *Příkazový řádek v Linuxu: praktická řešení.* Brno: Computer Press, 2011. ISBN 978-80-251-2819-0.

<neodsadit>Pokud v letech 2018 až 2022 začínáte s Linuxem a troufnete si na
příkazový řádek/příkazovou řádku, v Linuxu zvaný/ou „terminál“,
zadat „ls“ a chtěl/a byste toho víc, ale nemáte dobrou představu, co vám může
to černé (popř. bílé či jinak jednobarevné) okno nabídnout, a frustruje vás to,
ale zase nechcete hned pronikat do jeho nejhlubších ezoterických tajemství
ani trávit dny čtením nudné programátorské dokumentace v angličtině
a experimentováním a všechno vám to připadá nezvladatelně složité
a nepochopitelné a přehnaně zdlouhavé jako toto souvětí,
pak vám tato kniha může být velice užitečná.

Zatímco grafické uživatelské rozhraní, na jaké jste nejspíš zvyklý/á, vám nabízí
barevné ikony, panely nástrojů, menu, zvuky, dialogová okna a další příjemné věci,
terminál takový není. Vypadá, že jen očekává příkazy, a nedává vám žádné vodítko,
jaké příkazy to mohou být, a čeho se s nimi dá dosáhnout.
Nemáte žádnou šanci se dozvědět, že můžete zadat příkaz „tput sgr0“ nebo „test -t 1“,
ani co dělá nebo k čemu vám může být dobrý.
Cílem této knihy je to napravit a učinit úžasný „svět“ terminálu
a konfiguračních souborů podobně přehledným a srozumitelným,
jako jsou dialogová okna, nabídky a panely nástrojů.
Současně se snaží shromáždit přehledy konkrétních, ověřených a funkčních příkazů
a parametrů, kterými lze těchto možností přímo využít.

<!--
*Veškerá moc terminálu přehledně, pro začátečníky i pokročilé.*
-->

„Linux: Kniha kouzel“ vám bude sloužit trochu jako mapa či jako konverzační slovník.
Nečekejte však, že vás povede krok za krokem jako návod.
Nejde ani o referenční příručku, protože místo mnoha způsobů, jak jde něco udělat,
uvádí zpravidla jen jeden, který připadal autorovi kapitoly nejlepší.
A také vás nahlížení do manuálových stránek a dokumentace nejspíš úplně neušetří,
jen s nimi strávíte opravdu podstatně méně času; minuty místo dní.

Nejste-li náhodou programátor (což rozhodně nemusíte být), určitě si předem zjistěte,
co znamenají pojmy ze základů programování jako např. „funkce“, „příkaz“ či „skript“.
K pochopení, jak terminál používat, to budete potřebovat vědět.

## Tajuplná moc terminálu (shrnutí)

Máte-li na počítači nainstalovaný Linux, máte na disku gigabajty nesmírně mocných
nástrojů jako bash, Perl či TeX, které v sobě skrývají desítky let práce špičkových
programátorů, a nemusíte nezbytně pochopit, jak fungují, abyste s nimi dokázal/a
velké věci. Pokud vás zajímá, co s nimi můžete udělat, a konkrétní postup,
jak toho dosáhnout, je toto kniha pro vás.

## Sesílání kouzel

Napadlo vás už někdy, že zadávání příkazů v terminálu se mnoha aspekty podobá
**sesílání kouzel** ve fantasy světech? Tento příměr je o to děsivější, že zatímco
fantasy kouzla ovlivňují jen životy smyšlených postav, vaše příkazy terminálu budou mít
reálné důsledky ve vašem vlastním počítači! Linux: Kniha kouzel je na tomto přirovnání
založena, a proto se v ní všechny druhy příkladů nazývají „zaklínadla“.
Můžete si to představit, třeba jako že jste začínající čaroděj ve fantasy světě a dostal/a
jste do ruky lexikon kouzel pro pokročilé, s poznámkami, které si pro sebe poznačil
váš zkušený předchůdce. Při sesílání kouzel přesahujících vaši kvalifikaci
se sice můžete snadno „spálit“ (a to platí i u této sbírky),
přesto vám to však prospěje mnohem víc, než kdybyste se omezil/a jen na to,
co už bezpečně umíte. (Zamyslete se, jak by dopadl takový Harry Potter,
kdyby znal jen kouzla odpovídající jeho školnímu ročníku.)

## Je tato kniha pro váš systém?

> *„Když dojdete na místo, kde má být podle mapy studánka, a najdete tam místo ní supermarket, neznamená to, že je mapa chybná, jen je určena pro jinou verzi lesa.“*<br>− Singularis

<neodsadit>Verze knihy „vanilková příchuť“ řady 1.x jsou určeny především pro
**Ubuntu 18.04, Bionic Beaver**, a jeho varianty Kubuntu, Lubuntu, Ubuntu Budgie,
Ubuntu MATE, Ubuntu Studio a Xubuntu.

Ačkoliv drtivá většina uvedených zaklínadel bude bez problémů fungovat i na mnoha
jiných současných linuxových distribucích, především na Linuxu Mint
(začátečníkům nedoporučuji pokoušet Debian, kde může být jejich zprovoznění obtížnější),
vztáhnout verzi knihy na konkrétní verzi konkrétní distribuce je nutné,
protože linuxové programy se prudce vyvíjejí, a co v jedné jejich verzi funguje,
v příští již může fungovat jinak.

## Nejdůležitější zaklínadla

Velmi podstatnou vlastností této knihy je její **organizace**.
Zaklínadla v kapitolách jsou shromážděna do logických skupin
a až na odůvodněné výjimky jsou vždy řazena od nejčastějších a nejdůležitějších
k méně obvyklým. Díky tomu nemusíte kapitolu číst celou − ty nejužitečnější znalosti
získáte hned z několika prvních zaklínadel z několika prvních skupin.

Ačkoliv jsou v knize i kapitoly zaměřené na konkrétní nástroje (např. GNU make),
důraz kladu spíše na kapitoly tematické, které kombinují vždy ty nejvhodnější
nástroje k dosažení daných cílů.

## Pomocné skripty a funkce

Některé úkoly, přestože zní jednoduše, jsou pro terminál ve skutečnosti dost složité,
takže je ve výchozí instalaci není možné vykonat krátkým příkazem. Tradičním a stále
efektivním linuxovým řešením takových situací je použití skriptů, které lze zavolat
jednoduchým příkazem a vykonají za vás automaticky mnoho, často i velmi složitých příkazů,
které danou úlohu vyřeší.

Každá kapitola, která tyto pomocné skripty vyžaduje, obsahuje jejich úplný zdrojový kód,
což vám umóžňuje si je vytvořit sám/a pouhým zkopírováním či ručním přepsáním
(což nedoporučuji kvůli riziku překlepů); pro vaše pohodlí je ovšem
ke každé vydané verzi knihy online distribuován balíček ve formátu „.deb“,
který si můžete nainstalovat na svůj systém a umožní vám spouštění skriptů z knihy
příkazem „lkk“, takže je nebudete muset ručně kopírovat.

## Pro pokročilé uživatele

Tato kniha může být užitečná také **pokročilým uživatelům**, kteří již
systém GNU/Linux řadu let používají. Jste-li takovým uživatelem, kniha vám nabízí
jiné výhody než začátečníkům − především rychlou nápovědu k příkazům a parametrům,
které už jste pozapomněl/a, moderní a pohodlné alternativy k zastaralým
a těžkopádným postupům, na které jste možná zvykl/á ze starších verzí GNU/Linuxu, a programátorskou inspiraci (jako i spousta jiných projektů na GitHubu).

## Příběh

Když jsem s Linuxem kdysi dávno začínal/a, nesmírně mi pomáhaly některé vynikající příručky;
ve vědeckých knihovnách na ně sice lze stále narazit, ale vzhledem k prudkému vývoji Linuxu,
GNU, KDE, Xfce, FreeDesktop.org, Perlu, Pythonu, LaTeXu a dalších linuxových projektů beznadějně
zastarávají a dnešnímu uživateli již nedokážou přehledně a pravdivě představit
úžasný systém, který na svém počítači má.
A tak mě mrzelo, že od roku 2012 již žádná nová podobně hodnotná příručka pro uživatele
nevyšla. Online zdroje jsou zdlouhavé, nepraktické, úzce specializované a z velké části
v angličtině a je mi skoro až líto osob, které jsou na ně odkázány.
Proto jsem se rozhodl/a založit tento projekt.

## Licence

„Linux: Kniha kouzel“ je dílem svobodné kultury; můžete ho/ji šířit a modifikovat
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

## Aktuální poznámka k verzi „vanilková příchuť 1.3“

Ve verzi 1.3 nepřibyly žádné nové kapitoly.

Hlavní novinkou je spouštěč pomocných skriptů „lkk“ distribuovaný spolu se skripty ve formě balíčku „deb“.

V PDF variantě se mi podařilo další podstatné zlepšení designu. Nadpisy jsou nyní přehlednější, stránky mají název kapitoly v záhlaví a titulky zaklínadel jsou střídavě podbarvené, což jim umožňuje být přehlednější.

V HTML variantě nastaly jen menší změny, nejvýraznější je nová organizace rozcestníku v záhlaví kapitoly, která nově obsahuje i podsekce. Další výraznou změnou je opatrný začátek podpory ikon zaklínadel (ty se ještě budou vyvíjet).

Vydání verze 1.4 očekávám již ke konci února 2020, případně na začátku března.

&nbsp;

<neodsadit>− Singularis
