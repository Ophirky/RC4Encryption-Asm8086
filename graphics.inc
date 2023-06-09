; Macros ;
; ---------------------------------------------;
; SUMMARY - Prints a given line                ;
;                                              ;
; IN - line offset                             ;
;                                              ;
; OUT - void                                   ;
; ---------------------------------------------;
macro PrintLine lineOffset
    mov dx, lineOffset
    mov ah, 9h
    int 21h
endm PrintLine

; ---------------------------------------------;
; SUMMARY - Prints a new line                  ;
;                                              ;
; IN - None                                    ;
;                                              ;
; OUT - void                                   ;
; ---------------------------------------------;
macro PrintNewLine
    mov dl, 0ah
    mov ah, 2h
    int 21h
endm PrintNewLine

; Procs ;
; ---------------------------------------------;
; SUMMARY - Prints the program title           ;
;                                              ;
; IN - None                                    ;
;                                              ;
; OUT - void                                   ;
; ---------------------------------------------;
proc PrintRc4Title
    PrintNewLine
    lea cx, [titleLine0]
    PrintLine cx
    lea cx, [titleLine1]
    PrintLine cx
    lea cx, [titleLine2]
    PrintLine cx
    lea cx, [titleLine3]
    PrintLine cx
    lea cx, [titleLine4]
    PrintLine cx
    lea cx, [titleLine5]
    PrintLine cx
    lea cx, [titleLine6]
    PrintLine cx
    lea cx, [titleLine7]
    PrintLine cx
    lea cx, [titleLine8]
    PrintLine cx
    lea cx, [titleLine9]
    PrintLine cx
    lea cx, [titleLine10]
    PrintLine cx
    PrintNewLine
    ret
endp PrintRc4Title
; ---------------------------------------------;
; SUMMARY - Prints the txt page title          ;
;                                              ;
; IN - None                                    ;
;                                              ;
; OUT - void                                   ;
; ---------------------------------------------;
proc PrintTxtTitle
    PrintNewLine
    lea cx, [textTitleLine0]
    PrintLine cx
    lea cx, [textTitleLine1]
    PrintLine cx
    lea cx, [textTitleLine2]
    PrintLine cx
    lea cx, [textTitleLine3]
    PrintLine cx
    lea cx, [textTitleLine4]
    PrintLine cx
    lea cx, [textTitleLine5]
    PrintLine cx
    lea cx, [textTitleLine6]
    PrintLine cx
    lea cx, [textTitleLine7]
    PrintLine cx
    PrintNewLine
    ret
endp PrintTxtTitle
; ---------------------------------------------;
; SUMMARY - Prints the file page title         ;
;                                              ;
; IN - None                                    ;
;                                              ;
; OUT - void                                   ;
; ---------------------------------------------;
proc PrintFileTitle
    PrintNewLine
    lea cx, [fileTitleLine0]
    PrintLine cx
    lea cx, [fileTitleLine1]
    PrintLine cx
    lea cx, [fileTitleLine2]
    PrintLine cx
    lea cx, [fileTitleLine3]
    PrintLine cx
    lea cx, [fileTitleLine4]
    PrintLine cx
    lea cx, [fileTitleLine5]
    PrintLine cx
    lea cx, [fileTitleLine6]
    PrintLine cx
    lea cx, [fileTitleLine7]
    PrintLine cx
    PrintNewLine
    ret
endp PrintFileTitle
