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
CONVERT := convert

# Dodatky a kapitoly
# ----------------------------------------------------------------------------
VSECHNY_DODATKY := predmluva koncepce-projektu plan-vyvoje test zakladni-znalosti licence

# _ A, B, C, D, E, F, G
VSECHNY_KAPITOLY := _ostatni _ukazka apache awk barvy-a-titulek bash css datum-cas-kalendar diskove-oddily docker dosbox firefox git grub
# H, I, J, K, L, M
VSECHNY_KAPITOLY += hledani-souboru konverze-formatu latex lkk make markdown moderni-veci
# N, O, P, Q, R, S
VSECHNY_KAPITOLY += odkazy perl planovani-uloh prace-s-archivy promenne regularni-vyrazy
# S
VSECHNY_KAPITOLY += sed soubory-a-adresare sprava-balicku sprava-balicku-2 sprava-procesu sprava-uzivatelu stahovani-videi system
# T, U, V, W, X, Y, Z
VSECHNY_KAPITOLY += unicode uzivatelska-rozhrani wine x
# Z
VSECHNY_KAPITOLY += zpracovani-binarnich-souboru zpracovani-obrazku zpracovani-textovych-souboru zpracovani-videa-a-zvuku

VSECHNY_KAPITOLY_A_DODATKY = $(VSECHNY_KAPITOLY) $(VSECHNY_DODATKY)
VSECHNY_KAPITOLY_A_DODATKY_MD = $(VSECHNY_KAPITOLY:%=kapitoly/%.md) $(VSECHNY_DODATKY:%=dodatky/%.md)

# Obrázky (bitmapové a SVG)
# ----------------------------------------------------------------------------
OBRAZKY := favicon.png by-sa.png logo-knihy-velke.png make.png barvy.png ve-vystavbe.png marsh.jpg udoli.jpg banner.png
OBRAZKY += ik-vychozi.png
SVG_OBRAZKY := kalendar.svg graf-filtru.svg
OBRAZKY_IK := awk.png barvy-a-titulek.png datum-cas-kalendar.png diskove-oddily.png docker.png git.png hledani-souboru.png
OBRAZKY_IK += make.png markdown.png planovani-uloh.png prace-s-archivy.png regularni-vyrazy.png sed.png soubory-a-adresare.png sprava-balicku.png sprava-procesu.png stahovani-videi.png system.png
OBRAZKY_IK += zpracovani-textovych-souboru.png zpracovani-videa-a-zvuku.png
OBRAZKY_IK += predmluva.png koncepce-projektu.png

# CSS motivy (vedle motivu „hlavní“)
# ----------------------------------------------------------------------------
CSS_MOTIVY := vk-svetly vk-tmavy tmavy

# Datum sestavení (automaticky generované)
# ----------------------------------------------------------------------------
DATUM_SESTAVENI := $(shell date +%Y%m%d)

# Další nastavení
# ----------------------------------------------------------------------------
SOUBORY_PREKLADU := soubory_prekladu
VYSTUP_PREKLADU := vystup_prekladu

# Jméno sestavení (doporučuji nastavovat z příkazového řádku)
# ----------------------------------------------------------------------------
JMENO := Sid $(DATUM_SESTAVENI)

# Verze .deb-balíčku (automaticky generovaná, ale je dovoleno ji nastavit ručně)
# ----------------------------------------------------------------------------
DEB_VERZE := $(shell gawk -f skripty/extrakce/debverze.awk -- "$(JMENO)")

# Soubory symbolizující nastavení (automaticky generované)
# ----------------------------------------------------------------------------
DATUM_SESTAVENI_SOUBOR := $(SOUBORY_PREKLADU)/symboly/datum-sestaveni/$(DATUM_SESTAVENI)
DEB_VERZE_SOUBOR := $(SOUBORY_PREKLADU)/symboly/deb-verze/$(DEB_VERZE)
JMENO_SESTAVENI_SOUBOR := $(SOUBORY_PREKLADU)/symboly/jmeno-sestaveni/$(shell printf %s "$(JMENO)" | tr "/ \\n\\t" -)

.PHONY: all clean html log pdf-a4 pdf-a4-bez pdf-b5 pdf-b5-bez pdf-b5-na-a4 info
.DELETE_ON_ERROR: # Speciální cíl, který nastavuje „make“, aby v případě selhání pravidla byl odstraněn jeho cíl.

all: deb html log pdf-a4 pdf-a4-bez pdf-b5 pdf-b5-bez pdf-b5-na-a4

clean:
	$(RM) -Rv $(SOUBORY_PREKLADU) $(VYSTUP_PREKLADU)

info: $(DATUM_SESTAVENI_SOUBOR) $(DEB_VERZE_SOUBOR) $(JMENO_SESTAVENI_SOUBOR)
	@printf %s\\n "Jméno buildu: <$(JMENO)>" "DEB verze: <$(DEB_VERZE)>" "Datum sestavení: <$(DATUM_SESTAVENI)>" "Datum sestavení soubor: <$(DATUM_SESTAVENI_SOUBOR)>" "Deb verze soubor: <$(DEB_VERZE_SOUBOR)>" "Jméno sestavení soubor: <$(JMENO_SESTAVENI_SOUBOR)>" ""

# Podporované formáty:
deb: $(VYSTUP_PREKLADU)/lkk_$(DEB_VERZE)_all.deb
html: $(addprefix $(VYSTUP_PREKLADU)/html/, lkk-$(DATUM_SESTAVENI).css $(CSS_MOTIVY:%=lkk-$(DATUM_SESTAVENI)-%.css) index.htm x-autori.htm x-stitky.htm)
log: $(VYSTUP_PREKLADU)/log/index.log
pdf-a4: $(VYSTUP_PREKLADU)/pdf-a4.pdf
pdf-a4-bez: $(VYSTUP_PREKLADU)/pdf-a4-bez.pdf
pdf-b5: $(VYSTUP_PREKLADU)/pdf-b5.pdf
pdf-b5-bez: $(VYSTUP_PREKLADU)/pdf-b5-bez.pdf
pdf-b5-na-a4: $(VYSTUP_PREKLADU)/pdf-b5-na-a4.pdf

$(DATUM_SESTAVENI_SOUBOR):
	mkdir -pv $(dir $(DATUM_SESTAVENI_SOUBOR))
	$(RM) $(dir $(DATUM_SESTAVENI_SOUBOR))*
	touch "$(DATUM_SESTAVENI_SOUBOR)"

$(DEB_VERZE_SOUBOR):
	mkdir -pv $(dir $(DEB_VERZE_SOUBOR))
	$(RM) $(dir $(DEB_VERZE_SOUBOR))*
	touch "$(DEB_VERZE_SOUBOR)"

$(JMENO_SESTAVENI_SOUBOR):
	mkdir -pv $(dir $(JMENO_SESTAVENI_SOUBOR))
	$(RM) $(dir $(JMENO_SESTAVENI_SOUBOR))*
	touch "$(JMENO_SESTAVENI_SOUBOR)"

# POMOCNÉ SOUBORY:
# ============================================================================

# 1. soubory_prekladu/fragmenty.tsv + soubory_prekladu/stitky.tsv
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/fragmenty.tsv: $(wildcard poradi-kapitol.lst poradi-kapitol.vychozi.lst) \
  skripty/extrakce/fragmenty.awk \
  $(VSECHNY_KAPITOLY_A_DODATKY_MD) \
  $(SOUBORY_PREKLADU)/ucs_ikony.dat
	mkdir -pv $(SOUBORY_PREKLADU)
	(cat poradi-kapitol.lst 2>/dev/null || cat poradi-kapitol.vychozi.lst 2>/dev/null || printf %s\\n "# Seznam kapitol a dodatků k vygenerování" "predmluva" "" "# Kapitoly" $(strip $(sort $(VSECHNY_KAPITOLY))) "" "# Dodatky" $(strip $(sort $(filter-out predmluva,$(VSECHNY_DODATKY))))) | $(AWK) -f skripty/extrakce/fragmenty.awk 3>$(SOUBORY_PREKLADU)/fragmenty.tsv 4>$(SOUBORY_PREKLADU)/stitky.tsv

$(SOUBORY_PREKLADU)/stitky.tsv: $(SOUBORY_PREKLADU)/fragmenty.tsv

# 2. soubory_prekladu/fragmenty.tsv + *.md => soubory_prekladu/osnova/*.tsv
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv): $(SOUBORY_PREKLADU)/osnova/%.tsv: kapitoly/%.md $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/extrakce/osnova.awk
	mkdir -pv $(SOUBORY_PREKLADU)/osnova
	$(AWK) -f skripty/extrakce/osnova.awk -v IDKAPITOLY=$(<:kapitoly/%.md=%) $< >$@

$(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv): $(SOUBORY_PREKLADU)/osnova/%.tsv: dodatky/%.md $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/extrakce/osnova.awk
	mkdir -pv $(SOUBORY_PREKLADU)/osnova
	$(AWK) -f skripty/extrakce/osnova.awk -v IDKAPITOLY=$(<:dodatky/%.md=%) $< >$@

# 3. soubory_prekladu/postprocess.dat
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/postprocess.dat: $(wildcard postprocess.dat)
	-test -r postprocess.dat && cat postprocess.dat >"$@"
	touch "$@"

# 4. soubory_prekladu/ucs_ikony.dat
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/ucs_ikony.dat: ucs_ikony/ikony.txt skripty/extrakce/ikony-zaklinadel.awk
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/extrakce/ikony-zaklinadel.awk

# 5. soubory_prekladu/qr.svg
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/qr.svg:
	printf 'https://singularis-mzf.github.io' | qrencode -o "$@" -t svg -s 8

# HTML:
# ============================================================================

# 1A. kapitoly/{kapitola}.md => soubory_prekladu/html/{kapitola}
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/html/%): \
  $(SOUBORY_PREKLADU)/html/%: \
  kapitoly/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/preklad/do_html.awk skripty/preklad/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -v FRAGMENTY_TSV=$(SOUBORY_PREKLADU)/fragmenty.tsv -f skripty/preklad/do_html.awk $< > $@

# 1B. dodatky/{dodatek}.md => soubory_prekladu/html/{dodatek}
# ----------------------------------------------------------------------------
$(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/html/%): \
  $(SOUBORY_PREKLADU)/html/%: \
  dodatky/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/preklad/do_html.awk skripty/preklad/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -v FRAGMENTY_TSV=$(SOUBORY_PREKLADU)/fragmenty.tsv -f skripty/preklad/do_html.awk $< > $@

# 2. soubory_prekladu/html/{id} => vystup_prekladu/html/{id}.htm
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(VYSTUP_PREKLADU)/html/%.htm): \
  $(VYSTUP_PREKLADU)/%.htm: \
  $(SOUBORY_PREKLADU)/% skripty/plneni-sablon/kapitola.awk skripty/plneni-sablon/hlavni.awk formaty/html/sablona.htm $(SOUBORY_PREKLADU)/fragmenty.tsv $(DATUM_SESTAVENI_SOUBOR)
	mkdir -pv $(VYSTUP_PREKLADU)/html
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | fgrep -qx $(basename $(notdir $<)) && exec $(AWK) -f skripty/plneni-sablon/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDFORMATU=html -v IDKAPITOLY=$(basename $(notdir $@)) -v TELOKAPITOLY=$< -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v VARIANTA=kapitola formaty/html/sablona.htm > $@ || true

# 3. formaty/html/sablona.css => vystup_prekladu/html/lkk.css
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/html/lkk-$(DATUM_SESTAVENI).css: formaty/html/sablona.css skripty/plneni-sablon/css.awk skripty/plneni-sablon/css2.awk
	mkdir -pv $(dir $@)
	$(RM) $(VYSTUP_PREKLADU)/html/lkk-????????.css
	set -o pipefail; $(AWK) -v IDFORMATU=html -v MOTIV=hlavni -f skripty/plneni-sablon/css.awk $< | $(AWK) -f skripty/plneni-sablon/css2.awk > $@

$(CSS_MOTIVY:%=$(VYSTUP_PREKLADU)/html/lkk-$(DATUM_SESTAVENI)-%.css): %: formaty/html/sablona.css skripty/plneni-sablon/css.awk skripty/plneni-sablon/css2.awk
	mkdir -pv $(dir $@)
	$(RM) $(@:$(VYSTUP_PREKLADU)/html/lkk-$(DATUM_SESTAVENI)%=$(VYSTUP_PREKLADU)/html/lkk-????????%)
	set -o pipefail; $(AWK) -v IDFORMATU=html -v MOTIV=$(strip $(patsubst lkk-$(DATUM_SESTAVENI)-%.css, %, $(notdir $@))) -f skripty/plneni-sablon/css.awk $< | $(AWK) -f skripty/plneni-sablon/css2.awk > $@

# 4. obrazky/{obrazek} => vystup_prekladu/html/obrazky/{obrazek}
# ----------------------------------------------------------------------------
$(OBRAZKY:%=$(VYSTUP_PREKLADU)/html/obrazky/%) $(OBRAZKY_IK:%=$(VYSTUP_PREKLADU)/html/obrazky/ik/%): $(VYSTUP_PREKLADU)/html/obrazky/%: obrazky/%
	mkdir -pv $(dir $@)
	$(CONVERT) $< $@

$(SVG_OBRAZKY:%=$(VYSTUP_PREKLADU)/html/obrazky/%): $(VYSTUP_PREKLADU)/html/obrazky/%: obrazky/%
	mkdir -pv $(dir $@)
	cp $< $@

$(VYSTUP_PREKLADU)/html/obrazky/qr.svg: $(SOUBORY_PREKLADU)/qr.svg
	mkdir -pv $(dir $@)
	cp $< $@

# 5. vystup_prekladu/html/{id}.htm => vystup_prekladu/html/index.htm
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/html/index.htm: $(SOUBORY_PREKLADU)/fragmenty.tsv \
  skripty/plneni-sablon/index-html.awk \
  formaty/html/sablona.htm \
  $(addsuffix .htm,$(addprefix $(VYSTUP_PREKLADU)/html/,$(VSECHNY_KAPITOLY) $(VSECHNY_DODATKY)))   $(SOUBORY_PREKLADU)/fragmenty.tsv \
  $(OBRAZKY:%=$(VYSTUP_PREKLADU)/html/obrazky/%) \
  $(OBRAZKY_IK:%=$(VYSTUP_PREKLADU)/html/obrazky/ik/%) \
  $(SVG_OBRAZKY:%=$(VYSTUP_PREKLADU)/html/obrazky/%) \
  $(VYSTUP_PREKLADU)/html/obrazky/qr.svg \
  $(DATUM_SESTAVENI_SOUBOR)
	$(AWK) -f skripty/plneni-sablon/index-html.awk -v JMENOVERZE='$(JMENO)' -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v IDFORMATU=html -v VARIANTA=index $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/html/sablona.htm > $@

# 6. sepsat copyrighty ke kapitolám
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/html/kap-copys.htm: $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/extrakce/copyrighty.awk $(VSECHNY_DODATKY:%=dodatky/%.md) $(VSECHNY_KAPITOLY:%=kapitoly/%.md)
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -f skripty/extrakce/copyrighty.awk $(shell cut -f 1,2 --output-delimiter=/ $< | sed 's/$$/.md/') >$@

# 7. sepsat copyrighty k obrázkům
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/html/obr-copys.htm: COPYRIGHT skripty/extrakce/copykobr.awk
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/extrakce/copykobr.awk $< $(OBRAZKY:%=obrazky/%) $(SVG_OBRAZKY:%=obrazky/%) >$@

# 8. shromáždit copyrighty na stránku x-autori.htm
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/html/x-autori.htm: \
  $(addprefix $(SOUBORY_PREKLADU)/html/, kap-copys.htm obr-copys.htm) \
  skripty/plneni-sablon/kapitola.awk skripty/plneni-sablon/hlavni.awk \
  formaty/html/sablona.htm \
  $(DATUM_SESTAVENI_SOUBOR)
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/plneni-sablon/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDFORMATU=html -v IDKAPITOLY=_autori -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v COPYRIGHTY_KAPITOL=$(SOUBORY_PREKLADU)/html/kap-copys.htm -v COPYRIGHTY_OBRAZKU=$(SOUBORY_PREKLADU)/html/obr-copys.htm -v VARIANTA=autori formaty/html/sablona.htm > $@

# 9. shromáždit štítky na stránku x-stitky.htm
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/html/x-stitky.htm: \
  skripty/plneni-sablon/kapitola.awk skripty/plneni-sablon/hlavni.awk \
  formaty/html/sablona.htm \
  $(SOUBORY_PREKLADU)/fragmenty.tsv \
  $(DATUM_SESTAVENI_SOUBOR)
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/plneni-sablon/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDFORMATU=html -v IDKAPITOLY=_stitky -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v FRAGMENTY_TSV=$(SOUBORY_PREKLADU)/fragmenty.tsv -v IDFORMATU=html -v VARIANTA=stitky formaty/html/sablona.htm >$@

# LOG:
# ============================================================================

# 1A. kapitoly/{kapitola}.md => soubory_prekladu/log/{kapitola}
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/log/%): \
  $(SOUBORY_PREKLADU)/log/%: \
  kapitoly/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/preklad/do_logu.awk skripty/preklad/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -v FRAGMENTY_TSV=$(SOUBORY_PREKLADU)/fragmenty.tsv -f skripty/preklad/do_logu.awk $< > $@

# 1B. dodatky/{dodatek}.md => soubory_prekladu/log/{dodatek}
# ----------------------------------------------------------------------------
$(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/log/%): \
  $(SOUBORY_PREKLADU)/log/%: \
  dodatky/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/preklad/do_logu.awk skripty/preklad/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -v FRAGMENTY_TSV=$(SOUBORY_PREKLADU)/fragmenty.tsv -f skripty/preklad/do_logu.awk $< > $@

# 2. soubory_prekladu/log/{id} => soubory_prekladu/log/{id}.kap
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/log/%.kap): \
  %.kap: \
  % skripty/plneni-sablon/kapitola.awk skripty/plneni-sablon/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv formaty/log/sablona $(DATUM_SESTAVENI_SOUBOR)
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -f skripty/plneni-sablon/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDFORMATU=log -v IDKAPITOLY=$(basename $(notdir $@)) -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v TELOKAPITOLY=$< formaty/log/sablona > $@

# 3. soubory_prekladu/log/{id}.kap => vystup_prekladu/log/{id}.log
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(VYSTUP_PREKLADU)/log/%.log): \
  $(VYSTUP_PREKLADU)/log/%.log: \
  $(SOUBORY_PREKLADU)/log/%.kap
	mkdir -pv $(VYSTUP_PREKLADU)/log
	cat $< > $@

# 4. soubory_prekladu/log/{id}.kap => vystup_prekladu/log/index.log
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/log/index.log: \
  $(VSECHNY_KAPITOLY_A_DODATKY:%=$(VYSTUP_PREKLADU)/log/%.log) \
  $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(VYSTUP_PREKLADU)/log
	cd $(SOUBORY_PREKLADU)/log; cut -f 2 ../fragmenty.tsv | sed -E 's/$$/.kap/' | xargs -r fgrep --color=always -Hn '' >../../$@ || true

# PDF (společná část):
# ============================================================================

# 1A. kapitoly/{kapitola}.md => soubory_prekladu/pdf-spolecne/{kapitola}
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%): \
  $(SOUBORY_PREKLADU)/pdf-spolecne/%: \
  kapitoly/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/preklad/do_latexu.awk skripty/preklad/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	$(AWK) -v FRAGMENTY_TSV=$(SOUBORY_PREKLADU)/fragmenty.tsv -f skripty/preklad/do_latexu.awk $< > $@

# 1B. dodatky/{dodatek}.md => soubory_prekladu/pdf-spolecne/{dodatek}
# ----------------------------------------------------------------------------
$(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%): \
  $(SOUBORY_PREKLADU)/pdf-spolecne/%: \
  dodatky/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/preklad/do_latexu.awk skripty/preklad/hlavni.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	$(AWK) -v FRAGMENTY_TSV=$(SOUBORY_PREKLADU)/fragmenty.tsv -f skripty/preklad/do_latexu.awk $< > $@

# 2. soubory_prekladu/pdf-spolecne/{id} => soubory_prekladu/pdf-spolecne/{id}.kap
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/%.kap): \
  %.kap: \
  %
	cat $< >$@
	#$(AWK) -f skripty/plneni-sablon/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDKAPITOLY=$(basename $(notdir $@)) -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v TELOKAPITOLY=$< formaty/pdf/sablona.tex > $@

# 3. obrazky/{obrazek} => soubory_prekladu/pdf-spolecne/_obrazky/{obrazek}
# ----------------------------------------------------------------------------
$(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%) $(OBRAZKY_IK:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/ik/%): $(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%: obrazky/% konfig.ini
	mkdir -pv $(dir $@)
	$(CONVERT) $< $(shell bash -e skripty/precist_konfig.sh "Filtry" "$(@:$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%=../obrazky/%)" "-colorspace Gray" < konfig.ini) $@

$(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%.pdf): $(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%.pdf: obrazky/%.svg
	mkdir -pv $(dir $@)
#	inkscape --without-gui "--file=$<" "--export-pdf=$@"
#	z balíčku „librsvg2-bin“:
	rsvg-convert -f pdf -o "$@" "$<"


# PDF A4:
# ============================================================================

# 4. soubory_prekladu/pdf-spolecne/{id}.kap => soubory_prekladu/pdf-a4/{id}.kap
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-a4/%.kap): \
  $(SOUBORY_PREKLADU)/pdf-a4/%.kap: \
  $(SOUBORY_PREKLADU)/pdf-spolecne/%.kap $(SOUBORY_PREKLADU)/postprocess.dat skripty/postprocess.awk skripty/utility.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-a4 -f skripty/postprocess.awk $(SOUBORY_PREKLADU)/postprocess.dat $< 2>&1 >$@

# 5. soubory_prekladu/pdf-a4/{id}.kap => soubory_prekladu/pdf-a4/_all.kap
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-a4/_all.kap: $(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-a4/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | sed 's/.*/$(SOUBORY_PREKLADU)\/pdf-a4\/&.kap/' | xargs -r cat >$@

# 6. soubory_prekladu/pdf-a4/_all.kap => soubory_prekladu/pdf-a4/kniha.tex
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-a4/kniha.tex: $(SOUBORY_PREKLADU)/pdf-a4/_all.kap formaty/pdf/sablona.tex
	$(AWK) -f skripty/plneni-sablon/specialni.awk -v IDFORMATU=pdf-a4 -v JMENOVERZE='$(JMENO)' -v TELO=$< formaty/pdf/sablona.tex >$@

# 7. soubory_prekladu/pdf-a4/kniha.tex => vystup_prekladu/pdf-a4.pdf
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/pdf-a4.pdf: \
  $(SOUBORY_PREKLADU)/pdf-a4/kniha.tex \
  $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%) \
  $(OBRAZKY_IK:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/ik/%) \
  $(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%.pdf)
	mkdir -pv $(dir $@)
	ln -rsTv skripty $(dir $<)skripty 2>/dev/null || true
	cd $(dir $<); exec $(AWK) -f skripty/latex.awk
	cat $(<:%.tex=%.pdf) > $@

# PDF A4 bez ořezových značek:
# ============================================================================

# 4. soubory_prekladu/pdf-spolecne/{id}.kap => soubory_prekladu/pdf-a4-bez/{id}.kap
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-a4-bez/%.kap): \
  $(SOUBORY_PREKLADU)/pdf-a4-bez/%.kap: \
  $(SOUBORY_PREKLADU)/pdf-spolecne/%.kap $(SOUBORY_PREKLADU)/postprocess.dat skripty/postprocess.awk skripty/utility.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-a4-bez -f skripty/postprocess.awk $(SOUBORY_PREKLADU)/postprocess.dat $< 2>&1 >$@

# 5. soubory_prekladu/pdf-a4-bez/{id}.kap => soubory_prekladu/pdf-a4-bez/_all.kap
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-a4-bez/_all.kap: $(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-a4-bez/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | sed 's/.*/$(SOUBORY_PREKLADU)\/pdf-a4-bez\/&.kap/' | xargs -r cat >$@

# 6. soubory_prekladu/pdf-a4-bez/_all.kap => soubory_prekladu/pdf-a4-bez/kniha.tex
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-a4-bez/kniha.tex: $(SOUBORY_PREKLADU)/pdf-a4-bez/_all.kap formaty/pdf/sablona.tex
	$(AWK) -f skripty/plneni-sablon/specialni.awk -v IDFORMATU=pdf-a4-bez -v JMENOVERZE='$(JMENO)' -v TELO=$< formaty/pdf/sablona.tex >$@

# 7. soubory_prekladu/pdf-a4-bez/kniha.tex => vystup_prekladu/pdf-a4-bez.pdf
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/pdf-a4-bez.pdf: \
  $(SOUBORY_PREKLADU)/pdf-a4-bez/kniha.tex \
  $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%) \
  $(OBRAZKY_IK:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/ik/%) \
  $(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%.pdf)
	mkdir -pv $(dir $@)
	ln -rsTv skripty $(dir $<)skripty 2>/dev/null || true
	cd $(dir $<); exec $(AWK) -f skripty/latex.awk
	cat $(<:%.tex=%.pdf) > $@

# PDF B5:
# ============================================================================

# 4. soubory_prekladu/pdf-spolecne/{id}.kap => soubory_prekladu/pdf-b5/{id}.kap
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-b5/%.kap): \
  $(SOUBORY_PREKLADU)/pdf-b5/%.kap: \
  $(SOUBORY_PREKLADU)/pdf-spolecne/%.kap $(SOUBORY_PREKLADU)/postprocess.dat skripty/postprocess.awk skripty/utility.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-b5 -f skripty/postprocess.awk $(SOUBORY_PREKLADU)/postprocess.dat $< 2>&1 >$@

# 5. soubory_prekladu/pdf-b5/{id}.kap => soubory_prekladu/pdf-b5/_all.kap
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5/_all.kap: $(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-b5/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | sed 's/.*/$(SOUBORY_PREKLADU)\/pdf-b5\/&.kap/' | xargs -r cat >$@

# 6. soubory_prekladu/pdf-b5/_all.kap => soubory_prekladu/pdf-b5/kniha.tex
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5/kniha.tex: $(SOUBORY_PREKLADU)/pdf-b5/_all.kap formaty/pdf/sablona.tex
	$(AWK) -f skripty/plneni-sablon/specialni.awk -v IDFORMATU=pdf-b5 -v JMENOVERZE='$(JMENO)' -v TELO=$< formaty/pdf/sablona.tex >$@

# 7. soubory_prekladu/pdf-b5/kniha.tex => vystup_prekladu/pdf-b5.pdf
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/pdf-b5.pdf: \
  $(SOUBORY_PREKLADU)/pdf-b5/kniha.tex \
  $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%) \
  $(OBRAZKY_IK:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/ik/%) \
  $(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%.pdf)
	mkdir -pv $(dir $@)
	ln -rsTv skripty $(dir $<)skripty 2>/dev/null || true
	cd $(dir $<); exec $(AWK) -f skripty/latex.awk
	cat $(<:%.tex=%.pdf) > $@

# PDF B5 bez ořezových značek:
# ============================================================================

# 4. soubory_prekladu/pdf-spolecne/{id}.kap => soubory_prekladu/pdf-b5-bez/{id}.kap
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-b5-bez/%.kap): \
  $(SOUBORY_PREKLADU)/pdf-b5-bez/%.kap: \
  $(SOUBORY_PREKLADU)/pdf-spolecne/%.kap $(SOUBORY_PREKLADU)/postprocess.dat skripty/postprocess.awk skripty/utility.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-b5-bez -f skripty/postprocess.awk $(SOUBORY_PREKLADU)/postprocess.dat $< 2>&1 >$@

# 5. soubory_prekladu/pdf-b5-bez/{id}.kap => soubory_prekladu/pdf-b5-bez/_all.kap
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5-bez/_all.kap: $(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-b5-bez/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | sed 's/.*/$(SOUBORY_PREKLADU)\/pdf-b5-bez\/&.kap/' | xargs -r cat >$@

# 6. soubory_prekladu/pdf-b5-bez/_all.kap => soubory_prekladu/pdf-b5-bez/kniha.tex
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5-bez/kniha.tex: $(SOUBORY_PREKLADU)/pdf-b5-bez/_all.kap formaty/pdf/sablona.tex
	$(AWK) -f skripty/plneni-sablon/specialni.awk -v IDFORMATU=pdf-b5-bez -v JMENOVERZE='$(JMENO)' -v TELO=$< formaty/pdf/sablona.tex >$@

# 7. soubory_prekladu/pdf-b5-bez/kniha.tex => vystup_prekladu/pdf-b5-bez.pdf
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/pdf-b5-bez.pdf: \
  $(SOUBORY_PREKLADU)/pdf-b5-bez/kniha.tex \
  $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%) \
  $(OBRAZKY_IK:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/ik/%) \
  $(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%.pdf)
	mkdir -pv $(dir $@)
	ln -rsTv skripty $(dir $<)skripty 2>/dev/null || true
	cd $(dir $<); exec $(AWK) -f skripty/latex.awk
	cat $(<:%.tex=%.pdf) > $@

# PDF B5 na A4:
# ============================================================================

# 4. soubory_prekladu/pdf-spolecne/{id}.kap => soubory_prekladu/pdf-b5-na-a4/{id}.kap
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-b5-na-a4/%.kap): \
  $(SOUBORY_PREKLADU)/pdf-b5-na-a4/%.kap: \
  $(SOUBORY_PREKLADU)/pdf-spolecne/%.kap $(SOUBORY_PREKLADU)/postprocess.dat skripty/postprocess.awk skripty/utility.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-b5-na-a4 -f skripty/postprocess.awk $(SOUBORY_PREKLADU)/postprocess.dat $< 2>&1 >$@

# 5. soubory_prekladu/pdf-b5-na-a4/{id}.kap => soubory_prekladu/pdf-b5-na-a4/_all.kap
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5-na-a4/_all.kap: $(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-b5-na-a4/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | sed 's/.*/$(SOUBORY_PREKLADU)\/pdf-b5-na-a4\/&.kap/' | xargs -r cat >$@

# 6. soubory_prekladu/pdf-b5-na-a4/_all.kap => soubory_prekladu/pdf-b5-na-a4/kniha.tex
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5-na-a4/kniha.tex: $(SOUBORY_PREKLADU)/pdf-b5-na-a4/_all.kap formaty/pdf/sablona.tex
	$(AWK) -f skripty/plneni-sablon/specialni.awk -v IDFORMATU=pdf-b5-na-a4 -v JMENOVERZE='$(JMENO)' -v TELO=$< formaty/pdf/sablona.tex >$@

# 7. soubory_prekladu/pdf-b5-na-a4/kniha.tex => vystup_prekladu/pdf-b5-na-a4.pdf
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/pdf-b5-na-a4.pdf: \
  $(SOUBORY_PREKLADU)/pdf-b5-na-a4/kniha.tex \
  $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%) \
  $(OBRAZKY_IK:%=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/ik/%) \
  $(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-spolecne/_obrazky/%.pdf)
	mkdir -pv $(dir $@)
	ln -rsTv skripty $(dir $<)skripty 2>/dev/null || true
	cd $(dir $<); exec $(AWK) -f skripty/latex.awk
	cat $(<:%.tex=%.pdf) > $@

# DEB:
# ============================================================================

# 1. skripty/lkk/lkk => soubory_prekladu/deb/usr/bin/lkk
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/deb/usr/bin/lkk: skripty/lkk/lkk
	mkdir -pv $(dir $@)
	cp --no-preserve=mode,timestamps -f $< $@
	chmod 755 $@

# 2. skripty/lkk/awkvolby.awk => soubory_prekladu/deb/usr/share/awkvolby.awk
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/deb/usr/share/lkk/awkvolby.awk: skripty/lkk/awkvolby.awk
	mkdir -pv $(dir $@)
	cat $< >$@

# 3. skripty/lkk/lkk.awk => soubory_prekladu/deb/usr/share/lkk/lkk.awk
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/deb/usr/share/lkk/lkk.awk: skripty/lkk/lkk.awk $(JMENO_SESTAVENI_SOUBOR)
	mkdir -pv $(dir $@)
	sed -E "s/\{\{JMÉNO VERZE\}\}/$(JMENO)/g" $< >$@

# 4. kapitoly/*.md => soubory_prekladu/deb/usr/share/lkk/skripty/*
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/deb/usr/share/lkk/skripty/pomocne-funkce: skripty/extrakce/pomocne-funkce.awk $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/utility.awk $(VSECHNY_KAPITOLY:%=kapitoly/%.md)
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/extrakce/pomocne-funkce.awk $(SOUBORY_PREKLADU)/fragmenty.tsv

# 5. COPYRIGHT-DEB => soubory_prekladu/deb/usr/share/doc/lkk/copyright
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/deb/usr/share/doc/lkk/copyright: COPYRIGHT-DEB
	mkdir -pv $(dir $@)
	cat $< >$@

# 6. formaty/deb/control => soubory_prekladu/deb/DEBIAN/control
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/deb/DEBIAN/control: formaty/deb/control $(DEB_VERZE_SOUBOR)
	mkdir -pv $(dir $@)
	sed -E -e "s/\\{Version\\}/$(DEB_VERZE)/g" -e "s/\\{Installed-Size\\}/$$(du -ks --exclude=DEBIAN $(SOUBORY_PREKLADU)/deb | cut -f 1 | tail -n 1)/g" $< >"$@"

# 7. skripty/lkk/bash-doplnovani.sh => soubory_prekladu/deb/usr/share/bash-completion/completions/lkk
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/deb/usr/share/bash-completion/completions/lkk: skripty/lkk/bash-doplnovani.sh
	mkdir -pv $(dir $@)
	cat $< >$@

# 8. soubory_prekladu/deb/** => soubory_prekladu/deb/DEBIAN/md5sums
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/deb/DEBIAN/md5sums: \
  $(SOUBORY_PREKLADU)/deb/usr/bin/lkk \
  $(SOUBORY_PREKLADU)/deb/usr/share/doc/lkk/copyright \
  $(SOUBORY_PREKLADU)/deb/usr/share/lkk/awkvolby.awk \
  $(SOUBORY_PREKLADU)/deb/usr/share/lkk/lkk.awk \
  $(SOUBORY_PREKLADU)/deb/usr/share/lkk/skripty/pomocne-funkce \
  $(SOUBORY_PREKLADU)/deb/usr/share/bash-completion/completions/lkk
	mkdir -pv $(dir $@)
	(cd $(SOUBORY_PREKLADU)/deb && exec find * -path DEBIAN -prune -o -type f -exec md5sum -- '{}' +) | LC_ALL=C sort -k 1.33b >$@

# 8. soubory_prekladu/deb/** => vystup_prekladu/lkk_{verze}_all.deb
# ----------------------------------------------------------------------------
# Poznámka: přes „md5sums“ závisí také na všech ostatních souborech v $(SOUBORY_PREKLADU)/deb mimo podadresář DEBIAN.
$(VYSTUP_PREKLADU)/lkk_$(DEB_VERZE)_all.deb: \
  $(SOUBORY_PREKLADU)/deb/DEBIAN/control \
  $(SOUBORY_PREKLADU)/deb/DEBIAN/md5sums
	mkdir -pv $(dir $@)
	chmod -R u+rw,go+r,go-w "$(SOUBORY_PREKLADU)/deb"
	dpkg-deb -b --root-owner-group "$(SOUBORY_PREKLADU)/deb" "$@"
