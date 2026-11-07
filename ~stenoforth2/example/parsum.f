\ =====================================================================
\ Реальная двухпоточность в SP-Forth: сумма байтов массива
\
\ Один поток суммирует первую половину массива, второй - вторую,
\ оба работают одновременно (TASK: + START = реальные потоки Windows).
\
\ Дополнительно каждый поток сообщает, на каком ядре он работал:
\   GetCurrentProcessorNumber - номер ядра в момент старта работы,
\   маска ядер за прогон      - битовая карта всех ядер, на которых
\                               поток успел побывать (миграция видна).
\ При PIN? = 1 потоки закрепляются за разными ядрами через
\ SetThreadAffinityMask; при PIN? = 0 закрепления нет - видны переезды.
\
\ Стек Forth каждому потоку _WNDPROC-CODE выделяет внутри стека самого
\ OS-потока, поэтому задачи можно стартовать повторно. Требование одно -
\ тело потока должно быть реентерабельным: только свой стек и локали,
\ результат в отдельную ячейку + флаг.
\
\ Замер словом SEET (lib\seetl.f, счётчик TSC, среднее по 4 прогонам),
\ 40 МБ x 6:
\   один поток : 116.545 мс   (512800487 tics)
\   два потока :  65.593 мс   (288608808 tics)  - ускорение 1.78x
\ Потоки закрепляются за ядрами 0 и 2: логические CPU 0 и 1 - это SMT-соседи
\ одного физического ядра, на них выигрыша нет (проверено: 125 мс, как у
\ одного потока). При PIN? = 0 видны переезды потока между ядрами.
\
\ Запуск:  spf486.exe example\parsum.f
\ =====================================================================

WINAPI: GetCurrentProcessorNumber KERNEL32.DLL
WINAPI: SetThreadAffinityMask       KERNEL32.DLL

\ прибавить сумму байтов участка к накопленному значению
: SUMB+ ( a u s -- s+ )
  -ROT
  DUP 0> IF
    0 DO
      DUP I + C@
      ROT +
      SWAP
    LOOP
  ELSE DROP THEN
  DROP ;

\ сумма участка за n проходов; msk - адрес маски ядер этого потока
: RSUM { a u n msk \ s }
  0 TO s
  n 0> IF
    n 0 DO
      GetCurrentProcessorNumber 1 SWAP LSHIFT  msk @ OR  msk !
      a u s SUMB+ TO s
    LOOP
  THEN
  s ;

40960 1024 * CONSTANT ASIZE            \ 40 МБ
ASIZE 2/     CONSTANT HALF
6            CONSTANT REPS             \ проходов по массиву

HERE ASIZE ALLOT CONSTANT ARR
ARR ASIZE 7 FILL                        \ заполнили семёрками

VARIABLE S1 VARIABLE S2                 \ результаты половин
VARIABLE D1 VARIABLE D2                 \ флаги завершения
VARIABLE GO                             \ 0 - потоки ждут, 1 - работать
VARIABLE PIN?  1 PIN? !                 \ 1 - закрепить за ядрами

VARIABLE CORE0 VARIABLE CORE1 VARIABLE CORE2   \ ядро на старте
VARIABLE MASK0 VARIABLE MASK1 VARIABLE MASK2   \ все ядра за прогон

: WAITGO  BEGIN GO @ 0= WHILE 1 PAUSE REPEAT ;

: TALL WAITGO GetCurrentProcessorNumber CORE0 !
          ARR ASIZE REPS MASK0 RSUM S1 !  1 D1 ! TERMINATE ;

: TH1  WAITGO GetCurrentProcessorNumber CORE1 !
          ARR HALF REPS MASK1 RSUM S1 !  1 D1 ! TERMINATE ;

: TH2  WAITGO GetCurrentProcessorNumber CORE2 !
          ARR HALF + HALF REPS MASK2 RSUM S2 !  1 D2 ! TERMINATE ;

' TH1  TASK: TA
' TH2  TASK: TB
' TALL TASK: TC

\ закрепить поток th за ядром mask (1 - ядро 0, 2 - ядро 1, ...)
\ ВАЖНО: WINAPI: кладёт аргументы на стек справа налево, то есть
\ последний аргумент C-прототипа первым. SetThreadAffinityMask(h, mask)
\ вызывается как ( mask h ) - поэтому SWAP.
: PIN ( th mask -- )
  PIN? @ IF SWAP SetThreadAffinityMask DROP ELSE 2DROP THEN ;

: ONE ( -- ) 0 D1 ! 0 MASK0 ! 0 GO !
             0 TC START 1 PIN
             1 GO !
             BEGIN D1 @ 0= WHILE 1 PAUSE REPEAT ;

: TWO ( -- ) 0 D1 ! 0 D2 ! 0 MASK1 ! 0 MASK2 ! 0 GO !
             0 TA START 1 PIN                       \ ядро 0
             0 TB START 4 PIN                       \ ядро 2
             1 GO !
             BEGIN D1 @ 0= D2 @ 0= OR WHILE 1 PAUSE REPEAT ;

: .CORES ( -- )
  HEX
  S" one thread  : core " TYPE CORE0 @ . S"  mask " TYPE MASK0 @ . CR
  S" thread 1    : core " TYPE CORE1 @ . S"  mask " TYPE MASK1 @ . CR
  S" thread 2    : core " TYPE CORE2 @ . S"  mask " TYPE MASK2 @ . CR
  DECIMAL ;

ONE                                      \ прогрев
S" one thread  (40MB x6):" TYPE CR SEET ONE
S" two threads (20MB x6):" TYPE CR SEET TWO
S" control sum = " TYPE S1 @ S2 @ + . CR
S" expected    = " TYPE ASIZE 7 * REPS * . CR

S" --- закреплено за ядрами (PIN? = 1) ---" TYPE CR
TWO .CORES

S" --- без закрепления (PIN? = 0): видна миграция ---" TYPE CR
0 PIN? !  TWO .CORES

\ BYE
