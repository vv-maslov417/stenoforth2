\ stenoforth32

VARIABLE rand
: seed ( U -- ) rand ! ;
: random ( -- U ) rand @ 0x8088405 * 1+ DUP rand ! ;
: rnd ( U1 -- U2 ) \ U2 - RANDOM NUMBER FROM 0 TO U1
  random UM* NIP ;
: randomize DUP DAC=TSCP seed ;
