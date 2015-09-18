; Christopher Paul
; 02/21/2015

%define STDIN 0
%define STDOUT 1
%define SYSCALL_EXIT  1
%define SYSCALL_READ  3
%define SYSCALL_WRITE 4
%define BUFLEN 256


        SECTION .data                   ; initialized data section

;we need a lookup array

prompt:	db "Enter some input: ", 0	;this is the string we want to prompt the user
prompt_len: equ $-prompt

output: db "This is how long your user input is: %d ", 10, 0
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

		;mov		num_spaces, 0
		mov		esi, input				;keep the addressing in a register
		mov		edx, 0


getlen:

		cmp		byte [esi + edx], 0
		jz		gotlen
		inc		edx
		jmp		getlen


gotlen:

		dec		edx						;there is a hidden character at the end?
		push 	edx
		push	output
		call 	printf
		add		esp, 8


        ; final exit
        ;
exit:   mov     eax, SYSCALL_EXIT       ; exit function
        mov     ebx, 0                  ; exit code, 0=normal
        int     080h                    ; ask kernel to take over

