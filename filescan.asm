.MODEL SMALL
.STACK 100h

.DATA
folder DB 'D:/Python/theFile', 0
filename DB 100 DUP('$')
findhandle DW ?
found DB ?

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX
    
    ; Find first file in folder
    MOV AH, 1Ah
    LEA DX, folder
    INT 21h
    JC EXIT
    
SCAN_LOOP:
    ; Print filename
    LEA DX, filename
    MOV AH, 09h
    INT 21h
    
    ; Find next file in folder
    MOV AH, 1Bh
    MOV DX, OFFSET found
    INT 21h
    JZ EXIT
    
    JMP SCAN_LOOP
    
EXIT:
    ; Exit program
    MOV AH, 4Ch
    INT 21h
    
MAIN ENDP
END MAIN
