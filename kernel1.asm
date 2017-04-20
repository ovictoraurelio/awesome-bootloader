org 0x7e00
jmp _start

;Variable declaration area
score db 0
game_over_msg db "                G   A   M   E       O   V   E   R   ! ! !", 0
score_msg db "Your score is: ", 0
highscore_msg db "The High Score is: ", 0
answer_message db " Enter the sequence, then press Enter.", 13, 10, 13, 10, " ", 0
next_level_message db " C", 10, 10," O", 10, 10," N", 10, 10, " G", 10, 10, " R", 10, 10, " A", 10, 10, " T", 10, 10, " U", 10, 10, " L            GET READY TO THE NEXT LEVEL!!!",8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8, 10, 10, " A", 10,  10," T", 10,  10," I", 10, 10, " O", 10, 10, " N", 10, 10, " S",0 
menu_message db "             Welcome to the Lenux-based Color Sequence Game!", 13, 10, 13, 10, 0
game_instructions db " Instructions:", 13, 10," - Look carefully to the screen and memorize the color order.", 13, 10, " - Do not press any key unless the game instructs you to do so, pressing the", 13, 10, "   wrong key or any key in some inappropriate moment will result in GAME OVER.", 13, 10," - Insert the order according to:", 13, 10, "     1 - Blue", 13, 10, "     2 - Green", 13, 10, "     3 - Cyan", 13, 10, "     4 - Red",13, 10, "     Ignore - Black",0
control_instructions db 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, 13, 10, "                 Press Enter to start or ESC to leave", 0
number times 2 db 0
answer db 0
ten db 10
rand dw 0
rand_num dw 0
rand_num1 dw 0
i db 0
sequence times 40 db 0 
head dw 0
queue_front times 50 db 0 	;points to the initial memory address, holds the color values
counter dw 0
counter1 dw 0


_start:
	xor ax, ax		;ax to 0
	mov ds, ax		;ds to 0

	.video_mode:
		mov ah, 0 	;call number
		mov al, 12h ;video mode
		int 10h

	;Game menu
	mov bl, 0x7 	;sets the screen color as dark grey
	call show_color

	mov si, menu_message
	call print_string

	mov si, game_instructions
	call print_string	

	mov si, control_instructions
	call print_string
;-----------------------------------------------------------------;
	mov dx, 220 ;coordenada y do primeiro pixel
	
	mov al,0x1 ;cor do pixel (azul)
	mov cx, 150
	loopS:
		push cx
		call square_print
		pop cx
		loop loopS

	mov dx, 220

	mov byte[counter], 0
	mov al,0x2 ;cor do pixel (verde)
	mov cx, 150
	loopS2:
		push cx
		call square_print2
		pop cx
		loop loopS2

	mov dx, 220

	mov byte[counter], 0
	mov al,0x3 ;cor do pixel (cyan)
	mov cx, 150
	loopS3:
		push cx
		call square_print3
		pop cx
		loop loopS3

	mov dx, 220

	mov byte[counter], 0
	mov al,0x4 ;cor do pixel (red)
	mov cx, 150
	loopS4:
		push cx
		call square_print4
		pop cx
		loop loopS4	
;-----------------------------------------------------------------;
	menu_control:
		mov ah, 0x0								;instruction to read from keyboard
		int 0x16								;interrupt de teclado

		enter_cmp:
			cmp al, 0xd							;CMP with ENTER
			je game								;if equal, start game
		esc_cmp:
			cmp al, 0x1b						;CMP with ESC
			je end								;if equal, end game and shutdown computer
	jmp menu_control 							;else, reads again
	xor di, di
	xor si, si
	
	game:
		call clear_screen
		mov di, queue_front
		game_loop:
			call random 				;makes bl a random number between 1 and 4 and bh == 0
			mov al, bl 					
			
			mov [di], bl
			inc di

			; mov bl, [di - 1] 			;saves the queue[di - 1] value in bl, because queue[di] will always be 0
			; call show_color			;changes the background to the color which is in bl
			; call delay

			; mov bl, [di - 1]
			; xor bh, bh
			; mov ax, bx
			; call print_int
			; call delay 

			; mov ah,0xe		;print char in al
			; mov al, 0xa 	;new line character
			; int 10h
			; jmp game_loop

			.show_sequence:
				mov si, queue_front
				.loop:
					lodsb 				;gets the value in queue[si] and saves in al, then points si to the next position
					mov bl, al 			 
					cmp bl, 0			;compares bl with 0, to know if it reached the end of the numbers
					je get_answer		;if its equal go to get_answer				
					
					call show_color		;else, changes the background to the color which is in bl
					call delay			;delay

					mov bl, 0 			;puts a black screen between the colors
					call show_color
					call mini_delay
				jmp .loop				;loads the next memory position (next color)

			; ;GERSON
			; ;mostra mensagem pra pedir sequencia invertida
			get_answer:
				mov bl, 7  			;sets the screen as grey
				call show_color
				
				mov si, answer_message 	;displays the get_answer message
				call print_string

				mov si, queue_front

				.answer:

					mov al, ' ' 		;prints a space between each number
					call print_char
					
					mov ah, 0x0			;instruction to read from the keyboard
					int 0x16			;keyboard interrupt
					
					add al, -48 		;transforms the ascii char into a number
					mov byte[answer], al;saves the answer from al
					xor ah, ah
					call print_int 

					; mov al, 10
					; call print_char
					
					; mov al, [si]
					; xor ah, ah
					; call print_int

					mov al, [si]
					inc si
				
					cmp al, 0			;compares al with 0, to know if it reached the end of the numbers
					je .next_level 		;if its in the end, go to the next level
					
					cmp al, byte[answer];else, compares with the color
					je .answer 			;if equal, go to the next color
					call delay
					jmp  game_over		;if wrong, finishes the game


			.next_level:
				call clear_screen
				mov bl, 9
				call show_color
				mov si, next_level_message
				call print_string
				times 2 call delay			;delay
				call clear_screen
				inc byte[score]
			jmp game_loop


			game_over:
				call clear_screen
				mov bl, 4
				call show_color
				mov si, game_over_msg
				call print_string

				mov al, 13
				call print_char

				mov al, 10
				call print_char

				mov si, score_msg
				call print_string

				xor ah, ah
				mov al, byte[score]
				call print_int

				times 2 call delay
			jmp end
jmp end

;-------------------------------------------------;
;-----------------Main functions------------------;
;-------------------------------------------------;

;To use this function, put the value you wanna print in the
;reg ax and be sure that there's no important data in the regs
;dx and cl.
print_int:			;show the integer in al as a string in the screen
	xor dx, dx
	xor cl, cl
	.sts:					;starts the conversion (sts = send to stack)
			div byte[ten]	;divide ax by cl(10) saves the quocient in al and the remainder in ah
			mov dl, ah		;sends ah to dl
			mov ah, 0		;sets ah to 0
			push dx			;sends dx to the stack
			inc cl			;increments cl
			cmp al, 0		;compares the quocient (al) with 0
			jne .sts		;if it isnt 0, sends the next character to the stack

	.print:					;else
			pop ax			;pop from the stack to ax
			add al, 48		;transforms the int in ASCII
			call print_char	;prints char from al
			dec cl			;decrements cl
			cmp cl, 0		;compares cl with 0
			jne .print		;if counter != 0, prints the next char

ret	;else, return

inc_score:	;incrementa score
	mov si, score 	;coloca endereço de score em ds
	lodsw 			;ax = [score]
	inc ax			;ax++
	mov di, score 	;coloca endereço de score em es
	stosw 			;[score] = ax
ret

square_print:
		add cx, [counter]	;printa na coordenada [dx,(cx + counter)]
		mov WORD [counter], 20 ;coordenada x do primeiro pixel
	.loop:
		mov cx, [counter]
		call pixel_print 
		inc WORD [counter]	;(*counter)++
		cmp WORD [counter], 150 ;if counter >= 100
		jae .endloop	;jump to endloop
		jmp .loop		;else restart the loop
	.endloop:
	inc dx
ret

square_print2:
		add cx, [counter]	;printa na coordenada [dx,(cx + counter)]
		mov WORD [counter], 170 ;coordenada x do primeiro pixel
	.loop:
		mov cx, [counter]
		call pixel_print 
		inc WORD [counter]	;(*counter)++
		cmp WORD [counter], 310 ;if counter >= 100
		jae .endloop	;jump to endloop
		jmp .loop		;else restart the loop
	.endloop:
	inc dx
ret

square_print3:
		add cx, [counter]	;printa na coordenada [dx,(cx + counter)]
		mov WORD [counter], 330 ;coordenada x do primeiro pixel
	.loop:
		mov cx, [counter]
		call pixel_print 
		inc WORD [counter]	;(*counter)++
		cmp WORD [counter], 470 ;if counter >= 100
		jae .endloop	;jump to endloop
		jmp .loop		;else restart the loop
	.endloop:
	inc dx
ret

square_print4:
		add cx, [counter]	;printa na coordenada [dx,(cx + counter)]
		mov WORD [counter], 490 ;coordenada x do primeiro pixel
	.loop:
		mov cx, [counter]
		call pixel_print 
		inc WORD [counter]	;(*counter)++
		cmp WORD [counter], 630 ;if counter >= 100
		jae .endloop	;jump to endloop
		jmp .loop		;else restart the loop
	.endloop:
	inc dx
ret

pixel_print:
	mov ah, 0Ch ;pixel na coordenada [dx, cx]
	mov bh, 0
	int 10h
ret

;-------------------------------------------------;
;--------------Auxiliary functions----------------;
;-------------------------------------------------;

;This function returns a randomized value in bx and uses the value in [rand] as a seed
random:
	mov ah, 0x2
	int 0x1A
	xor ch, ch
	add cl, dh
	mov word[rand], cx 	;gets the seed for the random function from the clock and saves in the variable "rand"

	mov ax, word[rand]	;seed 1
	mov dx, word[rand_num1] ;seed 2
	mov cx, word[rand_num]	;seed 3	

	mov bx, dx
	xor bx, cx
	mov word[rand_num1], cx
	mov word[rand_num], bx

	inc word[rand_num]
	mul dx
	add ax, cx
	;xor ah, ah
	mov word[rand], ax	;updates seed
	and al, 11b			;same as al = al%4
	inc al				;a1 = [1, 4]
	mov bl, al			;bl = ah
	xor bh, bh 			;bx  ==  bl
ret

mini_delay:			;0.5 sec delay			
	mov ah, 86h		;wait
	mov cx, 0x1	;high order word
	mov dx, 0		;cx:dx == 7A120
	int 15h			;interrupt 
ret

delay:				;0.5 sec delay			
	mov ah, 86h		;wait
	mov cx, 1Ah		;high order word
	mov dx, 1Ah		;cx:dx == 7A120
	int 15h			;interrupt 
ret

;Save the string in si before using this function.
print_string:			;Função de printar string na tela
		lodsb				;al = string[si++]
		cmp al, 0			;if(char == '\0')
		je fim_print		;then go to fim_print
		call print_char		;else go to print_char
	jmp print_string		;loop again

	fim_print:				;return
		mov al, 10			
		call print_char		;printa a new line
		mov al, 13			
		call print_char		;printa o carriage return
ret

;Save the char in the reg al before using this function.
print_char:				;Função de printar caractere na tela
	mov ah,0xe			;Codigo da instrucao de imprimir um caractere que esta em al
	mov bl,0xf			;Cor do caractere em modos de video graficos (branco)
	int 10h				;Interrupcao de video.
ret

show_color: 			;mostra cor em bl
	mov ah, 0xb 		;numero da chamada
	mov bh, 0  			;id da paleta de cores
	int 10h				;video interrupt		
ret

clear_screen:
    mov ah, 0 	;call number
    mov al, 12h ;video mode
    int 10h
ret

end:
;Turn off the system
mov ax,0x5307
mov bx,0x0001
mov cx,0x0003
int 0x15