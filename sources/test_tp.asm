; Test TP

include macros.inc

extrn afficherDec: near

assume cs:code, ds:data, ss:pile

pile segment stack
    dw 1024 dup(0)
pile ends

data segment
    SourceStr db "Hello world", 0
    TestStr db "world", 0
data ends

code segment

    index proc
            pushf
            push si
            push di
            push bp
            mov bp, sp

            mov ax, si ; Initialisation du AX

        ind1:
            cmp byte ptr ds:[si], 0
            je nonTrouve

            mov di, [bp+2] ; Restauration de la valeur de DI

            ind2:
                cmp byte ptr es:[di], 0
                je trouve

                cmp byte ptr ds:[si], 0
                je nonTrouve
                
                cmpsb
                jne finInd2

                jmp ind2

            finInd2:
                inc ax
                mov si, ax
                jmp ind1

        nonTrouve:
            mov ax, 0ffffh ; N'est pas trouvee
        trouve:
            pop bp
            pop di
            pop si
            popf
            ret
    index endp

    main:
        mov ax, data
        mov ds, ax
        mov es, ax

        lea si, SourceStr
        lea di, TestStr
        
        call index

        call afficherDec

        mov ah, 4ch
        int 21h
code ends
end main
