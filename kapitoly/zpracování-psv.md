<!--

Linux Kniha kouzel, kapitola Zpracování PSV
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

⊨
-->

# Zpracování PSV

!Štítky: {tematický okruh}{zpracování textu}{formát}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

GNU Awk (gawk) je vyvíjen v rámci projektu GNU.

## Definice
<!--
- Uveďte výčet specifických pojmů pro použití v této kapitole a tyto pojmy definujte co nejprecizněji.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

* **PSV** – komplikovaný textový formát s pojmenovanými sloupci; záznamy jsou ukončeny prázdnými řádkami; sloupce jsou pojmenovány.
* **Odstavec** je posloupnost záznamů v souboru ukončená jedním nebo více prázdnými záznamy.


!ÚzkýRežim: vyp

## Zaklínadla
<!--
- Rozdělte na podsekce a naplňte „zaklínadly“.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)



### Filtrace záznamů podle pořadí

*# vzít/vynechat N **prvních***<br>
**gawk 'BEGIN {RS = ""; ORS = "\\n\\n"; FS = "\\n";} NR &gt;** {*N*} **{exit} {print}'** [{*soubor*}]...<br>
**gawk 'BEGIN {RS = ""; ORS = "\\n\\n"; FS = "\\n";} NR &gt;** {*N*} **{print}'** [{*soubor*}]...

*# vzít/vynechat N **posledních***<br>
?<br>
?

*# vzít/vynechat **konkrétní** záznam*<br>
**gawk 'BEGIN {RS = ""; ORS = "\\n\\n"; FS = "\\n";} NR ==** {*N*} **{print; exit;}'** [{*soubor*}]...<br>
**gawk 'BEGIN {RS = ""; ORS = "\\n\\n"; FS = "\\n";} NR !=** {*N*} **{print}'** [{*soubor*}]...

*# vzít/vynechat **rozsah** záznamů*<br>
**gawk 'BEGIN {RS = ""; ORS = "\\n\\n"; FS = "\\n";} NR &gt;=** {*první-ponechaný*} **{print} NR ==** {*poslední-ponechaný*} **{exit}'** [{*soubor*}]...<br>
**gawk 'BEGIN {RS = ""; ORS = "\\n\\n"; FS = "\\n";} NR &lt;** {*první-vynechaný*} **\|\| NR &gt;** {*poslední-vynechaný*} **{print}'** [{*soubor*}]...

*# vzít pouze **liché/sudé** záznamy*<br>
**gawk 'BEGIN {RS = ""; ORS = "\\n\\n"; FS = "\\n";} NR % 2 {print}'** [{*soubor*}]...<br>
**gawk 'BEGIN {RS = ""; ORS = "\\n\\n"; FS = "\\n";} !(NR % 2) {print}'** [{*soubor*}]...

### Vybrat/sloučit sloupce

*# vzít jen/vynechat určité sloupce*<br>
?<br>
?

*# sloučit záznamy ze dvou souborů podle čísla záznamu*<br>
?

*# sloučit záznamy ze dvou souborů podle společného sloupce*<br>
?

### Filtrace záznamů podle obsahu sloupců

Vzít/vynechat záznamy,...

*# které **obsahují určitý sloupec***<br>
?<br>
?

*# kde určitý sloupec odpovídá **regulárnímu výrazu***<br>
?<br>
?

*# kde určitý sloupec obsahuje **podřetězec***<br>
?<br>
?

*# kde určitý sloupec je **řetězec***<br>
?<br>
?

### Řazení a přeskládání záznamů

*# **obrátit** pořadí*<br>
**tac -rs $'\\n\\n\\n\*'**

*# **náhodně** přeskládat*<br>
?

*# seřadit podle určitého sloupce*<br>
?

*# seřadit podle více kritérií*<br>
?

### Ostatní

*# **počet záznamů***<br>
**tr '\\na' ab** [**&lt;** {*soubor*}] **\| fgrep -o aa \| wc -l**

*# **rozdělit** soubory na díly s uvedeným maximálním počtem záznamů*<br>
?

*# ke každému záznamu přidat sloupec*<br>
?


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

<!--
## Ukázka
<!- -
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
- ->
![ve výstavbě](../obrázky/ve-výstavbě.png)
-->


!ÚzkýRežim: zap

## Tipy a zkušenosti
<!--
- Do odrážek uveďte konkrétní zkušenosti, které jste při práci s nástrojem získali; zejména případy, kdy vás chování programu překvapilo nebo očekáváte, že by mohlo překvapit začátečníky.
- Popište typické chyby nových uživatelů a jak se jim vyhnout.
- Buďte co nejstručnější; neodbíhejte k popisování čehokoliv vedlejšího, co je dost možné, že už čtenář zná.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

## Další zdroje informací
<!--
- Uveďte, které informační zdroje jsou pro začátečníka nejlepší k získání rychlé a obsáhlé nápovědy. Typicky jsou to manuálové stránky, vestavěná nápověda programu nebo webové zdroje. Můžete uvést i přímé odkazy.
- V seznamu uveďte další webové zdroje, knihy apod.
- Pokud je vestavěná dokumentace programů (typicky v adresáři /usr/share/doc) užitečná, zmiňte ji také.
- Poznámka: Protože se tato sekce tiskne v úzkém režimu, zaklínadla smíte uvádět pouze bez titulku a bez poznámek pod čarou!
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
