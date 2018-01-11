; Author - Maryanovsky Alla

; This program is presentation of access to segment CODE.

IDEAL

MODEL small

STACK 100h

DATASEG

; --------------------------



CODESEG





	

start:

  	

	mov ax, 0b800h         ; start address of text video memory

	                       ; 80 columns * 25 rows * 2 bytes per character:

						   ; low byte = character code; high byte = attribute (background+color)

	mov es, ax

	mov bx,12h

	mov [byte ptr cs:bx], 2ah

	mov di,  (2*80+9)*2    ; address on third line

	mov ah, 100              ; red on orange         

	mov al, '$'            ; we'll put 10 "dollars" on the screen

	mov cx,10

	

od:

	mov [es:di], al        ; [es:di] - logical address; es*16 + di = 20 bit physical address

	inc di

	mov [es:di], ah

	inc di

	loop od



	

exit:

	mov ax, 4c00h

	int 21h

END start


