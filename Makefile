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

VSECHNY_DODATKY := predmluva koncepce-projektu plan-vyvoje test mechanismus-prekladu licence

# _ A, B, C, D, E, F, G
VSECHNY_KAPITOLY := _ostatni _ukazka awk barvy-a-titulek datum-cas-kalendar docker firefox git
# H, I, J, K, L, M
VSECHNY_KAPITOLY += hledani-souboru make markdown
# N, O, P, Q, R, S
VSECHNY_KAPITOLY += obrazky odkazy planovani-uloh regularni-vyrazy soubory stahovani-videi
# T, U, V, W, X, Y, Z
VSECHNY_KAPITOLY += x zpracovani-videa-a-zvuku

OBRAZKY := favicon.png by-sa.png logo-knihy-velke.png make.png barvy.png ve-vystavbe.png marsh.jpg banner.png

SOUBORY_PREKLADU := soubory_prekladu
VYSTUP_PREKLADU := vystup_prekladu

# Výchozí jméno buildu
JMENO := Sid $(shell date +%Y%m%d)

.PHONY: all clean

all: html log pdf-a4 pdf-b5 pdf-a5

clean:
	$(RM) -Rv $(SOUBORY_PREKLADU) $(VYSTUP_PREKLADU) kapitoly.lst

# Podporované formáty:
html: $(addprefix $(VYSTUP_PREKLADU)/html/, index.htm _autori.htm)
log: $(VYSTUP_PREKLADU)/log/index.log
pdf-a4: $(VYSTUP_PREKLADU)/pdf-a4/kniha.pdf
pdf-b5: $(VYSTUP_PREKLADU)/pdf-b5/kniha.pdf
pdf-a5: $(VYSTUP_PREKLADU)/pdf-a5/kniha.pdf

# POMOCNÉ SOUBORY:
# 1. kapitoly.lst (není-li, použít kapitoly.lst.vychozi; není-li ani ten, vygenerovat)
# ============================================================================
kapitoly.lst.vychozi:
	printf %s\\n "# Seznam kapitol a dodatků k vygenerování" "predmluva" "" "# Kapitoly" > $@
	printf %s\\n $(strip $(sort $(VSECHNY_KAPITOLY))) >> $@
	printf %s\\n "" "# Dodatky" >> $@
	printf %s\\n $(strip $(sort $(filter-out predmluva,$(VSECHNY_DODATKY)))) >> $@

kapitoly.lst: kapitoly.lst.vychozi
	test -e $@ && touch $@ || cat $< >$@

# 2. kapitoly.lst => soubory_prekladu/fragmenty.tsv
# ============================================================================
$(SOUBORY_PREKLADU)/fragmenty.tsv: kapitoly.lst skripty/sepsat-fragmenty.awk
	mkdir -pv $(SOUBORY_PREKLADU)
	$(AWK) -f skripty/sepsat-fragmenty.awk $< > $@


# 3. soubory_prekladu/postprocess.tsv
# ============================================================================
$(SOUBORY_PREKLADU)/postprocess.tsv:
	test -r postprocess.tsv && cat postprocess.tsv >"$@"
	touch "$@"

# HTML:

# 1A. kapitoly/{kapitola}.md => soubory_prekladu/html/{kapitola}
# ============================================================================
$(addprefix $(SOUBORY_PREKLADU)/html/,$(VSECHNY_KAPITOLY)): $(SOUBORY_PREKLADU)/html/%: kapitoly/%.md skripty/do_html.awk skripty/hlavni.awk skripty/utility.awk formaty/html/sablona_kapitoly $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -f skripty/do_html.awk -v IDKAPITOLY=$(basename $(notdir $@)) $< > $@

# 1B. dodatky/{dodatek}.md => soubory_prekladu/html/{dodatek}
# ============================================================================
$(addprefix $(SOUBORY_PREKLADU)/html/,$(VSECHNY_DODATKY)): $(SOUBORY_PREKLADU)/html/%: dodatky/%.md skripty/do_html.awk skripty/hlavni.awk skripty/utility.awk formaty/html/sablona_kapitoly $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -f skripty/do_html.awk -v IDKAPITOLY=$(basename $(notdir $@)) $< > $@

# 2. soubory_prekladu/html/{id} => vystup_prekladu/html/{id}.htm
# ============================================================================
$(addsuffix .htm,$(addprefix $(VYSTUP_PREKLADU)/html/,$(VSECHNY_KAPITOLY) $(VSECHNY_DODATKY))): $(VYSTUP_PREKLADU)/%.htm: $(SOUBORY_PREKLADU)/% skripty/kapitola.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(VYSTUP_PREKLADU)/html
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | fgrep -qx $(basename $(notdir $<)) && exec $(AWK) -f skripty/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDKAPITOLY=$(basename $(notdir $@)) -v TELOKAPITOLY=$< formaty/html/sablona_kapitoly > $@ || true

# 3. formaty/html/sablona.css => vystup_prekladu/html/lkk.css
# ============================================================================
$(VYSTUP_PREKLADU)/html/lkk.css: formaty/html/sablona.css
	cat $< > $@

# 4. obrazky/{obrazek} => vystup_prekladu/html/obrazky/{obrazek}
# ============================================================================
$(OBRAZKY:%=$(VYSTUP_PREKLADU)/html/obrazky/%): $(VYSTUP_PREKLADU)/html/obrazky/%: obrazky/%
	mkdir -pv $(dir $@)
	$(CONVERT) $< $@

# 5. vystup_prekladu/html/{id}.htm => vystup_prekladu/html/index.htm
# ============================================================================
$(VYSTUP_PREKLADU)/html/index.htm: $(SOUBORY_PREKLADU)/fragmenty.tsv \
  skripty/generovat-index-html.awk \
  $(addsuffix .htm,$(addprefix $(VYSTUP_PREKLADU)/html/,$(VSECHNY_KAPITOLY) $(VSECHNY_DODATKY)))   $(VYSTUP_PREKLADU)/html/lkk.css \
  $(OBRAZKY:%=$(VYSTUP_PREKLADU)/html/obrazky/%)
	$(AWK) -f skripty/generovat-index-html.awk -v JMENOVERZE='$(JMENO)' formaty/html/sablona_kapitoly > $@

# 6. sepsat copyrighty ke kapitolám
# ============================================================================
$(SOUBORY_PREKLADU)/html/kap-copys.htm: $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/sepsat-copyrighty.awk $(VSECHNY_DODATKY:%=dodatky/%.md) $(VSECHNY_KAPITOLY:%=kapitoly/%.md)
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -f skripty/sepsat-copyrighty.awk $(shell cut -f 1,2 --output-delimiter=/ $< | sed 's/$$/.md/') >$@

# 7. sepsat copyrighty k obrázkům
# ============================================================================
$(SOUBORY_PREKLADU)/html/obr-copys.htm: COPYING skripty/sepsat-copykobr.awk
	$(AWK) -f skripty/sepsat-copykobr.awk $< $(OBRAZKY:%=obrazky/%) >$@

# 8. shromáždit copyrighty na stránku _autori.htm
# ============================================================================
$(VYSTUP_PREKLADU)/html/_autori.htm: $(addprefix $(SOUBORY_PREKLADU)/html/, kap-copys.htm obr-copys.htm) skripty/kapitola.awk formaty/html/sablona_licinfo
	$(AWK) -f skripty/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDKAPITOLY=_autori -v TELOKAPITOLY=/dev/null -v COPYRIGHTY_KAPITOL=$(SOUBORY_PREKLADU)/html/kap-copys.htm -v COPYRIGHTY_OBRAZKU=$(SOUBORY_PREKLADU)/html/obr-copys.htm formaty/html/sablona_licinfo > $@ || true


# LOG:

# 1A. kapitoly/{kapitola}.md => soubory_prekladu/log/{kapitola}
# ============================================================================
$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_KAPITOLY)): $(SOUBORY_PREKLADU)/log/%: kapitoly/%.md skripty/do_logu.awk skripty/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -v IDKAPITOLY=$(basename $(notdir $@)) -f skripty/do_logu.awk $< > $@

# 1B. dodatky/{dodatek}.md => soubory_prekladu/log/{dodatek}
# ============================================================================
$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_DODATKY)): $(SOUBORY_PREKLADU)/log/%: dodatky/%.md skripty/do_logu.awk skripty/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -f skripty/do_logu.awk -v IDKAPITOLY=$(basename $(notdir $@)) $< > $@

# 2. soubory_prekladu/log/{id} => soubory_prekladu/log/{id}.kap
# ============================================================================
$(addsuffix .kap,$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_KAPITOLY) $(VSECHNY_DODATKY))): %.kap: % skripty/kapitola.awk $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/log/sablona_kapitoly
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -f skripty/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDKAPITOLY=$(basename $(notdir $@)) -v TELOKAPITOLY=$< formaty/log/sablona_kapitoly > $@

# 3. soubory_prekladu/log/{id}.kap => vystup_prekladu/log/index.log
# ============================================================================
$(VYSTUP_PREKLADU)/log/index.log: $(addsuffix .kap,$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_KAPITOLY) $(VSECHNY_DODATKY))) skripty/kniha.awk $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/log/sablona_kapitoly
	mkdir -pv $(VYSTUP_PREKLADU)/log
	$(AWK) -f skripty/kniha.awk -v IDFORMATU=log -v JMENOVERZE='$(JMENO)' -v VSTUPPREFIX=$(SOUBORY_PREKLADU)/log/ -v VSTUPSUFFIX=.kap formaty/log/sablona_kapitoly > $@

# PDF (společná část):

# 1A. kapitoly/{kapitola}.md => soubory_prekladu/pdf-spolecne/{kapitola}
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%): $(SOUBORY_PREKLADU)/pdf-spolecne/%: kapitoly/%.md skripty/do_latexu.awk skripty/hlavni.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/do_latexu.awk -v IDKAPITOLY=$(basename $(notdir $@)) $< > $@

# 1A. dodatky/{dodatek}.md => soubory_prekladu/pdf-spolecne/{dodatek}
# ============================================================================
$(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%): $(SOUBORY_PREKLADU)/pdf-spolecne/%: dodatky/%.md skripty/do_latexu.awk skripty/hlavni.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/do_latexu.awk -v IDKAPITOLY=$(basename $(notdir $@)) $< > $@

# 2. soubory_prekladu/pdf-spolecne/{id} => soubory_prekladu/pdf-spolecne/{id}.kap
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%.kap) $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%.kap): %.kap: % skripty/kapitola.awk $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/pdf/sablona.tex
	$(AWK) -f skripty/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDKAPITOLY=$(basename $(notdir $@)) -v TELOKAPITOLY=$< formaty/pdf/sablona.tex > $@

# 3. obrazky/{obrazek} => soubory_prekladu/pdf-spolecne/_obrazky/{obrazek}
# ============================================================================
$(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%): $(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%: obrazky/%
	mkdir -pv $(dir $@)
	$(CONVERT) $< -colorspace Gray $@



# PDF A5:

# 4. soubory_prekladu/pdf-spolecne/{id}.kap => soubory_prekladu/pdf-a5/{id}.kap
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-a5/%.kap) $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-a5/%.kap): $(SOUBORY_PREKLADU)/pdf-a5/%.kap: $(SOUBORY_PREKLADU)/pdf-spolecne/%.kap $(SOUBORY_PREKLADU)/postprocess.tsv skripty/postprocess.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-a5 -v IDKAPITOLY=$(<:$(SOUBORY_PREKLADU)/pdf-spolecne/%.kap=%) -v LOGSOUBOR=$(SOUBORY_PREKLADU)/postprocess.log -f skripty/postprocess.awk $< >$@

# 5. soubory_prekladu/pdf-a5/{id}.kap => soubory_prekladu/pdf-a5/kniha.tex
# ============================================================================
$(SOUBORY_PREKLADU)/pdf-a5/kniha.tex: $(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-a5/%.kap) $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-a5/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/pdf/sablona.tex
	$(AWK) -f skripty/kniha.awk -v IDFORMATU=pdf-a5 -v JMENOVERZE='$(JMENO)' -v VSTUPPREFIX=$(SOUBORY_PREKLADU)/pdf-a5/ -v VSTUPSUFFIX=.kap formaty/pdf/sablona.tex >$@

# 6. soubory_prekladu/pdf-a5/kniha.tex => vystup_prekladu/pdf-a5/kniha.pdf
# ============================================================================
# skript "prelozit_vystup_latexu.awk" je zde volán jen pro zpřehlednění výstupu; je možno ho bezpečně vynechat
$(VYSTUP_PREKLADU)/pdf-a5/kniha.pdf: $(SOUBORY_PREKLADU)/pdf-a5/kniha.tex $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%)
	mkdir -pv $(dir $@)
	bash -e -c '(cd $(dir $<); exec $(PDFLATEX) $(notdir $<)) | $(AWK) -f skripty/prelozit_vystup_latexu.awk; exit $${PIPESTATUS[0]}'
	bash -e -c '(cd $(dir $<); exec $(PDFLATEX) $(notdir $<)) | $(AWK) -f skripty/prelozit_vystup_latexu.awk; exit $${PIPESTATUS[0]}'
	cat $(<:%.tex=%.pdf) > $@

# PDF A4:

# 4. soubory_prekladu/pdf-spolecne/{id}.kap => soubory_prekladu/pdf-a4/{id}.kap
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-a4/%.kap) $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-a4/%.kap): $(SOUBORY_PREKLADU)/pdf-a4/%.kap: $(SOUBORY_PREKLADU)/pdf-spolecne/%.kap $(SOUBORY_PREKLADU)/postprocess.tsv skripty/postprocess.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-a4 -v IDKAPITOLY=$(<:$(SOUBORY_PREKLADU)/pdf-spolecne/%.kap=%) -v LOGSOUBOR=$(SOUBORY_PREKLADU)/postprocess.log -f skripty/postprocess.awk $< >$@

# 5. soubory_prekladu/pdf-a4/{kapitola}.kap => soubory_prekladu/pdf-a4/kniha.tex
# ============================================================================
$(SOUBORY_PREKLADU)/pdf-a4/kniha.tex: $(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-a4/%.kap) $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-a4/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/pdf/sablona.tex
	$(AWK) -f skripty/kniha.awk -v IDFORMATU=pdf-a4 -v JMENOVERZE='$(JMENO)' -v VSTUPPREFIX=$(SOUBORY_PREKLADU)/pdf-a4/ -v VSTUPSUFFIX=.kap formaty/pdf/sablona.tex >$@

# 6. soubory_prekladu/pdf-a4/kniha.tex => vystup_prekladu/pdf-a4/kniha.pdf
# ============================================================================
# skript "prelozit_vystup_latexu.awk" je zde volán jen pro zpřehlednění výstupu; je možno ho bezpečně vynechat
$(VYSTUP_PREKLADU)/pdf-a4/kniha.pdf: $(SOUBORY_PREKLADU)/pdf-a4/kniha.tex $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%)
	mkdir -pv $(dir $@)
	bash -e -c '(cd $(dir $<); exec $(PDFLATEX) $(notdir $<)) | $(AWK) -f skripty/prelozit_vystup_latexu.awk; exit $${PIPESTATUS[0]}'
	bash -e -c '(cd $(dir $<); exec $(PDFLATEX) $(notdir $<)) | $(AWK) -f skripty/prelozit_vystup_latexu.awk; exit $${PIPESTATUS[0]}'
	cat $(<:%.tex=%.pdf) > $@

# PDF B5:
# 4. soubory_prekladu/pdf-spolecne/{id}.kap => soubory_prekladu/pdf-b5/{id}.kap
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-b5/%.kap) $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-b5/%.kap): $(SOUBORY_PREKLADU)/pdf-b5/%.kap: $(SOUBORY_PREKLADU)/pdf-spolecne/%.kap $(SOUBORY_PREKLADU)/postprocess.tsv skripty/postprocess.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-b5 -v IDKAPITOLY=$(<:$(SOUBORY_PREKLADU)/pdf-spolecne/%.kap=%) -v LOGSOUBOR=$(SOUBORY_PREKLADU)/postprocess.log -f skripty/postprocess.awk $< >$@

# 5. soubory_prekladu/pdf-spolecne/{kapitola}.kap => soubory_prekladu/pdf-a4/kniha.tex
# ============================================================================
$(SOUBORY_PREKLADU)/pdf-b5/kniha.tex: $(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-b5/%.kap) $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-b5/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/pdf/sablona.tex
	$(AWK) -f skripty/kniha.awk -v IDFORMATU=pdf-b5 -v JMENOVERZE='$(JMENO)' -v VSTUPPREFIX=$(SOUBORY_PREKLADU)/pdf-b5/ -v VSTUPSUFFIX=.kap formaty/pdf/sablona.tex >$@

# 6. soubory_prekladu/pdf-b5/kniha.tex => vystup_prekladu/pdf-b5/kniha.pdf
# ============================================================================
# skript "prelozit_vystup_latexu.awk" je zde volán jen pro zpřehlednění výstupu; je možno ho bezpečně vynechat
$(VYSTUP_PREKLADU)/pdf-b5/kniha.pdf: $(SOUBORY_PREKLADU)/pdf-b5/kniha.tex $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%)
	mkdir -pv $(dir $@)
	bash -e -c '(cd $(dir $<); exec $(PDFLATEX) $(notdir $<)) | $(AWK) -f skripty/prelozit_vystup_latexu.awk; exit $${PIPESTATUS[0]}'
	bash -e -c '(cd $(dir $<); exec $(PDFLATEX) $(notdir $<)) | $(AWK) -f skripty/prelozit_vystup_latexu.awk; exit $${PIPESTATUS[0]}'
	cat $(<:%.tex=%.pdf) > $@
