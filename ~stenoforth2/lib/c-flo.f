\ stenoforth32

MODULE: fsynonyms
m: a FABS ;
m: b FLOG2 ;
m: c FCOS ;
m: d FDUP ;
m: e ELSE ;
m: f DS>F ;
m: g FLOG ;
m: h HERE ;
m: i F1+ ;
m: j 1e F- ; \ F1-
m: k FACOS ;
m: l FLN ;
m: m FMIN ;
m: n FNEGATE ;
m: o FDEPTH ;
m: p F**2 ;
m: q FSQRT ;
m: r FASIN ;
m: s FSIN ;
m: t THEN ;
m: u FATAN ;
m: v 2e F/ ; \ F2/
m: w 2e F* ; \ F2*
m: x FDROP ;
m: y $ -4 @P=A A^A $ -4 Pa ; \ 0
m: z F0= INVERT ;    \ F0<>

m: A AGAIN ;
m: B BEGIN ;
m: C CASE ;
m: D ?DO ;
m: E ENDCASE ;
m: F D>F ;
m: G aDO ;
\ m: H ;
m: L LOOP ;
m: M FMAX ;
m: N +LOOP ;
\ m: O FDEPTH ;
m: P FPI ;
m: Q LEAVE ;
m: R REPEAT ;
m: S F>DS ;
m: T FTAN ;
m: U UNTIL ;
m: W WHILE ;
m: X EXP ;
m: Y $ -4 @P=A $ 1 A=# $ -4 Pa ;  \ 1
m: Z F0= ;

m: @ F@ ;
m: ! F! ;
m: + F+ ;
m: - F- ;
m: * F* ;
m: / F/ ;
m: = F= ;
m: # F= INVERT ;
m: ? IF ;
m: < F< ;
m: > FOVER FOVER F< F= OR 0= ;
m: ~ F~ ;
m: ^ F** ;
m: . F. ;
m: : -> ;
m: ; EXIT ;
m: 1 Г ; m: 2 Д ; m: 3 Е ; m: 4 Ё ; m: 5 Ж ; m: 6 З ; m: 7 И ; m: 8 Й ; m: 9 К ;
EXPORT
m: fs| {{ fsynonyms ;
m: |fs }} ;
;MODULE

: NOTFOUND u\ a\ a C@ '{' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN
` fs| a 1+ u 1- aDO I 1 EVALUATE LOOP ` |fs ;

MODULE: fvaluenames
m: 1 Г$ ; m: 2 Д$ ; m: 3 Е$ ; m: 4 Ё$ ; m: 5 Ж$ ; m: 6 З$ ; m: 7 И$ ; m: 8 Й$ ; m: 9 К$ ;
EXPORT
m: vf| {{ fvaluenames ;
m: |vf }} ;
;MODULE


: NOTFOUND u\ a\ a C@ '$' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN
  ` vf| a 1+ a 1+ u + 2- DO I 1 EVALUATE -1  +LOOP ` |vf ;

MODULE: mfvaluenames
m: 1 Г; ; m: 2 Д; ; m: 3 Е; ; m: 4 Ё; ; m: 5 Ж; ; m: 6 З; ; m: 7 И; ; m: 8 Й; ; m: 9 К; ;
EXPORT
m: mvf| {{ mfvaluenames ;
m: |mvf }} ;
;MODULE

: NOTFOUND u\ a\ a C@ ';' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN
  ` mvf| a 1+ a 1+ u + 2- DO I 1 EVALUATE -1 +LOOP ` |mvf ;

\ сокращенная запись стат. переменных с плав. точкой однопоточных и многопоточных
m: |$2 $12 ; m: |$3 $123 ; m: |$4 $1234 ; m: |$5 $12345 ; m: |$6 $123456 ; m: |$7 $1234567 ; m: |$8 $12345678 ; m: |$9 $123456789 ;
m: |;2 ;12 ; m: |;3 ;123 ; m: |;4 ;1234 ; m: |;5 ;12345 ; m: |;6 ;123456 ; m: |;7 ;1234567 ; m: |;8 ;12345678 ; m: |;9 ;123456789 ;
