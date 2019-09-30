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
TODO:

Pochopit a zpracovat filtry:
- chorus
- equalizer
- highpass
- lowpass
- pan
- silenceremove
- stereowiden
- volume (dynamicky)

Zpracovat filtry:
- movie, amovie


- Rozlišit parametry na globální, vstupní a výstupní.
- Popsat vestavěné funkce, viz .
-->
# FFmpeg

## Úvod
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Definice
![ve výstavbě](../obrazky/ve-vystavbe.png)

**Stopa** je složka multimediálního souboru určená ke spojení s ostatními stopami. Existují čtyři druhy stop − obrazová, zvuková, titulková a datová. Multimediální kontejner může obsahovat více stop a tyto stopy mohou být různé...

**Kanál** je vrstva tvořící stopu. Na rozdíl od stop, kanály stopy trvají vždy stejně dlouho a tvoří každý snímek obrazu či vzorek zvuku společně.

**Snímek** je základní kvantum obrazové stopy. Vzorkovací frekvence videa čili počet snímků za sekundu se nazývá **fps**. Hodnota fps se obvykle pohybuje v rozmezí 10 až 60.

**Vzorek** je základní kvantum zvukové stopy. Obvyklá vzorkovací frekvence zvuku je 44100.



## Zaklínadla (filtry)
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Úprava časové osy

*# zrychlení 2×*<br>
**[vi] setpts=0.5\*PTS [vo] ; [ai] atempo=2.0 [ao]**

*# zrychlení 4×*<br>
**[vi] setpts=0.25\*PTS [vo] ; [ai] atempo=2.0,atempo=2.0 [ao]**

*# zrychlení 5×*<br>
**[vi] setpts=0.2\*PTS [vo] ; [ai] atempo=2.0,atempo=2.0,atempo=1.25 [ao]**

*# zrychlení 16×*<br>
**[vi] setpts=0.0625\*PTS [vo] ; [ai] atempo=2.0,atempo=2.0,atempo=2.0,atempo=2.0 [ao]**

*# zpomalení 2×*<br>
**[vi] setpts=2.0\*PTS [vo] ; [ai] atempo=0.5 [ao]**

*# zpomalení 4×*<br>
**[vi] setpts=4.0\*PTS [vo] ; [ai] atempo=0.5,atempo=0.5 [ao]**

*# zpomalení 5×*<br>
**[vi] setpts=5.0\*PTS [vo] ; [ai] atempo=0.5,atempo=0.5,atempo=0.8 [ao]**

*# zpomalení 16×*<br>
**[vi] setpts=16.0\*PTS [vo] ; [ai] atempo=0.5,atempo=0.5,atempo=0.5,atempo=0.5 [ao]**

*# vyříznout časový úsek (údaje jsou v sekundách, např. 20.5)*<br>
**[vi] trim=**{*začátek*}**:**{*konec*}**,setpts=PTS-STARTPTS [vo] ; [ai] atrim=**{*začátek*}**:**{*konec*}**,asetpts=PTS-STARTPTS [ao]**<br>
**[vi] trim=start=**{*začátek*}**:duration=**{*trvání*} **[vo] ; [ai] atrim=start=**{*začátek*}**:duration=**{*trvání*}**,asetpts=PTS-STARTPTS [ao]**<br>
**[vi] trim=start_frame=**{*index-prvního-zahrnutého-snímku*}**:**{*index-snímku-za-koncem*}**,setpts=PTS-STARTPTS [vo]**<br>
**[ai] atrim=start_sample=**{*index-prvního-zahrnutého-vzorku*}**:**{*index-vzorku-za-koncem*}**,asetpts=PTS-STARTPTS [ao]**

*# opakovat celý obrazový/zvukový vstup po zadaný počet sekund*<br>
*// na vstupu vezme maximálně 32767 snímků a max. 2147483647 zvukových vzorků; snímky odpovídají cca 21,8 minuty při fps=25*<br>
**[vi] setpts=PTS-STARTPTS,loop=-1:32767,trim=0:**{*cílový-počet-sekund*}** [vo]**<br>
**[ai] asetpts=PTS-STARTPTS,aloop=-1:2147483647,atrim=0:**{*cílový-počet-sekund*}** [ao]**

*# opakovat vyříznutou část obrazového/zvukového vstupu po zadaný počet sekund*<br>
**[vi] trim=**{*začátek*}**:**{*konec*}**,setpts=PTS-STARTPTS,loop=-1:32767,trim=0:**{*cílový-počet-sekund*}** [vo]**<br>
**[ai] atrim=**{*začátek*}**:**{*konec*}**,asetpts=PTS-STARTPTS,aloop=-1:2147483647,atrim=0:**{*cílový-počet-sekund*}** [ao]**

*# obrátit video*<br>
*// Pozor! Filtr reverse musí celé video nekomprimované uložit do paměti. Pro zpracování dlouhého videa tedy doporučuji dočasně zapnout opravdu velký swapovací soubor, nebo video obracet po částech.*<br>
**[vi] reverse [vo]**




### Úprava obrazu

*# změna rozlišení (roztažení, smrsknutí, škálování)(pro většinu kodeků musejí být hodnoty šířka a výška sudé!)*<br>
**[vi] scale=**{*šířka*}**:**{*výška*} **[vo]**

*# změnit šířku i výšku na polovinu a zajistit, aby oba rozměry byly sudé*<br>
**[vi] scale=2\*trunc(iw/4):2\*trunc(ih/4) [vo]**

*# zvětšit šířku i výšku s interpolací pro pixel-art na dvojnásobek/dvojnásobek/trojnásobek/čtyřnásobek*<br>
**[vi] super2xsai [vo]**<br>
**[vi] xbr=2 [vo]**<br>
**[vi] xbr=3 [vo]**<br>
**[vi] xbr=4 [vo]**

*# nadstavení obrazu (padding)(barva=#RRGGBB[AA] jako v HTML) *<br>
**[vi] pad=**{*šířka*}**:**{*výška*}**:**{*posun-x-zleva*}**:**{*posun-y-shora*}[**:**{*barva*}] **[vo]**

*# oříznutí/vyříznutí obrazu (cropping)*<br>
**[vi] crop=**{*šířka*}**:**{*výška*}**:**{*posun-x-zleva*}**:**{*posun-y-shora*} **[vo]**

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

*# zapéci titulky do obrazu (normálně/podtrženým červeným písmem Arial velikosti 48)*<br>
*// Nastavení stylu jsou ve formátu ASS, přičemž znaky = a , musíte escapovat kvůli ffmpegu.*<br>
**[vi] subtitles=**{*soubor-s-titulky*}[**:force_style=**{*nastavení-stylu*}] **[vo]**<br>
**[vi] subtitles=**{*soubor-s-titulky*}**:force_style=FontName\\=Arial\\,Fontsize\\=48\\,PrimaryColour\\=&amp;H000000FF\\,Underline\\=1 [vo]**

<!--
Barvy se zadávají ve formátu AABBGGRR, kde AA=FF je úplná průhlednost a AA=00 úplná neprůhlednost.
-->

*# zakrýt/odstranit logo nebo jiný rušivý element z obrazu*<br>
**[vi] delogo=x=**{*posun-x-zleva*}**:y=**{*posun-y-shora*}**:w=**{*šířka*}**:h=**{*výška*} **[vo]**

*# vykreslit do obrazu obdelník*<br>
*// invert=invertující rámeček; fill=vyplněný obdelník*<br>
**[vi] drawbox=**{*posun-x-zleva*}**:**{*posun-y-shora*}**:**{*šířka*}**:**{*výška*}**:**{*barva-nebo-invert*}[**@**{*krytí-0-až-1*}][**:**{*tloušťka-nebo-fill*}]

*# odstranit prokládání*<br>
**[vi] yadif [vo]**

*# nastavit kontrast, jas, saturaci a gama korekci*<br>
*// při eval=frame se hodnoty počítají pro každý snímek zvlášť*<br>
**[vi] eq=**[**contrast=**{*-2.0..2.0;def=1.0*}]
[**:brightness=**{*-1.0..1.0;def=0.0*}]
[**:saturation=**{*0.0..3.0;def=1.0*}]
[**:gamma=**{*0.1..10.0;def=1.0*}]
[**:eval=frame**] **[vo]**

*# vložit roztmívačku/zatmívačku*<br>
*// všechny snímky před začátkem roztmívačky a za koncem zatmívačky budou nastaveny na uvedenou barvu*
<!--
[ ] OVĚŘIT!
-->
**[vi] fade=t=in:st=**{*začátek*}**:d=**{*trvání*}[**:c=**{*barva*}][**:alpha=1**] **[vo]**<br>
**[vi] fade=t=out:st=**{*začátek*}**:d=**{*trvání*}[**:c=**{*barva*}][**:alpha=1**] **[vo]**

*# rozmazat obraz*<br>
*// výchozí sigma=0.5*<br>
**[vi] gblur**[**=**{*sigma*}] **[vo]**

*# aplikovat výraz po pixelech*<br>
*// Ve výrazu můžete použít proměnné: čas snímku v sekundách (T), sekvenční číslo snímku (N), souřadnice výstupního pixelu (X, Y), rozměry snímku (W, H); a funkce r(), g(), b() a a(), které přijímají parametry (x, y) a načtou odpovídající složku z pixelu původního snímku na uvedených souřadnicích. Pro souřadnice mimo rozsah vrací 0.*<br>
**[vi] geq=r=**{*výraz-red*}**:g=**{*výraz-green*}**:b=**{*výraz-blue*}[**:a=**{*výraz-alfa*}] **[vo]**

<!--
TODO: [ ] Vyzkoušet rozsah složky A. (Ostatní: 0..255.)
-->

*# sestavit každý nový snímek z pixelů původního*<br>
*// Souřadnice mimo rozsah (?)*<br>
**[vi] geq=p(**{*výraz-x*}**\\,**{*výraz-y*}**) [vo]**

<!--
[ ] POKRAČOVAT OD:
https://ffmpeg.org/ffmpeg-filters.html#geq
-->

*# naskládat videa stejné výšky vedle sebe/videa stejné šířky pod sebe*<br>
*// Všechny použité vstupy musejí mít kromě stejné výšky/šířky také stejný formát pixelu (pixel-format).*<br>
**[vi]**... **hstack=inputs=**{*počet-vstupů*}[**:shortest=1**] **[vo]**
**[vi]**... **vstack=inputs=**{*počet-vstupů*}[**:shortest=1**] **[vo]**

*# odbarvit obrázek na stupně šedi*<br>
**[vi] hue=s=0 [vo]**

*# roztmívačka saturace*<br>
*// Čas začátku a trvání efektu jsou v sekundách.*<br>
**[vi] hue=s=max(0\,min(1\,(t - **{*čas-začátku*}**)/**{*trvání-efektu*}**)) [vo]**

*# zatmívačka saturace*<br>
*// Čas začátku a trvání efektu jsou v sekundách.*<br>
**[vi] hue=s=max(0\,min(1\,(**{*čas-začátku*} **- t)/**{*trvání-efektu*}**)) [vo]**

*# invertovat barvy*<br>
?

*# proložit obraz (sníží framerate na polovinu)*<br>
**[vi] interlace [vo]**

*# oříznout hodnoty složek obrazu*<br>
*// TODO: Nevím, zda se aplikuje i na alfa-kanál.*<br>
**[vi] limiter=**[**min=**{*minimum*}][**:max=**{*maximum*}] **[vo]**

*# zvýšit fps s inteligentní interpolací pohybů*<br>
*// Poznámka: tento filtr může být velmi pomalý. Před aplikací na delší video ho raději vyzkoušejte na kratším úseku.*<br>
**[vi] minterpolate=fps=**{*nové-fps*} **[vo]**<br>
**[vi] minterpolate=fps=**{*nové-fps*}**:mi_mode=blend [vo]**<br>
**[vi] minterpolate=fps=**{*nové-fps*}**:mi_mode=dup [vo]**

*# prolnout několik vstupů stejných rozměrů*<br>
**[vi]**... **mix=nb_inputs=**{*počet-vstupů*}**:weights=**{*váhy oddělené mezerami*}[**:duration=**{*longest-shortest-nebo-first*}] **[vo]**

*# negovat složky snímku bez alfa kanálu/včetně alfa kanálu*<br>
**[vi] negate [vo]**<br>
**[vi] negate=negate_alpha=1 [vo]**

*# zašumět obraz proměnným RGB-šumem*<br>
*// Přípustné hodnoty parametry allf jsou a, p, t, u a jejich kombinace operátorem +; při letmém vyzkoušení se mi jevily použitelné jen varianty „t“ a „t+u“ (jemnější).*<br>
**[vi] noise=alls=**{*síla-šumu-0-az-100*}**:allf=t**

*# překrýt jeden videovstup druhým; po skončení překryvného vstupu: ho skrýt/ukončit výstup/zamrznout překryvný vstup na jeho posledním snímku*<br>
*// Hodnoty posunu jsou výrazy s výsledkem v pixelech. Mohou používat: rozměry hlavního videa (W, H), rozměry překryvného videa (w, h), čas v sekundách (t) a sekvenční číslo snímku (n). Poznámka: výstup filtru overlay není nikdy delší než délka jeho hlavního (prvního) vstupu.*<br>
**[vi][vi] overlay=x=**{*posun-x*}**:y=**{*posun-y*}**:eof_action=pass [vo]**<br>
**[vi][vi] overlay=x=**{*posun-x*}**:y=**{*posun-y*}**:eof_action=endall [vo]**<br>
**[vi][vi] overlay=x=**{*posun-x*}**:y=**{*posun-y*}**:eof_action=repeat [vo]**

*# sloučit jeden a druhý videovstup (obecně/)*<br>
*// Ve výrazu můžete použít hodnoty: sekvenční číslo snímku (N), souřadnice pixelu ((X/SW), (Y/SW)), šířka a výška ((W/SW), (H/SW)), čas v sekundách (T) a především hodnotu složky prvního vstupu (A) a druhého vstupu (B).*<br>
**[vi][vi] blend=all_expr=**{*výraz*}[**:eof_action=**]{*repeat-endall-nebo-shortest*} **[vo]**

*# opravit perspektivu ze zadaných souřadnic (vLevo, vpRavo, Nahoře, Dole)*<br>
**[vi] perspective=**{*LNx*}**:**{*LNy*}**:**{*RNx*}**:**{*RNy*}**:**{*LDx*}**:**{*LDy*}**:**{*RDx*}**:**{*RDy*}[**:sense=destination**][**:interpolation=cubic**] **[vo]**

*# prohazovat a zahazovat snímky podle zadaného klíče*<br>
*// Filtr načte do vstupního bufferu tolik snímků ze vstupu, kolik jste zadali indexů. Následně na výstup vybírá snímky z bufferu podle indexů, které jste uvedli. Indexy se mohou opakovat a lze uvést speciální index -1, který způsobí vynechání snímku na výstupu (zahození).*<br>
**[vi] shuffleframes=**{*indexy dělené mezerami*} **[vo]**

*# náhodně prohazovat snímky v čase (snímky se do bufferu vkládají sekvenčně a vybírají v náhodném pořadí)*<br>
*// Velikost bufferu musí být v rozmezí 2 až 512 (výchozí hodnota je 30); snímky se do bufferu vkládají sekvenčně a vybírají se v náhodném pořadí.*<br>
**[vi] random=**{*velikost-bufferu*}

*# z každé dávky snímků vybrat ten nejreprezentativnější a ten roztáhnout na celou délku dávky*<br>
*// Má velké paměťové nároky, nepoužívat pro velký počet snímků; rozumný je tak maximálně 1000.*<br>
**[vi] thumbnail=**{*počet-snímků-na-dávku*} **[vo]**

*# zneviditelnit předmět na určité pozici*<br>
*// Mapa by měla mít stejný rozměr jako video a musí obsahovat bílé pixely na pozicích, kde je na videu předmět k odstranění, a černé pixely na místech, která se nemají změnit.*<br>
**[vi] removelogo=**{*obrázek-s-mapou.png*} **[vo]**

*# aplikovat na obraz Sobelův operátor detekce hran*<br>
**[vi] sobel [vo]**

*# vyměnit dvě obdelníkové oblasti ve videu*<br>
*// Všechny hodnoty mohou používat rozměry snímku (w, h), čas v sekundách (t) a sekvenční číslo snímku (n).*<br>
**[vi] swaprect=**{*šířka-oblastí*}**:**{*výška-oblastí*}**:**{*x1*}**:**{*y1*}**:**{*x2*}**:**{*y2*} **[vo]**

*# rozdělit snímky po dávkách a každou dávku vykreslit po řádcích do mřížky daných rozměrů*<br>
**[vi] tile=**{*počet-sloupců-mřížky*}**x**{*počet-řádků-mřížky*}[**:margin=**{*šířka-okraje*}][**:padding=**{*rozestup-mřížky*}][**:color=**{*barva-pozadí*}][**:nb_frames=**{*velikost-dávky*}] **[vo]**

*# ztmavit/zesvětlit okraje snímku (efekt vignette)*<br>
*// Úhel čočky je v rozsahu 0 (žádný účinek) až PI/2 (maximální účinek). Pro vyhodnocování výrazů pro každý snímek musíte přidat parametr „eval=frame“. Mód *<br>
**[vi] vignette=a=**{*úhel-čočky*}[**:x0=**{*x-středu*}**:y0=**{*y-středu*}][**:eval=frame**] **[vo]**<br>
**[vi] vignette=mode=backward:a=**{*úhel-čočky*}[**:x0=**{*x-středu*}**:y0=**{*y-středu*}][**:eval=frame**] **[vo]**




### Úprava zvuku

*# změnit hlasitost (snížit na desetinu/zvýšit na pětinásobek)*<br>
**[ai] volume=0.1 [ao]**<br>
**[ai] volume=5.0 [ao]**

*# spojit za sebe dva vstupy a prolnout sedmisekundovou prolínačkou*<br>
**[ai][ai] acrossfade=d=7:c1=exp:c2=exp [ao]**

*# před každý zvukový kanál vložit určitý počet milisekund ticha*<br>
**[ai] adelay=**{*ms-pro-pravý-kanál*}[**\|**{*ms-pro-levý-kanál*}] **[ao]**

*# přidat ozvěnu*<br>
*// Hlasitost ozvěny je v rozsahu 0 až 1.0 a nesmí být 0. Filtr mírně sníží hlasitost původních zvuků, je potřeba ji vyladit.*<br>
**[ai] aecho=0.6:0.3:**{*ms-zpoždění*}**:**{*hlasitost-ozvěny*} **[ao]**

*# přidat dvě a více ozvěn*<br>
**[ai] aecho=0.6:0.3:**{*ms-zpoždění-1*}**\|**{*ms-další-zpoždění*}...**:**{*hlasitost-ozvěny-1*}**\|**{*hlasitost-další-ozvěny*}... **[ao]**

*# aplikovat na zvukové vzorky obecný výraz*<br>
*// Ve výrazu můžeme použít: hodnotu pravé/levé stopy (val(0)/val(1)), čas vzorku v sekundách (t), číslo vzorku (n), číslo kanálu (ch), původní počet kanálů (nb_in_channels), vzorkovací frekvenci (s).*<br>
**[ai] aeval=**{*výraz*}[**|**{*výraz-pro-druhý-kanál*}]**:c=same [ao]**

*# sloučit kanály stereo stopy do jedné daným výrazem*<br>
*// Hodnota pravé stopy je „val(0)“ a hodnota levé „val(1)“.*<br>
**[ai] aeval=**{*výraz*} **[ao]**

*# aplikovat zvukovou zatmívačku/roztmívačku*<br>
*// Podporované tvary jsou: tri, qsin, hsin, esin, log, ipar, qua, cub, squ, cbr, par, exp, iqsin, ihsin, dese. Poznámka: Veškerý zvuk po konci zatmívačky, resp. začátkem roztmívačky bude tímto filtrem nahrazen tichem.*<br>
**[ai] afade=out:st=**{*čas-začátku*}**:d=**{*trvání-v-s*}**:curve=**{*tvar*} **[ao]**<br>
**[ai] afade=in:st=**{*čas-začátku*}**:d=**{*trvání-v-s*}**:curve=**{*tvar*} **[ao]**

*# spojit levý a pravý (v tomto pořadí) audio-vstup do jedné stereo-stopy*<br>
**[ai][ai] amerge [ao]**

*# rozdělit stereo-stopu na pravé a levé mono*<br>
**[ai] channelsplit [ao][ao]**

*# smíchat paralelní audiostopy*<br>
**[ai]**... **amix=**{*počet-vstupů*}**:duration=**{*longest,shortest,nebo-first*}[**:weights=váhy vstupů**] **[ao]**

*# vynásobit vzorky*<br>
**[ai][ai] amultiply [ao]**

*# přidat na konec zvukové stopy nekonečné ticho*<br>
**[ai] apad [ao]**

*# přidat na konec zvukové stopy několik sekund ticha*<br>
?

*# přidat na konec několik vzorků ticha*<br>
**[ai] apad=pad_len=**{*počet-vzorků*} **[ao]**

*# doplnit na konec ticho pro dosažení minimálního počtu vzorků*<br>
**[ai] apad=whole_len=**{*min-počet-vzorků*} **[ao]**

*# převzorkovat stopu na novou frekvenci*<br>
**[ai] aresample=**{*nová-frekvence*} **[ao]**

*# obrátit celou zvukovou stopu v čase*<br>
**// Varování: Tento filtr potřebuje načíst celý zvuk najednou do paměti, což může pro delší soubory způsobit velké paměťové nároky.**<br>
**[ai] areverse [ao]**

*# nastavit novou vzorkovací frekvenci bez ovlivnění vzorků*<br>
**[ai] asetrate=**{*nová-frekvence*} **[ao]**

*# vylepšit zvuk pro poslech přes sluchátka*<br>
**[ai] earwax [ao]**

*# zvýraznit rozdíl mezi stereokanály*<br>
**[ai] extrastereo**[**=**{*koeficient*}] **[ao]**

*# rozkolísat amplitudu/fázi zvuku*<br>
*// Frekvence je v rozsahu 0.1 až 20000; rozumně slyšitelné jsou hodnoty do 20 Hz. Síla je v rozsahu 0.0 až 1.0.*<br>
**[ai] tremolo=f=**{*frekvence-Hz*}[**:d=**{*síla*} **[ao]**<br>
**[ai] vibrato=f=**{*frekvence-Hz*}[**:d=**{*síla*} **[ao]**



### Generátory obrazu

*# černý/modrý/poloprůhledný zelený/zcela průhledný obraz*<br>
*// Nejsou-li zadány parametry „d“ a „r“, výstup generátoru bude nekonečný s fps 25.*<br>
**color=c=#000000:s=**{*šířka*}**x**{*výška*}[**:r=**{*fps*}][**:d=**{*trvání-v-sekundách*}]<br>
**color=c=#0000FF:s=**{*šířka*}**x**{*výška*}[**:r=**{*fps*}][**:d=**{*trvání-v-sekundách*}]<br>
**color=c=#00FF0080:s=**{*šířka*}**x**{*výška*}[**:r=**{*fps*}][**:d=**{*trvání-v-sekundách*}]<br>
**color=c=#00000000:s=**{*šířka*}**x**{*výška*}[**:r=**{*fps*}][**:d=**{*trvání-v-sekundách*}]

### Generátory zvuku

*# bílý šum*<br>
*// Amplituda se uvádí v rozsahu 0 až 1. Místo white lze použít také pink, brown, blue a violet.*<br>
**anoisesrc=c=white**[**:d=**{*trvání-v-s*}][**:a=**{*amplituda*}][**:r=**{*vzorkovací-frekvence*}] **[ao]**

<!--
+ sine
-->


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
**[vi][ai][vi][ai]**... **concat=n=**{*počet-n-tic vstupů*}**:v=1:a=1 [vo] [ao]**

*# (nefunguje!!!!!!!!)přehrát úsek a opakovat ho ještě N-krát znovu (Je-li např. počet 2, úsek se celkem přehraje třikrát!)*<br>
**[vi] loop=**{*počet*}**:{*maximální-počet-snímků*} [vo] ; [ai] aloop=**{*počet*}**:{*maximální-počet-vzorků*} [ao]**<br>
**[vi] loop=**{*počet*}**:32767 [vo] ; [ai] aloop=**{*počet*}**:2147483647 [ao]**<br>
**[vi] loop=-1:32767 [vo] ; [ai] aloop=-1:2147483647 [ao]**

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
**ffprobe -hide_banner** {*vstupní-soubor*}

*# konvertovat video/zvuk z jednoho formátu na druhý*<br>
**ffmpeg** [**-hide_banner**] **-i** {*vstupní-soubor.přípona*} **-qscale:0 0** [**-qscale:1 0**] {*výstupní soubor.přípona*}

*# konverze zvuku na stereo/na mono*<br>
**ffmpeg** [**-hide_banner**] **-i** {*vstup*} **-ac 2** {*výstup*}<br>
**ffmpeg** [**-hide_banner**] **-i** {*vstup*} **-ac 1** {*výstup*}

*# nastavit audiofrekvenci (v Hz, obvykle 44100, ale také 22050 či 48000)*<br>
**ffmpeg** [**-hide_banner**] **-i** {*vstup*} **-ar** {*frekvence*} {*výstup*}

*# nastavit poměr stran videa při přehrávání (doporučené hodnoty: 4:3, 16:9, 1:1, 5:4, 16:10)*<br>
**ffmpeg** [**-hide_banner**] **-i** {*vstup*} **-aspect** {*hodnota*} {*výstup*}

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
**ffmpeg() { $(which ffmpeg) -hide\_banner "$@";}**<br>
**ffprobe() { $(which ffprobe) -hide\_banner "$@";}**

## Parametry příkazů
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Jak získat nápovědu
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Tipy a zkušenosti
![ve výstavbě](../obrazky/ve-vystavbe.png)

- Pokud obraz či zvuk neupravujete a nekonvertujete, můžete jejich původní kvalitu a kodek zachovat pomocí parametru **-c:v copy** pro obraz, resp. **-c:a copy** pro zvuk. Zvuk můžete v takovém případě ořezávat pomocí parametrů **-ss**, **-to** a **-t**, u obrazu to silně nedoporučuji, protože typicky pak trpí výpadky na začátku a konci výsledného videa.


<!--
Podle https://superuser.com/questions/435941/which-codecs-are-most-suitable-for-playback-with-windows-media-player-on-windows
- přidat **-pix_fmt yuv420p** má umožnit přehrání videa v microsoftích přehravačích
-->

### Doporučené kodeky

Pro obraz (**-c:v**): **h264** (synonymum **libx264**), mpeg4.

Pro zvuk (**-c:a**): **aac**, **libmp3lame**.

<!--
- Používat -ab a -vb k nastavení bitrate.
-->

## Odkazy
![ve výstavbě](../obrazky/ve-vystavbe.png)

* [manuálová stránka](http://manpages.ubuntu.com/manpages/bionic/en/man1/ffmpeg.1.html) (anglicky)
* [oficiální stránky](https://ffmpeg.org/) (anglicky)
* [dokumentace k filtrům](https://ffmpeg.org/ffmpeg-filters.html) (anglicky)

<!--
Poznámky:
- filtr v360 (https://ffmpeg.org/ffmpeg-filters.html#toc-v360)
- vidstabdetect, vidstabtransform
- filtr zoompan
-->
