# Linux Kniha kouzel, Makefile
# Copyright (c) 2019, 2020 Singularis <singularis@volny.cz>
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

# Nástroje
# ----------------------------------------------------------------------------
SHELL := /bin/bash
AWK := gawk
#CONVERT := convert
PERL := LC_ALL=cs_CZ.UTF-8 perl -CSDAL -I./skripty/lkk -Mstrict -Mwarnings -Mutf8 -MEnglish -MLinuxKnihaKouzel -Mv5.26.0
SED := sed -E
TRANSAKCE := skripty/transakce

# Datum sestavení (automaticky generované; např. „20210101“)
# ----------------------------------------------------------------------------
export DATUM_SESTAVENI := $(shell date +%Y%m%d)

# Další nastavení
# ----------------------------------------------------------------------------
export PDF_ZALOZKY := 1
export SOUBORY_PREKLADU := soubory_překladu
export VYSTUP_PREKLADU := výstup_překladu
export PDF_ZALOZKY_MAX_DELKA := 32
export REKLAMNI_PATY := 0
export PREMIOVE_KAPITOLY := 0

# Jméno sestavení (doporučuji nastavovat z příkazového řádku)
# ----------------------------------------------------------------------------
export JMENO := Sid $(DATUM_SESTAVENI)

# Verze .deb-balíčku (automaticky generovaná, ale je dovoleno ji nastavit ručně)
# ----------------------------------------------------------------------------
export DEB_VERZE := $(shell $(AWK) -f skripty/extrakce/debverze.awk -- "$(JMENO)")

# Soubory symbolizující nastavení (automaticky generované)
# ----------------------------------------------------------------------------
DATUM_SESTAVENI_SOUBOR := $(SOUBORY_PREKLADU)/symboly/datum-sestavení/$(DATUM_SESTAVENI)
DEB_VERZE_SOUBOR := $(SOUBORY_PREKLADU)/symboly/deb-verze/$(DEB_VERZE)
JMENO_SESTAVENI_SOUBOR := $(SOUBORY_PREKLADU)/symboly/jméno-sestavení/$(shell JMENO="$(JMENO)"; printf %s "$${JMENO//[$$'/ \n\t']/-}")

#$(shell mkdir -pv $(SOUBORY_PREKLADU) >/dev/null; true > $(SOUBORY_PREKLADU)/dynamický-Makefile)

.PHONY: all clean html log pdf-a4 pdf-a4-bez pdf-b5 pdf-b5-bez pdf-b5-na-a4 info $(SOUBORY_PREKLADU)/fragmenty.tsv
.DELETE_ON_ERROR: # Přítomnost tohoto cíle nastaví „make“, aby v případě kteréhokoliv pravidla byl odstraněn jeho cíl.
.SUFFIXES: # Vypíná implicitní obecná pravidla pro přípony

all: deb html log pdf-a4 pdf-a4-bez pdf-b5 pdf-b5-bez pdf-b5-na-a4 pdf-výplach

clean:
	@skripty/h1 Zahajuji čištění
	$(RM) -Rv $(SOUBORY_PREKLADU) $(VYSTUP_PREKLADU)
	@skripty/h2 Čištění dokončeno

info: $(DATUM_SESTAVENI_SOUBOR) $(DEB_VERZE_SOUBOR) $(JMENO_SESTAVENI_SOUBOR) $(SOUBORY_PREKLADU)/fragmenty.tsv
	$(AWK) -f skripty/info.awk

# Podporované formáty:
deb: $(SOUBORY_PREKLADU)/deb-Makefile $(DATUM_SESTAVENI_SOUBOR) $(DEB_VERZE_SOUBOR) $(JMENO_SESTAVENI_SOUBOR)
	@skripty/h1 'Zahajuji překlad formátu DEB'
	$(MAKE) -f $< deb
	@skripty/h2 'Formát DEB úspěšně přeložen'

$(SOUBORY_PREKLADU)/deb-Makefile: $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/makegen/deb.awk $(DATUM_SESTAVENI_SOUBOR) $(DEB_VERZE_SOUBOR) $(JMENO_SESTAVENI_SOUBOR)
	@mkdir -pv $(dir $@)
	$(TRANSAKCE) -o $@
	$(AWK) -f skripty/makegen/deb.awk $< >$@
	$(TRANSAKCE) -z $@

html: $(SOUBORY_PREKLADU)/html/Makefile
	@skripty/h1 'Zahajuji překlad formátu HTML'
	$(MAKE) -f $< html
	@skripty/h2 'Formát HTML úspěšně přeložen'

$(SOUBORY_PREKLADU)/html/Makefile: $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/makegen/html.awk $(DATUM_SESTAVENI_SOUBOR) $(DEB_VERZE_SOUBOR) $(JMENO_SESTAVENI_SOUBOR)
	@mkdir -pv $(dir $@)
	$(TRANSAKCE) -o $@
	$(AWK) -f skripty/makegen/html.awk $< >$@
	$(TRANSAKCE) -z $@

log: $(SOUBORY_PREKLADU)/log-Makefile
	@skripty/h1 'Zahajuji překlad formátu LOG'
	$(MAKE) -f $< log
	@skripty/h2 'Formát LOG úspěšně přeložen'

$(SOUBORY_PREKLADU)/log-Makefile: $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/makegen/log.awk $(DATUM_SESTAVENI_SOUBOR) $(DEB_VERZE_SOUBOR) $(JMENO_SESTAVENI_SOUBOR)
	@mkdir -pv $(dir $@)
	@printf 'Regeneruji log-Makefile...\n'
	@$(TRANSAKCE) -o $@
	@$(AWK) -f skripty/makegen/log.awk $< >$@
	@$(TRANSAKCE) -z $@

pdf-a4: $(SOUBORY_PREKLADU)/pdf-a4-Makefile pdf-společné $(SOUBORY_PREKLADU)/postprocess.dat
	@skripty/h1 'Zahajuji překlad formátu PDF A4'
	$(MAKE) -f $< pdf-a4
	@skripty/h2 'Formát PDF A4 úspěšně přeložen'

$(SOUBORY_PREKLADU)/pdf-a4-Makefile: $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/makegen/pdf-varianta.awk $(DATUM_SESTAVENI_SOUBOR) $(DEB_VERZE_SOUBOR) $(JMENO_SESTAVENI_SOUBOR)
	@mkdir -pv $(dir $@)
	$(AWK) -f skripty/makegen/pdf-varianta.awk -v VARIANTA=pdf-a4 $< >$@

pdf-a4-bez: $(SOUBORY_PREKLADU)/pdf-a4-bez-Makefile pdf-společné $(SOUBORY_PREKLADU)/postprocess.dat
	@skripty/h1 'Zahajuji překlad formátu PDF A4 bez spadávek'
	$(MAKE) -f $< pdf-a4-bez
	@skripty/h2 'Formát PDF A4 bez spadávek úspěšně přeložen'

$(SOUBORY_PREKLADU)/pdf-a4-bez-Makefile: $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/makegen/pdf-varianta.awk $(DATUM_SESTAVENI_SOUBOR) $(DEB_VERZE_SOUBOR) $(JMENO_SESTAVENI_SOUBOR)
	@mkdir -pv $(dir $@)
	$(AWK) -f skripty/makegen/pdf-varianta.awk -v VARIANTA=pdf-a4-bez $< >$@

pdf-b5: $(SOUBORY_PREKLADU)/pdf-b5-Makefile pdf-společné $(SOUBORY_PREKLADU)/postprocess.dat
	@skripty/h1 'Zahajuji překlad formátu PDF B5'
	$(MAKE) -f $< pdf-b5
	@skripty/h2 'Formát PDF B5 úspěšně přeložen'

$(SOUBORY_PREKLADU)/pdf-b5-Makefile: $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/makegen/pdf-varianta.awk $(DATUM_SESTAVENI_SOUBOR) $(DEB_VERZE_SOUBOR) $(JMENO_SESTAVENI_SOUBOR)
	@mkdir -pv $(dir $@)
	$(AWK) -f skripty/makegen/pdf-varianta.awk -v VARIANTA=pdf-b5 $< >$@

pdf-b5-bez: $(SOUBORY_PREKLADU)/pdf-b5-bez-Makefile pdf-společné $(SOUBORY_PREKLADU)/postprocess.dat
	@skripty/h1 'Zahajuji překlad formátu PDF B5 bez spadávek'
	$(MAKE) -f $< pdf-b5-bez
	@skripty/h2 'Formát PDF B5 bez spadávek úspěšně přeložen'

$(SOUBORY_PREKLADU)/pdf-b5-bez-Makefile: $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/makegen/pdf-varianta.awk $(DATUM_SESTAVENI_SOUBOR) $(DEB_VERZE_SOUBOR) $(JMENO_SESTAVENI_SOUBOR)
	@mkdir -pv $(dir $@)
	$(AWK) -f skripty/makegen/pdf-varianta.awk -v VARIANTA=pdf-b5-bez $< >$@

pdf-b5-na-a4: $(SOUBORY_PREKLADU)/pdf-b5-na-a4-Makefile pdf-společné $(SOUBORY_PREKLADU)/postprocess.dat
	@skripty/h1 'Zahajuji překlad formátu PDF B5 na A4'
	$(MAKE) -f $< pdf-b5-na-a4
	@skripty/h2 'Formát PDF B5 na A4 úspěšně přeložen'

$(SOUBORY_PREKLADU)/pdf-b5-na-a4-Makefile: $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/makegen/pdf-varianta.awk $(DATUM_SESTAVENI_SOUBOR) $(DEB_VERZE_SOUBOR) $(JMENO_SESTAVENI_SOUBOR)
	@mkdir -pv $(dir $@)
	$(AWK) -f skripty/makegen/pdf-varianta.awk -v VARIANTA=pdf-b5-na-a4 $< >$@

pdf-výplach: $(SOUBORY_PREKLADU)/pdf-výplach-Makefile pdf-společné $(SOUBORY_PREKLADU)/postprocess.dat
	@skripty/h1 'Zahajuji překlad formátu PDF výplach'
	$(MAKE) -f $< pdf-výplach
	@skripty/h2 'Formát PDF výplach úspěšně přeložen'

$(SOUBORY_PREKLADU)/pdf-výplach-Makefile: $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/makegen/pdf-varianta.awk $(DATUM_SESTAVENI_SOUBOR) $(DEB_VERZE_SOUBOR) $(JMENO_SESTAVENI_SOUBOR)
	@mkdir -pv $(dir $@)
	$(AWK) -f skripty/makegen/pdf-varianta.awk -v VARIANTA=pdf-výplach $< >$@

pdf-společné: $(SOUBORY_PREKLADU)/pdf-společné-Makefile
	@skripty/h1 'Zahajuji překlad společného základu pro PDF formáty'
	$(MAKE) -f $< pdf-společné
	@skripty/h2 'Společný základ pro PDF formáty přeložen'

$(SOUBORY_PREKLADU)/pdf-společné-Makefile: $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/makegen/pdf-společné.awk $(DATUM_SESTAVENI_SOUBOR) $(DEB_VERZE_SOUBOR) $(JMENO_SESTAVENI_SOUBOR)
	@mkdir -pv $(dir $@)
	$(AWK) -f skripty/makegen/pdf-společné.awk $< >$@

# Symbolické soubory:
$(DATUM_SESTAVENI_SOUBOR) $(DEB_VERZE_SOUBOR) $(JMENO_SESTAVENI_SOUBOR):
	@if ! test -e $@; then skripty/h2 'Nastavuji $@...'; mkdir -pv $(dir $@); $(RM) $(dir $@)*; touch "$@"; fi

# soubory_překladu/fragmenty.tsv
# + soubory_překladu/štítky.tsv
# + soubory_překladu/osnova/*.tsv
# + soubory_překladu/prémiové-kapitoly.tsv
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/fragmenty.tsv: # generování se spouští pokaždé
# skripty/extrakce/fragmenty.pl $(VSECHNY_KAPITOLY_A_DODATKY_MD) $(SOUBORY_PREKLADU)/ucs_ikony.dat konfig.ini
	@skripty/h1 "Regeneruji $(SOUBORY_PREKLADU)/fragmenty.tsv a Makefily..."
	@mkdir -pv $(dir $@)
	@shopt -qu failglob; shopt -qs nullglob; $(TRANSAKCE) -on $@ $(SOUBORY_PREKLADU)/osnova/*.tsv
	@$(PERL) skripty/extrakce/fragmenty.pl
	@$(TRANSAKCE) -zn $@ $(SOUBORY_PREKLADU)/osnova/*.tsv
	@$(RM) -v $(SOUBORY_PREKLADU)/osnova/*.transakce

$(SOUBORY_PREKLADU)/postprocess.dat: $(wildcard postprocess.dat)
	@skripty/h2 'Obnovuji $@...'
	@mkdir -pv $(dir $@)
	@$(TRANSAKCE) -o $@
	-test -r postprocess.dat && cat postprocess.dat >$@ || touch $@
	@$(TRANSAKCE) -z $@
