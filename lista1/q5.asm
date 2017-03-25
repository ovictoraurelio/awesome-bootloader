;DecHex	Binary	Color
;0	0	0000	Black	 
;1	1	0001	Blue	
;2	2	0010	Green	
;3	3	0011	Cyan	
;4	4	0100	Red	
;5	5	0101	Magenta	
;6	6	0110	Brown	
;7	7	0111	Light Gray	
;8	8	1000	Dark Gray	
;9	9	1001	Light Blue	
;10	A	1010	Light Green	
;11	B	1011	Light Cyan	
;12	C	1100	Light Red	
;13	D	1101	Light Magenta	
;14	E	1110	Yellow	
;15	F	1111	White
org 0x7c00
jmp 0x0000:_start
;Declaracao de variaveis
counter times 1 dw 0

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
	call square_print
		
jmp end					;fim da main

square_print:
		mov al,0x4 ;cor do pixel (azul)
		mov dx, 90
		mov cx, 150
	.loop:
		add cx, [counter]	;printa na coordenada [dx,(cx + counter)]
		call pixel_print 
		inc BYTE [counter]	;(*counter)++
		cmp BYTE [counter],100 ;if counter >= 100
		jae .endloop	;jump to endloop
		jmp .loop		;else restart the loop
	.endloop:
ret

pixel_print:
	mov ah, 0Ch ;pixel na coordenada [dx, cx]
	mov bh, 0
	int 10h
ret
		
end:
int 20h
jmp $
times 510 - ($ - $$) db 0
dw 0xaa55	