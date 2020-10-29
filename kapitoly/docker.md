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

!Štítky: {program}{kontejnery}{virtualizace}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod
Docker je nástroj pro odlehčenou virtualizaci formou takzvaných kontejnerů. Kontejner obsahuje vlastní podstrom procesů, který je izolovaný od zbytku systému (má vlastní souborový systém, konfiguraci, knihovny, démony, síťové rozhraní a IP adresu), ale sdílí s ním jádro a výpočetní prostředky. To umožňuje bezpečný a snadno přenositelný běh programů určených pro jiné distribuce (můžete např. na nejnovější Fedoře spouštět program ze staré verze Debianu apod.). Nevýhodou Dockeru je, že jeho používání vyžaduje oprávnění superuživatele a nepodporuje přímo spouštění grafických aplikací nebo přímý přístup k hardwaru (i barvy v terminálu je tam podtřeba zprovoznit). Nejčastěji se používá na provozování databází.

Použití Dockeru obecně probíhá tak, že napíšete vlastní Dockerfile, z něj sestavíte obraz a z tohoto obrazu pak vytváříte kontejnery, které spouštíte. Kontejner může běžet buď na popředí (v příkazové řádce), nebo na pozadí.

Tato verze kapitoly pokrývá pouze základy Dockeru; nezmiňuje se o nástoji „docker-compose“ a pokrývá jen malou část dostupných „docker“-příkazů. Neuvádí specializované repozitáře jako např. „mysql“.

## Definice

* **Kontejner** je dočasné (ale perzistentní) částečně izolované prostředí pro spouštění programů.
* **Obraz** je neměnný, opakovaně použitelný výchozí stav kontejneru.
* **Repozitář** je soubor obrazů se společným označením (např. „ubuntu“ či „mysql“). Jednotlivé obrazy se pak identifikují pomocí **tagu** uvedeného za název repozitáře a dvojtečku (např. „ubuntu:18.04“). Není-li tag uveden, Docker automaticky doplní „latest“.
* **Dockerfile** je textový soubor s názvem „Dockerfile“, obsahující instrukce k vytvoření obrazu.

!ÚzkýRežim: vyp

## Zaklínadla (docker)

### Práce s obrazy
*# **vytvořit** obraz z Dockerfilu*<br>
*// Pozor na tečku na konci příkazu, je povinná a bez ní příkaz skončí vypsáním nápovědy!*<br>
**sudo docker build** [**-t** {*repozitář*}[**:**{*tag-pro-obraz*}]] [**\-\-no-cache**] **.**

*# **vypsat** lokálně dostupné obrazy*<br>
**sudo docker images**

*# **smazat** obraz (lokálně)*<br>
**sudo docker rmi** {*obraz*}...

*# vyhledat vzdáleně dostupné repozitáře*<br>
*// Uvedený příkaz má přednastavený limit 25 položek; parametrem lze počet zvýšit maximálně na 100.*<br>
**sudo docker search** [**\-\-limit=100**] {*text-k-vyhledání*}

*# vypsat všechny vzdáleně dostupné repozitáře*<br>
?

*# vypsat vzdáleně dostupné obrazy z určitého repozitáře*<br>
?

*# **přejmenovat** obraz *<br>
*// Původní označení zůstane zachováno.*<br>
**sudo docker tag** {*starý-repozitář*}[**:**{*starý-tag*}] {*nový-repozitář*}[**:**{*nový-označení-tag*}]<br>
**sudo docker rmi** {*starý-repozitář*}[**:**{*starý-tag*}]

*# **uložit** obraz do souboru/**načíst** ze souboru*<br>
*// Uložený obraz doporučuji komprimovat (je ve formátu tar); obsahuje všechny vrstvy potřebné pro rekonstrukci obrazu, takže ho lze načíst i na počítači bez připojení k internetu. Rovněž je to vhodný způsob, jak si obraz zálohovat.*<br>
**sudo docker save -o** {*soubor*} {*obraz*}<br>
**sudo docker load -i** {*soubor*}

*# uložit obraz na standardní výstup/načíst ze standardního vstupu*<br>
**sudo docker save** {*obraz*}<br>
**sudo docker load**

*# stáhnout vzdálený obraz k použití lokálně*<br>
*// Tento příkaz obvykle není třeba používat, protože Docker chybějící obrazy stahuje automaticky, jakmile jsou potřeba.*<br>
**sudo docker pull** {*obraz*}

### Práce s kontejnery

*# vytvořit a **spustit** kontejer*<br>
**sudo docker run** [{*parametry*}] {*obraz*} [{*náhradní příkaz a jeho parametry*}]

*# **vypsat** seznam kontejnerů (jen běžících/všech na daném počítači)*<br>
**sudo docker ps**<br>
**sudo docker ps -a**

*# **zastavit** kontejner (normálně/násilně)*<br>
**sudo docker stop** {*kontejner*}<br>
**sudo docker kill** {*kontejner*}

*# **znovu spustit** zastavený kontejner*<br>
**sudo docker start** {*kontejner*}

*# **smazat** kontejner (jen zastavený/i běžící)*<br>
**sudo docker rm** {*kontejner*}<br>
**sudo docker rm -f** {*kontejner*}

*# **přejmenovat** kontejner*<br>
**sudo docker rename** {*kontejner*} {*nové-jméno*}

*# spustit nový interpret příkazové řádky v již běžícím kontejneru (obecně/konkrétně)*<br>
**sudo exec -it** {*kontejner*} {*interpret*}<br>
**sudo exec -it ef95f2 bash**

*# kopírování souborů z kontejneru/do kontejneru*<br>
**sudo docker cp** {*kontejner*}**:**{*/cesta/v/kontejneru*} {*cíl/mimo*}<br>
**sudo docker cp** {*zdroj/mimo/kontejner*} {*kontejner*}**:**{*/cíl/v/kontejneru*}

*# vytvořit kontejner bez spuštění*<br>
**sudo docker create** [{*parametry*}] {*obraz*}

### Pročištění systému
*# **pročistit systém** (po čase bývá nezbytné)*<br>
**sudo docker system prune**

### Eskalace práv
*# přečtení souboru, který nemáte právo číst*<br>
**sudo docker \-\-rm -it -v "$(pwd):/root" ubuntu cat "/root/**{*název souboru*}**"**

*# přepsání souboru, do kterého nemáte právo zapisovat*<br>
**sudo docker \-\-rm -it -v "$(pwd):/root" ubuntu bash -c "cat &gt; '/root/**{*název souboru*}**'"**

*# přivlastnění si cizího souboru*<br>
**sudo docker \-\-rm -it -v "$(pwd):/root" ubuntu chown $UID "/root/**{*název souboru*}**"**

## Zaklínadla (Dockerfile)

*# komentář*<br>
**#** {*komentář do konce řádku*}

*# načíst existující obraz a použít ji jako základ pro nový*<br>
**FROM** {*obraz*}

*# spustit příkaz*<br>
*// Pozor, každý příkaz se spouští v nové instanci příkazovém intepretu „/bin/sh“!*<br>
**RUN** {*příkaz*}

*# zkopírovat soubory a adresáře z kontextu sestavení do kontejneru*<br>
*// Kontext sestavení (build context) je zvláštní oblast, kam se při spuštění příkazu „docker build“ rekurzivně zkopíruje veškerý obsah aktuálního adresáře.*<br>
**COPY** {*zdroj*} [{*další-zdroj*}]... {*cíl*}

*# vytvořit zadaný adresář a nastavit ho jako aktuální*<br>
*// Cesta může být i relativní.*<br>
**WORKDIR** {*cesta*}

*# nastavit výchozí proces kontejneru (obecně/konkrétně)*<br>
**ENTRYPOINT ["**{*příkaz*}**"**[**, "**{*parametr*}**"**]...**]**<br>
**ENTRYPOINT ["/bin/bash", "-e"]**

*# nastavit proměnné prostředí*<br>
**ENV** {*proměnná*}**="**{*hodnota*}**"** [{*další\_proměnná*}**="**{*její hodnota*}**"**]...


## Parametry příkazů

### docker run
*# *<br>
**sudo docker run** [{*parametry*}] {*obraz*} [{*náhradní příkaz a jeho parametry*}]

* **\-\-rm** \:\: Po ukončení hlavního procesu automaticky smaže kontejner.
* **-it** \:\: Spustí pro kontejner interaktivní terminál. (Opakem je **-d**, které spustí kontejner na pozadí.)
* **\-v** {*/adresář/venku*}**:**{*/adresář/v/kontejneru*} \:\: Připojí adresář vnějšího počítače do kontejneru.
* **\-p** {*port-venku*}**:**{*port-v-kontejneru*} \:\: Připojí síťový port vnějšího počítače do kontejneru.
* **\-\-name** {*jméno*} \:\: Přidělí kontejneru jméno.
* **\-\-security-opt seccomp:unconfined** \:\: Nevím přesně, co to dělá, ale může pomoci při problémech se zabezpečeným spojením z kontejneru.
* **\-w** {*/adresář/v/kontejneru*} \:\: Nastaví aktuální adresář v kontejneru.
* **\-\-network none** \:\: Spuštěný kontejner nebude mít přístup k síti.

## Instalace na Ubuntu
*# *<br>
**sudo apt-get install docker.io**

## Ukázka
*# Dockerfile*<br>
**FROM ubuntu:18.04**<br>
**RUN apt-get update &amp;&amp; apt-get upgrade -y &amp;&amp; apt-get install -y mc vim**<br>
**WORKDIR /root**<br>
**ENTRYPOINT ["/usr/bin/mc"]**

*# sestavení a spuštění obrazu*<br>
**sudo docker build -t midnight-commander .**<br>
**sudo docker run \-\-rm -it midnight-commander**

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Přidání uživatele do skupiny „docker“, které některé stránky doporučují, mu umožňuje spouštět Docker bez sudo. Z bezpečnostního hlediska to ale není dobrý nápad, protože jak ukazuje podsekce zaklínadel „Eskalace práv“, spouštění Dockeru je prakticky ekvivalentem přidělení práv superuživatele. Proto raději příkaz „docker“ spouštím z bashe spuštěného pomocí „sudo bash“.
* Řádek v Dockerfilu lze rozdělit na víc řádků; v takovém případě se na konec každého kromě posledního přidá zpětné lomítko.
* Programy spouštěné při sestavování obrazu nesmí vyžadovat žádnou uživatelskou interakci. Pokud k tomu dojde, sestavení obrazu selže. (Proto je třeba u příkazu „apt-get install“ používat parametr „-y“.)
* V kontejnerech je možno zakládat nové uživatele a používat jejich účty, ale není to příliš běžné. Obvykle se všechny programy v kontejnerech spouští pod účtem uživatele root.
* Při sestavování obrazu příkazem „docker build“ se celý obsah lokálního adresáře včetně všech podadresářů nejprve zkopíruje do zvláštní oblasti zvané „build context“; příkaz Dockerfilu „COPY“ pak může čerpat pouze z této oblasti. Proto doporučuji mít aktuální adresář při sestavování obrazu co nejmenší a nikdy nespouštět „docker build“ např. z kořenového adresáře. (Ani domovský adresář uživatele není moc dobrý nápad.)
* Hash kontejneru se v kontejneru používá jako název počítače, takže se zobrazuje ve výzvě příkazového interpretu a lze ji snadno zjistit příkazem „hostname“.
* Ačkoliv by spuštění grafických aplikací v Dockeru mělo být také možné, vyžaduje specializovaný postup a nikdy jsem se o ně nepokoušel/a.

## Další zdroje informací

Pro sestavení Dockerfilu je asi nejlepším informačním zdrojem online „Referenční příručka pro Dockerfile“. Pro spouštění je pak vhodná „Oficiální referenční příručka“. Oba zdroje jsou bohužel v angličtině.

Pro základní přehled lze použít i příkazy:

*# *<br>
**docker \-\-help**<br>
**docker** {*příkaz*} **\-\-help**

* [Praktický úvod do Docker a kontejnerů](http://www.cloudsvet.cz/?series=docker)
* [Video: Jakub Kratina – Docker 101](https://www.youtube.com/watch?v=cV0HFt0QGEA)
* [Článek: Proč používat Docker](https://www.zdrojak.cz/clanky/proc-pouzivat-docker/)
* [Stránka na Wikipedii](https://cs.wikipedia.org/wiki/Docker\_(software\))
* [Video: Docker pro neznalé (Václav Pavlín)](https://www.youtube.com/watch?v=A1nngnx8WDg)
* [Video: Daniel Plakinger – Docker #2](https://www.youtube.com/watch?v=x\_jsNPW6ixQ) (slovensky)
* [Referenční příručka pro Dockerfile](https://docs.docker.com/engine/reference/builder/) (anglicky)
* [TL;DR stránka „docker“](https://github.com/tldr-pages/tldr/blob/master/pages/common/docker.md) (anglicky)
* [Oficiální referenční příručka](https://docs.docker.com/engine/reference/commandline/docker/) (anglicky)
* [TL;DR stránka „docker images“](https://github.com/tldr-pages/tldr/blob/master/pages/common/docker-images.md) (anglicky)
* [TL;DR stránka „docker container“](https://github.com/tldr-pages/tldr/blob/master/pages/common/docker-containers.md) (anglicky)
* [TL;DR stránka „docker-compose“](https://github.com/tldr-pages/tldr/blob/master/pages/common/docker-compose.md) (anglicky)
* [Oficiální stránka programu](https://www.docker.com/) (anglicky)
* [Balíček Bionic „docker.io“](https://packages.ubuntu.com/bionic/docker.io) (anglicky)

!ÚzkýRežim: vyp
