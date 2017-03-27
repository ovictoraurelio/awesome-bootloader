org 0x7c00
jmp 0x0000:_start
;
;for(i = 0; i < number_programs;i++)
;{
;	scanf(inteiro[i])
;	{
;		string_to_int()
;		if(inteiro[i] > maior)
;			maior = inteiro[i]
;		if(inteiro[i] < menor)
;			menor = inteiro[i]
;	}
;}
;printf(maior)
;printf(menor)
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

str_maior: db " - O(n!) :(", 13, 10, 0
str_menor: db " - O(lg n) :)", 13, 10, 0

_start:					;inicio da main
	mov di, string 		;di = &string[0]
	call string_read 	;scanf(n_programs)
	
	;mov si, string 		;si = &string[0]
	;call print_string 		;printf(n_programs)
	
	mov si, string
	call string_to_int ;string_to_int()

	mov al, 'a'
	call print_char
	
	push cx
	mov cx, [integer]  ;n_programs = integer
	mov [n_programs], cx
	pop cx

	mov al, 49;byte[n_programs]
	call print_char

jmp end					;fim da main

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
		call print_char
		mov al, si
		cmp al, 0 ;if string[si] == 0
		je .endfunc ; jump to endfunc

		mov al, byte[ten] ;multiplies the integer by 10
		call print_char
		mul byte[integer]
		mov byte[integer], al
		
		;mov al, byte[integer]
		;call print_char

		mov bl, [si]
		add byte [integer], bl;integer + si (ASCII)
		sub byte [integer], 48	;integer - 48 (integer)

		inc si
		
		;mov al, byte[integer]
		;call print_char
	jmp .loop

	;pop ax ;pops the value in al from the stack
.endfunc:
mov al, 'c'
call print_char
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