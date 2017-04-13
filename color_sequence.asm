org 0x7c00
jmp 0x0000:_start
;Variable declaration area
score dw 0
highscore dw 0
game_over_msg db "Game Over!", 0
score_msg db "Your score is: ", 0
highscore_msg db "The High Score is: ", 0
number times 2 db 0
ten db 10
rand dw 0
rand_num dw 0
rand_num1 dw 0
i db 0
sequence times 40 db 0 
head dw 0
queue_front times 50 db 0
queue_rear db 0
queue_cursor db 0

_start:
	xor ax, ax		;ax to 0
	mov ds, ax		;ds to 0

	mov bx, [queue_front] 	;saves the memory adress of queue_front in bx
	mov [queue_cursor], bx	;saves the memory adress of bx in queue_cursor 
	mov [queue_rear], bx		;saves the memory adress of bx in queue_rear

	.video_mode:
		mov ah, 0 ;numero da chamada
		mov al, 12h ;modo de video
		int 10h

	call delay
;--------------------------------------------------------------------------------------------------;
;---------------------------------------------Working Area-----------------------------------------;
;--------------------------------------------------------------------------------------------------;
	game:
		call random 				;makes bl a random number between 1 and 4 and bh == 0
		mov byte[queue_rear], bl	;saves the randomly-generated value in the end of the queue

		mov bl, byte[queue_rear]
		call show_color		;muda background pra cor q está em bl
		call delay

		mov cl, queue_rear  
		inc cl 				;increments the queue_rear, points to the next memory address
		mov [queue_cursor], cl

		mov bl, byte[queue_rear]
		xor bh, bh
		mov ax, bx
		call print_int
		call delay 


		mov al, 0xa
		mov ah,0xe		;print char in al
		int 10h


		; .show_sequence:
		; 	mov bh, byte[queue_cursor] 
		; 	mov byte[queue_front], bh
		; 	.loop:
		; 		mov bl, byte[queue_cursor] 
		; 		cmp bl, 0			;compara bx com 0
		; 		je get_answer		;se for igual vá para get answer
		; 		add byte[queue_cursor], 1  				
		; 		call show_color		;muda background pra cor q está em bl
		; 		call delay			;delay
		; 	jmp .loop				;recomeça

		; ;GERSON
		; ;mostra mensagem pra pedir sequencia invertida
		; get_answer:
		; 	mov al, 'b'
		; 	mov ah,0xe		;print char in al
		; 	mov bl,0xf		;char color (white)
		; 	int 10h

		; 	times 2 call delay			;delay
		; 	jmp game

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

end:
;Turn off the system
mov ax,0x5307
mov bx,0x0001
mov cx,0x0003
int 0x15

jmp $
times 510 - ($ - $$) db 0
dw 0xaa55