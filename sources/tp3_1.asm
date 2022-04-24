; TP 3: Les procedures et les macros

include macros.inc

extrn afficherDec: near

assume cs:code, ds:data, ss:pile

pile segment stack
    dw 256 dup(0)
pile ends

data segment
        tab db 15, 23, 87, 21, 65, 98, 55, 120, 65, 54, 200, 88, 7
        tabsize dw $-offset tab
        min db ?
        max db ?
        msg db 'TAB: ', '$'
        msg1 db ' | MIN: ', '$'
        msg2 db ' | MAX: ', '$'

data ends

code segment
    
    ;Un exemple de passage de parametres par @ utilisant la pile
    getMin proc
            push bp
            mov bp, sp     ;Permet d'avoir une reference fixe pour recuperer les parametres

            push ax
            push cx
            push si
            push di

            mov cx, [bp+4] ;Recuperer la taille du tableau
            mov si, [bp+6] ;Recuperer l'@ du premier element du tableau
            mov di, [bp+8] ;Recuperer l'@ du resultat
            
            mov al, [si]
        boucle:
            inc si
            getMinMac al, [si]
            loop boucle
            mov byte ptr [di], al

            pop di
            pop si
            pop cx
            pop ax
            pop bp
            ret 6 ;Depiler le IP et liberer 6 octets de la pile (les trois parametres)
    getMin endp

    getMax proc
            push bp
            mov bp, sp
            push ax
            push cx
            push si
            push di
            mov cx, [bp+4]
            mov si, [bp+6]
            mov di, [bp+8]
            mov al, [si]
        boucle2:
            inc si
            getMaxMac al, [si]
            loop boucle2
            mov byte ptr [di], al
            pop di
            pop si
            pop cx
            pop ax
            pop bp
            ret 6
    getMax endp

    afficherTab proc
            push bp
            mov bp, sp
            push ax
            push cx
            push dx ;Car le macro afficherEspace modifie le DL
            push si
            mov cx, [bp+4]
            mov si, [bp+6]
        boucle3:
            xor ah, ah
            mov al, [si]
            call afficherDec
            afficherEspace
            inc si
            loop boucle3

            pop si
            pop dx ;Car le macro afficherEspace modifie le DL
            pop cx
            pop ax
            pop bp
            ret 4
    afficherTab endp

    main:
        mov ax, data
        mov ds, ax

        afficherChaine msg
        push offset tab
        push tabsize
        call afficherTab

        afficherChaine msg1
        push offset min
        push offset tab
        push tabsize
        call getMin
        xor ah, ah
        mov al, min
        call afficherDec

        afficherChaine msg2
        push offset max
        push offset tab
        push tabsize
        call getMax
        xor ah, ah
        mov al, max
        call afficherDec

        mov ah, 4ch
        int 21h
code ends
end main
