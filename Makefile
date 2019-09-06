# Linux Kniha kouzel, Makefile
# Copyright (c) 2019 Singularis <singularis@volny.cz>
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

SHELL := /bin/sh
AWK := gawk

VSECHNY_KAPITOLY := _ukazka docker make gawk
SOUBORY_PREKLADU := soubory_prekladu
VYSTUP_PREKLADU := vystup_prekladu

.PHONY: all clean

all: html log latexa5

clean:
	$(RM) -R $(SOUBORY_PREKLADU) $(VYSTUP_PREKLADU)

html: $(VYSTUP_PREKLADU)/html/index.htm

log: $(VYSTUP_PREKLADU)/log/index.log

latexa5: $(VYSTUP_PREKLADU)/latex-a5/kniha.pdf

# HTML:

# 1. kapitoly/{kapitola}.md => soubory_prekladu/html/{kapitola}
# ============================================================================
$(addprefix $(SOUBORY_PREKLADU)/html/,$(VSECHNY_KAPITOLY)): $(SOUBORY_PREKLADU)/html/%: kapitoly/%.md skripty/do_html.awk skripty/hlavni.awk skripty/utility.awk formaty/html/sablona_kapitoly
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -f skripty/do_html.awk $< > $@

# 2. soubory_prekladu/html/{kapitola} => vystup_prekladu/html/{kapitola}.htm
# ============================================================================
$(addsuffix .htm,$(addprefix $(VYSTUP_PREKLADU)/html/,$(VSECHNY_KAPITOLY))): $(VYSTUP_PREKLADU)/%.htm: $(SOUBORY_PREKLADU)/% skripty/kapitola.awk skripty/zjistit_nazev.awk
	mkdir -pv $(VYSTUP_PREKLADU)/html
	IDKAPITOLY=$(basename $(notdir $@)) NAZEVKAPITOLY="$(shell $(AWK) -f skripty/zjistit_nazev.awk kapitoly/$(notdir $(@:%.htm=%.md)))" TELOKAPITOLY=$< $(AWK) -f skripty/kapitola.awk formaty/html/sablona_kapitoly > $@


# 3. vystup_prekladu/html/{kapitola}.htm => vystup_prekladu/html/index.htm (provizorní)
# ============================================================================
$(VYSTUP_PREKLADU)/html/index.htm: skripty/kniha.awk kapitoly.lst $(addsuffix .htm,$(addprefix $(VYSTUP_PREKLADU)/html/,$(VSECHNY_KAPITOLY))) $(VYSTUP_PREKLADU)/html/lkk.css kapitoly.lst
	SEZNAMKAPITOL=kapitoly.lst VSTUPPREFIX=$(VYSTUP_PREKLADU)/html/ VSTUPSUFFIX=.htm $(AWK) -f skripty/kniha.awk formaty/html/sablona_kapitoly > $@
	cp -Rv obrazky $(VYSTUP_PREKLADU)/html/

# 4. formaty/html/sablona.css => vystup_prekladu/html/lkk.css
# ============================================================================
$(VYSTUP_PREKLADU)/html/lkk.css: formaty/html/sablona.css
	cat $< > $@


# LOG:

# 1. kapitoly/{kapitola}.md => soubory_prekladu/log/{kapitola}
# ============================================================================
$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_KAPITOLY)): $(SOUBORY_PREKLADU)/log/%: kapitoly/%.md skripty/do_logu.awk skripty/hlavni.awk skripty/utility.awk formaty/log/sablona_kapitoly
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -f skripty/do_logu.awk $< > $@

# 2. soubory_prekladu/log/{kapitola} => soubory_prekladu/log/{kapitola}.kap
# ============================================================================
$(addsuffix .kap,$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_KAPITOLY))): %.kap: % skripty/kapitola.awk
	mkdir -pv $(SOUBORY_PREKLADU)/log
	IDKAPITOLY=$(notdir $(@:%.kap=%)) NAZEVKAPITOLY="$(shell $(AWK) -f skripty/zjistit_nazev.awk kapitoly/$(notdir $(@:%.kap=%.md)))" TELOKAPITOLY=$< $(AWK) -f skripty/kapitola.awk formaty/log/sablona_kapitoly > $@

# 3. soubory_prekladu/log/{kapitola}.kap => vystup_prekladu/log/index.log
# ============================================================================
$(VYSTUP_PREKLADU)/log/index.log: $(addsuffix .kap,$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_KAPITOLY))) kapitoly.lst
	mkdir -pv $(VYSTUP_PREKLADU)/log
	SEZNAMKAPITOL=kapitoly.lst VSTUPPREFIX=$(SOUBORY_PREKLADU)/log/ VSTUPSUFFIX=.kap $(AWK) -f skripty/kniha.awk formaty/log/sablona_kapitoly > $@


# LATEX A5:

# 1. kapitoly/{kapitola}.md => soubory_prekladu/latex-a5/{kapitola}
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/latex-a5/%): $(SOUBORY_PREKLADU)/latex-a5/%: kapitoly/%.md skripty/do_latexu.awk
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/do_latexu.awk $< > $@

# 2. soubory_prekladu/latex-a5/{kapitola} => soubory_prekladu/latex-a5/{kapitola}.kap
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/latex-a5/%.kap): %.kap: % skripty/zjistit_nazev.awk skripty/kapitola.awk formaty/latex-a5/sablona.tex
	IDKAPITOLY=$(notdir $(@:%.kap=%)) NAZEVKAPITOLY="$(shell $(AWK) -f skripty/zjistit_nazev.awk kapitoly/$(notdir $(@:%.kap=%.md)))" TELOKAPITOLY=$< $(AWK) -f skripty/kapitola.awk formaty/latex-a5/sablona.tex > $@

# 3. soubory_prekladu/latex-a5/{kapitola}.kap => soubory_prekladu/latex-a5/kniha.tex
# ============================================================================
$(SOUBORY_PREKLADU)/latex-a5/kniha.tex: $(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/latex-a5/%.kap) kapitoly.lst
	mkdir -pv $(dir $@)
	SEZNAMKAPITOL=kapitoly.lst VSTUPPREFIX=$(SOUBORY_PREKLADU)/latex-a5/ VSTUPSUFFIX=.kap $(AWK) -f skripty/kniha.awk formaty/latex-a5/sablona.tex >$@

# 4. soubory_prekladu/latex-a5/kniha.tex => soubory_prekladu/latex-a5/kniha.dvi
# ============================================================================
$(SOUBORY_PREKLADU)/latex-a5/kniha.dvi: $(SOUBORY_PREKLADU)/latex-a5/kniha.tex
	bash -c '(cd $(dir $<); exec latex $(notdir $(<:%.tex=%))) | $(AWK) -f skripty/prelozit_vystup_latexu.awk; exit $${PIPESTATUS[0]}'
	bash -c '(cd $(dir $<); exec latex $(notdir $(<:%.tex=%))) | $(AWK) -f skripty/prelozit_vystup_latexu.awk; exit $${PIPESTATUS[0]}'
# skript "prelozit_vystup_latexu.awk" je zde volán jen pro zpřehlednění výstupu; je možno ho bezpečně vynechat

# 5. soubory_prekladu/latex-a5/kniha.tex => vystup_prekladu/latex-a5/kniha.pdf
# ============================================================================
$(VYSTUP_PREKLADU)/latex-a5/kniha.pdf: $(SOUBORY_PREKLADU)/latex-a5/kniha.dvi
	mkdir -pv $(dir $@)
	dvipdfm -o $@ $(<:%.dvi=%)


#
kapitoly.lst:
	echo '# Seznam kapitol k vygenerování' > kapitoly.lst
	exec bash -c 'for X in $(VSECHNY_KAPITOLY); do echo "$$X" >> kapitoly.lst; done'

