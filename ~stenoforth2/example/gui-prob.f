\ =====================================================================
\  gui-prob.f - проверка компонентов gui-kit
\  Рабочий файл: только подгрузка библиотеки и описание формы.
\  Правила параметризации - в шапке gui-kit.f (описаны там один раз).
\
\  Запуск:  spf486.exe gui-prob.f
\ =====================================================================

REQUIRE WINDOW gui-kit.f

"Проверка компонентов"       WINDOW prob 760 600

"Громкость"                  TEXT   lvol 16  20 110 18
                             SLIDER vol  130 16 220 30  0 100 H on-move
"Микрофон"                   TEXT   lmic 16  62 110 18
                             SLIDER mic  130 58 220 30  0 100 H on-move
"Уровень"                    TEXT   llvl 370 10 60  40
                             SLIDER lvl  380 54  30 120 0 100 V on-move

"Запомнить настройки"        CHECK  chk 16 110 240 24 on-check
"Вариант A"                  RADIO  ra  16 150 200 24 G on-radio
"Вариант B"                  RADIO  rb  16 176 200 24 - on-radio
"Вариант C"                  RADIO  rc  16 202 200 24 - on-radio

"Города"                     GROUPBOX gb1 16 240 340 210
                             LISTBOX  lst 32 270 300 160 on-list

"Выбор"                      GROUPBOX gb2 380 240 360 210
                             COMBO    cmb 396 274 320 150 on-list

"Текущие значения"           TEXT   lout 16 470 150 18
                             EDIT   out  16 490 728 90
END

\ ----------------------------------------------- сборка строки значений
CREATE BUF 1024 ALLOT  VARIABLE BLEN
: OUT-CLEAR ( -- ) 0 BLEN ! ;
: OUT+  ( a u -- ) { a u } a BUF BLEN @ + u CMOVE  BLEN @ u + BLEN ! ;
CREATE DIG 12 ALLOT
: OUT+NUM ( n -- )                      \ дописать десятичное число
  { n \ i }
  n 0= IF 48 BUF BLEN @ + C! 1 BLEN +! EXIT THEN
  0 TO i
  BEGIN
    n 0=
    IF
      BEGIN
        i 0= IF EXIT THEN
        i 1- TO i
        DIG i + C@ BUF BLEN @ + C!
        1 BLEN +!
      AGAIN
    THEN
    n 10 MOD 48 + DIG i + C!
    n 10 / TO n
    i 1+ TO i
  AGAIN
;

: SHOW-VALUES ( -- )
  OUT-CLEAR
  S" vol=" OUT+   vol @ POS@ OUT+NUM
  S"  mic=" OUT+  mic @ POS@ OUT+NUM
  S"  lvl=" OUT+  lvl @ POS@ OUT+NUM
  S"  chk=" OUT+  chk @ STATE@ OUT+NUM
  S"  вариант: " OUT+
  ra @ STATE@ IF S" A" OUT+ THEN
  rb @ STATE@ IF S" B" OUT+ THEN
  rc @ STATE@ IF S" C" OUT+ THEN
  S"  | список: " OUT+  lst @ SELTEXT@ OUT+
  S"  | combo: " OUT+   cmb @ SELTEXT@ OUT+
  BUF BLEN @ out @ TEXT!
;

\ ---------------------------------------------------------- обработчики
: on-move  ( -- ) SHOW-VALUES ;
: on-check ( -- ) SHOW-VALUES ;
: on-radio ( -- ) SHOW-VALUES ;
: on-list  ( -- ) SHOW-VALUES ;
: on-quit  ( -- ) QUIT-APP ;

\ ------------------------------------------------------- наполнение списков
S" Москва"     lst @ ITEM+
S" Тверь"      lst @ ITEM+
S" Сочи"       lst @ ITEM+
S" Казань"     lst @ ITEM+
S" Первый"     cmb @ ITEM+
S" Второй"     cmb @ ITEM+
S" Третий"     cmb @ ITEM+
0 lst @ SEL!
0 cmb @ SEL!

\ ------------------------------------------------------------- запуск
SHOW-VALUES
HIDE-CONSOLE
SHOW prob
BYE
