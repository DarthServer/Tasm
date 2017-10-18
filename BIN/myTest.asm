IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
db 1, 2, 3, 4
CODESEG
start:
	mov ax, @data
	mov ds, ax
	
	mov bx, 0
	mov ax, [bx]
	inc bx
	mov ah, [bx]
; --------------------------
; Your code here
; --------------------------
	
exit:
	mov ax, 4c00h
	int 21h
END start


