include pcmac.inc
.model small
.stack 100h
.data
	intro_msg db 13, 10, 'Enter a message containing at most 50 characters: ', 13, 10, '$'

		; Create struct to store the users message

    MSG_BUFFER_COUNT 		EQU 51
    GetMessageStruct   		db MSG_BUFFER_COUNT
                			db ?
	msg_buffer 				db MSG_BUFFER_COUNT DUP (?), '$'

	echo_msg 				db 'You said: $'

	function1_msg 			db 'You selected function 1', 13, 10, '$'
	function2_msg 			db 'You selected function 2', 13, 10, '$'
	
		; Function Menu

	function_menu_intro db 13, 10, 'Select a function from the menu below$'
	function_menu_1 db 13, 10, '1. Determine where the first occurrence of a selected character (spaces included) is in the message$'
	function_menu_2 db 13, 10, '2. Find the number of occurrences of a certain letter in the message$'
	function_menu_3 db 13, 10, '3. Find the length of the message$'
	function_menu_4 db 13, 10, '4. Find the number of characters in the message$'
	function_menu_5 db 13, 10, '5. Perform a routine that replaces every occurrence of a certain letter with another symbol in the message$'
	function_menu_6 db 13, 10, '6. Capitalize all letters in the message$'
	function_menu_7 db 13, 10, '7. Make each letter in the message lower-case$'
	function_menu_8 db 13, 10, '8. Toggle the case of each letter in the message$'
	function_menu_9 db 13, 10, '9. Input a new message$'
	function_menu_10 db 13, 10, '10. Undo the last action that modified the message$'
	function_menu_100 db 13, 10, '100. Output this menu again$'
	function_menu_0 db 13, 10, '0. Exit', 13, 10, '$'

		;

		; Function 1 Declarations
	fn1_msg 		db 13, 10, 'Which character do you wish to search for in your message?$'
	fn1_found_char_msg	db 13, 10, 'Position $' 
	fn1_char_not_found_msg  db 13, 10, 'The character you wish to search was not found in the message$'
	fn1_current_offset  db ?
		; End Function 1 Declarations

		; Create struct to store the users menu option

	MENU_OPTION_BUFFER_COUNT EQU 5
	GetMenuOptionStruct		db MENU_OPTION_BUFFER_COUNT
							db ?
	menu_option_buffer  	db MENU_OPTION_BUFFER_COUNT DUP (?), '$'

.code

	GetMenuOption PROC
		_PutStr function_menu_intro
		_PutStr function_menu_1
		_PutStr function_menu_2
		_PutStr function_menu_3
		_PutStr function_menu_4
		_PutStr function_menu_5
		_PutStr function_menu_6
		_PutStr function_menu_7
		_PutStr function_menu_8
		_PutStr function_menu_9
		_PutStr function_menu_10
		_PutStr function_menu_100
		_PutStr function_menu_0

	get_menu_option:
										; Store the users selection in the array
		_GetStr GetMenuOptionStruct
										; print new line
		_PutCh	10
										; Get the length of the actual selection string stored at GetMenuOptionStruct[2]. Place in a byte register
		mov 	al, GetMenuOptionStruct + 1
		add 	al, 2
		mov 	ah, 0
		add 	ax, OFFSET GetMenuOptionStruct
		mov 	di, ax
		mov 	bx, 24h
		mov 	[di], bx
		Call 	RunSelectedFunction
		ret
	GetMenuOption ENDP

	RunSelectedFunction PROC
		cmp 	menu_option_buffer, 30h			
		je		zero
		jmp 	not_zero
	zero:
		cmp 	[menu_option_buffer+1], 13					; is the second character a carriage return?
		jne 	invalid_option
		jmp 	exit
	not_zero:
		cmp		menu_option_buffer, 31h
		jne		not_one
		cmp 	[menu_option_buffer+1], 30h			 		; check the next char if '1' is the first char
		je 		not_nine
		cmp 	[menu_option_buffer+1], 24h					; is the second character a carriage return?
		jne 	invalid_option 									
		Call 	Function1
	not_one:
		cmp 	menu_option_buffer, 32h
		jne 	not_two
		cmp 	[menu_option_buffer+1], 24h					; is the second character a carriage return?
		jne 	invalid_option 									
		Call 	Function2
	not_two:
		cmp		menu_option_buffer, 33h
		jne 	not_three
		cmp 	[menu_option_buffer+1], 24h					; is the second character a carriage return?
		jne 	invalid_option 									
		Call 	Function3
	not_three:
		cmp 	menu_option_buffer, 34h
		jne 	not_four
		cmp 	[menu_option_buffer+1], 24h					; is the second character a carriage return?
		jne 	invalid_option 									
		Call 	Function4
	not_four:
		cmp		menu_option_buffer, 35h
		jne 	not_five
		cmp 	[menu_option_buffer+1], 24h					; is the second character a carriage return?
		jne 	invalid_option 									
		Call 	Function5
	not_five:
		cmp		menu_option_buffer, 36h
		jne 	not_six
		cmp 	[menu_option_buffer+1], 24h					; is the second character a carriage return?
		jne 	invalid_option 									
		Call 	Function6
	not_six:
		cmp		menu_option_buffer, 37h
		jne 	not_seven
		cmp 	[menu_option_buffer+1], 24h					; is the second character a carriage return?
		jne 	invalid_option 									
		Call 	Function7
	not_seven:
		cmp		menu_option_buffer, 38h
		jne 	not_eight
		cmp 	[menu_option_buffer+1], 24h					; is the second character a carriage return?
		jne 	invalid_option 									
		Call 	Function8
	not_eight:
		cmp		menu_option_buffer, 39h
		jne 	not_nine
		cmp 	[menu_option_buffer+1], 24h					; is the second character a carriage return?
		jne 	invalid_option 									
		Call 	Function9
	not_nine:
		cmp 	[menu_option_buffer+2], 30h					; compare the 3rd character if first two read are '10'
		je 		not_ten
		cmp 	[menu_option_buffer+2], 24h					; is the third character a carriage return?
		jne 	invalid_option 
		Call 	Function10 									; '10' was entered
	not_ten:
		cmp 	[menu_option_buffer + 3], 24h				; is the fourth character a carriage return?
		je 		invalid_option
		Call 	Function100
	invalid_option:
		_PutStr menu_option_buffer
		Call 	GetMenuOption
		ret

	RunSelectedFunction ENDP

	Function1 		Proc
		_PutStr		echo_msg
		_PutStr 	function_menu_1
															; which character do you wish to search
		_PutStr 	fn1_msg 			
															; character read in al
		_GetCh		
															; iterate through the message and compare each character with desired
		push 	cx
															; counter
		mov 	cl, 0
															; store the length of the message in ch to decrement for each iteration
		mov 	ch, GetMessageStruct + 1
		fn1_loop:
															; compare the character stored in GetMessageStruct+2+cl (the current index of the messsage) with the search character
															; add 2 to the current index to offset the beginning of the message in the struct
			mov 	fn1_current_offset, 2
			add 	fn1_current_offset, cl
			cmp 	[fn1_current_offset], al
															; jump to the output message if equal
			je 		found_char
															; increment the message index
			inc 	cl
															; check if this is the last character in the message (the first index)
			cmp 	ch, 1
															; jump to output message if equal
			je 		char_not_found
															; otherwise, decrease the # of positions to search in the message
			dec 	ch
															; move to next index
			jmp 	fn1_loop
		char_not_found:
															; output that the char is not in the message, then jump to end of function
			_PutStr fn1_char_not_found_msg
			jmp 	end_fn1
		found_char:
															;output the position of the search character in the message, continue to end of function
			_PutStr fn1_found_char_msg
			_PutCh 	cl
		end_fn1:
															; replace the contents of cx that were used for the counters, and output the main menu again
			pop		cx
			Call GetMenuOption
			ret
	Function1 		EndP

	Function2 		Proc
		_PutStr		echo_msg
		_PutStr 	function_menu_2
		Call GetMenuOption
		ret
	Function2 		EndP

	Function3 		Proc
		_PutStr		echo_msg
		_PutStr 	function_menu_3
		Call GetMenuOption
		ret
	Function3 		EndP

	Function4 		Proc
		_PutStr		echo_msg
		_PutStr 	function_menu_4
		Call GetMenuOption
		ret
	Function4 		EndP

	Function5 		Proc
		_PutStr		echo_msg
		_PutStr 	function_menu_5
		Call GetMenuOption
		ret
	Function5 		EndP

	Function6		Proc
		_PutStr		echo_msg
		_PutStr 	function_menu_6
		Call GetMenuOption
		ret
	Function6 		EndP

	Function7 		Proc
		_PutStr		echo_msg
		_PutStr 	function_menu_7
		Call GetMenuOption
		ret
	Function7 		EndP

	Function8 		Proc
		_PutStr		echo_msg
		_PutStr 	function_menu_8
		Call GetMenuOption
		ret
	Function8 		EndP

	Function9		Proc
		_PutStr		echo_msg
		_PutStr 	function_menu_9
		Call GetMenuOption
		ret
	Function9 		EndP

	Function10 		Proc
		_PutStr		echo_msg
		_PutStr 	function_menu_10
		Call GetMenuOption
		ret
	Function10		EndP

	Function100		Proc
		_PutStr		echo_msg
		_PutStr 	function_menu_100
		Call GetMenuOption
		ret
	Function100		EndP

	start:
		mov     ax, @data
    	mov     ds, ax
    									; Output the intro message
		_PutStr intro_msg
										; Store the users message in the array
		_GetStr GetMessageStruct
										; print new line
		_PutCh	10
										; Get the length of the actual message stored at GetMessageStruct[2]. Place in a byte register
		mov		al, GetMessageStruct + 1
										; increment the pointer in the array by one. This location holds the value of a carriage return (13h) from user's message
		add 	al, 2
										; clear ah to prepare for addition
		mov		ah, 0					
										; add the address of GetMessageStruct with the size of the message to find the address whereas to place a string terminator ('$')
										; OFFSET is a memory location (word) and must be stored in word register
		add 	ax, OFFSET GetMessageStruct	
										; store the value of ax in an index register 
		mov		di, ax					
										; '$' to terminate the message that the user entered
		mov		bx, 24h					
										; Place the string terminator in GetMessageStruct[di] or the position directly after the last character read
		mov		[di], bx				
										; Output the echo message
		_PutStr echo_msg
										; Output the users message
		_PutStr msg_buffer
										; Display the function menu to the user and store their option in menu_option_buffer
		Call 	GetMenuOption
		
		jmp 	exit

	exit:
		mov     ah, 4Ch
		mov     al, 0
		int     21h

	end start