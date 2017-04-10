org 0x7c00 ;this command 

; ♥ ♥ ♥ ♥ ♥
; Assembly is love 
; @ovictoraurelio


jmp 0x0000:start


string:
	db "Hello Observe Universe", 13, 10, 0

start:
	; ax is a reg to geral use
	; ds 
	mov ax,0 	;ax = 0
	mov ds,ax 	;ds = 0
	mov cl,0	;cl = 0

	; load first memory postion of my string on SI (source)
	mov si, string
	
	print:
		lodsb		; load al, si index and si++
		cmp cl,al	; compare al with 0 (0, was set as end of string)
		je end
		
		mov ah,0xe	; instruction to show on screen
		mov bh, 13h	
		int 10h		; call video interrupt

	jmp print

end:
	jmp $
	times 510 - ($ - $$) db 0
	dw 0xaa55

	
	
	
