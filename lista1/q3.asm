org 0x7c00
jmp 0x0000:start

;   ♥ ♥ ♥ ♥ ♥
;   Assembly is love
;   @ovictoraurelio

stringH: times 64 db 0
stringL: times 64 db 0
stringMesmoTamanho: db 13, 10, 'As strings tem o mesmo tamanho' , 13, 10 , 0

start:
	; ax is a reg to geral use
	; ds
	mov ax,0 	;ax = 0
  mov ds, ax
	mov es, ax


  read1:
      mov di, stringH
      mov ch,0 ; clear counter thats have length of stringH
      call get_string

	call new_line

  read2:
      mov di, stringL
      mov cl,0 ; clear counter thats have length of stringL
      call get_string
			sub ch,cl ; removing the stringL.length of stringH.length because I have INCREMENT ch and cl always ..

	call new_line

  logical:
      cmp cl,ch
      je .mesmoTamanho

      cmp cl,ch
      jl .printH
          .printL:
            mov cl,0
            mov si, stringL
            call print_string
						call new_line
            jmp read1
          .printH:
            mov cl,0
            mov si, stringH
            call print_string
						call new_line
            jmp read1

      .mesmoTamanho:
          mov si, stringMesmoTamanho
          call print_string
					call new_line
          jmp read1









  get_string:
      .loop:

          mov ah, 0	    ;instruction to read of keyboard
      		int 16h		    ;interruption to read of keyboard

          cmp al, 0x1B
          je end			  ;if equal ESC jump to end
          cmp al, 0x0D
          je .done	    ;if equal ENTER done of string

          call print_char	    ;show char on screen
          stosb			          ;saves char on memory

					;;counters...
					inc ch ;; counter that contain length of stringH
					inc cl ;; counter that contain length of stringL

          jmp .loop 		      ;return to loop, read antoher char
    .done:
          mov al, 0       ;adding 0 to knows end of string
          stosb
    ret




















;***
;	** Print a string
;
print_string:
	lodsb		; load al, si index and si++
	cmp al,0	; compare al with 0 (0, was set as end of string)
	je endprintstring

	mov ah,0xe	; instruction to show on screen
	mov bh,13h
	int 10h		; call video interrupt

jmp print_string
endprintstring: ret
;***
;	** Print new line
;***
new_line:
    mov al, 10
    call print_char
    mov al, 13
    call print_char
ret
;***
;	** Print a char
;***/
print_char:		;imprime o caracter em al
    mov ah, 0x0e	;instrução para imprimir na tela
    int 10h		;interrup de tela
ret


end:
	jmp $
	times 510 - ($ - $$) db 0
	dw 0xaa55