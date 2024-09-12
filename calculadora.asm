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
   resultMsg: db "Resultado: ", 0xa
   lenresult: equ $-resultMsg
   cocienteMsg: db "Cociente: ", 0xa
   lencociente: equ $-cocienteMsg
   ResidMsg: db "Residuo: ", 0xa
   lenResid: equ $-ResidMsg
   newLine: db " ", 0xa, 0xd
   lenNew: equ $-newLine
   ten dd 10              ; constant 10 for division
   ;MACROS
   %macro ATOI 5
    ; Prompt user
        mov eax, 4             ; sys_write
        mov ebx, 1             ; file descriptor (stdout)
        mov ecx, %1            ; message to write
        mov edx, %2            ; message length
        int 0x80               ; call kernel

        ; Read user input
        mov eax, 3             ; sys_read
        mov ebx, 0             ; file descriptor (stdin)
        lea ecx, [%3]        ; buffer to store input
        mov edx, 5             ; number of bytes to read
        int 0x80               ; call kernel

        ; Convert input from ASCII to integer
        mov esi, %3          ; point to input buffer
        xor eax, eax           ; clear EAX (accumulator for result)
        xor ecx, ecx           ; clear ECX (multiplier)

    convert_loop%5:
        movzx edx, byte [esi]    ; load next byte from buffer
        cmp edx, 0ah             ; check for newline (ASCII 0x0A)
        je done_conversion%5     ; if newline, end conversion
        sub edx, 30h             ; convert ASCII to integer (0-9)
        imul eax, eax, 10        ; multiply current result by 10
        add eax, edx             ; add new digit
        inc esi                  ; move to next byte
        jmp convert_loop%5       ; repeat until newline

    done_conversion%5:
        ; Store result
        mov [%4], eax    ; save result in result1
   %endmacro

   %macro ITOA 3
        mov eax, [%1]         ; load result
        mov ebx, %2           ; point to output buffer
        add ebx, 10           ; start at end of buffer
        mov byte [ebx], 0     ; null-terminate the string
        dec ebx               ; move to previous byte

    convert_to_ascii%3:
        xor edx, edx          ; clear EDX (remainder)
        div dword [ten]       ; divide EAX by 10
        add dl, '0'           ; convert remainder to ASCII
        mov [ebx], dl         ; store ASCII character
        dec ebx               ; move to previous byte
        test eax, eax         ; check if EAX is zero

        jnz convert_to_ascii%3  ; if not zero, continue

        mov eax, 4              ; sys_write
        mov ebx, 1              ; file descriptor (stdout)
        lea ecx, [%2]           ; address of the result buffer
        mov edx, 10             ; length of the result string; adjust if necessary
        int 0x80                ; call kernel
   %endmacro

   %macro printear 2
        mov edx, %1            ;message length
        mov ecx, %2            ;message to write:
        mov ebx,1              ;file descriptor (stdout)
        mov eax,4              ;system call number (sys_write)
        int 0x80               ;call kernell
   %endmacro

   %macro resetResult 2
        mov eax, 0
        mov [%1], eax
        mov [%2], eax
        mov [%2 + 4], eax
        mov [%2 + 8], ax
        mov [%2 + 10], al
   %endmacro

section .bss
    ;Establecer variables para las operaciones y su tamaño en bytes
    input resb 2          ;reservar 2 byte - 16 bits
    var1 resb 5           ; Buffer for user input (max 5 digits)
    var2 resb 5           ; Buffer for user input (max 5 digits)
    result1 resd 1        ; Result of conversion 1(RESD - 4 bytes)
    result2 resd 1        ; Result of conversion 2(RESD - 4 bytes)
    resultValues resd 1   ; Result of var1 ARITHMETIC OPERATION var2 (RESD - 4 bytes)
    resultResiduo resd 1   ; Result of var1 ARITHMETIC OPERATION var2 (RESD - 4 bytes)
    resultPrint resb 11  ; Buffer for result output (max 11 digits + null terminator)

section .text
   global _start                      ;must be declared for linker(ld)
    _start:                           ;tell the linker entry point
        mov edx, len1                 ;message length de welcome
        mov ecx, welcome              ;message to write: welcome
        mov ebx,1                     ;file descriptor (stdout)
        mov eax,4                     ;system call number (sys_write)
        int 0x80                      ;call kernell
    _menu:
        mov ebx,1                     ;file descriptor (stdout)
        mov eax,4                     ;system call number (sys_write)
        mov edx, len2                 ;message length de new Line
        mov ecx, menu                 ;message to write: menu
        int 0x80                      ;call kernell

        mov eax,3                     ;syscall input
        mov edx,16                    ;edx TAMANNO MAXIMO INPUT
        mov ebx,0                     ;file descriptor (stdin)
        lea ecx,[input]               ;load effective address - guarda dir de INPUT
        int 0x80                      ;call kernell

        mov al, [input]
        cmp al,'1'
        je _suma                      ;If input equals '1' jump a suma
        cmp al,'2'
        je _resta                     ;If input equals '2' jump a resta
        cmp al, '3'
        je _multip                    ;If input equals '3' jump a multiplica
        cmp al,'4'
        je _divi                      ;If input equals '4' jump a divide
        cmp al, '5'
        je _fin                       ;If input equals '5' jump a fin
        jmp _menu                     ;If input diferente a todo lo anterior vuelve a preguntar

    ;OPERACIONES
    _suma:
        ATOI ask1, lenask1, var1, result1, 1
        ATOI ask2, lenask2, var2, result2, 2
        ; Convert inputs
        mov eax, [result1]
        add eax, [result2]
        mov [resultValues], eax
        printear lenresult, resultMsg
        ITOA resultValues, resultPrint, 1
        printear lenNew, newLine
        ; Jump to conversions
        jmp _hexadecimal
    ;---------------------------
    _resta: ;OJO: SOLO FUNCIONA PARA NUMEROS GRANDES RESTANDO PEQUENNOS O IGUALES
        ATOI ask1, lenask1, var1, result1, 3
        ATOI ask2, lenask2, var2, result2, 4
        ; Convert inputs
        mov eax, [result1]
        sub eax, [result2]
        mov [resultValues], eax
        printear lenresult, resultMsg
        ITOA resultValues, resultPrint, 2
        printear lenNew, newLine
        ; Jump to conversions
        jmp _hexadecimal
    ;---------------------------
    _multip:
        ATOI ask1, lenask1, var1, result1, 5
        ATOI ask2, lenask2, var2, result2, 6
        ; Convert inputs
        mov eax, [result1]
        mov ecx, [result2]
        mul ecx
        mov [resultValues], eax    ; value is stored in EAX
        printear lenresult, resultMsg
        ITOA resultValues, resultPrint, 3
        printear lenNew, newLine
        ; Jump to conversions
        jmp _hexadecimal
    ;---------------------------
    _divi:
        ATOI ask1, lenask1, var1, result1, 7
        ATOI ask2, lenask2, var2, result2, 8
        ; Convert inputs
        xor edx, edx              ; Clear EDX before division
        mov eax, [result1]        ; Dividend
        mov ebx, [result2]        ; Divisor
        div ebx                   ; EAX = quotient, EDX = remainder
        mov [resultValues], eax   ; Store quotient
        mov [resultResiduo], edx  ; Store remainder

        ; Print results
        printear lencociente, cocienteMsg
        ITOA resultValues, resultPrint, 4
        printear lenNew, newLine

        printear lenResid, ResidMsg
        ITOA resultResiduo, resultPrint, 5
        printear lenNew, newLine

        ; Jump to conversions
        jmp _hexadecimal
    ;---------------------------

    ;CONVERSIONES
    _hexadecimal:

    _binario:

    _octal:

    _goback:
        lea ebx, [resultValues]
        lea ecx, [resultPrint]
        lea edx, [resultResiduo]
        resetResult ebx, ecx
        resetResult edx, ecx

        jmp _menu

    _fin:
        mov eax,1                     ;sytem call number (sys_exit)
        int 0x80                      ;call kernell 
