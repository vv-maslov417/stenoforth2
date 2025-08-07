\ stenoforth32

\                              name             xt          typ
\ dictionary structure: byte-0 bytes-lex byte-0 addr byte-0 byte-typ byte-0

\ local naming

CREATE lcode 0x100000 ALLOT lcode VALUE dpl
CREATE ldate 0x100000 ALLOT ldate VALUE ldhere
VARIABLE XHERE  VARIABLE xdpl

0x1800 CONSTANT lenlvoc
USER-CREATE alvoc  lenlvoc USER-ALLOT  0 alvoc C!
USER lhere
USER axtloc
USER dtyp  0 dtyp !   \ variable type
USER locxt 0 locxt !
USER iol   0 iol !

USER-CREATE udata  0x2500 USER-ALLOT
udata ' udata 5 + @ DUP VALUE udhere - VALUE basa

m: usn! [ 0x8789 W, udhere , ] ;
m: usn@ [ 0x878B W, udhere , ] ;
m: adr@ [ 0xC78B W, udhere 0xC081 W, , ] ;  \ mov eax edi  add eax udhere

\ -- c-addr u
: lvoc   alvoc lenlvoc ;  lvoc ERASE 1 lhere !

\ c-addr u -- axtloc \ here u is 1 or 2 characters less than the original name with a type suffix of 1 or 2 characters
: lname, { a u | axt -- axtloc }
  lhere @ TO axt
  a axt u MOVE   0 axt u + C!
  axt u + 1+ DUP DUP lhere ! axtloc ! \ axtloc
;
: L{  dpl xdpl ! DP @ XHERE ! dpl DP ! ;
: }L  dpl DP @ xdpl @ - + TO dpl XHERE @ DP ! ;

: init-lvoc  lvoc ERASE  alvoc lhere ! ;

\ c-addr u --
: headl  lname, dpl SWAP ! lhere @ 7 + lhere ! ;

\ c-addr u s  -- c-addr u
m: nf1-exit \ -ROT 2DUP + 1- C@ -ROT 2SWAP <> IF NOTFOUND EXIT THEN
a u + 1- C@ s <>  IF a u NOTFOUND EXIT THEN a u
a u 1- SFIND IF CR a u 1- TYPE SPACE ." <-- this name already exists" CR CR KEY DROP BYE 2DROP THEN 2DROP
a u + 1- C@
CASE
')' OF   0 ENDOF \ variable-addres  4 or 8 bytes
'\' OF   1 ENDOF \ value-data fix-point
'%' OF   2 ENDOF \ value-data-multi-threads fix-point
'$' OF   4 ENDOF \ value-data float-point
';' OF   5 ENDOF \ value-data-multi-threads float-point
'"' OF   6 ENDOF \ evaluate strings
'(' OF   7 ENDOF \ code )
'[' OF   8 ENDOF \ macros
'{' OF   9 ENDOF \ closures
']' OF  10 ENDOF \ arrays-data fix-point
'}' OF  11 ENDOF \ arrays-data float-point
'^' OF  12 ENDOF \ vectors
ENDCASE
lhere @ u + 5 + DUP dtyp ! C! 0 lhere @ u + 6 + C!
;

\ c-addr u ss -- c-addr u
m: nf2-exit a u a u + 2- W@ s <> IF NOTFOUND EXIT THEN
a u 2- SFIND IF a u 1- CR TYPE ." <-- this name already exists" CR CR 2DROP THEN 2DROP
a u + 2- W@
CASE
'!d' OF  3 ENDOF \ value-data fix-point 64 bits
ENDCASE
lhere @ u + 4 + DUP dtyp ! C! 0 lhere @ u + 5 + C!
;

: +: : ;          \ extending the scope of the dictionary of previous definitions to the next definition
: : init-lvoc : ; \ erase dictionary of previous definitions by next definition via ':'

: NOTFOUND ( a u -- ) '(' { a u s } nf1-exit 1- headl L{ ;
: ) ( -- )  RET, }L ; IMMEDIATE \ name(  ) code

\ recursion for local word
: recloc ( -- ) g| axtloc @ @ c@r |g ; IMMEDIATE

: NOTFOUND ( a u -- ) '"' { a u s } nf1-exit 1- headl L{ LOAD-TEXT RET, }L ;            \ name"  " string
: NOTFOUND ( a u -- ) '[' { a u s } nf1-exit 1- headl L{ LOAD-TEXT ` EVALUATE RET, }L ; \ name[  ] macros

\ creating an anonymous function
: NOTFOUND ( a u -- ) '{' { a u s } nf1-exit 1- headl L{ LOAD-TEXT ` xts RET, }L ;      \ name{  closure text }
: x) ( -- )  RET, }L axtloc @ @ LIT, ; IMMEDIATE           \ name( ... x) xt gives out ( name is not used further)

\ search dictionary definition
: lsearch { a u a1 u1 \ a2 u2 fl -- a u 0|1 }
   0 TO fl BEGIN a u a1 u1 SEARCH >R TO u2 TO a2
                 R> a2 u1 + C@ 0= a2 1- C@ 0= AND AND
                 IF   1 TO fl a2 u1 TRUE
                 ELSE a2 u1 + 1+ TO a u2 u1 - 1- TO u
                      u u1 < IF 1 TO fl a u FALSE THEN
                 THEN
       fl UNTIL
;
: l' ( l' name -- xt ) TRUE locxt ! ; IMMEDIATE \ gives xt for name
USER st-wr  0 st-wr !
: -> 1 st-wr ! ; IMMEDIATE

: NOTFOUND \ a u --  compilation from local dictionary to global dictionary
  OVER     \ a u a
  C@       \ 1st name symbol
  '`' = IF 1 /STRING TRUE locxt ! THEN \ a u
  lvoc     \ a u av uv
  2OVER    \ a u av uv a u
  lsearch  \ a u a' u fl
  0= lhere @ 1 = OR IF 2DROP NOTFOUND EXIT THEN \ a u a' u
  2SWAP    \  a' u a u
  NIP      \  a' u u
  NIP      \  a' u
  + 1+ DUP 5 + C@ { typ }
  @ st-wr @
  IF
  typ  1 = IF 12 ELSE   \  1
  typ  2 = IF 13 ELSE   \  4
  typ  3 = IF 20 ELSE   \  2
  typ  4 = IF 25 ELSE   \  3
  typ  5 = IF 13 ELSE   \  5
  typ 12 = IF 14 ELSE   \ 12
  0 THEN THEN THEN THEN THEN THEN
  +
  THEN
  locxt @ 0<>
  IF   0 locxt ! LIT,
  ELSE typ 1 =
       IF DP @ st-wr @
          IF   12   \ 12
          ELSE 11   \ 11
          THEN
          MOVE DP @ st-wr @
          IF   12   \ 12
          ELSE 11   \ 11
          THEN + DP !
       ELSE COMPILE,
       THEN
  THEN 0 st-wr !
;

\ variables are single threaded
: NOTFOUND ( a u --  ) \ 2variable variable    "name)"
  ')' { a u s } nf1-exit 1- headl ldhere ALIGNED TO ldhere
  L{ ldhere LIT, RET, ldhere 2 CELLS + TO ldhere }L
;
: NOTFOUND ( a u --  ) \ value   "name\"
  '\' { a u s } nf1-exit  1- headl  ldhere ALIGNED TO ldhere ldhere LIT, ` !
  L{  ldhere LIT, ` @ RET, ldhere LIT, ` ! RET, ldhere 1 CELLS + TO ldhere }L
;
: NOTFOUND ( a u --  ) \ 2value  "name!d"
  '!d' { a u s } nf2-exit 2- headl ldhere ALIGNED TO ldhere ldhere LIT, ` 2!
  L{ ldhere LIT, ` 2@ RET, ldhere LIT, ` 2! RET, ldhere 2 CELLS + TO ldhere }L
;
: NOTFOUND ( a u --  ) \ fvalue  "name$"
  '$' { a u s } nf1-exit 1- headl ` FLOAT>DATA ldhere ALIGNED TO ldhere ldhere LIT, ` 2! ( 4 ltyp !)
  L{ ldhere LIT, ` 2@ ` DATA>FLOAT RET, ` FLOAT>DATA ldhere LIT, ` 2! RET, ldhere 2 CELLS + TO ldhere }L
;
\ variables multithreaded
: NOTFOUND ( a u --  ) \ value   "name%"
  '%' { a u s } nf1-exit 1- headl ` usn! ` DROP \ 2 ltyp !
  L{ ` DUP  ` usn@ RET,
     ` usn! ` DROP RET,
     udhere 1 CELLS + TO udhere }L
;
: NOTFOUND ( a u --  ) \ value   "name;"
  ';' { a u s } nf1-exit 1- headl  ` FLOAT>DATA32 ` usn! ` DROP \ 5 ltyp !
  L{ ` DUP ` usn@ ` DATA>FLOAT32  RET,
     ` FLOAT>DATA32 ` usn! ` DROP RET,
     udhere 1 CELLS + TO udhere }L
;
\ arrays are single threaded
: NOTFOUND ( a u --  ) \ [ 20 ] arr]
  ']' { a u s } nf1-exit 1- headl ldhere ALIGNED TO ldhere
  L{ ldhere LIT, RET, ldhere + TO ldhere }L
;
\ arrays multithreaded
: NOTFOUND ( a u --  ) \ [ 20 ] arr]u
  '}' { a u s } nf1-exit 1- headl
  L{ ` DUP ` adr@ RET,
  udhere + TO udhere }L
;

\ vectors
: NOTFOUND ( a u --  ) \ vector "name^"
  '^' { a u s } nf1-exit 1- headl ldhere ALIGNED TO ldhere ldhere LIT, ` !
  L{ ldhere LIT, ` @ ` EXECUTE RET, ldhere LIT, ` ! RET, 1 CELLS ldhere + TO ldhere }L
;


\ execution from the forth or if not there, then from the local dictionary
: NOTFOUND ( c-addr u -- ) { a u | [ 16 ] arr }
 a u + 1- C@ '`' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN
 a u 1- SFIND IF EXECUTE              \ search in current global dictionary
              ELSE lvoc 2SWAP lsearch \ search in local dictionary
                   IF + 1+ @ EXECUTE
                   ELSE TYPE SPACE ." not found " CR
                   THEN
              THEN
;
\ floating point number recognition  ( "1,0"  "-123,045" )
: NOTFOUND  ( c-addr u -- ) { a u | sq sz pt [ 20 ] an }
  a u OVER + SWAP ?DO I C@ '0' ':' WITHIN IF sq 1+ TO sq THEN
  I C@ ',' = IF I a - TO pt sz 1+ TO sz THEN LOOP
  a C@ '-' = IF sq u 2- = ELSE sq u 1- = THEN sz 1 = AND  0=
  IF a u NOTFOUND EXIT THEN
  a an u 2+  MOVE 'e' an u + C! '.' an pt + C! an u 1+ EVALUATE
;
I: | NextWord 2DUP + 1- C@ '|' <> IF RECURSE EVALUATE ELSE 2DROP THEN ;

: .s CR DEPTH .SN CR S0 @ SP! ;
: .sd DEPTH 0 DO I ROLL LOOP DEPTH 0 DO SWAP D. 2 +LOOP CR ;
