<!--

Linux Kniha kouzel, kapitola Diskové oddíly / Softwarový RAID
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Softwarový RAID

!Štítky: {tematický okruh}{systém}{RAID}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola se zabývá softwarovým RAID (prokládání, zrcadlení a RAID s paritou).

Tato verze kapitoly nepokrývá RAID6 a RAID10.

## Definice

* **Pole** (array) je skupina disků nebo jejich oddílů skombinovaná softwarovým RAID do jednoho blokového zařízení.
* **Dílem** pole (device) se v RAIDu rozumí jednotlivý oddíl disku či celý disk tvořící pole spolu s dalšími takovými díly. Obvykle se každý díl nachází na jiném fyzickém disku.
* Díly pole jsou dvou druhů — **základní díly** (active devices) tvoří pole a jsou aktivně používány; **záložní díly** (spare devices) nejsou používány, ale v případě výpadku některého ze základních dílů se jeden záložní díl stane základním a RAID na něj postupně „nasynchronizuje“ data. Díl pole může být také ve stavech „F“ (selhavší), „R“ (k nahrazení) a možná i dalších.
* Pole je v **degradovaném stavu**, pokud je počet jeho fungujících základních dílů nižší než deklarovaný.

V této kapitole budou pokryty tyto režimy softwarového RAID: prokládání (stripe, RAID0), zrcadlení (mirror, RAID1) a RAID s paritou (RAID5).

Kde máte v zaklínadlech zadat {*md-pole*}, můžete svoje pole identifikovat těmito způsoby:

* Pomocí UUID (např. „/dev/disk/by-uuid/ec2c7d38-“ atd.). Ve skriptech doporučuji preferovat tento způsob.
* Názvem pole (např. „/dev/md/mujraid“). Tento způsob označování doporučuji pro ruční použití; většinou je spolehlivý, ale může způsobit problémy, pokud při vytváření zapomenete parametr „\-\-homehost=any“ nebo pokud dojde ke konfliktu názvů (typicky po připojení výměnných médií s RAID-polem).
* Číslem md-zařízení (např. „/dev/md127“). Toto číslo se může změnit při každém připojení pole, ale může být potřeba v případě práce s neúplně sestaveným polem.
* Jakýmkoliv symbolickým odkazem na jednu z výše uvedených cest.

!ÚzkýRežim: vyp

## Zaklínadla

<!--
mdadm5 -D --scan >>/etc/mdadm/mdadm.conf && update-initramfs -u [-k all]
-->

### Všechny typy polí: zjišťování údajů

*# **dynamické informace** o připojených polích*<br>
**cat /proc/mdstat**

*# podrobné statické informace o některém **poli***<br>
**sudo mdadm \-\-detail** {*md-pole*}

*# statické informace o dílu pole (stručné/podrobné)*<br>
**sudo mdadm \-\-query** {*/dev/díl*}<br>
**sudo mdadm \-\-examine** {*/dev/díl*}

*# **seznam** připojených polí (pro skript)*<br>
**find /dev/disk/by-uuid -type l -xtype b -printf '%f %l\\n' \| sed -nE '/\\/md[0-9]+$/s!(\\.\\.\\/){2}!/dev/!;T;p'**

*# **seznam dílů** připojeného pole (pro skript)*<br>
?
<!--
[ ] nutno opravit: nezohledňuje, že za hranatými závorkami může být ještě stav
**mdpole=**{*md-pole*}
**test -e "$mdpole" &amp;&amp; sed -E "/^$(realpath -e \-\- "$mdpole" \| sed -E 's!.\*/!!')&blank;/!d;"'s![^]]+&blank;!&blank;!;s!&blank;([^][]+)\\\[\\S+\\\]!/dev/\\1\\n!g;s!\\n$!!' /proc/mdstat** [**\| LC\_ALL=C.UTF-8 sort**] **\| egrep .**
-->
<!--
realpath -e \-\- {*md-pole*} **\| sed -E 's!.\*/!!' => získá označení typu „md127“
/^$(...)&blank;/!d — vynechá řádky, které se hledaného pole netýkají
s![^]]+&blank;!&blank;! — vynechá vše až po konec posledního slova, které nekončí hranatou závorkou
s!&blank;([^][]+)\\\[\\S+\\\]!/dev/\\1\\n!g — vyjme označení dílu, přidá před něj /dev a každé umístí na samostatný řádek

egrep . — Selže, pokud bude výstup prázdný.
-->

*# zjistit **UUID** pole*<br>
?
<!--
[**sudo**] **lsblk -rno UUID** {*md-pole*}
// nefunguje; např. po ručním připojení pole nic nevypíše
-->

*# zjistit název pole*<br>
?
<!--
<br>
**readlink /dev/disk/by-uuid/**{*UUID*} **\| sed -E 's/^[^0-9]+//'**
-->

*# zjistit číslo pole*<br>
?


### Všechny typy polí: změny

*# **odpojit** pole*<br>
**sudo mdadm \-\-stop** {*md-pole*}

*# ručně **připojit** existující pole*<br>
*// Toto zaklínadlo budete obvykle potřebovat jen po ručním odpojení pole; jinak systém pole připojuje automaticky, jakmile ho zaregistruje, a stejně automaticky ho rozšiřuje, když narazí na nový díl, který do něj patří).*<br>
**sudo mdadm -A** {*md-pole*} {*/dev/oddíl*}...

*# označit díl jako **selhavší***<br>
*// Díl označený jako „selhavší“ pole okamžitě přestane používat a bude počítat se ztrátou všech dat na něm uložených.*<br>
**sudo mdadm \-\-manage** {*md-pole*} **-f** {*/dev/oddíl*}

*# **přejmenovat** pole*<br>
*// Přejmenováním pole se nezmění jeho UUID, může se však změnit číslo md-zařízení.*<br>
**sudo mdadm \-\-detail** {*md-pole*}<br>
!: Bezpečně si uschovejte seznam dílů pole.<br>
**sudo mdadm \-\-stop** {*md-pole*} **&amp;&amp; sudo mdadm -A /dev/md/**{*nový-název*} **\-\-update=name \-\-name=**{*nový-název*} **\-\-homehost=any** {*/dev/všechny-díly*}...

### Prokládané pole (RAID0)

*# **vytvořit***<br>
**for x in** {*/dev/oddíl*}...**; do sudo wipefs -a "$x"; done**<br>
**sudo mdadm -Cv /dev/md/**{*název*} **\-\-homehost=any -l stripe -n** {*počet-oddílů*} {*/dev/první-oddíl*} {*/dev/další-oddíl*}...
<!--
**sudo mdadm -Cv /dev/md/mojepole -l stripe -n 3 /dev/sdc /dev/sdd1 /dev/sde3**
-->

*# **smazat***<br>
!: Odpojte pole (madm \-\-stop)<br>
**for x in** {*/dev/oddíl*}...**; do sudo mdadm \-\-zero-superblock "$x"; done**<br>

### Zrcadlené pole (RAID1)

*# **vytvořit***<br>
**for x in** {*/dev/oddíl*}...**; do sudo wipefs -a "$x"; done**<br>
**sudo mdadm -Cv /dev/md/**{*název*} **\-\-homehost=any -l mirror -n** {*počet-zákl-dílů*} [**-x** {*počet-záložních-dílů*}] {*/dev/první-oddíl*} {*/dev/další-oddíl*}...
<!--
**sudo mdadm -Cv /dev/md/mojepole -l stripe -n 2 /dev/sdc /dev/sdd1**
-->

*# **smazat***<br>
!: Odpojte pole (madm \-\-stop)<br>
**for x in** {*/dev/oddíl*}...**; do sudo mdadm \-\-zero-superblock "$x"; done**<br>

*# přidat záložní/základní díl*<br>
**sudo mdadm \-\-manage** {*md-pole*} **-va** {*/dev/nový-oddíl*}<br>
**sudo mdadm \-\-grow** {*md-pole*} **-va** {*/dev/nový-oddíl*} **-n** {*nový-počet-zákl-oddílů*}

*# odebrat záložní/základní díl*<br>
**sudo mdadm \-\-manage** {*md-pole*} **-vr** {*/dev/nový-oddíl*}<br>
**sudo mdadm \-\-manage -vf** {*/dev/díl*} **-r** {*/dev/díl*} **&amp;&amp; sudo mdadm \-\-grow -n** {*nový-počet-zákl-oddílů*}

*# zvýšit počet základních dílů na úkor záložních*<br>
**sudo mdadm \-\-grow** {*md-pole*} **-n** {*nový-počet-zákl-dílů*}

*# učinit z některých základních oddílů záložní*<br>
?

*# ručně spustit/ukončit kontrolu konzistence pole*<br>
**sudo tee /sys/devices/virtual/block/$(basename $(realpath** {*md-pole*} **))/md/sync\_action &lt;&lt;&lt;check**<br>
**sudo tee /sys/devices/virtual/block/$(basename $(realpath** {*md-pole*} **))/md/sync\_action &lt;&lt;&lt;idle**

### Pole s paritou (RAID5)

*# **vytvořit***<br>
**for x in** {*/dev/oddíl*}...**; do sudo wipefs -a "$x"; done**<br>
**sudo mdadm -Cv /dev/md/**{*název*} **\-\-homehost=any -l raid5 -n** {*počet-zákl-dílů*} [**-x** {*počet-záložních-dílů*}] {*/dev/oddíl*}...<br>
!: Před dalšími operacemi s polem počkejte, než se uklidní (lze sledovat pomocí „watch -n 1 cat /proc/mdstat“).

*# **smazat***<br>
!: Odpojte pole (madm \-\-stop)<br>
**for x in** {*/dev/oddíl*}...**; do sudo mdadm \-\-zero-superblock "$x"; done**<br>

*# přidat záložní/základní díl*<br>
*// Po přidání základního dílu neprovádějte další zásadní operace s polem, dokud se neuklidní.*<br>
**sudo mdadm \-\-manage** {*md-pole*} **-va** {*/dev/nový-oddíl*}<br>
**sudo mdadm \-\-grow** {*md-pole*} **-va** {*/dev/nový-oddíl*} [**-a** {*/dev/další-nový-oddíl*}]... **-n** {*nový-počet-zákl-dílů*}

*# odebrat záložní díl*<br>
**sudo mdadm \-\-manage** {*md-pole*} **-vr** {*/dev/nový-oddíl*}

*# odebrat základní díl*<br>
?
<!--
**sudo mdadm \-\-grow \-\-array-size ...
**sudo mdadm \-\-manage -vf** {*/dev/díl*} **-r** {*/dev/díl*} **&amp;&amp; sudo mdadm \-\-grow -n** {*nový-počet-zákl-dílů*}
-->

*# zvýšit počet základních dílů na úkor záložních*<br>
**sudo mdadm \-\-grow** {*md-pole*} **-n** {*nový-počet-zákl-dílů*}
<!-- [ ] vyzkoušet -->

*# učinit z některých základních oddílů záložní*<br>
?

*# nahradit díl za běhu jiným oddílem*<br>
**sudo mdadm \-\-manage** {*md-pole*} **-v \-\-replace** {*/dev/díl-k-odstranění*} **-a** {*/dev/nový-oddíl*}<br>
!: Počkejte, než se pole uklidní (lze sledovat pomocí „watch -n 1 cat /proc/mdstat“)<br>
**sudo mdadm \-\-manage** {*md-pole*} **-vr** {*/dev/díl-k-odstranění*}

<!--
[ ] assembly?
-->

<!--
### Nástroje k řešení potíží

*# pokusit se aktivovat všechna nalezená pole, i neúplná*<br> // ?
**sudo mdadm -A \-\-scan**
-->

## Instalace na Ubuntu

Podporu softwarového RAID je nutno doinstalovat:

*# *<br>
**sudo apt-get install mdadm**

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

<!-- * V /etc/fstab uvádějte UUID souborového systému (přidělené při formátování), ne UUID RAID-pole! -->
* Prokládaný RAID nemá redundanci, nemá záložní díly a počet jeho dílů *není možné měnit*. Pokud přijdete o data na kterémkoliv z jeho dílů, přijdete o data v celém poli.
* Ve všech popsaných druzích RAIDu mají všechny díly pole stejnou velikost. Pokud se je pokusíte umístit na různě velké oddíly, RAID z nich použije jen části odpovídající velikosti nejmenšího z nich.
* Máte-li v systému zrcadlené RAID pole, pravděpodobně jednou za měsíc se na něm automaticky spustí kontrola konzistence.

## Další zdroje informací

* [YouTube: Combining Drives Together](https://www.youtube.com/watch?v=scMkYQxBtJ4) (anglicky)
* [How to create RAID arrays with mdadm...](https://www.digitalocean.com/community/tutorials/how-to-create-raid-arrays-with-mdadm-on-ubuntu-18-04) (anglicky)
* [A guide to mdadm](https://raid.wiki.kernel.org/index.php/A\_guide\_to\_mdadm) (anglicky)

!ÚzkýRežim: vyp
