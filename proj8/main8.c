//Name: Christopher Paul
//Date: 4/28/15
//email: cp11@umbc.edu
//Description: This is the main file for this project where we grab the data that is given
//             to us from a function called rot13initdev and feed in input to this function.
//             Here I have to manipulate the bits in order to manipulate the code that is going on
//             in the background.

#include <stdlib.h>
#include <stdio.h>
#include "rot13_dev.h"

//struct that sets up the bitmap for the whole project
typedef struct Map{

	int flags;
	int input;
	int output;

}Map;

//struct that uses counters in order to manipulate the bitmap
typedef struct Counter{

	Map* bitmap;
	int currentCounter;
	int beginning;

}Counter;

//paramters: pointer to a void
//this function is called by the o file and will output to the user the rot 13 of their input
void ISR(void* mem){

	//cast the parameter to be a pointer to a struct Counter
	Counter* map = (Counter*)mem;

	//print out the letter
	printf("%c", (char)map->bitmap->output);

	//make sure to the set the flags
	map->bitmap->flags = map->bitmap->flags ^ 2;
	map->bitmap->flags = map->bitmap->flags ^ 8;

	//we are done so we this will main so
	map->currentCounter--;


}


int main(){

	//set everything up for the main algorithm to work
	char str[20];
	int size;
	Map* memory;
	Counter count;

	//set everything up for the main algorithm to work
	int i = 0;
	unsigned int bool = 1;
	unsigned int bool2 = 1;
	count.beginning = 0;
	count.currentCounter = 0;

	//get the memory map
	memory = init_rot13_dev( ISR,  &count);
	//set it equal to the bitmap in the counter struct
	count.bitmap = memory;

	//keep doing this till the user enters only a newline
	do{
		//get ready
		memory->flags = memory->flags | 4;

		//ask the user for input
		printf("Input to ROT13 (ENTER to exit) \n");

		//get the input
		fgets(str, sizeof(str), stdin);

		//set the counters and beginning flag to 0
		count.currentCounter = 0;
		count.beginning = 0;

		//while flag is true
		while(bool == 1){

			//while the input ready bit equals 1
			while((memory->flags & 1) == 1){

			}

			//if the user entered in only a newline
			if(str[i] == '\0'){
				bool = 0; //stop the loop through characters in a string
			}

			else{

				//if this is the first character being looked at in a phrase
				if(count.beginning == 0){
					printf("ROT13 String: ");
				}

				//set beginning to 1 now
				count.beginning = 1;

				//put the input in the input field of the struct
				memory->input = str[i];

				//increase the current counter to 1
				count.currentCounter++;

				//this is where the other code will be triggered to run
				memory->flags = memory->flags | 1;

				//while it is still processing
				//current Counter is incremented before the ISR is called and once ISR is called it is decremented
				//this is to ensure that the ISR was called
				while(count.currentCounter != 0){

				}

				i++;

			}
		}
		//format
		printf("\n");

		//make sure we can do this more than once if needed
		count.beginning = 0;
		i = 0;
		bool = 1;

	}while(str[0] != '\n');

	return 1;

}
