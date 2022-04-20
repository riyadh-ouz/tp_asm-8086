assume ds:data, cs:code

data segment ;Marque de debut du segment de donnees
    msg db "Hello, World!", '$'
data ends

code segment ;Marque de debut du segment de code
    main:
        mov ax, data
        mov ds, ax
        
        ;La fonction 9h du DOS (INT 21h) affiche a l'ecran la chaîne de caracteres dont l'adresse
        ;est passee par DX et qui se termine par un '$' (non affiche).
        
        mov ah, 09h
        mov dx, offset msg
        
        ;L'appel du DOS
        int 21h

        mov ah, 4ch ;La fonction 9h du DOS met fin au programme
        int 21h ;L'appel du DOS
code ends
end main ;Point d'entree du programme
