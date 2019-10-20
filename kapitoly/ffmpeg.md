<!--

Linux Kniha kouzel, kapitola FFmpeg
Copyright (c) 2019 Singularis <singularis@volny.cz>

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
-->
# FFmpeg

## Úvod
FFmpeg je nástroj pro konverzi, úpravu a streamování videa, zvuku a titulků.
Hlavní výhodou FFmpegu oproti videoeditorům s grafickým uživatelským rozhraním
je modularita a opakovatelnost zpracování pro různé vstupní soubory.

Základním nástrojem pro zpracování multimediálních souborů je tzv. filtr grafů (filtergraph),
který definujete pomocí parametru **-filter\_complex** (resp. **-filter\_complex\_script**),
případně zjednodušeně pomocí parametrů **-vf** a **-af**.

## Definice
* **Stopa** je časovaná složka multimediálního souboru proložená v čase s ostatními stopami
téhož souboru. Stopy v jednom souboru mohou být různého typu (obrazová, zvuková,
titulková či datová) a mohou mít různou délku.

* **Kanál** (plane/channel) je datová vrstva tvořící stopu s ostatními kanály. Kanály stopy
trvají vždy stejně dlouho a tvoří každý snímek obrazu či vzorek zvuku společně. Obrazová stopa
se typicky dělí na kanály Y (svítivost), U a V (barva), případně ještě alfa (krytí); zvuková
stopa mívá buď jeden kanál (mono), nebo pravý a levý kanál (stereo); titulková stopa má
obvykle pouze jeden kanál. (Titulky v různých jazycích se řeší přidáním více titulkových stop.)

* **Snímek** je základní kvantum obrazové stopy. Vzorkovací frekvence videa čili počet snímků
za sekundu se nazývá **fps**. Hodnota fps se obvykle pohybuje v rozmezí 10 až 60.

* **Vzorek** je základní kvantum zvukové stopy. Obvyklá vzorkovací frekvence zvuku je 44 100
vzorků za sekundu.

* **Filtr** je objekt v grafu filtrů, který očekává určitý počet vstupů určitého typu v určitém pořadí (toto očekávání se může lišit v závislosti na parametrech). Na tyto vstupy je pak potřeba připojit buď stopy vstupů ffmpegu (typicky vstupních souborů) nebo výstupy jiných filtrů. Filtr mívá také výstupy, které je pak nutno připojit na vstupy jiných filtrů nebo na stopy výstupů ffmpegu. Filtry v grafu filtrů pojmenované nejsou, ale propojení mezi jejich výstupy a vstupy ano.

* **Graf filtrů** je orientovaný graf definovaný uživatelem, který popisuje tok dat různého typu přes ffmpeg ze vstupů na výstupy.

## Zaklínadla (filtry)
### Úprava časové osy

*# zrychlení 2×/4×/5×/16×*<br>
*// Důvodem k rozdílné implementaci je, že filtr „atempo“ akceptuje parametr pouze v rozsahu 0.5 až 2.0; vyšších, resp. nižších hodnot je možno dosáhnout zřetězením více těchto filtrů.*<br>
**[vi] setpts=PTS/2 [vo] ; [ai] atempo=2 [ao]**<br>
**[vi] setpts=PTS/4 [vo] ; [ai] atempo=2,atempo=2 [ao]**<br>
**[vi] setpts=PTS/5 [vo] ; [ai] atempo=2,atempo=2,atempo=5/4 [ao]**<br>
**[vi] setpts=PTS/16 [vo] ; [ai] atempo=2,atempo=2,atempo=2,atempo=2 [ao]**

*# zpomalení 2×/4×/5×/16×*<br>
**[vi] setpts=2.0\*PTS [vo] ; [ai] atempo=1/2 [ao]**<br>
**[vi] setpts=4.0\*PTS [vo] ; [ai] atempo=1/2,atempo=1/2 [ao]**<br>
**[vi] setpts=5.0\*PTS [vo] ; [ai] atempo=1/2,atempo=1/2,atempo=4/5 [ao]**<br>
**[vi] setpts=16.0\*PTS [vo] ; [ai] atempo=1/2,atempo=1/2,atempo=1/2,atempo=1/2 [ao]**

*# vyříznout časový úsek (údaje v sekundách)(alternativy)*<br>
**[vi] trim=**{*začátek*}**:**{*konec*}**,setpts=PTS-STARTPTS [vo] ; [ai] atrim=**{*začátek*}**:**{*konec*}**,asetpts=PTS-STARTPTS [ao]**<br>
**[vi] trim=start=**{*začátek*}**:duration=**{*trvání*} **[vo] ; [ai] atrim=start=**{*začátek*}**:duration=**{*trvání*}**,asetpts=PTS-STARTPTS [ao]**

*# vyříznout časový úsek (údaje ve snímcích)(alternativy)*<br>
**[vi] trim=start\_frame=**{*index-prvního-zahrnutého-snímku*}**:**{*index-snímku-za-koncem*}**,setpts=PTS-STARTPTS [vo]**<br>
**[ai] atrim=start\_sample=**{*index-prvního-zahrnutého-vzorku*}**:**{*index-vzorku-za-koncem*}**,asetpts=PTS-STARTPTS [ao]**

*# obrátit celou stopu*<br>
*// Pozor! Filtr reverse musí celé video nekomprimované uložit do paměti. Pro zpracování dlouhého videa tedy doporučuji dočasně zapnout opravdu velký swapovací soubor, nebo video obracet po částech.*<br>
**[vi] reverse [vo]; [ai] areverse [ao]**

*# opakovat celý (krátký) obrazový/zvukový vstup po zadaný počet sekund*<br>
*// Na vstupu vezme maximálně 32 767 snímků a max. 2 147 483 647 zvukových vzorků, což obvykle odpovídá cca 21,8 minut obrazu a 13,5 hodině zvuku.*<br>
**[vi] setpts=PTS-STARTPTS,loop=-1:32767,trim=0:**{*cílový-počet-sekund*}** [vo]**<br>
**[ai] asetpts=PTS-STARTPTS,aloop=-1:2147483647,atrim=0:**{*cílový-počet-sekund*}** [ao]**

*# opakovat vyříznutou část obrazového/zvukového vstupu po zadaný počet sekund*<br>
**[vi] trim=**{*začátek*}**:**{*konec*}**,setpts=PTS-STARTPTS,loop=-1:32767,trim=0:**{*cílový-počet-sekund*}** [vo]**<br>
**[ai] atrim=**{*začátek*}**:**{*konec*}**,asetpts=PTS-STARTPTS,aloop=-1:2147483647,atrim=0:**{*cílový-počet-sekund*}** [ao]**

*# zpomalit obraz 10× s interpolací pohybu/zpomalit zvuk 10×*<br>
*// Poznámka: filtr „minterpolate“ je neparalelizovatelný a může být velmi pomalý.*<br>
**[vi] setpts=10.0\*PTS,minterpolate=fps=25**[**:mi\_mode=**{*blend-nebo-dup*}] **[vo]**<br>
**[ai] atempo=1/2,atempo=1/2,atempo=1/2,atempo=8/10 [ai]**

### Škálování obrazu (resize)

*# změna rozlišení (roztažení, smrsknutí, škálování)(pro většinu kodeků musejí být hodnoty šířka a výška sudé!)*<br>
**[vi] scale=**{*šířka*}**:**{*výška*} **[vo]**

*# změnit šířku i výšku na polovinu a zajistit, aby oba rozměry byly sudé*<br>
**[vi] scale=2\*trunc(iw/4):2\*trunc(ih/4) [vo]**

*# zvětšit šířku i výšku s interpolací pro pixel-art na dvojnásobek/dvojnásobek/trojnásobek/čtyřnásobek*<br>
**[vi] super2xsai [vo]**<br>
**[vi] xbr=2 [vo]**<br>
**[vi] xbr=3 [vo]**<br>
**[vi] xbr=4 [vo]**

### Transformace a oříznutí obrazu

*# nadstavení obrazu (padding)(barva=#RRGGBB[AA] jako v HTML) *<br>
**[vi] pad=**{*šířka*}**:**{*výška*}**:**{*posun-x-zleva*}**:**{*posun-y-shora*}[**:**{*barva*}] **[vo]**

*# vyříznutí obrazu/oříznutí okrajů (cropping)*<br>
**[vi] crop=**{*šířka*}**:**{*výška*}**:**{*posun-x-zleva*}**:**{*posun-y-shora*} **[vo]**<br>
**[vi] crop=iw-**{*zleva*}**-**{*zprava*}**:ih-**{*shora*}**-**{*zespodu*}**:**{*zleva*}**:**{*shora*} **[vo]**

*# převrátit obraz (horizontálně/vertikálně)*<br>
**[vi] hflip [vo]**<br>
**[vi] vflip [vo]**

*# otočit obraz o +90° (o 90° proti směru hodinových ručiček)*<br>
**[vi] transpose=2 [vo]**

*# otočit obraz o 180°*<br>
**[vi] hflip,vflip [vo]**

*# otočit obraz o -90° (o 90° po směru hodinových ručiček)*<br>
**[vi] transpose=1 [vo]**

*# otočit obraz o obecný úhel (ve stupních) proti/po směru hodinových ručiček*<br>
**[vi] rotate=**{*úhel*}**\*(-PI/180)**[**:**{*výsl-šířka*}**:**{*výsl-výška*}][**:c=**{*barva-pozadí-nebo-none*}] **[vo]**<br>
**[vi] rotate=**{*úhel*}**\*(PI/180)**[**:**{*výsl-šířka*}**:**{*výsl-výška*}][**:c=**{*barva-pozadí-nebo-none*}] **[vo]**

*# otočit obraz o obecný úhel (ve stupních) proti směru hodinových ručiček a zvětšit rozlišení na obdelník opsaný otočenému snímku; nevyplněné rohy ponechat průhledné*<br>
**[vi] rotate=**{*úhel*}**\*(-PI/180):rotw(**{*úhel*}**\*(-PI/180)):roth(**{*úhel*}**\*(-PI/180)):c=none [vo]**

*# opravit perspektivu ze zadaných souřadnic (vLevo, vpRavo, Nahoře, Dole)*<br>
**[vi] perspective=**{*LNx*}**:**{*LNy*}**:**{*RNx*}**:**{*RNy*}**:**{*LDx*}**:**{*LDy*}**:**{*RDx*}**:**{*RDy*}[**:sense=destination**][**:interpolation=cubic**] **[vo]**

*# vyměnit dvě obdelníkové oblasti ve videu*<br>
*// Všechny hodnoty mohou používat rozměry snímku (w, h), čas v sekundách (t) a sekvenční číslo snímku (n).*<br>
**[vi] swaprect=**{*šířka-oblastí*}**:**{*výška-oblastí*}**:**{*x1*}**:**{*y1*}**:**{*x2*}**:**{*y2*} **[vo]**

### Překryv, skládání a prolínání obrazových stop (blend)

*# naskládat videa stejné výšky vedle sebe/videa stejné šířky pod sebe*<br>
*// Všechny použité vstupy musejí mít kromě stejné výšky/šířky také stejný formát pixelu (pixel-format).*<br>
**[vi]**... **hstack=inputs=**{*počet-vstupů*}[**:shortest=1**] **[vo]**
**[vi]**... **vstack=inputs=**{*počet-vstupů*}[**:shortest=1**] **[vo]**

*# prolnout několik vstupů*<br>
*// Všechny vstupy musejí mít stejné rozměry. Toto lze docílit vhodným předzpracováním.*<br>
**[vi]**... **mix=nb\_inputs=**{*počet-vstupů*}**:weights=**{*váhy oddělené mezerami*}[**:duration=**{*longest-shortest-nebo-first*}] **[vo]**

*# překrýt jeden videovstup druhým; po skončení překryvného vstupu: ho skrýt/ukončit výstup/zamrznout překryvný vstup na jeho posledním snímku*<br>
*// Hodnoty posunu jsou výrazy s výsledkem v pixelech. Mohou používat: rozměry hlavního videa (W, H), rozměry překryvného videa (w, h), čas v sekundách (t) a sekvenční číslo snímku (n). Poznámka: výstup filtru overlay není nikdy delší než délka jeho hlavního (prvního) vstupu.*<br>
**[vi][vi] overlay=x=**{*posun-x*}**:y=**{*posun-y*}**:eof\_action=pass [vo]**<br>
**[vi][vi] overlay=x=**{*posun-x*}**:y=**{*posun-y*}**:eof\_action=endall [vo]**<br>
**[vi][vi] overlay=x=**{*posun-x*}**:y=**{*posun-y*}**:eof\_action=repeat [vo]**

*# prolnout jeden a druhý videovstup (obecně/konkrétně)*<br>
*// Ve výrazu můžete použít hodnoty: sekvenční číslo snímku (N), souřadnice pixelu ((X/SW), (Y/SW)), šířka a výška ((W/SW), (H/SW)), čas v sekundách (T) a především hodnotu složky prvního vstupu (A) a druhého vstupu (B).*<br>
**[vi][vi] blend=all\_expr=**{*výraz*}[**:eof\_action=**]{*repeat-endall-nebo-pass*} **[vo]**<br>
**[prvni][druhy] blend=all\_expr=if(eq(mod(Y\\,2)\\,0)\\,A\\,B):eof\_action=endall [vysledek]**

### Jas, kontrast, barva a spol.
<!--
[ ] Úkol: Prozkoumat rozdíl mezi „eq“ a „hue“.
-->

*# odbarvit obrázek na stupně šedi*<br>
**[vi] hue=s=0 [vo]**

*# invertovat barvy/barvy a alfa-kanál*<br>
**[vi] negate [vo]**<br>
**[vi] negate=negate\_alpha=1 [vo]**

*# efekt „sépie“*<br>
?

*# nastavit kontrast (rozsah -2.0 až 2.0; neutrální hodnota 1.0)*<br>
*// Záporné hodnoty vyústí v inverzní obraz.*<br>
**[vi] eq=contrast=**{*hodnota*}[**:eval=frame**] **[vo]**

*# nastavit jas (rozsah -1.0 až 1.0; neutrální hodnota 0.0)*<br>
**[vi] eq=brightness=**{*hodnota*}[**:eval=frame**] **[vo]**

*# nastavit saturaci (rozsah 0.0 až 3.0; neutrální hodnota 1.0*<br>
**[vi] eq=saturation=**{*hodnota*}[**:eval=frame**] **[vo]**

*# nastavit gama-korekci (rozsah 0.1 až 10.; neutrální hodnota 1.0)*<br>
**[vi] eq=gamma=**{*hodnota*}[**:eval=frame**] **[vo]**

*# nastavit kontrast, jas, saturaci a gama korekci současně*<br>
**[vi] eq=contrast=**{*kontrast*}**:brightness=**{*jas*}**:saturation=**{*saturace*}**:gamma=**{*gama*}[**:eval=frame**] **[vo]**

*# rozmazat obraz (normálně/maximálně/minimálně/obecně)*<br>
**[vi] gblur=2 [vo]**<br>
**[vi] gblur=1024 [vo]**<br>
**[vi] gblur=0 [vo]**<br>
**[vi] gblur=**{*sigma*} **[vo]**

*# zašumět obraz proměnným RGB-šumem*<br>
*// Přípustné hodnoty parametry allf jsou a, p, t, u a jejich kombinace operátorem +; při letmém vyzkoušení se mi jevily použitelné jen varianty „t“ a „t+u“ (jemnější).*<br>
**[vi] noise=alls=**{*síla-šumu-0-az-100*}**:allf=t**

*# ztmavit/zesvětlit okraje snímku (efekt vignette)*<br>
*// Úhel čočky je v rozsahu 0 (žádný účinek) až PI/2 (maximální účinek). Pro vyhodnocování výrazů pro každý snímek musíte přidat parametr „eval=frame“. Mód *<br>
**[vi] vignette=a=**{*úhel-čočky*}[**:x0=**{*x-středu*}**:y0=**{*y-středu*}][**:eval=frame**] **[vo]**<br>
**[vi] vignette=mode=backward:a=**{*úhel-čočky*}[**:x0=**{*x-středu*}**:y0=**{*y-středu*}][**:eval=frame**] **[vo]**

### Zapékání titulků

*# zapéci titulky do obrazu (normálně)*<br>
**[vi] subtitles=**{*soubor-s-titulky*} **[vo]**

*# zapéci titulky do obrazu (obecně/podtrženým červeným písmem Arial velikosti 48)*<br>
*// Nastavení stylu jsou ve formátu ASS, přičemž znaky = a , musíte escapovat kvůli ffmpegu.*<br>
**[vi] subtitles=**{*soubor-s-titulky*}[**:force\_style=**{*nastavení-stylu*}] **[vo]**<br>
**[vi] subtitles=**{*soubor-s-titulky*}**:force\_style=FontName\\=Arial\\,Fontsize\\=48\\,PrimaryColour\\=&amp;H000000FF\\,Underline\\=1 [vo]**

<!--
Barvy se zadávají ve formátu AABBGGRR, kde AA=FF je úplná průhlednost a AA=00 úplná neprůhlednost.
-->

### Roztmívačky, zatmívačky a další přechody (obrazu i zvuku)

*# vložit roztmívačku/zatmívačku*<br>
*// všechny snímky před začátkem roztmívačky a za koncem zatmívačky budou nastaveny na uvedenou barvu*
**[vi] fade=t=in:st=**{*začátek*}**:d=**{*trvání*}[**:c=**{*barva*}][**:alpha=1**] **[vo]**<br>
**[vi] fade=t=out:st=**{*začátek*}**:d=**{*trvání*}[**:c=**{*barva*}][**:alpha=1**] **[vo]**

*# roztmívačka/zatmívačka saturace*<br>
*// Čas začátku a trvání efektu jsou v sekundách.*<br>
**[vi] hue=s=max(0\\,min(1\\,(t - **{*čas-začátku*}**)/**{*trvání-efektu*}**)) [vo]**<br>
**[vi] hue=s=max(0\\,min(1\\,(**{*čas-začátku*} **- t)/**{*trvání-efektu*}**)) [vo]**

*# spojit za sebe dva vstupy a prolnout sedmisekundovou prolínačkou (konkrétně/obecně)*<br>
**[ai][ai] acrossfade=d=7:c1=exp:c2=exp [ao]**<br>
**[ai][ai] acrossfade=d=**{*trvání-prolínačky*}**:c1=**{*funkce-zatmívačky*}**:c2=**{*funkce-roztmívačky*} **[ao]**<br>

*# aplikovat zvukovou zatmívačku/roztmívačku*<br>
*// Podporované tvary jsou: tri, qsin, hsin, esin, log, ipar, qua, cub, squ, cbr, par, exp, iqsin, ihsin, dese. Poznámka: Veškerý zvuk po konci zatmívačky, resp. začátkem roztmívačky bude tímto filtrem nahrazen tichem.*<br>
**[ai] afade=out:st=**{*čas-začátku*}**:d=**{*trvání-v-s*}**:curve=**{*tvar*} **[ao]**<br>
**[ai] afade=in:st=**{*čas-začátku*}**:d=**{*trvání-v-s*}**:curve=**{*tvar*} **[ao]**

### Retušování (zvuku)

*# zakrýt/odstranit logo nebo jiný rušivý element z obrazu*<br>
**[vi] delogo=x=**{*posun-x-zleva*}**:y=**{*posun-y-shora*}**:w=**{*šířka*}**:h=**{*výška*} **[vo]**

*# zneviditelnit předmět na určité pozici*<br>
*// Mapa by měla mít stejný rozměr jako video a musí obsahovat bílé pixely na pozicích, kde je na videu předmět k odstranění, a černé pixely na místech, která se nemají změnit. Tento filtr je pro oblasti výpočetně náročný, proto by měla být drtivá většina pixelů mapy zcela černá.*<br>
**[vi] removelogo=**{*obrázek-s-mapou.png*} **[vo]**

### Vykreslování do videa
*# obdelník*<br>
*// invert=invertující rámeček; fill=vyplněný obdelník*<br>
**[vi] drawbox=**{*posun-x-zleva*}**:**{*posun-y-shora*}**:**{*šířka*}**:**{*výška*}**:**{*barva-nebo-invert*}[**@**{*krytí-0-až-1*}][**:**{*tloušťka-nebo-fill*}]

### Ostatní
*# odstranit prokládání*<br>
*// Odstranění prokládání zvýší fps na dvojnásobek. Existuje na ně i mnoho dalších filtrů.*<br>
**[vi] yadif [vo]**

*# proložit obraz*<br>
*// Prokláďání obrazu sníží fps na polovinu.*<br>
**[vi] interlace [vo]**

*# aplikovat na obraz Sobelův operátor detekce hran*<br>
**[vi] sobel [vo]**

*# rozdělit snímky po dávkách a každou dávku vykreslit po řádcích do mřížky daných rozměrů*<br>
**[vi] tile=**{*počet-sloupců-mřížky*}**x**{*počet-řádků-mřížky*}[**:margin=**{*šířka-okraje*}][**:padding=**{*rozestup-mřížky*}][**:color=**{*barva-pozadí*}][**:nb\_frames=**{*velikost-dávky*}] **[vo]**

### Nízkoúrovňové manipulace
*# aplikovat výraz po pixelech*<br>
*// Ve výrazu můžete použít proměnné: čas snímku v sekundách (T), sekvenční číslo snímku (N), souřadnice výstupního pixelu (X, Y), rozměry snímku (W, H); a funkce r(), g(), b() a a(), které přijímají parametry (x, y) a načtou odpovídající složku z pixelu původního snímku na uvedených souřadnicích. Pro souřadnice mimo rozsah vrací 0.*<br>
**[vi] geq=r=**{*výraz-red*}**:g=**{*výraz-green*}**:b=**{*výraz-blue*}[**:a=**{*výraz-alfa*}] **[vo]**
<!--
TODO: [ ] Vyzkoušet rozsah složky A. (Ostatní: 0..255.)
-->

*# sestavit každý nový snímek z pixelů původního*<br>
*// Souřadnice mimo rozsah (?)*<br>
**[vi] geq=p(**{*výraz-x*}**\\,**{*výraz-y*}**) [vo]**

*# oříznout hodnoty složek obrazu*<br>
**[vi] limiter=**[**min=**{*minimum*}][**:max=**{*maximum*}] **[vo]**
<!--
Úkol: [ ]Nevím, zda se aplikuje i na alfa-kanál.
-->

*# aplikovat na zvukové vzorky obecný výraz*<br>
*// Ve výrazu můžeme použít: hodnotu pravé/levé stopy (val(0)/val(1)), čas vzorku v sekundách (t), číslo vzorku (n), číslo kanálu (ch), původní počet kanálů (nb\_in\_channels), vzorkovací frekvenci (s).*<br>
**[ai] aeval=**{*výraz*}[**|**{*výraz-pro-druhý-kanál*}]**:c=same [ao]**

*# vynásobit vzorky dvou vstupů*<br>
**[ai][ai] amultiply [ao]**

*# nastavit novou vzorkovací frekvenci bez ovlivnění vzorků*<br>
**[ai] asetrate=**{*nová-frekvence*} **[ao]**


### Manipulace po snímcích

*# prohazovat a zahazovat snímky podle zadaného klíče*<br>
*// Filtr načte do vstupního bufferu tolik snímků ze vstupu, kolik jste zadali indexů. Následně na výstup vybírá snímky z bufferu podle indexů, které jste uvedli. Indexy se mohou opakovat a lze uvést speciální index -1, který způsobí vynechání snímku na výstupu (zahození).*<br>
**[vi] shuffleframes=**{*indexy dělené mezerami*} **[vo]**

*# náhodně prohazovat snímky v čase (snímky se do bufferu vkládají sekvenčně a vybírají v náhodném pořadí)*<br>
*// Velikost bufferu musí být v rozmezí 2 až 512 (výchozí hodnota je 30); snímky se do bufferu vkládají sekvenčně a vybírají se v náhodném pořadí.*<br>
**[vi] random=**{*velikost-bufferu*}

*# z každé dávky snímků vybrat ten nejreprezentativnější a ten roztáhnout na celou délku dávky*<br>
*// Má velké paměťové nároky, nepoužívat pro velký počet snímků; rozumný je tak maximálně 1000.*<br>
**[vi] thumbnail=**{*počet-snímků-na-dávku*} **[vo]**

### Základní úprava zvuku

*# změnit hlasitost (snížit na desetinu/zvýšit na pětinásobek)*<br>
**[ai] volume=0.1 [ao]**<br>
**[ai] volume=5.0 [ao]**

*# přidat ozvěnu*<br>
*// Hlasitost ozvěny je v rozsahu 0 až 1.0 a nesmí být 0. Filtr mírně sníží hlasitost původních zvuků, je potřeba ji vyladit.*<br>
**[ai] aecho=0.6:0.3:**{*ms-zpoždění*}**:**{*hlasitost-ozvěny*} **[ao]**

*# přidat dvě a více ozvěn*<br>
**[ai] aecho=0.6:0.3:**{*ms-zpoždění-1*}**\|**{*ms-další-zpoždění*}...**:**{*hlasitost-ozvěny-1*}**\|**{*hlasitost-další-ozvěny*}... **[ao]**

*# smíchat paralelní audiostopy*<br>
**[ai]**... **amix=**{*počet-vstupů*}**:duration=**{*longest,shortest,nebo-first*}[**:weights=**{*váhy vstupů*}**] [ao]**


### Pokročilá úprava zvuku
*# převzorkovat stopu na novou frekvenci*<br>
**[ai] aresample=**{*nová-frekvence*} **[ao]**

*# vylepšit zvuk pro poslech přes sluchátka*<br>
**[ai] earwax [ao]**

*# zvýraznit rozdíl mezi stereokanály*<br>
**[ai] extrastereo**[**=**{*koeficient*}] **[ao]**

*# rozkolísat amplitudu/fázi zvuku*<br>
*// Frekvence je v rozsahu 0.1 až 20000; rozumně slyšitelné jsou hodnoty do 20 Hz. Síla je v rozsahu 0.0 až 1.0.*<br>
**[ai] tremolo=f=**{*frekvence-Hz*}[**:d=**{*síla*} **[ao]**<br>
**[ai] vibrato=f=**{*frekvence-Hz*}[**:d=**{*síla*} **[ao]**

### Vložit ticho

*# vložit ticho před stopu*<br>
**[ai] adelay=**{*ms-pro-pravý-kanál*}[**\|**{*ms-pro-levý-kanál*}] **[ao]**<br>

*# vložit ticho za stopu*<br>
*// V případě opakovaného použití v rámci jednoho grafu filtrů nahraďte identifikátor „tmpticho“ při každém použití jiným identifikátorem.*<br>
**anoisesrc=a=0:d=**{*trvání-v-s*} **[tmpticho]; [ai][tmpticho] concat=n=2:v=0:a=1 [ao]**

*# nadstavení zvuku na určitou délku*<br>
**[ai] apad=whole\_len=**{*cílový-min-počet-vzorků*} **[ao]**

*# přidat na konec zvukové stopy nekonečné ticho*<br>
**[ai] apad [ao]**

### Konverze mono/stereo/L/R

*# duplikovat kanál mono-stopy na stereo-stopu*<br>
**[ai] channelmap=mono-FR\|mono-FL [ao]**

*# smíchat kanály stereo-stopy do mono-stopy*<br>
**[ai] channelsplit,amix,channelmap=0-mono:mono [ao]**

*# sloučit kanály stereo stopy do mono-stopy daným výrazem*<br>
*// Hodnota pravé stopy je „val(0)“ a hodnota levé „val(1)“.*<br>
**[ai] aeval=**{*výraz*}**,channelmap=0-mono:mono [ao]**

*# rozdělit stereo-stopu na FR a FL stopu/na dvě mono-stopy*<br>
**[ai] channelsplit=channels=FR\|FL [ao][ao]**<br>
**[ai] asplit[a0][a1];[a0]channelmap=FR-mono:mono[ao-pravy];[a1]channelmap=FL-mono:mono [ao-levy]**

*# spojit FR a FL stopu/„pravou“ a „levou“ mono-stopu do jedné stereo-stopy*<br>
**[ai][ai] amerge [ao]**<br>
**[ai][ai] join=map=0.0-FR\|1.0-FL [ao]**

*# prohodit levý a pravý kanál stereo-stopy*<br>
**[ai] channelmap=FR-FL\|FL-FR [ao]**

<!--
*# přidat na konec několik vzorků ticha*<br>
**[ai] apad=pad_len=**{*počet-vzorků*} **[ao]**

*# doplnit na konec ticho pro dosažení minimálního počtu vzorků*<br>
**[ai] apad=whole_len=**{*min-počet-vzorků*} **[ao]**
-->

### Generátory a čtení „bokem“

*# načíst ze souboru obraz/zvuk/obraz i zvuk*<br>
**movie=**{*vstupní-soubor*} **[vo]**<br>
**amovie=**{*vstupní-soubor*} **[ao]**<br>
**movie=**{*vstupní-soubor*}**:s=dv+da [vo][ao]**

*# černý/modrý/poloprůhledný zelený/zcela průhledný obraz*<br>
*// Nejsou-li zadány parametry „d“ a „r“, výstup generátoru bude nekonečný s fps 25.*<br>
**color=c=#000000:s=**{*šířka*}**x**{*výška*}[**:r=**{*fps*}][**:d=**{*trvání-v-sekundách*}]<br>
**color=c=#0000FF:s=**{*šířka*}**x**{*výška*}[**:r=**{*fps*}][**:d=**{*trvání-v-sekundách*}]<br>
**color=c=#00FF0080:s=**{*šířka*}**x**{*výška*}[**:r=**{*fps*}][**:d=**{*trvání-v-sekundách*}]<br>
**color=c=#00000000:s=**{*šířka*}**x**{*výška*}[**:r=**{*fps*}][**:d=**{*trvání-v-sekundách*}]

*# bílý šum*<br>
*// Amplituda se uvádí v rozsahu 0 až 1. Místo white lze použít také pink, brown, blue a violet.*<br>
**anoisesrc=c=white**[**:d=**{*trvání-v-s*}][**:a=**{*amplituda*}][**:r=**{*vzorkovací-frekvence*}] **[ao]**

*# ticho*<br>
**anoisesrc=a=0**[**:d=**{*trvání-v-s*}][**:r=**{*vzorkovací-frekvence*}]

*# tón o zadané frekvenci*<br>
*// V praxi může být nutno zvýšit výchozí hodnotu parametru „samples\_per\_frame“, ale nemám s tím zkušenosti. Amplituda generovaného signálu je 1/8.*<br>
**sine=f=**{*frekvence-v-Hz*}[**:d=**{*trvání-v-s*}][**:r=**{*vzorkovací-frekvence*}]

### Rozdělování a spojování

<!--
concat: vstupy se musejí shodovat v:
- rozlišení (lze upravit filtry jako pad, crop či scale)
- SAR (lze upravit setsar, např. setsar=1/1)
- počtu video/audio kanálů

pozor na PTS!
-->

*# spojit (za sebou) obrazové vstupy*<br>
**[vi]**... **concat=n=**{*počet vstupů*}**:v=1:a=0 [vo]**

*# spojit (za sebou) zvukové vstupy*<br>
**[ai]**... **concat=n=**{*počet vstupů*}**:v=0:a=1 [ao]**

*# spojit (za sebou) obrazové a zvukové vstupy*<br>
**[vi][ai][vi][ai]**... **concat=n=**{*počet-n-tic vstupů*}**:v=1:a=1 [vo][ao]**

<!--
*# (nefunguje!!!!!!!!)přehrát úsek a opakovat ho ještě N-krát znovu (Je-li např. počet 2, úsek se celkem přehraje třikrát!)*<br>
**[vi] loop=**{*počet*}**:{*maximální-počet-snímků*} [vo] ; [ai] aloop=**{*počet*}**:{*maximální-počet-vzorků*} [ao]**<br>
**[vi] loop=**{*počet*}**:32767 [vo] ; [ai] aloop=**{*počet*}**:2147483647 [ao]**<br>
**[vi] loop=-1:32767 [vo] ; [ai] aloop=-1:2147483647 [ao]**
-->

*# naklonovat videovstup/audiovstup na více shodných výstupů*<br>
**[vi] split=**{*počet výstupů*} **[vo]**...<br>
**[ai] asplit=**{*počet výstupů*} **[ao]**...


### Ostatní filtry

*# ponechat obraz/zvuk beze změny*<br>
**[vi] copy [vo]**<br>
**[ai] acopy [ao]**

*# pohltit video/zvuk bez výstupu*<br>
**[vi] nullsink**<br>
**[ai] anullsink**

## Zaklínadla (příkaz ffmpeg)

*# analyzovat soubor (ukáže streamy a jejich parametry)*<br>
**ffprobe** {*vstupní-soubor*}

*# konvertovat video/zvuk z jednoho formátu na druhý*<br>
**ffmpeg -i** {*vstupní-soubor.přípona*} **-qscale:0 0** [**-qscale:1 0**] {*výstupní soubor.přípona*}

*# konverze zvuku na stereo/na mono*<br>
**ffmpeg -i** {*vstup*} **-ac 2** {*výstup*}<br>
**ffmpeg -i** {*vstup*} **-ac 1** {*výstup*}

*# nastavit audiofrekvenci (v Hz, obvykle 44100, ale také 22050 či 48000)*<br>
**ffmpeg -i** {*vstup*} **-ar** {*frekvence*} {*výstup*}

*# nastavit poměr stran videa při přehrávání (doporučené hodnoty: 4:3, 16:9, 1:1, 5:4, 16:10)*<br>
**ffmpeg -i** {*vstup*} **-aspect** {*hodnota*} {*výstup*}

*# rozložit video na obrázky ve formátu podle výstupní přípony: JPEG (jpg), PNG (png), BMP (bmp), TIFF (tif)*<br>
**ffmpeg -i** {*video.přípona*} **-r** {*počet-snímků-za-sekundu*} **-f image2 -q:v 0** {*obrázek*}**-%05d.**{*výstupní-přípona*}

*# složit video z obrázků (bez zvuku/přidat zvuk)*<br>
**ffmpeg -framerate** {*počet-snímků-za-sekundu*} **-i** {*předpona*}**%05d.**{*přípona*} [{*další parametry kodeku*}] {*výstupní-video.přípona*}<br>
**ffmpeg -framerate** {*počet-snímků-za-sekundu*} **-i** {*předpona*}**%05d.**{*přípona*} **-i** {*soubor-se-zvukem*}  [{*další parametry kodeku*}] **-map 0:v -map 1:a** {*výstupní-video.přípona*}

*# vygenerovat sekvenci zmenšených náhledů z videa (šířka max. 640 pixelů), přibližně pro každou minutu*<br>
**ffmpeg -i** {*video*} **-r 0.0166666 -q:v 14 -vf 'scale=min(640\\,iw):-1' nahled%05d.jpg**

*# načíst statický obrázek (jpg,png,bmp,tif,...) jako nekonečné video (pozor − ne gif!)*<br>
**ffmpeg -loop 1 -i** {*obrázek*} {*další parametry*}
<!-- Pro gif prý -ignore_loop 0, ale vykoná cyklus jen podle hlavičky gifu. -->

*# oříznout časovou osu vstupního videa/nahrávky*<br>
**ffmpeg -ss** {*začátek*} **-to** {*konec*} **-i** {*vstup*} {*...*}<br>
**ffmpeg -ss** {*začátek*} **-t** {*trvání-v-sekundách*} **-i** {*vstup*} {*...*}<br>

*# oříznout časovou osu na výstupu*<br>
**ffmpeg -i** {*vstup*} **-ss** {*začátek*} **-to** {*konec*} {*...*}<br>
**ffmpeg -i** {*vstup*} **-ss** {*začátek*} **-t** {*trvání-v-sekundách*} {*...*}<br>

*# spojit za sebou soubory*<br>
**(for X in** {*vstupní-soubor*}... **; do echo "file '$X'"; done) &gt;** {*dočasný-soubor.txt*}<br>
**ffmpeg -f concat -safe 0 -i** {*dočasný-soubor.txt*} **-c copy** {*výstup*}

## Zaklínadla (příkazy)

*# vypnout úvodní banner s verzí a konfigurací pro ffmpeg/ffprobe*<br>
*// Toto vypnutí platí jen pro danou instanci bashe.*<br>
**source &lt;(printf "ffmpeg() { '%s' -hide\_banner "\\$@";}\\n" "$(which ffmpeg)")**<br>
**source &lt;(printf "ffprobe() { '%s' -hide\_banner "\\$@";}\\n" "$(which ffprobe)")**

## Parametry příkazů
![ve výstavbě](../obrazky/ve-vystavbe.png)

Příkaz ffmpeg přijímá tři typy parametrů: globální, vstupní a výstupní.
Globální parametry se zadávají jako první a platí pro danou instanci ffmpegu jako celek.
Vstupní parametry se zadávají v sekvenci ukončené parametrem **-i** a platí pouze pro daný jeden vstup. Výstupní parametry se zadávají v sekvenci ukončené názvem výstupního souboru a platí pouze pro daný jeden výstup.

### Globální parametry (ffmpeg)

* **\-filter\_complex** {*graf-filtrů*} -- Nastaví graf filtrů.
* **\-filter\_complex\_script** {*soubor*} -- Načte graf filtrů ze souboru.
* **\-y** -- Přepíše existující výstupní soubory bez ptaní.
* **\-n** -- Existuje-li výstupní soubor, nepřepíše ho a rovnou skončí s chybou.
* **\-nostdin** -- Vypne interakci ffmpegu s uživatelem.

### Vstupní parametry
* **-ss** {*začátek*} -- Načítání vstupu zahájí od zadaného času.
* **-t** {*trvání*} -- Ukončí načítání po dosažení zadané délky.
* **-framerate** {*číslo*} -- Při načítání sekvence obrázků udává její *fps*.

### Výstupní parametry
* **-c:v** {*kodek-videa*} -- Nastaví použitý kodek videa.
* **-c:a** {*kodek-zvuku*} -- Nastaví použitý kodek zvuku.
* **-vb** {*číslo*} -- Nastaví bitrate videa (možno použít přípony, např. „128k“ nebo „5M“).
* **-ab** {*číslo*} -- Nastaví bitrate audia (možno použít přípony, např. „128k“ nebo „5M“).
* **-ss** {*začátek*} -- Zahodí všechny výstupní snímky i vzorky, dokud nedosáhne požadovaného času začátku, teprve pak začne zapisovat výstup.
* **-to** {*konec*} -- Ukončí dekódování po dosažení zadaného času.
* **-t** {*trvání*} -- Ukončí dekódování po dosažení zadané délky výstupu.
* **-r**[**:**{*stopa*}] {*fps*} -- Vynutí na výstupu zadané konstantní fps.
* **-aspect**[**:**{*stopa*}] {*poměr:stran*} -- Vynutí na výstupu zadaný poměr stran videa (např. „4:3“ nebo „16:9“).
* **-vn**, **-an**, **-sn**, **-dn** -- Zakáže výstup daného typu stopy (video, zvuk, titulky, data).
* **-ar**[**:**{*stopa*}] {*frekvence-v-Hz*} -- Vynutí na výstupu vzorkovací frekvenci zvuku.
* **-ac**[**:**{*stopa*}] {*počet-kanálů*} -- Vynutí zadaný počet kanálů zvukové stopy.



## Jak získat nápovědu
*# *<br>
**man ffmpeg**<br>
**man ffmpeg-filters**

Dalším dobrým zdrojem je oficiální dokumentace k filtrům, ale ta může být podstatně novější než vaše verze ffmpegu; v takovém případě váš ffmpeg nemusí podporovat vše, co je v online dokumentaci uvedeno.

## Tipy a zkušenosti

* Pokud obraz či zvuk neupravujete a nekonvertujete, můžete jejich původní kvalitu a kodek zachovat pomocí parametru **-c:v copy** pro obraz, resp. **-c:a copy** pro zvuk. Zvuk můžete v takovém případě ořezávat pomocí parametrů **-ss**, **-to** a **-t**, u obrazu to silně nedoporučuji, protože typicky pak trpí výpadky na začátku a konci výsledného videa.
* Většina kodeků odmítne zapsat video, jehož šířka či výška v pixelech je lichá; myslete na to při používání filtru **-scale**.
* Výstupy filtrů **split** a **asplit** musejí být odebírány paralelně, jinak hrozí přetečení bufferu; je např. špatný nápad zapojit je do filtru **concat**, protože ten čte nejprve první vstup, a než se dostane ke druhému, buffer na něm přeteče, protože filtr **split** nedokáže posílat snímky nejprve na jeden výstup a až pak na druhý. Rychlým řešením je druhý výstup filtru **split** či **asplit** zapojit přes dvojici filtrů **reverse,reverse**, resp. **areverse,areverse**, protože ty dokážou zřídit v paměti buffer neomezené velikosti, ale správným řešením je výstup uložit do souboru a načítat pomocí více parametrů **-i** nebo generátorů **movie**, které mohou svoje načítání pozdržet, než budou snímky či zvuk filtrem **concat** požadovány.
* Můžete-li téhož efektu dosáhnout pomocí filtru nebo pomocí výstupního parametru, preferujte parametr; dává jistější výsledky, možná i kvalitnější.


<!--
Podle https://superuser.com/questions/435941/which-codecs-are-most-suitable-for-playback-with-windows-media-player-on-windows
- přidat **-pix_fmt yuv420p** má umožnit přehrání videa v microsoftích přehravačích
-->

### Doporučené kodeky

Pro obraz (**-c:v**): **h264** (synonymum **libx264**), **mpeg4**, **rawvideo** (opatrně); další použitelné: **gif**; pro série obrázků: **png**, **tiff**, **mjpeg** (pokud generuje varování „deprecated pixel format used, make sure you did set range correctly“, toto můžete bezpečně ignorovat).
<!--
Zdroj: https://superuser.com/questions/1273920/deprecated-pixel-format-used-make-sure-you-did-set-range-correctly
-->

Pro zvuk (**-c:a**): **aac** (mp4), **libmp3lame** (mp3), **pcm16\_le** (wav), **libvorbis** (ogg), **flac** (flac).

<!--
- Používat -ab a -vb k nastavení bitrate.
-->

## Odkazy
![ve výstavbě](../obrazky/ve-vystavbe.png)

* [Dokumentace k filtrům](https://ffmpeg.org/ffmpeg-filters.html) (anglicky)
* [manuálová stránka](http://manpages.ubuntu.com/manpages/bionic/en/man1/ffmpeg.1.html) (anglicky)
* [oficiální stránky](https://ffmpeg.org/) (anglicky)

<!--
Poznámky:
- filtr v360 (https://ffmpeg.org/ffmpeg-filters.html#toc-v360)
- vidstabdetect, vidstabtransform
- filtr zoompan
-->
