.MODEL small
.STACK 100h
DATASEG
;data
db ?, ?, ?, ?, ?
CODESEG
;code
start:
	mov ax, @data
	mov ds, ax

	mov bx, 2

	mov [word ptr bx], FF
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
