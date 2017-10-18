IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
count db 10
CODESEG
start:
	mov ax, @data
	mov ds, ax
	
	mov cl, offset count
	mov bx, 0
	jmp lp
	
lp:
    cmp cl, 0
    jnz do
    jz exit
do:
    mov [bx], bx
    inc bx
    dec cl
    jmp lp
; --------------------------
; Your code here
; --------------------------
	
exit:
	mov ax, 4c00h
	int 21h
END start


