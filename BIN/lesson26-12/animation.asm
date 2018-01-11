IDEAL
MODEL small
STACK 100h
DATASEG
;data

CODESEG
;code


delaySecond: ; waits one second
	push cx
	push ax
	push dx
	; backed up all the used cpu registers
	mov cx, 0Fh
	mov dx, 4240H
	mov AH, 86h

	int 15h
	; called the int 15h with parameters that make it wait 1 second
	pop dx
	pop ax
	pop cx
	; restored register data
	ret

setStarColor: ; ah - color
	inc di
	mov [es:di], ah
	dec di
	ret
start:
	mov ax, 0b800h
	mov es, ax
	;defines extra segment
	mov di, (80*2 + 7)*12 ;defines pointer to location on screen (video memory)
	mov al, '*' ; defines the character that has to be displayed
	mov ah, 100 ; defines color
	
	mov [es:di], al ; moves the initial character to place
	inc di 
	mov [es:di], ah ; moves the initial
	mov cx, 10
lp:
		
	mov ah, 0
	call setStarColor
	call delaySecond
	mov ah, 100
	call setStarColor
	call delaySecond
	loop lp

;code here

exit:
	mov ax, 4c00h
	int 21h
END start
