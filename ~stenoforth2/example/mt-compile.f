\ =====================================================================
\ mt-compile.f - многопоточная компиляция в SP-Forth (stenoforth2-1)
\
\ Задача. Несколько потоков одновременно компилируют слова. Обычный словарь
\ у потоков общий: компилятор пишет по указателю DP, и потоки затирают код
\ и заголовки друг друга, а список словарей (VOC-LIST) и последнее слово
\ (LATEST) остаются в единственном экземпляре.
\
\ Решение, взятое из ~pinka/spf/storage.f (ruvim, 2006): не подменять
\ словарь временным списком слов через TEMP-WORDLIST, а дать каждому
\ потоку собственное ХРАНИЛИЩЕ - независимую область кода и данных со своим
\ DP, своим списком слов VOC-LIST и своим текущим словарём CURRENT.
\ Словарь, созданный в одном хранилище, не виден из другого и не может
\ быть затёрт соседним потоком: потоки пишут в разные области памяти.
\
\ Что делает этот файл:
\   1) главный поток заранее создаёт по хранилищу на каждый поток;
\   2) поток монтирует СВОЁ хранилище, берёт его словарь (DEFAULT-WORDLIST),
\      делает его текущим и первым в порядке поиска;
\   3) компилирует в нём слово с тем же именем MTC-THWORD, что и остальные
\      потоки, но со своим телом (значение берётся из своей переменной
\      MTC-SEED), вызывает его и складывает результат и xt в свою ячейку;
\   4) главный поток дожидается всех и проверяет: значения разные, xt разные,
\      MTC-THWORD в базовом словаре нет.
\
\ Найденные ограничения (проверено на spf486.exe):
\   - NEW-STORAGE нельзя вызывать в задаче: FORMAT сам монтирует хранилище и
\     оставляет его помеченным занятым, повторный MOUNT падает с #-2012.
\     Поэтому хранилища создаёт главный поток;
\   - монтировать базовое хранилище в задаче нельзя: оно занято главным
\     потоком (storage.f: "устанавливаемое хранилище должно быть свободно").
\     Поток работает только в своём хранилище и не размонтирует его;
\   - локальные из { ... } у каждого потока свои (счётчики - USER-переменные,
\     память - на стеке возврата): две задачи с одинаковой локальной дают
\     p1=1 p2=2, работают и три уровня вложенности;
\   - с storage.f они уживаются, если образ собран в порядке
\     storage.f -> locals.f -> thread-dp.f (так теперь в spf4290.f):
\     thread-dp.f при определённом STORAGE-ID не патчит DP, иначе HERE
\     и (MOUNT) расходятся и падает создание записи локальных
\     (C0000005 в ParseLocals1 -> created -> SHEADER1 -> ",");
\   - на образе, собранном иначе (например в старом bin\spf486.exe),
\     { ... } с хранилищем работать не будет - там нужны локальные с
\     суффиксом "_";
\   - EVALUATE в задаче работает, собственный входной буфер потоку не нужен;
\   - слова управления (DO..LOOP, IF..THEN, BEGIN..WHILE) в режиме
\     интерпретации дают #-312: в демонстрационной части они вынесены в слова.
\
\ Требование к телам потоков: они должны быть реентерабельны (свой стек,
\ свои локальные, результат в отдельной ячейке + флаг) - поток перезапускаем.
\
\ Запуск:  spf486.exe example\mt-compile.f
\ Пути в REQUIRE ниже - абсолютные; при переносе проекта поправьте корень.
\ =====================================================================

REQUIRE Included      F:\spf429\devel\~pinka\lib\ext\requ.f
REQUIRE REPLACE-WORD  F:\spf429\lib\ext\patch.f
REQUIRE NDROP         F:\spf429\devel\~pinka\lib\ext\common.f
REQUIRE BIND-NODE     F:\spf429\devel\~pinka\samples\2006\lib\plain-list.f
REQUIRE VOCS          F:\spf429\devel\~pinka\spf\vocs.f
REQUIRE STORAGE-ID    F:\spf429\devel\~pinka\spf\storage.f

\ Свой указатель словаря у каждого потока (DP-TAB/DP-VAL по THREAD-ID).
\ В образе spf486.exe модуль уже загружен; строка ниже нужна для сборок без него.
[DEFINED] DICT@ 0= [IF]
  REQUIRE (DP-T) F:\spf429\devel\~stenoforth2-1\lib\thread-dp.f
[THEN]

4 CONSTANT MTC-TASKS            \ сколько потоков компилируют одновременно
16 1024 * 1024 * CONSTANT MTC-SIZE \ 16 МБ кода на поток

CREATE MTC-HANDLE MTC-TASKS CELLS ALLOT   \ хранилище потока
CREATE MTC-WID    MTC-TASKS CELLS ALLOT   \ его словарь
CREATE MTC-RES    MTC-TASKS CELLS ALLOT   \ результат вызова слова
CREATE MTC-XT     MTC-TASKS CELLS ALLOT   \ xt скомпилированного слова
CREATE MTC-DONE   MTC-TASKS CELLS ALLOT   \ флаг завершения
VARIABLE MTC-GO                           \ 0 - потоки ждут, 1 - компилируют

\ ячейка таблицы по индексу: ( i addr -- addr+i*cell )
: MTC-CELL ( i a -- addr ) SWAP CELLS + ;

\ вернуться в базовое хранилище системы
: MTC-BASE ( -- )
  FORTH-STORAGE MOUNT
  FORTH-WORDLIST SET-CURRENT ;

\ дочерний поток начинает с пустым контекстом: хранилище и словарь
\ у него не установлены, поэтому сначала задаём базовые явно
: MTC-CONTEXT ( -- )
  MTC-BASE
  FORTH-WORDLIST 1 SET-ORDER ;

\ хранилища создаются заранее в главном потоке: NEW-STORAGE внутри задачи
\ оставляет хранилище помеченным занятым (FORMAT монтирует его сам), и
\ повторное MOUNT в потоке падает с #-2012
: MTC-STORES ( -- )
  MTC-TASKS 0 DO
    MTC-SIZE NEW-STORAGE  I MTC-HANDLE MTC-CELL !
  LOOP ;

\ i-й поток: смонтировать своё (свободное) хранилище, сделать свой словарь
\ текущим и первым в порядке поиска
: MTC-ENTER { i | w }
  i MTC-HANDLE MTC-CELL @ MOUNT
  DEFAULT-WORDLIST TO w
  w i MTC-WID MTC-CELL !
  w SET-CURRENT
  GET-ORDER w SWAP 1+ SET-ORDER ;

\ выйти из своего хранилища в базовое и убрать свой словарь из порядка поиска
: MTC-UNENTER ( -- )
  MTC-BASE
  PREVIOUS ;

\ компиляция в хранилище с индексом i: войти, скомпилировать, вызвать
: MTC-COMPILE { i }
  i MTC-ENTER                             \ вошли в своё хранилище
\ имена MTC-SEED и MTC-THWORD существуют только внутри хранилища потока,
\ поэтому обращение к ним идёт текстом через EVALUATE, а не компилятором:
\ значение индекса уже лежит на стеке и уходит в MTC-SEED
  i 10 * 7 +
  S" VARIABLE MTC-SEED : MTC-THWORD MTC-SEED @ 1+ ; MTC-SEED ! MTC-THWORD ' MTC-THWORD" EVALUATE
  i MTC-XT MTC-CELL !                     \ xt пригодится главному потоку
  i MTC-RES MTC-CELL ! ;                  \ вызов своего слова уже выполнен

\ тело потока: индекс потока на стеке
\ ВАЖНО: базовое хранилище занято главным потоком, монтировать его в задаче
\ нельзя (storage.f: "устанавливаемое хранилище должно быть свободно"),
\ поэтому поток работает только в своём хранилище и не размонтирует его сам.
: MTC-BODY { i }
  BEGIN MTC-GO @ UNTIL                    \ ждём общего старта
  i MTC-COMPILE
  1 i MTC-DONE MTC-CELL !                 \ отметка о завершении
  TERMINATE ;

\ тот же сценарий, но в одном потоке - по очереди по всем хранилищам
: MTC-SEQ ( -- )
  MTC-STORES
  MTC-TASKS 0 DO I MTC-COMPILE MTC-UNENTER LOOP ;

: MTC-W0 0 MTC-BODY ;
: MTC-W1 1 MTC-BODY ;
: MTC-W2 2 MTC-BODY ;
: MTC-W3 3 MTC-BODY ;

' MTC-W0 TASK: MTC-T0
' MTC-W1 TASK: MTC-T1
' MTC-W2 TASK: MTC-T2
' MTC-W3 TASK: MTC-T3

: MTC-ALL-DONE? ( -- fl )
  TRUE MTC-TASKS 0 DO
    I MTC-DONE MTC-CELL @ 0= IF DROP FALSE LEAVE THEN
  LOOP ;

: MTC-WAIT ( -- )
  BEGIN MTC-ALL-DONE? 0= WHILE 1 PAUSE REPEAT ;

: MTC-RUN ( -- )
  0 MTC-GO !
  MTC-TASKS 0 DO 0 I MTC-DONE MTC-CELL ! LOOP
  MTC-STORES                              \ хранилища готовим в главном потоке
  0 MTC-T0 START
  0 MTC-T1 START
  0 MTC-T2 START
  0 MTC-T3 START  1 MTC-GO !                              \ пошли компилировать
  MTC-WAIT ;

\ проверка: слово с таким именем есть только в хранилищах потоков
: MTC-IN-BASE? ( -- fl )
  S" MTC-THWORD" CONTEXT @ SEARCH-WORDLIST 0<> ;

\ ---------------------------------------------------------------------
\ демонстрация
\ ---------------------------------------------------------------------
CR S" base HERE before : " TYPE HERE . CR

\ 1 - компилировать в потоках, 0 - по очереди (результат одинаковый)
VARIABLE MTC-MT?  1 MTC-MT? !
: MTC-DO ( -- )  MTC-MT? @ IF MTC-RUN ELSE MTC-SEQ THEN ;
MTC-DO

: MTC-REPORT-BUILT ( -- )
  CR S" compiled into per-thread storages:" TYPE CR
  MTC-TASKS 0 DO
    CR S" thread " TYPE I .
    S"   storage " TYPE I MTC-HANDLE MTC-CELL @ .
    S"   wid " TYPE I MTC-WID MTC-CELL @ .
    S"   MTC-THWORD -> " TYPE I MTC-RES MTC-CELL @ .
  LOOP ;

: MTC-REPORT-CALL ( -- )
  CR CR S" each word is callable through its own xt: " TYPE
  MTC-TASKS 0 DO I MTC-XT MTC-CELL @ EXECUTE . LOOP CR
  CR S" base HERE after  : " TYPE HERE . CR
  CR S" MTC-THWORD in base dictionary? " TYPE MTC-IN-BASE? . CR ;

MTC-REPORT-BUILT
MTC-REPORT-CALL

\ освободить хранилища потоков (слова после этого недействительны)
: MTC-FREE ( -- )
  MTC-TASKS 0 DO I MTC-HANDLE MTC-CELL @ DEL-STORAGE LOOP ;
\ MTC-FREE

\ BYE
