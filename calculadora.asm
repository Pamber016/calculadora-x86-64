section .data
   ;strings a printear
   welcome: db "Bienvenido a la calculadora, ingresa operaciones decimales y obtiene sus resultados en base binaria, octal, decimal y hexadecimal",0xa
   len1: equ $-welcome
   menu: db "Presione 1 para sumar, 2 para restar, 3 para multiplicar o 4 para dividir. 5 para salir",0xa
   len2: equ $-menu
   decimals: db "Decimal:",0xa
   len3: equ $-decimals
   binarios: db "Binario:",0xa
   len4: equ $-binarios 
   octals: db "Octal:",0xa
   len5: equ $-octals
   hexas: db "Hexadecimal:",0xa
   len6: equ $-hexas 
   ask1: db "Ingrese el primer numero:",0xa
   lenask1: equ $-ask1
   ask2: db "Ingrese el segundo numero:",0xa
   lenask2: equ $-ask2  
   ;MACROS
   %macro printear 3
    ;PEDIRLE AL USUARIO NUMERO
        mov edx, %1                   ;length pregunta      
        mov ecx, %2                   ;pregunta
        mov ebx,1                     ;file descriptor (stdout)
        mov eax,4                     ;system call number (sys_write)
        int 0x80                      ;call kernell
        ;Ingresa primer numero
        mov eax,3                     ;syscall input
        mov edx,16                    ;edx TAMANNO MAXIMO - 2 integers
        mov ebx,0                     ;file descriptor (stdin)
        lea ecx,[%3]                  ;load effective address - guarda dir de variable
        int 0x80                      ;call kernell
   %endmacro

section .bss
    ;Establecer variables para las operaciones y su tamaño en bytes
    input resb 2                    ;reservar 2 byte - 16 bits
    var1 resb 2
    var2 resb 2
section .text
   global _start                     ;must be declared for linker(ld)
    _start:                          ;tell the linker entry point
        mov edx, len1                 ;message length de welcome
        mov ecx, welcome              ;message to write: welcome
        mov ebx,1                     ;file descriptor (stdout)
        mov eax,4                     ;system call number (sys_write)
        int 0x80                      ;call kernell
    _menu:
        mov edx, len2                 ;message length de menu
        mov ecx, menu                 ;message to write: menu
        mov ebx,1                     ;file descriptor (stdout)
        mov eax,4                     ;system call number (sys_write)
        int 0x80                      ;call kernell

        mov eax,3                     ;syscall input
        mov edx,16                    ;edx TAMANNO MAXIMO INPUT
        mov ebx,0                     ;file descriptor (stdin)
        lea ecx,[input]               ;load effective address - guarda dir de INPUT
        int 0x80                      ;call kernell

        mov al, [input]
        cmp al,'1'
        je _suma                      ;Si input equals '1' jump a suma
        cmp al,'2'
        je _resta                     ;Si input equals '2' jump a resta
        cmp al, '3'
        je _multip                    ;Si input equals '3' jump a multiplica
        cmp al,'4'
        je _divi                      ;Si input equals '4' jump a divide
        cmp al, '5'
        je _fin                        ;Si input equals '5' jump a fin
        jmp _menu                     ;Si input diferente a todo lo anterior vuelve a preguntar

    ;OPERACIONES
    _suma:
        printear lenask1, ask1, var1
        printear lenask2, ask2, var2
        jmp _hexadecimal
    ;---------------------------
    _resta:
        printear lenask1, ask1, var1
        printear lenask2, ask2, var2
        jmp _hexadecimal
    ;---------------------------
    _multip:
        printear lenask1, ask1, var1
        printear lenask2, ask2, var2
        jmp _hexadecimal
    ;---------------------------
    _divi:
        printear lenask1, ask1, var1
        printear lenask2, ask2, var2
        jmp _hexadecimal
    ;---------------------------

    ;CONVERSIONES
    _hexadecimal:

    _binario:

    _octal:

    _goback:
        jmp _menu

    _fin:
        mov eax,1                     ;sytem call number (sys_exit)
        int 0x80                      ;call kernell 