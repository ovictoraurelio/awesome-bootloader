org 0x00000500
; ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥
;						Assembly is love
;
;						bootStage2.asm by BootloaderBros
;						BootloaderBros:
;   										 	Gerson Fialho @jgfn
;    											Nathan Prestwood @nmf2
;    											Victor Aurélio @vags
;
; ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥

jmp start

topText: db '                   Welcome to Awesome-Bootloader ', 13, 10, 0
botText: db '                Awesome-Bootloader by BootloaderBros ', 13, 10, 0
option1: db ' > Lenux ', 13, 10, 0
option2: db '   Ruindous ', 13, 10, 0

;
;		On the map of memory, 0x00500 has 32kb
;			Our kernel, will be load on 0x00007E00 tha has 480.5kb
;

start:
		xor ax, ax
		mov ds, ax

		mov ah,0xe
		mov al, 'A'
		int 0x10
		mov ah,0xe
		mov al, 'B'
		int 0x10

		call clearScreen

		mov si, topText
		call print_string

		; AH=2h: Set cursor position
		mov dl, 0 ; Column
		mov dh, 23 ; Row
		mov ah, 2h
		int 0x10

		mov si, botText
		call print_string

		; AH=2h: Set cursor position
		mov dl, 0 ; Column
		mov dh, 08 ; Row
		mov ah, 2h
		int 0x10

		mov si, option1
		call print_string

		mov si, option2
		call print_string

		; AH=2h: Set cursor position
		mov dl, 01 ; Column
		mov dh, 08 ; Row
		mov ah, 2h
		int 0x10

		jmp $
		;***
		;	** Print a string
		;
		print_string:
			lodsb							; load al, si index and si++
			cmp al,0					; compare al with 0 (0, was set as end of string)
			je endprintstring

			mov ah,0xe				; instruction to show on screen

			int 0x10						; call video interrupt

		jmp print_string
		endprintstring: ret

		clearScreen:
	    pusha

			; AH=2h: Set cursor position
	    mov ax, 0x0700  ; function 07, AL=0 means scroll whole window
	    mov bh, 0x07    ; character attribute = white on black
	    mov cx, 0x0000  ; row = 0, col = 0
	    mov dx, 0x184f  ; row = 24 (0x18), col = 79 (0x4f)
	    int 0x10        ; call BIOS video interrupt

	    popa

			; AH=2h: Set cursor position
			mov dl, 0 ; Column
			mov dh, 0 ; Row
			mov ah, 2h
			int 0x10
    ret

		jmp $
; jmp 0x00007E00