; Autor - Maryanovsky Alla
; What performs this program?

IDEAL 
MODEL small
Stack 100h

DATASEG
; --------------------------
; Your variables here
; --------------------------
	num           dw 20                                          ; array length
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

	mov bx, offset arr ; moves 2 into bx
	mov si ,bx ;moves 2 to si
        mov di ,bx ;moves 2 to di
        add bx, [num] ; error because db of num is byte and not word
	
inloop:
	mov al ,[si] ; moves value of mem adress 2 into al 
	cmp [bx-1], al; compaers value of mem adress 1 and al
	jnz cont ; if not equals jumps to count

	mov ah, [di] ; if equels moves the of mem adress the value of di into ah
	mov [si], ah; moves the value of ah to mem adress by the value of si
cont:
	inc si ; increments si
	cmp bx, si ; compares bx and si  
	jnz inloop ; if they aren't equal jumps back to condition
	
	
exit:
	mov ax, 4C00h
	int 21h
END start
