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

[ ] Zjistit, co dělají příkazy „.fi“ a „.nf“ (enable/disable filling).

⊨
-->

# Manuálové stránky

!Štítky: {tematický okruh}{dokumentace}{syntaxe}
!FixaceIkon: 1754
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

!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

### Hlavní prvky

*# obecná struktura manuálové stránky*<br>
*// Obvyklé je „Dole uprostřed“ uvést datum poslední úpravy manuálové stránky, „Dole vlevo“ uvést název a verzi balíčku či projektu a „Nahoře uprostřed“ neuvádět.*<br>
[{*komentáře*}]...<br>
**.TH "**{*Název dokumentu*}**"** {*ČísloSekce*} [**"**{*Dole uprostřed*}**"** [**"**{*Dole vlevo*}**"** [**"**{*Nahoře uprostřed*}**"**]]]<br>
**.SH "**{*Nadpis první sekce*}**"**<br>
{*...*}

*# komentář*<br>
!: Kdekoliv na řádku:
**\\"**{*Text komentáře do konce řádky*}

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
*// Oba typy nadpisů ruší odsazení.*<br>
**.SH "**{*Text nadpisu*}**"**<br>
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

*# **zarovnat** následující odstavce vlevo/do bloku*<br>
**.ad l**<br>
**.ad b**

*# zvýšit úroveň **odsazení***<br>
*// Samotný příkaz „.RS“ ukončí řádku, ale nikoliv odstavec, proto i typ písma zůstává zachovaný.*<br>
**.RS**<br>
[**.PP**]

*# snížit úroveň odsazení*<br>
*// Samotný příkaz „.RE“ ukončí řádku, ale nikoliv odstavec, proto i typ písma zůstává zachovaný.*<br>
**.RE**<br>
[**.PP**]

*# vypnout odsazení*<br>
*// Samotný příkaz „.RE 1“ ukončí řádku, ale nikoliv odstavec, proto i typ písma zůstává zachovaný.*<br>
**.RE 1**<br>
[**.PP**]

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
*// Uvnitř bloku „.EX“ až „.EE“ neprobíhá automatické zalamování řádek a jejich odsazení mezerami či tabulátory bude na výstupu zachováno; použije se neproporcionální písmo (v terminálu je totéž jako to normální). Ostatní příkazy jsou však interpretovány.*<br>
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

*# konec řádky/prázdná řádka*<br>
*// Obojí na prázdnou řádku. Tyto příkazy nelze použít vícekrát ihned po sobě, takže není možné vložit více než jeden prázdný řádek.*<br>
**.br**<br>
**.sp**

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

* Do sekce 1 patří běžné uživatelské příkazy; příkazy pro správu systému patří do sekce 8; dokumentace formátů souborů (zejména konfiguračních) patří do sekce 5.
* Do manuálové stránky nelze vložit blok více prázdných řádek; při zobrazení se takový blok sloučí do jednoho prázdného řádku.

### Obvyklé názvy sekcí

* 1. JMÉNO (NAME)
* 2. POUŽITÍ (SYNOPSIS)
* 3. POPIS (DESCRIPTION) — Obvykle se dělí na podsekce a obsahuje podrobný popis.
* 4. VOLBY (OPTIONS)
* 5. PŘÍKLADY (EXAMPLES) (volitelná)
* 6. POZNÁMKY (NOTES) (volitelná)
* 7. LICENCE (LICENSE) (má smysl hlavně u svobodného software)
* 8. VIZ TAKÉ (SEE ALSO) (volitelná)

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!

http://manpages.ubuntu.com/manpages/focal/en/man7/groff_man.7.html
http://manpages.ubuntu.com/manpages/focal/en/man8/mandb.8.html

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

!ÚzkýRežim: vyp
