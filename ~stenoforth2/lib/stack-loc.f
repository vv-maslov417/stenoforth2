\ стековые локальные переменные

MODULE: stack-fixpoint
m: a ABS ;                          m: A AGAIN ;                       m: # <> ;
m: b C@ ;                           m: B BEGIN ;                       m: ? IF ;
m: c EMIT ;                         m: C CASE ;                        m: _ ALLOT ;
m: d DUP ;                          m: D ?DO ;                         m: ^ XOR ;
m: e ELSE ;                         m: E ENDCASE ;                     m: & AND ;
m: f ENDOF ;                        m: F FILL ;                        m: ~ INVERT ;
m: g +! ;                           m: G aDO ;                         m: | OR ;
m: h HERE ;                         m: H WITHIN ;                      m: % MOD ;
m: i 1+ ;                                                              m: ; EXIT ;
m: j 1- ;                                                              m: \ CR ;
m: k KEY ;                          m: K COMPARE ;                     m: " TYPE ;
m: l LSHIFT ;                       m: L LOOP ;                        m: $ SPACE ;
m: o OF ;                           m: O ERASE ;
m: p CHOOSE ;                       m: P randomize ;
m: q 1+! ;                          m: Q LEAVE ;
m: r RSHIFT ;                       m: R REPEAT ;
m: s I+ ;                           m: S SEARCH ;
m: t THEN ;                         m: T TRUE ;
m: u EVALUATE ;                     m: U UNTIL ;
m: v 2* ;                           m: V MOVE ;
m: w C! ;                           m: W WHILE ;
m: x DROP ;                         m: X EXECUTE ;
m: y FALSE ;                        m: Y TRUE NEGATE ;
m: z 0<> ;                          m: Z 0= ;

EXPORT
m: st| {{ stack-fixpoint ;
m: |st }} ;
;MODULE

: cins? \ a u char -- flg   в строке a u символ char есть?
  |3 [y12GIb3=?xTQtL ;

m: /s  T=RS ;  \ чтобы не убирать параметры со стека

\ число параметров на входе
rec: '_' 0 spos? a 1+ u 1- number? nip swap nmbz\ and u 1 > and
gen: 0x57 c, 0x8D c, 0x7D c, nmbz 2- 4 * c, ;

\ строка символов параметров и операторов
rec: 0 nmb\ '/' 0 spos? u 1 > and
gen: a 1+ u 1-
        aDO I a 1+ u 1- + > IF LEAVE THEN
            I 1 number? nip nip
            IF S" +-*/%|&^Mmrl><=#:" I 1+ c@ cins?
               IF I c@ '0' - -> nmb I 1+ c@
                  CASE
                  '+' of 0x03 c, 0x47 c, nmb 1- -4 * c, endof
                  '-' of 0x2B c, 0x47 c, nmb 1- -4 * c, endof
                  '*' of 0xF7 c, 0x6F c, nmb 1- -4 * c, endof
                  '/' of 0x8B c, 0x4F c, nmb 1- -4 * c, 0x99 c, 0xF7 c, 0xF9 c, endof
                  '%' of 0x8B c, 0x4F c, nmb 1- -4 * c, 0x99 c, 0xF7 c, 0xF9 c, 0x8B c, 0xC2 c, endof
                  '|' of 0x0B c, 0x47 c, nmb 1- -4 * c, endof
                  '&' of 0x23 c, 0x47 c, nmb 1- -4 * c, endof
                  '^' of 0x33 c, 0x47 c, nmb 1- -4 * c, endof
                  'M' of 0x8B c, 0x57 c, nmb 1- -4 * c, 0x3B c, 0xD0 c, 0x0F c, 0x4F c, 0xC2 c, endof
                  'm' of 0x8B c, 0x57 c, nmb 1- -4 * c, 0x3B c, 0xD0 c, 0x0F c, 0x4C c, 0xC2 c, endof
                  'r' of 0x8B c, 0xC8 c, 0x8B c, 0x47 c, nmb 1- -4 * c, 0xD3 c, 0xE8 c, endof
                  'l' of 0x8B c, 0xC8 c, 0x8B c, 0x47 c, nmb 1- -4 * c, 0xD3 c, 0xE0 c, endof
                  '<' of 0x3B c, 0x47 c, nmb 1- -4 * c, 0x0F c, 0x9D c, 0xC0 c, 0x83 c, 0xE0 c, 0x01 c, 0x48 c, endof
                  '>' of 0x3B c, 0x47 c, nmb 1- -4 * c, 0x0F c, 0x9E c, 0xC0 c, 0x83 c, 0xE0 c, 0x01 c, 0x48 c, endof
                  '=' of 0x33 c, 0x47 c, nmb 1- -4 * c, 0x83 c, 0xE8 c, 0x01 c, 0x1B c, 0xC0 c, endof
                  '#' of 0x33 c, 0x47 c, nmb 1- -4 * c, 0xF7 c, 0xD8 c, 0x1B c, 0xC0 c, endof
                  ':' of 0x89 c, 0x47 c, nmb 1- -4 * c, ` drop endof \ присвоение

                  ENDCASE 1 I+
               ELSE ` dup 0x8B c, 0x47 c, i c@ '0' - 1- -4 * c, THEN
            ELSE ` st| I 1 EVALUATE  ` |st
            THEN
        LOOP ;

\ оставить число верхних параметров на выходе из общего числа параметров на стеке
rec: '/' u 2- spos? a u 2- number? nip swap n\ and
     u 2 > and  a u + 1- 1 number? nip swap m\ and
gen: m 1+ 1 ?do 0x8B c, 0x5D c, m i - 4 * c,
                0x89 c, 0x5D c, n i - 4 * c, loop
                0x8D c, 0x6D c, n m - 4 * c, 0x5F c, ;
