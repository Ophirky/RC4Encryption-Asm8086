; Written by: Ophir Nevo Michrowski                          ;
; Name: rc4.asm                                              ;
; an encryption decryption library using the rc4 encryption  ;

; --------------------------------------------;
; SUMMARY - Mixing the sched array with a     ;
;           using a pseudo random location    ;
;                                             ;
; IN - the proc uses global vars and does not ; 
;      accept any arguments                   ;
;                                             ;
; OUT - nothing                               ;
; --------------------------------------------;
proc keyScheduling
    ; Mixing the sched (ds[0-255]) array ;
    schedOffset equ 0
    keyOffset equ 256

    xor bx,bx
    xor di,di

    MixSchedArray: ; while di < 256 ;
        ; choosing the psuedo random location in the sched array ;
        mov bx, [schedOffset+di]
        mov si, di

        xor ax,ax
        mov al, [key_arr_len]
        div si
        mov si, dx

        add bx, [keyOffset+di]

        mov ax, 256
        div bx
        mov bx, dx

        ; Switching between two items in the sched array[bx,di] ;
        ; TMP variable ;
        mov si, schedOffset
        add si, di

        ; switch 1 ;
        mov ax, [schedOffset+di]
        mov [si], ax

        ; switch 2 ;
        mov si, [si]
        mov [schedOffset + bx], si

        ; Increasing loop counter ;
        inc di
    cmp di, 256
    jb MixSchedArray

endp keyScheduling

; --------------------------------------------;
; SUMMARY -                                   ;
; IN -                                        ;
; OUT -                                       ;
; --------------------------------------------;
proc generateStreamKey

endp generateStreamKey

; --------------------------------------------;
; SUMMARY -                                   ;
; IN -                                        ;
; OUT -                                       ;
; --------------------------------------------;
proc encrypt

endp encrypt

; --------------------------------------------;
; SUMMARY -                                   ;
; IN -                                        ;
; OUT -                                       ;
; --------------------------------------------;
proc decrypt

endp decrypt