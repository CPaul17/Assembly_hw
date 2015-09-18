################################################################
#
# Makefile for rpntest
# Last Edited 2/15/2015
#
################################################################

AS=nasm
LD=gcc
ASFLAGS=-f elf -g -F dwarf
LDFLAGS=-m32 -g
.PREFIXES= .o .asm

ALL_TARGETS=cpntestneg

ASM_SOURCE=cpntestneg.asm

ASM_OBJECTS=${ASM_SOURCE:.asm=.o}

all: ${ALL_TARGETS}

%.o: %.asm
	${AS} ${ASFLAGS} $< -o $@

cpntestneg: cpntestneg.o
	${LD} ${LDFLAGS} -o $@ $<

clean:
	rm -f *.o ${ALL_TARGETS} *.lst

