include macros.inc

public lireDec
public afficherDec
public factorial
public repeat

assume cs:code

code segment
    
    lireDec proc ;Lire un nombre decimal sur 16 bits et le retourner dans ds:[di]
            push ax
            push bx
            push cx
            push dx

            xor bx, bx
            mov cx, 10
            xor dx, dx
        boucle:
            mov ah, 08h
            int 21h
            cmp al, '0' ; '0'< al
            jb fin
            cmp al, '9' ; al < '9'
            ja fin
            sub al, '0'
            mov bl, al
            mov ax, dx
            mul cx
            add ax, bx
            mov dx, ax
            jmp boucle
        fin:
            mov word ptr [di], dx
            pop dx
            pop cx
            pop bx
            pop ax
            ret
    lireDec endp

    afficherDec proc ;Afficher le contenu de AX en decimal
            push ax
            push bx
            push cx
            push dx

            mov bx, 10
            xor cx, cx

            cmp ax, 0
            jne boucle1
            push ax
            inc cx
            jmp fin1

        boucle1:
            xor dx, dx
            cmp ax, 0
            je fin1
            div bx
            push dx ;On empile le reste de la division
            inc cx
            jmp boucle1

        fin1:
            mov ah, 02h ;La fonction 2h du DOS, affiche le caractere passe par dl.
        boucle2:
            pop dx
            or dl, '0' ; add dl, '0'
            int 21h
            loop boucle2

            pop dx
            pop cx
            pop bx
            pop ax
            ret
    afficherDec endp

    factorial proc ;Retourner le factoriel dans AX
            push bp
            push si
            mov bp, sp
            mov si, [bp+6]
            cmp si, 0
            je finCalc
            mov ax, si
            dec ax
            push ax
            call factorial
            mul si
            jmp suite
        finCalc:
            mov ax, 1
        suite:
            pop si
            pop bp
            ret 2
    factorial endp

    ;Initialise une chaine de taille CX par le caractere stocke dans AL
    repeat proc
        pushf
        push cx
        push di

        cld
        rep stosb
        mov byte ptr es:[di], '$'

        pop di
        pop cx
        popf
        ret
    repeat endp

code ends
end
