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

errorFirstName: db "Unknown first name "
errorFirstName_len: equ $-errorFirstName

validLastName: db "Correct lastname: "
validLastName_len: equ $-validLastName

everythingValid: db "Everything is valid", 10
everythingValid_len: equ $-everythingValid

validFirstName: db "Correct first name", 10
validFirstName_len: equ $-validFirstName


extern citizens 						;assume citizens to be a pointer to the beginning



        SECTION .bss                    ; uninitialized data section


input:    resb BUFLEN                     ; buffer for read
input2:		resb BUFLEN
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

		mov 	esi, input 							;esi will now hold the beginning of user input
		mov 	ebx, citizens						;put the first node in ebx

		dec 	eax									;decrease the length of the user input
		mov 	[esi + eax], byte 0					;replace the \n with a \0 (null character)
		mov 	[userinput_temp_name], esi 			;put away esi (the beginning of input) to access at a later time
		mov		[currentNode_temp_name], ebx		;put away the beginnig of the first node to access at a later time

verify_characters:


;uses esi and ebx
compare_characters:
		;start comparing the characters in which we asked for the last name


		mov 	cl, [esi] 						;store the character in user input
		mov 	ch, [ebx] 						;store the character in Node's name


		cmp 	cl, ch 							;check if they are the same
		jne 	canGoToNextNode_last			;if they are not then go to the next Node

		;the below has to do with the last character in a string
		cmp 	[esi], byte 0   				;check if we have gotten to the end of the string
		je 		correctLastName 				;if this has triggered that means that everything has been the same
												;and the user input is the same now jump to correct Last Name


		;if we haven't gotten to the end of the string we hit this
		inc 	esi 							;go to next character
		inc 	ebx								;go to next character
		jmp 	compare_characters				;keep looping




canGoToNextNode_last:

		;DOES THE BELOW EVEN WORK since we have been incrimenting ebx before so it's no longer the same
		;I THINK ORIGINAL CODE  	cmp		[ebx, OFFSET_NEXT] would be better

		;cmp 	[ebx], byte 0 					;check if the current node is NULL
		;je 		wrongLastName 					;if we are at the end of the linked list then we can no longer
												;search and we cannot find a database entry

		;  then print out something and exit
		mov		ebx, [currentNode_temp_name]	;we have manipulated

;--------------------------------------------------------------------------------------------
;		add 	ebx, OFFSET_NEXT				;WHY DOES THIS NOT WORK BUT THE NEXT ONE WORK?????????
;		mov 	ebx, [ebx + OFFSET_NEXT]
;--------------------------------------------------------------------------------------------

		mov 	ebx, [ebx + OFFSET_NEXT]
		mov 	esi, [userinput_temp_name]
		mov		[currentNode_temp_name], ebx

		jmp 	compare_characters


;uses esi and ebx
compare_characters_first:
		;start comparing the characters of the first name



		mov 	cl, [esi] 						;store the character in user input
		mov 	ch, [ebx] 						;store the character in Node's name


		cmp 	cl, ch 							;check if they are the same
		jne 	canGoToNextNode_first			;if they are not then go to wrong name

		;the below has to do with the last character in a string
		cmp 	[esi], byte 0   				;we have gotten to the end of the string and final check to exit
		je 		acceptedFirstName 				;jump to get the first name from the user


		;if we haven't gotten to the end of the string we hit this
		inc 	esi 							;go to next character
		inc 	ebx								;go to next character
		jmp 	compare_characters_first		;keep looping


canGoToNextNode_first:

		mov 	cl, 0
		mov 	ch, 0
										;  then print out something and exit
		mov		ebx, [currentNode_temp_name + OFFSET_NEXT]
;		add 	ebx, OFFSET_NEXT 		;go to the next node if it's not Null

;		mov 	ebx, [ebx + OFFSET_NEXT]


		mov 	esi, [userinput_temp_name]
		mov		[currentNode_temp_name], ebx
		jmp 	compare_characters_first


correctLastName:

;		push 	ebx
;		push 	cl
;		push 	ch

        ; prompt user for input

        mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, STDOUT             ; Arg1: file descriptor
        mov     ecx, prompt2             ; Arg2: addr of message
        mov     edx, prompt2_len         ; Arg3: length of message
        int     080h                    ; ask kernel to write


        ; read user input
        ;
        mov     eax, SYSCALL_READ       ; read function
        mov     ebx, STDIN              ; Arg 1: file descriptor
        mov     ecx, input2              ; Arg 2: address of buffer
        mov     edx, BUFLEN             ; Arg 3: buffer length
        int     080h

;		pop		ch
;		pop 	cl
;		pop 	ebx

		;cl is used for the comparison in compare_characters
		mov 	ch, 0
		mov 	cl, 0

		mov 	esi, input2 				;esi will now hold the beginnin of user input
;		mov 	ebx, citizens + OFFSET_FIRST_NAME			;put the first node in eax

;		mov 	ebx, [ebx + OFFSET_FIRST_NAME] ; why is this line giving problems. it's changing the values of ebx
		add 	[ebx], byte OFFSET_FIRST_NAME
;		sub 	[ebx], byte OFFSET_FIRST_NAME

		mov		[currentNode_temp_name], ebx


		;delete the last character in the user input
		;	the "\n" and replace it with a null character

		dec 	eax

		mov 	[esi + eax], byte 0
		mov 	[userinput_temp_name], esi

		jmp  	compare_characters_first

wrongLastName:


        mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, STDOUT             ; Arg1: file descriptor
        mov     ecx, errorLastName             ; Arg2: addr of message
        mov     edx, errorLastName_len         ; Arg3: length of message
        int     080h                    ; ask kernel to write
		jmp 	exit

wrongFirstName:

        mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, STDOUT             ; Arg1: file descriptor
        mov     ecx, errorFirstName             ; Arg2: addr of message
        mov     edx, errorFirstName_len         ; Arg3: length of message
        int     080h                    ; ask kernel to write
		jmp 	exit


;compare_characters_first:
;		mov     eax, SYSCALL_WRITE      ; write function
;        mov     ebx, STDOUT             ; Arg1: file descriptor
;        mov     ecx, everythingValid             ; Arg2: addr of message
;        mov     edx, everythingValid_len         ; Arg3: length of message
;        int     080h                    ; ask kernel to write
;		jmp 	exit

acceptedFirstName:
		mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, STDOUT             ; Arg1: file descriptor
        mov     ecx, validFirstName             ; Arg2: addr of message
        mov     edx, validFirstName_len         ; Arg3: length of message
        int     080h                    ; ask kernel to write


;use call from the subroutine.asm
;it prints a string without needing to know how long it is

exit:   mov     eax, SYSCALL_EXIT       ; exit function
        mov     ebx, 0                  ; exit code, 0=normal
        int     080h                    ; ask kernel to take over


