MODULE: syn-fixp
m: a ABS ;                          m: A AGAIN ;                       m: # <> ;
m: b C@ ;                           m: B BEGIN ;                       m: ? IF ;
m: c EMIT ;                         m: C CASE ;                        m: _ ALLOT ;
m: d DUP ;                          m: D ?DO ;                         m: ^ XOR ;
m: e ELSE ;                         m: E ENDCASE ;                     m: & AND ;
m: f ENDOF ;                        m: F FILL ;                        m: ~ INVERT ;
m: g +! ;                           m: G aDO ;                         m: | OR ;
m: h HERE ;                         m: H WITHIN ;                      m: % MOD ;
m: i 1+ ;                                                              m: : in ;
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
m: v CHOOSE ;                       m: V MOVE ;
m: w C! ;                           m: W WHILE ;
m: x DROP ;                         m: X EXECUTE ;
m: y $ -4 @P=A A^A $ -4 Pa ;        m: Y $ -4 @P=A $ 1 A=# $ -4 Pa ;
m: z 0<> ;                          m: Z 0= ;
m: 1   ; m: 2 ¡ ; m: 3 ¢ ; m: 4 £ ; m: 5 ¤ ; m: 6 ¥ ; m: 7 ñ ; m: 8 ¦ ; m: 9 § ;
EXPORT
m: sfp| {{ syn-fixp ;
m: |sfp }} ;
;MODULE

: NOTFOUND u\ a\ a C@ '/' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN
  ` sfp| a 1+ u 1- aDO I 1 EVALUATE LOOP ` |sfp ;
\ : NOTFOUND u\ a\ a C@ '[' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN
\ ` s| a 1+ u 1- aDO I C@ ''' <> IF I 1 EVALUATE ELSE I 1+ 1 NUMBER? 2DROP LIT, 1 I+ THEN LOOP ` |s ;

MODULE: valuen
m: 1 _  ; m: 2 _¡ ; m: 3 _¢ ; m: 4 _£ ; m: 5 _¤ ; m: 6 _¥ ; m: 7 _ñ ; m: 8 _¦ ; m: 9 _§ ;
EXPORT
m: vsn| {{ valuen ;
m: |vsn }} ;
;MODULE

: NOTFOUND u\ a\ a C@ '%' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN  \  \1234
  ` vsn| a 1+ a 1+ u + 2- DO  I 1 EVALUATE -1 +LOOP ` |vsn ;

m: ~1 %1 ; m: ~2 %12 ; m: ~3 %123 ; m: ~4 %1234 ; m: ~5 %12345 ; m: ~6 %123456 ; m: ~7 %1234567 ; m: ~8 %12345678 ; m: ~9 %123456789 ;
