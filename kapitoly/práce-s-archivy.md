<!--

Linux Kniha kouzel, kapitola Práce s archivy
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

[ ] Pokrýt také .xz (?)

-->

# Práce s archivy

!Štítky: {tematický okruh}{komprese}{zip}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola uvádí univerzální nástroje pro balení a rozbalování archivů
v mnoha různých formátech a specificky se věnuje nejrozšířenějším
formátům .7z, .zip, .tar, .gz, .tar.gz a .squashfs.

Univerzální nástroje (např. apack a aunpack) nepracují s archivem samy;
místo toho pouze podle přípony rozpoznají jeho typ a zavolají
odpovídající nástroj, je-li v systému nainstalovaný.
Oproti tomu příkazy pro práci s určitým typem archivu (např. 7z, tar či zip)
pracují s archivem samy.

Tato kapitola se nezabývá zálohováním ani správou verzí.
Nepokrývá práci s obrazy souborových systémů ani různé typy softwarových balíčků
(např. .deb či .rpm). Nezabývá se konverzí jednoho archivního formátu na jiný.

Poznámka: Použití „souborů se seznamem“ při psaní této kapitoly nebylo testováno.

GNU Tar je vyvíjen v rámci projektu GNU.

## Definice

* **Archiv** je soubor ve formátu primárně určeném k ukládání a pozdějšímu získání jednoho nebo více souborů libovolného typu spolu s metadaty, popř. i adresářovou strukturou. Většina typů archivů nabízí kompresi, některé také ochranu šifrováním a heslem, případně i další funkce. Za archivy se nepovažují soubory, které sice plní funkci archivu, ale není to jejich hlavní účel, jako např. databázové tabulky, repozitáře gitu či obrazy souborových systémů.
<!--
U softwarových balíčků (např. deb či rpm) to není zcela jednotné, protože technicky vzato o archivy jde, ale jejich primární funkcí je popis instalace softwaru, nikoliv ukládání obecných souborů libovolného typu.
-->
* **Vybalení souboru** je získání obsahu souboru s metadaty či bez nich z archivu.
* **Rozbalení archivu** je vybalení všech souborů a adresářů z archivu do adresáře.

!ÚzkýRežim: vyp

## Zaklínadla

### Univerzální nástroje

*# **rozbalit** archiv*<br>
*// Nezadáte-li cílový adresář parametrem „-X“, pak záleží cílový adresář na obsahu archivu: 1) Pokud archiv obsahuje pouze jeden soubor, vybalí se do aktuálního adresáře. 2) Jinak se vytvoří nový adresář se jménem odvozeným od jména archivu a vybalené soubory se uloží do něj. 3) Pokud takový adresář existuje, vybalené soubory se uloží do adresáře s názvem ve tvaru „Unpack-XXXX“, kde X jsou náhodné číslice.*<br>
**aunpack** [**-X** {*cílová/cesta*}] {*archiv.přípona*}

*# **vybalit** soubor či adresář*<br>
**aunpack** [**-X** {*cílová/cesta*}] {*archiv.přípona*} {*cesta/v/archivu*}...

*# **vytvořit** nový archiv a uložit do něj soubory a adresáře*<br>
**apack** {*archiv.přípona*} {*cesta*}...

*# **vypsat** soubory a adresáře v archivu (pro člověka)*<br>
*// Formát výstupu je závislý na typu archivu.*<br>
**als** {*archiv.přípona*}

*# vypsat soubory a adresáře (pro skript)*<br>
?

*# vybalit konkrétní soubor na standardní výstup*<br>
**acat** {*archiv.přípona*} {*cesta/v/archivu*}

*# vypsat jen strukturu adresářů v archivu*<br>
?

*# vytvořit nový archiv a uložit do něj soubory (vstup ve formátu find -print0)*<br>
{*zdroj*} **\| apack -0** {*archiv.přípona*}

*# porovnat obsahy odpovídajících souborů ve dvou archivech*<br>
**adiff** {*archiv.přípona*} {*druhý-archiv.přípona*}

### 7Z

Příkaz „7z“ primárně podporuje formát .7z, ale podle manuálové stránky
umí vytvořit také archivy formátů .bz2, .gz, .tar, .wim, .xz a .zip
a rozbalit mnoho dalších formátů (ačkoliv na některé z nich volá
externí programy).

*# **rozbalit** archiv*<br>
**7z x** [**-o**{*cílový/adresář*}] {*archiv.přípona*}

*# **vybalit** soubor či adresář (alternativy)*<br>
*// Volba -spd vypne intepretaci vzorků v cestách. Při zadávání cest mimo archiv je to žádoucí, protože zde vzorky obecně intepretuje už příkazový interpret a není žádoucí, aby je 7z interpretoval znovu, ale u cest v archivu je nutné je interpretovat na straně 7z, takže pokud nehodláte vybalovat soubory, které ve svých názvech obsahují otazníky, hvězdičky či hranaté závorky, je vhodnější tento parametr vynechat.*<br>
**7z x** [**-spd**] <nic>[**-o**{*cílový/adresář*}] {*archiv.přípona*} {*vzorek/cesty/v/archivu*}...<br>
**7z x** [**-spd**] <nic>[**-o**{*cílový/adresář*}] {*archiv.přípona*} **@**{*soubor-se-seznamem*}

*# **vybalit** konkrétní soubor na standardní výstup*<br>
**7z x -so** [**-spd**] {*archiv.přípona*} {*cesta/v/archivu*}

*# **vytvořit** archiv a uložit do něj soubory či adresáře (alternativy)*<br>
**7z a -spd** {*archiv.přípona*} {*cesta*}...<br>
**7z a -spd** {*archiv.přípona*} **@**{*soubor-se-seznamem*}

*# **vypsat** soubory a adresáře v archivu (pro člověka)*<br>
**7z l** {*archiv.přípona*}

*# **přidat** soubory či adresáře do archivu*<br>
**7z a -spd** {*archiv.přípona*} {*cesta*}...<br>
**7z a -spd** {*archiv.přípona*} **@**{*soubor-se-seznamem*}

*# **smazat** soubory či adresáře z archivu (alternativy)*<br>
**7z d** [**-spd**] {*archiv.přípona*} {*cesta/v/archivu*}...<br>
**7z d** [**-spd**] {*archiv.přípona*} [**@**{*soubor-se-seznamem*}]

*# **vytvořit** archiv, uložit do něj soubory či adresáře a ochránit heslem*<br>
*// Tato ochrana heslem by měla být kompatibilní s programy pro práci s formátem 7z v jiných operačních systémech.*<br>
**7z a -p -spd** [**-mhe=on**] {*archiv.přípona*} {*cesta*}...<br>
**7z a -p -spd** [**-mhe=on**] {*archiv.přípona*} **@**{*soubor-se-seznamem*}

*# otestovat integritu archivu*<br>
**7z t** {*archiv.přípona*}

### TAR

*# **rozbalit** archiv*<br>
**tar x**[**v**]**f** {*archiv.tar*}

*# **vybalit** soubor či adresář*<br>
**tar x**[**v**]**f** {*archiv.tar*} {*cesta/v/archivu*}...

*# **vybalit** konkrétní soubor na standardní výstup*<br>
*// Zadáte-li k rozbalení víc souborů, tar je vypíše v pořadí, v jakém jsou uloženy v archivu; ne v pořadí, v jakém jste je zadal/a.*<br>
**tar xOf** {*archiv.tar*} {*cesta/v/archivu*}...

*# **vytvořit** archiv a uložit do něj soubory a adresáře*<br>
**tar c**[**v**]**f** {*archiv.tar*} {*cesta*}...

*# **vypsat** soubory a adresáře v archivu*<br>
**tar tf** {*archiv.tar*}

*# **přidat** soubory či adresáře do archivu*<br>
*// Pozor, pokud soubory v archivu již existují, přidají se znovu, takže skončíte s archivem, ve kterém je několik souborů identifikovaných stejnou cestou. S takovým archivem se pak obtížně pracuje.*<br>
**tar r**[**v**]**f** {*archiv.tar*} {*cesta*}...

*# **smazat** soubory či adresáře z archivu*<br>
**tar \-\-delete \-\-file** {*archiv.tar*} {*cesta/v/archivu*}...

*# otestovat integritu archivu*<br>
*// Poznámka: tar implementuje jen velmi slabou kontrolu, takže neodhalí náhodné porušení archivu. Dokáže ale odhalit, že archiv byl zkrácen nebo přepsán zcela nesmyslnými daty. V takovém případě vypíše hlášení na standardní chybový výstup a vrátí návratový kód 2.*<br>
**tar tf** {*archiv.tar*} **&gt;/dev/null**

### GZIP

*# **vybalit** soubor (archiv smazat/ponechat)*<br>
**gunzip** {*soubor*}...<br>
**gunzip -k** {*soubor*}...

*# **zabalit** soubor (původní soubor smazat/ponechat)*<br>
**gzip** [**-9**] {*soubor*}...<br>
**gzip -k** [**-9**] {*soubor*}...

*# vybalit soubor na standardní výstup*<br>
**zcat** {*archiv.gz*}...

*# zabalit soubor ze standardního vstupu*<br>
{*zdroj*} **\| gzip** [**-9**] **&gt;** {*archiv.gz*}

*# použití v rouře (zabalit/vybalit)*<br>
{*zdroj*} **\| gzip** [**-9**] **\|** {*cíl*}<br>
{*zdroj*} **\| gunzip \|** {*cíl*}

*# otestovat integritu archivu*<br>
**gzip -t** {*archiv.gz*}

### TAR + GZIP

*# **rozbalit** archiv*<br>
**tar x**[**v**]**zf** {*archiv.tar*}

*# **vybalit** soubor či adresář*<br>
**tar x**[**v**]**zf** {*archiv.tar*} {*cesta/v/archivu*}...

*# **vybalit** soubor na standardní výstup*<br>
**tar xOzf** {*archiv.tar.gz*} {*cesta/v/archivu*}...

*# **vytvořit** nový archiv a uložit do něj soubory a adresáře*<br>
**tar c**[**v**]**zf** {*archiv.tar.gz*} {*cesta*}...

*# **vypsat** soubory a adresáře v archivu*<br>
**tar tzf** {*archiv.tar.gz*}

*# **přidat** soubory či adresáře do archivu*<br>
**gunzip** {*archiv.tar.gz*}<br>
**tar r**[**v**]**f** {*archiv.tar*} {*cesta*}...<br>
**gzip** [**-9**] {*archiv.tar*}

*# **smazat** soubory či adresáře z archivu*<br>
**cp** {*archiv.tar.gz*} {*archiv.tar.gz*}**.old**<br>
**zcat** {*archiv.tar.gz*}**.old \| tar \-\-delete** {*cesta/v/archivu*} **\| gzip** [**-9**] **&gt;** {*archiv.tar.gz*}<br>
**rm** {*archiv.tar.gz*}**.old**

### ZIP

*# **rozbalit** archiv*<br>
**unzip** [**-d** {*cílový/adresář*}] {*archiv.zip*}

*# **vybalit** soubor či adresář*<br>
**unzip** [**-d** {*cílový/adresář*}] {*archiv.zip*} {*vzorek/cesty*}...

*# **vybalit** soubor na standardní výstup*<br>
**unzip -p** {*archiv.zip*} {*vzorek/cesty*}...

*# **vytvořit** nový archiv a uložit do něj soubory a adresáře*<br>
**zip -r** {*archiv.zip*} {*cesta*}...

*# **vytvořit** nový archiv, uložit do něj soubory a adresáře a ochránit heslem*<br>
**zip -re** {*archiv.zip*} {*cesta*}...

*# **vypsat** soubory a adresáře v archivu*<br>
**unzip -l** {*archiv.zip*}

*# **přidat** další soubory či adresáře*<br>
**zip -r** {*archiv.zip*} {*cesta*}...

*# **přidat** další soubory či adresáře a ochránit heslem*<br>
**zip -re** {*archiv.zip*} {*cesta*}...

*# **smazat** z archivu soubory a adresáře*<br>
**zip -d** {*archiv.zip*} {*vzorek/cesty*}...

### SquashFS

Poznámka: Archiv typu SquashFS obsahuje vždy svůj kořenový adresář (zpravidla jménem
„squashfs-root“). Veškerý obsah archivu je pak v podstromu pod tímto adresářem.

*# **rozbalit** archiv*<br>
*// Poznámka: cílový adresář nesmí existovat, bude vytvořen a vybalí se do něj obsah kořenového adresáře archivu.*<br>
**unsquashfs -d** {*cílový/adresář*} [**-no-xattrs**] <nic>[**-info**] {*archiv.squashfs*}

*# **vybalit** soubor či adresář*<br>
*// Poznámka: cílový adresář nesmí existovat, bude vytvořen. Cesty v archivu se zadávají relativně vůči kořenovému adresáři archivu a příkaz k nim pod cílovým adresářem vytvoří odpovídající adresářovou strukturu.*<br>
**unsquashfs -d** {*cílový/adresář*} [**-no-xattrs**] <nic>[**-info**] {*archiv.squashfs*} {*cesta/v/archivu*}...

*# **vybalit** soubor na standardní výstup*<br>
?

*# **vytvořit** nový archiv a uložit do něj soubory a adresáře*<br>
**mksquashfs** {*cesta*}... {*archiv.squashfs*} **-noappend** [**-info**] <nic>[**-keep-as-directory**] <nic>[{*-další-volby*}]...

<!--
*# **vytvořit** nový archiv, uložit do něj soubory a adresáře a ochránit heslem*<br>
*# **přidat** další soubory či adresáře a ochránit heslem*<br>
// není podporováno
-->

*# **vypsat** soubory a adresáře v archivu (pro člověka/pro skript)*<br>
**unsquashfs -lln** {*archiv.squashfs*}
**unsquashfs -l** {*archiv.squashfs*} **\| sed -E '0,/^$/d;/^squashfs-root$/s!$!/!;s/^squashfs-root//'**

*# **přidat** další soubory či adresáře*<br>
**mksquashfs** {*cesta*}... {*archiv.squashfs*} [**-info**] <nic>[**-keep-as-directory**] <nic>[{*-další-volby*}]...

*# **smazat** z archivu soubory a adresáře*<br>
*// Doporučený postup je archiv vybalit, odstranit soubory a adresáře a znovu zabalit.*<br>
**unsquashfs -d** {*dočasný/adresář*} {*archiv.squashfs*}<br>
**rm -Rf** [**\-\-**] {*dočasný/adresář*}**/**{*cesta*} [{*dočasný/adresář*}**/**{*další/cesta*}]...<br>
**mksquashfs** {*dočasný/adresář*} {*archiv.squashfs*} **-noappend**<br>
**rm -Rf** {*dočasný/adresář*}

*# přidat do archivu při vytváření/doplňování adresář*<br>
*// V cestě v archivu musejí být odzvláštněny zpětným lomítkem všechny bílé znaky (např. mezera či tabulátor), znaky „\\“ a „"“ a možná ještě některé další. Takto vytvořenému adresáři nelze nastavit časové známky.*<br>
!: Na konec příkazu mksquashfs doplňte ještě tento parametr (lze použít opakovaně):<br>
**-p "**{*cesta/v archivu*} **d** {*mód*} {*vlastník*} {*skupina*}**"**

*# přidat do archivu při vytváření/doplňování soubor*<br>
*// V cestě v archivu musejí být odzvláštněny zpětným lomítkem všechny bílé znaky (např. mezera či tabulátor), znaky „\\“ a „"“ a možná ještě některé další. Generující příkaz je příkaz interpretu „sh“; mksquashfs v něm nevyžaduje žádné dodatečné odzvláštnění.*<br>
!: Na konec příkazu mksquashfs doplňte ještě tento parametr (lze použít opakovaně):<br>
**-p "**{*cesta/v archivu*} **f** {*mód*} {*vlastník*} {*skupina*} {*generující příkaz*}**"**

*# přidat do archivu při vytváření/doplňování symbolický odkaz*<br>
*// V cestě v archivu musejí být odzvláštněny zpětným lomítkem všechny bílé znaky (např. mezera či tabulátor), znaky „\\“ a „"“ a možná ještě některé další. V obsahu odkazu se neodzvláštňují žádné znaky (ani případný konec řádky).*<br>
!: Na konec příkazu mksquashfs doplňte ještě tento parametr (lze použít opakovaně):<br>
**-p "**{*cesta/v archivu*} **s 777** {*vlastník*} {*skupina*} {*obsah-odkazu*}**"**


## Zaklínadla: Připojení archivů do VFS

### SquashFS

*# **připojit** archiv (jako superuživatel/jako obyčejný uživatel)*<br>
**sudo mount -t squashfs** [**-o** {*volby,připojení*}] {*archiv.squashfs*} {*prázdný/adresář*}<br>
**squashfuse** [**-o** {*volby,připojení*}] {*archiv.squashfs*} {*prázdný/adresář*}

*# **odpojit** archiv (jako superuživatel/jako obyčejný uživatel)*<br>
**sudo umount** {*přípojný/bod*}<br>
**umount** {*přípojný/bod*}

### ZIP, TAR, TAR + GZIP

*# **připojit** archiv zip/tar/tar.gz*<br>
*// Poznámka: uživatel musí mít k uvedenému adresáři právo zápisu a adresář nesmí mít nastaven příznak omezení smazání. Kontrola přístupových práv uvnitř připojeného archivu se chová velmi podivně – uživatel připojivší archiv má vždy práva čtení a zápisu a právo spouštění u adresářů; u souboru má právo spouštění, pokud je nastaveno u „u“, „g“ nebo „o“. Všem ostatním uživatelům včetně superuživatele je zakázán jakýkoliv přístup. Důrazně doporučuji zadat přinejmenším volbu „ro“ nebo zakázat zápis do archivu. Do připojeného archivu sice je možné zapisovat, ale není to efektivní.*<br>
**archivemount** [**-o** [**ro,**]{*volby,připojení*}] {*archiv.přípona*} {*cesta/k/prázdnému/adresáři*}

*# **odpojit** archiv*<br>
**umount** {*cesta/k/adresáři*}

## Instalace na Ubuntu

Nástroje tar, gzip a zip jsou již součástí minimální instalace Ubuntu. Nástroje apack, aunpack,7z a archivemount je nutno nainstalovat:

*# apack, aunpack apod., 7z*<br>
**sudo apt-get install atool p7zip-full** [**archivemount**]<br>
[**sudo apt-get install arc arj lzip lzop march rpm unace unalz**]

*# pro práci s archivy SquashFS (kromě připojování) jsou třeba balíčky:*<br>
**sudo apt-get install squashfs-tools squashfuse**

*# pro plnou podporu formátu RAR (vyžaduje nesvobodný balíček!)*<br>
**sudo apt-get install rar**

*# pro svobodnou podporu formátu RAR (pouze vybalování a vypsání obsahu)*<br>
**sudo apt-get install unrar-free**<br>
**sudo ln -s /etc/alternatives/unrar /usr/local/bin/rar**

*# pokud se později rozhodnete přejít na nesvobodný balíček*<br>
**sudo rm -f /usr/local/bin/rar**<br>
**sudo apt-get purge unrar-free**<br>
**sudo apt-get install rar**

## Ukázka

*# *<br>
**mkdir "Žluťoučký kůň"**<br>
**printf %s\\\\n "žluťoučký kůň" "ŽLUŤOUČKÝ KŮŇ" &gt;"Žluťoučký kůň/příšerně úpěl.txt"**<br>
**apack "žluťoučký kůň příšerně úpěl.7z" "Žluťoučký kůň"**<br>
**rm -R "Žluťoučký kůň"**<br>
**ls -l**<br>
**aunpack "žluťoučký kůň příšerně úpěl.7z"**<br>
**ls -l "Žluťoučký kůň"**<br>
**cat "Žluťoučký kůň/příšerně úpěl.txt"**<br>
**printf %s\\\\n "Nový soubor" &gt;"Žluťoučký kůň/nový.txt"**<br>
**7z a -p -spd "žluťoučký kůň příšerně úpěl.7z" "Žluťoučký kůň/nový.txt"**<br>
!: Zadejte dvakrát po sobě stejné heslo (např. „abc“).<br>
**rm -R "Žluťoučký kůň"**<br>
**aunpack "žluťoučký kůň příšerně úpěl.7z"**<br>
!: Zadejte vámi zvolené heslo.<br>
**ls -l "Žluťoučký kůň"**

!ÚzkýRežim: zap

## Tipy a zkušenosti

* U formátů, které dobře neznáte, doporučuji omezit se jen na vytvoření archivu z adresářové struktury, jeho vypsání a kompletní rozbalení. Ostatní operace mají v různých formátech svoje specifika, která musíte znát, abyste daný archivní formát použili efektivně.
* Heslo v archivu typu ZIP chrání jednotlivé soubory, nikoliv celý archiv. V jednom archivu mohou být jednotlivé soubory chráněny různými hesly, případně některé dostupné bez hesla.
* TAR je asi jediný formát, který do archivu k souborům uloží opravdu všechna metadata včetně přístupových práv, rozšířených atributů, a dokonce i strukturu symbolických a pevných odkazů.
* Při práci s velkými archivy typu TAR je třeba mít na paměti, že většina operací si vynutí sekvenční průchod celým archivem.
* U svobodné implementace vybalování formátu RAR (unrar-free) jsem měl/a problémy s rozbalením některých archivů; pokud selže, může pomoci nesvobodný balíček.

## Další zdroje informací
*# *<br>
**man 7z**<br>
**man atool**<br>
**man zip**<br>
**man unzip**<br>
**man mksquashfs**

* [Manuálová stránka „atool“](http://manpages.ubuntu.com/manpages/focal/en/man1/atool.1.html) (anglicky)
* [Manuálová stránka „7z“](http://manpages.ubuntu.com/manpages/focal/en/man1/7z.1.html) (anglicky)
* [TL;DR stránka „7z“](https://github.com/tldr-pages/tldr/blob/master/pages/common/7z.md) (anglicky)
* [Oficiální stránka 7-Zip](https://www.7-zip.org/) (anglicky)
* [Balíček „atool“](https://packages.ubuntu.com/focal/atool) (anglicky)
* [Balíček „p7zip-full“](https://packages.ubuntu.com/focal/p7zip-full) (anglicky)
* [SquashFS HowTo](https://elinux.org/Squash\_FS\_Howto) (anglicky)
* [Pseudo file example](https://github.com/plougher/squashfs-tools/blob/master/RELEASE-READMEs/pseudo-file.example) (anglicky)

!ÚzkýRežim: vyp
