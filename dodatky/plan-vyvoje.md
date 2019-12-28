<!--

Linux Kniha kouzel, část Plán budoucího vývoje
Copyright (c) 2019 Singularis <singularis@volny.cz>

Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
vydané neziskovou organizací Creative Commons. Text licence je přiložený
k tomuto projektu nebo ho můžete najít na webové adrese:

https://creativecommons.org/licenses/by-sa/4.0/

-->

# Plán budoucího vývoje

Podle mých představ v době vydání této verze knihy by do její příští verze měly přibýt některé z následujících kapitol:

* „Unicode a emotikony“ („mapa znaků“, vzorníky a různé symboly)
* „GNU awk“ (vzorky, příkazy, funkce, syntaxe, použití, zkušenosti)
* „Základy Perlu“ (jednoduše, konzistentně)
* „Zpracování textových souborů“ (prohledávání, filtrování, řazení, CSV, TSV, JSON, XML apod.)
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
* „Hledání souborů“ (find, locate, whereis a další)
* „Soubory a adresáře“ (vytváření, mazání, fallocate, truncate, kopírování, práva a atributy)
* „Pevné a symbolické odkazy“
* „Bash“ (syntaxe, rozvoj proměnných, exec, přesměrování, roury a další)
* „LaTeX“ (základní struktura dokumentu, standardní značky, překlad do PDF, důležité balíčky)
* „SQL“ (SQLite, MySQL, MariaDB; všechno možné)
* „ASCII art“ (banner, toilet a další)
* „Wine“ (parametry, konfigurace, zkušenosti, wine-prefixy apod.)
* „Správa balíčků 2“ (apt-src, apt-mirror, aptly)
* „Správa procesů“ (ps, pgrep, pstree, kill, nice, nohup apod.)
* „Proměnné prostředí“ (printenv a další možnosti)
* „Matematické výpočty“ (bc, dc, expr apod.)

<!--
* „HTTP, FTP, MySQL a spol. (klientská strana − ftp, wget, curl, ...)“
* „HTTP, FTP, MySQL a spol. (servery)“
-->

Pokud máte nějaké osobní preference, které z nich byste tam chtěl/a vidět, nebo byste rád/a dostal/a zpracované jiné téma, napište mi váš názor e-mailem nebo komentářem na GitHubu. Váš zájem mě určitě potěší a povzbudí.

Kromě toho mám v plánu rozvíjet i formátování a mechanismus překladu.
V plánu mám následující vlastnosti:

* Pomocné funkce a skripty by měly být k dispozici také ve formě .deb balíčku.
* Podpora poznámek pod čarou i mimo zaklínadla.
* Ikony pro kapitoly.
* Rozdílné ikony pro jednotlivá zaklínadla.
* Vylepšovat design a přehlednost HTML varianty.
* Vylepšovat design a přehlednost PDF variant.

Uvažoval/a jsem o přechodu z Awk na Perl, ale vzhledem k tomu, že mechanismus překladu
je značně založený na příkazech „switch“, které Perl implicitně dobře neumí, zatím to není aktuální.
