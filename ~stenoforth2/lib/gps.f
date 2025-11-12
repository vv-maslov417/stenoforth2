\ генератор всех разных перестановок символов 
\ обмен байтами между двумя адресами
: cswapa \ a1 a2 --
  a| b=[p cl=[b dl=[a [b=dl [a=cl |a 2\
;
\ если char нет в памяти между адресами a1 и a2 то выдать true
: cnotfinda \ char a2 a1 -- t/f
  a| L4: 0 a=[p?
     L1  J=  bl=[a 4 bl=[p?
     L2  J=  ai
     L4  JMP
     L1: a=1
     L3  JMP
     L2: a^a
     L3: 8 pa
  |a
;
\ 0 a2 a1 a u -- count a2 a1' a u
1 value notype \ не выводить на печать 
: variants
  2>r 2dup - 1 <
  if 2>r 1+ 2r> 2r>
     notype 0= if 2dup type cr then
     exit
  then
  dup >r
  begin 2dup >
  while
     dup c@ over r@ cnotfinda
     if dup r@ cswapa r> 1+ swap 2r> rot >r
        recurse
        r> -rot 2>r swap 1- >r dup r@ cswapa
     then
     1+
  repeat
  drop r> 2r>
;
: VARIANTS \ a u -- n
    dup 0 = if 2drop 0 exit then
    2dup 2>r over + swap 0 -rot 2r> variants 2drop 2drop
;

\eof
0 to notype
s" 1111444466666666" 2DUP VARIANTS .( variants: ) . type cr cr

: t1 s" 11114444666666" VARIANTS drop ; seet t1
