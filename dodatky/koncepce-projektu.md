<!--

Linux Kniha kouzel, část Koncept projektu Linux: Kniha kouzel
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Koncept projektu Linux: Kniha kouzel

## Závazná pravidla

* Cílem projektu je sdílení znalostí mezi pokročilými a začínajícími uživateli Linuxu tak, že projekt umožní pokročilým uživatelům sepisovat, přehledně organizovat a sdílet svoje nejčastěji používaná zaklínadla („snippets“) a začátečníkům umožní je (pokročilé) přitom sledovat a odnést si z toho v rámci jejich (začátečníků) schopností co nejvíc.
* Koncepce není neměnná. Bude se mírně přizpůsobovat zjištěným potřebám obou cílových skupin; zájmy obou cílových skupin přitom musejí zůstat v rovnováze, aby byli pokročilí motivováni přispívat a jejich příspěvky byly převážně užitečné i začátečníkům.
* Zaklínadla jsou v každé úrovni řazena od užitečnějších k méně užitečným. Úzce související zaklínadla (např. na přidání a odebrání objektu) jsou však seskupena k sobě a jejich užitečnost je posuzována společně.
* Při psaní kódu jednotlivých zaklínadel mějme na paměti, že náš kód budou používat i lidé, kteří mu nerozumí a nezvládnou opravit naše chyby. Proto pišme kód robustní, důkladně ho testujme a známá omezení dokumentujme (např. v poznámkách pod čarou).
* Duplicita není zakázána. Stejné zaklínadlo se může objevit ve více podsekcích jedné kapitoly či ve více kapitolách, pokud to bude dávat smysl.
* V kapitole (zpravidla především v sekci „Instalace na Ubuntu“) musejí být zmíněny všechny balíčky, které může být nutné doinstalovat ke zproznění zaklínadel na některé z podporovaných verzí operačního systému.

## Doporučení

* Kód zaklínadel má být spíš robustní než jednoduchý.
* Formátování a uspořádání kapitol a zaklínadel v nich má být převážně jednotné, aby se usnadnila uživateli rychlá orientace.
* Primárním cílem PDF výstupu je tištěná podoba, proto jsou optimalizovány výhradně pro ni, ne pro čtení na počítači. Primárním cílem HTML výstupu je zobrazení na počítači a možnost zaklínadla vykopírovat a přímo použít. Proto musí být kód zaklínadla vykopírovaný z HTML výstupu po doplnění položek „doplň“ okamžitě použitelný a spustitelný v příkazovém řádku.
* Snažme se psát zaklínadla co nejkratší a nejefektivnější při zachování robustnosti, i za cenu toho, že nebudou srozumitelná.
* U příkazů, které vyžadují oprávnění superuživatele, používáme sudo, kdekoliv je to možné, dokonce i u příkazů určených ke spuštění v jednouživatelském režimu, kde to není nezbytné. Účelem je přehledná dokumentace faktu, že příkaz spuštění superuživatelem vyžaduje.
