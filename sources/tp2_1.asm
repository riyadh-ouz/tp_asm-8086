assume cs:code, ds:data

data segment
     N1 dw 25h
     N2 dw 4
     Prod dw ?
data ends

code segment
     main:
          mov ax, data
          mov ds, ax

          mov ax, N1
          mov cx, N2
          mov dx, 0
     boucle:
          add dx, ax
          loop boucle

          mov Prod, dx

          mov ah, 4ch
          int 21h
code ends
end main
