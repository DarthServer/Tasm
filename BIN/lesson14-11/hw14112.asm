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
	jz mkb
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
	

tswu: ; arguments -> ax - the number, cx - base of the number, ch - ending index
	
	lp:
		div cx
		add dx, 30h
		mov [bx], dl
		mov dx, 0
	cond:	
		dec bx
		cmp bl, ch
		jnz lp
	ret


start:
	mov ax, @data
	mov ds, ax

	mov ax, 1234
	mov cx, 10
	mov dl, 0
	call stblWord
	call tswu
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
