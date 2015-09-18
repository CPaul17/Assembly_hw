//Name: Christopher Paul
//Date: 4/9/14
//email: cp11@umbc.edu
//Description: This file will be used to declare all of the functions and structs
//             that will be defined in the c file. The buf_desc struct is what the
//             project centers around and is what every function manipulates and
//             uses in the form of a linked list. Where the linked list acts as a
//             memory allocator and each node is free memory.


#ifndef BUF_DESC_H
#define BUF_DESC_H

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>




typedef struct buf_desc{
	void* buffer;
	unsigned int len;
	struct buf_desc* next;

}buf_desc;

//parameters: a pointer to void, an unsigned integer named length
//this function will display the actual char values of the buffer and will display it right in
//sequence right after the hex values
//  series. ex. if the buffer is "1234" it will display 1234 after the hex values
void hexdump_buffer_value(void *mem, unsigned int len);

//parameters: a pointer to void, an unsigned integer named length, and trigger
//this function will display the actual hex values of the buffer and will display ever buffer in
//  series. ex. if the buffer is "1234" it will display 31 32 33 34
void hexdump_buffer_hexDisplay(void* mem, unsigned int len, unsigned int trigger);

//parameters: a node that is a pointer to a buf_desc
//this function will is the overall function that controls when the hex value of the buffer
//  is displayed and when the char value of the value is displayed
void hexdump_buf_desc(buf_desc* node);

//parameters: N/A
//this function initializes ten buf_desc in a linked list for the program to use
void init_buf_desc();

//parameters: N/A
//this function initializes ten more buf_desc in a linked list for the program to use
//they are initialized the same way as init_buf_desc
void init_buf_desc_ten_more();

//parameters: N/A
//this function will grab an available memory address and return it to the caller
buf_desc* new_buf_desc();

//parameters: a pointer to a buf_desc struct instance
//this function will take the pointer given to it and will reset the fields of
//  that instance of the struct back to what it was when it held nothing
void del_buf_desc(buf_desc* buffer);

//parameters: N/A
//this function will check if there are 10 or fewer items current in use but 20 have
//   been malloc'd. In this instance clean_buf_desc() should free() 10 of the malloc()'d
//   entries from the available list
void clean_buf_desc();

//parameter: N/A
//this function will display the number of currently allocated buf_desc's, the number of
//    currently available fub_desc's and the addresses of the buf_desc's in the available
//    list
void dump_buf_desc();


#endif
