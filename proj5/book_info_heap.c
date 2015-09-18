//Christopher Paul
//email: cp11@umbc.edu
//date: 4/1/15
//description: This file is the main file of the program that defines all of the methods that will be used
// 	 	 	   This is where init_heap, del_book, dump_heap, and del_book_info and defined to make the main
// 			   work properly.

#include "book_info_heap.h"
#include <stdio.h>

//LAST POSITION'S YEAR PUBLISHED IN THE ARRAY IS EQUAL TO -1
//DOES THIS FACT AFFECT MY CODE???????


//go through each index and make the year_published (what our next is) equal to the next index that
//is free in the array   ex. if index 3 is taken and filled with information then GLOBAL_ARRAY[2]->year_published = 4
//if we want to find out what the next free memory is: We keep incrementing till we find a year_published < 20 and the other fields are null

void init_heap(){
	int j;
	unsigned int i;

	for(i = 0; i < 20; i++){
		//to set a char pointer (array) to null you have to set the first character to null (\0)
		//usually the \0 is at the end of the char array to denote the end of the string.
		//by having it at the beginning you are denoting it is an empty string

		GLOBAL_ARRAY[i].author[0] = '\0';

		GLOBAL_ARRAY[i].title[0] = '\0';

		GLOBAL_ARRAY[i].year_published = i+1;

	}
	GLOBAL_ARRAY[19].year_published = -1;

	HEAD = 0;
}


//parameters: none
//this function will always return the FIRST availability in memory
//this means that it will grab the first availability if it exists and return it
//nothing else needs to be done since there is nothing before it in the sequence (it is the first)
//and whatever is next already has something it's pointing to or is a negative number to signify the end



book_info* new_book_info(){

	book_info freeArr;

	//if there is no empty variable
	if(HEAD == -2){
		return NULL;
	}

	//if there is then do the below

	//store the next available index
	int next = GLOBAL_ARRAY[HEAD].year_published;

	book_info* currentHead = &GLOBAL_ARRAY[HEAD];

	//if the head is the last available memory
	if(next == -1){

		//when it's -2 that means there is no available memory
		HEAD = -2;
		return currentHead;
	}

	//if next is > -1 then there's more than one available memory
	else{

		//store the next head memory
		HEAD = next;
		return currentHead;
	}

}

//parameters: N/A
//this function prints out every member variable of of every element of the global array of structs
void dump_heap(){
	int i;
	printf("*** BEGIN HEAP DUMP *** \n");
	printf("head: %u \n", HEAD);


	//loop through each index
	for(i = 0; i < 20; i++){

		//this is for formating
		if(i < 10){
			printf("  %d: %u, %s, %s \n", i, GLOBAL_ARRAY[i].year_published, GLOBAL_ARRAY[i].title, GLOBAL_ARRAY[i].author );
		}
		//this is for formating
		else{
			printf(" %d: %u, %s, %s \n", i, GLOBAL_ARRAY[i].year_published, GLOBAL_ARRAY[i].title, GLOBAL_ARRAY[i].author );

		}

	}
	printf("*** END HEAP DUMP ***\n");
}



//Your del_book_info() function should do some error checking and make sure that the pointer passed to it is actually pointing to an item in your
//global array and not some random place in memory.  If it detects an error, it should display an error string and exit the program immediately.
void del_book_info(book_info* info){

	book_info* start = &GLOBAL_ARRAY[0];

	int offset;

	//will give a num from 0 - 19
	offset = info - start;

	//make sure it is a valid number
	if(offset < 20 && offset > -1){

		book_info* location = &GLOBAL_ARRAY[offset];

		//set the author and title to be NULL
		location->author[0] = '\0';
		location->title[0] = '\0';

		//this node is the new head
		location->year_published = HEAD;

		HEAD = offset;


	}
}



