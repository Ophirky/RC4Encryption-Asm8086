; Written by: Ophir Nevo Michrowski                          ;
; Name: Scanner.asm                                          ;
; This file is the library that handles all of the file work ;

; ---------------------------------------------;
; SUMMARY - This opens the file in the         ;
;           specified format                   ;
;                                              ;
; IN - This proc takes the File path,          ;
;      file handle offset, opening type [      ;
;           0 - Read,                          ;
;           1 - Write,                         ;
;           2 - Read & Write                   ;
;      ]                                       ;
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
; SUMMARY - This reads 255 chars from the      ;
;           given file                         ;
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
; SUMMARY - This writes to the given file      ;
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
; SUMMARY - This creates a file in the         ;
;           specified path & name              ;
;                                              ;
; IN - This proc takes the File path offset    ;
;                                              ;
; OUT - hex error code in ah                   ;
;       02h: File not found                    ;
;       03h: Path not found                    ;
;       05h: Access denied                     ;
;       08h: Memory control block destroyed    ;
;       0Ch: Invalid file handle               ;
;       10h: Invalid environment               ;
; ---------------------------------------------;
proc CreateFile
    file_name equ [bp + 4]

    push bp
    mov bp, sp

    mov dx, file_name
    mov cx, 0                
    mov ah, 3Ch              
    int 21h                  

    pop bp
    ret 2
endp CreateFile


; ---------------------------------------------;
; SUMMARY - goes over a file line by line and  ;
;           encrypts\decrypts it               ;
;                                              ;
; IN - This proc takes the file path,          ;
;      file handle offset, rc4File handle      ;
;      offset, text offset, key, key_len       ;
;      sched offset                            ;
;                                              ;
; OUT - void                                   ;
; ---------------------------------------------;
proc FileEncryptDecrypt
    ; local vars ;
    file_path equ [bp+16]
    file_handle_offset equ [bp+14]
    processed_file_handle_offset equ [bp+12]
    text_offset equ [bp+10]
    key_offset equ [bp+8]
    key_len equ [bp+6]
    sched_offset equ [bp+4]

    push bp
    mov bp, sp

    ; getting rid of the \r prompt ;
    mov bx, file_path
    removeEndOfInputReturnCarriage:
        cmp [byte ptr bx], 0
        je afterRemoveEndOfInputReturnCarriageLoop

        inc bx
        jmp removeEndOfInputReturnCarriage
    afterRemoveEndOfInputReturnCarriageLoop:

    dec bx
    mov [byte ptr bx], 0

    ; opening all files ;
    push file_path
    push file_handle_offset
    push 0
    call OpenFile

    ; adding the prefix to the processed file path ;  
    mov si, file_path        ; Load the address of the path string
    ; mov di, offset prefix      ; Load the address of the prefix string

    ; Find the position of the last backslash (\) in the path
    mov cx, file_path                  ; Counter for the position of the last backslash
    mov al, '\'
    mov bx, -1                 ; Register to store the position of the last backslash

    find_backslash:
        inc bx
        cmp [byte ptr si + bx], 0     ; Check for end of string
        je done

        cmp [byte ptr si + bx], al    ; Compare current character with backslash
        jne find_backslash
        add si, bx
        mov cx, si
        sub si, bx
        jmp find_backslash

    done:
    ; cx = last backslash, bx = length of text
    ; Print the modified path
        mov si,cx
        dec bx
        add bx, file_path
        shrItems:
            mov al, [bx]
            mov [bx+1], al
            dec bx
            cmp bx,cx
            jne shrItems
        
        mov bx, cx
        mov [byte ptr bx], 'e'    

    ; creating the processed file ;
    push file_path
    call CreateFile

    push file_path
    push processed_file_handle_offset
    push 1
    call OpenFile

    ; reading the file and encrypting it ;
    mov si, 0
    WSR:
        ; clearing the buffer ;
        mov bx, 255
        clearBuffer:
            dec bx
            add bx, text_offset
            mov al, [bx]
            xor [bx], al
            sub bx, text_offset
        cmp bx, 0
        jnz clearBuffer
        
        ; reading from the original file ;
        push text_offset
        mov bx, file_handle_offset
        push [bx]
        call ReadFile
        mov si, ax

        ; Encrypting ;
        push si
        push text_offset
        push si
        push sched_offset
        push key_offset
        push key_len
        call encryptDecrypt

        ; Writing new text to the new file ;
        pop si
        push text_offset
        push si
        mov bx, processed_file_handle_offset
        push [bx]
        call WriteToFile

    ; check if done reading the file ;
    cmp si, 255
    je WSR

    ; closing all files ;
    mov bx, file_handle_offset
    push [bx]
    call CloseFile
    mov bx, processed_file_handle_offset
    push [bx]
    call CloseFile

    pop bp
    ret 14
endp FileEncryptDecrypt