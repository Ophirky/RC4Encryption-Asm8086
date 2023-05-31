; Written by: Ophir Nevo Michrowski                          ;
; Name: Scanner.asm                                          ;
; This file is the library that handles all of the file work ;

; ---------------------------------------------;
; SUMMARY - This opens the file in the         ;
;           specified format                   ;
;                                              ;
; IN - This proc takes the File name,          ;
;      file handle offset, opening type[0,1,2] ;
;                                              ;
; OUT - int - error code through ax            ;
;       0 - no error,                          ;
;       2 - file not found,                    ;
;       5 - to many file open,                 ;
;       12 - access denied                     ;
; ---------------------------------------------;

proc OpenFile
        ; local vars ;
        filename_offset equ [bp + 8]
        file_handle_offset equ [bp + 6]
        opening_format equ [byte ptr bp + 4]

        push bp
        mov bp, sp

        ; setting the int params ;
        mov ah, 3Dh

        mov al, opening_format

        mov dx, filename_offset
        int 21h

        ; Error handling ;
        jc returnFromProc

        mov bx, file_handle_offset
        mov [bx], ax
        xor ax,ax
        
        returnFromProc:
            pop bp
            ret 6
    endp OpenFile

; ---------------------------------------------;
; SUMMARY - This reads the file                ;
;                                              ;
; IN - This proc takes the File read buffer &  ;
;      file handle                             ;
;                                              ;
; OUT - void                                   ;
; ---------------------------------------------;
proc ReadFile
    ; local vars ;
    file_read_buffer_offset equ [bp + 6]
    file_handle equ [bp + 4]


    push bp
    mov bp, sp

    mov ah, 3Fh
    
    mov bx, file_handle
    mov cx, 255
    mov dx, file_read_buffer_offset

    int 21h

    pop bp
    ret 4
endp ReadFile

; ---------------------------------------------;
; SUMMARY - This writes to the file            ;
;                                              ;
; IN - This proc takes the text to write &     ;
;      message_len, file handle                ;
;                                              ;
; OUT - void                                   ;
; ---------------------------------------------;
proc WriteToFile
    ; local vars ;
    message_offset equ [bp + 8]
    message_len equ [bp + 6]
    file_handle equ [bp + 4]

    push bp
    mov bp, sp

    mov ah, 40h
    
    mov bx, file_handle
    mov cx, message_len
    mov dx, message_offset

    int 21h

    pop bp
    ret 6
endp WriteToFile

; ---------------------------------------------;
; SUMMARY - This closes the file               ;
;                                              ;
; IN - This proc takes file_handle             ;
;                                              ;
; OUT - void                                   ;
; ---------------------------------------------;
proc CloseFile
    file_handle equ [bp + 4]
    
    push bp
    mov bp, sp

    mov ah,3Eh
    mov bx, file_handle
    int 21h

    pop bp
    ret 2
endp CloseFile

; ---------------------------------------------;
; SUMMARY - scans the folder for files and     ;
;           sub folders and encryps every file ;
; IN -                                         ;
; OUT -                                        ;
; ---------------------------------------------;
proc FolderScanAndEncrypt
endp FolderScanAndEncrypt

; ---------------------------------------------;
; SUMMARY - goes over a file line by line and  ;
;           encryps it                         ;
; IN -                                         ;
; OUT -                                        ;
; ---------------------------------------------;
proc FileEncrypt
endp FileEncrypt  