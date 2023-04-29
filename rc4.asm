; Written by: Ophir Nevo Michrowski                          ;
; Name: rc4.asm                                              ;
; an encryption decryption library using the rc4 encryption  ;

; --------------------------------------------;
; SUMMARY - Mixing the sched array with a     ;
;           using a pseudo random location    ;
;                                             ;
; IN - the proc accepts the key using the     ;
;      global var named key                   ; 
;                                             ;
; OUT - mixed sched arr                       ;
; --------------------------------------------;
proc keyScheduling
    ; Mixing the sched (ds[0-255]) array ;
    schedOffset equ 0
    keyOffset equ offset key

    xor bx,bx
    xor di,di

    MixSchedArray:
        ; while di < 256 ;

        ; we use bl as i
        add bl, [schedOffset+di]

        xor ax,ax
        mov ax, di
        mov si, [word ptr key_arr_len]
        xor dx, dx
        div si
        mov si, dx
    
        add bl, [keyOffset+si]

        ; Switching between two items in the sched array[bx,di] ;
        ; TMP variable ;
        xor bh,bh
        mov cl, [schedOffset+di]
    
        ; switch 1 ;
        mov al, [schedOffset+bx]
        mov [schedOffset + di], al
    
        ; switch 2 ;
        mov [schedOffset + bx], cl
    
        ; Increasing loop counter ;
        inc di
        cmp di, 256
        jb MixSchedArray
        
    ret
endp keyScheduling


; --------------------------------------------;
; SUMMARY -                                   ;
; IN - plain-text/cipher-text offset & key    ;
;      offset through the stack               ;
; OUT - plain/cipher text                     ;
; --------------------------------------------;
proc encryptDecrypt
    push bp
    mov bp,sp

    textOffset equ [bp + 6]
    textLength equ [bp + 4]
    schedOffset equ offset sched

    ; KeyScheduling ;
    call keyScheduling

    xor bx,bx
    xor di,di

    mov cx, textLength
    EncryptionDecryptionLoop:
        ; stream generation ;
        inc bl

        xor bh,bh
        add di, [schedOffset + bx]
        and di, 0ffh

        ; Switching between two items in the sched array[bx,di] ;
        ; TMP variable ;
        mov dl, [schedOffset + di]
    
        ; switch 1 ;
        mov al, [schedOffset + bx]
        mov [schedOffset + di], al
    
        ; switch 2 ;
        mov [schedOffset + bx], dl

        ; Getting the stream value ;
        xor ax, ax
        mov al, [schedOffset + di]
        add al, [schedOffset + bx]
        mov si, ax

        ; encryption or decryption ;
        mov ax, di
        mov di, cx
        dec di

        ; next key stream byte in dl
        mov dl, [schedOffset + si]  ; next stream byte - breakpoint
        add di, textOffset
        xor [di], dl

        ; restore di backup from ax
        mov di, ax

    loop EncryptionDecryptionLoop

    pop bp
    ret 4
endp encryptDecrypt