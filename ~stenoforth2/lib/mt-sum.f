\ stenoforth32

\ mt-sum.f - сумма значений байтов массива в двух задачах.
\ Каждая задача считает свою половину, затем результаты складываются.
\ Параметры и промежуточные значения хранятся в многопоточных локальных
\ переменных (имена с суффиксом "_"): они лежат в области задачи, поэтому
\ у каждой задачи своё значение, а обращение компилируется в одну команду.
\ Слова манипуляции стеком (DUP SWAP OVER ROT NIP и т.п.) не используются.
\
\ Проверено на spf486.exe (SP-Forth 4.29 + stenoforth2-1).
\
\ Загрузка и запуск демонстрации:
\   S" f:\spf429\devel\~stenoforth2-1\lib\mt-sum.f" INCLUDED
\   MTS-DEMO
\
\ Слово MTS-SUM ( a n -- s ) можно использовать и само по себе.
\
\ Правила обращения с такими переменными:
\   объявление и инициализация:  | x_ y_ |   (значения берутся со стека)
\                                или  V x_   (одиночное присвоение)
\   чтение:                      x           (суффикс опускается)
\   присваивание:                -> x        (суффикс опускается)
\
\ Соглашение об именах: системные (глобальные) слова - длинные имена,
\ локальные переменные - короткие.  Если имя локальной (без суффикса)
\ совпадёт с уже существующим словом системы, компилятор зацикливается:
\ например, нельзя  jn_  - jn это системная переменная глубины вложенности.

REQUIRE { lib\ext\locals.f

1000 CONSTANT MTS-N

CREATE MTS-ARR MTS-N ALLOT          \ демонстрационный массив

\ блок задания: адрес, длина, сумма, флаг завершения
CREATE MTS-JOB1 0 , 0 , 0 , 0 ,
CREATE MTS-JOB2 0 , 0 , 0 , 0 ,

\ -------------------- суммирование --------------------

: MTS-SUM1 ( a n -- s )             \ обычная (однопоточная) сумма байтов
  | xa_ xn_ |                       \ xa_ = a, xn_ = n
  0 xs_                             \ xs_ = 0
  xn 0 DO xa I + C@ xs + -> xs LOOP
  xs
;

: MTS-WORKER ( job -- )             \ тело задачи
  | wj_ |
  wj @ wa_
  wj CELL+ @ wn_
  wa wn MTS-SUM1 ws_
  ws wj 2 CELLS + !                 \ сумма   -> job[2]
  1 wj 3 CELLS + !                  \ признак -> job[3]
;

' MTS-WORKER TASK: MTS-TASK1
' MTS-WORKER TASK: MTS-TASK2

: MTS-JOB! ( a n j -- )             \ заполнить блок задания
  | ja_ jb_ jc_ |
  ja jc !
  jb jc CELL+ !
  0 jc 2 CELLS + !
  0 jc 3 CELLS + !
;

: MTS-SUM ( a n -- s )              \ сумма двумя задачами
  | sa_ sn_ |
  sn 2/ sn1_
  sa sn1 MTS-JOB1 MTS-JOB!
  sa sn1 + sn sn1 - MTS-JOB2 MTS-JOB!
  MTS-JOB1 MTS-TASK1 START th1_     \ START ( x task -- th )
  MTS-JOB2 MTS-TASK2 START th2_
  BEGIN                             \ ждём обе задачи
    MTS-JOB1 3 CELLS + @
    MTS-JOB2 3 CELLS + @ AND
  UNTIL
  MTS-JOB1 2 CELLS + @ MTS-JOB2 2 CELLS + @ +
;

\ -------------------- демонстрация --------------------

: MTS-FILL ( a n -- )               \ байт = i AND 255
  | fa_ fn_ |
  fn 0 DO I 255 AND fa I + C! LOOP
;

: MTS-DEMO ( -- )
  CR MTS-ARR MTS-N MTS-FILL
  MTS-ARR MTS-N MTS-SUM1 dseq_
  MTS-ARR MTS-N MTS-SUM dpar_
  CR ." seq  = " dseq .
  CR ." par  = " dpar .
  CR ." half1= " MTS-JOB1 2 CELLS + @ .
     ."  half2= " MTS-JOB2 2 CELLS + @ .
  CR dseq dpar = IF ." OK" ELSE ." MISMATCH!" THEN
  CR
;
