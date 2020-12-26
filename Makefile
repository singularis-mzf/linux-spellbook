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
SED := sed -E

# Dodatky a kapitoly
# ----------------------------------------------------------------------------
VSECHNY_DODATKY := předmluva koncepce-projektu plán-vývoje základní-znalosti licence

# _ A, B, C, D, E, F, G
VSECHNY_KAPITOLY := _ostatní _ukázka apache awk bash css datum-čas-kalendář diskové-oddíly docker dosbox firefox git grub
# H, I, J, K, L, M
VSECHNY_KAPITOLY += hledání-souborů kalkulace konverze-formatů latex lkk make markdown moderní-věci
# N, O, P, Q, R, S
VSECHNY_KAPITOLY += nabídka-aplikací odkazy pdf perl-moduly perl-standardní-knihovna perl-základy plánování-úloh práce-s-archivy proměnné regulární-výrazy
# S
VSECHNY_KAPITOLY += sed soubory-a-adresáře správa-balíčků správa-balíčků-2 správa-procesů správa-uživatelských-účtů stahování-videí stahování-z-webu systém šifrování
# T, U, V, W, X, Y, Z
VSECHNY_KAPITOLY += terminál unicode uživatelská-rozhraní vim virtualbox wine x
# Z
VSECHNY_KAPITOLY += zpracování-binárních-souborů zpracování-obrázků zpracování-psv zpracování-textových-souborů zpracování-videa-a-zvuku

VSECHNY_KAPITOLY_A_DODATKY := $(VSECHNY_DODATKY) $(VSECHNY_KAPITOLY)
VSECHNY_KAPITOLY_A_DODATKY_MD := $(VSECHNY_DODATKY:%=dodatky/%.md) $(VSECHNY_KAPITOLY:%=kapitoly/%.md)
VSECHNY_KAPITOLY_A_DODATKY_OMEZ := $(shell skripty/omezit-název.sh $(VSECHNY_KAPITOLY_A_DODATKY))

# Obrázky (bitmapové a SVG)
# ----------------------------------------------------------------------------
OBRAZKY := favicon.png by-sa.png logo-knihy-velké.png ve-výstavbě.png močál.jpg údolí.jpg banner.png
OBRAZKY += ik-výchozí.png
SVG_OBRAZKY := kalendář.svg graf-filtrů.svg git.svg
OBRAZKY_IK := awk.png datum-čas-kalendář.png diskové-oddíly.png docker.png git.png hledání-souborů.png
OBRAZKY_IK += make.png markdown.png odkazy.png perl-základy.png plánování-úloh.png práce-s-archivy.png proměnné.png regulární-výrazy.png
OBRAZKY_IK += sed.png soubory-a-adresáře.png správa-balíčků.png správa-procesů.png správa-uživatelských-účtů.png
OBRAZKY_IK += stahování-videí.png systém.png terminál.png vim.png
OBRAZKY_IK += základní-znalosti.png zpracování-binárních-souborů.png zpracování-textových-souborů.png zpracování-videa-a-zvuku.png
OBRAZKY_IK += předmluva.png koncepce-projektu.png plán-vývoje.png licence.png

OBRAZKY_OMEZ := $(shell skripty/omezit-název.sh $(OBRAZKY))
SVG_OBRAZKY_OMEZ := $(shell skripty/omezit-název.sh $(SVG_OBRAZKY))
OBRAZKY_IK_OMEZ := $(shell skripty/omezit-název.sh $(OBRAZKY_IK))

# CSS motivy (vedle motivu „hlavní“)
# ----------------------------------------------------------------------------
CSS_MOTIVY := vk-svetly vk-tmavy svetly

# Datum sestavení (automaticky generované)
# ----------------------------------------------------------------------------
DATUM_SESTAVENI := $(shell date +%Y%m%d)

# Další nastavení
# ----------------------------------------------------------------------------
export PDF_ZALOZKY := 1
export SOUBORY_PREKLADU := soubory_překladu
export VYSTUP_PREKLADU := výstup_překladu
# PDF_ZALOZKY_MAX_DELKA - po změně je nutno ve skriptu „skripty/extrakce/osnova.awk“ změnit odpovídajícím způsobem délku proměnné „PNAZEV_SABLONA“!
export PDF_ZALOZKY_MAX_DELKA := 32
export REKLAMNI_PATY := 0
PREMIOVE_KAPITOLY := 0

# Jméno sestavení (doporučuji nastavovat z příkazového řádku)
# ----------------------------------------------------------------------------
export JMENO := Sid $(DATUM_SESTAVENI)

# Verze .deb-balíčku (automaticky generovaná, ale je dovoleno ji nastavit ručně)
# ----------------------------------------------------------------------------
DEB_VERZE := $(shell $(AWK) -f skripty/extrakce/debverze.awk -- "$(JMENO)")

# Soubory symbolizující nastavení (automaticky generované)
# ----------------------------------------------------------------------------
DATUM_SESTAVENI_SOUBOR := $(SOUBORY_PREKLADU)/symboly/datum-sestavení/$(DATUM_SESTAVENI)
DEB_VERZE_SOUBOR := $(SOUBORY_PREKLADU)/symboly/deb-verze/$(DEB_VERZE)
JMENO_SESTAVENI_SOUBOR := $(SOUBORY_PREKLADU)/symboly/jméno-sestavení/$(shell printf %s "$(JMENO)" | tr "/ \\n\\t" -)
PORADI_KAPITOL_SOUBOR := $(SOUBORY_PREKLADU)/symboly/pořadí-kapitol/$(shell skripty/pořadí-kapitol.sh $(VSECHNY_DODATKY) $(VSECHNY_KAPITOLY) | md5sum -b | cut -d ' ' -f 1)
NASTAVENI_SOUBOR := $(SOUBORY_PREKLADU)/symboly/nastavení/$(PREMIOVE_KAPITOLY)

$(shell mkdir -pv $(SOUBORY_PREKLADU) >/dev/null; true > $(SOUBORY_PREKLADU)/dynamický-Makefile)

.PHONY: all clean html log pdf-a4 pdf-a4-bez pdf-b5 pdf-b5-bez pdf-b5-na-a4 info
.DELETE_ON_ERROR: # Přítomnost tohoto cíle nastaví „make“, aby v případě kteréhokoliv pravidla byl odstraněn jeho cíl.

all: deb html log pdf-a4 pdf-a4-bez pdf-b5 pdf-b5-bez pdf-b5-na-a4 pdf-výplach

clean:
	$(RM) -Rv $(SOUBORY_PREKLADU) $(VYSTUP_PREKLADU)

info: $(DATUM_SESTAVENI_SOUBOR) $(DEB_VERZE_SOUBOR) $(JMENO_SESTAVENI_SOUBOR) $(PORADI_KAPITOL_SOUBOR)
	@printf '%s\n' "Jméno sestavení: <$(JMENO)>" "DEB verze: <$(DEB_VERZE)>" "Datum sestavení: <$(DATUM_SESTAVENI)>" "Datum sestavení soubor: <$(DATUM_SESTAVENI_SOUBOR)>" "Deb verze soubor: <$(DEB_VERZE_SOUBOR)>" "Jméno sestavení soubor: <$(JMENO_SESTAVENI_SOUBOR)>" "Pořadí kapitol soubor: <$(PORADI_KAPITOL_SOUBOR)>" "Řádek dynamického Makefile: <$$(wc -l $(SOUBORY_PREKLADU)/dynamický-Makefile)>" "Adresáře překladu: <$${SOUBORY_PREKLADU}> <$${VYSTUP_PREKLADU}>" "" "Pořadí kapitol a dodatků:"
	@skripty/pořadí-kapitol.sh $(VSECHNY_KAPITOLY_A_DODATKY) | bash -c 'while read -r nazev; do if test -f kapitoly/$${nazev}.md; then md5sum kapitoly/$${nazev}.md; elif test -f dodatky/$${nazev}.md; then md5sum dodatky/$${nazev}.md; else echo "?/$${nazev}.md: Neexistuje!"; fi | tr -d \\n; skripty/omezit-název.sh $${nazev} | sed -E "s/.*/\\t> &.htm/"; done' | nl -s " " -w 3
	@printf '\n'

# Podporované formáty:
deb: $(VYSTUP_PREKLADU)/lkk_$(DEB_VERZE)_all.deb
html: $(addprefix $(VYSTUP_PREKLADU)/html/, lkk-$(DATUM_SESTAVENI).css $(CSS_MOTIVY:%=lkk-$(DATUM_SESTAVENI)-%.css) index.htm x-autori.htm x-stitky.htm)
log: $(VYSTUP_PREKLADU)/log/index.log
pdf-a4: $(VYSTUP_PREKLADU)/pdf-a4.pdf
pdf-a4-bez: $(VYSTUP_PREKLADU)/pdf-a4-bez.pdf
pdf-b5: $(VYSTUP_PREKLADU)/pdf-b5.pdf
pdf-b5-bez: $(VYSTUP_PREKLADU)/pdf-b5-bez.pdf
pdf-b5-na-a4: $(VYSTUP_PREKLADU)/pdf-b5-na-a4.pdf
pdf-výplach: $(VYSTUP_PREKLADU)/pdf-výplach.pdf

$(DATUM_SESTAVENI_SOUBOR):
	mkdir -pv $(dir $@)
	$(RM) $(dir $@)*
	touch "$@"

$(DEB_VERZE_SOUBOR):
	mkdir -pv $(dir $@)
	$(RM) $(dir $@)*
	touch "$@"

$(JMENO_SESTAVENI_SOUBOR):
	mkdir -pv $(dir $@)
	$(RM) $(dir $@)*
	touch "$@"

$(PORADI_KAPITOL_SOUBOR):
	mkdir -pv $(dir $@)
	$(RM) $(dir $@)*
	@printf 'Test existence dodatků a kapitol... '
	@skripty/pořadí-kapitol.sh | while read -r nazev; do if test ! -r "kapitoly/$${nazev}.md" -a ! -r "dodatky/$${nazev}.md"; then printf '\nCHYBA: Kapitola ani dodatek s id %s nenalezen!\n' "$${nazev}" >&2; exit 1; fi; done
	@printf 'v pořádku.\n'
	touch "$@"

$(NASTAVENI_SOUBOR):
	mkdir -pv $(dir $@)
	$(RM) $(dir $@)*
	touch "$@"

# POMOCNÉ SOUBORY:
# ============================================================================

# 1. soubory_překladu/fragmenty.tsv + soubory_překladu/štítky.tsv
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/fragmenty.tsv: $(PORADI_KAPITOL_SOUBOR) $(NASTAVENI_SOUBOR) \
  skripty/extrakce/fragmenty.awk \
  $(VSECHNY_KAPITOLY_A_DODATKY_MD) \
  $(SOUBORY_PREKLADU)/ucs_ikony.dat konfig.ini \
  $(wildcard vydané-kapitoly.lst)
	mkdir -pv $(SOUBORY_PREKLADU)
	skripty/pořadí-kapitol.sh $(VSECHNY_DODATKY) $(VSECHNY_KAPITOLY) | $(AWK) -v "PREMIOVE_KAPITOLY=$(PREMIOVE_KAPITOLY)" -f skripty/extrakce/fragmenty.awk 3>$(SOUBORY_PREKLADU)/fragmenty.tsv 4>$(SOUBORY_PREKLADU)/štítky.tsv

# Poznámka: na souborech ucs_ikony.dat a konfig.ini ve skutečnosti fragmenty.tsv nezávisí,
# ale závislost je zde uvedena, aby se při jejich změně zajistilo přegenerování celého projektu.

$(SOUBORY_PREKLADU)/štítky.tsv: $(SOUBORY_PREKLADU)/fragmenty.tsv

# 2. soubory_překladu/fragmenty.tsv + *.md => soubory_překladu/osnova/*.tsv
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv): $(SOUBORY_PREKLADU)/osnova/%.tsv: kapitoly/%.md $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/extrakce/osnova.awk
	mkdir -pv $(SOUBORY_PREKLADU)/osnova
	$(AWK) -f skripty/extrakce/osnova.awk -v IDKAPITOLY=$(<:kapitoly/%.md=%) $< >$@.základ
	cut -f 5 $@.základ | tr -d \\n | iconv -f UTF-8 -t UTF-16BE | xxd -p -u -c $$((2 * $(PDF_ZALOZKY_MAX_DELKA))) | sed -E 's/(001A)*$$//;s/^/FEFF/;s/..../\\u&/g' | paste <(cut -f 1-4 $@.základ) - <(cut -f 6- $@.základ) >$@
	$(RM) $@.základ

$(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv): $(SOUBORY_PREKLADU)/osnova/%.tsv: dodatky/%.md $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/extrakce/osnova.awk
	mkdir -pv $(SOUBORY_PREKLADU)/osnova
	$(AWK) -f skripty/extrakce/osnova.awk -v IDKAPITOLY=$(<:dodatky/%.md=%) $< >$@.základ
	cut -f 5 $@.základ | tr -d \\n | iconv -f UTF-8 -t UTF-16BE | xxd -p -u -c $$((2 * $(PDF_ZALOZKY_MAX_DELKA))) | $(SED) 's/(001A)*$$//;s/^/FEFF/;s/..../\\u&/g' | paste <(cut -f 1-4 $@.základ) - <(cut -f 6- $@.základ) >$@
	$(RM) $@.základ

# 3. soubory_překladu/postprocess.dat
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/postprocess.dat: $(wildcard postprocess.dat)
	mkdir -pv $(dir $@)
	-test -r postprocess.dat && cat postprocess.dat >"$@"
	touch "$@"

# 4. soubory_překladu/ucs_ikony.dat
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/ucs_ikony.dat: ucs_ikony/ikony.txt skripty/extrakce/ikony-zaklínadel.awk
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/extrakce/ikony-zaklínadel.awk

# HTML:
# ============================================================================

# 1A. kapitoly/{kapitola}.md => soubory_překladu/html/{kapitola}
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/html/%): \
  $(SOUBORY_PREKLADU)/html/%: \
  kapitoly/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/překlad/do_html.awk skripty/překlad/hlavní.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -f skripty/překlad/do_html.awk $< > $@

# 1B. dodatky/{dodatek}.md => soubory_překladu/html/{dodatek}
# ----------------------------------------------------------------------------
$(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/html/%): \
  $(SOUBORY_PREKLADU)/html/%: \
  dodatky/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/překlad/do_html.awk skripty/překlad/hlavní.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -f skripty/překlad/do_html.awk $< > $@

# 2. soubory_překladu/html/{id} => soubory_překladu/html/{id}.htm => výstup_překladu/html/omezid.htm
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/html/%.htm): \
  $(SOUBORY_PREKLADU)/%.htm: \
  $(SOUBORY_PREKLADU)/% skripty/plnění-šablon/kapitola.awk skripty/plnění-šablon/hlavní.awk formáty/html/šablona.htm $(SOUBORY_PREKLADU)/fragmenty.tsv $(DATUM_SESTAVENI_SOUBOR)
	mkdir -pv $(VYSTUP_PREKLADU)/html
	if cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | fgrep -qx $(basename $(notdir $<)); then exec $(AWK) -f skripty/plnění-šablon/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDFORMATU=html -v IDKAPITOLY=$(basename $(notdir $@)) -v TELOKAPITOLY=$< -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v VARIANTA=kapitola formáty/html/šablona.htm > $@; else $(RM) $@; fi

$(shell SOUBORY_PREKLADU=$(SOUBORY_PREKLADU) skripty/dynamicky.sh -o $(SOUBORY_PREKLADU)/html/ $(VYSTUP_PREKLADU)/html/ $(VSECHNY_KAPITOLY_A_DODATKY:%=%.htm))

# 3. formáty/html/šablona.css => vystup_překladu/html/lkk-*.css
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/html/lkk-$(DATUM_SESTAVENI).css: formáty/html/šablona.css skripty/plnění-šablon/css.awk skripty/plnění-šablon/css2.awk
	mkdir -pv $(dir $@)
	$(RM) $(VYSTUP_PREKLADU)/html/lkk-????????.css
	set -o pipefail; $(AWK) -v IDFORMATU=html -v MOTIV=hlavni -f skripty/plnění-šablon/css.awk $< | $(AWK) -f skripty/plnění-šablon/css2.awk > $@

$(CSS_MOTIVY:%=$(VYSTUP_PREKLADU)/html/lkk-$(DATUM_SESTAVENI)-%.css): %: formáty/html/šablona.css skripty/plnění-šablon/css.awk skripty/plnění-šablon/css2.awk
	mkdir -pv $(dir $@)
	$(RM) $(@:$(VYSTUP_PREKLADU)/html/lkk-$(DATUM_SESTAVENI)%=$(VYSTUP_PREKLADU)/html/lkk-????????%)
	set -o pipefail; $(AWK) -v IDFORMATU=html -v MOTIV=$(strip $(patsubst lkk-$(DATUM_SESTAVENI)-%.css, %, $(notdir $@))) -f skripty/plnění-šablon/css.awk $< | $(AWK) -f skripty/plnění-šablon/css2.awk > $@

# 4. obrázky/{obrázek} => soubory_překladu/html/obrázky/{obrázek} => výstup_překladu/html/obrazky/{obrazek}
# ----------------------------------------------------------------------------
$(OBRAZKY:%=$(SOUBORY_PREKLADU)/html/obrázky/%) $(OBRAZKY_IK:%=$(SOUBORY_PREKLADU)/html/obrázky/ik/%): $(SOUBORY_PREKLADU)/html/obrázky/%: obrázky/%
	mkdir -pv $(dir $@)
	cp $< $@

$(SVG_OBRAZKY:%=$(SOUBORY_PREKLADU)/html/obrázky/%): $(SOUBORY_PREKLADU)/html/obrázky/%: obrázky/%
	mkdir -pv $(dir $@)
	cp $< $@

$(shell export SOUBORY_PREKLADU=$(SOUBORY_PREKLADU); skripty/dynamicky.sh -o $(SOUBORY_PREKLADU)/html/obrázky/ $(VYSTUP_PREKLADU)/html/obrazky/ $(OBRAZKY) $(SVG_OBRAZKY); skripty/dynamicky.sh -o $(SOUBORY_PREKLADU)/html/obrázky/ik/ $(VYSTUP_PREKLADU)/html/obrazky/ik/ $(OBRAZKY_IK))

# 5. výstup_překladu/html/*.htm => výstup_překladu/html/index.htm
# ----------------------------------------------------------------------------
# $(VSECHNY_KAPITOLY_A_DODATKY_OMEZ:%=$(VYSTUP_PREKLADU)/html/%.htm)
$(VYSTUP_PREKLADU)/html/index.htm: $(SOUBORY_PREKLADU)/fragmenty.tsv \
  skripty/plnění-šablon/index-html.awk \
  formáty/html/šablona.htm \
  $(VSECHNY_KAPITOLY_A_DODATKY_OMEZ:%=$(VYSTUP_PREKLADU)/html/%.htm) \
  $(SOUBORY_PREKLADU)/fragmenty.tsv \
  $(OBRAZKY_OMEZ:%=$(VYSTUP_PREKLADU)/html/obrazky/%) \
  $(OBRAZKY_IK_OMEZ:%=$(VYSTUP_PREKLADU)/html/obrazky/ik/%) \
  $(SVG_OBRAZKY_OMEZ:%=$(VYSTUP_PREKLADU)/html/obrazky/%) \
  $(DATUM_SESTAVENI_SOUBOR)
	$(AWK) -f skripty/plnění-šablon/index-html.awk -v JMENOVERZE='$(JMENO)' -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v IDFORMATU=html -v VARIANTA=index $(SOUBORY_PREKLADU)/fragmenty.tsv formáty/html/šablona.htm > $@

# 6. sepsat copyrighty ke kapitolám
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/html/kap-copys.htm: $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/extrakce/copyrighty.awk $(VSECHNY_DODATKY:%=dodatky/%.md) $(VSECHNY_KAPITOLY:%=kapitoly/%.md)
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -f skripty/extrakce/copyrighty.awk $(shell $(SED) 's/^[^\t]*\t([^\t]+)\t[^\t]*\t([^\t]+)\t.*$$/\2\/\1.md/' $<) >$@

# 7. sepsat copyrighty k obrázkům
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/html/obr-copys.htm: COPYRIGHT skripty/extrakce/copykobr.awk
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/extrakce/copykobr.awk $< $(OBRAZKY:%=obrázky/%) $(SVG_OBRAZKY:%=obrázky/%) >$@

# 8. shromáždit copyrighty na stránku x-autori.htm
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/html/x-autori.htm: \
  $(addprefix $(SOUBORY_PREKLADU)/html/, kap-copys.htm obr-copys.htm) \
  skripty/plnění-šablon/kapitola.awk skripty/plnění-šablon/hlavní.awk \
  formáty/html/šablona.htm \
  $(DATUM_SESTAVENI_SOUBOR)
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/plnění-šablon/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDFORMATU=html -v IDKAPITOLY=_autori -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v COPYRIGHTY_KAPITOL=$(SOUBORY_PREKLADU)/html/kap-copys.htm -v COPYRIGHTY_OBRAZKU=$(SOUBORY_PREKLADU)/html/obr-copys.htm -v VARIANTA=autori formáty/html/šablona.htm > $@

# 9. shromáždit štítky na stránku x-stitky.htm
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/html/x-stitky.htm: \
  skripty/plnění-šablon/kapitola.awk skripty/plnění-šablon/hlavní.awk \
  formáty/html/šablona.htm \
  $(SOUBORY_PREKLADU)/fragmenty.tsv \
  $(DATUM_SESTAVENI_SOUBOR)
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/plnění-šablon/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDFORMATU=html -v IDKAPITOLY=_stitky -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v FRAGMENTY_TSV=$(SOUBORY_PREKLADU)/fragmenty.tsv -v IDFORMATU=html -v VARIANTA=stitky formáty/html/šablona.htm >$@

# LOG:
# ============================================================================

# 1A. kapitoly/{kapitola}.md => soubory_překladu/log/{kapitola}
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/log/%): \
  $(SOUBORY_PREKLADU)/log/%: \
  kapitoly/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/překlad/do_logu.awk skripty/překlad/hlavní.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -f skripty/překlad/do_logu.awk $< > $@

# 1B. dodatky/{dodatek}.md => soubory_překladu/log/{dodatek}
# ----------------------------------------------------------------------------
$(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/log/%): \
  $(SOUBORY_PREKLADU)/log/%: \
  dodatky/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/překlad/do_logu.awk skripty/překlad/hlavní.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -f skripty/překlad/do_logu.awk $< > $@

# 2. soubory_překladu/log/{id} => soubory_překladu/log/{id}.kap
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/log/%.kap): \
  %.kap: \
  % skripty/plnění-šablon/kapitola.awk skripty/plnění-šablon/hlavní.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv formáty/log/šablona $(DATUM_SESTAVENI_SOUBOR)
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -f skripty/plnění-šablon/kapitola.awk -v JMENOVERZE='$(JMENO)' -v IDFORMATU=log -v IDKAPITOLY=$(basename $(notdir $@)) -v DATUMSESTAVENI=$(DATUM_SESTAVENI) -v TELOKAPITOLY=$< formáty/log/šablona > $@

# 3. soubory_překladu/log/{id}.kap => vystup_překladu/log/{id}.log
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(VYSTUP_PREKLADU)/log/%.log): \
  $(VYSTUP_PREKLADU)/log/%.log: \
  $(SOUBORY_PREKLADU)/log/%.kap
	mkdir -pv $(VYSTUP_PREKLADU)/log
	cat $< > $@

# 4. soubory_překladu/log/{id}.kap => vystup_překladu/log/index.log
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/log/index.log: \
  $(VSECHNY_KAPITOLY_A_DODATKY:%=$(VYSTUP_PREKLADU)/log/%.log) \
  $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(VYSTUP_PREKLADU)/log
	cd $(SOUBORY_PREKLADU)/log; cut -f 2 ../fragmenty.tsv | $(SED) 's/$$/.kap/' | xargs -r fgrep --color=always -Hn '' >../../$@ || true

# PDF (společná část):
# ============================================================================

# 1A. kapitoly/{kapitola}.md => soubory_překladu/pdf-společné/{kapitola}.kap
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/pdf-společné/%.kap): \
  $(SOUBORY_PREKLADU)/pdf-společné/%.kap: \
  kapitoly/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/překlad/do_latexu.awk skripty/překlad/hlavní.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	$(AWK) -v FRAGMENTY_TSV=$(SOUBORY_PREKLADU)/fragmenty.tsv -f skripty/překlad/do_latexu.awk $< > $@

# 1B. dodatky/{dodatek}.md => soubory_překladu/pdf-společné/{dodatek}.kap
# ----------------------------------------------------------------------------
$(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-společné/%.kap): \
  $(SOUBORY_PREKLADU)/pdf-společné/%.kap: \
  dodatky/%.md $(SOUBORY_PREKLADU)/osnova/%.tsv skripty/překlad/do_latexu.awk skripty/překlad/hlavní.awk skripty/utility.awk $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/překlad/do_latexu.awk $< > $@

# 2. (zrušeno)

# 3. obrázky/{obrázek} => soubory_překladu/pdf-společné/_obrázky/{obrázek}
# ----------------------------------------------------------------------------
$(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%) $(OBRAZKY_IK:%=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/ik/%): $(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%: obrázky/% konfig.ini
	mkdir -pv $(dir $@)
	$(CONVERT) $< $(shell bash -e skripty/přečíst-konfig.sh "Filtry" "$(@:$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%=../obrázky/%)" "-colorspace Gray" < konfig.ini) $@

$(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%.pdf): $(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%.pdf: obrázky/%.svg
	mkdir -pv $(dir $@)
#	inkscape --without-gui "--file=$<" "--export-pdf=$@"
#	z balíčku „librsvg2-bin“:
	rsvg-convert -f pdf -o "$@" "$<"

$(SOUBORY_PREKLADU)/pdf-společné/qr.eps: konfig.ini
	bash skripty/přečíst-konfig.sh Adresy do-qr <$< | qrencode -o "$@" -t eps -s 8

# PDF A4:
# ============================================================================

# 4. soubory_překladu/pdf-společné/{id}.kap => soubory_překladu/pdf-a4/{id}.kap
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-a4/%.kap): \
  $(SOUBORY_PREKLADU)/pdf-a4/%.kap: \
  $(SOUBORY_PREKLADU)/pdf-společné/%.kap $(SOUBORY_PREKLADU)/postprocess.dat skripty/postprocess.awk skripty/utility.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-a4 -f skripty/postprocess.awk $(SOUBORY_PREKLADU)/postprocess.dat $< 2>&1 >$@

# 5. soubory_překladu/pdf-a4/{id}.kap => soubory_překladu/pdf-a4/_všechny.kap
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-a4/_všechny.kap: $(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-a4/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | $(SED) 's/.*/$(SOUBORY_PREKLADU)\/pdf-a4\/&.kap/' | xargs -r cat >$@

# 6. soubory_překladu/pdf-a4/_všechny.kap => soubory_překladu/pdf-a4/kniha.tex
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-a4/kniha.tex: $(SOUBORY_PREKLADU)/pdf-a4/_všechny.kap formáty/pdf/šablona.tex
	$(AWK) -f skripty/plnění-šablon/speciální.awk -v IDFORMATU=pdf-a4 -v JMENOVERZE='$(JMENO)' -v TELO=$< formáty/pdf/šablona.tex >$@

# 7. soubory_překladu/pdf-a4/kniha.tex => soubory_překladu/pdf-a4/kniha.pdf
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-a4/kniha.pdf: \
  $(SOUBORY_PREKLADU)/pdf-a4/kniha.tex \
  $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%) \
  $(OBRAZKY_IK:%=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/ik/%) \
  $(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%.pdf) \
  $(SOUBORY_PREKLADU)/pdf-společné/qr.eps
	mkdir -pv $(dir $@)
	ln -rsTv skripty $(dir $<)skripty 2>/dev/null || true
	cd $(dir $<); exec $(AWK) -f skripty/latex.awk

# 8. soubory_překladu/pdf-a4/kniha.toc => soubory_překladu/pdf-a4/pdfmarks
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-a4/pdfmarks: \
  $(SOUBORY_PREKLADU)/pdf-a4/kniha.pdf \
  $(SOUBORY_PREKLADU)/fragmenty.tsv \
  $(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv) \
  $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv) \
  skripty/extrakce/pdf-záložky.awk
	$(AWK) -f skripty/extrakce/pdf-záložky.awk $(SOUBORY_PREKLADU)/pdf-a4/kniha.toc >$@

# 9. soubory_překladu/pdf-a4/kniha.pdf => vystup_překladu/pdf-a4.pdf
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/pdf-a4.pdf: \
  $(SOUBORY_PREKLADU)/pdf-a4/kniha.pdf \
  $(SOUBORY_PREKLADU)/pdf-a4/pdfmarks
	mkdir -pv $(dir $@)
	if test "$(PDF_ZALOZKY)" != "0"; then gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=$@ $(SOUBORY_PREKLADU)/pdf-a4/kniha.pdf $(SOUBORY_PREKLADU)/pdf-a4/pdfmarks </dev/null; else cat $< > $@; fi


# PDF A4 bez ořezových značek:
# ============================================================================

# 4. soubory_překladu/pdf-společné/{id}.kap => soubory_překladu/pdf-a4-bez/{id}.kap
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-a4-bez/%.kap): \
  $(SOUBORY_PREKLADU)/pdf-a4-bez/%.kap: \
  $(SOUBORY_PREKLADU)/pdf-společné/%.kap $(SOUBORY_PREKLADU)/postprocess.dat skripty/postprocess.awk skripty/utility.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-a4-bez -f skripty/postprocess.awk $(SOUBORY_PREKLADU)/postprocess.dat $< 2>&1 >$@

# 5. soubory_překladu/pdf-a4-bez/{id}.kap => soubory_překladu/pdf-a4-bez/_všechny.kap
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-a4-bez/_všechny.kap: $(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-a4-bez/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | $(SED) 's/.*/$(SOUBORY_PREKLADU)\/pdf-a4-bez\/&.kap/' | xargs -r cat >$@

# 6. soubory_překladu/pdf-a4-bez/_všechny.kap => soubory_překladu/pdf-a4-bez/kniha.tex
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-a4-bez/kniha.tex: $(SOUBORY_PREKLADU)/pdf-a4-bez/_všechny.kap formáty/pdf/šablona.tex
	$(AWK) -f skripty/plnění-šablon/speciální.awk -v IDFORMATU=pdf-a4-bez -v JMENOVERZE='$(JMENO)' -v TELO=$< formáty/pdf/šablona.tex >$@

# 7. soubory_překladu/pdf-a4-bez/kniha.tex => soubory_překladu/pdf-a4-bez/kniha.pdf
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-a4-bez/kniha.pdf: \
  $(SOUBORY_PREKLADU)/pdf-a4-bez/kniha.tex \
  $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%) \
  $(OBRAZKY_IK:%=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/ik/%) \
  $(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%.pdf) \
  $(SOUBORY_PREKLADU)/pdf-společné/qr.eps
	mkdir -pv $(dir $@)
	ln -rsTv skripty $(dir $<)skripty 2>/dev/null || true
	cd $(dir $<); exec $(AWK) -f skripty/latex.awk

# 8. soubory_překladu/pdf-a4-bez/kniha.toc => soubory_překladu/pdf-a4-bez/pdfmarks
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-a4-bez/pdfmarks: \
  $(SOUBORY_PREKLADU)/pdf-a4-bez/kniha.pdf \
  $(SOUBORY_PREKLADU)/fragmenty.tsv \
  $(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv) \
  $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv) \
  skripty/extrakce/pdf-záložky.awk
	$(AWK) -f skripty/extrakce/pdf-záložky.awk $(SOUBORY_PREKLADU)/pdf-a4-bez/kniha.toc >$@

# 9. soubory_překladu/pdf-a4-bez/kniha.pdf => vystup_překladu/pdf-a4-bez.pdf
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/pdf-a4-bez.pdf: \
  $(SOUBORY_PREKLADU)/pdf-a4-bez/kniha.pdf \
  $(SOUBORY_PREKLADU)/pdf-a4-bez/pdfmarks
	mkdir -pv $(dir $@)
	if test "$(PDF_ZALOZKY)" != "0"; then gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=$@ $(SOUBORY_PREKLADU)/pdf-a4-bez/kniha.pdf $(SOUBORY_PREKLADU)/pdf-a4-bez/pdfmarks </dev/null; else cat $< > $@; fi


# PDF B5:
# ============================================================================

# 4. soubory_překladu/pdf-společné/{id}.kap => soubory_překladu/pdf-b5/{id}.kap
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-b5/%.kap): \
  $(SOUBORY_PREKLADU)/pdf-b5/%.kap: \
  $(SOUBORY_PREKLADU)/pdf-společné/%.kap $(SOUBORY_PREKLADU)/postprocess.dat skripty/postprocess.awk skripty/utility.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-b5 -f skripty/postprocess.awk $(SOUBORY_PREKLADU)/postprocess.dat $< 2>&1 >$@

# 5. soubory_překladu/pdf-b5/{id}.kap => soubory_překladu/pdf-b5/_všechny.kap
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5/_všechny.kap: $(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-b5/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | $(SED) 's/.*/$(SOUBORY_PREKLADU)\/pdf-b5\/&.kap/' | xargs -r cat >$@

# 6. soubory_překladu/pdf-b5/_všechny.kap => soubory_překladu/pdf-b5/kniha.tex
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5/kniha.tex: $(SOUBORY_PREKLADU)/pdf-b5/_všechny.kap formáty/pdf/šablona.tex
	$(AWK) -f skripty/plnění-šablon/speciální.awk -v IDFORMATU=pdf-b5 -v JMENOVERZE='$(JMENO)' -v TELO=$< formáty/pdf/šablona.tex >$@

# 7. soubory_překladu/pdf-b5/kniha.tex => soubory_překladu/pdf-b5/kniha.pdf
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5/kniha.pdf: \
  $(SOUBORY_PREKLADU)/pdf-b5/kniha.tex \
  $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%) \
  $(OBRAZKY_IK:%=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/ik/%) \
  $(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%.pdf) \
  $(SOUBORY_PREKLADU)/pdf-společné/qr.eps
	mkdir -pv $(dir $@)
	ln -rsTv skripty $(dir $<)skripty 2>/dev/null || true
	cd $(dir $<); exec $(AWK) -f skripty/latex.awk

# 8. soubory_překladu/pdf-b5/kniha.toc => soubory_překladu/pdf-b5/pdfmarks
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5/pdfmarks: \
  $(SOUBORY_PREKLADU)/pdf-b5/kniha.pdf \
  $(SOUBORY_PREKLADU)/fragmenty.tsv \
  $(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv) \
  $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv) \
  skripty/extrakce/pdf-záložky.awk
	$(AWK) -f skripty/extrakce/pdf-záložky.awk $(SOUBORY_PREKLADU)/pdf-b5/kniha.toc >$@

# 9. soubory_překladu/pdf-b5/kniha.pdf => vystup_překladu/pdf-b5.pdf
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/pdf-b5.pdf: \
  $(SOUBORY_PREKLADU)/pdf-b5/kniha.pdf \
  $(SOUBORY_PREKLADU)/pdf-b5/pdfmarks
	mkdir -pv $(dir $@)
	if test "$(PDF_ZALOZKY)" != "0"; then gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=$@ $(SOUBORY_PREKLADU)/pdf-b5/kniha.pdf $(SOUBORY_PREKLADU)/pdf-b5/pdfmarks </dev/null; else cat $< > $@; fi


# PDF B5 bez ořezových značek:
# ============================================================================

# 4. soubory_překladu/pdf-společné/{id}.kap => soubory_překladu/pdf-b5-bez/{id}.kap
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-b5-bez/%.kap): \
  $(SOUBORY_PREKLADU)/pdf-b5-bez/%.kap: \
  $(SOUBORY_PREKLADU)/pdf-společné/%.kap $(SOUBORY_PREKLADU)/postprocess.dat skripty/postprocess.awk skripty/utility.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-b5-bez -f skripty/postprocess.awk $(SOUBORY_PREKLADU)/postprocess.dat $< 2>&1 >$@

# 5. soubory_překladu/pdf-b5-bez/{id}.kap => soubory_překladu/pdf-b5-bez/_všechny.kap
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5-bez/_všechny.kap: $(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-b5-bez/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | $(SED) 's/.*/$(SOUBORY_PREKLADU)\/pdf-b5-bez\/&.kap/' | xargs -r cat >$@

# 6. soubory_překladu/pdf-b5-bez/_všechny.kap => soubory_překladu/pdf-b5-bez/kniha.tex
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5-bez/kniha.tex: $(SOUBORY_PREKLADU)/pdf-b5-bez/_všechny.kap formáty/pdf/šablona.tex
	$(AWK) -f skripty/plnění-šablon/speciální.awk -v IDFORMATU=pdf-b5-bez -v JMENOVERZE='$(JMENO)' -v TELO=$< formáty/pdf/šablona.tex >$@

# 7. soubory_překladu/pdf-b5-bez/kniha.tex => soubory_překladu/pdf-b5-bez/kniha.pdf
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5-bez/kniha.pdf: \
  $(SOUBORY_PREKLADU)/pdf-b5-bez/kniha.tex \
  $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%) \
  $(OBRAZKY_IK:%=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/ik/%) \
  $(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%.pdf) \
  $(SOUBORY_PREKLADU)/pdf-společné/qr.eps
	mkdir -pv $(dir $@)
	ln -rsTv skripty $(dir $<)skripty 2>/dev/null || true
	cd $(dir $<); exec $(AWK) -f skripty/latex.awk

# 8. soubory_překladu/pdf-b5-bez/kniha.toc => soubory_překladu/pdf-b5-bez/pdfmarks
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5-bez/pdfmarks: \
  $(SOUBORY_PREKLADU)/pdf-b5-bez/kniha.pdf \
  $(SOUBORY_PREKLADU)/fragmenty.tsv \
  $(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv) \
  $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv) \
  skripty/extrakce/pdf-záložky.awk
	$(AWK) -f skripty/extrakce/pdf-záložky.awk $(SOUBORY_PREKLADU)/pdf-b5-bez/kniha.toc >$@

# 9. soubory_překladu/pdf-b5-bez/kniha.pdf => vystup_překladu/pdf-b5-bez.pdf
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/pdf-b5-bez.pdf: \
  $(SOUBORY_PREKLADU)/pdf-b5-bez/kniha.pdf \
  $(SOUBORY_PREKLADU)/pdf-b5-bez/pdfmarks
	mkdir -pv $(dir $@)
	if test "$(PDF_ZALOZKY)" != "0"; then gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=$@ $(SOUBORY_PREKLADU)/pdf-b5-bez/kniha.pdf $(SOUBORY_PREKLADU)/pdf-b5-bez/pdfmarks </dev/null; else cat $< > $@; fi


# PDF B5 na A4:
# ============================================================================

# 4. soubory_překladu/pdf-společné/{id}.kap => soubory_překladu/pdf-b5-na-a4/{id}.kap
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-b5-na-a4/%.kap): \
  $(SOUBORY_PREKLADU)/pdf-b5-na-a4/%.kap: \
  $(SOUBORY_PREKLADU)/pdf-společné/%.kap $(SOUBORY_PREKLADU)/postprocess.dat skripty/postprocess.awk skripty/utility.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-b5-na-a4 -f skripty/postprocess.awk $(SOUBORY_PREKLADU)/postprocess.dat $< 2>&1 >$@

# 5. soubory_překladu/pdf-b5-na-a4/{id}.kap => soubory_překladu/pdf-b5-na-a4/_všechny.kap
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5-na-a4/_všechny.kap: $(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-b5-na-a4/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | $(SED) 's/.*/$(SOUBORY_PREKLADU)\/pdf-b5-na-a4\/&.kap/' | xargs -r cat >$@

# 6. soubory_překladu/pdf-b5-na-a4/_všechny.kap => soubory_překladu/pdf-b5-na-a4/kniha.tex
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5-na-a4/kniha.tex: $(SOUBORY_PREKLADU)/pdf-b5-na-a4/_všechny.kap formáty/pdf/šablona.tex
	$(AWK) -f skripty/plnění-šablon/speciální.awk -v IDFORMATU=pdf-b5-na-a4 -v JMENOVERZE='$(JMENO)' -v TELO=$< formáty/pdf/šablona.tex >$@

# 7. soubory_překladu/pdf-b5-na-a4/kniha.tex => soubory_překladu/pdf-b5-na-a4/kniha.pdf
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5-na-a4/kniha.pdf: \
  $(SOUBORY_PREKLADU)/pdf-b5-na-a4/kniha.tex \
  $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%) \
  $(OBRAZKY_IK:%=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/ik/%) \
  $(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%.pdf) \
  $(SOUBORY_PREKLADU)/pdf-společné/qr.eps
	mkdir -pv $(dir $@)
	ln -rsTv skripty $(dir $<)skripty 2>/dev/null || true
	cd $(dir $<); exec $(AWK) -f skripty/latex.awk

# 8. soubory_překladu/pdf-b5-na-a4/kniha.toc => soubory_překladu/pdf-b5-na-a4/pdfmarks
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-b5-na-a4/pdfmarks: \
  $(SOUBORY_PREKLADU)/pdf-b5-na-a4/kniha.pdf \
  $(SOUBORY_PREKLADU)/fragmenty.tsv \
  $(VSECHNY_KAPITOLY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv) \
  $(VSECHNY_DODATKY:%=$(SOUBORY_PREKLADU)/osnova/%.tsv) \
  skripty/extrakce/pdf-záložky.awk
	$(AWK) -f skripty/extrakce/pdf-záložky.awk $(SOUBORY_PREKLADU)/pdf-b5-na-a4/kniha.toc >$@

# 9. soubory_překladu/pdf-b5-na-a4/kniha.pdf => vystup_překladu/pdf-b5-na-a4.pdf
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/pdf-b5-na-a4.pdf: \
  $(SOUBORY_PREKLADU)/pdf-b5-na-a4/kniha.pdf \
  $(SOUBORY_PREKLADU)/pdf-b5-na-a4/pdfmarks
	mkdir -pv $(dir $@)
	if test "$(PDF_ZALOZKY)" != "0"; then gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=$@ $(SOUBORY_PREKLADU)/pdf-b5-na-a4/kniha.pdf $(SOUBORY_PREKLADU)/pdf-b5-na-a4/pdfmarks </dev/null; else cat $< > $@; fi

# PDF výplach:
# ============================================================================

# 4. soubory_překladu/pdf-společné/{id}.kap => soubory_překladu/pdf-výplach/{id}.kap
# ----------------------------------------------------------------------------
$(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-výplach/%.kap): \
  $(SOUBORY_PREKLADU)/pdf-výplach/%.kap: \
  $(SOUBORY_PREKLADU)/pdf-společné/%.kap $(SOUBORY_PREKLADU)/postprocess.dat skripty/postprocess.awk skripty/utility.awk
	mkdir -pv $(dir $@)
	touch $(SOUBORY_PREKLADU)/postprocess.log
	$(AWK) -v IDFORMATU=pdf-výplach -f skripty/postprocess.awk $(SOUBORY_PREKLADU)/postprocess.dat $< 2>&1 >$@

# 5. soubory_překladu/pdf-výplach/{id}.kap => soubory_překladu/pdf-výplach/_všechny.kap
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-výplach/_všechny.kap: $(VSECHNY_KAPITOLY_A_DODATKY:%=$(SOUBORY_PREKLADU)/pdf-výplach/%.kap) $(SOUBORY_PREKLADU)/fragmenty.tsv
	mkdir -pv $(dir $@)
	cut -f 2 $(SOUBORY_PREKLADU)/fragmenty.tsv | $(SED) 's/.*/$(SOUBORY_PREKLADU)\/pdf-výplach\/&.kap/' | xargs -r cat >$@

# 6. soubory_překladu/pdf-výplach/_všechny.kap => soubory_překladu/pdf-výplach/kniha.tex
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/pdf-výplach/kniha.tex: $(SOUBORY_PREKLADU)/pdf-výplach/_všechny.kap formáty/pdf/šablona.tex
	$(AWK) -f skripty/plnění-šablon/speciální.awk -v IDFORMATU=pdf-výplach -v JMENOVERZE='$(JMENO)' -v TELO=$< formáty/pdf/šablona.tex >$@

# 7. soubory_překladu/pdf-výplach/kniha.tex => výstup_překladu/pdf-výplach/kniha.pdf
# ----------------------------------------------------------------------------
$(VYSTUP_PREKLADU)/pdf-výplach.pdf: \
  $(SOUBORY_PREKLADU)/pdf-výplach/kniha.tex \
  $(OBRAZKY:%=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%) \
  $(OBRAZKY_IK:%=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/ik/%) \
  $(SVG_OBRAZKY:%.svg=$(SOUBORY_PREKLADU)/pdf-společné/_obrázky/%.pdf) \
  $(SOUBORY_PREKLADU)/pdf-společné/qr.eps
	mkdir -pv $(dir $@)
	ln -rsTv skripty $(dir $<)skripty 2>/dev/null || true
	cd $(dir $<); exec $(AWK) -f skripty/latex.awk
	cp -fv $(SOUBORY_PREKLADU)/pdf-výplach/kniha.pdf $@

# DEB:
# ============================================================================

# 1. skripty/lkk/lkk => soubory_překladu/deb/usr/bin/lkk
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/deb/usr/bin/lkk: skripty/lkk/lkk
	mkdir -pv $(dir $@)
	cp --no-preserve=mode,timestamps -f $< $@
	chmod 755 $@

# 2. skripty/lkk/LinuxKnihaKouzel.pl => soubory_překladu/deb/usr/share/lkk/LinuxKnihaKouzel.pl
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/deb/usr/share/lkk/LinuxKnihaKouzel.pl: skripty/lkk/LinuxKnihaKouzel.pl $(JMENO_SESTAVENI_SOUBOR)
	mkdir -pv $(dir $@)
	$(SED) "s/\{\{JMÉNO VERZE\}\}/$(JMENO)/g" $< >$@

# 3. skripty/lkk/lkk-spouštěč.pl => soubory_překladu/deb/usr/share/lkk/lkk-spoustec.pl
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/deb/usr/share/lkk/lkk-spoustec.pl: skripty/lkk/lkk-spouštěč.pl $(JMENO_SESTAVENI_SOUBOR)
	mkdir -pv $(dir $@)
	$(SED) "s/\{\{JMÉNO VERZE\}\}/$(JMENO)/g" $< >$@

# 4. kapitoly/*.md => soubory_překladu/deb/usr/share/lkk/skripty/*
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/deb/usr/share/lkk/skripty/pomocné-funkce: skripty/extrakce/pomocné-funkce.awk $(SOUBORY_PREKLADU)/fragmenty.tsv skripty/utility.awk $(VSECHNY_KAPITOLY:%=kapitoly/%.md)
	mkdir -pv $(dir $@)
	$(AWK) -f skripty/extrakce/pomocné-funkce.awk

# 5. COPYRIGHT-DEB => soubory_překladu/deb/usr/share/doc/lkk/copyright
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/deb/usr/share/doc/lkk/copyright: COPYRIGHT-DEB
	mkdir -pv $(dir $@)
	cat $< >$@

# 6. formáty/deb/control => soubory_překladu/deb/DEBIAN/control
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/deb/DEBIAN/control: formáty/deb/control $(DEB_VERZE_SOUBOR)
	mkdir -pv $(dir $@)
	$(SED) 's/\{Version\}/$(DEB_VERZE)/g;s/\{Installed-Size\}/'"$$(du -ks --exclude=DEBIAN $(SOUBORY_PREKLADU)/deb | cut -f 1 | tail -n 1)/g" $< >"$@"

# 7. skripty/lkk/bash-doplňování.sh => soubory_překladu/deb/usr/share/bash-completion/completions/lkk
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/deb/usr/share/bash-completion/completions/lkk: skripty/lkk/bash-doplňování.sh
	mkdir -pv $(dir $@)
	cat $< >$@

# 8. soubory_překladu/deb/** => soubory_překladu/deb/DEBIAN/md5sums
# ----------------------------------------------------------------------------
$(SOUBORY_PREKLADU)/deb/DEBIAN/md5sums: \
  $(SOUBORY_PREKLADU)/deb/usr/bin/lkk \
  $(SOUBORY_PREKLADU)/deb/usr/share/doc/lkk/copyright \
  $(SOUBORY_PREKLADU)/deb/usr/share/lkk/LinuxKnihaKouzel.pl \
  $(SOUBORY_PREKLADU)/deb/usr/share/lkk/lkk-spoustec.pl \
  $(SOUBORY_PREKLADU)/deb/usr/share/lkk/skripty/pomocné-funkce \
  $(SOUBORY_PREKLADU)/deb/usr/share/bash-completion/completions/lkk
	mkdir -pv $(dir $@)
	(cd $(SOUBORY_PREKLADU)/deb && exec find * -path DEBIAN -prune -o -type f -exec md5sum -- '{}' +) | LC_ALL=C sort -k 1.33b >$@

# 8. soubory_překladu/deb/** => vystup_překladu/lkk_{verze}_all.deb
# ----------------------------------------------------------------------------
# Poznámka: přes „md5sums“ závisí také na všech ostatních souborech v $(SOUBORY_PREKLADU)/deb mimo podadresář DEBIAN.
$(VYSTUP_PREKLADU)/lkk_$(DEB_VERZE)_all.deb: \
  $(SOUBORY_PREKLADU)/deb/DEBIAN/control \
  $(SOUBORY_PREKLADU)/deb/DEBIAN/md5sums
	mkdir -pv $(dir $@)
	chmod -R u+rw,go+r,go-w "$(SOUBORY_PREKLADU)/deb"
	dpkg-deb -b --root-owner-group "$(SOUBORY_PREKLADU)/deb" "$@"

include $(SOUBORY_PREKLADU)/dynamický-Makefile
