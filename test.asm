IDEAL
MODEL small
STACK 100h

DATASEG

    fileReadBuffer db 5 dup(?), '$'
    fileHandle dw ?
    fileHandle2 dw ?
    errorMsg db "Error", 10, 13, '$'
    ; textToWrite db 'Hello World!',10,13,'#'
    textToWrite db 'Hello new File!',0
    enc_file_name db "enc-"
    fileName db "file.txt", 0

    prefix db 'e'
    path db "file.txt", 0

CODESEG
    proc OpenFile
        ; setting the int params ;
        mov ah, 3Dh

        mov al, 2

        mov dx, di
        int 21h

        ; Error handling ;
        jc printError

        mov si, ax
        ret

        printError:
            mov dx, offset errorMsg
            mov ah, 9h
            int 21h
        ret
    endp OpenFile

    proc ReadFile
        mov ah, 3Fh
        mov bx, [fileHandle]
        mov cx, 5
        mov dx, offset fileReadBuffer
        int 21h
        ret
    endp ReadFile

    proc CloseFile
        mov ah,3Eh
        mov bx, di
        int 21h
        ret
    endp CloseFile

    proc WriteToFile
        mov ah, 40h
        mov bx, [fileHandle2]
        mov cx, 5
        mov dx, offset fileReadBuffer
        int 21h
        ret
    endp WriteToFile

    proc createFile
        push bx               ; Save registers
        push dx
        push cx

        mov dx, OFFSET enc_file_name  ; Pointer to the file name
        mov cx, 0                ; File attributes (0 for normal file)
        mov ah, 3Ch              ; DOS function: Create file
        int 21h                  ; Call DOS interrupt

        jc createFileError       ; Check if carry flag is set to handle error

        ; File created successfully
        ; Continue with your code here

        createFileExit:
            pop cx                ; Restore registers
            pop dx
            pop bx
            ret

        createFileError:
            ; Handle file creation error here
            jmp createFileExit     ; Jump to exit the procedure
    endp createFile


    start:
        mov ax, @data
        mov ds, ax

        ; call createFile



        ; call OpenFile
        ; call ReadFile

        ; WhileFileIsNotOver:
        ;     call ReadFile
        ; cmp ax, 0
        ; jne WhileFileIsNotOver

        ; call CloseFile
        ; call OpenFile
        ; call WriteToFile
        ; call CloseFile

        ; mov bx, OFFSET textToWrite  ; Pointer to the string
        ; mov ah, 2                  ; DOS function: Print character

        ; printLoop:
        ;     mov dl, [bx]            ; Load the byte from memory
        ;     sub dl, '0'
        ;     int 21h                 ; Print the character

        ;     inc bx                  ; Move to the next byte
        ;     cmp [byte ptr bx], 0    ; Check if end of string
        ;     jnz printLoop           ; If not end of string, continue looping

        ; mov dl, 0Ah                ; Print newline character
        ; int 21h

        ; call CreateFile

        ; mov di, offset fileName
        ; call OpenFile
        ; mov [fileHandle], si

        ; mov di, offset enc_file_name
        ; call OpenFile
        ; mov [fileHandle2], si

        ; mov si, 0
        ; WSR:
        ;     mov bx, 5
        ;     clearBuffer:
        ;         mov al, [byte ptr fileReadBuffer + bx]
        ;         xor [byte ptr fileReadBuffer + bx], al
        ;         dec bx
        ;     cmp bx, 0
        ;     jnz clearBuffer
                
        ;     call ReadFile
        ;     mov di, [fileHandle]
        ;     mov si, ax

        ;     call WriteToFile
        ; cmp si, 5
        ; je WSR

        ; mov di, [fileHandle2]
        ; call CloseFile
        ; call CloseFile


        


        ; sub [textToWrite], '0'
        ; lea dx, textToWrite
        ; ; sub dx, '0'
        ; mov ah, 9h
        ; int 21h


    mov si, offset path        ; Load the address of the path string
    mov di, offset prefix      ; Load the address of the prefix string

    ; Find the position of the last backslash (\) in the path
    mov cx, 0                  ; Counter for the position of the last backslash
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
        add bx, offset path
        shrItems:
            sub bx, offset path
            mov al, [offset path + bx]
            mov [offset path + bx+1], al
            dec bx
            add bx, offset path
            cmp bx,cx
            jne shrItems
        
        mov [byte ptr bx+1], 'e'

    ; Exit program
    mov ah, 4ch
    int 21h

END start