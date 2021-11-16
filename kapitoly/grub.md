<!--

Linux Kniha kouzel, kapitola GRUB a jádro
Copyright (c) 2019-2021 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

[ ] efibootmgr

⊨
-->

# GRUB a jádro

!Štítky: {systém}{program}
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod
<!--
- Vymezte, co je předmětem této kapitoly.
- Obecně popište základní principy, na kterých fungují používané nástroje.
- Uveďte, co kapitola nepokrývá, ačkoliv by to čtenář mohl očekávat.
-->
![ve výstavbě](../obrázky/ve-výstavbě.png)

GNU GRUB je vyvíjen v rámci projektu GNU.

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

*# minimální téma*<br>
*// Použijete-li obrázek na pozadí, soubor umístěte do téhož adresáře jako „theme.txt“. Metoda umístění může být podle dokumentace „stretch“ (výchozí), „crop“, „padding“, „fitwidth“ nebo „fitheight“, ale nezkoušel/a jsem je.*<br>
**title-text: "**[{*text titulku*}]**"**<br>
**title-color: "#**{*barvatextuRRGGBB*}**"**<br>
**desktop-color: "#**{*barvapozadíRRGGBB*}**"**<br>
[**desktop-image: "**{*obrázek-na-pozadí.png*}**"**<br>
**desktop-image-scale-method: "**{*metoda-umístění*}**"**]<br>
**\+&blank;boot\_menu&blank;\{**<br>
<odsadit1>**left = 5% width = 90% top = 10% height = 70%**<br>
<odsadit1>**item\_height = 20**<br>
<odsadit1>**item\_color = "#**{*barvaneaktivníRRGGBB*}**"**<br>
<odsadit1>**selected\_item\_color = "#**{*barvaaktivníRRGGBB*}**"**<br>
**\}**<br>
**+&blank;label&blank;\{**<br>
<odsadit1>**left = 5% width = 90% top = 90% height = 5%**<br>
<odsadit1>**id = "\_\_timeout\_\_" align = "center" color = "#**{*barvatextuRRGGBB*}**"**<br>
<odsadit1>**text = "%d s"**<br>
**\}**

*# sestavit zaváděcí ramfs (pro nejnovější jádro/pro všechna jádra/pro konkrétní jádro)*<br>
*// Konkrétní verze jádra se zadává ve formátu „4.15.0-99-generic“.*<br>
**sudo update-initramfs -u**[**v**]<br>
**sudo update-initramfs -u**[**v**] **-k all**<br>
**sudo update-initramfs -u**[**v**] **-k** {*verze-jádra*}

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

<!--
Oficiální dokumentace ohledně motivů:
https://www.gnu.org/software/grub/manual/grub/html_node/Theme-file-format.html
-->

## Zákulisí kapitoly
<!--
- Doplňte, pokud víte. Udržujte aktuální.
-->

V této verzi kapitoly chybí:

!KompaktníSeznam:
* nic

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* nic

!ÚzkýRežim: vyp
