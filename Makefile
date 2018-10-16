RGBASM := rgbasm
RGBGFX := rgbgfx
RGBLINK := rgblink
RGBFIX := rgbfix

ROM := crystal_clear_modified.gbc
BASEROM := i_made_this.gbc

OBJS := main.o

.PHONY: all

all: $(ROM)

$(ROM): $(OBJS) | $(BASEROM)
	$(RGBLINK) -d -n $(@:.gbc=.sym) -O $(BASEROM) -o $@ $<

%.o: %.asm
	$(RGBASM) -o $@ $<

$(BASEROM):
	@echo "Please obtain a copy of Crystal Clear 2.0 and put it in this directory as $@"
	@exit 1
