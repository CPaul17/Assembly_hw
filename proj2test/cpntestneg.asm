; Christopher Paul project 2 rpn calculator
; 02/21/2015

; Assemble using NASM:  nasm -f elf -g -F dwarf libc_example.asm
; Link with gcc:  gcc -m32 -g -o libc_example libc_example.o


%define STDIN 0
%define STDOUT 1
%define SYSCALL_EXIT  1
%define SYSCALL_READ  3
%define SYSCALL_WRITE 4
%define BUFLEN 256


        SECTION .data                   ; initialized data section

;we need a lookup array

prompt:	db "Expression to calculate: "	;this is the string we want to prompt the user
prompt_len: equ $-prompt

output: db "Result: %d ", 10 			; this is the string that is outputed to the user
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


		mov		esi, input				;keep the address in a register
		mov		ebx, 0 					;results register that will keep track of the final number
		mov		ecx, 0 					;
		mov		edx, 0 					;this will be the temp register


;I must include at least one subroutine (function with return)

While_Loop:


		mov 	cl, [esi]

		cmp 	cl, 10 					;check if we have reached the end of the input
		je		Done 					;if so then jump

		cmp 	cl, '+'					;if the current address is an addition symbol
		je 		Addition 				;jump to the addition portion of the program

		cmp 	cl, '-' 				;if the current address is a subtraction symbol
		je 		DecideNeg	 			;jump to the subtraction portion of the program

		cmp 	cl, '/'				;if the current address is a division symbol
		je 		Division 				;jump to the division portion of the program

		cmp 	cl, '*' 				;if the current address is a mulitplication symbol
		je 		Multiply 				;jump to the multiplication portion of the program


		push	esi 					;push the current address location of user input


		call 	atoi					;call atoi to convert address to a number

		add 	esp, 4   				; pop last thing off the stack
		push 	eax						; push the digit on the stack

		call 	nextSpace				; find the next space in the user input
		inc 	esi 					; go to the character after the space

		jmp 	While_Loop				; go back and repeat


DecideNeg:

		inc 	esi 					;go to the next character
		mov 	cl, [esi] 				;store the character
		dec 	esi 					;go back to what it was before


		cmp 	cl, 32 					;is it a space
		je 		Subtraction 			;if so then this is a operation

		;if not
		push 	esi
		call atoi

		add		esp, 4
		push 	eax
		call 	nextSpace
		inc 	esi
		jmp		While_Loop


Addition:



		pop 	ebx 					; take the integer off the stack and store it
		pop    	edx					; do the same

		add 	ebx, edx 				; add the two together

		push 	ebx					; push the result onto the stack

		call 	nextSpace
		inc 	esi
		jmp		While_Loop


Subtraction:

		pop 	edx 					; take the integer off the stack and store it
		pop    	ebx					; do the same

		sub 	ebx, edx 				; add the two together

		push 	ebx					; push the result onto the stack

		call 	nextSpace
		inc 	esi
		jmp		While_Loop

Multiply:

		pop 	ebx 					; take the integer off the stack and store it
		pop    	edx					; do the same


		imul 	ebx, edx 				; add the two together

		push 	ebx					; push the result onto the stack

		call 	nextSpace
		inc 	esi
		jmp		While_Loop

Division:

		mov 	edx, 0


		pop 	ebx 	    			; take the integer off the stack and store it;
		;cdq
		pop    	eax					; do the same
		cdq

;		idiv 	edx  				; add the two together
;		push 	eax					; push the result onto the stack

;		pop 	ebx
;		pop 	ecx

;		mov 	eax, 0
		;mov 	edx, 0

		idiv 	ebx
		push 	eax

		call 	nextSpace
		inc 	esi
		jmp		While_Loop






nextSpace:



		inc 	esi 					; go to the next element in the user input
		mov 	cl, [esi]
		cmp 	cl, 32 				;check if the character is a space
										;can this even compare since it's a 32 bit register?

		jne 	nextSpace

		ret



Done: 

		push 	output
		call 	printf

		add 	esp, 8




        ; final exit
        ;
exit:   mov     eax, SYSCALL_EXIT       ; exit function
        mov     ebx, 0                  ; exit code, 0=normal
        int     080h                    ; ask kernel to take over

