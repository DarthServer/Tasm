IDEAL
MODEL small
STACK 100h
DATASEG
;data

running_flag dw 0

update_player_timer dw 0
update_obstacles_timer dw 0
create_obstacles_timer dw 0
create_obstacles_timer_2 db 0
create_obstacles_timeout db 1

welcome_string_message db 'Welcome To Dino, Press Any Key To Start The Game'

score dw 0

player_x db 5
player_y db 20

player_velocity db 0

player_high_y db 8
player_low_y db 20 

player_up_tiemout db 3

player_target_y db 10

player_width db 3
player_height db 2
player_sprite db '****'
db '****'
db '****'
player_up_timer db 0 

empty_line db '                                                                 '
obstacle_sprite db '**'
db '**'
db '**'
db '**'
obstacle_width db 2
obstacle_height db 4
obstacle_x db 60
obstacle_y db 18
obstacle_locations dw 10 dup(0)

obstalce_spaw_time_counter db 0
obstacle_spawn_times db 5, 3, 9, 3, 6, 2, 6, 8, 3, 7, 5, 3

score_string db 10 dup(30h)

CODESEG
;code

draw_text_line:

    push bp

    mov bp, sp

    push ax
    push bx
    push cx
    push di

    mov di, [bp + 8] ; pointer to initial location in video memory
    mov bx, [bp + 6] ; offset of string in the memory
    mov ax, [bp + 4] ; lb - color of the text

    dtl_lp:
    mov cl, [bx]
    mov [di], cl
    inc di
    mov [di], al
    inc di
    inc bx
    cmp [byte ptr bx], '$'
    jnz dtl_lp


    pop di
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6


number_to_string:
    push bp

    mov bp, sp

    push ax
    push bx
    push cx
    push dx
    push di

    mov di, 10 ; devider 

    mov bx, [bp + 6] ; offset of last memory location of string
    mov ax, [bp + 4] ; the number that needs to be converted into string

    mov dx, 0

    strnum_lp:

    div di
    add dl, 30h
    mov [bx], dl
    mov dx, 0
    dec bx
    cmp ax, 0
    jnz strnum_lp

    mov bx, offset score_string
    add bx, 10
    inc bx
    mov [byte ptr bx], '$'

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4


update_score:
    push ax

    inc [word ptr score]

    mov ax, offset score

    push ax

    mov ax, [score]

    push ax

    call number_to_string

    mov ax, offset score_string

    push ax

    mov ax, 0

    push ax

    call draw_text_line

    pop ax
    ret

update_spawn_time:
    push ax
    push bx

    mov ax, 0
    inc [obstalce_spaw_time_counter]
    cmp [obstalce_spaw_time_counter], 12
    jl next_ust
    mov [obstalce_spaw_time_counter], 0
    next_ust:
    mov al, [obstalce_spaw_time_counter]
    mov bx, offset obstacle_spawn_times
    add bx, ax
    mov al, [bx]
    mov [create_obstacles_timeout], al
    end_ust:
    pop bx
    pop ax
    ret

clear_keyboard_buffer:
    push ax

    mov ah, 08h
    int 21h

    pop ax
    ret

update_io:

    push ax

    mov ax, 0
    mov ah, 01h

    int 16h
    jz exit_io

    mov ah, 00h
    int 16h

    cmp al, 119
    je move_up_io

    cmp al, 115
    je move_down_io

    jmp exit_io

    move_up_io:
    cmp [player_velocity], 1
    je exit_io
    cmp [player_velocity], 2
    je exit_io
    mov [player_velocity], 1
    jmp exit_io

    move_down_io:
    cmp [player_velocity], 0
    je exit_io
    mov [player_velocity], 2
    mov [player_up_timer], 0

    exit_io:
    pop ax
    ret

check_1d_collision:
    ; checks for 
    ; t == t'
    ; t' < t && t'+ b >= t
    ; t < t' && t + a >= t'
    push bp
    mov bp, sp

    push ax
    push bx

    mov ax, [bp + 6] ; lb - t , hb - a 
    mov bx, [bp + 4] ; lb - t', hb - b

    cmp al, bl
    jz positive_result
    jg checktt
    
    add al, ah
    cmp al, bl
    jl negative_result
    jmp positive_result

    checktt:
    add bl, bh
    cmp bl, al
    jl negative_result
    jmp positive_result


    positive_result:
    mov [bp + 6], 1
    jmp end_c1dc

    negative_result:
    mov [bp + 6], 0

    end_c1dc:
    pop bx
    pop ax
    pop bp
    ret 2

check_2d_collision:
    push bp
    mov bp, sp

    push ax
    push bx
    push cx
    push dx

    mov ax, [bp + 10]; lb - x, hb - w
    mov bx, [bp + 8]; lb - y, hb - h
    mov cx, [bp + 6]; lb -x', hb - w'
    mov dx, [bp + 4]; lb -y', hb - h'

    push ax
    push cx
    call check_1d_collision
    pop ax

    push bx
    push dx
    call check_1d_collision
    pop bx


    cmp ax, 1
    jnz zero
    cmp bx, 1
    jnz zero
    mov [word ptr bp + 10], 1
    jmp end_c2dc
    zero:
    mov [word ptr bp + 10], 0
    end_c2dc:
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6

check_obstacle_player_collision:
    push bp
    mov bp, sp

    push ax
    push bx
    push cx
    push di
    mov di, [bp + 4] ; pointer to obstacle location pointer

    mov cx, [di] ; pointer to obstacle in video memory

    mov al, [player_x]
    mov ah, [player_width]

    mov bl, [player_y]
    mov bh, [player_height]

    push ax
    push bx

    push cx
    call pointer_to_xy
    pop cx

    mov al, cl
    mov ah, [obstacle_width]

    mov bl, ch
    mov bh, [obstacle_height]

    push ax
    push bx

    call check_2d_collision
    pop ax

    cmp ax, 1
    jnz end_copdc
    call end_game
    end_copdc:
    pop di
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2

create_obstacle:
    push bx
    push cx
    push dx

    mov bx, offset obstacle_locations

    mov dl, [obstacle_x]
    mov dh, [obstacle_y]
    push dx
    call xy_to_pointer
    pop dx
    mov cx, 7
    lp_co:
    cmp [word ptr bx], 0
    jnz lp_co1
    mov [word ptr bx], dx
    jmp end_co
    lp_co1:
    add bx, 2
    loop lp_co

    end_co:
    pop dx
    pop cx
    pop bx
    ret 

clear_obstacle:
    push bp
    mov bp, sp

    push ax
    push bx
    push di

    mov di, [bp + 4]
    mov ax, [di]; pointer
    mov bl, [obstacle_width]
    mov bh, [obstacle_height]
    push ax
    push bx
    call clear_sprite

    pop di
    pop bx
    pop ax
    pop bp
    ret 2

move_obstacle:
    push bp
    mov bp, sp

    push ax
    push bx

    mov bx, [bp + 4]; pointer to location

    mov ax, [word ptr bx]
    push ax
    call pointer_to_xy
    pop ax

    dec al
    cmp al, 0
    jnge end_mo_zero
    push ax
    call xy_to_pointer
    pop ax
    mov [word ptr bx], ax 
    jmp end_mo
    end_mo_zero:
    mov [word ptr bx], 0h
    end_mo:
    pop bx
    pop ax
    pop bp
    ret 2

update_obstacles:
    push ax
    push bx
    push cx

    mov bx, offset obstacle_locations
    mov cx, 7

    lp_uo:
    cmp [word ptr bx], 0h
    jz cond_lpuo
    push bx
    call clear_obstacle
    push bx
    call move_obstacle
    push bx
    call draw_obstacle
    push bx
    call check_obstacle_player_collision
    cond_lpuo:
    add bx, 2
    loop lp_uo

    uo_end:
    pop cx
    pop bx
    pop ax
    ret

move_player_up:
    push ax

    mov al, [player_y] ; current y of the player
    mov ah, [player_high_y]; the y the player should be at

    cmp ah, al
    jne mp_change_y
    inc [player_up_timer]
    mov al, [player_up_timer]
    cmp al, [player_up_tiemout]
    jle end_mp_up
    mov [player_velocity], 2
    jmp end_mp_up
    mp_change_y:
    dec [player_y]
    end_mp_up:
    pop ax
    ret

move_player_down:
    push ax

    mov al, [player_y] ; current y of the player
    mov ah, [player_low_y]; the y the player should be at

    cmp ah, al
    jne mp_down
    mov [player_velocity], 0
    jmp end_mp_down
    mp_down:
    inc [player_y]
    end_mp_down:
    pop ax
    ret

update_player:
    push ax
    push cx
    push dx
    push di
    push si

    mov dl, [player_x]
    mov dh, [player_y]
    push dx
    call xy_to_pointer

    mov cl, [player_width]
    mov ch, [player_height]

    push cx
    call clear_sprite

    cmp [player_velocity], 0
    jz up_draw
    cmp [player_velocity], 1
    jnz up_next
    call move_player_up
    jmp up_draw
    up_next:
    cmp [player_velocity], 2
    jnz up_draw
    call move_player_down
    up_draw:
    call draw_player
    endpo:
    pop si
    pop di
    pop dx
    pop cx
    pop ax
    ret

update_timer:
    push bx
    push cx
    
    mov bx, offset update_player_timer
    inc [word ptr bx]
    cmp [word ptr bx], 0FFFh
    jne ut_cont1
    call update_player
    call update_io
    mov [word ptr bx], 0
    ut_cont1:
    mov bx, offset update_obstacles_timer
    inc [word ptr bx]
    cmp [word ptr bx], 0E00h
    jne ut_cont2
    call update_obstacles
    mov [word ptr bx], 0
    ut_cont2:
    mov bx, offset create_obstacles_timer
    inc [word ptr bx]
    cmp [word ptr bx], 00FFFh
    jne ut_cont3
    mov bx, offset create_obstacles_timer_2
    inc [byte ptr bx]
    mov cl, [create_obstacles_timeout]
    cmp [byte ptr bx], cl
    jne ut_cont3
    call create_obstacle
    mov [create_obstacles_timer], 0
    mov [create_obstacles_timer_2], 0
    call update_spawn_time
    ut_cont3:
    
    ut_end:
    pop bx
    pop cx
    ret

pointer_to_xy:
    push bp
    mov bp, sp

    push ax
    push bx
    push cx
    push dx

    mov ax, [bp + 4] ; pointer
    mov dx, 0
    mov cx, 160

    div cx

    mov bh, al

    mov cl, 2
    mov al, dl
    div cl
    mov bl, al

    ; result -> lb - x, hb - y

    mov [bp + 4], bx 

    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 

xy_to_pointer:
    push bp

    mov bp, sp

    push ax
    push bx
    push cx
    push dx

    mov bx, [bp + 4]; lb - x, hb - y
    mov ax, 0
    mov dx, 0

    mov al, bl ; x to multiply
    mov cx, 2

    mul cx

    mov [bp + 4], ax

    mov ax, 0
    mov dx, 0
    mov al, bh ; y to multiply
    mov cx, 160

    mul cx

    add [bp + 4], ax

    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret

clear_sprite:
    push bp
    mov bp, sp

    push ax
    push bx
    push cx

    mov ax, [bp + 6] ; screen location
    mov bx, offset empty_line
    mov cx, [bp + 4] ; width and height
    

    push ax
    push bx
    push cx
    call draw_ascii_sprite 

    pop cx
    pop bx
    pop ax
    pop bp
    ret 4

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

    mov di, [bp + 8] ; initial location
    mov si, [bp + 6] ; initial memory address
    mov cx, [bp + 4] ; length

    mov ax, 0
    mov ah, 5 ; color

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
    mov dx, 0
    mov dl, al ; width
    mov cx, 0
    mov cl, ah ; height

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

draw_obstacle:
    push bp
    mov bp, sp

    push ax
    push bx

    mov bx, [bp + 4]; pointer to obstacle location in video memory
    mov ax, [bx]

    cmp ax, 0h
    jz end_do

    push ax

    mov ax, offset obstacle_sprite
    push ax

    mov al, [obstacle_width]
    mov ah, [obstacle_height]
    push ax

    call draw_ascii_sprite

    end_do:
    pop bx
    pop ax
    pop bp
    ret 2

draw_player:
    push ax

    mov al, [player_x]
    mov ah, [player_y]

    push ax
    call xy_to_pointer

    mov ax, offset player_sprite
    push ax

    mov al, [player_width]
    mov ah, [player_height]
    push ax

    call draw_ascii_sprite

    pop ax
    ret

start:
	mov ax, @data
	mov ds, ax
    mov ax, 0b800h
    mov es, ax

    call clear_screen

    lp:
    call update_timer
    cmp [running_flag], 0
    jz lp
    jmp exit

end_game:
    call exitProgram
    ret

exitProgram:
    mov ax, 4c00h
    int 21h
    ret 
exit:
	mov ax, 4c00h
	int 21h
END start