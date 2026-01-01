\ stenoforth32

m: aDO  OVER + SWAP ?DO ;     \ макрос ( BOUND ?DO )
m: I+  ( n -- )  R@ + RP@ ! ; \ макрос - увеличение счетчика цикла

: >=  @P=A? A=GE sA=sbA -A NIP ;
: <=  @P=A? A=LE sA=sbA -A NIP ;

: 0>= A|A A=GE sA=sbA -A ;
: 0<= A|A A=LE sA=sbA -A ;

: .0b ( n -- ) 2 BASE ! .0 DECIMAL ;
: .0h ( n -- ) HEX .0 DECIMAL ;
: .BL ( n -- ) >R 0 <# #S R@ SIGN '-' EMIT #> R> OVER SWAP - 0 MAX DUP IF 0 DO BL EMIT LOOP ELSE DROP THEN TYPE ;

: sqrt  ( n -- sqrt  ) DS>F FSQRT F>DS ;
: sqrt- ( n -- sqrt- ) DUP sqrt DUP DUP * ROT > -1 AND + ;

: D*  D>F D>F F* F>D ;
: D/  2SWAP D>F D>F F/ F>D ;

: DOR     ( d1 d2 -- d3)  D=@P $ 8 Pa $ -4 A|@P @P|D ;
: DXOR    ( d1 d2 -- d3)  D=@P $ 8 Pa $ -4 A^@P @P^D ;
: DAND    ( d1 d2 -- d3)  D=@P $ 8 Pa $ -4 A&@P @P&D ;
: DINVERT ( d1 -- d2 )    @P~ A~ ;
: DLSHIFT ( d n -- 'd ) $ 4 D=@P $ 32 C=# C-A D>> C=A @P<< $ 4 @P<< @P|D DROP ;
: DRSHIFT ( d n -- 'd ) D=@P $ 32 C=# C-A D<< C=A @P>> $ 4 @P>> $ 4 @P|D DROP ;
: D0<>    ( d -- f ) D0= INVERT ;
: 1-!     ( addr --) @A-- DROP ;
: -!      ( n addr -- ) D=@P -D @A+D $ 4 A=@P $ 8 Pa ;

\ убрать со стека n байтов
: SPDROP ( p*n n -- )
  P+A DROP
;
\ переместить n байтов со стека в память
: SPMOVE ( p*n addr n -- p*n )
  $ 4 B=aP D=A D+@P
  L1: $ -4 Da C=@B @D=C $ 4 Ba $ 4 A-#
  L1 J0<> 2DROP
;
\ a n -- a n
: SP>MEM CELLS { a n } a n SPMOVE n SPDROP a n ;
