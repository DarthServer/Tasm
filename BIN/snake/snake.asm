.MODEL small
.STACK 100h
DATASEG
;data

pointers_arr dw 8 dup(0)
food_ptr dw 0
character db '*'
color db 100

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

clearScreen:

  push di
  push si

  mov si, 160 * 24
  mov si, 0

  lp:
    mov [byte ptr es:di], 0
    inc di
    cmp di, si
    jnz lp
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

;code here

exit:
	mov ax, 4c00h
	int 21h
END start
