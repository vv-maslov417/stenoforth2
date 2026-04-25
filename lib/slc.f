\ stenoforth32
0 value vdn
MODULE: syn-slc
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
m: y $ -4 @P=A A^A $ -4 Pa ; ( 0 )  m: Y $ -4 @P=A $ 1 A=# $ -4 Pa ; ( 1 )
m: z 0<> ;                          m: Z 0= ;
m: 1 vdn       @ ;
m: 2 vdn   4 - @ ;
m: 3 vdn   8 - @ ;
m: 4 vdn  12 - @ ;
m: 5 vdn  16 - @ ;
m: 6 vdn  20 - @ ;
m: 7 vdn  24 - @ ;
m: 8 vdn  28 - @ ;
m: 9 vdn  32 - @ ;
EXPORT
m: sc| {{ syn-slc ;
m: |sc }} ;
;MODULE



: NOTFOUND u\ a\ a c@ '0' - 1 9 1+ within  a 1+ c@ '/' = and u 2 > and 0= if a u NOTFOUND EXIT then
  ` sc| a c@ 48 - 4 * sp@ + TO vdn a 2+ u 2- ado i 1 evaluate loop ` |sc ;

m: ssq 2/1122 ; see ssq

1 2 3 4 5 6 7 ssq
