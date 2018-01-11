.MODEL small
.STACK 100h
DATASEG
;data
msg db 'no game no life $'
CODESEG
;code
; bx - used as pointer
; cl - checks if found no
; dh - stores the current character
; dl - stores * character
start:
	mov ax, @data
	mov ds, ax
	; resets values
	mov bx, offset msg
	mov cl, 0
	mov dl, '*'
; main loop
lp:
	mov dh, [bx] ; saves current character to dh 
	c1:
		cmp dh, 'n' ; checks if the current character is n
		jnz c2
		or cl, 00000001b ; if n saves this data
	c2:
		cmp dh, 'o' ; checks if the current character is o
		jnz c3
		cmp cl, 00000001b ; checks if the previos character was n
		jnz no
		or cl, 00000010b ; if both true saves data

	c3:
		cmp dh, ' ' ; checks if the current character is ' '
		jnz incre 
		cmp cl, 00000011b ; checks if the prevoios two were 'n' and 'o'
		jnz no
		jmp truestory
	no :
		; resets cl
		mov cl, 0
		jmp incre
	truestory:
		; sets the word no to **
		mov si, bx
		dec si
		mov [byte ptr si], dl
		dec si
		mov [byte ptr si], dl
		mov cl, 0
	incre:
		inc bx

cond:
	cmp [bx], '$'
	jnz lp

print:
	mov dx, offset msg
	mov ah, 9h
	int 21h
	mov ah, 2
	mov dl, 10
	int 21h
	mov dl, 13
	int 21h
;code here

exit:
	mov ax, 4c00h
	int 21h
END start
