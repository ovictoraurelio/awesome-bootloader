org 0x7e00
jmp _start

;Variable declaration area
score dw 0
highscore dw 0
game_over_msg db "Game Over!", 0
score_msg db "Your score is: ", 0
highscore_msg db "The High Score is: ", 0
menu_message db 13, 10, 13, 10, 13, 10, "             Welcome to the Lenux-based Color Sequence Game!", 13, 10, 13, 10, 13, 10, "Press Enter to start or ESC to leave"
number times 2 db 0
ten db 10
rand dw 0
rand_num dw 0
rand_num1 dw 0
i db 0
sequence times 40 db 0 
head dw 0
queue_front times 50 db 0 	;points to the initial memory address, holds the color values
queue_rear dd 0 	;Holds the memory address of the end of the queue 
queue_cursor dd 0 

_start:
	xor ax, ax		;ax to 0
	mov ds, ax		;ds to 0

	; mov es, queue_front 	;saves the memory adress of queue_front in ES:SI
	; mov dword[queue_cursor], bx	;saves the memory adress of queue_front in queue_cursor 
	; mov dword[queue_rear], bx	;saves the memory adress of queue_front in queue_rear

	.video_mode:
		mov ah, 0 	;call number
		mov al, 12h ;video mode
		int 10h

	;Game menu
	mov bl, 0x7 	;sets the screen color as dark grey
	call show_color

	mov si, menu_message
	call print_string	

	times 3 call delay
	call clear_screen
;--------------------------------------------------------------------------------------------------;
;---------------------------------------------Working Area-----------------------------------------;
;--------------------------------------------------------------------------------------------------;
	game:
		mov di, queue_front
		game_loop:
			call random 				;makes bl a random number between 1 and 4 and bh == 0
			mov al, bl 					
			cld 						;clears the direction flag so the "cursor" will go forward
			stosb 						;loads the randomly-generated value(in al) into the memory and points to next memory position
			
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

			.show_sequence:
				mov si, queue_front
				.loop:
					lodsb 				;gets the value in queue[si] and saves in al, then points si to the next position
					mov bl, al 			 
					cmp bl, 0			;compares bl with 0, to know if it reached the end of the numbers
					je get_answer		;if its equal go to get_answer				
					
					call show_color		;else, changes the background to the color which is in bl
					call delay			;delay
				jmp .loop				;loads the next memory position (next color)

			; ;GERSON
			; ;mostra mensagem pra pedir sequencia invertida
			get_answer:
				mov al, 'b'
				mov ah,0xe		;print char in al
				mov bl,0xf		;char color (white)
				int 10h

				times 2 call delay			;delay
				jmp game_loop

			; .next_level:
			; 	;print next level message
			; 	call inc_score	;incrementa score
			; 	mov ax, word[score]
			; 	cmp ax, word[highscore]
			; 	ja game
			; 	inc word[highscore]
				jmp game
;--------------------------------------------------------------------------------------------------;
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

delay:				;0.5 sec delay			
	mov AH, 86h		;wait
	mov CX, 001Ah	;high order word
	mov DX, 011Ah	;cx:dx == 7A120
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