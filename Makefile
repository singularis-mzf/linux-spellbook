VSECHNY_KAPITOLY := _ukazka docker make gawk
SOUBORY_PREKLADU := soubory_prekladu
VYSTUP_PREKLADU := vystup_prekladu
AWK := gawk

.PHONY: all clean

all: html log

clean:
	$(RM) -R $(SOUBORY_PREKLADU) $(VYSTUP_PREKLADU)

html: $(VYSTUP_PREKLADU)/html/index.htm

log: $(VYSTUP_PREKLADU)/log/index.log

# HTML:

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


# 3. vystup_prekladu/html/{kapitola}.htm => vystup_prekladu/html/index.htm (provizorní)
# ============================================================================
$(VYSTUP_PREKLADU)/html/index.htm: skripty/kniha.awk kapitoly.lst $(addsuffix .htm,$(addprefix $(VYSTUP_PREKLADU)/html/,$(VSECHNY_KAPITOLY))) $(VYSTUP_PREKLADU)/html/lkk.css kapitoly.lst
	SEZNAMKAPITOL=kapitoly.lst VSTUPPREFIX=$(VYSTUP_PREKLADU)/html/ VSTUPSUFFIX=.htm $(AWK) -f skripty/kniha.awk formaty/html > $@
	cp -Rv obrazky $(VYSTUP_PREKLADU)/html/

# 4. formaty/html.css => vystup_prekladu/html/lkk.css
# ============================================================================
$(VYSTUP_PREKLADU)/html/lkk.css: formaty/html.css
	cat formaty/html.css > $(VYSTUP_PREKLADU)/html/lkk.css


# LOG:

# 1. kapitoly/{kapitola}.md => soubory_prekladu/log/{kapitola}
# ============================================================================
$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_KAPITOLY)): $(SOUBORY_PREKLADU)/log/%: kapitoly/%.md skripty/do_logu.awk skripty/hlavni.awk skripty/utility.awk formaty/log
	mkdir -pv $(SOUBORY_PREKLADU)/log
	$(AWK) -f skripty/do_logu.awk $< > $@

# 2. soubory_prekladu/log/{kapitola} => soubory_prekladu/log/{kapitola}.kap
# ============================================================================
$(addsuffix .kap,$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_KAPITOLY))): %.kap: % skripty/kapitola.awk
	mkdir -pv $(SOUBORY_PREKLADU)/log
	IDKAPITOLY=$(basename $(notdir $@)) NAZEVKAPITOLY="$(shell $(AWK) 'BEGIN {N = "Bez názvu";} /^# .+/ {N = substr($$0, 3);} END {print N;}' kapitoly/$(basename $(notdir $@)).md)" TELOKAPITOLY=$< $(AWK) -f skripty/kapitola.awk formaty/log > $@

# 3. soubory_prekladu/log/{kapitola}.kap => vystup_prekladu/log/index.log
# ============================================================================
$(VYSTUP_PREKLADU)/log/index.log: $(addsuffix .kap,$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_KAPITOLY))) kapitoly.lst
	mkdir -pv $(VYSTUP_PREKLADU)/log
	SEZNAMKAPITOL=kapitoly.lst VSTUPPREFIX=$(SOUBORY_PREKLADU)/log/ VSTUPSUFFIX=.kap $(AWK) -f skripty/kniha.awk formaty/log > $@
#	cat $(addsuffix .kap,$(addprefix $(SOUBORY_PREKLADU)/log/,$(VSECHNY_KAPITOLY))) > $@


kapitoly.lst:
	echo '# Seznam kapitol k vygenerování' > kapitoly.lst
	exec bash -c 'for X in $(VSECHNY_KAPITOLY); do echo "$$X" >> kapitoly.lst; done'

