# AC

README Untea Robert-Marius, 333AC
Descriere Generala
Modulul process este un modul Verilog destinat procesarii imaginilor. Acest
modul implementeaza diverse operatii de procesare a imaginilor precum oglindirea,
conversia la grayscale și aplicarea unui filtru de sharpness. Operatiile sunt
executate intr-un mediu sincron, controlat de un semnal de ceas (clk).
Intrari si Iesiri
Intrari:
clk: Semnal de ceas pentru sincronizarea operatiilor.
in_pix [23:0]: Valoarea pixelului de intrare, formata din trei componente de
culoare (Rosu, Verde, Albastru).
Iesiri:
row [5:0], col [5:0]: Selecteaza un rand si o coloana specifica din imagine.
out_we: Semnal care activeaza scrierea în memoria imaginii de iesire.
out_pix [23:0]: Valoarea pixelului de iesire.
mirror_done, gray_done, filter_done: Semnale care indica finalizarea diferitelor
etape de procesare (oglindire, grayscale, filtru sharpness).
Functionalitati
Modulul process este structurat intr-o masina de stari finită (FSM) pentru a
gestiona diferitele operatii de procesare a imaginii.
Procesele implementate sunt:
Oglindirea Imaginii:
Imaginea este procesata pentru a fi oglindita pe axa orizontala.
Starile FSM controleaza citirea, procesarea si scrierea pixelilor oglinditi.
Conversia la Grayscale:
Pixelii sunt convertiti din formatul RGB la grayscale.
Procesul implica calculul unei medii intre valorile maxime si minime ale componentelor
de culoare ale fiecarui pixel.
Aplicarea Filtrului de Sharpness:
Aceasta sectiune este rezervata pentru implementarea unui filtru de sharpness,
cu logica specifica de adaugat.
Observatii
Modulul este proiectat pentru a functiona intr-un mediu sincron, cu operatiile
declansate de fronturile pozitive ale semnalului de ceas.
La finalizarea fiecarei etape de procesare, un semnal specific (mirror_done,
gray_done, filter_done) este activat pentru a indica terminarea acelei etape.
