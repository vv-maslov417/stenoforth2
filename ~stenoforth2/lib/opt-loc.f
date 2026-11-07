\ =====================================================================
\ Пеephole-оптимизатор для кода, который генерирует SPF
\
\ Идею взял у NTF/LXF П. Фальта: его компилятор ведёт виртуальный стек
\ и не порождает лишних пересылок. Компилятор SPF классический, поэтому
\ тот же эффект достижим только пост-обработкой уже сгенерированного кода.
\ Здесь реализовано то, что безопасно сделать без пересборки ядра.
\
\ Что убирается (видно на "a a *"):
\   MOV EAX,[ESP+0C]   \ a
\   MOV [EBP-8],EAX    \ сохранили
\   MOV EAX,[ESP+0C]   \ <-- лишняя перезагрузка того же самого
\   IMUL [EBP-8]       \ a*a
\ Третья команда не нужна: EAX уже содержит это значение.
\
\ Правила:
\   P1: MOV EAX,[m] ; MOV [s],EAX ; MOV EAX,[m]  -> третью заменить на NOP
\   P2: MOV [s],EAX ; MOV EAX,[s]                -> загрузку заменить на NOP
\ Удаление делается заменой байтов на 0x90, поэтому все адреса и переходы
\ внутри тела остаются на месте, а размер слова не меняется.
\
\ Ограничение: разбирается только подможество инструкций, которое
\ генерирует сам SPF; на неизвестном опкоде оптимизация прекращается.
\
\ Замечание: в этом образе VALUE/TO и локали в таком коде ведут себя
\ ненадёжно, поэтому вся реализация - на VARIABLE с @ и !.
\ =====================================================================

VARIABLE OPT-N        \ сколько инструкций выброшено всего
VARIABLE OPT-CHG      \ были ли изменения в текущем проходе
VARIABLE OPT-KNOWN    \ FALSE, если встретился неизвестный опкод
VARIABLE IA           \ адрес разбираемой инструкции
VARIABLE NA           \ адрес в NOP-OUT
VARIABLE NN           \ счётчик в NOP-OUT

\ --- длина ModRM + SIB + смещения; a указывает на байт ModRM
: MB-LEN ( a -- n )
  DUP C@ 0xC0 AND 0xC0 = IF DROP 1 EXIT THEN         \ mod=11: только ModRM
  DUP C@ 0xC0 AND 0x40 = IF 1 ELSE                   \ mod=01: disp8
  DUP C@ 0xC0 AND 0x80 = IF 4 ELSE 0 THEN THEN       \ mod=10: disp32
  OVER C@ 7 AND 4 = IF 1+ THEN                       \ SIB
  OVER C@ 0xC0 AND 0= IF                             \ mod=00
     OVER C@ 7 AND 5 = IF 4 + THEN                   \ [disp32]
  THEN
  NIP 1 +                                            \ отбросить адрес
;

\ --- опкоды, у которых после байта опкода идёт ModRM
: OP-MB? ( op -- fl )
  DUP 0x89 = OVER 0x8B = OR OVER 0x8D = OR
  OVER 0x01 = OR OVER 0x03 = OR OVER 0x09 = OR
  OVER 0x0B = OR OVER 0x2B = OR OVER 0x33 = OR
  OVER 0x3B = OR OVER 0x85 = OR OVER 0x87 = OR
  OVER 0x39 = OR OVER 0xC1 = OR OVER 0xD1 = OR
  OVER 0xF7 = OR OVER 0x0F = OR
  NIP ;

\ --- длина инструкции по её адресу
\ на неизвестном опкоде снимает OPT-KNOWN и считает длину 1,
\ чтобы проход просто остановился, ничего не испортив
: ILEN ( a -- n )
  IA !
  IA @ C@ 0x90 = IF 1 EXIT THEN                      \ nop
  IA @ C@ 0xC3 = IF 1 EXIT THEN                      \ ret
  IA @ C@ 0x50 >= IA @ C@ 0x5F <= AND IF 1 EXIT THEN \ push/pop r32
  IA @ C@ 0x6A = IF 2 EXIT THEN                      \ push imm8
  IA @ C@ 0xB8 >= IA @ C@ 0xBF <= AND IF 5 EXIT THEN \ mov r32,imm32
  IA @ C@ 0x68 = IF 5 EXIT THEN                      \ push imm32
  IA @ C@ 0xE8 = IF 5 EXIT THEN                      \ call rel32
  IA @ C@ 0xE9 = IF 5 EXIT THEN                      \ jmp rel32
  IA @ C@ 0xEB = IF 2 EXIT THEN                      \ jmp rel8
  IA @ C@ 0x70 >= IA @ C@ 0x7F <= AND IF 2 EXIT THEN \ jcc rel8
  IA @ C@ 0x0F = IF IA @ 2 + MB-LEN 2 + EXIT THEN    \ 0F xx /r
  IA @ C@ 0x83 = IF IA @ 1+ MB-LEN 1+ 1+ EXIT THEN   \ группа 83 /r ib
  IA @ C@ 0x81 = IF IA @ 1+ MB-LEN 1+ 4 + EXIT THEN  \ группа 81 /r id
  IA @ C@ 0xF7 = IF IA @ 1+ MB-LEN 1+ EXIT THEN      \ imul/idiv r/m32
  IA @ C@ OP-MB? IF 1 IA @ 1+ MB-LEN + EXIT THEN
  FALSE OPT-KNOWN !
  1 ;

\ --- операнды двух инструкций совпадают (байты после опкода)
VARIABLE S-A1 VARIABLE S-L1 VARIABLE S-A2 VARIABLE S-L2
: SAME-OP? ( a1 l1 a2 l2 -- fl )
  S-L2 ! S-A2 ! S-L1 ! S-A1 !
  S-A1 @ 1+ S-L1 @ 1- S-A2 @ 1+ S-L2 @ 1- COMPARE 0= ;

\ --- заменить инструкцию по адресу на NOP'ы
: NOP-OUT ( a -- )
  NA ! NA @ ILEN NN !
  BEGIN NN @ 0> WHILE
     0x90 NA @ C!
     NA @ 1+ NA !
     NN @ 1- NN !
  REPEAT
  1 OPT-N +!
  TRUE OPT-CHG ! ;

\ --- один проход по телу слова до RET
VARIABLE OP-P VARIABLE OP-Q VARIABLE OP-R
VARIABLE OP-L1 VARIABLE OP-L2 VARIABLE OP-L3

: OPT-PASS ( a0 -- )
  OP-P !
  BEGIN OP-P @ C@ 0xC3 <> WHILE
     OP-P @ ILEN OP-L1 !
     OP-P @ OP-L1 @ + OP-Q !
     OP-Q @ C@ 0xC3 = IF EXIT THEN
     OP-Q @ ILEN OP-L2 !
     OP-Q @ OP-L2 @ + OP-R !
     OP-R @ ILEN OP-L3 !
     OP-R @ C@ 0xC3 <> IF
        \ P1: MOV EAX,[m] ; MOV [s],EAX ; MOV EAX,[m]
        OP-P @ C@ 0x8B = OP-Q @ C@ 0x89 = AND
        OP-R @ C@ 0x8B = AND
        OP-P @ OP-L1 @ OP-R @ OP-L3 @ SAME-OP? AND
        IF   OP-R @ NOP-OUT  OP-Q @ OP-P !
        ELSE
             \ P2: MOV [s],EAX ; MOV EAX,[s]
             OP-P @ C@ 0x89 = OP-Q @ C@ 0x8B = AND
             OP-P @ OP-L1 @ OP-Q @ OP-L2 @ SAME-OP? AND
             IF   OP-Q @ NOP-OUT  OP-R @ OP-P !
             ELSE OP-Q @ OP-P !
             THEN
        THEN
     ELSE EXIT
     THEN
  REPEAT ;

\ --- применить правила к слову по xt, повторяя проходы до насыщения
: OPT-LOC ( xt -- n )   \ n - сколько инструкций выброшено
  0 OPT-N !
  BEGIN
    FALSE OPT-CHG !
    TRUE OPT-KNOWN !
    DUP OPT-PASS
    OPT-CHG @ 0=
  UNTIL
  DROP OPT-N @ ;
