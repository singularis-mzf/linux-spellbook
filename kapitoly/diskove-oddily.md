<!--

Linux Kniha kouzel, kapitola Diskové oddíly
Copyright (c) 2019 Singularis <singularis@volny.cz>

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

Tato kapitola pokrývá dělení pevného disku na oddíly, jejich formátováním, připojováním ručním i automatickým a odpojováním. Zabývá se také prací s ramdisky, odkládacím prostorem a LVM.

Tato verze kapitoly nepokrývá šifrování a nastavování kvót a souborový systém BTRFS.
Rovněž nepokrývá vypalování DVD.

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Zaklínadla (fstab)

*# připojit kořenový systém souborů (obecně/příklad)*<br>
{*diskový-oddíl*} **/** {*soub-systém*} {*nastavení*} **0 1**<br>
**/dev/sda2<tab7>/<tab7>ext4<tab7>errors=remount-ro,discard,nouser\_xattr<tab3>0<tab7>1**

*# připojit jiný než kořenový systém souborů (obecně/příklad)*<br>
*// 2 v posledním poli zapne automatickou kontrolu souboru systémů při startu; tato volba je vhodná pro místní souborové systémy. 0 v posledním poli automatickou kontrolu vypne, ta je vhodná především pro výměnná média a síťové systémy souborů. Rovněž je vhodná pro místní systémy souborů připojované výhradně pro čtení.*<br>
{*co-připojit*} {*soub-systém*} {*nastavení*} **0** {*2-nebo-0*}<br>
**UUID="61bbd562-0694-4561-a8e2-4ccfd004a660" ext4 defaults 0 2**

<!--
3 možnosti „co připojit“:

1) oddíl (např. /dev/sda1)
2) UUID (např. UUID="61bbd562-0694-4561-a8e2-4ccfd004a660")
3) jmenovka (např. LABEL="MojeData")
-->

### Ramdisk

*# připojit ramdisk (fstab)*<br>
*// Velikost se udává nejčastěji v mebibajtech (s příponou M − např. „256M“) nebo gibibajtech (s příponou G − např. „10G“).*<br>
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

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti − ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
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
