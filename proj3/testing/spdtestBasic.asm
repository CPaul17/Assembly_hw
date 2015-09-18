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

%define OFFSET_LAST_NAME 0
%define OFFSET_FIRST_NAME 20
%define OFFSET_NUM_ARRESTS 40
%define OFFSET_ARRESTS_PTR 44
%define OFFSET_NEXT 48

%define OFFSET_ARREST_YEAR 0
%define OFFSET_ARREST_MONTH 8
%define OFFEST_ARREST_DAY 12
%define AFFSET_ARREST_DESCRIPTION 16
%define SIZEOF_STRUCT_ARRESTS 56




        SECTION .data                   ; initialized data section

;we need a lookup array

prompt:	db "Enter Citizen's Last Name: "	;this is the string we want to prompt the user
prompt_len: equ $-prompt

prompt2: db "Enter Citizen's First Name: " 			; this is the string that is outputed to the user
prompt2_len: equ $-prompt2

errorLastName: db "Unknown last name: "
errorLastName_len: equ $-errorLastName

validLastName: db "Correct lastname: "
validLastName_len: equ $-validLastName


extern citizens 						;assume citizens to be a pointer to the beginning



        SECTION .bss                    ; uninitialized data section


input:    resb BUFLEN                     ; buffer for read
temp:   resb 16                        ; temp variable to move things around
num_spaces: resb 22							; result variable holds the final digit

firstName: resb 30
lastName: resb 30
numArrests: resb 30
currentNode: resb BUFLEN

userinput_temp_name: resb 4
currentNode_temp_name: resb 4





        SECTION .text                   ; Code section.
									;of the linked list of arrest records

         global  _start                  ; let loader see entry point

_start: nop                             ; Entry point.
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


;get user input
;store the input in a register
;get the length
;decrement the length
;change the last character of the user input to a null character

;make the following a subroutine where eax and ebx are used
;go through every character
;	store the user input in esi
;	store the comparison last name in ebx
;	go through and compare doing "cmp  [esi],[ebx]"
;   there is no need for a counter since the last char is a null
;		and nothing can follow a null
;	exit true statement should be as follows
;		"cmp  [esi], 0"    (this works since the code will never get here
;							unless everything before it has been the same
;							and correct. remember that right after
;							"cmp  [esi], [ebx]" there is a "jne " if they
;							are not the same







;esi is input
; is counter for how many characters we've gone through
; is counter for how many characters were the same
;if al == ah then they are the same
; wil be the offset to add onto esi to check the characters
;			DO NOT ADD esi and bl instead ADD esi and ebx since 32 bit
;ecx will hold the citizen database pointer

;eax = nlength of input

;you have to compare every character so you need to use 8 bit registers

		;eax is used for finding thelast character in user input
		;ebx is used for citizens node
		;esi is used for user input
		mov 	ebx, 0
		mov 	ecx, 0
		mov 	edx, 0

		;cl is used for the comparison in compare_characters

verify_characters:
		mov 	esi, input 				;esi will now hold the beginnin of user input
		mov 	ebx, citizens			;put the first node in eax

		;delete the last character in the user input
		;	the "\n" and replace it with a null character

		dec 	eax
		mov 	[esi + eax], byte 0

		;make sure that esi is the user input ending with a null character
		;	and that ebx starts at the last name of the node
		mov 	[userinput_temp_name], esi
		mov		[currentNode_temp_name], ebx
		call 	compare_characters


;uses esi and ebx
compare_characters:
		;start comparing the characters

		mov 	cl, [esi]
		mov 	ch, [ebx]
;		cmp 	[esi], [ebx]

		cmp 	cl, ch
		jne 	wrongLastName

		cmp 	[esi], byte 0
		je 		correctLastName

		inc 	esi
		inc 	ebx
		jmp 	compare_characters




correctLastName:


        mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, STDOUT             ; Arg1: file descriptor
        mov     ecx, validLastName             ; Arg2: addr of message
        mov     edx, validLastName_len         ; Arg3: length of message
        int     080h                    ; ask kernel to write
		jmp 	exit


wrongLastName:


        mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, STDOUT             ; Arg1: file descriptor
        mov     ecx, errorLastName             ; Arg2: addr of message
        mov     edx, errorLastName_len         ; Arg3: length of message
        int     080h                    ; ask kernel to write


;use call from the subroutine.asm
;it prints a string without needing to know how long it is

exit:   mov     eax, SYSCALL_EXIT       ; exit function
        mov     ebx, 0                  ; exit code, 0=normal
        int     080h                    ; ask kernel to take over


