org 0x7c00
jmp 0x0000:start

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Created by nmf2		;
;	Assembly is Love <3	;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mult: dw 1
string: times 5 db 0
dez: db 10
num: dw 0
n: db 0

start:
	xor ax, ax
	mov es, ax
	mov ss, ax	; setup stack
	mov sp, 0x7C00	; stack grows downwards from 0x7C00
	mov di, ax	; zera di

	get_num:
		push ax			;manda ax para a pilha (vai servir em .transform)

		.loop:
		mov ah, 0		;instrução para ler do teclado
		int 16h			;interrupt de teclado
		cmp al, 0x1b	;comparar com ESC
		je end			;acabar programa
		cmp al, 0x0d	;comparar com \n
		je .transform	;fim da string
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
		cmp al, 0		;se for o \0
		je .done		;acabou get_num

		sub ax, 48		;transform from char to int
		mul word [mult]		;multiplica ax por mult (mul) e salva em dx:ax
		add ax, cx		;soma o que já estava em num (cx) com o resultado de mult*ax
		mov di, num		;coloca num em di
		stosw			;salva ax em num
		mov ax, [mult]		;salva muti em ax
		mul byte [dez]		;multiplica ax por 10

		mov di, mult		;di = mult
		stosw			;manda ax para mult

		jmp .transform		;recomeça

		.done:
			jmp calculate		;calculate faz as contas com inteiro (num) e imprive

	print_char:			;imprime o caracter em al
		push ax
		mov ah, 0x0e	;instrução para imprimir na tela
		int 10h
		pop ax			;interrup de tela
		ret

	print_int:			;mostra inteiro em al como string na tela
		xor dx, dx
		xor cl, cl

		.sts:			;começa conversão (sts = send to stack)

		div byte[dez]		;divide ax por cl(10) salva quociente em al e resto em ah
		mov dl, ah		;manda ah pra cl
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
		call new_line		;imprime nova linha
		
		mov ax, [num]		;coloca num em ax
		
		xor bx,bx 			;VALOR FINAL..

		cmp ax, 0			;compara ax com 0
		je .fim_calculo		;se for igual, nada a fazer
		;caso contrario, mais que 0: 

		.mq0: ;mais que 0
			add bx, 8		
			cmp ax, 30		;compare ax com 30
			jg .mq30		;se for maior, vá para mais que 30
			cmp ax, 10		;compare ax com 10
			jl .fim_calculo	;se for menos que 10, acabou
								
		.entre10_30:		;caso contrário:
			sub ax, 10		;subtrai 10 de ax
			sal ax, 1		;shift left em ax, multiplica ax por dois
			add bx, ax		;some bx com ax

			jmp .fim_calculo	;acabou o calculo

		.mq30:
			add bx, 40		;soma 40 a bx, o máximo pra mais q 30

			cmp ax, 100		;compare ax com 100
			jg .mq100		;se for maior ou igual, vá para mais que 100

		.entre30_100:		;caso contrário
			sub ax, 30		;subtrai 30 de ax
			mov cx, 4 		;coloque 4 em cl (valor da taxa)

			mul cx			;multiplique ax por 4
			add bx, ax		;some bx com ax
			jmp .fim_calculo	;acabou o calculo

		.mq100:
			add bx, 280		;soma 280 a bx, o máximo pra mais q 100
			sub ax, 100		;subtrai 100 de ax
			mov cx, 6 		;coloque 6 em cl (valor da taxa)

			mul cx			;multiplique ax por 6
			add bx, ax		;some bx com ax
		
		.fim_calculo:			;acabou o calculo
			call new_line 	;nova linha
			mov ax, bx		;ax = bx
			sar ax, 1		;shift right,  divide por 2

			mov cx, 3		;cl = 3
			mul cx			;ax = ax * cl

			call print_int 	;print ax 	
			call new_line
			jmp end

	new_line:
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
