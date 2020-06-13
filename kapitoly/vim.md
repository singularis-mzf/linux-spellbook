<!--

Linux Kniha kouzel, kapitola Vim
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

https://cs.wikibooks.org/wiki/Vi
http://vimdoc.sourceforge.net/htmldoc/help.html
https://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim
https://vim.fandom.com/wiki/Vim_Tips_Wiki

[ ] Prozkoumat: https://www.youtube.com/watch?v=1alWK5ByNMc
[ ] Prozkoumat: https://cs.wikibooks.org/wiki/Vi

Optimalizace:

I = i + Home
A = i + End
C = c End

Přechod na Focal Fossa:

⊨
-->

# Vim

!Štítky: {program}{editor}{ovládání}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola se věnuje editoru Vim. Vim je textový editor (původně terminálový,
ale nabízí v samostatném balíčku také GUI), práce s nímž je založena na přepínání
mezi řadou režimů, z nichž nejdůležitější jsou *základní režim*, ve kterém se zadávají příkazy,
kterými uživatel ovládá editor, a *vkládací režim*, v němž uživatel píše text.

Tato verze kapitoly se nevěnuje stylu „práce s objekty“ a vyhýbá se funkcím,
jejichž činnost závisí na konkrétní syntaxi editovaného textu (např. skok na deklaraci proměnné pod kurzorem).
Rovněž nepokrývá doplňování s našeptáváním (autocomplete), skládání (folding), režim srovávání „vimdiff“,
specifika GUI varianty (gvim) a zásuvné moduly (plug-ins).
Nedostatečně pokrývá příkaz „g//“.

## Definice

### Režimy editoru Vim

* **Základní režim** (také „normální mód“, „command mode“) je výchozí po spuštění programu. Každé zaklínadlo v této kapitole, není-li uvedeno jinak, předpokládá zadání v základním režimu. Z každého jiného režimu se můžete vrátit zpět do základního režimu jedním nebo více stisky klávesy {_Esc_}.
* **Režim vkládání** je režim, ve kterém se zapsané znaky vkládají do editovaného textu. Jeho variantou je **režim přepisování**, kdy zapsané znaky přepisují stávající znaky textu.
* V **režimu příkazové řádky** místo textu otevřeného souboru upravujete příkaz, který bude vykonán teprve po potvrzení klávesou {_Enter_}. Do tohoto režimu vstoupíte ze základního režimu klávesou „:“.
* V **režimu výběru** posouváním kurzoru vytváříte **výběr**, tedy úsek textu, na který pak aplikujete nějakou operaci. Pokud to váš terminál podporuje a zapnete ovládání myší, budete moci výběr vytvářet i pomocí myši.

Další režimy můžete najít v dokumentaci, ale pravděpodobně o nich nyní nepotřebujete vědět.

### Další pojmy

* **Kurzor** je značka označující jednoznačnou pozici v upravovaném textu, k níž se budou vztahovat prováděné operace.
* **Aktuální řádek** je řádek upravovaného textu, na kterém se nachází kurzor.
* **Pohled** je výřez z upravovaného textu zobrazený uživateli; vždy zahrnuje aktuální řádek. Normálně okno editoru obsahuje pouze jeden **panel** a ten obsahuje pouze jeden pohled. Příslušnými příkazy však lze panel rozdělit na více pohledů a lze také otevřít další panely a ty také rozdělit. Nicméně uzavřením posledního pohledu z panelu se vždy uzavře i panel a uzavřením posledního panelu se uzavře celý editor.
* Vim má 26 **schránek**, označených písmeny anglické abecedy „a“ až „z“. Do těchto schránek se ukládají vyjmuté texty (které můžete později vložit na jiné místo souboru) a makra (která můžete později spustit). Při zápisu do schránky můžete její označení uvést malým písmenem (pak se stávající obsah přepíše) nebo velkým písmenem (pak se nový obsah připojí za stávající).
* **Registr** je schránka označená písmenem (malým či velkým), nebo zvláštní registr označený číslicí či speciálním znakem.

!ÚzkýRežim: vyp

## Zaklínadla: Posuny kurzoru a pohledu, záložky

### Posun kurzoru jen v rámci řádky

*# **vlevo**/**vpravo** o 1 znak*<br>
{_←_}<br>
{_→_}

*# vlevo/vpravo o N znaků*<br>
{*N*}{_←_}<br>
{*N*}{_→_}

*# na začátek/konec řádky*<br>
{_Home_}<br>
{_End_}

*# na následující/předchozí **výskyt** určitého znaku*<br>
[{*počet-opakování*}]**f**{*znak*}<br>
[{*počet-opakování*}]**F**{*znak*}

*# před následující/předchozí výskyt určitého znaku*<br>
[{*počet-opakování*}]**t**{*znak*}<br>
[{*počet-opakování*}]**T**{*znak*}

*# zopakovat poslední zadaný příkaz „f“, „F“, „t“ či „T“*<br>
[{*počet-opakování*}]**;**

*# na **první nebílý** znak řádky*<br>
**^**

*# do konkrétního **sloupce** (logického od 1/znakového od 0)*<br>
*// V případě logických sloupců se tabulátor počítá jako 1 či více sloupců podle své šířky; v případě znakových sloupců se počítá vždy jako jeden znak.*<br>
{*číslo-sloupce*}**\|**<br>
{_Home_}{*číslo-sloupce*}{_→_}

### Posun kurzoru na jinou řádku

PNZ = první nebílý znak

*# **nahoru**/**dolů** o 1 řádek*<br>
{_↑_}<br>
{_↓_}

*# nahoru/dolů o N řádek*<br>
*// K posunu kurzoru nahoru či dolů po řádkách obrazovky místo po řádkách souboru slouží příkazy „gk“ a „gj“.*<br>
{*N*}{_↑_}<br>
{*N*}{_↓_}

*# řádek **číslo** N, PNZ (alternativy)*<br>
{*N*}**G**<br>
**:**{*N*}{_Enter_}

*# na začátek/**střed**/konec pohledu, PNZ*<br>
**H**<br>
**M**<br>
**L**

*# na **první**/**poslední** řádku souboru, PNZ*<br>
**gg**<br>
**G**

*# na N-tý řádek pohledu, PNZ*<br>
{*N*}**H**

*# na následující/předchozí řádku, PNZ*<br>
{_Enter_}<br>
{_↑_}**^**

<!--
*# na začátek/konec následujícího řádku*<br>
{_↓_}{_Home_}<br>
{_↓_}{_End_}

*# na konec N-tého následujícího řádku*<br>
{*N*}{_↓_}{_End_}
-->

*# na následující **prázdný**/neprázdný řádek*<br>
[{*počet-opakování*}]**/^$**{_Enter_}<br>
[{*počet-opakování*}]**/^.**{_Enter_}

### Vyhledávání

\\c = ignorovat velikost písmen; /e = kurzor nastavit na poslední znak shody (jinak na první).

*# najít následující/předchozí výskyt **podřetězce***<br>
*// V podřetězci je nutno odzvláštnit zpětná lomítka!*<br>
**/**[**\\c**]**\\V**{*podřetězec*}[**/e**]{_Enter_}<br>
**?**[**\\c**]**\\V**{*podřetězec*}[**/e**]{_Enter_}

*# najít následující/předchozí shodu s **regulárním výrazem***<br>
*// Poznámka: vim používá vlastní syntaxi regulárních výrazů, která je nejpodobnější základním regulárním výrazům. Při použití této funkce buďte opatrní a očekávajte problémy se složitějšími výrazy.*<br>
**/**[**\\c**]<nic>[**\\v**]{*regulární výraz*}[**/e**]{_Enter_}<br>
**?**[**\\c**]<nic>[**\\v**]{*regulární výraz*}[**/e**]{_Enter_}

*# **zopakovat** poslední vyhledávání stejným/opačným směrem*<br>
**n**<br>
**N**

<!--
[ ] (!) vyhledávání bez ohledu na velikost písmen!
[ ] pro každý vyhledaný výskyt spustit příkaz...
-->

### Záložky

*# nastavit záložku na pozici kurzoru*<br>
*// Jako označení záložky můžete použít malá písmena anglické abecedy („a“ až „z“.)*<br>
**m**{*písmeno*}

*# přejít kurzorem na pozici záložky*<br>
**\`**{*písmeno*}

*# vypsat nastavené (a systémové) záložky*<br>
**:marks**{_Enter_}

### Ostatní posuny

*# posun na znak, který je zobrazený **nad**/**pod** aktuálním*<br>
[{*počet-opakování*}]**gk**<br>
[{*počet-opakování*}]**gj**<br>

*# skok na odpovídající párovou **závorku***<br>
*// Tento příkaz funguje (za předpokladu správného spárování závorek) přinejmenším pro závorky (), [] a {}.*<br>
**%**

*# skok na poslední **upravenou** pozici*<br>
**g;**

### Posuny po slovech

„*Programátorské slovo*“ je sekvence jakýchkoliv nebílých znaků; „*standardních slovo*“ je sekvence nebílých znaků, které jsou buď alfanumerické, nebo tvoří interpunkci. To znamená, že např. „a1a;;;B2B“ je jedno programátorské slovo, ale tři standardní! (Podobně „Ahoj, světe!“ jsou dvě programátoská slova, ale čtyři standardní.)

*# o jedno/N „programátorských slov“ vpřed*<br>
**W**<br>
{*N*}**W**

*# o jedno/N „programátorských slov“ vzad*<br>
**B**<br>
{*N*}**B**

*# na poslední znak programátorského/standardního slova*<br>
**E**<br>
**e**

*# o jedno „standardní slovo“ vpřed/vzad*<br>
*// Funguje i v režimu vkládání.*<br>
{_Shift_}**+**{_→_}<br>
{_Shift_}**+**{_←_}

*# o N „standardních slov“ vpřed/vzad*<br>
{*N*}**w**<br>
{*N*}**b**

## Zaklínadla: Základní

### Psaní textu (vkládání a přepisování)

*# **psát** text, počínaje znakem pod kurzorem/následujícím znakem/koncem řádky/začátkem řádky*<br>
**i**{*(režim vkládání)*}<br>
**a**{*(režim vkládání)*}<br>
**A**{*(režim vkládání)*}<br>
**0i**{*(režim vkládání)*}<br>

*# vložit **novou** prázdnou řádku před/za aktuální a psát na ní text*<br>
**O**{*(režim vkládání)*}<br>
**o**{*(režim vkládání)*}

*# **přepisovat** text, počínaje znakem pod kurzorem*<br>
*// Stisknete-li v režimu přepisování klávesu Backspace, obnoví se tím původně přepsaný znak.*<br>
**R**{*(režim přepisování)*}

*# přepnout vkládání na přepisování/přepisování na vkládání*<br>
{*(režim vkládání)*}{_Insert_}{*(režim přepisování)*}<br>
{*(režim přepisování)*}{_Insert_}{*(režim vkládání)*}

*# vložit text **opakovaně***<br>
{*počet-opakování*}**i**{*text*}{_Esc_}

### Soubory, adresáře a aktivní pohled

*# **uložit** změny a zavřít pohled (alternativy)*<br>
**ZZ**<br>
**:wq**{_Enter_}

*# **zavřít** pohled (opatrně/zahodit změny)*<br>
**:q**{_Enter_}<br>
**:q!**{_Enter_}

*# **otevřít** soubor (opatrně/zahodit změny)*<br>
**:e** {*cesta*}{_Enter_}<br>
**:e!** {*cesta*}{_Enter_}

*# **uložit** změny (v aktuálním pohledu/ve všech pohledech)*<br>
*// Pokud nemáte otevřený žádný soubor, k prvnímu uložení textu musíte použít příkaz „:w“ s cestou, jinak skončíte s chybou „Žádný název souboru“.*<br>
**:w**{_Enter_}<br>
**:wa**{_Enter_}

*# **znovu** načíst otevřený soubor (zahodit změny)*<br>
*// Tip: účinky tohoto příkazu můžete zrušit okamžitým provedením příkazu „u“.*<br>
**:e!**{_Enter_}

*# vypsat/změnit **aktuální adresář** editoru*<br>
**:pwd**{_Enter_}<br>
**:cd** {*cesta*}{_Enter_}

*# vytvořit adresář*<br>
**:!mkdir** [**-p**] {*cesta*}

*# zapsat **kopii** souboru*<br>
**:w** {*cílová/cesta*}{_Enter_}

*# zapsat rozsah řádek do souboru (obecně/příklad)*<br>
**:**{*první-zapsaná*}**,**{*poslední-zapsaná*}**w** {*cílová/cesta*}{_Enter_}<br>
**:3,17w prehledy/radky.txt**{_Enter_}

*# načíst soubor a **vložit** za aktuální řádek*<br>
**:r** {*cesta/k/souboru*}{_Enter_}

*# otevřít soubor jen pro **čtení***<br>
**:e**[**!**] {*cesta*}{_Enter_}**:set ro**{_Enter_}

*# **ukončit** editor (uložit změny/opatrně/zahodit změny)*<br>
**:wqa**{_Enter_}<br>
**:qa**{_Enter_}<br>
**:qa!**{_Enter_}

### Kopírování, mazání a schránky

Tip: jako výchozí používejte schránku „p“.

*# aktuální **řádka** (smazat/vyjmout/zkopírovat/nahradit textem)*<br>
**dd**<br>
**"**{*schránka*}**dd**<br>
**"**{*schránka*}**yy**<br>
[**"**{*schránka*}]**cc**{*text*}{_Esc_}

*# **znak** pod kurzorem (smazat/vyjmout/zkopírovat/nahradit znakem/nahradit textem)*<br>
**x**<br>
**"**{*schránka*}**x**<br>
**"**{*schránka*}**yl**<br>
**r**{*znak*}<br>
[**"**{*schránka*}]**cl**{*text*}{_Esc_}

*# znaky do konce aktuální řádky (smazat/vyjmout/zkopírovat/nahradit textem)*<br>
**d**{_End_}<br>
**"**{*schránka*}**d**{_End_}<br>
**"**{*schránka*}**y**{_End_}<br>
[**"**{*schránka*}]**c**{_End_}{*text*}{_Esc_}

*# znaky od začátku aktuální řádky před kurzor (smazat/vyjmout/zkopírovat/nahradit textem)*<br>
**d**{_Home_}<br>
**"**{*schránka*}**d**{_Home_}<br>
**"**{*schránka*}**y**{_Home_}<br>
[**"**{*schránka*}]**c**{_Home_}{*text*}{_Esc_}

*# aktuální řádek a všechny následující neprázdné (smazat/vyjmout/zkopírovat/nahradit textem)*<br>
**d/^$**{_Enter_}<br>
**"**{*schránka*}**d/^$**{_Enter_}<br>
**"**{*schránka*}**y/^$**{_Enter_}<br>
[**"**{*schránka*}]**c/^$**{_Enter_}{*text*}<br>

*# N řádků počínaje aktuálním (smazat/vyjmout/zkopírovat/nahradit textem)*<br>
{*N*}**dd**<br>
**"**{*schránka*}{*N*}**dd**<br>
**"**{*schránka*}{*N*}**yy**<br>
[**"**{*schránka*}]{*N*}**cc**{*text*}{_Esc_}

### Vložit, spojit, duplikovat

*# **vložit** obsah schránky (za aktuální pozici/před ni)*<br>
**"**{*schránka*}]<nic>[{*počet-opakování*}]**p**<br>
**"**{*schránka*}]<nic>[{*počet-opakování*}]**P**

*# vložit poslední **smazaný** či nahrazený text (za akt. pozici/před ni)*<br>
[{*počet-opakování*}]**p**<br>
[{*počet-opakování*}]**P**

*# **spojit** řádky (viz poznámku)*<br>
*// Připojí následující řádku na konec aktuální. Pokud aktuální řádka končí znakem, který není mezera, před připojením tam mezeru vloží. Prázdný řádek nekončí žádným znakem, proto za něj mezeru nevkládá.*<br>
**J**

*# **duplikovat** aktuální řádek*<br>
**yy**{*počet-opakování*}**p**


### Externí příkazy a spolupráce s bashem

*# **ukončit** editor bez uložení změn (opatrně/zahodit změny/uložit změny)*<br>
**:qa**{_Enter_}<br>
**:qa!**{_Enter_}<br>
**:qwa**{_Enter_}

*# odsunout editor **na pozadí***<br>
*// Zpět na popředí obnovíte editor příkazem „fg“.*<br>
{_Ctrl_}**+**{_Z_}

*# **spustit** externí příkaz*<br>
**:!**{*příkaz*}{_Enter_}

*# otevřít interpret příkazové řádky (obvykle **bash**)*<br>
**:shell**{_Enter_}

*# vykonat externí příkaz a vložit jeho standardní výstup za aktuální řádek (obecně/příklad)*<br>
**:r !**{*příkaz*} [{*parametry*}]{_Enter_}<br>
**:r !ls -lh**{_Enter_}

*# **zamrznout** na N sekund*<br>
*// Zamrznutí můžete předčasně ukončit kombinací kláves Ctrl+C.*<br>
{*N*}**gs**

### Nahradit text (příkaz „:s“)

Poznámka: parametr „kde“ u příkazu „:s“ může být:
**prázdný řetězec** pro nahrazování v aktuální řádce;
**znak %** pro nahrazování v celém souboru;
**číselný rozsah řádků** (např. „5,25“) pro nahrazování na řádcích v uvedeném rozsahu „včetně“.

*# nahradit první výskyt podřetězce/všechny výskyty*<br>
*// V podřetězci je nutno odzvláštnit znaky „\\“ a „/“!*<br>
*// „c“ se před každým nahrazením zeptá a umožní vám nechtěné náhrady přeskočit.*<br>
**:**{*kde*}**s/\\V**{*podřetězec*}**/**{*čím nahradit*}**/**{_Enter_}<br>
**:**{*kde*}**s/\\V**{*podřetězec*}**/**{*čím nahradit*}**/g**[**c**]{_Enter_}

*# nahradit první shodu s reg. výrazem/všechny shody*<br>
*// „c“ se před každým nahrazením zeptá a umožní vám nechtěné náhrady přeskočit.*<br>
**:**{*kde*}**s/\\v**{*regulární výraz*}**/**{*čím nahradit*}**/**{_Enter_}<br>
**:**{*kde*}**s/\\v**{*regulární výraz*}**/**{*čím nahradit*}**/g**[**c**]{_Enter_}

### Odsazení

*# nastavit šířku jedné úrovně odsazení*<br>
*// Výchozí hodnota je 8. Toto nastavení nezmění text, má vliv až na další operace.*<br>
**:set shiftwidth=**{*počet-mezer*}{_Enter_}

*# zvětšit odsazení řádek (alternativy)*<br>
[{*počet-řádků*}]**&gt;&gt;**<br>
{*(režim výběru)*}[{*počet-úrovní*}]**&gt;**

*# zmenšit odsazení řádek (alternativy)*<br>
[{*počet-řádků*}]**&lt;&lt;**<br>
{*(režim výběru)*}[{*počet-úrovní*}]**&lt;**

*# odstranit odsazení z výběru*<br>
*// Funguje jen tehdy, pokud je každá řádka výběru odsazená o méně než 999 úrovní (což je pro typické textové soubory splněno).*<br>
{*(režim výběru)*}**999&lt;**

*# odstranit odsazení z aktuálního řádku*<br>
*// Funguje jen tehdy, pokud je aktuální řádka odsazená o méně než 999 úrovní (což je pro typické textové soubory splněno).*<br>
**V999&lt;**

### Velikost písmen

*# písmeno pod kurzorem (přepnout/malé/velké)*<br>
**\~**<br>
**vu**<br>
**vU**

*# N písmen na aktuálním řádku, počínaje kurzorem (přepnout/malé/velké)*<br>
{*N*}**\~**<br>
**v**{*N-1*}**lu**<br>
**v**{*N-1*}**lU**

*# řádka na malá písmena*<br>
**Vu**

*# řádka na velká písmena*<br>
**VU**

*# každé první písmeno slova velké, ostatní malá*<br>
?

### Pokročilé úpravy

*# odstranit každý řádek vyhovující/nevyhovující regulárnímu výrazu*<br>
**:g/**[**\\v**]{*regulární výraz*}**/d** [**\_**]{_Enter_}<br>
**:v/**[**\\v**]{*regulární výraz*}**/d** [**\_**]{_Enter_}

## Zaklínadla: Režim výběru

### Režim výběru

*# výběr po znacích (normální)*<br>
**v**{*(režim výběru)*}

*# výběr po celých řádkách (**řádkový**)*<br>
**V**{*(režim výběru)*}

*# **sloupcový** výběr*<br>
{_Ctrl_}**+**{_V_}{*(režim výběru)*}

*# obnovit poslední výběr*<br>
*// Např. po nechtěném stisknutí Esc.*<br>
**gv**{*(režim výběru)*}

*# přepnout na opačný konec výběru*<br>
{*(režim výběru)*}**o**{*(režim výběru)*}

*# ve sloupcovém výběru přepnout do opačného rohu na stejném řádku*<br>
{*(režim výběru)*}**O**{*(režim výběru)*}

### Operace nad jakýmkoliv výběrem

*# **smazat***<br>
{*(režim výběru)*}**d**

*# vyjmout/zkopírovat*<br>
{*(režim výběru)*}**"**{*schránka*}**d**<br>
{*(režim výběru)*}**"**{*schránka*}**y**

*# celý výběr na malá/velká písmena/přepnout velikost písmen*<br>
{*(režim výběru)*}**u**<br>
{*(režim výběru)*}**U**<br>
{*(režim výběru)*}**\~**

*# nahradit (jen normální a řádkový výběr!)*<br>
{*(režim výběru)*}**c**{*(režim vkládání)*}

*# nahradit všechny znaky určitým znakem*<br>
{*(režim výběru)*}**r**{*znak*}

### Operace nad řádkovým výběrem

*# **spojit** řádky*<br>
{*(režim výběru)*}**J**

*# **profiltrovat** externím příkazem*<br>
{*(režim výběru)*}**!**{*příkaz s parametry*}{_Enter_}

*# zvětšit/zmenšit **odsazení***<br>
{*(režim výběru)*}[{*počet*}]**&gt;**<br>
{*(režim výběru)*}[{*počet*}]**&lt;**

*# automaticky přeformátovat řádky na šířku okna*<br>
{*(režim výběru)*}**gq**

*# **nahradit** text*<br>
*// Pro význam částí „co“ a „čím“ viz zaklínadla týkající se nahrazování textu. Tato varianta se od obyčejného příkazu „:s“ liší jen tím, že místo nad aktuálním řádkem pracuje nad řádky výběru.*<br>
{*(režim výběru)*}**:s/**{*co*}**/**{*čím*}**/**[{*parametry*}]{_Enter_}

### Operace nad sloupcovým výběrem

*# před/za každý řádek výběru **vložit** text*<br>
{*(režim výběru)*}**I**{*text*}{_Esc_}<br>
{*(režim výběru)*}**A**{*text*}{_Esc_}

*# **nahradit** každou řádku výběru textem*<br>
{*(režim výběru)*}**c**{*text*}{_Esc_}

*# před/za každý řádek vložit obsah schránky*<br>
*// Pozor! Toto funguje jen tehdy, pokud je obsah schránky ve „znakovém“ režimu; schránka tedy nesmí obsahovat celé řádky ani textový blok!*<br>
{*(režim výběru)*}**"**{*schránka*}**P**<br>
{*(režim výběru)*}**"**{*schránka*}**p**

## Zaklínadla: Ostatní

### Historie změn

*# **zopakovat** poslední provedenou změnu na aktuální pozici*<br>
[{*počet-opakování*}]**.**

*# vrátit poslední změnu (**zpět**)*<br>
**u**<br>

*# znovu provést vrácenou změnu (**znovu**)*<br>
{_Ctrl_}**+**{_R_}

*# vrátit poslední upravovaný řádek do původního stavu*<br>
*// Poznámka: Pozor! Tento příkaz je sám o sobě změnou; k jeho odvolání použijte příkaz „u“, nikoliv Ctrl+R!*<br>
**U**

### Makra

Tip: jako výchozí schránku pro makra používejte schránku „q“.

*# nahrávat prováděné stisky kláves jako makro*<br>
*// Zadáte-li schránku velkým písmenem, nahrané stisky kláves se připojí ke stávajícímu obsahu daného makra.*<br>
**q**{*schránka*}{*stisky kláves*}**q**

*# spustit makro*<br>
[{*kolikrát*}]**@**{*schránka*}

*# znovu spustit poslední spuštěné makro*<br>
[{*kolikrát*}]**@@**

### Správce souborů

*# otevřít **správce souborů** (v pohledu nad/pod/vlevo/vpravo/na novém panelu)*<br>
**:Sex**{_Enter_}<br>
**:Hex**{_Enter_}<br>
**:Vex**{_Enter_}<br>
**:Vex!**{_Enter_}<br>
**:Tex**{_Enter_}

*# **otevřít** soubor/adresář ze správce souborů*<br>
!: Nastavte kurzor na název souboru.<br>
{_Enter_}

*# přejít o adresář výš*<br>
{*(ve správci souborů)*}{_-_}

*# **zavřít** správce souborů (alternativy)*<br>
{*(ve správci souborů)*}**ZZ**<br>
{*(ve správci souborů)*}**:q**

### Zvýraznění syntaxe

*# zapnout/vypnout zvýraznění syntaxe*<br>
**:syntax on**{_Enter_}<br>
**:syntax off**{_Enter_}

*# ručně nastavit syntaxi*<br>
**:setfiletype** {*syntaxe*}{_Enter_}

*# vypsat seznam podporovaných syntaxí*<br>
**:setfiletype**<br>
{_Space_}<br>
{_Ctrl_}**+**{_D_}

*# zvýrazňovat klíčové slovo jako klíčové slovo/identifikátor/funkci/operátor*<br>
**:syntax keyword Keyword** {*slovo*}{_Enter_}<br>
**:syntax keyword Identifier** {*slovo*}{_Enter_}<br>
**:syntax keyword Function** {*slovo*}{_Enter_}<br>
**:syntax keyword Operator** {*slovo*}{_Enter_}
<!--
Další skupiny na: http://vimdoc.sourceforge.net/htmldoc/syntax.html#{group-name}
-->

*# vypsat platná pravidla zvýrazňování syntaxe (není pro začátečníky)*<br>
**:syntax list**{_Enter_}


### Ostatní

*# zobrazit **kódovou** (číselnou) hodnotu znaku pod kurzorem*<br>
**ga** ⊨ &lt;ž&gt; 382, Hex 017e, Octal 576
<!--
&lt;m&gt; 109, šestnáctkově 6d, osmičkově 155
-->

*# **inkrementovat**/dekrementovat celé číslo pod kurzorem*<br>
{_Ctrl_}**+**{_A_}<br>
{_Ctrl_}**+**{_X_}

*# vložit **název** otevřeného souboru před/za kurzor*<br>
**"%P** ⊨ test.txt<br>
**"%p**

## Zaklínadla: Pohledy a panely

### Posun pohledu

*# o stránku nahoru/dolů*<br>
{_PageUp_}<br>
{_PageDown_}

*# aktuální řádku doprostřed pohledu*<br>
**zz**

*# o půl okna nahoru/dolů*<br>
{_Ctrl_}**+**{_U_}<br>
{_Ctrl_}**+**{_D_}

*# o řádek nahoru/dolů*<br>
{_Ctrl_}**+**{_Y_}<br>
{_Ctrl_}**+**{_E_}

*# na začátek/konec souboru*<br>
**gg**<br>
**G**

*# aktuální řádek na horní/dolní okraj pohledu*<br>
**zt**<br>
**zb**

*# o N znaků vlevo/vpravo (jen při vypnutém zalamování)*<br>
{*N*}**zh**<br>
{*N*}**zl**

### Práce s rozděleným panelem

*# **rozdělit** panel a v novém pohledu (nad stávajícím/vlevo od stávajícího) otevřít jiný soubor*<br>
**:split** {*cesta/k/souboru*}{_Enter_}<br>
**:vsplit** {*cesta/k/souboru*}{_Enter_}

*# **přepnout** zaměření o pohled nahoru/dolu/doleva/doprava*<br>
{_Ctrl_}**+**{_W_}{_↑_}<br>
{_Ctrl_}**+**{_W_}{_↓_}<br>
{_Ctrl_}**+**{_W_}{_←_}<br>
{_Ctrl_}**+**{_W_}{_→_}

*# **rozdělit** panel na pohledy nad sebou/vedle sebe*<br>
**:split**{_Enter_}<br>
**:vsplit**{_Enter_}

*# otevřít nový prázdný pohled nad aktivním/vlevo od aktivního*<br>
**:new**{_Enter_}<br>
**:vnew**{_Enter_}

*# nastavit výšku aktivního pohledu*<br>
**:res** {*počet-řádek*}{_Enter_}

*# nastavit všechna rozdělení rovnoměrně*<br>
{_Ctrl_}**+**{_W_}{_=_}

*# **rotovat** pohledy*<br>
{_Ctrl_}**+**{_W_}{_R_}

### Práce s více panely

*# otevřít **nový** panel (prázdný/se stejným souborem jako v aktivním pohledu/s jiným souborem)*<br>
**:tabnew**{_Enter_}<br>
**:tabnew %**{_Enter_}<br>
**:tabnew** {*cesta/k/souboru*}{_Enter_}

*# přepnout se na další/předchozí panel*<br>
**gt**<br>
**gT**

*# zavřít panel*<br>
*// Obvykle panel uzavřete uzavřením posledního pohledu v něm příkazem „:q“.*<br>
**:tabclose**{_Enter_}

## Zaklínadla: Nastavení

### Obecně

*# nastavit volbu typu „ano/ne“ (zapnout/vypnout/přepnout)*<br>
**:set** {*volba*}{_Enter_}<br>
**:set no**{*volba*}{_Enter_}<br>
**:set inv**{*volba*}{_Enter_}

*# nastavit číselnou či textovou volbu*<br>
*// Hodnota může být prázdná. Pokud textová hodnota obsahuje bílé či speciální znaky (kromě tečky a čárky), musíte je odzvláštnit zpětným lomítkem; použití uvozovek vim, zdá se, nepodporuje..*<br>
**:set** {*volba*}**=**{*hodnota*}{_Enter_}

*# **zjistit** hodnotu volby*<br>
**:set** {*volba*}**?**{_Enter_}

*# vypsat hodnoty všech voleb*<br>
**:set all**{_Enter_}

### Vzhled

*# před každou řádkou zobrazit její **číslo** (v rámci souboru/relativní)*<br>
**:set number**{_Enter_}<br>
**:set relativenumber**{_Enter_}
<!--
numberwidth=4
-->

*# **podtrhnout** aktuální řádek*<br>
**:set cursorline**{_Enter_}

*# vypnout **zalamování** řádků*<br>
**:set nowrap**{_Enter_}

*# **zvýraznit** sloupec s kurzorem*<br>
**:set cursorcolumn**{_Enter_}

*# **zvýraznit** konkrétní sloupce*<br>
**:set cc=**{*číslo-sloupce*}[**,**{*další-číslo-sloupce*}]{_Enter_}

*# skrýt informace o aktuální **pozici** ve stavové řádce (nedoporučuji)*<br>
**:set noruler**

*# skrýt název aktivního **režimu** ve stavové řádce (nedoporučuji)*<br>
**:set noshowmode**

### Chování

*# při vyhledávání **ignorovat** velikost písmen*<br>
**:set ignorecase**{_Enter_}

*# vypnout a smazat dočasný odkládací soubor/nastavit, kam ho uložit*<br>
**:set noswapfile**{_Enter_}<br>
**:set dir=**{*cesta*}[**,**{*další/cesta*}]...

*# zapnout **automatické** odsazování*<br>
**:set autoindent**{_Enter_}

*# místo tabulátorů vkládat odpovídající počet **mezer***<br>
**:set expandtab**{_Enter_}

*# zapnout automatické **znovunačtení** po změně souboru mimo Vim*<br>
**:set autoread**{_Enter_}

*# nechat vim nastavit **titulek** emulátoru terminálu (je-li to možné)*<br>
**:set title**{_Enter_}


### Ostatní

*# zapnout/vypnout ovládání **myší** (doporučuji zapnout)*<br>
**:set mouse=a**{_Enter_}<br>
**:set mouse=**{_Enter_}

*# dovolit posun kurzoru mimo řádek při blokovém výběru (doporučuji)*<br>
**:set virtualedit=block**{_Enter_}

*# kódová stránka souboru*<br>
*// Tuto vlastnost jsem příliš nezkoušel/a. Pokud s ní nemáte zkušenosti, doporučuji překódování raději provádět příkazem „iconv“ mimo vim.*<br>
**:set fileencoding=**{*kódování*}{_Enter_}

### Příznaky

*# zakázat jakoukoliv změnu textu/zápis do souboru bez !/jakýkoliv zápis do souboru*<br>
**:set nomodifiable**{_Enter_}<br>
**:set ro**{_Enter_}<br>
**:set nowrite**{_Enter_}

*# vypnout příznak, že soubor byl změněn*<br>
**:set nomodified**{_Enter_}

<!--
*# umístit odkládací soubor do /tmp*<br>
**:set dir=/tmp//,.**
-->
<!--
:set background={dark|light}
-->
<!--
### Nastavení folding

foldclose=
foldclose=all       # automaticky se uzavře

foldcolumn=0..12    # sloupce s foldy (výchozí 0)

foldenable (bool)   # vypnutím se vypne foldování


foldmarker={{{,}}}
foldmethod=marker
http://vimdoc.sourceforge.net/htmldoc/fold.html#fold-marker

foldtext? http://vimdoc.sourceforge.net/htmldoc/fold.html#fold-foldtext

zR - unfold all
zM - fold all
za - fold/unfold
zo - unfold
zc - fold

----
http://vimdoc.sourceforge.net/htmldoc/options.html#'linebreak'
http://vimdoc.sourceforge.net/htmldoc/options.html#'rulerformat'
-->


## Parametry příkazů

*# *<br>
**vim** [{*parametry*}] <nic>[**\-\-**] {*soubor*} [{*další-soubor*}]...<br>
**view** [{*parametry*}] <nic>[**\-\-**] {*soubor*} [{*další-soubor*}]...

!parametry:

* ○ -o ○ -O ○ -p :: Je-li zadáno více souborů, otevře je: v pohledech nad sebou (shora)/v pohledech vedle sebe (zleva)/v panelech. Výchozí chování: Je-li zadáno více souborů, otevře se pouze první a ostatní jsou otevřeny skrytě a uživatel se na ně musí přepnout příkazem „:n“.
* "+{*příkaz*}" :: Po otevření vykoná příkaz v režimu příkazové řádky (+ se nahradí „:“). Tento parametr lze zadat opakovaně, ale maximální počet je omezen. Nejčastější použití je s číslem řádky (např. „+12“).
* ☐ -n :: Vypne použití odkládacího souboru, vše udržuje jen v paměti.
* ☐ -u {*vimrc*} :: Místo běžných konfiguračních souborů (vimrc) použije uvedený.
<!--
* -s {*soubor/skript*} :: Po otevření spustí skript a vykoná ho v základním režimu (příkazy mohou režim přepínat). (Nezkoušel/a jsem.)
* -W {*výstup-skript*} :: Z běhu vygeneruje skript použitelný pro parametr -s. (Nezkoušel/a jsem.)
--cmd {*příkaz*} :: Vykoná příkaz před načtením konfigurace.
-->

Příkaz „view“ otevře soubor v režimu „jen pro čtení“, „vim“ ho otevře pro úpravy.

## Instalace na Ubuntu

Editor Vim lze na Ubuntu doinstalovat tímto příkazem:

*# *<br>
**sudo apt-get install vim**

Místo „vim“ si můžete nainstalovat balíček „neovim“, což je nová, víceméně kompatibilní
implementace téhož editoru. Podle mé zkušenosti se z uživatelského hlediska liší prakticky jen
odlišným výchozím nastavením.

Základní součástí Ubuntu (a mnoha jiných distribucí) je editor „vi“, což je předchůdce Vimu.
V něm však většina zaklínadel z této kapitoly není použitelná.

<!--
## Ukázka
<!- -
- Tuto sekci ponechávat jen v kapitolách, kde dává smysl.
- Zdrojový kód, konfigurační soubor nebo interakce s programem, a to v úplnosti – ukázka musí být natolik úplná, aby ji v této podobě šlo spustit, ale současně natolik stručná, aby se vešla na jednu stranu A5.
- Snažte se v ukázce ilustrovat co nejvíc zaklínadel z této kapitoly.
- ->
![ve výstavbě](../obrazky/ve-vystavbe.png)
-->

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Doporučuji komukoliv (bez ohledu na úroveň zkušeností) si alespoň jednou projít „kurz“, který spustíte příkazem „vimtutor“ (příkaz zadávejte v bashi, ne ve vimu).
* Příkaz „c“ je velmi efektivní v kombinaci s opakováním příkazem „.“ a opakováním vyhledávání příkazem „n“.
* Každá schránka si spolu s textem zachovává i „režim“: znakový, řádkový či sloupcový. Je-li schránka ve znakovém režimu, „p“ vloží její obsah za kurzor; je-li v řádkovém režimu, „p“ vloží její obsah za aktuální řádku; je-li ve sloupcovém režimu (což znamená, že vznikla ze sloupcového výběru), „p“ vloží její první řádku za kurzor a následující řádky na odpovídající pozice následujících řádků textu.
* Klávesové zkratky editoru Vim jsou optimalizované pro anglickou klávesnici; proto doporučuji s tímto editorem používat rozložení kláves kompatibilní s anglickým.
* Doporučuji nastavit si „:set number“ a „:set cursorline“. Editor s nimi podle mě vypadá podstatně lépe.
* Většina uživatelů Vimu intenzivně používá příkazy „y“ a „p“ bez uvedení schránky; to se ovšem vyplácí jen tehdy, pokud chcete zkopírovaný text okamžitě někam vložit a pak už ho nebudete potřebovat. V ostatních případech totiž brzy narazíte na problém, že skoro jakákoliv další úprava vám „poslední smazaný text“ přepíše. Doporučuji proto si zvyknout jakékoliv úseky, které si chcete udržet delší dobu, ukládat do schránky „p“ (příkaz bude vypadat např. „"pdd“). Alternativním řešením je směrovat ostatní příkazy mazání a náhrad do zvláštního registru „\_“ (např. „"\_dd“).
* Nastavení provedená příkazem „:set“ z editoru jsou platná jen do ukončení procesu. Pro trvalé nastavení pro nově otevírané instance editoru zapište příkazy „:set“ do souboru „~/.vimrc“ nebo do „/etc/vim/vimrc.local“.
* Jeden editovaný soubor může být otevřen ve více pohledech, dokonce i na různých panelech. V těchto případech má ovšem každý pohled svůj kurzor, čehož lze někdy chytře využít.

## Další zdroje informací

V začátcích je nejlepším zdrojem informací „Vim Reference: Quick Reference Guide“
a rozhodně doporučuji manuál Pavla Satrapy,
nicméně pokud s editorem Vim nemáte dřívější zkušenosti, určitě si nejprve vyzkoušejte
kurz spouštěný příkazem „vimtutor“.

* [Pavel Satrapa: Vim](http://www.nti.tul.cz/~satrapa/docs/vim/index.html)
* [Wikipedie: Vim](https://cs.wikipedia.org/wiki/Vim)
* [Vim Basics in 8 Minutes](https://www.youtube.com/watch?v=ggSyF1SVFr4) (anglicky)
* [YouTube playlist: TheFrugalComputerGuy: Vim](https://www.youtube.com/playlist?list=PLy7Kah3WzqrEjsuvhT46fr28Q11oa5ZoI) (anglicky)
* [YouTube playlist: BrandonioProductions](https://www.youtube.com/playlist?list=PL13bz4SHGmRxlZVmWQ9DvXo1fEg4UdGkr) (anglicky)
* [Vim Reference: Quick Reference Guide](https://vimhelp.org/quickref.txt.html) (anglicky)
* [Vim Help Files](https://vimhelp.org/) (anglicky)
* [Vim Tips Wiki](https://vim.fandom.com/wiki/Vim_Tips_Wiki) (anglicky)
* [Oficiální stránka Vim](https://www.vim.org/) (anglicky)
* [Official Vim FAQ](https://vimhelp.org/vim_faq.txt.html) (anglicky)
* [Balíček Bionic](https://packages.ubuntu.com/bionic/vim) (anglicky)
* [What Is Your Most Productive Shortcut with Vim?](https://stackoverflow.com/questions/1218390/what-is-your-most-productive-shortcut-with-vim) (anglicky)

K referenční příručce můžete získat přístup také přímo v editoru Vim příkazem „:help“,
ale vzhledem k tomu, že Vim se téměř nevyvíjí, neměl by být problém použít online referenční
příručku i s velmi starou verzí Vimu (ne však s „vi“).

<!--
* Publikované knihy
-->

!ÚzkýRežim: vyp
