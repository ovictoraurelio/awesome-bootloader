org 0x7e00
jmp _start
;Declaracao de variaveis

string db "A problem has been detected and Ruindows has been shut down to prevent damage", 13, 10
string1 db "to your computer.", 13, 10, 10
string2 db "DRIVER_MACROZOSFT_NOT_WELL_MADE", 13, 10, 10
string3 db "If this is the first time you've seen this error screen, restart your", 13, 10
string4 db "computer and use Lenux. If it is the second or further time you've", 13, 10
string5 db "seen this error screen, restart your computer and use Lenux.", 13, 10,
string6 db "If you know how to do it, DO NOT read these steps:", 13, 10, 10
string7 db "Check to make sure you are alone and your windows are properly closed.", 13, 10
string8 db "Turn off the lights. Pay attention.", 13, 10
string9 db "Calm down and have a coffee, don't be afraid. Read carefully.", 13, 10
string10 db "My name is Samara, I'm 14 years old (I would be if I were alive),", 13, 10
string11 db "I was hit by a car in a rainy night, no one helped me, I died alone.", 13, 10
string12 db "Send this message to 10 friends, and you'll save my tormented soul", 13, 10
string13 db "do it fast, or I'll visit you at night.", 13, 10, 10
string14 db "Technical information:", 13, 10, 10
string15 db "*** STOP: 0xSA00SAD1 (0xMA000MA0, 0xRA00RA11, 0x0D0E0A0D, 0xF7662E73)", 13, 10
string16 db "*** atp.samara (Address F77E43C9 base at F77X2000, Datestamp 3b7d83e5)", 13, 10, 10
string17 db "Collecting data for crash dump...", 13, 10
string18 db "Beginning dump of physical memory...", 13, 10
string19 db "Physical memory dump complete.", 13, 10
string20 db "Contact your system administrator or technical support group for further", 13, 10
string21 db "assistance.", 13, 10, 0

_start:					;inicio da main
	mov ax, 0
	mov ds, ax

	mov ah, 0 ;numero da chamada
	mov al, 12h ;modo de video
	int 10h

	mov ah, 0xb ;numero da chamada
	mov bh, 0  ;id da paleta de cores
	mov bl, 0x1 ;cor azul
	int 10h

	mov si, string ;ponteiro pra string
	call print_string
	int 10h

jmp end					;fim da main

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

print_char:				;Função de printar caractere na tela
	mov ah,0xe			;Codigo da instrucao de imprimir um caractere que esta em al
	mov bl,0xf			;Cor do caractere em modos de video graficos (branco)
	int 10h				;Interrupcao de video.
ret

end: