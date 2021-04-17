<!--

Linux Kniha kouzel, kapitola Šifrování a kryptografie
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

- Podle https://www.sallyx.org/sally/linux/prikazy/binary-files:
    sudo cryptsetup luksFormat {*/soubor-nebo-oddíl*} -c aes-xts-plain64 -s 512
    sudo cryptsetup luksOpen {*/soubor-nebo-oddíl*} {*id*}
    sudo mount /dev/mapper/{*id*} {*kam*}
    ...
    sudo umount /dev/mapper/{*id*}
    sudo cryptsetup luksClose /dev/mapper/{*id*}

    [ ] openssl
    [ ] mcrypt

⊨
-->

# Šifrování a kryptografie

!Štítky: {tematický okruh}
!FixaceIkon: 1754
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

GNU Privacy Guard, jehož součástí je příkaz „gpg“, je vyvíjen v projektu GNU.

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

* **Soukromý klíč** je „tajný“ soubor obsahující náhodnou sekvenci bitů sloužící ke kryptografickým účelům. Soukromý klíč obsahuje jméno, e-mail a komentář (nemusí být vždy pravdivé). Obvykle je sám chráněn heslem (což není povinné) a často má časově omezenou platnost (což také není povinné).
* **Veřejný klíč** je soubor obsahující sekvencí bitů odvozenou od soukromého klíče. Veřejným klíčem lze provést opačné operace k operacím provedeným soukromým klíčem (tzn. dešifrovat data zašifrovaná soukromým klíčem, zašifrovat data tak, aby šla dešifrovat jen soukromým klíčem; nebo ověřit elektronický podpis vytvořený pomocí soukromého klíče).
* **Otisk klíče** je výstup určené hešovací funkce aplikované na klíč. Otisk slouží k porovnávání klíčů a jako identifikátor klíče pro některé operace.
* **Server s klíči** (anglicky „keyserver“) je server určený k distribuci veřejných klíčů.
* **Šifrovací agent** je program, který běží na pozadí jako démon, pamatuje si zadaná hesla a „odemknuté klíče“ a poskytuje ostatním programům kryptografické služby s nimi (ale samotné klíče jim neposkytne). Díky šifrovacímu agentovi nemusíte opakovaně zadávat heslo, dokud se neodhlásíte.
* **Odvolací certifikát** je tajný soubor vygenerovaný ze soukromého klíče. Jeho zveřejněním klíč „odvoláte“ (prohlásíte za nedůvěryhodný).

!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

*# vypsat seznam veřejných/soukromých klíčů v klíčence*<br>
**gpg \-\-list-keys**<br>
**gpg \-\-list-secret-keys**

*# smazat veřejný/soukromý klíč z klíčenky*<br>
**gpg \-\-delete-keys** {*otisk*}<br>
**gpg** [**\-\-yes**] **\-\-delete-secret-keys** {*otisk*}

*# stáhnout veřejný klíč ze serveru klíčů*<br>
**gpg** [**\-\-keyserver** {*server*}] **\-\-recv-keys** {*otisk*}

*# odeslat veřejný klíč na sever klíčů*<br>
**gpg** [**\-\-keyserver** {*server*}] **\-\-send-keys** {*otisk*}

<!--
keys.gnupg.net
-->

*# zašifrovat soubor veřejným klíčem*<br>
**gpg \-\-encrypt** [**\-\-armor**] **-r** {*otisk*} **&lt;**{*soubor*} **&gt;**{*cílový-soubor*}

*# dešifrovat soubor soukromým klíčem*<br>
**gpg \-\-decrypt &lt;**{*zašifrovaný-soubor*} **&gt;**{*výstupní-soubor*}

*# ověřit podpis souboru*<br>
?

*# exportovat všechny veřejné klíče do textového souboru*<br>
**gpg \-\-export &gt;**{*soubor.asc*}
<!--
--export-secret-keys
-->

*# importovat klíče z textového souboru do klíčenky*<br>
**gpg \-\-import &lt;**{*soubor.asc*}

## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíčků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

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
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

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

## Zákulisí kapitoly
<!--
- Doplňte, pokud víte. Udržujte aktuální.
-->

V této verzi kapitoly chybí:

!KompaktníSeznam:
* nic

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* nic

!ÚzkýRežim: vyp
