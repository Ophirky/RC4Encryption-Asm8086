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
    sched_offset equ 0
    key_offset equ offset key

    mov cl, 0
    SetSchedArray0To255Two:
        mov bl,cl
        mov [byte ptr bx], cl
        inc cx
        cmp cx,256
        jb SetSchedArray0To255Two

    xor cx,cx
    xor bx,bx
    xor di,di

    MixSchedArray:
        ; while di < 256 ;

        add bl, [sched_offset+di]

        xor ax,ax
        mov ax, di
        mov si, [word ptr key_arr_len]
        xor dx, dx
        div si
        mov si, dx
    
        add bl, [key_offset+si]

        ; Switching between two items in the sched array[bx,di] ;
        ; TMP variable ;
        xor bh,bh
        mov cl, [sched_offset+di]
    
        ; switch 1 ;
        mov al, [sched_offset+bx]
        mov [sched_offset + di], al
    
        ; switch 2 ;
        mov [sched_offset + bx], cl
    
        ; Increasing loop counter ;
        inc di
        cmp di, 256
        jb MixSchedArray
        
    ret
endp keyScheduling


; --------------------------------------------;
; SUMMARY - This function gets text and       ;
;           encrypts it if it's not encrypted ;
;           or decrypts it if it's already    ;
;           encrypted                         ;
;                                             ;
; IN - plain-text/cipher-text offset & key    ;
;      offset through the stack               ;
;                                             ;
; OUT - plain/cipher text                     ;
; --------------------------------------------;
proc encryptDecrypt
    push bp
    mov bp,sp

    text_offset equ [bp + 6]
    text_length equ [bp + 4]
    sched_offset equ offset sched

    ; KeyScheduling ;
    call keyScheduling


    ; Reseting everything ;
    xor ax,ax
    xor cx,cx
    xor si,si
    xor di,di
    xor dx,dx
    xor bx,bx
    xor di,di

    ; The loop that is incharge of the encryption/decryption ;
    mov cx, text_length
    EncryptionDecryptionLoop:
        ; stream generation ;
        inc bl

        xor bh,bh
        add di, [sched_offset + bx]
        and di, 0ffh

        ; Switching between two items in the sched array[bx,di] ;
        ; TMP variable ;
        mov dl, [sched_offset + di]
    
        ; switch 1 ;
        mov al, [sched_offset + bx]
        mov [sched_offset + di], al
    
        ; switch 2 ;
        mov [sched_offset + bx], dl

        ; Getting the stream value ;
        xor ax, ax
        mov al, [sched_offset + di]
        add al, [sched_offset + bx]
        mov si, ax

        ; encryption or decryption ;
        mov ax, di
        mov di, cx
        dec di

        ; next key stream byte in dl
        mov dl, [sched_offset + si]  ; next stream byte - breakpoint
        add di, text_offset
        xor [di], dl

        ; restore di backup from ax
        mov di, ax

    loop EncryptionDecryptionLoop

    pop bp
    ret 4
endp encryptDecrypt