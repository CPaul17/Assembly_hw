;we need to create an array that has [0,3,6,9,2,5,8,1,4,7]
;where the index values are the numbers and the element is actually
;what you would get if you multiplied    (i*3)%10

;you add in that element if it's even numbered and add in the actual
;input number if it's odd the

;for(i = 0; i < 11; ++i){
;	if(i & 1)
;		check_digit += a[i]
;	else
;		check_digit += lookup[a[i]]
;	if(check_digit >= 10)
;		check_digit -= 10;
;}
;if(check_digit > 0)
;	check_digit = 10 - check_digit


%define STDIN 0
%define STDOUT 1
%define SYSCALL_EXIT  1
%define SYSCALL_READ  3
%define SYSCALL_WRITE 4
%define BUFLEN 256

SECTION .data

msg: db "Enter a number: " 			;prompt
msg_len: equ $-msg

newLine: db "", 10
newLine_len: equ $-newLine



SECTION .bss

buf: resb BUFLEN					;reserve BUFLEN number of bytes
int_inp: resb BUFLEN				;reserve BUFLEN number of bytes
rlen: resb 5						;reserve 5 bytes

		SECTION .text
		global _start

_start: nop
start:

	;prompt
	mov 	eax, SYSCALL_WRITE
	mov 	ebx, STDOUT
	mov 	ecx, msg
	mov 	edx, msg_len
	int 	080h

	;get input
	mov 	eax, SYSCALL_READ
	mov 	ebx, STDIN
	mov 	ecx, buf
	mov 	edx, BUFLEN
	int 	080h

	;put user input into a memory address
	mov 	[rlen], eax
	int 	080h


	;this just displays the same thing
	mov 	eax, SYSCALL_WRITE
	mov 	ebx, STDOUT
	mov 	ecx, [rlen]
	mov		edx, [rlen]
	int 	080h



exit:
	mov		eax, SYSCALL_EXIT
	mov		ebx, 0
	int 	080h




