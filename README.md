<!--

Linux Kniha kouzel, README
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
![Linux: Kniha kouzel](obrázky/banner.png)

„Linux: Kniha kouzel“ je česká multimediální sbírka krátkých řešených příkladů
z prostředí svobodného software v linuxu<sup>**\***</sup>, především distribucích Ubuntu a Linux Mint.
Má formu připomínající konverzační slovník cizího jazyka a je vydávána v PDF A4 a B5
pro profesionální i domácí tisk a ve formátu HTML pro snadné vykopírování zaklínadel,
můžete ji tedy používat na papíře i v počítači, proto „multimediální“.

Verze *vanilková příchuť 2.6 Nikita Nálepka* je cílena na *Ubuntu 20.04 Focal Fossa* a jeho deriváty.

Obsah podléhá licenci [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
Podrobné údaje o autorství zdrojových souborů jsou uvedeny v komentářích v jejich záhlaví;
údaje o autorství obrázkových souborů jsou uvedeny v souboru [COPYRIGHT](COPYRIGHT).

---

<sup>**\***</sup> *V tomto projektu rozlišuji „Linux“ (jen jádro) a „linux“ (operační systém včetně programů). Podrobnější informace najdete v [koncepci projektu](dodatky/koncepce-projektu.md).*

## Návody k použití

### Základní použití online (úroveň 1 — pro začátečníky)

1. Navštivte [webové stránky](https://singularis-mzf.github.io/).
2. Vyberte si „TMAVÝ MOTIV“ (výchozí), nebo „SVĚTLÝ MOTIV“ a klikněte na něj.
3. Zvolte si jednu či více kapitol z přehledu nebo z menu „KAPITOLY“. Zvolíte-li si více kapitol, doporučuji si je otevřít v samostatných „panelech“ prohlížeče.
4. Ve vybraných kapitolách pak najděte nějaké zaklínadlo, které si chcete vyzkoušet.

Obvyklý postup použití zaklínadla je následující:

1. Zamyslete se, jaký kontext zaklínadlo vyžaduje. (Nemá smysl se např. snažit vypsat název větve gitu mimo jeho pracovní adresář. Ne všechna zaklínadla se zapisují přímo na příkazovou řádku.)
2. Označte zaklínadlo v prohlížeči (má-li zaklínadlo víc alternativních variant, označte jen jednu z nich).
3. Zkopírujte ho do schránky (Ctrl+C).
4. Přepněte se do okna terminálu (nebo otevřete nové).
5. Vložte zaklínadlo (Shift+Ctrl+V).
6. Projděte zaklínadlo a místa, která jsou na webové stránce označena podtržením (k doplnění), nahraďte odpovídajícími parametry (např. názvem souboru). Smažte hranaté závorky obklopující volitelné parametry.
7. Potvrďte příkaz (Enter).

*Poznámka 1:* Na webu najdete jen základní kapitoly. Prémiové kapitoly jsou [za odměnu za sestavení](dokumentace/odměna-za-sestavení.md). Na webu najdete jen tmavý a světlý motiv; ostatní barevné motivy můžete získat v offline HTML verzi přejmenováním souborů s příponou „.css“.

*Poznámka 2:* Linux: Kniha kouzel není tutorial. Pokud ani po přečtení úvodu a definic nepochopíte,
jak se uvedená zaklínadla používají, musíte nejprve získat zkušenosti nebo navštívit jiné stránky,
kde vám použití daných nástrojů někdo názorně vysvětlí. Odkazy na takové stránky (včetně videí)
najdete v sekci „Další zdroje informací“ na konci téměř každé kapitoly.

### Základní použití offline (úroveň 2)

Na stránce [Ke stažení](https://singularis-mzf.github.io/ke-stazeni.htm) si stáhněte
„offline HTML“ variantu aktuální verze vanilkové příchuti (soubor „html.zip“)
a archiv rozbalte do vámi zvoleného adresáře.
Na téže stránce si můžete stáhnout PDF pro tisk a vytisknout.

Pokud chcete přepnout barevný motiv, smažte (nebo přejmenujte) soubor „lkk-*datum*.css“ a soubor
„lkk-*datum*-*id-motivu*“ přejmenujte na „lkk-*datum*.css“. To je výhoda, kterou má offline HTML
verze oproti online HTML verzi.

Nakonec otevřete soubor „index.htm“ ve vašem oblíbeném prohlížeči (můj oblíbený prohlížeč je Firefox)
a dále postupujte jako u základního použití online. Pokud budete HTML verzi používat dlouhodobě,
čas od času si nezapomeňte stáhnout novou verzi, abyste dostal/a ta nejnovější vylepšení a opravy.

*Poznámka 1:* V offline HTML verzi a PDF pro tisk dostupných ke stažení najdete jen základní kapitoly. Prémiové kapitoly jsou [za odměnu za sestavení](dokumentace/odměna-za-sestavení.md).

### Vlastní sestavení a tisk (úroveň 3)

Vlastní sestavení vám dává největší volnost ve výběru kapitol a v možnosti projekt upravovat
a přispívat do něj. Máte na výběr dvě varianty:

1. **[Malé sestavení](dokumentace/malé-sestavení.md)**, při kterém vznikne offline HTML verze a případně balíček pomocných funkcí a skriptů (a případně ladicí varianta „log“). Malé sestavení je celkově nenáročné, nezískáte při něm ale PDF pro tisk.
2. **[Velké sestavení](dokumentace/velké-sestavení.md)**, při kterém můžete sestavit všechny dostupné výstupní formáty. Velké sestavení vyžaduje téměř kompletní TeXlive (několik gigabajtů nástrojů) a na pomalejším počítači může trvat i mnoho minut. PDF pro tisk pak doporučuji nechat profesionálně vytisknout a svázat do kroužkové vazby. Pak můžete použít lepicí záložky k označení nejčastěji používaných zaklínadel.

Místo fyzické instalace Ubuntu 20.04 můžete k sestavení použít *kontejnery Dockeru*. Poskytuji a oficiálně podporuji [Dockerfile pro malé sestavení](docker/malé-sestavení/Dockerfile) (vyžaduje cca 500MB místa na disku) a [Dockerfile pro velké sestavení](docker/velké-sestavení/Dockerfile) (vyžaduje cca 1,5GB místa na disku). Po sestavení obrazu (``sudo docker build -t lkk .``) a spuštění kontejneru (``sudo docker run --rm -it lkk``) v obou skončíte v adresáři „/root/linux-spellbook“, kde můžete provést „git pull“, přepnout větev (pokud chcete) a následně použít příkazy „make“ z návodů pro malé/velké sestavení. Výstup překladu budete muset z kontejneru vykopírovat. Pokud budete mít s překladem v Dockeru jakýkoliv problém, napište mi e-mail a pokusím se vám poradit, nebo dokonce pomoci.

Pokud budete upravovat zdrojové kódy kapitol, vyplatí se si před tím pročíst dokument [Syntaxe kapitol](dokumentace/syntaxe-kapitol.md) a jako vzor vám může sloužit zvláštní kapitola [Ukázka](kapitoly/_ukazka.md).

## Výběr a pořadí kapitol

Zde je aktualizovaný přehled kapitol, které si při sestavení můžete vybrat v souboru „pořadí-kapitol.lst“:

### Vydané kapitoly a podkapitoly

| ID | Název kapitoly | Vydána od verze | Zařazení |
| :--- | :--- | :--- | --- |
| [awk](kapitoly/awk.md) | AWK | 1.2 | prémiová |
| [datum-čas-kalendář](kapitoly/datum-čas-kalendář.md) | Datum, čas a kalendář | 1.1 | prémiová |
| [diskové-oddíly](kapitoly/diskové-oddíly.md) | Diskové oddíly | 1.6 | základní |
| [diskové-oddíly/btrfs](kapitoly/diskové-oddíly/btrfs.md) | Diskové oddíly/Btrfs | 2.5 | základní? |
| [diskové-oddíly/lvm](kapitoly/diskové-oddíly/lvm.md) | Diskové oddíly/LVM | 2.5 | základní? |
| [diskové-oddíly/softwarový-raid](kapitoly/diskové-oddíly/softwarový-raid.md) | Diskové oddíly/Softwarový RAID | 2.5 | základní? |
| [git](kapitoly/git.md) | Git | 1.0 | základní |
| [hledání-souborů](kapitoly/hledání-souborů.md) | Hledání souborů | 1.5 | základní |
| [make](kapitoly/make.md) | Make | 1.0 | prémiová |
| [manuálové-stránky](kapitoly/manuálové-stránky.md) | Manuálové stránky | 2.4 | prémiová |
| [markdown](kapitoly/markdown.md) | Markdown | 1.0 | prémiová |
| [metapříkazy](kapitoly/metapříkazy.md) | Metapříkazy | 2.7 | základní |
| [nabídka-aplikací](kapitoly/nabídka-aplikací.md) | Nabídka aplikací | 2.4 | základní |
| [odkazy](kapitoly/odkazy.md) | Pevné a symbolické odkazy | 2.2 | základní |
| [perl-moduly](kapitoly/perl-moduly.md) | Perl: moduly a objekty | 2.3 | prémiová |
| [perl-základy](kapitoly/perl-základy.md) | Perl: základy | 2.3 | základní |
| [práce-s-archivy](kapitoly/práce-s-archivy.md) | Práce s archivy | 1.1 | základní |
| [proměnné](kapitoly/proměnné.md) | Proměnné prostředí a interpretu | 1.9 | prémiová |
| [regulární-výrazy](kapitoly/regulární-výrazy.md) | Regulární výrazy | 1.1 | základní |
| [sed](kapitoly/sed.md) | Sed | 1.8 | prémiová |
| [soubory-a-adresáře](kapitoly/soubory-a-adresáře.md) | Soubory a adresáře | 1.5 | prémiová |
| [správa-balíčků](kapitoly/správa-balíčků.md) | Správa balíčků | 1.1 | základní |
| [správa-procesů](kapitoly/správa-procesů.md) | Správa procesů | 1.4 | prémiová |
| [správa-uživatelských-účtů](kapitoly/správa-uživatelských-účtů.md) | Správa uživatelských účtů | 1.11 | základní |
| [stahování-videí](kapitoly/stahování-videí.md) | Stahování videí | 1.0 | prémiová |
| [systém](kapitoly/systém.md) | Systém | 1.2 | základní |
| [terminál](kapitoly/terminál.md) | Terminál | (1.0) | prémiová |
| [terminál/emodži](kapitoly/terminál/emodži.md) | Terminál / Emodži | (2.0) | prémiová |
| [vim](kapitoly/vim.md) | Vim | 1.8 | prémiová |
| [zpracování-binárních-souborů](kapitoly/zpracování-binárních-souborů.md) | Zpracování binárních souborů | 2.0 | prémiová |
| [zpracování-textových-souborů](kapitoly/zpracování-textových-souborů.md) | Zpracování textových souborů | 1.2 | základní |
| [zpracování-videa-a-zvuku](kapitoly/zpracování-videa-a-zvuku.md) | Zpracování videa a zvuku | 1.0 | základní |

### Rozpracované kapitoly a podkapitoly

<!--
Priority:
1. [bash] (základní věci jako roury, správa úloh apod.)
2. [pdf]
3. [wine]
4. [firefox]
-->

| ID | Název kapitoly | Růst | Stav |
| :--- | :--- | ---: | :--- |
| [x](kapitoly/x.md) | X (Správce oken) | 60% | dítě |
| [firefox](kapitoly/firefox.md) | Firefox | 60% | dítě |
| [kalkulace](kapitoly/kalkulace.md)| Kalkulace | 50% | dítě |
| [stahování-z-webu](kapitoly/stahování-z-webu.md) | Stahování z webu | 40% | dítě |
| [zpracování-obrázků](kapitoly/zpracování-obrázků.md) | Zpracování obrázků | 40% | dítě |
| [metapříkazy](kapitoly/metapříkazy.md) | Metapříkazy | 20% | dítě |
| [moderní-věci](kapitoly/moderní-věci.md) | Moderní věci | 10% | dítě |
| [unicode](kapitoly/unicode.md) | Unicode a emotikony | 10% | dítě |
| [uživatelská-rozhraní](kapitoly/uživatelská-rozhraní.md) | Uživatelská rozhraní skriptů | 5% | dítě |
| [apache](kapitoly/apache.md) | Webový server Apache | 5% | dítě |
| [latex](kapitoly/latex.md) | LaTeX | 5% | dítě |
| [dosbox](kapitoly/dosbox.md) | DosBox | 5% | dítě |
| [perl-standardní-knihovna](kapitoly/perl-standardní-knihovna.md) | Perl: standardní knihovna | 3% | dítě |
| [bash](kapitoly/bash.md) | Bash | 2% | dítě |
| [lkk](kapitoly/lkk.md) | Linux: Kniha kouzel | 2% | dítě |
| [zpracování-psv](kapitoly/zpracování-psv.md) | Zpracování PSV | 2% | dítě |
| [správa-balíčků-2](kapitoly/správa-balíčků-2.md) | Správa balíčků 2 | 1% | dítě |
| [grub](kapitoly/grub.md) | GRUB a jádro | 1% | dítě |
| [konverze-formatů](kapitoly/konverze-formatů.md) | Konverze formátů | 0% | embryo |
| [wine](kapitoly/wine.md) | Wine | 0% | embryo |
| [pdf](kapitoly/pdf.md) | PDF | 0% | embryo |
| [virtualbox](kapitoly/virtualbox.md) | VirtualBox | 0% | embryo |
| [šifrování](kapitoly/šifrování.md) | Šifrování a kryptografie | 0% | embryo |
| [soubory-a-adresáře/kopírování](kapitoly/soubory-a-adresáře/kopírování.md) | Soubory a adresáře/Kopírování | 0% | embryo |
| přehrávání-videa | Přehrávání videa, zvuku a obrázků | - | přál/a bych si |
| firewall | Firewall | - | přál/a bych si |
| sql | SQL | - | přál/a bych si |
| ascii-art | ASCII art | - | přál/a bych si |
| záznam-x | Záznam obrazovky | - | přál/a bych si |
| css | Kaskádové styly CSS | - | přál/a bych si |

### Zvláštní a vyřazené kapitoly

* [_šablona](kapitoly/_šablona.md) − Nepřekládá se. Slouží jako výchozí podoba pro nově založené kapitoly.
* [x-ostatní](kapitoly/x-ostatní.md) − Slouží k dočasnému shromážďování dosud nezařazených zaklínadel.
* [x-ukázka](kapitoly/x-ukázka.md) − Překládá se, ale není součástí vydaných verzí. Slouží k dokumentaci a testování mechanismu překladu. Obsahuje všechny podporované jazykové konstrukce a znaky.
* [Docker](kapitoly/docker.md)
* [Plánování úloh](kapitoly/plánování-úloh.md)

## Jak pomoci nebo se zapojit do vývoje

Viz soubor [JAK-SE-ZAPOJIT.md](JAK-SE-ZAPOJIT.md).

## Větve na GitHubu

* *vývojová* – Aktivně vyvíjený zdrojový kód. Sem směřují nejčerstvější příspěvky.
* *stabilní* – Zdrojový kód poslední vydané verze. Pokud vám nepůjde přeložit kód z větve „vývojová“, použijte kód z větve „stabilní“.
* *v1* — Větev 1.x; ve stádiu dlouhodobé pasivní údržby do 1. března 2023.

## Podobné projekty

*Poznámka: Uvedené údaje o licencích jsou orientační, a ačkoliv je uvádím v dobré víře, nemusí již být aktuální!*

* [Sallyx.org](https://www.sallyx.org/) (nesvobodná licence CC BY-NC-SA 3.0) jsou vynikající, obsáhlé a dodnes velmi dobře udržované stránky o linuxu a programování. Na rozdíl od *Linuxu: Knihy kouzel* nejsou open-source (autor je udržuje sám, v podstatě jde o freeware) a nemají knižní ambice, jsou však optimalizovány pro samouky, aby se z nich uváděné nástroje mohli snadno naučit. Dle mého názoru jde o nejlepší konkurenční zdroj v češtině.
* [Pure Bash Bible](https://github.com/dylanaraps/pure-bash-bible) (anglicky, licence: MIT) je stejně jako *Linux: Kniha kouzel* knihou řešených příkladů (ačkoliv jde o e-book) a také se snaží nabízet ověřená a co nejlepší řešení, autor dokonce na svoje příkazy píše automatizované testy. Oproti Linuxu: Knize kouzel je ale Pure Bash Bible zaměřená pouze na příkazový interpret „bash“.
* [Linux Journey](https://linuxjourney.com/) (anglicky, licence pouze textu: CC BY-SA 4.0) je rozsáhlý a kvalitní výukový kurz linuxových příkazů z různých oblastí. Hlavním rozdílem oproti Linuxu: Knize kouzel zde je, že je zaměřený na výuku (dokonce u jednotlivých sekcí nabízí i úkoly k procvičení), není však tak podrobný a vyhýbá se komplikovaným a nejmodernějším technologiím (např. tam nenajdete vysvětlení ACL, LVM apod.).
* [TL;DR](https://github.com/tldr-pages/tldr) (anglicky − „Too Long; Didn't Read“, licence: MIT) představuje výrazně zjednodušené manuálové stránky s krátkými příklady k jednotlivým nástrojům. Na rozdíl od *Linuxu: Knihy kouzel* je organizován po nástrojích, takže musíte vědět, k čemu chcete nápovědu, a neporadí vám lepší nástroje k provedení dané činnosti. Ke každému nástrojí navíc uvádí jen nejběžnější příklady. Kladem je, že jeden z jeho klientů je dostupný jako balíček [Ubuntu](https://packages.ubuntu.com/bionic/tldr) a [Debianu](https://packages.debian.org/buster/tldr).
* Projekt [eg](https://github.com/srsudar/eg) (anglicky, licence MIT) nabízí zjednodušené a velmi praktické „manuálové stránky“ s vynikajícím zvýrazňováním syntaxe, snadným přístupem a možností je snadno upravovat (v Markdownu). Jeho nedostatkem je orientace na dokumentaci nástrojů spíš než na řešení úloh. Také již není příliš aktivně vyvíjen (poslední verze 1.1.1 je z října 2018). (Mimochodem, autor má smysl pro humor, když radí přejmenovat „eg“ na „woman“.)
* [Cheat](https://github.com/chrisallenlane/cheat) (anglicky, licence: MIT) je nástroj pro správu vlastních jednoduchých „manuálových stránek“. Používá se snadno, ale není určen k objevování nových programů a ve srovnání s klasickými manuálovými stránkami má horší zvýrazňování syntaxe.

### Zastaralé podobné projekty

* [The Linux Documentation Project](http://www.tldp.org/) (anglicky, licence: GFDL 1.2, některé části i pod jinými svobodnými licencemi) je monumentální historická sbírka návodů a příruček mapující programy GNU a Linux. Je již ovšem prakticky neudržovaná a většinou velmi zastaralá. K návštěvě ji mohu doporučit jen „počítačovým archeologům“, rozhodně ne současným začátečníkům.
* [GNU/Linux Desktop Survival Guide](https://togaware.com/linux/survivor/) (anglicky, licence: GPL v2+ nebo CC BY 2.0+) je původně rozsáhlá sbírka jednostránkových článků o konkrétních problémech uživatele Debianu. Ačkoliv je dodnes udržovaná, připadá mi, že jedinou formou aktualizace je odstraňování již neaktuálního obsahu, po kterém bohužel zůstávají prázdné články. Na rozdíl od Linuxu: Knihy kouzel již vyšla knižně a PDF verze je placená (HTML verze je dostupná online a zdarma).

## Licence

Kniha a všechny zdrojové kódy podléhají licenci [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/),
některé soubory nabízejí také jinou licenci.
Podrobné údaje o autorství a konkrétní licenci zdrojových souborů jsou uvedeny v komentářích
v jejich záhlaví; údaje o autorství obrázkových a datových souborů (včetně formátu .tsv)
jsou uvedeny v souboru [COPYRIGHT](COPYRIGHT).
