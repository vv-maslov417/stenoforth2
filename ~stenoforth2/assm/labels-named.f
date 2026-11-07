\ =====================================================================
\ Произвольные имена меток для постфиксного ассемблера (mp-assm.f)
\
\ Требует: mp-assm.f  (XN, $LABEL, DP)
\
\ Порядок работы:
\   LABEL  entry loop done        \ объявить метки (до определения!)
\   : T1
\       entry JMP   ...           \ переход на метку
\       loop J0=    ...
\       done:
\       ...
\   ;
\
\ Метки объявляются ДО определения, потому что имя метки - это
\ immediate-слово, которое должно быть создано в словаре вне тела
\ определяемого слова (иначе код его тела попадёт внутрь тела T1).
\
\ Ограничения:
\   - не более 32 объявленных имён, далее слоты переиспользуются;
\   - имя не длиннее 63 символов;
\   - счётчики сбрасываются на каждом проходе XN, признаки длины - на новом цикле;
\   - нельзя брать имена существующих слов (ассемблер, ядро) - они будут
\     переопределены, о чём система предупредит сообщением isn't unique.
\ =====================================================================

32 CONSTANT NA-MAX

CREATE NA-LAB 128 ALLOT      \ адреса меток (32 * 4 байта)
CREATE NA-XLN 128 ALLOT      \ признаки длины интервала (8 ссылок на метку)
CREATE NA-CNT 128 ALLOT      \ счётчики числа ссылок на метку
VARIABLE NA-N                \ сколько имён занято
VARIABLE NA-PASS             \ номер прохода, для которого счётчики чисты

CREATE NA-NAM 64 ALLOT       \ копия имени текущей метки
VARIABLE NA-NL
CREATE NA-BUF 512 ALLOT      \ строка для EVALUATE
VARIABLE NA-P
CREATE NA-D0 16 ALLOT        \ буфер цифр для NA-LIT
VARIABLE NA-I

: NA-LAB@ ( -- addr ) NA-LAB NA-N @ CELLS + ;
: NA-XLN@ ( -- addr ) NA-XLN NA-N @ CELLS + ;
: NA-CNT@ ( -- addr ) NA-CNT NA-N @ CELLS + ;

\ --- сброс ячеек: счётчики - на каждом проходе, признаки длины - на новом цикле
: NA-CLR-CNT ( -- )
  NA-MAX 0 DO  0 NA-CNT I CELLS + !  LOOP ;

: NA-CLR-ALL ( -- )
  NA-MAX 0 DO
    0 NA-XLN I CELLS + !
    0 NA-CNT I CELLS + !
  LOOP ;

\ --- сборка строки в NA-BUF и выдача наружу -------------------------
: NA-+ ( a u -- )
  DUP >R  NA-BUF NA-P @ +  SWAP MOVE
  NA-P @ R> + NA-P ! ;

\ --- шестнадцатеричное число в текст, без зависимости от BASE -------
: NA-LIT ( n -- )
  16 NA-I !
  BEGIN
    DUP 15 AND DUP 9 > IF 55 + ELSE 48 + THEN
    NA-D0 NA-I @ 1- DUP NA-I ! +
    C!
    4 RSHIFT
    DUP 0=
  UNTIL
  DROP
  S" 0x" NA-+
  NA-D0 NA-I @ +   16 NA-I @ -   NA-+ ;

\ --- создание пары слов для текущего имени --------------------------
: NA-EMIT ( -- )
  0 NA-P !
  S" I: " NA-+              NA-NAM NA-NL @ NA-+
  S"  " NA-+  NA-LAB@ NA-LIT  S"  @" NA-+
  S"  " NA-+  NA-XLN@ NA-LIT
  S"  " NA-+  NA-CNT@ NA-LIT
  S"  NA-COUNT+ ; I: " NA-+  NA-NAM NA-NL @ NA-+
  S" : DP @ " NA-+  NA-LAB@ NA-LIT  S"  ! ;" NA-+
  NA-BUF NA-P @ EVALUATE ;

\ --- регистрация одного имени ---------------------------------------
: NA-NEW ( a u -- )
  DUP 0=
  IF 2DROP
  ELSE
    DUP 64 > ABORT" LABEL: имя длиннее 63 символов"
    DUP NA-NL !  NA-NAM SWAP MOVE
    NA-N @ NA-MAX >= IF 0 NA-N ! THEN
    NA-EMIT
    NA-N 1+!
  THEN ;

\ --- объявление метки: LABEL имя [имя ...] --------------------------
: LABEL ( -- )
  BEGIN PARSE-NAME DUP WHILE NA-NEW REPEAT 2DROP ;

\ --- ссылка на метку: то же, что у L1..L8, но со сбросом по проходу -
: NA-COUNT+ ( A-Lab A-Len A-Cnt -- )
  XN NA-PASS @ >
  IF XN NA-PASS ! NA-CLR-ALL
  ELSE XN NA-PASS @ <> IF XN NA-PASS ! NA-CLR-CNT THEN THEN
  DUP 1+! 1 TO $LABEL ;

\ --- освободить таблицу вручную -------------------------------------
: NA-RESET ( -- ) 0 NA-N ! 0 NA-PASS ! NA-CLR-ALL ;
