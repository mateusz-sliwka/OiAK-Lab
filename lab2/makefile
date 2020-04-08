all: odejmowanie dodawanie mnozenie
	
odejmowanie: odejmowanie.o
	ld -m elf_i386 -o odejmowanie odejmowanie.o

odejmowanie.o: odejmowanie.s
	as -g --32 -o odejmowanie.o odejmowanie.s

dodawanie: dodawanie.o
	ld -m elf_i386 -o dodawanie dodawanie.o

dodawanie.o: dodawanie.s
	as -g --32 -o dodawanie.o dodawanie.s

mnozenie: mnozenie.o
	ld -m elf_i386 -o mmnozenie mnozenie.o

mnozenie.o: mnozenie.s
	as -g --32 -o mnozenie.o mnozenie.s