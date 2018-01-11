.MODEL small
.STACK 100h
DATASEG
;data

CODESEG
;code


stblByte: ; arguments -> base of number - cl, is signed -> dl (need to be aither 0 or 1)
	
	mov bl, dl
	cmp cl, 2
	jz mkb
	cmp cl, 10
	jz mkd
	cmp cl, 16
	jz mkh

	mkb:
		add bl, 7
		
		ret
	mkd:
		add bl, 2
		ret
	mkh:
		add bl, 1
		ret
	ret

tsbu: ; arguments -> number - al, base of the number - cl, ending index - ch

	mov ah, 0
	lp:
		div cl
		add ah, 30h
		mov [bx], ah
		mov ah, 0
	cond:
		dec bx
		cmp bl, ch
		jnz lp

	ret
tsbs: ; arguments -> number - al, base of number - cl
	
start:
	mov ax, @data
	mov ds, ax

	mov al, 123
	mov cl, 10
	mov ch, -1
	call stblByte
	call tsbu

;code here

exit:
	mov ax, 4c00h
	int 21h
END start
