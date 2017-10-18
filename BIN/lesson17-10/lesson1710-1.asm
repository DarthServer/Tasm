.MODEL small
.STACK 100h
DATASEG
;data

CODESEG
;code
start:
	mov ax, @data
	mov ds, ax
	mov cl, 0
	jmp cond
cond:
	cmp cl, 5
	jz bod
	jnz exit
bod:
	mov bx, cl
	mov [bx], cl
	inc cl
	jmp cond
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
