\ stenoforth32

MODULE: dsynonyms
m: a DABS ;
m: b W@ ;
m: c EMIT ;
m: d 2DUP ;
m: e ELSE ;
m: f F>D ;
\ g
m: h HERE ;
m: i 1+! ;
m: j 1-! ;
\ k
m: l DLSHIFT ;
m: m -! ;
m: n DNEGATE ;
\ o
m: p +! ;
\ q
m: r DRSHIFT ;
m: s SPACE ;
m: t THEN ;
\ u v
m: w W! ;
m: x 2DROP ;
m: y 0. ;
m: z D0<> ;

m: A ALLOCATE THROW ;
m: B .0b ;
m: D ?DO ;
m: F FREE THROW ;
m: G aDO ;
m: H .0h ;
\ K
m: L LOOP ;
\ M
m: N +LOOP ;
m: O .0 ;
m: P NextWord ;
\ Q
m: R RESIZE THROW ;
\ S
m: T TYPE ;
\ U
m: V MOVE ;
\ W X
m: Y 1. ;
m: Z D0= ;

m: + D+ ;
m: - D- ;
m: * D* ;
m: / D/ ;
m: % DMOD ;
m: . D. ;
m: @ 2@ ;
m: ! 2! ;
m: < D< ;
m: > D> ;
m: = D= ;
m: # D<> ;
m: & DAND ;
m: | DOR ;
m: ^ DXOR ;
m: ~ DINVERT ;
m: \ CR ;
m: ? IF ;
m: _ .BL ;
m: : -> ;
m: ; EXIT ;
m: 1 с ; m: 2 т ; m: 3 у ; m: 4 ф ; m: 5 х ; m: 6 ц ; m: 7 ч ; m: 8 ш ; m: 9 щ ;
EXPORT
m: sd| {{ dsynonyms ;
m: |sd }} ;
;MODULE

: NOTFOUND u\ a\ a C@ '"' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN
` sd| a 1+ u 1- aDO I 1 EVALUATE LOOP ` |sd ;

MODULE: dvaluenames
m: 1 с!d ; m: 2 т!d ; m: 3 у!d ; m: 4 ф!d ; m: 5 х!d ; m: 6 ц!d ; m: 7 ч!d ; m: 8 ш!d ; m: 9 щ!d ;
EXPORT
m: vd| {{ dvaluenames ;
m: |vd }} ;
;MODULE

: NOTFOUND u\ a\ a W@ '!d' = u 2 > AND 0= IF a u NOTFOUND EXIT THEN
  ` vd| a 2+ a 2+ u + 3 - DO I 1 EVALUATE -1 +LOOP ` |vd ;

\ сокращенная запись стат. переменных с фикс. точкой двойной разрядности однопоточных
m: |d2 !d12 ; m: |d3 !d123 ; m: |d4 !d1234 ; m: |d5 !d12345 ; m: |:6 !d123456 ; m: |:7 !d1234567 ; m: |:8 !d12345678 ; m: |:9 !d123456789 ;
