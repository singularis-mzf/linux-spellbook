<!--

Linux Kniha kouzel, kapitola Správa uživatelských účtů
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

[ ] Patří do této kapitoly automatické přihlašování? Nebo patří spíš do kapitoly Systém?
Nebo udělat samostatnou kapitolu Zavádění a přihlašování?
[ ] Co znamenají uživatelé guest a nobody?

⊨
-->

# Správa uživatelských účtů

!Štítky: {tematický okruh}{systém}{přístupová práva}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola se zabývá vytvářením, zkoumáním a rušením uživatelských účtů a jejich skupin.
Dále se zabývá nastavováním účtů a skupin z pozice superuživatele (správce systému).

Linuxové operační systémy jsou víceuživatelské, a než je uživateli umožněna práce
se systémem, musí se přihlásit k některému uživatelskému účtu, což určí, jaká oprávnění
budou mít programy, které spustí. V Ubuntu a mnoha dalších linuxových distribucích
se první uživatelský účet (s UID 1000) vytváří při instalaci, další účty se vytvářejí
později. Každý uživatelský účet má svůj domovský adresář, kde se uchovává
veškeré nastavení specifické pro daný účet a obvykle rovněž většina uživatelských souborů.

Do této kapitoly nespadá nastavování přihlašování do systému a většina nastavení
specifických pro určité grafické prostředí (např. nastavení pozadí plochy).
Tato verze kapitoly nepokrývá nastavení avatarů uživatelů a nevysvětluje význam
důležitých systémových skupin (jako např. skupiny „sudo“).

## Definice

* **Uživatelský účet** je v této kapitole systémový účet jednoznačně identifikovaný pomocí **uživatelského jména** a také pomocí čísla **UID**. Existují tři typy uživatelských účtů: **běžný účet** (UID ≥ 1000), **systémový účet** (UID 1 až 999) a **superuživatel** (UID 0). Každý soubor nebo běžící proces přísluší nějakému uživatelskému účtu.
* Běžné účty slouží k přihlášení osob k systému, a to jak v grafickém, tak i v textovém režimu.
* Systémové účty slouží k vnitřním účelům systému, zejména k omezení práv některých démonů.
* Superuživatel „root“ slouží ke správě systému. Má nejvyšší možná oprávnění, neplatí pro něj většina omezení a jako jediný může spouštět procesy s právy jiných uživatelů a skupin bez znalosti jakéhokoliv hesla.
* **Skupina** je množina uživatelských účtů, jednoznačně identifikovaná **názvem skupiny** a také číslem **GID**. Skupina může být prázdná. Do skupin se přihlašují procesy a přiřazují se souborům na disku, kde umožňují efektivně nastavit sdílení adresářů a souborů mezi uživateli. Každý soubor nebo běžící proces přísluší nějaké skupině (vždy jen jedné).
* Každý uživatel je členem právě jedné **výchozí skupiny** (login group)(zpravidla stejnojmenné, ale není to podmínkou).

<!--
[ ] Celé jméno?
-->

### Uživatelé a hesla

Existují tři stavy zabezpečení uživatelského účtu:

* Je-li účet **zabezpečený heslem** (což je obvyklé u běžných účtů), přihlášení k němu je možné jen po zadání daného hesla.
* Je-li účet **uzamčený** (což je běžné u systémových účtů a v Ubuntu je to výchozí stav i u superuživatele), přihlásit se k němu není možné; jeho práva však lze získat použitím příkazu sudo.
* Je-li účet **nezabezpečený**, přihlášení k němu je možné bez omezení.

<!--
Pro skupiny platí:

* Není-li skupina zabezpečena heslem (což je obvyklý stav), mohou se do ní přihlásit jen procesy uživatelů, kteří jsou členy dané skupiny.
* Je-li skupina zabezpečena heslem (což se nedoporučuje), mohou se do ní přihlásit procesy členů skupiny bez hesla a procesy ostatních uživatelů po zadání hesla.
-->
<!--

- uživatel (systémový/běžný) + identifikován pomocí UID
- skupina (systémová/běžná) + identifikována pomocí GID (množina uživatelů)
- shell (příkazový interpret)

-->

!ÚzkýRežim: vyp

## Zaklínadla (správa uživatelů)

### Vytvořit/vypsat/smazat uživatele

*# **vytvořit** nového (běžného) uživatele*<br>
*// Pozor! Celé jméno uživatele nesmí obsahovat znaky čárka a rovná se (, a =), nemělo by obsahovat ani znak dvojtečka. Při použití ne-ASCII znaků program vypíše varování, což je ale na dnešních systémech dost absurdní; doporučuji toto varování ignorovat.*<br>
*// Pokud nezadáte volbu „\-\-disable-login“, příkaz vás hned interaktivně nechá nastavit počáteční heslo nově vzniklého uživatele.*<br>
*// Pokud nezadáte parametr „\-\-ingroup“, s vytvořením nového uživatele se pro něj rovněž vytvoří nová, stejnojmenná výchozí skupina.*<br>
**sudo adduser \-\-gecos "**{*Celé jméno*}**"** [**\-\-disable-login**] <nic>[**\-\-debug**] <nic>[**\-\-shell** {*shell*}] <nic>[**\-\-ingroup** {*název-výchozí-skupiny*}] <nic>[**\-\-uid** {*konkrétní-UID*}] {*nový-uživatel*}

*# **smazat** uživatele*<br>
**sudo deluser** [**\-\-remove-home**] {*uživatel*}

*# **existuje** uživatel? (uspěje, pokud ano)*<br>
**getent passwd** {*uživatel*} **&gt;/dev/null**

*# **vypsat** všechny uživatele kromě systémových/úplně všechny*<br>
**getent passwd \| sed -E '/^([<nic>^:]\*:){2}(0\|[0-9]{4,}):/!d;s/:.\*//'** [**\| LC\_ALL=C.utf8 sort**]<br>
<!--
gawk -F : '$3 == 0 || $3 &gt;= 1000 {print $1;}'** [**\| LC\_ALL=C.utf8 sort**]<br>
-->
**getent passwd \| cut -d : -f 1** [**\| LC\_ALL=C.utf8 sort**]

*# vypsat uživatele, kteří jsou právě přihlášeni k systému (pro člověka/pro skript)*<br>
**who**<br>
?

*# vytvořit nového **systémového** uživatele*<br>
**sudo adduser \-\-system** [**\-\-gid** {*GID-skupiny*}] <nic>[**\-\-uid** {*konkrétní-UID*}] {*nový-uživatel*}

### Heslo uživatele

*# **nastavit** heslo (pro člověka)*<br>
**sudo passwd** {*uživatelské-jméno*}<br>
!: Dvakrát zadat nové heslo. Pokaždé potvrdit Enter.

*# nastavit heslo (pro skript)*<br>
**printf %s\\n "**{*uživatelské-jméno*}**:**{*heslo*}**" ["**{*další-uživatelské-jméno*}**:**{*další-heslo*}**"**]... **\| sudo chpasswd**

*# **zamknout** uživatelský účet*<br>
**sudo passwd -l** {*uživatelské-jméno*}

*# **odemknout** uživatelský účet (alternativy)*<br>
*// Poznámka: Ve většině případů je správným postupem odemknutí hesla jeho nové nastavení. Příkaz „sudo passwd -u“ je možno použít pouze u účtů, které byly zamknuty příkazem  „sudo passwd -l“, v případech, kdy chceme zachovat původní heslo.*<br>
**printf %s\\n "**{*uživatelské-jméno*}**:**{*nové-heslo*}**" \| sudo chpasswd**<br>
**sudo passwd -u** {*uživatelské-jméno*}

*# nastavit **vypršení** hesla/okamžitě vypršet (nezkoušeno)*<br>
*// Vyprší-li platnost hesla, uživatel bude po příštím přihlášení donucen si heslo změnit. Poznámka: vypršení hesla jsem podrobně nezkoušel/a.*<br>
**sudo passwd -x** {*dnů-platnosti*} [**-w** {*kolik-dnů-předem-varovat*}] {*uživatelské-jméno*}<br>
**sudo passwd -e** {*uživatelské-jméno*}

*# vypnout zabezpečení heslem (umožní přihlášení **bez hesla**)*<br>
*// Varování: Než použijete tento příkaz, dobře si rozmyslete, co děláte. Uživatelský účet bez hesla může představovat závažnou bezpečnostní díru ve vašem systému. Nepoužívejte tuto možnost, pokud vám stačí automatické přihlášení („autologin“).*<br>
**sudo passwd -d** {*uživatelské-jméno*}

*# test na typ zabezpečení uživatele: vyžaduje heslo?/je zamčený?/umožňuje přihlášení bez hesla?*<br>
?<br>
?<br>
?

### Vypsat nastavení uživatelského účtu (kromě hesla)

*# vypsat **skupiny**, ve kterých je účet členem (pro člověka/pro skript)*<br>
**groups** {*uživatel*}<br>
**id -Gn** {*uživatel*} **\| tr "&blank;" \\\\n \|** [**LC\_ALL=C.utf8**] **sort**

*# **UID***<br>
**id -u** {*uživatelské-jméno*}<br>
<!--
**getent passwd** {*uživatel*} **\| cut -d : -f 3**
-->

*# **celé jméno***<br>
**getent passwd** {*uživatel*} **\| cut -d : -f 5 \| cut -d , -f 1**

*# **domovský adresář***<br>
**getent passwd** {*uživatel*} **\| cut -d : -f 6**

*# **příkazový interpret***<br>
**getent passwd** {*uživatel*} **\| cut -d : -f 7**

*# uživatelské **jméno** (podle UID)*<br>
**id -un** {*UID*}

*# vypsat uživatelovu **výchozí skupinu** (názvem/GID)*<br>
**id -Gn** {*uživatel*} **\| sed -E 's/\\s.\*//'**<br>
**id -G** {*uživatel*} **\| sed -E 's/\\s.\*//'**

*# získat **avatar***<br>
?

### Změnit nastavení uživatelského účtu (kromě hesla)

*# **celé jméno** (pozor – neplést si s uživatelským jménem!)*<br>
**sudo chfn -f "**{*nové jméno*}**"** {*uživatelské-jméno*}

*# **domovský adresář** (bez přesunu/přesunout)*<br>
**sudo usermod -d** {*/nový/adresář*} {*uživatelské-jméno*}<br>
**sudo usermod -m -d** {*/nový/adresář*} {*uživatelské-jméno*}

*# **avatar***<br>
?
<!--
Vzít obrázek, zkonvertovat na 480x480 PNG 8bit RGB a uložit do souboru
~/.face. Změna se projeví okamžitě.

-->

*# **příkazový interpret** (shell)*<br>
**sudo chsh** [**-s** {*/cesta/k/novému/shellu*}] {*uživatel*}<br>

*# změnit UID*<br>
*// Tento příkaz také rekurzívně projde domovský adresář uživatele a všechny adresářové položky, jejichž je daný uživatel vlastníkem, přepíše na nové UID, aby uživatel jejich vlastníkem zůstal.*<br>
**sudo usermod -u** {*nové-UID*} {*uživatel*}

*# změnit výchozí skupinu*<br>
*// Tento příkaz také rekurzívně projde domovský adresář uživatele a všechny adresářové položky příslušné k původní výchozí skupině přepíše na novou výchozí skupinu.*<br>
**sudo usermod -g** {*název-nové-vých-skup*} **-G "$(id -Gn** {*uživatel*} **\| tr '&blank;' ,)"** {*uživatel*}

*# změnit uživatelské jméno*<br>
*// Tento příkaz nepřejmenuje domovský adresář uživatele!*<br>
**sudo usermod -l** {*nové-už-jméno*} {*původní-už-jméno*}

## Zaklínadla (samospráva uživatele)

### Vypsat nastavení

*# skupiny, ve kterých je členem (pro člověka/pro skript)*<br>
**groups**<br>
**id -Gn \| tr "&blank;" \\\\n \|** [**LC\_ALL=C.utf8**] **sort**<br>

*# domovský adresář (doporučená varianta/spolehlivá varianta)*<br>
**printf %s\\\\n "$HOME"**<br>
**getent passwd $(whoami) \| cut -d : -f 6**

*# **uživatelské jméno**/UID*<br>
**whoami**<br>
**id -u**

*# **celé jméno***<br>
**getent passwd $(whoami) \| cut -d : -f 5 \| cut -d , -f 1**

*# **příkazový interpret***<br>
**getent passwd "$(whoami)" \| cut -d : -f 7**

*# získat **avatar***<br>
?

*# **výchozí skupina** (názvem/GID)*<br>
**id -Gn \| sed -E 's/\\s.\*//'**<br>
**id -G \| sed -E 's/\\s.\*//'**

### Změnit nastavení

*# **heslo** (pro člověka)*<br>
**passwd**<br>
!: Na výzvu zadejte původní heslo. Potvrďte klávesou Enter.<br>
!: Dvakrát zadejte nové heslo. Každé potvrďte klávesou Enter.

*# příkazový **interpret** (pro člověka)*<br>
**chsh** [**-s** {*/cesta/k/novému/interpretu*}]<br>
!: Na výzvu zadejte svoje heslo a potvrďte Enter.

*# změnit **avatar***<br>
?

## Zaklínadla (správa skupin)

### Vytvořit/vypsat/zrušit

*# vytvořit **skupinu** (běžnou/systémovou)*<br>
**sudo addgroup** [**\-\-gid** {*konkrétní-GID*}] {*název-nové-skupiny*}<br>
**sudo addgroup \-\-system** [**\-\-gid** {*konkrétní-GID*}] {*název-nové-skupiny*}

*# **smazat** skupinu*<br>
**sudo delgroup** [**\-\-only-if-empty**] {*skupina*}

*# **vypsat** všechny skupiny kromě systémových/úplně všechny*<br>
**getent group \| sed -E '/^([<nic>^:]\*:){2}(0\|[0-9]{4,}):/!d;s/:.\*//'** [**\| LC\_ALL=C.utf8 sort**]<br>
**getent group \| cut -d : -f 1** [**\| LC\_ALL=C.utf8 sort**]
<!--
**gawk -F : '$3 == 0 || $3 &gt;= 1000 {print $1;}' /etc/group** [**\| LC\_ALL=C.utf8 sort**]<br>
**cut -d : -f 1 /etc/group** [**\| LC\_ALL=C.utf8 sort**]
-->

*# vypsat GID skupiny podle názvu/název podle GID*<br>
**getent group** {*název-skupiny*} **\| cut -d : -f 3**<br>
**getent group** {*GID*} **\| cut -d : -f 1**

*# **existuje** skupina?*<br>
**getent group** {*skupina*} **&gt;/dev/null**

### Přidat/vypsat/odebrat účty

*# **přidat** účet do skupiny (alternativy)*<br>
*// Použít „gpasswd“ bez sudo je oprávněn pouze správce skupiny.*<br>
[**sudo**] **gpasswd -a** {*uživatel*} {*skupina*}<br>
**sudo adduser** {*uživatel*} {*skupina*}

*# **odebrat** účet ze skupiny*<br>
*// Použít „gpasswd“ bez sudo je oprávněn pouze správce skupiny.*<br>
*// Uživatele nelze odebrat z jeho výchozí skupiny. Pokud to chcete udělat, musíme mu nejprve nastavit jinou výchozí skupinu.*<br>
[**sudo**] **gpasswd -d** {*uživatel*} {*skupina*}<br>
**sudo deluser** {*uživatel*} {*skupina*}

*# **vypsat** účty ve skupině (po řádcích)*<br>
?
<!--
**getent group** {*skupina*} **\| sed -E 's/^([<nic>^:]\*:){3}([<nic>^:]\*).\*$/\\2/;/^$/d;s/,/\\n/g'** [**\| LC\_ALL=C.utf8 sort**]
[ ] CHYBA: Nevypisuje účty, pro které je skupina výchozí skupinou! (Použít members?)
-->

*# je účet členem skupiny? (podle názvu/podle GID)(uspěje, pokud ano)*<br>
**id -Gn** {*uživatel*} **\| fgrep -qw** {*název\_skupiny*}<br>
**id -G** {*uživatel*} **\| fgrep -qw** {*GID*}

<!--
**getent group** {*skupina*} **\| sed -E 's/^([<nic>^:]\*:){3}([<nic>^:]\*).\*$/\\2/;/^$/d;s/,/\\n/g' \| fgrep -qx** {*uživatelské-jméno*}

**printf ,%s,\\n "$(getent group** {*skupina*} **\| cut -f : -f 4)" \| fgrep -q ,**{*uživatel*}**,**
-->

*# **vyprázdnit** skupinu (odebrat všechny účty)*<br>
**sudo gpasswd -M ''** {*skupina*}

### Nastavení skupiny (včetně hesla)

*# změnit název skupiny*<br>
**sudo groupmod -n** {*nový-název*} {*původní-název*}

*# změnit GID skupiny*<br>
*// Poznámka: příslušnost souborů na disku ke skupinám se ukládá ve formě GID a tímto příkazem se nezmění, takže se ztratí příslušnost těchto souborů ke skupině (soubory budou odkazovat na původní GID, ale skupina již bude identifikována jiným).*<br>
**sudo groupmod -g** {*nové-GID*} {*skupina*}

*# nastavit/zrušit **správce** skupiny*<br>
*// Správce skupiny může přidávat do skupiny a odebírat ze skupiny odstatní uživatele a nastavovat skupině heslo, ale to vše pouze s pomocí příkazu „gpasswd“.*<br>
**sudo gpasswd -A** {*uživatelské-jméno*}[**,**{*další-správce*}]... {*název\_skupiny*}<br>
**sudo gpasswd -A ""** {*název\_skupiny*}<br>

*# nastavit **heslo** skupiny (pro člověka)*<br>
**sudo gpasswd** {*skupina*}<br>
!: Dvakrát zadat nové heslo. Pokaždé potvrdit Enter.

*# nastavit heslo skupiny (pro skript)*<br>
?

*# zrušit heslo skupiny*<br>
*// Použít „gpasswd“ bez sudo je oprávněn pouze správce skupiny.*<br>
[**sudo**] **gpasswd -r** {*skupina*}

*# je skupina chráněná heslem?*<br>
?

## Zaklínadla (ostatní)

### Formáty souborů

*# formát /etc/passwd*<br>
{*přihlašovací-jméno*}**:x:**{*UID*}**:**{*GID-výchozí-skupiny*}**:**{*celé jméno*}**[,**{*další údaje*}]**:**{*/domovský/adresář*}[**:**{*/výchozí/shell*}]

*# formát /etc/group*<br>
*// Výchozí skupina uživatele nemusí být v souboru /etc/group uvedena. Uživatelský účet je jejím členem i v případě, že zde uvedena není!*<br>
{*název-skupiny*}**:x:**{*GID*}**:**[{*první-člen*}[**,**{*další-člen*}]...]

<!--
### Ostatní
<!- -

*# kteří uživatelé jsou přihlášeni k systému?*<br>
**who -q \| egrep "^#"**
[ ] Vyřešit problémy se „su“ a „sudo“.

-->

<!--
## Parametry příkazů
<!- -
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
- ->
![ve výstavbě](../obrazky/ve-vystavbe.png)

[ ] adduser
[ ] getent?
[ ] passwd
[ ] gpasswd

-->

## Instalace na Ubuntu

Všechny použité nástroje jsou základními součástmi Ubuntu přítomnými i v minimální instalaci.

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

* Jméno uživatelského účtu či název skupiny musí začínat malým písmenem anglické abecedy a ve zbytku může obsahovat malá písmena anglické abecedy, číslice, pomlčky a podtržítka.
* Standardní způsob sdílení určitého adresáře více uživateli spočívá v tom, že vytvoříme skupinu (addgroup), přidáme do ní všechny uživatelské účty (gpasswd -a), které mají adresář sdílet, nastavíme skupinu sdílenému adresáři (chgrp) a nastavíme mu příznak zmocnění skupiny (chmod g+s), aby se skupinová příslušnost rozšířila i na nové podadresáře. V případě malého počtu uživatelů můžeme místo vytvoření nové skupiny použít výchozí skupinu některého z uživatelů.
* Obyčejný uživatel není oprávněn změnit ani svoje vlastní celé jméno.
* Do každého nově vytvořeného domovského adresáře se nakopíruje obsah adresáře „/etc/skel“.
* Používat hesla skupin se nedoporučuje; jsou neintuitivní, nepraktická a jsou s nimi bezpečnostní problémy.

## Další zdroje informací

* man 5 passwd
* man 1 gpasswd
* [Wikipedie: Uživatelský účet v Unixu](https://cs.wikipedia.org/wiki/U%C5%BEivatelsk%C3%BD\_%C3%BA%C4%8Det\_v\_Unixu)
* [YouTube: Linux Add, Delete and Modify Users](https://www.youtube.com/watch?v=DSDsaDnFpWI) (anglicky)
* [YouTube: Linux Tip: How to add and delete user accounts](https://www.youtube.com/watch?v=933Uo9T4kfk) (anglicky)
* [TL;DR stránka „adduser“](https://github.com/tldr-pages/tldr/blob/master/pages/linux/adduser.md) (anglicky)

!ÚzkýRežim: vyp
