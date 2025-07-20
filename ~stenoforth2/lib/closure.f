\ stenoforth32

\ position(1..n)  -- char
m: pos>char  a 1- + C@ ;
\ position char -- flag
m: pos-char? swap pos>char = ;

CREATE StrOut 255 ALLOT 0 VALUE dso
: dso++ dso 1+ TO dso ;
: $+  StrOut dso + C! dso++ ;
: s$+ >R StrOut dso + R@ MOVE R> dso + TO dso ;
: n$+ S>D (D.) s$+ BL $+ ;
: tt-xt ( any xt -- any ) STATE @ IF COMPILE, ELSE EXECUTE THEN ;
I: $"  ( "ccc<quote>" -- |sd ) ['] S" EXECUTE  ['] s$+ tt-xt ;

m: rec: 0 WARNING ! : NOTFOUND u\ a\ ;
m: gen: 0= IF a u NOTFOUND EXIT THEN
   StrOut 255 ERASE 0 TO dso ;
\ state @ ( false - execute  true - evaluate )
: erg HERE h\ EVALUATE
   STATE @ 0= IF ret, h EXECUTE h DP ! THEN ;
: esd StrOut dso HERE h\ EVALUATE
   STATE @ 0= IF ret, h EXECUTE h DP ! THEN ;

\ непоср.значение переменной name' на стек
rec: a C@ ''' <> a u + 1- C@ ''' = AND
gen: [ 16 ] ar] lvoc a u 1- lsearch 2DROP 7 + C@ typ\
     a ar u 1- MOVE '`' ar u + 1- C! ar u EVALUATE
     typ 3 > IF S" FLITERAL" EVALUATE ELSE
     typ 3 < IF S" LITERAL"  EVALUATE ELSE
     typ 3 = IF S" 2LITERAL" EVALUATE THEN
     THEN THEN ;

rec: lvoc a u lsearch fl\ um\ am\
     fl am um + 6 + C@ 8 = AND
gen: am um + 1+ @ EXECUTE ;

: closure ;
