.MODEL small
.STACK 100h
DATASEG
;data

CODESEG
;code
start:
	mov ax, @data
	mov ds, ax

	mov al, 2
	mov ah, 3
	mov bl, al

	xor al, ah
	xor al, bl

	xor ah, bl
	xor ah, al

;code here

exit:
	mov ax, 4c00h
	int 21h
END start
