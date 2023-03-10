IDEAL
MODEL small
STACK 100h

DATASEG
sched db 255 dup(?)


CODESEG
    start:
        mov ax, @data
        mov ds, ax

        mov bx, 0
        SetArray0To255:
            cmp ax, 256d
            je SetArray0To255End

            mov [bx], bx
            inc bx
            jmp SetArray0To255

        SetArray0To255End:

    exit:
        mov ax, 4c00h
        int 21h

END start