.MODEL small
.STACK 100h
DATASEG
;data
;db 3 dup('b'), 'a'
;dw 4
db 1, 2, 3, 4, 5, 6, 7, 8, 9
CODESEG
;code
start:
	mov ax, @data
	mov ds, ax

	mov bx, 0
	xor ax, ax

	cond:
		mov al, [bx]
		mov cl, 2
		div cl
		cmp ah, 1
		jnz next
		inc [byte ptr bx]
		next:
		inc bx
		cmp bx, 10
		jnz cond
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
