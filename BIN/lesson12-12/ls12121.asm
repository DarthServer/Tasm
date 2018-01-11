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

	mov di, 160 + 18
	mov cx, 0
	mov ah, 200
	
	lp:
	add cx, 30
	mov [es:di], cl
	inc di
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
