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

hello: db "Hello we are at kernel 2. "

start:
		mov al,'B'										; compare al with 0 (0, was set as end of string)
		mov ah,0xe										; instruction to show on screen
		int 0x10											; call video interrupt
		mov al,'Q'										; compare al with 0 (0, was set as end of string)
		mov ah,0xe										; instruction to show on screen
		int 0x10											; call video interrupt
		mov al,'I'										; compare al with 0 (0, was set as end of string)
		mov ah,0xe										; instruction to show on screen
		int 0x10											; call video interrupt

		xor ax, ax
		mov ds, ax

		mov si, hello
		call print_string

		jmp $

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