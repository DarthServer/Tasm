IDEAL
MODEL small
STACK 100h
DATASEG
;data

CODESEG
;code


toggleStar: ; ah - color, si - pointer to color
	
	push bp

	mov bp, sp

	push di
	push dx

	mov di, [bp + 6]
	mov dx, [bp + 4]

	mov [es : di], dl
	inc di
	mov [es : di], dh

	pop dx
	pop di
	pop bp
	ret

clearCurrentPos:
	push bp

	mov bp, sp

	push di

	mov di, [bp + 4]
	mov [es:di], 0
	inc di
	mov [es:di], 0
	pop di
	pop bp
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
	push bp

	mov bp, sp

	push di
	push ax
	push bx
	push dx

	mov di, [bp + 4]
	mov ax, di
	mov bx, 160
	div bx
	cmp dx, 0
		je endML
	sub di, 2
	mov [bp + 4], di

	endML:
	pop dx
	pop bx
	pop ax
	pop di
	pop bp
	ret

moveRight:
	push bp

	mov bp, sp

	push di
	push ax
	push bx
	push dx

	mov di, [bp + 4]
	mov ax, di
	mov bx, 160
	div bx
	cmp dx, 158
		je endMR
	add di, 2
	mov [bp + 4], di
	endMR:
	pop dx
	pop bx
	pop ax
	pop di
	pop bp
	ret



moveUp:
	push bp

	mov bp, sp
	
	push di

	mov di, [bp + 4]
	sub di, 160
	cmp di, 0
	jl endMU

	mov [bp + 4], di

	endMU:
	pop bx
	pop bp
	ret
moveDown:
	push bp

	mov bp, sp

	push di

	mov di, [bp + 4]
	add di, 160
	cmp di, 160 * 25
	jg endMD

	mov [bp + 4], di

	endMD:
	pop di
	pop bp
	ret

processKeypress:
	push bp

	mov bp, sp

	push di
	push cx

	mov cx, [bp + 6]
	mov di, [bp + 4]

	cmp cl, 99
	jne nKP
	call exitProgram

	nKP:
	push di
	cmp cl, 119
	je mvUKP
	cmp cl, 97
	je mvLKP
	cmp cl, 115
	je mvDKP
	cmp cl, 100
	je mvRKP
	jmp endPK

	mvUKP:
		call moveUp
		jmp endPK
	mvLKP:
		call moveLeft
		jmp endPK
	
	mvDKP:
		call moveDown
		jmp endPK
	mvRKP:
		call moveRight
		jmp endPK

	endPK:
		pop di
		mov [bp + 4], di
		pop cx
		pop di
		pop bp
	ret

start:
	;mov ax, @data
	;mov ds, ax
	mov ax, 0b800h
	mov es, ax

	mov di, (160) * 12 ; defines initial pointer to star location (center)
	mov dl, '*' ; character
	mov dh, 5; color of the char
;code here

lp:
	mov dh, 5
	push di
	push dx
	call toggleStar
	call delaySecond
	mov dh, 0
	push di
	push dx
	call toggleStar
	call delaySecond

	push di
	call clearCurrentPos

	mov ah, 1
	int 16h
	jz lp
	mov ah, 0
	int 16h
	push ax
	push di
	call processKeypress
	pop di
	pop ax
	jmp lp

exitProgram:
	mov ax, 4c00h
	int 21h
	ret
exit:
	mov ax, 4c00h
	int 21h
END start
