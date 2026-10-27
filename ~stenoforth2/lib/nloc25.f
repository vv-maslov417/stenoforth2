\ stenoforth32

\                              name             xt          typ
\ dictionary structure: byte-0 bytes-lex byte-0 addr byte-0 byte-typ byte-0

\ local naming

\ the areas below are addressed literally from compiled code,
\ so their sizes are the session limits for local data and local code
0x10000 CONSTANT lenldate \ local variables data area (64K)
0x20000 CONSTANT lenlcode \ local words code area (128K)

CREATE lcode lenlcode ALLOT lcode VALUE dpl
CREATE ldate lenldate ALLOT ldate VALUE ldhere
VARIABLE XHERE  VARIABLE xdpl

0x400 CONSTANT lenlvoc
USER-CREATE alvoc  lenlvoc USER-ALLOT  0 alvoc C!
USER lhere
USER axtloc
USER dtyp  0 dtyp !   \ variable type
USER locxt 0 locxt !
USER iol   0 iol !

USER-CREATE udata  0x2000 USER-ALLOT
udata ' udata 5 + @ DUP VALUE udhere - VALUE basa

m: usn! [ 0x8789 W, udhere , ] ;
m: usn@ [ 0x878B W, udhere , ] ;
m: adr@ [ 0xC78B W, udhere 0xC081 W, , ] ;  \ mov eax edi  add eax udhere
m: fldq [ 0x87DD W, udhere , ] ;   \ fld qword [edi+udhere]
m: fstpq [ 0x9FDD W, udhere , ] ;  \ fstp qword [edi+udhere]

\ -- c-addr u
\ the first byte of the buffer stays zero: it is a marker of the record start
: lvoc   alvoc 1+ lenlvoc 1- ;  0 alvoc C!  alvoc 1+ lhere !  \ the dictionary is empty

\ c-addr u -- axtloc \ here u is 1 or 2 characters less than the original name with a type suffix of 1 or 2 characters
: lname, { a u | axt -- axtloc }
  lhere @ TO axt
  a axt u MOVE   0 axt u + C!
  axt u + 1+ DUP DUP lhere ! axtloc ! \ axtloc
;
: L{  dpl xdpl ! DP @ XHERE ! dpl DP ! ;
: }L  dpl DP @ xdpl @ - + TO dpl XHERE @ DP ! ;

: init-lvoc  0 alvoc C!  alvoc 1+ lhere ! ;

\ u -- \ control of the local areas before the next name record is created
: ?lmem ( u -- )
  DUP lhere @ + 8 + alvoc lenlvoc + > ABORT" lvoc overflow: too many local names"
  DROP
  ldhere 2 CELLS + ldate lenldate + > ABORT" ldate overflow: too many local variables"
  dpl 64 + lcode lenlcode + > ABORT" lcode overflow: too much local code" ;

\ c-addr u --
: headl  DUP ?lmem  lname, dpl SWAP ! lhere @ 7 + lhere ! ;

\ the record is: name 0 xt:4 typ code
\ code = length of the read code, bit 7 is set when the name has no write entry;
\ the write entry starts right after the read code, so its offset = code length
0 VALUE wxt
0 VALUE ltyp
0 VALUE lwdel
0 VALUE lrlen
0 VALUE lwoff
: wdelta, ( -- )  wxt axtloc @ @ - axtloc @ 4 + C! ;
: nodelta, ( -- )  dpl axtloc @ @ - 0x80 OR axtloc @ 4 + C! ;
\ the read code of the types below has no relative call, so it may be copied
\ into the definition being compiled ( types 4,5,6,8,9 call DATA>FLOAT,
\ FLOAT>DATA32, EVALUATE, xts and must stay in place )
: inlinable? ( typ -- fl )  DUP 4 < IF DROP TRUE ELSE 10 13 WITHIN THEN ;

\ types 0,1,3,4,10 keep the address of their storage in the record and are
\ compiled as a literal address plus the access word. The compiler then sees an
\ ordinary variable and optimizes it in the same way as a global one
\ ( for example "a a *" becomes "IMUL [addr]" )
: l@, ( typ -- )  CASE  1 OF ['] @  COMPILE, ENDOF
                        3 OF ['] 2@ COMPILE, ENDOF
                        4 OF ['] F@ COMPILE, ENDOF  ENDCASE ;
: lpre!, ( typ -- )  CASE  ENDCASE ;
: l!, ( typ -- )  CASE  1 OF ['] !  COMPILE, ENDOF
                        3 OF ['] 2! COMPILE, ENDOF
                        4 OF ['] F! COMPILE, ENDOF  ENDCASE ;

\ c-addr u s  -- c-addr u
m: nf1-exit \ -ROT 2DUP + 1- C@ -ROT 2SWAP <> IF NOTFOUND EXIT THEN
a u + 1- C@ s <>  IF a u NOTFOUND EXIT THEN a u
a u 1- SFIND IF CR a u 1- TYPE SPACE S" <-- this name already exists" TYPE CR CR KEY DROP BYE 2DROP THEN 2DROP
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
'{' OF   9 ENDOF \ function modifier
']' OF  10 ENDOF \ arrays-data fix-point
'}' OF  11 ENDOF \ arrays-data float-point
'^' OF  12 ENDOF \ vectors
ENDCASE
lhere @ u + 5 + DUP dtyp ! C! 0 lhere @ u + 6 + C!
;

\ c-addr u ss -- c-addr u
m: nf2-exit a u a u + 2- W@ s <> IF NOTFOUND EXIT THEN
a u 2- SFIND IF a u 1- CR TYPE S" <-- this name already exists" TYPE CR CR 2DROP THEN 2DROP
a u + 2- W@
CASE
'!d' OF  3 ENDOF \ value-data fix-point 64 bits
ENDCASE
lhere @ u + 4 + DUP dtyp ! C! 0 lhere @ u + 5 + C!
;

: +: : ;          \ extending the scope of the dictionary of previous definitions to the next definition
: : init-lvoc : ; \ erase dictionary of previous definitions by next definition via ':'
: lempty?  lhere @ alvoc 1+ = ; \ the local dictionary has no names

: NOTFOUND ( a u -- ) '(' { a u s } nf1-exit 1- headl nodelta, L{ ;
: ) ( -- )  RET, }L ; IMMEDIATE \ name(  ) code

\ recursion for local word
: recloc ( -- )  axtloc @ @ 0xE8 C, DP @ 4 + - , ; IMMEDIATE

\ the text of the names below is built inside the definition ( load-text emits a jump
\ over the data ), the record keeps the address of the text and its length; the access
\ is compiled at the place of use, so there is no extra call into lcode
: NOTFOUND ( a u -- ) '"' { a u s } nf1-exit 1- headl L{ load-text 1- DLIT, RET, }L nodelta, ;            \ name"  " string
: NOTFOUND ( a u -- ) '[' { a u s } nf1-exit 1- headl L{ load-text  DLIT, ` EVALUATE RET, }L nodelta, ; \ name[  ] macros

\ creating an anonymous function
: NOTFOUND ( a u -- ) '{' { a u s } nf1-exit 1- headl L{ LOAD-TEXT ` xts RET, }L nodelta, ;      \ name{  function modifier text }
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
(
: lsearch { a u a1 u1 \ ab ae d fb fe }
  BEGIN a d + C@ 0<> fb 0= AND
    IF a d + TO ab 1 TO fb
    ELSE fb a d + C@ 0= AND a d + 1- C@ 0<> AND
      IF a d + TO ae 0 TO fb ab ae ab - a1 u1 COMPARE 0=
         IF ab ae ab - TRUE 1 TO fe THEN
      THEN
    THEN
    d 1+ TO d d u > fe OR
  UNTIL fe 0= IF a u fe THEN ;

: lsearch  \ s1 s2 -- s3 f
  >R HERE SWAP R@ S, 0 C, R@ 1+ SEARCH
  IF DROP R> TRUE ELSE RDROP FALSE THEN ;

: lsearch \ c-addr1 u1 c-addr2 u2  -- c-addr3 u3 flag
  HERE { a2 u2 h } a2 u2 S, 0 C,  h u2 1+ SEARCH
  IF DROP u2 TRUE ELSE  FALSE THEN ;
)
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
  0= lempty? OR IF 2DROP NOTFOUND EXIT THEN \ a u a' u
  2SWAP    \  a' u a u
  NIP      \  a' u u
  NIP      \  a' u
  + 1+ DUP 5 + C@ TO ltyp  DUP 4 + C@ TO lwdel \ addr typ code info
  lwdel 0x7F AND TO lrlen
  lwdel 0xC0 AND IF 0 ELSE lrlen THEN TO lwoff   \ 0x40 - direct address, 0x80 - no write entry
  @                                              \ code entry or storage address
  st-wr @ IF lwoff + THEN
  locxt @ 0<>
  IF   0 locxt ! LIT,
  ELSE lwdel 0x40 AND
            IF   st-wr @ IF ltyp lpre!, THEN
                 LIT,                            \ literal address: the compiler optimizes
                 st-wr @ IF ltyp l!, ELSE ltyp l@, THEN \ the access like a global variable
            ELSE st-wr @
                 IF   ltyp 1 =          \ the write code is copied as is ( 12 bytes )
                      IF   DP @ lwoff MOVE  DP @ lwoff + DP !
                      ELSE COMPILE,
                      THEN
                 ELSE                   \ the read code is copied without the final RET,
                                        \ so reading a local variable has no CALL
                      ltyp inlinable?
                      IF   DP @ lrlen 1- MOVE  DP @ lrlen 1- + DP !
                      ELSE COMPILE,
                      THEN
                 THEN
            THEN
  THEN 0 st-wr !
;

\ variables are single threaded
: NOTFOUND ( a u --  ) \ 2variable variable    "name)"
  ')' { a u s } nf1-exit 1- headl ldhere ALIGNED TO ldhere
  ldhere axtloc @ !  0x40 axtloc @ 4 + C!  \ the record keeps the address of the storage
  ldhere 2 CELLS + TO ldhere
;
\ : NOTFOUND ( a u --  ) \ 2variable variable    "name)"
\   ')' { a u s } nf1-exit 1- headl \ lcode ALIGNED TO lcode
\   L{ lcode LIT, RET, lcode 2 CELLS + TO lcode }L
\ ;

\ 0 VALUE sml
\ I: sv! i| ldhere @=t sml t=c |i ;
\ m: svv sml ' sv! 8 + C! sml 4 + TO sml ;
\ I: esv i| sml pa |i 0 TO sml ;

: NOTFOUND ( a u --  ) \ value   "name\"
  '\' { a u s } nf1-exit  1- headl  ldhere ALIGNED TO ldhere
  ldhere axtloc @ !  0x40 axtloc @ 4 + C!
  ldhere LIT, ` !                    \ initialisation store, the same code as "value !"
  ldhere 1 CELLS + TO ldhere
;
: NOTFOUND ( a u --  ) \ 2value  "name!d"
  '!d' { a u s } nf2-exit 2- headl ldhere ALIGNED TO ldhere
  ldhere axtloc @ !  0x40 axtloc @ 4 + C!
  ldhere LIT, ` 2!
  ldhere 2 CELLS + TO ldhere
;
: NOTFOUND ( a u --  ) \ fvalue  "name$"
  '$' { a u s } nf1-exit 1- headl ldhere ALIGNED TO ldhere
  ldhere DUP axtloc @ !  0x40 axtloc @ 4 + C!
  LIT, ` F!                          \ the initialisation store: native double
  ldhere 2 CELLS + TO ldhere
;
\ variables multithreaded
: NOTFOUND ( a u --  ) \ value   "name%"
  '%' { a u s } nf1-exit 1- headl ` usn! ` DROP \ 2 ltyp !
  L{ ` DUP  ` usn@ RET, DP @ TO wxt
     ` usn! ` DROP RET,
     udhere 1 CELLS + TO udhere }L wdelta,
;
: NOTFOUND ( a u --  ) \ fvalue  "name;"  64-bit float in task area (fld/fstp qword)
  ';' { a u s } nf1-exit 1- headl ` fstpq
  L{ ` fldq RET, DP @ TO wxt
     ` fstpq RET,
     udhere 2 CELLS + TO udhere }L wdelta,
;
\ arrays are single threaded
: NOTFOUND ( a u --  ) \ [ 20 ] arr]
  ']' { a u s } nf1-exit 1- headl ldhere ALIGNED TO ldhere
  ldhere axtloc @ !  0x40 axtloc @ 4 + C!
  ldhere + TO ldhere
;
\ arrays multithreaded
: NOTFOUND ( a u --  ) \ [ 20 ] arr}
  '}' { a u s } nf1-exit 1- headl
  L{ ` DUP ` adr@ RET,
  udhere + TO udhere }L nodelta,
;

\ vectors
: NOTFOUND ( a u --  ) \ vector "name^"
  '^' { a u s } nf1-exit 1- headl ldhere ALIGNED TO ldhere ldhere LIT, ` !
  L{ ldhere LIT, ` @ ` EXECUTE RET, DP @ TO wxt ldhere LIT, ` ! RET, 1 CELLS ldhere + TO ldhere }L wdelta,
;
\ execution from the forth or if not there, then from the local dictionary
: NOTFOUND ( c-addr u -- ) { a u | [ 16 ] arr }
 a u + 1- C@ '`' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN
 a u 1- SFIND IF EXECUTE              \ search in current global dictionary
              ELSE lvoc 2SWAP lsearch \ search in local dictionary
                   IF + 1+ DUP 4 + C@ 0x40 AND
                      IF   DROP a u 1- NOTFOUND \ direct address: compile the usual access
                      ELSE @ EXECUTE            \ code entry: string/macro/modifier/local word
                      THEN
                   ELSE TYPE SPACE S" not found " TYPE CR
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
\ I: | NextWord 2DUP + 1- C@ '|' <> IF RECURSE EVALUATE ELSE 2DROP THEN  ;
I: | CS0
   BEGIN NextWord 2DUP S" |" COMPARE 0=
     IF 2DROP
        BEGIN ?CS IF EXIT ELSE CS> CS> EVALUATE THEN AGAIN
     ELSE >CS >CS THEN
   AGAIN ;
: .s CR DEPTH .SN CR S0 @ SP! ;
: .sd DEPTH 0 DO I ROLL LOOP DEPTH 0 DO SWAP D. 2 +LOOP CR ;
