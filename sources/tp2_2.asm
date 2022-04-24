; TP 2: (suite)

assume cs:code, ds:data

data segment
     org 10h
     nombres dw 0120h, 234Dh, 1DE6h, 3BC7h, 010Dh, 566Ah
     org 20h
     somme dw ?
data ends

code segment
     main:
          mov ax, data
          mov ds, ax

          mov cx, 6
          mov si, offset nombres
          mov bx, 0
     boucle:
          add dx, [si]
          add si, 2
          dec cx
          jnz boucle

          mov di, offset somme
          mov [di], bx

          mov ah, 4ch
          int 21h
code ends
end main
