#LAB2 DODAWANIE, STUDENT MATEUSZ ŚLIWKA (214375)

SYSEXIT = 1
EXIT_SUCCESS = 0

.data

liczba1: 
    	.long 0x10304008, 0x701100FF, 0x45100020, 0x08570030 
liczba1_len = (. - liczba1)/4 #zmienna przechowujaca dlugosc liczby1

liczba2:
    	.long 0xF040500C, 0x00220026, 0x321000CB, 0x04520031 
liczba2_len = (. - liczba2)/4 #zmienna przechowujaca dlugosc liczby2


.text
.global _start
_start:

clc #ustawienie flagi przeniesienia (carry flag) na 0
pushf  #odłożenie na stos zawartości rejestru flag
movl $liczba1_len,%edi  #ustawienie liczniak petli (rejestr indeksowy)
dec %edi #zmniejszenie licznika petli
movl $liczba2_len, %esi #przypisanie dlugosci liczby2 (tej krotszej) do pomocniczego rejestru esi
dec %esi #zmniejszenie pomocniczego rejestru (dekrementuje bo w LE wystepuje indeks 0)

dodawaj:
popf #sciagamy flagi ze stosu
movl liczba1(,%edi, 4), %eax #wpisanie do rejestru eax liczby bedacej na pozycji o indeksie %edi w liczba1
movl liczba2(,%esi, 4), %ebx #wpisanie do rejestru eax liczby bedacej na pozycji o indeksie %edi w liczba2
adcl %ebx, %eax #dodanie obu rejestrow z uwzglednieniem przeniesienie
push %eax #odlozenie wyniku na stos
pushf #odlozenie flag na stos
dec %edi #dekrementacja licznika liczby1
dec %esi #dekrementacja licznika liczby2
cmp $0,%esi #porownanie licznika liczba2 zeby nie wyjsc poza jej zakres
jl dodawaj_do_liczba1 #jezeli jest 0 to znaczy ze liczba2 sie skonczyla i do liczba1 bedziemt dodawac 0
cmp $0,%edi #jesli nie to sprawdzam czy liczba1 sie nie skonczyla
jl dodawaj_do_liczba2  #jak tak to do licba2 bede dodawal zera
jmp dodawaj #jak nie to znaczy ze dodaje fragmenty obu liczb dalej

dodawaj_do_liczba1:
cmp $0,%edi #sprawdzam czy czasem obie licby sie nie skonczyly
jl sprawdz_nadmiar #jak tak to przechodze do finalnego sprawdzenia nadmiaru
movl liczba1(,%edi, 4), %eax #wpisanie do rejestru eax wycietej liczby z liczba1 o dlugosci 4 o okrelsonym indeksie
popf #sciagam ze stosu flagi
adcl $0,%eax #dodaje zero do eax z uwzglednieniem przeniesienia
push %eax #wkladam wynik dodawania na stos
dec %edi #zmniejszam licznik petli
pushf #odkladam na stos flagi
jmp dodawaj_do_liczba1 #jezeli nie to kontynuujemy dodawanie zera do liczby dluzszej

dodawaj_do_liczba2:
cmp $0,%esi #sprawdzam czy o obie liczby sie nie skonczyly
jl sprawdz_nadmiar #jesli tak to przechodze do finalnwego sprawdzenia nadmiaru
movl liczba2(,%esi, 4), %eax #wpisanie do rejestru eax wycietej liczby z liczba1 o dlugosci 4 o okrelsonym indeksie
popf #sciagam ze stosu flagi
adcl $0,%eax #dodaje z przeniesieniem zero do eax
push %eax #wkladam wynik dodawania na stos
dec %esi #zmniejszam licznik petli
pushf #odkladam na stos flagi
jmp dodawaj_do_liczba2 #jezeli nie to kontynuujemy dodawanie zera do liczby dluzszej


sprawdz_nadmiar: #sprawdzanie nadmiaru
popf #sciagamy flagi ze stosu
jc dodaj_nadmiar #skok do dodaj_nadmiar jezeli CF=1
jnc exit #skok do exit jezeli CF=0

dodaj_nadmiar: #zapisyoswanie nadmiaru na najwyzsza pozycje wyniku
push $0x1 #wrzucamy go na stos

exit: #zakanczanie programu
mov $SYSEXIT, %eax
mov $EXIT_SUCCESS, %ebx
int $0x80
