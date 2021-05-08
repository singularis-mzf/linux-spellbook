<!--

Linux Kniha kouzel, dokumentace: Návody
Copyright (c) 2020, 2021 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Návody

## Jak přidat novou kapitolu

**STAV TEXTU:** hotový

Toto je poměrně snadný úkol.

1. Vytvořte ze šablony [\_šablona.md](../kapitoly/_šablona.md) nový zdrojový soubor v adresáři „kapitoly“. Jeho název bez přípony „.md“ bude sloužit jako ID kapitoly. ID kapitoly může být tvořeno malými písmeny české abecedy, pomlčkami, podtržítky a číslicemi, nesmí však být tvořeno pouze číslicemi a nesmí být prázdné.
2. Doplňte do souboru název kapitoly (na 2 místa) a vlastní licenční záhlaví do hlavičky (původní ponechejte).
3. ID nové kapitoly doplňte do [seznamu seznamy/kapitoly.seznam](../seznamy/kapitoly.seznam), resp. [../seznamy/dodatky.seznam](seznamy/dodatky.seznam).
4. ID nové kapitoly doplňte jako nový řádek do souboru „pořadí-kapitol.seznam“, aby se kapitola generovala na výstup.
5. Zkuste vše přeložit příkazem „make“ a zkontrolujte, že se nová kapitola přeložila.

Pak už můžete novou kapitolu začít plnit obsahem.

<!--
## Jak přidat podporu nového znaku

1. Zjistěte, jak daný znak vysázet v LaTeXu.
2. Ve skriptu [do\_latexu.awk](../skripty/do\_latexu.awk) ve funkci ZpracujZnak() přidejte novou větev přepínače pro obsluhu vámi zvoleného znaku.
3. Pokud daný znak vyžaduje zvláštní zacházení ve formátu HTML, učiňte totéž i ve skriptu [do\_html.awk](../skripty/do\_html.awk), většinu znaků však bude možno do HTML zkopírovat přímo.
4. Do zvláštní kapitoly [\_ukázka](../kapitoly/_ukázka.md) doplňte nový znak do seznamu podporovaných znaků.
5. Pokud kapitola „\_ukázka“ není uvedena v souboru „pořadí-kapitol.lst“, doplňte ji tam.
6. Zkuste přeložit všechny výstupní formáty příkazem „make“ a zkontrolujte překlad kapitoly „Ukázka“, zda v každém výstupním formátu, kromě formátu LOG, obsahuje korektně vysázený nový znak.

Pokud má být nový znak v Markdownu zadávaný HTML entitou nebo jiným nestandardním způsobem,
budete muset navíc navštívit skript [hlavni.awk](../skripty/hlavni.awk)
a doplnit interpretaci nové entity do funkce FormatovatRadek(), případně
i do funkce ZpracujZnaky(), pokud má být entita interpretována v kontextech
nepodporujících formátování jako např. URL adresy.
-->
