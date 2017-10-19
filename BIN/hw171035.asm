.MODEL small
.STACK 100h
DATASEG
;data

cmpnum dw 0ffh
CODESEG
;code
start:
	mov ax, @data
	mov ds, ax

	mov ax, 0ffh
	mov bx, 0
	mov cx, 0
	mov dx, 0
	
	add di, ax
	add di, bx
	add di, cx
	add di, dx

	cmp di, [cmpnum]
	jz mkpos
	jnz mkneg

mkneg:
	mov si, -100
	jmp exit
mkpos:
	mov si, 100
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
