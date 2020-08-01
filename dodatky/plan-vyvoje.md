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

* „Zpracování binárních souborů“ (md5sum, uuencode, base64, analýzy, konverze a další)
* „Pevné a symbolické odkazy“
* „PDF“ (dělení, slučování, operace po stránkách, transformace, konverze apod.)
* „Unicode a emotikony“ („mapa znaků“, vzorníky a různé symboly)
* „X (správce oken)“ (práce s okny, se schránkou, oznámení a další)
* „Zpracování obrázků“ (ImageMagick, konverze RAW z fotoaparátů, zatím asi bez animovaných gifů)
* „Komplexní textové formáty“ (JSON, XML apod.)
* „Základy Perlu“ (jednoduše, konzistentně)
* „Přehrávání videa, zvuku a obrázků“ (mplayer, feh, gpicview, ristretto)
* „Šifrování a kryptografie“ (gpg, šifrování archivů, elektronické podpisy, HTTPS certifikáty)
* „Firewall“ (asi hlavně iptables)
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
* „Matematické výpočty“ (bc, dc, expr apod.)
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

Přechod projektu z AWK na Perl v nejbližší budoucnosti *nenastane*.
Mechanismus překladu je značně založený na příkazech „switch“,
které Perl sám o sobě dobře neumí a náhražky v něm vypadají ošklivě
nebo dobře nefungují. Proto bude další vývoj mechanismu překladu probíhat
i nadále v AWK.

Plánuji však převod spouštěče „lkk“ do Perlu, tak aby GNU awk nebylo
vyžadováno jako závislost balíčku „lkk“.
