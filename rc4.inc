; Written by: Ophir Nevo Michrowski                          ;
; Name: rc4.asm                                              ;
; an encryption decryption library using the rc4 encryption  ;

; --------------------------------------------;
; SUMMARY - Mixing the sched array with a     ;
;           using a pseudo random location    ;
;                                             ;
; IN - The proc accepts the key_offset,       ;
;      key_len and sched_offset.              ; 
;                                             ;
; OUT - void                                  ;
; --------------------------------------------;

proc keyScheduling
    ; Local Vars ;
    key_offset equ [bp+8]
    key_len equ [bp+6]
    sched_offset equ [bp+4]

    push bp
    mov bp, sp

    ; defining the sched array to 0-255 ;
    xor cx,cx
    xor bx,bx
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

        add di, sched_offset
        add bl, [di]
        sub di, sched_offset


        xor ax,ax
        mov ax, di
        mov si, key_len
        xor dx, dx
        div si
        mov si, dx
    
        add si, key_offset
        add bl, [si]
        sub si, key_offset

        ; Switching between two items in the sched array[bx,di] ;
        ; TMP variable ;
        xor bh,bh
        add di, sched_offset
        mov cl, [di]
        sub di, sched_offset
    
        ; switch 1 ;
        add bx, sched_offset
        mov al, [bx]
        sub bx, sched_offset

        add di, sched_offset
        mov [di], al
        sub di, sched_offset
    
        ; switch 2 ;
        add bx, sched_offset
        mov [bx], cl
        sub bx, sched_offset
    
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
; IN - The Proc gets the plain-txt/cipher-txt ;
;      offset, txt_len, sched_offset, key     ;
;      offset & key_len through the stack     ;
;                                             ;
; OUT - void                                  ;
; --------------------------------------------;
proc encryptDecrypt
    ; Local Vars ;
    text_offset equ [bp + 12]
    text_length equ [bp + 10]
    sched_offset equ [bp + 8]
    key_offset equ [bp + 6]
    key_len equ [bp + 4]

    push bp
    mov bp,sp

    ; KeyScheduling ;
    push key_offset
    push key_len
    push sched_offset
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
        add bx, sched_offset
        add di, [bx]
        sub bx, sched_offset
        and di, 0ffh

        ; Switching between two items in the sched array[bx,di] ;
        ; TMP variable ;
        add di, sched_offset
        mov dl, [di]
        sub di, sched_offset
    
        ; switch 1 ;
        add bx, sched_offset
        mov al, [bx]
        sub bx, sched_offset

        add di, sched_offset
        mov [di], al
        sub di, sched_offset
    
        ; switch 2 ;
        add bx, sched_offset
        mov [bx], dl
        sub bx, sched_offset

        ; Getting the stream value ;
        xor ax, ax
    
        add di, sched_offset
        mov al, [di]
        sub di, sched_offset

        add bx, sched_offset
        add al, [bx]
        sub bx, sched_offset

        mov si, ax

        ; encryption or decryption ;
        mov ax, di
        mov di, cx
        dec di

        ; next key stream byte in dl
        add si, sched_offset
        mov dl, [si]
        sub si, sched_offset
        
        add di, text_offset
        xor [di], dl

        ; restore di backup from ax
        mov di, ax

    loop EncryptionDecryptionLoop

    pop bp
    ret 10
endp encryptDecrypt