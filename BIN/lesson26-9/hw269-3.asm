.MODEL small
.STACK 100h
DATASEG
;data
db 1, 2, 3
CODESEG
;code
start:
	mov ax, @data
	mov ds, ax
	
	mov bx, 0
	cmp [bx], al
	jz exit
	jnz lpbegin
lpbegin:
	mov al, 100d
	jmp lp
lp:
	cmp bx, 3
	jz exit
	jnz do
do:
	mov [bx], 100d
	inc bx
	jmp lp

;code here

exit:
	mov ax, 4c00h
	int 21h
END start
