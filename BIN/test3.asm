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
	
	mov di, (2*80+9)*2
	mov ah, 100
	mov al, 0

	mov [es:di], al
	inc di
	mov [es:di], ah

;code here

exit:
	mov ax, 4c00h
	int 21h
END start
