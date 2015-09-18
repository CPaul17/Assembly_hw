//Christopher Paul
//email: cp11@umbc.edu
//date: 4/1/15
//description: this file sets up the struct and variables needed for the methods that
//  		   will be defined in book_info_heap.c

#ifndef BOOK_INFO_HEAP_H
#define BOOK_INFO_HEAP_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct book_info{
	char title[50];
	char author[40];
	unsigned int year_published;
}book_info;

static book_info GLOBAL_ARRAY[20];

static int HEAD;

#endif
