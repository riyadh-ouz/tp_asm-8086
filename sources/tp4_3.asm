include macros.inc

extrn afficherDec: near

assume cs:code, ds:data, ss:pile

pile segment stack
    dw 1024 dup(0)
pile ends

data segment
    SourceStr db "Hello world"
    TestStr db "world"
    string db 20 dup(?)
data ends

code segment

    index proc
        xor ax, ax
        ret
    index endp

    main:
        mov ax, data
        mov ds, ax
        mov es, ax

        call index

        call afficherDec

        mov ah, 4ch
        int 21h
code ends
end main
