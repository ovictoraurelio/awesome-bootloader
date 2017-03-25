;//Maiusc. > 64 && < 91      Minusc. > 96 && < 123         fator de conversao: |32|
;i = 0
;while(char[i] != '\0')
;{
;	if(char[i] > 64)
;		if(char[i] > 96)
;			char[i] -= 32
;		else
;			char[i] += 32
;}
org 0x7c00
jmp 0x0000:_start
;Declaracao de variaveis
string times 64 db 0
string1: db "Oi", 10, 13, 0
string2: db "looper", 10, 13, 0

_start:					;inicio da main
	xor ax,ax			;zera os regs
	mov ds,ax
	mov es,ax
	
	mov di,string		;di = &string[0]
	call string_read	;le a string do teclado
	
	;mov si, string		;si = &string[0]
	;call print_string	;printa a string lida
	;ate aqui ok
	call des_capitalizar
	mov si, string		;si = &string[0]
	call print_string	;printa a string lida
		
jmp end					;fim da main

string_read:			;inicio da funcao
    call char_read		;chama funcao de leitura de caractere
	;cmp al,0xa			;if(char == '\n')
	;je end;_read		;then go to end_read		
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

print_string:			;Função de printar string na tela
	lodsb				;al = string[si++]
	
	;call print_char
	
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

print_char:				;Função de printar caractere na tela
	mov ah,0xe			;Codigo da instrucao de imprimir um caractere que esta em al
	mov bl,2			;Cor do caractere em modos de video graficos (verde)
	int 10h				;Interrupcao de video.
ret

des_capitalizar:
	mov di,string			;di = string
	do:
		
		;mov al,BYTE [di]
		;call print_char
		
		cmp BYTE [di],65				;compara string[di] com 64
		jb while						;se for menor que 65, finaliza
		cmp BYTE [di],91
		jb descapitalizar				;se for maior que ou igual a 65 e menor que 91, descapitaliza
		cmp BYTE [di],97
		jb while						;se for maior que e 91 e menor que 97, finaliza
		cmp BYTE [di],123
		jb capitalizar					;se for >=97 e < 123, capitaliza
	
		capitalizar:
			sub BYTE [di],32			;string[di] -= 32
		jmp while
		
		descapitalizar:	
			add BYTE [di],32			;string[di] += 32
		jmp while
		
	while:
		cmp BYTE [di],0
		je end_cap
		inc di					;di++
		jne do					;loop
		
end_cap:
		;mov si, string2		;si = &string[0]
		;call print_string	;printa a string lida
ret
		
end:
jmp $
times 510 - ($ - $$) db 0
dw 0xaa55	