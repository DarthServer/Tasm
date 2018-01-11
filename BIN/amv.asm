IDEAL
MODEL small
STACK 100h
DATASEG
;data

CODESEG
;code


toggleStar: ; ah - color, si - pointer to color
	mov [es : si], dh
	mov [es : di], dl
	ret

delaySecond:
	push cx
	push ax
	push dx

	mov cx, 0Fh
	mov dx, 0F90h
	mov ah, 86h
	int 15h

	pop dx
	pop ax
	pop cx
	ret


getChar:

	push ax
	mov ah, 0h
	int 21h
	pop ax
	ret
isCharAvaliable:
	push ax
	mov ah, 1h
	int 21h
	pop ax
	ret

moveLeft:
	mov ax, di
	div bx
	cmp dx, 0
		jne nxtL
		ret
	nxtL:
	sub di, 2
	sub si, 2
	ret
moveRight:
	mov ax, di
	div bx
	cmp dx, 158
		jne nxtR
		ret
	nxtR:
	add di, 2
	add si, 2
	ret
moveUp:
	push bx
	mov bx, di
	sub bx, 160
	cmp bx, 0
	jl endMU
	sub di, 160
	sub si, 160

	endMU:
	pop bx
	ret
moveDown:
	push bx
	mov bx, di
	add bx, 160
	cmp bx, 160 * 25
	jg endMD
	add di, 160
	add si, 160

	endMD:
	pop bx
	ret

processKeypress:
	push ax
	push dx
	mov cl, al
	mov bx, 160
	mov ax, 0
	mov dx, 0
	cmp cl, 99
		jnz next
		call exitProgram
	next:
	cmp cl, 97
		je mvl
	cmp cl, 100
		je mvr
	cmp cl, 119
		je mvu
	cmp cl, 115
		je mvd
	jmp endMvStr

	mvl:
		call moveLeft
		jmp endMvStr
	mvr:
		call moveRight
		jmp endMvStr
	mvu:
		call moveUp
		jmp endMvStr
	mvd:
		call moveDown
		jmp endMvStr
	endMvStr:
		pop dx
		pop ax
	ret

start:
	;mov ax, @data
	;mov ds, ax
	mov ax, 0b800h
	mov es, ax

	mov di, (160) * 12 ; defines initial pointer to star location (center)
	mov si, di ; defines initial pointer to star color
	inc si
	mov dl, '*' ; character
	mov dh, 100 ; color

	mov [es:di], dl
	mov [es:si], dh
;code here

lp:
	mov dh, 0
	call toggleStar
	call delaySecond
	mov dh, 5
	call toggleStar
	call delaySecond

	mov [byte ptr es:di], 0
	mov [byte ptr es:si], 0

	mov ah, 1
	int 16h
	jz lp
	mov ah, 0
	int 16h
	call processKeypress
	jmp lp

exitProgram:
	mov ax, 4c00h
	int 21h
	ret
exit:
	mov ax, 4c00h
	int 21h
END start
