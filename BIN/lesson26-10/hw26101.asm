.MODEL small
.STACK 100h
DATASEG
;data
strg db 'a', 'b', 'c', '$'
CODESEG
;code
start:
	mov ax, @data
	mov ds, ax
	mov al, 11010111b
	mov si, offset strg
	jmp cnd
lp:
	xor [si], al
	inc si

cnd:
	cmp si, 3
	jnz lp
;code here
print:
	mov dx, offset strg
	mov ah, 9h
	int 21h
	mov ah, 2
	mov dl, 10
	int 21h
	mov dl, 13
	int 21h


exit:
	mov ax, 4c00h
	int 21h
END start
