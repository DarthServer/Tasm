IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
db 0, 1, 2, 3 , 4, 5, 6, 7
CODESEG
start:
	mov ax, @data
	mov ds, ax
	mov bx, 5
	mov ah, [bx]
	mov bx, 7
	mov al, [bx]
	mov [bx], ah
	mov bx, 5
	mov [bx], al
; --------------------------
; Your code here
; --------------------------
	
exit:
	mov ax, 4c00h
	int 21h
END start


