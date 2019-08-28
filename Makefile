VSECHNY_KAPITOLY := docker make
SOUBORY_PREKLADU := soubory_prekladu
VYSTUP_PREKLADU := vystup_prekladu
AWK := gawk

all: html

clean:
	$(RM) -R $(SOUBORY_PREKLADU) $(VYSTUP_PREKLADU)

.PHONY: all clean

html: $(VYSTUP_PREKLADU)/html/index.htm

# 1. kapitoly/{kapitola}.md => soubory_prekladu/html/{kapitola}
# ============================================================================
$(addprefix $(SOUBORY_PREKLADU)/html/,$(VSECHNY_KAPITOLY)): $(SOUBORY_PREKLADU)/html/%: kapitoly/%.md skripty/do_html.awk skripty/hlavni.awk skripty/utility.awk formaty/html
	mkdir -pv $(SOUBORY_PREKLADU)/html
	$(AWK) -f skripty/do_html.awk $< > $@

# 2. soubory_prekladu/html/{kapitola} => vystup_prekladu/html/{kapitola}.htm
# ============================================================================
$(addsuffix .htm,$(addprefix $(VYSTUP_PREKLADU)/html/,$(VSECHNY_KAPITOLY))): $(VYSTUP_PREKLADU)/%.htm: $(SOUBORY_PREKLADU)/% skripty/kapitola.awk
	mkdir -pv $(VYSTUP_PREKLADU)/html
	IDKAPITOLY=$(basename $(notdir $@)) NAZEVKAPITOLY="$(shell $(AWK) 'BEGIN {N = "Bez názvu";} /^# .+/ {N = substr($$0, 3);} END {print N;}' kapitoly/$(basename $(notdir $@)).md)" TELOKAPITOLY=$< $(AWK) -f skripty/kapitola.awk formaty/html > $@


# 3. vystup_prekladu/html/{kapitola}.htm => vystup_prekladu/html/index.htm
# ============================================================================
$(VYSTUP_PREKLADU)/html/index.htm: skripty/kniha.awk kapitoly.lst $(addsuffix .htm,$(addprefix $(VYSTUP_PREKLADU)/html/,$(VSECHNY_KAPITOLY))) $(VYSTUP_PREKLADU)/html/lkk.css
	SEZNAMKAPITOL=/dev/null $(AWK) -f skripty/kniha.awk formaty/html > $@

$(VYSTUP_PREKLADU)/html/lkk.css: formaty/html.css
	cat formaty/html.css > $(VYSTUP_PREKLADU)/html/lkk.css

kapitoly.lst:
	echo '# Seznam kapitol k vygenerování' > kapitoly.lst
	exec bash -c 'for X in $(VSECHNY_KAPITOLY); do echo "$$X" >> kapitoly.lst; done'

