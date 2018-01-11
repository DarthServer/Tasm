IDEAL
MODEL small
STACK 100h
DATASEG
;data

food_ptr dw 0
character db '*'
color db 10
star_count db 1
pointers_arr (160*10 + 2), (160*10 + 4), (160*10 + 6) dw  dup(-1)

CODESEG
;code

delay: ; function that waits a sertain time
	push cx
	push ax
	push dx
	mov cx, 0Fh

	mov dx, 0F90h
	mov ah, 86h
	int 15h

	pop dx
	pop ax
	pop cx
	ret

updatePointers:
  mov di, bx
  mov si, di
  inc si
  ret
processKeypress:
	add di, 2
	add si, 2
	ret

displayStar:
	push cx
	mov ch, character
	mov [es:di], ch
	mov ch, color
	mov [es:si], ch
	pop cx
	ret

clearScreen:

  push di
  push si
	push ax

  mov si, 160 * 24
  mov di, 0

	mov al, 0

  lpCS:
    mov [es:di], al
    inc di
    cmp di, si
    jnz lpCS
	pop ax
  pop si
  pop di
  ret

start:
	mov ax, @data
	mov ds, ax

	mov ax, 0b800h
	mov es, ax

  mov bx, 0 ; pointer on pointers_arr
  mov si, 0 ; pointer on color
  mov di, 0 ; pointer on character

  mov bx, 10h



  call clearScreen

	mov di, (160*10 + 20)
	mov si, di
	inc si

	call displayStar

mainLP:
	;call clearScreen
	call displayStar
	mov ah, 0
	int 16h
	jz mainLP
	mov ah, 1
	int 16h
	call processKeypress
	jmp mainLP


;code here

exit:
	mov ax, 4c00h
	int 21h
END start
