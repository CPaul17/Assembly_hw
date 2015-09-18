
/*
CC=gcc
AS=nasm
CFLAGS=-m32 -g -pthread
ASFLAGS=-f elf -g -F dwarf

.PREFIXES= .c .o

ALL_TARGETS=main8

C_SOURCE=main8.c rot13_dev.c

C_OBJECTS=${C_SOURCE:.c=.o}

all: ${ALL_TARGETS}

%.o: %.c
	${CC} -fno-stack-protector -c ${CFLAGS} $< -o $@

main8.o: main8.c rot13_dev.h

rot13_dev.o: rot13_dev.c rot13_dev.h

main8: main8.o rot13_dev.o
	${CC} ${CFLAGS} -o $@ main8.o rot13_dev.o

clean:
	rm -f *.o ${ALL_TARGETS}

*/

#include <stdlib.h>
#include <stdio.h>
#include "rot13_dev.h"

//void *init_rot13_dev(void (*interrupt_fn)(void *data), void *data){

typedef struct Map{

	int flags;
	int input;
	int output;

	//int targetCounter;
	//int currentCounter;

}Map;

typedef struct Counter{

	Map* bitmap;
	int targetCounter;
	int currentCounter;

}Counter;

void ISR(void* mem){



	Counter* map = (Counter*)mem;

//	if(map->targetCounter != map->currentCounter){

//		while(map->bitmap->flags & 2 != 1){
//		}

	printf("%c", (char)map->bitmap->output);

	map->bitmap->flags = map->bitmap->flags ^ 2;

	//map->currentCounter++;


//	}

	map->currentCounter--;
	map->bitmap->flags = map->bitmap->flags ^ 8;

//	*(mem + )

//	((int)mem & 0) = 1;
//	(*mem & 0) = 1;
}


int main(){

	char str[20];
	int size;
	Map* memory;
	Counter count;


	int i = 0;
	unsigned int bool = 1;
	unsigned int bool2 = 1;

	count.targetCounter = 0;
	count.currentCounter = 0;

	memory = init_rot13_dev( ISR,  &count);
	count.bitmap = memory;




//	if( *(memory) & 0 == 1){
//	if( ((int)memory) & 1 == 1){

		do{
			memory->flags = memory->flags | 4;

			printf("Input to ROT13 (ENTER to exit) \n");

			fgets(str, sizeof(str), stdin);

			count.currentCounter = 0;
//			count.targetCounter = sizeof(str);

			while(bool == 1){

				//printf("entering big while loop \n");
				while((memory->flags & 1) == 1){

				}


				if(str[i] == '\0'){
					//printf("stop looping through letters \n");
					bool = 0; //stop the loop through characters in a string
				}

				else{
					//printf("going to next character \n");

					memory->input = str[i];

					count.currentCounter++;

					memory->flags = memory->flags | 1;

					while(count.currentCounter != 0){

					}

					i++;

				}


//			if(((*memory) & 0) == 1){
//				if(((*memory) & 1) == 1){
//					i++;
//					*(memory + 4) = str[i];
//				}

			}
			i = 0;
			bool = 1;

//		printf("%s", str);

//			if(count.targetCounter == count.currentCounter){
//				str[0] = '\n';

//			}

		}while(str[0] != '\n');

//	}
	return 1;

}
