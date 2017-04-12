org 0x7c00
jmp 0x0000:_start
;Variable declaration area
score dw 0
highscore dw 0
game_over_msg db "Game Over!" ; tamanho = 10
score_msg db "Your score is: " ;tamanho = 15
highscore_msg db "The High Score is: " ;tamanho = 19
number times 2 db 0
ten db 10
rand dw 0
i db 0
sequence times 40 db 0 
head dw 0

_start:
	xor ax, ax		;ax to 0
	mov ds, ax		;ds to 0

	mov al, 'b'
	mov ah,0xe		;print char in al
	mov bl,0xf		;char color (white)
	int 10h
	call delay

	.random:
		mov ah, 0
		int 0x1A
		mov word[rand], dx 	;gets the seed for the random function from the clock and saves in the variable "rand"

	mov ax, word[rand]
	call print_int

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

;-------------------------------------------------;
;--------------Auxiliary functions----------------;
;-------------------------------------------------;
delay:				;0.5 sec delay			
	mov AH, 86h		;wait
	mov CX, 001Ah	;high order word
	mov DX, 011Ah	;cx:dx == 7A120
	int 15h			;interrupt 
ret

;Save the char in the reg al before using this function.
print_char:				;Função de printar caractere na tela
	mov ah,0xe			;Codigo da instrucao de imprimir um caractere que esta em al
	mov bl,2			;Cor do caractere em modos de video graficos (verde)
	int 10h				;Interrupcao de video.
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