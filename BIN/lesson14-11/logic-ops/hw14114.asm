.MODEL small
.STACK 100h
DATASEG
;data

CODESEG
;code
start:
	mov ax, @data
	mov ds, ax
	
	mov dx, 0FFFFh

	mov cx, dx

	mov ax, 000Fh

	mov bx, 4

	lp:
		and 	

;code here

exit:
	mov ax, 4c00h
	int 21h
END start
