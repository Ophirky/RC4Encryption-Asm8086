; Written by: Ophir Nevo Michrowski                          ;
; Name: rc4.asm                                              ;
; an encryption decryption library using the rc4 encryption  ;

; --------------------------------------------;
; SUMMARY - Mixing an array that holds with   ;
;           a values from 0 to 255 using a    ;
;           pseudo random location            ;
;                                             ;
; IN - SchedOffset, KeyOffset, KeyLen         ; 
;                                             ;
; OUT - mixed scheduled array                 ;
; --------------------------------------------;
proc keyScheduling
    ; Local vars ;
    sched_offset equ [bp+4]
    key_offset equ [bp+6]
    key_len equ [bp+8]

    push bp
    mov bp, sp

    ; Mixing the sched (ds[0-255]) array ;
    ; Starting the array ;
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

    ; Loop to mix the Sched array ;
    MixSchedArray:
        ; while di < 256 ;
        add bl, [sched_offset+di]

        xor ax,ax
        mov ax, di
        mov si, [word ptr key_len]
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
        
    pop bp
    ret 6
endp keyScheduling


; --------------------------------------------;
; SUMMARY - This function gets text and       ;
;           encrypts it if it's not encrypted ;
;           or decrypts it if it's already    ;
;           encrypted                         ;
;                                             ;
; IN - plain-text/cipher-text offset,         ;
;      text length, sched offset, key offset  ;
;      key length                             ;
;                                             ;
; OUT - plain/cipher text                     ;
; --------------------------------------------;
proc encryptDecrypt

    ; Local Variables ;
    key_len equ [bp + 12]
    key_offset equ [bp + 10]
    sched_offset equ [bp + 8]
    text_length equ [bp + 6]
    text_offset equ [bp + 4]


    push bp
    mov bp,sp

    ; KeyScheduling ;
    push sched_offset
    push key_offset
    push key_len
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

        ;--------------------------;
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
    ret 10
endp encryptDecrypt