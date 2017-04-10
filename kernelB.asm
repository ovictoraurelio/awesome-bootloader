org 0x7c00
jmp 0x0000:start

score dw 0
highscore dw 0
game_over_msg db "Game Over!" ; tamanho = 10
score_msg db "Your score is: " ;tamanho = 15
highscore_msg db "The high_score is: " ;tamanho = 19
number times 2 db 0
dez db 10
rand dw 0
i db 0
sequence times 40 db 0
stack dw 0


start:
	.random:
		mov ah, 0
		int 0x1A
		mov word[rand], dx

	.init:
		xor ax, ax		;zera ax
		mov es, ax		;zera es
		mov di,	number 	;coloca number em di
		stosw 			;manda ax (0) para es:di (number)
		mov cx, ax		;zera cx
		mov ds, ax		;zera ds
		mov ss, ax
		mov sp, 7C00h	;setup SP

	.video_mode:
		mov ah, 0 		;numero da chamada
		mov al, 12h 	;modo de video
		int 10h

	game:
		call random 	;makes bl a random number between 1 and 4 and bh == 0
		push bx

		show_sequence:
			pop bx
			cmp bx, 0			;compara bx com 0
			je get_answer		;se for igual vá para get answer
			call show_color		;muda background pra cor q está em bl
			call delay			;delay
			jmp show_sequence	;recomeça

		;GERSON
		;mostra mensagem pra pedir sequencia invertida
		get_answer:
			times 4 call delay			;delay
			jmp game

		.next_level:
			;print next level message
			call inc_score	;incrementa score
			mov ax, word[score]
			cmp ax, word[highscore]
			jg game
			inc word[highscore]
			jmp game

	game_over:
		mov bp, game_over_msg 	;coloca endereço em bp
		mov cx, 10				;tamanho da msg
		mov dl, 20				;coluna pra começar
		mov dh, 20				;linha pra começar
		mov ds, sp				;salva stack
		call print_msg		;parametros:cx-tamanho,bp-ponteiro,dh-linha,dl-coluna
		mov sp, ds				;restaura stack

		mov bp, score_msg		;coloca endereço em bp
		mov cx, 15				;tamanho da msg
		mov dl, 20				;coluna pra começar
		mov dh, 21				;linha pra começar
		mov ds, sp				;salva stack
		call print_msg		;parametros:cx-tamanho,bp-ponteiro,dh-linha,dl-coluna
		mov sp, ds				;restaura stack

		mov ax, word[score]
		call int_to_memory 		;transforma int em ax pra string em number
		mov bp, number			;coloca endereço em bp
		mov cx, 3				;tamanho da msg
		mov dl, 36				;coluna pra começar
		mov dh, 21				;linha pra começar
		mov ds, sp				;salva stack
		call print_msg		;parametros:cx-tamanho,bp-ponteiro,dh-linha,dl-coluna
		mov sp, ds				;restaura stack

		mov bp, highscore_msg		;coloca endereço em bp
		mov cx, 19				;tamanho da msg
		mov dl, 20				;coluna pra começar
		mov dh, 22				;linha pra começar
		mov ds, sp				;salva stack
		call print_msg 		 	;parametros:cx-tamanho,bp-ponteiro,dh-linha,dl-coluna
		mov sp, ds				;restaura stack

		mov ax, word[highscore]
		call int_to_memory 		;transforma int em ax pra string em number
		mov bp, number		;coloca endereço em bp
		mov cx, 3				;tamanho da msg
		mov dl, 40				;coluna pra começar
		mov dh, 22				;linha pra começar
		mov ds, sp				;salva stack
		call print_msg		;parametros:cx-tamanho,bp-ponteiro,dh-linha,dl-coluna
		mov sp, ds				;restaura stack
		times 10 call delay		;chama delay 10 vezes (5 segundos)

		jmp start


;-----------------------------------------------------------------------------------;
;							   		SUB ROTINAS 									;
;-----------------------------------------------------------------------------------;

inc_score:	;incrementa score
	push ax			;salva ax na pilha
	mov si, score 	;coloca endereço de score em ds
	lodsw 			;ax = [score]
	inc ax			;ax++
	mov di, score 	;coloca endereço de score em es
	stosw 			;[score] = ax
	pop ax			;restaura ax
ret

delay:		;delay de .5 segundos
	mov AH, 86h		;wait
	mov CX, 000Ah		;high order word
	mov DX, 000Ah	;cx:dx == 7A120
	int 15h			;interrupt
ret

show_color: 			;mostra cor em bl
	mov ah, 0xb ;numero da chamada
	mov bh, 0  	;id da paleta de cores
	int 10h		;id da paleta de cores
	mov word[stack], sp
	int 10h				;video interrupt
	mov sp, word[stack]
ret

print_msg:	;parametros:cx-tamanho,bp-ponteiro,dh-linha,dl-coluna
			;salvar sp antes de chamar pois o interrupt destroi o valor de sp
	mov ah, 0xb	;numero da chamada
	mov bh, 0  	;id da paleta de cores
	mov bl, 0x8	;cor cinza escuro
	int 10h

	mov ah, 13h		;printa string
	mov bh, 0  		;numero da pagina
	mov bl, 0xf 	;cor dos caracteres
	;mov cx, 76  	;tamanho da string
	;mov dh, 0  	;linha inicial
	;mov dl, 0  		;coluna inicial
	;mov bp, string ;ponteiro pra string
	int 10h
ret

int_to_memory:
	push ax			;salva ax
		;zera number
	mov ah, '0'		;
	mov al, '0'		;
	mov di, number  ;
	stosw 			;manda ax (0) para es:di (number)
		;fim zera number
	pop ax			;restaura ax

	add di, 2		;faz di =+ 2, a escrita vai do fim do número pro começo

	.sts:			;começa conversão (sts = send to stack)

	div byte[dez]		;divide ax por cl(10) salva quociente em al e resto em ah
	xchg al, ah		;troca ah com al, resto agr está em al
	add al, 48		;transforma em ascii
	lodsb 			;manda char pra memória
	mov al, 0		;zera al
	xchg ah, al		;troca ah com al, quociente agr está em al e ah está zerado
	cmp al, 0		;compara o quociente(al) com 0
	jne .sts		;se não for 0 manda próximo caractere para pilha

ret					;caso contrario, retorne

random:
	mov ax, word[rand]
	mov dx, 7993
	mov cx, 9781
	mul dx
	add ax, cx
	mov word[rand], ax	;updates seed
	mov cl, 4
	div cl				;al = ax/cl, ah = ax % cl
	inc ah				;ah = [1, 4]
	mov bl, ah			;bl = ah
	xor bh, bh 			;bx  ==  bl
ret


jmp $

times 510 - ($ - $$) db 0
dw 0xaa55