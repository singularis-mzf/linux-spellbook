<!--

Linux Kniha kouzel, kapitola Datum, čas a kalendář
Copyright (c) 2019-2021 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->
<!--
Poznámky:

⊨

-->

# Datum, čas a kalendář

!Štítky: {tematický okruh}{čas}
!OblíbenáZaklínadla:
!ÚzkýRežim: zap

## Úvod

Obsahem této kapitoly je veškerá práce s hodnotami času a data a kalendářem jako takovým,
to znamená výpočty, formátování, práci s časovými zónami a vizualizace. Kapitola rovněž
pokrývá nastavování systémového a hardwarového času.

Příkaz „date“ je vyvíjen v rámci projektu GNU.

## Definice

* **Časová známka Unixu** je číselná reprezentace okamžiku v čase daná počtem sekund od 00:00:00 UTC 1. ledna 1970. Čas před tímto milníkem se reprezentuje zápornými čísly, pozdější čas kladnými. Obvykle se uvažují celá čísla, ale některé implementace pracují i s desetinnými. Časová známka Unixu se uvádí téměř výhradně v desítkové soustavě.
* **Systémový čas** je čas zpřístupněný systémem programům. Při startu systému se nastaví podle hardwarového času a zaniká vypnutím operačního systému. Systémový čas je obvykle v lokální časové zóně. Protikladem je **hardwarový čas**, což je čas poskytovaný zařízením na základní desce počítače. Hardwarový čas je obvykle v UTC.
* **UTC** je základní celosvětový čas, od kterého se odvozují hodnoty času v jednotlivých časových zónách.

!ÚzkýRežim: vyp

## Zaklínadla: Obecná

### Výstupní formát („date +“ a „strftime“)

Číselné hodnoty (kromě %s) se automaticky zarovnávají nulami (např. leden je měsíc 01),
potlačit to můžete vložením „-“ za %, např. „%-m“ vrátí pro leden „1“;
pro zarovnání mezerami místo nulami tam vložte „\_“, např. „%\_m“ vrátí pro leden „&blank;1“.

*# lokalizované celky*<br>
**%x** ⊨ datum = 31.12.2019<br>
**%X** ⊨ čas (24hodinový) = 23:59:59<br>
**%r** ⊨ čas (12hodinový) = 11:59:59<br>
**%c** ⊨ datum a čas (24hodinový) = Út 31. prosince 2019, 23:59:59 CET

*# nelokalizované celky*<br>
**%D** ⊨ %m/%d/%y = 12/31/19<br>
**%F** ⊨ %Y-%m-%d = 2019-12-31<br>
**%R** ⊨ %H:%M = 23:59<br>
**%T** ⊨ %H:%M:%S = 23:59:59

*# den v týdnu (alternativy)*<br>
**%A** ⊨ Úterý (plný název, lokalizovaný)<br>
**%a** ⊨ Út (zkratka, lokalizovaná)<br>
**%u** ⊨ 2 (číslo 1..7, kde 1 je pondělí)<br>
**%w** ⊨ 2 (číslo 0..6, kde 0 je neděle)

*# **rok** (alternativy)*<br>
**%Y** ⊨ 2010 (4 číslice)<br>
**%C** ⊨ 20 (století)<br>
**%y** ⊨ 10 (dvojčíslí roku)

*# čtvrtletí (ne strftime)*<br>
**%q** ⊨ 3 (číslo 1..4)

*# **měsíc** (alternativy)*<br>
**%m** ⊨ 03 (číslo)<br>
**%B** ⊨ listopad (plný název, lokalizovaný)<br>
**%b** ⊨ lis (zkratka, lokalizovaná)

*# den v měsíci (alternativy)*<br>
**%d** ⊨ 03 (číslo)<br>
**%e** ⊨ &blank;3 (číslo zarovnané mezerou)

*# **hodina** + období dne (alternativy)*<br>
**%H** ⊨ 15 (číslo 00..23)<br>
**%I** ⊨ 03 (číslo 01..12)<br>
**%p** ⊨ AM/PM (lokalizovaně)<br>
**%P** ⊨ am/pm (lokalizovaně)

*# **minuta***<br>
**%M** ⊨ 59 (číslo 00..59)

*# **sekunda***<br>
**%S** ⊨ 59 (číslo 00..61)

*# zlomky sekundy (ne strftime)*<br>
*// Počet „číslic“ by měl být v rozsahu 1 až 9.*<br>
**%**[{*číslic*}]**N** ⊨ 123456789 (počítadlo nanosekund)

*# **časová zóna***<br>
*// strftime jen %z a %Z.*<br>
**%Z** ⊨ CET (zkratka časové zóny)<br>
**%z** ⊨ +0100<br>
**%:z** ⊨ +01:00<br>
**%::z** ⊨ +01:00:00<br>
**%:::z** ⊨ +01 (nejkratší přesné vyjádření)

*# číslo týdne podle ISO normy (týden začíná pondělím)*<br>
**%G** ⊨ 2010 (celé číslo roku)<br>
**%g** ⊨ 10 (dvojčíslí roku)<br>
**%V** ⊨ 03 (číslo týdne 01..53)

*# číslo týdne v roce*<br>
**%W** ⊨ 07 (00..53, týden začíná pondělím)<br>
**%U** ⊨ 07 (00..53, týden začíná nedělí)

*# odzvláštněné znaky (alternativy)*<br>
**%%** ⊨ %<br>
**%n** ⊨ konec řádku<br>
**%t** ⊨ tabulátor

*# časová známka Unixu (ne strftime)*<br>
**%s** ⊨ 1577833199

*# číslo dne v roce*<br>
**%**[**-**]**j** ⊨ 001

### Doporučené vstupní formáty času („date -d“)

*# **lokální čas** (alternativa 1/2/příklady...)*<br>
*// Odpovídá formátům „%F %T“, „%FT%T.%3N“, „%F %T.%9N“, „%FT%T.%6N“ apod.*<br>
*// „f“ je jedna až devět číslic.*<br>
{*rok*}**-**{*měsíc*}**-**{*den*}**&blank;**{*hodina*}**:**{*minuta*}**:**{*sekunda*}[**.**{*f*}]<br>
{*rok*}**-**{*měsíc*}**-**{*den*}**T**{*hodina*}**:**{*minuta*}**:**{*sekunda*}[**.**{*f*}]<br>
**2019-12-31 23:59:59**<br>
**2019-12-31 23:59:59.123456789**<br>
**2019-12-31T23:59:59.123456**

*# čas s udaným **posunem proti UTC** (obecně/příklady)*<br>
*// „posun“ je znaménko a čtyři číslice značící posun oproti UTC v hodinách a minutách, např. „+0100“. Odpovídá formátu „%z“.*<br>
{*rok*}**-**{*měsíc*}**-**{*den*}**&blank;**{*hodina*}**:**{*minuta*}**:**{*sekunda*}[**.**{*f*}]<nic>[**&blank;**]{*posun*}<br>
{*rok*}**-**{*měsíc*}**-**{*den*}**T**{*hodina*}**:**{*minuta*}**:**{*sekunda*}[**.**{*f*}]{*posun*}<br>
**2019-12-31 23:59:59.123456789 -0100**<br>
**2019-12-31T23:59:59.123456+0100**


*# čas v udané **časové zóně** (obecně/příklady...)*<br>
**TZ="**{*časová/zóna*}**"&blank;**{*rok*}**-**{*měsíc*}**-**{*den*}**&blank;**{*hodina*}**:**{*minuta*}**:**{*sekunda*}[**.**{*f*}]<br>
**TZ="Europe/Prague"&blank;2019-12-31&blank;23:59:59.123456**<br>
**TZ="UTC"&blank;2019-12-31&blank;23:59:59.123456789**

*# **UTC čas** (alternativy)*<br>
{*rok*}**-**{*měsíc*}**-**{*den*}**&blank;**{*hodina*}**:**{*minuta*}**:**{*sekunda*}[**.**{*f*}]**Z**<br>
{*rok*}**-**{*měsíc*}**-**{*den*}**T**{*hodina*}**:**{*minuta*}**:**{*sekunda*}[**.**{*f*}]**Z**<br>
{*rok*}**-**{*měsíc*}**-**{*den*}**&blank;**{*hodina*}**:**{*minuta*}**:**{*sekunda*}[**.**{*f*}]<nic>[**&blank;**]**+0000**<br>
{*rok*}**-**{*měsíc*}**-**{*den*}**T**{*hodina*}**:**{*minuta*}**:**{*sekunda*}[**.**{*f*}]**+0000**<br>
**TZ="UTC"&blank;**{*rok*}**-**{*měsíc*}**-**{*den*}**&blank;**{*hodina*}**:**{*minuta*}**:**{*sekunda*}[**.**{*f*}]

*# **časová známka Unixu** (obecně/příklady)*<br>
*// „číslo“ může být kladné i záporné, celé i s desetinnou tečkou. Odpovídá formátu „%s“, resp. „%s.%N“*<br>
**@**{*číslo*}<br>
**@1577750400**<br>
**@-12345.6789**

*# půlnoc daného dne (obecně/příklad)*<br>
*// Odpovíďá formátu „+%F“.*<br>
{*rok*}**-**{*měsíc*}**-**{*den*}<br>
**2019-12-31**

<neodsadit>Příkaz „date“ podporuje i mnoho dalších vstupních formátů; úplná dokumentace v angličtině je dostupná příkazem „info date“, ale v praxi doporučuji omezit se pouze na zde uvedené.

### Čekání

*# počkat určitou dobu*<br>
*// Počet sekund může být i necelé číslo, např. 0.12 počká 120 milisekund. Pro hodnoty pod 100 milisekund ale neočekávejte velkou přesnost.*<br>
**sleep** {*sekund*}...

### Gregoriánský kalendář

*# je **rok přestupný**?*<br>
**test 61 -eq $(date -d** {*rok*}**-03-01 +%-j)**

*# zobrazit kalendář měsíce a **dvou okolních***<br>
**ncal -M3**[**b**]<nic>[**w**] <nic>[{*měsíc-1-až-12*} {*rok*}]

*# zobrazit kalendář měsíce*<br>
**ncal -M**[**b**]<nic>[**w**] <nic>[{*měsíc-1-až-12*}] {*rok*}

*# zobrazit kalendář všech měsíců **v roce***<br>
**ncal -Mb**[**w**] {*rok*}

*# zobrazit kalendář měsíce a N následujících*<br>
**ncal -M**[**b**]<nic>[**w**] **-A** {*N*} [{*měsíc-1-až-12*}] {*rok*}

### Aktuální čas a datum (všechny kalendáře)

*# vypsat aktuální čas (resp. datum): lokální/UTC/v určité časové zóně*<br>
**date** [**+**{*formát*}]<br>
**date -u** [**+**{*formát*}]<br>
**TZ="**{*časová/zóna*}**" date** [**+**{*formát*}]

*# zobrazit kalendář aktuálního měsíce a dvou okolních*<br>
**ncal -M3**[**b**]<nic>[**w**]

### Východ a západ slunce, Velikonoce

*# zjistit čas východu a západu slunce (obecně/příklad: Václavské náměstí v Praze)*<br>
*// Čas východu slunce bude na první řádce výstupu, čas západu slunce na druhé. Pozice-NS je zeměpisná šířka a musí začínat písmenem N (severní) nebo S (jižní) a pokračovat číslem ve stupních a následně buď tečkou a desetinnou částí (např. N50.08105), nebo minutami a sekundami oddělenými dvojtečkami (např. N50:4:52). Pozice-WE je zeměpisná šířka ve stejném formátu, ale písmeno je W (západní) nebo E (východní). Datum se zadává ve standardním formátu YYYY-MM-DD. Přesnost výpočtu jsem podrobně nezkoumal/a, ale neočekávajte vyšší přesnost než tak plus minus dvě minuty.*<br>
**TZ=UTC hdate -qsT -l** {*pozice-NS*} **-L** {*pozice-WE*} **$(($(date -d '**{*datum*}**&blank;00:00:00' +%s) / 86400 + 2440589)) \| sed -E '/^[0-9]/!d;s/\\.([0-9])\\./.0\\1./g;s/^([0-9]+)\\.([0-9]+)\\.([0-9]+),[<nic>^,]\*,([<nic>^,]+),([<nic>^,]+).\*/TZ="UTC" \\3-\\2-\\1&blank;\\4:00\\nTZ="UTC" \\3-\\2-\\1&blank;\\5:00/'** [**\|** [**TZ="**{*časová/zóna*}**"**] **date -f - "+%F %T %z"**]<br>
**TZ=UTC hdate -qsT -l N50.0810578 -L E14.4279506 $(($(date -d '2020-08-19&blank;00:00:00' +%s) / 86400 + 2440589)) \| sed -E '/^[0-9]/!d;s/\\.([0-9])\\./.0\\1./g;s/^([0-9]+)\\.([0-9]+)\\.([0-9]+),[<nic>^,]\*,([<nic>^,]+),([<nic>^,]+).\*/TZ="UTC" \\3-\\2-\\1&blank;\\4:00/' \| date -f - "+%F %T %z"**

<!--
Význam skriptu v sedu:

/^[0-9]/!d; # vyloučí řádky nezačínající číslicí (zejména záhlaví tabulky vypsané příkazem „hdate“)
s/\\.([0-9])\\./.0\\1./g; # vloží nulu před číslo dne či měsíce, je-li tvořeno jedinou číslicí
s/
    ^([0-9]+)\\.([0-9]+)\\.([0-9]+),[<nic>^,]\*,([<nic>^,]+),([<nic>^,]+).\*
/
    TZ="UTC" \\3-\\2-\\1&blank;\\4:00\\nTZ="UTC" \\3-\\2-\\1&blank;\\5:00
/ # načte datum a čas z výstupu „hdate“ a zformátuje je na vstup „date“

Poznámka: podle Wikipedie se má při konverzi na JDN přičítat 2440587.5, ale „hdate“ v takovém případě vypisuje jiné datum. Toto by si zasloužilo prozkoumat.

-->

*# zjistit datum **Velikonoční** neděle*<br>
**date -d "$(LC\_ALL=C ncal -e** [{*rok*}]**)" +%F**


## Zaklínadla: Konverze data a času a časová aritmetika

### Konverze časové zóny

*# konverze z UTC na lokální čas/z lokálního času na UTC*<br>
**date -d "TZ=\\"UTC\\"** {*čas-UTC*}**" "+%F %T"**<br>
**date -ud "TZ=\\"$(cat /etc/timezone)\\"&blank;**{*lokální čas*}**" "+%F %T"**<br>
**date -ud "@$(date -d "**{*čas*}**" +%s)" "+%F %T"**

*# konverze z jedné časové zóny do druhé (obecně/příklad)*<br>
**TZ="**{*cílová/časová/zóna*}**" date -d 'TZ="**{*zdrojová/časová/zóna*}**"&blank;**{*čas*}**' "+%F %T**[**&blank;%z**]**"**<br>
**TZ="America/New\_York" date -d 'TZ="Asia/Vladivostok" 2019-01-01 12:35:57' "+%F %T %z"**

### Aritmetika s datem
*# konverze data na „číslo dne“/zpět*<br>
**printf %s\\\\n $(($(date -ud** {*datum*} **+%s) / 86400))**<br>
**date -ud "@$((**{*číslo-dne*}** \* 86400))" +%F**

*# **přičíst/odečíst** N dní*<br>
**date -ud @$((**{*N*} **\* 86400 + $(date -ud "**{*datum*}**" +%s))) +%F**<br>
**date -ud @$((-**{*N*} **\* 86400 + $(date -ud "**{*datum*}**" +%s))) +%F**

*# **rozdíl** ve dnech*<br>
**printf %s\\\\n $((($(date -ud** {*datum*} **+%s) - $(date -ud** {*odečítané-datum*} **+%s)) / 86400))**

### Artimetika s časem
*# konverze lokálního/UTC času na časovou známku Unixu*<br>
**date -d "**{*čas*}**" +%s**<br>
**date -ud "**{*čas*}**" +%s**

*# konverze časové známky Unixu na lokální čas/UTC*<br>
**date -d @**{*časová-známka*} **"+%F %T**[**&blank;%z**]**"**<br>
**date -ud @**{*časová-známka*} **"+%F %T"**

*# **přičíst/odečíst** N sekund (v UTC)*<br>
**date -ud @$(($(date -ud "**{*datum čas*}**" +%s) +** {*N*} **)) "+%F %T"**<br>
**date -ud @$(($(date -ud "**{*datum čas*}**" +%s) -** {*N*} **)) "+%F %T"**

*# **rozdíl** UTC časů v sekundách*<br>
**printf %s\\\\n $(($(date -ud** {*čas*} **+%s) - $(date -ud** {*odečítaný-čas*} **+%s)))**

### Konverze kalendářů

*# konverze data gregoriánského kalendáře na juliánský/naopak*<br>
?<br>
?

*# konverze data gregoriánského kalendáře na hebrejský/naopak*<br>
?<br>
?

*# konverze data gregoriánského kalendáře na arabský/naopak*<br>
?<br>
?

## Zaklínadla: Nastavení systému

### Časové zóny

*# **vypsat** seznam podporovaných časových zón, seřazený podle jejich aktuální odchylky od UTC*<br>
**timedatectl list-timezones \| sed 's/.\*/TZ="&amp;" date +%z; echo &amp;/' \| bash \| xargs -rd \\\\n -n 2 printf "%s\\\\t%s\\\\n" \| LC\_ALL=C sort \| sort -ns**

*# vypsat seznam podporovaných časových zón*<br>
**timedatectl list-timezones**

*# vypsat aktuální časovou zónu nastavenou v systému (alternativy)*<br>
**cat /etc/timezone**<br>
**readlink /etc/localtime | sed -E 's!.\*/share/zoneinfo/!!'**

*# nastavit časovou zónu pro celý systém*<br>
*// Změna časové zóny má okamžitou platnost a vydrží i po restartu.*<br>
**sudo timedatectl set-timezone** {*časová/zóna*}

*# nastavit časovou zónu pro nový proces*<br>
**TZ="**{*časová/zóna*}**"** {*příkaz*} [{*parametry*}]...

### Systémový a hardwarový čas

*# vypnout/zapnout **automatickou synchronizaci** systémového času*<br>
**timedatectl set-ntp off**<br>
**timedatectl set-ntp on**

*# **ručně** nastavit systémový čas*<br>
*// Zadejte čas a datum ve formátu „YYYY-MM-DD HH:MM:SS“. Poznámka: Jsou-li ve VirtualBoxu nainstalované přídavky pro hosta, tyto přídavky velmi často systémový čas vnitřního systému (hosta) synchronizují se systémovým časem vnějšího systému (hostitele), proto v takovém případě změna systémového času vnitřního systému vydrží jen velmi krátce a je sotva pozorovatelná.*<br>
**timedatectl set-ntp off**<br>
**timedatectl set-time "**{*nový lokální čas*}**"**

*# ručně nastavit hardwarový čas*<br>
*// Datum a čas by měly být ve formátu „YYYY-MM-DD HH:MM:SS“, dovoleny jsou i jiné formáty. Pozor, je vyžadován lokální čas v časové zóně systému, a to i v případě, že ve skutečnosti je hardwarový čas uložen v UTC!*<br>
**sudo hwclock \-\-set \-\-date '**{*lokální datum čas*}**'**

*# nastavit systémový čas z hardwarového/hardwarový ze systémového*<br>
**sudo hwclock -s**<br>
**sudo hwclock -w**

*# zobrazit hardwarový čas (lokální/UTC)*<br>
**sudo hwclock -r**<br>
**sudo hwclock -r \| date -u -f - '+%F&blank;%T.%6N%z'**

*# ručně synchronizovat systémový čas*<br>
?
<!--
timedatectl set-ntp on && sleep 1 && timedatectl set-ntp off
-->


## Parametry příkazů
### date
*# *<br>
[**TZ="**{*cílová časová zóna*}**"**] **date** [{*parametry*}] <nic>[**+**{*formát*}]

!Parametry:

* ○ -d '{*datum a čas*}' ○ -d '"{*původní čas. zóna*}" {*datum a čas*}' ○ -f {*soubor*} ○ -f - :: Použije zadaný čas (parametr -d), popř. načte čas z řádků daného souboru či ze standardního vstupu (parametr -f). Výchozí chování: použije aktuální čas.
* ○ -u :: Cílová časová zóna bude UTC. Výchozí chování: časovou zónu určuje proměnná prostředí TZ, popř. je to lokální čas.

### ncal
*# *<br>
**ncal** {*parametry*} [[{*měsíc*}] {*rok*}]

!Parametry:

* ○ -M ○ -S :: Týden začíná pondělím/nedělí. Výchozí chování určuje lokalizace systému.
* ○ -b :: Týdny tvoří řádky. Výchozí chování: týdny tvoří sloupce.
* ☐ -3 :: Zobrazí také předchozí a následující měsíc.
* ☐ -w :: Do kalendáře zahrne čísla týdnů.

## Instalace na Ubuntu

Většina použitých nástrojů je součástí minimální instalace Ubuntu; výjimkou je příkaz „hdate“,
který je třeba doinstalovat:

*# *<br>
**sudo apt-get install hdate**

## Ukázka

*# *<br>
**ncal -M3bw**<br>
**date "+%F %T.%9N %z%t(%s.%9N)"**<br>
**date -u "+%F %T.%9N %z%t(%s.%9N)"**<br>
**date -d "TZ=\\"America/New\_York\\"&blank;2000-02-29 12:01:02.123" "+%FT%T.%9N%z"**<br>
**date -ud "TZ=\\"America/New\_York\\"&blank;2000-02-29 12:01:02.123" "+%FT%T.%9N%z"**<br>
**TZ="America/New\_York" date -d "TZ=\\"America/New\_York\\"&blank;2000-02-29 12:01:02.123" "+%FT%T.%9N%z"**<br>
**printf %s\\\\n $((($(date -ud 2001-01-01 +%s) - $(date -ud 2000-01-01 +%s)) / 86400))**

!ÚzkýRežim: zap

## Tipy a zkušenosti

* Specifikace časové zóny či posunu mají následující prioritu: 1) parametr **-d**; 2) parametr **-u**; 3) proměnná prostředí **TZ**; 4) časová zóna systému.

## Další zdroje informací

*# *<br>
**man date**<br>
**man ncal**

* [Reference funkce strftime](https://en.cppreference.com/w/c/chrono/strftime) (anglicky)
* [Manuálová stránka „date“](http://manpages.ubuntu.com/manpages/focal/en/man1/date.1.html) (anglicky)
* [Manuálová stránka „ncal“](http://manpages.ubuntu.com/manpages/focal/en/man1/ncal.1.html) (anglicky)
* [Video Linux Operating System \| Commands \| Date And Time](https://www.youtube.com/watch?v=FMrV5FdmBVI) (anglicky)
* [TL;DR stránka „date“](https://github.com/tldr-pages/tldr/blob/master/pages/common/date.md) (anglicky)

## Zákulisí kapitoly
<!--
- Doplňte, pokud víte. Udržujte aktuální.

libdatetime-event-sunrise-perl

-->

V této verzi kapitoly chybí:

!KompaktníSeznam:
* menstruační kalendář
* výpočet času muslimských modliteb
* konverze mezi druhy kalendářů (juliánský, gregoriánský, hebrejský, čínský apod.).

Tato kapitola záměrně nepokrývá:

!KompaktníSeznam:
* plánování úloh na konkrétní čas

!ÚzkýRežim: vyp
