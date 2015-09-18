################################################################
#
# Makefile for subroutines lecture
# Last Edited 2/18/2015
#
################################################################

#TARGET = proj1
#all: $(TARGET).o
#	/home/cpaul/Documents/313/proj2 $(TARGET).o -o $(TARGET)

#$(TARGET).o: $(TARGET).asm
#	nasm -f elf $(TARGET).asm
#	gcc -m32 -g -o $(TARGET) 


CC=gcc
AS=nasm
LD=ld
MAKE=make
ASFLAGS=-f elf -g -F dwarf
LDFLAGS=-melf_i386
CCFLAGS =-m32 -g -o

.PREFIXES= .c .o .asm

ASM_SOURCE= rpntest2.asm

ALL_TARGETS=rpntest2

all: ${ALL_TARGETS}

rpntest2.o: rpntest2.asm
	${AS} ${ASFLAGS} $< -o $@

rpntest2: rpntest2.o
	${CC} ${CCFLAGS}  $@ $<

clean:
	rm -f *.o ${ALL_TARGETS}

