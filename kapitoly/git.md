<!--

Linux Kniha kouzel, kapitola Git
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
ÚKOLY:

[ ] Lépe zpracovat git rev-list.
[ ] Nějak zpracovat řešení konfliktů při slučování větví.
[ ] Zpracovat „git remote add“
[ ] Zpracovat „git stash“
[ ] Zpracovat „git for-each-ref“

Ubuntu 22.04:
git config --global init.defaultBranch {název} // od git 2.28 je možno změnit výchozí název větve

-->

# Git

!Štítky: {program}{správa verzí}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod
Git je systém správy verzí. Umožňuje vám zachytit přesný stav souborů v určitém
adresáři a jeho podadresářích. Každý takto zachycený stav se opatří datem, časem
a popisem a později se k němu můžete vrátit, nebo ho exportovat do samostatného
adresáře. Kromě toho umožňuje git synchronizaci a slučování změn v jinak oddělených
kopiích daného adresáře a perfektní evidenci změn v textových souborech.

Tato verze kapitoly nepokrývá dostatečně řešení konfliktů při slučování větví
a příkaz „git stash“.

## Definice
* **Pracovní adresář** je množina všech verzovaných souborů v gitem spravovaném uživatelském adresáři. Nikdy nezahrnuje obsah speciálního adresáře „.git“.
* **Revize** je konkrétní neměnný (historický) stav pracovního adresáře zapsaný do repozitáře a doplněný o další údaje. Revizi lze v příkazové řádce určit řadou způsobů, viz níže. Revize vzniká operací **commit**.
* **Repozitář** je skupina souborů a adresářů, do kterých git vysoce optimalizovaným způsobem ukládá všechny revize. Repozitář může mít přiřazen jeden nebo více vzdálených repozitářů (nejčastěji pouze jeden, zvaný **origin**); není-li repozitář takzvaně „bare“, má také svůj primární pracovní adresář a může mít i jeden nebo více „sekundárních pracovních adresářů“.
* **Tag** je symbolický název pevně přiřazený uživatelem určité konkrétní revizi; není vhodné jej dodatečně měnit. (Je v gitu analogií konstanty v programování.)
* **Větev** je proměnný symbolický název odkazující na určitou revizi v repozitáři (s výjimkou takzvané prázdné větve, která na žádnou revizi neodkazuje). Součástí operace „**commit**“ je přiřazení nové revize větvi. (Větev je v gitu analogií proměnné v programování.)
* **HEAD** je „aktuální revize“. Nejčastěji je to prostě revize, která byla do pracovního adresáře načtena jako poslední.
* **Index** (také zvaný „staging area“) je myšlená kopie revize HEAD příslušná pracovnímu adresáři, do které lze průběžně zapisovat změny a pak z ní operací „commit“ vytvořit novou revizi. Do indexu se rovněž provádí slučování větví (merge). Doporučuji představovat si index jako skrytý adresář určený k tvorbě nových revizí.

!ÚzkýRežim: vyp

### Označení revize

Každá revize je jednoznačně identifikována pomocí své MD5 heše. Kromě této úplné heše můžeme pojmenovat revizi těmito způsoby:

* Jednoznačný prefix heše (Nebude-li uvedený prefix jednoznačný, git vyvolá chybu a umožní vám situaci napravit, takže se nebojte používat ani velmi krátké prefixy.)
* HEAD
* Název větve
* Název tagu
* Jiné označení revize, tilda a číslo; takto získáte N-tého předka dané revize, např. **HEAD\~1** je bezprostřední předek aktuální revize, **vetev\~3** je čtvrtá nejčerstvější revize ve větvi „vetev“ apod.

## Zaklínadla

### Práce s repozitáři

*# **vytvořit** nový repozitář v aktuálním adresáři (normální/bare)*<br>
**git init** [**&amp;&amp; git checkout -b** {*název\_výchozí\_větve*}]<br>
**git init \-\-bare**

*# vytvořit lokální repozitář **ze vzdáleného***<br>
**git clone** {*vzdálená-adresa*} [{*místní-adresář*}]

*# získat do samostatného nového adresáře konkrétní revizi*<br>
*// Poznámka: nový adresář musí ležet mimo stávající pracovní adresář. Můžete jej zadat jak relativní, tak i absolutní cestou.*<br>
**git worktree add \-\-detach** {*nový/adresář*} {*revize*} **&amp;&amp; rm** {*nový/adresář*}**/.git &amp;&amp; git worktree prune**

*# konverze bare repozitáře na normální*<br>
**git -C** {*repozitář*} **config core.bare false**<br>
**mv** {*repozitář*} {*repozitář*}**-git**<br>
**mkdir** {*repozitář*}<br>
**mv** {*repozitář*}**-git** {*repozitář*}**/.git**<br>
**git -C** {*repozitář*} **reset \-\-hard**

*# konverze normálního repozitáře na bare repoziťář*<br>
**mv** {*repozitář*}**/.git** {*repozitář*}**-git**<br>
**rm -R** {*repozitář*}<br>
**mv** {*repozitář*}**-git** {*repozitář*}<br>
**git -C** {*repozitář*} **config core.bare true**

### Mezi pracovním adresářem, indexem a lokálním repozitářem

*# **načíst** zadanou revizi do pracovního adresáře i indexu (jen načíst/načíst a vytvořit z ní ní novou větev)*<br>
*// Jsou-li v pracovním adresáři změny, tento příkaz se je pokusí zachovat.*<br>
**git checkout** {*revize*}<br>
**git checkout -b** {*nová-větev*} [{*revize*}]

*# přenést do indexu změny v pracovním repozitáři (všech souborů/jen již verzovaných)*<br>
*// Normálně „git add“ přenese smazání souboru jen tehdy, je-li daný soubor výslovně jmenován na příkazovém řádku. S parametrem „-A“ přenese všechna smazání.*<br>
**git add** [**-A**] <nic>[**\-\-**] {*soubor-nebo-adresář*}...<br>
**git add -u** [**-A**] <nic>[**\-\-**] <nic>[{*soubor-nebo-adresář*}]...

*# operace **commit** (vytvořit z indexu novou revizi a nastavit na ni aktuální větev)*<br>
**git commit** [**-m** {*komentář*}] <nic>[**-a**] <nic>[**\-\-allow-empty**] <nic>[**\-\-amend**] <nic>[**-S**] <nic>[**\-\-reset-author**]

*# nahradit poslední commitnutou revizi novým commitem se zachováním původního autora, předků, komentáře a časové známky*<br>
*// Pozn.: heš commitu se v tomto případě změní, protože revize je neměnná, takže jediný způsob, jak ji upravit, je vytvořit novou revizi a nahradit s ní tu původní.*<br>
**git commit \-\-amend \-\-no-edit**

*# načíst konkrétní soubory z revize v repozitáři do pracovního adresáře a indexu*<br>
*// Výchozí revize je HEAD. Pozor, bez ptaní přepíše změny v pracovním adresáři!*<br>
**git checkout** [{*revize*}] <nic>[**\-\-**] {*soubor-nebo-adresář*}...

*# načíst HEAD do indexu/do indexu a pracovního adresáře (**zrušit všechny změny**)*<br>
**git reset**<br>
**git reset \-\-hard**

*# načíst konkrétní soubory z revize v repozitáři do indexu*<br>
*// Výchozí revize je HEAD.*<br>
**git reset** [{*revize*}] <nic>[**\-\-**] {*soubor-nebo-adresář*}...

*# načíst do pracovního adresáře i indexu revizi, která byla nejnovější k určitému datu/před 14 dny*<br>
**git checkout $(git rev-list -n 1 \-\-first-parent "\-\-until=**{*datum-YYYY-MM-DD HH:mm:ss*}**" HEAD)**<br>
**git checkout $(git rev-list -n 1 \-\-first-parent "\-\-until=$(date -d "14 days ago" "+%F %T")" HEAD)**

*# smazat soubor z pracovního adresáře i indexu/jen z indexu*<br>
**git rm** [**-f**] <nic>[**-r**] <nic>[[\-\-] {*soubor-či-adresář*}...]
**git rm \-\-cached** [**-f**] <nic>[**-r**] <nic>[[\-\-] {*soubor-či-adresář*}...]

*# přesunout či přejmenovat soubor/přesunout soubory v pracovním adresáři i indexu*<br>
**git mv** {*původní-cesta*} {*nová-cesta*}<br>
**git mv** {*zdroj*}... {*cílový-adresář*}

*# vypsat na standardní výstup konkrétní soubor z konkrétní revize*<br>
?

### Práce se vzdáleným repozitářem (origin)

*# stáhnout všechny novinky a **aktualizovat** právě načtenou větev*<br>
*// Pokud ve vzdáleném repozitáři nastaly změny i v jiných větvích, než té, která je právě načtená do pracovního adresáře, příkaz „git pull“ tyto jiné větve neaktualizuje!*<br>
**git pull**

*# **odeslat změny** v aktuální větvi z lokálního repozitáře do vzdáleného (jednorázově/nastavit/větev už je nastavená)*<br>
**git push origin** {*větev*}<br>
**git push -u origin** {*větev*}
**git push**

*# vytvořit novou větev z HEAD a **odeslat** ji do vzdáleného repozitáře*<br>
**git checkout -b** {*nová-větev*}<br>
**git push -u origin** {*nová-větev*}

*# odeslat zadané větve (existující větve ve vzdáleném repozitáři budou přepsány)*<br>
*// Poznámka: Příkaz „git push“ selže, pokud vzdálený repozitář není bare.*<br>
**git push** [**-u**] **origin** {*větev*}...

*# odeslat zadané tagy*<br>
**git push origin** {*tag*}...

*# smazat zadanou větev nebo tag ze vzdáleného repozitáře*<br>
**git push :**{*větev-nebo-tag*} [**:**{*další-větev-nebo-tag*}]...

*# stáhnout všechny novinky ze vzdáleného repozitáře*<br>
**git fetch**

### Jednoduchá práce s větvemi
*# **vytvořit** novou větev z HEAD a přepnout se na ni (nezmění pracovní adresář ani index)*<br>
**git checkout -b** {*nová-větev*}

*# vytvořit novou větev a přiřadit jí HEAD/určitou revizi (lze použít k duplikaci větve)*<br>
**git branch** {*nová-větev*}<br>
**git branch** {*nová-větev*} {*revize*}

*# **smazat** větev (jen sloučenou/kteroukoliv)*<br>
*// Pozor, při smazání nesloučené větve můžete přijít o commitnuté revize, které přestanou být po smazání dané větve dostupné!*<br>
**git branch -d** {*větev*}...<br>
**git branch -D** {*větev*}...

*# **přejmenovat** větev*<br>
**git branch -m** {*starý-název*} {*nový-název*}

*# ručně přiřadit aktuální větvi **určitou revizi** (i nesouvisející)*<br>
**git reset \-\-soft** {*revize*}

*# vytvořit novou **odpojenou větev** (orphan branch)(z určité revize/zcela prázdnou)*<br>
**git checkout \-\-orphan** [{*revize*}]
**git checkout \-\-orphan &amp;&amp; git rm -rf .**

### Jednoduchá práce s tagy
*# **vytvořit** nový tag (normální/anotovaný)*<br>
**git tag** {*název-tagu*} [{*revize*}]<br>
**git tag -a -m** {*komentář*} [{*revize*}]

*# **vypsat** seznam tagů (všech/odpovídajících vzorku)*<br>
**git tag**<br>
**git tag -l "**{*vzorek*}**"**

*# **smazat** tag*<br>
*// Mazání a znovuvytvoření zcela lokálního tagu, který nemá obdobu ve vzdáleném repozitáři, je bezpečné. Všechny ostatní případy mohou mít nepříjemné nečekané důsledky.*<br>
**git tag -d** {*název-tagu*}

### Analýza stavu

*# vypsat „pro člověka“ **běžné informace** (aktuální větev a změněné soubory v indexu a pracovním adresáři)*<br>
**git status** [{*soubor-či-adresář*}]...

*# vypsat **změny** v pracovním adresáři oproti HEAD/v pracovním adresáři oproti indexu/v indexu oproti HEAD*<br>
**git diff HEAD** [**\-\-** {*soubor-nebo-adresář*}...]<br>
**git diff** [**\-\-** {*soubor-nebo-adresář*}...]<br>
**git diff \-\-cached** [**\-\-** {*soubor-nebo-adresář*}...]

*# vypsat **rozdíly** mezi dvěma revizemi*<br>
**git diff** {*revize1*} {*revize2*} [**\-\-** {*soubor-nebo-adresář*}...]

*# vypsat „pro člověka“ zpětnou historii předků aktuální revize (až po kořen/jen po první revizi dosažitelnou z „omezující-revize“)*<br>
**git log** [**\-\-pretty=**{*formát*}] <nic>[**-n** {*maximální-počet-revizí*}] <nic>[{*revize*}]<br>
**git log** [**\-\-pretty=**{*formát*}] <nic>[**-n** {*maximální-počet-revizí*}] {*omezující-revize*}**..**{*revize*}

*# vypsat „pro člověka“ zpětnou historii revizí, u kterých došlo ke změně v některém z uvedených souborů*<br>
**git log** [**\-\-pretty=**{*formát*}] <nic>[**-n** {*maximální-počet-revizí*}] <nic>[{*revize*}] **\-\-** {*soubor-nebo-adresář*}...

*# vypsat podrobné informace o revizi*<br>
**git show** {*revize*}

*# vypsat (pro skript) seznam tvořený revizí a všemi jejími předky*<br>
**git rev-list** {*revize*}

*# vypsat úplnou heš dané revize*<br>
**git rev-list -n 1** {*revize*}

### Sekundární pracovní adresáře

*# **vytvořit***<br>
*// Poznámka: v žádných dvou pracovních adresářích jednoho repozitáře nemůže být současně aktivní tatáž větev; toto opatření platí, aby se zamezilo konfliktům při commitování.*<br>
**git worktree add** [**\-\-detach**] <nic>[**-b** {*nová-větev*}] {*/nový/adresář*} {*revize*}

*# **vypsat** seznam*<br>
**git worktree list** [**\-\-porcelain**]

*# **smazat***<br>
**git worktree remove** {*/sekundární/pracovní/adresář*}

*# smazat všechny nedostupné sekundární pracovní adresáře*<br>
**git worktree prune**

*# **přesunout***<br>
**git worktree move** {*/sekundární/pracovní/adresář*} {*/nové/umístění*}

*# zamknout/odemknout (zamknutý adresář se nesmaže příkazem „prune“)*<br>
**git worktree lock** [**\-\-reason** {*důvod*}] {*/sekundární/pracovní/adresář*}<br>
**git worktree unlock** {*/sekundární/pracovní/adresář*}

### Slučování větví a řešení konfliktů

*# sloučit rozdíly mezi HEAD a uvedenou revizí do aktuální větve provedením commitu*<br>
*// Dojde-li při slučování ke konfliktu, můžeme je zrušit příkazem „git merge \-\-abort“.*<br>
**git merge** {*revize*}...

### Práce se změnami z revizí (pokročilá)

*# **odvolat** změny z určitých revizí/z určitého rozsahu revizí a odvolání commitnout*<br>
*// Příkaz „git revert“ vyžaduje, aby v indexu ani pracovním adresáři nebyly žádné změny oproti HEAD.*<br>
**git revert** [**\-\-no-edit**] <nic>[**-n**] {*revize*}...<br>
**git revert** [**\-\-no-edit**] <nic>[**-n**] {*starší-revize*}**..**{*novější-revize*}

*# **přenést** změny z uvedených revizí do aktuální větve (seznam revizí uvést v příkazu/načíst)*<br>
**git cherry-pick** [**-x**] <nic>[**-n**] {*revize*}...<br>
{*příkaz generující seznam revizí*} **\| git cherry-pick \-\-stdin** [**-x**] <nic>[**-n**]

*# zařadit změny provedené v jiné větvi před změny provedené v této větvi*<br>
*// Pozor! Protože revize jsou neměnné včetně odkazů na své předky, tento příkaz vytvoří zcela novou historii větve, a změní tak heše všech jejích revizí.*<br>
**git rebase** {*revize-jiná-větev*}

### Konfigurace repozitáře (obecně)
*# **vypsat** současnou hodnotu určitého klíče*<br>
**git config** [**\-\-global**] **\-\-get** {*klíč*}

*# **nastavit** hodnotu určitého klíče*<br>
**git config** [**\-\-global**] {*klíč*} **"**{*nová hodnota*}**"**

*# vypsat celou konfiguraci (lokální/globální/globální a pod ní lokální)*<br>
**git config \-\-local -l**
**git config \-\-global -l**
**git config -l**

*# vypsat platné konfigurační dvojice klíč=hodnota*<br>
**git config -l \| tac \| awk -F = '/=/ &amp;&amp; !($1 in A) {A[$1] = 1; print $0;}' \| LC\_ALL=C sort**

*# najít seznam podporovaných konfiguračních klíčů*<br>
**git config \-\-help**

### Konfigurace gitu či repozitáře (konkrétně)
*# v logu zobrazovat datum ve formátu YYYY-MM-DD HH:MM:SS +ZZZZ (např. „1970-12-31 23:59:59 +0700“)*<br>
**git config** [**\-\-global**] **log.date iso**

*# vypisovat ne-ASCII znaky v názvech souborů tak, jak jsou*<br>
**git config** [**\-\-global**] **core.quotePath false**

*# po přihlášení (např. na GitHub) si nějakou dobu pamatovat přihlašovací údaje*<br>
*// Vhodný počet sekund je např. 300 (5 minut), 86400 (24 hodin), 604800 (týden). Údaje se ukládají pouze v RAM, takže se ztratí restartem systému, možná i odhlášením.*<br>
**git config** [**\-\-global**] **credential.helper "cache \-\-timeout=**{*počet-sekund*}**"**

*# nastavit **editor**, který má být vyvolán pro editaci komentářů k revizím*<br>
*// Vhodné jsou editory, které otevírají každý soubor v novém procesu, např. „nano“, „vim“, „emacs“, „mousepad“; předpokladem je, že daný editor musíte mít nainstalovaný.*<br>
**git config** [**\-\-global**] **core.editor** {*příkaz*}



## Zaklínadla (.gitignore)

*# komentář*<br>
**#** [{*text do konce řádky*}]

*# ignorovat soubory a adresáře vyhovující vzorku (může obsahovat znaky ? a \* ve stejném významu jako v bashi)*<br>
{*vzorek*}

*# ignorovat pouze adresáře vyhovující vzorku*<br>
{*vzorek*}**/**

## Parametry příkazů

*# *<br>
**git** [{*globální parametry*}] {*příkaz*} [{*parametry příkazu*}]

* **-C** {*adresář*} \:\: (globální parametr) Před vykonáním příkazu vstoupí do zadaného adresáře.

*# *<br>
**git** [{*globální parametry*}] **commit** [{*parametry*}]

* **\-a** \:\: Před provedením commitu přenese do indexu všechny změny a smazání verzovaných souborů v pracovním adresáři.
* **\-m "**{*komentář*}**"** \:\: Slouží k uvedení komentáře ke commitu na příkazové řádce (jinak se uživateli k sepsání komentáře otevře nastavený editor).
* **\-\-amend** \:\: Nově vytvořenou revizí nahradí stávající revizi, na kterou odkazuje aktuální větev. (Na rozdíl od normálního chování, při kterém commit přidá novou revizi jako potomka.) Nové revizi se přiřadí čas a autorství (a potenciálně i komentář) původní revize.
* **\-\-allow-empty** \:\: Dovolí vložit novou revizi i v případě, že index neobsahuje oproti HEAD žádné změny.
* **\-\-reset-author** \:\: V kombinaci s volbou \-\-amend nepřebírá z přepsané revize autorství a čas.
* **\-\-no-edit** \:\: Potlačí vyvolání editoru k zadání komentáře ke commitu.

*# *<br>
**git** [{*globální parametry*}] **add** [{*parametry*}]

* **\-u** \:\: Přenese do indexu jen změny ve verzovaných souborech a jejich smazání, nepřidává nové soubory k verzování.
* **\-v** \:\: Vypisuje provedené změny.

## Instalace na Ubuntu
*# *<br>
**sudo apt-get install git**<br>
**git config \-\-global user.name "**{*vaše celé jméno*}**"**<br>
**git config \-\-global user.email "**{*váš e-mail*}**"**

Celé jméno a e-mail se používají k označení autorství revizí. Musíte je zadat, jinak git odmítne pracovat a vyzve vás k jejich nastavení. Pro konkrétní repozitář můžete nastavit jiné hodnoty použitím stejných konfiguračních příkazů bez parametru **\-\-global**. Nastavení platí pro daný systémový uživatelský účet; chcete-li git používat z více uživatelských účtů, musíte uvedené dvě volby nastavit z každého zvlášť.

## Ukázka
*# Příprava ukázkového adresáře a souborů*<br>
**mkdir Projekt &amp;&amp; cd Projekt**<br>
**printf %s\\\\n "#!""/bin/bash" "cat text" &gt; skript**<br>
**chmod 755 skript**<br>
**printf %s\\\\n "Toto je textový soubor" &gt; text**<br>

*# Tělo příkladu*<br>
**git init**
**git add skript text**<br>
**git commit -m "První verze"**<br>
**printf %s\\\\n "Druhá řádka" &gt;&gt; text**<br>
**git status**<br>
**git commit -a -m "Přidána druhá řádka"**<br>
**git log**

*# Druhá část příkladu*<br>
**git checkout -b nova-vetev HEAD~1**<br>
**printf %s\\\\n "Jiný druhý řádek" &gt;&gt; text**<br>
**git commit -a -m "Alternativní verze"**<br>
**git diff master nova-vetev**

!ÚzkýRežim: zap

## Tipy a zkušenosti
* Normální repozitář je jednodušší než bare repozitář. Má vlastní pracovní adresář, se kterým pracuje. Normální repozitář můžete použít jako vzdálený repozitář, ale pouze ke čtení – nelze do něj zapisovat příkazem „git push“. Naopak bare repozitář slouží výhradně jako vzdálený repozitář.
* Revize vzniklé sloučením větví (merge) mají za předky všechny revize, ze kterých byly sloučeny.
* Soubor .gitignore může být v každém podadresáři pracovního adresáře; deklarace z každého souboru .gitignore platí v daném adresáři a rekurzivně ve všech jeho podadresářích, ne však nutně v celém pracovním adresáři.
* Vytvoříte-li v podadresáři pracovního adresáře soubor „.gitignore“ obsahující jediný řádek „\*“, git bude tento adresář a veškerý jeho další obsah zcela ignorovat. To je praktické, když chcete mít v pracovním adresáři podadresář, který nikdy nebudete chtít verzovat, ale současně také nechcete tento adresář zapisovat do hlavního souboru „.gitignore“.
* Soubor „.gitignore“ se obvykle verzuje spolu s normálními soubory.

## Další zdroje informací
*# *<br>
**git \-\-help**<br>
**git** {*příkaz-gitu*} **\-\-help**

Další dobrou možností je oficiální online referenční příručka (viz sekci „Odkazy“).
Přehled podporovaných konfiguračních voleb pro příkaz „git config“ najdete
(v angličtině) v online referenční příručce u příkazu „git config“.

## Odkazy

* [Playlist: tutorial gitu od BambooMachine](https://www.youtube.com/playlist?list=PL9n3wo1YKCEgKQBl1DrR_EzED9ogmKHX7)
* [Stránka na Wikipedii](https://cs.wikipedia.org/wiki/Git)
* [Kniha „Pro Git“](https://www.root.cz/knihy/pro-git/) (ISBN 978-80-904248-1-4, podléhá licenci [Creative Commons Uveďte autora-Nevyužívejte dílo komerčně-Zachovejte licenci 3.0 United States](https://creativecommons.org/licenses/by-nc-sa/3.0/us/))
* [Video: Git křížem krážem](https://www.youtube.com/watch?v=OZeqGAbtBLQ)
* [Video: Git - rýchly úvod, prvé príkazy](https://www.youtube.com/watch?v=8o5jutq2TEU) (slovensky)
* [Oficiální online referenční příručka](https://git-scm.com/docs) (anglicky)
* [Oficiální stránka programu](https://git-scm.com/) (anglicky)
* [Manuálová stránka](http://manpages.ubuntu.com/manpages/focal/en/man1/git.1.html) (anglicky)
* [Balíček Ubuntu „git“](https://packages.ubuntu.com/focal/git) (anglicky)
* [Balíček Ubuntu „gitk“](https://packages.ubuntu.com/focal/gitk) (anglicky)

!ÚzkýRežim: vyp
