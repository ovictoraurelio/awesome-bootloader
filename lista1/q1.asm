org 0x7c00
jmp 0x0000:start



str_impar: db 13, 10, "Impar", 13, 10, 0
str_par: db 13, 10, "Par", 13, 10, 0
start:
				; ax is a reg to geral use
				; ds
	mov ax,0 		;ax = 0
	mov ds,ax 		;ds = 0
;	mov cl,0x0D		;cl = 0

	scanf:
		mov ah,0	; Keyboard read
		int 16h		; Keyboard interrupt


		cmp al, 0x1B
		je end					;if equal ESC end program
		cmp al, 0x0D
		je compare		 	;if equal to \n jump to compare
		cmp al, '0'
		jl scanf				;if smallest than 0 is not a number, ignore (jump to read another input keyboard)
		cmp al, '9'
		jg scanf				;if bigger than 9 is not a number, ignore (jump to read another input keyboard)


	printKeyboard:

		mov ah, 0xe	; Screen show content of al
		int 10h		; Screen interrupt

		mov bl,al
		jmp scanf

	compare:

		mov al, 10
		int 10h
		mov al,13
		int 10h

		and bl, 1
		je even

		odd:
			mov si, str_impar
			jmp print

		even:
			mov si, str_par
			jmp print


print:
	lodsb		; load al, si index and si++
	cmp cl,al	; compare al with 0 (0, was set as end of string)
	je scanf

	mov ah,0xe	; instruction to show on screen
	mov bh, 13h
	int 10h		; call video interrupt

jmp print


end:
	jmp $
	times 510 - ($ - $$) db 0
	dw 0xaa55