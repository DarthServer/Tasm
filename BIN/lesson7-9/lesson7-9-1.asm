/*A program that switches the values from mem addres 5 and mem adress 7*/
mov BX, 5
mov BX, 7
mov AH, [BX]
mov [BX], AL
mov BX, 5
mov [BX], AH
