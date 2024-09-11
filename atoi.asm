section .data
   ;MACROS
   %macro getInputs 1
    ;PEDIRLE AL USUARIO NUMERO
        ;Ingresa primer numero
        mov eax,3                     ;syscall input
        mov edx,40                    ;edx TAMANNO MAXIMO - 5 integers
        mov ebx,0                     ;file descriptor (stdin)
        lea ecx,[%1]                  ;load effective address - guarda dir de variable
        int 0x80                      ;call kernell
        mov [position], ax                   
   %endmacro

section .bss
    ;Establecer variables para las operaciones y su tamaño en bytes
    var1 resb 5                    ;reservar 5 byte - 40 bits
    position resb 2                ;reservar 2 byte - 16 bits (para ax)
    var2 resb 5
    result1 resb 2
    result2 resb 2
    resultFinal resb 2

section .text
    global _start                     ;must be declared for linker(ld)
    _start:
        getInputs var1                  ; ecx esta el input de var1
        mov cx,[position]              ; en ecx se encuentra cantidad de numeros
        sub cx,2                       ; toma en cuenta el ENTER como un byte
        _ATOI:
            mov bl, [var1+ecx]          ; guardar en ebx los primeros 8 bits
            cmp bl, 30h                 ; comparacion con la tabla ASCII 30h = 0
            jl _end                     ; si menor a 0, finaliza
            cmp bl, 39h                 ; comparacion con la tabla ASCII 39h = 9
            jg _end                     ; si mayor a 9, finaliza

            sub bl,30h

            _unidades:
            mov al,10
            mul bl
            mov dx,cx
            sub dx,1
            cmp dx,0
            jg _unidades

            add [result1],ax
            
            sub cx, 1
            mov dx, 0
            cmp cx,dx
            jg _ATOI

        getInputs var2
        mov cx,[position]
        sub cx,2

        _ATOI2:
            mov bl, [var2+ecx]          ; guardar en ebx los primeros 8 bits
            cmp bl, 30h                 ; comparacion con la tabla ASCII 30h = 0
            jl _end                     ; si menor a 0, finaliza
            cmp bl, 39h                 ; comparacion con la tabla ASCII 39h = 9
            jg _end                     ; si mayor a 9, finaliza

            sub bl,30h

            _unidades2:
            mov al,10
            mul bl
            mov dx,cx
            sub dx,1
            cmp dx,0
            jg _unidades2

            add [result2],ax

            LOOP _ATOI2

        mov bx, [result1]
        add [resultFinal],bx
        mov bx, [result2]
        add [resultFinal],bx

        mov edx, 2                 
        mov ecx, [resultFinal]        
        mov ebx,1                     
        mov eax,4                     ;system call number (sys_write)
        int 0x80                      ;call kernell

    _end:
        mov eax,1                     ;sytem call number (sys_exit)
        int 0x80                      ;call kernell 
        
