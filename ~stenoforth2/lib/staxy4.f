\ stenoforth32

\ staxy     1...5-->0...16      1\ ... 5\1234512345123451
\ : a=b  0xC38B W,    ;  : a=c  0xC18B W,    ;  : a=d  0xC28B W,    ;  : a=s  0xC68B W,    ;  : p+   0x6D8D W, C, ;
\ : a=@p 0x458B W, C, ;  : b=@p 0x5D8B W, C, ;  : c=@p 0x4D8B W, C, ;  : d=@p 0x558B W, C, ;  : s=@p 0x758B W, C, ;
\ : @p=a 0x4589 W, C, ;  : @p=b 0x5D89 W, C, ;  : @p=c 0x4D89 W, C, ;  : @p=d 0x5589 W, C, ;  : @p=s 0x7589 W, C, ;

: NOTFOUND u\ a\
1 a + C@ '\' <> 0 a + C@ '1' '5' 1+ WITHIN 0= OR IF  a u NOTFOUND EXIT THEN  STATE @ 0= IF HERE here\ THEN
0 b\ 0 e\ [ 17 ] SE] [ 17 ] 1TE] [ 17 ] 2TE] 0 3TE\ [ 17 ] 4TE] [ 17 ] 5TE]
a=b[  0xC38B W,    ]  a=c[  0xC18B W,    ]  a=d[  0xC28B W,    ]  a=s[  0xC68B W,    ]  p+[   0x6D8D W, C, ]
a=@p[ 0x458B W, C, ]  b=@p[ 0x5D8B W, C, ]  c=@p[ 0x4D8B W, C, ]  d=@p[ 0x558B W, C, ]  s=@p[ 0x758B W, C, ]
@p=a[ 0x4589 W, C, ]  @p=b[ 0x5D89 W, C, ]  @p=c[ 0x4D89 W, C, ]  @p=d[ 0x5589 W, C, ]  @p=s[ 0x7589 W, C, ]
u 2- emax\   a C@ '0' - bmax\
@T(  + C@ )  !T(  + C! )  @SE(  SE @T )  !SE(  SE !T )
SE 17 ERASE  1TE 17 ERASE  2TE 17 ERASE  4TE 17 ERASE 5TE 17 ERASE
emax 0= bmax 1 = OR 0= IF emax 2+ 2 DO I a @T '0' - I 1- !SE LOOP THEN
r1=CB(  @T DUP  IF 1- 4 * b=@p`   1 1 5TE !T ELSE DROP THEN  )
r2=CB(  @T DUP  IF 1- 4 * c=@p`   2 2 5TE !T ELSE DROP THEN  )
r3=CB(  @T DUP  IF 1- 4 * d=@p`   3 3 5TE !T ELSE DROP THEN  )
r4=CB(  @T DUP  IF 1- 4 * s=@p`   4 4 5TE !T ELSE DROP THEN  )
CE=TB(  @T DUP IF 16 SWAP 4 * - @p=a` ELSE DROP THEN )
TE=R|CB(
 CASE
   1 OF  0 a=@p` ENDOF  2 OF  4 a=@p` ENDOF  3 OF 8 a=@p` ENDOF  4 OF 12 a=@p` ENDOF
   5 OF    a=s`  ENDOF  6 OF    a=d`  ENDOF  7 OF    a=c` ENDOF  8 OF    a=b`  ENDOF
 ENDCASE )
CE=TE(  @T DUP IF 16 SWAP 4 * - @p=a` ELSE DROP THEN )
emax 0=
IF   bmax 1 17 WITHIN IF bmax 1- 4 * a=@p` THEN \ ????? DROP
ELSE bmax 1 =
     IF   emax 2 17 WITHIN IF emax 1- -4 * -4 DO I @p=a` -4 +LOOP THEN \ ????? DUP
     ELSE emax 1 >
          IF 1 -> b
             BEGIN  1 -> e
               BEGIN b e <> b e @SE = AND e @SE bmax <> AND e @SE emax @SE <> AND
                     b @SE bmax = b emax @SE = AND OR
                     IF  bmax b - b 1TE !T THEN
                     e 1+ -> e e emax =
               UNTIL
               b 1+ -> b  b bmax =
             UNTIL
          THEN
          emax 1 >
          IF 1  -> e
             BEGIN  e @SE bmax = IF  e bmax - 5 +  e 2TE !T THEN
                    e 1+ -> e  e emax =
             UNTIL
          THEN
          1 -> b
          BEGIN  b emax @SE =
                 IF b 1TE @T
                    IF 9
                    ELSE bmax
                    THEN b - -> 3TE
                 THEN
                 b 1+ -> b   b bmax =
          UNTIL
          emax 1 >
          IF  1 -> e
              BEGIN e @SE emax @SE = e @SE e <> AND e 2TE @T 0= AND
                    IF 5 bmax - e + e 4TE !T THEN
                    e 1+ -> e  e emax =
              UNTIL
          THEN
     THEN
THEN
emax 0 >
IF
1 1TE r1=CB 2 1TE r2=CB 3 1TE r3=CB 4 1TE r4=CB
17 1 ?DO I 2TE CE=TB LOOP
3TE TE=R|CB
17 1 ?DO I 4TE CE=TE LOOP
17 1 ?DO bmax 1- I - 4 * I @SE 1TE @T pr5\ pr5 0<> bmax pr5 - I 5TE @T <> AND
          IF bmax pr5 -
               CASE 1 OF @p=b`  ENDOF 2 OF @p=c`  ENDOF  3 OF @p=d`   ENDOF  4 OF @p=s`   ENDOF
                    DROP
               ENDCASE
          ELSE DROP THEN
       LOOP
THEN
bmax emax - DUP 0<> IF 4 * p+` ELSE DROP THEN  STATE @ 0= IF RET, here EXECUTE THEN
;


: NOTFOUND u\ a\
a C@ '1' '5' 1+ WITHIN a 1+ C@ '%' =  AND a 2+ C@ '[' <> AND 0= IF a u NOTFOUND EXIT THEN
a C@ '0' - bmax\ bmax u 2- +  emax\
1s" 1\1 "  2s" 2\12 "  3s" 3\123 "  4s" 4\1234 "  5s" 5\12345 "
emax 2+ ALLOCATE THROW ah\ ah emax 2+ ERASE
bmax
CASE
1 OF 1s ENDOF 2 OF 2s ENDOF 3 OF 3s ENDOF 4 OF 4s ENDOF 5 OF 5s ENDOF
DROP
ENDCASE
ah SWAP MOVE a 2+ ah bmax 2+ + u 2- MOVE ah emax 2+ EVALUATE
ah FREE THROW
;
: pusto ;
