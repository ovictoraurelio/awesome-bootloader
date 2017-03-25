;int number_programs
;int i
;int maior = 0
;int menor = 100000
;
;scanf(number_programs)
;for(i = 0; i < number_programs;i++)
;{
;	scanf(inteiro[i])
;	if(inteiro[i] > maior)
;		maior = inteiro[i]
;	if(inteiro[i] < menor)
;		menor = inteiro[i]
;}
;printf(maior)
;printf(menor)
;
;Funçao de converter string pra inteiro
;int i;
;int s = 0;
;for(i=0; string[i] != '\0'; ++i)
;{
;	s *= 10;
;	s += string[i] - 48;
;}

org 0x7c00
jmp 0x0000:_start
;Declaracao de variaveis
n_programs db 0
counter db 0
maior db 0
menor db 0

_start:					;inicio da main
	
		
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

end:
jmp $
times 510 - ($ - $$) db 0
dw 0xaa55	