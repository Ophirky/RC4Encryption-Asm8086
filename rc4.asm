; Written by: Ophir Nevo Michrowski                          ;
; Name: rc4.asm                                              ;
; an encryption decryption library using the rc4 encryption  ;

; --------------------------------------------;
; SUMMARY -                                   ;
; IN -                                        ;
; OUT -                                       ;
; --------------------------------------------;
proc keyScheduling
    mov ax, 0
    SetArray0To255:
        mov [ax], ax        

    SetArray0To255End:

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