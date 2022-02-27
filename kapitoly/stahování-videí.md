<!--

Linux Kniha kouzel, kapitola Stahování videí
Copyright (c) 2019-2022 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
ÚKOLY:

[ ] Rozšířit ukázku.

-->

# Stahování videí

!Štítky: {program}{internet}{video}
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod

Tato kapitola se zabývá stahováním videí a zvukových záznamů ze služeb jako YouTube,
Instagram, Facebook, MixCloud, Vimeo apod. pomocí programu „yt-dlp“.
Je určena vždy pro jeho nejaktuálnější verzi z GitHubu,
protože časté změny ve webovém rozhraní online služeb obvykle způsobují
nefunkčnost dřívějších verzí programu.

## Definice

* **Id** je technický textový (popř. číselný) identifikátor videa či zvukového záznamu na přílušné službě.

!ÚzkýRežim: vyp

## Zaklínadla

### Stahování videí

*# stáhnout **video** či více videí*<br>
**yt-dlp -f** {*požadované,formáty*} [**-P "**{*adresář/kam/stáhnout*}**"**] **-o "**{*formát názvu souboru*}**"** [**\-\-no-mtime**] <nic>[{*další parametry*}] **'**{*URL/videa*}**'** [**'**{*URL/dalšího/videa*}**'**]...

*# stáhnout **všechna** videa z playlistu či kanálu*<br>
**yt-dlp -f** {*požadované,formáty*} [**-P "**{*adresář/kam/stáhnout*}**"**] **-o "**{*formát názvu souboru*}**"** [**\-\-no-mtime**] <nic>[{*další parametry*}] **'**{*URL/playlistu/či/kanálu*}**'**

*# stáhnout **nová** videa z playlistu či kanálu*<br>
*// Před prvním použitím by měl být záznamový soubor prázdný. Tento příkaz do něj vyplní id již stažených videí.*<br>
**yt-dlp -f** {*požadované,formáty*} [**-P "**{*adresář/kam/stáhnout*}**"**] **-o "**{*formát názvu souboru*}**"** [**\-\-no-mtime**] **\-\-download-archive** {*záznamový-soubor*} <nic>[{*další parametry*}] **'**{*URL/playlistu/či/kanálu*}**'**

*# vytvořit prázdný/úplný záznamový soubor*<br>
*// Úplný záznamový soubor bude obsahovat identifikátory všech videí z daného playlistu či kanálu, takže při jeho příštím použití se stáhnou jen ta, která přibyla od jeho vytvoření.*<br>
**true &gt;**{*záznamový-soubor*}<br>
**yt-dlp -O '%(extractor)s %(id)s' -i \-\-flat-playlist '**{*URL/playlistu/či/kanálu*}**' &gt;**{*záznamový-soubor*}

### Nejdůležitější parametry

*# volba formátů ke stažení (-f; obecně/příklad)*<br>
*// V parametru -f se používají tři operátory (zde v pořadí od nejvyšší priority po nejnižší): „+“ odděluje formát videa a formát zvuku v případě, že mají být staženy samostatně a spojeny; „/“ odděluje alternativy — program stáhne první z uvedených formátů, který bude dostupný; „,“ odděluje více formátů k postupnému stažení.*<br>
**-f '**{*požadované,formáty*}**'**<br>
**-f 'bestvideo+bestaudio/best'**<br>
**-f '244+140,248+140'**

*# cílový adresář (-P; obecně/příklad)*<br>
**-P "**{*cesta*}**"**<br>
**-P "../videa"**<br>
**-P \~/Videa**

*# formát názvu souboru*<br>
*// Obsahuje-li parametr -o relativní cestu, ta bude vyhodnocena relativně vůči cestě určené parametrem -P; neexistující adresáře budou vytvořeny podle potřeby. Každý formát názvu souboru by měl končit „.%(ext)s“, aby nenastaly problémy při konverzích.*<br>
**-o "**[{*cesta*}]{*formátovací řetězec*}**.%(ext)s"**<br>
**-o "%(title)s(%(id)s)-%(heightd).%(ext)s"**<br>
**-o "%(title)s/%(title)s-%(format\_id)s.%(ext)s"**

*# čas poslední změny souboru nastavit na: čas nahrátí videa na službu/čas stažení*<br>
**\-\-mtime**<br>
**\-\-no-mtime**

*# nepřerušovat činnost při chybě*<br>
**-i**

*# nestahovat, ale vypsat údaje o videu na standardní výstup*<br>
**-O '**{*formátovací řetězec*}**'**

### Výběr formátu videa (-f)

*# stáhnout **nejlepší** dostupný formát/ale pokud možno s jiným kodekem než AV1*<br>
**\-f 'bestvideo+bestaudio/best'**<br>
**\-f 'bestvideo[vcodec!^=av01]+bestaudio/bestvideo+bestaudio/best'**

*# stáhnout nejlepší dostupný formát s výškou maximálně 480 pixelů*<br>
*// Vhodné hodnoty výšky: 144, 240, 360, 480, 720, 1080, 1440, 2160.*<br>
**\-f 'bestvideo[height&lt;=?480]+bestaudio/best[height&lt;=?480]/best'**

*# stáhnout co nejmenší formát*<br>
**\-f 'best' \-\-format\-sort '+size,+br,+res,+fps'**

*# stáhnout co nejlepší formát, ale každý soubor maximálně cca 100 MiB*<br>
**\-f 'bestvideo[filesize&lt;=100M]+bestaudio[filesize&lt;=100M]/best[filesize&lt;=100M]'**

*# stáhnout jen co nejlepší **zvuk bez obrazu***<br>
*// Audio-formát uvádějte, jen pokud vám na něm záleží (překódování může snížit kvalitu zvuku). Může to být: best, aac, flac, mp3, m4a, opus, vorbis nebo wav.*<br>
**\-f 'bestaudio'** [**-x** [**\-\-audio-format** {*audio-formát*}]]

*# stáhnout jedině nejlepší video bez obrazu, s kodekem H264*<br>
**\-f 'bestvideo[vcodec^=avc1]'**

### Formátovací řetězec pro parametry -o a -O

*# **identifikátor** videa*<br>
**%(id)s** ⊨ CvhJWKtBLn4

*# **název** videa*<br>
**%(title)s** ⊨ Oficiální ASMR booktrailer seriálu Ester Krejčí 1.0

*# správná **přípona** výstupního souboru*<br>
**%(ext)s** ⊨ mkv

*# **šířka/výška** videa*<br>
**%(width)d** ⊨ 1920<br>
**%(height)d** ⊨ 1080

*# **formát** videa (číslo/podrobný popis)*<br>
**%(format\_id)s** ⊨ 299<br>
**%(format)s** ⊨ 299 - 1920x1080 (1080p60)

*# **datum nahrátí** videa na službu (nemusí odpovídat datu zveřejnění)*<br>
**%(upload\_date)s** ⊨ 20190618<br>
**%(upload\_date&gt;%Y-%m-%d)s** ⊨ 2019-06-18

*# **počítadlo stahování** (pět míst/jen číslo)*<br>
**%(autonumber**[**+**{*prvníčíslo*}**-1**]**)05d** ⊨ 00001<br>
**%(autonumber**[**+**{*prvníčíslo*}**-1**]**)d** ⊨ 1

*# index v playlistu (doplněný nulami/jen číslo)*<br>
**%(playlist\_index)03d** ⊨ 001<br>
**%(playlist\_index)d** ⊨ 1

*# název kanálu*<br>
**%(uploader)s** ⊨ Mikoláš Štrajt

*# délka videa v sekundách*<br>
**%(duration)d** ⊨ 1448

*# aktuální čas před zahájením stahování videa (různé formáty)*<br>
**%(epoch&gt;%Y-%m-%dT%H:%M:%S)s** ⊨ 2022-02-20T12:53:40<br>
**%(epoch&gt;%Y%m%d)s** ⊨ 20220220

*# popis videa*<br>
**%(description)s**

*# počet zhlédnutí/liků/disliků*<br>
**%(view\_count)d** ⊨ 12<br>
**%(like\_count)d** ⊨ 1<br>
**%(dislike\_count)d** ⊨ 0

*# technické označení kodeku videa/zvuku*<br>
**%(vcodec)s** ⊨ avc1.64001e<br>
**%(acodec)s** ⊨ mp4a.40.2

*# identifikátor/název playlistu*<br>
**%(playlist\_id)s** ⊨ NA<br>
**%(playlist\_title)s** ⊨ NA

*# licence videa*<br>
**%(license)s** ⊨ NA

*# přibližná/co nejpřesnější velikost souboru v bajtech*<br>
**%(filesize\_approx)d** ⊨ 235205166<br>
**%(filesize,filesize\_approx)d** ⊨ 235205166

<!--
*# celkový počet položek v playlistu*<br>
**%(n\_entries)d**
%(playlist_count)d ?
-->

<!--
%(age_limit)d
-->

### Získat informace o videu

*# vypsat **dostupné formáty** videa*<br>
**yt-dlp -F** [**-v**] {*URL-videa*}

*# získat o videu informace ve vlastním formátu (obecně/příklad)*<br>
**yt-dlp -O "**{*formátovací řetězec*}**"** [**-f '**{*formáty-videa*}**'**] {*URL-videa*}<br>
**yt-dlp -O "Video '%(title)s' od %(uploader)s je k dispozici ve formátu %(format\_id)s s rozměry %(width)dx%(height)d a příponou .%(ext)s." -f 'bestvideo+bestaudio/best' "https://www.youtube.com/watch?v=CvhJWKtBLn4"**

*# získat všechny dostupné informace (výstup do formátu JSON)*<br>
**yt-dlp -j '**{*URL videa, playlistu či kanálu*}**'** [{*URL dalšího*}]...

*# získat popisek videa bez dalších informací*<br>
**yt-dlp -O '%(description)s'** {*URL-videa*}

### Zpracování playlistu či kanálu

*# **rychle** vypsat playlist (obecně/příklad)*<br>
*// Při použití parametru \-\-flat-playlist budou ve formátovacím řetězci fungovat pouze některé parametry (zejména id, title, duration a údaje související s playlistem či kanálem, ostatní položky budou vracet „NA“. Doporučuji předem vyzkoušet, zda bude váš formátovací řetězec s tímto parametrem správně fungovat.*<br>
**yt-dlp \-\-flat-playlist -O '**{*formátovací řetězec*}**'** {*URL-playlistu-či-kanálu*}...<br>
**yt-dlp \-\-flat-playlist -O '%(url,id)s %(title)s' 'https://www.youtube.com/playlist?list=PLXGwauS5zHVbHtwHtc\_4YET61DZwVOSco'**

*# vypsat **každé video z playlistu** (informace ve vlastním formátu)*<br>
**yt-dlp -i -O "**{*formátovací řetězec*}**"** [**-f '**{*formát-videa*}**'**] {*URL-playlistu*}...

*# pro každé video v playlistu YouTube vypsat jeho úplnou adresu*<br>
**yt-dlp -i -O 'https://www.youtube.com/watch?v=%(id)s'** {*URL-playlistu*}...

*# pro každé video v playlistu vypsat jeho index, id a titulek*<br>
**yt-dlp -i -O "%(playlist\_index)d. %(id)s %(title)s"** {*URL-playlistu*}...

*# pro každé video v playlistu vypsat jeho index, id a rozměry nejlepšího formátu*<br>
**yt-dlp -i -O "%(playlist\_index)d. %(id)s %(width)dx%(height)d" -f "bestvideo/best"** {*URL-playlistu*}...

### Stahování titulků

*# vypsat dostupné titulky*<br>
**yt-dlp \-\-list-subs '**{*URL-videa*}**'**

*# stáhnout k videu i titulky (normální/automaticky přeložené)*<br>
*// Formát titulků může být ass, srt, vtt nebo lrc.*<br>
**yt-dlp \-\-write-sub** [**\-\-sub-lang** {*jazyk*}] **\-\-convert-subs** {*formát-titulků*} **"**{*URL-videa*}**"**<br>
**yt-dlp \-\-write-auto-sub** [**\-\-sub-lang** {*jazyk*}] **\-\-convert-subs** {*formát-titulků*} **"**{*URL-videa*}**"**

*# stáhnout s videem titulky a sloučit je do kontejneru/všít do videa*<br>
{*...*} **\-\-embed-subs \-\-write-subs** [**\-\-sub-lang** {*jazyk*}] {*...*}<br>
?

*# stáhnout z videa jen titulky (normální/automaticky přeložené)*<br>
{*...*} **\-\-skip-download \-\-write-subs** [**\-\-sub-lang** {*jazyky*}] {*...*}<br>
{*...*} **\-\-skip-download \-\-write-auto-subs** [**\-\-sub-lang** {*jazyky*}] {*...*}

### Aktualizace programu

*# aktualizovat program*<br>
**rm -fv yt-dlp**<br>
**wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O ./yt-dlp &amp;&amp; (cmp yt-dlp /usr/local/bin/yt-dlp \|\| sudo install -CpvT -o root -g root -m 755 yt-dlp /usr/local/bin/yt-dlp)**<br>
[**rm -fv yt-dlp**]

<!--
*# smazat keš (někdy pomůže, když program přestane fungovat)*<br>
**yt-dlp \-\-rm-cache**
-->

<!--
### Náhled (thumbnail)

*# stáhnout s videem i náhled*<br>
**\-\-write-thumbnail**

*# při stahování do zvukového souboru do něj včlenit náhled jako cover-art*<br>
**\-\-embed-thumbnail**

*# stáhnout místo videa jen náhled*<br>
?
-->

## Parametry příkazů

Začíná-li zaklínadlo v této kapitole příkazem „yt-dlp“, uvádí úplný příkaz; jinak uvádí jen parametry příkazu „yt-dlp“, které je třeba skombinovat s dalšími parametry.

<!--
### yt-dlp

*# *<br>
**yt-dlp** {*parametry*} {*URL-videa*}...<br>
**yt-dlp** {*parametry*} **-a** {*soubor-se-seznamem-URL*}<br>

!parametry:

* -o "{*formátovací řetězec*}" :: Specifikuje cestu a název cílového souboru; viz zaklínadla v podsekci „Parametry ve formátovacím řetězci (-o)“.
* -f "{*volba-formátu*}" :: Definuje, který z dostupných formátů videa či zvuku bude zvolen ke stažení.
* --no-mtime :: Ponechá čas modifikace staženého souboru aktuální. (Jinak se po stažení nastaví na čas uploadu videa.)
* --download-archive {*soubor*} :: Stáhne jen videa neuvedená v souboru; nově stažená videa do souboru zaznamená.
* -i :: Při stahování ignoruje chyby.
-->
<!--
* --ignore-config :: Nečte konfigurační soubor. Vhodné, pokud všechna potřebná nastavení uvádíte jako parametry.
* --no-continue :: Začne stahování od začátku, i když už byla část videa stažena.
-->

## Instalace na Ubuntu

*# *<br>
**sudo apt-get install -y ffmpeg python3 wget**<br>
**sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp**<br>
**sudo chmod u=rwx,go=rx /usr/local/bin/yt-dlp**

## Ukázka

*# *<br>
**yt-dlp "https://www.youtube.com/watch?v=CvhJWKtBLn4"**

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Pokud stahování z některé služby přestane fungovat, první, co je třeba vyzkoušet, je aktualizovat program.
* Důrazně doporučuji si na volání příkazu „yt-dlp“ vytvořit skripty (popř. funkce či aliasy), které mu předají obvyklá nastavení. Parametry sice lze vložit také do konfiguračního souboru, ale dle mých zkušeností jsou skripty či aliasy praktičtější.
* Pole „%(url)s“ není v některých kontextech k dispozici, pomůže ho v takovém případě nahradit polem „%(id)s“.

<!--
Možná u yt-dlp není aktuální
* Je-li video v playlistu nedostupné, ___________ na něm skončí s chybou. Přimějete-li ho pokračovat parametrem **-i**, přeskočí nedostupné video, jako by v playlistu nebylo.
-->

## Další zdroje informací
*# *<br>
**yt-dlp \-\-help** [**\| less**]

Pro podrobný popis formátovacího řetězce a mechanismu automatického výběru formátu ke stažení navštivte oficiální dokumentaci. Bohužel, veškerá oficiální nápověda je jen v angličtině.

* [Článek: Pět tipů pro přehrávání webového videa](https://www.root.cz/clanky/pet-tipu-pro-prehravani-weboveho-videa/)
* [Oficiální dokumentace](https://github.com/yt-dlp/yt-dlp/blob/master/README.md) (anglicky)
* [Video: Downloading Videos, Music and More with Youtube DL](https://www.youtube.com/watch?v=9A-HLSvtBWc) (anglicky)
* [Video: Command Line App For Downloading YouTube Videos](https://www.youtube.com/watch?v=fOjP-7-gI4Y) (anglicky)
<!-- * [Oficiální stránka](https://ytdl-org.github.io/youtube-dl/index.html) (anglicky) -->
<!-- * [Balíček Ubuntu](https://packages.ubuntu.com/focal/youtube-dl) (anglicky) -->
<!-- * [Manuálová stránka](http://manpages.ubuntu.com/manpages/focal/en/man1/youtube-dl.1.html) (anglicky) -->
<!-- * [TL;DR stránka „youtube-dl“](https://github.com/tldr-pages/tldr/blob/master/pages/common/youtube-dl.md) (anglicky) -->
<!--* [Návod na vypsání playlistu](https://archive.zhimingwang.org/blog/2014-11-05-list-youtube-playlist-with-youtube-dl.html) (anglicky) -->

## Zákulisí kapitoly
<!--
- Doplňte, pokud víte. Udržujte aktuální.
-->

V této verzi kapitoly chybí:

!KompaktníSeznam:
* práce s náhledovými obrázky

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* nic

!ÚzkýRežim: vyp
