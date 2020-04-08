#LAB2 MNOZENIE, STUDENT MATEUSZ ŚLIWKA (214375)

SYSEXIT = 1
EXIT_SUCCESS = 0

.data
#relaizujemy zadanie liczba2*liczba1
liczba1:
    	.long 0x10304008, 0x701100FF, 0x45100020, 0x08570030
liczba1_len = (. - liczba1)/4 #zmienna przechowujaca dlugosc liczby1


liczba2:
    	.long 0xF040500C, 0x00220026, 0x321000CB, 0x04520031
liczba2_len = (. - liczba2)/4 #zmienna przechowujaca dlugosc liczby2


wynik:
	.space 64,0 #

.text
.global _start

_start:
clc #czyszczenie flag
pushf #odlozenie czystych flag na stos
push $liczba1_len #odlozenie na stos dlugosci liczby1
push $0 #odlozenie na stos 0, za chwile zdjemiemy je do edi 

duza_petla:
pop %edi #zdjecie ze stosu wartosci licznika (bedzie to index pozycji w wyniku) do rejestru edi
inc %edi #zwiekszenie licznika 
pop %esi #sciagam esi ze stosu (bedzie licznikiem petli duza_petla)
cmp $0,%esi #sprawdzam czy esi jest juz zerem
jz exit #jak jest to koncze
dec %esi #jak nie to zmniejszam licznik o 1
movl liczba1(,%esi, 4), %eax #wpisuje do eaxa aktualny fragment liczby1 wedlug licznika esi
push %esi #odkladam licznika na stos
push %edi #odkladam edi na stos
mov $liczba2_len, %esi #wpisuje do rejestru esi dlugosc liczby drugiej (bedzie to licznik malej petli)
 
mala_petla: #mala to nazwa robocza, chodzi o to ze jest w duzej tj. zagniezdzona
push %eax #odkladam na stois %eax (aktualny fragment liczba1)
dec %esi #zmniejszam esi o 1
dec %edi #zmniejszam edi o 1, wynik najpierw wpisuje na mlodsza czesc aktualnej pozycji w wyniku
movl liczba2(,%esi, 4), %ebx  #wycinam fragment liczby2 i wkladam do ebx
mull %ebx #mnoze ebx z eax, wynik zapisuje sie w eax i w edx
addl %eax,wynik(,%edi,4) #dodaje eax do wyniku na najnizsza pozycje
inc %edi #inkrementuje edi
jc dodaj_nadmiar1 #jezeli jest nadmiar to przechodze do funkcji ktora go doda na pozycje kolejna
wroc1: #callback dla funkcji dodajacej nadmiar
addl %edx,wynik(,%edi,4) #dodaje do kolejnej pozycji druga porcje iloczynu 
inc %edi #inkrementuje edi
jc dodaj_nadmiar2 #sprawdzam czy wystapil nadmiar
wroc2: #callback dla funkcji dodajacej nadmiar
pop %eax #sciagam eax ze stosu
cmp $0,%esi #porownuje licznik malej petli czy sie skonczyl
jz duza_petla #jezeli tak to wraca do duzej petli
jmp mala_petla #jezeli nie to wciaz iteruje po liczbie2 w malej petli


dodaj_nadmiar1:
adcl $0,wynik(,%edi,4) #dodaje nadmiar tzn 0 z uwzglednieniem przeniesienia na kolejna pozycje wyniku
clc #czyszcze flagi
jmp wroc1 #wracam do malej petli

dodaj_nadmiar2:
adcl $0,wynik(,%edi,4) #dodaje nadmiar tzn 0 z uwzglednieniem przeniesienia na kolejna pozycje wyniku
clc #czyszce flagi
jmp wroc2 #wracam do malej petli


exit: #zakanczanie programu
mov $SYSEXIT, %eax
mov $EXIT_SUCCESS, %ebx
int $0x80
