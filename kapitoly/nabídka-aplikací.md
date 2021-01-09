<!--

Linux Kniha kouzel, kapitola Nabídka aplikací
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

[ ] Vytváření podadresářů v menu aplikací.

⊨
-->

# Nabídka aplikací

!Štítky: {tematický okruh}{aplikace}{syntaxe}{GUI}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola pokrývá tvorbu spouštěčů aplikací (\*.desktop)
a jejich použití v nabídce aplikací a automatické spouštění po přihlášení.

Spouštěč je textový soubor s příponou „.desktop“.
Konkrétní možnosti a chování spouštěčů zavisí na použitém
okenním prostředí; obecně však platí následující:

Spouštěč, který máte právo spouštět (právo „x“), můžete použít
ve správcích souborů nebo na pracovní ploše. Dvojklikem
se spustí jeho *výchozí příkaz* a přetažením jednoho nebo více
souborů či adresářů na spouštěč je s ním můžete „otevřít“.

Spouštěče umístěné v adresářích „**/usr/share/applications**“,
„**/usr/local/share/applications**“ a „**~/.local/share/applications**“
se navíc objeví v nabídce aplikací, a pokud mají nastaven klíč „**MimeType**“,
je možno je nastavit jako výchozí příkazy pro otevírání v něm
uvedených typů souborů dvojklikem.

Spouštěče umístěné v adresářích „**/etc/xdg/autostart**“ a „**~/.config/autostart**“
se automaticky spustí po přihlášení uživatele (uživatel může jejich
spouštění vypnout v nastavení systému).

## Definice

* **Název** (name) je u spouštěče hlavní text, který se vždy zobrazí u ikony spouštěče. Měl by být krátký a téměř nikdy neodpovídá názvu souboru.
* **Popisek** (comment) je vedlejší text, který může prostředí zobrazit u ikony spouštěče. Může být i delší, ale není povinný.
* **Kategorie** (category) jsou identifikátory („štítky“) sloužící mimo jiné k roztřídění spouštěčů do podnabídek. Spouštěč může patřit i do více podnabídek současně.
* **Výchozí příkaz** je příkaz, který se spustí dvojkliknutím (popř. kliknutím) na spouštěč a který obsluhuje soubory a adresáře na spouštěč přetažené.
* **Akce** je dodatečný pojmenovaný příkaz příslušný ke spouštěči, který lze (na rozdíl od výchozího příkazu) spustit jedině výběrem z kontextového menu (jen v některých okenních prostředích).

!ÚzkýRežim: vyp

## Zaklínadla

### Spouštěč (syntaxe)

*# obvyklý tvar spouštěče \*.desktop*<br>
*// Pozor — před psaním klíče „Exec“ nastudujte příslušnou podsekci v sekci „Parametry příkazů“! Pokud neznáte přesný identifikátor požadované ikony, doporučuji pro nastavení klíče „Icon“ použít GUI editor.*<br>
**\[Desktop&blank;Entry\]**<br>
[**Version=1.0**]<br>
**Type=Application**<br>
**Name=**{*Název spouštěče*}<br>
[**Name[cs]=**{*Název jen pro české prostředí*}]<br>
**Exec=**{*výchozí příkaz*}<br>
[**Icon=**{*ikona*}]<br>
[**Actions=**{*IdAkce*}**;**[{*IdDalsiAkce*}**;**]...]<br>
[{*další=volby*}]...<br>
[{*definice akcí*}]...

*# nastavit **aktuální adresář***<br>
**Path=**{*/absolutní/cesta*}

*# otevřít v emulátoru terminálu*<br>
**Terminal=true**

*# řádka s komentářem (kdekoliv v souboru)*<br>
**\#**[{*libovolný text*}]

*# nastavit **popisek***<br>
**Comment=**{*Popisek*}<br>
[**Comment[cs]=**{*Popisek jen pro české prostředí*}]

*# potlačit zobrazení v menu*<br>
**NoDisplay=true**

*# zařadit do **kategorií***<br>
**Categories=**{*Kategorie*}**;**[{*DalšíKategorie*}**;**]...

*# nastavit obsluhované MIME typy*<br>
**MimeType=**{*mime/typ*}**;**[{*další/mime/typ*}**;**]...

<!--
**GenericName=**{*Obecný popis*}
-->

### Definice akce (syntaxe)

*# obecný tvar akce*<br>
*// Pozor — před psaním klíče „Exec“ nastudujte příslušnou podsekci v sekci „Parametry příkazů“!*<br>
**[Desktop&blank;Action&blank;**{*IdAkce*}**]**<br>
**Name=**{*Titulek*}<br>
[**Name[cs]=**{*Titulek česky*}]<br>
**Exec=**{*příkaz akce*}<br>
[**Icon=**{*ikona*}]

### GUI

*# otevřít spouštěč*<br>
**exo-desktop-item-edit** {*cesta/ke/spouštěči.desktop*}

*# vytvořit nový spouštěč (GUI)*<br>
*// Volitelné parametry jsem nezkoušel/a.*<br>
**exo-desktop-item-edit \-\-create-new \-\-type Application** [**\-\-name** {*"Název"*}] <nic>[**\-\-command** {*"Příkaz"*}] <nic>[**\-\-icon** {*ikona*}] {*cesta/ke/spouštěči.desktop*}

## Parametry příkazů
### Příkazová řádka v klíči Exec

Příkazová řádka v klíčích Exec se zadává podobně jako v Bashi,
ale se dvěma zásadními odchylkami:

* Znaky !, $, &amp;, ;, &lt;, =, &gt;, ?, \[, \], ^, \`, {, \|, }, \~ a další jsou obyčejné; nemůžete je použít způsobem, na jaký jste zvyklý/á z Bashe, a není třeba je odzvláštňovat.
<!-- [ ] Blíž prozkoumat „*“ -->
* Příkaz musí začínat názvem spustitelného souboru (bez cesty či s cestou); přiřazení do proměnných, funkce a vestavěné příkazy Bashe (včetně jakýchkoliv zvláštních konstrukcí) jsou vyloučeny.
* Znak „\\“ má zvláštní význam v celém řetězci kromě vnitřku apostrofů; znak „%“ má zvláštní význam úplně v celkém řetězci. Oba tyto znaky se zde odzvláštňují **zdvojením**.
* Do řádky lze vložit (nezvláštní) konec řádky sekvencí „\\n“.

Pokud nějakou konstrukci z Bashe potřebujete, musíte zavolat Bash a příkaz mu předat parametrem „-c“;
přitom si dejte pozor na nutnost odzvláštnění znaku „%“ a znaku „\\“ mimo apostrofy (GUI editor vám s tímto bohužel nepomůže).

Ve výchozím příkazu (ne v příkazu akce) můžete na místě jednoho parametru
(obvykle posledního) uvést jednu z následujících značek, která se uplatní
v případě, že uživatel na spouštěč přetáhne jeden nebo více souborů či adresářů
(jinak se daný parametr tiše vypustí):

* **%f** se rozvine na absolutní cestu jednoho souboru/adresáře (v případě přetažení více položek se spustí pro každý soubor/adresář samostatný příkaz)
* **%F** se rozvine na seznam souborů/adresářů (každý v samostatném parametru)
* **%u** a **%U** jsou jako %f a %F, ale místo cesty se předá URI (může být i vzdálené)

### Ikona v klíči Icon

Ikona je obvykle zadána názvem (v takovém případě bude vyhledávána
ve standardních adresářích). Může však být zadána také jako absolutní cesta
k souboru s ikonou (ve formátu PNG nebo SVG), v takovém případě se použije
vždy daný soubor. Pokud přesný název ikony neznáte, použijte k jejímu
nastavení GUI editor.

### Kategorie odpovídající podnabídkám hlavního menu

* „Grafika“ (Graphics)
* „Hry“ (Game)
* „Internet“ (Network)
* „Kancelář“ (Office)
* „Multimédia“ (AudioVideo)
* „Nastavení“ (Settings) — Aplikace v této kategorii se v Xfce objevují také v „Nastavení systému“.
* „Příslušenství“ (Utility)
* „Systém“ (System)
* „Vývoj“ (Development)
* „Vzdělávání“ (Education)

<neodsadit>Příklad (umístit spouštěč do podnabídek „Multimédia“ a „Vzdělávání“):

*# *<br>
**Category=AudioVideo;Education;**

## Instalace na Ubuntu

Většina použitých nástrojů je přítomna i v minimální instalaci Ubuntu. Pouze editor exo-desktop-item-edit může být nutno doinstalovat:

*# *<br>
**sudo apt-get install exo-utils**

## Ukázka

*# \~/.local/share/applications/vycet.xterm.desktop*<br>
**[Desktop Entry]**<br>
**Version=1.0**<br>
**Type=Application**<br>
**Name=List of paths in xterm**<br>
**Name[cs]=Výčet cest v xtermu**<br>
**Exec=xterm -e bash -c 'printf %%s\\\\\\\\n "$@" &amp;&amp; read' \-\- %F**<br>
**# řekněme, že lepší ikonu jste nenašel/a...**<br>
**Icon=ibus**<br>
**Categories=Utility;System;**<br>
**Comment=Přetáhněte sem soubory a adresáře, xterm vám vypíše jejich cesty!**

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Častá začátečnická chyba je používání znaků „~“ a „$“ v klíči Exec v domnění, že budou fungovat stejně jako v Bashi.
* Název spouštěče může obsahovat prakticky jakékoliv tisknutelné znaky; zpětné lomítko však musí být odzvláštněno zdvojením a doporučuji název začínat písmenem, číslicí nebo ne-ASCII znakem.
* Ve správcích souborů a na pracovní ploše jsou rozpoznávány jen spouštěče, které máte právo spouštět (právo „x“). Pro ostatní použití (v nabídkách apod.) není toto právo vyžadováno a obvykle také není nastaveno, takže se takový soubor ve správcích souborů objevuje jako obyčejný soubor.
* Umístíte-li do „~/.local/share/applications“ spouštěč se stejným názvem souboru, jaký existuje na systémové úrovni, váš spouštěč ten systémový „překryje“; toho můžete využít k přízpusobení si spouštěčů v rámci svého uživatelského účtu; můžete změnit název, ikonu, příkaz apod.

## Další zdroje informací

* [YouTube: Linux pro začátečníky: Jak vytvořit spouštěč](https://www.youtube.com/watch?v=QzXCJFpDBRQ)
* [man exo-destop-item-edit](http://manpages.ubuntu.com/manpages/focal/en/man1/exo-desktop-item-edit.1.html) (anglicky)
* [YouTube: Managing AppImages on Linux](https://www.youtube.com/watch?v=9Mph07loSMo) (anglicky)
* [Oficiální specifikace formátu spouštěčů](https://specifications.freedesktop.org/desktop-entry-spec/latest/) (anglicky)
* [Balíček exo-utils](https://packages.ubuntu.com/focal/exo-utils) (anglicky)
* [Seznam hlavních kategorií](https://specifications.freedesktop.org/menu-spec/latest/apa.html) (anglicky)
* [Seznam vedlejších kategorií](https://specifications.freedesktop.org/menu-spec/latest/apas02.html) (anglicky)

!ÚzkýRežim: vyp
