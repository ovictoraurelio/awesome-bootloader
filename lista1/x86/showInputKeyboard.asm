org 0x7c00 ;this command 

jmp 0x0000:start


string:
	db "Digite um numero: ", 13, 10, 0

start:
				; ax is a reg to geral use
				; ds 
	mov ax,0 		;ax = 0
	mov ds,ax 		;ds = 0
	mov cl,0x0D		;cl = 0
				; load first memory postion of my string on SI (source)
	mov si, string

	scanf: 
		mov ah,0	; Keyboard read
		int 16h		; Keyboard interrupt
		
		cmp ah,cl
		je end

	printKeyboard:
		mov ah, 0xe	; Screen show content of al
		int 10h		; Screen interrupt
		
		jmp scanf
	

end:
	jmp $
	times 510 - ($ - $$) db 0
	dw 0xaa55

	
	
	
