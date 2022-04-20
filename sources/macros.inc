getMinMac macro p1, p2
                local stocker
                local fin
                cmp p1, p2
                jb stocker
                mov al, p2
                jmp fin
        stocker:
                mov al, p1
        fin:
endm

getMaxMac macro p1, p2
                local stocker
                local fin
                cmp p1, p2
                ja stocker
                mov al, p2
                jmp fin
        stocker:
                mov al, p1
        fin:
endm

afficherEspace macro
    mov dl, 20h
    mov ah, 02h
    int 21h
endm

afficherChaine macro message
    lea dx, message
    mov ah, 09h
    int 21h
endm
