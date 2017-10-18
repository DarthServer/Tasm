.MODEL small
.STACK 100h
DATASEG
;data
db 1, 2, 3, 4, 5

sum db 0
CODESEG
;code
start:
	mov ax, @data
	mov ds, ax
	mov bx, 0
	jmp lp
lp:
	cmp bx, 5
	jz exit
	jnz do
do:
	mov cl, [bx]
	add ch, cl
	inc bx
	jmp lp

;code here

exit:
	mov ax, 4c00h
	int 21h
END start
