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
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

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
**sudo adduser \-\-gecos "**{*Celé jméno*}**"** [**\-\-disable-login**] [**\-\-debug**] [**\-\-shell** {*shell*}] [**\-\-uid** {*konkrétní-UID*}] {*nový-uživatel*}<br>
**sudo adduser \-\-system** [**\-\-gid** {*ID-skupiny*}] [**\-\-uid** {*konkrétní-UID*}] {*nový-uživatel*}

*# smazat uživatele*<br>
**sudo deluser** [**\-\-remove-home**] {*uživatel*}


*# existuje uživatel? (uspěje, pokud ano)*<br>
**egrep -q "^$(whoami):" /etc/passwd**

*# vypsat všechny uživatele/všechny kromě systémových*<br>
**cut -d : -f 1 /etc/passwd** [**\| LC\_ALL=C sort**]<br>
**gawk -F : '$3 == 0 || $3 &gt;= 1000 {print $1;}' /etc/passwd** [**\| LC\_ALL=C sort**]


*# změnit příkazový interpret uživatele/aktuálního uživatele (změnit shell)*<br>
**sudo chsh** [**-s** {*/cesta/k/novému/shellu*}] {*uživatel*}<br>
**chsh** [**-s** {*/cesta/k/novému/shellu*}]

### Vlastnosti uživatelů (změnit)

*# změnit heslo uživatele/vlastní heslo*<br>
**sudo passwd** {*uživatel*}<br>
**passwd**

*# změnit celé jméno uživatele (ne to přihlašovací)*<br>
**sudo chfn -f "**{*nové jméno*}**"** {*uživatel*}

*# změnit domovský adresář uživatele (bez přesunu/přesunout)*<br>
**sudo usermod -d** {*/nový/adresář*} {*uživatel*}<br>
**sudo usermod -m -d** {*/nový/adresář*} {*uživatel*}

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

*# vypsat přihlašovací jméno aktuálního uživatele*<br>
**whoami**

*# vypsat celé jméno uživatele/aktuálního uživatele*<br>
**getent passwd** {*uživatel*} **\| cut -d : -f 5 \| cut -d , -f 1**<br>
**getent passwd $(whoami) \| cut -d : -f 5 \| cut -d , -f 1**

*# vypsat domovský adresář uživatele*<br>
**getent passwd** {*uživatel*} **\| cut -d : -f 6**

*# vypsat příkazový interpret (shell) uživatele*<br>
**getent passwd** {*uživatel*} **\| cut -d : -f 7**

*# vypsat domovský adresář aktuálního uživatele (doporučená varianta/spolehlivá varianta)*<br>
**$HOME**<br>
**getent passwd $(whoami) \| cut -d : -f 6**

*# vypsat UID uživatele/aktuálního uživatele*<br>
**getent passwd** {*uživatel*} **\| cut -d : -f 3**<br>
**id -u**

*# vypsat skupiny uživatele/aktuálního uživatele*<br>
**groups** {*uživatel*} **\| cut -d : -f 2- \| tr "&blank;" \\\\n \| LC\_ALL=C sort \| fgrep -vx ""**<br>
**groups \| tr "&blank;" \\n**

### Skupiny

*# vytvořit skupinu uživatelů/systémovou skupinu*<br>
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

*# vypsat všechny skupiny/všechny kromě systémových*<br>
**cut -d : -f 1 /etc/group** [**\| LC\_ALL=C sort**]<br>
**gawk -F : '$3 == 0 || $3 &gt;= 1000 {print $1;}' /etc/group** [**\| LC\_ALL=C sort**]

*# změnit GID skupiny*<br>
**sudo groupmod -g** {*nové-GID*} {*skupina*}

*# je uživatel členem skupiny? (uspěje, pokud ano)*<br>
**printf ,%s,\\n "$(getent group** {*skupina*} **\| cut -f : -f 4)" \| fgrep -q ,**{*uživatel*}**,**

### Formáty souborů

*# formát /etc/passwd*<br>
{*přihlašovací-jméno*}**:x:**{*UID*}**:**{*GID-výchozí-skupiny*}**:**{*celé jméno*}**[,**{*další údaje*}]**:**{*/domovský/adresář*}[**:**{*/výchozí/shell*}]

*# formát /etc/group*<br>
{*název-skupiny*}**:x:**{*GID*}**:**[{*první-člen*}[**,**{*další-člen*}]...]

### Ostatní
<!--

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
* [TL;DR stránka „adduser“](https://github.com/tldr-pages/tldr/blob/master/pages/linux/adduser.md) (anglicky)

!ÚzkýRežim: vyp
