; Written by: Ophir Nevo Michrowski                       ;
; Name: mainFile.asm                                      ;
; this is a file handler that manages the user interface  ;

; File Defenition ;
IDEAL
MODEL small
STACK 100h

; Global Variables ;
DATASEG
    sched db 256 dup(?)
    key db 256 dup(?)
    key_arr_len dw 0
    text db "Hello world", 245 dup(0)
    text_len dw 0

; Code ;
CODESEG


    ; Including the librarys ;
    include "RC4.asm" ; encryption
    include "FHandle.asm" ; file and folder encryption
    include "GUI.asm" ; GUI elements

    ; Start ;
    start:
        ; Required Code ;
        mov ax, @data
        mov ds, ax

        ; PlaceHolder key ;
        mov [offset key], 31d
        mov [offset key+1], 21d
        mov [offset key+2], 11d
        mov [key_arr_len], 3
        mov [text_len], 11d


        ; Pushing the values of the encrypt decrypt proc to stack ;
        push offset text
        
        mov ax, [text_len]
        push ax

        push offset sched
        push offset key

        mov ax, [key_arr_len]
        push ax

        ; Calling the encrypt decrypt proc ;
        call encryptDecrypt

        ; Pushing the values of the encrypt decrypt proc to stack ;
        push offset text
        
        mov ax, [text_len]
        push ax

        push offset sched
        push offset key

        mov ax, [key_arr_len]
        push ax

        ; Calling the encrypt decrypt proc ;
        call encryptDecrypt

    ; Exit ;
    exit:
        ; Required code ;
        mov ax, 4c00h
        int 21h
; End of file ;
END start