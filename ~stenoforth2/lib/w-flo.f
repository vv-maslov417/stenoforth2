\ stenoforth32

\ операции над числами с плав. точкой
MODULE: fpoint
: abs     FABS    ;
: negate  FNEGATE ;
: +       F+      ;
: -       F-      ;
: *       F*      ;
: /       F/      ;
: 2/      2e F/   ;
: 2*      2e F*   ;
: 1+      F1+     ;
: 1-      1e F-   ;
: @       F@      ;
: !       F!      ;
: <       F<      ;
: 0<      F0<     ;
: =       F=      ;
: 0=      F0=     ;
: max     FMAX    ;
: min     FMIN    ;
: pi      FPI     ;
: .       F.      ;
: ~       F~      ;
: dup     FDUP    ;
: drop    FDROP   ;
: swap    FSWAP   ;
: over    FOVER   ;
: rot     FROT    ;
: sin     FSIN    ;
: cos     FCOS    ;
: acos    FACOS   ;
: asin    FASIN   ;
: tan     FTAN    ;
: atan    FATAN   ;
: sqrt    FSQRT   ;
: ^       F**     ;
: ^2      F**2    ;
: ln      FLN     ;
: log     FLOG    ;
: log2    FLOG2   ;
: exp     EXP     ;
: 10*     F10*    ;
: 10/     F10/    ;
: f>d     F>D     ;
: >s      F>DS    ;
: >f      DS>F    ;
: d>f     D>F     ;
I: to   ` FTO     ;
: 2drop   FDROP FDROP ;
EXPORT
m: f|  {{ fpoint ;
m: |f  }} ;
;MODULE

\ операции над комплексными числами
MODULE: complex
m: arg i2$ r2$ i1$ r1$ ;
m: rr  r1 r2 F* ;
m: ii  i1 i2 F* ;
m: ir  i1 r2 F* ;
m: ri  r1 i2 F* ;
m: a2  r2 r2 F* i2 i2 F* F+ ;
 : +  arg r1 r2 F+ i1 i2 F+ ;
 : -  arg r1 r2 F- i1 i2 F- ;
 : *  arg rr ii F- ir ri F+ ;
 : /  arg rr ii F+ a2 FDUP a3$ F/
          ir ri F- a3 F/ ;
 : .  FSWAP F. F. ;
EXPORT
m: c|  {{ complex ;
m: |c  }} ;
;MODULE

\ одинарные целые числа немедленного исполнения
: NOTFOUND 2DUP 2>R 1- NUMBER? 2R@ + 1- C@ '`' = AND 0=
  IF 2DROP 2R> NOTFOUND EXIT THEN RDROP RDROP DROP
;

\EOF

\ радиус_цистерны длина_цистерны высота_жидкости --> объём_жидкости
: Объём  высота$ длина$ радиус$
  f| радиус высота - радиус / acos угол$
     радиус радиус * угол *
     радиус угол sin * радиус высота - * - длина * .
  |f
;

1,5  20,0  0,3  Объём

: Streug  x$ y$ z$  \ -- S
  f| x y + z + 2e / p$
  p x - p y - * p z - * p * sqrt . |f
;

12,3 23,4 34,5 Streug

\ поиск минимума функции
m: fun \ | x^3/3 + x^2 + 3x - 2 - |
   x ^2 x * 3e / x ^2 + 3e x * - 2e - abs ;

: MinFun  xmax$ xmin$
  0e xy$ 0e ymin$ 0e x$ 1e-7 dx$
  f| xmin ip x fun ip ymin
  xmax dx / >s xmin dx / >s
  DO I >f dx * ip x fun dup ymin <
     IF   ip ymin I >f dx * ip xy
     ELSE drop THEN
  LOOP
  CR ." интервал x от " xmin . ." до " xmax .
  CR ." ymin = " ymin . ." x = " xy . |f
;
-2e 2e MinFun

: check  -0,5770273 x$ f| fun |f ; check CR F.

: NOTFOUND 2DUP 2>R 1- NUMBER? 2R@ + 1- C@ '`' = AND 0=
  IF 2DROP 2R> NOTFOUND EXIT THEN RDROP RDROP DROP
;

: sss   20` 30` +` 23 100 + ;  .s sss  .s
: sss1  [ 20 30 + ] 23 100 + ; .s sss1 .s
