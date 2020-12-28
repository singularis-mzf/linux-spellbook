<!--

Linux Kniha kouzel, dokumentace: Perl bez balíčku DEB
Copyright (c) 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
# Perl bez balíčku DEB

**STAV TEXTU:** aktuální

Kapitoly Linuxu: Knihy kouzel o programovacím jazyce Perl vyžadují
určité dodatečné funkce a nastavení, která vám může pohodlně zprostředkovat
skript spouštěče „lkk“ dodávaný v balíčku typu DEB.
Tato kapitola popisuje, jak tyto funkce zpřístupnit a nastavení provést
bez balíčku, např. na systémech, které nepoužívají balíčkovací systém DPKG.

## Nejjednodušší postup

1. Zvolte si adresář pro modul Linuxu: Knihy kouzel.
2. Do zvoleného adresáře stáhněte soubor modulu [LinuxKnihaKouzel.pm](../skripty/lkk/LinuxKnihaKouzel.pm).
3. Svůj skript Perlu vždy spouštějte následujícím příkazem, kde za {/adresář/modulu} dosadíte absolutní cestu adresáře, kam jste stáhl/a soubor modulu (nezapomeňte na případné odzvláštnění), a za {skript.pl} cestu k souboru skriptu:

``perl -CSDAL -I{/adresář/modulu} -Mv5.26.0 -Mstrict -Mwarnings -Mutf8 -MEnglish -MLinuxKnihaKouzel {skript.pl}``

Pokud chcete skriptu předat parametry, umístěte je na konec, za cestu k souboru skriptu.

Konkrétní příklad:

``perl -CSDAL -I/home/vlasta/perl -Mv5.26.0 -Mstrict -Mwarnings -Mutf8 -MEnglish -MLinuxKnihaKouzel ../moje-skripty/test1.pl *.txt``

Pokud některý požadovaný modul ve vašem systému chybí (a Perl si na to bude stěžovat), budete ho muset doinstalovat z repozitářů. Např. na Fedoře 33 chybí modul English, proto je nutno ho doinstalovat příkazem: ``sudo dnf install perl-English``

## Podrobnější vysvětlení k parametrům

* Parametr „-CSDAL“ zapíná některé vlastnosti podpory Unicode. Tento parametr musí být předán na příkazové řádce a není nahraditelný ve zdrojovém kódu.
* Parametr „-I“ přidává vámi zvolený adresář do cesty, kde budou vyhledávány moduly. Je nutný, aby Perl našel modul Linuxu: Knihy kouzel.
* Parametry „-M“ vkládají na začátek hlavního souboru skriptu příkazy „use“, abyste je tam nemusel/a psát ručně jako u souborů modulů.

Podrobnější informace o významu těchto parametrů naleznete v dokumentaci Perlu v souboru [perldoc](https://perldoc.perl.org/5.30.0/perlrun).

Parametry „-I“ a „-M“ můžete z příkazové řádky vynechat, pokud na začátek hlavního skriptu přidáte tyto řádky:

``use utf8;``<br>``use lib("{/adresář/modulu}");``<br>``use v5.26.0;``<br>``use strict;``<br>``use warnings;``<br>``use English;``<br>``use LinuxKnihaKouzel;``

## Podrobnější vysvětlení k modulu

Modul *LinuxKnihaKouzel.pm* plní podobnou úlohu jako „pomocná kolečka“
u jízdního kola. Definuje nebo nabízí několik (zpravidla velmi jednoduchých)
funkcí, které ve výchozím stavu (bez dalších příkazů „use“) v Perlu nejsou dostupné,
ale dle mého názoru by měly (např. alength(), array(), bool(), croak(),
min(), max(), fprintf()).

Soubor modulu podléhá licenci CC0 (jak je poznamenáno v jeho záhlaví),
můžete ho tedy (bez spouštěče „lkk“) přibalit jakýmkoliv způsobem
k jakémukoliv projektu bez dalších podmínek.
