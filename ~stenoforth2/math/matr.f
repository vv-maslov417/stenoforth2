\ stenoforth32

\ Матрицы с символическими элементами.
\ Элемент - число, имя слова-значения (VALUE/CONSTANT) или выражение
\ над ними (+ - * /). Результаты операций приводятся к сумме мономов:
\ раскрываются скобки и собираются подобные слагаемые.
\ Вычисление значений - EVALMAT, печать - M. (то же, что [type]).
\ Числовая версия без символики сохранена в matr-num.f.

\ ---------- арена узлов и текстов имён ----------
CREATE ARENA 262144 ALLOT
VARIABLE AHERE
: ARESET ( -- ) ARENA AHERE ! ;
ARESET

VARIABLE TEMPA
: ALLOC { n -- a }
  AHERE @ DUP TEMPA !
  n 3 + -4 AND + AHERE !
  TEMPA @ ;

: NODE ( -- a ) 16 ALLOC ;

0 CONSTANT #NUM
1 CONSTANT #VAR
2 CONSTANT #ADD
3 CONSTANT #SUB
4 CONSTANT #MUL
5 CONSTANT #NEG
6 CONSTANT #DIV

: EL-K@ ( el -- k ) @ ;
: EL-A@ ( el -- v ) CELL+ @ ;
: EL-B@ ( el -- v ) 2 CELLS + @ ;
: EL-N@ ( el -- n ) 3 CELLS + @ ;
: EL-K! ( k el -- ) ! ;
: EL-A! ( v el -- ) CELL+ ! ;
: EL-B! ( v el -- ) 2 CELLS + ! ;
: EL-N! ( n el -- ) 3 CELLS + ! ;

: MK-NUM { n -- el }
  NODE 0 OVER EL-K! 0 OVER EL-A! 0 OVER EL-B! n OVER EL-N! ;

: MK-BIN { k x y -- el }
  NODE k OVER EL-K! x OVER EL-A! y OVER EL-B! 0 OVER EL-N! ;

VARIABLE NAMEBUF
: MK-VAR { xt a u -- el }
  u ALLOC DUP NAMEBUF !
  a SWAP u MOVE
  NODE 1 OVER EL-K! xt OVER EL-A! NAMEBUF @ OVER EL-B! u OVER EL-N! ;

\ ---------- печать ----------
: PREC-OF { el -- p }
  el EL-K@ CASE
    #NUM OF 3 ENDOF
    #VAR OF 3 ENDOF
    #NEG OF 2 ENDOF
    #MUL OF 1 ENDOF
    #ADD OF 0 ENDOF
    #SUB OF 0 ENDOF
    #DIV OF 1 ENDOF
  ENDCASE ;

: .N ( n -- ) DUP ABS 0 <# #S ROT SIGN #> TYPE ;
: N-W ( n -- w ) DUP ABS 0 <# #S ROT SIGN #> NIP ;

: EL$ { el prec -- }
  el PREC-OF prec < IF ." (" THEN
  el EL-K@ CASE
    #NUM OF el EL-N@ .N ENDOF
    #VAR OF el EL-B@ el EL-N@ TYPE ENDOF
    #NEG OF ." -" el EL-A@ 2 RECURSE ENDOF
    #MUL OF el EL-A@ 1 RECURSE ." *" el EL-B@ 1 RECURSE ENDOF
    #ADD OF el EL-A@ 0 RECURSE ." +" el EL-B@ 0 RECURSE ENDOF
    #SUB OF el EL-A@ 0 RECURSE ." -" el EL-B@ 1 RECURSE ENDOF
    #DIV OF el EL-A@ 1 RECURSE ." /" el EL-B@ 2 RECURSE ENDOF
  ENDCASE
  el PREC-OF prec < IF ." )" THEN ;

: EL-W { el prec -- w }
  el EL-K@ CASE
    #NUM OF el EL-N@ N-W ENDOF
    #VAR OF el EL-N@ ENDOF
    #NEG OF el EL-A@ 2 RECURSE 1+ ENDOF
    #MUL OF el EL-A@ 1 RECURSE el EL-B@ 1 RECURSE + 1+ ENDOF
    #ADD OF el EL-A@ 0 RECURSE el EL-B@ 0 RECURSE + 1+ ENDOF
    #SUB OF el EL-A@ 0 RECURSE el EL-B@ 1 RECURSE + 1+ ENDOF
    #DIV OF el EL-A@ 1 RECURSE el EL-B@ 2 RECURSE + 1+ ENDOF
  ENDCASE
  el PREC-OF prec < IF 2 + THEN ;

\ ---------- операции над элементами ----------
: MK-NEG { x -- el }
  x EL-K@ 0= IF x EL-N@ NEGATE MK-NUM EXIT THEN
  x EL-K@ #NEG = IF x EL-A@ EXIT THEN
  #NEG x 0 MK-BIN ;

: EL+ { x y -- z }
  x EL-K@ 0= y EL-K@ 0= AND IF x EL-N@ y EL-N@ + MK-NUM EXIT THEN
  x EL-K@ 0= IF x EL-N@ 0= IF y EXIT THEN THEN
  y EL-K@ 0= IF y EL-N@ 0= IF x EXIT THEN THEN
  #ADD x y MK-BIN ;

: EL- { x y -- z }
  x EL-K@ 0= y EL-K@ 0= AND IF x EL-N@ y EL-N@ - MK-NUM EXIT THEN
  y EL-K@ 0= IF y EL-N@ 0= IF x EXIT THEN THEN
  x EL-K@ 0= IF x EL-N@ 0= IF y MK-NEG EXIT THEN THEN
  #SUB x y MK-BIN ;

: EL* { x y -- z }
  x EL-K@ 0= y EL-K@ 0= AND IF x EL-N@ y EL-N@ * MK-NUM EXIT THEN
  x EL-K@ 0= IF x EL-N@ 0= IF 0 MK-NUM EXIT THEN x EL-N@ 1 = IF y EXIT THEN THEN
  y EL-K@ 0= IF y EL-N@ 0= IF 0 MK-NUM EXIT THEN y EL-N@ 1 = IF x EXIT THEN THEN
  #MUL x y MK-BIN ;

: EL/ { x y -- z }
  y EL-K@ 0= IF y EL-N@ 0= IF ." division by zero" ABORT THEN THEN
  y EL-K@ 0= IF y EL-N@ 1 = IF x EXIT THEN THEN
  x EL-K@ 0= IF x EL-N@ 0= IF 0 MK-NUM EXIT THEN THEN
  x EL-K@ 0= y EL-K@ 0= AND
    IF x EL-N@ y EL-N@ MOD 0= IF x EL-N@ y EL-N@ / MK-NUM EXIT THEN THEN
  x y = IF 1 MK-NUM EXIT THEN
  #DIV x y MK-BIN ;

\ ---------- вычисление выражения ----------
: EV { el -- n }
  el EL-K@ CASE
    #NUM OF el EL-N@ ENDOF
    #VAR OF el EL-A@ EXECUTE ENDOF
    #ADD OF el EL-A@ RECURSE el EL-B@ RECURSE + ENDOF
    #SUB OF el EL-A@ RECURSE el EL-B@ RECURSE - ENDOF
    #MUL OF el EL-A@ RECURSE el EL-B@ RECURSE * ENDOF
    #NEG OF el EL-A@ RECURSE NEGATE ENDOF
    #DIV OF el EL-A@ RECURSE el EL-B@ RECURSE / ENDOF
  ENDCASE ;

\ ---------- разбор ----------
\ ============ приведение подобных и раскрытие скобок ============

CREATE KBUF 512 ALLOT
CREATE KB2 512 ALLOT
CREATE KB3 256 ALLOT
CREATE KB4 256 ALLOT

: CH>BUF { c buf -- buf' } c buf C! buf 1+ ;

VARIABLE NU
: N>BUF { n buf -- buf' }
  n DUP ABS 0 <# #S ROT SIGN #> DUP NU !
  buf SWAP MOVE
  buf NU @ + ;

: EL>BUF { el prec buf -- buf' }
  el PREC-OF prec < IF [CHAR] ( buf CH>BUF TO buf THEN
  el EL-K@ CASE
    #NUM OF el EL-N@ buf N>BUF TO buf ENDOF
    #VAR OF el EL-B@ el EL-N@ buf SWAP MOVE buf el EL-N@ + TO buf ENDOF
    #NEG OF [CHAR] - buf CH>BUF TO buf el EL-A@ 2 buf RECURSE TO buf ENDOF
    #MUL OF el EL-A@ 1 buf RECURSE TO buf [CHAR] * buf CH>BUF TO buf el EL-B@ 1 buf RECURSE TO buf ENDOF
    #ADD OF el EL-A@ 0 buf RECURSE TO buf [CHAR] + buf CH>BUF TO buf el EL-B@ 0 buf RECURSE TO buf ENDOF
    #SUB OF el EL-A@ 0 buf RECURSE TO buf [CHAR] - buf CH>BUF TO buf el EL-B@ 1 buf RECURSE TO buf ENDOF
    #DIV OF el EL-A@ 1 buf RECURSE TO buf [CHAR] / buf CH>BUF TO buf el EL-B@ 2 buf RECURSE TO buf ENDOF
  ENDCASE
  el PREC-OF prec < IF [CHAR] ) buf CH>BUF TO buf THEN
  buf ;

: AKEY { atom buf -- a u }
  atom 0 buf EL>BUF
  buf - buf SWAP ;

: ATOM-CMP { x y -- n }
  x KB3 AKEY
  y KB4 AKEY
  COMPARE ;

CREATE SCR 131072 ALLOT
VARIABLE SH
: SRESET ( -- ) SCR SH ! ;
SRESET

VARIABLE STMP
: S-ALLOC { n -- a }
  SH @ DUP STMP !
  n 3 + -4 AND + SH !
  STMP @ ;

: MAT ( m i -- addr ) CELLS 3 CELLS + + ;
: M-COEFF@ ( m -- n ) CELL+ @ ;
: M-COEFF! ( n m -- ) CELL+ ! ;
: M-CNT@ ( m -- n ) 2 CELLS + @ ;
: M-CNT! ( n m -- ) 2 CELLS + ! ;

: SMONO ( -- m )
  19 CELLS S-ALLOC
  0 OVER !
  1 OVER CELL+ !
  0 OVER 2 CELLS + ! ;

: MONO-N { k -- m }
  SMONO
  DUP k SWAP M-COEFF! ;

: MONO-A { el -- m }
  SMONO DUP 1 SWAP M-COEFF!
  DUP 0 MAT el SWAP !
  DUP 1 SWAP M-CNT! ;

: LPUSH ( l m -- l' ) TUCK ! ;

VARIABLE NX
: LCAT { l1 l2 -- l }
  BEGIN l2 WHILE
    l2 @ NX !
    l1 l2 LPUSH TO l1
    NX @ TO l2
  REPEAT
  l1 ;

VARIABLE CUR
: LSCALE { l k -- l }
  l CUR !
  BEGIN CUR @ WHILE
    CUR @ M-COEFF@ k * CUR @ M-COEFF!
    CUR @ @ CUR !
  REPEAT
  l ;

VARIABLE NEWM VARIABLE CN VARIABLE LC1 VARIABLE LC2 VARIABLE RACC
VARIABLE TMPX

: MMUL1 { m1 m2 -- m }
  SMONO NEWM !
  NEWM @ m1 M-COEFF@ m2 M-COEFF@ * SWAP M-COEFF!
  0 CN !
  m1 M-CNT@ DUP 0> IF 0 DO
    m1 I MAT @ NEWM @ CN @ MAT !
    CN @ 1+ CN !
  LOOP ELSE DROP THEN
  m2 M-CNT@ DUP 0> IF 0 DO
    m2 I MAT @ NEWM @ CN @ MAT !
    CN @ 1+ CN !
  LOOP ELSE DROP THEN
  CN @ NEWM @ M-CNT!
  NEWM @ ;
: LMUL { l1 l2 -- r }
  l1 LC1 !
  0 RACC !
  BEGIN LC1 @ WHILE
    l2 LC2 !
    BEGIN LC2 @ WHILE
      LC2 @ @ NX !
      LC1 @ LC2 @ MMUL1 RACC @ SWAP LPUSH RACC !
      NX @ LC2 !
    REPEAT
    LC1 @ @ LC1 !
  REPEAT
  RACC @ ;

: MSORT { m -- }
  m M-CNT@ 1- DUP 0> IF 0 DO
    m M-CNT@ 1- DUP 0> IF 0 DO
      m I MAT @ m I 1+ MAT @ ATOM-CMP 0> IF
        m I MAT @ TMPX !
        m I 1+ MAT @ m I MAT !
        TMPX @ m I 1+ MAT !
      THEN
    LOOP ELSE DROP THEN
  LOOP ELSE DROP THEN ;
: MONO-KEY { m buf -- buf' }
  m MSORT
  m M-CNT@ DUP 0> IF 0 DO
    m I MAT @ 0 buf EL>BUF TO buf
  LOOP ELSE DROP THEN
  buf ;
: MKEY { m buf -- a u }
  m buf MONO-KEY
  buf - buf SWAP ;

: MCMP { m1 m2 -- n }
  m1 KBUF MKEY
  m2 KB2 MKEY
  COMPARE ;

CREATE MLIST 512 CELLS ALLOT
VARIABLE NML

: L>ARR { l -- n }
  0 NML !
  BEGIN l WHILE
    l MLIST NML @ CELLS + !
    NML @ 1+ NML !
    l @ TO l
  REPEAT
  NML @ ;

: SARRSORT { n -- }
  n 1- DUP 0> IF 0 DO
    n 1- DUP 0> IF 0 DO
      MLIST I CELLS + @ MLIST I 1+ CELLS + @ MCMP 0> IF
        MLIST I CELLS + @ TMPX !
        MLIST I 1+ CELLS + @ MLIST I CELLS + !
        TMPX @ MLIST I 1+ CELLS + !
      THEN
    LOOP ELSE DROP THEN
  LOOP ELSE DROP THEN ;
VARIABLE RESC
VARIABLE CC VARIABLE IDX
: COLLECT { l -- r }
  l L>ARR NML !
  NML @ 0= IF 0 EXIT THEN
  NML @ SARRSORT
  0 CUR !
  BEGIN CUR @ NML @ < WHILE
    MLIST CUR @ CELLS + @ M-COEFF@ 0<> IF
      CUR @ 1+ CC !
      BEGIN CC @ NML @ < WHILE
        MLIST CUR @ CELLS + @ MLIST CC @ CELLS + @ MCMP 0= IF
          MLIST CC @ CELLS + @ M-COEFF@ MLIST CUR @ CELLS + @ M-COEFF@ +
          MLIST CUR @ CELLS + @ M-COEFF!
          0 MLIST CC @ CELLS + @ M-COEFF!
        THEN
        CC @ 1+ CC !
      REPEAT
    THEN
    CUR @ 1+ CUR !
  REPEAT
  0 RESC !
  NML @ 1- IDX !
  BEGIN IDX @ 0>= WHILE
    MLIST IDX @ CELLS + @ M-COEFF@ 0<> IF
      RESC @ MLIST IDX @ CELLS + @ LPUSH RESC !
    THEN
    IDX @ 1- IDX !
  REPEAT
  RESC @ ;

VARIABLE ACC VARIABLE NEGF
: MONO>EL { m -- el }
  m M-CNT@ 0= IF m M-COEFF@ MK-NUM EXIT THEN
  m 0 MAT @ ACC !
  m M-CNT@ DUP 1 > IF 1 DO
    #MUL ACC @ m I MAT @ MK-BIN ACC !
  LOOP ELSE DROP THEN
  m M-COEFF@ DUP 0< NEGF !
  ABS
  DUP 1 = IF DROP ACC @ ELSE MK-NUM #MUL SWAP ACC @ MK-BIN THEN
  NEGF @ IF MK-NEG THEN ;

VARIABLE ACC2 VARIABLE GOT
: ADD-TERM { el -- }
  GOT @ IF
    el EL-K@ #NEG = IF
      #SUB ACC2 @ el EL-A@ MK-BIN ACC2 !
    ELSE
      #ADD ACC2 @ el MK-BIN ACC2 !
    THEN
  ELSE
    el EL-K@ #NEG = IF el EL-A@ MK-NEG ELSE el THEN
    ACC2 !
    1 GOT !
  THEN ;

: BUILD { l -- el }
  0 GOT !
  l CUR !
  BEGIN CUR @ WHILE
    CUR @ M-COEFF@ 0<> IF CUR @ MONO>EL ADD-TERM THEN
    CUR @ @ CUR !
  REPEAT
  GOT @ IF ACC2 @ ELSE 0 MK-NUM THEN ;

: NORM { el -- l }
  el EL-K@ CASE
    #NUM OF el EL-N@ MONO-N ENDOF
    #VAR OF el MONO-A ENDOF
    #NEG OF el EL-A@ RECURSE -1 LSCALE ENDOF
    #ADD OF el EL-A@ RECURSE el EL-B@ RECURSE LCAT ENDOF
    #SUB OF el EL-A@ RECURSE el EL-B@ RECURSE -1 LSCALE LCAT ENDOF
    #MUL OF el EL-A@ RECURSE el EL-B@ RECURSE LMUL ENDOF
    #DIV OF el MONO-A ENDOF
    DROP el MONO-A
  ENDCASE ;

: NORM-EL ( el -- el' )
  SRESET
  NORM COLLECT BUILD ;

CREATE MBUF 65536 CELLS ALLOT
VARIABLE MCNT VARIABLE MROWS VARIABLE MCOLS
VARIABLE NEG?

: M-PUT ( el -- ) MCNT @ CELLS MBUF + ! MCNT @ 1+ MCNT ! ;

: S>NUM { a u -- n f }
  u 0= IF 0 0 EXIT THEN
  a C@ [CHAR] - = NEG? !
  NEG? @ IF 0 0 a 1+ u 1- >NUMBER ELSE 0 0 a u >NUMBER THEN
  DUP 0= IF
    DROP 2DROP
    NEG? @ IF NEGATE THEN
    -1
  ELSE 2DROP 2DROP 0 THEN ;

: M-TOKEN { a u -- }
  a u S" )" COMPARE 0= IF MROWS @ 1+ MROWS ! EXIT THEN
  a u S>NUM IF MK-NUM M-PUT EXIT THEN
  a u CONTEXT @ SEARCH-WORDLIST IF a u MK-VAR M-PUT EXIT THEN
  a u TYPE ." ? " ABORT ;

\ ---------- матрицы ----------
: MAT-ALLOC { cnt -- a u }
  cnt 2 + CELLS ALLOC DUP cnt 2 + CELLS ;

: MAT-MAKE { cnt -- a u }
  cnt 2 + CELLS ALLOC
  DUP MBUF SWAP cnt CELLS MOVE
  DUP cnt 2 + CELLS ;

: m( ( -- a u )
  0 MCNT ! 0 MROWS !
  BEGIN PARSE-NAME DUP WHILE M-TOKEN REPEAT 2DROP
  MCNT @ 0= IF ." empty matrix" ABORT THEN
  MROWS @ 0= IF 1 MROWS ! THEN
  MCNT @ MROWS @ / MCOLS !
  MCNT @ MAT-MAKE
  2DUP + 8 - MCOLS @ SWAP !
  2DUP + 4 - MROWS @ SWAP ! ;

VARIABLE C1 VARIABLE S1 VARIABLE C2 VARIABLE S2
VARIABLE RA VARIABLE WID VARIABLE OS

: (( { a u -- b v }
  0 MCNT !
  BEGIN PARSE-NAME DUP WHILE M-TOKEN REPEAT 2DROP
  MCNT @ 0= IF a u EXIT THEN
  a u + 8 - @ C1 !  a u + 4 - @ S1 !  u 8 - 4 / OS !
  OS @ MCNT @ + 2 + CELLS ALLOC DUP RA !
  DUP a SWAP OS @ CELLS MOVE
  DUP OS @ CELLS + MBUF SWAP MCNT @ CELLS MOVE
  RA @ DUP OS @ MCNT @ + 2 + CELLS
  2DUP + 8 - C1 @ SWAP !
  2DUP + 4 - S1 @ 1+ SWAP ! ;

: M@ ( a i -- el ) CELLS + @ ;
: M! ( el a i -- ) CELLS + ! ;

: [t] { a u -- b v }
  a u + 8 - @ C1 !  a u + 4 - @ S1 !
  C1 @ S1 @ * MAT-ALLOC OVER RA !
  S1 @ 0 DO
    C1 @ 0 DO
      a I C1 @ * J + M@
      RA @ J S1 @ * I + M!
    LOOP
  LOOP
  RA @ DUP C1 @ S1 @ * 2 + CELLS
  2DUP + 8 - S1 @ SWAP !
  2DUP + 4 - C1 @ SWAP ! ;

: DOT { a aa row col -- el }
  0 MK-NUM
  C1 @ 0 DO
    a row C1 @ * I + M@
    aa I C2 @ * col + M@
    EL* EL+
  LOOP NORM-EL ;

: [*] { a u aa uu -- b v }
  a u + 8 - @ C1 !  a u + 4 - @ S1 !
  aa uu + 8 - @ C2 !  aa uu + 4 - @ S2 !
  C1 @ S2 @ <> IF ." invalid format" ABORT THEN
  S1 @ C2 @ * MAT-ALLOC OVER RA !
  S1 @ 0 DO
    C2 @ 0 DO
      a aa J I DOT
      RA @ J C2 @ * I + M!
    LOOP
  LOOP
  RA @ DUP S1 @ C2 @ * 2 + CELLS
  2DUP + 8 - C2 @ SWAP !
  2DUP + 4 - S1 @ SWAP ! ;

: ZIP { a u aa uu k -- b v }
  a u + 8 - @ C1 !  a u + 4 - @ S1 !
  aa uu + 8 - @ C2 !  aa uu + 4 - @ S2 !
  C1 @ C2 @ = S1 @ S2 @ = AND 0= IF ." invalid format" ABORT THEN
  C1 @ S1 @ * MAT-ALLOC OVER RA !
  C1 @ S1 @ * 0 DO
    a I M@ aa I M@ k CASE 0 OF EL+ ENDOF 1 OF EL- ENDOF 2 OF EL* ENDOF 3 OF EL/ ENDOF ENDCASE NORM-EL
    RA @ I M!
  LOOP
  RA @ DUP C1 @ S1 @ * 2 + CELLS
  2DUP + 8 - C1 @ SWAP !
  2DUP + 4 - S1 @ SWAP ! ;

: ZIPN { a u n k ord -- b v }
  a u + 8 - @ C1 !  a u + 4 - @ S1 !
  n MK-NUM OS !
  C1 @ S1 @ * MAT-ALLOC OVER RA !
  C1 @ S1 @ * 0 DO
    ord IF OS @ a I M@ ELSE a I M@ OS @ THEN k CASE 0 OF EL+ ENDOF 1 OF EL- ENDOF 2 OF EL* ENDOF 3 OF EL/ ENDOF ENDCASE NORM-EL
    RA @ I M!
  LOOP
  RA @ DUP C1 @ S1 @ * 2 + CELLS
  2DUP + 8 - C1 @ SWAP !
  2DUP + 4 - S1 @ SWAP ! ;

: [+] ( a1 u1 a2 u2 -- a3 u3 ) 0 ZIP ;
: [-] ( a1 u1 a2 u2 -- a3 u3 ) 1 ZIP ;
: [/] ( a1 u1 a2 u2 -- a3 u3 ) 3 ZIP ;
: [n+] ( n a u -- a3 u3 ) { n a u -- b v } a u n 0 0 ZIPN ;
: [n-] ( n a u -- a3 u3 ) { n a u -- b v } a u n 1 1 ZIPN ;
: [n*] ( n a u -- a3 u3 ) { n a u -- b v } a u n 2 0 ZIPN ;
: [+n] ( a u n -- a3 u3 ) { a u n -- b v } a u n 0 0 ZIPN ;
: [-n] ( a u n -- a3 u3 ) { a u n -- b v } a u n 1 0 ZIPN ;
: [*n] ( a u n -- a3 u3 ) { a u n -- b v } a u n 2 0 ZIPN ;
: [n/] ( n a u -- a3 u3 ) { n a u -- b v } a u n 3 1 ZIPN ;
: [/n] ( a u n -- a3 u3 ) { a u n -- b v } a u n 3 0 ZIPN ;

: [type] { a u }
  a u + 8 - @ C1 !  a u + 4 - @ S1 !
  0 WID !
  C1 @ S1 @ * 0 DO a I M@ 0 EL-W WID @ MAX WID ! LOOP
  S1 @ 0 DO CR
    C1 @ 0 DO
      a J C1 @ * I + M@
      DUP 0 EL-W WID @ SWAP - SPACES
      0 EL$
      SPACE
    LOOP
  LOOP CR ;

: M. ( a u -- ) [type] ;

: EVALMAT { a u }
  a u + 8 - @ C1 !  a u + 4 - @ S1 !
  C1 @ S1 @ * MAT-ALLOC OVER RA !
  C1 @ S1 @ * 0 DO
    a I M@ EV MK-NUM RA @ I M!
  LOOP
  RA @ DUP C1 @ S1 @ * 2 + CELLS
  2DUP + 8 - C1 @ SWAP !
  2DUP + 4 - S1 @ SWAP ! ;


\EOF

\ Примеры работы:
\
\   5 VALUE X
\   7 VALUE Y
\
\   m( X Y )
\   (( 1 X )
\   2VALUE M
\   M M.                  \ X  Y
\                         \ 1  X
\   M EVALMAT M.          \ 5 7
\                         \ 1 5
\
\   m( 1 2 )
\   (( 3 4 )
\   2VALUE N
\
\   M N [*] M.            \ X+3*Y 2*X+4*Y
\                         \ 1+3*X  2+4*X
\   M N [*] EVALMAT M.    \ 26 38
\                         \ 16 22
\
\   M M [+] M.            \ 2*X 2*Y
\                         \  2  2*X
\   3 M [n*] M.           \ 3*X 3*Y
\                         \  3  3*X
\   M 2 [/n] M.           \ X/2 Y/2
\                         \ 1/2 X/2
\
\   M [t] M.              \ транспонирование
\   M N [+] M.            \ сложение
\   M N [-] M.            \ вычитание
\   M N [/] M.            \ поэлементное деление
\   2 M [n-] M.           \ 2 минус элемент
\   M 2 [-n] M.           \ элемент минус 2
\
\ Элементом может быть число, имя слова-значения (VALUE/CONSTANT)
\ или выражение над ними операциями + - * /; результаты приводятся
\ к сумме мономов (скобки раскрываются, подобные собираются).
\ EVALMAT считает значения по текущим VALUE; M. печатает матрицу.
