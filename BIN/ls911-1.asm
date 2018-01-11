.MODEL small
.STACK 100h
DATASEG
;data
msg db 'i love assembly$'
CODESEG
;code
; bx - pointer to new message
; si - pointer to original message
; al - a place to save the starting point of the new message
start:
	mov ax, @data
	mov ds, ax
	mov cl, 0
	mov si, 0
	mov bx, offset msg
lp1:
	inc cl
	inc bx
cond1:
	mov ah, [bx]
	cmp ah, '$'
	jnz lp1
	inc bx
	inc cl
lp2:
	mov ah, [si]
	cmp ah, 'l'
	jz makecapital
	mov [bx], ah
	jmp incstuff

makecapital:
	mov [bx], 'L'
incstuff:
	inc si
	inc bx
cond2:
	mov ah, [si]
	cmp ah, '$'
	jnz lp2
	mov [byte ptr bx], '$'
print1:
	mov dx, offset msg
	mov ah, 9h
	int 21h
	mov ah, 2
	mov dl, 10
	int 21h
	mov dl, 13
	int 21h
	mov dl, cl
	mov ah, 9h
	int 21h
	mov ah, 2
	mov dl, 10
	int 21h
	mov dl, 13
	int 21h
	
	
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
