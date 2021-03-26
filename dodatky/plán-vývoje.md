<!--

Linux Kniha kouzel, dodatek Plán budoucího vývoje
Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Plán budoucího vývoje

## Chystané kapitoly

* „PDF“ (dělení, slučování, operace po stránkách, transformace, konverze apod.)
* „Zpracování obrázků“ (ImageMagick, konverze RAW z fotoaparátů, zatím asi bez animovaných gifů)
* „Stahování z webu“ (wget, curl, firefox, wkhtmltoimage, robots.txt, ...)
* „Unicode a emotikony“ („mapa znaků“, vzorníky a různé symboly)
* „X (správce oken)“ (práce s okny, se schránkou, oznámení a další)
* „Komplexní textové formáty“ (JSON, XML apod.)
* „Přehrávání videa, zvuku a obrázků“ (mplayer, feh, gpicview, ristretto)
* „Šifrování a kryptografie“ (gpg, šifrování archivů, elektronické podpisy, HTTPS certifikáty)
* „Firewall“ (asi hlavně iptables a ufw)
* „Jádro a GRUB“ (konfigurace, dualboot, nastavení grafického pozadí)
* „Bash“ (syntaxe, exec, přesměrování, roury a další)
* „LaTeX“ (základní struktura dokumentu, standardní značky, překlad do PDF, důležité balíčky)
* „SQL“ (SQLite, MySQL, MariaDB; všechno možné)
* „ASCII art“ (banner, toilet a další)
* „DOSBox“ (ovládání, konfigurace, spouštění)
* „Wine“ (parametry, konfigurace, zkušenosti, wine-prefixy apod.)
* „VirtualBox“ (ovládání z terminálu)
* „Záznam obrazovky“ (maim, ffmpeg a další)
* „Správa balíčků 2“ (apt-src, aptly apod.)
* „Kalkulace“ (bc, dc, expr apod.)
* „Firefox“ (zejm. konfigurační volby a volání z terminálu)

<!--
* „HTTP, FTP, MySQL a spol. (klientská strana – ftp, wget, curl, ...)“
* „HTTP, FTP, MySQL a spol. (servery)“
-->

<neodsadit>Aktuální vývoj chystaných kapitol můžete sledovat na GitHubu.

Pokud máte nějaké osobní preference, které z kapitol byste chtěl/a dostat co nejdřív,
nebo návrh na zpracování jiného tématu, napište mi váš názor e-mailem
nebo komentářem na GitHubu. Váš zájem mě určitě potěší a povzbudí.

## Možný přechod na jazyk Perl

Dříve nebo později do Perlu začnu přepisovat méně významné pomocné skripty.

Připouštím možnost, že některé pomocné skripty v budoucnu přepíšu do Perlu,
hlavní část mechanismu překladu ale zatím zůstane v GNU awk,
protože je z velké části založena na příkazech „switch“,
které Perl sám o sobě dobře neumí a náhražky v něm vypadají ošklivě
nebo dobře nefungují. U hlavní části mechanismu překladu bude přechod
možný v případě, že se podaří najít efektivní náhradu za příkazy switch
(zatím vypadají nadějně asociativní pole); zatím ale není prioritou.
