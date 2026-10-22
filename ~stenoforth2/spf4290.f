\ stenoforth32

0 WARNING !

REQUIRE CASE         lib\ext\case.f                      \ конструкция выбора по целому
REQUIRE {            lib\ext\locals.f                    \ локальные переменные SPF
REQUIRE NUMBER?      ~mak\lib\fpcnum.f                   \ преобразование строк в числа
REQUIRE LIKE         ~pinka\lib\like.f                   \ выделение по маске
REQUIRE $!           ~mak\place.f                        \ утилиты для многопроходной компиляции
REQUIRE CHOOSE       lib\ext\rnd.f                       \ случайный выбор
REQUIRE STACK        ~stenoforth2-1\lib\cstack.f         \ стеки CS( используется для Ассма и для общего применения) и L(для общего) в памяти
REQUIRE M:           ~stenoforth2-1\lib\nf-name.f        \ макросы, слова-строки
REQUIRE 0SQRT        ~stenoforth2-1\assm\mp-assm.f       \ встроенный постфиксный ассемблер( с зачатками плав.точки)
REQUIRE IDN          ~stenoforth2-1\assm\sp-assm.f       \ встроенный трехпроходный ассемблер с метками и коротким синтаксисом для инструкций
REQUIRE F.           lib\include\float2.f                \ вещественные числа
REQUIRE instructions ~stenoforth2-1\lib\instructions.f   \ часто используемые инструкции процессора, параметризуемые со стека данных
REQUIRE sd.          ~stenoforth2-1\lib\nloc25.f         \ статические локальные: переменные, слова, макросы, строки и модификаторы
REQUIRE 1-!          ~stenoforth2-1\lib\man-ip.f         \ расширения базового словаря FORTH
REQUIRE pusto        ~stenoforth2-1\lib\staxy4.f         \ прямое задание манипуляций параметрами на стеке параметров - "стексы"
REQUIRE sseet        ~stenoforth2-1\lib\seetl.f          \ измеритель времени исполнения слова при разовом и циклическом его исполнении
REQUIRE fpoint       ~stenoforth2-1\lib\w-flo.f          \ модуль для слов плав.точки
REQUIRE recgen       ~stenoforth2-1\lib\recgen.f         \ расширение для формирования групп литеральных слов
REQUIRE valuenames   ~stenoforth2-1\lib\c-fix.f          \ модуль синонимов для сжатия слов для работы с фикс.точкой - разряднось 32
REQUIRE mfvaluenames ~stenoforth2-1\lib\c-flo.f          \ модуль синонимов для сжатия слов для работы с плав.точкой
REQUIRE dsynonyms    ~stenoforth2-1\lib\c-fixd.f         \ модуль синонимов для сжатия слов для работы с фикс.точкой - разрядность 64
REQUIRE 2VARIABLE    lib\include\double.f                \ переменные двойной разрядности
REQUIRE SYNONYM      ~stenoforth2-1\lib\synonym.f        \ создание синонимов имен слов
REQUIRE immediate    ~stenoforth2-1\lib\w-fix.f          \ перевод имен из верхнего регистра в нижний для слов с фикс. точкой - разряднось 32
REQUIRE f.           ~stenoforth2-1\lib\r-flo.f          \ перевод имен из верхнего регистра в нижний для слов с плав. точкой
REQUIRE SEE          ~stenoforth2-1\lib\disasm.f         \ доработанный SEE(дает размер кода и число инструкций)
REQUIRE syndop       ~stenoforth2-1\lib\dopsyn.f         \ доп. синонимы
REQUIRE t>T          ~stenoforth2-1\lib\dopassm.f        \ сохранение регистров в памяти и восстановление их из памяти
REQUIRE |a           ~stenoforth2-1\lib\short-asm.f      \ часто используемые инструкции процессора, параметризуемые со стека данных и из их имён
REQUIRE VARIANTS     ~stenoforth2-1\lib\gps.f            \ генератор перестановок символов в строках
REQUIRE in           ~stenoforth2-1\lib\stat-loc.f       \ статичские локальные переменные в общем пространстве кода, многопоточные
REQUIRE valuen       ~stenoforth2-1\lib\cfixo.f          \ сжатая форма стат. лок. переменные в общем пространстве кода
REQUIRE skip-next    ~stenoforth2-1\lib\dop-words.f      \ анти-комментарии



S" f:\spf429\devel\~stenoforth2-1\bin\spf486.exe" SAVE

BYE

\EOF

Порядок получения расширенной форт-системы spf-4.29(spf486.exe):

1. Пусть исходная форт-система расположена в папке f:\spf429(вместо f: д.б. быть указан ваш диск).
   После скачивания файлов из репозитория(github) нужно поменять формат строк во всех файлах на Dos/Windows(0Dh,0Ah).
   Если есть желание использовать кириллицу в именах слов и текстовых литералах(лексемах) в ваших программах,
   то можно поменять кодировку всех текстовых файлов на cp866 для корректного отображения кириллицы в консоли.

2. Скопировать скачанную из репозитория GIT папку ~stenoforth2-1, в каталог \spf429\devel\
   файл disasm.f из spf429\lib\ext\ заменить файлом disasm.f, из скачанного репозитория.

3. Исполнить файл compile.bat из папки \spf429\src

4. Увеличить размер образа форт-системы, исполнив из ком. строки команду:
   spf4.exe  IMAGE-SIZE 64 * 1024 * TO IMAGE-SIZE S" spf4p.exe" SAVE BYE

5. Оттранслировать этот файл(Spf4290.f) c помощью spf4p.exe из папки \spf429


   
