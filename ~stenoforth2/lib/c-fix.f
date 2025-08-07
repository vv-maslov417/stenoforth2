\ stenoforth32

MODULE: syn-fixpoint
m: a ABS ;                          m: A AGAIN ;                       m: # <> ;
m: b C@ ;                           m: B BEGIN ;                       m: ? IF ;
m: c EMIT ;                         m: C CASE ;                        m: _ ALLOT ;
m: d DUP ;                          m: D ?DO ;                         m: ^ XOR ;
m: e ELSE ;                         m: E ENDCASE ;                     m: & AND ;
m: f ENDOF ;                        m: F FILL ;                        m: ~ INVERT ;
m: g rnd ;                          m: G aDO ;                         m: | OR ;
m: h HERE ;                         m: H WITHIN ;                      m: % MOD ;
m: i 1+ ;                                                              m: : -> ;
m: j 1- ;                                                              m: ; EXIT ;
m: k KEY ;                          m: K COMPARE ;
m: l LSHIFT ;                       m: L LOOP ;
m: m MIN ;                          m: M MAX ;
m: n NEGATE ;                       m: N +LOOP ;
m: o OF ;                           m: O ERASE ;
m: p DEPTH ;                        m: P randomize ;
m: q sqrt ;                         m: Q LEAVE ;
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

: NOTFOUND u\ a\ a C@ '[' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN
` s| a 1+ u 1- aDO I 1 EVALUATE LOOP ` |s ;

MODULE: valuenames
m: 1 а\ ; m: 2 б\ ; m: 3 в\ ; m: 4 г\ ; m: 5 д\ ; m: 6 е\ ; m: 7 ё\ ; m: 8 ж\ ; m: 9 з\ ;
EXPORT
m: vs| {{ valuenames ;
m: |vs }} ;
;MODULE

: NOTFOUND u\ a\ a C@ '\' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN  \  \1234
  ` vs| a 1+ a 1+ u + 2- DO  I 1 EVALUATE -1 +LOOP ` |vs ;

m: |1 \1 ; m: |2 \12 ; m: |3 \123 ; m: |4 \1234 ; m: |5 \12345 ; m: |6 \123456 ; m: |7 \1234567 ; m: |8 \12345678 ; m: |9 \123456789 ;

MODULE: mvaluenames
m: 1 а% ; m: 2 б% ; m: 3 в% ; m: 4 г% ; m: 5 д% ; m: 6 е% ; m: 7 ё% ; m: 8 ж% ; m: 9 з% ;
EXPORT
m: mvs| {{ mvaluenames ;
m: |mvs }} ;
;MODULE

: NOTFOUND u\ a\ a C@ '%' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN  \  %1234
  ` mvs| a 1+ a 1+ u + 2- DO I 1 EVALUATE -1 +LOOP ` |mvs ;

m: |%1 %1 ; m: |%2 %12 ; m: |%3 %123 ; m: |%4 %1234 ; m: |%5 %12345 ; m: |%6 %123456 ; m: |%7 %1234567 ; m: |%8 %12345678 ; m: |%9 %123456789 ;