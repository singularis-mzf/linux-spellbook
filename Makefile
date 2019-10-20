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
CONVERT := convert
PDFLATEX := pdflatex -halt-on-error

VSECHNY_DODATKY := predmluva koncepce-projektu plan-vyvoje test mechanismus-prekladu
VSECHNY_KAPITOLY := _ukazka awk docker ffmpeg firefox git hledani-souboru
VSECHNY_KAPITOLY += make markdown obrazky odkazy ostatni planovani-uloh
VSECHNY_KAPITOLY += soubory stahovani-videi
OBRAZKY := logo-knihy-velke.png make.png ve-vystavbe.png

SOUBORY_PREKLADU := soubory_prekladu
VYSTUP_PREKLADU := vystup_prekladu

.PHONY: all clean

all: html log pdf-a4 pdf-a5

clean:
	$(RM) -R $(SOUBORY_PREKLADU) $(VYSTUP_PREKLADU)

# Podporované formáty:
html: $(VYSTUP_PREKLADU)/html/index.htm
log: $(VYSTUP_PREKLADU)/log/index.log
pdf-a4: $(VYSTUP_PREKLADU)/pdf-a4/kniha.pdf
pdf-a5: $(VYSTUP_PREKLADU)/pdf-a5/kniha.pdf

# POMOCNÉ SOUBORY:
# 1. kapitoly.lst (vygenerovat, pokud chybí)
# ============================================================================
kapitoly.lst:
	echo '# Seznam kapitol a dodatků k vygenerování\npredmluva\n\n# Kapitoly' > $@
	echo $(strip $(sort $(VSECHNY_KAPITOLY))) | tr ' ' '\n' >> $@
	echo '\n# Dodatky' >> $@
	echo $(strip $(sort $(filter-out predmluva,$(VSECHNY_DODATKY)))) | tr ' ' '\n' >> $@

# 2. kapitoly.lst => soubory_prekladu/fragmenty.tsv
# ============================================================================
$(SOUBORY_PREKLADU)/fragmenty.tsv: kapitoly.lst skripty/sepsat-fragmenty.awk
	mkdir -pv $(SOUBORY_PREKLADU)
	$(AWK) -f skripty/sepsat-fragmenty.awk $< > $@

# HTML:

# 1A. kapitoly/{kapitola}.md => soubory_prekladu/html/{kapitola}
# ============================================================================
$(addprefix $(SOUBORY_PREKLADU)/html/,$(VSECHNY_KAPITOLY)): $(SOUBORY_PREKLADU)/html/%: kapitoly/%.md skripty/do_html.awk skripty/hlavni.awk skripty/utility.awk formaty/html/sablona_kapitoly $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -f skripty/do_html.awk $< > $@

# 1B. dodatky/{dodatek}.md => soubory_prekladu/html/{dodatek}
# ============================================================================
$(addprefix $(SOUBORY_PREKLADU)/html/,$(VSECHNY_DODATKY)): $(SOUBORY_PREKLADU)/html/%: dodatky/%.md skripty/do_html.awk skripty/hlavni.awk skripty/utility.awk formaty/html/sablona_kapitoly $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -f skripty/do_html.awk $< > $@

# 2. soubory_prekladu/html/{id} => vystup_prekladu/html/{id}.htm
# ============================================================================
$(addsuffix .htm,$(addprefix $(VYSTUP_PREKLADU)/html/,$(VSECHNY_KAPITOLY) $(VSECHNY_DODATKY))): $(VYSTUP_PREKLADU)/%.htm: $(SOUBORY_PREKLADU)/% skripty/kapitola.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(VYSTUP_PREKLADU)/html
	$(AWK) -f skripty/kapitola.awk -v IDKAPITOLY=$(basename $(notdir $@)) -v TELOKAPITOLY=$< formaty/html/sablona_kapitoly > $@

# 3. formaty/html/sablona.css => vystup_prekladu/html/lkk.css
# ============================================================================
$(VYSTUP_PREKLADU)/html/lkk.css: formaty/html/sablona.css
	cat $< > $@

# 4. obrazky/{obrazek} => vystup_prekladu/html/obrazky/{obrazek}
# ============================================================================
$(OBRAZKY:%=$(VYSTUP_PREKLADU)/html/obrazky/%): $(VYSTUP_PREKLADU)/html/obrazky/%: obrazky/%
	mkdir -pv $(dir $@)
	$(CONVERT) $< $@

# 5. vystup_prekladu/html/{id}.htm => vystup_prekladu/html/index.htm (provizorní)
# ============================================================================
$(VYSTUP_PREKLADU)/html/index.htm: skripty/kniha.awk $(SOUBORY_PREKLADU)/fragmenty.tsv $(addsuffix .htm,$(addprefix $(VYSTUP_PREKLADU)/html/,$(VSECHNY_KAPITOLY) $(VSECHNY_DODATKY))) $(VYSTUP_PREKLADU)/html/lkk.css $(OBRAZKY:%=$(VYSTUP_PREKLADU)/html/obrazky/%)
	$(AWK) -f skripty/kniha.awk -v IDFORMATU=html -v VSTUPPREFIX=$(VYSTUP_PREKLADU)/html/ -v VSTUPSUFFIX=.htm formaty/html/sablona_kapitoly > $@



# LOG:

# 1A. kapitoly/{kapitola}.md => soubory_prekladu/log/{kapitola}
# ============================================================================
$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_KAPITOLY)): $(SOUBORY_PREKLADU)/log/%: kapitoly/%.md skripty/do_logu.awk skripty/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -f skripty/do_logu.awk $< > $@

# 1B. dodatky/{dodatek}.md => soubory_prekladu/log/{dodatek}
# ============================================================================
$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_DODATKY)): $(SOUBORY_PREKLADU)/log/%: dodatky/%.md skripty/do_logu.awk skripty/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -f skripty/do_logu.awk $< > $@

# 2. soubory_prekladu/log/{id} => soubory_prekladu/log/{id}.kap
# ============================================================================
$(addsuffix .kap,$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_KAPITOLY) $(VSECHNY_DODATKY))): %.kap: % skripty/kapitola.awk $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/log/sablona_kapitoly
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -f skripty/kapitola.awk -v IDKAPITOLY=$(basename $(notdir $@)) -v TELOKAPITOLY=$< formaty/log/sablona_kapitoly > $@

# 3. soubory_prekladu/log/{id}.kap => vystup_prekladu/log/index.log
# ============================================================================
$(VYSTUP_PREKLADU)/log/index.log: $(addsuffix .kap,$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_KAPITOLY) $(VSECHNY_DODATKY))) skripty/kniha.awk $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/log/sablona_kapitoly
	mkdir -pv $(VYSTUP_PREKLADU)/log
	$(AWK) -f skripty/kniha.awk -v IDFORMATU=log -v VSTUPPREFIX=$(SOUBORY_PREKLADU)/log/ -v VSTUPSUFFIX=.kap formaty/log/sablona_kapitoly > $@

# PDF (společná část):

# 1A. kapitoly/{kapitola}.md => soubory_prekladu/pdf-spolecne/{kapitola}
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%): $(SOUBORY_PREKLADU)/pdf-spolecne/%: kapitoly/%.md skripty/do_latexu.awk skripty/hlavni.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/do_latexu.awk $< > $@

# 1A. dodatky/{dodatek}.md => soubory_prekladu/pdf-spolecne/{dodatek}
# ============================================================================
$(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%): $(SOUBORY_PREKLADU)/pdf-spolecne/%: dodatky/%.md skripty/do_latexu.awk skripty/hlavni.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/do_latexu.awk $< > $@

# 2. soubory_prekladu/pdf-spolecne/{id} => soubory_prekladu/pdf-spolecne/{id}.kap
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%.kap) $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%.kap): %.kap: % skripty/kapitola.awk $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/pdf/sablona.tex
	$(AWK) -f skripty/kapitola.awk -v IDKAPITOLY=$(basename $(notdir $@)) -v TELOKAPITOLY=$< formaty/pdf/sablona.tex > $@

# 3. obrazky/{obrazek} => soubory_prekladu/pdf-spolecne/_obrazky/{obrazek}
# ============================================================================
$(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%): $(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%: obrazky/%
	mkdir -pv $(dir $@)
	$(CONVERT) $< -colorspace Gray $@



# PDF A5:

# 4. soubory_prekladu/pdf-spolecne/{id}.kap => soubory_prekladu/pdf-a5/kniha.tex
# ============================================================================
$(SOUBORY_PREKLADU)/pdf-a5/kniha.tex: $(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%.kap) $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/pdf/sablona.tex
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/kniha.awk -v IDFORMATU=pdf-a5 -v VSTUPPREFIX=$(SOUBORY_PREKLADU)/pdf-spolecne/ -v VSTUPSUFFIX=.kap formaty/pdf/sablona.tex >$@

# 5. soubory_prekladu/pdf-a5/kniha.tex => vystup_prekladu/pdf-a5/kniha.pdf
# ============================================================================
# skript "prelozit_vystup_latexu.awk" je zde volán jen pro zpřehlednění výstupu; je možno ho bezpečně vynechat
$(VYSTUP_PREKLADU)/pdf-a5/kniha.pdf: $(SOUBORY_PREKLADU)/pdf-a5/kniha.tex $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%)
	mkdir -pv $(dir $@)
	bash -e -c '(cd $(dir $<); exec $(PDFLATEX) $(notdir $<)) | $(AWK) -f skripty/prelozit_vystup_latexu.awk; exit $${PIPESTATUS[0]}'
	bash -e -c '(cd $(dir $<); exec $(PDFLATEX) $(notdir $<)) | $(AWK) -f skripty/prelozit_vystup_latexu.awk; exit $${PIPESTATUS[0]}'
	cat $(<:%.tex=%.pdf) > $@

# PDF A4:

# 4. soubory_prekladu/pdf-spolecne/{kapitola}.kap => soubory_prekladu/pdf-a4/kniha.tex
# ============================================================================
$(SOUBORY_PREKLADU)/pdf-a4/kniha.tex: $(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%.kap) $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/pdf/sablona.tex
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/kniha.awk -v IDFORMATU=pdf-a4 -v VSTUPPREFIX=$(SOUBORY_PREKLADU)/pdf-spolecne/ -v VSTUPSUFFIX=.kap formaty/pdf/sablona.tex >$@

# 5. soubory_prekladu/pdf-a4/kniha.tex => vystup_prekladu/pdf-a4/kniha.pdf
# ============================================================================
# skript "prelozit_vystup_latexu.awk" je zde volán jen pro zpřehlednění výstupu; je možno ho bezpečně vynechat
$(VYSTUP_PREKLADU)/pdf-a4/kniha.pdf: $(SOUBORY_PREKLADU)/pdf-a4/kniha.tex $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%)
	mkdir -pv $(dir $@)
	bash -e -c '(cd $(dir $<); exec $(PDFLATEX) $(notdir $<)) | $(AWK) -f skripty/prelozit_vystup_latexu.awk; exit $${PIPESTATUS[0]}'
	bash -e -c '(cd $(dir $<); exec $(PDFLATEX) $(notdir $<)) | $(AWK) -f skripty/prelozit_vystup_latexu.awk; exit $${PIPESTATUS[0]}'
	cat $(<:%.tex=%.pdf) > $@


