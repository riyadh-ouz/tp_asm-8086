; TP 2: (suite)

extrn lireDec: near
extrn afficherDec: near

assume cs:code, ds:data, ss:pile

pile segment stack
    dw 256 dup(0)
pile ends

data segment
    N1 dw ?
    N2 dw ?
    somme dw ?
data ends

code segment
    main:
        mov ax, data
        mov ds, ax

        lea di, N1
        call lireDec

        lea di, N2
        call lireDec

        mov ax, N1
        add ax, N2
        mov somme, ax
        
        call afficherDec

        mov ah, 4ch
        int 21h
code ends
end main
