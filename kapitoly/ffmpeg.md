<!--

Linux Kniha kouzel, kapitola FFmpeg
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
# Název

## Úvod
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Definice
![ve výstavbě](../obrazky/ve-vystavbe.png)

## Zaklínadla (filtry)
![ve výstavbě](../obrazky/ve-vystavbe.png)

### Úprava časové osy

*# zrychlení 2×*<br>
**[vi] setpts=0.5\*PTS [vo] ; [ai] atempo=2.0 [ao]**

*# zrychlení 4×*<br>
**[vi] setpts=0.25\*PTS [vo] ; [ai] atempo=2.0,atempo=2.0 [ao]**

*# zrychlení 5×*<br>
**[vi] setpts=0.2\*PTS [vo] ; [ai] atempo=2.0,atempo=2.0,atempo=1.25 [ao]**

*# zrychlení 16×<br>
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






### Úprava obrazu

*# změna rozlišení (roztažení, smrsknutí, škálování)(pro většinu kodeků musejí být hodnoty šířka a výška sudé!)*<br>
**[vi] scale=**{*šířka*}**:**{*výška*} **[vo]**

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


*# vložit MKV titulky do obrazu (tzv. zapéci)(??)*<br>
** subtitles={soubor-s-titulky.mkv} [vo] **

*# odstranit prokládání*<br>
**[vi] yadif [vo]**

### Úprava zvuku

*# změnit hlasitost (snížit na desetinu/zvýšit na pětinásobek)*<br>
**[ai] volume=0.1 [ao]**<br>
**[ai] volume=5.0 [ao]**



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


### Ostatní filtry

*# ponechat obraz/zvuk beze změny*<br>
**[vi] copy [vo]**<br>
**[ai] acopy [ao]**

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

* [oficiální stránky](https://ffmpeg.org/) (anglicky)
* [dokumentace k filtrům](https://ffmpeg.org/ffmpeg-filters.html) (anglicky)
