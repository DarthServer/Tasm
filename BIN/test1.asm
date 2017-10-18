.MODEL small
.STACK 100h
DATASEG
;data

CODESEG
;code
start:
	mov ax, @data
	mov ds, ax
	mov cx, 0
	mov bx, 0
	jmp cond
cond:
	cmp cl, 5
	jnz bod
	jz exit
bod:
	mov bx, cx
	mov [bx], cx
	inc cx
	jmp cond
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
