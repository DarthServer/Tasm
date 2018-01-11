IDEAL
MODEL small
STACK 100h
DATASEG
;data

CODESEG
;code
start:
	mov ax, @data
	mov ds, ax
	
	mov ax, 0b800h
	mov es, ax

	mov di, 100 + 160
	mov cl, 0
	mov ah, 100
	
	lp:
	add cl, 30h
	mov [es:di], cl
	inc di
	sub cl, 30h
	mov [es:di], ah
	inc di
	inc cx
	cmp cx, 10
	jnz lp


;code here

exit:
	mov ax, 4c00h
	int 21h
END start
