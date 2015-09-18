; File: toupper.asm last updated 09/26/2001
; Minor updates to comments 02/05/2015
;
; Convert user input to upper case.
;
; Assemble using NASM:  nasm -f elf -g -F stabs toupper.asm
; Link with ld:  ld -o toupper toupper.o -melf_i386
;
;074646813720

%define STDIN 0
%define STDOUT 1
%define SYSCALL_EXIT  1
%define SYSCALL_READ  3
%define SYSCALL_WRITE 4
%define BUFLEN 256

;bl -> result or check_digit number
;ecx -> counter for how many times we loop through. Starts at 11 and decreases
;esi -> address to beginning of the the user input   ex 92848920   esi is at address of the character 9
;edi -> holds the beginning of the look up table
;al  -> holds the current character being looked at in the user input
;ah  -> holds the integer value of the current character being looked at in the user input
;ch  -> temp register for 10 - check_digit
;cl  -> holds the last character in the user input
;dl	 -> temp register to do a bitwise and . Where dl holds the value of al

        SECTION .data                   ; initialized data section

array: db 0, 3, 6, 9, 2, 5, 8, 1, 4, 7
arrayLen: equ $-array

msg1:   db "Enter 12-digit UPC: "           ; user prompt
len1:   equ $-msg1                      	; length of first message

msg2:   db "This is a valid UPC number. "   ; original string label
len2:   equ $-msg2                      	; length of second message

msg3:   db "This is NOT a valid UPC number" ; converted string label
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

read_OK:


L1_init:

		mov		edx, 0
		mov		bl , 0					; bl will be the current digit register
										;buf is pointer to the first digit of the user input
		mov		ecx, 11					;ecx is the counter for how many times we loop through
		mov		esi, buf				;esi now holds the buf pointer which points to the first digit of the user input
		mov		edi, array				;edi holds the beginning of the lookup table
L1_top:

		cmp		ecx, 0					;if the counter > 0 keep going
		je		L1_end					;if == 0 then we end

        mov     al, [esi]               ; get a character
        mov		ah, al					; make a copy
        ;sub 	ah, '0'					; make the digit a number
		sub		ah, 30

		mov		dl, ah
		;Check if even or odd
		and		dl, 1
		jnz		odd
		jz		even

odd:

		add		bl, ah					; bl = bl + al , this records the what the result plus the current digit
		cmp 	bl, 9					;is bl greater than 9
		inc		esi						;incriment the index of the buffer (the user input)
		dec 	ecx						;decriment the counter loop
		jg 		above_Nine				;if bl (the result) is greater than 9 then jump to above nine segment
		jl		L1_top					;if bl (the result) is less than 9 then we are done and jump to the loop

even:
		;find the lookup element
		;add it to the result register

		;add		edi, [esi]   		;look up table index = current lookup table index + current digit being looked at from user input

		add		edi, ah					;look up table index = current lookup table index + current digit(int) being looked at from user input

;		add		bl, [array + edi]
		add 	bl, [edi]				; result number = current result number + lookup table element

		sub		edi, ah				;set the look up table index back to the original
									;beginning look up table index = current lookup table index + current digit(int) being looked at from user input

		;mov		edi, buf

		inc		esi						;go to the next position of the user input
		dec		ecx						;decriment the loop counter
		cmp		bl, 9					;check if the result is equal to 9
		jg 		above_Nine				;if bl (the result) is greater than 9 then jump to above nine segment
		jl		L1_top					;if bl (the result) is less than 9 then we are done and jump to the loop

above_Nine:


		sub		bl, 10					; result = result - 10
		jmp 	L1_top					; go to the loop


L1_end:

		cmp 	bl, 10					;checck if the result is greater than 10
		jg		result_greater			;if so then go to result greater section
		jmp		compare_results			;if not then we just compare results

result_greater:
		mov		ch, 10					;create a temp register for 10
		sub		ch, bl					; temp = temp(which is 10) - result
		mov		bl, ch					;store result back in bl

compare_results:

		mov		esi, buf				;have esi hold the beginning of the user input
		mov		cl, [esi + 11]			;store the last character in a temp
		sub		cl, '0'					;make sure it is a digit

		cmp		bl, cl					;compare the result and the last digit
		je		is_equal				;if they are equal go to is_equal
		jmp		not_equal				;if they are not then go to not_equal


is_equal:

		mov     eax, SYSCALL_WRITE      ; write message
        mov     ebx, STDOUT
        mov     ecx, msg2
        mov     edx, len2
        int     080h


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



