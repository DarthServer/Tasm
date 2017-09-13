.MODEL small
.STACK 100h
.data
db 1,2,3
.code
start:
mov ax,@data
mov ds,ax
; start your program
mov al,5
mov ah,al
mov al,7
mov bx,10
mov [bx],al
; end your program
;back to DOS
mov ah,4ch
mov al,0
int 21h
end start

