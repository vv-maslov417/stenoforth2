m: rec: 0 WARNING ! : NOTFOUND u\ a\
   p>c[ a 1- + C@ ]   \ pos -- char
   pc?[ SWAP p>c = ]  \ pos char -- flag
;
m: gen: 0= IF a u NOTFOUND EXIT THEN ;

\ непоср.значение переменной name' на стек
rec: a C@ ''' <> a u + 1- C@ ''' = AND
gen: [ 16 ] ar] lvoc a u 1- lsearch 2DROP 7 + C@ typ\
     a ar u 1- MOVE '`' ar u + 1- C! ar u EVALUATE ar 16 ERASE
     typ 3 > IF S" FLITERAL" EVALUATE ELSE
     typ 3 < IF S" LITERAL"  EVALUATE ELSE
     typ 3 = IF S" 2LITERAL" EVALUATE THEN
     THEN THEN ;

rec: lvoc a u lsearch fl\ um\ am\
     fl am um + 6 + C@ 8 = AND
gen: am um + 1+ @ EXECUTE ;

: recgen ;
