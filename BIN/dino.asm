IDEAL
MODEL small
STACK 100h
DATASEG
;data

running_flag dw 0
sound_flag dw 0
win_flag db 0

score_screen_location dw 0h

update_player_timer dw 0
update_obstacles_timer dw 0 
update_score_timer dw 0
create_obstacles_timer dw 0
create_obstacles_timer_2 db 0
create_obstacles_timeout db 1
create_obstacle_timeouts db 5, 3, 7, 3, 6, 1, 7, 3, 7, 1, 5, 3
create_obstacles_timeout_index db 0

screen_text_initial_x db 5
screen_text_initial_y db 12

welcome_screen db 'Welcome To Dino, Press Any Key To Start The Game$'
db 'Press H to view help menu$'
db 'Press ESC to exit$'
db 'Press Any other key to start the game$'

help_screen db 'The objective of the game is to avoid the obstacles$'
db 'Press W to jump over the obstacles$'
db 'You get score for the time you are running$'
db 'If you touch the an obstacle you loose$'
db 'If you reach a score of 1000 you win$'
db 'Press any key to go back to the welcome screen'


loose_screen db 'You Have Lost The Game!!!$'
db 'Press Any Key To Replay, Press ESC To Exit$'

win_screen db 'You Have Won The Game!!!$'
db 'Press Any Key To Replay, Press ESC To Exit$'
score dw 0

player_x db 5
player_y db 20

player_velocity db 0

player_high_y db 8
player_low_y db 20 

player_up_tiemout db 3
player_up_timer db 0 

player_width db 3
player_height db 2
player_sprite db '---'
db '***'

empty_line db '                                                                 '

obstacle_width db 2
obstacle_height db 4
obstacle_sprite db '||'
db '||'
db '**'
db '**'

obstacle_starting_x db 60
obstacle_starting_y db 18
current_obstacle_locations dw 10 dup(0)

score_string db 5 dup(30h)

CODESEG
;code

; this function converts a given 16 bit number to a string that is saved in the memory
number_to_string:
    push bp

    mov bp, sp

    push ax
    push bx
    push cx
    push dx
    push di

    mov di, 10 ; devider - decimal number system

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

    mov bx, [bp + 6] ; getting original pointer
    inc bx
    mov [byte ptr bx], '$'; closing the string with a separator character

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4



; this function is responsible for converting a given pointer to a char in video memory 
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

; this function converts a given x and y parameters into a pointer to a character in video memory
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

; this function draws one character to the video screen.
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

; this function draws a line with a given length from the memory, used to draw ascii sprites
draw_ascii_line:
    push bp
    mov bp, sp
    push di
    push si
    push cx
    push ax

    mov di, [bp + 8] ; initial location on screen
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

; this function is responsible for drawing an ascii sprite from the memory
draw_ascii_sprite:
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


; this function draws a string of charactes to the screen
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
    push di
    mov cl, [bx]
    mov ch, al
    push cx
    call draw_char
    add di, 2
    inc bx
    cmp [byte ptr bx], '$'
    jne dtl_lp


    mov [bp + 8], bx ; returns the end pointer.

    pop di
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4

; this function draws a "menu_screen" to the screen using draw_text_line
draw_menu_screen:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push di

    mov di, [bp + 10] ; location in video memory where the screen should be drawn
    mov bx, [bp + 8] ; offset of the screen in memory
    mov cx, [bp + 6] ; number of lines that should be drawn
    mov ax, [bp + 4] ; the color the screen should be 

    lp_dsc:
    push di
    push bx
    push ax
    call draw_text_line
    pop bx
    inc bx
    add di, 160
    loop lp_dsc

    pop di
    pop cx
    pop bx
    pop ax
    pop bp
    ret 8

; this function is responsible for drawing empty char in place of an ascii sprite
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

; this function is responsible for clearing the entire video memory
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

; this function plays a short sound
beep:
    push ax
    push cx
    
    mov al, 0b6h            ; prepare the speaker for change frequency
	out 43h, al

    mov ax,  0a98h          ;frequency of the note 
	out 42h, al             ; output low byte
	mov al,  ah
	out 42h, al             ; output hight byte (out only from register <al>)
	in al, 61h              ; port 61h - speaker port
	or al, 00000011b        ; put two lowest bits as 1 for
	out 61h, al 

    mov cx, 0FFFFh
    lp_beep:
	  
    loop lp_beep

    in al, 61h
	and al, 11111100b      
	out 61h, al   

    pop cx
    pop ax
    ret

; this function is responsible for clearing the keyboard buffer using int 21h
clear_keyboard_buffer:
    push ax

    mov ah,0ch
    mov al,0
    int 21h

    pop ax
    ret

; this function check if two lines are colliding with each other.
; returns 1 or 0 according to the result of the calculation
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

; this function checks if two rectangels collide with one another using check_1d_collision on both of the damations of the rectangles
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


; this function checks if the player character collides with a given obstacle
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
    mov [running_flag], 1
    end_copdc:
    pop di
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2

; this function increases the score, converts it to string and draws it to string.
update_score:
    push ax

    inc [word ptr score]

    mov ax, offset score_string
    add ax, 5 ; length of the string
    push ax

    mov ax, [score]

    push ax

    call number_to_string ; converts the score number to string

    call draw_score ; draws the score to the screen
    pop ax
    ret



; this function is responsible for handeling all the logic of the game that is releated to the keyboard IO
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

    ; this section of the code changes the playe'rs velocity - the variable that tells the player character in which direction it should move

    move_up_io:
    cmp [player_velocity], 1
    je exit_io
    cmp [player_velocity], 2
    je exit_io
    mov [player_velocity], 1
    call beep
    jmp exit_io

    move_down_io:
    cmp [player_velocity], 0
    je exit_io
    mov [player_velocity], 2
    mov [player_up_timer], 0

    exit_io:
    ;call clear_keyboard_buffer
    pop ax
    ret


; this function is responsible for updating the pseudo-random spawning time of the obstacles.
update_spawn_time:
    push ax
    push bx

    mov ax, 0
    cmp [create_obstacles_timeout_index], 12
    jl next_ust
    mov [create_obstacles_timeout_index], 0
    next_ust:
    mov al, [create_obstacles_timeout_index]
    mov bx, offset create_obstacle_timeouts
    add bx, ax
    mov al, [bx]
    mov [create_obstacles_timeout], al
    end_ust:
    inc [create_obstacles_timeout_index]
    pop bx
    pop ax
    ret

; this function is responsable for creating a new obstacle 
create_obstacle:
    push bx
    push cx
    push dx

    mov bx, offset current_obstacle_locations

    mov dl, [obstacle_starting_x]
    mov dh, [obstacle_starting_y]
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

; this function is responsible for drawing a blank screen where a given obstacle once stood
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

; this function is responsible for moving a given obstacle to the left side of the screen
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

; this function gathers all of the logic that is releated to obstacles.
update_obstacles:
    push ax
    push bx
    push cx

    mov bx, offset current_obstacle_locations
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

; this function is responsible for moving the player character up
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

; this function is responsible for moving the player character down
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

; this function is responsible for handeling all the logic that is releated to the player - drawing and moving.
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
    mov [sound_flag], 0
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

; this is the main function of the game, it is responsible for updating all the game timers and trigerring all the other game logic functions
update_timers:
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
    cmp [word ptr bx], 0A00h
    jne ut_cont2
    call update_obstacles
    mov [word ptr bx], 0
    ut_cont2:
    mov bx, offset create_obstacles_timer
    inc [word ptr bx]
    cmp [word ptr bx], 0010h
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
    mov bx, offset update_score_timer
    inc [word ptr bx]
    cmp [word ptr bx], 0F000h
    jne ut_cont4
    call update_score
    mov [word ptr bx], 0
    ut_cont4:
    
    ut_end:
    pop bx
    pop cx
    ret




; this function is responsible for drawing the score string to the screen
draw_score:
    push ax
    mov ax, [score_screen_location]

    push ax

    mov ax, offset score_string

    push ax

    mov al, 10

    push ax

    call draw_text_line
    pop ax ; ignored the returned parameter from the function
    pop ax
    ret

; this function draws a given obstacle to the screen 
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

; this function is responsible for drawing the player character to the screen
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
; this function draws the welcome screen
draw_welcome_screen:
    push bx

    mov bl, [screen_text_initial_x]
    mov bh, [screen_text_initial_y]
    push bx
    call xy_to_pointer

    mov bx, offset welcome_screen
    push bx
    mov bx, 4
    push bx
    mov bx, 3
    push bx

    call draw_menu_screen

    pop bx
    ret

; this function draws the loose screen 
draw_loose_screen:
    push bx

    mov bl, [screen_text_initial_x]
    mov bh, [screen_text_initial_y]

    push bx

    call xy_to_pointer

    mov bx, offset loose_screen
    push bx

    mov bx, 2
    push bx

    mov bx, 3
    push bx

    call draw_menu_screen
    pop bx
    ret

; this function draws the win screen 
draw_win_screen:
    push bx

    mov bl, [screen_text_initial_x]
    mov bh, [screen_text_initial_y]

    push bx

    call xy_to_pointer

    mov bx, offset win_screen
    push bx

    mov bx, 2
    push bx

    mov bx, 3
    push bx

    call draw_menu_screen

    pop bx
    ret
; this function draws the help screen
draw_help_screen:
    push ax
    push bx

    mov bl, [screen_text_initial_x]
    mov bh, [screen_text_initial_y]


    push bx

    call xy_to_pointer

    mov bx, offset help_menu_screen
    push bx

    mov bx, 6
    push bx

    mov bx, 3
    push bx

    call draw_menu_screen

    pop bx
    ret

; this function resets all the important variables for the game to restart properly
reset_game:
    push bx
    push cx
    mov [create_obstacles_timer], 0
    mov [create_obstacles_timer_2], 0
    mov [create_obstacles_timeout], 1
    mov [update_obstacles_timer], 0
    mov [update_player_timer], 0
    mov [update_score_timer], 0
    mov [player_velocity], 0
    mov [create_obstacles_timeout_index], 0
    mov [score], 0
    mov [running_flag], 0
    mov [win_flag], 0
    mov [sound_flag], 0
    mov [player_y], 20
    mov bx, offset current_obstacle_locations
    mov cx, 7

    lp_rg:
    mov [word ptr bx], 0
    add bx, 2
    loop lp_rg

    pop cx
    pop bx
    ret

; this is the main game loop, this function updates the win flag according to different game events
game:
    lp:
    call update_timers
    cmp [score], 1001
    jz win_game
    cmp [running_flag], 0
    jz lp
    jmp end_game
    win_game:
    mov [win_flag], 1
    end_game:
    ret

start:
	mov ax, @data
	mov ds, ax
    mov ax, 0b800h
    mov es, ax

    draw_welcome:
    call clear_keyboard_buffer
    call beep 
    call clear_screen
    call draw_welcome_screen

    lp_welcome:
    mov ax, 0
    mov ah, 01h
    int 16h
    jz lp_welcome
    mov ah, 00h
    int 16h
    cmp ah, 23h
    je help_menu_label
    cmp ah, 01h
    je exit
    call beep
    game_label:
    call clear_screen
    call game
    call clear_screen
    cmp [win_flag], 0
    jnz draw_win
    call draw_loose_screen
    jmp restart_menu_label
    draw_win:
    call draw_win_screen
    restart_menu_label:
    mov ax, 0
    mov ah, 01h
    restart_loop:
    int 16h
    jz restart_loop
    mov ah, 00h
    int 16h
    cmp ah, 01h
    je exit
    mov ax, 0
    mov ah, 01h 
    call reset_game
    jmp game_label

    help_menu_label:
    call clear_screen
    call draw_help_screen
    mov ax, 0
    mov ah, 01h
    help_loop:
    int 16h
    jz help_loop
    jmp draw_welcome

exit:
	mov ax, 4c00h
	int 21h
END start