; Written by: Ophir Nevo Michrowski                          ;
; Name: mainFile.asm                                         ;
; this is a file handler that manages the user interface     ;

; File Defenition ;
IDEAL
MODEL small
STACK 100h

; Global Variables ;
DATASEG
    ; encryption vars ;
    sched db 256 dup(?)
    key db 256 dup(?)
    keyLen dw 0
    text db "Hello World!", 245 dup(?)
    ; text db 255 dup(?), 10, 13, '$'
    textLen dw 0

    ; file vars ;
    fileName db "file.txt", 0
    fileHandle dw ?
    errorMsg db "Error", 10, 13, '$'
    fileReadBuffer db 255 dup(?), '$'
    textToWrite db 'Hello World!'

; Code ;
CODESEG


    ; Including the librarys ;
    include "rc4.inc" ; encryption
    include "FHandle.inc" ; file and folder encryption

    ; Start ;
    start:
        ; Required Code ;
        mov ax, @data
        mov ds, ax

        ; push offset fileName
        ; push offset fileHandle
        ; push 00000010b
        ; call OpenFile

        ; push offset text
        ; push [fileHandle]
        ; call ReadFile

        ; mov dx, offset text
        ; mov ah, 9h
        ; int 21h

        ; push [fileHandle]
        ; call CloseFile

        ; push offset fileName
        ; push offset fileHandle
        ; push 00000010b
        ; call OpenFile

        ; mov [textLen], 12d
        ; push offset textToWrite
        ; push [textLen]
        ; push [fileHandle]
        ; call WriteToFile

        ; push [fileHandle]
        ; call CloseFile
        

        ; PlaceHolder key ;
        mov [offset key], 31d
        mov [offset key+1], 21d
        mov [offset key+2], 11d
        mov [keyLen], 3
        mov [textLen], 11d

        ; Encrypting ;
        push offset text
        xor ax, ax
        mov al, [byte ptr textLen]
        push ax
        push offset sched
        push offset key
        push [keyLen]
        call encryptDecrypt

        ; Decrypting ;
        push offset text
        xor ax, ax
        mov al, [byte ptr textLen]
        push ax
        push offset sched
        push offset key
        push [keyLen]
        call encryptDecrypt

    ; Exit ;
    exit:
        ; Required code ;
        mov ax, 4c00h
        int 21h
; End of file ;
END start