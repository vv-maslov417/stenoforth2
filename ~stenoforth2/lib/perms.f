\ perms.f - перестановки символов строки без повторов, итеративно.
\ Одно слово perms0, всё внутри его области видимости:
\   локальные переменные  | s\ n\ ... |
\   локальные макросы     c@k[ ] c!k[ ] swp[ ] srt[ ] nxt[ ]
\ Требует загруженного nloc25.f (локальные имена StenoForth).
\
\ swp, srt, nxt - макросы: текст компилируется в точке вызова, без CALL/RET.
\ На 10! перестановках это ~19% быстрее, чем те же тела локальными словами
\ (1281 мс против 1578 мс на 50 прогонов). Плата - код дублируется в каждом
\ месте вызова; здесь вызов один.
\ В макросе нельзя писать EXIT: он вышел бы из самого perms, поэтому в nxt
\ вместо EXIT стоит ветка IF ... ELSE ... THEN.
\
\ Печать:
\     perms   - только считает перестановки и выводит число перестановок
\     perms.  - печатает каждый вариант перестановки (type + cr) и выводит число перестановок
\
\ Пример:
\     s" abc" perms.


: perms0 | s\ n\ prnt\ |
   0 0 0 0 0 | ix\ jx\ lo\ hi\ cnt\ |
   c@k[ s + C@ ]
   c!k[ s + C! ]
   \ ( i1 i2 -- ) обмен байтов по индексам
   swp[ OVER c@k >R DUP c@k ROT c!k R> SWAP c!k ]

   \ ( -- ) сортировка вставками, один раз
   srt[
      1 -> ix
      BEGIN ix n < WHILE
         ix c@k  ix 1- -> jx
         BEGIN jx 0 >= OVER jx c@k < AND WHILE
            jx c@k  jx 1+ c!k
            jx 1- -> jx
         REPEAT
         jx 1+ c!k
         ix 1+ -> ix
      REPEAT
   ]
   \ ( -- f ) следующая перестановка, 0 - кончились
   nxt[
      n 2 - -> ix
      BEGIN ix 0 >= IF ix c@k  ix 1+ c@k >= ELSE 0 THEN WHILE
         ix 1- -> ix
      REPEAT
      ix 0 < IF 0 ELSE
         n 1- -> jx
         BEGIN ix c@k  jx c@k >= WHILE  jx 1- -> jx  REPEAT
         ix jx swp
         ix 1+ -> lo
         n 1- -> hi
         BEGIN lo hi < WHILE
            lo hi swp
            lo 1+ -> lo
            hi 1- -> hi
         REPEAT
         -1
      THEN
   ]
   n 0= IF 0 EXIT THEN
   srt
   0 -> cnt
   BEGIN
      cnt 1+ -> cnt
      prnt IF s n TYPE CR THEN
      nxt 0=
   UNTIL
   cnt
;

: perms  ( c-addr u -- cnt_perms ) 0 perms0 ;
: perms. ( c-addr u -- 'type_perms'  cnt_perms )  1 perms0 ;
