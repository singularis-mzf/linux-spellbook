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

* „Proměnné prostředí“ (printenv a další možnosti)
* „Unicode a emotikony“ („mapa znaků“, vzorníky a různé symboly)
* „Základy Perlu“ (jednoduše, konzistentně)
* „Komplexní textové formáty“ (JSON, XML apod.)
* „Přehrávání videa, zvuku a obrázků“ (mplayer, feh, gpicview, ristretto)
* „Šifrování a kryptografie“ (gpg, šifrování archivů, elektronické podpisy, HTTPS certifikáty)
* „X (správce oken)“ (práce s okny, se schránkou, oznámení a další)
* „Zpracování obrázků“ (ImageMagick, konverze RAW z fotoaparátů, zatím asi bez animovaných gifů)
* „Zpracování binárních souborů“ (md5sum, uuencode, base64, analýzy, konverze a další)
* „Diskové oddíly“ (fstab, mount, fsck, mkfs, LVM, vypalování DVD)
* „Firewall“ (asi hlavně iptables)
* „GRUB“ (konfigurace, dualboot, nastavení grafického pozadí)
* „Vim“ (základní a mírně pokročilé ovládání)
* „Záznam obrazovky“ (maim, ffmpeg a další)
* „Pevné a symbolické odkazy“
* „Bash“ (syntaxe, rozvoj proměnných, exec, přesměrování, roury a další)
* „LaTeX“ (základní struktura dokumentu, standardní značky, překlad do PDF, důležité balíčky)
* „SQL“ (SQLite, MySQL, MariaDB; všechno možné)
* „ASCII art“ (banner, toilet a další)
* „Wine“ (parametry, konfigurace, zkušenosti, wine-prefixy apod.)
* „Správa balíčků 2“ (apt-src, apt-mirror, aptly)
* „Matematické výpočty“ (bc, dc, expr apod.)

<!--
* „HTTP, FTP, MySQL a spol. (klientská strana – ftp, wget, curl, ...)“
* „HTTP, FTP, MySQL a spol. (servery)“
-->

<neodsadit>Aktuální vývoj chystaných kapitol můžete sledovat na GitHubu.

Pokud máte nějaké osobní preference, které z kapitol byste chtěl/a dostat co nejdřív,
nebo návrh na zpracování jiného tématu, napište mi váš názor e-mailem
nebo komentářem na GitHubu. Váš zájem mě určitě potěší a povzbudí.

## Chystaný vývoj formátování a mechanismu překladu

* Vylepšovat design a přehlednost HTML varianty.
* Vylepšovat design a přehlednost PDF variant.
<!--
* Podpora poznámek pod čarou i mimo zaklínadla.
-->

## Možný přechod na jazyk Perl

Přechod projektu z AWK na Perl v nejbližší budoucnosti *nenastane*.
Mechanismus překladu je značně založený na příkazech „switch“,
které Perl sám o sobě dobře neumí a náhražky v něm vypadají ošklivě
nebo dobře nefungují. Proto bude další vývoj mechanismu překladu probíhat
i nadále v AWK.
