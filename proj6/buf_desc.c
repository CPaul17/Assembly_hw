//Name: Christopher Paul
//Date: 4/9/14
//email: cp11@umbc.edu
//Description: This file will be used to define all of the functions that will be
//             used in the project. The buf_desc struct is what the
//             project centers around and is what every function manipulates and
//             uses in the form of a linked list. Where the linked list acts as a
//             memory allocator and each node is free memory.


#include "buf_desc.h"


#ifndef HEXDUMP_COLS
#define HEXDUMP_COLS 8
#endif

buf_desc* HEAD;
unsigned int numItems;
unsigned int numUsed;

//parameters: N/A
//this function initializes ten buf_desc in a linked list for the program to use where
//  the buffer is null and len is 0 and the next points to another buf_desc
void init_buf_desc(){

	//make a pointer that will start the loop
	buf_desc* start;
	start = (buf_desc*)malloc(sizeof(buf_desc));
	assert(start != NULL);

	//the head will be the beginning of the linked list
	HEAD = start;

	int i;

	//loop through and free up memory for a linked list
	for(i = 0; i < 10; i++){

		start->buffer = NULL;
		start->len = 0;
		if(i != 9){
			start->next = (buf_desc*)malloc(sizeof(buf_desc));
			assert(start->next);
			start = start->next;
		}
	}

	//make the very last node's next equal to NULL
	start->next = NULL;
	numItems = 10;
	numUsed = 0;
}

//parameters: N/A
//this function initializes ten more buf_desc in a linked list for the program to use
//they are initialized the same way as init_buf_desc
void init_buf_desc_ten_more(){
	//make a pointer that will start the loop
	buf_desc* start;
	start = (buf_desc*)malloc(sizeof(buf_desc));
	assert(start != NULL);

	//make a temp pointer to keep track of beginning
	buf_desc* temp;
	temp = start;

	int i;

	//loop through and free up memory for a linked list
	for(i = 0; i < 10; i++){

		start->buffer = NULL;
		start->len = 0;
		//if we are making anything but the 10th node
		//go to the next node
		if(i != 9){
			start->next = (buf_desc*)malloc(sizeof(buf_desc));
			assert(start->next != NULL);
			start = start->next;
		}
		//if we are making the 10th node then have that point to the
		//  head and then have the temp (start of the new 10 series of nodes)
		//  be the new head
		else{
			start->next = HEAD;
			HEAD = temp;
		}
	}

	numItems = 20;
}



//parameters: N/A
//this function will grab an available memory address and return it to the caller
buf_desc* new_buf_desc(){

	buf_desc* temp;

	temp = HEAD;

	//the user wants a free linked list.
	//if the head is null and there are 10 itmes
	if(HEAD == NULL && numItems == 10){
		//create ten more items in the list
		init_buf_desc_ten_more();
		temp = HEAD;
		//move the head
		HEAD = HEAD->next;
		numUsed++;

		//make the temp fields NULL then give it to the user
		temp->next = NULL;
		temp->buffer = NULL;
		return temp;
	}

	//if the head is null
	else if(HEAD == NULL){
		return NULL;
	}

	//if the next head is NULL
	else if(HEAD->next != NULL){
		HEAD = HEAD->next;
		numUsed++;

		//make the temp fields NULL then give it to the user
		temp->next = NULL;
		temp->buffer = NULL;
		return temp;
	}

	//if next to head is NULL
	else{
		HEAD = NULL;
		numUsed++;

		//make the temp fields NULL then give it to the user
		temp->next = NULL;
		temp->buffer = NULL;


		return temp;

	}

}

//parameters: a pointer to a buf_desc struct instance
//this function will take the pointer given to it and will reset the fields of
//  that instance of the struct back to what it was when it held nothing
void del_buf_desc(buf_desc* buffer){

	buf_desc* temp = buffer;

	//as long as the temp is not null
	while(temp != NULL){
		numUsed--;
		//set the memory to NULL and len to 0
		buffer->buffer = NULL;
		buffer->len = 0;
		//now bring this node back into the linked list
		temp = buffer->next;
		buffer->next = HEAD;
		HEAD = buffer;
		buffer = temp;
	}

}

//parameters: N/A
//this function will check if there are 10 or fewer items current in use but 20 have
//   been malloc'd. In this instance clean_buf_desc() should free() 10 of the malloc()'d
//   entries from the available list
void clean_buf_desc(){
	int i;

	buf_desc* temp;

	temp = HEAD;

	//if there are 10 or less items used and 20 items have been allocated
	if(numUsed <= 10 && numItems == 20){

		//go through ten times to get rid of ten nodes
		for(i = 0; i < 10; i++){
			temp = HEAD;
			HEAD = HEAD->next;

			//set the buffer and next to NULL then free both
			temp->buffer = NULL;
			free(temp->buffer);
			temp->len = 0;
			temp->next = NULL;
			free(temp->next);
			//now free the temp itself
			free(temp);


		}

		//since we deleted 10 from the 20 we only have 10
		numItems = 10;

	}
}

//parameter: N/A
//this function will display the number of currently allocated buf_desc's, the number of
//    currently available fub_desc's and the addresses of the buf_desc's in the available
//    list
void dump_buf_desc(){

	buf_desc* temp;
	temp = HEAD;

	unsigned int unused;

	//if there are more than 10 items in the linked list
	if(numItems > 10){

		unused = 20 - numUsed;
	}
	else{
		unused = 10 - numUsed;
	}

	//print formatting for the output
	printf("Total allocated entries: %u \n", numItems);

	printf("Total available entries: %u \n", unused);

	printf("Addresses of available buf_structs: \n");
	//now print all of the memory addresses
	while(temp != NULL){

		printf("  %p \n", temp);
		temp = temp->next;


	}

}

//parameters: a node that is a pointer to a buf_desc
//this function will is the overall function that controls when the hex value of the buffer
//  is displayed and when the char value of the value is displayed
void hexdump_buf_desc(buf_desc* node){

	unsigned int count = 0;

	buf_desc* temp = node;

	unsigned int trigger = 1;

	//while the temp variable is not null
	while(temp != NULL){

		//we need to display the hex values first
		hexdump_buffer_hexDisplay(temp->buffer, temp->len, trigger);
		temp = temp->next;
		trigger = 0;

	}

	temp = node;

	while(temp != NULL){
		//now we can display the actual char values next
		hexdump_buffer_value(temp->buffer, temp->len);
		temp = temp->next;
	}

	printf("\n");


}

//parameters: a pointer to void, an unsigned integer named length, and trigger
//this function will display the actual hex values of the buffer and will display ever buffer in
//  series. ex. if the buffer is "1234" it will display 31 32 33 34
void hexdump_buffer_hexDisplay(void* mem, unsigned int len, unsigned int trigger){

	unsigned int i, j;

	//loop through
	for(i = 0; i < len + ((len % HEXDUMP_COLS) ? (HEXDUMP_COLS - len % HEXDUMP_COLS) : 0); i++)
    {
            /* print offset */
            if(i % HEXDUMP_COLS == 0 && trigger == 1)
            {
            	printf("0x%06x: ", i);

            }
            if(i % HEXDUMP_COLS == 0){

            }

            /* print hex data */
            if(i < len)
            {
            		//format output
            	    printf("%02x ", 0xFF & ((char*)mem)[i]);
            }

    }

}

//parameters: a pointer to void, an unsigned integer named length
//this function will display the actual char values of the buffer and will display it right in
//sequence right after the hex values
//  series. ex. if the buffer is "1234" it will display 1234 after the hex value
void hexdump_buffer_value(void *mem, unsigned int len){

	unsigned int i, j;
	// print ASCII dump

	for(i = 0; i < len + ((len % HEXDUMP_COLS) ? (HEXDUMP_COLS - len % HEXDUMP_COLS) : 0); i++){
		for(j = i - (HEXDUMP_COLS - 1); j <= i; j++)
		{
			if(j >= len) // end of block, not really printing
			{
			}
			else if(isprint(((char*)mem)[j])) // printable char
			{
				putchar(0xFF & ((char*)mem)[j]);
			}
			else // other char
			{
				putchar('.');
			}
		}
	}
}
