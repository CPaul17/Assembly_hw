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

ALL_TARGETS=rpntest2

ASM_SOURCE=rpntest2.asm

ASM_OBJECTS=${ASM_SOURCE:.asm=.o}

all: ${ALL_TARGETS}

%.o: %.asm
	${AS} ${ASFLAGS} $< -o $@

rpntest2: rpntest2.o
	${LD} ${LDFLAGS} -o $@ $<

clean:
	rm -f *.o ${ALL_TARGETS} *.lst

