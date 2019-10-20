<!--

Linux Kniha kouzel, kapitola Docker
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
ÚKOLY:

-->

# Docker

## Úvod
Docker je nástroj pro odlehčenou virtualizaci formou takzvaných kontejnerů. Kontejner obsahuje vlastní podstrom procesů, který je izolovaný od zbytku systému (má vlastní souborový systém, konfiguraci, knihovny, démony a síťové rozhraní), ale sdílí s ním jádro a výpočetní prostředky.

Použití Dockeru obecně probíhá tak, že napíšete vlastní Dockerfile, z něj sestavíte image a z této image pak spouštíte kontejnery. Kontejner může běžet buď na popředí (v příkazové řádce), nebo na pozadí.

Tato verze kapitoly pokrývá pouze základy Dockeru; nezmiňuje se o nástoji „docker-compose“ a pokrývá jen malou část dostupných „docker“-příkazů.

## Definice

* **Kontejner** je dočasné (ale perzistentní) virtualizované prostředí pro spouštění programů.
* **Image** je neměnný, opakovaně použitelný výchozí stav kontejneru.
* **Repozitář** je soubor imagí se společným označením (např. „ubuntu“). Jednotlivé image se pak identifikují pomocí **tagu** uvedeného za název repozitáře a dvojtečku (např. „ubuntu:18.04“). Není-li tag uveden, Docker automaticky doplní tag „latest“.
* **Dockerfile** je textový soubor s názvem „Dockerfile“, obsahující instrukce k vytvoření image.

## Zaklínadla (docker)

### Práce s images
*# vytvořit image z Dockerfilu*<br>
*// Pozor na tečku na konci příkazu, je povinná a bez ní příkaz skončí vypsáním nápovědy!*<br>
**sudo docker build** [**-t** {*repozitář*}[**:**{*tag-pro-image*}]] [**\-\-no-cache**] **.**

*# vypsat lokálně dostupné image*<br>
**sudo docker images**

*# vyhledat vzdáleně dostupné image*<br>
**sudo docker search** [**\-\-limit=100**] {*text-k-vyhledání*}

*# vypsat všechny vzdáleně dostupné image*<br>
?

*# smazat image (lokálně)*<br>
**sudo docker rmi** {*image*}

*# stáhnout vzdálenou image k použití lokálně*<br>
**sudo docker pull** {*image*}

*# nové označení pro image*<br>
*// Původní označení zůstane zachováno.*<br>
**sudo docker tag** {*image*} {*nové-označení-repozitář*}[**:**{*nové-označení-tag*}]

*# uložit image do souboru/načíst ze souboru*<br>
*// Uloženou image doporučuji komprimovat (je ve formátu tar). Uložená image obsahuje všechny vrstvy potřebné pro její rekonstrukci, takže ji lze načíst i na počítači bez připojení k internetu. Rovněž je to vhodný způsob, jak si image zálohovat.*<br>
**sudo docker save -o** {*soubor*} {*image*}<br>
**sudo docker load -i** {*soubor*}

*# uložit image na standardní výstup/načíst ze standardního vstupu*<br>
**sudo docker save** {*image*}<br>
**sudo docker load**

### Práce s kontejnery

*# vytvořit a spustit kontejer*<br>
**sudo docker run** [{*parametry*}] {*image*} [{*náhradní příkaz a jeho parametry*}]

*# vypsat seznam kontejnerů (jen běžících/všech)*<br>
**sudo docker ps**<br>
**sudo docker ps -a**

*# zastavit kontejner (normálně/násilně)*<br>
**sudo docker stop** {*kontejner*}<br>
**sudo docker kill** {*kontejner*}

*# znovu spustit zastavený kontejner*<br>
**sudo docker start** {*kontejner*}

*# smazat kontejner (jen zastavený/i běžící)*<br>
**sudo docker rm** {*kontejner*}<br>
**sudo docker rm -f** {*kontejner*}

*# přejmenovat kontejner*<br>
**sudo docker rename** {*kontejner*} {*nové-jméno*}

*# spustit nový interpret příkazové řádky v již běžícím kontejneru (obecně/konkrétně)*<br>
**sudo exec -it** {*kontejner*} {*interpret*}<br>
**sudo exec -it ef95f2 bash**

*# kopírování souborů z kontejneru/do kontejneru*<br>
**sudo docker cp** {*kontejner*}**:**{*/cesta/v/kontejneru*} {*cíl/mimo*}<br>
**sudo docker cp** {*zdroj/mimo/kontejner*} {*kontejner*}**:**{*/cíl/v/kontejneru*}

### Pročištění systému
*# pročistit systém (po čase bývá nezbytné)*<br>
**sudo docker system prune**

### Eskalace práv
*# přečtení souboru, který nemáte právo číst*<br>
**sudo docker \-\-rm -it -v $(pwd):/root ubuntu cat "/root/**{*název souboru*}**"**

*# přepsání souboru, do kterého nemáte právo zapisovat*<br>
**sudo docker \-\-rm -it -v $(pwd):/root ubuntu bash -c "cat &gt; '/root/**{*název souboru*}**'"**

*# přivlastnění si cizího souboru*<br>
**sudo docker \-\-rm -it -v $(pwd):/root ubuntu chown $UID "/root/**{*název souboru*}**"**

## Zaklínadla (Dockerfile)

*# komentář*<br>
**#** {*komentář do konce řádku*}

*# načíst existující image a použít ji jako základ pro novou*<br>
**FROM** {*image*}

*# spustit příkaz*<br>
*// Pozor, každý příkaz se spouští v novém příkazovém intepretu!*<br>
**RUN** {*příkaz*}

*# zkopírovat soubory a adresáře z kontextu sestavení do kontejneru*<br>
*// Kontext sestavení (build context) je zvláštní oblast, kam se při spuštění příkazu „docker build“ rekurzivně zkopíruje veškerý obsah aktuálního adresáře.*<br>
**COPY** {*zdroj*} [{*další-zdroj*}]... {*cíl*}

*# vytvořit zadaný adresář a nastavit ho jako aktuální*<br>
*// Cesta může být i relativní.*<br>
**WORKDIR** {*cesta*}

*# nastavit výchozí proces kontejneru*<br>
**ENTRYPOINT ["**{*příkaz*}**"**[**, "**{*parametr*}**"**]...**]**

*# nastavit proměnné prostředí*<br>
**ENV** {*proměná*}**="**{*hodnota*}**"** [{*další\_proměná*}**="**{*její hodnota*}**"**]...


## Parametry příkazů

### docker run
*# *<br>
**sudo docker run** [{*parametry*}] {*image*} [{*náhradní příkaz a jeho parametry*}]

* **\-\-rm** \:\: Po ukončení hlavního procesu kontejner automaticky smaže.
* **-it** \:\: Spustí pro kontejner interaktivní terminál. (Opakem je **-d**, které spustí kontejner na pozadí.)
* **\-v** {*/adresář/venku*}**:**{*/adresář/v/kontejneru*} \:\: Připojí adresář vnějšího počítače do kontejneru.
* **\-p** {*port-venku*}**:**{*port-v-kontejneru*} \:\: Připojí síťový port vnějšího počítače do kontejneru.
* **\-\-name** {*jméno*} \:\: Přidělí kontejneru jméno.
* **\-\-security-opt seccomp:unconfined** \:\: Nevím přesně, co to dělá, ale může pomoci při problémech se zabezpečeným spojením z kontejneru.
* **\-w** {*/adresář/v/kontejneru*} \:\: Nastaví aktuální adresář v kontejneru.
* **\-\-network none** \:\: Spuštěný kontejner nebude mít přístup k síti.

## Jak získat nápovědu
Pro sestavení Dockerfilu je asi nejlepším informačním zdrojem online „Referenční příručka pro Dockerfile“. Pro spouštění je pak vhodná „Oficiální referenční příručka“. Oba zdroje jsou bohužel v angličtině.

Pro základní přehled lze použít i příkazy:

*# *<br>
**docker \-\-help**<br>
**docker** {*příkaz*} **\-\-help**

## Tipy a zkušenosti

* Přidání uživatele do skupiny „docker“, které některé stránky doporučují, mu umožňuje spouštět Docker bez sudo. Z bezpečnostního hlediska to ale není dobrý nápad, protože jak ukazuje sekce zaklínadel „Eskalace práv“, spouštění Dockeru je prakticky ekvivalentem přidělení práv superuživatele. Proto raději příkaz „docker“ spouštím z bashe spuštěného pomocí „sudo bash“.
* Řádek v Dockerfilu lze rozdělit na víc řádků; v takovém případě se na konec každého kromě posledního přidá zpětné lomítko.
* Programy spouštěné při sestavování image nesmí vyžadovat žádnou uživatelskou interakci. Pokud k tomu dojde, sestavení image selže. (Proto je třeba u příkazu „apt-get install“ používat parametr „-y“.)
* V kontejnerech je možno zakládat nové uživatele a používat jejich účty, ale není to příliš běžné. Obvykle se všechny programy v kontejnerech spouští pod účtem uživatele root.
* Při sestavování image příkazem „docker build“ se celý obsah lokálního adresáře včetně všech podadresářů nejprve zkopíruje do zvláštní oblasti zvané „build context“; příkaz Dockerfilu „COPY“ pak může čerpat pouze z této oblasti. Proto doporučuji mít aktuální adresář při sestavování image co nejmenší a nikdy nespouštět „docker build“ např. z kořenového adresáře. (Ani vlastní domovský adresář není moc dobrý nápad.)
* Hash kontejneru se v kontejneru používá jako název počítače, takže se zobrazuje ve výzvě příkazového interpretu a lze ji snadno zjistit příkazem „hostname“.
* Ačkoliv by spuštění grafických aplikací v Dockeru mělo být také možné, je zřejmě náročné. (Nikdy jsem se o to nepokoušel/a.)

## Ukázka
*# Dockerfile*<br>
**FROM ubuntu:18.04**<br>
**RUN apt-get update &amp;&amp; apt-get upgrade -y &amp;&amp; apt-get install -y mc vim**<br>
**WORKDIR /root**<br>
**ENTRYPOINT ["/usr/bin/mc"]**

*# sestavení a spuštění image*<br>
**sudo docker build -t midnight-commander .**<br>
**sudo docker run \-\-rm -it midnight-commander**

## Instalace na Ubuntu
*# *<br>
**sudo apt-get install docker.io**

## Odkazy

* [Praktický úvod do Docker a kontejnerů](http://www.cloudsvet.cz/?series=docker)
* [Video: Jakub Kratina − Docker 101](https://www.youtube.com/watch?v=cV0HFt0QGEA)
* [Článek: Proč používat Docker](https://www.zdrojak.cz/clanky/proc-pouzivat-docker/)
* [Stránka na Wikipedii](https://cs.wikipedia.org/wiki/Docker\_(software\))
* [Video: Docker pro neznalé (Václav Pavlín)](https://www.youtube.com/watch?v=A1nngnx8WDg)
* [Video: Daniel Plakinger − Docker #2](https://www.youtube.com/watch?v=x\_jsNPW6ixQ) (slovensky)
* [Referenční příručka pro Dockerfile](https://docs.docker.com/engine/reference/builder/) (anglicky)
* [Oficiální referenční příručka](https://docs.docker.com/engine/reference/commandline/docker/) (anglicky)
* [Oficiální stránka programu](https://www.docker.com/) (anglicky)
* [Balíček Bionic „docker.io“](https://packages.ubuntu.com/bionic/docker.io) (anglicky)
