<!--

Linux Kniha kouzel, kapitola Diskové oddíly / Btrfs
Copyright (c) 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--

Výhody btrfs:
* umožňuje klonování pododdílů s tím, že kopie se vytvoří až při zápisu
* automaticky počítá a ukládá kontrolní součty dat; umožňuje jejich kontrolu
* umožňuje použít při ukládání dat kompresi

Nevýhody btrfs:
* odkládací soubor může být na btrfs umístěn jen za zvláštních okolností
* je obtížné správně zjistit a interpretovat velikost volného místa v btrfs
* je asynchronní, takže chyby a selhání se projevují opožděně a není snadné určit jejich příčinu
* s jeho zřízením je víc starostí

[ ] http://manpages.ubuntu.com/manpages/focal/en/man8/btrfs-filesystem.8.html
[ ] http://manpages.ubuntu.com/manpages/focal/en/man8/btrfs-check.8.html
? http://manpages.ubuntu.com/manpages/focal/en/man8/btrfs-balance.8.html

-->

# Btrfs

!Štítky: {tematický okruh}{systém}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola se zabývá prací se souborovým systémem typu Btrfs způsoby,
které nejsou dostupné u souborových systémů typu ext4.

## Definice

### Btrfs

* Souborový systém typu btrfs se dělí na takzvané **pododdíly**. Každý pododdíl je reprezentován svým vlastním „kořenovým“ adresářem. Reprezentující adresář představuje jednoznačnou hranici mezi vnějším (obklopujícím) pododdílem a vnitřním (vnořeným) pododdílem. Pododdíly se vždy překrývají pouze tímto hraničním adresářem, jinak jsou oddělené. Operace prováděné s obklopujícím pododdílem (např. klonování) se vnořeného pododdílu netýkají. (V důsledku toho, když naklonujete pododdíl, hraniční adresáře v něm vnořených pododdílů budou v klonu prázdné.) Každý pododdíl má také svoje číselné „id“, ale jeho používání není příliš praktické.
* **Kořenový pododdíl** je pododdíl reprezentovaný kořenovým adresářem souborového systému. Nemá žádný obklopující pododdíl, má vždy id 5 a není možno ho (samostatně) odstranit ani přesunout.
* **Klon** (reflink/snapshot) je v btrfs virtuální kopie souboru nebo celého pododdílu, která se navenek chová jako zcela nezávislá kopie, ale vnitřně sdílí část datových či metadatových bloků s původním souborem či pododdílem, dokud se do nich nikdo nepokusí zapisovat (teprve poté se vytvoří skutečné kopie, ale jen bloků, u kterých je to potřeba). Díky tomu je vytváření klonů rychlé, nenáročné a klony zprvu zabírají jen velmi málo místa.
* Pododdíl může být označený jako „**neměnný**“ (toto označení lze přidat či odebrat i dodatečně); neměnný pododdíl je chráněný proti změnám dat i metadat, bez ohledu na přístupová práva, může však být odstraněn jako celek. Nejčastěji se jako neměnné nastavují klony pododdílů.
* **Zrcadlené oddíly** jsou dva oddíly, kde každá změna je zapisována paralelně na oba, takže v případě poškození či ztráty jednoho z nich nedojde ke ztrátě dat.

Poznámka k pevným odkazům: pevný odkaz v souborovém systému typu btrfs nemůže vést přes hranici pododdílu, místo toho však lze přes hranici pododdílů vytvořit klon souboru.

!ÚzkýRežim: vyp

## Zaklínadla

### Formátování

*# formátovat samostatný oddíl na **btrfs** (obecně/příklad)*<br>
**sudo mkfs.btrfs** [**-f**] <nic>[**-L "**{*Jmenovka*}**"**] <nic>[**-U** {*UUID*}] {*/dev/zařízení-nebo-oddíl*}<br>
**sudo mkfs.btrfs -f -L "Můj nový oddíl" /dev/sda3**

*# formátovat zrcadlené oddíly na **btrfs** (obecně/příklad)*<br>
*// Poznámka: zrcadlené oddíly jsem zatím nezkoušel/a.*<br>
*// Zrcadlené oddíly by měly být stejně velké a nacházet se na dvou různých fyzických úložištích. Také se doporučuje, aby obě úložiště nabízela přibližně stejnou rychlost čtení i zápisu, jinak mohou nastat problémy s výkonem. Při připojování pak stačí připojit jen jeden z oddílů a systém automaticky najde a připojí i to druhé.*<br>
**sudo mkfs.btrfs -d raid1 -m raid1** [**-f**] <nic>[**-L "**{*Jmenovka*}**"**] <nic>[**-U** {*UUID*}] {*/dev/zařízení-nebo-oddíl-1*} {*/dev/zařízení-nebo-oddíl-2*}<br>
**sudo mkfs.btrfs -d raid1 -m raid1 -f -L "Zrcadlo" /dev/sda3 /dev/sdb1**
<!--
[ ] Vyzkoušet!

-O raid1c34 :: RAID1 with 3 or 4 copies
-->

*# změnit velikost souborového systému typu btrfs (na udanou velikost/na celý oddíl)*<br>
*// Souborový systém musí být připojený, aby bylo možno změnit jeho velikost!*<br>
**sudo btrfs filesystem resize** {*cílová-velikost-P*} {*/přípojný/bod*}<br>
**sudo btrfs filesystem resize max** {*/přípojný/bod*}<br>

### Jmenovka (nastavit)

<!--
Poznámka: souborové systémy FAT a NTFS by při nastavování jmenovky měly být odpojené. Souborové systémy ext4 a btrfs mohou být i připojené.
-->

*# nastavit/smazat jmenovku **btrfs***<br>
*// „Specifikace oddílu“ je v případě nepřipojeného oddílu „/dev/oddíl“, v případě připojeného oddílu je nutno uvést jeho přípojný bod. Příkaz selže s chybou, pokud uvedete připojený oddíl označením ve tvaru /dev/oddíl! Jmenovka může mít pravděpodobně maximálně 256 bajtů a nesmí obsahovat znak konce řádku nebo nulový bajt.*<br>
**sudo btrfs filesystem label** {*specifikace/oddílu*} **"**{*Nová jmenovka*}**"**<br>
**sudo btrfs filesystem label** {*specifikace/oddílu*} **""**

*# zjistit jmenovku oddílu btrfs (připojeného/nepřipojeného)*<br>
**sudo btrfs filesystem label** {*/přípojný/bod*}<br>
**sudo btrfs filesystem label** {*/dev/oddíl*}

### Degrafmentace, kontrola, TRIM apod.

*# **zkontrolovat** a opravit souborový systém*<br>
?

*# zkontrolovat souborový systém typu btrfs*<br>
**sudo btrfs check \-\-readonly** [**\-\-progress**] {*/dev/oddíl*}
<!--
**sudo btrfs rescue chunk-recover -v** {*/dev/oddíl*}
?
-->

*# vynulovat volné bloky*<br>
?
<!--
btrfs: sudo sfill -fllvz {*/přípojný/bod*}
; balíček: secure-delete
[ ] vyzkoušet, zda opravdu nuluje
-->

*# defragmentovat oddíl typu btrfs (pozor!)*<br>
?

### Správa pododdílů

*# **vytvořit** pododdíl (obecně/příklad)*<br>
*// Příklad vytvoří poddíl reprezentováný novým adresářem „test“ v aktuálním adresáři. (Nově vytvářený adresář nesmí předem existovat!)*<br>
**btrfs subvolume create** {*cesta/k/novému/adresáři*}<br>
**btrfs subvolume create test**

*# **smazat** pododdíl*<br>
*// Pokud souborový systém nebyl připojen s volbou „user\_subvol\_rm\_allowed“, smí pododdíl smazat jen superuživatel. Jinak ho smí smazat i jeho vlastník (tzn. vlastník adresáře reprezentujícího pododdíl); pokud je však oddíl neměnný, musí mu tuto vlastnost nejprve odebrat. Vlastník také může pododdíl smazat jako obyčejný adresář příkazem „rm -R“, ale ten bývá pomalejší, protože nejprve projde a smaže všechny soubory a adresáře v daném pododdílu.*<br>
[**btrfs property set** {*cesta/k/pododdílu*} **ro false**]<br>
[**sudo**] **btrfs subvolume delete -c** {*cesta/k/pododdílu*}...

*# vypsat **seznam** pododdílů (s právy superuživatele/bez nich)*<br>
**(cd ** {*/bod/připojení/btrfs*} ** &amp;&amp; pwd &amp;&amp; sudo btrfs subvolume list . | sed -E 's/^(\\S+\\s+){7}path\\s/'"$(pwd | sed -E 's!/!\\\\/!g')"'\\//')**<br>
**find** {*/abs/cesta/přípojného/bodu*} **-type d -inum -257 -print**
<!-- Hraniční adresáře pododdílů v Btrfs mají čísla i-uzlů <= 256 -->

*# přejmenovat či **přesunout** pododdíl (kromě neměnného)*<br>
*// Nové umístění musí být v rámci téhož souborového systému btrfs, ale může to být i v jiném obklopujícím pododdílu. Poznámka: neměnný pododdíl nelze přejmenovat či přesunout.*<br>
**mv -T** {*cesta/pododdílu*} {*nové/umístění*}

*# přejmenovat či přesunout neměnný pododdíl*<br>
**btrfs property set** {*původní/cesta*} **ro false**<br>
**mv** [**-v**] {*původní/cesta*} {*nová/cesta*}<br>
**(rv=$?; for x in {*původní/cesta*} {*nová/cesta*}; do btrfs property set "$x" ro true 2&gt;/dev/null; done; exit $rv)**

*# nastavení pododdílu jako **neměnného** (vypnout/zapnout)*<br>
**btrfs property set** {*cesta/k/pododdílu*} **ro false**<br>
**btrfs property set** {*cesta/k/pododdílu*} **ro true**

*# **je** adresář pododdíl btrfs?*<br>
*// Pokud víte s jistotou, že testovaný adresář leží na oddílu typu btrfs, můžete první test vynechat.*<br>
**adr="$(realpath "**{*cesta/k/adresáři*}**")"**<br>
[**test "$(stat -fc %T "$adr")" = btrfs &amp;&amp;**] **test "$(stat -c %i "$adr")" -le 256**
<!--
Test částečně podle: https://stackoverflow.com/questions/25908149/how-to-test-if-location-is-a-btrfs-subvolume

Další možnost:
**btrfs property get** {*cesta/k/adresáři*} **ro 2&gt;/dev/null**
-->

*# je pododdíl neměnný?*<br>
**btrfs property get** {*cesta/k/adresáři*} **ro \| fgrep -qx ro=true**

### Klonování

*# vytvořit **klon podstromu** adresářů*<br>
*// Cíl („/cesta/pro/klon“) před vykonáním příkazu nesmí existovat. Poznámka: Naklonují se pouze soubory; adresáře se pro ně vytvoří nové, takže pokud je podstrom rozsáhlejší, bude to chvíli trvat.*<br>
[**rm -Rf** {*/cesta/pro/klon*} **&amp;&amp;**]<br>
**cp \-\-reflink=always -R** [**\-\-preserve=all**] <nic>[**-v**] {*/cesta/k/adresáři*} {*/cesta/pro/klon*}

*# vytvořit klon **pododdílu** (normální/neměnný)*<br>
**btrfs subvolume snapshot** {*cesta/k/pododdílu*} {*cesta/k/novému/pododdílu*}<br>
**btrfs subvolume snapshot -r** {*cesta/k/pododdílu*} {*cesta/k/novému/pododdílu*}

*# vytvořit klon **souboru***<br>
**cp \-\-reflink=always** [**\-\-preserve=all**] <nic>[**-t**] <nic>[**-v**] {*/cesta/k/souboru*} {*/cesta/pro/klon*}

*# osamostatnit klon souboru, aby nevyužíval sdílené datové bloky*<br>
**btrfs filesystem defragment** [**-v**] <nic>[**\-\-**] {*cesta/k/souboru*}...

### Práce s oddíly

*# **přesunout** souborový systém z jednoho oddílu na jiný*<br>
*// Cílový oddíl může být menší i větší než původní, musí se však na něj vejít všechna data a metadata.*<br>
**sudo bash -c '**<br>
**btrfs device add /dev/**{*nový-oddíl*} {*/přípojný/bod*} **\|\| exit $?**<br>
**btrfs device remove /dev/**{*původní-oddíl*} {*/přípojný/bod*} **\|\|**<br>
**(r=$?; btrfs device remove /dev/**{*nový-oddíl*} {*/přípojný/bod*}**; exit $r)**<br>
**'**

*# **vytvořit** dva zrcadlené oddíly z jednoho samostatného*<br>
?

*# **osamostatnit** oddíl ze zrcadlené dvojice*<br>
?

*# vyvořit N-tici prokládaných oddílů z neprokládaného jednooddílového btrfs*<br>
?

*# vytvořit jednoduchý oddíl BTRFS z prokládané N-tice*<br>
?

### Přenos neměnných pododdílů přes soubor

*# **uložit** neměnný pododdíl do souboru*<br>
*// Pokud ukládáte více pododdílů, jejich reprezentující adresáře se musejí lišit jménem, a to i v případě, že leží v různých podadresářích!*<br>
**sudo btrfs send -e**[**v**] {*/cesta/k/pododdílu*}... **\| gzip &gt;**{*cílový/soubor.gz*}

*# **načíst** neměnné oddíly ze souboru*<br>
*// Příkaz vytvoří ve výstupním adresáři pododdíly uložené v souboru pod jejich původními názvy a na konci operace je nastaví jako neměnné.*<br>
**zcat** {*soubor.gz*} **\| sudo btrfs receive -e**[**v**] {*výstupní/adresář*}

*# zkontrolovat v souboru uložené neměnný oddíly*<br>
**zcat** {*soubor.gz*} **\| btrfs receive \-\-dump**

### Ostatní

<!--
btrfs filesystem defrag -v -c{*komprese*} {*soubor*} — umožňuje rekomprimovat soubor
-->

*# vypsat podrobné údaje o obsazení souborového systému*<br>
[**sudo**] **btrfs filesystem usage** {*/přípojný/bod/btrfs*}

*# ověřit kontrolní součty všech souborů*<br>
**sudo btrfs scrub start -B -d -r** {*/přípojný/bod/btrfs*}

*# ověřit kontrolní součty některých souborů*<br>
?

*# defragmentovat pododdíl*<br>
**sudo btrfs filesystem defragment -r** {*cesta/pododdílu*}

### Přenos rozdílu klonů

Pozor! Tyto operace slouží k přenosu změn z jednoho oddílu btrfs na jiný (obvykle na jiném počítači)
a mají poměrně tvrdé požadavky na to, co musejí klony na jednom i druhém počítači splňovat.
Před jejich použitím si musíte přečíst manuálové stránky vyvolané příkazem
„man 8 btrfs-send btrfs-receive“.

*# uložit do souboru rozdíl*<br>
**sudo btrfs send -e**[**v**] **-c** {*/cesta/k/původnímu-klonu*} {*/cesta/k/novému/klonu*} **\| gzip &gt;**{*cílový/soubor.gz*}

*# aplikovat rozdíl*<br>
**zcat** {*soubor.gz*} **\| sudo btrfs receive -e**[**v**] {*výstupní/adresář*}


## Nejdůležitější volby připojení (Btrfs)

!Parametry:

* ☐ user\_subvol\_rm\_allowed :: Umožní smazat pododdíl jeho vlastníkovi (doporučuji).
* ☐ skip\_balance :: Po připojení nebude pokračovat v přerušené operaci „balance“. Tento parametr se používá především v situaci, kdy operace „balance“ selhala kvůli nedostatku místa na disku a způsobila vynucený přechod souborového systému do režimu „ro“ (jen pro čtení).
* ○ compress-force={*hodnota*} ○ compress={*hodnota*} :: Nastavuje výchozí kompresi pro nově vytvořené soubory. Použijte hodnotu „off“ pro žádnou kompresi, „lzo“ pro nenáročnou kompresi, „zstd:10“ pro důkladnou kompresi nebo „zstd:15“ pro maximální kompresi.
* ☐ degraded :: Umožní připojit oddíl zrcadleného systému souborů v situaci, kdy některé ze zařízení není dostupné. Doporučuji skombinovat s volbou „ro“.
* ○ discard ○ nodiscard :: Zapne/vypne automatické označování prázdného prostoru na SSD discích (operace TRIM). Možná není nutné ho zadávat.
* ○ subvol={*/cesta*} ○ subvolid={*id*} :: Připojí zadaný pododdíl namísto výchozího (což je zpravidla ten kořenový). Varování: jeden souborový systém typu btrfs je dovoleno připojit vícenásobně (na různé přípojné body), ale pokud se chcete vyhnout problémům, použijte u všech připojení přesně stejné volby až na „subvol“ či „subvolid“ (vyzkoušel/a jsem, že další volby, které se mohou bezpečně lišit, jsou \*atime a ro/rw).

Manuálová stránka pro zlepšení výkonu doporučuje použít obecnou volbu „noatime“.

## Instalace na Ubuntu

Pro podporu Btrfs je nutno doinstalovat:

*# *<br>
**sudo apt-get btrfs-progs**

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

* Btrfs se prý nedokáže dobře zotavit ze selhání a chyb (i v manuálové stránce je varování, že program „btrfs check“ může problémy spíš zhoršit než vyřešit). Pokud dojde prostor pro metadata, souborový systém se nuceně přepne do režimu „jen pro čtení“ a je obtížné či skoro nemožné se z takového stavu zotavit – viz [stránku na superuser.com](https://superuser.com/questions/1419067/btrfs-root-no-space-left-on-device-auto-remount-read-only-cant-balance-cant). Navíc, když se mi to stalo, souborový systém stále hlásil cca 500 MiB volných. Proto doporučuji si za všech okolností nechávat jeden až dva gibibajty každého oddílu typu btrfs volné a jednou za čas provést „offline zálohu“ metodou sektor po sektoru, aby bylo v případě havárie možno obnovit původní obsah a funkčnost oddílu.
* Pododdíly se v některých ohledech chovají jako samostatně připojené souborové systémy – každý pododdíl má vlastní číslování i-uzlů (proto nejsou dovoleny pevné odkazy přes hranice pododdílu) a nástroje, které nepřekračují hranice souborových systémů (např. „find“ s parametrem „-xdev“), nesestoupí do adresáře reprezentujícího pododdíl. Důležitým technickým rozdílem oproti připojenému systému souborů však je, že adresář reprezentující pododdíl se nepovažuje za přípojný bod VFS a pododdíly nejsou viditelné pro příkazy jako „findmnt“.
* Příznak neměnnosti se při klonování nepřenáší; pokud ho nenastavíte (např. parametrem „-r“), do klonů neměnného oddílu půjde zapisovat, což může být velmi užitečné (můžete např. vytvořit neměnný klon pododdílu a později původní pododdíl smazat a nahradit ho obyčejným klonem z neměnného klonu).
* Umístění odkládacího souboru na souborový systém btrfs je možné, ale nedoporučuji to. Přesný postup a související omezení najdete v manuálové stránce zobrazené příkazem „man 5 btrfs“ (kapitola „SWAPFILE SUPPORT“).
* Doporučuji se vyhýbat volbám připojení „subvol“ a „subvolid“; pro připojení pododdílů na různá místa souborového systému raději použijte „mount \-\-bind“, resp. jeho obdobu v /etc/fstab.
* Klonování pododdílu je velmi rychlé i u rozsáhlých pododdílů; naopak klonování jednotlivých souborů je sice podstatně rychlejší než jejich kopírování, ale pomalejší než vytváření pevných odkazů na ně.
* Velmi špatná vlastnost Btrfs je, že je asynchronní – operace vypadají, že rychle a úspěšně proběhly, ale za několik minut souborový systém může zhavarovat, když „naslibovanou“ operaci nedokáže provést.
* Transparentní komprese je jen zřídka užitečná. Její účinnost ve srovnání s archivy či SquashFS je mizivá, u dobře komprimovatelných textových souborů ušetří maximálně desítky procent kapacity, zatímco běžný „zip“ u stejných dat dokáže ušetřit třeba 95% jejich velikosti. Navíc většina dnes používaných formátů, které zabírají hodně místa, už komprimovaná je, takže je u nich další komprese zcela neúčinná.

## Další zdroje informací

* [Root.cz: Souborový systém Btrfs: vlastnosti a výhody moderního ukládání dat](https://www.root.cz/clanky/souborovy-system-btrfs-vlastnosti-a-vyhody-moderniho-ukladani-dat/)
* [Wikipedie: Btrfs](https://cs.wikipedia.org/wiki/Btrfs)
* [Chris Titus Tech: Btrfs Guide](https://christitus.com/btrfs-guide/) (anglicky)
* [man 8 btrfs-subvolume](http://manpages.ubuntu.com/manpages/focal/en/man8/btrfs-subvolume.8.html) (anglicky)
* [man 5 btrfs](http://manpages.ubuntu.com/manpages/focal/en/man5/btrfs.5.html) (anglicky)
* [Btrfs Sysadmin Guide](https://btrfs.wiki.kernel.org/index.php/SysadminGuide) (anglicky)
* [Kernel Btrfs Wiki](https://btrfs.wiki.kernel.org/index.php/Main\_Page) (anglicky)
* [Arch Wiki: Btrfs](https://wiki.archlinux.org/index.php/Btrfs) (anglicky)
* [man 8 btrfs-scrub](http://manpages.ubuntu.com/manpages/focal/en/man8/btrfs-scrub.8.html) (anglicky)

!ÚzkýRežim: vyp
