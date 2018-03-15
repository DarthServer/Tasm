IDEAL
MODEL small
STACK 100h
DATASEG
;data

lngth dw 0
wdth dw 10
hght dw 10
indexes dw 0

CODESEG
;code


drawCollum:
    ; arguments -> pointer to initial location, lngth
    push bp

    mov bp, sp

    push di
    push cx
    push dx


    mov di, [bp + 8] ; pointer 
    mov cx, [bp + 6] ; length
    mov dx, [bp + 4] ; colors
    lpdc:
        push di
        push dx
        call drawChar
        pop dx
        call saveLocation
        pop di
        add di, 160
        loop lpdc
    pop dx
    pop cx
    pop di
    pop bp
    ret

saveLocation:
    push bp

    mov bp, sp

    push di
    push si

    mov di, [bp + 4]

    mov si, offset indexes
    add si, lngth
    add si, lngth

    mov [si], di

    inc lngth

    pop si
    pop di
    pop bp
    ret

checkLocation:
    push bp

    mov bp, sp

    push di
    push bx
    push cx
    push si

    mov di, [bp + 4] ; pointer to location of the star

    mov cx, lngth
    mov bx, 0
    mov si, offset indexes

    lpCL:
        mov bx, [si]
        cmp di, bx
        jnz cnt
        call finalWord
        cnt:
        add si, 2
        loop lpCL

    pop si
    pop cx
    pop bx
    pop di
    pop bp
    ret
drawRec:
    ; arguments -> pointer to initial location,
    ; width, height, color
    push bp

    mov bp, sp

    push di
    push ax
    push cx
    push dx

    mov di, [bp + 10] ; pointer
    mov cx, [bp + 8] ; width
    mov ax, [bp + 6] ; height
    mov dx, [bp + 4] ; color


    lpdr:
        push di
        push ax
        push dx
        call drawCollum
        pop dx
        pop ax
        pop di
        add di, 2
        loop lpdr

    pop dx
    pop cx
    pop ax
    pop di
    pop bp
    ret


drawChar:
    ; arguments -> pointer to location,
    ; and a word where low byte is the char and the high is the color
    push bp

    mov bp, sp

    push di
    push dx


    mov di, [bp + 6]
    mov dx, [bp + 4]
    mov [es:di], dl
    inc di
    mov [es:di], dh

    pop dx
    pop di
    pop bp
    ret

clearPos:
    push bp

    mov bp, sp

    push di

    mov di, [bp + 4]

    mov [byte ptr es:di], 0

    pop di
    pop bp
    ret

moveUp:
    ; moves the pointer up
    ; initializion and poping arguments
    ; di - pointer

    push bp
    mov bp, sp
    push di

    mov di, [bp + 4]
    ; end block

    ; checks if pointer is lower than the upper border
    sub di, 160
    cmp di, 0
    jl endMU

    mov [bp + 4], di
    ;end block

    ; ending of the function
    endMU:
    pop di
    pop bp
    ret
    ; end block 

moveDown:
    ; moves the pointer up
    ; initialization and poping arguments
    push bp
    mov bp, sp
    push di
    mov di, [bp + 4]
    ; end block

    ; checkes if pointer is bigger than the lower border
    add di, 160
    cmp di, 160 * 25
    jg endMD
    ; end block

    mov [bp + 4], di

    ; ending of the function
    endMD:
    pop di
    pop bp
    ret
    ; end block

moveLeft:
    ; moves pointer left
    ; initialization and poping arguments
    push bp
    mov bp, sp

    push di
    push ax
    push bx
    push dx

    mov di, [bp + 4]
    mov ax, di
    mov bx, 160
    mov dx, 0
    ; end block

    ; checks if the pointer is in the left border
    div bx
    cmp dx, 0
    je endML
    sub di, 2
    mov [bp + 4], di
    ; end block
    endML:
    pop dx
    pop bx
    pop ax
    pop di
    pop bp
    ret

moveRight:
    ; moves pointer right
    ; initialization and poping arguments
    push bp
    mov bp, sp

    push di
    push ax
    push bx
    push dx

    mov di, [bp + 4]
    mov ax, di
    mov bx, 160
    mov dx, 0
    ; end block

    ; checks if the pointer is in the left border
    div bx
    cmp dx, 158
    je endMR
    add di, 2
    mov [bp + 4], di
    ; end block
    endMR:
    pop dx
    pop bx
    pop ax
    pop di
    pop bp
    ret
processKey:
    ; the big function that processes the keyboard input.
    ; arguments -> location pointer and keyboard input

    ; initialization and poping arguments
    ; al - character in ascii
    ; di - pointer to char location
    push bp

    mov bp, sp

    push di
    push ax
    mov di, [bp + 6]
    mov ax, [bp + 4]
    ; end block

    ; checks if 'c' was pressed, if yes exits
    cmp al, 99
    jne nextPK
    call exitProgram
    ; end block 

    ; checks for WASD buttons and runs the coresponding functions
    nextPK:
    push di
    call clearPos
    ;pop di
    ;push di
    cmp al, 119
    je mvUp
    cmp al, 97
    je mvLeft
    cmp al, 115
    je mvDown
    cmp al, 100
    je mvRight
    jmp endPK

    mvUp:
        call moveUp
        jmp endPK
    mvLeft:
        call moveLeft
        jmp endPK
    mvDown:
        call moveDown
        jmp endPK
    mvRight:
        call moveRight
        jmp endPK

    ; end block
    ; ends function
    endPK:
    pop di
    mov [bp + 6], di
    pop ax
    pop di
    pop bp
    ret
    ; end block
 

start:
	mov ax, @data
	mov ds, ax
	mov ax, 0b800h
	mov es, ax
    mov di, (170) * 12

    mov dl, '*'
    mov dh, 5

    push bx
    push 170 * 3
    mov bx, [wdth]
    push bx
    mov bx, [hght]
    push bx
    mov bl, 'a'
    mov bh, 8
    push bx
    call drawRec
    pop bx
    pop bx
    pop bx
    pop bx
    pop bx


lp:
    mov ax, 0
    ; draws char to screen
    push di
    push dx
    call drawChar
    pop dx
    pop di
    ; end block

    ; awaits for keyboard input

        ; checks if input is available, if not, continues the loop
        mov ah, 1
        int 16h
        jz lp
        ; end block

        ; gets the available input into ax
        mov ah, 0
        int 16h
    ; end block

    ; processes keyboard input

    push di
    push ax
    call processKey
    pop ax
    call checkLocation
    pop di

    ; end block


    jmp lp

finalWord:
    mov [byte ptr lngth], 0
    push bx
    push 170 * 3
    mov bx, [wdth]
    push bx
    mov bx, [hght]
    push bx
    mov bl, 'a'
    mov bh, 15
    push bx
    call drawRec
    pop bx
    pop bx
    pop bx
    pop bx
    pop bx

    call exitProgram
    ret


exitProgram:
	mov ax, 4c00h
	int 21h
    ret
END start
