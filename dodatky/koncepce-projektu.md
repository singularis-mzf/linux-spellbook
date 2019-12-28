<!--

Linux Kniha kouzel, část Koncepce projektu Linux: Kniha kouzel
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Koncepce projektu Linux: Kniha kouzel

!ÚzkýRežim: zap

## Základní cíle projektu (heslovitě)

* Ukázat začátečníkům v Ubuntu, jaké možnosti jim jejich operační systém nabízí.
* Začátečníkům i pokročilým pomoci najít a použít funkce Linuxu, které potřebují.

## Závazná pravidla

* Cílem projektu je sdílení znalostí mezi pokročilými a začínajícími uživateli Linuxu tak, že projekt umožní pokročilým uživatelům sepisovat, přehledně organizovat a sdílet svoje nejčastěji používaná zaklínadla („snippets“) a začátečníkům umožní je (pokročilé) přitom sledovat a odnést si z toho v rámci jejich (začátečníků) schopností co nejvíc.
* Koncepce není neměnná. Bude se mírně přizpůsobovat zjištěným potřebám obou cílových skupin; zájmy začátečníků a pokročilých přitom musejí zůstat v rovnováze, aby byli pokročilí motivováni přispívat a většina jejich příspěvků byla užitečná i začátečníkům.
* Zaklínadla jsou v každé úrovni řazena od užitečnějších k méně užitečným. Úzce související zaklínadla (např. na přidání a odebrání objektu) jsou však seskupena k sobě a jejich užitečnost je posuzována společně.
* Při psaní kódu jednotlivých zaklínadel mějme na paměti, že náš kód budou používat i lidé, kteří mu nerozumí a nezvládnou opravit naše chyby. Proto pišme kód robustní, důkladně ho testujme a známá omezení dokumentujme (např. v poznámkách pod čarou).
* Duplicita není zakázána. Stejné zaklínadlo se může objevit ve více podsekcích jedné kapitoly či ve více kapitolách, pokud to bude dávat smysl.
* V kapitole (zpravidla především v sekci „Instalace na Ubuntu“) musejí být zmíněny všechny balíčky, které může být nutné doinstalovat ke zproznění zaklínadel na některé z podporovaných verzí operačního systému.

## Doporučení

* Kód zaklínadel má být spíš robustní než jednoduchý.
* Formátování a uspořádání kapitol a zaklínadel v nich má být převážně jednotné, aby se usnadnila uživateli rychlá orientace.
* Primárním cílem PDF výstupu je tištěná podoba, proto je formátování PDF optimalizováno výhradně pro ni, ne pro čtení na počítači. Primárním cílem HTML výstupu je zobrazení na počítači a možnost zaklínadla vykopírovat (Ctrl+C/Ctrl+V) a přímo použít. Proto musí být kód zaklínadla vykopírovaný z HTML výstupu po doplnění položek „doplň“ okamžitě a bez dalších úprav použitelný a funkční.
* Snažme se psát zaklínadla co nejkratší a nejefektivnější při zachování robustnosti, i za cenu toho, že nebudou srozumitelná. (Za deset zpětných lomítek po sobě není třeba se stydět...)
* U příkazů, které vyžadují oprávnění superuživatele, používáme sudo, kdekoliv je to možné, dokonce i u příkazů určených ke spuštění v jednouživatelském režimu, kde to není nezbytné. Účelem je přehledná dokumentace faktu, že příkaz spuštění superuživatelem vyžaduje. Výjimkou jsou příkazy určené výhradně ke spouštění v kontejneru Dockeru, kde se sudo obvykle nepoužívá a mohlo by být matoucí.

<!--

Netušíte-li například jak naplánovat vyskakovací oznámení na dnešních 15.30, jak začít
psát svoje poznámky v Markdownu a nechat je automaticky zformátovat do HTML,
jak zmenšit všechny svoje fotografie a odstranit z nich EXIF data,
nebo jak otočit svoje oblíbené video o 180° a všít do něj titulky, je toto kniha pro vás.

-->
!ÚzkýRežim: vyp
