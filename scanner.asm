; Written by: Ophir Nevo Michrowski                                     ;
; Name: Scanner.asm                                                     ;
; this virus I MEAN FILE contains the algorithm to scan a folder given  ;

; ---------------------------------------------;
; SUMMARY - This opens the file in the         ;
;           specified format                   ;
; IN -                                         ;
; OUT -                                        ;
; ---------------------------------------------;

proc OpenFile
    ; Setting up for the file open ;
    mov ah, 3Dh
    xor al, al
    lea dx, [filename] 
    int 21h
    
    jc openerror ; If there is an error with the open ;

    mov [filehandle], ax
    ret

    ; Error Handle ;
    openerror:

        ; Printing the Error message ;
        mov dx, offset ErrorMsg
        mov ah, 9h
        int 21h
        
        ret
endp OpenFile

; ---------------------------------------------;
; SUMMARY - scans the folder for files and     ;
;           sub folders and encryps every file ;
; IN -                                         ;
; OUT -                                        ;
; ---------------------------------------------;
proc FolderScanAndEncrypt
    
endp FolderScanAndEncrypt

; ---------------------------------------------;
; SUMMARY - scans the folder for files and     ;
;           sub folders and decryps every file ;
; IN -                                         ;
; OUT -                                        ;
; ---------------------------------------------;
proc FolderScanAndDecrypt
endp FolderScanAndDecrypt


; ---------------------------------------------;
; SUMMARY - goes over a file line by line and  ;
;           encryps it                         ;
; IN -                                         ;
; OUT -                                        ;
; ---------------------------------------------;
proc FileEncrypt
endp FileEncrypt

; ---------------------------------------------;
; SUMMARY - goes over a file line by line and  ;
;           decryps it                         ;
; IN -                                         ;
; OUT -                                        ;
; ---------------------------------------------;
proc FileDecrypt
endp FileDecrypt