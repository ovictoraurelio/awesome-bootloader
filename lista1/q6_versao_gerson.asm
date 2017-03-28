org 0x7c00
jmp 0x0000:_start
;
; Assembly is the best-worst love of all time.
; Made by Jose Gerson Fialho Neto - jgfn1@github.com
; With contributions of Nathan Martins Freire.
;
;for(i = 0; i < number_programs;i++)
;{
;	scanf(inteiro[i])
;	{
;		string_to_int()
;		if(inteiro[i] > bigger)
;			bigger = inteiro[i]
;		if(inteiro[i] < lower)
;			lower = inteiro[i]
;	}
;}
;printf(bigger)
;printf(lower)
;

;Variable declaration
;int n_programs
;int counter
;int bigger
;int lower
;int integer = 0;
n_programs db 0
counter db 0
bigger db 0
lower db 0
string times 64 db 0
integer db 0
ten db 10

str_bigger: db " - O(n!) :(", 13, 10, 0
str_lower: db " - O(lg n) :)", 13, 10, 0

_start:					;inicio da main
;--------------------------------------------------------; 
	mov di, string 		;di = &string[0]
	call string_read 	;scanf(n_programs)
	
	mov si, string
	call string_to_int ;string_to_int()
	
	mov cl, byte[integer]  ;n_programs = integer
	mov byte[n_programs], cl

	mov byte[integer], 0
	mov byte[string], 0
	mov si, 0 		 

	
	mov di, string 		;di = &string[0]
	call string_read 	;scanf(n_programs)
	
	mov si, string
	call string_to_int ;string_to_int()


	xor cx, cx
	mov cl, byte[n_programs]
	sub cx, 1

	xor ax, ax
	mov al, byte[integer]
	mov byte[bigger], al
	mov byte[lower], al

	mov al, byte[integer]
	mov byte[integer], 0
	mov byte[string], 0

	cmp cx, 0
	je endloop
	loopReadNumbers:
			mov di, string 		;di = &string[0]
			call string_read 	;scanf(n_programs)
			
			mov si, string
			call string_to_int ;string_to_int()

			mov al, byte[integer]	
			cmp al, byte[bigger]
			ja .bigger
		.continue:
			mov al, byte[integer]	
			cmp al, byte[lower]
			jb .lower
			jmp .point
		
		.bigger:
				;mov al, 'a'
				;call print_char
				mov al, byte[integer]
				mov byte[bigger], al
		jmp .continue
		
		.lower:
				; push ax
				; xor ax, ax
				; mov al, 'b'
				; call print_char
				; pop ax
				mov al, byte[integer]
				mov byte[lower], al
	.point:
		mov byte[integer], 0
		mov si, 0 		 
		mov byte[string], 0 	
	loop loopReadNumbers 

	endloop:

	push ax
		xor ax, ax
		mov al, byte[bigger]
		call print_int
		mov si, str_bigger
		call print_string

		xor ax, ax
		mov al, byte [lower]
		call print_int
		mov si, str_lower
		call print_string
	pop ax
;--------------------------------------------------------;

jmp end					;fim da main

;To use this function, put the value you wanna print in the
;reg ax and be sure that there's no important data in the regs
;dx and cl.
print_int:			;mostra inteiro em al como string na tela
	xor dx, dx
	xor cl, cl
	.sts:			;começa conversão (sts = send to stack)
			div byte[ten]		;divide ax por cl(10) salva quociente em al e resto em ah
			mov dl, ah		;manda ah pra dl
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
			cmp cl, 0		;compara cl com 0
			jne .print		;se o contador não for 0, imprima o próximo char

ret				;caso contrario, retorne

;Function which converts a string to an integer.
;To use it, put the string pointer in the si reg and
;then get the result in the "integer" variable.
;
;for(si=0; string[i] != '\0'; ++si)
;{
;	integer *= 10;
;	integer += string[si] - 48;
;}
string_to_int:
	.loop:
		mov al, byte[integer]
		;call print_char
		mov al, [si] 	;equivalent to the first part of lodsb
		cmp al, 0 ;if string[si] == 0
		je .endfunc ; jump to endfunc

		mov al, byte[ten] ;multiplies the integer by 10
		;call print_char
		mul byte[integer]
		mov byte[integer], al
		
		;mov al, 't'
		;call print_char

		mov bl, [si]
		add byte[integer], bl;integer + si (ASCII)
		sub byte [integer], 48	;integer - 48 (integer)

		;mov al, byte[integer] 
		;call print_char
		
		;add al, 48
		;call print_char

		inc si ;second part of lodsb
		
		;mov al, byte[integer]
	jmp .loop
	;pop ax ;pops the value in al from the stack
.endfunc:
;mov al, 'c'
;call print_char
ret

;Save the string pointer in the di register before using
;this function.
string_read:			;inicio da funcao
    call char_read		;chama funcao de leitura de caractere		
	cmp al,0xd			;if(char(a) == carriage return)
	je end_read			;then go to end_read
	call print_char		;else go to print_char
	stosb				;string[di++] = char (al)
jmp string_read	
		
end_read:
	xor al,al			;al = '\0'
	stosb				;string[di++] = '\0' 
	mov al, 10			
	call print_char		;printa a new line
	mov al, 13			
	call print_char		;printa o carriage return
ret	
		
char_read:				;Função de leitura de caracteres		
	mov ah,0 			;salva a instrucao de leitura da interrupcao do teclado em ah
	int 16h  			;interruptor do teclado
ret

;Save the string pointer in the si register before using
;this function.
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
	mov bl,2			;Cor do caractere em modos de video graficos (verde)
	int 10h				;Interrupcao de video.
ret

end:
jmp $
times 510 - ($ - $$) db 0
dw 0xaa55	