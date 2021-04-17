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
[ ] Zpracovat „git for-each-ref“

[ ] git push {*vzdálený-repozitář*} {*co-lokálně*}:{*kam-vzdáleně*} // + vynechání co-lokálně
[ ] git fetch {*vzdálený-repozitář*} {*co-vzdáleně*}:{*kam-lokálně*}

Ubuntu 22.04:
git config --global init.defaultBranch {název} // od git 2.28 je možno změnit výchozí název větve

-->

# Git

!Štítky: {program}{správa verzí}
!FixaceIkon: 1754
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod

Git je široce používaný systém správy verzí.
Je používán k verzování zdrojových kódů nebo jiných skupin textových souborů.
Umožňuje snadný přístup do historie verzovaných souborů a slučování změn provedených
odděleně, často mnoha různými uživateli.

Příklad architektury repozitářů v Gitu:

![Obrázek: architektura Gitu](../obrázky/git.svg)

Tato verze kapitoly nepokrývá práci s podrepozitáři (submodules).
Příkaz „git stash“ je pokryt částečně, příkaz „git rebase -i“ pokryt není.

## Definice

### Základní definice

* **Pracovní adresář** (**PA**) je adresář, který obsahuje soubory verzované Gitem v otevřené podobě, abyste s nimi mohli přímo pracovat. Vždy přísluší k určitému místnímu repozitáři.
* Ke každému PA příluší jedna **přípravná oblast** (**PO**, anglicky „staging area“ či „index“), což je skrytá oblast, ve které přenášením změn z PA vzniká nová revize.
* **Revize** je konkrétní neměnný (historický) stav verzovaných souborů v PA, označený a doplněný o další údaje (zejména datum, čas, komentář a označení přispěvatele).
* Když do repozitáře vložíte novou revizi, předchozí revize se stane **rodičem** nově vložené revize. Většina revizí má jednoho rodiče; výjimkou jsou **kořenové revize**, které nemají žádné rodiče, a revize vzniklé slučováním změn („spojováním vývojových větví“), které mají obvykle dva rodiče (vzácně i víc).
* **Předkové** revize X jsou její rodiče, rodiče rodičů a tak dále. **Nejbližší společný předek** (**NSP**) dvou revizí je: 1) Pokud je jedna z revizí předkem té druhé, pak je NSP ona. 2) Jinak je NSP, pokud existuje, taková revize, která je společným předkem obou revizí, ale není rodičem žádné revize, která by společným předkem obou revizí byla také.
* **Větev** (branch) je v Gitu proměnný odkaz na (nejnovější) revizi. Když vytvoříte novou revizi, **aktivní větev** se automaticky nastaví tak, aby na tuto novou revizi odkazovala. Můžete mít mnoho různých větví, každou nechat odrážet jiný směr vývoje a přepínat se mezi nimi.
* **Jméno revize** (tag) je trvalé a neměnné symbolické označení určité revize v repozitáři (něco jako konstanta). Obvykle se používá k označení význačných revizí, např. těch, ze kterých vznikla vydaná verze softwaru.
* **Aktivní větev** je pro daný PA větev, která do něj byla naposledy načtena a k níž je připojen – to znamená, že nově vzniklé revize budou do dané větve přiřazovány. Pokud je PA odpojený od větve, má místo aktivní větve pouze **aktivní revizi**. Aktivní větev (případně aktivní revize) se symbolicky označuje **HEAD**.
* **Vzdálená větev** není větev ve výše uvedeném významu, ale jde o kopii větve ze vzdáleného repozitáře v místním repozitáři, která je aktualizována příkazem „git fetch“ nebo „git pull“.

### Druhy repozitářů

**Repozitář** je úložiště revizí. V Gitu se setkáte se třemi druhy repozitářů:

* **Místní repozitář** je nejčastější. Může spolupracovat se vzdálenými repozitáři a má k sobě vždy jeden **hlavní PA**; můžete k němu vytvářet také **vedlejší PA**. Místní repozitář může sloužit jako vzdálený repozitář jiného místního repozitáře, ale pouze ke čtení – nelze do něj odesílat.
* **Holý repozitář** nemá vlastní pracovní adresáře; slouží především v roli vzdáleného repozitáře pro místní repozitáře.
* Máte-li místní repozitář, jako **vzdálené repozitáře** se označují oddělené repozitáře, ke kterým je místní repozitář připojen a může z nich čerpat revize a větve, případně je do nich i odesílat. Vzdálené repozitáře se mohou nacházet v místním souborovém systému nebo být dostupné přes síť a samy o sobě to mohou být holé nebo (méně často) místní repozitáře.

### Označení revize

V Gitu se používá několik způsobů, jak můžete v příkazech označovat jednotlivé revize:

* **Úplná SHA-1 heš** je vhodná pouze ve skriptech, na ruční použití je nepraktická.
* **Jednoznačná předpona heše** je vhodná pro ruční použití; v malých projektech obvykle stačí první tři znaky, ve velkých pět nebo šest. Pokud předpona není jednoznačná, Git ohlásí chybu.
* **Symbolické označení**, např. název větve, jméno revize nebo „HEAD“.

Za jakýmkoliv označením revize můžete (i opakovaně a v kombinaci) použít tyto dva operátory:

* Stříška „^“ znamená přechod na rodiče revize, takže např. „HEAD^^“ znamená rodič rodiče aktivní revize. Pro přechod na jiného než prvního rodiče zadejte za stříšku číslo, takže např. „HEAD^2“ znamená přechod na druhého rodiče aktivní revize.
* Tilda (např. „\\\~2“) znamená N opakování operátoru „^“. Např. „\\\~3“ je zkratka za „^^^“, tedy rodič rodiče rodiče revize. (Zpětné lomítko se zde používá kvůli odzvláštnění v bashi; alternativní možností je uzavření označení revize do uvozovek, např. „"HEAD\~2"“.)

!ÚzkýRežim: vyp

## Zaklínadla: Revize, větve a změny

### Informace o stavu PO a PA

*# **běžné informace** pro člověka*<br>
**git status** [**-bs**] <nic>[**\-\-ignored**]
<!-- [{*soubor-či-adresář*}]... -->

*# **změny** v PA oproti HEAD/v PA oproti PO/v PO oproti HEAD*<br>
**git diff** [**\-\-name-status**] **HEAD** [**\-\-** {*soubor-nebo-adresář*}...]<br>
**git diff** [**\-\-name-status**] <nic>[**\-\-** {*soubor-nebo-adresář*}...]<br>
**git diff** [**\-\-name-status**] **\-\-cached** [**\-\-** {*soubor-nebo-adresář*}...]

*# **historie** předků aktuální revize*<br>
*// Vhodné formáty jsou „medium“, „oneline“ a „reference“; vyzkoušejte, který z nich vám víc vyhovuje. Úplný popis k revizím z nich poskytuje jen „medium“.*<br>
**git log** [**\-\-pretty=**{*formát*}] <nic>[**-n** {*maximální-počet-revizí*}] <nic>[{*revize*}]

*# historie předků, ve kterých došlo ke změně v některém z uvedených souborů*<br>
**git log** [**\-\-pretty=**{*formát*}] <nic>[**-n** {*maximální-počet-revizí*}] <nic>[{*revize*}] **\-\-** {*soubor-nebo-adresář*}...

*# historie v určitém rozsahu revizí*<br>
**git log** [**\-\-pretty=**{*formát*}] **^**{*nejstarší-revize*}**^@** {*nejnovější-revize*}

*# je soubor verzovaný?*<br>
?

*# seznam verzovaných souborů*<br>
?

*# seznam ignorovaných souborů a adresářů*<br>
?

### Větve (ne vzdálené)

*# **vytvořit** novou větev a přepnout se na ni/bez přepnutí*<br>
*// Pokud nezadáte revizi, použije se HEAD.*<br>
**git checkout -b** {*nová-větev*} [{*revize*}]<br>
**git branch** {*nová-větev*} [{*revize*}]

*# **smazat** větev (bezpečně/drasticky)*<br>
*// Při bezpečném mazání Git odmítne smazat větev, pokud by tím přestaly být dostupné některé revize, protože nejsou odkazovány odjinud. Bezpečné mazání je tedy určeno především pro mazání větví, jejichž změny již byly sloučeny do jiných větví.*<br>
**git branch -d** {*větev*}...<br>
**git branch -D** {*větev*}...

*# **seznam** větví (pro člověka/pro skript)*<br>
**git branch**<br>
**git branch \-\-no-column \-\-format '%(refname:lstrip=2)'**

*# ručně přiřadit aktuální větvi/libovolné větvi **určitou revizi** (i nesouvisející)*<br>
*// Po přiřazení nové revize aktivní větvi vám zdánlivě v PO vzniknou nové změny, protože PO zůstane ve stavu odpovídajícím původní revizi. Pokud se chcete veškerých odlišností PO a PA od cílové revize zbavit, místo „\-\-soft“ použijte „\-\-hard“.*<br>
**git reset \-\-soft** {*revize*}<br>
**git branch -f** {*větev*} {*revize*}

*# **přejmenovat** větev*<br>
**git branch -m** {*starý-název*} {*nový-název*}

*# vytvořit novou **odpojenou větev** a přejít na ni*<br>
*// Místo uvedeného tvaru příkazu „git commit“ můžete použít jakýkoliv jiný, podstatné však je, že nová větev nevznikne, dokud v ní nevytvoříte alespoň jednu revizi.*<br>
**git checkout \-\-orphan &amp;&amp; git rm -Rf . &amp;&amp; git commit \-\-allow-empty -m 'kořenová revize'**

### Aktivní větev/revize

*# **přepnout** aktivní větev a načíst ji do PA i PO/bez načtení*<br>
*// Pokud byly v PA a PO již nějaké změny oproti původní aktivní větvi, Git se je při načítání nové větve pokusí zachovat.*<br>
**git checkout** {*větev*}<br>
**git checkout \-\-detach &amp;&amp; git reset \-\-soft** {*větev*} **&amp;&amp; git checkout** {*větev*}

*# **název** aktivní větve*<br>
**git branch \-\-show-current**

*# **odpojit** se od aktivní větve*<br>
**git checkout \-\-detach**

*# **heš** aktivní revize*<br>
**git rev-parse \-\-verify HEAD**

*# je některá větev aktivní?*<br>
**git branch \-\-show-current \| egrep -q .**

### Z PA do PO a z PO do repozitáře

<!--
PA -> PO -> REPO
-->
*# odeslat změny z PA do PO, rovnou z nich vytvořit **novou revizi** a nastavit na ni aktivní větev*<br>
*// Poznámka: tento příkaz nepřidá do revize žádné dosud neverzované soubory, a pokud jste některý verzovaný soubor přesunuli jinak než příkazem „git mv“, Git už ho nenajde a v revizi skončí jako smazaný.*<br>
**git commit -a**[**S**] <nic>[**-m '**{*komentář*}**'**]

<!--
PA -> PO
-->
*# odeslat změny PA **do PO**; neverzované soubory zahrnout jako přidané/ignorovat*<br>
**git add -A**<br>
**git add -u**

<!--
PA -> PO
-->
*# odeslat do PO konkrétní soubory či adresáře (i dosud neverzované)*<br>
*// Příkaz „git add“ automaticky ignoruje soubory a adresáře nastavené k ignorování v souboru „.gitignore“.*<br>
**git add** [**-u**] <nic>[**\-\-**] {*soubor-nebo-adresář*}...

<!--
PO -> REPO
-->
*# vytvořit **novou revizi** z PO (a nastavit na ni aktivní větev)*<br>
**git commit** [**-m** {*komentář*}] <nic>[**-a**] <nic>[**-S**] <nic>[**\-\-allow-empty**]

<!--
PO -> REPO
-->
*# **nahradit** poslední revizi novou z PO*<br>
*// Revizi v každém případě zůstanou rodiče. Neuvedete-li „\-\-reset-author“, zůstane jí i autor a časová známka. Neuvedete-li „\-\-no-edit“, zůstane jí komentář. Vždy se naopak změní obsah a heš. Pozor, ostatní odkazy na nahrazovanou revizi (např. jiná než aktivní větev) budou nadále odkazovat na původní, nezměněnou revizi!*<br>
**git commit \-\-amend** [**\-\-no-edit**] <nic>[**\-\-reset-author**]

<!--
PA/PO
-->
*# **smazat** soubor z PO i PA/jen z PO*<br>
**git rm** [**-f**] <nic>[**-r**] <nic>[[\-\-] {*soubor-či-adresář*}...]<br>
**git rm \-\-cached** [**-f**] <nic>[**-r**] <nic>[[\-\-] {*soubor-či-adresář*}...]

<!--
PA/PO
-->
*# přesunout soubor/více souborů v PA i PO*<br>
**git mv** {*původní-cesta*} {*nová-cesta*}<br>
**git mv** {*zdroj*}... {*cílový-adresář*}

### Z repozitáře do PO a PA

<!--
REPO -> PO -> PA
-->
*# **načíst** revizi do PO a PA (jen načíst/načíst a vytvořit z ní ní novou větev)*<br>
*// Jsou-li v pracovním adresáři změny, tento příkaz se je pokusí zachovat.*<br>
**git checkout** {*revize*}<br>
**git checkout -b** {*nová-větev*} [{*revize*}]

<!--
REPO -> PO [-> PA]
-->
*# načíst konkrétní soubory z revize do PO a PA/jen do PO*<br>
*// Výchozí revize je HEAD. Pozor, bez ptaní přepíše změny v pracovním adresáři!*<br>
**git checkout** [{*revize*}] <nic>[**\-\-**] {*soubor-nebo-adresář*}...<br>
**git reset** [{*revize*}] <nic>[**\-\-**] {*soubor-nebo-adresář*}...

<!--
REPO -> PO [-> PA]
-->
*# zrušit všechny změny oproti HEAD v PO a PA/jen v PO*<br>
**git reset \-\-hard**<br>
**git reset**

<!--
REPO -> PO -> PA
-->
*# načíst do PO a PA revizi, která byla nejnovější k určitému datu/před 14 dny*<br>
**git checkout $(git rev-list -n 1 \-\-first-parent "\-\-until=**{*datum-YYYY-MM-DD HH:mm:ss*}**" HEAD)**<br>
**git checkout $(git rev-list -n 1 \-\-first-parent "\-\-until=$(date -d "14 days ago" "+%F %T")" HEAD)**

*# načíst revizi do PO a PA, ale nepřepnout se na ni*<br>
?

### Přístup k revizím z repozitáře

<!--
REPO -> x
-->
*# získat do samostatného nového adresáře konkrétní **revizi***<br>
[**rm -Rf** {*cílový/adresář*}]<br>
**mkdir -p**[**v**] {*cílový/adresář*} **&amp;&amp; git -C "$(git rev-parse \-\-show-toplevel)" archive** {*revize*} **\| tar x -C** {*cílový/adresář*}

<!--
Poznámka: s parametrem --remote git archive přijímá jako revizi pouze HEAD,
názvy větví a jména revizí; nepřijímá výrazy s operátory ^ a ~ ani částečné ani úplné
SHA-1 heše.
-->

<!--
**revize=$(git rev-parse \-\-verify** {*revize*}**); test -n $revize &amp;&amp; git clone -sn \-\- "$(git rev-parse \-\-show-toplevel)"** {*nový/adresář*} **&amp;&amp; (cd** {*nový/adresář*} **&amp;&amp; git checkout \-\-detach $revize &amp;&amp; rm -Rf .git)**
-->

*# vypsat na standardní výstup **soubor** z určité revize*<br>
*// Pozor! Cesta/k/souboru nesmí opustit podstrom aktuálního adresáře. Tzn. např. cesta „../x.c“ je neplatná a skončí chybou, a to i v případě, že odkazovaný soubor je verzovaný v daném repozitáři.*<br>
**git archive** {*revize*} [**\-\-**] {*cesta/k/souboru*} **\| tar xO**

*# zabalit konkrétní revizi jako **archiv** typu zip*<br>
**git -C "$(git rev-parse \-\-show-toplevel)" archive \-\-format=zip** [**-9**] {*revize*} **&gt;**{*výstup.zip*}

### Jména revizí

*# **pojmenovat** revizi*<br>
**git tag** {*nové-jméno*} [{*revize*}]

*# seznam jmen revizí*<br>
**git tag**

*# smazat jméno revize*<br>
*// Poznámka: Jména revizí jsou obvykle trvalá. Pokud se rozhodnete je měnit či mazat, pamatujte, že Git při načítání jmen revizí ze vzdáleného repozitáře nikdy nepřepíše již stažené údaje, takže znovupoužití téhož jména k označení jiné revize povede k tomu, že v repozitářích různých uživatelů bude totéž jméno označovat různé revize, což není dobrý nápad.*<br>
**git tag -d** {*jméno-revize*}

### Práce se změnami

*# **sloučit změny** do aktivní větve*<br>
*// Příkaz „git merge“ se pokusí do aktivní větve sloučit všechny změny od NSP po uvedenou revizi. Pokud to bude potřeba, vytvoří pro to novou revizi se dvěma rodiči.*<br>
**git merge** {*revize*}

*# **odvolat** změny z určitých revizí/z určitého rozsahu revizí*<br>
*// Příkaz „git revert“ vyžaduje, aby v PO ani PA nebyly žádné změny oproti HEAD. Příkaz vytvoří nové revize s opačným účinkem oproti zadaným revizím.*<br>
**git revert** [**\-\-no-edit**] <nic>[**-n**] {*revize*}...<br>
**git revert** [**\-\-no-edit**] <nic>[**-n**] {*starší-revize*}**..**{*novější-revize*}

*# **přehrát** změny z uvedených revizí v aktivní větvi (seznam revizí uvést/načíst)*<br>
**git cherry-pick** [**-x**] <nic>[**-n**] {*revize*}...<br>
{*zdroj*} **\| git cherry-pick \-\-stdin** [**-x**] <nic>[**-n**]

*# **přehrát změny** na vrchol aktivní větve*<br>
?

*# zakomponovat změny do historie aktivní větve*<br>
*// Tento příkaz používejte opatrně. Vyjde od zadané revize a vytvoří zcela novou sérii revizí, ve které revizi po revizi přehrává změny od NSP po aktivní větev. Nakonec nastaví aktivní větev na konec takto vytvořené sekvence revizí, takže se původní revize ztratí, ledaže na ně vedl jiný odkaz (např. jiná větev či jméno revize).*<br>
**git rebase** {*revize*}

<!--
[ ] git rebase -i

*// Příkaz „git rebase“ najde nejbližšího společného předka aktivní větve a uvedené revize a pro každou revizi mezi nimi se pokusí vzít změny, které přinesla, přenést je na vrchol aktivní větve a z výsledku vytvořit novou revizi.*<br>
-->

*# zrušit slučování (nastal-li konflikt)*<br>
**git merge \-\-abort**

### Vzdálené větve

*# stáhnout všechny novinky a sloučit vzdálené změny do aktivní větve/jen sloučit změny*<br>
**git pull**<br>
**git merge FETCH\_HEAD**

*# **odeslat změny** v aktuální větvi (do napojené větve/a nastavit napojení)*<br>
**git push**<br>
**git push -u** {*vzdálený-repozitář*} **$(git branch \-\-show-current)**

*# načíst vzdálenou větev do místní a přepnout se na ni*<br>
**git checkout** {*vzdálený-repozitář*}**/**{*vzdálená-větev*}

*# **seznam** vzdálených větví (pro člověka/pro skript)*<br>
**git branch -r**<br>
**git branch -r \-\-no-column \-\-format '%(refname:lstrip=2)'**

*# kam je napojená aktivní větev?*<br>
*// Pokud aktivní větev není napojená, příkaz selže s návratovým kódem 128.*<br>
**git rev-parse \-\-abbrev-ref "HEAD@{upstream}" 2&gt;/dev/null** ⊨ origin/vzdalena-vetev

<!--
**git for-each-ref \-\-format '%(upstream:short)' "refs/heads/$(git branch \-\-get-current)"**
Ve starších verzích použít „git symbolic-ref --short HEAD 2&gt;/dev/null“.
-->

*# **smazat** větev ve vzdáleném repozitáři*<br>
**git push** {*vzdálený-repozitář*} **:**{*vzdálená-větev*} [**:**{*další-vzdálená-větev*}]...

*# **vytvořit** místní větev napojenou na existující vzdálenou větev (obecně/příklad)*<br>
**git branch** {*místní-název*} {*vzdálený-repozitář*}**/**{*vzdálená-větev*}<br>
**git branch moje-stabilni origin/stabilni**

*# odeslat do vzdáleného repozitáře **jména revizí***<br>
**git push** {*vzdálený-repozitář*} {*jméno-revize*}...

*# nastavit/zrušit napojení místní větve na vzdálenou*<br>
**git branch -u** {*vzdálený-repozitář*}**/**{*vzdálená-větev*} {*místní-větev*}<br>
**git branch \-\-unset-upstream** {*místní-větev*}

*# kam je napojená určitá větev?*<br>
**git rev-parse \-\-abbrev-ref "**{*místní-větev*}**@{upstream}"** [**"**{*místní-větev*}**@{upstream}"**]...

### Vyhledávání revizí

*# **NSP***<br>
**git merge-base** {*revize*} {*další-revize*}...

*# všechny revize z určitého dne*<br>
?

## Zaklínadla: Pracovní adresáře a repozitáře

### Analýza stavu

*# vypsat **rozdíly** mezi dvěma revizemi*<br>
**git diff** [**\-\-name-status**] {*revize1*} {*revize2*} [**\-\-** {*soubor-nebo-adresář*}...]

*# vypsat „pro člověka“ zpětnou historii předků aktuální revize (až po kořen/jen po první revizi dosažitelnou z „omezující-revize“)*<br>
**git log** [**\-\-pretty=**{*formát*}] <nic>[**-n** {*maximální-počet-revizí*}] <nic>[{*revize*}]<br>
**git log** [**\-\-pretty=**{*formát*}] <nic>[**-n** {*maximální-počet-revizí*}] {*omezující-revize*}**..**{*revize*}

*# úplná cesta k pracovnímu adresáři (aktuálnímu/hlavnímu)*<br>
**git rev-parse \-\-show-toplevel**<br>
**git worktree list \-\-porcelain \| sed -E '2,$d;s/^worktree&blank;//'**

*# vypsat podrobné informace o revizi*<br>
**git show** {*revize*}

*# vypsat (pro skript) seznam tvořený revizí a všemi jejími předky*<br>
**git rev-list** {*revize*}

*# vypsat úplnou heš dané revize*<br>
**git rev-list -n 1** {*revize*}

<!--
### Vyhledávání revizí
[ ]
-->

### Vytvoření a konverze repozitáře (místní/holý)

*# **vytvořit** nový repozitář v aktuálním adresáři (místní/holý)*<br>
**git init** [**&amp;&amp; git checkout -b** {*název\_výchozí\_větve*}]<br>
**git init \-\-bare**

*# vytvořit lokální repozitář **ze vzdáleného***<br>
*// Vzdálená adresa může být URL nebo místní cesta. Vzniklý repozitář pak bude mít automaticky nastavený vzdálený repozitář „origin“ na uvedenou adresu či cestu.*<br>
**git clone** [**\-\-branch** {*větev*}] {*vzdálená-adresa*} [{*místní-adresář*}]

*# konverze holého repozitáře na **místní***<br>
**git -C** {*repozitář*} **config core.bare false**<br>
**mv** {*repozitář*} {*repozitář*}**-git**<br>
**mkdir** {*repozitář*}<br>
**mv** {*repozitář*}**-git** {*repozitář*}**/.git**<br>
**git -C** {*repozitář*} **reset \-\-hard**

*# konverze místního repozitáře na **holý***<br>
**mv** {*repozitář*}**/.git** {*repozitář*}**-git**<br>
**rm -R** {*repozitář*}<br>
**mv** {*repozitář*}**-git** {*repozitář*}<br>
**git -C** {*repozitář*} **config core.bare true**

### Vzdálený repozitář

*# stáhnout všechny novinky do lokální kopie (1 repozitář/všechny)*<br>
**git fetch** [**\-\-tags**] <nic>[{*vzdálený-repozitář*}]<br>
**git fetch \-\-all** [**\-\-tags**]

*# zjistit/změnit **adresu***<br>
**git remote get-url** {*vzdálený-repozitář*}<br>
**git remote set-url** {*vzdálený-repozitář*} **"**{*adresa*}**"**

*# **seznam** vzdálených repozitářů (i pro skript)*<br>
**git remote**

*# vypsat **informace** o vzdáleném repozitáři*<br>
**git remote show -n** {*vzdálený-repozitář*}

*# **přidat**/odebrat*<br>
**git remote add** {*název*} **"**{*adresa*}**"**<br>
**git remote remove** {*název*}

*# **přejmenovat***<br>
**git remote rename** {*původní-název*} {*nový-název*}

<!--
git remote set-head {*vzdálený-repozitář*} -d
:: Pomůže proti „ignoring broken ref refs/remotes/*/HEAD“
-->

### Vedlejší pracovní adresáře

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

### Odkládání a rušení změn v PA a PO

<!--
[ ] git clean – odstranění neverzovaných souborů
-->

*# **odložit** změny v PA a PO*<br>
**git stash push -ku** [**-m "**{*Popis*}**"**]

*# **obnovit** odložené změny do PA a PO*<br>
*// Poznámka: PA a PO nemusí být při obnovování změn v přesně stejném stavu jako při odkládání, stačí když při obnovování změn nedojde ke konfliktu.*<br>
**git stash pop \-\-index**

*# **smazat** odložené změny*<br>
**git stash clear**

*# vypsat odložené změny (jen poslední odložení)*<br>
**git stash show -p**

*# vypsat seznam uložených odložení*<br>
**git stash list**

### Ostatní

*# smazat neverzované soubory a adresáře (kromě/včetně ignorovaných)*<br>
*// Poznámka: Tento příkaz smaže pouze soubory v aktuálním adresáři a jeho podadresářích; pokud chcete smazat neverzované soubory v celém PA, musíte příkaz spustit v kořeni pracovního adresáře.*<br>
**git clean -fd**[**i**]<br>
**git clean -fdx**[**i**]




## Zaklínadla: Konfigurace a ostatní

### Syntaxe v souboru .gitignore

*# ignorovat soubory a adresáře/jen adresáře vyhovující vzorku*<br>
*// Vzorek může obsahovat zvláštní znaky „?“, „\*“, a konstrukce „[...]“ a „[<nic>^...]“.*<br>
{*vzorek*}

*# komentář*<br>
**#** [{*text do konce řádky*}]

*# ignorovat všechny soubory a adresáře*<br>
**\***

### Konfigurace obecně

*# **vypsat** současnou hodnotu určitého klíče*<br>
**git config** [**\-\-global**] **\-\-get** {*klíč*}

*# **nastavit** hodnotu určitého klíče*<br>
**git config** [**\-\-global**] {*klíč*} **"**{*nová hodnota*}**"**

*# vypsat celou konfiguraci (lokální/globální/globální a pod ní lokální)*<br>
**git config \-\-local -l**<br>
**git config \-\-global -l**<br>
**git config -l**

*# vypsat platné konfigurační dvojice klíč=hodnota*<br>
**git config -l \| tac \| awk -F = '/=/ &amp;&amp; !($1 in A) {A[$1] = 1; print $0;}' \| LC\_ALL=C sort**

*# **smazat** určitý klíč*<br>
**git config** [**\-\-global**] **\-\-unset** {*klíč*}

*# najít seznam podporovaných konfiguračních klíčů*<br>
**git help config**<br>
!: Zadejte:<br>
**/^\\s\*Variables** {_Enter_}

### Konfigurace konkrétně

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

### Zkratky

*# **nastavit** na příkaz Gitu/vnější příkaz*<br>
**git config** [**\-\-global**] **alias.**{*podpříkaz*} **'**{*příkaz-gitu*}&blank;[{*parametry*}]**'**<br>
**git config** [**\-\-global**] **alias.**{*podpříkaz*} **'!**{*příkaz*}[&blank;{*parametry*}]**'**

*# **seznam** (globálních/místních/právě platných)*<br>
**git config \-\-global -l \| sed -E 's/^alias\\.([<nic>^=]+)=.\*$/\\1/;t;d'**<br>
**git config \-\-local -l \| sed -E 's/^alias\\.([<nic>^=]+)=.\*$/\\1/;t;d'**<br>
**git config -l \| sed -E 's/^alias\\.([<nic>^=]+)=.\*$/\\1/;t;d' \| sort -u**

*# vypsat obsah zkratky*<br>
?
<!--
**git config** [**\-\-global**] **\-\-get alias.**{*podpříkaz*}
[ ] Nutno zohlednit prioritu v případě vícenásobného výskytu.
-->

*# **zrušit***<br>
**git config** [**\-\-global**] **\-\-unset alias.**{*podpříkaz*}

## Parametry příkazů

*# *<br>
**git** [{*globální parametry*}] {*příkaz*} [{*parametry příkazu*}]

!parametry:
* -C {*adresář*} :: (globální parametr) Před vykonáním příkazu vstoupí do zadaného adresáře.

*# *<br>
**git** [{*globální parametry*}] **commit** [{*parametry*}]

!parametry:

* -a :: Před vytvořením revize přenese do PO všechny změny a smazání verzovaných souborů v pracovním adresáři. Neverzované soubory nepřidává.
* -m "{*komentář*}" :: Použije k revizi uvedený komentář a neotevře editor.
* --amend :: Nahradí stávající aktivní revizi, přičemž nové revizi zůstane čas, označení přispěvatele a komentář z původní revize, pokud nepoužijete v kombinaci s parametrem „\-\-reset-author“.
* --allow-empty :: Dovolí vložit novou revizi i v případě, že PO neobsahuje žádné změny oproti HEAD.
* --no-edit :: Potlačí vyvolání editoru k zadání komentáře ke commitu.

<!--
* **\-\-reset-author** \:\: V kombinaci s volbou \-\-amend nepřebírá z přepsané revize autorství a čas.
-->

*# *<br>
**git** [{*globální parametry*}] **add** [{*parametry*}]

!parametry:

* -u :: Přenese do indexu jen změny ve verzovaných souborech a jejich smazání, nepřidává nové soubory k verzování.
* -v :: Vypisuje provedené změny.

## Instalace na Ubuntu

*# *<br>
**sudo apt-get install git**<br>
**git config \-\-global user.name "**{*vaše celé jméno*}**"**<br>
**git config \-\-global user.email "**{*váš e-mail*}**"**

Celé jméno a e-mail se používají k označení autorství revizí.
Musíte je zadat z každého uživatelského účtu, kde budete Git používat,
odmítne pracovat a vyzve vás k jejich nastavení. (Nemusíte je ovšem zadat pravdivě.)
Globálně zadané hodnoty můžete pro jednotlivé repozitáře změnit.

## Ukázka

*# Příprava ukázkového adresáře a souborů*<br>
**mkdir Projekt &amp;&amp; cd Projekt**<br>
**printf %s\\\\n "#!""/bin/bash" "cat text" &gt; skript**<br>
**chmod 755 skript**<br>
**printf %s\\\\n "Toto je textový soubor" &gt; text**

*# Tělo příkladu*<br>
**git init**<br>
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

* Soubor .gitignore může být v každém podadresáři PA; jeho deklarace platí v adresáři, kde se nachází, a ve všech jeho podadresářích.
* Vytvoříte-li v podadresáři pracovního adresáře soubor „.gitignore“ obsahující jediný řádek „\*“, git bude tento adresář a veškerý jeho další obsah zcela ignorovat. To je praktické, když chcete mít v pracovním adresáři podadresář, který nikdy nebudete chtít verzovat.
* Soubor „.gitignore“ se obvykle verzuje spolu s normálními soubory.

### Slučování změn a řešení konfliktů

Příkaz „git merge {*revize*}“ najde NSP aktivní větve a zadané revize
a pokusí se do aktivní větve sloučit všechny změny od tohoto předka do „revize“.
(To mimochodem znamená, že je-li revize předkem aktivní větve, neudělá příkaz nic, a je-li
naopak potomkem, aktivní větev se jednoduše nastaví na zadanou revizi.)

Git se při slučování snaží všechny změny zanést automaticky. Pokud jsou však změny v některých
souborech konfliktní, automatické slučování selže a konflikty musíte vyřešit ručně,
příkazem „git mergetool“ nebo slučování zrušit příkazem „git merge \-\-abort“.

Zde vysvětlím pouze ruční řešení konfliktů. Příkazem „git status“ identifikujte soubory,
kde se konflikty nacházejí (jsou označené „both modified“). Každý takový soubor musíte
otevřít v textovém editoru a najít konflikty (Git je označil příslušnými značkami).
Řádky, které jsou v konfliktu, musíte nějakým rozumným způsobem sloučit, a značky Gitu
odstranit. Po vyřešení všech konfliktů odešlete změny do PO a vytvořte revizi:

*# *<br>
**git add -u &amp;&amp; git commit \-\-no-edit**

Pozor, pokud značky konfliktu někde zapomenete, zůstanou součástí příslušných souborů,
což může být do budoucna problém.

## Další zdroje informací

*# *<br>
**git help**<br>
**git help** {*příkaz-gitu*}

Další dobrou možností je oficiální online referenční příručka (viz sekci „Odkazy“),
ale vždy budete muset zkontrolovat, zda vaše verze Gitu uváděné volby již podporuje.
Přehled podporovaných konfiguračních voleb pro příkaz „git config“ najdete
(v angličtině) v online referenční příručce u příkazu „git config“.

## Odkazy

* [Playlist: tutorial gitu od BambooMachine](https://www.youtube.com/playlist?list=PL9n3wo1YKCEgKQBl1DrR_EzED9ogmKHX7)
* [Stránka na Wikipedii](https://cs.wikipedia.org/wiki/Git)
* [Kniha „Pro Git“](https://www.root.cz/knihy/pro-git/) (ISBN 978-80-904248-1-4, podléhá licenci [Creative Commons Uveďte autora-Nevyužívejte dílo komerčně-Zachovejte licenci 3.0 United States](https://creativecommons.org/licenses/by-nc-sa/3.0/us/))
* [Video: Git křížem krážem](https://www.youtube.com/watch?v=OZeqGAbtBLQ)
* [Video: Git - rýchly úvod, prvé príkazy](https://www.youtube.com/watch?v=8o5jutq2TEU) (slovensky)
* [Learn Git Branching](https://learngitbranching.js.org/) (anglicky) (velmi dobrý kurz, podléhá licenci MIT)
* [A Step by Step Guide for How to Resolve Git Merge Conflicts](https://www.youtube.com/watch?v=\_\_cR7uPBOIk) (anglicky)
* [Git rebase and Git rebase \-\-onto](https://medium.com/@gabriellamedas/git-rebase-and-git-rebase-onto-a6a3f83f9cce) (anglicky)
* [Oficiální online referenční příručka](https://git-scm.com/docs) (anglicky)
* [Oficiální stránka programu](https://git-scm.com/) (anglicky)
* [Manuálová stránka](http://manpages.ubuntu.com/manpages/focal/en/man1/git.1.html) (anglicky)
* [Balíček Ubuntu „git“](https://packages.ubuntu.com/focal/git) (anglicky)
* [Balíček Ubuntu „gitk“](https://packages.ubuntu.com/focal/gitk) (anglicky)

## Zákulisí kapitoly
<!--
- Doplňte, pokud víte. Udržujte aktuální.
-->

V této verzi kapitoly chybí:

!KompaktníSeznam:
* git for-each-ref
* git rev-list (je třeba lepší zpracování)

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* nic

!ÚzkýRežim: vyp
