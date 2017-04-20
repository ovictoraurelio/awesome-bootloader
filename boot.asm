; ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥
;						Assembly is love
;
;						boot.asm by BootloaderBros
;						BootloaderBros:
;   										 	Gerson Fialho @jgfn
;    											Nathan Prestwood @nmf2
;    											Victor Aurélio @vags
;
; ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥ ♥

org 0x00007C00
jmp 0x00000000:start

start:
    xor ax,ax
    mov ds,ax
    loaderBoot:

        ;****************************************
        ;	Reset disk
        ;****************************************
        .reset:
          	mov	ah, 0					  ;
          	int	0x13					  ; (13h) DISK interrupt (0h) (Reset)
                                ;   Resets the fixed disk or diskette controller and drive, forcing recalibration of the read/write head.
          	jc	.reset					;

        ;****************************************
        ;	Load second stage to memory
        ;****************************************
        .load_disk:

          	mov	ax, 0x0000050
          	mov	es, ax
          	xor	bx, bx          ;  set on BX the address of our code at PC Memory

          	mov	ah, 0x02				; Interrupt that read sectors into Memory
                                ; this interrupt use all of registers below
            mov	ch, 0x0				  ; Cylinder number
          	mov	al, 0x03				; Number of sectors to read
          	mov	cl, 0x02				; Sector to read.
          	mov	dh, 0x0				  ; Head number
          	mov dl, 0x0		      ; Drive number
          	int	0x13					  ; DISK interrupt

            jc .load_disk

        	  jmp	0x00000500			  ; jump to execute the Stage two!

end:
  	times 510 - ($ - $$) db 0
  	dw 0xAA55
