<!--

Linux Kniha kouzel, kapitola Diskové oddíly
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

[x] BTRFS
[ ] Pokrýt ovládání programu fdisk.
[ ] Šifrování LVM?
[ ] Připojování obyčejným uživatelem
[ ] SquashFS.

Zpracovat také:
https://www.root.cz/clanky/pripojeni-obrazu-disku-pod-beznym-uzivatelem-bez-opravneni-roota/

Volby připojení:
data=ordered
uhelper=udisks2

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

# Diskové oddíly

!Štítky: {tematický okruh}{systém}{LVM}{ramdisk}{odkládací prostor}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola se zabývá dělením pevného disku na oddíly, jejich formátováním
(zejména souborové systémy ext4, btrfs, FAT32 a NTFS), údržbou a připojováním
(ručním i automatickým). Zabývá se také prací s ramdisky, odkládacím prostorem a LVM.
<!-- a squash-fs.-->

Tato verze kapitoly pokrývá jen částečně: dělení pevného disku na oddíly,
práci se systémem btrfs, LVM (nejsou pokryty „layouty“ a „snapshoty“).

Tato verze kapitoly nepokrývá: připojovaní souborových systémů obyčejnými uživateli;
šifrování a nastavování kvót; další typy systému souborů (např. ZFS);
síťové souborové systémy; vypalování DVD; práci s ISO obrazy CD a DVD;
práci se systémem souborů SquashFS.

## Definice

### Obecné definice

* **Virtuální souborový systém** (VFS) je způsob, jakým Linux nahlíží na strukturu adresářů. Při startu počítače obsahuje jen prázdný kořenový adresář „/“, na který jádro „připojí“ (viz níže) kořenový adresář kořenového systému souborů.
* **Systém souborů** je vymezená část adresářové struktury zpřístupněná jednotným způsobem (např. na jednom oddílu pevného disku). Každý systém souborů má svůj **kořenový adresář**, který může být „připojen“ (viz níže) na některý z existujících adresářů VFS. Systémy souborů mohou být fyzické (uložené fyzicky na nějakém paměťovém médiu), virtuální (generované za běhu jádrem operačního systému), vzdálené (připojované přes síť) nebo vnořené (uložené v souboru – to bývá např. SquashFS). Konkrétní způsob fyzické organizace systému souborů na úložném médiu nazývá **typ systému souborů**, to je např. ext4 nebo NTFS.
* **Připojení** systému souborů znamená, že jádro vezme existující adresář ve VFS a „překryje“ ho kořenovým adresářem připojovaného systému souborů (včetně jeho vlastnictví, příznaků a přístupových práv). Podstrom původního adresáře tímto z VFS odpadne a místo něj se stane součástí VFS celá adresářová struktura nově připojeného systému souborů. Opačným úkonem je **odpojení**, při němž z VFS odpadne adresářová struktura připojeného systému souborů a dojde k opětovnému zapojení podstromu původního adresáře do VFS. Zvláštním (ale komplikovaným a méně častým) případem je připojení jiného než kořenového adresáře systému souborů.
* **Přípojný bod** (anglicky „mount point“) je adresář VFS, kam je připojený systém souborů.
* **Odkládací oddíl** je úložný prostor sloužící k odkládání paměťových stránek, popř. k hibernaci. V linuxu se s ním zachází podobně jako se souborovým systémem, proto je předmětem této kapitoly.
<!--
Jeden systém souborů může být připojen vícenásobně (na více různých míst VFS), na jedno místo VFS ale může být připojen nejvýše jeden systém souborů současně.
-->

### Identifkátory souborových systémů

K identifikaci konkrétního systému souborů se používá několik druhů identifikátorů:

* **UUID** je identifikátor přidělovaný souborovému systému při formátování (tzn. dalším formátováním se změní, ale naopak překopírování po bajtech ho neohrozí); ne všechny souborové systémy mají nějakou formu UUID, ale ext4, btrfs, FAT32 a NTFS ano.
* **PARTUUID** je identifikátor oddílu na disku, je-li dělen metodou GPT (na discích dělených starší metodou MBR se emuluje, u logických oddílů LVM není dostupný vůbec).
* **Jmenovka** je textový identifikátor souborového systému přidělovaný uživatelem, zpravidla při formátování.
* Poslední možností je cesta k zařízení v /dev, např. „/dev/sda1“. Tato možnost je preferována u logických oddílů LVM; u oddílů na discích se nedoporučuje, protože cesta k zařízení se může snadno změnit.

### LVM

LVM (logical volume management) je metoda rozložení oddílů na pevném disku, která má
odstínit uživatele od fyzického rozložení dat a poskytnout nové možnosti, např. rozložení
jednoho oddílu přes několik fyzických disků nebo snadné přesouvání oddílů a změnu jejich velikosti, často i bez nutnosti restartu počítače.

* **Logický oddíl** je v LVM obdoba běžného diskového oddílu (tzn. je možno ho naformátovat a používat k ukládání dat); na rozdíl od něj ale nemá pevné fyzické umístění na disku, jeho fyzické umístění je vymezené skupinou svazků, ve které je vytvořen. Logický oddíl LVM je dostupný pod cestou „/dev/{*skupina-svazků*}/{*název-oddílu*}“.
* **Skupina svazků** je v LVM neprázdná pojmenovaná skupina fyzických svazků k vytváření logických oddílů. Data každého logického oddílu se fyzicky nacházejí pouze na fyzických svazcích příslušných do dané skupiny.
* **Fyzický svazek** je v LVM blokové zařízení (celý disk nebo jeho oddíl), které je nastavené a naformátované k ukládání dat logických oddílů. Nemůže to být logický oddíl LVM.

### Co a kam připojit

V následujících zaklínadlech platí:

{*co-připojit*} může být:

* UUID souborového systému ve tvaru „UUID=61bbd562-0694-4561-a8e2-4ccfd004a660“.
* PARTUUID ve tvaru „PARTUUID=0337a362-e7b3-4c50-a81d-9a5d45755e75“.
* Jmenovka ve tvaru LABEL="Jmenovka".
* Cesta diskového oddílu či zařízení (např. „/dev/sda1“).
* U některých typů souborových systémů je to jiný řetězec (např. „tmpfs“, „none“ apod.)
* Existuje ještě tvar pro síťový souborový systém, viz manuálovou stránku „man 5 fstab“.
<!--
Tento tvar je vhodný pouze u logických oddílů LVM či při jednorázovém připojování příkazem „mount“. V ostatních případech se nedoporučuje, protože cesta k diskovému oddílu se může změnit po každém restartu v závislosti na počtu oddílů, připojeném hardware apod.
-->

{*kam-připojit*} je zpravidla cesta nastávajícího přípojného bodu (v /etc/fstab musí být absolutní, v příkazu „mount“ stačí i relativní), výjimka platí pro odkládací prostor, kde se uvádí „none“.

{*typ-soub-sys*} je identifikátor typu souborového systému (např. ext4, btrfs, vfat, ntfs, tmpfs apod.) Lze použít i „auto“; systém se pak typ pokusí detekovat automaticky.

{*volby-připojení*} je seznam čárkami oddělených voleb nebo klíčové slovo „defaults“, které má význam „rw,suid,dev,exec,auto,nouser,async“.

### Btrfs

* Souborový systém typu btrfs se dělí na takzvané **pododdíly**. Každý pododdíl je reprezentován svým vlastním „kořenovým“ adresářem. Reprezentující adresář představuje jednoznačnou hranici mezi vnějším (obklopujícím) pododdílem a vnitřním (vnořeným) pododdílem. Pododdíly se vždy překrývají pouze tímto hraničním adresářem, jinak jsou oddělené. Operace prováděné s obklopujícím pododdílem (např. klonování) se vnořeného pododdílu netýkají. (V důsledku toho, když naklonujete pododdíl, hraniční adresáře v něm vnořených pododdílů budou v klonu prázdné.) Každý pododdíl má také svoje číselné „id“, ale jeho používání není příliš praktické.
* **Kořenový pododdíl** je pododdíl reprezentovaný kořenovým adresářem souborového systému. Nemá žádný obklopující pododdíl, má vždy id 5 a není možno ho (samostatně) odstranit ani přesunout.
* **Klon** (reflink/snapshot) je v btrfs virtuální kopie souboru nebo celého pododdílu, která se navenek chová jako zcela nezávislá kopie, ale vnitřně sdílí část datových či metadatových bloků s původním souborem či pododdílem, dokud se do nich nikdo nepokusí zapisovat (teprve poté se vytvoří skutečné kopie, ale jen bloků, u kterých je to potřeba). Díky tomu je vytváření klonů rychlé, nenáročné a klony zprvu zabírají jen velmi málo místa.
* Pododdíl může být označený jako „**neměnný**“ (toto označení lze přidat či odebrat i dodatečně); neměnný pododdíl je chráněný proti změnám dat i metadat, bez ohledu na přístupová práva, může však být odstraněn jako celek. Nejčastěji se jako neměnné nastavují klony pododdílů.
* **Zrcadlené oddíly** jsou dva oddíly, kde každá změna je zapisována paralelně na oba, takže v případě poškození či ztráty jednoho z nich nedojde ke ztrátě dat.

Poznámka k pevným odkazům: pevný odkaz v souborovém systému typu btrfs nemůže vést přes hranici pododdílu, místo toho však lze přes hranici pododdílů vytvořit klon souboru.

!ÚzkýRežim: vyp

## Zaklínadla

### Položky v /etc/fstab

*# připojit **kořenový** systém souborů (obecně/příklad)*<br>
*// Poznámka: Připojení kořenového systému souborů by mělo být v /etc/fstab první řádkou kromě komentářů a prázdných řádek.*<br>
{*co-připojit*} **/** {*typ-soub-sys*} {*volby-připojení*} **0 1**<br>
**UUID="61bbd562-0694-4561-a8e2-4ccfd004a660"<tab7>/<tab7>ext4<tab7>errors=remount-ro,discard,nouser\_xattr<tab3>0<tab7>1**

*# **připojit** jiný než kořenový systém souborů (obecně/příklad)*<br>
*// 2 v posledním poli zapne automatickou kontrolu souboru systémů při startu; tato volba je vhodná pro místní souborové systémy. 0 v posledním poli automatickou kontrolu vypne, ta je vhodná především pro výměnná média a síťové systémy souborů. Rovněž je vhodná pro místní systémy souborů připojované výhradně pro čtení.*<br>
{*co-připojit*} {*kam-připojit*} {*typ-soub-sys*} {*volby-připojení*} **0** {*2-nebo-0*}<br>
**/dev/skupina/muj-oddil ext4 defaults 0 2**

*# připojit **ramdisk***<br>
*// Velikost se udává nejčastěji v mebibajtech (s příponou M – např. „256M“) nebo gibibajtech (s příponou G – např. „10G“). Lze ji udat také v procentech dostupné paměti RAM (např. „150%“ pro 1,5-násobek velikosti RAM).*<br>
**tmpfs** {*kam-připojit*} **tmpfs size=**{*velikost*}[**,nosuid**]<nic>[**,nodev**]<nic>[**,noexec**]<nic>[**,mode=**{*práva-číselně*}]<nic>[**,uid=**{*UID-vlastníka*}]<nic>[**,gid=**{*GID-skupiny*}]<nic>[**,**{*další,volby*}] **0 0**

*# připojit **odkládací** oddíl/odkládací soubor*<br>
{*co-připojit*} **none swap sw 0 0**<br>
{*/cesta/k/souboru*} **none swap sw 0 0**

*# připojit **adresář** z již připojeného systému souborů na nové místo*<br>
**/původní/adresář /nový/adresář none bind 0 0**

<!--
3 možnosti „co připojit“:

1) oddíl (např. /dev/sda1)
2) UUID (např. UUID="61bbd562-0694-4561-a8e2-4ccfd004a660")
3) jmenovka (např. LABEL="MojeData")
-->

### Připojení a odpojení systému souborů

*# **připojit** systém souborů uvedený v /etc/fstab (alternativy)*<br>
[**sudo**] **mount** {*kam-připojit*}<br>
[**sudo**] **mount** {*co-připojit*}

*# připojit systém souborů libovolně (obecně/příklad)*<br>
**sudo mount -t** {*typ-soub-sys*} **-o** {*volby,připojení*} {*/co/připojit*} {*/kam/připojit*}<br>
**sudo mount -t ext4 -o defaults,nosuid,nodev,lazytime,discard UUID=61bbd562-0694-4561-a8e2-4ccfd004a660 /mnt/abc**

*# odpojit systém souborů a **vysunout** zařízení (alternativy)*<br>
*// Příkaz „eject“ pro jistotu používejte se sudo, popř. vyzkoušejte, zda bez něj ve vašem konkrétním případě funguje. Často se mi stává, že i uživateli, který je ve skupinách „cdrom“ a „plugdev“ selže s chybou „Nemohu otevřít zařízení“ a zatím se mi nepodařilo zjistit, jaké tam platí pravidlo.*<br>
[**sudo**] **eject** [**-v**] {*/dev/oddíl*}<br>
[**sudo**] **eject** [**-v**] {*/dev/zařízení*}<br>
[**sudo**] **eject** [**-v**] {*/cesta/přípojného/bodu*}

*# **odpojit** systém souborů*<br>
[**sudo**] **umount** {*kam-připojit*}

*# přepnout již připojený systém souborů do režimu **jen pro čtení**/do režimu čtení i zápis*<br>
*// Tato operace selže, pokud je některý soubor z daného systému souborů otevřený pro zápis. Otevření pro čtení nevadí.*<br>
**sudo mount -o remount,ro**[**,**{*další-volba*}]... {*/přípojný/bod/nebo/zařízení*}<br>
**sudo mount -o remount,rw**[**,**{*další-volba*}]... {*/přípojný/bod/nebo/zařízení*}

*# připojit **adresář** z již připojeného systému souborů na nový přípojný bod*<br>
*// Poznámka: Tímto příkazem se vytvoří nové, nezávislé připojení téhož systému souborů do nového přípojného bodu. Tento příkaz umožňuje připojit i jiný než kořenový adresář připojovaného systému souborů.*<br>
**sudo mount \-\-bind** {*/cesta/k/adresáři*} {*/nový/přípojný/bod*}

*# **přesunout** systém souborů na jiný přípojný bod (alternativa 1)*<br>
**sudo mount \-\-bind** {*/původní/přípojný/bod*} {*/nový/přípojný/bod*}<br>
**sudo umount** {*/původní/přípojný/bod*}

*# přesunout systém souborů na jiný přípojný bod (alternativa 2)*<br>
**sudo mount \-\-make-private** {*/nadřazený/přípojný/bod*} **&amp;&amp;**<br>
**sudo mount \-\-move** {*/původní/přípojný/bod*} {*/nový/přípojný/bod*}

### Již připojené systémy souborů (vypsat/zjistit údaje)

*# **vypsat** (pro člověka/pro skript)*<br>
**findmnt -D -t nofuse.gvfsd-fuse,nodevtmpfs,nosquashfs**<br>
**findmnt -nu -o SOURCE | egrep '^/' | LC\_ALL=C sort -u**

*# vypsat seznam přípojných bodů*<br>
**findmnt -ln -o TARGET**

*# velikost dostupného (**volného**) místa (pro člověka/pro skript)*<br>
**df -h** {*/přípojný/bod*}<br>
**findmnt -bnu -o AVAIL** {*/přípojný/bod*}
<!--
[ ] btrfs?
-->

*# zjistit **volby připojení***<br>
**findmnt -nu -o OPTIONS** {*/přípojný/bod*}

*# **typ** souborového systému*<br>
**findmnt -nu -o FSTYPE** {*/přípojný/bod*}

*# **UUID**/**PARTUUID**/**jmenovka***<br>
**findmnt -nu -o UUID** {*/přípojný/bod*}<br>
**findmnt -nu -o PARTUUID** {*/přípojný/bod*}<br>
**findmnt -nu -o LABEL** {*/přípojný/bod*}

*# je připojený jen pro čtení?*<br>
**findmnt -nu -o OPTIONS** {*/přípojný/bod*} **\| tr ,\\\\n \\\\n, \| fgrep -x ro**

*# zjistit **kapacitu** systému souborů (pro člověka/pro skript)*<br>
**df -h** {*/přípojný/bod*}<br>
**findmnt -bnu -o SIZE** {*/přípojný/bod*}
<!--
[ ] btrfs?
-->

*# zjistit **zdrojové** zařízení z přípojného bodu/naopak*<br>
*// Jedno zdrojové zařízení může být připojeno na víc přípojných bodů (např. při použití příkazu „mount \-\-bind“); v tom případě příkaz „findmnt“ vypíše každý přípojný bod na samostatnou řádku!*<br>
**findmnt -nu -o SOURCE** {*/přípojný/bod*}<br>
**findmnt -nu -o TARGET** {*/dev/disknebooddíl*} [** \| head -n 1**]

*# zjistit velikost použité části souborového systému (pro člověka/pro skript)*<br>
**df -h** {*/přípojný/bod*}<br>
**findmnt -bnu -o USED** {*/přípojný/bod*}

*# zjistit cestu připojeného adresáře uvnitř připojeného systému souborů*<br>
?

### Oddíly a zařízení (vypsat/zjistit údaje)

*# **UUID**/**PARTUUID**/**jmenovka** oddílu*<br>
[**sudo**] **lsblk -ln -o UUID** {*/dev/oddíl*}<br>
[**sudo**] **lsblk -ln -o PARTUUID** {*/dev/oddíl*}<br>
[**sudo**] **lsblk -ln -o LABEL** {*/dev/oddíl*}
<!--
**sudo blkid -s UUID -o value** {*/dev/oddíl*}<br>
**sudo blkid -s PARTUUID -o value** {*/dev/oddíl*}
-->

*# **typ** souborového systému*<br>
[**sudo**] **lsblk -ln -o FSTYPE** {*/dev/oddíl*}
<!--
**sudo blkid -s TYPE -o value** {*/dev/oddíl*}
-->

*# vypsat místní zařízení a oddíly (pro člověka/pro skript)*<br>
*// Poznámka: vypsaný seznam může obsahovat i zařízení nedostupná či k ukládání dat nevhodná. Buďte při jejich zkoumání opatrný/á.*<br>
[*sudo*] **lsblk** [**\-\-all**]<br>
[*sudo*] **lsblk -ln -o NAME \| sed -E 's!\-\-!\\x00!g;s!-!/!g;s!\\x00!-!g;s!^!/dev/!' \| LC\_ALL=C sort**

*# přesná **velikost** oddílu/disku v bajtech*<br>
**sudo blockdev \-\-getsize64** {*/dev/oddíl*}<br>
**sudo blockdev \-\-getsize64** {*/dev/disk*}

*# je oddíl či zařízení jen pro čtení?*<br>
*// Odpověď 0 znamená, že zařízení je i pro zápis; odpověď 1 znamená, že je jen pro čtení.*<br>
**sudo blockdev \-\-getro** {*/dev/oddíl-nebo-zařízení*}

*# zjistit velikost fyzického bloku/logického sektoru (v bajtech)*<br>
**sudo blockdev \-\-getbsz** {*/dev/zařízení*}<br>
**sudo blockdev \-\-getss** {*/dev/zařízení*}
<!--
asi PHY-SEC/LOG-SEC u lsblk
-->

### Formátování

*# formátovat na **ext4** (obecně/příklad)*<br>
*// Maximální velikost jmenovky je 16 bajtů.*<br>
*// Parametr -U přijímá také speciální hodnoty „random“ (vygenerovat náhodné UUID), „time“ (vygenerovat UUID závislé na čase), „clear“ (zrušit UUID).*<br>
**sudo mke2fs -t ext4** [**-c**[**c**]] <nic>**-v** <nic>[**-E root\_owner=**{*UID*}**:**{*GID*}] <nic>[**-L** {*jmenovka*}] <nic>[**-U** {*UUID*}] <nic>[**-d** {*cesta*}] <nic>[**-F**] {*/dev/zařízení-nebo-oddíl*}<br>
**sudo mke2fs -t ext4 -c -v -U 977bda6f-ce11-4549-9325-c48c360069ef /dev/sda3**

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

*# formátovat na **FAT32** (obecně/příklad)*<br>
*// Poznámka: jmenovka systémů FAT může být maximálně 11 znaků dlouhá!*<br>
*// Pro formátování na FAT16 či FAT12 nahraďte hodnotu 32 u parametru -F. Tyto staré souborové systémy se dnes už ale v praxi nepoužívají.*<br>
**sudo mkfs.fat -F 32** [**-c**] <nic>[**-h** {*počet-skrytých-sektorů*}] <nic>[**-n "**{*JMENOVKA*}**"**] <nic>[**-v**] {*/dev/oddíl*}

*# formátovat na **NTFS** (obecně/příklad)*<br>
**sudo mkntfs** [**-f**] <nic>[**-v**] <nic>[**-L** {*jmenovka*}] <nic>[**-C**] <nic>[**-U**] {*/dev/zařízení-nebo-oddíl*}<br>
**sudo mkntfs -f -v -L MůjDisk /dev/sda3**

*# změnit velikost souborového systému typu ext4 (na udanou velikost/na celý oddíl)*<br>
*// Velikost se zadává s příponou (např. „2048M“ nebo „4G“). Tip: velikost ext4 lze obvykle změnit i tehdy, když je souborový systém připojený.*<br>
**sudo e2fsck -f** {*/dev/oddíl*} **&amp;&amp; sudo resize2fs** {*/dev/oddíl*} {*velikost*}<br>
**sudo e2fsck -f** {*/dev/oddíl*} **&amp;&amp; sudo resize2fs** {*/dev/oddíl*}

*# „odformátovat“ oddíl (přepsat: jen značky/celou hlavičku/celý oddíl)*<br>
**sudo wipefs -a** [**\-\-backup**] {*/dev/oddíl*}<br>
?<br>
**sudo dd if=/dev/zero of=**{*/dev/oddíl*} [**status=progress**]

*# změnit velikost souborového systému typu btrfs (na udanou velikost/na celý oddíl)*<br>
*// Souborový systém musí být připojený, aby bylo možno změnit jeho velikost!*<br>
**sudo btrfs filesystem resize** {*cílová-velikost-P*} {*/přípojný/bod*}<br>
**sudo btrfs filesystem resize max** {*/přípojný/bod*}<br>

### Odkládací oddíly a soubory

*# **připojit** odkládací oddíl či soubor (obecně/příklady)*<br>
*// Pro odkládací oddíl či soubor platí totéž, co pro běžné diskové oddíly — aby se připojil automaticky při startu systému, musí být odpovídající záznam zapsaný v /etc/fstab!*<br>
**sudo swapon** {*co-připojit*}...<br>
**sudo swapon /mujswap**<br>
**sudo swapon UUID="977bda6f-ce11-4549-9325-c48c360069ef"**

*# **odpojit** odkládací oddíl či soubor/všechny odkládací prostory*<br>
**sudo swapoff** {*co-připojit*}...<br>
**sudo swapoff -a**[**v**]

*# **vypsat** aktivní odkládací oddíly a soubory*<br>
*// Bez sudo vynechá jmenovky a UUID.*<br>
[**sudo**] **swapon \-\-show**[**=NAME,USED,SIZE,PRIO,LABEL,UUID**] <nic>[**\-\-noheadings**] <nic>[**\-\-bytes**]

*# **vytvořit** odkládací soubor*<br>
*// Velikost můžete zadat také v megabajtech (s příponou „M“) či gigabajtech (s příponou „G“). Poznámka: odkládací soubor by měl být na souborovém systému ext4 (popř. ext3 nebo ext2). Umístění na btrfs nedoporučuji, ale prý je možné při dodržení zvláštních podmínek.*<br>
[**sudo**] **fallocate -l** {*velikost-v-bajtech*} {*název-souboru*}<br>
[**sudo**] **chmod 600** {*název-souboru*}<br>
[**sudo**] **mkswap** {*název-souboru*}<br>
**sudo chown root:root** {*název-souboru*}

*# **smazat** odpojený odkládací soubor*<br>
**sudo rm** {*název-souboru*}

*# **naformátovat** odkládací oddíl*<br>
**sudo mkswap** [**-L** {*jmenovka*}] <nic>[**-U** {*požadované-UUID*}] {*/dev/oddíl*}

### Dělení disku

*# GUI (grafické uživatelské rozhraní)*<br>
**sudo gparted**

*# TUI (textové uživatelské rozhraní)*<br>
**sudo cfdisk** {*/dev/zařízení*}

*# CLI (ovládání z terminálu)*<br>
**sudo fdisk** {*/dev/zařízení*}

### Jmenovka (nastavit)

<!--
Poznámka: souborové systémy FAT a NTFS by při nastavování jmenovky měly být odpojené. Souborové systémy ext4 a btrfs mohou být i připojené.
-->

*# nastavit/smazat jmenovku **odkládacího** oddílu*<br>
**sudo swaplabel -L "**{*novájmenovka*}**"** {*/dev/oddíl*}
**sudo swaplabel -L ""** {*/dev/oddíl*}

*# nastavit/smazat jmenovku **ext4***<br>
**sudo e2label** {*/dev/oddíl*} **"**{*novájmenovka*}**"**<br>
**sudo e2label** {*/dev/oddíl*} **""**

*# nastavit/smazat jmenovku **btrfs***<br>
*// „Specifikace oddílu“ je v případě nepřipojeného oddílu „/dev/oddíl“, v případě připojeného oddílu je nutno uvést jeho přípojný bod. Příkaz selže s chybou, pokud uvedete připojený oddíl označením ve tvaru /dev/oddíl! Jmenovka může mít pravděpodobně maximálně 256 bajtů a nesmí obsahovat znak konce řádky nebo nulový bajt.*<br>
**sudo btrfs filesystem label** {*specifikace/oddílu*} **"**{*Nová jmenovka*}**"**<br>
**sudo btrfs filesystem label** {*specifikace/oddílu*} **""**

*# nastavit/smazat jmenovku **FAT32***<br>
*// Jmenovka souborového systému FAT32 může mít nejvýše 11 znaků. Z důvodu kompatibility by měla být tvořena pouze velkými písmeny anglické abecedy, číslicemi, pomlčkami a podtržítky. Ostatní typy systému souborů mají omezení na jmenovku podstatně volnější.*<br>
**sudo fatlabel** {*/dev/oddíl*} **"**{*novájmenovka*}**"**<br>
**sudo fatlabel** {*/dev/oddíl*} **""**

*# nastavit/smazat jmenovku **NTFS***<br>
**sudo ntfslabel** [**\-\-new-serial**] {*/dev/oddíl*} **"**{*novájmenovka*}**"**<br>
**sudo ntfslabel** [**\-\-new-serial**] {*/dev/oddíl*} **""**<br>

*# zjistit jmenovku jakéhokoliv oddílu*<br>
*// Poznámka: pokud byla jmenovka od startu systému (resp. od připojení příslušného zařízení) změněna, tento příkaz může u některých souborových systémů ukazovat původní jmenovku (podle mých zkušeností to tak dělá obyčejným uživatelům u oddílů btrfs; superuživateli však ukáže již aktuální jmenovku).*<br>
**lsblk -ln -o LABEL** {*/dev/oddíl*}
<!--
Viz: https://wiki.archlinux.org/index.php/Persistent_block_device_naming
-->

*# zjistit jmenovku oddílu btrfs (připojeného/nepřipojeného)*<br>
**sudo btrfs filesystem label** {*/přípojný/bod*}<br>
**sudo btrfs filesystem label** {*/dev/oddíl*}

### Degrafmentace, kontrola, TRIM apod.

*# **zkontrolovat** a opravit souborový systém (kromě btrfs/btrfs)*<br>
*// Příkaz „fsck“ pravděpodobně lze použít i se souborovým systémem v souboru, ale nezkoušel/a jsem to.*<br>
**sudo fsck** [**-V**] {*/dev/oddíl*}<br>


*# zkontrolovat souborový systém typu btrfs*<br>
**sudo btrfs check \-\-readonly** [**\-\-progress**] {*/dev/oddíl*}
<!--
**sudo btrfs rescue chunk-recover -v** {*/dev/oddíl*}
?
-->

*# najít chybné bloky (obecně/příklad)*<br>
*// Poznámka: Tento příkaz chybné bloky najde, ale neudělá nic proto, aby se je systém souborů nesnažil používat.*<br>
**sudo badblocks** [**-v**[**v**]] <nic>[**-w**] {*/dev/zařízení-nebo-oddíl*}<br>
**sudo badblocks -vv /dev/sda1**

*# oznámit zařízení nevyužité bloky souborového systému (operace TRIM)(konkrétní soub.systém/všechny dostupné)*<br>
**sudo fstrim** [**-v**] {*/přípojný/bod*}<br>
**sudo fstrim -a** [**-v**]

*# defragmentovat oddíl typu btrfs (pozor!)*<br>
?

*# zkontrolovat **fragmentaci** oddílu typu ext4*<br>
**sudo e4defrag -c** {*/dev/oddíl*}

*# defragmentovat oddíl typu ext4 (pozor!)*<br>
*// Pokud jste začátečník, nedefragmentujte oddíly typu ext4! Obvykle to není potřeba.*<br>
**sudo e4defrag** {*/dev/oddíl*}

### Ostatní

*# je adresář **přípojným bodem**?*<br>
*// Tento příkaz následuje symbolické odkazy. To, že adresář reprezentuje pododdíl btrfs, ho pro účely tohoto příkazu přípojným bodem nečiní.*<br>
**mountpoint** [**-q**] {*cesta*}

*# **zálohovat** diskový oddíl do souboru (přímo/komprimovaný)*<br>
**sudo dd if=**{*/dev/oddíl*} **of=**{*cesta*} [**status=progress**]<br>
**sudo dd if=**{*/dev/oddíl*} [**status=progress**] **\| gzip -n**[**9**] **&gt;**{*cesta.gz*}

*# **obnovit** diskový oddíl (přímo/komprimovaný)*<br>
*// Pozor! Tato operace je nebezpečná! Pokud zadáte chybný cílový oddíl, daný oddíl se nevratně přepíše daty určenými pro ten správný. Pokud velikost zálohy neodpovídá přesně velikosti cílového oddílu, nemusí být oddíl po obnově dobře použitelný. Tento příkaz používejte s velkou opatrností!*<br>
**sudo dd if=**{*cesta*} **of=/dev/**{*oddíl*} [**status=progress**]<br>
**gunzip -cd** {*cesta.gz*} **\| sudo dd of=**{*/dev/oddíl*} [**status=progress**]

## Zaklínadla: LVM

### Fyzické svazky

*# **vytvořit** z celého zařízení/jeho oddílu*<br>
**sudo pvcreate** {*/dev/zařízení*} [**-v**[**v**]]<br>
**sudo pvcreate** {*/dev/oddíl*} [**-v**[**v**]]

*# **smazat***<br>
**sudo pvremove** {*/dev/zařízení-nebo-oddíl*} [**-v**[**v**]]

*# **zkontrolovat***<br>
**sudo pvck** {*/dev/zařízení-nebo-oddíl*}

*# **vypsat** (pro člověka/pro skript)*<br>
**sudo pvs**<br>
**sudo pvs \-\-noheadings \| sed -E 's/^\\s\*(\\S+)\\s.\*$/\\1/'**

*# uvolnit všechno místo na fyzickém svazku*<br>
**sudo pvmove** {*/dev/zařízení-nebo-oddíl*}

### Skupiny svazků

*# **vytvořit***<br>
**sudo vgcreate** {*id-skupiny*} {*/dev/fyzický-svazek*}... [**-v**[**v**]]

*# **přidat** fyzický svazek do skupiny*<br>
**sudo vgextend** {*id-skupiny*} {*/dev/fyzický-svazek*}... [**-v**[**v**]]

*# **odebrat** fyzický svazek ze skupiny*<br>
**sudo pvmove** {*/dev/fyzický-svazek*}<br>
**sudo vgreduce** {*id-skupiny*} {*/dev/fyzický-svazek*}

*# **přejmenovat***<br>
**sudo vgrename** {*id-skupiny*} {*nove-id-skupiny*}

*# **vypsat** (pro člověka/pro skript)*<br>
**sudo vgs**<br>
?

*# **smazat***<br>
**sudo lvremove** {*id-skupiny*}
**sudo vgremove** {*id-skupiny*}

### Logické oddíly

*# **vytvořit** (velikost zadat: absolutně/v procentech velikosti skupiny/v procentech velikosti volného místa/všechno volné místo)*<br>
*// Pro přesnější určení rozměru můžete zadat velikost oddílu v mebibajtech místo gibibajtů (místo přípony „G“ uveďte příponu „M“), ale v takovém případě počítejte s možností, že příkaz zadanout hodnotu může zaokrouhlit o několik mebibajtů nahoru.*<br>
**sudo lvcreate** {*id-skupiny*} **\-\-name** {*id-oddílu*} **\-\-size** {*gibibajtů*}**G** [**-v**[**v**]] <nic>[{*/dev/fyzický-svazek*}]...<br>
**sudo lvcreate** {*id-skupiny*} **\-\-name** {*id-oddílu*} **\-\-extents** {*procenta*}**%VG** [**-v**[**v**]]<br>
**sudo lvcreate** {*id-skupiny*} **\-\-name** {*id-oddílu*} **\-\-extents** {*procenta*}**%FREE** [**-v**[**v**]]<br>
**sudo lvcreate** {*id-skupiny*} **\-\-name** {*id-oddílu*} **\-\-extents 100%FREE** [**-v**[**v**]]

*# **vypsat** (pro člověka/pro skript)*<br>
**sudo lvs**<br>
?

*# **zvětšit** (na velikost/relativně)*<br>
*// Volba \-\-resizefs je podporována pouze pro některé typy systému souborů, zejména pro ext4.*<br>
**sudo lvextend** {*id-skupiny*}**/**{*id-oddílu*} **\-\-size** {*gibibajtů*}**G** [**-v**[**v**]]<br>
**sudo lvextend** {*id-skupiny*}**/**{*id-oddílu*} **\-\-size +**{*gibibajtů*}**G** [**-v**[**v**]] <nic>[**\-\-resizefs**]

*# **zmenšit** (na velikost/relativně)*<br>
*// Pozor! Pokud je na zmenšovaném oddíle souborový systém, musíte ho před zmenšením oddílu zmenšit na odpovídající velikost, jinak dojde ke ztrátě dat! To neplatí, použijete-li zde parametr \-\-resizefs.*<br>
**sudo lvreduce** {*id-skupiny*}**/**{*id-oddílu*} **\-\-size** {*gibibajtů*}**G** [**-v**[**v**]]<br>
**sudo lvreduce** {*id-skupiny*}**/**{*id-oddílu*} **\-\-size +**{*gibibajtů*}**G** [**-v**[**v**]] <nic>[**\-\-resizefs**]

*# **přejmenovat** oddíl*<br>
**sudo lvrename** {*id-skupiny*}**/**{*id-oddílu*} {*nové-id-oddílu*}

*# **smazat** oddíl/všechny oddíly ve skupině*<br>
**sudo lvremove** {*id-skupiny*}**/**{*id-oddílu*} [**-v**[**v**]]<br>
**sudo lvremove** {*id-skupiny*} [**-v**[**v**]]

*# přesunout do jiné skupiny svazků*<br>
?

### Ostatní

*# aktualizovat systémový přehled LVM podle připojených zařízení*<br>
**sudo lvscan \-\-mknodes**

## Zaklínadla: btrfs

### Správa pododdílů

*# **vytvořit** pododdíl (obecně/příklad)*<br>
*// Příklad vytvoří poddíl reprezentováný novým adresářem „test“ v aktuálním adresáři. (Nově vytvářený adresář nesmí předem existovat!)*<br>
**btrfs subvolume create** {*cesta/k/novému/adresáři*}<br>
**btrfs subvolume create test**

*# **smazat** pododdíl*<br>
*// Pokud souborový systém nebyl připojen s volbou „user\_subvol\_rm\_allowed“, smí pododdíl smazat jen superuživatel. Jinak ho smí smazat i jeho vlastní (tzn. vlastník adresáře reprezentujícího pododdíl); pokud je však oddíl neměnný, musí mu tuto vlastnost nejprve odebrat. Vlastník také může pododdíl smazat jako obyčejný adresář příkazem „rm -R“, ale ten bývá pomalejší, protože nejprve projde a smaže všechny soubory a adresáře v daném pododdílu.*<br>
[**btrfs property set** {*cesta/k/pododdílu*} **ro false**]<br>
[**sudo**] **btrfs subvolume delete -c** {*cesta/k/pododdílu*}...

*# vypsat **seznam** pododdílů (s právy superuživatele/bez nich)*<br>
**(cd ** {*/bod/připojení/btrfs*} ** &amp;&amp; pwd &amp;&amp; sudo btrfs subvolume list . | sed -E 's/^(\\S+\\s+){7}path\\s/'"$(pwd | sed -E 's!/!\\\\/!g')"'\\//')**<br>
**find** {*/abs/cesta/přípojného/bodu*} **-type d -printf '%i:%p\\0' \| sed -zE 's/^(1?[<nic>^:]{1,2}|2[01234]<nic>[<nic>^:]|25[0123456])://;t;d' \| tr \\\\0 \\\\n**
<!--
s/^(1?[<nic>^:]{1,2}|2[01234]<nic>[<nic>^:]|25[0123456])://
– Testuje, zda číslo i-uzlu je menší nebo rovno 256. Pokud ano, je to pododdíl a bude vypsán.
-->

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

### Práce se zrcadlenými oddíly

*# **vytvořit** dva zrcadlené oddíly z jednoho samostatného*<br>
?

*# **osamostatnit** oddíl ze zrcadlené dvojice*<br>
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
„man 8 btrfs-send btrfs-receive“. Navíc doporučuji přenosový soubor komprimovat příkazem „gzip“,
čímž získá menší velikost a odolnost proti chybám při přenosu.

*# uložit do souboru rozdíl*<br>
**sudo btrfs send -e**[**v**] **-c** {*/cesta/k/původnímu-klonu*} {*/cesta/k/novému/klonu*} **\| gzip &gt;**{*cílový/soubor.gz*}

*# aplikovat rozdíl*<br>
**zcat** {*soubor.gz*} **\| sudo btrfs receive -e**[**v**] {*výstupní/adresář*}

## Nejdůležitější volby připojení

### Pro všechny typy systému souborů

!Parametry:

* ◉ rw ○ ro :: Připojit pro čtení i zápis/jen pro čtení.
* ◉ dev ○ nodev :: Povolit/zakázat speciální zařízení na připojeném systému souborů. (Doporučuji vždy „nodev“.)
* ◉ exec ○ noexec :: Povolit/zakázat spouštění souborů z připojeného systému souborů.
* ◉ suid ○ nosuid :: Povolit/zakázat respektování příznaků „u+s“ a „g+s“. V případě „nosuid“ tyto příznaky půjde měnit a číst, ale nebudou mít žádný vliv.
* ☐ sync :: Zakáže používání systémové mezipaměti. Všechny operace budou prováděny přímo se zařízením.
* ○ lazytime ◉ nolazytime :: lazytime: Časové známky u souborů se nebudou zapisovat na disk, dokud to nebude nutné; budou se aktualizovat pouze v paměti, což umožní výrazně snížit počet zápisů na disk. Příkaz „sync“ a některé další situace způsobí zapsání všech provedených změn časových známek na disk.
* ◉ relatime ○ strictatime ○ noatime :: Časovou známku přístupu při čtení (access time) aktualizovat: jen pokud soubor či adresář od poslední změny nebyl čten/pokaždé/nikdy.
* ☐ nodiratime :: U adresářů časovou známku přístupu pro čtení (access time) neaktualizovat nikdy.
* ☐ nofail :: Jen se pokusit o připojení; případné selhání tiše ignorovat.
* ☐ noauto :: Nepřipojovat automaticky při startu systému (resp. příkazem „mount -a“).
* ☐ X-mount.mkdir :: Pokud přípojný bod neexistuje, vytvoří ho s přístupovými právy „u=rwx,go=rx“. (Poznámka: připojený adresář tato práva zpravidla přepíše.) Podle manuálové stránky je tato volba dovolena pouze superuživateli.

### Pro ext4, ext3 a ext2

!Parametry:

* ○ errors=remount-ro ○ errors=panic ○ errors=continue :: V případě kritické chyby: připojí systém jen pro čtení/zhroutí se/pokračuje. (Nezkoušel/a jsem.)
* ◉ user\_xattr ○ nouser\_xattr :: Povolí/zakáže uživatelské rozšířené atributy. (ext3/ext4) V případě nouser\_xattr budou uživatelské rozšířené atributy stávajících souborů a adresářů zachovány, ale nepůjdou číst ani zapisovat.
* ◉ acl ○ noacl :: Povolí/zakáže rozšířená přístupová práva. (Zatím jsem nezkoušel/a.)
* ○ discard ○ nodiscard :: Zapne/vypne automatické označování prázdného prostoru na SSD discích (operace TRIM).

### Pro „vfat“ (FAT32, FAT16, FAT12)

<!--
[ ] Vyzkoušet!
-->
!Parametry:

* ☐ uid={*UID*} :: Nastaví vlastníka všech položek.
* ☐ gid={*GID*} :: Nastaví skupinu všech položek.
* ○ umask={*mód*} ○ dmask={*mód*},fmask={*mód*} :: Nastaví přístupová práva všech adresářových položek/všech adresářů a souborů.
* ☐ quiet :: Pokusy o změnu vlastníka, skupiny či přístupových práv nevyvolají chybu.
* ○ fat=12 ○ fat=16 ○ fat=32 :: Vynutí konkrétní verzi FAT (obvykle není potřeba, autodetekce pozná typ správně).

### Pro „ntfs“ (NTFS)

!Parametry:

* ☐ uid={*UID*} :: Nastaví vlastníka všech položek.
* ☐ gid={*GID*} :: Nastaví skupinu všech položek.
* ○ umask={*mód*} :: Nastaví přístupová práva všech adresářových položek.

### Pro „tmpfs“ (ramdisk)

!Parametry:

* ☐ size={*velikost*} :: Nastaví kapacitu „ramdisku“; typicky se používá s příponami „M“ pro mebibajty a „G“ pro gibibajty (např. „size=4G“).
* ☐ uid={*UID*} :: Nastaví počátečního vlastníka kořenového adresáře.
* ☐ gid={*GID*} :: Nastaví počáteční skupinu kořenového adresáře.
* ○ umask={*mód*} :: Nastaví počítační přístupová práva a příznaky kořenového adresáře.

### Pro „btrfs“

!Parametry:

* ☐ user\_subvol\_rm\_allowed :: Umožní smazat pododdíl jeho vlastníkovi (doporučuji).
* ○ compress-force={*hodnota*} ○ compress={*hodnota*} :: Nastavuje výchozí kompresi pro nově vytvořené soubory. Použijte hodnotu „off“ pro žádnou kompresi, „lzo“ pro nenáročnou kompresi, „zstd:10“ pro důkladnou kompresi nebo „zstd:15“ pro maximální kompresi.
* ☐ degraded :: Umožní připojit oddíl zrcadleného systému souborů v situaci, kdy některé ze zařízení není dostupné. Doporučuji skombinovat s volbou „ro“.
* ○ discard ○ nodiscard :: Zapne/vypne automatické označování prázdného prostoru na SSD discích (operace TRIM). Možná není nutné ho zadávat.
* ○ subvol={*/cesta*} ○ subvolid={*id*} :: Připojí zadaný pododdíl namísto výchozího (což je zpravidla ten kořenový). Varování: jeden souborový systém typu btrfs je dovoleno připojit vícenásobně (na různé přípojné body), ale pokud se chcete vyhnout problémům, použijte u všech připojení přesně stejné volby až na „subvol“ či „subvolid“ (vyzkoušel/a jsem, že další volby, které se mohou bezpečně lišit, jsou \*atime a ro/rw).

Manuálová stránka pro zlepšení výkonu doporučuje použít obecnou volbu „noatime“.

## Instalace na Ubuntu

Všechny použité nástroje jsou základními součástmi Ubuntu, kromě nástrojů pro práci s LVM, btrfs a nástroje GParted.
Pokud chcete používat LVM, musíte doinstalovat:

*# *<br>
**sudo apt-get install lvm2**

Pokud chcete používat btrfs, musíte doinstalovat:

*# *<br>
**sudo apt-get btrfs-progs**

Nástroj GParted najdete v balíčku „gparted“:

*# *<br>
**sudo apt-get install gparted**

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

* Pomocí příkazu „mount \-\-bind“ můžete jeden ramdisk připojit na několik různých míst VFS!
* Zadáte-li výměnnou jednotku (např. USB flash disk) v /etc/fstab a tato jednotka nebude dostupná při startu systému, zavádění selže a nabídne vám přechod do záchranného režimu. Proti tomu pomohou volby „nofail“ (v případě jakékoliv chyby se připojení systému souborů tiše přeskočí) a „noauto“ (systém se vůbec nepokusí o připojení, ale oddíl či jednotku půjde připojit zkrácenou syntaxí příkazu „mount“).
* Určitý konkrétní adresář může být použit jako přípojný bod vícenásobně, ale nedoporučuji to (nedává to příliš smysl). Také je možné připojením jiného souborového systému na adresář nadřazený přípojnému bodu překrýt přípojný bod i s jeho obsahem, ale rovněž to nedoporučuji.

### LVM

* V případě změny velikosti oddílu v LVM je třeba samostatně změnit velikost souborového systému a samostatně velikost logického oddílu. Výjimkou je souborový systém „ext4“, u kterého je možné tyto operace sloučit použitím parametru „\-\-resizefs“.
* LVM poskytuje svůj vlastní interpret příkazové řádky, který nabízí pouze příkazy související s LVM (bez zadávání „sudo“). Spustíte ho příkazem „sudo lvm“.

### Btrfs

* Příznak neměnnosti se při klonování nepřenáší; pokud ho nenastavíte (např. parametrem „-r“), do klonů neměnného oddílu půjde zapisovat, což může být velmi užitečné (můžete např. vytvořit neměnný klon pododdílu a později původní pododdíl smazat a nahradit ho obyčejným klonem z neměnného klonu).
* Umístění odkládacího souboru na souborový systém btrfs je možné, ale nedoporučuji to. Přesný postup a související omezení najdete v manuálové stránce zobrazené příkazem „man 5 btrfs“ (kapitola „SWAPFILE SUPPORT“).
* Doporučuji se vyhýbat volbám připojení „subvol“ a „subvolid“; pro připojení pododdílů na různá místa souborového systému raději použijte „mount \-\-bind“, resp. jeho obdobu v /etc/fstab.
* Btrfs se prý nedokáže dobře zotavit ze selhání a chyb (i v manuálové stránce je varování, že program „btrfs check“ může problémy spíš zhoršit než vyřešit) a v případě, že dojde vyhrazený prostor pro metadata, se nuceně přepne do režimu „jen pro čtení“ a je obtížné se z takového stavu zotavit – viz [stránku na superuser.com](https://superuser.com/questions/1419067/btrfs-root-no-space-left-on-device-auto-remount-read-only-cant-balance-cant).
* Pododdíly se prezentují systému jako samostatně připojené souborové systémy; to znamená, že přes hranici pododdílu nemohou vést pevné odkazy, příkaz „find“ s parametrem „-xdev“ otestuje adresář nesestoupí do podadresáře reprezentujícího pododdíl apod.
* Klonování pododdílu je velmi rychlé i u rozsáhlých pododdílů; naopak klonování jednotlivých souborů je sice podstatně rychlejší než jejich kopírování, ale pomalejší než vytváření pevných odkazů na ně.
* Velmi špatná vlastnost Btrfs je, že je asynchronní – operace vypadají, že rychle a úspěšně proběhly, ale za několik minut souborový systém může zhavarovat, když „naslibovanou“ operaci nedokáže provést.

<!--
* Komprese je jen zřídka užitečná. Desítky procent kapacity může ušetřit jen v případě, že velkou část dat lze snadno komprimovat, většina dnes používaných formátů, které zabírají hodně místa, už ale komprimovaná je.
-->

## Další zdroje informací

Pokud hledáte nástroj pro dělení disku ze skriptu, zkuste [sfdisk](http://manpages.ubuntu.com/manpages/focal/en/man8/sfdisk.8.html) (anglicky).

* [Root.cz: Souborový systém Btrfs: vlastnosti a výhody moderního ukládání dat](https://www.root.cz/clanky/souborovy-system-btrfs-vlastnosti-a-vyhody-moderniho-ukladani-dat/)
* [Seriál Logical Volume Manager](https://www.abclinuxu.cz/serialy/lvm)
* [Wikipedie: Logical Volume Management](https://cs.wikipedia.org/wiki/Logical_Volume_Management)
* [Wikipedie: Btrfs](https://cs.wikipedia.org/wiki/Btrfs)
* [Chris Titus Tech: Btrfs Guide](https://christitus.com/btrfs-guide/) (anglicky)
* [LVM Ubuntu Tutorial](https://linuxhint.com/lvm-ubuntu-tutorial/) (anglicky)
* [man lvm](http://manpages.ubuntu.com/manpages/focal/en/man8/lvm.8.html) (anglicky)
* [man 8 btrfs-subvolume](http://manpages.ubuntu.com/manpages/focal/en/man8/btrfs-subvolume.8.html) (anglicky)
* [man 5 btrfs](http://manpages.ubuntu.com/manpages/focal/en/man5/btrfs.5.html) (anglicky)
* [Arch Wiki: LVM](https://wiki.archlinux.org/index.php/LVM) (anglicky)
* [Btrfs Sysadmin Guide](https://btrfs.wiki.kernel.org/index.php/SysadminGuide) (anglicky)
* [Kernel Btrfs Wiki](https://btrfs.wiki.kernel.org/index.php/Main\_Page
https://btrfs.wiki.kernel.org/index.php/Main\_Page) (anglicky)
* [Arch Wiki: Btrfs](https://wiki.archlinux.org/index.php/Btrfs) (anglicky)
* [Balíček Bionic: lvm2](https://packages.ubuntu.com/bionic/lvm2) (anglicky)
* [YouTube: Lesson 20 Managing LVM](https://www.youtube.com/watch?v=m9SNN6IWyZo) (anglicky)
* [YouTube: Combining Drives Together](https://www.youtube.com/watch?v=scMkYQxBtJ4) (anglicky)
* [YouTube: LVM snapshots](https://www.youtube.com/watch?v=N8rUlYL2O_g) (anglicky)
* [Wikipedie: Mount (computing)](https://en.wikipedia.org/wiki/Mount\_\(computing\)) (anglicky)
* [man 8 btrfs-scrub](http://manpages.ubuntu.com/manpages/focal/en/man8/btrfs-scrub.8.html) (anglicky)

!ÚzkýRežim: vyp
