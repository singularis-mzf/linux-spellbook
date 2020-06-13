<!--

Linux Kniha kouzel, kapitola Správa uživatelů
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

⊨
-->

# Správa uživatelů

!Štítky: {tematický okruh}{systém}
!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Definice

* **Uživatel** je v této kapitole systémový účet identifikovaný pomocí **uživatelského jména** a někdy také pomocí čísla **UID**. Existují tři typy uživatelů: **běžný** (UID ≥ 1000), **systémový** (UID 1 až 999) a **superuživatel** (UID 0). Každý soubor nebo běžící proces přísluší nějakému uživateli.
* Běžní uživatelé slouží k přihlášení osob k systému s různým nastavením a různými právy, co se týče zacházení se systémem.
* Systémoví uživatelé slouží k vnitřním účelům systému, zejména k omezení práv některých démonů.
* Superuživatel „root“ pak má nejvyšší možná oprávnění, neplatí pro něj většina omezení a jako jediný může spouštět procesy s právy jiných uživatelů a skupin bez znalosti jakéhokoliv hesla.
* **Skupina** je neprázdná množina uživatelů identifikovaná **názvem skupiny** a někdy také číslem **GID**. Do skupin se přihlašují procesy (ne uživatelé či osoby) a přiřazují se souborům na disku za účelem komplexnějšího řízení přístupových práv. Každý soubor nebo běžící proces přísluší nějaké skupině (vždy jen jedné).

### Uživatelé, skupiny a hesla

* Uživatel je zabezpečený heslem – jako takový uživatel se můžete přihlásit po zadání jeho hesla. Nemá-li uživatel heslo, můžete se jako on přihlásit kdykoliv, bez zadání hesla. Systémoví uživatelé (a v Ubuntu i superuživatel) však mají hesla takzvaně zamčená, což prakticky znamená, že se jako oni přihlásit nemůžete.
* Proces s právy uživatele, který je členem skupiny, se může do dané skupiny „přihlásit“ vždy bez zadávání hesla. Má-li skupina nastaveno heslo, může se do ní navíc přihlásit i proces uživatele, který není členem skupiny, avšak jen po zadání hesla.

<!--

- uživatel (systémový/běžný) + identifikován pomocí UID
- skupina (systémová/běžná) + identifikována pomocí GID (množina uživatelů)
- shell (příkazový interpret)

-->

!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Uživatelé (vytvořit/vypsat/zrušit)
*# vytvořit nového uživatele/nového systémového uživatele*<br>
*// Pozor! Celé jméno uživatele nesmí obsahovat znaky „,“ a „=“ a při použití non-ASCII znaků program vypíše varování (což je ale na dnešních systémech dost absurdní).*<br>
*// Volbou „\-\-disable-login“ umožníte zadat heslo později, jinak se na něj program hned zeptá.*<br>
**sudo adduser \-\-gecos "**{*Celé jméno*}**"** [**\-\-disable-login**] <nic>[**\-\-debug**] <nic>[**\-\-shell** {*shell*}] <nic>[**\-\-uid** {*konkrétní-UID*}] {*nový-uživatel*}<br>
**sudo adduser \-\-system** [**\-\-gid** {*ID-skupiny*}] <nic>[**\-\-uid** {*konkrétní-UID*}] {*nový-uživatel*}

*# smazat uživatele*<br>
**sudo deluser** [**\-\-remove-home**] {*uživatel*}

*# existuje uživatel? (uspěje, pokud ano)*<br>
**getent** {*uživatel*} **&gt;/dev/null**

*# vypsat všechny uživatele/všechny kromě systémových*<br>
**getent passwd \| cut -d : -f 1** [**\| LC\_ALL=C sort**]<br>
**getent passwd \| gawk -F : '$3 == 0 || $3 &gt;= 1000 {print $1;}'** [**\| LC\_ALL=C sort**]

*# změnit **příkazový interpret** uživatele/aktuálního uživatele (změnit shell)*<br>
**sudo chsh** [**-s** {*/cesta/k/novému/shellu*}] {*uživatel*}<br>
**chsh** [**-s** {*/cesta/k/novému/shellu*}]

### Heslo uživatele

*# nastavit **heslo** (pro člověka)*<br>
**sudo passwd** {*uživatelské-jméno*}<br>
!: Dvakrát zadat nové heslo.

*# nastavit heslo (pro skript)*<br>
**printf %s\\n "**{*uživatelské-jméno*}**:**{*heslo*}**" ["**{*další-uživatelské-jméno*}**:**{*další-heslo*}"]... **\| sudo chpasswd**

*# změnit vlastní heslo*<br>
**passwd**<br>
!: Zadat původní heslo.<br>
!: Dvakrát zadat nové heslo.

*# zrušit heslo (umožní přihlášení **bez hesla**)*<br>
*// Varování: Než použijete tento příkaz, dobře si rozmyslete, co děláte. Uživatelský účet bez hesla může představovat závažnou bezpečnostní díru ve vašem systému. Nepoužívejte tuto možnost, pokud vám stačí automatické přihlášení („autologin“).*<br>
**sudo passwd -d** {*uživatelské-jméno*}

*# **zamknout** heslo uživatele*<br>
**sudo passwd -l** {*uživatelské-jméno*}

*# **odemknout** heslo zamknuté pomocí „passwd -l“ (alternativy)*<br>
*// Poznámka: Ve většině případů je správným postupem odemknutí hesla jeho nové nastavení. Příkaz „sudo passwd -u“ by měl být používán pouze pro hesla zamknutá pomocí „sudo passwd -l“, chceme-li zachovat původní heslo.*<br>
**printf %s\\n "**{*uživatelské-jméno*}**:**{*nové-heslo*}**" \| sudo chpasswd**<br>
**sudo passwd -u** {*uživatelské-jméno*}

*# nastavit vypršení hesla/okamžitě vypršet (nezkoušeno)*<br>
*// Vyprší-li platnost hesla, uživatel bude po příštím přihlášení donucen si heslo změnit. Poznámka: vypršení hesla jsem podrobně nezkoušel/a.*<br>
**sudo passwd -x** {*dnů-platnosti*} [**-w** {*kolik-dnů-předem-varovat*}] {*uživatelské-jméno*}<br>
**sudo passwd -e** {*uživatelské-jméno*}

### Vlastnosti uživatelů (změnit)

*# nastavit celé jméno uživatele (pozor – neplést si s uživatelským jménem!)*<br>
**sudo chfn -f "**{*nové jméno*}**"** {*uživatelské-jméno*}

*# změnit domovský adresář uživatele (bez přesunu/přesunout)*<br>
**sudo usermod -d** {*/nový/adresář*} {*uživatelské-jméno*}<br>
**sudo usermod -m -d** {*/nový/adresář*} {*uživatelské-jméno*}

*# změnit UID uživatele*<br>
*// Podle manuálové stránky tento příkaz rovněž upraví vlastnictví uživatelova domovského adresáře a všech podadresářů a souborů v něm, jejichž je uživatel vlastníkem.*<br>
**sudo usermod -u** {*nové-UID*} {*uživatel*}

*# změnit přihlašovací jméno uživatele*<br>
?

*# nastavit avatar*<br>
?
<!--
Vzít obrázek, zkonvertovat na 480x480 PNG 8bit RGB a uložit do souboru
~/.face. Změna se projeví okamžitě.

-->

### Vlastnosti uživatelů (vypsat)

*# vypsat uživatelské jméno/UID **aktuálního uživatele***<br>
**whoami**<br>
**id -u**

*# vypsat **celé jméno** uživatele/aktuálního uživatele*<br>
**getent passwd** {*uživatel*} **\| cut -d : -f 5 \| cut -d , -f 1**<br>
**getent passwd $(whoami) \| cut -d : -f 5 \| cut -d , -f 1**

*# vypsat **domovský adresář** uživatele*<br>
**getent passwd** {*uživatel*} **\| cut -d : -f 6**

*# vypsat **příkazový interpret** (shell) uživatele*<br>
**getent passwd** {*uživatel*} **\| cut -d : -f 7**

*# vypsat domovský adresář aktuálního uživatele (doporučená varianta/spolehlivá varianta)*<br>
**$HOME**<br>
**getent passwd $(whoami) \| cut -d : -f 6**

*# vypsat UID uživatele/aktuálního uživatele*<br>
**id -u** {*uživatel*}<br>
**id -u**
<!--
**getent passwd** {*uživatel*} **\| cut -d : -f 3**
-->

*# vypsat skupiny uživatele/aktuálního uživatele*<br>
**id -Gn** {*uživatel*} **\| tr "&blank;" \\\\n \|** [**LC\_ALL=C**] **sort**<br>
**id -Gn \| tr "&blank;" \\\\n \|** [**LC\_ALL=C**] **sort**<br>
<!--
**groups \| tr "&blank;" \\\\n**
-->

### Skupiny

*# vytvořit **skupinu** (běžnou/systémovou)*<br>
**sudo addgroup** [**\-\-gid** {*konkrétní-GID*}] {*nová-skupina*}<br>
**sudo addgroup \-\-system** [**\-\-gid** {*konkrétní-GID*}] {*nová-skupina*}

*# smazat skupinu*<br>
**sudo delgroup** [**\-\-only-if-empty**] {*skupina*}

*# přidat uživatele do skupiny*<br>
**sudo adduser** {*uživatel*} {*skupina*}

*# odebrat uživatele ze skupiny*<br>
**sudo deluser** {*uživatel*} {*skupina*}

*# vypsat uživatele ve skupině (po řádcích)*<br>
**getent group** {*skupina*} **\| cut -d : -f 4 \| tr , \\\\n** [**\| LC\_ALL=C sort**]

*# vypsat GID skupiny*<br>
**getent group vboxsf \| cut -d : -f 3**

*# vypsat **všechny skupiny**/všechny kromě systémových*<br>
**cut -d : -f 1 /etc/group** [**\| LC\_ALL=C sort**]<br>
**gawk -F : '$3 == 0 || $3 &gt;= 1000 {print $1;}' /etc/group** [**\| LC\_ALL=C sort**]

*# změnit GID skupiny*<br>
**sudo groupmod -g** {*nové-GID*} {*skupina*}

*# je uživatel členem skupiny? (uspěje, pokud ano)*<br>
**printf ,%s,\\n "$(getent group** {*skupina*} **\| cut -f : -f 4)" \| fgrep -q ,**{*uživatel*}**,**

*# nastavit **heslo** skupiny (pro člověka)*<br>
**sudo gpasswd** {*skupina*}<br>
!: Dvakrát zadat nové heslo.

*# nastavit heslo skupiny (pro skript)*<br>
?

*# zrušit heslo skupiny*<br>
**sudo gpasswd -r** {*skupina*}

### Formáty souborů

*# formát /etc/passwd*<br>
{*přihlašovací-jméno*}**:x:**{*UID*}**:**{*GID-výchozí-skupiny*}**:**{*celé jméno*}**[,**{*další údaje*}]**:**{*/domovský/adresář*}[**:**{*/výchozí/shell*}]

*# formát /etc/group*<br>
{*název-skupiny*}**:x:**{*GID*}**:**[{*první-člen*}[**,**{*další-člen*}]...]

<!--
### Ostatní
<!- -

*# kteří uživatelé jsou přihlášeni k systému?*<br>
**who -q \| egrep "^#"**
[ ] Vyřešit problémy se „su“ a „sudo“.

-->



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

*# *<br>
**sudo apt-get install gawk**

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

<!--
[ ] Proč nikdy nezadávat heslo na příkazové řádce či ve skriptu a neukládat do proměnných prostředí.
-->

## Další zdroje informací

*# *<br>
**man 5 passwd**

Co hledat:

* [stránku na Wikipedii](https://cs.wikipedia.org/wiki/Hlavn%C3%AD_strana)
* oficiální stránku programu
* oficiální dokumentaci
* [manuálovou stránku](http://manpages.ubuntu.com/)
* [balíček Bionic](https://packages.ubuntu.com/)
* online referenční příručky
* různé další praktické stránky, recenze, videa, tutorialy, blogy, ...
* publikované knihy
* ...
* [Video: Linux Tip: How to add and delete user accounts](https://www.youtube.com/watch?v=933Uo9T4kfk) (anglicky)
* [TL;DR stránka „adduser“](https://github.com/tldr-pages/tldr/blob/master/pages/linux/adduser.md) (anglicky)

!ÚzkýRežim: vyp
