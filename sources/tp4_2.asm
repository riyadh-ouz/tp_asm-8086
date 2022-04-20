include macros.inc

assume cs:code, ds:data, ss:pile

pile segment stack
    dw 1024 dup(0)
pile ends

data segment
    time_buf db '00:00:00:00', 0dh, 0ah, 24h
    msg1 db "Utilisant MOVSB: ", '$'
    msg2 db "Utilisant MOVSW: ", '$'
    msg3 db "Utilisant LODSB et STOSB ", '$'
	buffer1 db 2048 dup(1)
    buffer2 db 2048 dup(?)
data ends

code segment

    convert proc
        push dx
        xor ah, ah
        mov dl, 10
        div dl
        or ax, 3030h
        pop dx
        ret
    convert endp

    get_time proc
        mov ah, 2ch
        int 21h
        mov al, ch
        call convert
        mov [bx], ax
        mov al, cl
        call convert
        mov [bx+3], ax
        mov al, dh
        call convert
        mov [bx+6], ax
        mov al, dl
        call convert
        mov [bx+9], ax
        ret
    get_time endp

    display_time proc
        call get_time
        lea dx, time_buf
        mov ah, 09h
        int 21h
        ret
    display_time endp

    main:
        mov ax, data
        mov ds, ax
        mov es, ax

        lea bx, time_buf
        call display_time

        ;Transfert en utilisant MOVSB
        afficherChaine msg1

        mov dx, 0ffffh ; 65536 fois
    movsblp:
        lea si, buffer1
        lea di, buffer2
        cld
        mov cx, 0800h ; copier 2048 byte
        rep movsb
        dec dx
        jnz movsblp

        lea bx, time_buf
        call display_time

        ;Transfert en utilisant MOVSW
        afficherChaine msg2

        mov dx, 0ffffh ; 65536 fois
    movswlp:
        lea si, buffer1
        lea di, buffer2
        cld
        mov cx, 0400h ; copier 1024 word (2 bytes)
        rep movsw
        dec dx
        jnz movswlp

        lea bx, time_buf
        call display_time

        ;Transfert en utilisant LODSB et STOSB
        afficherChaine msg3

        mov dx, 0ffffh ; 65536 fois
    lslp:
        lea si, buffer1
        lea di, buffer2
        cld

        mov cx, 0800h ; copier 2048 byte
    boucle:
        lodsb
        stosb
        loop boucle

        dec dx
        jnz lslp

        lea bx, time_buf
        call display_time

        mov ah, 4ch
        int 21h
code ends
end main
