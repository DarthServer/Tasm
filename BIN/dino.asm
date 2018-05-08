IDEAL
MODEL large
STACK 200h
DATASEG
;data

time_counter1 dw 0
time_counter2 dw 0

player_sprite db '******'
db '*    *'
db '*    *'
db '******'
player_action db 0
player_location dw 0

player_target_location dw 0
player_velocity db 0

obstacle_sprite db '   *'
db '* **'
db '* * '
db '*** '
db ' ** '
db ' ** '
db ' ** '

obstacle_counter db 0
obstacle_length db 0
obstacle_lcations dw 0 
CODESEG
;code



update_timer:
    push bx
    push dx
    push di
    push si

    mov si, [player_location]
    mov di, offset player_sprite
    mov al, 6
    mov ah, 4

    mov bx, offset time_counter1
    
    inc [word ptr bx]
    next1up:
    cmp [word ptr bx], 0FFFFh
    jne contup
    jne next1up
    push si
    push di
    push ax
    call draw_ascii_sprite
    add bx, 2
    inc [word ptr bx]
    cmp [word ptr bx], 01Fh
    jne contup
    call clear_screen

    contup:
    pop si
    pop di
    pop dx
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
    mov cl, ah ; height
    mov dx, 0
    mov dl, al ; width

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

move_sprite_up:
    push bp
    mov bp, sp
    push di
    mov di, [bp + 4]
    sub di, 160
    cmp di, 0
    jge endmu
    mov di, 0
    endmu:
    mov [bp + 4], di
    pop di
    pop bp
    ret 

start:
	mov ax, @data
	mov ds, ax
    mov ax, 0b800h
    mov es, ax

    ; call clear_screen

    ; mov bx, offset player_sprite
    ; mov di, 2500
    ; mov al, 6
    ; mov ah, 4
    ; push di
    ; push bx
    ; push ax
    ; call draw_ascii_sprite


    ; call clear_screen
    lp:
    call update_timer
    jmp lp

;code here

exitProgram:
    mov ax, 4c00h
    int 21h
    ret 
exit:
	mov ax, 4c00h
	int 21h
END start
