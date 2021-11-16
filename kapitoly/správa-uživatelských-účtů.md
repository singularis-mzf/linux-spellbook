<!--

Linux Kniha kouzel, kapitola Správa uživatelských účtů
Copyright (c) 2019-2021 Singularis <singularis@volny.cz>

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
[ ] Prozkoumat účet „Host“ (guest) a možnosti přihlášení k němu.

⊨
-->

# Správa uživatelských účtů

!Štítky: {tematický okruh}{systém}{přístupová práva}
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod

Tato kapitola se zabývá vytvářením, zkoumáním a rušením uživatelských účtů a jejich skupin.
Dále se zabývá nastavováním účtů a skupin z pozice superuživatele (správce systému)
a nastavováním vlastností vlastního účtu (např. hesla) obyčejným uživatelem.

Linuxy jsou víceuživatelské, a než je uživateli umožněna práce
se systémem, musí se přihlásit k některému uživatelskému účtu, což určí, jaká oprávnění
budou mít programy, které spustí. V Ubuntu a mnoha dalších linuxových distribucích
se první uživatelský účet (s UID 1000) vytváří při instalaci, další účty se vytvářejí
později. Každý uživatelský účet má svůj domovský adresář, kde se uchovává
veškeré nastavení specifické pro daný účet a obvykle rovněž většina uživatelských souborů.

## Definice

* **Uživatelský účet** je v této kapitole systémový účet jednoznačně identifikovaný pomocí **uživatelského jména** (také „přihlašovacího jména“; pozor, neplést si s „celým jménem“) a také pomocí čísla **UID**. Existují tři typy uživatelských účtů: **běžný účet** (UID ≥ 1000), **systémový účet** (UID 1 až 999) a **superuživatel** (UID 0). Každý soubor nebo běžící proces přísluší nějakému uživatelskému účtu.
* Běžné účty slouží k přihlášení osob k systému, a to jak v grafickém, tak i v textovém režimu.
* Systémové účty slouží k vnitřním účelům systému, zejména k omezení práv některých démonů.
* Superuživatel „root“ slouží ke správě systému. Má nejvyšší možná oprávnění, neplatí pro něj většina omezení a jako jediný může spouštět procesy s právy jiných uživatelů a skupin bez znalosti jakéhokoliv hesla.
* **Skupina** je množina uživatelských účtů, jednoznačně identifikovaná **názvem skupiny** a také číslem **GID**. Skupina může být prázdná. Skupiny obvykle slouží k přidělování dodatečných práv k těm, která má daný uživatelský účet sám o sobě; umožňují také efektivně nastavit sdílení adresářů a souborů mezi uživateli. Každý soubor nebo běžící proces přísluší nějaké skupině (vždy jen jedné).
* Každý uživatel je členem právě jedné **výchozí skupiny** (login group)(zpravidla stejnojmenné, ale není to podmínkou).

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

## Zaklínadla: Správa uživatelů

### Vytvořit/vypsat/smazat uživatele

*# **vytvořit** nový běžný uživatelský účet (jen interaktivně)*<br>
*// Pozor! Celé jméno uživatele nesmí obsahovat znaky čárka a rovná se (, a =), nemělo by obsahovat ani znak dvojtečka. Při použití ne-ASCII znaků program vypíše varování, což je ale na dnešních systémech dost absurdní; doporučuji toto varování ignorovat.*<br>
*// Pokud nezadáte parametr „\-\-ingroup“, s vytvořením nového uživatele se pro něj rovněž vytvoří nová, stejnojmenná výchozí skupina.*<br>
**sudo adduser \-\-gecos "**{*Celé jméno*}**"** [**\-\-debug**] <nic>[**\-\-shell** {*shell*}] <nic>[**\-\-ingroup** {*název-výchozí-skupiny*}] <nic>[**\-\-uid** {*konkrétní-UID*}] {*nové-přihlašovací-jméno*}<br>
!: Zadejte heslo pro nového uživatele. Potvrďte klávesou Enter.<br>
!: Znovu zadejte totéž heslo a znovu potvrďte.

*# **vytvořit** nový zamknutý běžný uživatelský účet (lze i ze skriptu)*<br>
**sudo adduser \-\-gecos "**{*Celé jméno*}**" \-\-disabled-password** [**\-\-debug**] <nic>[**\-\-shell** {*shell*}] <nic>[**\-\-ingroup** {*název-výchozí-skupiny*}] <nic>[**\-\-uid** {*konkrétní-UID*}] {*nové-přihlašovací-jméno*}

*# **smazat** uživatelský účet*<br>
**sudo deluser** [**\-\-remove-home**] {*uživatelské-jméno*}

*# **existuje** uživatelský účet? (uspěje, pokud ano)*<br>
**getent passwd** {*uživatel*} **&gt;/dev/null**

*# **vypsat** všechny uživatelské účty kromě systémových/úplně všechny*<br>
**getent passwd \| sed -E '/^([<nic>^:]\*:){2}(0\|[0-9]{4,}):/!d;s/:.\*//'** [**\| LC\_ALL=C.UTF-8 sort**]<br>
<!--
gawk -F : '$3 == 0 || $3 &gt;= 1000 {print $1;}'** [**\| LC\_ALL=C.UTF-8 sort**]<br>
-->
**getent passwd \| cut -d : -f 1** [**\| LC\_ALL=C.UTF-8 sort**]

*# vypsat uživatele, kteří jsou právě přihlášeni k systému (pro člověka/pro skript)*<br>
**who**<br>
?

*# vytvořit nový **systémový** uživatelský účet*<br>
**sudo adduser \-\-system** [**\-\-gid** {*GID-skupiny*}] <nic>[**\-\-uid** {*konkrétní-UID*}] {*nové-přihlašovací-jméno*}

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
**id -Gn** {*uživatel*} **\| tr "&blank;" \\\\n \|** [**LC\_ALL=C.UTF-8**] **sort**

*# **UID***<br>
**id -u** {*uživatelské-jméno*}
<!--
**getent passwd** {*uživatel*} **\| cut -d : -f 3**
-->

*# **celé jméno***<br>
**getent passwd** {*uživatel*} **\| cut -d : -f 5 \| cut -d , -f 1**

*# **domovský adresář***<br>
**getent passwd** {*uživatel*} **\| cut -d : -f 6**

*# uživatelské **jméno** (podle UID)*<br>
**id -un** {*UID*}

*# získat **avatar***<br>
*// Avatar čtvercový obrázek je ve formátu PNG. Počet pixelů tvořících stranu čtverce může být různý.*<br>
[**sudo**] **cp ~**{*uživatelské jméno*}**/.face** {*cíl.png*}

*# vypsat uživatelovu **výchozí skupinu** (názvem/GID)*<br>
**id -Gn** {*uživatel*} **\| sed -E 's/\\s.\*//'**<br>
**id -G** {*uživatel*} **\| sed -E 's/\\s.\*//'**

*# **příkazový interpret***<br>
**getent passwd** {*uživatel*} **\| cut -d : -f 7**

### Změnit nastavení uživatelského účtu (kromě hesla)

*# **celé jméno** (pozor – neplést si s uživatelským jménem!)*<br>
**sudo chfn -f "**{*nové jméno*}**"** {*uživatelské-jméno*}

*# **domovský adresář** (bez přesunu/přesunout)*<br>
**sudo usermod -d** {*/nový/adresář*} {*uživatelské-jméno*}<br>
**sudo usermod -m -d** {*/nový/adresář*} {*uživatelské-jméno*}

*# **avatar***<br>
**convert** {*obrázek*} **-gravity center -crop "$(identify -format "%[fx:min(w,h)]x%[fx:min(w,h)]"** {*obrázek*}**)" +repage -delete -1 png24:- \|** [**sudo**] **tee ~**{*uživatelské-jméno*}**/.face**

*# **příkazový interpret** (shell)*<br>
**sudo chsh** [**-s** {*/cesta/k/novému/shellu*}] {*uživatelské-jméno*}

*# změnit UID*<br>
*// Tento příkaz také rekurzivně projde domovský adresář uživatele a všechny adresářové položky, jejichž je daný uživatel vlastníkem, přepíše na nové UID, aby uživatel jejich vlastníkem zůstal.*<br>
**sudo usermod -u** {*nové-UID*} {*uživatelské-jméno*}

*# změnit výchozí skupinu*<br>
*// Tento příkaz také rekurzivně projde domovský adresář uživatele a všechny adresářové položky příslušné k původní výchozí skupině přepíše na novou výchozí skupinu.*<br>
**sudo usermod -g** {*název-nové-vých-skup*} **-G "$(id -Gn** {*uživatelské-jméno*} **\| tr '&blank;' ,)"** {*uživatelské-jméno*}

*# změnit uživatelské jméno*<br>
*// Tento příkaz nepřejmenuje domovský adresář uživatele!*<br>
**sudo usermod -l** {*nové-už-jméno*} {*původní-už-jméno*}

### Automatické přihlašování

*# **zapnout** (lightdm — jen Lubuntu, Ubuntu Budgie, Ubuntu MATE, Ubuntu Studio, Xubuntu)*<br>
!: V souboru „/etc/lightdm/lightdm.conf“ v sekci „[Seat:\*]“ nastavte:<br>
**autologin-user=**{*uživatelské-jméno*}<br>
**autologin-user-timeout=0**

*# zapnout (sddm — jen Kubuntu)*<br>
!: V souboru „/etc/sddm.conf“ v sekci „[Autologin]“ nastavte:<br>
**User=**{*uživatelské-jméno*}<br>
**Session=plasma.desktop**

*# zapnout (gdm — jen Ubuntu)*<br>
!: V souboru „/etc/gdm3/custom.conf“ v sekci „[daemon]“ nastavte:<br>
**AutomaticLoginEnable=true**<br>
**AutomaticLogin=**{*uživatelské-jméno*}

*# **vypnout** (lightdm — jen Lubuntu, Ubuntu Budgie, Ubuntu MATE, Ubuntu Studio, Xubuntu)*<br>
!: V souboru „/etc/lightdm/lightdm.conf“ v sekci „[Seat:\*]“ smažte klíče „autologin-user“ a „autologin-user-timeout“.

*# vypnout (sddm — jen Kubuntu)*<br>
!: V souboru „/etc/sddm.conf“ v sekci „[Autologin]“ smažte klíče „User“ a „Session“.

*# vypnout (gdm — jen Ubuntu)*<br>
!: V souboru „/etc/gdm3/custom.conf“ v sekci „[daemon]“ nastavte:<br>
**AutomaticLoginEnable=false**<br>
**AutomaticLogin=**

## Zaklínadla: Samospráva uživatele

### Vypsat nastavení

*# skupiny, ve kterých je členem (pro člověka/pro skript)*<br>
**groups**<br>
**id -Gn \| tr "&blank;" \\\\n \|** [**LC\_ALL=C.UTF-8**] **sort**

*# domovský adresář (doporučená varianta/spolehlivá varianta)*<br>
**printf %s\\\\n "$HOME"**<br>
**getent passwd $(whoami) \| cut -d : -f 6**

*# **uživatelské jméno**/UID*<br>
**whoami**<br>
**id -u**

*# **celé jméno***<br>
**getent passwd $(whoami) \| cut -d : -f 5 \| cut -d , -f 1**

*# získat **avatar***<br>
*// Avatar čtvercový obrázek je ve formátu PNG. Počet pixelů tvořících stranu čtverce může být různý.*<br>
**cp ~/.face** {*cíl.png*}

*# **příkazový interpret***<br>
**getent passwd "$(whoami)" \| cut -d : -f 7**

*# **výchozí skupina** (názvem/GID)*<br>
**id -Gn \| sed -E 's/\\s.\*//'**<br>
**id -G \| sed -E 's/\\s.\*//'**

### Změnit nastavení

*# **heslo** (pro člověka)*<br>
**passwd**<br>
!: Na výzvu zadejte původní heslo. Potvrďte klávesou Enter.<br>
!: Dvakrát zadejte nové heslo. Každé potvrďte klávesou Enter.

*# změnit **avatar***<br>
*// Pozor, pokud konverze obrázku selže, uvedený příkaz smaže váš současný avatar bez náhrady.*<br>
**convert** {*obrázek*} **-gravity center -crop "$(identify -format "%[fx:min(w,h)]x%[fx:min(w,h)]"** {*obrázek*}**)" +repage -delete -1 png24:- &gt;~/.face**

*# příkazový **interpret** (pro člověka)*<br>
**chsh** [**-s** {*/cesta/k/novému/interpretu*}]<br>
!: Na výzvu zadejte svoje heslo a potvrďte klávesou Enter.

*# změnit **celé jméno** (musí povolit správce)*<br>
*// Ve výchozím nastavení Ubuntu je tento příkaz běžným uživatelům zakázaný. Uživatelé však mohou svoje celé jméno změnit pomocí sběrnice DBUS nebo v GUI programem „mugshot“ ze stejnojmenného balíčku. Změna pomocí „chfn“ se povolí tak, že v souboru „/etc/login.defs“ do konfigurační volby „CHFN\_RESTRICT“ doplníte písmeno „f“ nebo ji nastavíte na hodnotu „no“.*<br>
^^**sudo sed -iE '/^CHFN\_RESTRICT/s/\\&lt;rwh\\&gt;/f&amp;/' /etc/login.defs**<br>
**chfn -f "**{*Nové celé jméno*}**"**<br>
!: Na výzvu zadejte svoje heslo a potvrďte klávesou Enter.

*# změnit **celé jméno** pomocí sběrnice DBUS*<br>
*// Tato metoda sice také určité oprávnění požaduje, ale ve výchozím nastavení v Ubuntu všichni uživatelé toto oprávnění mají, takže si svoje celé jméno mohou změnit. Navíc nevyžaduje zadání hesla.*<br>
**ofa=org.freedesktop.Accounts**<br>
**ofacesta="$(dbus-send \-\-system \-\-dest=$ofa \-\-type=method\_call \-\-print-reply=literal /${ofa//./\\/} ${ofa}.FindUserByName "string:$(whoami)" \| tr -d "&blank;")"**<br>
**novejmeno="**{*Nové celé jméno*}**"**<br>
**dbus-send \-\-system \-\-dest=$ofa \-\-type=method\_call \-\-print-reply=literal "$ofacesta" ${ofa}.User.SetRealName "string:${novejmeno//[,=:]/}$(getent passwd "$(whoami)" \| sed -E 's/^([<nic>^:]\*:){4}[<nic>^,:]\*([<nic>^:]\*):.\*$/\\2/')"**
<!--
Význam regulárního výrazu:

^
([<nic>^:]*:){4}        # 4 skupiny znaků končící dvojtečkou (přeskočí první čtyři sloupce /etc/passwd)
[<nic>^,:]*             # přeskočí původní celé jméno (až před nejbližší „,“ nebo „:“)
([<nic>^:]*)            # do skupiny načte celý zbytek dodatečných informací (typicky jsou tam jen tři čárky)
                        # -> tato skupina se vypíše na výstup
:.*$                    # co je za následující dvojtečkou už nás nezajímá

-->


## Zaklínadla: Správa skupin

### Vytvořit/vypsat/zrušit

*# vytvořit **skupinu** (běžnou/systémovou)*<br>
**sudo addgroup** [**\-\-gid** {*konkrétní-GID*}] {*název-nové-skupiny*}<br>
**sudo addgroup \-\-system** [**\-\-gid** {*konkrétní-GID*}] {*název-nové-skupiny*}

*# **smazat** skupinu*<br>
**sudo delgroup** [**\-\-only-if-empty**] {*skupina*}

*# **vypsat** všechny skupiny kromě systémových/úplně všechny*<br>
**getent group \| sed -E '/^([<nic>^:]\*:){2}(0\|[0-9]{4,}):/!d;s/:.\*//'** [**\| LC\_ALL=C.UTF-8 sort**]<br>
**getent group \| cut -d : -f 1** [**\| LC\_ALL=C.UTF-8 sort**]
<!--
**gawk -F : '$3 == 0 || $3 &gt;= 1000 {print $1;}' /etc/group** [**\| LC\_ALL=C.UTF-8 sort**]<br>
**cut -d : -f 1 /etc/group** [**\| LC\_ALL=C.UTF-8 sort**]
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

*# **odebrat** účet ze skupiny (alternativy)*<br>
*// Použít „gpasswd“ bez sudo je oprávněn pouze správce skupiny.*<br>
*// Uživatele nelze odebrat z jeho výchozí skupiny. Pokud to chcete udělat, musíte mu nejprve nastavit jinou výchozí skupinu.*<br>
[**sudo**] **gpasswd -d** {*uživatel*} {*skupina*}<br>
**sudo deluser** {*uživatel*} {*skupina*}

*# **vypsat** účty ve skupině (po řádcích)*<br>
**lkk veskupine** {*skupina*}

*# je účet členem skupiny? (podle názvu/podle GID)(uspěje, pokud ano)*<br>
**id -Gn** {*uživatel*} **\| fgrep -qw** {*název\_skupiny*}<br>
**id -G** {*uživatel*} **\| fgrep -qw** {*GID*}

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
**sudo gpasswd -A ""** {*název\_skupiny*}

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

## Zaklínadla: Ostatní

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
![ve výstavbě](../obrázky/ve-výstavbě.png)

[ ] adduser
[ ] getent?
[ ] passwd
[ ] gpasswd

-->

## Instalace na Ubuntu

Všechny použité nástroje jsou základními součástmi Ubuntu přítomnými i v minimální instalaci,
s výjimkou příkazů „convert“ a „identify“, které je potřeba doinstalovat:

*# *<br>
**sudo apt-get install imagemagick**

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

* Používat hesla skupin se nedoporučuje; jsou neintuitivní, nepraktická a jsou s nimi bezpečnostní problémy.
* Jméno uživatelského účtu či název skupiny musí začínat malým písmenem anglické abecedy a ve zbytku může obsahovat malá písmena anglické abecedy, číslice, pomlčky a podtržítka.
* Standardní způsob sdílení určitého adresáře více uživateli spočívá v tom, že vytvoříme skupinu (addgroup), přidáme do ní všechny uživatelské účty (gpasswd -a), které mají adresář sdílet, nastavíme skupinu sdílenému adresáři (chgrp) a nastavíme mu příznak zmocnění skupiny (chmod g+s), aby se skupinová příslušnost rozšířila i na nové podadresáře. V případě malého počtu uživatelů můžeme místo vytvoření nové skupiny použít výchozí skupinu některého z uživatelů.
* Při výchozím nastavení uživatel nemůže změnit „celé jméno“ vlastního účtu příkazem „chfn“, může ho však změnit z GUI, např. programem „mugshot“.
* Do každého nově vytvořeného domovského adresáře se nakopíruje obsah adresáře „/etc/skel“.

## Další zdroje informací

* man 5 passwd
* man 1 gpasswd
* [Wikipedie: Uživatelský účet v Unixu](https://cs.wikipedia.org/wiki/U%C5%BEivatelsk%C3%BD\_%C3%BA%C4%8Det\_v\_Unixu)
* [YouTube: Linux Add, Delete and Modify Users](https://www.youtube.com/watch?v=DSDsaDnFpWI) (anglicky)
* [YouTube: Linux Tip: How to add and delete user accounts](https://www.youtube.com/watch?v=933Uo9T4kfk) (anglicky)
* [HowTo: Linux Add User To Group](https://www.hostingadvice.com/how-to/linux-add-user-to-group/) (anglicky)
* [TL;DR stránka „adduser“](https://github.com/tldr-pages/tldr/blob/master/pages/linux/adduser.md) (anglicky)

!ÚzkýRežim: vyp

## Pomocné skripty a funkce

*# lkk veskupine – vypíše seznam uživatelských účtů, které jsou v některé z uvedených skupin*<br>
**#!/bin/bash**<br>
**set -e; for x in "$@"; do getent group "$x"; done &gt;/dev/null; set +e**<br>
**for x in "$@"**<br>
**do**<br>
<odsadit1>**gid=$(getent group "$x" \| cut -d : -f 3)**<br>
<odsadit1>**sed -E "/^([^:]\*:){3}${gid}:/!""d;s/:.\*//" /etc/passwd**<br>
<odsadit1>**getent group "$gid" \| cut -d : -f 4 \| sed -E '/^$/d;s/,/\\n/g'**<br>
**done \| LC\_ALL=C.UTF-8 sort -u**

!ÚzkýRežim: zap

## Zákulisí kapitoly
<!--
- Doplňte, pokud víte. Udržujte aktuální.
-->

V této verzi kapitoly chybí:

!KompaktníSeznam:
* vysvětlení významu důležitých systémových skupin (jako např. skupiny „sudo“)

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* nastavování přihlašování do systému a většina nastavení specifických pro určité grafické prostředí (např. nastavení pozadí plochy)

!ÚzkýRežim: vyp
