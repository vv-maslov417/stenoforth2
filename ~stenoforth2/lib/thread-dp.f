\ =====================================================================
\ Свой указатель словаря у каждого потока
\
\ Ядро обращается к области словаря не напрямую через (DP), а через
\ слово DP: HERE, ALLOT, C, , и компилятор делают CALL DP.
\ Поэтому достаточно переопределить DP и перенаправить старый вход
\ безусловным переходом на новое слово.
\
\ Ячейка DP у каждого потока своя. Она ищется по THREAD-ID в таблице
\ DP-TAB/DP-VAL, поэтому не нужны ни USER-переменные (их нельзя
\ добавлять в уже работающей системе), ни правка ядра.
\ =====================================================================

16 CONSTANT DP-MAX              \ столько потоков поддерживается

CREATE DP-TAB  DP-MAX CELLS ALLOT   \ идентификаторы потоков
CREATE DP-VAL  DP-MAX CELLS ALLOT   \ их указатели словаря
VARIABLE DP-N                        \ занято записей

VARIABLE DP-INIT                     \ стартовое значение для нового потока
VARIABLE DP-TID
VARIABLE DP-RES

: DP-FIND ( -- addr | 0 )            \ ячейка DP текущего потока
  THREAD-ID DP-TID !
  0 DP-RES !
  DP-N @ 0> IF
    DP-N @ 0 DO
      DP-TID @ DP-TAB I CELLS + @ =
      IF DP-VAL I CELLS + DP-RES ! THEN
    LOOP
  THEN
  DP-RES @ ;

: DP-CELL ( -- addr )
  DP-FIND
  DUP 0= IF
    DROP
    DP-N @ DP-MAX < IF
      DP-TID @   DP-TAB DP-N @ CELLS + !
      DP-N @ 0= IF DP-INIT @ ELSE DP-VAL @ THEN
      DP-VAL DP-N @ CELLS + !
      DP-N 1+!
      DP-VAL DP-N @ 1- CELLS +
    ELSE DP-VAL THEN
  THEN ;

: DP-NEW ( -- addr )
  IS-TEMP-WL IF GET-CURRENT 7 CELLS + ELSE DP-CELL THEN ;

[DEFINED] STORAGE-ID [IF]

\ storage.f уже подменяет DP на USER-переменную, и она своя у каждой задачи.
\ Патчить DP кодом в этом случае нельзя: (MOUNT) пишет указатель словаря
\ в ячейку storage.f, а DP-NEW возвращал бы другую ячейку - HERE разошёлся
\ бы с DP, и создание записи локальных падало в SHEADER1 -> ",".
: DICT! ( addr -- ) DP ! ;

\ текущее значение указателя словаря потока
: DICT@ ( -- addr ) DP @ ;

[ELSE]

' DP CONSTANT OLD-DP                 \ адрес старого входа DP

HERE DP-INIT !                       \ захват текущего HERE перед патчем

OLD-DP 0xE9 OVER C! DROP             \ JMP rel32 на новое DP
OLD-DP 5 + ' DP-NEW SWAP - OLD-DP 1+ !

\ переключить указатель словаря текущего потока на область addr
: DICT! ( addr -- ) DP-CELL ! ;

\ текущее значение указателя словаря потока
: DICT@ ( -- addr ) DP-CELL @ ;

[THEN]
