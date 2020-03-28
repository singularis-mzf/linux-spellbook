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

+ mount
+ LVM
+ BTRFS
+ tmpfs
[ ] sudo fstrim

+ přesunout odkládací oddíly

Článek o btrfs: https://www.root.cz/clanky/souborovy-system-btrfs-vlastnosti-a-vyhody-moderniho-ukladani-dat/

Zpracovat také:
https://www.root.cz/clanky/pripojeni-obrazu-disku-pod-beznym-uzivatelem-bez-opravneni-roota/

Volby připojení:
nodev?
relatime?
data=ordered
uhelper=udisks2
errors=remount-ro
umask/fmask/dmask

-->

# Diskové oddíly

!Štítky: {tematický okruh}{systém}{LVM}{ramdisk}

!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

Tato kapitola se zabývá dělením pevného disku na oddíly, jejich formátováním a připojováním (ručním i automatickým). Zabývá se také prací s ramdisky, odkládacím prostorem, LVM a squash-fs.

Tato verze kapitoly nepokrývá připojovaní souborových systémů obyčejným uživatelem; šifrování a nastavování kvót a souborový systém BTRFS.
Rovněž nepokrývá síťové souborové systémy a vypalování DVD.

## Definice

* **Systém souborů** je něco, co nabízí adresářovou strukturu kompatibilní se způsobem, jakým Linux nahlíží na adresáře a soubory. Některé systémy souborů jsou „fyzické“ (uložené na skutečném zařízení), jiné jsou čistě virtuální (generované za běhu ovladačem v jádře).
* **Virtuální souborový systém** (VFS) je způsob, jakým Linux nahlíží na strukturu souborů v počítači; není to skutečný systém souborů. Existuje pouze jeden, je pouze pro čtení a neobsahuje nic jiného než prázdný počáteční kořenový adresář. Při startu systému je na tento adresář připojen kořenový adresář kořenového systému souborů.
* **Připojení** systému souborů znamená, že systém vezme existující adresář ve VFS (takzvaný **přípojný bod**, anglicky „mount point“) a „překryje“ ho kořenovým adresářem připojovaného systému souborů včetně jeho vlastnictví, příznaků a přístupových práv. Celá adresářová struktura připojeného systému souborů se pak stane součástí VFS, dostupnou přes daný přípojný bod. Naopak původní překrytý adresář (včetně svého obsahu) tímto z VFS odpadne. Opačným úkonem je **odpojení** systému souborů; při něm dojde k opětovnému zpřístupnění původního adresáře. Do VFS lze připojit i jiný než kořenový adresář systému souborů, nicméně k tomu musí být daný systém souborů již připojen jinam.
* **Typ systému souborů** je buď způsob uložení souborů a adresářů na diskovém oddílu (např. ext4) nebo druh ovladače, který poskytuje nějakým způsobem získanou adresářovou strukturu (např. „tmpfs“). Zvláštním typem systému souborů je „swap“, tedy odkládací oddíl, protože ten adresářovou strukturu neposkytuje.

V následujících zaklínadlech platí:

{*co-připojit*} může být:

* UUID ve tvaru „UUID="61bbd562-0694-4561-a8e2-4ccfd004a660"“ pro připojení diskového oddílu s daným UUID.
* Jmenovka ve tvaru LABEL="Jmenovka" pro připojení diskového oddílu s danou jmenovkou.
* Cesta diskového oddílu či zařízení (např. „/dev/sda1“) pro připojení daného oddílu. V /etc/fstab se doporučuje tento tvar nepoužívat, protože na některých počítačích se označení zařízení může při každém restartu změnit. Použití při jednorázovém příkazu „mount“ je ale v pořádku.
* U některých souborových systémů je to jiný řetězec (např. „tmpfs“, „none“ apod.)
* Existuje ještě tvar pro síťový souborový systém, viz manuálovu stránku.

{*kam-připojit*} může být:

* Absolutní cesta k adresáři, který v dané chvíli ve VFS existuje, ale není ještě přípojným bodem. (V příkazu „mount“ lze zadat i relativní cestu.)
* „none“ pro odkládací prostor.

{*soub-systém*} je identifikátor souborového systému (např. ext4, vfat, ntfs, tmpfs apod.) Lze použít i „auto“; systém se pak pokusí detekovat typ systému souborů automaticky.

{*volby-připojení*} je seznam čárkami oddělených voleb nebo klíčové slovo „defaults“, které má význam „rw,suid,dev,exec,auto,nouser,async“.


!ÚzkýRežim: vyp

## Zaklínadla

## Zaklínadla (fstab)

### Položky v /etc/fstab

*# připojit kořenový systém souborů (obecně/příklad)*<br>
{*diskový-oddíl*} **/** {*soub-systém*} {*nastavení*} **0 1**<br>
**/dev/sda2<tab7>/<tab7>ext4<tab7>errors=remount-ro,discard,nouser\_xattr<tab3>0<tab7>1**

*# připojit jiný než kořenový systém souborů (obecně/příklad)*<br>
*// 2 v posledním poli zapne automatickou kontrolu souboru systémů při startu; tato volba je vhodná pro místní souborové systémy. 0 v posledním poli automatickou kontrolu vypne, ta je vhodná především pro výměnná média a síťové systémy souborů. Rovněž je vhodná pro místní systémy souborů připojované výhradně pro čtení.*<br>
{*co-připojit*} {*kam-připojit*} {*soub-systém*} {*nastavení*} **0** {*2-nebo-0*}<br>
**UUID="61bbd562-0694-4561-a8e2-4ccfd004a660" ext4 defaults 0 2**

*# připojit adresář z již připojeného systému souborů na nové místo*<br>
*// Pozor! Tímto způsobem vytváříte „druhé jméno“ pro již připojený souborový systém. Pokud však do některého podadresáře připojíte jiný další souborový systém, bude tento viditelný pouze přes cestu, na kterou byl připojen; stejná cesta v druhém umístění nebude překryta a povede do původního adresáře původního souborového systému.*<br>
**/původní/adresář /nový/adresář none bind 0 0**

<!--
3 možnosti „co připojit“:

1) oddíl (např. /dev/sda1)
2) UUID (např. UUID="61bbd562-0694-4561-a8e2-4ccfd004a660")
3) jmenovka (např. LABEL="MojeData")
-->

### Připojení a odpojení systému souborů

*# připojit systém souborů uvedený v /etc/fstab*<br>
[**sudo**] **mount** {*/přípojný/bod*}

*# připojit systém souborů*<br>
**sudo mount -t** {*typ*} **-o** {*volby,připojení*} {*/co/připojit*} {*/přípojný/bod*}
<!--
<br>
**sudo mount -t** {*typ*} **-o** {*volby,připojení*} **'LABEL=**{*jmenovka*}**'** {*/přípojný/bod*}
-->

*# odpojit systém souborů*<br>
[**sudo**] **umount** {*/přípojný/bod*}

*# připojit adresář z již připojeného systému souborů na nový přípojný bod*<br>
*// Poznámka: Tímto příkazem se vytvoří nové, nezávislé připojení existujícího systému souborů.*<br>
**sudo mount \-\-bind** {*/cesta/k/adresáři*} {*/nový/přípojný/bod*}

*# přesunout systém souborů na jiný přípojný bod*<br>
**sudo mount \-\-make-private** {*/nadřazený/přípojný/bod*} **&amp;&amp;**<br>
**sudo mount \-\-move** {*/původní/přípojný/bod*} {*/nový/přípojný/bod*}

### Ramdisk

*# připojit ramdisk (fstab)*<br>
*// Velikost se udává nejčastěji v mebibajtech (s příponou M – např. „256M“) nebo gibibajtech (s příponou G – např. „10G“).*<br>
**tmpfs** {*/cesta*} **tmpfs size=**{*velikost*}[**,nosuid**]<nic>[**,noexec**]<nic>[**,mode=**{*práva-číselně*}]<nic>[**,uid=**{*UID-vlastníka*}]<nic>[**,gid=**{*GID-skupiny*}]<nic>[**,**{*další,volby*}] **0 0**

### Degrafmentace apod.

*# zkontrolovat fragmentaci oddílu typu ext4*<br>
**sudo e4defrag -c** {*/dev/oddíl*}

*# defragmentovat oddíl typu ext4*<br>
**sudo e4defrag** {*/dev/oddíl*}

*# najít chybné bloky (obecně/příklad)*<br>
*// Poznámka: Tento příkaz chybné bloky najde, ale neudělá nic proto, aby se je systém souborů nesnažil používat.*<br>
**sudo badblocks** [**-v**[**v**]] <nic>[**-w**] {*/dev/zařízení-nebo-oddíl*}<br>
**sudo badblocks -vv /dev/sda1**

*# zkontrolovat a opravit souborový systém*<br>
*// Příkaz „fsck“ pravděpodobně lze použít i se souborovým systémem v souboru.*<br>
**sudo fsck** [**-V**] {*/dev/oddíl*}

### Dělení disku

*# TUI*<br>
**sudo cfdisk** {*/dev/zařízení*}

*# CLI*<br>
**sudo fdisk** {*/dev/zařízení*}

### Formátování

<!--
[**sudo**] **mkfs**
-->

*# formátovat na **ext4** (obecně/příklad)*<br>
*// Maximální velikost jmenovky je 16 bajtů.*<br>
*// Parametr -U přijímá také speciální hodnoty „random“ (vygenerovat náhodné UUID), „time“ (vygenerovat UUID závislé na čase), „clear“ (zrušit UUID).*<br>
**sudo mke2fs -f ext4** [**-c**[**c**]] <nic>**-v** <nic>[**-E root\_owner=**{*UID*}**:**{*GID*}] <nic>[**-L** {*jmenovka*}] <nic>[**-U** {*UUID*}] <nic>[**-d** {*cesta*}] <nic>[**-F**] {*/dev/zařízení-nebo-oddíl*}<br>
**sudo mke2fs -f ext4 -c -v -U 977bda6f-ce11-4549-9325-c48c360069ef /dev/sda3**

*# formátovat na **NTFS** (obecně/příklad)*<br>
**sudo mkntfs** [**-f**] <nic>[**-v**] <nic>[**-L** {*jmenovka*}] <nic>[**-C**] <nic>[**-U**] {*/dev/zařízení-nebo-oddíl*}<br>
**sudo mkntfs -f -v -L MůjDisk /dev/sda3**

<!--
[ ] mkfs.fat => 12|16|32
-->

### Jmenovka

*# zjistit jmenovku odkládacího oddílu/ext4*<br>
**sudo swaplabel** {*/dev/oddíl*} **\| sed -nE 's/^LABEL:\\s\*//;T;p'**<br>
**sudo e2label** {*/dev/oddíl*}

*# nastavit jmenovku odkládacího oddílu/ext4*<br>
**sudo swaplabel -L "**{*novájmenovka*}**"** {*/dev/oddíl*}<br>
**sudo e2label** {*/dev/oddíl*} **"**{*novájmenovka*}**"**

*# smazat jmenovku odkládacího oddílu/ext4*<br>
**sudo swaplabel -L ""** {*/dev/oddíl*}<br>
**sudo e2label** {*/dev/oddíl*} **""**

<!--
Viz: https://wiki.archlinux.org/index.php/Persistent_block_device_naming
-->

### Ostatní

*# zálohovat diskový oddíl do souboru (přímo/komprimovaný)*<br>
**sudo dd if=**{*/dev/oddíl*} **of=**{*cesta*} [**status=progress**]<br>
**sudo dd if=**{*/dev/oddíl*} [**status=progress**] **\| gzip -n**[**9**] **&gt;**{*cesta.gz*}

*# obnovit diskový oddíl (přímo/komprimovaný)*<br>
*// Pozor! Tato operace je nebezpečná! Pokud zadáte chybný cílový oddíl, daný oddíl se nevratně přepíše daty určenými pro ten správný. Pokud velikost zálohy neodpovídá přesně velikosti cílového oddílu, nemusí být oddíl po obnově dobře použitelný. Tento příkaz používejte s velkou opatrností!*<br>
**sudo dd if=**{*cesta*} **of=/dev/**{*oddíl*} [**status=progress**]<br>
**gunzip -cd** {*cesta.gz*} **\| sudo dd of=**{*/dev/oddíl*} [**status=progress**]

*# zjistit přesnou velikost oddílu v bajtech*<br>
**sudo blockdev \-\-getsize64** {*/dev/oddíl*}

*# zjistit přesnou velikost disku v bajtech*<br>
**sudo blockdev \-\-getsize64** {*/dev/zařízení*}

*# zjistit velikost fyzického bloku/logického sektoru (v bajtech)*<br>
**sudo blockdev \-\-getbsz** {*/dev/zařízení*}<br>
**sudo blockdev \-\-getss** {*/dev/zařízení*}

*# zjistit, zda je zařízení jen pro čtení*<br>
**test 1 -eq "$(sudo blockdev \-\-getro** {*/dev/zařízení*}**)"**

## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Volby připojení

<!--
rw,suid,dev,exec,auto,nouser,async
-->

Nejdůležitější volby připojení pro všechny typy systému souborů:

!Parametry:

* ◉ rw ○ ro :: Připojit pro čtení i zápis/jen pro čtení.
* ◉ dev ○ nodev :: Povolit/zakázat speciální zařízení na připojeném systému souborů. (Doporučuji vždy „nodev“.)
* ◉ exec ○ noexec :: Povolit/zakázat spouštění souborů z připojeného systému souborů.
* ◉ suid ○ nosuid :: Povolit/zakázat respektování příznaků „u+s“ a „g+s“. V případě „nosuid“ tyto příznaky půjde měnit a číst, ale nebudou mít žádný vliv.
* ☐ sync :: Zakáže používání systémové mezipaměti. Všechny operace budou prováděny přímo se zařízením.
* ○ lazytime ◉ nolazytime :: lazytime: Časové známky u souborů se nebudou zapisovat na disk, dokud to nebude nutné; budou se provádět pouze v paměti, což umožní výrazně snížit počet zápisů na disk. Příkaz „sync“ a některé další situace způsobí zapsání všech provedených změn časových známek na disk.
* ◉ relatime ○ strictatime ○ noatime :: Časovou známku přístupu při čtení (access time) aktualizovat: jen pokud soubor či adresář od poslední změny nebyl čten/pokaždé/nikdy.
* ☐ nodiratime :: U adresářů časovou známku přístupu pro čtení (access time) neaktualizovat nikdy.
* ☐ noauto :: Nepřipojovat automaticky při startu systému (resp. příkazem „mount -a“).
* ☐ nofail :: Ignorovat selhání při připojení.
* ☐ X-mount.mkdir :: Pokud přípojný bod neexistuje, vytvoří ho s přístupovými právy „u=rwx,go=rx“. (Poznámka: připojený adresář tato práva zpravidla přepíše.) Podle manuálové stránky je tato volba dovolena pouze superuživateli.

Nejdůležitější volby připojení pro **ext4**, **ext3** a **ext2**:

!Parametry:

* ○ errors=remount-ro ○ errors=panic ○ errors=continue :: V případě kritické chyby: připojí systém jen pro čtení/zhroutí se/pokračuje. (Nezkoušel/a jsem.)
* ◉ user\_xattr ○ nouser\_xattr :: Povolí/zakáže uživatelské rozšířené atributy. (ext3/ext4) V případě nouser\_xattr budou uživatelské rozšířené atributy stávajících souborů a adresářů zachovány, ale nepůjdou číst ani zapisovat.
* ◉ acl ○ noacl :: Povolí/zakáže rozšířená přístupová práva. (Zatím jsem nezkoušel/a.)
* ○ discard ○ nodiscard :: Zapne/vypne označování prázdného prostoru na SSD discích (operace TRIM).

Nejdůležitější volby připojení pro **vfat** (FAT32, FAT16, popř. FAT12):

<!--
[ ] Vyzkoušet!
-->
!Parametry:

* ☐ uid={*UID*} :: Nastaví vlastníka všech položek.
* ☐ gid={*GID*} :: Nastaví skupinu všech položek.
* ○ umask={*mód*} ○ dmask={*mód*},fmask={*mód*} :: Nastaví přístupová práva všech adresářových položek/všech adresářů a souborů.
* ☐ quiet :: Pokusy o změnu vlastníka, skupiny či přístupových práv nevyvolají chybu.
* ○ fat=12 ○ fat=16 ○ fat=32 :: Vynutí konkrétní verzi FAT (obvykle není potřeba).

Nejdůležitější volby připojení pro ntfs:

!Parametry:

* ☐ uid={*UID*} :: Nastaví vlastníka všech položek.
* ☐ gid={*GID*} :: Nastaví skupinu všech položek.
* ○ umask={*mód*} :: Nastaví přístupová práva všech adresářových položek.

Nejdůležitější volby připojení pro tmpfs:

!Parametry:

* ☐ size={*velikost*} :: Nastaví kapacitu „ramdisku“; typicky se používá s příponami „M“ pro mebibajty a „G“ pro gibibajty (např. „size=4G“).
* ☐ uid={*UID*} :: Nastaví počátečního vlastníka kořenového adresáře.
* ☐ gid={*GID*} :: Nastaví počáteční skupinu kořenového adresáře.
* ○ umask={*mód*} :: Nastaví počítační přístupová práva a příznaky kořenového adresáře.

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

Všechny použité nástroje jsou základními součástmi Ubuntu.

## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

!ÚzkýRežim: zap

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

Co hledat:

* [Článek na Wikipedii](https://cs.wikipedia.org/wiki/Hlavn%C3%AD_strana)
* Oficiální stránku programu
* Oficiální dokumentaci
* [Manuálovou stránku](http://manpages.ubuntu.com/)
* [Balíček](https://packages.ubuntu.com/)
* Online referenční příručky
* Různé další praktické stránky, recenze, videa, tutorialy, blogy, ...
* Publikované knihy
* [Stránky TL;DR](https://github.com/tldr-pages/tldr/tree/master/pages/common)

!ÚzkýRežim: vyp
