<!--

Linux Kniha kouzel, kapitola Metapříkazy
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:


⊨
-->

# Metapříkazy

!Štítky: {tematický okruh}{bash}
!FixaceIkon: 1754
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod

Předmětem této kapitoly jsou příkazy jako „sudo“ či „exec“,
které přijímají další příkaz i s jeho argumenty. Většina těchto příkazů
najde externí program toho názvu a spustí ho v nějakým způsobem pozměněném
prostředí, např. s právy superuživatele, s nižší prioritou nebo v jiném
adresáři. Některé metapříkazy je možno použít i s vestavěnými příkazy
Bashe.

Interpret Bash je vyvíjen v rámci projektu GNU.

## Definice

* **Metapříkaz** je příkaz, kterému lze smysluplně zadat jiný příkaz k vykonání.
* **Pseudometapříkaz** je syntaktická konstrukce bashe podobná formou i účelem metapříkazům.

Kde je v zaklínadlech uvedeno {*příkaz a parametry*}, zadává se metapříkazu název vnořeného příkazu a každý jeho argument samostatně, např.:

*# *<br>
**sudo** {*příkaz a parametry*}<br>
**sudo printf TEST\\\\n**

Naopak kde je uvedeno {*"příkaz s parametry"*}, zadává se celý příkazový řádek *jako jeden argument* (tento argument pak zpravidla bude interpretován interpretem „sh“):

*# *<br>
**sg** {*skupina*} {*"příkaz s parametry"*}<br>
**sg adm 'printf TEST\\\\n'**

Pozor na tento rozdíl!

!ÚzkýRežim: vyp

## Zaklínadla

### Spustit jako jiný uživatel/skupina

*# jako **superuživatel***<br>
**sudo** {*příkaz a parametry*}

*# jako **uživatel***<br>
**sudo -u** {*uzivatel*} [**-g** {*skupina*}] {*příkaz a parametry*}

*# jako **skupina** (alternativy)*<br>
**sudo -g** {*skupina*} {*příkaz a parametry*}<br>
**sg** {*skupina*} {*"příkaz s parametry"*}

*# jako uživatel/skupina (jen pro superuživatele)*<br>
*// Poznámka: „sudo“ u příkazu „runuser“ je pouze symbolické; ve skutečnosti se nezadává, protože příkaz „runuser“ spouští pouze root (resp. skripty běžící pod účtem root) a sudo by zde bylo zbytečné.*<br>
**sudo runuser -u** {*uzivatel*} [**-g** {*skupina*}] {*"příkaz s parametry"*}<br>
**sudo runuser -g** {*skupina*} {*"příkaz s parametry"*}

### Interakce s interpretem

*# spustit proces **místo** aktuálního interpretu*<br>
*// Nový proces získá PID aktuálního interpretu a většinu jeho kontextu. Parametr „-c“ před vykonáním náhrady smaže všechny proměnné prostředí (dokonce i HOME, PATH apod., takže to možná není moc dobrý nápad).*<br>
**exec** [**-c**] {*příkaz a parametry*} [*přesměrování*]

*# **interpretovat** text a vykonat jako příkazovou řádku ve stávající instanci interpretu*<br>
**eval** {*"příkaz s parametry"*}

*# interpretovat a vykonat interpretem „**sh**“*<br>
[*sudo*] **sh -c** {*"příkaz a parametry"*}

*# interpretovat a vykonat interpretem „**bash**“*<br>
[*sudo*] **bash -c** {*"příkaz a parametry"*}

*# interpretovat příkaz, ale **nevykonat ho***<br>
*// Hlavní smysl tohoto metapříkazu spočívá v situacích, kdy má interpretace příkazu očekávané vedlejší účinky (např. nastavení zvláštní proměnné $\_ nebo uložení do historie příkazů v interaktivním režimu interpretu).*<br>
**true** {*příkaz a parametry*}

### Vykonat příkazy hromadně

*# sestavit parametry příkazu ze záznamů ze vstupu, vykonat po dávkách*<br>
*// Neuvedete-li parametr „-n“, použije „xargs“ v každé dávce co nejvíc parametrů, kolik mu umožní systémové limity. Neuvedete-li parametr „-P“, výchozí hodnota je 1, což znamená, že další dávka se spustí, teprve až ta předchozí doběhne. Parametr „-a“ použijte v případě, že vykonávaný příkaz potřebuje přístup ke standardnímu výstupu.*<br>
**xargs -r0** [**-a** {*vstupní-soubor*}] <nic>[**-n** {*max-parametrů-na-dávku*}] <nic>[**-P** {*úroveň-paralelismu*}] {*příkaz a počáteční parametry*}

*# pro každý vstupní záznam spustit příkaz a záznam dosadit do parametrů (obecně/příklad použití)*<br>
*// Obsah vstupního záznamu bude dosazen do parametrů vnořeného příkazu za všechny výskyty podřetězce nastaveného parametrem „-I“ (obvykle „{}“).*<br>
**xargs -r0 -I '{}'** [**-a** {*vstupní-soubor*}] <nic>[**-P** {*úroveň-paralelismu*}] {*příkaz a parametry*}<br>
**find . -maxdepth 1 -type f -print0 \| xargs -r0 -I '{}' -P 4 ln -frsTv "{}" "{}.odkaz"**

### Spustit jinak...

*# pokud příkaz poběží ještě po N sekundách, poslat mu signál (obecně/příklady použití)*<br>
*// Výchozí signál je SIGTERM (tedy požadavek na ukončení). Zadáte-li parametr „-k“, pak se po zaslání signálu odpočítá ještě „trvání2“ a příkaz se ukončí signálem SIGKILL. Obě trvání jsou v sekundách. Signály se zašlou i potomkům, které příkaz mezitím spustí.*<br>
**timeout** [**-s** {*signál*}] <nic>[**-k** {*trvání2*}] <nic>[**-v**] {*trvání1*} {*příkaz a parametry*}<br>
**timeout -s KILL 5.5 yes "Ahoj, světe!"**<br>
**{ timeout 1.125 yes "abc" \|\| true; } \| wc -l**

*# s upravenými proměnnými **prostředí***<br>
**env** [**-u** {*promenna\_k\_odebrani*}]... [{*promenna\_k\_nastaveni*}**=**{*hodnota*}]... {*příkaz a parametry*}

*# v jiném adresáři*<br>
**env** [**-C** {*nový/aktuální/adresář*}] {*příkaz a parametry*}

*# s vypnutým účinkem operace „sync“ (obecně/příklad)*<br>
*// Potlačení účinku operace „sync“ tímto příkazem závisí na určitých proměnných prostředí, proto se rozšíří do všech procesů, které tyto proměnné zdědí.*<br>
**eatmydata** {*příkaz a parametry*}<br>
**sudo eatmydata apt-get dist-upgrade**

*# s nižší/vyšší **prioritou***<br>
*// Zvýšení/snížení se počítá relativně vůči prioritě interpretu, ve kterém je příkaz použit, a výsledek se omezí do intervalu 19 (nejnižší možná priorita) až -20 (nejvyšší možná priorita). Takže když zadáte „nice -n 10 bash“, dostanete interpret s prioritou „10“, a když v něm zadáte „nice -n 6 bash“, nový interpret bude mít prioritu 16. Když pak v něm zadáte ještě „nice -n 9 bash“, třetí interpret bude mít prioritu 19.*<br>
**nice -n** {*číslo 0 až 19*} {*příkaz a parametry*}<br>
**sudo nice -n** {*číslo -1 až -20*} {*příkaz a parametry*}

*# jako **démona** (obecně/příklad)*<br>
*// Při použití příkazu „nohup“ důrazně doporučuji ručně přesměrovat standardní vstup a oba standardní výstupy mimo terminál; pokud to neuděláte, příkaz „nohup“ to udělá za vás, ale vypíše přitom rušivou zprávu „nohup: vstup ignoruji a výstup připojuji k 'nohup.out'“. Ostatní deskriptory přesměrovávat nemusíte, ale pokud některý z nich povede na terminál, který mezitím zavřete, program pravděpodobně skončí s chybou, jakmile se z něj pokusí číst či do něj zapisovat.*<br>
**nohup** {*příkaz a parametry*} **&lt;**{*vstup*} **&gt;**{*kam/směřovat/výstup*} **2gt;**{*kam/směřovat/chybový/výstup*}<br>
**nohup sort &lt;můj-soubor.txt &gt;seřazený-soubor.txt 2&gt;/dev/null**

*# s prázdným prostředím (obecně/příklad)*<br>
**env -i** {*příkaz a parametry*}<br>
**env -i printenv**

*# s nebufferovaným standardním vstupem a výstupem*<br>
*// Užitečnost tohoto příkazu je velmi nízká, protože bude účinkovat jen na programy, které si nastavení bufferování svých vstupů nemění samy, a ani u nich nemusí výsledky odpovídat očekávání. Raději se podívejte do dokumentace příslušného programu, zda nepodporuje nějaký způsob zapnutí „nebufferovaného režimu“.*<br>
**stdbuf -i 0 -o 0** {*příkaz a parametry*}

### Pseudometapříkazy

**Pozor na pořadí**: Jsou-li pseudometapříkazy použity spolu s dalšími
metapříkazy, musejí být jako první! Navíc je u nich nutno dodržet
toto pořadí: „&blank;“, „time“, „!“ (může být i víckrát), „\\“.

**Zvláštnosti:** Příkaz „&blank;“ (mezera) účinkuje na celou příkazovou řádku,
i když obsahuje více příkazů. Příkazy „time“ a „!“ účinkují na celou
posloupnost příkazů spojených rourami. Pseudometapříkaz „\\“ se *neodděluje*
mezerou a účinkuje jen na samotné označení příkazu (tzn. nemá vliv
na jeho parametry).

*# změřit **čas běhu** příkazu*<br>
**time** [**-p**] {*příkaz a parametry*} [**\|** {*další příkaz a parametry*}]...

*# příkaz vykonat, ale neuložit do historie*<br>
*// Mezera musí prvním znakem příkazové řádky vůbec (tzn. před ní nesmí být žádný další příkaz ani jiný znak), a aby tento způsob potlačení ukládání do historie fungoval, musí být proměnná HISTCONTROL nastavena na hodnotu „ignorespace“ nebo „ignoreboth“ (což je ve výchozím nastavení v Ubuntu v interaktivním režimu bashe splněno).*<br>
**&blank;**{*příkaz a parametry*}

*# logicky obrátit hodnotu ukládanou do $?*<br>
*// Do $? se uloží 1 pro nulový návratový kód a 0 pro nenulový. Tento příkaz nemá žádný vliv na pole PIPE\_STATUS (tam zůstanou původní hodnoty). Tento příkaz ovlivní zřetězení operátory „&amp;&amp;“ a „\|\|“, protože tyto operátory čtou proměnnou $?*<br>
**!** {*příkaz a parametry*} [**\|** {*další příkaz a parametry*}]...

*# při spouštění příkazu nerozvíjet aliasy (obecně/příklad)*<br>
**\\**{*příkaz a parametry*}<br>
**\\printenv PATH**

*# příklad kombinace všech pseudometapříkazů*<br>
**&blank;time ! ! \\ls**

### Sledování výstupu

Příkaz *watch*:  d — zvýrazňovat změny oproti předchozímu běhu
(užitečný parametr); t - nepřidávat záhlaví.
Neuvedete-li parametr -n, výchozí interval jsou 2 sekundy.
Parametr -n přijímá i desetinná čísla (minimální dovolená hodnota je „0.1“).

*# spouštět příkaz v pravidelném intervalu*<br>
**watch -px**[**t**]<nic>[**d**] <nic>[**-n** {*interval-v-sekundách*}] {*příkaz a parametry*}

*# mezi spuštěními příkazu dělat pauzu*<br>
**watch -x**[**t**]<nic>[**d**] <nic>[**-n** {*pauza-v-sekundách*}] {*příkaz a parametry*}

### Ostatní metapříkazy

*# spustit jedině vestavěný nebo externí příkaz (ne funkci či alias)(obecně/příklad použití)*<br>
*// Tento příkaz se nejčastěji používá, když určitý externí program nahradíte stejnojmennou funkcí a chcete ho pak z této funkce zavolat.*<br>
**command** {*příkaz a parametry*}<br>
**function echo { command echo "Toto je příkaz echo:" "$@"; }**

*# nastavit příkaz jako **obsluhu signálu** v aktuální instanci interpretu*<br>
**trap** {*"příkaz s parametry"*} {*signál*}...

<!--
[ ] VYZKOUŠET!
-->
*# spustit příkaz v jiné **instalaci** linuxu (zatím nezkoušeno)*<br>
*// Správné použití tohoto příkazu je náročné na znalosti, viz sekci „Příkaz chroot“.*<br>
**cd** {*/kořenový/adresář/instalace*}<br>
[**for x in dev proc sys dev/shm dev/pts; do sudo mount \-\-bind {,.}/$x; done**]<br>
**sudo ln -fsv /proc/mounts etc/mtab**<br>
**sudo cp -fv -t etc /etc/hosts /etc/resolv.conf**<br>
**sudo chroot .** [**runuser -u** {*uzivatelske-jmeno*}] {*příkaz a parametry*}

*# spustit příkaz v jiné instalaci linuxu (příklad, nezkoušeno)*<br>
**mkdir /tmp/druhý**<br>
**sudo mount -t ext4 -o rw,exec,suid,nodev /dev/sda3 /tmp/druhý**<br>
**cd /tmp/druhý**<br>
**for x in dev proc sys; do sudo mount \-\-bind {,.}/$x; done**<br>
**sudo chroot . runuser -u karel bash**

*# spustit jedině vestavěný příkaz*<br>
**builtin** {*příkaz a parametry*}

<!--
## Parametry příkazů
<!- -
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)

-->

## Instalace na Ubuntu

Všechny použité příkazy jsou základními součástmi Ubuntu přítomnými i v minimální
instalaci; výjimkou je příkaz eatmydata, který je nutno doinstalovat:

*# *<br>
**sudo apt-get install eatmydata**

<!--
## Ukázka
<!- -
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)

-->

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Typickou začátečnickou chybou je očekávání, že „sudo“ bude účinkovat na přesměrování nebo substituované příkazy, např. „sudo echo "$(whoami)" &gt;/root/test.txt“. V uvedeném příkazu proběhne jak příkaz „whoami“, tak přesměrování do souboru s právy aktuálního uživatele; práva superuživatele v tomto příkladu získá teprve až příkaz „echo“ (který je zrovna moc nepotřebuje).
<!-- * Většina metapříkazů přijímá pouze příkazy, které existují jako externí programy (tzn. např. příkaz „sudo cd /“ způsobí chybu). Z vestavených příkazů lze s nimi přímo použít „[“, echo, false, kill, printf, pwd, test a true, které současně existují i jako externí. Ostatní vestavěné příkazy je možno použít pomocí metapříkazu „bash -c“. -->
* Metapříkazy je možno řetězit, ale ne libovolně — záleží na tom, který příkaz je vestavěný a který externí. Třeba „sudo exec“ nefunguje vůbec a „exec sudo“ zase nezachová PID (protože původní PID obsadí proces „sudo“). Doporučuji s takovými možnostmi počítat a trochu experimentovat, než získáte dostatek znalostí a zkušeností, abyste dokázal/a posoudit, který příkaz se kterým a v jakém pořadí lze skombinovat a co to udělá.
* Příkaz „xargs“ s parametrem „-n“ lze použít k rozdělení vstupu na n-tice a volání příkazu pro každou z nich. (Nebude-li počet vstupních záznamů beze zbytku dělitelný n, xargs sestaví poslední n-tici kratší.)

### Příkaz chroot

Příkaz „chroot“ pro nově spouštěný příkaz (a všechny jeho potomky) nastaví určitý adresář VFS jako kořenový. Příkaz se pak vyhledá v tomto podstromu a nebude z něj mít přímý přístup ven (dokonce i symbolické odkazy se mu budou vyhodnocovat podle nového kořenového adresáře). Aby to fungovalo, daný adresář musí obsahovat části systému, které program potřebuje ke svému spuštění a běhu. Správné použití příkazu „chroot“ je náročné na znalosti systému, proto doporučuji ho používat opatrně a raději si nejprve přečíst příslušný článek na ArchWiki.

* V podstromu nového kořenového adresáře musí být nainstalovaná nějaká instalace linuxu (do které se chystáte vstoupit).
* Spouštěný příkaz se musí v této instalaci nacházet a mít tam i knihovny, které ke svému běhu potřebuje, a všechno nastavení.
* Spouštěný příkaz se spustí jako root, přepnutý do nového kořenového adresáře.
* Instalace, do které vstupujete, nemusí být stejná distribuce a nemusí obsahovat funkční jádro, musí však být stejné architektury (z 64bitového systému prý nelze vstoupit do 32bitové instalace a naopak).

Příkaz tedy z instalace, do které vstupujete, používá:

!KompaktníSeznam:
* Programy, které spouští.
* Knihovny.
* Systémová a uživatelská nastavení (/etc).

Naopak z hostujícího operačního systému používá vše ostatní, zejména:

!KompaktníSeznam:
* tabulku procesů (PID apod.)
* přístup k zařízením (vyžaduje namapovaný /dev)
* meziprocesovou komunikaci
* systémové démony apod.

## Další zdroje informací

* [Wikipedie: sudo](https://cs.wikipedia.org/wiki/Sudo)
* [Wikipedie: xargs](https://cs.wikipedia.org/wiki/Xargs)
* [Wikipedie: chroot](https://cs.wikipedia.org/wiki/Chroot)
* [ArchWiki: chroot](https://wiki.archlinux.org/index.php/Chroot) (anglicky)
* [Oficiální stránka Sudo](https://www.sudo.ws/) (anglicky)
* [TL;DR: env](https://github.com/tldr-pages/tldr/blob/master/pages/common/env.md) (anglicky)
* [TL;DR: timeout](https://github.com/tldr-pages/tldr/blob/master/pages/common/timeout.md) (anglicky)
* [TL;DR: xargs](https://github.com/tldr-pages/tldr/blob/master/pages/common/xargs.md) (anglicky)
* [TL;DR: chroot](https://github.com/tldr-pages/tldr/blob/master/pages/common/chroot.md) (anglicky)

## Zákulisí kapitoly

V této verzi kapitoly chybí:

!KompaktníSeznam:
* pkexec
* proot
* ssh

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* Příkazy, u kterých spouštění (resp. podmíněné spouštění či nespouštění) programu není jejich hlavní činností (např. „find“ s parametrem „-exec“).
* Příkazové interprety, interprety programovacích jazyků a emulátory terminálu; výjimkou jsou „sh“ a „bash“.
* Příkazy úzce svázané s konkrétním programem, který není široce používaný (např. „docker exec“).
* Syntaktické konstrukce bashe (jako např. „&amp;“) s výjimkou několika málo tzv. pseudometapříkazů.

!ÚzkýRežim: vyp
