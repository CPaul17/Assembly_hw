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


array: db 0, 3, 6, 9, 2, 5, 8, 1, 4, 7
arrayLen: equ $-array


SECTION .bss

buf: resb BUFLEN					;reserve BUFLEN number of bytes
temp_num: resb 13

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
											;beginning of numbers is 0 end is new line
	mov		edx, 0							;I will use edx as a the result register that contains the final digit
	mov		ecx, 13							;I will use ecx as the counter
	dec		ecx								;I will decrement counter since we start at 0
	dec 	ecx								;we are not looking at the very last number

loop:
	dec 	ecx								;decrement to take care of newline

	;if we are done
	cmp 	ecx, 0							;these two lines: if(ecx < 0) jump to finalDisplay
	jb		finalDisplay

	and 	[eax + ecx], 1					;check if even or odd (0 or 1 || 1 or 0) idk which one
											; this line and the jnz are ~ if(i & 0)
	jnz 	even							;if result is not zero go to even
	jz		odd


even:




	add		edx, [array + [eax + ecx]]		;get the position of the element we're at
											;dereference it to get the number. Add that to the
											;beginning of the array to get the lookup value

	cmp 	edx, 9							;is edx greater than 9
	ja 		aboveNine
	jb		loop

odd:

	add 	edx, [eax + ecx]
	cmp		edx, 9
	ja		aboveNine
	jb		loop

aboveNine:
	sub		edx, 10
	jmp		loop


finalDisplay:

	;prompt
	mov 	eax, SYSCALL_WRITE
	mov 	ebx, STDOUT
	;mov 	edx, msg
	mov 	edx, 13
	int 	080h

exit:
	mov		eax, SYSCALL_EXIT
	mov		ebx, 0
	int 	080h




