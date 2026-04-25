\ stenoforth32

MODULE: syn-fixpoint
m: a ABS ;                          m: A AGAIN ;                       m: # <> ;
m: b C@ ;                           m: B BEGIN ;                       m: ? IF ;
m: c EMIT ;                         m: C CASE ;                        m: _ ALLOT ;
m: d DUP ;                          m: D ?DO ;                         m: ^ XOR ;
m: e ELSE ;                         m: E ENDCASE ;                     m: & AND ;
m: f ENDOF ;                        m: F FILL ;                        m: ~ INVERT ;
m: g +! ;                           m: G aDO ;                         m: | OR ;
m: h HERE ;                         m: H WITHIN ;                      m: % MOD ;
m: i 1+ ;                                                              m: : -> ;
m: j 1- ;                                                              m: ; EXIT ;
m: k KEY ;                          m: K COMPARE ;                     m: \ CR ;
m: l LSHIFT ;                       m: L LOOP ;                        m: ' C, ;
m: m MIN ;                          m: M MAX ;                         m: " BL ;
m: n NEGATE ;                       m: N +LOOP ;                       m: ` S, ;
m: o OF ;                           m: O ERASE ;
m: p DEPTH ;                        m: P randomize ;
m: q 1+! ;                          m: Q LEAVE ;
m: r RSHIFT ;                       m: R REPEAT ;
m: s I+ ;                           m: S SEARCH ;
m: t THEN ;                         m: T TRUE ;
m: u EVALUATE ;                     m: U UNTIL ;
m: v 2* ;                           m: V MOVE ;
m: w C! ;                           m: W WHILE ;
m: x DROP ;                         m: X EXECUTE ;
m: y $ -4 @P=A A^A $ -4 Pa ;        m: Y $ -4 @P=A $ 1 A=# $ -4 Pa ;
m: z 0<> ;                          m: Z 0= ;
m: 1 а ; m: 2 б ; m: 3 в ; m: 4 г ; m: 5 д ; m: 6 е ; m: 7 ё ; m: 8 ж ; m: 9 з ;
EXPORT
m: s| {{ syn-fixpoint ;
m: |s }} ;
;MODULE

\ : NOTFOUND u\ a\ a C@ '[' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN
\ ` s| a 1+ u 1- aDO I 1 EVALUATE LOOP ` |s ;
: NOTFOUND u\ a\ a C@ '[' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN
` s| a 1+ u 1- aDO I C@ ''' <> IF I 1 EVALUATE ELSE I 1+ 1 NUMBER? 2DROP LIT, 1 I+ THEN LOOP ` |s ;

MODULE: valuenames
m: 1 а\ ; m: 2 б\ ; m: 3 в\ ; m: 4 г\ ; m: 5 д\ ; m: 6 е\ ; m: 7 ё\ ; m: 8 ж\ ; m: 9 з\ ;
EXPORT
m: vs| {{ valuenames ;
m: |vs }} ;
;MODULE

: NOTFOUND u\ a\ a C@ '\' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN  \  \1234
  ` vs| a 1+ a 1+ u + 2- DO  I 1 EVALUATE -1 +LOOP ` |vs ;

m: |1 \1 ; m: |2 \12 ; m: |3 \123 ; m: |4 \1234 ; m: |5 \12345 ; m: |6 \123456 ; m: |7 \1234567 ; m: |8 \12345678 ; m: |9 \123456789 ;
m: |21 |2 0 \3 ; m: |22 |2 0. \34 ; m: |23 |2 0. 0 \345 ; m: |24 |2 0. 0. \3456 ; m: |25 |2 0. 0. 0 \34567 ; m: |26 |2 0. 0. 0. \345678 ;
m: |31 |3 0 \4 ; m: |32 |3 0. \45 ; m: |33 |3 0. 0 \456 ; m: |34 |3 0. 0. \4567 ; m: |35 |3 0. 0. 0 \45678 ; m: |36 |3 0. 0. 0. \456789 ;
m: |41 |4 0 \5 ; m: |42 |4 0. \56 ; m: |43 |4 0 0. \567 ; m: |44 |4 0. 0. \5678 ; m: |45 |4 0. 0. 0 \56789 ; m: |27 |2 0. 0. 0. 0 \3456789 ;
m: |51 |5 0 \6 ; m: |52 |5 0. \67 ; m: |53 |5 0 0. \678 ; m: |54 |5 0. 0. \6789 ;
m: |61 |6 0 \7 ; m: |62 |6 0. \78 ; m: |63 | 0 0.  \789 ;
m: |71 |7 0 \8 ; m: |72 |7 0. \89 ;
m: |81 |8 0 \9 ;

MODULE: mvaluenames
m: 1 а% ; m: 2 б% ; m: 3 в% ; m: 4 г% ; m: 5 д% ; m: 6 е% ; m: 7 ё% ; m: 8 ж% ; m: 9 з% ;
EXPORT
m: mvs| {{ mvaluenames ;
m: |mvs }} ;
;MODULE

: NOTFOUND u\ a\ a C@ '%' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN  \  %1234
  ` mvs| a 1+ a 1+ u + 2- DO I 1 EVALUATE -1 +LOOP ` |mvs ;

m: |%1 %1 ; m: |%2 %12 ; m: |%3 %123 ; m: |%4 %1234 ; m: |%5 %12345 ; m: |%6 %123456 ; m: |%7 %1234567 ; m: |%8 %12345678 ; m: |%9 %123456789 ;
