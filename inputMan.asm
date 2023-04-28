; Written by: Ophir Nevo Michrowski                          ;
; Name: mainFile.asm                                         ;
; this is a file handler that manages the user interface     ;

; File Defenition ;
IDEAL
MODEL small
STACK 100h

; Global Variables ;
DATASEG
    sched db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255
    key db 255 dup(?)
    key_arr_len db 0

; Code ;
CODESEG


    ; Including the librarys ;
    ; include "rc4.asm" ; encryption
    include "scanner.asm" ; file and folder encryption

proc keyScheduling
    ; Mixing the sched (ds[0-255]) array ;
    schedOffset equ 0
    keyOffset equ 256

    xor bx,bx
    xor di,di

    MixSchedArray:
        ; while di < 256 ;

        add bl, [schedOffset+di]

        cmp di, 0
        je KSDiZero
        xor ax,ax
        mov ax, di
        mov si, [word ptr key_arr_len]
        xor dx, dx
        div si
        mov si, dx
        KSDiZero:
    
        add bl, [keyOffset+si]
    
        mov cx, 256
        mov al, bl
        xor dx,dx
        div cx
        mov bx, dx
    
        ; Switching between two items in the sched array[bx,di] ;
        ; TMP variable ;
        mov si, schedOffset
        add si, di
    
        ; switch 1 ;
        xor ax,ax
        mov al, [schedOffset+di]
        mov [si], ax
    
        ; switch 2 ;
        mov si, [si]
        mov [schedOffset + bx], si
    
        ; Increasing loop counter ;
        inc di
        cmp di, 256
        jb MixSchedArray
        
    ret
endp keyScheduling


    ; Start ;
    start:
        ; Required Code ;
        mov ax, @data
        mov ds, ax

        ; PlaceHolder key ;
        mov [offset key], 31d
        mov [offset key+1], 21d
        mov [offset key+2], 11d
        add [key_arr_len], 3


        call keyScheduling
    ; Exit ;
    exit:
        ; Required code ;
        mov ax, 4c00h
        int 21h

; End of file ;
END start