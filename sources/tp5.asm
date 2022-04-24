; TP 5: Les interfaces d'entrees et de sorties

include macros.inc

assume cs:code, ds:data, ss:pile

pile segment stack
    dw 1024 dup(0)
pile ends

data segment
    time_buf db '00:00:00', 0dh, 0ah, 24h
data ends

code segment

    convert proc
        push dx
        xor ah, ah
        mov dl, 16 ;On divise sur 16
        div dl
        or ax, 3030h
        pop dx
        ret
    convert endp


    get_time proc

        ;On recupere l'heure systeme de la RAM CMOS utilisant les ports 70h et 71h

        ;Heures
        mov al, 04h ; 04h est l'adresse des heures dans la RAM CMOS
        out 70h, al ; on passe l'adresse dans le port 70h
        in al, 71h  ; on recupere l'info (l'heure) du port 71h
        call convert
        mov [bx], ax

        ;Minutes
        mov al, 02h ; 02h est l'adresse des minutes dans la RAM CMOS
        out 70h, al
        in al, 71h
        call convert
        mov [bx+3], ax

        ;Secondes
        mov al, 00h ; 00h est l'adresse des secondes dans la RAM CMOS
        out 70h, al
        in al, 71h
        call convert
        mov [bx+6], ax

        ret
    get_time endp


    display_time proc
        call get_time
        afficherChaine time_buf
        ret
    display_time endp

    main:
        mov ax, data
        mov ds, ax

        lea bx, time_buf
        call display_time

        mov ah, 4ch
        int 21h
code ends
end main
