IDEAL
MODEL small
STACK 100h

DATASEG

    fileName db "file.txt", 0
    fileHandle dw ?
    errorMsg db "Error", 10, 13, '$'
    fileReadBuffer db 255 dup(?), '$'
    textToWrite db 'Hello World!'

CODESEG
    proc OpenFile
        ; setting the int params ;
        mov ah, 3Dh

        mov al, 2

        lea dx, [fileName]
        int 21h

        ; Error handling ;
        jc printError

        mov [fileHandle], ax
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
        mov cx, 255
        mov dx, offset fileReadBuffer
        int 21h
        ret
    endp ReadFile

    proc CloseFile
        mov ah,3Eh
        mov bx, [filehandle]
        int 21h
        ret
    endp CloseFile

    proc WriteToFile
        mov ah, 40h
        mov bx, [fileHandle]
        mov cx, 12
        mov dx, offset textToWrite
        int 21h
        ret
    endp WriteToFile

    start:
        mov ax, @data
        mov ds, ax

        call OpenFile
        call ReadFile

        WhileFileIsNotOver:
            call ReadFile
        cmp ax, 0
        jne WhileFileIsNotOver

        call CloseFile
        ; call OpenFile
        ; call WriteToFile
        ; call CloseFile

    exit:
        mov ax, 4c00h
        int 21h

END start