call PrintTxtTitle

; Getting the key from the user ;
mov cx, offset keyInput
PrintLine cx

mov dx, offset keyBufferSettings
mov ah, 0ah
int 21h

mov bx, dx
mov dl, [byte ptr bx+1]
xor dh,dh
mov [keyLen], dx

; Getting the text from the user ;
mov cx, offset textInput
PrintLine cx

mov dx, offset textBufferSettings
mov ah, 0ah
int 21h

mov bx, dx
mov dl, [byte ptr bx+1]
xor dh,dh
mov [textLen], dx

; getting rid of the \r prompt ;
mov bx, [textLen]
mov dx, [offset text + bx]
xor [offset text + bx],dx
mov bx, [keyLen]
mov dx, [offset key + bx]
xor [offset key + bx],dx

; Encrypting ;
push offset text
xor ax, ax
mov al, [byte ptr textLen]
push ax
push offset sched
push offset key
push [keyLen]
call encryptDecrypt

PrintNewLine
mov cx, offset resultOutput
PrintLine cx

xor bx,bx
PrintText:
mov ah, 02h
mov dl, [offset text + bx]
int 21h
inc bx
cmp bx, [textLen]
jne PrintText