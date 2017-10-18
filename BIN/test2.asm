.MODEL small
.STACK 100h
DATASEG
;data
db 0, 0, 0, 0, 0, 0, 0, 0, 0
CODESEG
;code
start:
	mov ax, @data
	mov ds, ax

	mov bx, 2

	mov [word ptr bx], 0ff01h

;code here

exit:
	mov ax, 4c00h
	int 21h
END start
