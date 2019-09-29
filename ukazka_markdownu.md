<!--

Linux Kniha kouzel, soubor ukazka_markdownu.md
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Ukázka Markdownu
## Nadpis druhé úrovně
Text prvního
odstavce obsahuje část **tučně**, část *kurzívou* a část <u>podtrženou</u> a také ``vložený kód``.

Text druhého odstavce, který místo toho obsahuje tři formy hypertextového odkazu: [s&nbsp;textem](http://www.slovnik-synonym.cz/), [s&nbsp;id][Slovník synonym] a <http://www.slovnik-synonym.cz/>.

Odstavec může obsahovat malý obrázek jako např. ![tento][ve výstavbě] nebo ![tento](../obrazky/ve-vystavbe.png).

[Slovník synonym]: http://www.slovnik-synonym.cz/
[ve výstavbě]: ../obrazky/ve-vystavbe.png

### Víceřádkový kód
    #include <stdio.h>

    int main()
    {
        printf("Hello, world.\n");
    }

#### Seznamy
##### Odrážkovaný
* Odrážkovaný seznam.
* Druhá pložka.

##### Číslovaný
1. Číslovaný seznam.
1. Druhá položka.

## Ostatní
> Odstavec odsazený
na první úroveň.

> > Odstavec odsazený
na druhou úroveň.

### Horizontální čára
***

## Markdown Extra
### Víceřádkový kód {#viceradkovy}
~~~ .kod
#include <stdio.h>

int main()
{
    printf("Hello, world.\n");
}
~~~

### Tabulka
| Sloupec 1 | Sloupec 2 | Sloupec 3
| :--- | --- | ---:
| vlevo | na střed | vpravo

### Definice
Jablko
Hruška
: Ovoce...

Mrkev
: Mrkev není ovoce.
Je to zelenina[^pozn-pod-carou].

[^pozn-pod-carou]: Toto je poznámka pod čarou k&nbsp;zelenině.
