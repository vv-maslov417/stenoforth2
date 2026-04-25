\ stenoforth32

m: beg-nmb a u + 1- c@ = if a u 1- number? 3\31 nmb\
   else 0 decimal then u 1 > and ;
m: end-nmb nmb >CS decimal ;

rec: 'h' hex        beg-nmb  gen: end-nmb ;
rec: 'd' decimal    beg-nmb  gen: end-nmb ;
rec: 'b' 0x2 base ! beg-nmb  gen: end-nmb ;

\ saving registers in memory
m: A>a [ a) a >CS ] @=A ; m: B>b [ b) b >CS ] @=B ;
m: C>c [ c) c >CS ] @=C ; m: D>d [ d) d >CS ] @=D ;
m: S>s [ s) s >CS ] @=S ; m: T>t [ t) t >CS ] @=T ;
m: P>p [ p) p >CS ] @=P ; m: X>x [ x) x >CS ] @=X ;
m: p=P [ dup A=P p1\ ] ;
m: A>a1 [ a1) a1 >CS ] @=A ; m: B>b1 [ b1) b1 >CS ] @=B ;
m: C>c1 [ c1) c1 >CS ] @=C ; m: D>d1 [ d1) d1 >CS ] @=D ;
m: S>s1 [ s1) s1 >CS ] @=S ; m: T>t1 [ t1) t1 >CS ] @=T ;

\ restoring registers from memory
m: a>A [ a >CS ] A=@ ; m: a>B [ a >CS ] B=@ ; m: a>C [ a >CS ] C=@ ;
m: a>D [ a >CS ] D=@ ; m: a>S [ a >CS ] S=@ ; m: a>T [ a >CS ] T=@ ;
m: b>A [ b >CS ] A=@ ; m: b>B [ b >CS ] B=@ ; m: b>C [ b >CS ] C=@ ;
m: b>D [ b >CS ] D=@ ; m: b>S [ b >CS ] S=@ ; m: b>T [ b >CS ] T=@ ;
m: c>A [ c >CS ] A=@ ; m: c>B [ c >CS ] B=@ ; m: c>C [ c >CS ] C=@ ;
m: c>D [ c >CS ] D=@ ; m: c>S [ c >CS ] S=@ ; m: c>T [ c >CS ] T=@ ;
m: d>A [ d >CS ] A=@ ; m: d>B [ d >CS ] B=@ ; m: d>C [ d >CS ] C=@ ;
m: d>D [ d >CS ] D=@ ; m: d>S [ d >CS ] S=@ ; m: d>T [ d >CS ] T=@ ;
m: s>A [ s >CS ] A=@ ; m: s>B [ s >CS ] B=@ ; m: s>C [ s >CS ] C=@ ;
m: s>D [ s >CS ] D=@ ; m: s>S [ s >CS ] S=@ ; m: s>T [ s >CS ] T=@ ;
m: t>A [ t >CS ] A=@ ; m: t>B [ t >CS ] B=@ ; m: t>C [ t >CS ] C=@ ;
m: t>D [ t >CS ] D=@ ; m: t>S [ t >CS ] S=@ ; m: t>T [ t >CS ] T=@ ;
m: p>A [ p >CS ] A=@ ; m: p>B [ p >CS ] B=@ ; m: p>C [ p >CS ] C=@ ;
m: p>D [ p >CS ] D=@ ; m: p>S [ p >CS ] S=@ ; m: p>T [ p >CS ] T=@ ;
m: p>P [ p >CS ] P=@ ; m: p>X [ p >CS ] X=@ ;
m: a1>A [ a1 >CS ] A=@ ; m: b1>B [ b1 >CS ] B=@ ; m: c1>C [ c1 >CS ] C=@ ;
m: d1>D [ d1 >CS ] D=@ ; m: s1>S [ s1 >CS ] S=@ ; m: t1>T [ t1 >CS ] T=@ ;
m: s1>C [ s1 >CS ] C=@ ; m: P=p [ p1 >CS ] A=# ;

\ stack local variables
: uc>rg 0x758B W, C, ;
: rg>da 0x3589 W,  , ;
: dpad  0xBD   C,  , ;

: sman1 si1\ 1703792 so1\ 1 ?DO si1 uc>rg si1 4 - -> si1 so1 rg>da so1 4 - -> so1 LOOP so1 4 + dpad ;

rec: '_' a c@ = a 1+ u 1- number? nip nip and u 1 > and u 4 < and
gen: STATE @ 0= IF HERE hered\ THEN a 1+ u 1- number? 2drop n1\
     n1 n1 2- 4 * sman1 STATE @ 0= IF RET, hered execute THEN ;
(
: uc>rg 0x758B W, C, ;
: rg>dc 0x7589 W, C, ;
: dpdd  0x6D8D W, C, ;
: rg>da 0x3589 W,  , ;
: dpad  0xBD   C,  , ;

\ m/n m - число параметров убрать снизу n - число параметров оставить сверху
: sman  si\ so\ 1 ?do si uc>rg si 4 - -> si so rg>dc so 4 - -> so loop so 4 + dpdd ;
rec: 0 spos '1' '9' 1+ within '/' 1 spos? and 2 spos '1' '9' 1+ within and u 3 = and
gen: 0 spos '0' - m\ 2 spos '0' - n\  n n m + 2- 4 * n 2- 4 * sman ;

: NOTFOUND u\ a\ a C@ '/' = a 1+ C@ '0' - 1 9 1+ WITHIN AND u 2 > AND 0= IF a u NOTFOUND EXIT THEN
          ` zf| S0 @ SP@ - a 1+ C@ '0' - 4 * <
                IF ." depth incorrect" EXIT
                ELSE SP@ a 1+ C@ '0' - 1- 4 * + TO agrn
                THEN
                a 2+ u 2- aDO  I C@ '`' <> IF I 1 EVALUATE
                ELSE I 1+ 1 NUMBER? 2DROP LIT, 1 I+ THEN  LOOP ` |zf ;
)
