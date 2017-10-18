IDEAL
.MEDEL small
.STACK 100h
DATASEG
;data
	db 1, 2, 3
CODESEG
;code
start:
	mov ax, @data
	mov ds, ax
	mov bx, 0 ;moved address 0 to register bx
	mov al, [bx] ;al gets the value of mem address 0
	inc bx ;bx recieves bx + 1. bx = 1
	mov ah, [bx];ah gets the value of mem address 1
	inc bx ; bx recieves bx + 1. bx = 2
	mov cx, bx;cx gets the value of bx (1)
	; cx = 2
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
