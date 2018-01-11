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
	mov bh, 1
	mov si, 5h
	mov cl, al
lpl:
	shl bl, 1
	loop lpl
	mov cl, ah
lph:
	shl bh, 1
	loop lph


;code here

exit:
	mov ax, 4c00h
	int 21h
END start
