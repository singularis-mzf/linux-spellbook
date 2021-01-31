<!--

Linux Kniha kouzel, kapitola Manuálové stránky
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

[ ] info - uvážit
[ ] tldr - zjistit, jak provozovat offline
⊨
-->

# Manuálové stránky

!Štítky: {tematický okruh}{dokumentace}{syntaxe}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola pokrývá zobrazování, správu a vytváření manuálových stránek
v linuxu.
<!-- a dále využití jiných jim příbuzných a podobných informačních zdrojů. -->

Manuálové stránky jsou hlavním zdrojem základních informací o příkazech
v terminálu (např. „ps“), vlastnostech a funkcích operačního systému
(např. „fstab“) a funkcích v programovacích jazycích (např. „strcpy“).

## Definice

* **Název** je základní označení manuálové stránky bez dalšího upřesnění (např. „printf“ či „git-config“). V názvech se *nerozlišuje* velikost písmen, ale obvykle se píšou malými písmeny a slova se oddělují pomlčkami.
<!-- [ ] Smí identifikátor začínat číslicí? -->
* Manuálové stránky se nacházejí v číslovaných **manuálových sekcích** (něco jako adresáře, neplést si se sekcemi manuálových stránek).
* **Anotace** je velmi stručné, jednořádkové shrnutí činnosti příkazu, programu či funkce, které manuálová stránka poskytuje v sekci „JMÉNO“ („NAME“).
* Každá manuálová stránka se člení na **sekce manuálové stránky** a **podsekce**, více úrovní členění není podporováno.

Protože je běžné, že pod jedním názvem existují manuálové stránky v několika
různých manuálových sekcích, pro úplné určení je nutné uvést název
manuálové stránky i označení manuálové sekce; pro to existuje několik
nekompatibilních syntaxí:

!KompaktníSeznam:
* passwd(5)
* passwd.5
* passwd&blank;(5)

!ÚzkýRežim: vyp

## Zaklínadla: hlavní

### Zobrazit manuálové stránky

*# **zobrazit** m. stránku (obecně/příklady)*<br>
*// Uvedete-li v tomto zaklínadle na místo názvu více parametrů, příkaz man se je nejprve pokusí složit pomlčkami. Teprve pokud takovou m. stránku nenajde, zkusí zpracovat každý parametr zvlášť.*<br>
**man** {*název*}[**.**{*sekce*}]<br>
**man man**<br>
**man apt-get.8**

*# zobrazit postupně **více m. stránek** (obecně/příklad)*<br>
*// Pokud znáte sekce, z nichž chcete stránky zobrazit, doporučuji při zobrazování více stránek zadávat jejich úplné názvy. Zabráníte tím zobrazení stejnojmenných m. stránek z nechtěných sekcí.*<br>
**man -a \-\-no-subpages** {*název*}[**.**{*sekce*}] [{*název*}[**.**{*sekce*}]]...<br>
**man -a \-\-no-subpages git.1 diff sudo.8 apt-get.8**

*# vypsat **anotaci***<br>
**whatis** [**-s** {*sekce*}] {*název*}

*# zobrazit m. stránku z konkrétního **souboru***<br>
*// Zadaný soubor může, ale nemusí být komprimovaný příkazem „gzip“. Na název a umístění zadaného souboru nejsou kladena žádná zvláštní omezení. (Ale pokud název začíná pomlčkou, musíte použít oddělovač „\-\-“.)*<br>
**man -l** [**\-\-**] {*cesta/k/souboru*}

*# zobrazit m. stránku a přejít na **určitou sekci***<br>
?

*# zobrazit všechny m. stránky, jejichž název odpovídá **regulárnímu výrazu***<br>
**man \-\-names-only \-\-regex** [**-s** {*výčet,m.,sekcí*}]...] <nic>[**\-\-**] {*'regulární výraz'*}

### Seznamy manuálových stránek

*# seznam **všech** dostupných m. str.*<br>
**man** [**-s** {*výčet,m.,sekcí*}] **-k .** [**\| sort**]  <nic>[**\| less**]

*# všech m. str. v man. sekci 1*<br>
**man -s 1 -k . \| sort** [**\| less**]

<!--
**man -k . \| sed -E 's/^(\\S+) \\([^()]\\)\\s\*\\S\\s(.+)$/\\2\\t\\1\\t\\3/'**
-->

*# seznam m. str. dostupných v **češtině** (jen úplné názvy)*<br>
**printf %s\\\\n /usr/share/man/cs/man\*/\*.\*.gz \| sed -E 's/^(.\*)\\/(.\*)\\.([^.]+)\\.gz$/\\2(\\3)/'** [**\| sort**]

*# seznam m. str. podle klíčového slova*<br>
**apropos** {*klíčovéslovo*}
<!-- [ ] vyzkoušet -->

*# seznam manuálových stránek, jejichž identifikátor odpovídá regulárnímu výrazu (obecně/příklad)*<br>
**man** [**-s** {*výčet,m.,sekcí*}] **-k** {*'regulární výraz'*} [**\| sort**]<br>
**man -s 8 -k '^apt($|-)' \| sort**

### Pokročilá práce s manuálovými stránkami

*# vypsat cestu k m. stránce/více m. stránkám*<br>
*// Je-li m. stránka dostupná ve více lokalizacích, příkaz s parametrem „-a“ je vypíše všechny.*<br>
**man -w** [**-s** {*sekce*}] {*název*}<br>
**man -wa** [**-s** {*výčet,m.,sekcí*}] {*název*}...

*# vypsat sekce a podsekce m. stránky*<br>
?

*# zkontrolovat syntaxi zdrojového kódu m. stránky*<br>
?

<!--
// chybně konvertuje „š“
*# konvertovat do HTML*<br>
**man2html -r** {*/cesta/k/souboru.gz*} **\| sed -E '1,/^$/d' &gt;**{*cílový-soubor.htm*}
-->

## Zaklínadla: syntaxe manuálové stránky

### Hlavní prvky

*# obecná struktura manuálové stránky*<br>
*// Obvyklé je „Dole uprostřed“ uvést datum poslední úpravy manuálové stránky, „Dole vlevo“ uvést název a verzi balíčku či projektu a „Nahoře uprostřed“ neuvádět.*<br>
[{*komentáře*}]...<br>
**.TH "**{*Název dokumentu*}**"** {*ČísloSekce*} [**"**{*Dole uprostřed*}**"** [**"**{*Dole vlevo*}**"** [**"**{*Nahoře uprostřed*}**"**]]]<br>
**.SH "**{*NADPIS PRVNÍ SEKCE*}**"**<br>
{*NÁZEV*} **-** {*anotace*}<br>
{*...*}

*# komentář (varianta A/varianta B)*<br>
*// Varianta A se vyhodnotí jako konec řádky; varianta B se zcela vypustí (tzn. řádek s komentářem se po vypuštění komentáře sloučí s následujícím řádkem).*<br>
!: Kdekoliv na řádku:<br>
**\\"**{*Text komentáře do konce řádky*}<br>
**\\#**{*Text komentáře do konce řádku*}

<!--
*# syntaxe příkazu (synopsis)*<br>
**.SY "**{*příkaz*}**"**<br>
[{*argumenty*}]...<br>
[**.SY "**{*příkaz*}**"**<br>
[{*argumenty*}]...]...<br>
**.YS**
-->

### Formátování odstavců

*# **nadpis** sekce/podsekce*<br>
*// Oba typy nadpisů ruší odsazení. Nadpisy sekcí je zvykem psát VELKÝMI PÍSMENY, ačkoliv to „man“ nevynucuje.*<br>
**.SH "**{*TEXT NADPISU*}**"**<br>
**.SS "**{*Text nadpisu*}**"**

*# předěl **odstavce***<br>
**.PP**

*# seznam **definic***<br>
*// Formátovací přepínač v každém štítku platí jen do konce štítku. To platí i u posledního vedlejšího štítku.*<br>
**.TP**<br>
[**\\fB**]{*Hlavní štítek*}<br>
[**.TQ**<br>
[**\\fB**]{*Vedlejší štítek*}]...<br>
{*Text definice*}...<br>
[**.PP**]

*# **zarovnat** následující odstavce vlevo*<br>
**.PP**<br>
**.ad l**

*# **zarovnat** následující odstavce do bloku*<br>
**.PP**<br>
**.ad b**

*# zvýšit úroveň **odsazení***<br>
*// Samotný příkaz „.RS“ ukončí řádek, ale nikoliv odstavec, proto i typ písma zůstává zachovaný.*<br>
**.RS**<br>
[**.PP**]

*# snížit úroveň odsazení*<br>
*// Samotný příkaz „.RE“ ukončí řádku, ale nikoliv odstavec, proto i typ písma zůstává zachovaný.*<br>
**.RE**<br>
[**.PP**]

*# ukončit odsazení*<br>
*// Samotný příkaz „.RE 1“ ukončí řádek, ale nikoliv odstavec, proto i typ písma zůstává zachovaný.*<br>
**.RE 1**<br>
[**.PP**]

*# **zarovnat** následující odstavce na střed*<br>
**.PP**<br>
**.ad c**

*# **zarovnat** následující odstavce vpravo*<br>
*// Zarovnání odstavců vpravo v podání manuálových stránek nevypadá moc dobře; než se rozhodnete ho použít, raději ho nejprve vyzkoušejte.*<br>
**.PP**<br>
**.ad r**

### Formátování písma

*# přepnout na tučné/podtržené/normální písmo (do konce odstavce)*<br>
*// Místo podtrženého písma mohou některé terminály zobrazovat text kurzívou. Mezery uprostřed podtrženého textu nebudou podtrženy.*<br>
{*...*}**\\fB**{*...*}<br>
{*...*}**\\fI**{*...*}<br>
{*...*}**\\fR**{*...*}

*# povinná volba*<br>
**\\fB**{*volba*}[**&blank;\\fI**{*argument*}]**\\fR**

*# volitelná volba*<br>
*// Tento příkaz vypíše: obyčejným písmem „[“, tučně volbu, podtrženým písmem argument (je-li uveden) a obyčejným písmem „]“, to vše oddělené mezerami. Používá se především v „synopsi“ příkazu. Pokud volba nebo argument obsahují mezeru, je nutno příslušnou část uzavřít do dvojitých uvozovek.*<br>
**.OP** {*volba*} [{*argument*}]

*# ukázka kódu (**&lt;pre&gt;**)*<br>
*// Uvnitř bloku „.EX“ až „.EE“ neprobíhá automatické zalamování řádků a jejich odsazení mezerami či tabulátory bude na výstupu zachováno; použije se neproporcionální písmo (v terminálu je totéž jako to normální). Ostatní příkazy jsou však interpretovány.*<br>
**.EX**<br>
{*řádky kódu*}...<br>
**.EE**

*# hypertextový odkaz*<br>
*// V terminálu se hypertextový odkaz realizuje tak, že se vypíše text odkazu a za ním URI v kulatých závorkách. Při exportu do HTML se ovšem vytvoří skutečný hypertextový odkaz.*<br>
**.UR** {*URI*}<br>
{*Text odkazu*}<br>
**.UE** [{*Text za odkazem.*}]

### Přepínače

*# odsazení a konce řádek: zachovat/zploštit na mezeru (jako v HTML)*<br>
*// Poznámka: přepínač „.nf“ nevypne zalamování příliš dlouhých řádek.*<br>
**.nf**<br>
**.fi**

*# vypnout/zapnout lámání slov (**hyphenation**)*<br>
**.nh**<br>
**.hy**

### Speciální znaky

*# tečka na začátku řádky*<br>
*// Také pomůže před tečku umístit přepínač typu písma (např. „\\fR“).*<br>
**\\&amp;.**{*...*}

*# nezlomitelná mezera*<br>
*// Pokud místo této značky použijete přímo nezlomitelnou mezeru, ta se neroztáhne při zarovnání do bloku a bude podtržena v případě přepnutí na podtržené písmo.*<br>
**\\~**

*# ASCII znaky: „-“, „\\“, „'“, „"“, „\`“, „^“, „\~“*<br>
*// Pokud tyto znaky použijete přímo, terminál místo nich může zobrazit jiné, podobné znaky, což může způsobit problémy, pokud se je uživatel pokusí z manuálové stránky vykopírovat. Zpětné lomítko přímo použít nemůžete.*<br>
**\\- \\\\ \\(aq \\(dq \\(ga \\(ha \\(ti**<br>

*# konec řádky/prázdný řádek*<br>
**.br**<br>
**.sp**

<!-- \& — non-printable zero-width glyph -->

*# volitelný zlom slova (v případě zlomu vložit pomlčku)*<br>
**\\%**

<!--
nevložit nic? Nějak nefunguje.
**\\:**
-->

*# zakázat zlom slova*<br>
!: Před první znak slova vložte:<br>
**\\%**

*# copyright*<br>
**\\(co**

*# plná kulatá odrážka*<br>
**\\(bu**

<!--
### Tabulky

?
*# tabulka*<br>
**.TS box**<br>
**l l l.**<br>
**\_**<br>
**a  b  c<br>
**.TE**
-->

## Parametry příkazů
### man

*# *<br>
[**MANWIDTH=**{*počet-znaků*}] **man** {*parametry*} {*název*}...

!parametry:

* ☐ -a :: zobrazit postupně stejnojmenné stránky ze všech prohledaných sekcí (jinak se zobrazí jen první nalezená)
* ☐ -L en\_US :: manuálové stránky zobrazovat výhradně v angličtině
* ☐ --nh ☐ --nj :: Zakázat lámání slov/zarovnání do bloku.

Nastavením proměnné prostředí „MANWIDTH“ lze určit, na jakou šířku se výstup
příkazu „man“ zformátuje. Ve výchozím stavu se zformátuje na šířku
terminálu (což je obvykle to, co chcete).

### Instalace manuálových stránek

Manuálové stránky v angličtině se umísťují do adresářů
/usr/share/man/man{*sekce*}, musejí být komprimované ve formátu „.gz“
a mít název „{*název*}.{*sekce*}.gz“ (např. „apt-get.8.gz“). Manuálové stránky
v češtině se umísťují do adresářů
/usr/share/man/cs/man{*sekce*}. Pokud odpovídající adresář neexistuje
(což se stává především u českých manuálových stránek), budete ho muset vytvořit.

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíčků k instalaci vycházejte z minimální instalace Ubuntu.
-->

Manuálové stránky a nástroje pro práci s nimi jsou základní součástí Ubuntu přítomnou i v minimální instalaci.

<!--
TLDR?
**git clone 'https://github.com/tldr-pages/tldr.git' tldr**<br>
**chmod -R ug=rwx,o=r tldr**<br>
**sudo chown -R root:root tldr**<br>
**sudo mv -vt /opt tldr**<br>
**mkdir -pv ~/.tldr &amp;&amp; ln -fsv -t ~/.tldr /opt/tldr**
-->

## Ukázka

*# *<br>
**.TH "MOJE" 1 "14.\\~ledna\\~2020" "Moje vlastní stránky"**<br>
**.SH "JMÉNO"**<br>
**moje - moje první manuálová stránka**<br>
**.SH "POUŽITÍ"**<br>
**.SY moje**<br>
**[\\fB\\-x\\fR]**<br>
**.OP -y test**<br>
**.YS**<br>
**.SH "POPIS"**<br>
**Toto je moje první vlastní manuálová stránka. K\\~ jejímu napsání mi pomohl**<br>
**Linux: Kniha kouzel.**<br>
**.PP**<br>
**Delší ukázkou je:**<br>
**\\(bu manuálová stránka dodávaná ke spouštěči \\fBlkk\\fR.**

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Častou začátečnickou chybou je očekávání, že když za příkaz „man“ zadáte více neúplných názvů, zobrazí manuálovou stránku pro každý z nich. Jenže to funguje jen někdy, takže se dříve nebo později „spálíte“. Zkuste, co udělá příkaz „man apt get“ (nebo pokud máte nainstalovaný git, můžete zkusit „man git diff“).
* Prázdné řádky ve zdrojovém kódu manuálové stránky jsou tiše ignorovány. Pomocí příkazů lze vložit nanajvýš jeden zcela prázdný řádek, více prázdných řádek se při zobrazení sloučí do jedné.
* Pro většinu uživatelů jsou nejužitečnější manuálové sekce 1 (patří běžné uživatelské příkazy), 8 (příkazy pro správu systému) a 5 (dokumentace konfiguračních souborů, souborových systémů a dalších prvků operačního systému).
* Na místě souboru s m. stránkou může být symbolický odkaz na jiný takový soubor; toho lze využít k vytváření „aliasů“.

### Obvyklé názvy sekcí m. stránky

Toto jsou sekce obvyklé na jedné manuálové stránce; neplést si s manuálovými sekcemi.

* 1. JMÉNO (NAME)
* 2. POUŽITÍ (SYNOPSIS)
* 3. POPIS (DESCRIPTION) — Obvykle se dělí na podsekce a obsahuje podrobný popis.
* 4. VOLBY (OPTIONS)
* 5. PŘÍKLADY (EXAMPLES) (volitelná)
* 6. POZNÁMKY (NOTES) (volitelná)
* 7. LICENCE (LICENSE) (má smysl hlavně u svobodného software)
* 8. VIZ TAKÉ (SEE ALSO) (volitelná)

## Další zdroje informací

* [Wikipedie: Manuálová stránka](https://cs.wikipedia.org/wiki/Manu%C3%A1lov%C3%A1_str%C3%A1nka)
* [YouTube: Dokumentace příkazů](https://www.youtube.com/watch?v=j8Yqhesn9dY)
* [YouTube: Programování v shellu 4](https://www.youtube.com/watch?v=v0z14fE6icw)
* [ABC Linuxu: Manuálové stránky](https://www.abclinuxu.cz/clanky/navody/manualove-stranky)
* [YouTube: Mastering Linux Man Pages](https://www.youtube.com/watch?v=RzAkjX_9B7E) (anglicky)
* [YouTube: Write your own man page in Linux](https://www.youtube.com/watch?v=KVhFUwdsE2w) (anglicky)
* [man groff\_man.7](http://manpages.ubuntu.com/manpages/focal/en/man7/groff_man.7.html), [man groff.7](http://manpages.ubuntu.com/manpages/focal/en/man7/groff.7.html) (anglicky, nutno doinstalovat balíček „groff“)
* [TL;DR: man](https://github.com/tldr-pages/tldr/blob/master/pages/common/man.md) (anglicky)
* [Oficiální stránka jaderného projektu manuálových stránek](https://www.kernel.org/doc/man-pages/) (anglicky)
* [Oficiální stránky man-db](https://nongnu.org/man-db/) (anglicky)
* [Balíček man-db](https://packages.ubuntu.com/focal/man-db) (anglicky)

!ÚzkýRežim: vyp
<!--
Odloženo:
.ad l|r|c|b|n => zarování?
.brp => konec řádky se zarováním
.ce => příští řádek na střed

.color
.fcolor c => nastaví fill color
.gcolor c

.ne => prázdné řádky?
.ne N
-->
