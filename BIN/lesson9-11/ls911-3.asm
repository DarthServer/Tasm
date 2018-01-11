.MODEL small
.STACK 100h
DATASEG
;data

CODESEG
;code
start:
	mov ax, @data
	mov ds, ax
	mov bx, 0

	mov ah, 1
	int 21h
lp:
	mov [bx], al
	inc bx
cond:
	cmp bx, 19
	jnz lp
	inc bx
	mov [bx], '$'
pint:
	mov dx, 0
	mov ah, 9h
	int 21h
	mov ah, 2
	mov dl, 10
	int 21h
	mov dl, 13
	int 21h
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
