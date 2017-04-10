org 0x7c00		;0x7e00
jmp 0x0000:_start
;Declaracao de variaveis

; string db "A problem has been detected and Windows has been shut down to prevent damage"
; string1 db "to your computer."
; string2 db "DRIVER_IRQL_NOT_LESS_OR_EQUAL"
; string3 db "If this is the first time you've seen this error screen,"
; string4 db "restart your computer. If this screen appears again, follow"
; string5 db "these steps:"
; string6 db "Check to make sure any new hardware or software is properly installed."
; string7 db "If this is a new installation, ask your hardware or software manufacturer"
; string8 db "for any Windows updates you might need."
; string9 db "If problems continue, disable or remove any newly installed hardware"
; string10 db "or software. Disable BIOS memory options such as caching or shadowing."
; string11 db "If you need to use Safe Mode to remove or disable components, restart"
; string12 db "your computer, press F8 to select Advanced Startup Options, and then"
string13 db "select Safe Mode."
string14 db "Technical information:"
string15 db "*** STOP: 0x000000D1 (0x00000000, 0x00000011, 0x00000000, 0xF7662E73)"
string16 db "*** atapi.sys (Address F77E43C9 base at F77X2000, Datestamp 3b7d83e5)"
string17 db "Collecting data for crash dump..."
string18 db "Beginning dump of physical memory..."
string19 db "Physical memory dump complete."
string20 db "Contact your system administrator or technical support group for further"
string21 db "assistance."

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

	mov ah, 13h ;printa string
	mov bh, 0 	;numero da pagina
	mov bl, 0xf ;cor dos caracteres
	; mov cx, 76 	;tamanho da string
	mov dh, 0 	;linha inicial
	mov dl, 0 	;coluna inicial
	; mov bp, string ;ponteiro pra string
	; int 10h

	; mov dh, 1 	;pula pra linha 1
	; mov cx, 17	;tamanho da string
	; mov bp, string1 ;ponteiro pra string
	; int 10h

	; mov dh, 2 	;pula pra linha 2
	; mov cx, 29	;tamanho da string
	; mov bp, string2 ;ponteiro pra string
	; int 10h

	; mov dh, 4 	;linha
	; mov cx, 56	;tamanho da string
	; mov bp, string3 ;ponteiro pra string
	; int 10h

	; mov dh, 5 	;linha
	; mov cx, 59	;tamanho da string
	; mov bp, string4 ;ponteiro pra string
	; int 10h

	; mov dh, 6 	;linha
	; mov cx, 12	;tamanho da string
	; mov bp, string5 ;ponteiro pra string
	; int 10h

	; mov dh, 8 	;linha
	; mov cx, 70	;tamanho da string
	; mov bp, string6 ;ponteiro pra string
	; int 10h

	; mov dh, 9 	;linha
	; mov cx, 73	;tamanho da string
	; mov bp, string7 ;ponteiro pra string
	; int 10h

	; mov dh, 10 	;linha
	; mov cx, 39	;tamanho da string
	; mov bp, string8 ;ponteiro pra string
	; int 10h

	; mov dh, 12 	;linha
	; mov cx, 68	;tamanho da string
	; mov bp, string9 ;ponteiro pra string
	; int 10h

	; mov dh, 13 	;linha
	; mov cx, 70	;tamanho da string
	; mov bp, string10 ;ponteiro pra string
	; int 10h

	; mov dh, 14 	;linha
	; mov cx, 69	;tamanho da string
	; mov bp, string11 ;ponteiro pra string
	; int 10h

	; mov dh, 15 	;linha
	; mov cx, 68	;tamanho da string
	; mov bp, string12 ;ponteiro pra string
	; int 10h

	mov dh, 16 	;linha
	mov cx, 17	;tamanho da string
	mov bp, string13 ;ponteiro pra string
	int 10h

	mov dh, 18 	;linha
	mov cx, 22	;tamanho da string
	mov bp, string14 ;ponteiro pra string
	int 10h

	mov dh, 20 	;linha
	mov cx, 69	;tamanho da string
	mov bp, string15 ;ponteiro pra string
	int 10h

	mov dh, 21 	;linha
	mov cx, 69	;tamanho da string
	mov bp, string16 ;ponteiro pra string
	int 10h

	mov dh, 23 	;linha
	mov cx, 33	;tamanho da string
	mov bp, string17 ;ponteiro pra string
	int 10h

	mov dh, 25 	;linha
	mov cx, 36	;tamanho da string
	mov bp, string18 ;ponteiro pra string
	int 10h

	mov dh, 26 	;linha
	mov cx, 30	;tamanho da string
	mov bp, string19 ;ponteiro pra string
	int 10h

	mov dh, 27 	;linha
	mov cx, 72	;tamanho da string
	mov bp, string20 ;ponteiro pra string
	int 10h

	mov dh, 28 	;linha
	mov cx, 11	;tamanho da string
	mov bp, string21 ;ponteiro pra string
	int 10h

jmp end					;fim da main

end:
jmp $ ;0x7c00
times 510 - ($ - $$) db 0
dw 0xaa55