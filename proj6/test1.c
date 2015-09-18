/*
 * main6.c
 *
 *  Created on: Apr 9, 2015
 *      Author: Christopher Paul
 */

#include <stdio.h>
#include "buf_desc.h"

int main()
{
    int i;
    init_buf_desc();

    buf_desc *buf = new_buf_desc();
    buf->buffer = "1234";
    buf->len = 4;

    buf_desc *buf2 = new_buf_desc();
    buf2->buffer = "5678";
    buf2->len = 4;

    buf->next = buf2;

    buf_desc *buf3 = new_buf_desc();
    buf3->buffer = "2122";
    buf3->len = 4;

    buf2->next = buf3;


    hexdump_buf_desc(buf);

    dump_buf_desc();

    del_buf_desc(buf);

    dump_buf_desc();

    buf = new_buf_desc();
    buf2 = buf;

    for (i = 0; i < 10; i++)
    {
        buf2->next = new_buf_desc();
        buf2 = buf2->next;
    }

    dump_buf_desc();

    clean_buf_desc();

    dump_buf_desc();


    buf2 = buf->next;
    buf->next = NULL;
    del_buf_desc(buf);
    buf2->next;
    buf2->next = NULL;
    del_buf_desc(buf2);
    dump_buf_desc();

    clean_buf_desc();

    dump_buf_desc();
    return 0;
}
