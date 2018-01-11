.MODEL small
.STACK 100h
DATASEG
;data

CODESEG
;code

stblWord: ; arguments -> cx - base of the number, dl -> is signed

	mov bl, dl

	cmp cl, 2
	jz mkb
	cmp cl, 10
	jz mkd
	cmp cl, 16
	jz mkh

	mkb:
		add bl, 15
		ret
	mkd:
		add bl, 4
		ret
	mkh:
		add bl, 3
		ret
	ret
	

tsws: ; arguments -> ax - the number, cx - base of the number
	
	mov si, ax
	shl si, 1
	jc mkneg
	mov dl, '+'
	jmp cont
	mkneg:
	mov dl, '-'
	neg ax
	cont:
	mov bx, 0
	mov [bx], dl
	mov dx, 0
	mov si, 0
	call stblWord
	lp:
		div cx	
		add dx, 30h
		mov [bx], dl
		mov dx, 0
	cond:	
		dec bx
		cmp bx, 0
		jg lp
	ret

start:
	mov ax, @data
	mov ds, ax

	mov ax, -1234
	mov cx, 10
	call tsws
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
