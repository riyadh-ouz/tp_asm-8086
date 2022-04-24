; TP 4: (suite)

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
        mov ax, 0
        mov es, ax

        mov ax, es:[0ffh*4]      ;sauvegarder le CS(ff)
        mov word ptr intVectSave, ax
        mov ax, es:[0ffh*4+2]    ;sauvegarder le IP(ff)
        mov word ptr intVectSave+2, ax

        ;Installer la nouvelle interruption
        pushf
        cli
        mov word ptr es:[0ffh*4], offset display_time
        mov word ptr es:[0ffh*4+2], seg display_time
        popf

        ;Tester l'interruption
        lea bx, time_buf
        int 0ffh

        ;Restaurer l'ancienne interruption
        mov ax, 0
        mov es, ax

        pushf
        cli
        mov ax, word ptr intVectSave
        mov es:[0ffh*4], ax
        mov ax, word ptr intVectSave+2
        mov es:[0ffh*4+2], ax
        popf
        
        mov ah, 4ch
        int 21h
code ends
end main
