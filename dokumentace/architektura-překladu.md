<!--

Linux Kniha kouzel, dokumentace: Architektura překladu
Copyright (c) 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
# Architekura překladu

**STAV TEXTU:** rozepsaný

Samotný překlad ze zdrojového kódu v Markdownu zajišťují skripty v adresáři
**skripty/překlad**. Jejich společným základem je skript
[hlavní.awk](../skripty/překlad/hlavní.awk),
který provádí lexikální analýzu zdrojového kódu kapitoly či dodatku
a pro jednotlivé prvky volá funkce definované v jednom ze zbylých tří skriptů
(podle toho, který formát se zrovna překládá). Řetězce vrácené těmito
funkcemi pospojuje a vypíše do mezisouboru, který se pak dále zpracovává.

Všechny skripty do\_\*.awk mají stejnou strukturu; liší se jen obsluha
jednotlivých prvků.

## Funkce ve skriptech do\_\*.awk

### ZpracujZnak(znak)

Volá se pro každý normální znak, který se má zapsat do výstupního formátu.
Pokud je znak ve zdrojovém kódu odzvláštněný (např. „\\\*“), zavolá se tato
funkce jen na znak, jak má být zapsán (tzn. v tomto případě ZpracujZnak("\*")).

Funkce vrací řetězec, který se má vypsat na výstup.

Funkce ZpracujZnak() se nevolá pro bílé znaky (tzn. ani pro konce řádků).

### ZpracujBilyZnak(znak, opakovany)

Tato funkce se volá pro každý bílý znak ve zdrojovém souboru.
Parametr „opakovany“ je pravdivý, právě tehdy když daný bílý znak následuje
bezprostředně po stejném znaku.

### ZpracujChybnyZnak(znak)

Tato funkce se volá pro znaky na řádkách zaklínadel mimo tučné písmo,
pokud nemají řídicí význam. Takové znaky jsou pravděpodobně chybné,
ale současná implementace to nepovažuje za kritickou chybu.

### Tabulator(delka)

Tato funkce se volá pro značky &lt;tab1&gt; až &lt;tab8&gt; a má vygenerovat
tabulátor zadané délky.

### ZacatekKapitoly(nazevKapitoly, cisloKapitoly, stitky, osnova, ikonaKapitoly, jeDodatek)

Tato funkce se volá právě jednou, na začátku kapitoly. Je to první funkce,
která je při překladu volána.

Parametry mají následující význam a formát:

| Parametr | Popis | Příklad |
| :--- | :--- | :--- |
| nazevKapitoly | Název kapitoly. | "Zpracování textových souborů" |
| cisloKapitoly | Číslo kapitoly. Pokud kapitola není určena na výstup, použije se 0. | 12 |
| stitky | Štítky kapitoly //TODO: Formát? | ? |
| osnova | Pole... | |
| ikonaKapitoly | Cesta k ikoně kapitoly, ve stejném formátu jako ve *fragmenty.tsv*. | "ik/zpracovani-textovych-souboru.png" |
| jeDodatek | Parametr je pravdivý, právě tehdy když jde o dodatek a ne o kapitolu. | 0 |

### KonecKapitoly(nazevKapitoly, cislaPoznamek, textyPoznamek)

...
(ROZEPSÁNO)
