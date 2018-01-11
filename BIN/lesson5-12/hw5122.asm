.MODEL small
.STACK 100h
DATASEG
;data

CODESEG
;code
start:
	mov ax, @data
	mov ds, ax

;code here

exit:
	mov ax, 4c00h
	int 21h
END start
