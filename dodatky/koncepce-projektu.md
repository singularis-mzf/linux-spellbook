<!--

Linux Kniha kouzel, část Koncepce projektu Linux: Kniha kouzel
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Koncepce projektu Linux: Kniha kouzel

!ÚzkýRežim: zap

## Co je Linux: Kniha kouzel a role vanilkové příchuti

Linux: Kniha kouzel je česká sbírka velmi krátkých řešených příkladů
z prostřední linuxového operačního systému, ve formě připomínající
konverzační slovník cizího jazyka.

*Vanilková příchuť* je označení pro verze Linuxu: Knihy kouzel,
které vydává Singularis v repozitáři „singularis-mzf/linux-spellbook“ na GitHubu.
Počítám s tím, že nezávisle vydávané odnože spravované jinými osobami budou moci
(při dodržení licenčních podmínek) používat označení „Linux: Kniha kouzel“,
ne však ve spojení s označením „vanilková příchuť“.

## Základní cíle projektu (heslovitě)

* Sbírat a sdílet co nejužitečnější přehled možností, které nabízí uživatelům svobodný software v linuxových distrubucích příbuzných s Debianem.
* Pomáhat mírně pokročilým a středně pokročilým uživatelům uvedených systémů, aby mohli pro daný úkol použít ty nejlepší dostupné nástroje s co nejmenším úsilím.
* Okrajově také všem uživatelům pomoci najít nástroje a funkce svobodného software, které potřebují.

## Závazná pravidla pro celý repozitář

* Koncepce není neměnná. Bude se mírně přizpůsobovat zjištěným potřebám obou cílových skupin; zájmy středně pokročilých uživatelů přitom musejí zůstat v rovnováze se zájmy pokročilých, aby byli pokročilí motivováni přispívat a většina jejich příspěvků byla užitečná i středně pokročilým.
* Zaklínadla jsou v každé úrovni řazena od užitečnějších k méně užitečným. Úzce související zaklínadla (např. na přidání a odebrání objektu) jsou však seskupena k sobě a jejich užitečnost je posuzována společně.
* Při psaní kódu jednotlivých zaklínadel mějme na paměti, že náš kód budou používat i lidé, kteří mu nerozumí a nezvládnou opravit naše chyby. Proto pišme kód robustní, důkladně ho testujme a známá omezení dokumentujme (např. v poznámkách pod čarou).
* Duplicita není zakázána. Stejné zaklínadlo se může objevit ve více podsekcích jedné kapitoly či ve více kapitolách, pokud to bude dávat smysl.
* Nepište kapitoly o oblastech, o kterých se jen „domníváte, že by druzí o ně mohli mít zájem“. Pište kapitoly, o které máte nebo budete mít zájem *vy*! Jen tak budete motivováni napsat kapitolu v dostatečné kvalitě, aby mohla být zařazena do vanilkové příchuti.
* Je vítán každý příspěvek, který pomůže ve vývoji některé kapitoly, tedy i malý příspěvek. Velké a kvalitní příspěvky jsou ale vítány víc.
* Linux: Kniha kouzel je zaměřena na svobodný software. Nesvobodný software může být zmíněn a případně i doporučen (pokud svobodná alternativa neexistuje nebo není vhodná), v každém takovém případě ale musí být uvedeno upozornění, že uvedený software není svobodný. Stačí upozornění uvést v poznámce pod čarou nebo na odkazované stránce, jde-li o hypertextový odkaz.

## Závazná pravidla pro vanilkovou příchuť

* **okamžitě funkční kód** — Každé zaklínadlo musí být v ideálních podmínkách plně funkční okamžitě po doplnění vyžadovaných parametrů a jeho funkce musí odpovídat tomu, co může uživatel pravděpodobně očekávat podle titulku a zařazení zaklínadla. Tím je zejména míněno, že nesmějí např. chybět podstatné parametry, zmínka o nutných změnách nastavení či potřebných právech nebo specifické omezení vstupu jen na určité znaky („nesmí obsahovat dvojtečku“ apod.). Pokud má funkce zaklínadla omezení, které uživatel nemůže rozumně předpokládat na základě obecných znalostí, úvodu kapitoly, uvedených definic či titulku a zařazení zaklínadla, je třeba toto omezení uvést v poznámce pod čarou nebo jiným vhodným způsobem. Zaklínadlo však může od uživatele očekávat základní obecné znalosti, např. znalost pravidel odzvláštnění v bashi, a také nemusí být uvedeno, když zaklínadlo vyžaduje práva, která má výchozí uživatelský účet (vytvořený při instalaci) ve výchozím nastavení již přidělena.
* **výstižná česká terminologie** — Vanilková příchuť Linuxu: Knihy kouzel usiluje o nalezení a používání výstižných českých termínů, a to i tehdy, kdy nejsou široce používány (např. „odzvláštnění“). Pokud však takový termín není znám, vanilková příchuť upřednostňuje výstižnější anglický termín před nevkusným překladem, čímž se snaží vytvářet poptávku po nalezení lepšího překladu.
* **genderová spravedlnost** — V každé kapitole musí být přibližně vyrovnaný počet použití slov „řádka“ a „řádek“. Cílem tohoto opatření je napomoci gendrové spravedlnosti v jazyce. Naopak přechylování označení osob se doporučuje se vyhýbat, píšeme „uživatel“, ne „uživatelka“. Čtenáři vykáme a oslovujeme ji/ho v druhé osobě jednotného čísla, a kde je to možné, uvádíme obě rodové varianty oddělené lomítkem, ne však v podstatných jménech. (Výjimka platí pro předmluvu, kde uvádím u názvů osob přechýlenou i nepřechýlenou variantu, protože se příliš bojím nechápavých jedinců, které by mohlo urazit, kdyby v předmluvě nebyli osloveni „čtenářko“; nejsem si jistý/á jejich existencí, jen mám strach, že kvůli takové hlouposti na Linux: Knihu kouzel zanevřou.)
* Pro odstranění nejednoznačnosti je zakázáno mínit plurálem generického maskulina pouze muže. To znamená, že např. slovem „homosexuálové“ musíme vždy mínit muže i ženy nebo jen ženy; nikdy ne jen muže. (Ačkoliv pochybuji, že se ve sbírce řešených příkladů pro linux slovo „homosexuálové“ vůbec objeví.)
* V sekci „Instalace na Ubuntu“ a případně v poznámkách pod čarou nebo v kódu zaklínadel musejí být zmíněny všechny balíčky, které může být nutné doinstalovat do čisté minimální instalace příslušné verze Ubuntu, a všechny změny nastavení, které je třeba provést, aby byla zaklínadla v kapitole použitelná. Pokud proces instalace vyžaduje interakci s uživatelem, musí být popsána „algoritmicky“ a nevyžadovat od uživatele žádné specifické znalosti, kromě těch, které jsou v dané kapitole vysvětleny.
* Vanilková příchuť se dělí na vývojové řady, kde každá řada je vázana na určitou verzi Ubuntu. Řada 1.x je vázana na Ubuntu 18.04 Bionic Beaver; řada 2.x je vázana na Ubuntu 20.04 Focal Fossa.
* Vydané verze vanilkové příchuti vydávané po dobu aktivního vývoje dané řady dostávají názvy složené z českého jména a příjmení, kde obě části začínají stejným písmenem. Jména vhodná pro ženu musejí být v průměru v rovnováze se jmény vhodnými pro muže, neutrální jména však mohou být počítána jak jako vhodná pro ženu tak jako vhodná pro muže.

## Doporučení

* Použitelnost, spolehlivost a robustnost kódu má přednost před srozumitelností, jednoduchostí a výkonem.
* Kde je to možné, snažíme se psát kód zaklínadla spíše kratší, i za cenu toho, že bude méně srozumitelný a jeho vykonání bude o něco pomalejší.
* Formátování a uspořádání kapitol a zaklínadel v nich má být převážně jednotné, aby se usnadnila uživateli rychlá orientace.
* Primárním cílem PDF výstupu je tištěná podoba, proto je formátování PDF optimalizováno výhradně pro ni, ne pro čtení na počítači. Primárním cílem HTML výstupu je zobrazení na počítači a možnost zaklínadla vykopírovat (Ctrl+C/Ctrl+V) a přímo použít. Proto musí být kód zaklínadla vykopírovaný z HTML výstupu po doplnění položek „doplň“ okamžitě a bez dalších úprav použitelný a funkční.
* U příkazů, které vyžadují oprávnění superuživatele, používáme sudo, kdekoliv je to možné, dokonce i u příkazů určených ke spuštění v jednouživatelském režimu, kde to není nezbytné. Účelem je přehledná dokumentace faktu, že příkaz spuštění superuživatelem vyžaduje. Výjimkou jsou příkazy určené výhradně ke spouštění v kontejneru Dockeru, kde se sudo obvykle nepoužívá a mohlo by být matoucí.

## Označení „linux“, „Linux“ a „GNU/Linux“

V projektu Linux: Kniha kouzel jsem se rozhodl/a vlastní jméno „Linux“ používat výhradně
k označení jádra, v tom se shoduji s komunitou Debianu a postojem Free Software Foundation,
nakolik jsou mi známy. V ostatních příbuzných významech ovšem hodlám používat
obecné mnohoznačné podstatné jméno „linux“ — v naději, že by se takové řešení mohlo uchytit
v česky píšících komunitách. V tomto projektu bude používáno především v těchto dvou
významech:

> **linux**

> **1.** *operační systém na bázi Linuxu tvořený převážně nebo zcela svobodným software nebo jeho varianta či distribuce* (Příklady: „Ubuntu je linux.“ „Čtyři známé distribuce linuxu jsou Ubuntu, Fedora, Debian a Linux Mint.“)

> **2.** *konkrétní instalace takového operačního systému* (Příklady: „V tomto počítači jsou dva linuxy, jeden na oddílu sda3 a druhý na oddílu sda4.“ „V roce 2000 jsem měla na počítači linux a Windows, konkrétně Debian 2.1 Slink a Windows NT 4.0 Workstation.“)

Namísto označení GNU/Linux, prosazovaného komunitou Debianu a dle mého názoru
vhodného spíše v anglických a ryze odborných textech, pak doporučuji v každé kapitole,
kde je významně zastoupen nástroj z projektu GNU (např. Awk, Bash, Make apod.),
jeho příslušnost ke GNU zmínit v úvodu kapitoly. Pomůže to projektu GNU víc
než jeho povrchní spojování s linuxem.

!ÚzkýRežim: vyp
