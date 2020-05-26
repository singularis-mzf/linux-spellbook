<!--

Linux Kniha kouzel, kapitola GNU sed
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

https://www.gnu.org/software/sed/manual/sed.html#Other-Commands
https://www.grymoire.com/Unix/Sed.html
https://www.youtube.com/playlist?list=PLUQzXLQ6jvHL-Kw9I5H6dvFHal-ynWSTA

https://www.sallyx.org/sally/linux/prikazy/sed

⊨
-->

# Sed

!Štítky: {program}{syntaxe}{zpracování textových souborů}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

„Sed“ je nástroj příkazové řádky pro editaci textového souboru (txt či txtz) po záznamech.
Nejčastěji je užíván díky své schopnosti testovat záznamy vůči regulárním výrazům a nahrazovat
jejich shody. Ve skutečnosti nenabízí o mnoho víc, takže tato kapitola bude spíše stručná.
Jeho hlavními výhodami oproti konkurečním nástrojům jsou rychlost zpracování,
přítomnost v prakticky každé instalaci Linuxu, stoprocentní podpora UTF-8 a mimořádně
úsporná syntaxe.

Sed pracuje tak, že v cyklu načítá záznamy ze vstupních souborů a na každý záznam spustí
skript (zadaný typicky přímo na příkazové řádce, jen vzácně se ukládá do samostatného souboru).

## Definice

* **Prostor** (space) je v Sedu oblast, do které se ukládají textové záznamy nebo jiné hodnoty. Existují pouze pevně definované prostory.
* **Pracovní prostor** (pattern space) je prostor, do kterého se normálně na začátku každého cyklu přiřadí další načtený záznam. (Může však obsahovat i více záznamů.) Existují dva způsoby, jak na pracovní prostor nahlížet: většina příkazů ho vidí jako uspořádaný seznam záznamů, kde každý záznam je uveden včetně svého ukončovače; tzn. např. „ab\\n“ a „cd\\n“. Výjimkou je příkaz „s“, který vidí pracovní prostor jako řetězec, kde jsou tyto záznamy spojeny dohromady, ovšem ukončovač posledního záznamu je odsunut mimo. (Proto jsou-li např. v pracovním prostoru dva výše uvedené záznamy, příkaz „s/.\*//“ skončí stejně vypsáním jedné prázdné řádky, protože závěrečný ukončovač zůstává mimo dosah příkazu „s“.)
* **Paměť** (hold space) je pomocný prostor, do kterého lze záznamy z pracovního prostoru přenést či je tam připojit.
* **Příznak** je booleovská proměnná používaná k podmíněným skokům (viz příkazy „s“, „t“ a „T“).
* Vstupní data sed rozdělí na **záznamy**, což jsou ve výchozím stavu řádky (ukončené znakem „\\n“), ale s parametrem „-z“ to budou bloky znaků ukončené nulovým bajtem („\\0“).
* **Počítadlo záznamů** je číselná proměnná – na počátku má hodnotu 0 a inkrementuje se pokaždé, když je ze vstupu načten záznam (tzn. pro první záznam už má hodnotu 1). Nikdy se nenuluje.

<!--
* **Připojovací fronta** je prostor, kam se ukládají záznamy vytvořené příkazem „a“. (Je poměrně málo používaná.)
-->

### Cyklus sedu

Sed provádí zpracování vstupních souborů v těchto krocích:

<neodsadit>1) Smaž *pracovní prostor*.

<neodsadit>2) Pokud je na vstupu další záznam, načti ho a připoj na konec *pracovního prostoru*; jinak skonči.

<neodsadit>3) Procházej skript, vyhodnocuj podmínky a vykonávavej odpovídající příkazy.

<neodsadit>4) Vypiš *pracovní prostor* včetně odděleného ukončovače záznamu. (Tento krok se často z postupu odstraňuje voláním sedu s parametrem „-n“. Rovněž příkaz „d“ ho potlačí.)

<!--
<neodsadit>5) Vypiš *připojovací frontu* a vyprázdni ji.
-->

<neodsadit>5) Pokud nebyl v tomto cyklu skriptu proveden příkaz „q“, jdi zpět na krok 1.

### Obecný tvar příkazu

Příkazy sedu mají obecný tvar:

*# *<br>
{*podmínka*}[**!**]{*příkaz*}

Vykřičník neguje logickou hodnotu podmínky.

Je-li příkazů víc, odděluje je konec řádky („\\n“), není-li odzvláštněn zpětným lomítkem.
Pokud neposlední z příkazů neočekává jako parametr název souboru či obecný text, lze je oddělit
také středníkem.

Místo jednotlivého příkazu může být také blok příkazů, které pak mohou mít svoje vlastní podmínky. V takovém případě sed nejprve otestuje podmínku bloku; není-li splněna, celý blok se přeskočí. Je-li splněna, sed do bloku vstoupí a jeho obsah vykoná, jako by podmíněn nebyl. Bloky lze zanořovat. Příklad, jak může vypadat blok:

*# *<br>
**/^a/!\{**<br>
<odsadit1>**/test/d**<br>
<odsadit1>**/x/s/.\*/&amp;\*/**<br>
**\}**

### Řetězec náhrady

V příkazu „s“ se uvádí „řetězec náhrady“, tedy řetězec, který definuje, za co se mají
nahradit shody uvedeného regulárního výrazu. V tomto řetězci mají zvláštní význam znaky
„\\“, „&amp;“ a znak ohraničující daný regulární výraz (obvykle „/“ či „!“);
všechny lze odzvláštnit zpětným lomítkem.

Zvláštní významy znaků jsou následující: Za znak „&amp;“ se dosadí původní text celé shody;
za kombinace „\\1“ až „\\9“ se dosadí text podshody první až deváté skupiny
v regulárním výrazu (skupiny se číslují podle pozice otevírací závorky).
Za „\\n“ se dosadí znak konce řádku, pro vložení nulového bajtu použije kombinaci „\\x00“.

V řetězci náhrady také mohou být přepínače konverze velikosti písmen: „\\L“ konvertuje následující znaky na malá písmena, „\\U“ na velká písmena a „\\E“ tuto konverzi vypne. „\\l“ a „\\u“ fungují analogicky, ale uplatní se jen na jeden následující znak.

!ÚzkýRežim: vyp

## Zaklínadla
### Podmínky (uvádějí se před příkaz)

Kteroukoliv podmínku lze negovat uvedením vykřičníku za podmínku.

*# **každý** záznam*<br>
{*prázdný řetězec*}

*# záznam odpovídající **regulárnímu výrazu** (alterantivy)*<br>
**/**{*regulární výraz*}**/**<br>
**\\!**{*regulární výraz*}**!**

*# záznam odpovídající regulárnímu výrazu bez ohledu na velikost písmen (alterantivy)*<br>
**/**{*regulární výraz*}**/I**<br>
**\\!**{*regulární výraz*}**!I**

*# **rozsah** mezi dvěma řádky danými čísly záznamů*<br>
{*první-zahrnutý*}**,**{*poslední-zahrnutý*}

*# **rozsah** mezi dvěma řádky odpovídajícími regulárním výrazům*<br>
*// Poznámka: tento rozsah zahrnuje v sedu vždy alespoň dva záznamy. Pokud už první záznam rozsahu odpovídá regulárnímu výrazu pro poslední záznam, sed to ignoruje!*<br>
**/**{*reg. výraz pro první záznam*}**/**[**I**]**,/**{*reg. výraz pro poslední záznam*}**/**[**I**]

*# **konče**/počínaje určitým záznamem*<br>
**1,**{*poslední-zahrnutý*}<br>
{*první-zahrnutý*}**,$**

*# **první**/poslední záznam*<br>
**1**<br>
**$**

*# dva první/poslední záznamy*<br>
**1,2**<br>
?

*# všechny záznamy až po první záznam odpovídající regulárnímu výrazu včetně*<br>
**0,/**{*regulární výraz*}**/**[**I**]

*# záznam odpovídající regulárnímu výrazu a N následujících*<br>
**/**{*regulární výraz*}**/**[**I**]**,+**{*N*}

*# rozsah od záznamu odpovídajícího regulárnímu výrazu po následující záznam, jehož číslo je celočíselným násobkem N*<br>
**/**{*regulární výraz*}**/**[**I**]**,~**{*N*}

*# liché/sudé záznamy*<br>
**1~2**<br>
**2~2**

*# každý třetí záznam, počínaje sedmnáctým*<br>
**17~3**

## Zaklínadla (příkazy)

### Operace s pracovním prostorem

*# provést **náhradu** v pracovním prostoru (alternativy)*<br>
*// Volby mohou být: „g“ (nahradí všechny shody), kladné celé číslo (nahradí pouze tolikátou shodu), „i“ (nebude rozlišovat velká a malá písmena). Volby lze skombinovat, např. „2i“. V případě, že příkaz „s“ najde požadovanou shodu, nastaví příznak na hodnotu 1; v opačném případě příznak nemění(!).*<br>
**s/**{*regulární výraz*}**/**{*řetězec náhrady*}**/**[{*volby*}]<br>
**s!**{*regulární výraz*}**!**{*řetězec náhrady*}**!**[{*volby*}]

<!--
Volba může být také „p“ (došlo-li k náhradě, provést příkaz „p“).
-->

*# načíst **další záznam** do pracovního prostoru (přepsat stávající/přidat za stávající)*<br>
**n**<br>
**N**

*# nahradit znaky*<br>
*// Řetězce musejí mít přesně stejnou délku. Příkaz „y“ projde pracovní prostor znak po znaku a každý znak, který se nachází v řetězci 1 nahradí znakem na stejné pozici v řetězci 2. Vždy provede pouze jednu náhradu, takže tento příkaz je možno využít i k prohození dvou znaků.*<br>
**y/**{*řetězec 1*}**/**{*řetězec 2*}**/**

*# nahradit ukončovače záznamu (\\n nebo \\0) kromě posedního*<br>
**s/\\n/**{*řetězec náhrady*}**/g**<br>
**s/[\\x00]/**{*řetězec náhrady*}**/g**

*# přiřadit do pracovního prostoru jeden prázdný záznam*<br>
**z**

*# odstranit první záznam*<br>
?

### Skoky

*# na **konec** skriptu (nevypisovat pracovní prostor/normálně/nezačínat další cyklus)*<br>
**d**<br>
**b**<br>
**q**

*# **podmíněný** skok (skočit, pokud je příznak 1/pokud je 0)*<br>
*// Příkazy t a T příznak nulují vždy, i když ke skoku nedojde!*<br>
**t**[{*návěští*}]<br>
**T**[{*návěští*}]

*# návěští pro skoky*<br>
*// Návěští je příkaz, ale nepřijímá „podmínku“.*<br>
**:**{*návěští*}

*# skok na **návěští***<br>
**b**{*návěští*}

*# **okamžitě** ukončit zpracování*<br>
**Q**

*# je-li v pracovním prostoru víc záznamů, smazat první z nich a skočit na začátek skriptu; jinak se chová jako příkaz „d“*<br>
**D**

### Výpis na výstup

*# vypsat pracovní prostor na **standardní výstup** (všechny záznamy/jen první záznam)*<br>
**p**<br>
**P**

*# vypsat pracovní prostor **do souboru** (všechny záznamy/jen první záznam)*<br>
*// Poznámka: pokud soubor existuje, před prvním zápisem bude vyprázdněn!*<br>
**w**{*jméno/souboru*}<br>
**W**{*jméno/souboru*}

*# vypsat číslo záznamu (jako záznam)*<br>
**=**

*# vypsat konkrétní záznam*<br>
*// Pozor, jednotlivé řádky se vždy oddělí znakem „\\n“, ale ukončí se aktuálním ukončovačem záznamu („\\n“ nebo „\\0“).*<br>
**i\\**<br>
[{*řádek záznamu*}**\\**]<br>
{*poslední řádek záznamu*}

### Operace s pamětí

*# přiřadit obsah pracovního prostoru do paměti (**hold**)*<br>
**h**

*# přiřadit obsah paměti do pracovního prostoru (**get**)*<br>
**g**

*# **vyměnit** obsah pracovního prostoru a paměti*<br>
**x**

*# připojit obsah pracovního prostoru na konec paměti*<br>
**H**

*# připojit paměť na konec pracovního prostoru*<br>
**G**

### Komentář

*# komentář*<br>
**#** {*komentář do konce řádky*}

<!--
### Operace s připojovací frontou

*# načíst všechny záznamy ze souboru*<br>
**r**{*jméno/souboru*}

*# načíst další záznam ze souboru*<br>
*// Po vyčerpání záznamů v souboru jsou další volání pro tentýž soubor ignorována.*<br>
**R**{*jméno/souboru*}

*# vložit konstantní záznamy*<br>
**a\\**<br>
[{*nějaký záznam*}**\\**]<br>
{*poslední záznam*}
-->

<!--
## Zaklínadla (příklady volání)

*# všechna písmena uvnitř kulatých závorek převést na velká*<br>
**sed -E 's/\\((.\*)\\)/\\U&amp;/g'**
-->

## Parametry příkazů
### sed

*# *
**sed** {*parametry*} [**-e**] **'**{*skript*}**'** [{*vstupní-soubor*}]...<br>
**sed** {*parametry*} **-f** {*soubor-se-skriptem*} [{*vstupní-soubor*}]...<br>
[**sudo**] **sed -i** {*parametry*} [**-e**] **'**{*skript*}**'** {*soubor*}<br>
[**sudo**] **sed -i** {*parametry*} **-f** {*soubor-se-skriptem*} {*soubor*}

!parametry:

* ☐ -E :: Použije rozšířené regulární výrazy místo základních. (Tento parametr doporučuji důsledně používat, kdykoliv ve skriptu hodláte použít regulární výraz!)
* ☐ -n :: Odstranit z cyklu automatické vypisování pracovního prostoru.
* ☐ -z :: Záznamy jsou ukončeny „\\0“ místo „\\n“.
* ☐ -i :: Místo vypsání na výstup přepíše výstupem vstupní soubor.
* ☐ -u :: Ze vstupu načítá jen minimální množství dat.

## Instalace na Ubuntu

GNU sed je základní součástí Ubuntu přítomnou i v minimální instalaci.

## Ukázka

*# skript.sed*<br>
**/no/d**<br>
**\# pokud obsahuje „1“, třetí velké či malé „x“ uzavřít do závorek,**<br>
**\# ne však na řádcích 7 až 12**<br>
**7,12!{/1/s/x/(&amp;)/3i}**<br>
**\# liché řádky velkými písmeny, před sudé pomlčku**<br>
**2~2s/.\*/&blank;-&blank;&amp;/**<br>
**1~2s/.\*/\\U&amp;/**<br>
**p**<br>
**\# chybové hlášení, pokud stejná řádka obsahuje jablko i hrušku**<br>
**/jablko/I{/hruška/I{i\\**<br>
**Chyba: nemíchejte jablka s hruškami!**<br>
**\}}**

*# volání*<br>
**sed -nE -f skript.sed**<br>
!: a pište nějaké řádky textu. Sed ukončíte zkratkou Ctrl+D.


!ÚzkýRežim: zap

## Tipy a zkušenosti

* Programovat v sedu cokoliv složitějšího je namáhavé, nepraktické a náchylné na chyby. Pokud vám nestačí jen několik základních příkazů, je mnohem rozumnější použití složitějších nástrojů jako „GNU awk“ či „Perl“.
* Skripty v sedu dovedou být extrémně nesrozumitelné. Dovedli byste na příklad říci, co udělá „sed -E '\\!testy!I!s!s!x\\!!i'“?
* Malé textové soubory je často výhodné zpracovat najednou zadáním parametru „-z“. Když vstupní soubor neobsahuje nulový bajt, sed v takovém případě načte celý soubor jako jeden záznam.

## Další zdroje informací

* [Wikipedie: Sed](https://cs.wikipedia.org/wiki/Sed)
* HEROLD, Helmut. *Awk &amp; sed: příručka pro dávkové zpracování textu.* Brno: Computer Press, 2004. ISBN 80-251-0309-9.
* [Sally: Dávkový editor Sed](https://www.sallyx.org/sally/linux/prikazy/sed)
* [Oficiální manuál](https://www.gnu.org/software/sed/manual/sed.html) (anglicky)
* [An Introduction and Tutorial by Bruce Barnett](https://www.grymoire.com/Unix/Sed.html) (anglicky)
* [YouTube: Understanding How Sed Works](https://www.youtube.com/playlist?list=PLUQzXLQ6jvHL-Kw9I5H6dvFHal-ynWSTA) (anglicky)
* [Computer Hope: Linux sed Command Help and Examples](https://www.computerhope.com/unix/used.htm) (anglicky)
* [Oficiální stránka GNU sed](https://www.gnu.org/software/sed/) (anglicky)
* [Balíček](https://packages.ubuntu.com/bionic/sed) (anglicky)
* [TL;DR: sed](https://github.com/tldr-pages/tldr/blob/master/pages/common/sed.md) (anglicky)


!ÚzkýRežim: vyp
<!--
Prostory:
- pracovní prostor (pattern space)
- paměť (hold space)
- připojovací fronta („append“)
- příznak
- počítadlo záznamů (inkrementuje se pokaždé, když je načten záznam, i příkazy „n“ a „N“)

Obecný tvar:

{*podmínka*}[**!**]{*příkaz*}

Poznámka:
- Regulární výrazy se testují vůči celému pracovnímu prostoru kromě ukončovače posledního záznamu, který je z dosahu regulárních výrazů vyjmut.

Cyklus:

1) Smazat pracovní prostor a načíst do něj další záznam ze vstupu. (Pokud byl předchozí cyklus ukončen příkazem „D“ a pracovní prostor není prázdný, tento krok se vynechá.)

2) Projít skript, vyhodnocovat podmínky a vykonávat odpovíďající příkazy.

3) Nebyl-li sed volán s parametrem „-n“, vypsat pracovní prostor na standardní výstup.

4) Vypsat na standardní výstup připojovací frontu a vyprázdnit ji.

5) Skočit zpět na krok 1. (Byl-li cyklus ukončen příkazem „q“, sed místo toho skončí.)

-->
