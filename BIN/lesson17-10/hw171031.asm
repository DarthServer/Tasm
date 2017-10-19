.MODEL small
.STACK 100h
DATASEG
;data
db 9, 17, 14
CODESEG
;code
start:
	mov ax, @data
	mov ds, ax

	mov si, 010h; moved 10h into si (starting memadress index)
	mov dx, 016h; moved 16h into dx (ending memadress index)
	mov di, 0 ;moved 0 into di (counter of the memadresses indexes)
cond:
	cmp si, dx ;compares si and dx(staticly 16) if true exits
	jz exit ; if zf == 1 exits
	jnz lp; if zf != 1 jmps to loop body

incdi:
	mov di, 0
lp:
	; comapers di and 3 (if equals, jumps tp incdi to nullify di)
	cmp di, 3
	jz incdi ; if zf == 0 jumps to incdi 
	mov al, [di] ; moves the value of memadress pointed by di to al
	mov [si], al ; moves the value of al to the memadress pointed by si
	inc si ;increments si
	inc di ;increments di
	jmp cond ; jumps to the loop condition	
	
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
