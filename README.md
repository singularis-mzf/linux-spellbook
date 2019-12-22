<!--

Linux Kniha kouzel, README
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
![Linux: Kniha kouzel](obrazky/banner.png)

„Linux: Kniha kouzel“ je open source sbírka velmi krátkých řešených příkladů pro příkazovou řádku/příkazový řádek systému Linux, především distribuce Ubuntu. V současnosti je dostupná ve formátu HTML pro zobrazení na počítači a ve formátu PDF pro tisk na papír.

Verze 1.1 je cílena na *Ubuntu 18.04 Bionic Beaver* a jeho deriváty.

Příručka podléhá licenci [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
Podrobné údaje o autorství zdrojových souborů jsou uvedeny v komentářích v jejich záhlaví;
údaje o autorství obrázkových souborů jsou uvedeny v souboru [COPYING](COPYING).

## Návod k použití

### Použití online (pro začátečníky)

Navštivte [webové stránky](https://singularis-mzf.github.io/) a vyberte si nejnovější verzi pro váš operační systém. Na přehledové stránce si pak zvolíte jednu či více kapitol, které si chcete prohlédnout (zvolíte-li si více kapitol, doporučuji je otevít v samostatných „panelech“ prohlížeče). Ve vybraných kapitolách pak najděte nějaké zaklínadlo, které si chcete vyzkoušet. Obvyklý postup jeho použití je následující:

1. Zamyslete se, jaký kontext zaklínadlo vyžaduje. (Nemá smysl se např. snažit vypsat název větve gitu mimo jeho pracovní adresář. Ne všechna zaklínadla se zapisují přímo na příkazovou řádku.)
2. Označte zaklínadlo v prohlížeči (má-li zaklínadlo víc alternativních variant, označte jen jednu z nich).
3. Zkopírujte ho do schránky (Ctrl+C).
4. Přepněte se do okna terminálu (nebo otevřete nové).
5. Vložte zaklínadlo (Shift+Ctrl+V).
6. Projděte zaklínadlo a místa, která jsou na webové stránce označena podtržením (k doplnění), doplňte odpovídajícími parametry.
7. Potvrďte příkaz (Enter).

*Poznámka:* Linux: Kniha kouzel není tutorial. Pokud na první pokus nepochopíte, jak se uvedená zaklínadla používají, zkuste si prohlédnout ukázku (sekce „Ukázka“), pokud ji daná kapitola nabízí. Pokud to nepomůže, musíte nejprve navštívit jiné stránky, kde vám použití daných nástrojů někdo názorně vysvětlí. Odkazy na takové stránky (včetně videí) najdete v sekci „Odkazy“ prakticky v každé kapitole.

### Použití online (pro pokročilé)

Navštivte [webové stránky](https://singularis-mzf.github.io/), vyberte požadovanou verzi knihy, zvolte kapitoly, které jsou blízké tématu, které vás zajímá, a projděte přehled zaklínadel, který kapitola nabízí. Zaklínadla můžete ze stránky přímo vykopírovat, jen bude potřeba doplnit parametry označené podtržením.

### Použití offline

Na stránce [releases](https://github.com/singularis-mzf/linux-spellbook/releases) tohoto repozitáře si můžete stáhnout offline HTML variantu libovolné vydané verze projektu. Offline HTML verze funguje opravdu offline; internet budete potřebovat, jedině pokud se budete chtít podívat na některý z odkazovaných webů.

Pro tisk jsou určeny varianty ve formátu PDF, které jsou rovněž ke stažení na stránce [releases](https://github.com/singularis-mzf/linux-spellbook/releases). Tištěná verze je podstatně přehlednější než jakákoliv elektronická. Doporučuji vytištěné listy svázat do kroužkové vazby.

## Návod k sestavení

K sestavení příručky ze zdrojového kódu budete potřebovat Git, GNU make, GNU awk, ImageMagick, rsvg-convert a LaTeX
a kvůli řazení české locale „cs\_CZ.UTF-8“ (musí fungovat české řazení příkazem „sort“).
V Ubuntu 18.04 LTS, Debianu 10 a Linuxu Mint 17.2 můžete tyto nástroje nainstalovat příkazem:

> ``sudo apt-get install git make gawk imagemagick librsvg2-bin texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-fonts-extra texlive-lang-czechslovak hunspell-cs``

Předpokládám, že používáte českou lokalizaci daného systému. Pokud ne, v Ubuntu a Linuxu Mint to můžete napravit doinstalováním balíčku „language-pack-cs“ (na českou lokalizaci není nutno přepínat, stačí když bude nainstalovaná). Řešení pro Debian neznám.

Pak budete potřebovat stáhnout si repozitář:

> ``git clone https://github.com/singularis-mzf/linux-spellbook.git``

A nakonec stačí spustit make:

> ``cd linux-spellbook``<br>
> ``make``

Pro urychlení můžete programu „make“ předat parametr **„-j4“**.

Výstup ve všech podporovaných formátech najdete v podadresářích adresáře ``vystup_prekladu``.

## Návod k zapojení se

(ve výstavbě)

### Výběr a pořadí kapitol

Pořadí a přítomnost kapitol a dodatků ve výstupu se nastavuje v souboru „kapitoly.lst“,
který se při prvním překladu automaticky vygeneruje jako kopie souboru „kapitoly.lst.vychozi“.
Kapitoly ani dodatky se však nesmějí opakovat.


## Stav vývoje kapitol (podle ID)
### Vydané kapitoly

* [barvy-a-titulek](kapitoly/barvy-a-titulek.md)
* [datum-cas-kalendar](kapitoly/datum-cas-kalendar.md)
* [docker](kapitoly/docker.md)
* [git](kapitoly/git.md)
* [make](kapitoly/make.md)
* [markdown](kapitoly/markdown.md)
* [planovani-uloh](kapitoly/planovani-uloh.md)
* [prace-s-archivy](kapitoly/prace-s-archivy.md)
* [regularni-vyrazy](kapitoly/regularni-vyrazy.md)
* [sprava-balicku](kapitoly/sprava-balicku.md)
* [stahovani-videi](kapitoly/stahovani-videi.md)
* [zpracovani-videa-a-zvuku](kapitoly/zpracovani-videa-a-zvuku.md)

### Dospělé nevydané kapitoly

*Zatím nejsou.*

### Kapitoly-děti

* [sprava-uzivatelu](kapitoly/sprava-uzivatelu.md) (80%)
* [awk](kapitoly/awk.md) (60%)
* [zpracovani-obrazku](kapitoly/zpracovani-obrazku.md) (40%)
* [x](kapitoly/x.md) (40%)
* [odkazy](kapitoly/odkazy.md) (20%)
* [perl](kapitoly/perl.md) (20%)
* [latex](kapitoly/latex.md) (5%)
* [konverze-formatu](kapitoly/konverze-formatu.md) (0%)
* [zpracovani-textovych-souboru](kapitoly/zpracovani-textovych-souboru.md) (0%)
* [unicode](kapitoly/unicode.md) (0%)

### Zvláštní kapitoly

* [_ostatni](kapitoly/_ostatni.md) − Slouží k dočasnému shromážďování dosud nezařazených zaklínadel.
* [_sablona](kapitoly/_sablona.md) − Nepřekládá se. Slouží jako výchozí podoba pro nově založené kapitoly.
* [_ukazka](kapitoly/_ukazka.md) − Překládá se, ale není součástí vydaných verzí. Slouží k dokumentaci a testování mechanismu překladu. Obsahuje všechny podporované jazykové konstrukce a znaky.

## Podobné projekty

* [TL;DR](https://github.com/tldr-pages/tldr) (anglicky − „Too Long; Didn't Read“, licence: MIT) představuje výrazně zjednodušené manuálové stránky s krátkými příklady k jednotlivým nástrojům. Na rozdíl od *Linuxu: Knihy kouzel* je organizován po nástrojích, takže musíte vědět, k čemu chcete nápovědu, a neporadí vám lepší nástroje k provedení dané činnosti. Ke každému nástrojí navíc uvádí jen nejběžnější příklady. Kladem je, že jeden z jeho klientů je dostupný jako balíček [Ubuntu](https://packages.ubuntu.com/bionic/tldr) a [Debianu](https://packages.debian.org/buster/tldr).
* [eg](https://github.com/srsudar/eg) (anglicky, licence MIT) je projektu *Linux: Kniha kouzel* asi nejpodobnější. Nabízí zjednodušené a velmi praktické „manuálové stránky“ s vynikajícím zvýrazňováním syntaxe, snadným přístupem a možností je snadno upravovat (v Markdownu). Jediným jeho nedostatkem je opět orientace na dokumentaci nástrojů spíš než na úkoly. Také již není příliš aktivně vyvíjen (poslední verze 1.1.1 je z října 2018).
* [Cheat](https://github.com/chrisallenlane/cheat) (anglicky, licence: MIT) je nástroj pro správu vlastních jednoduchých „manuálových stránek“. Používá se snadno, ale není určen k objevování nových programů a ve srovnání s klasickými manuálovými stránkami má horší zvýrazňování syntaxe.
* [Bro Pages](http://bropages.org) (anglicky, pozor − proprietární licence) nabízejí stejně jako *Linux: Kniha kouzel* obsáhlejší přehled možností, ale stále organizovaný po jednotlivých nástrojích a bez kategorizace do logických skupin.

## Licence

Příručka podléhá licenci [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).
Podrobné údaje o autorství a konkrétní licenci zdrojových souborů jsou uvedeny v komentářích
v jejich záhlaví; údaje o autorství obrázkových a datových souborů (včetně formátu .tsv)
jsou uvedeny v souboru [COPYING](COPYING).
