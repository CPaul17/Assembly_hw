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

	book_info* book;


	for(i = 0; i < 20; i++){
		//to set a char pointer (array) to null you have to set the first character to null (\0)
		//usually the \0 is at the end of the char array to denote the end of the string.
		//by having it at the beginning you are denoting it is an empty string


		printf("this is i: %d \n", i);

		//memset(GLOBAL_ARRAY[i].author, '\0', 50);

		//memset(GLOBAL_ARRAY[i].title, '\0', 50);


		GLOBAL_ARRAY[i].author[0] = '\0';

		GLOBAL_ARRAY[i].title[0] = '\0';

		GLOBAL_ARRAY[i].year_published = i+1;
		//printf("this is year published: %u", book->year_published);

	}
	GLOBAL_ARRAY[19].year_published = -1;

	HEAD = GLOBAL_ARRAY[0];
}


//parameters: none
//this function will always return the FIRST availability in memory
//this means that it will grab the frist availability if it exists and return it
//nothing else needs to be done since there is nothing before it in the sequence (it is the first)
//and whatever is next already has something it's pointing to or is a negative number to signify the end



book_info* new_book_info(){

	book_info freeArr;

	//if there is no empty variable
	if(HEAD.year_published == -2){
		return NULL;
	}

	//if there is then do the below

	//store the next available index
	int next = HEAD.year_published;

	printf("this is the next in array: %d", next);

	book_info* currentHead = &HEAD;

	//book_info book;
	//book.author[0] = '\0';
	//book.title[0] = '\0';
	//book.year_published = -2;


	//if the head is the last available memory
	if(next == -1){
		book_info book;
		book.author[0] = '\0';
		book.title[0] = '\0';
		book.year_published = -2;

		//when it's -2 that means there is no available memory
		HEAD = book;
		return currentHead;
	}

	//if next is > -1 then there's more than one available memory
	else{

		//store the next head memory
		HEAD = GLOBAL_ARRAY[next];

		printf("this is year_published: %u", currentHead->year_published);

		if(currentHead->title[0] == '\0'){
			printf("Title is NUL");
		}

		return currentHead;
	}

}


void dump_heap(){
	int i;
	printf("*** BEGIN HEAP DUMP *** \n");
	printf("head: %u \n", HEAD.year_published);
	//printf("pipipipipipi\n");


	for(i = 0; i < 20; i++){
		//printf("  %d: %d, %s, %s", i, GLOBAL_ARRAY[i].year_published, GLOBAL_ARRAY[i].title, GLOBAL_ARRAY[i].author );
		printf("i : %d \n", i);
		printf("year: %u \n", GLOBAL_ARRAY[i].year_published);
		printf("title: %s \n", GLOBAL_ARRAY[i].title);
		printf("author: %s \n", GLOBAL_ARRAY[i].author);
		printf("not seg fault \n");
	}
	printf("*** END HEAP DUMP ***\n");
}









/*

//Your del_book_info() function should do some error checking and make sure that the pointer passed to it is actually pointing to an item in your
//global array and not some random place in memory.  If it detects an error, it should display an error string and exit the program immediately.
void del_book_info(book_info* info){

	book_info* freeSpace;

	//this is the exact index of where info appears in the global_array
	int index = findIndex(info);

	info->author = '\0';
	info->title = '\0';

	//find the previous free position before the index
	int prevIndex = findPrevIndex(index);

	//find the next free position after index
	int nextIndex = findNextIndex(index);

	//if there exist a memory location before and after the target index
	if(prevIndex > -1 && nextIndex > -1){
		//make the previous point to the current and the current to the next
		GLOBAL_ARRAY[prevIndex]->year_published = index;
		GLOBAL_ARRAY[index]->year_published = nextIndex;
	}

	//if there exist a memory location before but not after
	//that means that the current index will become the end of the list of free memory
	else if(prevIndex > -1 && nextIndex <  0){

	}
	//if there was something that was available before the position index
	if(prevIndex > -1){
		//now find the next free position after the specified index


	}
	//if there was nothing before it
	//this will become the first link in the linked list of free memory
	else{

	}
}
*/

