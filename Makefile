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
VSECHNY_KAPITOLY += unicode x zpracovani-binarnich-souboru zpracovani-obrazku zpracovani-textovych-souboru zpracovani-videa-a-zvuku

VSECHNY_KAPITOLY_A_DODATKY = $(VSECHNY_KAPITOLY) $(VSECHNY_DODATKY)
VSECHNY_KAPITOLY_A_DODATKY_MD = $(VSECHNY_KAPITOLY:%=kapitoly/%.md) $(VSECHNY_DODATKY:%=dodatky/%.md)

# Obrázky (bitmapové a SVG)
# ============================================================================
OBRAZKY := favicon.png by-sa.png logo-knihy-velke.png make.png barvy.png ve-vystavbe.png marsh.jpg banner.png
OBRAZKY += ik-vychozi.png
SVG_OBRAZKY := kalendar.svg tritecky.svg graf-filtru.svg


# Další nastavení
# ============================================================================
SOUBORY_PREKLADU := soubory_prekladu
VYSTUP_PREKLADU := vystup_prekladu
PORADI_KAPITOL := $(SOUBORY_PREKLADU)/poradi-kapitol.lst

# Datum sestavení ve formátu %Y%m%d a odpovídající soubor.
DATUM_SESTAVENI := $(shell date +%Y%m%d)
DATUM_SESTAVENI_SOUBOR := $(SOUBORY_PREKLADU)/datum-$(DATUM_SESTAVENI).txt

# Výchozí jméno buildu
JMENO := Sid $(DATUM_SESTAVENI)

.PHONY: all clean html log pdf-a4 pdf-b5 pomocne-funkce

all: html log pdf-a4 pdf-b5 pomocne-funkce

clean:
	$(RM) -Rv $(SOUBORY_PREKLADU) $(VYSTUP_PREKLADU) $(PORADI_KAPITOL)

# Podporované formáty:
html: $(addprefix $(VYSTUP_PREKLADU)/html/, lkk-$(DATUM_SESTAVENI).css index.htm x-autori.htm x-stitky.htm)
log: $(VYSTUP_PREKLADU)/log/index.log
pdf-a4: $(VYSTUP_PREKLADU)/pdf-a4.pdf
pdf-b5: $(VYSTUP_PREKLADU)/pdf-b5.pdf
pomocne-funkce: $(VYSTUP_PREKLADU)/bin/pomocne-funkce.sh

# POMOCNÉ SOUBORY:
# 1. soubory_prekladu/fragmenty.tsv + soubory_prekladu/stitky.tsv
# ============================================================================
$(SOUBORY_PREKLADU)/fragmenty.tsv: $(wildcard poradi-kapitol.lst poradi-kapitol.vychozi.lst) \
  skripty/extrakce/fragmenty.awk $(VSECHNY_KAPITOLY_A_DODATKY_MD)
	mkdir -pv $(SOUBORY_PREKLADU)
	(cat poradi-kapitol.lst 2>/dev/null || cat poradi-kapitol.vychozi.lst 2>/dev/null || printf %s\\n "# Seznam kapitol a dodatků k vygenerování" "predmluva" "" "# Kapitoly" $(strip $(sort $(VSECHNY_KAPITOLY))) "" "# Dodatky" $(strip $(sort $(filter-out predmluva,$(VSECHNY_DODATKY))))) | $(AWK) -f skripty/extrakce/fragmenty.awk 3>$(SOUBORY_PREKLADU)/fragmenty.tsv 4>$(SOUBORY_PREKLADU)/stitky.tsv

$(SOUBORY_PREKLADU)/stitky.tsv: $(SOUBORY_PREKLADU)/fragmenty.tsv

# 2. soubory_prekladu/fragmenty.tsv + *.md => soubory_prekladu/osnova/*.tsv
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv): $(SOUBORY_PREKLADU)/osnova/%.tsv: kapitoly/%.md $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/extrakce/osnova.awk
	mkdir -pv $(SOUBORY_PREKLADU)/osnova
	$(AWK) -f skripty/extrakce/osnova.awk -v IDKAPITOLY=$(<:kapitoly/%.md=%) $< >$@

$(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv): $(SOUBORY_PREKLADU)/osnova/%.tsv: dodatky/%.md $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/extrakce/osnova.awk
	mkdir -pv $(SOUBORY_PREKLADU)/osnova
	$(AWK) -f skripty/extrakce/osnova.awk -v IDKAPITOLY=$(<:dodatky/%.md=%) $< >$@

# 3. soubory_prekladu/postprocess.dat
# ============================================================================
$(SOUBORY_PREKLADU)/postprocess.dat: $(wildcard postprocess.dat)
	-test -r postprocess.dat && cat postprocess.dat >"$@"
	touch "$@"

# 4. soubory_prekladu/datum-*.txt
# ============================================================================
$(DATUM_SESTAVENI_SOUBOR):
	$(RM) -v $(SOUBORY_PREKLADU)/datum-*.txt
	printf $(DATUM_SESTAVENI)\\n >"$@"

# HTML:

# 1A. kapitoly/{kapitola}.md => soubory_prekladu/html/{kapitola}
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/html/%): \
  $(SOUBORY_PREKLADU)/html/%: \
  kapitoly/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/preklad/do_html.awk skripty/preklad/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -v FRAGMENTY_TSV=$(SOUBORY_PREKLADU)/fragmenty.tsv -f skripty/preklad/do_html.awk $< > $@

# 1B. dodatky/{dodatek}.md => soubory_prekladu/html/{dodatek}
# ============================================================================
$(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/html/%): \
  $(SOUBORY_PREKLADU)/html/%: \
  dodatky/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/preklad/do_html.awk skripty/preklad/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -v FRAGMENTY_TSV=$(SOUBORY_PREKLADU)/fragmenty.tsv -f skripty/preklad/do_html.awk $< > $@

# 2. soubory_prekladu/html/{id} => vystup_prekladu/html/{id}.htm
# ============================================================================
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(VYSTUP_PREKLADU)/html/%.htm): \
  $(VYSTUP_PREKLADU)/%.htm: \
  $(SOUBORY_PREKLADU)/% skripty/plneni-sablon/kapitola.awk formaty/html/sablona.htm $(SOUBORY_PREKLADU)/fragmenty.tsv $(DATUM_SESTAVENI_SOUBOR)
	mkdir -pv $(VYSTUP_PREKLADU)/html
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | fgrep -qx $(basename $(notdir $<)) && exec $(AWK) -f skripty/plneni-sablon/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDKAPITOLY=$(basename $(notdir $@)) -v TELOKAPITOLY=$< -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v VARIANTA=kapitola formaty/html/sablona.htm > $@ || true

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
  skripty/plneni-sablon/index-html.awk \
  formaty/html/sablona.htm \
  $(addsuffix .htm,$(addprefix $(VYSTUP_PREKLADU)/html/,$(VSECHNY_KAPITOLY) $(VSECHNY_DODATKY)))   $(SOUBORY_PREKLADU)/fragmenty.tsv \
  $(OBRAZKY:%=$(VYSTUP_PREKLADU)/html/obrazky/%) \
  $(SVG_OBRAZKY:%=$(VYSTUP_PREKLADU)/html/obrazky/%) \
  $(DATUM_SESTAVENI_SOUBOR)
	$(AWK) -f skripty/plneni-sablon/index-html.awk -v JMENOVERZE='$(JMENO)' -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v VARIANTA=index $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/html/sablona.htm > $@

# 6. sepsat copyrighty ke kapitolám
# ============================================================================
$(SOUBORY_PREKLADU)/html/kap-copys.htm: $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/extrakce/copyrighty.awk $(VSECHNY_DODATKY:%=dodatky/%.md) $(VSECHNY_KAPITOLY:%=kapitoly/%.md)
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -f skripty/extrakce/copyrighty.awk $(shell cut -f 1,2 --output-delimiter=/ $< | sed 's/$$/.md/') >$@

# 7. sepsat copyrighty k obrázkům
# ============================================================================
$(SOUBORY_PREKLADU)/html/obr-copys.htm: COPYING skripty/extrakce/copykobr.awk
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/extrakce/copykobr.awk $< $(OBRAZKY:%=obrazky/%) $(SVG_OBRAZKY:%=obrazky/%) >$@

# 8. shromáždit copyrighty na stránku x-autori.htm
# ============================================================================
$(VYSTUP_PREKLADU)/html/x-autori.htm: \
  $(addprefix $(SOUBORY_PREKLADU)/html/, kap-copys.htm obr-copys.htm) \
  skripty/plneni-sablon/kapitola.awk \
  formaty/html/sablona.htm \
  $(DATUM_SESTAVENI_SOUBOR)
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/plneni-sablon/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDKAPITOLY=_autori -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v COPYRIGHTY_KAPITOL=$(SOUBORY_PREKLADU)/html/kap-copys.htm -v COPYRIGHTY_OBRAZKU=$(SOUBORY_PREKLADU)/html/obr-copys.htm -v VARIANTA=autori formaty/html/sablona.htm > $@

# 9. shromáždit štítky na stránku x-stitky.htm
# ============================================================================
$(VYSTUP_PREKLADU)/html/x-stitky.htm: \
  skripty/plneni-sablon/kapitola.awk \
  formaty/html/sablona.htm \
  $(SOUBORY_PREKLADU)/fragmenty.tsv \
  $(DATUM_SESTAVENI_SOUBOR)
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/plneni-sablon/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDKAPITOLY=_stitky -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v FRAGMENTY_TSV=$(SOUBORY_PREKLADU)/fragmenty.tsv -v IDFORMATU=html -v VARIANTA=stitky formaty/html/sablona.htm >$@

# LOG:

# 1A. kapitoly/{kapitola}.md => soubory_prekladu/log/{kapitola}
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/log/%): \
  $(SOUBORY_PREKLADU)/log/%: \
  kapitoly/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/preklad/do_logu.awk skripty/preklad/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -v FRAGMENTY_TSV=$(SOUBORY_PREKLADU)/fragmenty.tsv -f skripty/preklad/do_logu.awk $< > $@

# 1B. dodatky/{dodatek}.md => soubory_prekladu/log/{dodatek}
# ============================================================================
$(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/log/%): \
  $(SOUBORY_PREKLADU)/log/%: \
  dodatky/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/preklad/do_logu.awk skripty/preklad/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -v FRAGMENTY_TSV=$(SOUBORY_PREKLADU)/fragmenty.tsv -f skripty/preklad/do_logu.awk $< > $@

# 2. soubory_prekladu/log/{id} => soubory_prekladu/log/{id}.kap
# ============================================================================
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/log/%.kap): \
  %.kap: \
  % skripty/plneni-sablon/kapitola.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/log/sablona $(DATUM_SESTAVENI_SOUBOR)
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -f skripty/plneni-sablon/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDKAPITOLY=$(basename $(notdir $@)) -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v TELOKAPITOLY=$< formaty/log/sablona > $@

# 3. soubory_prekladu/log/{id}.kap => vystup_prekladu/log/{id}.log
# ============================================================================
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(VYSTUP_PREKLADU)/log/%.log): \
  $(VYSTUP_PREKLADU)/log/%.log: \
  $(SOUBORY_PREKLADU)/log/%.kap
	mkdir -pv $(VYSTUP_PREKLADU)/log
	cat $< > $@

# 4. soubory_prekladu/log/{id}.kap => vystup_prekladu/log/index.log
# ============================================================================
$(VYSTUP_PREKLADU)/log/index.log: \
  $(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/log/%.kap) \
  $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(VYSTUP_PREKLADU)/log
	cd $(SOUBORY_PREKLADU)/log; cut -f 2 ../fragmenty.tsv | sed -E 's/$$/.kap/' | xargs -r fgrep --color=always -Hn '' >../../$@ || true

# PDF (společná část):

# 1A. kapitoly/{kapitola}.md => soubory_prekladu/pdf-spolecne/{kapitola}
# ============================================================================
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%): \
  $(SOUBORY_PREKLADU)/pdf-spolecne/%: \
  kapitoly/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/preklad/do_latexu.awk skripty/preklad/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	$(AWK) -v FRAGMENTY_TSV=$(SOUBORY_PREKLADU)/fragmenty.tsv -f skripty/preklad/do_latexu.awk $< > $@

# 1B. dodatky/{dodatek}.md => soubory_prekladu/pdf-spolecne/{dodatek}
# ============================================================================
$(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%): \
  $(SOUBORY_PREKLADU)/pdf-spolecne/%: \
  dodatky/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/preklad/do_latexu.awk skripty/preklad/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	$(AWK) -v FRAGMENTY_TSV=$(SOUBORY_PREKLADU)/fragmenty.tsv -f skripty/preklad/do_latexu.awk $< > $@

# 2. soubory_prekladu/pdf-spolecne/{id} => soubory_prekladu/pdf-spolecne/{id}.kap
# ============================================================================
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%.kap): \
  %.kap: \
  %
	cat $< >$@
	#$(AWK) -f skripty/plneni-sablon/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDKAPITOLY=$(basename $(notdir $@)) -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v TELOKAPITOLY=$< formaty/pdf/sablona.tex > $@

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


# PDF A4:

# 4. soubory_prekladu/pdf-spolecne/{id}.kap => soubory_prekladu/pdf-a4/{id}.kap
# ============================================================================
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-a4/%.kap): \
  $(SOUBORY_PREKLADU)/pdf-a4/%.kap: \
  $(SOUBORY_PREKLADU)/pdf-spolecne/%.kap $(SOUBORY_PREKLADU)/postprocess.dat skripty/postprocess.awk skripty/utility.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-a4 -f skripty/postprocess.awk $(SOUBORY_PREKLADU)/postprocess.dat $< 2>&1 >$@

# 5. soubory_prekladu/pdf-a4/{id}.kap => soubory_prekladu/pdf-a4/_all.kap
# ============================================================================
$(SOUBORY_PREKLADU)/pdf-a4/_all.kap: $(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-a4/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | sed 's/.*/$(SOUBORY_PREKLADU)\/pdf-a4\/&.kap/' | xargs -r cat >$@

# 6. soubory_prekladu/pdf-a4/_all.kap => soubory_prekladu/pdf-a4/kniha.tex
# ============================================================================
$(SOUBORY_PREKLADU)/pdf-a4/kniha.tex: $(SOUBORY_PREKLADU)/pdf-a4/_all.kap formaty/pdf/sablona.tex
	$(AWK) -f skripty/plneni-sablon/specialni.awk -v IDFORMATU=pdf-a4 -v JMENOVERZE='$(JMENO)' -v TELO=$< formaty/pdf/sablona.tex >$@

# 7. soubory_prekladu/pdf-a4/kniha.tex => vystup_prekladu/pdf-a4.pdf
# ============================================================================
$(VYSTUP_PREKLADU)/pdf-a4.pdf: $(SOUBORY_PREKLADU)/pdf-a4/kniha.tex $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%) $(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%.pdf)
	mkdir -pv $(dir $@)
	ln -rsTv skripty $(dir $<)skripty 2>/dev/null || true
	cd $(dir $<); exec $(AWK) -f skripty/latex.awk
	cat $(<:%.tex=%.pdf) > $@

# PDF B5:
# 4. soubory_prekladu/pdf-spolecne/{id}.kap => soubory_prekladu/pdf-b5/{id}.kap
# ============================================================================
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-b5/%.kap): \
  $(SOUBORY_PREKLADU)/pdf-b5/%.kap: \
  $(SOUBORY_PREKLADU)/pdf-spolecne/%.kap $(SOUBORY_PREKLADU)/postprocess.dat skripty/postprocess.awk skripty/utility.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-b5 -f skripty/postprocess.awk $(SOUBORY_PREKLADU)/postprocess.dat $< 2>&1 >$@

# 5. soubory_prekladu/pdf-b5/{id}.kap => soubory_prekladu/pdf-b5/_all.kap
# ============================================================================
$(SOUBORY_PREKLADU)/pdf-b5/_all.kap: $(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-b5/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | sed 's/.*/$(SOUBORY_PREKLADU)\/pdf-b5\/&.kap/' | xargs -r cat >$@

# 6. soubory_prekladu/pdf-b5/_all.kap => soubory_prekladu/pdf-b5/kniha.tex
# ============================================================================
$(SOUBORY_PREKLADU)/pdf-b5/kniha.tex: $(SOUBORY_PREKLADU)/pdf-b5/_all.kap formaty/pdf/sablona.tex
	$(AWK) -f skripty/plneni-sablon/specialni.awk -v IDFORMATU=pdf-b5 -v JMENOVERZE='$(JMENO)' -v TELO=$< formaty/pdf/sablona.tex >$@

# 7. soubory_prekladu/pdf-b5/kniha.tex => vystup_prekladu/pdf-b5.pdf
# ============================================================================
$(VYSTUP_PREKLADU)/pdf-b5.pdf: $(SOUBORY_PREKLADU)/pdf-b5/kniha.tex $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%) $(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%.pdf)
	mkdir -pv $(dir $@)
	ln -rsTv skripty $(dir $<)skripty 2>/dev/null || true
	cd $(dir $<); exec $(AWK) -f skripty/latex.awk
	cat $(<:%.tex=%.pdf) > $@


# Pomocné funkce a skripty:
$(VYSTUP_PREKLADU)/bin/pomocne-funkce.sh: $(VSECHNY_KAPITOLY:%=kapitoly/%.md) $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/extrakce/pomocne-funkce.awk skripty/utility.awk
	mkdir -pv $(VYSTUP_PREKLADU)/bin
	$(AWK) -f skripty/extrakce/pomocne-funkce.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
