.MODEL small
.STACK 100h
DATASEG
;data

CODESEG
;code


sqrt8bitDec: 
	; arguments -> al - initial number
	; returns -> al - result number
	mov al, dl

	mov cx, 10

	lp:
		mov dh, al
		add al, dl
		mov ah, 0
		div dh
		mov dh, 2
		div dh
		loop lp
ret 


getStringFromInput:
	; arguments -> dx - initial pointer
	; returns -> memory, beginning with dx - string, si - pointer to end
	mov bx, dx
	mov ah, 01h

	cond:
		int 21h
		mov [byte ptr bx], al
		inc bx
		cmp al, 13
		jnz cond
	mov si, bx
ret

get8bitNumberFromMemory:
	; arguments -> dx - initial pointer, si - end pointer
	; returns -> dh - number
	mov al, 1
	mov ah, 0
	mov bx, dx
	dec bx
	cond2:
		mov dl, [bx]
		cmp dl, 30h
		jng next
		sub dl, 30h
	next:
		mul dl
		add dh, al
		div dl
		mov cl, 10
		mul cl
		dec bx
		cmp bx, si
		jge cond2
ret

displayNumberFormDH: ;dh - number
	mov bx, 5
	



start:
	mov ax, @data
	mov ds, ax
	mov dl, 4
	mov ax, 0
	call getStringFromInput
	call get8bitNumberFromMemory
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
