; Written by: Ophir Nevo Michrowski                          ;
; Name: mainFile.asm                                         ;
; this is a file handler that manages the user interface     ;

; File Defenition ;
IDEAL
MODEL small
STACK 100h

; Global Variables ;
DATASEG

; Code ;
CODESEG 
    ; Start ;
    start:
        ; Required Code ;
        mov ax, @data
        mov ds, ax

    ; Exit ;
    exit:
        ; Required code ;
        mov ax, 4c00h
        int 21h

; End of file ;
END start