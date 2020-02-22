<!--

Linux Kniha kouzel, kapitola GNU sed
Copyright (c) 2019 Singularis <singularis@volny.cz>

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

!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

GNU sed je nástroj příkazové řádky pro zpracování textového souboru (txt či txtz) po záznamech.
Nejčastěji je užíván díky své schopnosti testovat záznamy vůči regulárním výrazům a nahrazovat
jejich shody. Ve skutečnosti nenabízí o mnoho víc. Jeho hlavními výhodami jsou, že je rychlý,
přítomný skoro v každé linuxové instalaci a plně podporuje UTF-8.

Sed pracuje tak, že v cyklu načítá záznamy ze vstupních souborů a na každý záznam spustí
skript (zadaný typicky přímo na příkazové řádce, jen vzácně se ukládá do samostatného souboru).
Není-li zadán

## Definice

* **Prostor** je proměnná v Sedu − je to oblast, do které se ukládají textové záznamy nebo jiné hodnoty. V Sedu existuje pouze pevně daný počet prostorů.
* **Pracovní prostor** je prostor, do kterého se normálně na začátku každého cyklu přiřadí další načtený záznam. (Může však obsahovat i více záznamů.) Existují dva způsoby, jak na pracovní prostor nahlížet: většina příkazů ho vidí jako uspořádaný seznam záznamů, kde každý záznam je uveden včetně svého ukončovače; tzn. např. „ab\\n“ a „cd\\n“. Příkaz „s“ ovšem vidí pracovní prostor jinak − jako řetězec, kde jsou tyto záznamy spojeny dohromady, ovšem ukončovač posledního záznamu je odsunut mimo.
* **Paměť** je pomocný prostor, do kterého lze záznamy z pracovního prostoru přenést či je připojit.
* **Příznak** je booleovská proměnná, která se nastavuje na hodnotu 1, když příkaz „s“ úspěšně provede náhradu. Na hodnotu 0 se nastavuje na začátku cyklu a po provedení příkazu „t“ či „T“.
* **Počítadlo záznamů** je číselná proměnná − na počátku má hodnotu 0 a inkrementuje se pokaždé, když je ze vstupu načten záznam.

### Cyklus sedu

Sed prochází skript v těchto krocích:

1) Smaž pracovní prostor.

2) Načti další záznam ze vstupu a připoj ho na konec pracovního prostoru.

3) Projdi skript, vyhodnocuj podmínky a vykonávavej odpovídající příkazy.

4) Nebyl-li sed volán s parametrem „-n“, vypiš pracovní prostor včetně odděleného ukončovače záznamu.

5) Vypiš připojovací frontu a vyprázdni ji.

6) Pokud nebyl v tomto cyklus skriptu proveden příkaz „q“, jdi zpět na krok 1.

<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

<!--
Registry:
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

!ÚzkýRežim: vyp

## Zaklínadla (podmínky)

*# **každý** záznam*<br>
{*prázdný řetězec*}

*# první/poslední záznam*<br>
**1**<br>
**$**

*# dva první/poslední záznamy*<br>
**1,2**<br>
?

*# liché/sudé záznamy*<br>
**1~2**<br>
**2~2**

*# záznam odpovídající regulárnímu výrazu (alterantivy)*<br>
**/**{*regulární výraz*}**/**<br>
**\\!**{*regulární výraz*}**!**

*# všechny záznamy až po první záznam odpovídající regulárnímu výrazu včetně*<br>
**0,/**{*regulární výraz*}**/**

*# záznam odpovídající regulárnímu výrazu a N následujících*<br>
**/**{*regulární výraz*}**/,+**{*N*}

*# rozsah od záznamu odpovídajícího regulárnímu výrazu po následující záznam, jehož číslo je celočíselným násobkem N*<br>
**/**{*regulární výraz*}**/,~**{*N*}

*# každý třetí záznam, počínaje sedmnáctým*<br>
**17~3**

*# **rozsah** mezi dvěma řádky odpovídajícími regulárním výrazům*<br>
*// Poznámka: tento rozsah zahrnuje v sedu vždy alespoň dva záznamy. Pokud už první záznam rozsahu odpovídá regulárnímu výrazu pro poslední záznam, sed to ignoruje!*<br>
**/**{*reg. výraz pro první záznam*}**/,/**{*reg. výraz pro poslední záznam*}**/**

*# rozsah mezi dvěma řádky danými čísly záznamů*<br>
{*první-zahrnutý*}**,**{*poslední-zahrnutý*}

*# konče/počínaje určitým záznamem*<br>
**1,**{*poslední-zahrnutý*}<br>
{*první-zahrnutý*},**$**

## Zaklínadla (příkazy)
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Operace s pracovním prostorem

*# provést náhradu v pracovním prostoru*<br>
*// Parametr může být: číslo 1 až 256(?) (nahradí pouze tolikátou shodu); „g“ (nahradí všechny shody); „i“ (nebude rozlišovat velká a malá písmena)(?). V případě, že najde požadovanou shodu, nastaví příznakový registr na hodnotu 1; v opačném případě příznakový registr nemění.*<br>
**s/**{*regulární výraz*}**/**{*řetězec náhrady*}**/**[{*parametr*}]

*# nahradit znaky*<br>
*// Řetězce musejí mít přesně stejnou délku. Příkaz „y“ projde pracovní prostor znak po znaku a každý znak, který se nachází v řetězci 1 nahradí znakem na stejné pozici v řetězci 2. Vždy provede pouze jednu náhradu, takže tento příkaz je možno využít i k prohození dvou znaků.*<br>
**y/**{*řetězec 1*}**/**{*řetězec 2*}**/**

*# vypsat a vyprázdnit připojovací frontu a načíst další záznam do pracovního prostoru (přepsat stávající/přidat za stávající)*<br>
**n**<br>
**N**

*# nahradit konce záznamu (\\n/\\0)*<br>
**s/\\n/**{*řetězec náhrady*}**/g**<br>
**s/[\\x00]/**{*řetězec náhrady*}**/g**

*# přiřadit do pracovního prostoru jeden prázdný záznam*<br>
**z**

*# odstranit první záznam*<br>
?

## Skoky

*# vyprázdnit pracovní prostor a skončit na konec cyklu*<br>
**d**

*# návěští pro skoky*<br>
*// Návěští je příkaz, ale nepřijímá „podmínku“.*<br>
**:**{*návěští*}

*# nepodmíněný skok na návěští/na konec cyklu*<br>
**b**{*návěští*}
**b**

*# nepodmíněný skok na konec cyklu; nezačínat další cyklus*<br>
**q**

*# okamžitě ukončit skript*<br>
**Q**

*# podmíněný skok (skončit, pokud je příznakový registr 1/0)*<br>
**t**<br>
**T**

*# smazat první záznam v pracovním prostoru, skočit na začátek cyklu, a pokud zůstal v pracovním prostoru nějaký záznam, nenačítat zatím další*<br>
**D**

## Výpis

*# vypsat pracovní prostor na standardní výstup (všechny záznamy/jen první záznam)*<br>
**p**<br>
**P**

*# vypsat pracovní prostor do souboru (všechny záznamy/jen první záznam)*<br>
**w**{*jméno/souboru*}<br>
**W**{*jméno/souboru*}

*# vypsat číslo záznamu (jako záznam)*<br>
**=**

*# vypsat konstantní záznamy*<br>
**i\\**<br>
[{*nějaký záznam*}**\\**]<br>
{*poslední záznam*}


## Operace s pamětí

*# přiřadit obsah pracovního prostoru do paměti*<br>
{*podmínka*}**h**

*# přiřadit do pracovního prostoru*<br>
{*podmínka*}**g**

*# připojit obsah pracovního prostoru*<br>
{*podmínka*}**H**

*# připojit do pracovního prostoru*<br>
**G**

*# vyměnit obsah pracovního prostoru a paměti*<br>
**x**

## Komentář

*# komentář*<br>
**#** {*komentář do konce řádku*}

## Operace s připojovací frontou

*# načíst všechny záznamy ze souboru*<br>
**r**{*jméno/souboru*}

*# načíst další záznam ze souboru*<br>
*// Po vyčerpání záznamů v souboru jsou další volání pro tentýž soubor ignorována.*<br>
**R**{*jméno/souboru*}

*# vložit konstantní záznamy*<br>
**a\\**<br>
[{*nějaký záznam*}**\\**]<br>
{*poslední záznam*}

## Parametry příkazů
<!--
- Pokud zaklínadla nepředstavují kompletní příkazy, v této sekci musíte popsat, jak z nich kompletní příkazy sestavit.
- Jinak by zde měl být přehled nejužitečnějších parametrů používaných nástrojů.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Instalace na Ubuntu
<!--
- Jako zaklínadlo bez titulku uveďte příkazy (popř. i akce) nutné k instalaci a zprovoznění všech nástrojů požadovaných kterýmkoliv zaklínadlem uvedeným v kapitole. Po provedení těchto činností musí být nástroje plně zkonfigurované a připravené k práci.
- Ve výčtu balíčků k instalaci vycházejte z minimální instalace Ubuntu.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Ukázka
<!--
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti − ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

!ÚzkýRežim: zap

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
-->
![ve výstavbě](../obrazky/ve-vystavbe.png)

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
