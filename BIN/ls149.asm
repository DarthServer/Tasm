IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
db 1, 2, 1, 4, 5
CODESEG
start:
	mov ax, @data
	mov ds, ax
	
	mov bx, 0
	mov al, [0]
	mov ah, [bx+2]
	cmp al, ah
	je equals
	inc ah
	
equals:
    inc al
    jmp exit
	
exit:
	mov ax, 4c00h
	int 21h
END start


