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

[ ] sfdisk
[ ] Pokrýt ovládání programu fdisk.
[ ] Šifrování?
[ ] Připojování obyčejným uživatelem

Zpracovat také:
https://www.root.cz/clanky/pripojeni-obrazu-disku-pod-beznym-uzivatelem-bez-opravneni-roota/

Volby připojení:
data=ordered
uhelper=udisks2

- Na Ubuntu 20.04 je rozsah čísla /dev/md* 0 až 1048575 (2^20-1).

-->

# Diskové oddíly

!Štítky: {tematický okruh}{systém}{LVM}{ramdisk}{odkládací prostor}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola se zabývá dělením pevného disku na oddíly, jejich formátováním
(zejména souborové systémy ext4, btrfs, FAT32 a NTFS), údržbou a připojováním
(ručním i automatickým). Zabývá se také prací s ramdisky a odkládacím prostorem.

Tato verze kapitoly pokrývá jen částečně: dělení pevného disku na oddíly.

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

### Identifikátory souborových systémů

K identifikaci konkrétního systému souborů se používá několik druhů identifikátorů:

* **UUID** je identifikátor přidělovaný souborovému systému při formátování (tzn. dalším formátováním se změní, ale naopak překopírování po bajtech ho neohrozí); ne všechny souborové systémy mají nějakou formu UUID, ale ext4, btrfs, FAT32 a NTFS ano.
* **PARTUUID** je identifikátor oddílu na disku, je-li dělen metodou GPT (na discích dělených starší metodou MBR se emuluje, u logických oddílů LVM není dostupný vůbec).
* **Jmenovka** je textový identifikátor souborového systému přidělovaný uživatelem, zpravidla při formátování.
* Poslední možností je cesta k zařízení v /dev, např. „/dev/sda1“. Tato možnost je preferována u logických oddílů LVM; u oddílů na discích se nedoporučuje, protože cesta k zařízení se může snadno změnit.

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

!ÚzkýRežim: vyp

## Zaklínadla

### Položky v /etc/fstab

*# připojit **kořenový** systém souborů (obecně/příklad)*<br>
*// Poznámka: Připojení kořenového systému souborů by mělo být v /etc/fstab první řádkou kromě komentářů a prázdných řádek.*<br>
{*co-připojit*} **/** {*typ-soub-sys*} {*volby-připojení*} **0 1**<br>
**UUID="61bbd562-0694-4561-a8e2-4ccfd004a660"<tab7>/<tab7>ext4<tab7>errors=remount-ro,discard,nouser\_xattr<tab3>0<tab7>1**

*# **připojit** jiný než kořenový systém souborů (obecně/příklad)*<br>
*// 2 v posledním poli zapne automatickou kontrolu systému souborů při startu; tato volba je vhodná pro místní souborové systémy. 0 v posledním poli automatickou kontrolu vypne, ta je vhodná především pro výměnná média a síťové systémy souborů. Rovněž je vhodná pro místní systémy souborů připojované v režimu jen pro čtení (ro).*<br>
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

*# změnit volby připojení pro již připojený systém souborů*<br>
*// Tento příkaz je výhodný především pro nastavování voleb připojení u souborových systémů na výměnných zařízeních, které si necháte připojit automaticky. Ne všechny volby takto jdou nastavit, proto doporučuji po změně ověřit příkazem „findmnt -nu -o OPTIONS /přípojný/bod“, zda byla úspěšná.*<br>
**sudo mount -o remount,**{*nové,volby*}... {*/přípojný/bod/nebo/zařízení*}

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
*// Jedno zdrojové zařízení může být připojeno na víc přípojných bodů (např. při použití příkazu „mount \-\-bind“); v tom případě příkaz „findmnt“ vypíše každý přípojný bod na samostatný řádek!*<br>
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

*# aktuální počet **přečtených** bajtů od připojení zařízení (pro člověka/pro skript)*<br>
**lkk diskstat** {*/dev/zařízení-nebo-oddíl*}... **\| cut -f 2 \| LC\_ALL=en\_US.UTF-8 numfmt \-\-to=iec \-\-format=%.3f**<br>
**lkk diskstat** {*/dev/zařízení-nebo-oddíl*}... **\| cut -f 2**

*# aktuální počet **zapsaných** bajtů od připojení zařízení (pro člověka/pro skript)*<br>
**lkk diskstat** {*/dev/zařízení-nebo-oddíl*}... **\| cut -f 3 \| LC\_ALL=en\_US.UTF-8 numfmt \-\-to=iec \-\-format=%.3f**<br>
**lkk diskstat** {*/dev/zařízení-nebo-oddíl*}... **\| cut -f 3**

*# přehled přečtených a zapsaných bajtů pro člověka*<br>
**lkk diskstat \| LC\_ALL=en\_US.UTF-8 numfmt \-\-to=iec \-\-field=2,3 \-\-format=%12.3f**

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
**sudo dd iflag=fullblock if=/dev/zero of=**{*/dev/oddíl*} [**status=progress**]

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
*// „Specifikace oddílu“ je v případě nepřipojeného oddílu „/dev/oddíl“, v případě připojeného oddílu je nutno uvést jeho přípojný bod. Příkaz selže s chybou, pokud uvedete připojený oddíl označením ve tvaru /dev/oddíl! Jmenovka může mít pravděpodobně maximálně 256 bajtů a nesmí obsahovat znak konce řádku nebo nulový bajt.*<br>
**sudo btrfs filesystem label** {*specifikace/oddílu*} **"**{*Nová jmenovka*}**"**<br>
**sudo btrfs filesystem label** {*specifikace/oddílu*} **""**

*# nastavit/smazat jmenovku **FAT32***<br>
*// Jmenovka souborového systému FAT32 může mít nejvýše 11 znaků. Z důvodu kompatibility by měla být tvořena pouze velkými písmeny anglické abecedy, číslicemi, pomlčkami a podtržítky. Ostatní typy systému souborů mají omezení na jmenovku podstatně volnější. Souborový systém typu FAT32 by při nastavování jmenovky měl být odpojený.*<br>
**sudo fatlabel** {*/dev/oddíl*} **"**{*novájmenovka*}**"**<br>
**sudo fatlabel** {*/dev/oddíl*} **""**

*# nastavit/smazat jmenovku **NTFS***<br>
*// Souborový systém typu NTFS by při nastavování jmenovky měl být odpojený.*<br>
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
?

*# zkontrolovat souborový systém typu btrfs*<br>
**sudo btrfs check \-\-readonly** [**\-\-progress**] {*/dev/oddíl*}
<!--
**sudo btrfs rescue chunk-recover -v** {*/dev/oddíl*}
?
-->

*# vynulovat volné bloky (ext4/btrfs/FAT32/NTFS)*<br>
*// Příkaz „zerofree“ lze použít jen s odpojeným souborovým systémem!*<br>
**sudo zerofree** [**-v**] {*/dev/oddíl*}<br>
?<br>
?<br>
?
<!--
btrfs: sudo sfill -fllvz {*/přípojný/bod*}
; balíček: secure-delete
[ ] vyzkoušet, zda opravdu nuluje
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
**zcat** {*cesta.gz*} **\| sudo dd of=**{*/dev/oddíl*} [**status=progress**]

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

### Zobrazení ve správcích souborů (pro všechny typy)

Poznámka: funkčnost těchto voleb ve správcích souborů může být různá; mám vyzkoušeno, že Thunar je respektuje; v ostatních správcích raději nejprve vyzkoušejte, zda tam budou fungovat, než se na ně spolehnete.

!Parametry:

* ○ x-gvfs-show ○ x-gvfs-hide :: Systém souborů se má/nemá zobrazovat ve správcích souborů jako jednotka. Pozor: volby „nofail“ a „noauto“ uvedené před touto volbou nemusejí správně fungovat, proto je uvádějte až za ní.
* ☐ x-gvfs-name={*zakódované%20jméno*} :: Nastaví název, pod kterým se bude zobrazovat ve správcích souborů. Může obsahovat i ne-ASCII znaky; naopak ASCII znaky kromě obyčejných písmen a číslic musejí být zakódovany do hexadecimální formy sestávající z procenta a dvou hexadecimálních číslic; nejužitečnější jsou „%20“ (mezera) a „%2C“ (čárka).
* ☐ x-gvfs-icon={*id-ikony*} :: Nastaví ikonu, s jakou se bude zobrazovat ve správcích souborů; zkuste např. „folder-download“.

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

## Instalace na Ubuntu

Všechny použité nástroje jsou základními součástmi Ubuntu, kromě příkazu zerofree a nástroje GParted,
které v případě potřeby musíte doinstalovat:

*# *<br>
**sudo apt-get install gparted zerofree**

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

## Další zdroje informací

Pokud hledáte nástroj pro dělení disku ze skriptu, zkuste [sfdisk](http://manpages.ubuntu.com/manpages/focal/en/man8/sfdisk.8.html) (anglicky).

* [Wikipedie: Mount (computing)](https://en.wikipedia.org/wiki/Mount\_\(computing\)) (anglicky)

!ÚzkýRežim: vyp

## Pomocné funkce a skripty

<!-- https://www.kernel.org/doc/html/latest/admin-guide/iostats.html -->
*# lkk diskstat – vypíše počty čtených a zapsaných bajtů*<br>
**#!/bin/sh**<br>
**exec perl -CSDAL -Mv5.26.0 -Mstrict -Mutf8 -MEnglish -e '**<br>
**my %data; my %rps; my $počet\_chyb = 0;**<br>
**sub array {return @ARG}**<br>
**$OFS = "\\t"; $ORS = "\\n";**<br>
**\{ open(my $f, "&lt;:utf8", "/proc/diskstats") or die("Nemohu otevřít /proc/diskstats");**<br>
<odsadit1>**my $l;**<br>
<odsadit1>**while (defined($l = scalar(readline($f)))) \{**
<odsadit2>**my @f = split(/\\s+/, $l =~ s/\\A\\s+//r);**<br>
<odsadit2>**$data{$f[2]} = [512 \* $f[5], 512 \* $f[9], $f[2]]; # čtení, zápis, označení**<br>
**\}\}**<br>
**if (scalar(@ARGV) == 0) \{**<br>
<odsadit1>**foreach my $x (do { no locale; array(sort {fc($a) cmp fc($b)} keys(%data)); }) \{**
<odsadit2>**my @x = @{$data{$x}};**<br>
<odsadit2>**print("/dev/" . $x[2], @x[0, 1]) if ($x[0] + $x[1] &gt; 0);**<br>
**\}} else \{**<br>
<odsadit1>**foreach my $x (@ARGV) \{**<br>
<odsadit2>**my $z = $rps{$x} // do \{**<br>
<!-- \x{27} = „'“ \x{5c} = „\“ -->
<odsadit3>**my $s = ($x =~ s/\\x{27}/$&amp;\\x{5c}$&amp;$&amp;/rg);**<br>
<odsadit3>**use open("IN", ":utf8"); local $RS = undef;**<br>
<odsadit3>**$rps{$x} = (scalar(readpipe("realpath \-\- \\x{27}${s}\\x{27}")) =~ s/\\n\\z//r);**<br>
<odsadit2>**\};**<br>
<odsadit2>**if (defined($z) &amp;&amp; $z =~ /\\A\\/dev\\// &amp;&amp; defined($data{$z = substr($z, 5)})) \{**<br>
<odsadit3>**$z = $data{$z};**<br>
<odsadit3>**print($x, $z-&gt;[0], $z-&gt;[1]);**<br>
<odsadit2>**\} else \{++$počet\_chyb\}}**<br>
<odsadit1>**exit($počet\_chyb &lt; 254 ? $počet\_chyb : 254);**<br>
**\}' \-\- "$@"**
