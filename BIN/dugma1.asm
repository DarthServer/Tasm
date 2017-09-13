IDEAL
MODEL small
STACK 100h
DATASEG
	db 1,2,3
CODESEG
start:
	mov ax, @data
	mov ds, ax
	
	mov bx, 0     ; bx <-- address 0
	mov al, [bx]  ; al <-- value in address 0
	inc bx        ; bx <-- bx + 1;   bx = 1
	mov ah, [bx]  ; ah <-- value in address 1
	inc bx        ; bx <-- bx + 1;   bx = 2
	mov cx, bx    ; cx <-- bx  ; cx = 2 
	
exit:
	mov ax, 4c00h
	int 21h
END start


