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

[ ] BTRFS
[ ] Šifrování LVM?
[ ] Připojování obyčejným uživatelem

Článek o btrfs: https://www.root.cz/clanky/souborovy-system-btrfs-vlastnosti-a-vyhody-moderniho-ukladani-dat/

Zpracovat také:
https://www.root.cz/clanky/pripojeni-obrazu-disku-pod-beznym-uzivatelem-bez-opravneni-roota/

Volby připojení:
data=ordered
uhelper=udisks2

-->

# Diskové oddíly

!Štítky: {tematický okruh}{systém}{LVM}{ramdisk}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola se zabývá dělením pevného disku na oddíly, jejich formátováním (zejména souborové systémy ext4, FAT32 a NTFS), údržbou a připojováním (ručním i automatickým). Zabývá se také prací s ramdisky, odkládacím prostorem a LVM.
<!-- a squash-fs.-->

Tato verze kapitoly nepokrývá připojovaní souborových systémů obyčejným uživatelem;
šifrování a nastavování kvót a další typy systému souborů, např. BTRFS a ZFS.
Rovněž nepokrývá síťové souborové systémy, vypalování DVD ani práci s ISO obrazy CD a DVD.
Rovněž nepokrývá práci se systémem souborů SquashFS. U LVM nepokrývá „layouty“ a „snapshoty“.

## Definice

### Obecné definice

* **Systém souborů** je něco, co nabízí adresářovou strukturu kompatibilní se způsobem, jakým Linux nahlíží na adresáře a soubory. Některé systémy souborů jsou „fyzické“ (uložené na skutečném zařízení), jiné jsou čistě virtuální (generované za běhu ovladačem v jádře).
* **Virtuální souborový systém** (VFS) je způsob, jakým Linux nahlíží na strukturu souborů v počítači; není to skutečný systém souborů. Existuje pouze jeden, je pouze pro čtení a neobsahuje nic jiného než prázdný počáteční kořenový adresář. Při startu systému je na tento adresář připojen kořenový adresář kořenového systému souborů.
* **Připojení** systému souborů znamená, že systém vezme existující adresář ve VFS (takzvaný **přípojný bod**, anglicky „mount point“) a „překryje“ ho kořenovým adresářem připojovaného systému souborů včetně jeho vlastnictví, příznaků a přístupových práv. Celá adresářová struktura připojeného systému souborů se pak stane součástí VFS, dostupnou přes daný přípojný bod. Naopak původní překrytý adresář (včetně svého obsahu) tímto z VFS odpadne. Opačným úkonem je **odpojení** systému souborů; při něm dojde k opětovnému zpřístupnění původního adresáře. Zvláštním (ale komplikovaným a méně častým) případem je připojení jiného než kořenového adresáře systému souborů.
* **Typ systému souborů** je buď způsob uložení souborů a adresářů na diskovém oddílu (např. „ext4“) nebo druh ovladače, který poskytuje nějakým způsobem získanou adresářovou strukturu (např. „tmpfs“). Zvláštním typem systému souborů je „swap“, tedy odkládací oddíl, protože ten adresářovou strukturu neposkytuje.
* K identifikaci konkrétního systémů souborů se používají: **UUID**, což je identifikátor souborového systému přidělovaný při formátování (tzn. dalším formátováním se změní); ne všechny souborové systémy mají nějakou formu UUID, ale ext4, FAT32 a NTFS ano; **PARTUUID**, což je identifikátor oddílu na disku, je-li dělen metodou GPT (na discích dělených starší metodou MBR se emuluje, u logických oddílů LVM není dostupný vůbec); **jmenovka**, což je textový identifikátor souborového systému přidělovaný uživatelem, zpravidla při formátování. Poslední možností je cesta k idenfikátoru zařízení v /dev, např. „/dev/sda1“.

### LVM

LVM (logical volume management) je metoda rozložení oddílů na pevném disku, který má
odstínit uživatele od fyzického rozložení dat a poskytnout nové možnosti, např. rozložení
jednoho oddílu přes několik fyzických disků nebo snadné přesouvání oddílů a změnu jejich velikosti, často i bez nutnosti restartu počítače.

* **Logický oddíl** je v LVM obdoba běžného diskového oddílu (tzn. je možno ho naformátovat a používat k ukládání dat); na rozdíl od něj ale nemá pevné fyzické umístění na disku, jeho fyzické umístění je vymezené skupinou svazků, ve které je vytvořen. Logický oddíl LVM je dostupný pod cestou „/dev/{*skupina-svazků*}/{*název-oddílu*}“.
* **Skupina svazků** je v LVM neprázdná pojmenovaná skupina fyzických svazků k vytváření logických oddílů. Data každého logického oddílu se fyzicky nacházejí pouze na fyzických svazcích příslušných do stejné skupiny.
* **Fyzický svazek** je v LVM blokové zařízení (celý disk nebo jeho oddíl), které je nastavené a naformátované k ukládání dat logických oddílů. Nemůže to být logický oddíl.

### Co a kam připojit

V následujících zaklínadlech platí:

{*co-připojit*} může být:

* UUID souborového systému ve tvaru „UUID=61bbd562-0694-4561-a8e2-4ccfd004a660“.
* PARTUUID ve tvaru „PARTUUID=0337a362-e7b3-4c50-a81d-9a5d45755e75“.
* Jmenovka ve tvaru LABEL="Jmenovka" pro připojení diskového oddílu s danou jmenovkou.
* Cesta diskového oddílu či zařízení (např. „/dev/sda1“). Tento tvar je vhodný pouze u logických oddílům LVM či při jednorázovém připojování příkazem „mount“. V ostatních případech se nedoporučuje, protože cesta k diskovému oddílu se může změnit po každém restartu v závislosti na počtu oddílů, připojeném hardware apod.
* U některých typů souborových systémů je to jiný řetězec (např. „tmpfs“, „none“ apod.)
* Existuje ještě tvar pro síťový souborový systém, viz manuálovou stránku „man 5 fstab“.

{*kam-připojit*} může být:

* Absolutní cesta k adresáři, který v dané chvíli ve VFS existuje, ale není ještě přípojným bodem. (V příkazu „mount“ lze zadat i relativní cestu.)
* „none“ pro odkládací prostor.

{*typ-soub-sys*} je identifikátor typu souborového systému (např. ext4, vfat, ntfs, tmpfs apod.) Lze použít i „auto“; systém se pak typ pokusí detekovat automaticky.

{*volby-připojení*} je seznam čárkami oddělených voleb nebo klíčové slovo „defaults“, které má význam „rw,suid,dev,exec,auto,nouser,async“.

!ÚzkýRežim: vyp

## Zaklínadla

### Položky v /etc/fstab

*# připojit kořenový systém souborů (obecně/příklad)*<br>
*// Poznámka: Připojení kořenového systému souborů by mělo být v /etc/fstab první řádkou kromě komentářů a prázdných řádek.*<br>
{*co-připojit*} **/** {*typ-soub-sys*} {*volby-připojení*} **0 1**<br>
**UUID="61bbd562-0694-4561-a8e2-4ccfd004a660"<tab7>/<tab7>ext4<tab7>errors=remount-ro,discard,nouser\_xattr<tab3>0<tab7>1**

*# připojit jiný než kořenový systém souborů (obecně/příklad)*<br>
*// 2 v posledním poli zapne automatickou kontrolu souboru systémů při startu; tato volba je vhodná pro místní souborové systémy. 0 v posledním poli automatickou kontrolu vypne, ta je vhodná především pro výměnná média a síťové systémy souborů. Rovněž je vhodná pro místní systémy souborů připojované výhradně pro čtení.*<br>
{*co-připojit*} {*kam-připojit*} {*typ-soub-sys*} {*volby-připojení*} **0** {*2-nebo-0*}<br>
**/dev/skupina/muj-oddil ext4 defaults 0 2**

*# připojit ramdisk*<br>
*// Velikost se udává nejčastěji v mebibajtech (s příponou M – např. „256M“) nebo gibibajtech (s příponou G – např. „10G“).*<br>
**tmpfs** {*kam-připojit*} **tmpfs size=**{*velikost*}[**,nosuid**]<nic>[**,nodev**]<nic>[**,noexec**]<nic>[**,mode=**{*práva-číselně*}]<nic>[**,uid=**{*UID-vlastníka*}]<nic>[**,gid=**{*GID-skupiny*}]<nic>[**,**{*další,volby*}] **0 0**

*# připojit odkládací oddíl/odkládací soubor*<br>
{*co-připojit*} **none swap sw 0 0**<br>
{*/cesta/k/souboru*} **none swap sw 0 0**

*# připojit adresář z již připojeného systému souborů na nové místo*<br>
**/původní/adresář /nový/adresář none bind 0 0**

<!--
3 možnosti „co připojit“:

1) oddíl (např. /dev/sda1)
2) UUID (např. UUID="61bbd562-0694-4561-a8e2-4ccfd004a660")
3) jmenovka (např. LABEL="MojeData")
-->

### Připojení a odpojení systému souborů

*# připojit systém souborů uvedený v /etc/fstab (alternativy)*<br>
[**sudo**] **mount** {*kam-připojit*}<br>
[**sudo**] **mount** {*co-připojit*}

*# připojit systém souborů libovolně (obecně/příklad)*<br>
**sudo mount -t** {*typ-soub-sys*} **-o** {*volby,připojení*} {*/co/připojit*} {*/kam/připojit*}<br>
**sudo mount -t ext4 -o defaults,nosuid,nodev,lazytime,discard UUID=61bbd562-0694-4561-a8e2-4ccfd004a660 /mnt/abc**

*# odpojit systém souborů*<br>
[**sudo**] **umount** {*kam-připojit*}

*# připojit adresář z již připojeného systému souborů na nový přípojný bod*<br>
*// Poznámka: Tímto příkazem se vytvoří nové, nezávislé připojení existujícího systému souborů.*<br>
**sudo mount \-\-bind** {*/cesta/k/adresáři*} {*/nový/přípojný/bod*}

*# přesunout systém souborů na jiný přípojný bod (alternativa 1)*<br>
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

*# zjistit **zdrojové** zařízení z přípojného bodu/naopak*<br>
**findmnt -nu -o SOURCE** {*/přípojný/bod*}<br>
**findmnt -nu -o TARGET** {*/dev/disknebooddíl*}

*# zjistit **volby připojení***<br>
**findmnt -nu -o OPTIONS** {*/přípojný/bod*}

*# zjistit velikost použité části souborového systému (pro člověka/pro skript)*<br>
**df -h** {*/přípojný/bod*}<br>
**findmnt -bnu -o USED** {*/přípojný/bod*}

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
*// Poznámka: vypsaný seznam může obsahovat i zařízení nedostupná či k ukládání dat nevhodná. Buďte při jejich zkoumání opatrní.*<br>
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
**sudo mke2fs -f ext4** [**-c**[**c**]] <nic>**-v** <nic>[**-E root\_owner=**{*UID*}**:**{*GID*}] <nic>[**-L** {*jmenovka*}] <nic>[**-U** {*UUID*}] <nic>[**-d** {*cesta*}] <nic>[**-F**] {*/dev/zařízení-nebo-oddíl*}<br>
**sudo mke2fs -f ext4 -c -v -U 977bda6f-ce11-4549-9325-c48c360069ef /dev/sda3**

*# formátovat na **FAT32** (obecně/příklad)*<br>
*// Poznámka: jmenovka systémů FAT může být maximálně 11 znaků dlouhá!*<br>
*// Pro formátování na FAT16 či FAT12 nahraďte hodnotu 32 u parametru -F. Tyto staré souborové systémy se dnes už ale v praxi nepoužívají.*<br>
**sudo mkfs.fat -F 32** [**-c**] <nic>[**-h** {*počet-skrytých-sektorů*}] <nic>[**-n "**{*JMENOVKA*}**"**] <nic>[**-v**] {*/dev/oddíl*}

*# formátovat na **NTFS** (obecně/příklad)*<br>
**sudo mkntfs** [**-f**] <nic>[**-v**] <nic>[**-L** {*jmenovka*}] <nic>[**-C**] <nic>[**-U**] {*/dev/zařízení-nebo-oddíl*}<br>
**sudo mkntfs -f -v -L MůjDisk /dev/sda3**

*# změnit velikost souborového systému ext4*<br>
*// Velikost se zadává s příponou (např. „2048M“ nebo „4G“). Pokud ji nezadáte, souborový systém se zvětší tak, aby pokud možno zaplnil celý oddíl. Tip: velikost souborového systému lze obvykle změnit i tehdy, když je souborový systém připojený.*<br>
**sudo e2fsck -f** {*/dev/oddíl*}<br>
**sudo resize2fs** {*/dev/oddíl*} [{*velikost*}]

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
*// Velikost můžete zadat také v megabajtech (s příponou „M“) či gigabajtech (s příponou „G“).*<br>
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

*# nastavit/smazat jmenovku odkládacího oddílu*<br>
**sudo swaplabel -L "**{*novájmenovka*}**"** {*/dev/oddíl*}
**sudo swaplabel -L ""** {*/dev/oddíl*}

*# nastavit/smazat jmenovku ext4*<br>
**sudo e2label** {*/dev/oddíl*} **"**{*novájmenovka*}**"**<br>
**sudo e2label** {*/dev/oddíl*} **""**

*# nastavit/smazat jmenovku FAT32*<br>
?<br>
?

*# nastavit/smazat jmenovku NTFS*<br>
?<br>
?

<!--
*# zjistit jmenovku odkládacího oddílu/ext4/NTFS/FAT32*<br>
**sudo swaplabel** {*/dev/oddíl*} **\| sed -nE 's/^LABEL:\\s\*//;T;p'**<br>
**sudo e2label** {*/dev/oddíl*}<br>
?<br>
?
-->
<!--
Viz: https://wiki.archlinux.org/index.php/Persistent_block_device_naming
-->

### Degrafmentace, kontrola, TRIM apod.

*# zkontrolovat a opravit souborový systém*<br>
*// Příkaz „fsck“ pravděpodobně lze použít i se souborovým systémem v souboru, ale nezkoušel/a jsem to.*<br>
**sudo fsck** [**-V**] {*/dev/oddíl*}

*# najít chybné bloky (obecně/příklad)*<br>
*// Poznámka: Tento příkaz chybné bloky najde, ale neudělá nic proto, aby se je systém souborů nesnažil používat.*<br>
**sudo badblocks** [**-v**[**v**]] <nic>[**-w**] {*/dev/zařízení-nebo-oddíl*}<br>
**sudo badblocks -vv /dev/sda1**

*# oznámit zařízení nevyužité bloky souborového systému (operace TRIM)(konkrétní soub.systém/všechny dostupné)*<br>
**sudo fstrim** [**-v**] {*/přípojný/bod*}<br>
**sudo fstrim -a** [**-v**]

*# zkontrolovat fragmentaci oddílu typu ext4*<br>
**sudo e4defrag -c** {*/dev/oddíl*}

*# defragmentovat oddíl typu ext4 (pozor!)*<br>
*// Pokud jste začátečník, nedefragmentujte oddíly typu ext4! Obvykle to není potřeba.*<br>
**sudo e4defrag** {*/dev/oddíl*}

### Ostatní

*# zálohovat diskový oddíl do souboru (přímo/komprimovaný)*<br>
**sudo dd if=**{*/dev/oddíl*} **of=**{*cesta*} [**status=progress**]<br>
**sudo dd if=**{*/dev/oddíl*} [**status=progress**] **\| gzip -n**[**9**] **&gt;**{*cesta.gz*}

*# obnovit diskový oddíl (přímo/komprimovaný)*<br>
*// Pozor! Tato operace je nebezpečná! Pokud zadáte chybný cílový oddíl, daný oddíl se nevratně přepíše daty určenými pro ten správný. Pokud velikost zálohy neodpovídá přesně velikosti cílového oddílu, nemusí být oddíl po obnově dobře použitelný. Tento příkaz používejte s velkou opatrností!*<br>
**sudo dd if=**{*cesta*} **of=/dev/**{*oddíl*} [**status=progress**]<br>
**gunzip -cd** {*cesta.gz*} **\| sudo dd of=**{*/dev/oddíl*} [**status=progress**]

## Zaklínadla (LVM)

### Fyzické svazky

*# **vytvořit** z celého zařízení/jeho oddílu*<br>
**sudo pvcreate** {*/dev/zařízení*} [**-v**[**v**]]<br>
**sudo pvcreate** {*/dev/oddíl*} [**-v**[**v**]]

*# **smazat***<br>
**sudo pvremove** {*/dev/zařízení-nebo-oddíl*} [**-v**[**v**]]

*# zkontrolovat*<br>
**sudo pvck** {*/dev/zařízení-nebo-oddíl*}

*# vypsat (pro člověka/pro skript)*<br>
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

*# vypsat (pro člověka/pro skript)*<br>
**sudo vgs**<br>
?

*# **smazat***<br>
**sudo lvremove** {*id-skupiny*}
**sudo vgremove** {*id-skupiny*}

### Logické oddíly

*# **vytvořit** (velikost zadat: absolutně/v procentech velikosti skupiny/v procentech velikosti volného místa/všechno volné místo)*<br>
*// Pro přesnější určení rozměru můžete zadat velikost oddílu v mebibajtech místo gibibajtů (místo přípony „G“ uveďte příponu „M“), ale v takovém případě počítejte s možností, že systém zadanou hodnotu mírně zaokrouhlí nahoru.*<br>
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

## Parametry příkazů

### Volby připojení

Nejdůležitější volby připojení pro všechny typy systému souborů:

!Parametry:

* ◉ rw ○ ro :: Připojit pro čtení i zápis/jen pro čtení.
* ◉ dev ○ nodev :: Povolit/zakázat speciální zařízení na připojeném systému souborů. (Doporučuji vždy „nodev“.)
* ◉ exec ○ noexec :: Povolit/zakázat spouštění souborů z připojeného systému souborů.
* ◉ suid ○ nosuid :: Povolit/zakázat respektování příznaků „u+s“ a „g+s“. V případě „nosuid“ tyto příznaky půjde měnit a číst, ale nebudou mít žádný vliv.
* ☐ sync :: Zakáže používání systémové mezipaměti. Všechny operace budou prováděny přímo se zařízením.
* ○ lazytime ◉ nolazytime :: lazytime: Časové známky u souborů se nebudou zapisovat na disk, dokud to nebude nutné; budou se aktualizovat pouze v paměti, což umožní výrazně snížit počet zápisů na disk. Příkaz „sync“ a některé další situace způsobí zapsání všech provedených změn časových známek na disk.
* ◉ relatime ○ strictatime ○ noatime :: Časovou známku přístupu při čtení (access time) aktualizovat: jen pokud soubor či adresář od poslední změny nebyl čten/pokaždé/nikdy.
* ☐ nodiratime :: U adresářů časovou známku přístupu pro čtení (access time) neaktualizovat nikdy.
* ☐ noauto :: Nepřipojovat automaticky při startu systému (resp. příkazem „mount -a“).
* ☐ nofail :: Ignorovat selhání při připojení.
* ☐ X-mount.mkdir :: Pokud přípojný bod neexistuje, vytvoří ho s přístupovými právy „u=rwx,go=rx“. (Poznámka: připojený adresář tato práva zpravidla přepíše.) Podle manuálové stránky je tato volba dovolena pouze superuživateli.

Nejdůležitější volby připojení pro **ext4**, **ext3** a **ext2**:

!Parametry:

* ○ errors=remount-ro ○ errors=panic ○ errors=continue :: V případě kritické chyby: připojí systém jen pro čtení/zhroutí se/pokračuje. (Nezkoušel/a jsem.)
* ◉ user\_xattr ○ nouser\_xattr :: Povolí/zakáže uživatelské rozšířené atributy. (ext3/ext4) V případě nouser\_xattr budou uživatelské rozšířené atributy stávajících souborů a adresářů zachovány, ale nepůjdou číst ani zapisovat.
* ◉ acl ○ noacl :: Povolí/zakáže rozšířená přístupová práva. (Zatím jsem nezkoušel/a.)
* ○ discard ○ nodiscard :: Zapne/vypne automatické označování prázdného prostoru na SSD discích (operace TRIM).

Nejdůležitější volby připojení pro **vfat** (FAT32, FAT16, popř. FAT12):

<!--
[ ] Vyzkoušet!
-->
!Parametry:

* ☐ uid={*UID*} :: Nastaví vlastníka všech položek.
* ☐ gid={*GID*} :: Nastaví skupinu všech položek.
* ○ umask={*mód*} ○ dmask={*mód*},fmask={*mód*} :: Nastaví přístupová práva všech adresářových položek/všech adresářů a souborů.
* ☐ quiet :: Pokusy o změnu vlastníka, skupiny či přístupových práv nevyvolají chybu.
* ○ fat=12 ○ fat=16 ○ fat=32 :: Vynutí konkrétní verzi FAT (obvykle není potřeba, autodetekce pozná typ správně).

Nejdůležitější volby připojení pro **ntfs**:

!Parametry:

* ☐ uid={*UID*} :: Nastaví vlastníka všech položek.
* ☐ gid={*GID*} :: Nastaví skupinu všech položek.
* ○ umask={*mód*} :: Nastaví přístupová práva všech adresářových položek.

Nejdůležitější volby připojení pro **tmpfs** (ramdisk):

!Parametry:

* ☐ size={*velikost*} :: Nastaví kapacitu „ramdisku“; typicky se používá s příponami „M“ pro mebibajty a „G“ pro gibibajty (např. „size=4G“).
* ☐ uid={*UID*} :: Nastaví počátečního vlastníka kořenového adresáře.
* ☐ gid={*GID*} :: Nastaví počáteční skupinu kořenového adresáře.
* ○ umask={*mód*} :: Nastaví počítační přístupová práva a příznaky kořenového adresáře.

## Instalace na Ubuntu

Všechny použité nástroje jsou základními součástmi Ubuntu, kromě nástrojů pro práci s LVM a nástroje GParted.
Pokud chcete používat LVM, musíte doinstalovat:

*# *<br>
**sudo apt-get install lvm2**

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
![ve výstavbě](../obrazky/ve-vystavbe.png)
-->

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Pomocí příkazu „mount \-\-bind“ můžete jeden ramdisk připojit na několik různých míst VFS!
* V případě změny velikosti oddílu v LVM je třeba samostatně změnit velikost souborového systému a samostatně velikost logického oddílu. Výjimkou je souborový systém „ext4“, u kterého je možné tyto operace sloučit použitím parametru „\-\-resizefs“.
* LVM poskytuje svůj vlastní interpret příkazové řádky, který nabízí pouze příkazy související s LVM (bez zadávání „sudo“). Spustíte ho příkazem „sudo lvm“.

## Další zdroje informací

* [Seriál Logical Volume Manager](https://www.abclinuxu.cz/serialy/lvm)
* [Wikipedie: Logical Volume Management](https://cs.wikipedia.org/wiki/Logical_Volume_Management)
* [LVM Ubuntu Tutorial](https://linuxhint.com/lvm-ubuntu-tutorial/) (anglicky)
* man lvm
* [Arch Wiki: LVM](https://wiki.archlinux.org/index.php/LVM) (anglicky)
* [Balíček Bionic](https://packages.ubuntu.com/bionic/lvm2) (anglicky)
* [YouTube: Lesson 20 Managing LVM](https://www.youtube.com/watch?v=m9SNN6IWyZo) (anglicky)
* [YouTube: Combining Drives Together](https://www.youtube.com/watch?v=scMkYQxBtJ4) (anglicky)
* [YouTube: LVM snapshots](https://www.youtube.com/watch?v=N8rUlYL2O_g) (anglicky)

!ÚzkýRežim: vyp
