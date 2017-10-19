.MODEL small
.STACK 100h
DATASEG
;data
db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
CODESEG
;code
start:
	mov ax, @data
	mov ds, ax
	mov cl, 1 ;set cl to 1 - stores the current number to be saved
	mov ch, 0 ;set ch to 0 - stores how much numbers were writen
	mov si, 0 ;set si to 0 - stores the pointer to the current memadress
	jmp cond1 ;jumps to the main condition of the loop

lpb:	
	mov [si], cl
	inc ch
	inc si
	jmp cond1
cond2:
	cmp ch, cl
	jnz lpb
	mov ch, 0
	inc cl

cond1:
	cmp cl, 11 ; compares the number to be writen to 11, if lower jumps tp cond2
	jnz cond2 ; jumps to cond2 if zf != 1
	jz exit ; jumps to exit if zf == 1
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
