# ARKO_projekt_x86

Rzut kuli z aproksymacją tarcia(T = K * v^2), interaktywna zmiana parametru K, kąta i szybkości wyrzutu. 

Zadaniem studenta jest określić jakie parametry dla algorytmu mogą być zmieniane przez użytkownika. 

Wszystkie napisane projekty muszą działać w sposób interaktywny – z wykorzystaniem klawiatury lub myszki. Użycie klawiatury lub myszki przez użytkownika ma powodować odświeżenie obrazu generowanego przez algorytm (obraz ma być odświeżany w ramach raz uruchomionego programu). 

Obsługa interfejsu użytkownika ma być napisana w C/C++, jedna funkcja assemblerowa ma rysować pełny wynik działania algorytmu na buforze przekazanym z poziomu funkcji main (gdzie został wcześniej utworzony). Funkcja assemblerowa przyjmuje jako argumenty parametry dla jakich algorytm jest wywoływany.  

Pozostałe wymagania są umieszczone na stronie laboratorium (home.elka.pw.edu.pl/~sniespod).  

Wskazówki do pisania projektów:
Projekt polega na napisaniu hybrydowego programu w języku C i Assemblerze x86. Część assemblerowa powinna być JEDNĄ funkcją, wołaną z poziomu języka C. Powinna ona realizować główną funkcjonalność algorytmu.
Program powinien być interaktywny - powinien zapewniać możliwość zmian parametrów w trakcie działania przy pomocy klawiatury i/lub myszki.
Obsługa interakcji z używtkowniekiem oraz wyświetlanie wyników powinno być zrealizowane na poziomie języka C (z wykorzystaniem biblioteki graficznej np. Allegro, OpenGL).
Część assemblerowa powinna być napisana z wykorzystaniem arytmetyki zmiennopozycyjnej(float).
Prototyp funkcji napisanej w assemblerze:
void function(unsigned char *pPixelBuffer, int width, int height, /* inne parametry specyficzne dla danego algorytmu */);
Funkcja przyjmuje wskaźniek na bufor na którym później bedzie rysować. Bufor ten jest zaalokowany na poziomie języka C. Po potrocie z funkcji program na poziomie języka C powinien wyświetlić wynik działania. Każda zmiana parametru przez użytkownika powinna być wykryta na poziomie języka C i powinna zainicjować kolejne wywołanie funkcji assemblerowej.