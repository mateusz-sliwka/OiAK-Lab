SYSEXIT = 1
EXIT_SUCCESS = 0

.data
liczba1_d: .double 5.513341
liczba2_d: .double -1.21221

liczba1_f: .float 5.513341
liczba2_f: .float -1.21221

zero: .float 0.00

#wartosci definicji zakraglen, precyzji i bazy ustalone zostaly wedlug budowy slowa 
#kontrolnego, co zostalo pokazane w sprawozdaniu

#zaokraglenie
najblizsze: .short 0x000 #zaokragalnie do najblizszej, binarnie to 00000000 00000000
wdol: .short 0x400 #zaokraglanie do minus niesko, binarnie to      00000100 00000000
wgory: .short 0x800 #zaokraglanie do plus niesko  binarnie to      00001000 00000000
obciecie: .short 0xc00 #zaokraglanie przez obciecie, binarnie to   00001100 00000000

#precyzja 
pojedyncze: .short 0x000 #binarnie to       00000000 00000000
podwojna: .short 0x200 #binarnie to  	    00000010 00000000

#baza
slowo_sterujace: .short 0x103F #binarnie to 00010000 00111111

.text
.global _start
_start:
			
mov najblizsze, %eax #do eax wpisujemy tryb zaokraglania, w tym przypadku w dol
mov podwojna, %ebx #do ebx wpisujemy rodzaj precyzji na jakim operujmy
mov slowo_sterujace, %ecx #wpisanie slowa sterujacego do ecx
add %eax, %ebx #dodanie do siebei rejestrow eax i ebx (zaokraglenie i precyzja), wynik w ebx
add %ebx, %ecx #dodanie do siebie rejestrow ebx i ecx (wyniku tego wyzej i slowa sterujacego), wynik w ecx
mov %ecx, slowo_sterujace #zapisanie ecx (nowego slowa sterujacego) jako slowo sterujace
fldcw slowo_sterujace #zaladowanie slowa sterujacego FPU

#WYBOR LICZB NA JAKICH DZIALAMY LUB TYLKO SYMULACJI WYJATKOW
#jmp zaladuj_float #PROGRAM REALIZUJE DZIALANIA DLA POJEDYNCZEJ PRECYZJI
jmp zaladuj_double #PROGRAM REALIZUJE DZIALANIA DLA PODWOJNEJ PRECYZJI
#jmp wyjatki #PROGRAM REALIZUJE SYMULACJE WYJATKOW

#WYBOR DZIALANIA DO ZREALZIOWANIA
dzialanie:
jmp odejmowanie #w tym przypadku realizujemy dzielenie

		
zaladuj_double: #funkcja ladujaca do st1 i st0 liczby typu double
fldl liczba2_d
fldl liczba1_d
jmp dzialanie #przejscie do wczesniej wybranego dzialania 

zaladuj_float: #funkcja ladujaca do st1 i st0 liczby typu float
flds liczba2_f
flds liczba1_f
jmp dzialanie #przejscie do wczesniej wybranego dzialania
 

dodawanie: #liczba1+liczba2
faddp  #dodanie do siebei dwoch liczb tzn liczba2 z liczba 1 w st0, wynik do st0
jmp exit

odejmowanie: #liczba1-liczba2
fsubp #odjecie od siebie dwoch liczb tzn liczby2 z liczba1 w st0, wynik do st0
jmp exit

mnozenie: #liczba1*liczba2
fmulp #mnozenie liczby2 razy liczba1 w st0, wynik w st0
jmp exit

dzielenie: #liczba1/liczba2
fdivp  #dzielenie liczby1 w st0 przez liczbe2, wynik w st0
jmp exit


wyjatki:

NotANumber:
fldz #NaN 0/0 = NaN
fdiv zero
nop #wynik 0/0 = nan

plus0_przez_liczbe:		
fldz # +0 0/liczba1 = +0
fdiv liczba1_f
nop #wynik 0/x = 0

minus0_przez_liczbe:
fldz # -0 0/liczba2 = -0
fdiv liczba2_f
nop #wynik 0/-x = -0

liczbaujemna_przez_zero:		
flds liczba2_f  # -inf liczba2/0 = -inf
fdiv zero
nop #wynik -x/0 = -inf

liczbadodatnia_przez_zero:	
flds liczba1_f # +inf liczba1/0 = +inf
fdiv zero
nop #wynik x/0 = inf


exit:
mov $SYSEXIT, %eax
mov $EXIT_SUCCESS, %ebx
int $0x80
