ifndef TARGET
$(error TARGET variable is required)
endif

ifndef KAKASI_ROOT
$(error KAKASI_ROOT variable is required)
endif

include scripts/targets/$(TARGET).mk

CFLAGS += -g
CFLAGS += -I$(KAKASI_ROOT)/include

lib/kanji_to_katakana.$(DYLIB): kanji_to_katakana.$(O)
	@echo "[$@]"
	LDFLAGS="$(LDFLAGS)" ruby scripts/link.rb $< $(KAKASI_ROOT)/lib/libkakasi.a $@
CLEAN += lib/kanji_to_katakana.$(DYLIB)

lib/kanji_to_katakana/platform.rb:
	@echo "[$@]"
	echo "KanjiToKatakana::PLATFORM = '$(TARGET)'" > $@
CLEAN += lib/kanji_to_katakana/platform.rb

kanji_to_katakana.$(O): src/kanji_to_katakana.c
	@echo "[$@]"
	CFLAGS="$(CFLAGS)" ruby scripts/compile.rb $< $@
CLEAN += kanji_to_katakana.o

clean:
	rm -rf $(CLEAN)

test: lib/kanji_to_katakana.$(DYLIB) lib/kanji_to_katakana/platform.rb
	rspec

.PHONE: clean test
$(V).SILENT: