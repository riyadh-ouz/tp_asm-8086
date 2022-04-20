assume cs:code, ds:data, ss:pile

pile segment stack
	dw 1024 dup(0)
pile ends

data segment
	time_buf db '00:00:00:00', 0dh, 0ah, 24h
    intVectSave dd ? ;Double pour sauvegarder le CS et le IP
data ends

code segment

    convert proc
        push dx
        xor ah, ah
        mov dl, 10
        div dl ; exemple: 17 div 10 ==> AL=1, AH=7
        or ax, 3030h ; add ah, '0' && add al, '0'
        pop dx
        ret
    convert endp

    get_time proc
        mov ah, 2ch ; CH=hour, CL=min, DH=sec, DL=hundredths
        int 21h

        mov al, ch
        call convert
        mov [bx], ax ; 'al:ah'

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

    ;La routine d'interruption
    display_time proc far
        call get_time
        lea dx, time_buf
        mov ah, 09h
        int 21h
        iret
    display_time endp


    main:
        mov ax, data
        mov ds, ax

        ;Sauvegarder l'ancienne interruption
        mov ax, 35ffh ; AH=35h, AL=ffh (la fonction 35h du DOS)
        int 21h
        mov word ptr intVectSave, cs      ;sauvegarder le CS(ff)
        mov word ptr intVectSave+2, bx    ;sauvegarder le IP(ff)

        ;Installer la nouvelle interruption
        mov ax, 25ffh ; AH=25h, AL=ffh.
        mov dx, seg display_time
        mov ds, dx
        lea dx, display_time
        int 21h

        ;Restauration de DS
        mov ax, data
        mov ds, ax

        ;Tester l'interruption
        lea bx, time_buf
        int 0ffh


        ;Restaurer l'ancienne interruption
        mov ax, 25ffh ; AH=25h, AL=ffh.
        lds dx, intVectSave
        int 21h
        
        mov ah, 4ch
        int 21h
code ends
end main
