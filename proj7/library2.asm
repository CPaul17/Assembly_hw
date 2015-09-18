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
	call main
;main: nop                             	; Entry point- note NOT _start anymore
;start:


;_start: main                             ; Entry point.
;.globl write
write:

		push 	ebp
		mov 	ebp,esp

		push 	ebx
		push 	esi
		push 	edi

        mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, STDOUT             ; Arg1: file descriptor
        mov     ecx, space             ; Arg2: addr of message
        mov     edx, space_len         ; Arg3: length of message
        int     080h                    ; ask kernel to write

		;display to the user

        mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, [ebp+8]            ; Arg1: file descriptor
        mov     ecx, [ebp+12]             ; Arg2: addr of message
        mov     edx, [ebp+16]         ; Arg3: length of message
        int     080h                    ; ask kernel to write

		pop 	edi
		pop 	esi
		pop 	ebx
		pop 	ebp

        ret

read:

		push 	ebp
		mov 	ebp,esp

		push 	ebx
		push 	esi
		push 	edi

        ; read user input
        ;
        mov     eax, SYSCALL_READ       ; read function
        mov     ebx, [ebp+8]            ; Arg1: file descriptor
        mov     ecx, [ebp+12]             ; Arg2: addr of message
        mov     edx, [ebp+16]         ; Arg3: length of message
        int     080h

		pop 	edi
		pop 	esi
		pop 	ebx
		pop 	ebp

;		mov 	eax, edx

        ret

strcmp:
		push 	ebp
		mov 	ebp,esp

		push 	ebx
		push 	esi
		push 	edi

		push 	ecx

;		mov 	eax, [ebp + 8]
;		mov 	ebx, [ebp + 12]
		mov 	cl, [ebp + 8]
		mov 	ch, [ebp + 12]

loop:

		cmp 	cl, ch
		jne	 	not_same
		je		null_char_check


null_char_check:

		cmp 	cl, 0
		jne		loop

same:
		mov 	eax, '1'
		jmp 	return

not_same:
		mov 	eax, '0'

return:

		pop 	ecx
		pop		edi
		pop 	esi
		pop 	ebx
		pop 	ebp

		ret

		pop 	edi
		pop 	esi
		pop 	ebx

        ret



exit:   mov     eax, SYSCALL_EXIT       ; exit function
        mov     ebx, 0                  ; exit code, 0=normal
        int     080h                    ; ask kernel to take over

