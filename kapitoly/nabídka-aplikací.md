<!--

Linux Kniha kouzel, kapitola Nabídka aplikací
Copyright (c) 2019-2021 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

[ ] Vytváření podadresářů v nabídce aplikací.

⊨
-->

# Nabídka aplikací

!Štítky: {tematický okruh}{aplikace}{syntaxe}{GUI}
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod

Tato kapitola pokrývá tvorbu spouštěčů aplikací (\*.desktop)
a jejich použití v nabídce aplikací a automatické spouštění
aplikací po přihlášení do grafického sezení
(pro automatické spouštění před přihlášením
je třeba použít démon „cron“ nebo jiné řešení).

Spouštěč je textový soubor s příponou „.desktop“.
Konkrétní možnosti a chování spouštěčů zavisí na použitém
okenním prostředí; obecně však platí následující:

Spouštěč umístěný v těchto adresářích se objeví v nabídce aplikací
a je možno ho nastavit, aby se spouštěl při dvojkliku na typy souborů,
které uvádí v klíči „**MimeType**“:

!KompaktníSeznam:
* „**/usr/share/applications**“
* „**/usr/local/share/applications**“
* „**~/.local/share/applications**“

Spouštěč umístěný v těcho adresářích se automaticky spustí
po přihlášení uživatele, pokud ho uživatel nepotlačí v nastavení systému:

!KompaktníSeznam:
* „**/etc/xdg/autostart**“
* „**~/.config/autostart**“

Spouštěč, k němuž má uživatel právo „x“, se zobrazí ve správcích souborů
a (případně) na pracovní ploše se svou ikonou a svým názvem
místo názvu souboru. Výchozí příkaz takového spouštěče můžete aktivovat
dvojklikem nebo přetažením adresářových položek na něj.

## Definice

* **Název** (name) je u spouštěče hlavní text, který se v nabídkách zobrazí u ikony spouštěče. Měl by být krátký a téměř nikdy neodpovídá názvu souboru.
* **Popisek** (comment) je vedlejší text, který prostředí může zobrazit spolu s názvem. Může být i delší, ale není povinný.
* **Kategorie** (category) jsou pojmenované skupiny sloužící především k roztřídění spouštěčů do podnabídek. Spouštěč může patřit i do více podnabídek současně.
* **Výchozí příkaz** je příkaz, který se spustí dvojkliknutím (popř. kliknutím) na spouštěč nebo když na něj uživatele přetáhne nějaké adresářové položky.
* **Akce** je dodatečný pojmenovaný příkaz příslušný ke spouštěči, který lze v některých prostředích spustit výběrem z kontextové nabídky.

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

*# nastavit **aktuální adresář** pro vých. příkaz*<br>
**Path=**{*/absolutní/cesta*}

*# spustit příkaz v emulátoru terminálu*<br>
**Terminal=true**

*# řádek s komentářem (kdekoliv v souboru)*<br>
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

*# otevřít spouštěč v GUI editoru*<br>
**exo-desktop-item-edit** {*cesta/ke/spouštěči.desktop*}

*# vytvořit nový spouštěč (GUI)*<br>
*// Volitelné parametry jsem nezkoušel/a.*<br>
**exo-desktop-item-edit \-\-create-new \-\-type Application** [**\-\-name** {*"Název"*}] <nic>[**\-\-command** {*"Příkaz"*}] <nic>[**\-\-icon** {*ikona*}] {*cesta/ke/spouštěči.desktop*}

## Parametry příkazů

### Příkazová řádka v klíči Exec

Příkazová řádka v klíčích Exec se zadává podobně jako v Bashi,
ale s několika dvěma zásadními odchylkami:

* Znaky !, $, &amp;, ;, &lt;, =, &gt;, ?, \[, \], ^, \`, {, \|, }, \~ a další jsou obyčejné; nemůžete je použít způsobem, na jaký jste zvyklý/á z Bashe, a není třeba je odzvláštňovat.
<!-- [ ] Blíž prozkoumat „*“ -->
* Příkaz musí začínat názvem spustitelného souboru (bez cesty či s cestou); přiřazení do proměnných, funkce a vestavěné příkazy Bashe (včetně jakýchkoliv zvláštních konstrukcí) jsou vyloučeny.
* Znak „\\“ má zvláštní význam všude kromě vnitřku apostrofů; znak „%“ i tam. Oba tyto znaky se zde odzvláštňují **zdvojením**.
* Mimo vnitřek apostrofů lze vložit (nezvláštní) konec řádku sekvencí „\\n“.

Pokud nějakou konstrukci z Bashe potřebujete, musíte zavolat Bash a příkaz mu předat parametrem „-c“;
přitom si dejte pozor na nutnost odzvláštnění znaku „%“ a znaku „\\“ mimo apostrofy (GUI editor vám s tímto bohužel nepomůže).

Ve výchozím příkazu (ne v příkazu akce) můžete na místě jednoho parametru
(obvykle posledního) uvést jednu z následujících značek, která se uplatní
v případě, že uživatel na spouštěč přetáhne jeden nebo více souborů či adresářů
(jinak se daný parametr tiše vypustí):

* **%f** se rozvine na absolutní cestu jednoho souboru/adresáře (v případě přetažení více položek se spustí pro každou položku samostatný příkaz)
* **%F** se rozvine na seznam souborů/adresářů (každý v samostatném parametru)
* **%u** a **%U** jsou jako %f a %F, ale místo cesty se předá URI (může být i vzdálené)

### Ikona v klíči Icon

Ikona je obvykle zadána názvem (v takovém případě bude vyhledávána
ve standardních adresářích). Může však být zadána také jako absolutní cesta
k souboru s ikonou (ve formátu PNG nebo SVG), v takovém případě se použije
vždy daný soubor (nezkoušel/a jsem). Pokud přesný název ikony neznáte,
použijte k jejímu nastavení GUI editor.

### Kategorie odpovídající podnabídkám hlavního menu

(Podnabídka → Category)

* „*Grafika*“ → Graphics
* „*Hry*“ → Game
* „*Internet*“ → Network
* „*Kancelář*“ → Office
* „*Multimédia*“ → AudioVideo
* „*Nastavení*“ → Settings — Aplikace v této kategorii se v Xfce objevují také v okně „Nastavení systému“.
* „*Příslušenství*“ → Utility
* „*Systém*“ → System
* „*Vývoj*“ → Development
* „*Vzdělávání*“ → Education

<neodsadit>Příklad (umístit spouštěč do podnabídek „Multimédia“ a „Vzdělávání“):

*# *<br>
**Category=AudioVideo;Education;**

## Instalace na Ubuntu

Většina použitých nástrojů je přítomna i v minimální instalaci Ubuntu. Pouze GUI editor exo-desktop-item-edit může být nutno doinstalovat:

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

* Častá začátečnická chyba je očekávání, že znaky „~“ a „$“ v klíči Exec že budou fungovat stejně jako v Bashi.
* Název spouštěče může obsahovat prakticky jakékoliv tisknutelné znaky; zpětné lomítko však musí být odzvláštněno zdvojením a doporučuji název začínat písmenem, číslicí nebo ne-ASCII znakem.
* Umístíte-li do „~/.local/share/applications“ spouštěč se stejným názvem souboru, jaký existuje na systémové úrovni, váš spouštěč ten systémový „překryje“. Toho můžete využít k přízpusobení si spouštěčů v rámci svého uživatelského účtu; můžete změnit název, ikonu, příkaz apod.

## Další zdroje informací

* [YouTube: Linux pro začátečníky: Jak vytvořit spouštěč](https://www.youtube.com/watch?v=QzXCJFpDBRQ)
* [man exo-destop-item-edit](http://manpages.ubuntu.com/manpages/focal/en/man1/exo-desktop-item-edit.1.html) (anglicky)
* [YouTube: Managing AppImages on Linux](https://www.youtube.com/watch?v=9Mph07loSMo) (anglicky)
* [Oficiální specifikace formátu spouštěčů](https://specifications.freedesktop.org/desktop-entry-spec/latest/) (anglicky)
* [Balíček exo-utils](https://packages.ubuntu.com/focal/exo-utils) (anglicky)
* [Seznam hlavních kategorií](https://specifications.freedesktop.org/menu-spec/latest/apa.html) (anglicky)
* [Seznam vedlejších kategorií](https://specifications.freedesktop.org/menu-spec/latest/apas02.html) (anglicky)

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
