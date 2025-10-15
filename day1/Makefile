COMPILE=typst
TARGET=repo
ROOT=..

build: $(TARGET).typ ../template.typ ../bxbibwrite.typ
	$(COMPILE) compile $(TARGET).typ --root $(ROOT)

.PHONY: build
