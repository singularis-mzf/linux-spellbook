<!--

Linux Kniha kouzel, předmluva
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Předmluva

*„Prostě příkazový řádek v Linuxu je něco úchvatného, a kdo se neumí v tomto prostředí pohybovat, přichází o hodně.“*<br>− KAMENÍK, Pavel. *Příkazový řádek v Linuxu: praktická řešení.* Brno: Computer Press, 2011. ISBN 978-80-251-2819-0.

&nbsp;

„Linux: Kniha kouzel“ je sbírka velmi krátkých řešených příkladů pro operační systém Linux.
Svým konceptem je určena začátečníkům a pokročilým uživatelům, přičemž každé z těchto skupin
přináší něco jiného.

Může být velice užitečná každému, kdo v současnosti začíná s Linuxem
a troufne si na příkazový řádek/příkazovou řádku, v Linuxu zvaný/ou „terminál“, zadat „ls“
a chtěl by toho víc, ale nemá představu, co mu může příkazová řádka/příkazový řádek
nabídnout. Jste-li takovým uživatelem a dáte-li této knize šanci, bude se snažit vám
doplnit dostupné referenční příručky, dokumentaci a různé online zdroje o to, co jim,
dle mého názoru, většinou zoufale chybí − bude se snažit být stručná, přehledná a praktická.
Jejím cílem je zpřístupnit vám tajuplnou moc terminálu a konfiguračních souborů
s elegancí a přehledností běžnou pro menu, dialogová okna a jiná grafická uživatelská
rozhraní, aniž byste museli studovat stovky stran dokumentace a pronikat do ezoterických
a tajuplných zákonitostí systému, jejichž pochopení je výsadou takzvaných „power users“.
Na druhou stranu vás ale nepovede jako běžné uživatelské příručky a určitou minimální míru
důvtipu a nahlížení do manuálových stránek po vás její praktické využití zpravidla vyžadovat
bude.

Patříte-li k **začátečníkům**, bude od vás tato kniha vyžadovat přinejmenším znalosti základů
programování (tzn. pojmy jako „proměnná“, „příkaz“ či „podprogram“) a zájem dozvědět se
něco nového o tom, co a jak můžete dělat s programy nabízenými vám moderní distribucí Linuxu.
Máte-li na počítači nainstalovaný Linux, máte na disku gigabajty nesmírně mocných
nástrojů, které v sobě skrývají desítky let práce špičkových programátorů, a nemusíte
nezbytně pochopit, jak fungují, abyste s nimi dokázali velké věci; musíte však znát postup,
jak je použít; příliš troufalí uživatelé totiž skončí na prvním chybovém hlášení.
V této knize chci s využitím svých zkušeností (a v mezích možností i zkušeností
jiných pokročilých uživatelů) k tomu, abych vám ukázal/a reálně dosažitelné cíle a postupy,
které vás k nim opravdu zavedou, rychle a v klidu.

Patříte-li k **pokročilým uživatelům** systému GNU/Linux, tato kniha vám nabídne především
rychlou nápovědu k příkazům a parametrům, které už jste pozapomněli, a programátorskou
inspiraci. Svoje oblíbená řešení si můžete ve vlastním výtisku knihy barevně zvýraznit,
zakroužkovat či dopsat. Především vám ale nabízí možnost svoje znalosti a zkušenosti
sdílet nejen se sobě rovnými, ale také s uživateli méně zkušenými; takovými,
jaký/á jste byl/a vy, než jste podstoupil/a roky experimentování, programování
a studia dokumentace. Vaše příspěvky, zlepšovací návrhy a chybová hlášení jsou
v repozitáři na GitHubu vítány, pokud budou v souladu s konceptem projektu. Pokud ne,
bude vítána vaše odnož (fork), kterou si budete moci uzpůsobit přesně podle svých představ.
(Veškerý obsah repozitáře je dostupný pod svobodnými licencemi, podrobněji viz níže.)

Napadlo vás už někdy, že zadávání příkazů v terminálu se mnoha aspekty podobá
**sesílání kouzel** ve fantasy světech? Tento příměr je o to děsivější, že zatímco
fantasy kouzla ovlivňují jen životy smyšlených postav, vaše příkazy budou mít
reálné důsledky va vašem vlastním počítači! Linux: Kniha kouzel je na tomto přirovnání
založena, a proto se v ní všechny druhy příkladů nazývají „zaklínadla“.
Představte si to, jako že jste začínající čaroděj ve fantasy světě a dostal/a jste
do ruky lexikon kouzel pro pokročilé, s poznámkami, které si pro sebe poznačil váš
zkušený předchůdce. Při sesílání kouzel přesahujících vaši kvalifikaci se sice můžete snadno
„spálit“ (a to platí i u této příručky), přesto je to však v životě mnohem lepší
než se omezit jen na to, co už bezpečně umíte. (Zamyslete se, jak by dopadl
takový Harry Potter, kdyby se omezil jen na kouzla odpovídající jeho školnímu ročníku.)

Tato verze knihy je zaměřena primárně na **Ubuntu 18.04, Bionic Beaver**, a jeho varianty
Kubuntu, Lubuntu, Ubuntu Budgie, Ubuntu MATE, Ubuntu Studio a Xubuntu,
ale většina uvedených zaklínadel bude fungovat bez větších problémů i na mnoha jiných
současných linuxových distribucích, především na Linuxu Mint. (Začátečníkům nedoporučuji
pokoušet Debian, kde může být jejich zprovoznění obtížnější.) U konkrétních zaklínadel
může být uvedena jiná verze či distribuce, pro kterou jsou určena.

Velmi podstatnou vlastností této knihy je její **organizace**. Zaklínadla jsou
v kapitolách organizována do logických skupin a vždy jsou řazena od nejužitečnějších
k nejméně užitečným, což znamená, že už přečtením několika prvních zaklínadel
z několika prvních skupin získáte ty nejdůležitější znalosti. Ačkoliv jsou v knize
i kapitoly zaměřené na konkrétní nástroje (např. GNU make), důraz kladu
spíš na kapitoly tematické, které kombinují vždy ty nejvhodnější nástroje
k dosažení daných cílů.

Když jsem s Linuxem kdysi dávno začínal/a, nesmírně mi pomáhaly některé vynikající příručky;
ve vědeckých knihovnách na ně sice lze stále narazit, ale vzhledem k prudkému vývoji Linuxu,
GNU, KDE, Xfce a dalších linuxových projektů beznadějně zastarávají a dnešnímu uživateli
již nedokážou přehledně a pravdivě představit úžasný systém, který na svém počítači má.
A tak mě mrzelo, že od roku 2012 již žádná nová podobně hodnotná příručka pro uživatele
nevyšla. Online zdroje jsou zdlouhavé, nepraktické, úzce specializované a z velké části
v angličtině a je mi skoro až líto osob, které jsou na ně odkázány.
Proto jsem se rozhodl/a začít tento projekt.

## Licence

Všechny zdrojové soubory tohoto projektu lze šířit pod podmínkami licence
[Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/). Měly by být k dispozici na GitHubu na adrese<br>[https://github.com/singularis-mzf/linux-spellbook](https://github.com/singularis-mzf/linux-spellbook).

<!--
- kouzla
- záhady
- autorita
- „zahrávat si s příkazy, kterým nerozumí“

Stejně jako uživatelské příručky si klade za cíl ukázat začátečníkům, jaké možnosti jim jejich operační systém nabízí, a stejně jako referenční příručka jim má kvalitní organizací pomoci najít a použít funkce, které budou potřebovat.

Netušíte-li například jak naplánovat vyskakovací oznámení na dnešních 15.30, jak začít
psát v Markdownu, jak zmenšit všechny svoje obrázky nebo jak otočit svoje oblíbené video
o 180° (popř. jak ho pustit pozpátku nebo s ním dělat jiné hlouposti), je toto kniha pro vás.

-->
