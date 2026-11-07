\ stenoforth32

m: aDO  OVER + SWAP ?DO ;     \ макрос ( BOUND ?DO )
m: I+  ( n -- )  R@ + RP@ ! ; \ макрос - увеличение счетчика цикла

: >=  @P=A? A=GE sA=sbA -A NIP ;
: <=  @P=A? A=LE sA=sbA -A NIP ;

: 0>= A|A A=GE sA=sbA -A ;
: 0<= A|A A=LE sA=sbA -A ;

: .0b ( n -- ) 2 BASE ! .0 DECIMAL ;
: .0h ( n -- ) HEX .0 DECIMAL ;

: .BL { n s }
    n ABS 0 <# #S #> s OVER - 0 MAX DUP
    IF 0 DO BL EMIT LOOP n 0< IF '-' EMIT THEN
    ELSE DROP THEN TYPE
;
: sqrt  ( n -- sqrt  ) DS>F FSQRT F>DS ;
: sqrt- ( n -- sqrt- ) DUP sqrt DUP DUP * ROT > -1 AND + ;

\ ( d1 d2 -- d3 ) младшие 64 разряда произведения, только целочисленные инструкции:
\ d3 = a_lo*b_lo + ((a_lo*b_hi + a_hi*b_lo) << 32);
\ старшая половина a_lo*b_lo берётся у знакового IMUL и правится на знаки a_lo и b_lo
: D*
  $ 4 C=@P  C*@P                    \ ECX = a_hi * b_lo (мл.)
  D=A  $ 8 D*@P  C+D                \ ECX = сумма перекрёстных членов
  $ 8 B=@P  A=B  S=@P  *S           \ EDX:EAX = a_lo * b_lo (знаковое)
  $ 8 @P=D  $ 4 @P=C                \ старшая половина и перекрёстные члены -> в стек
  D=B  $ 1F C=#  D>>  D*S  $ 8 @P+D \ + b_lo, если a_lo < 0
  D=S  $ 1F C=#  D>>  D*B  $ 8 @P+D \ + a_lo, если b_lo < 0
  $ 8 D=@P  $ 8 @P=A  A=D           \ младшая половина на место, старшая в EAX
  $ 4 A+@P  $ 8 Pa                  \ + перекрёстные члены, убрать 2 ячейки
;
\ ( d1 d2 -- d3 ) целочисленное деление: d3 = d1 / d2 с усечением к нулю.
\ делитель < 2^32 делится двумя DIV, больший - сдвиго-вычитанием по разрядам
m: DIVC [ 0xF7 C, 0xF1 C, ] ;          \ div ecx  ( edx:eax / ecx )
: D/
  B=A                                  \ EBX = b_hi (нужен для знака)
  $ -4 Pa                              \ ячейка [EBP] под знак результата
  $ 8 A=@P  A^B                        \ EAX = a_hi xor b_hi
  $ 1F C=#  A>>                        \ EAX = 1, если знаки разные
  @P=A                                 \ знак результата
  $ 8 D=@P  $ 1F C=#  D>>  -D          \ EDX = маска знака a (0 / -1)
  $ 8 S=@P  S^D                        \ ESI = a_hi ^ маска
  $ C A=@P  A^D  A-D                   \ EAX = (a_lo ^ маска) - маска, CF
  $ C @P=A                             \ a_lo = |a_lo|
  Sc-D                                 \ ESI = (a_hi ^ маска) - маска - CF
  $ 8 @P=S                             \ a_hi = |a_hi|
  D=B  $ 1F C=#  D>>  -D               \ EDX = маска знака b
  A=B  A^D                             \ EAX = b_hi ^ маска
  $ 4 S=@P  S^D  S-D                   \ ESI = (b_lo ^ маска) - маска, CF
  $ 4 @P=S                             \ b_lo = |b_lo|
  Ac-D  B=A                            \ EBX = |b_hi|
  $ 0 B=#?  L1 J<>                     \ делитель >= 2^32 -> медленный путь
  $ 4 C=@P                             \ ECX = b_lo
  $ 8 A=@P  D^D  DIVC                  \ EAX = старшая часть частного
  B=A                                  \ EBX = q_hi
  $ C A=@P  DIVC                       \ EAX = младшая часть частного
  L7 JMP
L1:
  $ 8 D=@P  A^A                        \ R = a_hi (частное < 2^32)
  $ 20 C=#  $ 8 @P=C                   \ счётчик разрядов = 32
  C^C                                  \ q = 0
  $ 4 S=@P                             \ ESI = b_lo
L2:
  $ 4 @P=C                             \ сохранить q (CL нужен для сдвига)
  $ 1 C=#  $ C @P<<                    \ a_lo <<= 1, CF = старший разряд
  $ 4 C=@P                             \ восстановить q
  Dc+D  Ac+A                           \ R = R*2 + разряд делимого
  L3 JC                              \ переполнение R -> R >= b
  D-S  Ac-B                            \ R - b
  L5 JB                              \ R < b: вернуть R
  L4 JMP
L3:
  D-S  Ac-B                            \ старшие разряды уже не нужны
L4:
  C+C  $ 1 C|#                         \ q = q*2 + 1
  L6 JMP
L5:
  D+S  Ac+B                            \ вернуть R
  C+C                                  \ q = q*2
L6:
  $ 8 @P--
  L2 J<>
  A=C  B^B                             \ q_lo в EAX, q_hi = 0
L7:
  $ 0 D=@P  -D                         \ EDX = маска знака результата
  C=B  C^D                             \ ECX = q_hi ^ маска
  A^D  A-D                             \ EAX = (q_lo ^ маска) - маска, CF
  $ C @P=A                             \ q_lo на место
  Cc-D                                 \ ECX = q_hi с учётом заёма
  A=C                                  \ EAX = q_hi
  $ C Pa                               \ убрать лишние ячейки
;

: DOR     ( d1 d2 -- d3)  D=@P $ 8 Pa $ -4 A|@P @P|D ;
: DXOR    ( d1 d2 -- d3)  D=@P $ 8 Pa $ -4 A^@P @P^D ;
: DAND    ( d1 d2 -- d3)  D=@P $ 8 Pa $ -4 A&@P @P&D ;
: DINVERT ( d1 -- d2 )    @P~ A~ ;
: DLSHIFT ( d n -- 'd ) $ 4 D=@P $ 1 C=# D>> $ 1F C=# C-A D>> C=A @P<< $ 4 @P<< @P|D DROP ;
: DRSHIFT ( d n -- 'd ) D=@P $ 1 C=# D<< $ 1F C=# C-A D<< C=A @P>> $ 4 @P>> $ 4 @P|D DROP ;
: D0<>    ( d -- f ) D0= INVERT ;
: 1+c!    ( c-addr --) @bA++ DROP ;
: 1-!     ( addr --) @A-- DROP ;
: 1-c!    ( c-addr --) @bA-- DROP ;
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

: s. DEPTH .SN CR ;

m: 2\21    SWAP ;
m: 2%1     OVER ;
m: 2\212   TUCK ;
m: 3\231    ROT ;
m: 3\312   -ROT ;
m: 4%12   2OVER ;
m: 4\3412 2SWAP ;



\EOF
\ повторение исполнения слова n раз
I: nrep ( n -- )
   STATE @ 0=
   IF   ' { xt } 0 DO xt EXECUTE LOOP
   ELSE 0 LIT, ` DO PARSE-NAME EVALUATE ` LOOP
   THEN
;
