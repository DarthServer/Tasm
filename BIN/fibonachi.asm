.MODEL small
.STACK 100h
DATASEG
;data

CODESEG
;code
start:
	mov ax, @data
	mov ds, ax
	mov si, 17h
	mov [byte ptr bx], 1
	mov [byte ptr bx], 1
	mov cx, 8
	
lp:
	mov al, [bx-1]
	add al, [byte ptr bx-2]
	inc bx
	mov [bx], al
	loop lp
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
