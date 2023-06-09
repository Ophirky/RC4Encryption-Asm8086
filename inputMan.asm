; Written by: Ophir Nevo Michrowski                          ;
; Name: mainFile.asm                                         ;
; this is a file handler that manages the user interface     ;

; File Defenition ;
IDEAL
MODEL small
STACK 100h

; Global Variables ;
DATASEG
    ; encryption vars ;
    sched db 256 dup(?)

    keyBufferSettings db 0ffh, 0
    key db 256 dup(?)
    keyLen dw 0

    ; text db 255 dup(?), 10, 13, '$'
    textBufferSettings db 0ffh, 0
    text db 255 dup(?), 0
    textLen dw 0

    ; Title Varialbes ;
    titleLine0 db  " _______     ______    __    __ ", 10, 13, "$"
    titleLine1 db  "|       \   /      \  |  \  |  \", 10, 13, "$"
    titleLine2 db  "| #######\ |  ######\ | ##  | ##|", 10, 13, "$"
    titleLine3 db  "| ##__| ##|| ##   \##|| ##__| ##|", 10, 13, "$"
    titleLine4 db  "| ##    ##|| ##       | ##    ##|", 10, 13, "$"
    titleLine5 db  "| #######\ | ##   __   \########|", 10, 13, "$"
    titleLine6 db  "| ##  | ##|| ##__/  \       | ##|", 10, 13, "$"
    titleLine7 db  "| ##  | ##| \##    ##|      | ##|", 10, 13, "$"
    titleLine8 db  " \##   \##|  \######/        \##|", 10, 13, "$"
    titleLine9 db  "---------------------------------", 10, 13, "$"
    titleLine10 db "           ", "encryption", "    ", 10, 13, "$"

    textTitleLine0 db "#######\   ######\  ##\      ##\       ########\ ##\   ##\ ########\ ", 10, 13, "$"
    textTitleLine1 db "##  __##\ ##  __##\ ## | #\  ## |      \__##  __|## |  ## |\__##  __|", 10, 13, "$"
    textTitleLine2 db "## |  ## |## /  ## |## |###\ ## |         ## |   \##\ ##  |   ## |   ", 10, 13, "$"
    textTitleLine3 db "#######  |######## |## ## ##\## |         ## |    \####  /    ## |   ", 10, 13, "$"
    textTitleLine4 db "##  __##< ##  __## |####  _#### |         ## |    ##  ##<     ## |   ", 10, 13, "$"
    textTitleLine5 db "## |  ## |## |  ## |###  / \### |         ## |   ##  /\##\    ## |   ", 10, 13, "$"
    textTitleLine6 db "## |  ## |## |  ## |##  /   \## |         ## |   ## /  ## |   ## |", 10, 13, "$"
    textTitleLine7 db "\__|  \__|\__|  \__|\__/     \__|         \__|   \__|  \__|   \__|", 10, 13, "$"

    fileTitleLine0 db " ######\ ######\ ##\       ########\  ######\  ", 10, 13, "$"
    fileTitleLine1 db "##  __##\\_##  _|## |      ##  _____|##  __##\ ", 10, 13, "$"
    fileTitleLine2 db "## /  \__| ## |  ## |      ## |      ## /  \__|", 10, 13, "$"
    fileTitleLine3 db "####\      ## |  ## |      #####\    \######\  ", 10, 13, "$"
    fileTitleLine4 db "##  _|     ## |  ## |      ##  __|    \____##\ ", 10, 13, "$"
    fileTitleLine5 db "## |       ## |  ## |      ## |      ##\   ## |", 10, 13, "$"
    fileTitleLine6 db "## |     ######\ ########\ ########\ \######  |", 10, 13, "$"
    fileTitleLine7 db "\__|     \______|\________|\________| \______/", 10, 13, "$"

    ; Errors ;
    fileNotFound db "File not found",10,13,"$"
    toManyFilesOpen db "To many files open", 10, 13, "$"
    accessDenied db "File access denied", 10, 13, "$"
    invalidInputError db "Invalid input", 10, 13, "$"
    fileCreationError db "File creation error", 10, 13, "$"
    noKeyEntered db "Secret key is mendatory", 10, 13, "$"

    ; texts ;
    fileOrText db "Enter 'F' for file or 'T' for plain text: ","$"
    textInput db "Enter plain text [up-to 255 chars]: ", "$"
    filePathInput db "Enter the file path [file path up-to 254 chars]: ", "$"
    keyInput db "Enter your secret key: ", "$"
    resultOutput db "result: ", "$"

    ; file vars ;
    filePrefix db 'e'
    fileNameBufferSettings db 0ffh, 0
    fileName db 256 dup(?), 0
    fileHandle dw ?
    rc4FileHandle dw ?

; Code ;
CODESEG

    ; Including the librarys ;
    include "graphics.inc" ; The Graphic drawings
    include "rc4.inc" ; encrypt  ion
    include "FHandle.inc" ; file and folder encryption
  
    ; Start ;
    start:
        ; Required Code ;
        mov ax, @data
        mov ds, ax

        ; Title Print ;
        ; ClearConsole
        call PrintRc4Title

        ; First input ;
        PrintNewLine
        lea cx, [fileOrText]
        PrintLine cx

        mov ah, 01h
        int 21h

        ; Validating the first input ;
        ; Validating file Work ;
        cmp al, 'F'
        je workOnFile
        cmp al, 'f'
        je workOnFile

        ; Validating raw text Work ;
        cmp al, 'T'
        jne checkForLowerCase
        jmp workOnRaw
        checkForLowerCase:
            cmp al, 't'
            jne invalidInputErrorJump
            jmp workOnRaw

        
        ; Input Invalid ;
        invalidInputErrorJump:
            PrintNewLine
            mov cx, offset invalidInputError
            printLine cx
            jmp exit

        ; File Work ;
        workOnFile:
            call PrintFileTitle

            ; Getting the key ;
            mov cx, offset keyInput
            PrintLine cx

            mov dx, offset keyBufferSettings
            mov ah, 0ah
            int 21h

            mov bx, dx
            mov dl, [byte ptr bx+1]
            xor dh,dh
            mov [keyLen], dx

            cmp [keyLen], 0
            jne NoFileKeyInputError
            PrintNewLine
            lea cx, [noKeyEntered]
            PrintLine cx
            jmp exit
            NoFileKeyInputError:

            ; Getting the path from the user ;
            mov cx, offset filePathInput
            PrintLine cx

            mov dx, offset fileNameBufferSettings
            mov ah, 0ah
            int 21h

            ; encrypting\decrypting the file ;
            push offset fileName
            push offset fileHandle
            push offset rc4FileHandle
            push offset text
            push offset key
            push [keyLen]
            push offset sched
            call FileEncryptDecrypt

            jmp exit

        ; Raw Text Word ;
        workOnRaw:
            call PrintTxtTitle

            ; Getting the key from the user ;
            mov cx, offset keyInput
            PrintLine cx

            mov dx, offset keyBufferSettings
            mov ah, 0ah
            int 21h

            mov bx, dx
            mov dl, [byte ptr bx+1]
            xor dh,dh
            mov [keyLen], dx

            cmp [keyLen], 0
            jne NoTextKeyInputError
            PrintNewLine
            lea cx, [noKeyEntered]
            PrintLine cx
            jmp exit
            NoTextKeyInputError:

            ; Getting the text from the user ;
            mov cx, offset textInput
            PrintLine cx

            mov dx, offset textBufferSettings
            mov ah, 0ah
            int 21h

            mov bx, dx
            mov dl, [byte ptr bx+1]
            xor dh,dh
            mov [textLen], dx

            ; getting rid of the \r prompt ;
            mov bx, [textLen]
            mov dx, [offset text + bx]
            xor [offset text + bx],dx
            mov bx, [keyLen]
            mov dx, [offset key + bx]
            xor [offset key + bx],dx

            ; Encrypting ;
            push offset text
            xor ax, ax
            mov al, [byte ptr textLen]
            push ax
            push offset sched
            push offset key
            push [keyLen]
            call encryptDecrypt

            PrintNewLine
            mov cx, offset resultOutput
            PrintLine cx

            xor bx,bx
            PrintText:
                mov ah, 02h
                mov dl, [offset text + bx]
                int 21h
                inc bx
                cmp bx, [textLen]
                jne PrintText


            ; mov cx, offset text
            ; PrintLine cx

        ; PlaceHolder key ;
        ; mov [offset key], 033h
        ; mov [keyLen], 1
        ; mov [textLen], 2

        ; mov [offset fileName], 'f'
        ; mov [offset fileName+1], 'i'
        ; mov [offset fileName+2], 'l'
        ; mov [offset fileName+3], 'e'
        ; mov [offset fileName+4], '.'
        ; mov [offset fileName+5], 't'
        ; mov [offset fileName+6], 'x'
        ; mov [offset fileName+7], 't'

    ;    push offset fileName
    ;    push offset fileHandle
    ;    push offset rc4FileHandle
    ;    push offset text
    ;    push offset key
    ;    push [keyLen]
    ;    push offset sched
    ;    call FileEncryptDecrypt


        ; push offset fileName
        ; push offset fileHandle
        ; push 00000010b
        ; call OpenFile

        ; push offset text
        ; push [fileHandle]
        ; call ReadFile

        ; mov dx, offset text
        ; mov ah, 9h
        ; int 21h

        ; push [fileHandle]
        ; call CloseFile

        ; push offset fileName
        ; push offset fileHandle
        ; push 00000010b
        ; call OpenFile

        ; mov [textLen], 12d
        ; push offset textToWrite
        ; push [textLen]
        ; push [fileHandle]
        ; call WriteToFile

        ; push [fileHandle]
        ; call CloseFile
        

        ; PlaceHolder key ;
        ; mov [byte ptr offset key], 033h
        ; mov [offset key+1], 21d
        ; mov [offset key+2], 11d
        ; mov [keyLen], 1
        ; mov [textLen], 5d

        ; mov [text], 'h'
        ; mov [text + 1], 'e'
        ; mov [text + 2], 'l'
        ; mov [text + 3], 'l'
        ; mov [text + 4], 'o'

        ; ; Encrypting ;
        ; push offset text
        ; xor ax, ax
        ; mov al, [byte ptr textLen]
        ; push ax
        ; push offset sched
        ; push offset key
        ; push [keyLen]
        ; call encryptDecrypt

        ; ; Decrypting ;
        ; push offset text
        ; xor ax, ax
        ; mov al, [byte ptr textLen]
        ; push ax
        ; push offset sched
        ; push offset key
        ; push [keyLen]
        ; call encryptDecrypt

    ; Exit ;
    exit:
        ; Required code ;
        mov ax, 4c00h
        int 21h
; End of file ;
END start