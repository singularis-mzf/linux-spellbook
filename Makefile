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

# Nástroje
# ============================================================================
SHELL := /bin/sh
AWK := gawk
CONVERT := convert

# Dodatky a kapitoly
# ============================================================================
VSECHNY_DODATKY := predmluva koncepce-projektu plan-vyvoje test licence

# _ A, B, C, D, E, F, G
VSECHNY_KAPITOLY := _ostatni _ukazka awk barvy-a-titulek datum-cas-kalendar diskove-oddily docker firefox git
# H, I, J, K, L, M
VSECHNY_KAPITOLY += hledani-souboru konverze-formatu latex make markdown
# N, O, P, Q, R, S
VSECHNY_KAPITOLY += odkazy perl planovani-uloh prace-s-archivy regularni-vyrazy
# S
VSECHNY_KAPITOLY += sprava-balicku sprava-uzivatelu stahovani-videi system
# T, U, V, W, X, Y, Z
VSECHNY_KAPITOLY += unicode x zpracovani-obrazku zpracovani-textovych-souboru zpracovani-videa-a-zvuku

# Obrázky (bitmapové a SVG)
# ============================================================================
OBRAZKY := favicon.png by-sa.png logo-knihy-velke.png make.png barvy.png ve-vystavbe.png marsh.jpg banner.png
SVG_OBRAZKY := kalendar.svg tritecky.svg graf-filtru.svg


# Další nastavení
# ============================================================================
SOUBORY_PREKLADU := soubory_prekladu
VYSTUP_PREKLADU := vystup_prekladu

# Datum sestavení ve formátu %Y%m%d a odpovídající soubor.
DATUM_SESTAVENI := $(shell date +%Y%m%d)
DATUM_SESTAVENI_SOUBOR := $(SOUBORY_PREKLADU)/datum-$(DATUM_SESTAVENI).txt

# Výchozí jméno buildu
JMENO := Sid $(DATUM_SESTAVENI)

.PHONY: all clean html log pdf-a4 pdf-b5 pdf-a5 pomocne-funkce

all: html log pdf-a4 pdf-b5 pomocne-funkce

clean:
	$(RM) -Rv $(SOUBORY_PREKLADU) $(VYSTUP_PREKLADU) kapitoly.lst

# Podporované formáty:
html: $(addprefix $(VYSTUP_PREKLADU)/html/, lkk-$(DATUM_SESTAVENI).css index.htm _autori.htm)
log: $(VYSTUP_PREKLADU)/log/index.log
pdf-a4: $(VYSTUP_PREKLADU)/pdf-a4/kniha.pdf
pdf-b5: $(VYSTUP_PREKLADU)/pdf-b5/kniha.pdf
pdf-a5: $(VYSTUP_PREKLADU)/pdf-a5/kniha.pdf
pomocne-funkce: $(VYSTUP_PREKLADU)/bin/pomocne-funkce.sh

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

# 3. soubory_prekladu/fragmenty.tsv + *.md => soubory_prekladu/osnova/*.tsv
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv): $(SOUBORY_PREKLADU)/osnova/%.tsv: kapitoly/%.md $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/sepsat-osnovu.awk
	mkdir -pv $(SOUBORY_PREKLADU)/osnova
	$(AWK) -f skripty/sepsat-osnovu.awk -v IDKAPITOLY=$(<:kapitoly/%.md=%) $< >$@

$(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv): $(SOUBORY_PREKLADU)/osnova/%.tsv: dodatky/%.md $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/sepsat-osnovu.awk
	mkdir -pv $(SOUBORY_PREKLADU)/osnova
	$(AWK) -f skripty/sepsat-osnovu.awk -v IDKAPITOLY=$(<:dodatky/%.md=%) $< >$@

# 3. soubory_prekladu/postprocess.tsv
# ============================================================================
$(SOUBORY_PREKLADU)/postprocess.tsv:
	-test -r postprocess.tsv && cat postprocess.tsv >"$@"
	touch "$@"

# 4. soubory_prekladu/datum-*.txt
# ============================================================================
$(DATUM_SESTAVENI_SOUBOR):
	$(RM) -v $(SOUBORY_PREKLADU)/datum-*.txt
	printf $(DATUM_SESTAVENI)\\n >"$@"

# HTML:

# 1A. kapitoly/{kapitola}.md => soubory_prekladu/html/{kapitola}
# ============================================================================
$(addprefix $(SOUBORY_PREKLADU)/html/,$(VSECHNY_KAPITOLY)): $(SOUBORY_PREKLADU)/html/%: kapitoly/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/do_html.awk skripty/hlavni.awk skripty/utility.awk formaty/html/sablona_kapitoly $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -f skripty/do_html.awk $< > $@

# 1B. dodatky/{dodatek}.md => soubory_prekladu/html/{dodatek}
# ============================================================================
$(addprefix $(SOUBORY_PREKLADU)/html/,$(VSECHNY_DODATKY)): $(SOUBORY_PREKLADU)/html/%: dodatky/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/do_html.awk skripty/hlavni.awk skripty/utility.awk formaty/html/sablona_kapitoly $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -f skripty/do_html.awk $< > $@

# 2. soubory_prekladu/html/{id} => vystup_prekladu/html/{id}.htm
# ============================================================================
$(addsuffix .htm,$(addprefix $(VYSTUP_PREKLADU)/html/,$(VSECHNY_KAPITOLY) $(VSECHNY_DODATKY))): $(VYSTUP_PREKLADU)/%.htm: $(SOUBORY_PREKLADU)/% skripty/kapitola.awk $(SOUBORY_PREKLADU)/fragmenty.tsv $(DATUM_SESTAVENI_SOUBOR)
	mkdir -pv $(VYSTUP_PREKLADU)/html
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | fgrep -qx $(basename $(notdir $<)) && exec $(AWK) -f skripty/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDKAPITOLY=$(basename $(notdir $@)) -v TELOKAPITOLY=$< -v DATUMSESTAVENI=$(DATUM_SESTAVENI) formaty/html/sablona_kapitoly > $@ || true

# 3. formaty/html/sablona.css => vystup_prekladu/html/lkk.css
# ============================================================================
$(VYSTUP_PREKLADU)/html/lkk-$(DATUM_SESTAVENI).css: formaty/html/sablona.css
	mkdir -pv $(dir $@)
	$(RM) $(VYSTUP_PREKLADU)/html/lkk-2*.css
	cat $< > $@

# 4. obrazky/{obrazek} => vystup_prekladu/html/obrazky/{obrazek}
# ============================================================================
$(OBRAZKY:%=$(VYSTUP_PREKLADU)/html/obrazky/%): $(VYSTUP_PREKLADU)/html/obrazky/%: obrazky/%
	mkdir -pv $(dir $@)
	$(CONVERT) $< $@

$(SVG_OBRAZKY:%=$(VYSTUP_PREKLADU)/html/obrazky/%): $(VYSTUP_PREKLADU)/html/obrazky/%: obrazky/%
	mkdir -pv $(dir $@)
	cp $< $@

# 5. vystup_prekladu/html/{id}.htm => vystup_prekladu/html/index.htm
# ============================================================================
$(VYSTUP_PREKLADU)/html/index.htm: $(SOUBORY_PREKLADU)/fragmenty.tsv \
  skripty/generovat-index-html.awk \
  $(addsuffix .htm,$(addprefix $(VYSTUP_PREKLADU)/html/,$(VSECHNY_KAPITOLY) $(VSECHNY_DODATKY)))   $(SOUBORY_PREKLADU)/fragmenty.tsv \
  $(OBRAZKY:%=$(VYSTUP_PREKLADU)/html/obrazky/%) \
  $(SVG_OBRAZKY:%=$(VYSTUP_PREKLADU)/html/obrazky/%) \
  $(DATUM_SESTAVENI_SOUBOR)
	$(AWK) -f skripty/generovat-index-html.awk -F \\t -v JMENOVERZE='$(JMENO)' -v DATUMSESTAVENI=$(DATUM_SESTAVENI) $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/html/sablona_kapitoly > $@

# 6. sepsat copyrighty ke kapitolám
# ============================================================================
$(SOUBORY_PREKLADU)/html/kap-copys.htm: $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/sepsat-copyrighty.awk $(VSECHNY_DODATKY:%=dodatky/%.md) $(VSECHNY_KAPITOLY:%=kapitoly/%.md)
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -f skripty/sepsat-copyrighty.awk $(shell cut -f 1,2 --output-delimiter=/ $< | sed 's/$$/.md/') >$@

# 7. sepsat copyrighty k obrázkům
# ============================================================================
$(SOUBORY_PREKLADU)/html/obr-copys.htm: COPYING skripty/sepsat-copykobr.awk
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/sepsat-copykobr.awk $< $(OBRAZKY:%=obrazky/%) $(SVG_OBRAZKY:%=obrazky/%) >$@

# 8. shromáždit copyrighty na stránku _autori.htm
# ============================================================================
$(VYSTUP_PREKLADU)/html/_autori.htm: \
  $(addprefix $(SOUBORY_PREKLADU)/html/, kap-copys.htm obr-copys.htm) \
  skripty/kapitola.awk \
  formaty/html/sablona_licinfo \
  $(DATUM_SESTAVENI_SOUBOR)
	$(AWK) -f skripty/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDKAPITOLY=_autori -v TELOKAPITOLY=/dev/null -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v COPYRIGHTY_KAPITOL=$(SOUBORY_PREKLADU)/html/kap-copys.htm -v COPYRIGHTY_OBRAZKU=$(SOUBORY_PREKLADU)/html/obr-copys.htm formaty/html/sablona_licinfo > $@ || true


# LOG:

# 1A. kapitoly/{kapitola}.md => soubory_prekladu/log/{kapitola}
# ============================================================================
$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_KAPITOLY)): $(SOUBORY_PREKLADU)/log/%: kapitoly/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/do_logu.awk skripty/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -f skripty/do_logu.awk $< > $@

# 1B. dodatky/{dodatek}.md => soubory_prekladu/log/{dodatek}
# ============================================================================
$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_DODATKY)): $(SOUBORY_PREKLADU)/log/%: dodatky/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/do_logu.awk skripty/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -f skripty/do_logu.awk $< > $@

# 2. soubory_prekladu/log/{id} => soubory_prekladu/log/{id}.kap + vystup_prekladu/log/{id}.log
# ============================================================================
$(addsuffix .kap,$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_KAPITOLY) $(VSECHNY_DODATKY))): %.kap: % skripty/kapitola.awk $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/log/sablona_kapitoly $(DATUM_SESTAVENI_SOUBOR)
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -f skripty/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDKAPITOLY=$(basename $(notdir $@)) -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v TELOKAPITOLY=$< formaty/log/sablona_kapitoly > $@

# 3. soubory_prekladu/log/{id}.kap => vystup_prekladu/log/{id}.log
# ============================================================================
$(addsuffix .log,$(addprefix $(VYSTUP_PREKLADU)/log/,$(VSECHNY_KAPITOLY) $(VSECHNY_DODATKY))): $(VYSTUP_PREKLADU)/log/%.log: $(SOUBORY_PREKLADU)/log/%.kap
	mkdir -pv $(VYSTUP_PREKLADU)/log
	cat $< > $@

# 4. soubory_prekladu/log/{id}.kap => vystup_prekladu/log/index.log
# ============================================================================
$(VYSTUP_PREKLADU)/log/index.log: \
  $(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/log/%.kap) \
  $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/log/%.kap) \
  $(VSECHNY_KAPITOLY:%=$(VYSTUP_PREKLADU)/log/%.log) \
  $(VSECHNY_DODATKY:%=$(VYSTUP_PREKLADU)/log/%.log) \
  skripty/kniha.awk \
  $(SOUBORY_PREKLADU)/fragmenty.tsv \
  formaty/log/sablona_kapitoly
	mkdir -pv $(VYSTUP_PREKLADU)/log
	$(AWK) -f skripty/kniha.awk -v IDFORMATU=log -v JMENOVERZE='$(JMENO)' -v VSTUPPREFIX=$(SOUBORY_PREKLADU)/log/ -v VSTUPSUFFIX=.kap formaty/log/sablona_kapitoly > $@

# PDF (společná část):

# 1A. kapitoly/{kapitola}.md => soubory_prekladu/pdf-spolecne/{kapitola}
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%): \
  $(SOUBORY_PREKLADU)/pdf-spolecne/%: \
  kapitoly/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/do_latexu.awk skripty/hlavni.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/do_latexu.awk $< > $@

# 1B. dodatky/{dodatek}.md => soubory_prekladu/pdf-spolecne/{dodatek}
# ============================================================================
$(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%): $(SOUBORY_PREKLADU)/pdf-spolecne/%: dodatky/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/do_latexu.awk skripty/hlavni.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/do_latexu.awk $< > $@

# 2. soubory_prekladu/pdf-spolecne/{id} => soubory_prekladu/pdf-spolecne/{id}.kap
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%.kap) $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%.kap): \
  %.kap: \
  % skripty/kapitola.awk $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/pdf/sablona.tex $(DATUM_SESTAVENI_SOUBOR)
	$(AWK) -f skripty/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDKAPITOLY=$(basename $(notdir $@)) -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v TELOKAPITOLY=$< formaty/pdf/sablona.tex > $@

# 3. obrazky/{obrazek} => soubory_prekladu/pdf-spolecne/_obrazky/{obrazek}
# ============================================================================
$(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%): $(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%: obrazky/% konfig.ini
	mkdir -pv $(dir $@)
	$(CONVERT) $< $(shell bash -e skripty/precist_konfig.sh "Filtry" "$(@:$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%=../obrazky/%)" "-colorspace Gray" < konfig.ini) $@

$(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%.pdf): $(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%.pdf: obrazky/%.svg
	mkdir -pv $(dir $@)
#	inkscape --without-gui "--file=$<" "--export-pdf=$@"
#	z balíčku „librsvg2-bin“:
	rsvg-convert -f pdf -o "$@" "$<"


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
$(VYSTUP_PREKLADU)/pdf-a5/kniha.pdf: $(SOUBORY_PREKLADU)/pdf-a5/kniha.tex $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%) $(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%.pdf)
	mkdir -pv $(dir $@)
	ln -rsTv skripty $(dir $<)skripty 2>/dev/null || true
	cd $(dir $<); exec $(AWK) -f skripty/latex.awk
	cat $(<:%.tex=%.pdf) > $@

# PDF A4:

# 4. soubory_prekladu/pdf-spolecne/{id}.kap => soubory_prekladu/pdf-a4/{id}.kap
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-a4/%.kap) $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-a4/%.kap): \
  $(SOUBORY_PREKLADU)/pdf-a4/%.kap: \
  $(SOUBORY_PREKLADU)/pdf-spolecne/%.kap $(SOUBORY_PREKLADU)/postprocess.tsv skripty/postprocess.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-a4 -v IDKAPITOLY=$(<:$(SOUBORY_PREKLADU)/pdf-spolecne/%.kap=%) -v LOGSOUBOR=$(SOUBORY_PREKLADU)/postprocess.log -f skripty/postprocess.awk $< >$@

# 5. soubory_prekladu/pdf-a4/{kapitola}.kap => soubory_prekladu/pdf-a4/kniha.tex
# ============================================================================
$(SOUBORY_PREKLADU)/pdf-a4/kniha.tex: $(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-a4/%.kap) $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-a4/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/pdf/sablona.tex
	$(AWK) -f skripty/kniha.awk -v IDFORMATU=pdf-a4 -v JMENOVERZE='$(JMENO)' -v VSTUPPREFIX=$(SOUBORY_PREKLADU)/pdf-a4/ -v VSTUPSUFFIX=.kap formaty/pdf/sablona.tex >$@

# 6. soubory_prekladu/pdf-a4/kniha.tex => vystup_prekladu/pdf-a4/kniha.pdf
# ============================================================================
$(VYSTUP_PREKLADU)/pdf-a4/kniha.pdf: $(SOUBORY_PREKLADU)/pdf-a4/kniha.tex $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%) $(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%.pdf)
	mkdir -pv $(dir $@)
	ln -rsTv skripty $(dir $<)skripty 2>/dev/null || true
	cd $(dir $<); exec $(AWK) -f skripty/latex.awk
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
$(VYSTUP_PREKLADU)/pdf-b5/kniha.pdf: $(SOUBORY_PREKLADU)/pdf-b5/kniha.tex $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%) $(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%.pdf)
	mkdir -pv $(dir $@)
	ln -rsTv skripty $(dir $<)skripty 2>/dev/null || true
	cd $(dir $<); exec $(AWK) -f skripty/latex.awk
	cat $(<:%.tex=%.pdf) > $@


# Pomocné funkce a skripty:
$(VYSTUP_PREKLADU)/bin/pomocne-funkce.sh: $(VSECHNY_KAPITOLY:%=kapitoly/%.md) $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/extrahovat-pomocne-funkce.awk
	mkdir -pv $(VYSTUP_PREKLADU)/bin
	$(AWK) -f skripty/extrahovat-pomocne-funkce.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
