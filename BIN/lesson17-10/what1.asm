; Autor - Maryanovsky Alla
; What performs this program?

IDEAL 
MODEL small
Stack 100h

DATASEG
; --------------------------
; Your variables here
; --------------------------
	num           db 20                                          ; array length
	arr           db 5,20,7,10,7,20,2,1,9,6,9,3,20,1,0,5,12,17,9,20 ; array
	
	
	
CODESEG
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Your code here
; --------------------------	
	;------------------- roles of variables: 
	; bx - 
	; di - 
	; si - 
	; ah - 
	; al - 

	mov bx, offset arr 
	mov si ,bx
        mov di ,bx  
        add bx, [num]                ; error because db of num
	
inloop:
	mov al ,[si] 
	cmp [bx-1], al                   ; ?
	jnz cont

	mov ah, [di] 
	mov [si], ah                   ; ?
cont:
	inc si
	cmp bx, si
	jnz inloop
	
	
exit:
	mov ax, 4C00h
	int 21h
END start
