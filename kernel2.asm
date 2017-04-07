org 0x7c00
jmp 0x0000:start

score dw 0
highscore dw 0
game_over_msg db "Game Over!" ; tamanho = 10
score_msg db "Your score is: " ;tamanho = 15
highscore_msg db "The high_score is: " ;tamanho = 19
number times 2 db 0
dez db 10


start:
	mov ax, 0x9000	;stack address
	mov ss, ax		;setup stack
	xor ax, ax		;zera ax
	mov es, ax		;zera es
	mov di,	number 	;coloca number em di
	stosw 			;manda ax (0) para es:di (number)
	mov cx, ax		;zera cx
	mov ds, ax		;zera ds
	mov sp, ax		;zera sp
	push ax			;manda ax pra pilha (0)

	;inicia modo de video
	mov ah, 0 ;numero da chamada
	mov al, 12h ;modo de video
	int 10h



	game:
		;gera numero aleatório
		;mov ah, 00h		;coloca numero de clocks desde meia noite em cx:dx
		;int 1AH			;time interrupt
		;mov ax, dx		;ax = dx
		;mov cl, 4		;cl = 4
		;div cl 			;ah recebe o resto, ah é o numero aleatório
		inc ah			;ah está entre 1 e 4
		;fim - numero aleatorio em ah
		;ah é a cor aleatória 1 - azul, 2 - verde, 3 - ciano, 4 - vermelho
		xor al, al		;zera al
		xchg ah, al		;troca ah por al, agora a cor está em al
		push ax			;manda ax pra pilha, cor está em al

		mov cx, sp		;salva top da pilha
		mov ax, bx
		inc bl
		mov dx, sp			;salva pilha
		call show_color		;muda background pra cor q está em bl
		mov sp, dx			;restaura pilha

		call delay 			
		inc bl

		mov dx, sp			;salva pilha
		call show_color		;muda background pra cor q está em bl
		mov sp, dx			;restaura pilha
		call delay 			
		inc bl

		mov dx, sp			;salva pilha
		call show_color		;muda background pra cor q está em bl
		mov sp, dx			;restaura pilha
		call delay 			
		inc bl


		.show_sequence:
			pop bx				;pega cor da pilha e coloca em bl, faz sp += 2
			cmp bx, 0			;compara bx com 0
			je get_answer		;se for igual vá para get answer
			mov dx, sp			;salva pilha
			call show_color		;muda background pra cor q está em bl
			mov sp, dx			;restaura pilha
			call delay			;delay
			mov bl, 0			;coloca preto em bl
			mov dx, sp			;salva pilha
			call show_color		;muda background pra cor q está em bl
			mov sp, dx			;restaura pilha
			call delay			;delay
			jmp .show_sequence	;recomeça

		mov sp, cx		;restaura top da pilha

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
	push ax			;salve ax
	push cx			;salve cx
	push dx			;salve dx
	mov AH, 86h		;wait
	mov CX, 7Ah		;high order word
	mov DX, 120h	;cx:dx == 7A120
	int 15h			;interrupt 
	pop dx			;restore dx
	pop cx			;restore cx
	pop ax			;restore ax
ret

show_color:		;mostra cor em bl
	mov ah, 0xb 	;numero da chamada
	mov bh, 0 		;id da paleta de cores
	mov cx, sp
	int 10h			;video interrupt
	mov sp, cx		
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


jmp $

times 510 - ($ - $$) db 0
dw 0xaa55