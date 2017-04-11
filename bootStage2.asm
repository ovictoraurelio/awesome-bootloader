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
option1: db ' > Lenux ', 13, 10, '   Ruindous ', 13, 10, 0
option2: db '   Lenux ', 13, 10, ' > Ruindous ', 13, 10, 0
loading_messages: db ' Veryfing disks. ', 13, 10, ' Searching for i/o devices. ', 13, 10, ' Loading settings of lan. ', 13, 10, ' Loading settings of something. ', 13, 10,' Loading another thing. ', 13, 10, ' Loading stranger things. ', 13, 10, ' Are you reading about things that we loading? ', 13, 10, ' Loading another a lot of things. ', 13, 10, ' Loading something dark. HaHaHa ', 13, 10, ' Status of your screen: OK! ', 13, 10, ' Scanning your heart rate. ', 13, 10, ' Your health is OK! ', 13, 13, 10, ' Starting the boot manager.',  0

;
;		On the map of memory, 0x00500 has 32kb
;			Our kernel, will be load on 0x00007E00 tha has 480.5kb
;

start:
		xor ax, ax
		mov ds, ax
		int 13h

		;******************************
		;	** Loading Screen
		;******************************

		call initalize_messages

		;******************************
		;	** Menu OS Select
		;******************************

		call show_menu_template
		call show_boot_menu1

		;******************************
		;	** Loop OS Select
		;******************************
		loop:
				mov ah, 0x0											;instruction to read from keyboard
				int 0x16												;interrupt de teclado

				enter_cmp:
					cmp al, 0xd										;CMP with ENTER
					je boot_selected									;start boot
				esc_cmp:
					cmp al, 0x1b									;CMP with ESC
					je shutdown										;shutdown computer
				up_cmp:
					;; reading for AX, because this tutorial teach me - http://stackoverflow.com/questions/29527059/scan-codes-for-arrow-keys
					cmp ax, 0x4800   							;CMP with UP
					jne down_cmp									;if not equal to UP, go to down_cmp
					call show_menu_template
					call show_boot_menu1
					jmp loop

				down_cmp:
					cmp ax, 0x05000   						;CMP with DOWN
					jne loop											;if not equal to DOWN, go to loop (wait another key)
					call show_menu_template
					call show_boot_menu2
					jmp loop											;se for menor que '0' não é um número, ignore


		;******************************
		;	** A Boot option selected
		;******************************
		boot_selected:

				mov ah,0x3 											; to read load_option_twocurrent cursor position
				mov bh, 0
				int 0x10

				cmp dh, 09											; if line of cursor is 9, this boot selection is the first
				je load_option_one
				jmp load_option_two





;************************************************************
;	**************** INITIALIZE MESSAGES
;************************************************************
		initalize_messages:
				call show_menu_template
				mov si, loading_messages
				call print_string_with_delay_on_breakline
				times 4 call delay
		ret

;************************************************************
;	**************** BOOT MENU TEMPLATE
;************************************************************
		show_menu_template:
				call clear_screen

				mov si, topText
				call print_string

				; Set cursor position
				mov dl, 0 ; Column
				mov dh, 23 ; Row
				mov ah, 2h
				int 0x10

				mov si, botText
				call print_string

				; Set cursor position
				mov dl, 0 ; Column
				mov dh, 2 ; Row
				mov ah, 2h
				int 0x10
		ret


;************************************************************
;	**************** SELECT 1 ON BOOT MENU
;************************************************************
		show_boot_menu1:
				; AH=2h: Set cursor position
				mov dl, 0 ; Column
				mov dh, 09 ; Row
				mov ah, 2h
				int 0x10
				mov si, option1
				call print_string
				; AH=2h: Set cursor position
				mov dl, 01 ; Column
				mov dh, 09 ; Row
				mov ah, 2h
				int 0x10
		ret

;************************************************************
;	**************** SELECT 2 ON BOOT MENU
;************************************************************
		show_boot_menu2:
				; AH=2h: Set cursor position
				mov dl, 0 ; Column
				mov dh, 09 ; Row
				mov ah, 2h
				int 0x10

				mov si, option2
				call print_string

				; AH=2h: Set cursor position
				mov dl, 01 ; Column
				mov dh, 10 ; Row
				mov ah, 2h
				int 0x10
		ret


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
;	**************** PRINT A STRING (with delay when 13, (breakline) was detected)
;************************************************************
		print_string_with_delay_on_breakline:
			lodsb												; load al, si index and si++

			cmp al, 13									; compare al with 13 (to call delay)
			jne .no_delay
					call delay

			.no_delay:
					cmp al, 0										; compare al with 0 (0, was set as end of string)
					je .endprintstring
					mov ah,0xe									; instruction to show on screen
					int 0x10										; call video interrupt

				jmp print_string_with_delay_on_breakline
				.endprintstring:
						call delay
		ret

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

;************************************************************
;	**************** DELAY
;************************************************************
		delay:
				pusha												; saving on stack my registers
				mov bp, 2000								; set this register with 3000
				mov si, 2000
				.delay2:
						dec bp
						nop
						jnz .delay2
						dec si
						cmp si,0
						jnz .delay2
				popa
		ret

;************************************************************
;	**************** LOAD OPTION ONE
;************************************************************
		load_option_one:

				xor ax,ax
				mov ds,ax
				int 13h

				mov ax, 0x07E0
				mov es, ax
				xor bx, bx					;  set on ES:BX the address of our code at PC Memory

				mov	ah, 0x02				; Interrupt that read sectors into Memory
														; this interrupt use all of registers below
				mov	al, 0x3				; Number of sectors to read
				mov	ch, 0x00			  ; Cylinder number
				mov	cl, 0x5				; Sector to read.
				mov	dh, 0x0				  ; Head number
				mov dl, 0x0		      ; Drive number
				int	0x13					  ; DISK interrupt

		jc load_option_one		; se leu com sucesso, pula para o endereço do kernel (ES:00)

	jmp 0x7E00  ; jump to execute the kernel 1

;************************************************************
;	**************** LOAD OPTION TWO
;************************************************************
		load_option_two:
				xor ax,ax
				mov ds,ax
				int 13h

				mov	ax, 0x07E0  ;0x00007E00
				mov	es, ax
				xor	bx, bx          ;  set on BX the address of our code at PC Memory

				mov	ah, 0x02					; Interrupt that read sectors into Memory
														; this interrupt use all of registers below
				mov	al, 0x3					; Number of sectors to read
				mov	ch, 0x0				  ; Cylinder number
				mov	cl, 0x8				; Sector to read.
				mov	dh, 0x0				  ; Head number
				mov dl, 0x0		      ; Drive number
				int	0x13					  ; DISK interrupt

				jc load_option_two

				jmp	0x7E00			  ; jump to execute the kernel 2

;************************************************************
;	**************** SHUTDOWN COMPUTER
;************************************************************
shutdown:
		;Try to set APM version (to 1.2)
		;mov ax, 0x530E
		;xor bx, bx
		;mov cx, 0x0102
		;int 0x15

		;Turn off the system
		mov ax,0x5307
		mov bx,0x0001
		mov cx,0x0003
		int 0x15
