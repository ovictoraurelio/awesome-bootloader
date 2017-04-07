org 0x7c00
jmp 0x0000:_start
;Declaracao de variaveis

_start:					;inicio da main
	mov ax, 0
	mov ds, ax

	mov ah, 0 ;numero da chamada
	mov al, 12h ;modo de video
	int 10h

	mov ah, 0xb ;numero da chamada
	mov bh, 0  	;id da paleta de cores
	mov bl, 0x1 ;
	int 10h

jmp end					;fim da main

end:
int 20h
jmp $
times 510 - ($ - $$) db 0
dw 0xaa55	