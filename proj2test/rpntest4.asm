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

prompt:	db "Expression to calculate: "	;this is the string we want to prompt the user
prompt_len: equ $-prompt

output: db "Result: %d ", 10
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

		;can you only push 32 bit registers on the stack???????????????????

;		mov 	cl, [esi]

		cmp 	esi, 10 				;check if we have reached the end of the input
		je		Done 					;if so then jump

		cmp 	esi, '+'				;if the current address is an addition symbol
		je 		Addition 				;jump to the addition portion of the program

		;cmp 	esi, '-' 				;if the current address is a subtraction symbol
		;je 		Subtraction 			;jump to the subtraction portion of the program

		;cmp 	esi, '/'				;if the current address is a division symbol
		;je 		Division 				;jump to the division portion of the program

		;cmp 	esi, '*' 				;if the current address is a mulitplication symbol
		;je 		Multiply 				;jump to the multiplication portion of the program


		push	esi 					;push the current address location of user input


		call 	atoi					;call atoi to convert address to a number

		add 	esp, 4   				; pop last thing off the stack
		push 	eax						; push the digit on the stack

		call 	nextSpace				; find the next space in the user input
		inc 	esi 					; go to the character after the space

		jmp 	While_Loop				; go back and repeat


Addition:


;ebx, ecx

		pop 	ebx 					; take the integer off the stack and store it
		pop    	edx					; do the same

		add 	ebx, edx 				; add the two together

;		mov 	b, 0
		push 	ebx					; push the result onto the stack

		call 	nextSpace
		jmp		While_Loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;atoi kills edx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;break linenumber
;continue (or c)
;s (step)
;print (label for variable)
;print $register_name
;info registers


;to look at memory
;x/(numberofbytes)


;get the user input
;push the address of the user input onto the stack
;atoi the stack and the result will be in eax
;make a function that goes to the next space (have it incriment esi till it finds a space)
;have conditions for operations



nextSpace:


		;cmp 	[esi], 10				;check if the current element is a new line character for input end
		;je		Done
										;the above will never happen since the end of an input will include a space


		inc 	esi 					; go to the next element in the user input
		cmp 	esi, 32 				;check if the character is a space
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

