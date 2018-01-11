.MODEL small
.STACK 100h
DATASEG
;data

CODESEG
;code


delaySecond:
	push cx
	push dx
	push ax
	mov cx, 0FH
	mov dx, 4240h
	mov ah, 86h
	int 15h
	pop ax
	pop dx
	pop cx
	ret
start:
	mov ax, @data
	mov ds, ax
	mov ax, 0b800h
	mov es, ax

	mov di, (2*80+9)*2
	mov al, '*'
	mov ah, 300
	

lp:
	
	mov bl, [es:di]
	cmp bl, al
	jnz nt
	mov [byte ptr es:di], 0 
	nt:
	mov [byte ptr es:di], '*'
	cont:
	call delaySecond
	jmp lp

;code here

exit:
	mov ax, 4c00h
	int 21h
END start
