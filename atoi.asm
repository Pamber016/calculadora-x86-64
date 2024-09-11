section .data
    msg db 'Ingrese un numero: ', 0
    len equ $ - msg
    ten dd 10              ; constant for division

section .bss
    var1 resb 5           ; Buffer for user input (max 5 digits)
    result1 resd 1        ; Result of conversion (4 bytes)
    resultFinal resb 11   ; Buffer for result output (max 10 digits + null terminator)

section .text
    global _start

    _start:
        mov eax, 4             ; sys_write
        mov ebx, 1             ; file descriptor (stdout)
        mov ecx, msg           ; message to write
        mov edx, len           ; message length
        int 0x80               ; call kernel

        ; Read user input
        mov eax, 3             ; sys_read
        mov ebx, 0             ; file descriptor (stdin)
        lea ecx, [var1]        ; buffer to store input
        mov edx, 5             ; number of bytes to read
        int 0x80               ; call kernel

        ; Convert input from ASCII to integer
        mov esi, var1          ; point to input buffer
        xor eax, eax           ; clear EAX (accumulator for result)
        xor ecx, ecx           ; clear ECX (multiplier)

    convert_loop:
        movzx edx, byte [esi]  ; load next byte from buffer
        cmp edx, 0ah           ; check for newline (ASCII 0x0A)
        je done_conversion     ; if newline, end conversion
        sub edx, 30h           ; convert ASCII to integer (0-9)
        imul eax, eax, 10      ; multiply current result by 10
        add eax, edx           ; add new digit
        inc esi                ; move to next byte
        ; SI LLEGA HASTA ACÁ
        jmp convert_loop       ; repeat until newline

        
    done_conversion:
        ; Store result
        mov [result1], eax    ; save result in result1

        ; Convert result to string
        mov eax, [result1]    ; load result
        mov ebx, resultFinal  ; point to output buffer
        add ebx, 10           ; start at end of buffer
        mov byte [ebx], 0     ; null-terminate the string
        dec ebx               ; move to previous byte

    convert_to_ascii:
        xor edx, edx          ; clear EDX (remainder)
        div dword [ten]       ; divide EAX by 10
        add dl, '0'           ; convert remainder to ASCII
        mov [ebx], dl         ; store ASCII character
        dec ebx               ; move to previous byte
        test eax, eax         ; check if EAX is zero

        ;SI llega hasta AQUÍ
        jnz convert_to_ascii  ; if not zero, continue

        ;SI llega hasta AQUÍ
        ; REVISADO Y ARREGLADO - OUTPUT
        mov eax, 4              ; sys_write
        mov ebx, 1              ; file descriptor (stdout)
        lea ecx, [resultFinal]  ; address of the result buffer
        mov edx, 10             ; length of the result string;
        int 0x80                ; call kernel

        ; Exit
        mov eax, 1            ; sys_exit
        xor ebx, ebx          ; status 0
        int 0x80              ; call kernel
        mov eax,1             ;sytem call number (sys_exit)
        int 0x80              ;call kernell 
