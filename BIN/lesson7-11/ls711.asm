.MODEL small
.STACK 100h
DATASEG
;data

CODESEG
;code
start:
	mov ax, @data
	mov ds, ax
	mov bl, 1
	mov cl, al

lp:
	shl bl, 1
	loop lp

;code here

exit:
	mov ax, 4c00h
	int 21h
END start
