org 0x7c00
jmp 0x0000:start

;   ♥ ♥ ♥ ♥ ♥
;   Assembly is love
;   @ovictoraurelio

mult: dw 1
dez: db 10
num: dw 0
stringMesmoTamanho: db 13, 10, 'A entrada informada é inválida' , 13, 10 , 0


string: times 5 db 0
n: db 0

start:
	; ax is a reg to geral use
	; ds
	xor ax,ax ;; ax=0
	mov ds,ax
	mov es, ax
	mov ss, ax	; setup stack
	mov sp, 0x7C00	; stack grows downwards from 0x7C00
	mov di, num; di aponta pra num
	stosw		; manda ax para num
	mov di, ax	; zera di

  read1:
      call get_num

			;mov si, num
			;call print_string


		get_num:
				xor ax, ax
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


						xor ah, ah		;zerar ah
						push ax			;mandar ah e al para a pilha pois al não pode ir sozinho, ah será ignorado

						call print_char 	;imprime o caracter recebido
						stosb			;manda char em al para string e di++

						jmp .loop 		;próximo caractere

				.transform: 		;transformar string em numero

						mov si, num		;coloca num em si
						lodsw							;lê num e coloca em ax
						mov cx, ax 				;coloca num (ax) em cx

						pop ax						;pop na pilha (só se usa al)
						cmp ax, 0					;se for o \0
						je .done					;acabou get_num

						sub ax, 48				;transform from char to int
						mul word [mult]		;multiplica ax por mult (mul) e salva em dx:ax
						add ax, cx				;soma o que já estava em num (cx) com o resultado de mult*ax
						mov di, num		;coloca num em di
						stosw							;salva ax em num
						;call print_char	;debug

						mov ax, [mult]		;salva muti em ax
						mul byte [dez]		;multiplica ax por 10

						mov di, mult			;di = mult
						stosw							;manda ax para mult

				jmp .transform		;recomeça
				.done:
						call new_line
						mov ax, word[num]	;coloca num em ax
						call print_int
						call new_line

						mov ax,word[num]
						xor bx,bx ;; VALOR FINAL..

						mov cx,ax
						;; caso  <10
						cmp ax,11
						jl .ate10

						cmp ax,31
						jl .ate30

						cmp ax,101
						jl .ate100
										push ax
										call new_line
										call new_line
										sub ax,100
										mov dx,ax
										call print_int

										mov cx, 6
										mul cx,
										add bx,ax

										pop ax
										sub ax,dx
								.ate100:
										push ax
										call new_line
										call new_line
										sub ax,30
										call print_int

										mov cx,4
										mul cx
										add bx,ax

										pop ax
								.ate30:
										push ax
										call new_line
										call new_line
										call print_int
										sub ax,10
										mov dx,ax

										mov cx,2
										mul cx
										add bx,ax

										pop ax
										sub ax,dx
								.ate10:
										add bx,8

								.finCalculo:
										;mov ah,bl
										;mov al,2
										;div al
										;add bx,ax
										mov ax,bx
								call print_int			;mostra inteiro em al como string na tela

							; imprime sufuxo "

						;jmp read1
							;imprime a string (salvar string na memoria tbm)
;;				call calculate		;calculate faz as contas com inteiro (num) e imprive




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

		.print:						;caso contrário
				pop ax			;pop na pilha pra ax
				add al, 48		;transforma numero em char
				call print_char	;imprime char em al
				dec cl			;decrementa cl
				cmp cl, 0		;compara al com 0
				jne .print		;se o contador não for 0, imprima o próximo char

ret				;caso contrario, retorne



;***
;	** Get a string
;				mov di, STRING
;				get_string
;
get_string:
    .loop:

        mov ah, 0	    ;instruction to read of keyboard
    		int 16h		    ;interruption to read of keyboard

        cmp al, 0x1B
        je end			  ;if equal ESC jump to end
        cmp al, 0x0D
        je .done	    ;if equal ENTER done of string

        call print_char	    ;show char on screen
        stosb			          ;saves char on memory

				;;counters...
				inc ch ;; counter that contain length of stringH
				inc cl ;; counter that contain length of stringL

        jmp .loop 		      ;return to loop, read antoher char
  .done:
        mov al, 0       ;adding 0 to knows end of string
        stosb
  ret

;***
;	** Print a string
;				mov si, STRING
;				print_string
print_string:
	lodsb		; load al, si index and si++
	cmp al,0	; compare al with 0 (0, was set as end of string)
	je endprintstring

	mov ah,0xe	; instruction to show on screen
	mov bh,13h
	int 10h		; call video interrupt

jmp print_string
endprintstring: ret
;***
;	** Print new line
;***
new_line:
		push ax
    mov al, 10
    call print_char
    mov al, 13
    call print_char
		pop ax
ret
;***
;	** Print a char
;***/
print_char:		;imprime o caracter em al
		push ax
    mov ah, 0x0e	;instrução para imprimir na tela
    int 10h		;interrup de tela
		pop ax
ret


end:
	jmp $
	times 510 - ($ - $$) db 0
	dw 0xaa55