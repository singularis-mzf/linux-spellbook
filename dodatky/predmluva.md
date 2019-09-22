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

![ve výstavbě](../obrazky/ve-vystavbe.png)

- kouzla
- záhady
- autorita
- „zahrávat si s příkazy, kterým nerozumí“

Napadlo vás už někdy, že zadávání příkazů na příkazovém řádku se určitými aspekty velice podobá sesílání kouzel ve fantasy světech? Linux: Kniha kouzel je sbírka jednoduchých řešených příkladů, která je na tomto přirovnání založena. Bude moci být velice užitečná každému, kdo začíná s Linuxem, protože mu pomůže poznávat a skutečně využívat nové oblasti, ve který si pravděpodobně myslí, že je nad jeho síly se orientovat. Jejím posláním je mýtit nedostatek znalostí a zkušeností, který činí začátečníky v Linuxu tak neschopnými, a zpřístupnit jim moc příkazové řádky, parametrů a konfiguračních souborů s elegancí a logikou běžnou pro menu, dialogová okna a jiná grafická rozhraní.





<!--
Opakování:
Linux: Kniha kouzel je sbírka příkazů, parametrů, konfiguračních voleb a postupů, které byly sestaveny s podrobnou znalostí dané problematiky. Představte si to, jako když ve fantasy světě začínající čaroděj dostane do ruky lexikon kouzel pro pokročilé. Při používání kouzel přesahujících jeho kvalifikaci se sice může snadno „spálit“, ale přesto to bude mnohem lepší, než kdyby se omezil jen na těch pár začátečnických postupů, které už bezpečně zná. (Zamyslete se např. jak by dopadl Harry Potter, kdyby se omezil pouze na ta kouzla, která se naučil v běžné školní výuce.)

Tato kniha tedy u začátečníků předpokládá zájem dozvědět se něco nového.

Cílem je zpřístupnit tato řešení začátečníkům, kteří zatím nemají dostatečné zkušenosti k tomu, aby taková řešení s použitím referenčních příruček v angličtině sestavili a vyrovnali se se všemi chybami, omyly a zvláštnostmi, na které při tom narazí.
-->



Stejně jako uživatelské příručky si klade za cíl ukázat začátečníkům, jaké možnosti jim jejich operační systém nabízí, a stejně jako referenční příručka jim má kvalitní organizací pomoci najít a použít funkce, které budou potřebovat.





Napadlo vás už někdy, že zadávání příkazů na příkazovém řádku se určitými aspekty velice podobá sesílání kouzel ve fantasy světech? Tento příměr je o to hrozivější, že zatímco fantasy kouzla ovlivňují jen životy smyšlených postav, příkazy příkazové řádky mají reálné důsledky ve vašem počítači. A ještě hrozivější je to, že je můžete zadávat vy.

Tato kniha je určena začátečníkům a pokročilým.

Linux: Kniha kouzel je sbírka jednoduchých řešených příkladů, která má za cíl částečně nahradit uživatelské a referenční příručky. Stejně jako uživatelská příručka vám dá přehled o tom, co můžete se svým operačním systémem dělat, a ukáže vám, jak na to. Na rozdíl od ní však tato kniha neobsahuje podrobná vysvětlení a nevede uživatele; pouze mu sdělí postup a...

Tato kniha bude moci být velice užitečná každému, kdo začíná s Linuxem. Podle jeho zájmu mu bude otevírat nové oblasti, ve kterých si pravděpodobně myslí, že je nad jeho síly se orientovat. Jejím posláním je mýtit nedostatek znalostí a zkušeností, který činí začátečníky v Linuxu tak neschopnými, a zpřístupnit jim moc příkazové řádky, parametrů a konfiguračních souborů s elegancí a logikou běžnou pro menu, dialogová okna a jiná grafická rozhraní. S touto knihou budete schopni zřídit a udržovat repozitář gitu, ořezávat obrázky či videa, ovládat okna, přeskládat stránky PDF souborů, napsat dobře fungující Makefile (a vědět, k čemu je) apod.

K psaní této knihy mě přivedla zkušenost, kdy jsem potřeboval/a otočit video o 180°. Po značném hledání jsem objevil/a referenční dokumentaci filtrů ffmpegu. „Prokousal/a“ jsem se seznamem zhruba stovky filtrů a konečně narazil/a na filtr „transpose“, který nabízel čtyři možnosti. Otočení o 180° mezi nimi ovšem nebylo. Tak jsem si s tím chvíli lámal/a hlavu a vyřešil/a problém zřetězením dvou otočení o 90°.

Linux: Kniha kouzel je sbírka příkazů, parametrů, konfiguračních voleb a postupů, které byly sestaveny s podrobnou znalostí dané problematiky. Představte si to, jako když ve fantasy světě začínající čaroděj dostane do ruky lexikon kouzel pro pokročilé. Při používání kouzel přesahujících jeho kvalifikaci se sice může snadno „spálit“, ale přesto to bude mnohem lepší, než kdyby se omezil jen na těch pár začátečnických postupů, které už bezpečně zná. (Zamyslete se např. jak by dopadl Harry Potter, kdyby se omezil pouze na ta kouzla, která se naučil v běžné školní výuce.)

Tato kniha tedy u začátečníků předpokládá zájem dozvědět se něco nového.

Cílem je zpřístupnit tato řešení začátečníkům, kteří zatím nemají dostatečné zkušenosti k tomu, aby taková řešení s použitím referenčních příruček v angličtině sestavili a vyrovnali se se všemi chybami, omyly a zvláštnostmi, na které při tom narazí.

Jsou lidé, kteří mají s příkazovým řádkem spojeny mnohé předsudky. Ve skutečnosti však pro to, abyste ho mohli použít, nemusíte rozumět počítači o nic víc, než potřebujete pro klikání myší. Příkazová řádka je jen dalším uživatelským rozhraním, které se liší způsobem, jakým uživatel zadává počítači svoje požadavky, ne však obsahem těchto požadavků.

Pokročilým uživatelům tato kniha nabízí především rychlou nápovědu k příkazům, které už pozapomněli, protože je dlouho nepoužili, a také soukromou sbírku oblíbených příkazů (které si mohou ve vlastním výtisku knihy zakroužkovat, podtrhnout, barevně zvýraznit, případně dopsat, pokud v původním výtisku chybí). Posledním možným využitím je rychlý přechod od jednoho programátorského řešení k jinému − v tomto případě vám kniha pomůže rychle se v novém prostředí zorientovat a udělat si přehled, jaké funkce máte k dispozici a jak je vhodně použít.

V začátcích práce s Linuxem (tehdy na vysoké škole) mi velmi pomohly některé vynikající příručky. To však už bylo dávno a od roku 2012 nevyšly na českém knižním trhu skoro žádné knihy, které by se zabývaly Linuxem z hlediska běžného uživatele. Starší knihy zase s vývojem Linuxu značně zastarávají.

Co se týče distribuce, příklady (není-li u nich uvedeno jinak) mají být funkční a otestované na Ubuntu 18.04 LTS s výhledem na přechod na Ubuntu 20.04 LTS. Většina příkazů ale bude fungovat i na jiných distribucích, byť možná bude vyžadovat instalaci jiných balíčků.
