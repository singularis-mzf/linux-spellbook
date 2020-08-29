<!--

Linux Kniha kouzel, kapitola Stahování videí
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

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
!FixaceIkon: 1754
!ÚzkýRežim: zap

## Úvod

Tato kapitola se zabývá stahováním videí a zvukových záznamů ze služeb jako YouTube,
Instagram, Facebook, MixCloud, Vimeo apod. pomocí programu „youtube-dl“.
Je určena vždy pro jeho nejaktuálnější verzi z oficiálních stránek,
protože každá změna ve webovém rozhraní online služeb může způsobit nefunkčnost
existujících verzí programu a pouze nejnovější verze (je-li řádně aktualizována)
se těmto změnám obvykle poměrně rychle přizpůsobuje.

<!--
## Definice
-->

!ÚzkýRežim: vyp

## Zaklínadla

### Parametry ve formátovacím řetězci (-o)
*# **identifikátor** videa*<br>
**%(id)s** ⊨ CvhJWKtBLn4

*# **název** videa*<br>
**%(title)s** ⊨ Oficiální ASMR booktrailer seriálu Ester Krejčí 1.0

*# správná **přípona** výstupního souboru*<br>
**%(ext)s** ⊨ mkv

*# **šířka/výška** videa*<br>
**%(width)d** ⊨ 1920<br>
**%(height)d** ⊨ 1080

*# **formát** videa (ve formátu pro parametr -f/podrobný popis)*<br>
**%(format\_id)s**<br>
**%(format)s**

*# **datum uploadu** videa*<br>
**%(upload\_date)s** ⊨ 20190618

*# **počítadlo** (pět míst/jen číslo)*<br>
*// Počáteční hodnota počítadla je 1, ale lze ji změnit parametrem „\-\-autonumber-start“.*<br>
**%(autonumber)s** ⊨ 00001<br>
**%(autonumber)d** ⊨ 1

*# index v playlistu (doplněný nulami/jen číslo)*<br>
**%(playlist\_index)s** ⊨ 001<br>
**%(playlist\_index)d** ⊨ 1

*# název kanálu*<br>
**%(uploader)s** ⊨ Mikoláš Štrajt

*# délka videa v sekundách*<br>
**%(duration)d**

*# počet zhlédnutí/liků/disliků*<br>
**%(view\_count)d** ⊨ 12<br>
**%(like\_count)d** ⊨ 1<br>
**%(dislike\_count)d** ⊨ 0

### Výběr formátu (-f)
*# stáhnout **nejlepší** dostupný formát*<br>
**\-f "bestvideo+bestaudio/best"**

*# stáhnout nejlepší dostupný formát s výškou maximálně 480 pixelů*<br>
*// Vhodné hodnoty výšky: 144, 240, 360, 480, 720, 1080, 1440, 2160.*<br>
**\-f "bestvideo[height&lt;=?480]+bestaudio/best[height&lt;=?480]/best"**

*# stáhnout jen co nejlepší **zvuk bez obrazu***<br>
*// Audio-formát může být: best, aac, flac, mp3, m4a, opus, vorbis nebo wav.*<br>
**\-f "bestaudio/best" -x** [**\-\-audio-format** {*audio-formát*}]

*# stáhnout **konkrétní formát***<br>
**\-f** {*číslo-formátu*}

*# stáhnout více různých formátů*<br>
**\-f** {*číslo-formátu-1*}[**,**{*další-číslo-formátu*}]...

### Získat informace o videu

*# vypsat dostupné formáty videa*<br>
**youtube-dl -F** {*URL-videa*}

*# získat o videu informace ve vlastním formátu (obecně/příklad)*<br>
**youtube-dl \-\-get-filename -o "**{*formátovací řetězec*}**"** [**-f** {*formát-videa*}] {*URL-videa*}<br>
**youtube-dl \-\-get-filename -o "Video '%(title)s' od %(uploader)s je k dispozici ve formátu %(format\_id)s s rozměry %(width)dx%(height)d a příponou .%(ext)s." -f bestvideo+bestaudio/best "https://www.youtube.com/watch?v=CvhJWKtBLn4"**

*# získat všechny dostupné informace (výstup do formátu JSON) o jednom videu/o více videích/o videích v playlistu*<br>
**youtube-dl -j** {*URL-videa*}<br>
**youtube-dl -J** {*URL-videa*} {*URL-dalšího-videa*}...<br>
**youtube-dl -J** {*URL-playlistu-či-kanálu*}

*# získat popisek videa bez dalších informací*<br>
**youtube-dl \-\-get-description** {*URL-videa*}

### Zpracování playlistu či kanálu

*# **rychle vypsat playlist***<br>
*// Při použití parametru \-\-flat-playlist budou ve formátovacím řetězci fungovat pouze parametry %(id)s a %(title)s! Žádné jiné pravděpodobně fungovat nebudou!*<br>
**youtube-dl \-\-flat-playlist \-\-get-filename -o "**{*formátovací řetězec*}**"** {*URL-playlistu-či-kanálu*}...

*# vypsat **každé video z playlistu** ve vlastním formátu (1 video na řádek)*<br>
**youtube-dl -i \-\-get-filename -o "**{*formátovací řetězec*}**"** [**-f** {*formát-videa*}] {*URL-playlistu*}...

*# pro každé video v playlistu YouTube vypsat jeho úplnou adresu*<br>
**youtube-dl -i \-\-get-filename -o "https://www.youtube.com/watch?v=%(id)s"** {*URL-playlistu*}...

*# pro každé video v playlistu vypsat jeho index, id a titulek*<br>
**youtube-dl -i \-\-get-filename -o "%(playlist\_index)d. %(id)s %(title)s"** {*URL-playlistu*}...

*# pro každé video v playlistu vypsat jeho index, id a rozměry nejlepšího formátu*<br>
**youtube-dl -i \-\-get-filename -o "%(playlist\_index)d. %(id)s %(width)dx%(height)d" -f "bestvideo/best"** {*URL-playlistu*}...

### Aktualizace programu

*# je-li nainstalován pro všechny uživatele*<br>
**sudo youtube-dl -U**

*# je-li nainstalován jen pro vás*<br>
**wget https://yt-dl.org/downloads/latest/youtube-dl -O ~/bin/youtube-dl**

### Náhled (thumbnail)

*# stáhnout s videem i náhled*<br>
**\-\-write-thumbnail**

*# při stahování do zvukového souboru do něj včlenit náhled jako cover-art*<br>
**\-\-embed-thumbnail**

*# stáhnout místo videa jen náhled*<br>
?

### Stahování titulků
*# vypsat dostupné titulky*<br>
**youtube-dl \-\-list-subs** {*URL-videa*}

*# stáhnout k videu i titulky (normální/automaticky přeložené)*<br>
*// Formát titulků může být ass, srt, vtt nebo lrc.*<br>
**youtube-dl \-\-write-sub** [**\-\-sub-lang** {*jazyk*}] **\-\-convert-subs** {*formát-titulků*} **"**{*URL-videa*}**"**<br>
**youtube-dl \-\-write-auto-sub** [**\-\-sub-lang** {*jazyk*}] **\-\-convert-subs** {*formát-titulků*} **"**{*URL-videa*}**"**

*# stáhnout s videem titulky a sloučit je do jednoho kontejneru (typicky mkv)*<br>
**youtube-dl \-\-write-sub** [**\-\-sub-lang** {*jazyk*}] **\-\-embed-subs "**{*URL-videa*}**"**<br>

*# stáhnout z videa jen titulky (normální/automaticky přeložené)*<br>
?<br>
?

*# stáhnout s videem titulky (normální/automaticky přeložené) a všít je do videa*<br>
?<br>
?

## Parametry příkazů

Začíná-li zaklínadlo v této kapitole příkazem „youtube-dl“, uvádí úplný příkaz; jinak uvádí jen parametry příkazu „youtube-dl“, které je třeba skombinovat s dalšími parametry.

### youtube-dl

*# *<br>
**youtube-dl** {*parametry*} {*URL-videa*}...<br>
**youtube-dl** {*parametry*} **-a** {*soubor-se-seznamem-URL*}<br>

!parametry:

* -o "{*formátovací řetězec*}" :: Specifikuje cestu a název cílového souboru; viz zaklínadla v podsekci „Parametry ve formátovacím řetězci (-o)“.
* -f "{*volba-formátu*}" :: Definuje, který z dostupných formátů videa či zvuku bude zvolen ke stažení.
* --no-mtime :: Ponechá čas modifikace staženého souboru aktuální. (Jinak se po stažení nastaví na čas uploadu videa.)
* -i :: Při stahování ignoruje chyby.
* --ignore-config :: Nečte konfigurační soubor. Vhodné, pokud všechna potřebná nastavení uvádíte jako parametry.
* --no-continue :: Začne stahování od začátku, i když už byla část videa stažena.

## Instalace na Ubuntu

Aktuální instalační postup „youtube-dl“ hledejte na [oficiálních stránkách youtube-dl](https://ytdl-org.github.io/youtube-dl/download.html).

Zde uvádím trochu složitější postup, který sestává z následujících kroků: nejprve musíte samotný program stáhnout, pak můžete zkontrolovat jeho elektronický podpis (ačkoliv stahování z https je už samo o sobě slušná ochrana před podvržením). A nakonec ho musíte nainstalovat; buď pro všechny uživatele (což je běžná, doporučovaná cesta), nebo jen pro sebe (což nevyžaduje použití „sudo“).

*# stažení (nezbytná část)*<br>
**sudo apt-get install -y python wget**<br>
**wget https://yt-dl.org/downloads/latest/youtube-dl -O youtube-dl**<br>

*# kontrola elektronického podpisu (volitelná)*<br>
**wget https://yt-dl.org/downloads/latest/youtube-dl.sig -O youtube-dl.sig**<br>
**gpg \-\-verify youtube-dl.sig youtube-dl**<br>
!: Pokud chcete, zkontrolujte, zda vypsaný otisk klíče odpovídá jednomu z otisků uvedených na oficiální stahovací stránce.
**rm youtube-dl.sig**<br>

*# instalace pro všechny uživatele*<br>
**sudo install -o root -g root -m u=rwx,go=rx youtube-dl /usr/local/bin/youtube-dl &amp;&amp; rm youtube-dl**

*# instalace pouze pro současného uživatele (alternativa k instalaci pro všechny)*<br>
**install -D -m u=rwx,go=- youtube-dl ~/bin/youtube-dl &amp;&amp; rm youtube-dl**

*# vytvoření konfiguračního souboru (volitelné)*<br>
**mkdir -pv ~/.config/youtube-dl**<br>
**touch ~/.config/youtube-dl/config**

V repozitáři Ubuntu sice je balíček „youtube-dl“, ale zpravidla zastaralý a již nefunkční, protože rozhraní streamovacích služeb se často mění.

## Ukázka

*# *<br>
**youtube-dl "https://www.youtube.com/watch?v=CvhJWKtBLn4"**

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Pokud stahování z některé služby přestane fungovat, první, co je třeba vyzkoušet, je aktualizovat program.
* Budete-li příkaz „youtube-dl“ používat často, doporučuji si na jeho volání vytvořit skripty, funkce či aliasy, které předvyplní nejčastěji používané parametry (zejména -f a -o, popř. \-\-no-mtime). Parametry sice můžete vložit také do konfiguračního souboru, ale budete-li používat youtube-dl více různými způsoby, skripty či aliasy jsou praktičtější.
* Je-li video v playlistu nedostupné, youtube-dl na něm skončí s chybou. Přimějete-li ho pokračovat parametrem **-i**, přeskočí nedostupné video, jako by v playlistu nebylo.

## Další zdroje informací
*# *<br>
**youtube-dl \-\-help** [**\| less**]

Pro podrobný popis formátovacího řetězce a mechanismu automatického výběru formátu ke stažení navštivte oficiální dokumentaci. Bohužel, veškerá oficiální nápověda je jen v angličtině.

* [Článek: Pět tipů pro přehrávání webového videa](https://www.root.cz/clanky/pet-tipu-pro-prehravani-weboveho-videa/)
* [Oficiální dokumentace](https://github.com/ytdl-org/youtube-dl/blob/master/README.md) (anglicky)
* [Video: Downloading Videos, Music and More with Youtube DL](https://www.youtube.com/watch?v=9A-HLSvtBWc) (anglicky)
* [Video: Command Line App For Downloading YouTube Videos](https://www.youtube.com/watch?v=fOjP-7-gI4Y) (anglicky)
* [Oficiální stránka](https://ytdl-org.github.io/youtube-dl/index.html) (anglicky)
* [Balíček Ubuntu](https://packages.ubuntu.com/focal/youtube-dl) (anglicky)
* [Manuálová stránka](http://manpages.ubuntu.com/manpages/focal/en/man1/youtube-dl.1.html) (anglicky)
* [TL;DR stránka „youtube-dl“](https://github.com/tldr-pages/tldr/blob/master/pages/common/youtube-dl.md) (anglicky)
* [Návod na vypsání playlistu](https://archive.zhimingwang.org/blog/2014-11-05-list-youtube-playlist-with-youtube-dl.html) (anglicky)

!ÚzkýRežim: vyp
