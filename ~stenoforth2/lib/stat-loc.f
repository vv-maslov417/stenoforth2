user-create astat 1024 user-allot user-value hsloc 0 TO hsloc astat 1024 erase
user-create dastat 0x1000 user-allot dastat 0x1000 erase
0 value nsinp 0 value stav variable iost 0 iost !

m: numsv@ ` dastat nv 4 * lit, ` +  ` @ ;
m: numsv! ` dastat nv 4 * lit, ` +  ` ! 0 iost ! ;
0 warning !

: hl+  hsloc  + TO hsloc ;
: ni++ nsinp 1+ TO nsinp ;
: hlw astat hsloc + c! 1 hl+ ;

rec: '_' 0 spos? u 1 > and
gen: ni++ a 1+ astat hsloc + u 1- move u 1- hl+ 0 hlw
     nsinp 0 (D.) ui\ ai\ ui 1 =
     if '0' hlw ai c@ hlw
     else ai astat hsloc + 2 move 2 hl+ then
     '@' hlw 0 hlw nsinp 4 * lit, ` dastat ` + ` ! 0 iost ! ;

\ инициализация
: _ 1 TO stav 0 TO nsinp 0 TO hsloc
\ hl+[ hsloc  + TO hsloc ]
\ ni++[ nsinp 1+ TO nsinp ]
\  hlw[ astat hsloc + c! 1 hl+ ]
0 asv\ 0 usv\
begin
  NextWord -> usv -> asv asv usv "_" compare
  if  ni++ asv astat hsloc + usv move usv hl+ 0 hlw
  nsinp 0 (D.) ui\ ai\ ui 1 = if '0' hlw ai c@ hlw else ai astat hsloc + 2 move 2 hl+ then
  '@' hlw 0 hlw 0 else 1 then
until 1 nsinp  do i 4 * lit, ` dastat ` + ` ! -1 +loop 0 iost ! ; immediate

\ чтение 0 запись 1
: in 1 iost ! ; immediate

\ компиляция
rec: astat hsloc a u search nip swap adrl\
     adrl u + c@ 0= and
     adrl u + 1+ 2 number? nip swap nv\ and
     adrl u + 3 + c@ '@' = and
gen: iost @ if   numsv! 0 iost !
          else numsv@ then ;

: ;  astat 1024 erase stav if 0 TO stav 0 iost ! then
     dastat 1024 erase
` ; ; immediate


\eof
create sinp 2 allot 0 value nmaxp
rec: ':' 0 spos? u 2 = and a 1+ u 1- number? nip swap TO nmaxp and
gen: nmaxp 1+ 1 do '_' sinp c! i '0' + sinp 1+ c! sinp 2 evaluate  loop ;

MODULE: statfix
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
EXPORT
m: stf| {{ statfix ;
m: |stf }} ;
;MODULE

rec: '/' 0 spos? u 1 > and
gen: a 1+ u 1- ado i 1 number? if drop nmaxp 1+ - abs 4 * dastat + lit, ` @ else 2drop ` stf| i 1 evaluate ` |stf then loop ;
