\ stenoforth32

VARIABLE rnd1
: seed1 ( U -- ) rnd1 ! ;
: random1 ( -- U ) rnd1 @ 0x8088405 * 1+ DUP rnd1 ! ;
: choose1 ( U1 -- U2 ) \ U2 - RANDOM NUMBER FROM 0 TO U1
  random1 UM* NIP ;
: randomize1 DUP DAC=TSCP seed1 ;
