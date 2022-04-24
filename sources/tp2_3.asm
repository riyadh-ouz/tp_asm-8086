; TP 2: (suite)

include macros.inc

assume cs:code, ds:data

data segment
    nom db 10 dup(?)
data ends

code segment
    main:
        mov ax, data
        mov ds, ax


        mov si, offset nom
        xor cx, cx
        mov ah, 08h ;La fonction 08h du DOS, lit UN seul caractere au clavier et le retourne par AL.
    lire:
        int 21h
        cmp al, 13 ;La touche entree
        je finLire
        mov byte ptr [si], al
        inc si
        inc cx
        jmp lire
    finLire:
        mov byte ptr [si], '$'
        

        mov ah, 02h ;La fonction 2h du DOS affiche le caractere dont le code ASCII est passé par DL.
        mov si, offset nom
    boucle:
        mov dl, [si]
        int 21h ;L'appel du DOS
        inc si
        loop boucle

        ;afficherChaine nom

        mov ah, 4ch
        int 21h
code ends
end main
