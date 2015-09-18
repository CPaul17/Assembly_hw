; Christopher Paul project 7
; 04/25/2015

;this project will define the write, read, and strcmp functions

; Assemble using NASM:  nasm -f elf -g -F dwarf libc_example.asm
; Link with gcc:  gcc -m32 -g -o libc_example libc_example.o


%define STDIN 0
%define STDOUT 1
%define SYSCALL_EXIT  1
%define SYSCALL_READ  3
%define SYSCALL_WRITE 4
%define BUFLEN 256



        SECTION .data                   ; initialized data section
space: db " ", 0
space_len: equ $-space

        SECTION .bss                    ; uninitialized data section
input: resb 70
temp: resb 4

        SECTION .text                   ; Code section.

		global _start
		global write					; let loader see entry point
		global read
		global strcmp
		extern main


_start:
	call	main
	jmp 	exit
write:

		mov 	[temp], ebp				;

		push 	ebp 					;mark the base pointer for the stack
		mov 	ebp,esp

		mov 	[temp], ebp				;


		push 	ebx						;save this register
		push 	esi						;save this register
		push 	edi						;save this register

		mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, [ebp+8]            ; Arg1: file descriptor
        mov     ecx, [ebp+12]             ; Arg2: addr of message
        mov     edx, [ebp+16]         ; Arg3: length of message
        int     080h                    ; ask kernel to write

		pop 	edi						;restore register
		pop 	esi						;restore register
		pop 	ebx						;restore register
		pop 	ebp						;restore register

        ret

read:

		push 	ebp						;save base pointer
		mov 	ebp,esp

		push 	ebx						;store the register
		push 	esi						;store the register
		push 	edi						;store the register

        ; read user input
        ;
        mov     eax, SYSCALL_READ       ; read function
        mov     ebx, [ebp+8]            ; Arg1: file descriptor
        mov     ecx, [ebp+12]             ; Arg2: addr of message
        mov     edx, [ebp+16]         ; Arg3: length of message
        int     080h

		pop 	edi						;restore register
		pop 	esi						;restore register
		pop 	ebx						;restore register
		pop 	ebp						;restore register

        ret

strcmp:
		push 	ebp
		mov 	ebp,esp

;		push 	ebx						;store the register
		push 	esi						;store the register
		push 	edi						;store the register

		mov 	eax, 0
		mov 	ebx, 0
		mov 	ecx, 0

		mov 	eax, [ebp + 8]
		mov 	ebx, [ebp + 12]


loop:
		mov 	cl, [eax]
		mov 	ch, [ebx]

		cmp 	cl, ch 					;compare the first byte of the word (letter) with each other
		jg	 	greater					;if cl is greater then return a 1
		jl		less					;if it's less then return a -1
		je		null_char_check			;if it's equal then check to see if we have reached the end

null_char_check:

		inc 	eax
		inc 	ebx
		cmp 	cl, 0					;have we reached the end
		jne		loop					;if not then loop back
		je 		same


greater:

		mov 	eax, 1 				; 1 means that left is greater than right when comparing
		jmp 	return

less:
		mov 	eax, -1 				;-1 means that right is greathen than left when comparing
		jmp		return

same:
		mov 	eax, 0				;0 means that both right and left are the same


return:
		pop		edi						;restore register
		pop 	esi						;restore register
		pop 	ebp						;restore register

		ret


exit:
		mov 	ecx, eax
		mov     eax, SYSCALL_EXIT       ; exit function
        mov     ebx, ecx                   ; exit code, 0=normal
        int     080h                    ; ask kernel to take over

