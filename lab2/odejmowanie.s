#LAB2 ODEJMOWANIE, STUDENT MATEUSZ ŚLIWKA (214375)

SYSEXIT = 1
EXIT_SUCCESS = 0

.data

liczba1: 
    	.long 0x10304008, 0x701100FF, 0x45100020, 0x08570030 
liczba1_len = (. - liczba1)/4 #zmienna przechowujaca dlugosc liczby1

liczba2:
    	.long 0xF040500C, 0x00220026, 0x321000CB, 0x04520031 
liczba2_len = (. - liczba2)/4 #zmienna przechowujaca dlugosc liczby2

#REALIZUJEMY DZIALANIE LICZBA1-LICZBA2

.text
.global _start
_start:

clc #ustawienie flagi przeniesienia (carry flag) na 0
pushf  #odłożenie na stos zawartości rejestru flag
movl $liczba1_len,%edi  #ustawienie liczniak petli (rejestr indeksowy)
dec %edi #zmniejszenie licznika petli
movl $liczba2_len, %esi #przypisanie dlugosci liczby2 (tej krotszej) do pomocniczego rejestru esi
dec %esi #zmniejszenie pomocniczego rejestru (dekrementuje bo w LE wystepuje indeks 0)

odejmuj:
popf #sciagamy flagi ze stosu
movl liczba1(,%edi, 4), %eax #wpisanie do rejestru eax liczby bedacej na pozycji o indeksie %edi w liczba1
movl liczba2(,%esi, 4), %ebx #wpisanie do rejestru eax liczby bedacej na pozycji o indeksie %edi w liczba2
sbbl %ebx, %eax #odjecie obu rejestrow z uwzglednieniem pozyczki
push %eax #odlozenie wyniku na stos
pushf #odlozenie flag na stos
dec %edi #dekrementacja licznika liczby1
dec %esi #dekrementacja licznika liczby2
cmp $0,%esi #porownanie pierwszego licznika czy moze pobralismy juz cala liczbe
jl odejmuj_od_liczba1 #jezeli przeslimy cala liczba2 to teraz od liczby1 odejmujemy zera
cmp $0,%edi #porownujemy drugi licznij
jl odejmuj_od_liczba2  #jezeli tak to teraz od zero odejmujemy liczba2
jmp odejmuj #jak nie to znaczy ze zadna z liczb sie jeszcze nie skonczyla i odejmujemy je obie od siebie dalej

odejmuj_od_liczba1: #odejmowanie zer od liczby1 bo liczba2 sie juz skonczyla
cmp $0,%edi #sprawdzamy czy czasem juz sie obie liczby nie skonczyly
jl sprawdz_nadmiar #jak tak to idziemy do sprawdzenia nadmiaru
movl liczba1(,%edi, 4), %eax #wpisanie do rejestru kolejnego framgnetu liczba1
popf #sciagam ze stosu flagi
sbbl $0,%eax #odejmujemy od fragmentu liczby1 zero no bo liczba2 juz sie skonczyla (uwzgledniamy pozyczke)
push %eax #wrzucamy wynik na stos
dec %edi #zmniejszam licznik petli
pushf #odkladam na stos flagi
jmp odejmuj_od_liczba1 #wracamy do poczatki funkcji

odejmuj_od_liczba2: #odejmowanie liczby2 od zer bo liczba1 sie skonczyla
cmp $0,%esi #sprawdzamy czy czasem juz sie obie liczby nie skonczyly
jl sprawdz_nadmiar #jak tak to idziemy do sprawdzenia
movl liczba2(,%esi, 4), %eax #wpisanie do rejestru eax wycietej liczby z liczba1 o dlugosci 4 o okrelsonym indeksie
popf #sciagam ze stosu flagi
movl $0, %ebx #wpisujemy zero do ebx, potrzebne do nastepnego odejmowania zeby bylo gdzie przechowac wynik
sbbl %eax,%ebx#odejmujemy z uwzglednieniem pozyczki, wynik trafia do ebx
push %ebx #wkladam wynik dodawania na stos
dec %esi #zmniejszam licznik petli
pushf #odkladam na stos flagi
jmp odejmuj_od_liczba2 #jezeli nie to kontynuujemy odejmowanie liczby2 od zer


sprawdz_nadmiar: #sprawdzanie nadmiaru
popf #sciagamy flagi ze stosu
check_flag:
jc dodaj_nadmiar #skok do dodaj_nadmiar jezeli CF=1
jnc exit #skok do exit jezeli CF=0

dodaj_nadmiar: #zapisywanie nadmiaru na najwyzsza pozycje wyniku
push $0xFFFFFFFF #wrzucamy go na stos

exit: #zakanczanie programu
mov $SYSEXIT, %eax
mov $EXIT_SUCCESS, %ebx
int $0x80
