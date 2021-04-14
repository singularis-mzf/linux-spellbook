<!--

Linux Kniha kouzel, kapitola Diskové oddíly / LVM
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

----

[ ] Je možno vytvořit k jednomu logickému oddílu víc logických snímků?

-->

# LVM

!Štítky: {tematický okruh}{systém}{LVM}
!FixaceIkon: 1754
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod

Tato podkapitola se zabývá prací s LVM.
LVM (logical volume management) je metoda rozložení oddílů na pevném disku,
která má odstínit uživatele od fyzického rozložení dat a poskytnout
nové možnosti, např. flexibilní rozložení jednoho oddílu přes
několik fyzických disků nebo snadné přemísťování oddílů a změnu jejich velikosti,
často i bez nutnosti restartu počítače.

## Definice

### Obecné definice

* **Logický oddíl** je v LVM obdoba běžného diskového oddílu (tzn. je možno ho naformátovat a používat k ukládání dat); na rozdíl od něj ale nemá pevné fyzické umístění na disku, jeho fyzické umístění je vymezené skupinou svazků, ve které je vytvořen. Logický oddíl LVM je dostupný pod cestou „/dev/{*skupina-svazků*}/{*název-oddílu*}“.
* **Skupina svazků** je v LVM neprázdná pojmenovaná skupina fyzických svazků k vytváření logických oddílů. Data každého logického oddílu se fyzicky nacházejí pouze na fyzických svazcích příslušných do dané skupiny.
* **Fyzický svazek** je v LVM blokové zařízení (celý disk nebo jeho oddíl), které je nastavené a naformátované k ukládání dat logických oddílů. Nemůže to být logický oddíl LVM.
* Normálně je každá skupina svazků **aktivovaná**, což znamená, že její logické oddíly jsou dostupné a je možné je připojit. Skupina svazků, jejíž fyzické svazky se nacházejí na výměnných médiích, se automaticky aktivuje při připojení posledního z nich. Aby však bylo možno tato média odpojit bez vypnutí systému, je nutno skupinu ručně **deaktivovat**, čímž její logické oddíly přestanou být dostupné.
* **Logický snímek** („LVM snapshot“) je (zpravidla dočasný) „klon“ logického oddílu, který při vytvoření sdílí umístění na disku s původním oddílem, ale LVM vytvářením kopií dat při zápisu (copy-on-write) způsobuje, že logický snímek se uživateli jeví jako samostatný oddíl. Nejčastěji se používá k vytvoření krátkodobé neměnné kopie jinak intenzivně zapisovaného diskového oddílu nebo k opakovanému vracení diskového oddílu do určitého výchozího stavu.

!ÚzkýRežim: vyp

## Zaklínadla

### Fyzické svazky

*# **vytvořit** z celého zařízení*<br>
**sudo wipefs -a** {*/dev/zařízení*}<br>
**sudo pvcreate** {*/dev/zařízení*} [**-v**[**v**]]
<!-- wipefs -f ? -->

*# **vytvořit** z oddílu*<br>
**sudo wipefs -a** {*/dev/oddíl*}<br>
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
*// Skupiny tvořené fyzickými svazky na více fyzických discích zvyšují pravděpodobnost ztráty dat, protože když havaruje kterýkoliv zúčastněný disk, přijdete o všechna data v celé skupině svazků. Proto pokud nepotřebujete slučovat úložný prostor na více fyzických discích, preferujte vytváření samostatné skupiny svazků pro fyzické svazky na každém fyzickém disku.*<br>
**sudo vgcreate** {*nazev-skupiny*} {*/dev/fyzický-svazek*}... [**-v**[**v**]]

*# **deaktivovat** skupinu*<br>
**sudo vgchange \-\-verbose \-\-activate n** {*nazev-skupiny*}

*# **přidat** fyzický svazek do skupiny*<br>
**sudo vgextend** {*nazev-skupiny*} {*/dev/fyzický-svazek*}... [**-v**[**v**]]

*# **odebrat** fyzický svazek ze skupiny*<br>
**sudo pvmove** {*/dev/fyzický-svazek*}<br>
**sudo vgreduce** {*nazev-skupiny*} {*/dev/fyzický-svazek*}

*# **přejmenovat***<br>
**sudo vgrename** {*nazev-skupiny*} {*novy-nazev-skupiny*}

*# **vypsat** (pro člověka/pro skript)*<br>
**sudo vgs**<br>
?

*# **smazat***<br>
**sudo lvremove** {*nazev-skupiny*}<br>
**sudo vgremove** {*nazev-skupiny*}

*# aktivovat deaktivovanou skupinu*<br>
*// Tento příkaz obvykle není potřeba, protože po připojení zařízení nebo startu systému se nalezené skupiny obvykle aktivují automaticky.*<br>
**sudo vgchange \-\-verbose \-\-activate y** {*nazev-skupiny*}

### Logické oddíly

*# **vytvořit** (velikost zadat: absolutně/v procentech velikosti skupiny/v procentech velikosti volného místa/všechno volné místo)*<br>
*// Pro přesnější určení rozměru můžete zadat velikost oddílu v mebibajtech místo gibibajtů (místo přípony „G“ uveďte příponu „M“), ale v takovém případě počítejte s možností, že příkaz zadanout hodnotu může zaokrouhlit o několik mebibajtů nahoru.*<br>
**sudo lvcreate** {*nazev-skupiny*} **\-\-name** {*nazev-oddilu*} **\-\-size** {*gibibajtů*}**G** [**-v**[**v**]] <nic>[{*/dev/fyzický-svazek*}]...<br>
**sudo lvcreate** {*nazev-skupiny*} **\-\-name** {*nazev-oddilu*} **\-\-extents** {*procenta*}**%VG** [**-v**[**v**]]<br>
**sudo lvcreate** {*nazev-skupiny*} **\-\-name** {*nazev-oddilu*} **\-\-extents** {*procenta*}**%FREE** [**-v**[**v**]]<br>
**sudo lvcreate** {*nazev-skupiny*} **\-\-name** {*nazev-oddilu*} **\-\-extents 100%FREE** [**-v**[**v**]]

*# vytvořit prokládaný logický oddíl*<br>
*// Nechť N je uvedený „počet-zařízení“. Velikost prokládaného oddílu se rozdělí na N stejných dílů a každý se umístí na jeden fyzický svazek ze zadané skupiny svazků. Pokud se některý z dílů na svůj fyzický svazek nevejde, všechny díly budou zmenšeny společně, aby se tam vešel. Kapacita vytvořeného oddílu bude cca 90% součtu místa zabraného všemi díly prokládaného oddílu (prokládání má zřejmě svoji režii). Příklad: máte ve skupině dva fyzické svazky 2G a jeden 1G a pokusíte se vytvořit prokládaný svazek o velikosti 5G; příkaz ho rozdělí na tři díly o velikosti 1,66G; jenže na třetí fyzický svazek se díl nevejde, tak se všechny zmenší na 1G. Výsledný oddíl tedy zabere 3G (na prvním i druhém svazku zůstane 1G volný) a kapacita nově vzniklého oddílu bude cca 2765M.*<br>
**sudo lvcreate** {*nazev-skupiny*} **\-\-name** {*nazev-oddilu*} {*parametr \-\-size nebo \-\-extents*} **\-\-stripes** {*počet-zařízení*} **\-\-stripesize 64** [**-v**[**v**]]

<!--
*# vytvořit zrcadlený logický oddíl*<br>
?
-->

*# **vypsat** (pro člověka/pro skript)*<br>
**sudo lvs**<br>
?

*# **zvětšit** (na velikost/relativně)*<br>
*// Volba \-\-resizefs je podporována pouze pro některé typy systému souborů, zejména pro ext4.*<br>
**sudo lvextend** {*nazev-skupiny*}**/**{*nazev-oddilu*} **\-\-size** {*gibibajtů*}**G** [**-v**[**v**]]<br>
**sudo lvextend** {*nazev-skupiny*}**/**{*nazev-oddilu*} **\-\-size +**{*gibibajtů*}**G** [**-v**[**v**]] <nic>[**\-\-resizefs**]

*# **zmenšit** (na velikost/relativně)*<br>
*// Pozor! Pokud je na zmenšovaném oddíle souborový systém, musíte ho před zmenšením oddílu zmenšit na odpovídající velikost, jinak dojde ke ztrátě dat! To neplatí, použijete-li zde parametr \-\-resizefs.*<br>
**sudo lvreduce** {*nazev-skupiny*}**/**{*nazev-oddilu*} **\-\-size** {*gibibajtů*}**G** [**-v**[**v**]]<br>
**sudo lvreduce** {*nazev-skupiny*}**/**{*nazev-oddilu*} **\-\-size +**{*gibibajtů*}**G** [**-v**[**v**]] <nic>[**\-\-resizefs**]

*# **přejmenovat** oddíl*<br>
**sudo lvrename** {*nazev-skupiny*}**/**{*nazev-oddilu*} {*nové-id-oddílu*}

*# **smazat** oddíl/všechny oddíly ve skupině*<br>
**sudo lvremove** {*nazev-skupiny*}**/**{*nazev-oddilu*} [**-v**[**v**]]<br>
**sudo lvremove** {*nazev-skupiny*} [**-v**[**v**]]

*# přesunout do jiné skupiny svazků*<br>
*// Přesouvaný oddíl nesmí být připojený a v aktuálním adresáři si toto zaklínadlo potřebuje vytvořit dočasný soubor „temp.dat“. Pokud vám tento název nevyhovuje, můžete použít jiný.*<br>
**sudo lvcreate** {*cíl-skupina*} **\-\-name** {*cíl-název*} **\-\-size $(sudo lvs /dev/**{*pův-skupina*}**/**{*pův-název*} **\-\-noheadings \-\-nosuffix \-\-units b -o size \| sed -E 's/^\\s\*(\\S+)\\s\*$/\\1b/')** [**-v**] **&amp;&amp;**<br>
**sudo dd if=/dev/**{*pův-skupina*}**/**{*pův-název*} **iflag=fullblock,skip\_bytes of=/dev/**{*cíl-skupina*}**/**{*cíl-název*} **oflag=seek\_bytes conv=nocreat,notrunc seek=1M skip=1M** [**status=progress**] **&amp;&amp;**<br>
**sudo dd if=/dev/**{*pův-skupina*}**/**{*pův-název*} **iflag=fullblock,count\_bytes count=1M of=temp.dat** [**status=progress**] **&amp;&amp;**<br>
**sudo dd if=temp.dat iflag=fullblock,count\_bytes count=1M of=/dev/**{*cíl-skupina*}**/**{*cíl-název*} **conv=notrunc,nocreat** [**status=progress**] **&amp;&amp;**<br>
**sudo lvremove** {*pův-skupina*}**/**{*pův-název*} [**-v**] <nic>[**-y**]<br>
[**sudo rm -v temp.dat &amp;&amp;**]

### Logické snímky

*# vytvořit*<br>
*// „velikost-P“ je velikost nově přiděleného prostoru pro alokaci kopií dat vzniklých při zápisu do původního oddílu nebo do logického snímku.*<br>
**sudo lvcreate \-\-snapshot \-\-type snapshot \-\-name** {*id-snimku*} **\-\-size** {*velikost-P*} [**-v**] **/dev/**{*skupina-svazků*}**/**{*puvodni-oddil*}

*# zrušit (bez kopírování)*<br>
**sudo lvremove /dev/**{*skupina-svazků*}**/**{*id-snimku*}

*# přepsat původní oddíl snímkem a snímek odstranit (nutné kopírování)*<br>
*// Pokud je původní oddíl připojený nebo jinak využívaný, nedojde k nakopírování a sloučení ihned, ale až při příští aktivaci logického oddílu (tzn. zpravidla po restartu systému).*<br>
**sudo lvconvert \-\-merge /dev/**{*skupina-svazků*}**/**{*id-snimku*}

*# zvětšit prostor pro logický snímek*<br>
**sudo lvextend** [**-v**] **\-\-size** {*nová-velikost-P*} **/dev/**{*skupina-svazků*}**/**{*id-snimku*}

*# kolik místa z logického snímku je již obsazeno? (pro člověka)*<br>
**sudo lvs** [**/dev/**{*skupina-svazku*}**/**{*nazev-snimku*}]<br>
!: Údaj ve sloupci „Data%“ uvádí, kolik procent prostoru je již obsazeno.

### Ostatní

*# aktualizovat systémový přehled LVM podle připojených zařízení*<br>
**sudo lvscan \-\-mknodes**

## Instalace na Ubuntu

Pokud chcete používat LVM, musíte doinstalovat:

*# *<br>
**sudo apt-get install lvm2**

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

* V případě změny velikosti oddílu v LVM je třeba samostatně změnit velikost souborového systému a samostatně velikost logického oddílu. Výjimkou je souborový systém „ext4“, u kterého je možné tyto operace sloučit použitím parametru „\-\-resizefs“.
* LVM lze použít i na vyjímatelných médiích (např. flash discích); v takovém případě je ale před fyzickým odpojením média potřeba deaktivovat příslušnou skupinu svazků. Je-li skupina svazků rozložena přes více takových médií, automaticky se aktivuje při připojení posledního z nich.
* Při vytváření velkého logického oddílu přes několik SSD disků doporučuji vytvořit raději prokládaný oddíl než normální; sice tím přijde o cca 10% kapacity, ale zato se rozsáhlé zápisy budou rovnoměrně rozkládat mezi všechny disky, což by u SSD disků mělo zvýšit jejich životnost.
* LVM poskytuje svůj vlastní interpret příkazové řádky, který nabízí pouze příkazy související s LVM (bez zadávání „sudo“). Spustíte ho příkazem „sudo lvm“.
* Pokud dojde k zaplnění prostoru pro logický snímek, ten se tím zničí, přijdete o zápisy na něj a budete ho muset smazat. Pokud nechcete, aby k tomu došlo, je třeba pro logický snímek vyhradit cca 110% až 125% velikosti původního oddílu (100% při experimentech nestačilo). V případě zaplnění však nepřijdete o žádná data na původním oddílu.
* Název skupiny svazků nebo logického oddílu smí obsahovat pouze malá a velká písmena anglické abecedy, číslice a znaky „.“, „-“, „+“ a „\_“. Název nesmí začínat pomlčkou a mnoho názvů je vyhrazených (viz „man 8 lvm“).

## Další zdroje informací

* [Seriál Logical Volume Manager](https://www.abclinuxu.cz/serialy/lvm)
* [Wikipedie: Logical Volume Management](https://cs.wikipedia.org/wiki/Logical\_Volume\_Management)
* [LVM Ubuntu Tutorial](https://linuxhint.com/lvm-ubuntu-tutorial/) (anglicky)
* [man lvm](http://manpages.ubuntu.com/manpages/focal/en/man8/lvm.8.html) (anglicky)
* [Arch Wiki: LVM](https://wiki.archlinux.org/index.php/LVM) (anglicky)
* [Balíček Bionic: lvm2](https://packages.ubuntu.com/bionic/lvm2) (anglicky)
* [YouTube: Lesson 20 Managing LVM](https://www.youtube.com/watch?v=m9SNN6IWyZo) (anglicky)
* [YouTube: Combining Drives Together](https://www.youtube.com/watch?v=scMkYQxBtJ4) (anglicky)
* [YouTube: LVM snapshots](https://www.youtube.com/watch?v=N8rUlYL2O\_g) (anglicky)

!ÚzkýRežim: vyp
