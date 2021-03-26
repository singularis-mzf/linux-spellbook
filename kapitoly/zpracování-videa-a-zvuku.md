<!--

Linux Kniha kouzel, kapitola Zpracování videa a zvuku
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
ÚKOLY:

Pochopit a zpracovat filtry:
- chorus
- equalizer
- highpass
- lowpass
- pan
- silenceremove
- stereowiden
- volume (dynamicky)

- Popsat vestavěné funkce.

[ ] Stručně a pochopitelně vysvětlit PTS.
[ ] Otestovat, zda „-pix_fmt yuv420p“ umožní bezproblémové přehrátí videa s kodekem h264 (nebo mpeg4) na Windows 7 a Windows 10.
[ ] Dodělat ukázku.

Poznámky:
- filtr v360 (https://ffmpeg.org/ffmpeg-filters.html#toc-v360)
- vidstabdetect, vidstabtransform
- filtr zoompan

-->
# Zpracování videa a zvuku

!Štítky: {tematický okruh}{video}{zvuk}
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

FFmpeg je nástroj pro konverzi, úpravu a streamování videa, zvuku a titulků.
Hlavní výhodou FFmpegu oproti videoeditorům s grafickým uživatelským rozhraním
je modularita a opakovatelnost zpracování pro různé vstupní soubory.

Tato verze kapitoly nepokrývá všechny dostupné filtry ffmpegu (zvlášť v oblasti
zpracování zvuku není pokrytí příliš dobré) a neobsahuje vysvětlení pojmu PTS.
Rovněž chybí popis vestavěných funkcí používaných ve výrazech v parametrech filtrů.

## Definice

* **Stopa** (stream) je časovaná složka multimediálního souboru proložená v čase s ostatními stopami
téhož souboru. Stopy v jednom souboru mohou být různého typu (obrazová, zvuková,
titulková či datová) a mohou mít různou délku.

* **Kanál** (plane/channel) je datová vrstva tvořící stopu s ostatními kanály. Všechny kanály stopy
trvají vždy stejně dlouho a tvoří každý snímek obrazu či vzorek zvuku společně. Obrazová stopa
se typicky dělí na kanály Y (svítivost), U a V (barva), případně ještě alfa (krytí); zvuková
stopa mívá nejčastěji kanály FR a FL (stereo), méně často jeden kanál (mono) či více kanálů.

* **Snímek** je základní kvantum obrazové stopy. Vzorkovací frekvence videa čili počet snímků
za sekundu se nazývá **fps**. Hodnota fps se obvykle pohybuje v rozmezí 10 až 60.

* **Vzorek** je základní kvantum zvukové stopy. Obvyklá vzorkovací frekvence zvuku je 44 100
vzorků za sekundu.

* **Filtr** je objekt v grafu filtrů, který očekává určitý počet vstupů určitého typu v určitém pořadí (toto očekávání se může lišit v závislosti na parametrech). Na tyto vstupy je pak potřeba připojit buď stopy vstupů ffmpegu (typicky vstupních souborů) nebo výstupy jiných filtrů. Filtr mívá také výstupy, které je pak nutno připojit na vstupy jiných filtrů nebo na stopy výstupů ffmpegu. Filtr, která má výstupy, ale ne vstupy, se nazývá **generátor**, přestože může načítat data z disku.

* **Graf filtrů** je orientovaný graf definovaný uživatelem, který popisuje tok dat různého typu přes ffmpeg ze vstupů na výstupy. V grafu filtrů nejsou dovoleny nepřipojené vstupy či výstupy filtrů.

!ÚzkýRežim: vyp

![Obrázek: ukázka grafu filtrů](../obrázky/graf-filtrů.svg)

### Syntaxe grafu filtrů

Základním nástrojem pro zpracování multimediálních souborů v ffmpegu je
tzv. graf filtrů (filtergraph), který může být buď kompletní, definovaný
pomocí globálního parametru **-filter\_complex** (resp. **-filter\_complex\_script**),
nebo jednoduchý, definovaný pomocí výstupních parametrů **-vf** a **-af**.

V komplexním grafu filtrů se každá stopa vstupu značí formou „[0:v]“, kde na místě 0
je pořadové číslo vstupu (počítáno od nuly) a na místě „v“ může být „v“ pro výchozí
obrazovou stopu, „a“ pro výchozí zvukovou stopu, nebo pořadové číslo stopy
v kontejneru vstupního souboru (lze zjistit z výstupu příkazu „ffprobe“).

<!--
[ ] Následující odstavec je nesrozumitelný. Bylo by vhodné ho přepsat nebo nahradit obrázkem.
-->
Jednoduché propojení mezi filtry se v komplexním i jednoduchém grafu filtrů vytvoří tak,
že se filtry zapíšou vedle sebe a oddělí čárkou (kde propojení není, píše se místo
čárky středník). V komplexním grafu filtrů se vytvářejí také pojmenovaná propojení,
jejichž identifikátory je nutno uzavřít do hranatých závorek.
Zatímco u jednoduchého grafu filtrů se konec namapuje na stopu výstupního souboru
automaticky, u komplexního grafu filtrů to musíme udělat ručně, samostatným výstupním
parametrem „-map“.

## Zaklínadla: Filtry

V této sekci používám následující konvence: {*vi*} značí obrazový vstup filtru (opakuje se
tolikrát, kolik má filtr obrazových vstupů); analogicky {*ai*} zvukový vstup,
{*vo*} obrazový výstup a {*ao*} zvukový výstup. Značky {*io1*}, {*io2*} atd. značí
pomocná propojení filtrů, kterým musíte vymyslet nové, v grafu filtrů dosud nepoužité identifikátory.

### Úprava časové osy

*# **zrychlení** 2×/4×/5×/16×*<br>
*// Důvodem k rozdílné implementaci různého zrychlení a zpomalení je, že filtr „atempo“ akceptuje parametr pouze v rozsahu 0.5 až 2.0; vyšších, resp. nižších hodnot je možno dosáhnout zřetězením více těchto filtrů.*<br>
**[**{*vi*}**] setpts=PTS/2 [**{*vo*}**] ; [**{*ai*}**] atempo=2 [**{*ao*}**]**<br>
**[**{*vi*}**] setpts=PTS/4 [**{*vo*}**] ; [**{*ai*}**] atempo=2,atempo=2 [**{*ao*}**]**<br>
**[**{*vi*}**] setpts=PTS/5 [**{*vo*}**] ; [**{*ai*}**] atempo=2,atempo=2,atempo=5/4 [**{*ao*}**]**<br>
**[**{*vi*}**] setpts=PTS/16 [**{*vo*}**] ; [**{*ai*}**] atempo=2,atempo=2,atempo=2,atempo=2 [**{*ao*}**]**

*# **zpomalení** 2×/4×/5×/16×*<br>
**[**{*vi*}**] setpts=2.0\*PTS [**{*vo*}**] ; [**{*ai*}**] atempo=1/2 [**{*ao*}**]**<br>
**[**{*vi*}**] setpts=4.0\*PTS [**{*vo*}**] ; [**{*ai*}**] atempo=1/2,atempo=1/2 [**{*ao*}**]**<br>
**[**{*vi*}**] setpts=5.0\*PTS [**{*vo*}**] ; [**{*ai*}**] atempo=1/2,atempo=1/2,atempo=4/5 [**{*ao*}**]**<br>
**[**{*vi*}**] setpts=16.0\*PTS [**{*vo*}**] ; [**{*ai*}**] atempo=1/2,atempo=1/2,atempo=1/2,atempo=1/2 [**{*ao*}**]**

*# **vyříznout** časový úsek (po sekundách)(alternativy)*<br>
**[**{*vi*}**] trim=**{*začátek*}**:**{*konec*}**,setpts=PTS-STARTPTS [**{*vo*}**] ; [**{*ai*}**] atrim=**{*začátek*}**:**{*konec*}**,asetpts=PTS-STARTPTS [**{*ao*}**]**<br>
**[**{*vi*}**] trim=start=**{*začátek*}**:duration=**{*trvání*} **[**{*vo*}**] ; [**{*ai*}**] atrim=start=**{*začátek*}**:duration=**{*trvání*}**,asetpts=PTS-STARTPTS [**{*ao*}**]**

*# vyříznout časový úsek (po snímcích)(alternativy)*<br>
**[**{*vi*}**] trim=start\_frame=**{*index-prvního-zahrnutého-snímku*}**:end\_frame=**{*index-snímku-za-koncem*}**,setpts=PTS-STARTPTS [**{*vo*}**]**<br>
**[**{*ai*}**] atrim=start\_sample=**{*index-prvního-zahrnutého-vzorku*}**:end\_sample=**{*index-vzorku-za-koncem*}**,asetpts=PTS-STARTPTS [**{*ao*}**]**

*# **obrátit** celou stopu*<br>
*// Pozor! Filtr reverse musí celé video nekomprimované uložit do paměti. Pro zpracování dlouhého videa tedy doporučuji dočasně zapnout opravdu velký odkládací soubor nebo video obracet po částech.*<br>
**[**{*vi*}**] reverse [**{*vo*}**]; [**{*ai*}**] areverse [**{*ao*}**]**

*# **opakovat** celý (krátký) obrazový/zvukový vstup po zadaný počet sekund*<br>
*// Na vstupu vezme maximálně 32 767 snímků a max. 2 147 483 647 zvukových vzorků, což obvykle odpovídá cca 21,8 minut obrazu a 13,5 hodině zvuku.*<br>
**[**{*vi*}**] setpts=PTS-STARTPTS,loop=-1:32767,trim=0:**{*cílový-počet-sekund*}** [**{*vo*}**]**<br>
**[**{*ai*}**] asetpts=PTS-STARTPTS,aloop=-1:2147483647,atrim=0:**{*cílový-počet-sekund*}** [**{*ao*}**]**

*# opakovat vyříznutou část obrazového/zvukového vstupu po zadaný počet sekund*<br>
**[**{*vi*}**] trim=**{*začátek*}**:**{*konec*}**,setpts=PTS-STARTPTS,loop=-1:32767,trim=0:**{*cílový-počet-sekund*}** [**{*vo*}**]**<br>
**[**{*ai*}**] atrim=**{*začátek*}**:**{*konec*}**,asetpts=PTS-STARTPTS,aloop=-1:2147483647,atrim=0:**{*cílový-počet-sekund*}** [**{*ao*}**]**

*# zpomalit obraz 10× s interpolací pohybu/zpomalit zvuk 10×*<br>
*// Poznámka: filtr „minterpolate“ je neparalelizovatelný a může být velmi pomalý.*<br>
**[**{*vi*}**] setpts=10.0\*PTS,minterpolate=fps=25**[**:mi\_mode=**{*blend-nebo-dup*}] **[**{*vo*}**]**<br>
**[**{*ai*}**] atempo=1/2,atempo=1/2,atempo=1/2,atempo=8/10 [**{*ai*}**]**

### Škálování obrazu (resize)

*# změna rozlišení (roztažení, smrsknutí, škálování)*<br>
*// Pozor, při zápisu do souboru musejí být šířka a výška obrazu pro většinu kodeků sudé! Toto omezení však neplatí, dokud je obrazová stopa jen zpracovávána uvnitř ffmpegu.*<br>
**[**{*vi*}**] scale=**{*šířka*}**:**{*výška*} **[**{*vo*}**]**

*# změnit šířku i výšku na polovinu a zajistit, aby oba rozměry byly sudé*<br>
**[**{*vi*}**] scale=2\*trunc(iw/4):2\*trunc(ih/4) [**{*vo*}**]**

*# zvětšit šířku i výšku s interpolací pro pixel-art na dvojnásobek/dvojnásobek jinak/trojnásobek/čtyřnásobek*<br>
**[**{*vi*}**] super2xsai [**{*vo*}**]**<br>
**[**{*vi*}**] xbr=2 [**{*vo*}**]**<br>
**[**{*vi*}**] xbr=3 [**{*vo*}**]**<br>
**[**{*vi*}**] xbr=4 [**{*vo*}**]**

### Transformace a oříznutí obrazu

*# nadstavení obrazu (**padding**)*<br>
*// Barva se zde uvádí ve formátu #RRGGBB[AA] ve stejném významu jako v CSS).*<br>
**[**{*vi*}**] pad=**{*šířka*}**:**{*výška*}**:**{*posun-x-zleva*}**:**{*posun-y-shora*}[**:**{*barva*}] **[**{*vo*}**]**

*# vyříznutí obrazu/oříznutí okrajů (**cropping**)*<br>
**[**{*vi*}**] crop=**{*šířka*}**:**{*výška*}**:**{*posun-x-zleva*}**:**{*posun-y-shora*} **[**{*vo*}**]**<br>
**[**{*vi*}**] crop=iw-**{*zleva*}**-**{*zprava*}**:ih-**{*shora*}**-**{*zespodu*}**:**{*zleva*}**:**{*shora*} **[**{*vo*}**]**

*# **převrátit** obraz (horizontálně/vertikálně)*<br>
**[**{*vi*}**] hflip [**{*vo*}**]**<br>
**[**{*vi*}**] vflip [**{*vo*}**]**

*# **otočit** obraz o +90° (o 90° proti směru hodinových ručiček)*<br>
**[**{*vi*}**] transpose=2 [**{*vo*}**]**

*# **otočit** obraz o 180°*<br>
**[**{*vi*}**] hflip,vflip [**{*vo*}**]**

*# **otočit** obraz o -90° (o 90° po směru hodinových ručiček)*<br>
**[**{*vi*}**] transpose=1 [**{*vo*}**]**

*# otočit obraz o obecný úhel (ve stupních) proti/po směru hodinových ručiček*<br>
**[**{*vi*}**] rotate=**{*úhel*}**\*(-PI/180)**[**:**{*výsl-šířka*}**:**{*výsl-výška*}]<nic>[**:c=**{*barva-pozadí-nebo-none*}] **[**{*vo*}**]**<br>
**[**{*vi*}**] rotate=**{*úhel*}**\*(PI/180)**[**:**{*výsl-šířka*}**:**{*výsl-výška*}]<nic>[**:c=**{*barva-pozadí-nebo-none*}] **[**{*vo*}**]**

*# otočit obraz o obecný úhel (ve stupních) proti směru hodinových ručiček a zvětšit rozlišení na obdelník opsaný otočenému snímku; nevyplněné rohy ponechat průhledné*<br>
**[**{*vi*}**] rotate=**{*úhel*}**\*(-PI/180):rotw(**{*úhel*}**\*(-PI/180)):roth(**{*úhel*}**\*(-PI/180)):c=none [**{*vo*}**]**

*# opravit perspektivu ze zadaných souřadnic (vLevo, vpRavo, Nahoře, Dole)*<br>
**[**{*vi*}**] perspective=**{*LNx*}**:**{*LNy*}**:**{*RNx*}**:**{*RNy*}**:**{*LDx*}**:**{*LDy*}**:**{*RDx*}**:**{*RDy*}[**:sense=destination**]<nic>[**:interpolation=cubic**] **[**{*vo*}**]**

*# vyměnit dvě obdelníkové oblasti ve videu*<br>
*// Všechny hodnoty mohou používat rozměry snímku (w, h), čas v sekundách (t) a sekvenční číslo snímku (n).*<br>
**[**{*vi*}**] swaprect=**{*šířka-oblastí*}**:**{*výška-oblastí*}**:**{*x1*}**:**{*y1*}**:**{*x2*}**:**{*y2*} **[**{*vo*}**]**

### Překryv, skládání a prolínání obrazových stop (blend)

*# **naskládat** videa stejné výšky vedle sebe/videa stejné šířky pod sebe*<br>
*// Všechny použité vstupy musejí mít kromě stejné výšky/šířky také stejný formát pixelu (pixel-format).*<br>
**[**{*vi*}**]**... **hstack=inputs=**{*počet-vstupů*}[**:shortest=1**] **[**{*vo*}**]**<br>
**[**{*vi*}**]**... **vstack=inputs=**{*počet-vstupů*}[**:shortest=1**] **[**{*vo*}**]**

*# **prolnout** několik vstupů*<br>
*// Všechny vstupy musejí mít stejné rozměry. Toto lze docílit vhodným předzpracováním.*<br>
**[**{*vi*}**]**... **mix=nb\_inputs=**{*počet-vstupů*}**:weights=**{*váhy oddělené mezerami*}[**:duration=**{*longest-shortest-nebo-first*}] **[**{*vo*}**]**

*# **překrýt** hlavní (první) videovstup překryvným (druhým); po skončení překryvného vstupu: ho skrýt/ukončit výstup/zamrznout překryvný vstup na jeho posledním snímku*<br>
*// Hodnoty posunu jsou výrazy s výsledkem v pixelech. Mohou používat: rozměry hlavního videa (W, H), rozměry překryvného videa (w, h), čas v sekundách (t) a sekvenční číslo snímku (n). Poznámka: výstup filtru overlay není nikdy delší než délka jeho hlavního (prvního) vstupu a hlavní vstup rovněž určuje jeho šířku a výšku.*<br>
**[**{*vi*}**]<nic>[**{*vi*}**] overlay=x=**{*posun-x*}**:y=**{*posun-y*}**:eof\_action=pass [**{*vo*}**]**<br>
**[**{*vi*}**]<nic>[**{*vi*}**] overlay=x=**{*posun-x*}**:y=**{*posun-y*}**:eof\_action=endall [**{*vo*}**]**<br>
**[**{*vi*}**]<nic>[**{*vi*}**] overlay=x=**{*posun-x*}**:y=**{*posun-y*}**:eof\_action=repeat [**{*vo*}**]**

*# prolnout jeden a druhý videovstup (obecně/konkrétně)*<br>
*// Ve výrazu můžete použít hodnoty: sekvenční číslo snímku (N), souřadnice pixelu ((X/SW), (Y/SW)), šířka a výška ((W/SW), (H/SW)), čas v sekundách (T) a především hodnotu složky prvního vstupu (A) a druhého vstupu (B).*<br>
**[**{*vi*}**]<nic>[**{*vi*}**] blend=all\_expr=**{*výraz*}[**:eof\_action=**]{*repeat-endall-nebo-pass*} **[**{*vo*}**]**<br>
**[prvni]<nic>[druhy] blend=all\_expr=if(eq(mod(Y\\,2)\\,0)\\,A\\,B):eof\_action=endall [vysledek]**

### Jas, kontrast, barva a spol.
<!--
[ ] Úkol: Prozkoumat rozdíl mezi „eq“ a „hue“.
-->

*# **odbarvit** obrázek na stupně šedi*<br>
**[**{*vi*}**] hue=s=0 [**{*vo*}**]**

*# nastavit **kontrast** (rozsah -2.0 až 2.0; neutrální hodnota 1.0)*<br>
*// Záporné hodnoty vyústí v inverzní obraz.*<br>
**[**{*vi*}**] eq=contrast=**{*hodnota*}[**:eval=frame**] **[**{*vo*}**]**

*# nastavit **jas** (rozsah -1.0 až 1.0; neutrální hodnota 0.0)*<br>
**[**{*vi*}**] eq=brightness=**{*hodnota*}[**:eval=frame**] **[**{*vo*}**]**

*# nastavit **saturaci** (rozsah 0.0 až 3.0; neutrální hodnota 1.0*<br>
**[**{*vi*}**] eq=saturation=**{*hodnota*}[**:eval=frame**] **[**{*vo*}**]**

*# nastavit **gama-korekci** (rozsah 0.1 až 10.0; neutrální hodnota 1.0)*<br>
**[**{*vi*}**] eq=gamma=**{*hodnota*}[**:eval=frame**] **[**{*vo*}**]**

*# nastavit kontrast, jas, saturaci a gama korekci současně*<br>
**[**{*vi*}**] eq=contrast=**{*kontrast*}**:brightness=**{*jas*}**:saturation=**{*saturace*}**:gamma=**{*gama*}[**:eval=frame**] **[**{*vo*}**]**

*# **invertovat** barvy/barvy a alfa-kanál*<br>
**[**{*vi*}**] negate [**{*vo*}**]**<br>
**[**{*vi*}**] negate=negate\_alpha=1 [**{*vo*}**]**

*# efekt „**sépie**“*<br>
**[**{*vi*}**] colorchannelmixer=0.393:0.769:0.189:0:0.349:0.686:0.168:0:0.272:0.534:0.131**[**,eq=contrast=0.8:saturation=1.2**] **[**{*vo*}**]**
<!--
Matice podle: http://ffmpeg.org/ffmpeg-filters.html
ale čísla možná pocházejí z https://www.w3.org/TR/filter-effects/#sepiaEquivalent
-->

*# **rozmazat** obraz (normálně/maximálně/minimálně/obecně)*<br>
**[**{*vi*}**] gblur=2 [**{*vo*}**]**<br>
**[**{*vi*}**] gblur=1024 [**{*vo*}**]**<br>
**[**{*vi*}**] gblur=0 [**{*vo*}**]**<br>
**[**{*vi*}**] gblur=**{*sigma*} **[**{*vo*}**]**

*# **zašumět** obraz proměnným RGB-šumem*<br>
*// Přípustné hodnoty parametry allf jsou a, p, t, u a jejich kombinace operátorem +; při letmém vyzkoušení se mi jevily použitelné jen varianty „t“ a „t+u“ (jemnější).*<br>
**[**{*vi*}**] noise=alls=**{*síla-šumu-0-až-100*}**:allf=t [**{*vo*}**]**

*# ztmavit/zesvětlit okraje snímku (efekt „**vignette**“)*<br>
*// Úhel čočky je v rozsahu 0 (žádný účinek) až PI/2 (maximální účinek). Pro vyhodnocování výrazů pro každý snímek musíte přidat parametr „eval=frame“.*<br>
**[**{*vi*}**] vignette=a=**{*úhel-čočky*}[**:x0=**{*x-středu*}**:y0=**{*y-středu*}]<nic>[**:eval=frame**] **[**{*vo*}**]**<br>
**[**{*vi*}**] vignette=mode=backward:a=**{*úhel-čočky*}[**:x0=**{*x-středu*}**:y0=**{*y-středu*}]<nic>[**:eval=frame**] **[**{*vo*}**]**

### Zapékání titulků

*# **zapéci titulky** do obrazu (normálně)*<br>
*// Pokud název souboru obsahuje mezery či jiné speciální znaky, uzavřete ho do apostrofů. Zadáváte-li graf filtrů přímo na příkazové řádce do apostrofů, musíte kvůli bashi apostrof zadat kombinací "'\\''".*<br>
**[**{*vi*}**] subtitles=**{*soubor-s-titulky*} **[**{*vo*}**]**

*# zapéci titulky s časovým posunem (opozdit titulky/opozdit video/příklad)*<br>
*// Posun se zadává v sekundách s desetinnou částí, např. „2.0“ pro posun o dvě sekundy.*<br>
**[**{*vi*}**] setpts=PTS-**{*posun-sekund*}**/TB,subtitles=**{*soubor-s-titulky*}**,setpts=PTS+**{*posun-sekund*}**/TB [**{*vo*}**]**<br>
**[**{*vi*}**] setpts=PTS+**{*posun-sekund*}**/TB,subtitles=**{*soubor-s-titulky*}**,setpts=PTS-**{*posun-sekund*}**/TB [**{*vo*}**]**<br>
**[vst] setpts=PTS+1.25/TB,subtitles=titulky.srt,setpts=PTS-1.25/TB [vvyst]**

*# zapéci titulky do obrazu (obecně/podtrženým červeným písmem Arial velikosti 48)*<br>
*// Nastavení stylu jsou ve formátu ASS, přičemž znaky = a , musíte odzvláštnit kvůli ffmpegu.*<br>
**[**{*vi*}**] subtitles=**{*soubor-s-titulky*}[**:force\_style=**{*nastavení-stylu*}] **[**{*vo*}**]**<br>
**[**{*vi*}**] subtitles=**{*soubor-s-titulky*}**:force\_style=FontName\\=Arial\\,Fontsize\\=48\\,PrimaryColour\\=&amp;H000000FF\\,Underline\\=1 [**{*vo*}**]**

<!--
Barvy se zadávají ve formátu AABBGGRR, kde AA=FF je úplná průhlednost a AA=00 úplná neprůhlednost.
-->

### Roztmívačky, zatmívačky a další přechody (obr. i zvuku)

*# vložit roztmívačku/zatmívačku*<br>
*// Všechny snímky před začátkem roztmívačky a za koncem zatmívačky budou nastaveny na uvedenou barvu, resp. zprůhledněny (je-li uveden parametr „alpha=1“).*<br>
**[**{*vi*}**] fade=t=in:st=**{*začátek*}**:d=**{*trvání*}[**:c=**{*barva*}]<nic>[**:alpha=1**] **[**{*vo*}**]**<br>
**[**{*vi*}**] fade=t=out:st=**{*začátek*}**:d=**{*trvání*}[**:c=**{*barva*}]<nic>[**:alpha=1**] **[**{*vo*}**]**

*# spojit za sebe dva **zvukové** vstupy **prolínačkou** (konkrétně sedmisekundovou/obecně)*<br>
**[**{*ai*}**]<nic>[**{*ai*}**] acrossfade=d=7:c1=exp:c2=exp [**{*ao*}**]**<br>
**[**{*ai*}**]<nic>[**{*ai*}**] acrossfade=d=**{*trvání-prolínačky*}**:c1=**{*funkce-zatmívačky*}**:c2=**{*funkce-roztmívačky*} **[**{*ao*}**]**<br>

*# spojit za sebe dva **obrazové** vstupy **prolínačkou** (konkrétně sedmisekundovou/obecně)*<br>
*// Tip: Pro pochopení fungování této konstrukce důrazně doporučuji si uvedený graf filtrů nakreslit.*<br>
*// Začátek prolínačky zde znamená počet sekund od začátku prvního videa, kdy má prolínačka začít. Tento počet sekund je nutno předem zjistit.*<br>
**[prvnivideo] split [x1]<nic>[x2];[x2] trim=0:5.12 [x3];[x3]<nic>[druhevideo] concat=n=2:v=1:a=0 [x4];[x1] fade=out:st=5.12:d=7.0:alpha=1 [x5];[x4]<nic>[x5] overlay=eof\_action=pass [vystup]**<br>
**[**{*vi*}**] split [**{*io1*}**]<nic>[**{*io2*}**];[**{*io2*}**] trim=0:**{*začátek*} **[**{*io3*}**];[**{*io3*}**]<nic>[**{*vi*}**] concat=n=2:v=1:a=0 [**{*io4*}**];[**{*io1*}**] fade=out:st={*začátek*}:d={*trvání*}:alpha=1 [**{*io5*}**];[**{*io4*}**]<nic>[**{*io5*}**] overlay=eof\_action=pass [**{*vo*}**]**

<!--
[vi-první] split [io1][io2]
[io1] trim [io3]
[io3][vi-druhý] concat [io4] // spodní vrstva
[io2] fade=out [io5] // horní vrstva
[io4][io5] overlay [vo]
-->

*# aplikovat **zvukovou** zatmívačku/roztmívačku*<br>
*// Podporované tvary jsou: tri, qsin, hsin, esin, log, ipar, qua, cub, squ, cbr, par, exp, iqsin, ihsin, dese, desi, losi a nofade. Poznámka: Veškerý zvuk po konci zatmívačky, resp. začátkem roztmívačky bude tímto filtrem nahrazen tichem; to platí i pro tvar nofade.*<br>
**[**{*ai*}**] afade=out:st=**{*čas-začátku*}**:d=**{*trvání-v-s*}**:curve=**{*tvar*} **[**{*ao*}**]**<br>
**[**{*ai*}**] afade=in:st=**{*čas-začátku*}**:d=**{*trvání-v-s*}**:curve=**{*tvar*} **[**{*ao*}**]**

*# roztmívačka/zatmívačka saturace*<br>
*// Čas začátku a trvání efektu jsou v sekundách.*<br>
**[**{*vi*}**] hue=s=max(0\\,min(1\\,(t - **{*začátek*}**)/**{*trvání*}**)) [**{*vo*}**]**<br>
**[**{*vi*}**] hue=s=max(0\\,min(1\\,(**{*začátek*} **- t)/**{*trvání*}**)) [**{*vo*}**]**

### Retušování (obrazu)

*# zakrýt/odstranit logo nebo jiný **rušivý element** z obrazu*<br>
**[**{*vi*}**] delogo=x=**{*posun-x-zleva*}**:y=**{*posun-y-shora*}**:w=**{*šířka*}**:h=**{*výška*} **[**{*vo*}**]**

*# **zneviditelnit předmět***<br>
*// Mapa by měla mít stejný rozměr jako video a musí obsahovat bílé pixely na pozicích, kde je na videu předmět k odstranění, a černé pixely na místech, která se nemají změnit. Tento filtr je pro velké oblasti výpočetně náročný, proto by měla být drtivá většina pixelů mapy zcela černá.*<br>
**[**{*vi*}**] removelogo=**{*obrázek-s-mapou.png*} **[**{*vo*}**]**

### Vykreslování do videa
*# **obdelník** (jen čáry/vyplněný/invertující)*<br>
**[**{*vi*}**] drawbox=**{*posun-x-zleva*}**:**{*posun-y-shora*}**:**{*šířka*}**:**{*výška*}**:**{*barva*}[**@**{*krytí-0-až-1*}]<nic>[**:**{*tloušťka*}] **[**{*vo*}**]**<br>
**[**{*vi*}**] drawbox=**{*posun-x-zleva*}**:**{*posun-y-shora*}**:**{*šířka*}**:**{*výška*}**:**{*barva*}[**@**{*krytí-0-až-1*}]**:fill [**{*vo*}**]**<br>
**[**{*vi*}**] drawbox=**{*posun-x-zleva*}**:**{*posun-y-shora*}**:**{*šířka*}**:**{*výška*}**:invert**[**@**{*krytí-0-až-1*}]<nic>**:fill [**{*vo*}**]**

*# trojúhelník*<br>
?

*# kruh*<br>
?

*# text*<br>
?

### Ostatní
*# odstranit **prokládání***<br>
*// Odstranění prokládání zvýší fps na dvojnásobek. Existuje na ně i mnoho dalších filtrů.*<br>
**[**{*vi*}**] yadif [**{*vo*}**]**

*# proložit obraz*<br>
*// Prokládání obrazu sníží fps na polovinu.*<br>
**[**{*vi*}**] interlace [**{*vo*}**]**

*# aplikovat na obraz **Sobelův operátor** detekce hran*<br>
**[**{*vi*}**] sobel [**{*vo*}**]**

*# rozdělit snímky po dávkách a každou dávku vykreslit po řádkách do mřížky daných rozměrů*<br>
**[**{*vi*}**] tile=**{*počet-sloupců-mřížky*}**x**{*počet-řádků-mřížky*}[**:margin=**{*šířka-okraje*}]<nic>[**:padding=**{*rozestup-mřížky*}]<nic>[**:color=**{*barva-pozadí*}]<nic>[**:nb\_frames=**{*velikost-dávky*}] **[**{*vo*}**]**

### Nízkoúrovňové manipulace

*# nahradit všechny pixely barvou/průhledností při zachování ostatních parametrů stopy*<br>
*// Ačkoliv stejného efektu můžete dosáhnout i použitím univerzálních nízkoúrovňových filtrů, použití filtru „fade“ by mělo být výrazně rychlejší.*<br>
**[**{*vi*}**] fade=t=in:s=2G:c=**{*barva*} **[**{*vo*}**]**<br>
**[**{*vi*}**] fade=t=in:s=2G:alpha=1 [**{*vo*}**]**

*# aplikovat výraz po pixelech*<br>
*// K tomuto úkolu slouží filtr „geq“, ale jeho efektivní použití je náročné a vyžaduje pochopení formátu pixelu a barevných kanálů U a V. Rovněž se mi nepodařilo s ním upravit alfa-kanál.*<br>
?

<!--
*// Ve výrazu můžete použít proměnné: čas snímku v sekundách (T), sekvenční číslo snímku (N), souřadnice výstupního pixelu (X, Y), rozměry snímku (W, H); a funkce r(), g(), b() a a(), které přijímají parametry (x, y) a načtou odpovídající složku z pixelu původního snímku na uvedených souřadnicích. Pro souřadnice mimo rozsah vrací 0.*<br>
**[**{*vi*}**] geq=r=**{*výraz-red*}**:g=**{*výraz-green*}**:b=**{*výraz-blue*}[**:a=**{*výraz-alfa*}] **[**{*vo*}**]**

Problém: geq závisí na použitém barevném formátu
-->

*# sestavit každý nový snímek z pixelů původního (obecně/příklad)*<br>
*// Ve výrazech můžete použít souřadnice výstupního pixelu „(X/SW)“ a „(Y/SH)“, šířku snímku „(W/SW)“, výšku snímku „(H/SH)“, čas v sekundách „T“ a sekvenční číslo snímku „N“. Souřadnice mimo rozsah budou zarovnány na nejbližší platnou hodnotu.*<br>
**[**{*vi*}**] geq=p(SW\*(**{*výraz-x*}**)\\,SH\*(**{*výraz-y*}**)) [**{*vo*}**]**
**[video] geq=p(SW\*((X/SW)+100)\\,SH\*((Y/SH)+150)) [**{*vo*}**]**

*# oříznout hodnoty složek obrazu (kromě alfa-kanálu)*<br>
**[**{*vi*}**] limiter=**[**min=**{*minimum*}]<nic>[**:max=**{*maximum*}] **[**{*vo*}**]**

*# aplikovat na zvukové vzorky obecný výraz*<br>
*// Ve výrazu můžeme použít: hodnotu prvního/druhého kanálu (val(0)/val(1)), čas vzorku v sekundách (t), číslo vzorku (n), číslo počítaného kanálu (ch), původní počet kanálů (nb\_in\_channels), vzorkovací frekvenci (s).*<br>
**[**{*ai*}**] aeval=**{*výraz*}[**|**{*výraz-pro-druhý-kanál*}]**:c=same [**{*ao*}**]**

*# vynásobit vzorky dvou vstupů*<br>
**[**{*ai*}**]<nic>[**{*ai*}**] amultiply [**{*ao*}**]**

*# nastavit novou vzorkovací frekvenci bez ovlivnění vzorků*<br>
**[**{*ai*}**] asetrate=**{*nová-frekvence*} **[**{*ao*}**]**


### Manipulace obrazu po snímcích

*# **prohazovat a zahazovat snímky** podle zadaného klíče*<br>
*// Filtr načte do vstupního bufferu tolik snímků ze vstupu, kolik jste zadal/a indexů. Následně na výstup vybírá snímky z bufferu podle indexů, které jste uvedli. Indexy se mohou opakovat a lze uvést speciální index -1, který způsobí vynechání snímku na výstupu (zahození).*<br>
**[**{*vi*}**] shuffleframes=**{*indexy dělené mezerami*} **[**{*vo*}**]**

*# **náhodně prohazovat snímky** v čase (snímky se do bufferu vkládají sekvenčně a vybírají v náhodném pořadí)*<br>
*// Velikost bufferu musí být v rozmezí 2 až 512 (výchozí hodnota je 30); snímky se do bufferu vkládají sekvenčně a vybírají se v náhodném pořadí.*<br>
**[**{*vi*}**] random=**{*velikost-bufferu*} **[**{*vo*}**]**

*# z každé dávky snímků vybrat ten nejreprezentativnější a ten roztáhnout na celou délku dávky*<br>
*// Má velké paměťové nároky, nepoužívat pro velký počet snímků; rozumný je tak maximálně 1000.*<br>
**[**{*vi*}**] thumbnail=**{*počet-snímků-na-dávku*} **[**{*vo*}**]**

### Základní úprava zvuku

*# změnit **hlasitost** (snížit na desetinu/zvýšit na pětinásobek)*<br>
**[**{*ai*}**] volume=0.1 [**{*ao*}**]**<br>
**[**{*ai*}**] volume=5.0 [**{*ao*}**]**

*# přidat **ozvěnu***<br>
*// Hlasitost ozvěny je v rozsahu 0 až 1.0 a nesmí být 0. Filtr mírně sníží hlasitost původních zvuků, je potřeba ji vyladit.*<br>
**[**{*ai*}**] aecho=0.6:0.3:**{*ms-zpoždění*}**:**{*hlasitost-ozvěny*} **[**{*ao*}**]**

*# přidat dvě a více ozvěn*<br>
**[**{*ai*}**] aecho=0.6:0.3:**{*ms-zpoždění-1*}**\|**{*ms-další-zpoždění*}...**:**{*hlasitost-ozvěny-1*}**\|**{*hlasitost-další-ozvěny*}... **[**{*ao*}**]**

*# smíchat paralelní audiostopy*<br>
**[**{*ai*}**]**... **amix=**{*počet-vstupů*}**:duration=**{*longest,shortest,nebo-first*}[**:weights=**{*váhy vstupů*}**] <nic>[**{*ao*}**]**


### Pokročilá úprava zvuku
*# převzorkovat stopu na novou frekvenci*<br>
**[**{*ai*}**] aresample=**{*nová-frekvence*} **[**{*ao*}**]**

*# vylepšit zvuk pro poslech přes sluchátka*<br>
**[**{*ai*}**] earwax [**{*ao*}**]**

*# zvýraznit rozdíl mezi stereokanály*<br>
**[**{*ai*}**] extrastereo**[**=**{*koeficient*}] **[**{*ao*}**]**

*# rozkolísat amplitudu/fázi zvuku*<br>
*// Frekvence je v rozsahu 0.1 až 20000; rozumně slyšitelné jsou hodnoty do 20 Hz. Síla je v rozsahu 0.0 až 1.0.*<br>
**[**{*ai*}**] tremolo=f=**{*frekvence-Hz*}[**:d=**{*síla*}] **[**{*ao*}**]**<br>
**[**{*ai*}**] vibrato=f=**{*frekvence-Hz*}[**:d=**{*síla*}] **[**{*ao*}**]**

### Vložit ticho

*# **před stopu** (do všech kanálů/do kanálů různě)*<br>
?<br>
?
<!--
Nefungovalo mi... vyzkoušet jiné varianty.
**[**{*ai*}**] adelay='"$(yes** {*milisekund*} **\| head -n 32 \| xargs echo \| tr ' ' \\\|)"' [**{*ao*}**]**<br>
**[**{*ai*}**] adelay=**{*ms-pro-první-kanál*}[**\|**{*ms-pro-další-kanál*}]... **[**{*ao*}**]**
<!--
**[**{*ai*}**] adelay=**{*ms*}**:all=1 [**{*ao*}**]**<br>
all vyžaduje novější verzi ffmpegu
-->

*# **za stopu***<br>
*// V případě opakovaného použití v rámci jednoho grafu filtrů nahraďte identifikátor „tmpticho“ při každém použití jiným identifikátorem.*<br>
**anoisesrc=a=0:d=**{*trvání-v-s*} **[**{*io1*}**]; [**{*ai*}**]<nic>[**{*io1*}**] concat=n=2:v=0:a=1 [**{*ao*}**]**

*# **nadstavení** zvuku na určitou délku*<br>
**[**{*ai*}**] apad=whole\_len=**{*cílový-min-počet-vzorků*} **[**{*ao*}**]**

*# přidat na konec zvukové stopy nekonečné ticho*<br>
**[**{*ai*}**] apad [**{*ao*}**]**

### Konverze mono/stereo/L/R

*# duplikovat kanál mono-stopy na stereo-stopu*<br>
**[**{*ai*}**] channelmap=mono-FR\|mono-FL [**{*ao*}**]**

*# smíchat kanály stereo-stopy do mono-stopy*<br>
**[**{*ai*}**] channelsplit,amix,channelmap=0-mono:mono [**{*ao*}**]**

*# sloučit kanály stereo-stopy do mono-stopy daným výrazem*<br>
*// Hodnota první stopy je „val(0)“ a hodnota druhé „val(1)“.*<br>
**[**{*ai*}**]** [**channelmap=FR-0|FL-1,**]**aeval=**{*výraz*}**:c=mono [**{*ao*}**]**

*# rozdělit stereo-stopu na FR a FL stopu/na dvě mono-stopy („pravou“ a „levou“)*<br>
**[**{*ai*}**] channelsplit=channels=FR\|FL [**{*ao*}**]<nic>[**{*ao*}**]**<br>
**[**{*ai*}**] asplit[**{*io1*}**]<nic>[**{*io2*}**];[**{*io1*}**] channelmap=FR-mono:mono [**{*ao*}**];[**{*io2*}**] channelmap=FL-mono:mono [**{*ao*}**]**

*# spojit FR a FL stopu/„pravou“ a „levou“ mono-stopu do jedné stereo-stopy*<br>
**[**{*ai*}**]<nic>[**{*ai*}**] amerge [**{*ao*}**]**<br>
**[**{*ai*}**]<nic>[**{*ai*}**] join=map=0.0-FR\|1.0-FL [**{*ao*}**]**

*# prohodit levý a pravý kanál stereo-stopy*<br>
**[**{*ai*}**] channelmap=FR-FL\|FL-FR [**{*ao*}**]**

<!--
*# přidat na konec několik vzorků ticha*<br>
**[**{*ai*}**] apad=pad_len=**{*počet-vzorků*} **[**{*ao*}**]**

*# doplnit na konec ticho pro dosažení minimálního počtu vzorků*<br>
**[**{*ai*}**] apad=whole_len=**{*min-počet-vzorků*} **[**{*ao*}**]**
-->

### Generátory a čtení „bokem“

*# bílý/jiný **šum***<br>
*// Amplituda se uvádí v rozsahu 0 až 1. Místo white lze použít také pink, brown, blue a violet.*<br>
**anoisesrc=c=white**[**:d=**{*trvání-v-s*}]<nic>[**:a=**{*amplituda*}]<nic>[**:r=**{*vzorkovací-frekvence*}] **[**{*ao*}**]**<br>
**anoisesrc=c=**{*druh-šumu*}[**:d=**{*trvání-v-s*}]<nic>[**:a=**{*amplituda*}]<nic>[**:r=**{*vzorkovací-frekvence*}] **[**{*ao*}**]**

*# **načíst ze souboru** obraz/zvuk/obraz i zvuk*<br>
**movie=**{*vstupní-soubor*} **[**{*vo*}**]**<br>
**amovie=**{*vstupní-soubor*} **[**{*ao*}**]**<br>
**movie=**{*vstupní-soubor*}**:s=dv+da [**{*vo*}**]<nic>[**{*ao*}**]**

*# **ticho***<br>
**anoisesrc=a=0**[**:d=**{*trvání-v-s*}]<nic>[**:r=**{*vzorkovací-frekvence*}]

*# **tón** o zadané frekvenci*<br>
*// V praxi může být nutno zvýšit výchozí hodnotu parametru „samples\_per\_frame“, ale nemám s tím zkušenosti. Amplituda generovaného signálu je 1/8.*<br>
**sine=f=**{*frekvence-v-Hz*}[**:d=**{*trvání-v-s*}]<nic>[**:r=**{*vzorkovací-frekvence*}]

*# černý/modrý/poloprůhledný zelený/zcela průhledný obraz*<br>
*// Nejsou-li zadány parametry „d“ a „r“, výstup generátoru bude nekonečný s fps 25.*<br>
**color=c=#000000:s=**{*šířka*}**x**{*výška*}[**:r=**{*fps*}]<nic>[**:d=**{*trvání-v-sekundách*}]<br>
**color=c=#0000FF:s=**{*šířka*}**x**{*výška*}[**:r=**{*fps*}]<nic>[**:d=**{*trvání-v-sekundách*}]<br>
**color=c=#00FF0080:s=**{*šířka*}**x**{*výška*}[**:r=**{*fps*}]<nic>[**:d=**{*trvání-v-sekundách*}]<br>
**color=c=#00000000:s=**{*šířka*}**x**{*výška*}[**:r=**{*fps*}]<nic>[**:d=**{*trvání-v-sekundách*}]

### Rozdělování a spojování

*# naklonovat videovstup/audiovstup na více shodných výstupů*<br>
**[**{*vi*}**] split=**{*počet-výstupů*} **[**{*vo*}**]**...<br>
**[**{*ai*}**] asplit=**{*počet-výstupů*} **[**{*ao*}**]**...

<!--
concat: vstupy se musejí shodovat v:
- rozlišení (lze upravit filtry jako pad, crop či scale)
- SAR (lze upravit setsar, např. setsar=1/1)
- počtu video/audio kanálů

pozor na PTS!
-->

*# spojit (za sebou) obrazové vstupy*<br>
**[**{*vi*}**]**... **concat=n=**{*počet vstupů*}**:v=1:a=0 [**{*vo*}**]**

*# spojit (za sebou) zvukové vstupy*<br>
**[**{*ai*}**]**... **concat=n=**{*počet vstupů*}**:v=0:a=1 [**{*ao*}**]**

*# spojit (za sebou) obrazové a zvukové vstupy*<br>
**[**{*vi*}**]<nic>[**{*ai*}**]<nic>[**{*vi*}**]<nic>[**{*ai*}**]**... **concat=n=**{*počet-dvojic-vstupů*}**:v=1:a=1 [**{*vo*}**]<nic>[**{*ao*}**]**

<!--
*# (nefunguje!!!!!!!!)přehrát úsek a opakovat ho ještě N-krát znovu (Je-li např. počet 2, úsek se celkem přehraje třikrát!)*<br>
**[**{*vi*}**] loop=**{*počet*}**:{*maximální-počet-snímků*} [**{*vo*}**] ; [**{*ai*}**] aloop=**{*počet*}**:{*maximální-počet-vzorků*} [**{*ao*}**]**<br>
**[**{*vi*}**] loop=**{*počet*}**:32767 [**{*vo*}**] ; [**{*ai*}**] aloop=**{*počet*}**:2147483647 [**{*ao*}**]**<br>
**[**{*vi*}**] loop=-1:32767 [**{*vo*}**] ; [**{*ai*}**] aloop=-1:2147483647 [**{*ao*}**]**
-->


### Ostatní filtry

*# pohltit obraz/zvuk bez výstupu*<br>
**[**{*vi*}**] nullsink**<br>
**[**{*ai*}**] anullsink**

*# ponechat obraz/zvuk beze změny*<br>
**[**{*vi*}**] copy [**{*vo*}**]**<br>
**[**{*ai*}**] acopy [**{*ao*}**]**

## Zaklínadla: Příkaz ffmpeg

Příkaz ffmpeg přijímá tři typy parametrů: globální, vstupní a výstupní.
Globální parametry platí pro danou instanci ffmpegu jako celek.
Vstupní parametry se zadávají v sekvenci ukončené parametrem **-i**
a vstupním souborem a platí pouze pro daný vstup.
Výstupní parametry se zadávají v sekvenci ukončené výstupním souborem
a platí pouze pro daný výstup.

&nbsp;

*# obecný tvar příkazu ffmpeg*<br>
**ffmpeg** {*globální parametry*} [{*vstupní parametry*} **-i** {*vstup*}]... [{*výstupní parametry*}] {*první-výstup*} [[{*výstupní parametry*}] {*další-výstup*}]...

### Globální parametry
*# nastavit **graf filtrů**/načíst ho ze souboru*<br>
*// Některá zaklínadla v této kapitole používají vložené příkazy bashe pomocí syntaxe „'"$(příkaz)"'“; tyto konstrukce budou v dané podobě fungovat jen na příkazové řádce.*<br>
**\-filter\_complex '**{*graf filtrů*}**'**<br>
**\-filter\_complex\_script** {*soubor*}

*# existující výstupní soubor přepsat bez ptaní/nepřepsat a skončit s chybou*<br>
**\-y**<br>
**\-n**

*# vypnout interakci ffmpegu s uživatelem (vhodné při použití ve skriptu)*<br>
**\-nostdin**

### Výstupní parametry
*# pro obrazové stopy: nastavit kodek/nepřekódovávat/zakázat výstup*<br>
*// Doporučené kodeky: „h264“ (synonymum „libx264“), „mpeg4“ (starší), „rawvideo“ (opatrně). Další použitelné kodeky: „gif“. Při generování série obrázků: „png“, „tiff“, „mjpeg“.*<br>
**\-c:v** {*kodek*}<br>
**\-c:v copy**<br>
**\-vn**

*# pro zvukové stopy: nastavit kodek/nepřekódovávat/zakázat výstup*<br>
*// Doporučené kodeky podle formátu: „aac“ (pro mp4), „libmp3lame“ (pro mp3, ale i mp4), „pcm16\_le“ (pro wav), „libvorbis“ (pro ogg), „flac“ (pro flac).*<br>
**\-c:a** {*kodek*}<br>
**\-c:a copy**<br>
**\-an**

*# nastavit bitrate obrazových stop/zvukových stop*<br>
*// Možno použít přípony, např. 128k či 5M.*<br>
**\-vb** {*bitrate*}<br>
**\-ab** {*bitrate*}

*# oříznout časovou osu (alternativy)*<br>
[**\-ss** {*začátek*}\] <nic>[**-to** {*konec*}]<br>
[**\-ss** {*začátek*}\] <nic>[**-t** {*trvání-v-sekundách*}]

*# nastavit jednoduchý graf filtrů pro obrazovou stopu/zvukovou stopu*<br>
**\-vf '**{*jednoduchý graf filtrů*}**'**<br>
**\-af '**{*jednoduchý graf filtrů*}**'**

*# vynutit konstantní fps obrazové stopy*<br>
**\-r**[**:**{*číslo-stopy*}] {*fps*}

*# nastavit jednoduchý graf filtrů pro obraz/pro zvuk*<br>
**-vf '**{*jednoduchý-graf-filtrů*}**'**<br>
**-af '**{*jednoduchý-graf-filtrů*}**'**

*# vynutit poměr stran videa obrazové stopy*<br>
*// Doporučené hodnoty: 4:3, 16:9, 1:1, 5:4, 16:10*<br>
**\-aspect**[**:**{*číslo-stopy*}] {*hodnota*}

*# konverze zvukové stopy na stereo/na mono*<br>
**\-ac**[**:**{*číslo-stopy*}] **2**<br>
**\-ac**[**:**{*číslo-stopy*}] **1**

*# zakázat výstup titulkových stop/datových stop*<br>
**\-sn**<br>
**\-dn**

*# vynutit vzorkovací frekvenci zvuku (v Hz, obvykle 44100, ale také 22050 či 48000)*<br>
*// Doporučená hodnota: 44100; další obvyklé: 22050, 48000.*<br>
**\-ar**[**:**{*číslo-stopy*}] {*frekvence*}

### Vstupní parametry

*# oříznout časovou osu vstupního videa/nahrávky*<br>
[**\-ss** {*začátek-s*}] <nic>[**-t** {*maximální-trvání-s*}] **-i** {*vstup*}

*# načíst statický obrázek (jpg,png,bmp,tif,...) jako nekonečné video (pozor – ne gif!)*<br>
**\-loop 1 -i** {*obrázek*}
<!-- Pro gif prý -ignore_loop 0, ale vykoná cyklus jen podle hlavičky gifu. -->

*# složit obrazovou stopu z obrázků*<br>
**\-framerate** {*počet-snímků-za-sekundu*} **-i** {*předpona*}**%05d.**{*přípona*}


### Celé příkazy

*# **konvertovat** video a zvuk z jednoho formátu na druhý*<br>
*// Uvedený parametr „-qscale“ se pokusí zachovat kvalitu vstupního souboru.*<br>
**ffmpeg -i** {*vstupní-soubor.přípona*} **-qscale:0 0** [**-qscale:1 0**] {*výstupní soubor.přípona*}

*# **spojit** za sebou soubory*<br>
*// Názvy souborů při volání tímto způsobem nesmějí obsahovat apostrof. Při spojování tímto způsobem nedochází k překódování, takže vstupní soubory si musejí velmi přesně odpovídat všemi parametry, jinak hrozí problémy při přehrávání.*<br>
**ffmpeg -f concat -safe 0 -i &lt;(for x in** {*soubor*}...**; do realpath -ze \-\- "$x"; done \| sed -zE $'/^\\\\x2f/!d;s/\\x27/&amp;\\\\x5c&amp;&amp;/g;s/.\*/file&blank;\\x27&amp;\\x27/' \| tr \\\\0 \\\\n) -c copy** {*výstup*}
<!-- \x27 = '  \x2f = /  \x5c = \ -->
<!--
/^\\x2f/!d; -- vypustit záznamy, které nezačínají "/" (= nejsou platná absolutní cesta)
s/\\x27/&amp;\\\\x5c&amp;&amp;/g; -- všechny ' nahradit za '\''
s/.\*/file&blank;\\x27&amp;\\x27/' -- obalit záznamy do file '*'
-->

*# rozložit **video na obrázky** ve formátu podle výstupní přípony: JPEG (jpg), PNG (png), BMP (bmp), TIFF (tif)*<br>
**ffmpeg -i** {*video.přípona*} **-r** {*počet-snímků-za-sekundu*} **-f image2 -q:v 0** {*obrázek*}**-%05d.**{*výstupní-přípona*}

*# vygenerovat sekvenci **zmenšených náhledů** z videa (šířka max. 640 pixelů), přibližně pro každou minutu*<br>
*// Časování je u tohoto příkazu velmi přibližné, proto se hodí spíše na dlouhá videa, kde posun o půl minuty či minutu nebude vadit.*<br>
**ffmpeg -i** {*video*} **-r 1/60 -q:v 14 -vf 'scale=min(640\\,iw):-1' nahled%05d.jpg**

## Zaklínadla: Ostatní příkazy

*# analyzovat soubor (ukáže stopy a jejich parametry)*<br>
**ffprobe** {*vstupní-soubor*}

*# vypnout úvodní banner s verzí a konfigurací pro ffmpeg/ffprobe (jen pro interaktivní bash)*<br>
**alias ffmpeg="ffmpeg -hide\_banner"**<br>
**alias ffprobe="ffprobe -hide\_banner"**

*# vypnout úvodní banner s verzí a konfigurací pro ffmpeg/ffprobe*<br>
**ffmpeg() { command ffmpeg -hide\_banner "$@";}**<br>
**ffprobe() { command ffprobe -hide\_banner "$@";}"**

## Parametry příkazů

Parametry příkazů a způsob volání ffmpegu jsou uvedeny v sekci „Zaklínadla: Příkaz ffmpeg“.

## Instalace na Ubuntu

*# *<br>
**sudo apt-get install ffmpeg** [**libavcodec-extra chromium-codecs-ffmpeg-extra**]

Poznámka: ačkoliv jsou kodeky v balíčku chromium-codecs-ffmpeg-extra svobodné,
mohou být omezeny patentovou ochranou podporovaných formátů. Pokud vám to vadí,
použijte místo „chromium-codecs-ffmpeg-extra“ jen „chromium-codecs-ffmpeg“.

## Ukázka

Ukázka vyžaduje, abyste v aktuálním adresáři měl/a video „video.mp4“ a to mělo alespoň 30 sekund, obraz (šířku i výšku alespoň 300 pixelů) a zvuk. První uvedený příkaz vypíše parametry videa. Druhý video zmenší na polovinu, vynechá zvuk a vlevo od obrazu umístí jeho černobílou kopii. Třetí příkaz obraz otočí o 180° a vymění dvě obdelníkové oblasti videa; současně do zvuku přidá roztmívačku a dvojnásobnou ozvěnu.

*# *<br>
**ffprobe video.mp4**<br>
**ffmpeg -nostdin -filter\_complex '[0:v]scale=2\*trunc(iw/4):2\*trunc(ih/4),split[a]<nic>[b];[a]hue=s=0[a2];[a2]<nic>[b]hstack[vv]' -i video.mp4 -c:v h264 -b:v 2048k -an -map '[vv]' bez-zvuku.mp4**<br>
**ffmpeg -nostdin -hide\_banner -filter\_complex '[0:v]hflip,vflip,swaprect=100:150:10:15:200:50[vv];[0:a]afade=in:st=1:d=5:curve=exp,aecho=0.6:0.3:250|500:0.8|0.6[av]' -i video.mp4 -c:v h264 -b:v 2048k -c:a libmp3lame -b:a 64k -map '[vv]' -map '[av]' -to 20 hratky.mp4**

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Pokud obraz či zvuk neupravujete a nekonvertujete, můžete jejich původní kvalitu a kodek zachovat zákazem překódování pomocí parametru **-c:v copy** pro obraz, resp. **-c:a copy** pro zvuk. Zvuk můžete v takovém případě ořezávat pomocí výstupních parametrů **-ss**, **-to** a **-t**, u obrazu to silně nedoporučuji, protože pak typicky trpí výpadky na začátku a konci výsledného videa.
* Většina kodeků odmítne zapsat video, jehož šířka či výška v pixelech je lichá; myslete na to při používání filtru **-scale**.
* Výstupy filtrů **split** a **asplit** musejí být odebírány paralelně, jinak hrozí přetečení bufferu. Řadě problémů se lze vyhnout tím, že místo rozdělení vstupu na dva načtete tentýž vstupní soubor vícekrát (více parametry **-i**). Rychlým (ale škaredým a nebezpečným) řešením problémů někdy může být zneužití filtrů „reverse“ a „areverse“, které dokážou v paměti zřídit buffer neomezené velikosti (resp. velikosti omezené jen množstvím dostupné paměti).
* Můžete-li téhož efektu dosáhnout pomocí filtru nebo pomocí výstupního parametru, preferujte parametr; dává jistější výsledky, možná i kvalitnější.
* Pokud použijete kodek „mjpeg“ a vypisuje vám varování „deprecated pixel format used, make sure you did set range correctly“, toto můžete bezpečně ignorovat.
<!--
Zdroj: https://superuser.com/questions/1273920/deprecated-pixel-format-used-make-sure-you-did-set-range-correctly
-->
* Při zapékání titulků se ujistěte, že soubor s titulky je v kódování UTF-8 (což často nebývá). Titulky, které nepůjde tímto kódováním znaků dekódovat, filtr „subtitles“ bez varování vynechá!
* Ačkoliv parametr „-filter\_complex“ jako globální parametr správně patří na začátek příkazu, jeho uvedení tam je nepraktické a dle mých zkušeností ho ffmpeg správně přijme, i když ho uvedete až před parametry „-map“.
* Kromě datových stop mohou být součástí multimediálního souboru i metadata, která se automaticky zkopírují do výstupního souboru a nepodařilo se mi přijít na způsob, jak se jich snadno zbavit.

<!--
Podle https://superuser.com/questions/435941/which-codecs-are-most-suitable-for-playback-with-windows-media-player-on-windows
- přidat **-pix_fmt yuv420p** má umožnit přehrání videa v microsoftích přehravačích
-->

## Další zdroje informací
*# *<br>
**man ffmpeg**<br>
**man ffmpeg-filters**

<neodsadit>Dalším velmi dobrým zdrojem je oficiální dokumentace k filtrům, ke které se dostanete tak, že si nainstalujete balíček „ffmpeg-doc“ a v prohlížeči otevřete soubor „/usr/share/doc/ffmpeg/manual/ffmpeg-filters.html“.

* [Ffmprovisr](https://amiaopensource.github.io/ffmprovisr/) (anglicky)
* [FFmpeg Wiki](https://trac.ffmpeg.org/) (anglicky)
* [Dokumentace k filtrům](https://ffmpeg.org/ffmpeg-filters.html) (anglicky)
* [Manuálová stránka ffmpeg](http://manpages.ubuntu.com/manpages/focal/en/man1/ffmpeg.1.html) (anglicky)
* [Manuálová stránka ffmpeg-filters](http://manpages.ubuntu.com/manpages/focal/en/man1/ffmpeg-filters.1.html) (anglicky)
* [Playlist videí: FFMPEG &amp; Command Line](https://www.youtube.com/playlist?list=PLJse9iV6Reqiy8wP0rXTgFQkMNutRMN0j) (anglicky)
* [Oficiální stránky](https://ffmpeg.org/) (anglicky)

!ÚzkýRežim: vyp
