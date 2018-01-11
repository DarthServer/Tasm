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

    mov ax, 100
    cmp ax, 101
    jg exit
    mov ax, 101

;code here

exit:
	mov ax, 4c00h
	int 21h
END start
