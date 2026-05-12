m: rec: 0 WARNING ! : NOTFOUND u\ a\
   spos[ a + C@ ] spos?[ spos = ] ;
m: gen: 0= IF a u NOTFOUND EXIT THEN ;

\ непоср.значение переменной name' на стек
rec: a C@ ''' <> a u + 1- C@ ''' = AND
gen: [ 16 ] ar] lvoc a u 1- lsearch 2DROP 7 + C@ typ\
     a ar u 1- MOVE '`' ar u + 1- C! ar u EVALUATE ar 16 ERASE
     typ 3 > IF S" FLITERAL" EVALUATE ELSE
     typ 3 < IF S" LITERAL"  EVALUATE ELSE
     typ 3 = IF S" 2LITERAL" EVALUATE THEN
     THEN THEN ;

\ ) \ % ] } <-- immediate for state @ 0=  [ <-- immediate for macros
rec: lvoc a u lsearch fl\ um\ am\
     fl am um + 6 + C@ ty\ ty 8 =
     ty 0 = ty 1 = ty 2 = OR OR STATE @ 0= AND OR AND
gen: am um + 1+ @ EXECUTE ;

\ for tests
\ tm| == 10^m 0 DO
rec: '|' 2 spos? 1 spos '0' ':' WITHIN AND 't' 0 spos? AND u 3 = AND
gen:  1 1 spos '0' - DUP TO NRUNS NRUNS 0<> IF 0 ?DO 10 * LOOP LIT, ELSE 1 LIT, THEN 0 LIT, ` DO ;
\ |nt == drop1 ... dropn LOOP
rec: '|' 0 spos? 1 spos '0' ':' WITHIN AND 't' 2 spos? AND u 3 = AND
gen:  1 spos '0' - 0 ?DO ` DROP LOOP ` LOOP ;

\ : tst t1| .... |2t ;


: recgen ;
