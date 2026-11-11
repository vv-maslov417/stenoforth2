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
                             SLIDER svol 130 16 220 30  0 100 H on-move
"Микрофон"                   TEXT   lmic 16  62 110 18
                             SLIDER smic 130 58 220 30  0 100 H on-move
"Уровень"                    TEXT   llvl 370 10 60  40
                             SLIDER slvl 380 54  30 120 0 100 V on-move

"Запомнить настройки"        CHECK  chkb 16 110 240 24 on-check
"Вариант A"                  RADIO  radA 16 150 200 24 G on-radio
"Вариант B"                  RADIO  radB 16 176 200 24 - on-radio
"Вариант C"                  RADIO  radC 16 202 200 24 - on-radio

"Города"                     GROUPBOX grp1 16 240 340 210
                             LISTBOX  list1 32 270 300 160 on-list

"Выбор"                      GROUPBOX grp2 380 240 360 210
                             COMBO    combo1 396 274 320 150 on-list

"Текущие значения"           TEXT   lout 16 470 150 18
                             EDIT   edout 16 490 728 90
FORM-END

\ ----------------------------------------------- сборка строки значений
CREATE OBUF 1024 ALLOT  VARIABLE BLEN
: OUT-CLEAR ( -- ) 0 BLEN ! ;
: OUT+  ( a u -- ) { a u } a OBUF BLEN @ + u CMOVE  BLEN @ u + BLEN ! ;
CREATE DIGS 12 ALLOT
: OUT+NUM ( n -- )                      \ дописать десятичное число
  { n \ i }
  n 0= IF 48 OBUF BLEN @ + C! 1 BLEN +! EXIT THEN
  0 TO i
  BEGIN
    n 0=
    IF
      BEGIN
        i 0= IF EXIT THEN
        i 1- TO i
        DIGS i + C@ OBUF BLEN @ + C!
        1 BLEN +!
      AGAIN
    THEN
    n 10 MOD 48 + DIGS i + C!
    n 10 / TO n
    i 1+ TO i
  AGAIN
;

: SHOW-VALUES ( -- )
  OUT-CLEAR
  S" vol=" OUT+   svol @ POS@ OUT+NUM
  S"  mic=" OUT+  smic @ POS@ OUT+NUM
  S"  lvl=" OUT+  slvl @ POS@ OUT+NUM
  S"  chk=" OUT+  chkb @ STATE@ OUT+NUM
  S"  вариант: " OUT+
  radA @ STATE@ IF S" A" OUT+ THEN
  radB @ STATE@ IF S" B" OUT+ THEN
  radC @ STATE@ IF S" C" OUT+ THEN
  S"  | список: " OUT+  list1 @ SELTEXT@ OUT+
  S"  | combo: " OUT+   combo1 @ SELTEXT@ OUT+
  OBUF BLEN @ edout @ TEXT!
;

\ ---------------------------------------------------------- обработчики
: on-move  ( -- ) SHOW-VALUES ;
: on-check ( -- ) SHOW-VALUES ;
: on-radio ( -- ) SHOW-VALUES ;
: on-list  ( -- ) SHOW-VALUES ;
: on-quit  ( -- ) QUIT-APP ;

\ ------------------------------------------------------- наполнение списков
S" Москва"     list1 @ ITEM+
S" Тверь"      list1 @ ITEM+
S" Сочи"       list1 @ ITEM+
S" Казань"     list1 @ ITEM+
S" Первый"     combo1 @ ITEM+
S" Второй"     combo1 @ ITEM+
S" Третий"     combo1 @ ITEM+
0 list1 @ SEL!
0 combo1 @ SEL!

\ ------------------------------------------------------------- запуск
SHOW-VALUES
HIDE-CONSOLE
SHOW prob
BYE
