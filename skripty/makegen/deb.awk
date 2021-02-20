# Linux Kniha kouzel, skript makegen/deb.awk
# Copyright (c) 2020 Singularis <singularis@volny.cz>
#
# Toto dílo je dílem svobodné kultury; můžete ho šířit a modifikovat pod
# podmínkami licence Creative Commons Attribution-ShareAlike 4.0 International
# vydané neziskovou organizací Creative Commons. Text licence je přiložený
# k tomuto projektu nebo ho můžete najít na webové adrese:
#
# https://creativecommons.org/licenses/by-sa/4.0/
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

@include "skripty/makegen/hlavní.awk"

BEGIN {
    n_md5 = 0;
    n_ost = 0;
    n_md_na_vystup = 0;
    delete zavislosti_md5; # závislosti pro md5sums
    delete zavislosti_ost; # závislosti přímo pro balíček
    delete md_na_vystup;

    print "# Tento soubor byl automaticky vygenerován skriptem skripty/makegen/deb.awk\n\n";
    print "SHELL := /bin/bash\n";
    print ".PHONY: deb\n";
    print "deb:\n\n";
}

{priznaky = $7}

priznaky ~ /z/ && priznaky !~ /d/ {
    uplneId = $2;
    adresar = $6;

    md_na_vystup[++n_md_na_vystup] = adresar "/" uplneId ".md";
}

END {
    if (FATALNI_VYJIMKA) {exit FATALNI_VYJIMKA}

    # 1. skripty/lkk/lkk => soubory_překladu/deb/usr/bin/lkk
    # cíl
    Cil(zavislosti_md5[++n_md5] = SOUBORY_PREKLADU "/deb/usr/bin/lkk");
    # závislosti
    Zavislost("skripty/lkk/lkk");
    # příkazy
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz("cat $< >$@");
    Prikaz("chmod =0755 $@");

    # 2. skripty/lkk/LinuxKnihaKouzel.pm => soubory_překladu/deb/usr/share/lkk/perl/LinuxKnihaKouzel.pm
    # cíl
    Cil(zavislosti_md5[++n_md5] = SOUBORY_PREKLADU "/deb/usr/share/lkk/perl/LinuxKnihaKouzel.pm");
    # závislosti
    Zavislost("skripty/lkk/LinuxKnihaKouzel.pm");
    ZavislostNaJmenuSestaveni();
    # příkazy
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz(SED " 's/\\{\\{JMÉNO VERZE\\}\\}/" JMENO_SESTAVENI "/g' $< >$@");

    # 3. skripty/lkk/lkk-spouštěč.pl => soubory_překladu/deb/usr/share/lkk/lkk-spoustec.pl
    Cil(zavislosti_md5[++n_md5] = SOUBORY_PREKLADU "/deb/usr/share/lkk/lkk-spoustec.pl");
    Zavislost("skripty/lkk/lkk-spouštěč.pl");
    ZavislostNaJmenuSestaveni();
    # příkazy
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz(SED " 's/\\{\\{JMÉNO VERZE\\}\\}/" JMENO_SESTAVENI "/g' $< >$@");

    # 4. kapitoly/*.md => soubory_překladu/deb/usr/share/lkk/skripty/*
    Cil(zavislosti_md5[++n_md5] = SOUBORY_PREKLADU "/deb/usr/share/lkk/skripty/pomocné-funkce");
    # závislosti
    Zavislost("skripty/extrakce/pomocné-funkce.awk");
    Zavislost("skripty/utility.awk");
    Zavislost(md_na_vystup);
    ZavislostNaPoradiKapitol();
    # příkazy
    Prikaz("rm -Rf $(dir $@)");
    Prikaz("mkdir -p $(dir $@)");
    if (n_md_na_vystup > 0) {
        Prikaz(AWK " -f $< " join(" ", md_na_vystup) " >&2");
    }

    # 5. COPYRIGHT-DEB => soubory_překladu/deb/usr/share/doc/lkk/copyright
    # [ ] změnit na copyright.gz
    Cil(zavislosti_md5[++n_md5] = SOUBORY_PREKLADU "/deb/usr/share/doc/lkk/copyright");
    Zavislost("COPYRIGHT-DEB");
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz("cat $< >$@");

    # 6. formáty/deb/control => soubory_překladu/deb/DEBIAN/control
    Cil(zavislosti_ost[++n_ost] = SOUBORY_PREKLADU "/deb/DEBIAN/control");
    Zavislost("formáty/deb/control");
    ZavislostNaDebVerzi();
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz(SED " 's/\\{Version\\}/$(DEB_VERZE)/g;s/\\{Installed-Size\\}/'\"$$(du -ks --exclude=DEBIAN " SOUBORY_PREKLADU "/deb | cut -f 1 | tail -n 1)/g\" $< >\"$@\"");

    # 7. skripty/lkk/bash-doplňování.sh => soubory_překladu/deb/usr/share/bash-completion/completions/lkk
    Cil(zavislosti_md5[++n_md5] = SOUBORY_PREKLADU "/deb/usr/share/bash-completion/completions/lkk");
    Zavislost("skripty/lkk/bash-doplňování.sh");
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz("cat $< >$@");

    # 8. formáty/deb/manuálová-stránka.1 => soubory_překladu/deb/usr/share/man/man1/lkk.1.gz
    #    formáty/deb/manuálová-stránka.1 => soubory_překladu/deb/usr/share/man/cs/man1/lkk.1.gz
    Cil(zavislosti_md5[++n_md5] = SOUBORY_PREKLADU "/deb/usr/share/man/man1/lkk.1.gz");
    Zavislost("formáty/deb/manuálová-stránka.1");
    Zavislost("skripty/plnění-šablon/manuálová-stránka.awk");
    ZavislostNaDatuSestaveni();
    ZavislostNaDebVerzi();
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz(AWK " -vDATUM=\"$$(LC_ALL=en_US.UTF-8 date +\"%B %-d., %Y\")\" " \
        "-vJAZYK=en -vJMENOVERZE='" JMENO_SESTAVENI "' -f skripty/plnění-šablon/manuálová-stránka.awk formáty/deb/manuálová-stránka.1 | gzip -9 >$@");
    Prikaz(AWK " -vDATUM=\"$$(LC_ALL=cs_CZ.UTF-8 date +\"%-d. %B %Y\")\" " \
        "-vJAZYK=cz -vJMENOVERZE='" JMENO_SESTAVENI "' -f skripty/plnění-šablon/manuálová-stránka.awk formáty/deb/manuálová-stránka.1 | gzip -9 >$@");

    # 9. soubory_překladu/deb/** => soubory_překladu/deb/DEBIAN/md5sums
    Cil(zavislosti_ost[++n_ost] = SOUBORY_PREKLADU "/deb/DEBIAN/md5sums");
    Zavislost(zavislosti_md5);
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz("(cd " SOUBORY_PREKLADU "/deb && exec find * -path DEBIAN -prune -o -type f -exec md5sum -- '{}' +) | LC_ALL=C sort -k 1.33b >$@");

    # 10. soubory_překladu/deb/** => vystup_překladu/lkk_{verze}_all.deb
    # Poznámka: přes „md5sums“ závisí také na všech ostatních souborech v $(SOUBORY_PREKLADU)/deb mimo podadresář DEBIAN.
    Cil(VYSTUP_PREKLADU "/lkk_$(DEB_VERZE)_all.deb");
    Zavislost(zavislosti_ost);
    Prikaz("mkdir -pv $(dir $@)");
    Prikaz("chmod -R u+rx,go+r,go-w " SOUBORY_PREKLADU "/deb");
    Prikaz("dpkg-deb -b --root-owner-group " SOUBORY_PREKLADU "/deb $@");

    # Závěr
    Cil("deb");
    Zavislost(VYSTUP_PREKLADU "/lkk_$(DEB_VERZE)_all.deb");
    Hotovo();
}
