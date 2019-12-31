<!--

Linux Kniha kouzel, Jak přispět
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
# Jak přispět

## Jak nahlásit nefunkční zaklínadlo

Verze „vanilková příchuť 1.x“ jsou navázány na Ubuntu 18.04 a verze „vanilková příchuť 2.x“ budou navázány na Ubuntu 20.04. Pokud v české lokalizaci dané verze operačního systému některé zaklínadlo uvedené v příslušné verzi Linuxu: Knihy kouzel nefunguje (a není to poznamenáno v poznámce pod čarou či to nevyplývá z úvodu kapitoly), znamená to, že je chybné a je žádoucí to nahlásit.

Při hlášení prosím použijte následující vzor:

### Fiktivní příklad správného nahlášení chyby:


**Přesný postup, jak navodit chybu na „čistém systému“:**

    sudo apt-get install gawk
    gawk -version

**Co by měl příkaz podle Linuxu: Knihy kouzel správně udělat:**<br>
Příkaz by měl vypsat nainstalovanou verzi gawk.

**Co ve vašem případě udělá:**<br>
Příkaz mi vypíše: „gawk: \`ersion' argument to \`-v' not in \`var=value' form“.

**Přesná verze LKK, název kapitoly a umístění zaklínadla:**<br>
Vanilková příchuť 1.0, kapitola „AWK“, sekce 6 „Parametry příkazů“.

**Jak by to mělo být správně (nepovinné; jen pokud to víte):**<br>
Správně by mělo být --version.

## Jak napsat zaklínadlo
![ve výstavbě](obrazky/ve-vystavbe.png)
Ve výstavbě...

Základní forma zaklínadla je následující:

    *# titulek*<br>
    **co má uživatel zadat doslovně** {*co má doplnit*} [**volitelná část**]

* Každý nebílý znak, který se má při použití zaklínadla objevit tak, jak je, musí být v Markdownu vyznačen tučně.
* Každý řádek zaklínadla kromě posledního musí končit značkou &lt;br&gt;.

## Jak napsat kapitolu
![ve výstavbě](obrazky/ve-vystavbe.png)
Ve výstavbě...

## Jak organizovat kapitolu
![ve výstavbě](obrazky/ve-vystavbe.png)
Ve výstavbě...

## Jak přidat podporu nového znaku
![ve výstavbě](obrazky/ve-vystavbe.png)
Ve výstavbě...
