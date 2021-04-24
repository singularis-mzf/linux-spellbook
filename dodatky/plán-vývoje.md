<!--

Linux Kniha kouzel, dodatek Plán budoucího vývoje
Copyright (c) 2019-2021 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Plán budoucího vývoje

## Chystané kapitoly

* „Bash“ (syntaxe, exec, přesměrování, roury a další)
* „Šifrování a kryptografie“ (gpg, šifrování archivů, elektronické podpisy, HTTPS certifikáty)
* „PDF“ (dělení, slučování, operace po stránkách, transformace, konverze apod.)
* „Zpracování obrázků“ (ImageMagick, konverze RAW z fotoaparátů, zatím asi bez animovaných gifů)
* „Stahování z webu“ (wget, curl, firefox, wkhtmltoimage, robots.txt, ...)
* „Unicode a emotikony“ („mapa znaků“, vzorníky a různé symboly)
* „X (správce oken)“ (práce s okny, se schránkou, oznámení a další)
* „Komplexní textové formáty“ (JSON, XML apod.)
* „Přehrávání videa, zvuku a obrázků“ (mplayer, feh, gpicview, ristretto)
* „Firewall“ (asi hlavně iptables a ufw)
* „Jádro a GRUB“ (konfigurace, dualboot, nastavení grafického pozadí)
* „LaTeX“ (základní struktura dokumentu, standardní značky, překlad do PDF, důležité balíčky)
* „SQL“ (SQLite, MySQL, MariaDB; všechno možné)
* „ASCII art“ (banner, toilet a další)
* „DOSBox“ (ovládání, konfigurace, spouštění)
* „Wine“ (parametry, konfigurace, zkušenosti, wine-prefixy apod.)
* „VirtualBox“ (ovládání z terminálu)
* „Záznam obrazovky“ (maim, ffmpeg a další)
* „Správa balíčků 2“ (apt-src, aptly apod.)
* „Kalkulace“ (bc, dc, expr apod.)

<!--
* „HTTP, FTP, MySQL a spol. (klientská strana – ftp, wget, curl, ...)“
* „HTTP, FTP, MySQL a spol. (servery)“
-->

<neodsadit>Aktuální vývoj chystaných kapitol můžete sledovat na GitHubu.

Pokud máte nějaké osobní preference, které z kapitol byste chtěl/a dostat co nejdřív,
nebo návrh na zpracování jiného tématu, napište mi váš názor e-mailem
nebo komentářem na GitHubu. Váš zájem mě určitě potěší a povzbudí.

## Možný přechod na jazyk Perl

Implementace mechanismu „oblíbených zaklínadel“ ve vanilkové příchuti 2.7
si vyžádala poměrně zásadní přepsání mechanismu překladu.
Ačkoliv je i jeho nová implementace v GNU awk, dospěl/a jsem k závěru,
že AWK je pro takovýto projekt špatným jazykem, protože disponuje jen
velmi omezeným sortimentem funkcí a je obtížné v něm spravovat složité
datové struktury založené na polích, ukazatelích a datových strukturách.
Navíc se zdá, že asociativní pole mohou ve většině potřebných případů
elegantně nahradit příkazy „switch“, takže pokud by bylo potřeba
mechanismus překladu kvůli nějaké nové vlastnosti znovu podstatně
přepsat, přepíšu ho už rovnou do Perlu.
