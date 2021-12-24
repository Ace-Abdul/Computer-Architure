# some Makefile magic to identify all .s files and build them into .lgsim files

# find all .s
SRCS=$(wildcard *.s)
# string replace so they're .imem.lgsim files -- these are our targets
OUTS=$(SRCS:.s=.imem.lgsim)

# all the targets as computed based on .s files found above
all: $(OUTS)

# recipe to convert .s to .imem.lgsim (used for all .s sources)
.s.imem.lgsim:
	../asm-sim/asm $<

# let make know that we're dealing with these weird extensions
.SUFFIXES : .s .imem.lgsim

# copy test code to the ../tests directory (USE ONLY DURING KIT DEVELOPMENT -- STUDENTS: DON'T USE THIS)
promote:
	cp *.lgsim ../tests/

clean:
	rm -f *.imem.lgsim *.dmem.lgsim 

