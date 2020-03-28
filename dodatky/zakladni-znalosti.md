<!--

Linux Kniha kouzel, dodatek Základní znalosti
Copyright (c) 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Základní znalosti

!ÚzkýRežim: zap

## Odzvláštňování

Když v terminálu zadáte příkaz, některé znaky budou zpracovány jako obyčejné
– tedy jako znaky tvořící název příkazu či obsah jeho parametrů. Jiné znaky
pak mají pro bash (popř. jiný intepret příkazového řádku) zvláštní význam,
např. mezera odděluje název příkazu od prvního parametru a pak také
jednotlivé parametry od sebe. Někdy ale potřebujete, aby se znak, který má normálně
zvláštní význam, zpracoval stejně jako obyčejné znaky, a právě k tomu
slouží „odzvláštňování“.

Základní (a velmi rozšířený) způsob odzvláštnění znaku je vložení zpětného lomítka
před tento znak. Srovnejte tyto dva příkazy:

*# *<br>
**ls -l**<br>
**ls\\ -l**

První příkaz je tvořen názvem příkazu „ls“ a parametrem „-l“, druhý příkaz pak
představuje volání příkazu „ls -l“ bez parametru. A protože příkaz „ls -l“ neexistuje,
skončí takový příkaz chybou.

V bashi mají zvláštní význam tyto znaky ASCII: konec řádku, mezera, !, ", #, $, &amp;, ',
(, ), \*, ;, &lt;, =, &gt;, ?, [, \\, ], \`, {, \|, }, ~. Možná je snazší si zapamatovat,
které „speciálně vypadající“ znaky zvláštní význam v bashi nemají: %, +, „,“, -, ., /, :, @, ^, \_.

Protože je však odzvláštňování zpětným lomítkem nepraktické, používají se ke stejnému
účelů tři druhy uvozovek. Bash analyzuje zadaný příkaz zleva doprava, a když narazí
na sekvencí „"“, „'“ nebo „$'“, přepne se jednoho z režimů uvozovek, kde si svůj zvláštní
význam zachovává pouze omezená množina znaků, konkrétně:

* Ve dvojitých uvozovkách „"text"“ si zvláštní význam uchovávají znaky !, ", $, \\ a \`. Všechny uvedené znaky kromě ! lze i uvnitř dvojitých uvozovek odzvláštnit zpětným lomítkem.
* V apostrofech „'text'“ zůstává zvláštní význam pouze znaku ', jehož odzvláštnění v tomto případě není možné.
* V apostrofech s dolarem ($'') zůstává zvláštní význam pouze znakům ' a \\. Oba tyto znaky lze ale odzvláštnit zpětným lomítkem. Navíc je v těchto apostrofech interpretována široká škála sekvencí umožňujících zadat řídicí znaky (např. \\n, \\t apod.).

## Manuálové stránky a další zdroje

Pokud objevíte nějaký příkaz a zajímá vás, co dělá a jaké přijímá volby,
přestaňte googlit! Online zdroje jsou totiž buď zastaralé, nebo naopak pokrývají nejnovější
verzi příkazu, kterou budete mít ve svém systému možná až za pár let.

Běžný postup, jak informace o příkazu (jako příklad uvedu příkaz „xxd“) zjistit, je následující:

* „man xxd“
* „xxd \-\-help“ nebo „xxd -h“ (musíte vyzkoušet, která z variant platí; někdy to budou obě)
* „info xxd“ (někdy obsahuje podrobnější informace než manuálová stránka, jindy je to jen manuálová stránka v jiném prohlížeči)
* prozkoumat adresář „/usr/share/doc/xxd“ (pokud pro daný příkaz existuje) – někdy budete příjemně překvapen/a, jak cenné informace tam najdete

Výjimkou jsou vestavěné příkazy bashe (např. „echo“, „printf“, „cd“, „exec“ apod.).
K těm hledejte nápovědu:

* „help příkaz“ (např. „help echo“; zkuste také „help help“)
* „man bash“ a hledejte v sekci „SHELL BUILTIN COMMANDS“

Teprve pokud uvedené postupy selžou nebo neposkytnou dostatečně podrobné informace,
hledejte oficiální stránku daného programu nebo jiný dostatečně věrohodný online zdroj.
Online zdroje vám také mohou pomoci v případě, kdy potřebujete funkci, která ve verzi
příkazu dostupné ve vašem systému, není podporovaná. V takovém případě vám mohou poradit,
jakou verzi potřebujete a jak ji do vašeho systému nainstalovat.

!ÚzkýRežim: vyp
