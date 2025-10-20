COMPILE=typst
TARGET=repo
ROOT=..

CLASSNO=2
ZIP=zip

build: $(TARGET).typ ../template.typ ../bxbibwrite.typ
	$(COMPILE) compile $(TARGET).typ --root $(ROOT) assets/report$(CLASSNO).pdf

zip: ./assets
	$(ZIP) -r class$(CLASSNO).zip ./assets -i "*.c" "*.h" "*.pdf" "*Makefile"

.PHONY: build zip
