\ stenoforth32

: randomize1 DUP DAC=TSCP SEED ;

create arr 1024 allot

: X^2  0e X$ arr 1024 erase
randomize1
1024 256 * 4 * 0 do 256 choose dup . key drop cells arr + 1+! cell +loop
1024 0 do arr i + @ 1024 - dup * ds>f 1024 ds>f f/ X f+ -> X cell +loop X f.
; X^2
: t-rnd1 randomize1
  1024 256 * 4 * 0 do 256 choose drop cell +loop ;
: t-rnd randomize
  1024 256 * 4 * 0 do 256 choose  drop cell +loop ;



seet t-rnd1
seet t-rnd
