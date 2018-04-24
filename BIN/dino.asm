IDEAL
MODEL small
STACK 200h
DATASEG
;data

player db '  * '
db ' ** '
db ' ** '
db ' ** '
db '****'
time_counter dw 0

player_location dw 0

obstacle_counter db 0
obstacle_length db 0
obstacle_lcations dw 0 
CODESEG
;code

update_timer:
    push bx

    mov bx, offset time_counter
    inc [word ptr bx]

    pop bx
    ret     

clear_screen:
    push di
    push cx

    mov di, 0
    mov cx, 160*25

    lp_cls:
    push di
    push 0000
    call draw_char
    add di, 2
    loop lp_cls

    pop cx
    pop di
    ret 

draw_char:

    push bp

    mov bp, sp

    push di
    push ax

    mov di, [bp + 6]; location
    mov ax, [bp + 4]; char and color

    mov [es : di], al ; draws character to screen
    inc di
    mov [es : di], ah ; draws color to screen

    pop ax
    pop di
    pop bp
    ret 4

draw_ascii_line:
    ; args:
    ; initial screen location
    ; initial memory address
    ; length
    push bp
    mov bp, sp
    push di
    push si
    push cx
    push ax

    mov di, [bp + 8]
    mov si, [bp + 6]
    mov cx, [bp + 4]

    mov ax, 0
    mov ah, 5

    lp_dl:
    mov al, [si]
    push di
    push ax
    call draw_char
    inc si
    add di, 2
    loop lp_dl

    pop ax
    pop cx
    pop si
    pop di
    pop bp
    ret 6

draw_ascii_sprite:
    ; args:
    ; initial location on screen
    ; initial memory address
    ; width - lb, height - hb
    push bp

    mov bp, sp

    push di
    push si
    push ax
    push cx
    push dx
    push bx

    mov di, [bp + 8] ; initial screen location
    mov si, [bp + 6] ; initial memory address
    mov ax, [bp + 4] ; width and height    

    ; extracts width and height
    mov cx, 0
    mov cl, ah
    mov dx, 0
    mov dl, al 

    ; defines char and color
    mov bx, 0
    mov bh, 5
    mov bl, 0
    height_loop_dsp:
    push di
    push si
    push dx
    call draw_ascii_line
    add si, dx
    add di, 160
    loop height_loop_dsp
    
    pop bx
    pop dx
    pop cx
    pop ax
    pop si
    pop di
    pop bp
    ret 6

start:
	mov ax, @data
	mov ds, ax
    mov ax, 0b800h
    mov es, ax

    call clear_screen

    mov bx, offset player
    mov di, 3200
    mov al, 4
    mov ah, 5
    push di
    push bx
    push ax
    call draw_ascii_sprite

;code here

exit:
	mov ax, 4c00h
	int 21h
END start
