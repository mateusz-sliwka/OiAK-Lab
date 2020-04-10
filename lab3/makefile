all: fpu
	
fpu: fpu.o
	ld -m elf_i386 -o fpu fpu.o

fpu.o: fpu.s
	as -g --32 -o fpu.o fpu.s

