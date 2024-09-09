all: tarea1

calculadora.o:  calculadora.asm
		nasm -f elf64 calculadora.asm

tarea1:   calculadora.o
		ld -s -o tarea1 calculadora.o