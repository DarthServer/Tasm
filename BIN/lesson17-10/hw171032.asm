.MODEL small
.STACK 100h
DATASEG
;data

CODESEG
;code
start:
	mov ax, @data
	mov ds, ax

	mov ch, 0
	mov cl, 0
	mov dh, 0
	mov dl, 0
	mov si, 0AAh
	mov di, 0F9h
	jmp condsi
incsi:
	inc ch
	jmp condsi
lpsi :
	inc dh
	rol si, 1
	jnc incsi
	
condsi :
	cmp dh, 16
	jnz lpsi
conddi:
	cmp dl, 16
	jnz lpdi
	jmp endlab
lpdi :
	inc dl
	rol di, 1
	jnc incdi
	jmp conddi
incdi:
	inc cl
	jmp conddi

nullify:
	mov si, 0
	mov di, 0
	jmp exit
endlab:
	cmp ch, cl
	jz nullify
	jmp exit

;code here


exit:
	mov ax, 4c00h
	int 21h
END start
