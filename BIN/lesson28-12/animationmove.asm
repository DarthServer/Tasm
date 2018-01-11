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
	mov dx, 4000h
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

moveChar:
	push ax
	push dx
	cmp al, 99
		jz exit

	cmp al, 97
		je mvl
	cmp al, 100
		je mvr
	cmp al, 119
		je mvu
	cmp al, 115
		je mvd
	jmp endMvStr

	mvl:
		mov ax, di
		div 160
		cmp dx, 0
		je mvu
		sub di, 2
		sub si, 2
		jmp endMvStr
	mvr:
		mov ax, di
		div 160
		cmp dx, 0
		je mvu
		add di, 2
		add si, 2
		jmp endMvStr
	mvu:
		sub di, 160
		sub si, 160
		jmp endMvStr
	mvd:
		add di, 160
		add si, 160
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
	jmp lp
exit:
	mov ax, 4c00h
	int 21h
END start
