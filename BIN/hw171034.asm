.MODEL small
.STACK 100h
DATASEG
;data
db 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
CODESEG
;code
start:
	mov ax, @data
	mov ds, ax
	mov si, 0
	jmp cond
lp:
	mov ah, [si]
	sal ah, 1
	mov [si], ah
	inc si
cond:
	cmp si, 10
	jnz lp
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
