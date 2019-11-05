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

* „Práce s archivy“ (atool, možná tar a gzip)
* „X (správce oken)“ (práce s okny, se schránkou, oznámení a další)
* „Zpracování obrázků“ (ImageMagick, konverze RAW z fotoaparátů, zatím asi bez animovaných gifů)
* „Zpracování binárních souborů“ (md5sum, uuencode, base64, analýzy, konverze a další)
* „Zpracování textových souborů“ (prohledávání, filtrování, řazení, CSV, TSV, JSON, XML apod.)
* „Šifrování a kryptografie“ (gpg, šifrování archivů, elektronické podpisy, HTTPS certifikáty)
* „Diskové oddíly“ (fstab, mount, fsck, mkfs, vypalování DVD)
* „Firewall“ (asi hlavně iptables)
* „GRUB“ (konfigurace, dualboot, nastavení grafického pozadí)
* „Správa balíčků“ (dpkg, dpkg-query, apt-get, apt-cache, apt-file, apt-src, apt-mirror a další; možná zmíním i Snap a Flatpak)
* „Systém“ (ovládání démonů, swapovacích oddílů, automatické přihlašování, synchronizace času, Num Lock a další)
* „Přehrávání videa, zvuku a obrázků“ (mplayer, feh, gpicview, ristretto)
* „Vim“ (základní a mírně pokročilé ovládání)
* „Záznam obrazovky“ (maim, ffmpeg a další)
* „Hledání souborů“ (find, locate, whereis a další)
* „Pevné a symbolické odkazy“
* „Bash“ (syntaxe, rozvoj proměnných, exec, přesměrování, roury a další)
* „GNU awk“ (vzorky, příkazy, funkce, syntaxe, použití)
* „LaTeX“ (základní struktura dokumentu, standardní značky, překlad do PDF, důležité balíčky)
* „Regulární výrazy“ (základní, rozšířené, Perl)
* „SQL“ (SQLite, MySQL, MariaDB; všechno možné)
* „ASCII art“ (banner, toilet a další)

Pokud máte nějaké osobní preference, které z nich byste tam chtěl/a vidět, nebo byste rád/a dostal/a zpracované jiné téma, napište mi váš názor e-mailem nebo komentářem na GitHubu. Váš zájem mě určitě potěší a povzbudí.

Kromě toho mám v plánu rozvíjet i formátování a mechanismus překladu. V plánu mám následující vlastnosti:

* Zlepšit a sjednotit prezentaci pomocných funkcí a skriptů. Měly by být k dispozici v ucelené podobě ke stažení, možná dokonce jako deb-balíček. Bude potřeba automatická extrakce funkcí z kapitol.
* Štítky kapitol (kapitoly budou organizované pomocí štítků, anglicky hashtags).
* Podpora tučně zvýrazněných „klíčových slov“ pro rychlou orientaci mezi zaklínadly.
* Podpora poznámek pod čarou i mimo zaklínadla.
* Šetření inkoustem (obrázky se do PDF varianty budou konvertovat tak, aby snímky terminálu byly tištěny dobře čitelným černým písmem na bílém podkladu).
* Ikony pro kapitoly.
* Ikony pro jednotlivá zaklínadla (zatím nemám přesnou představu, jak by měly vypadat; cílem je usnadnit orientaci lidem s grafickou pamětí).
* Vylepšovat design a přehlednost HTML varianty.
* Vylepšovat design a přehlednost PDF variant.
