0 WARNING !
REQUIRE STACK        ~stenoforth2\lib\cstack.f       \ стеки в памяти
REQUIRE CASE         lib\ext\case.f                 \ конструкция CASE
\ REQUIRE {            ~af\lib\locals.f
\ REQUIRE {            ~mak\locals4.f                 \ локальные переменные
REQUIRE {            lib\ext\locals.f               \ локальные переменные
REQUIRE NUMBER?      ~mak\lib\fpcnum.f              \ преобразование строк в числа
REQUIRE LIKE         ~pinka\lib\like.f              \ выделение по маске

REQUIRE M:           ~stenoforth2\lib\nf-name.f      \ макросы, слова-строки
REQUIRE $!           ~mak\place.f                   \ утилиты для многопроходной компиляции

REQUIRE 0SQRT        ~stenoforth2\assm\mp-assm.f     \ встроенный постфиксный ассемблер( с зачатками плав.точки)
REQUIRE IDN          ~stenoforth2\assm\sp-assm.f     \ встроенный трехпроходный ассемблер с метками и коротким синтаксисом для инструкций

REQUIRE CHOOSE       lib\ext\rnd.f                  \ случайный выбор
REQUIRE randomize    ~stenoforth2\lib\nrand.f        \ модифицированный для повышения быстродействия случайный выбор
REQUIRE F.           lib\include\float2.f           \ вещественные числа
REQUIRE instructions ~stenoforth2\lib\instructions.f
REQUIRE sd.          ~stenoforth2\lib\nloc25.f       \ статические локальные переменные, слова, макросы, строки
REQUIRE 1-!          ~stenoforth2\lib\man-ip.f       \ расширение

REQUIRE pusto        ~stenoforth2\lib\staxy4.f       \ прямое задание манипуляций параметрами на стеке параметров
REQUIRE sseet        ~stenoforth2\lib\seetl.f        \ измеритель времени исполнения слова при разовом и циклическом его исполнении

REQUIRE fpoint       ~stenoforth2\lib\w-flo.f        \ модуль для слов плав.точки
\ REQUIRE instructions ~stenoforth2\lib\instructions.f \ модуль слов-инструкций процессора x86
REQUIRE closure      ~stenoforth2\lib\closure.f      \ расширение для замыканий и для формирования литеральных слов

REQUIRE valuenames   ~stenoforth2\lib\c-fix.f        \ модуль синонимов для сжатия слов для работы с фикс.точкой - разряднось 32
REQUIRE mfvaluenames ~stenoforth2\lib\c-flo.f        \ модуль синонимов для сжатия слов для работы с плав.точкой
REQUIRE dsynonyms    ~stenoforth2\lib\c-fixd.f       \ модуль синонимов для сжатия слов для работы с фикс.точкой - разрядность 64

REQUIRE SYNONYM      ~stenoforth2\lib\synonym.f

REQUIRE 2VARIABLE    lib\include\double.f
REQUIRE immediate    ~stenoforth2\lib\w-fix.f
REQUIRE f.           ~stenoforth2\lib\r-flo.f
REQUIRE [type]       ~stenoforth2\math\matr.f        \ операции над матрицами с числами с фикс. точкой
REQUIRE SEE          ~stenoforth2\lib\disasm.f       \ доработанный SEE(дает размер кода и число инструкций)
REQUIRE s-inv        ~stenoforth2\lib\string.f

S" f:\spf429\devel\~stenoforth2\bin\spf486.exe" SAVE

BYE

\EOF

Порядок получения расширенной форт-системы spf-4.29(spf486.exe):

1. Пусть исходная форт-система расположена в папке f:\spf429(вместо f: д.б. быть указан ваш диск).
   После скачивания файлов из репозитория(github) нужно поменять формат строк во всех файлах на Dos/Windows(0Dh,0Ah).
   Если есть желание использовать кириллицу в именах слов и текстовых литералах(лексемах) в ваших программах,
   то можно поменять кодировку всех текстовых файлов на cp866 для корректного отображения кириллицы в консоли.

2. Скопировать скачанную из репозитория GIT папку ~stenoforth, в каталог \spf429\devel\
   файл disasm.f из spf429\lib\ext\ заменить файлом disasm.f, из скачанного репозитория.

3. Исполнить файл compile.bat из папки \spf429\src

4. Увеличить размер образа форт-системы, исполнив из ком. строки команду:
   spf4.exe  IMAGE-SIZE 64 * TO IMAGE-SIZE S" spf4p.exe" SAVE BYE

5. Оттранслировать этот файл(Spf4290.f) c помощью spf4p.exe из папки \spf429


   
