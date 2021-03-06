; Christopher Paul
; 02/21/2015

;does

;in order to pop off the stack you need to
;add	esp, 4 * numberofpushes           (I think 4 is in bytes)

;FOR THIS FILE YOU NEED TO ENTER IN YOUR INPUT BUT PRESS SPACE RIGHT AFTER

;INPUT MUST END WITH SPACE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

; Assemble using NASM:  nasm -f elf -g -F dwarf libc_example.asm
; Link with gcc:  gcc -m32 -g -o libc_example libc_example.o


;Get user input
;copy user input into a variable
;go character by character and count the amount of spaces
;store in a variable
;set the buffer variable back to the beginning of the user input
;loop the same number of times we have spaces
;	First line of loop should compare if it is a ' +, -, /, *'
;	If it is then jump to separate section
;		Pop off the two variables and do the appropriate operation (Pop register/memory -> this
;		pops whatever is on top of the stack and stores it in the parameter

;		Do an operation then put the results back on the stack

%define STDIN 0
%define STDOUT 1
%define SYSCALL_EXIT  1
%define SYSCALL_READ  3
%define SYSCALL_WRITE 4
%define BUFLEN 256


        SECTION .data                   ; initialized data section

;we need a lookup array

prompt:	db "Expression to calculate: ", 0	;this is the string we want to prompt the user
prompt_len: equ $-prompt

output: db "Result: %d ", 10, 0
output_len: equ $-output


        SECTION .bss                    ; uninitialized data section


input:    resb BUFLEN                     ; buffer for read
temp:   resb 16                        ; temp variable to move things around
num_spaces: resb 22							; result variable holds the final digit


        SECTION .text                   ; Code section.

extern printf							; Request access to printf
extern atoi								; Request access to atoi


        global  main					; let loader see entry point

main: nop                             	; Entry point- note NOT _start anymore
start:                                  ; address for gdb



;do i have to make a function that counts how many spaces there are and store it to a variable
;then loop and do atoi and arithmetic based on it and the symbols?

        ; prompt user for input

        mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, STDOUT             ; Arg1: file descriptor
        mov     ecx, prompt             ; Arg2: addr of message
        mov     edx, prompt_len         ; Arg3: length of message
        int     080h                    ; ask kernel to write

        ; read user input
        ;
        mov     eax, SYSCALL_READ       ; read function
        mov     ebx, STDIN              ; Arg 1: file descriptor
        mov     ecx, input              ; Arg 2: address of buffer
        mov     edx, BUFLEN             ; Arg 3: buffer length
        int     080h


		mov		esi, input				;keep the addressing in a register
;		mov		ebx, esi				;keep a copy
		mov		ebx, 0
		mov		ecx, 0
		mov		edx, 0


;I must include at least one subroutine (function with return)

While_Loop:

		;can you only push 32 bit registers on the stack???????????????????


		mov		ebx, [esi]				;get the first letter

		cmp		ebx, 0				;if we have reached the end of the user input
		je		end_of_input

		cmp		ebx, '+'					;if + then do addition
		je		Addition
		cmp		ebx, '-'					;if - then do subtraction
		je		Subtraction
		cmp		ebx, '/'					;if / then do division
		je		Division
		cmp		ebx, '*'					;if * then do multiplication
		je		Multiply

		push 	ebx
		inc		esi
		jmp 	While_Loop





Addition:

		pop		ecx
		pop		edx
		add		ecx, edx
		push	ecx
		inc		esi
		jmp		While_Loop


Subtraction:

		pop		ecx
		pop		edx
		sub		ecx, edx
		push	ecx
		inc		esi
		jmp		While_Loop



Division:

		pop		ecx
		pop		edx
;		idiv	ecx, edx
		idiv	edx 					;does this divide correctly?
										;online it says that it would take
										;ecx/ edx
		push	ecx
		inc		esi
		jmp		While_Loop


Multiply:

		pop		ecx
		pop		edx
		imul	ecx, edx
		push	ecx
		inc		esi
		jmp		While_Loop




end_of_input:

		push	output
		call 	printf
		add		esp, 8


;        mov     esi, input		    	; Get address of numbers string
;        push	esi						; Push address onto stack
;        call	atoi					; Call atoi
        								; The resulting number is in eax

;        add		esp, 4					; Remove esi from the stack
;        push	eax						; Push the result of atoi onto the stack
;        push	output   				; Push the address of the formatted string onto the stack
;        call	printf					; Call printf on the string
        								; Output should be: Returned number: 52

;        add		esp, 8					; Remove message and previous atoi conversion from the stack


        ; final exit
        ;
exit:   mov     eax, SYSCALL_EXIT       ; exit function
        mov     ebx, 0                  ; exit code, 0=normal
        int     080h                    ; ask kernel to take over

