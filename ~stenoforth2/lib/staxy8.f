\ staxy8: n\p1..pk n=6..8, k=1..16. result[i]=old[p_i] (1=низ).
VARIABLE PERMN VARIABLE PERMK VARIABLE PERML VARIABLE PERMC VARIABLE PERMI
VARIABLE PERMD0 VARIABLE PERMPROG VARIABLE PERMBUSY
CREATE PERMP 17 CELLS ALLOT
CREATE PERMCY 17 CELLS ALLOT
CREATE PERMV 17 CELLS ALLOT
CREATE REGT 3 , 1 , 2 , 6 ,
VARIABLE pstart
: modrmx ( r -- b ) 3 lshift 0x45 or ;
: e-mov-mem ( r o -- ) 0x8B C, swap modrmx C, C, ;
: e-sto-mem ( r o -- ) 0x89 C, swap modrmx C, C, ;
: e-mov-reg ( d s -- ) 0x8B C, swap 3 lshift or 0xC0 or C, ;
: e-lea ( o -- ) 0x8D C, 0x6D C, C, ;
: rgi ( i -- reg ) 1- CELLS REGT + @ ;
: RD ( s r -- ) OVER PERMN @ = IF SWAP DROP DUP 0= IF DROP EXIT THEN 0 e-mov-reg
  ELSE SWAP PERMN @ 1- SWAP - 4 * e-mov-mem THEN ;
: WR ( s r -- ) OVER PERMN @ = IF SWAP DROP DUP 0= IF DROP EXIT THEN 0 SWAP e-mov-reg
  ELSE SWAP PERMN @ 1- SWAP - 4 * e-sto-mem THEN ;
\ слоты в нотации ПОСЛЕ push: offset (n-s)*4
: RDs ( s r -- ) SWAP PERMN @ SWAP - 4 * e-mov-mem ;
: WRs ( s r -- ) SWAP PERMN @ SWAP - 4 * e-sto-mem ;

: PERMCYC
  PERMN @ 1+ 0 ?DO 0 PERMV I CELLS + ! LOOP
  PERMN @ 1+ 1 ?DO
    PERMV I CELLS + @ 0= IF
      0 PERML ! I PERMC !
      BEGIN 1 PERMV PERMC @ CELLS + !  PERMC @ PERMCY PERML @ CELLS + !
            PERML @ 1+ PERML !  PERMP PERMC @ CELLS + @ PERMC !  PERMC @ I = UNTIL
      PERML @ 1 > IF
        0 CELLS PERMCY + @ 3 RD
        PERML @ 1- 0 ?DO I 1+ CELLS PERMCY + @ 1 RD  I CELLS PERMCY + @ 1 WR LOOP
        PERML @ 1- CELLS PERMCY + @ 3 WR
      THEN
    THEN
  LOOP ;

: PERMREG
  PERMK @ 1 ?DO I rgi PERMP I CELLS + @ DUP PERMN @ = IF DROP 0 e-mov-reg ELSE PERMN @ 1- SWAP - 4 * e-mov-mem THEN LOOP
  PERMP PERMK @ CELLS + @ DUP PERMN @ = IF DROP ELSE PERMN @ 1- SWAP - 4 * 0 SWAP e-mov-mem THEN
  PERMK @ 1 ?DO I rgi PERMN @ 1- I - 4 * e-sto-mem LOOP
  PERMN @ PERMK @ - 4 * e-lea ;

\ k>5: in-place. Источники только в слотах 1..n. Топопорядок + циклы(temp).
: PERMOPT
  0 -4 e-sto-mem  -4 e-lea
  PERMP PERMK @ CELLS + @ 0 RDs
  PERMK @ PERMN @ 1+ > IF
    PERMK @ PERMN @ 1+ DO PERMP I CELLS + @ 3 RDs  I 3 WRs LOOP
  THEN
  PERMN @ 1+ 0 ?DO 0 PERMV I CELLS + ! LOOP
  PERMK @ 1- PERMN @ MIN 1+ 1 ?DO 1 PERMV I CELLS + ! LOOP
  BEGIN
    0 PERMPROG !
    PERMK @ 1- PERMN @ MIN 1+ 1 ?DO
      PERMV I CELLS + @ IF
        I PERMP I CELLS + @ = IF 0 PERMV I CELLS + ! 1 PERMPROG !
        ELSE
          1 PERMBUSY ! I PERMI !
          PERMK @ 1- PERMN @ MIN 1+ 1 ?DO
            PERMV I CELLS + @ IF PERMI @ PERMP I CELLS + @ = IF 0 PERMBUSY ! THEN THEN
          LOOP
          PERMBUSY @ IF
            PERMP PERMI @ CELLS + @ 3 RDs  PERMI @ 3 WRs
            0 PERMV PERMI @ CELLS + ! 1 PERMPROG !
          THEN
        THEN
      THEN
    LOOP
    PERMPROG @ 0= IF
      0 PERMBUSY ! 0 PERMI !
      PERMK @ 1- PERMN @ MIN 1+ 1 ?DO PERMV I CELLS + @ IF I PERMI ! 1 PERMBUSY ! THEN LOOP
      PERMBUSY @ IF
        PERMI @ PERMD0 !  PERMI @ 2 RDs  0 PERMPROG !
        BEGIN
          PERMP PERMI @ CELLS + @ PERMD0 @ =
          IF  PERMI @ 2 WRs  0 PERMV PERMI @ CELLS + ! 1 PERMPROG !
          ELSE PERMP PERMI @ CELLS + @ 3 RDs  PERMI @ 3 WRs  0 PERMV PERMI @ CELLS + !
               PERMP PERMI @ CELLS + @ PERMI !
          THEN
          PERMPROG @
        UNTIL
      THEN
    THEN
    0 PERMBUSY !
    PERMK @ 1- PERMN @ MIN 1+ 1 ?DO PERMV I CELLS + @ IF 1 PERMBUSY ! THEN LOOP
    PERMBUSY @ 0=
  UNTIL
  PERMN @ PERMK @ - 1+ 4 * e-lea ;

: NOTFOUND u\ a\
  a C@ '6' '8' 1+ WITHIN 0= IF a u NOTFOUND EXIT THEN
  a 1+ C@ '\' <> IF a u NOTFOUND EXIT THEN
  u 2 - 0> 0= IF a u NOTFOUND EXIT THEN
  u 2 - 16 > IF a u NOTFOUND EXIT THEN
  a C@ '0' - PERMN !
  u 2 - PERMK !
  STATE @ 0= IF HERE pstart ! THEN
  PERMK @ 1+ 1 ?DO a 2 + I 1- + C@ '0' - PERMP I CELLS + ! LOOP
  PERMK @ PERMN @ = IF PERMCYC ELSE PERMK @ 5 <= IF PERMREG ELSE PERMOPT THEN THEN
  STATE @ 0= IF RET, pstart @ EXECUTE THEN ;
: pusto8 ;
