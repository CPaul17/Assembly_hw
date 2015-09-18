; Christopher Paul project 3  citizen arrests struct project
; finished on: 3/10/2015
;gmail: cp11@umbc.edu
;this program will specify arrests records based on input

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
%define OFFSET_ARREST_DESCRIPTION 16
%define SIZEOF_STRUCT_ARRESTS 56




        SECTION .data                   ; initialized data section

;we need a lookup array

list: db "list", 0

arrest: db "Arrests: ", 10, 0

zeroArrests: db "No arrests.", 10, 0
zeroArrests_len: equ $-zeroArrests

prompt:	db "Enter Citizen's Last Name: "	;this is the string we want to prompt the user
prompt_len: equ $-prompt

prompt2: db "Enter Citizen's First Name: " 			; this is the string that is outputed to the user
prompt2_len: equ $-prompt2

errorLastName: db "Unknown last name: ", 0
errorLastName_len: equ $-errorLastName

errorFirstName: db "you have entered list", 0
errorFirstName_len: equ $-errorFirstName

unknownName: db "Unknown Name: ", 0
unknownName_len: equ $-unknownName

;validLastName: db "Correct lastname: "
;validLastName_len: equ $-validLastName

validFirstName: db "Correct first name", 10
validFirstName_len: equ $-validFirstName

validInputDisplay: db "Arrest Record for: ", 0
validInputDisplay_len: equ $-validInputDisplay

;arrests: db "Arrests: ", 10
;arrests_len: equ $-arrests

commaSpace: db ", ", 0
commaSpace_len: equ $-commaSpace

colonSpace: db": ", 0

newLine: db "  " , 10, 0
newLine_len: equ $-newLine

space: db " ", 0
space_len: equ $-space

dash: db "-", 0
dash_len: equ $-dash




extern citizens 						;assume citizens to be a pointer to the beginning



        SECTION .bss                    ; uninitialized data section

offsetLoop: resb 4
input:    resb BUFLEN                     ; buffer for read
input2:		resb BUFLEN
temp:   resd 32 ;bytes                       ; temp variable to move things around
num_spaces: resb 22							; result variable holds the final digit
counter: resb 4
nextArrest: resb 4

firstNameInput: resb 30
lastNameVar: resb 30
firstNameVar_len: resb 4
lastValidNodeLName: resb 30

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


;		mov		firstNameVarLen, eax				;store how long it is

		mov 	[esi + eax], byte 0					;replace the \n with a \0 (null character)
		mov 	[lastNameVar], esi 					;store the last name

		mov 	[userinput_temp_name], esi 			;put away esi (the beginning of input) to access at a later time
		mov		[currentNode_temp_name], ebx		;put away the beginnig of the first node to access at a later time
		mov 	[lastValidNodeLName], ebx

		mov 	edx, list

verify_characters:

		;check to see if the user entered "list"

		mov 	cl, [esi]
		mov 	ch, [edx]

		cmp 	cl, ch
		jne		notList

		cmp 	ch, byte 0
		je 		listFound

		inc 	esi
		inc 	edx

		jmp 	verify_characters



notList:
		mov 	esi, [userinput_temp_name]


;uses esi and ebx
compare_characters:
		;start comparing the characters in which we asked for the last name


		mov 	cl, [esi] 						;store the character in user input
		mov 	ch, [ebx] 						;store the character in Node's name


		cmp 	cl, ch 							;check if they are the same
		jne 	canGoToNextNode_last			;if they are not then go to the next Node

		;the below has to do with the last character in a string
		cmp 	[ebx], byte 0   				;check if we have gotten to the end of the string
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

		cmp 	ebx, byte 0
		je 		wrongLastName
		mov 	esi, [userinput_temp_name]
		mov		[currentNode_temp_name], ebx
		mov 	[lastValidNodeLName], ebx

		jmp 	compare_characters


beginning_first_name_compare:

		mov		esi, [firstNameInput]

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

;		mov 	esi, [userinput_temp_name] 		;reset where we are looking in the user input (cancel the increments)
		mov		ebx, [currentNode_temp_name]	;characters don't match so go back to beginning memory of node
		mov 	[temp], ebx
		mov 	esi, [lastNameVar]
		mov	 	[temp], ebx
;		mov 	esi, [input2]

		;since the first name does not match we need to find another node with the same Last name to keep checking

;		sub 	ebx, byte OFFSET_FIRST_NAME

		mov 	ebx, [ebx + OFFSET_NEXT]
		mov 	[temp], ebx

;		cmp		[ebx + OFFSET_NEXT], byte 0
		cmp		ebx, byte 0
		je 		wrongFirstName

;		mov 	ebx, [ebx + OFFSET_NEXT]


;		add 	ebx, byte OFFSET_FIRST_NAME       THIS AND THE ONE ABOVE WORKS AS A GOOD COMBINATION



;		cmp 	[ebx], byte 0					;if we have reached the end of the linked list
;		je 		wrongFirstName					;they gave us the wrong first name
		mov 	[currentNode_temp_name], ebx	;store the new node location

findGoodLastName:

		mov 	cl, [esi] 						;store the character in user input
		mov 	ch, [ebx] 						;store the character in Node's name


		cmp 	cl, ch 							;check if they are the same
		jne 	canGoToNextNode_first			;if they are not then go to the next Node

		;the below has to do with the last character in a string
		cmp 	[esi], byte 0   				;check if we have gotten to the end of the string
		je 		compareNodeFirstName 				;if this has triggered that means that everything has been the same
												;and the user input is the same now jump to correct Last Name


		;if we haven't gotten to the end of the string we hit this
		inc 	esi 							;go to next character
		inc 	ebx								;go to next character
		jmp  	findGoodLastName				;keep looping


compareNodeFirstName:

;		mov 	[currentNode_temp_name], ebx
		mov 	ebx, [currentNode_temp_name]
		mov 	[lastValidNodeLName], ebx
		add 	ebx, byte OFFSET_FIRST_NAME
		mov 	esi, [userinput_temp_name]
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
		mov 	ecx, 0
		mov 	ch, 0
		mov 	cl, 0

		mov 	esi, input2 				;esi will now hold the beginnin of user input
		mov 	ebx, [lastValidNodeLName]			;put the first node in eax



		add 	ebx, byte OFFSET_FIRST_NAME ; why is this line giving problems. it's changing the values of ebx
;		add 	[ebx], byte OFFSET_FIRST_NAME
		mov 	[temp], ebx
		;delete the last character in the user input
		;	the "\n" and replace it with a null character

		dec 	eax

		mov 	[esi + eax], byte 0
		mov 	[userinput_temp_name], esi
		mov 	[firstNameInput], esi

		jmp  	compare_characters_first

printDashes:
        mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, STDOUT             ; Arg1: file descriptor
        mov     ecx, dash               ; Arg2: addr of message
        mov     edx, dash_len           ; Arg3: length of message
        int     080h                    ; ask kernel to write
        ret


printNewLine:
		mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, STDOUT             ; Arg1: file descriptor
        mov     ecx, newLine               ; Arg2: addr of message
        mov     edx, newLine_len           ; Arg3: length of message
        int     080h                    ; ask kernel to write
        ret

printSetUp:
		mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, STDOUT             ; Arg1: file descriptor
        mov     ecx, validInputDisplay               ; Arg2: addr of message
        mov     edx, validInputDisplay_len           ; Arg3: length of message
        int     080h                    ; ask kernel to write
        ret


wrongLastName:


        mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, STDOUT             ; Arg1: file descriptor
        mov     ecx, errorLastName             ; Arg2: addr of message
        mov     edx, errorLastName_len         ; Arg3: length of message
        int     080h                    ; ask kernel to write

        mov 	eax, [lastNameVar]
        call 	print

		mov 	eax, newLine
		call 	print

		jmp 	exit


noArrests:
        mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, STDOUT             ; Arg1: file descriptor
        mov     ecx, zeroArrests             ; Arg2: addr of message
        mov     edx, zeroArrests_len         ; Arg3: length of message
        int     080h                    ; ask kernel to write
		jmp 	exit


listFound:

		mov 	eax, citizens 						;get the beginning
		mov 	[currentNode_temp_name], eax 		;store it
		mov 	eax, 0								;zero it out

loopAll:
		mov 	eax, [currentNode_temp_name] 		;get the last node
		cmp		eax, 0								;if it is null
		je 		exit								;we are done

		call 	printSetUp 							;format
		mov 	eax, [currentNode_temp_name]		;print the last name
		call 	print

		mov 	eax, commaSpace						;print a comma and a space
		call 	print

		mov 	eax, [lastValidNodeLName] 			;get back to the beginning
		add 	eax, OFFSET_FIRST_NAME				;go to the first name
		call 	print								;print the first name
		call 	printNewLine						;and a newLine


		mov 	ecx, [lastValidNodeLName]			;get back to the beginning
		mov 	[temp], ecx							;store it
		add 	ecx, OFFSET_NUM_ARRESTS				;go to the number of arrests
		mov 	[temp], ecx							;store it
		mov 	[counter], ecx						;store it
		mov 	esi, [ecx]							;access the actual integer value and store it
		mov 	[offsetLoop], esi					;that is now our offsetLoop



		cmp 	esi, 0									;see if there are any at all
		je 		noArrests2

		mov 	esi, 0								;these will be counters
		mov 	edi, 0
		mov 	[nextArrest], edi

		mov 	eax, arrest
		call	print


allArrests2:

		mov 	eax, [lastValidNodeLName] 				;get the last valid Node
		mov 	[temp], eax								;store it
		mov 	eax, [eax + OFFSET_ARRESTS_PTR]			;go to the arrests pointer
		mov 	edi, [nextArrest]						;get what is in the buffer
		add 	eax, edi								;add the offset if there is one
		mov 	[temp], eax								;store it then print
		call 	print

		call 	printDashes								;print dashes

		mov 	eax, [lastValidNodeLName]				;get the last valid Node
		mov 	[temp], eax
		mov 	eax, [eax + OFFSET_ARRESTS_PTR]			;go to the arrests pointer that actually has the informatin
		mov 	[temp], eax
		add 	eax, OFFSET_ARREST_MONTH				;go to the month of the arrest
		mov 	edi, [nextArrest]
		add 	eax, edi
		mov 	[temp], eax
		call 	print									;print it

		call 	printDashes

		mov 	eax, [lastValidNodeLName]				;go to beginning
		mov 	[temp], eax
		mov 	eax, [eax + OFFSET_ARRESTS_PTR]			;go to the arrests pointer that actually has the information
		mov 	[temp], eax
		add 	eax, OFFEST_ARREST_DAY					;go to the day of the arrest
		mov 	edi, [nextArrest]
		add 	eax, edi
		mov 	[temp], eax
		call 	print									;print it

		mov 	eax, colonSpace
		call 	print									;print a space

		mov 	eax, [lastValidNodeLName]				;go back to the beginning node
		mov 	[temp], eax
		mov 	eax, [eax + OFFSET_ARRESTS_PTR]			; we want the arrest information
		mov 	[temp], eax
		add 	eax, OFFSET_ARREST_DESCRIPTION			; go to the description part
		mov 	edi, [nextArrest]
		add 	eax, edi
		mov 	[temp], eax
;		mov 	[temp], eax
		call 	print									;print the description

		mov 	eax, newLine
		call 	print


		inc		esi
		mov 	edi, [nextArrest]						;this is to loop so that it will print out
		add 	edi, 56									;all the crimes that are on record
		mov 	[nextArrest], edi

		cmp 	esi, [offsetLoop]
		jne 	allArrests2

goToNextCitizen:

		mov 	eax, [currentNode_temp_name]
		mov 	eax, [eax + OFFSET_NEXT]
		mov 	[currentNode_temp_name], eax

		mov 	[lastValidNodeLName], eax

		cmp 	eax, byte 0
		jne 	loopAll



		jmp 	exit


noArrests2:

		mov 	[temp], eax
		mov 	eax, zeroArrests
		mov 	[temp], edi
		call 	print
		mov 	edi, [temp]
		jmp  	goToNextCitizen

wrongFirstName:

        mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, STDOUT             ; Arg1: file descriptor
        mov     ecx, unknownName             ; Arg2: addr of message
        mov     edx, unknownName_len         ; Arg3: length of message
        int     080h                    ; ask kernel to write

        mov 	eax, [lastNameVar]
        call 	print

		mov 	eax, commaSpace
		call 	print

        mov 	eax, [userinput_temp_name]
        call 	print

        mov 	eax, newLine
        call 	print

		jmp 	exit


print:
        ; find \0 character and count length of string
        ;
        mov     edi, eax                ; use edi as index
        mov     edx, 0                  ; initialize count

count:  cmp     [edi], byte 0           ; null char?
        je      end_count
        inc     edx                     ; update index & count
        inc     edi
        jmp     short count

end_count:

        ; make syscall to write
        ; edx already has length of string
        ;
        mov     ecx, eax                ; Arg3: addr of message
        mov     eax, SYSCALL_WRITE      ; write function
        mov     ebx, STDOUT             ; Arg1: file descriptor
        int     080h                    ; ask kernel to write
        ret




acceptedFirstName:


		call 	printSetUp
		mov 	eax, [lastValidNodeLName]				;format
		call 	print

		mov 	eax, commaSpace							;format
		call 	print

		mov 	eax, [lastValidNodeLName]
		add 	eax, OFFSET_FIRST_NAME
		call 	print									;format
		call 	printNewLine


		mov 	ecx, [lastValidNodeLName]
		mov 	[temp], ecx
		add 	ecx, OFFSET_NUM_ARRESTS				;get the number of arrests in a
		mov 	[temp], ecx							;and store it in a variable to be
;		mov 	ecx, [ecx]							;used later since we will be looping
		mov 	[counter], ecx						;that number of times
		mov 	esi, [ecx]
		mov 	[offsetLoop], esi



		cmp 	esi, 0									;see if there are any at all
		je 		noArrests

		mov 	esi, 0
		mov 	edi, 0									;zero out
		mov 	[nextArrest], edi

		mov 	eax, arrest
		call	print



allArrests:

;this is all much of the same that is done if "list is entered"by the user

		mov 	eax, [lastValidNodeLName] 				;get the last valid Node
		mov 	[temp], eax								;store it
		mov 	eax, [eax + OFFSET_ARRESTS_PTR]			;go to the arrests pointer
		mov 	edi, [nextArrest]
		add 	eax, edi
		mov 	[temp], eax
		call 	print

		call 	printDashes

		mov 	eax, [lastValidNodeLName]
		mov 	[temp], eax
		mov 	eax, [eax + OFFSET_ARRESTS_PTR]
		mov 	[temp], eax								;go to the node then go to the month of the arrest
		add 	eax, OFFSET_ARREST_MONTH				; and print that out
		mov 	edi, [nextArrest]
		add 	eax, edi
		mov 	[temp], eax
		call 	print

		call 	printDashes								;format

		mov 	eax, [lastValidNodeLName]
		mov 	[temp], eax
		mov 	eax, [eax + OFFSET_ARRESTS_PTR]			;go to the node then add the arrests pointer then
		mov 	[temp], eax								;day of the arrest and print the day of
		add 	eax, OFFEST_ARREST_DAY					;the arrest
		mov 	edi, [nextArrest]
		add 	eax, edi
		mov 	[temp], eax
		call 	print

		mov 	eax, colonSpace
		call 	print									;format

		mov 	eax, [lastValidNodeLName]
		mov 	[temp], eax
		mov 	eax, [eax + OFFSET_ARRESTS_PTR]			;go to the node then add the arrests pointer then
		mov 	[temp], eax								;the day of the arrest and print the day of
		add 	eax, OFFSET_ARREST_DESCRIPTION			;the arrest to the user
		mov 	edi, [nextArrest]
		add 	eax, edi
		mov 	[temp], eax
		call 	print

		mov 	eax, newLine					;format
		call 	print


		inc		esi

		mov 	edi, [nextArrest]				;we want to get every arrest against the individual
		add 	edi, 56							; so add for the next arrest
		mov 	[nextArrest], edi

		cmp 	esi, [offsetLoop]
		jne 	allArrests



;use call from the subroutine.asm
;it prints a string without needing to know how long it is

exit:   mov     eax, SYSCALL_EXIT       ; exit function
        mov     ebx, 0                  ; exit code, 0=normal
        int     080h                    ; ask kernel to take over


