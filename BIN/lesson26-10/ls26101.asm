d
.MODEL small
.STACK 100h
DATASEG
;data
;db 1, 2, 2, 1, 2, 2, 1, 2
CODESEG
;code
start:
	mov ax, @data
	mov ds, ax
	mov si, 0
	jmp cond

body:
	and [byte ptr si], 00000001b
	cmp [byte ptr si], 0
	jz inc
	jnz noteven
inc :
	inc si
cond:
	cmp si, 10
	jnz body
	mov bx, 20
	jmp exit

noteven:
	mov bx, 27
	
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
