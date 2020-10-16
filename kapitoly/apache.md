<!--

Linux Kniha kouzel, kapitola Webový server Apache
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

[ ] Po přechodu na Ubuntu 20.04 nutno aktualizovat verzi PHP.

- HTTP
- HTTPS
- PHP

⊨
-->

# Webový server Apache

!Štítky: {program}{web}{server}{http}{https}

!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

* Modul
* Virtuální web

!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

### Ovládání serveru

*# ručně **zastavit** server*<br>
**sudo systemctl stop apache2**

*# ručně spustit server*<br>
**sudo systemctl start apache2**

*# restartovat server*<br>
**sudo systemctl restart apache2**

*# nastavit server, aby se zapínal/nezapínal při startu systému*<br>
**sudo systemctl enable apache2**<br>
**sudo systemctl disable apache2**

### Ovládání modulů

*# **zapnout** modul*<br>
**sudo a2enmod** {*modul*}<br>
**sudo systemctl restart apache2**

*# **vypnout** modul*<br>
**sudo a2dismod** {*modul*}<br>
**sudo systemctl restart apache2**

*# vypsat seznam zapnutých modulů*<br>
**ls -N1 /etc/apache2/conf-enabled \| sed -E 's/\\.load$//;t;d'**

*# vypsat seznam všech dostupných modulů*<br>
**ls -N1 /etc/apache2/conf-available \| sed -E 's/\\.load$//;t;d'**

*# vypsat seznam vypnutých modulů*<br>
**LC\_ALL=C join -t "" -j 1 -v 1 &lt;(ls -1 /etc/apache2/conf-available \| LC\_ALL=C sort -u) &lt;(ls -1 /etc/apache2/conf-enabled \| LC\_ALL=C sort -u) \| sed -E 's/\\.load$//;t;d'**

*# je modul zapnutý?*<br>
**test -e /etc/apache2/conf-enabled/**{*modul*}**.load**

## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Instalace na Ubuntu

*# *<br>
**sudo apt-get install apache2 php libapache2-mod-php php-gd php-mbstring php-sqlite3**
**sudo a2enmod php7.2**<br>
**sudo a2enmod rewrite**<br>
**sudo sed -Ei '/^&lt;Directory \\/var\\/www\\/&gt;$/,/^&lt;\\/Directory&gt;$/s/^(\\s\*AllowOverride )None$/\\1All/' /etc/apache2/apache2.conf**<br>
**sudo systemctl restart apache2**

Otevřete ve webovém prohlížeči adresu [http://localhost](http://localhost) a zkontrolujte, že se vám zobrazí (v angličtině) uvítací stránka Apache2. Server nyní zpřístupňuje adresář „/var/www/html“; k souborům a adresářům přistupuje ze systémového uživatelského účtu „www-data“, proto potřbuje, aby k nim tento účet měl příslušná práva.

Pro zprovoznění konkrétních webových aplikací budete možná potřebovat doinstalovat a zapnout další moduly Apache či PHP.

<!--
Modul „rewrite“ a změna konfigurace jsou potřeba, aby fungovaly soubory .htaccess.

Modul „gd“ slouží ke zpracování bitmapových obrázků, modul „mbstring“ slouží ke zpracování textových řetězců a module „sqlite3“ k přístupu do databázových souborů SQLite.

*# seznam balíčků s moduly Apache/PHP (pro člověka)*<br>
**apt list 'libapache2-mod-\*'**
**apt list 'php-\*' 'php?.?-\*'**
-->

## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

!ÚzkýRežim: zap

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

* Apache server běží pod systémovým uživatelským účtem „www-data“, zatímco soubory a adresáře ve /var/www/html po instalaci vlastní root; pokud chcete, aby Apache mohl do některých souborů či adresářů zapisovat, musíte do nich účtu „www-data“ poskytnout právo zápisu.
* Ve výchozí konfiguraci zpřístupňuje Apache server adresář /var/www/html. Další soubory a adresáře z něj můžete zpřístupnit např. pomocí symbolických odkazů. (Jen se ujistěte, že účet www-data k nim bude mít odpovídající práva.)

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

Co hledat:

* [Seznam modulů Apache](https://en.wikipedia.org/wiki/List\_of\_Apache_modules) (anglicky)

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
