; File: proj1.asm	by Christopher Paul
;email: cp11@umbc.edu
;date: 2/19/15
;
;This program takes in user input to make sure that the user input is a valid UPC number
;
;
; Assemble using NASM:  nasm -f elf -g -F stabs toupper.asm
; Link with ld:  ld -o toupper toupper.o -melf_i386
;
;

%define STDIN 0
%define STDOUT 1
%define SYSCALL_EXIT  1
%define SYSCALL_READ  3
%define SYSCALL_WRITE 4
%define BUFLEN 256


        SECTION .data                   ; initialized data section

;we need a lookup array
array: db 0, 3, 6, 9, 2, 5, 8, 1, 4, 7
arrayLen: equ $-array

msg1:   db "Enter 12-digit UPC: "           ; user prompt
len1:   equ $-msg1                      	; length of first message

msg2:   db "This is a valid UPC number. ", 10   ; original string label
len2:   equ $-msg2                      	; length of second message

msg3:   db "This is NOT a valid UPC number", 10 ; converted string label
len3:   equ $-msg3

        SECTION .bss                    ; uninitialized data section


buf:    resb BUFLEN                     ; buffer for read
temp:   resb 16                        ; temp variable to move things around
result: resb 16							; result variable holds the final digit

        SECTION .text                   ; Code section.
        global  _start                  ; let loader see entry point

_start: nop                             ; Entry point.
start:                                  ; address for gdb

        ; prompt user for input

        mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, STDOUT             ; Arg1: file descriptor
        mov     ecx, msg1               ; Arg2: addr of message
        mov     edx, len1               ; Arg3: length of message
        int     080h                    ; ask kernel to write

        ; read user input
        ;
        mov     eax, SYSCALL_READ       ; read function
        mov     ebx, STDIN              ; Arg 1: file descriptor
        mov     ecx, buf                ; Arg 2: address of buffer
        mov     edx, BUFLEN             ; Arg 3: buffer length
        int     080h

       ;no error check needed. we assume it is correct
       ;buf holds the user input


L1_init:

		mov		bl , 0					;bl will be the current digit register
										;buf is pointer to the first digit of the user input
		mov		dh, 0					;dh is the counter for how many times we loop through
		mov		esi, buf				;esi now holds the buf pointer which points to the first digit of the user input
		mov		edi, array				;edi holds the beginning of the lookup table
L1_top:


		;cmp		dh, 11					;if the counter < 11 keep going
		;je		L1_end					;if == 0 then we end

        mov     al, [esi]               ; get a character

        sub 	al, '0'					; make the digit a number

		cmp		dh, 11					;if the counter < 11 keep going
		je		L1_end					;if == 0 then we end

		mov		dl, dh					;Check if even or odd
		and		dl, 1
		jnz		odd
		jz		even

odd:

		add		bl, al					; bl = bl + al , this records the what the result plus the current digit
		inc		esi						;incriment the index of the buffer (the user input)
		inc 	dh						;incriment the counter loop
		cmp 	bl, 9					;is bl greater than 9
		je		L1_top
		jb		L1_top					;if bl (the result) is less than 9 then we are done and jump to the loop
		ja 		above_Nine				;if bl (the result) is greater than 9 then jump to above nine segment
even:

		add		edi, eax				;look up table index = current lookup table index + current digit(int) being looked at from user input

		add 	bl, [edi]				; result number = current result number + lookup table element

		sub		edi, eax				;set the look up table index back to the original
										;beginning look up table index = current lookup table index + current
										;digit(int) being looked at from user input

		inc		esi						;go to the next position of the user input
		inc		dh						;incriment the loop counter
		cmp		bl, 9					;check if the result is equal to 9
		je		L1_top					;if bl is equal to 9                   ;;;;;;;;;;;;;;;;;;;;;it keeps jumping to above nine when    cmp   bl,9 is 9 == 9
		jb		L1_top					;if bl (the result) is less than 9 then we are done and jump to the loop
		ja 		above_Nine				;if bl (the result) is greater than 9 then jump to above nine segment

above_Nine:


		sub		bl, 10					; result = result - 10
		jmp 	L1_top					; go to the loop


L1_end:

		cmp 	bl, 0					;checck if the result is greater than 10
		jg		result_greater			;if so then go to result greater section
		jmp		compare_results			;if not then we just compare results

result_greater:
		mov		ch, 10					;create a temp register for 10
		sub		ch, bl					; temp = temp(which is 10) - result
		mov		bl, ch					;store result back in bl

compare_results:


		cmp		bl, al					;compare the result and the last digit
		je		is_equal				;if they are equal go to is_equal
		jmp		not_equal				;if they are not then go to not_equal


is_equal:

		mov     eax, SYSCALL_WRITE      ; write message
        mov     ebx, STDOUT
        mov     ecx, msg2
        mov     edx, len2
        int     080h
		jmp		exit

not_equal:


        ; print out user input for feedback
        ;
        mov     eax, SYSCALL_WRITE      ; write message
        mov     ebx, STDOUT
        mov     ecx, msg3
        mov     edx, len3
        int     080h

exit:   mov     eax, SYSCALL_EXIT       ; exit function
        mov     ebx, 0                  ; exit code, 0=normal
        int     080h                    ; ask kernel to take over



