org 0x7c00
jmp 0x0000:start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Created by nmf2		;
;	Assembly is Love <3	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mult: dw 1
dez: db 10
num: dw 0

start:
	xor ax, ax
	mov es, ax
	mov dx, ax
	mov ss, ax	; setup stack
	mov sp, 0x7C00	; stack grows downwards from 0x7C00
	mov di, num	; di aponta pra num
	stosw		; manda ax para num
	inc ax		;faz ax = 1
	mov di, mult	; di aponta pra mult
	stosw		; manda ax para mult
	mov di, es	; zera di
	mov ax, es	; zera ax


	get_num:
		push ax			;manda ax para a pilha (vai servir em .transform)

		.loop:
		mov ah, 0		;instrução para ler do teclado
		int 16h			;interrupt de teclado
		cmp al, 0x1b		;comparar com ESC
		je end			;acabar programa
		cmp al, 0x0d		;comparar com \n
		je .transform		;fim da string
		cmp al, '0'		;comparar al com '0'
		jl .loop		;se for menor que '0' não é um número, ignore
		cmp al, '9'		;comparar al com '9'
		jg .loop		;se for maior que '9' não é um numero, ignore

						;caso contrario
		call print_char 	;imprime o caracter recebido

		xor ah, ah		;zerar ah
		push ax			;mandar ah e al para a pilha pois al não pode ir sozinho, ah será ignorado
		jmp .loop 		;próximo caractere

		.transform: 		;transformar string em numero

		mov si, num		;coloca num em si
		lodsw			;lê num e coloca em ax
		mov cx, ax 		;coloca num (ax) em cx

		pop ax			;pop na pilha (só se usa al)
		cmp ax, 0		;se for o \0
		je .done		;acabou get_num

		sub ax, 48		;transform from char to int
		mul word [mult]		;multiplica ax por mult (mul) e salva em dx:ax
		add ax, cx		;soma o que já estava em num (cx) com o resultado de mult*ax
		mov di, num		;coloca num em di
		stosw			;salva ax em num
		;call print_char	;debug

		mov ax, [mult]		;salva muti em ax
		mul byte [dez]		;multiplica ax por 10

		mov di, mult		;di = mult
		stosw			;manda ax para mult

		jmp .transform		;recomeça

		.done:

					;imprime a string (salvar string na memoria tbm)
		call calculate		;calculate faz as contas com inteiro (num) e imprive

	print_char:			;imprime o caracter em al
		push ax
		mov ah, 0x0e	;instrução para imprimir na tela
		int 10h
		pop ax			;interrup de tela
		ret

	show_int:			;mostra inteiro em al como string na tela
		xor dx, dx
		xor cl, cl

		.sts:			;começa conversão (sts = send to stack)

		div byte[dez]		;divide ax por cl(10) salva quociente em al e resto em ah
		mov dl, ah		;manda ah pra dl
		mov ah, 0		;zera ah
		push dx			;manda dx pra pilha
		inc cl			;incrementa cl
		cmp al, 0		;compara o quociente(al) com 0
		jne .sts		;se não for 0 manda próximo caractere para pilha

		.print:
						;caso contrário
		pop ax			;pop na pilha pra ax
		add al, 48		;transforma numero em char
		call print_char	;imprime char em al
		dec cl			;decrementa cl
		cmp cl, 0		;compara al com 0
		jne .print		;se o contador não for 0, imprima o próximo char

		ret				;caso contrario, retorne

	calculate:
		mov al, 10			;coloca '\n' em al
		call print_char		;imprime char em al
		mov al, 13			;coloca '\r' (carriage return) em al
		call print_char		;imprime char em al

		mov ax, word[num]	;coloca num em ax
		call show_int		;imprime numero

						; imprime sufuxo " C\n\r"
		mov al, ' '			;coloca ' ' (espaço) em al
		call print_char			;imprime char em al
		mov al, 'C'			;coloca 'C' em al
		call print_char			;imprime char em al
		call newline

						;para farenheit
		xor ah, ah
		mov al, 9			;coloca 9 em al
		mul word[num]			;multiplica o conteudo de num por al e salva em ax
		mov cl, 5			;coloca 5 em cl
		div cl				;divide ax por 5 e salva em al
	 	push ax				;salva o resultado
		xor ah, ah			;limpa o resto em ah
		add ax, 32
		call show_int			;mostra inteiro em al como string na tela


		mov al, '.'                     ;coloca '.' em al
                call print_char         ;imprime char em al
		pop ax
		sal ah, 1 		;multiplica resto por 10/5 (2)
		xchg ah, al		;troca ah e al para poder imprimir o valor de ah
		xor ah, ah		;zera ah(já q foi mandado pra al)
		call show_int			;mostra resto (que está em al)


							; imprime sufuxo " F\n\r"
		mov al, ' '			;coloca ' ' (espaço) em al
		call print_char		;imprime char em al
		mov al, 'F'			;coloca 'F' em al
		call print_char		;imprime char em al
		mov al, 10			;coloca '\n' em al
		call print_char		;imprime char em al
		mov al, 13			;coloca '\r' (carriage return) em al
		call print_char		;imprime char em al

							;para kelvin
		mov ax, word[num]	;coloca num em ax
		add ax, 273			;soma 273 com ax
		call show_int		;mostra inteiro em al como string na tela

							; imprime sufuxo " K\n\r"
		mov al, ' '			;coloca ' ' (espaço) em al
		call print_char		;imprime char em al
		mov al, 'K'			;coloca 'F' em al
		call print_char		;imprime char em al
		mov al, 10			;coloca '\n' em al
		call print_char		;imprime char em al
		mov al, 13			;coloca '\r' (carriage return) em al
		call print_char		;imprime char em al
		call newline
		jmp start

	newline:
		push ax
		mov al, 10			;coloca '\n' em al
		call print_char		;imprime char em al
		mov al, 13			;coloca '\r' (carriage return) em al
		call print_char		;imprime char em al
		pop ax
		ret

end:
jmp $
times 510-($-$$) db 0		; preenche o resto do setor com zeros
dw 0xaa55					; coloca a assinatura de boot no final
								;do setor (x86 : little endian)
