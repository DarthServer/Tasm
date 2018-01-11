.MODEL small
.STACK 100h
DATASEG
;data
db 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
CODESEG
;code
start:
	mov ax, @data
	mov ds, ax
	mov si, 0 ;moved 0 to si
	jmp cond ; jumps to condition label
lp:
	mov ah, [si]; moves the value pointed by si to ah
	sal ah, 1 ;multiplies ah by 2
	mov [si], ah ;moves the value of ah to the mem addres pointed by si
	inc si ;increments si
cond:
	cmp si, 10 ; compares si to 10
	jnz lp ; if not equal continues
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
