org 0x000007E00
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

hello_message: db 'Hello we are at kernel 1. ', 0

start:
		xor ax, ax
		mov ds, ax

		call clear_screen

		mov ah,0xe										; instruction to show on screen
		mov al,'h'										; compare al with 0 (0, was set as end of string)
		int 0x10											; call video interrupt
		mov al,'e'										; compare al with 0 (0, was set as end of string)
		int 0x10											; call video interrupt
		mov al,'r'										; compare al with 0 (0, was set as end of string)
		int 0x10											; call video interrupt
		mov al,'e'										; compare al with 0 (0, was set as end of string)
		int 0x10											; call video interrupt

		mov si, hello_message
		call print_string

;************************************************************
;	**************** PRINT A STRING
;************************************************************
		print_string:
			lodsb												; load al, si index and si++
			cmp al,0										; compare al with 0 (0, was set as end of string)
			je .endprintstring

			mov ah,0xe									; instruction to show on screen
			int 0x10										; call video interrupt

		jmp print_string
		.endprintstring: ret


;************************************************************
;	**************** CLEAR SCREEN
;************************************************************
		clear_screen:
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
