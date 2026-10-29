\ stenoforth32

\                           имя              xt                       тип
\ структура словаря: byte-0 bytes-lex byte-0 addr byte-0 flags byte-0 typ byte-0

\ локальные имена

\ Код локального слова компилируется стандартными DP и HERE в то же пространство
\ кода, что и словарь FORTH: тело размещается на месте своего определения,
\ а охватывающее определение перепрыгивает через него, поэтому тело достижимо
\ только из вызовов, скомпилированных в местах его использования. Таким образом,
\ оптимизатор работает с локальным кодом так же, как с кодом самого определения.
\ Тела делят пространство кода со словарём, поэтому локальный код и код словаря
\ попадают в одни и те же строки кэша: это цена за ПОЛНУЮ работу оптимизатора.
\ Область локальных данных адресуется непосредственно из скомпилированного кода,
\ поэтому её размер - это предел сеанса для локальных переменных и массивов

0x10000 CONSTANT lenldate \ область данных локальных переменных (64K)
CREATE ldate lenldate ALLOT ldate VALUE ldhere

0x400 CONSTANT lenlvoc
USER-CREATE alvoc  lenlvoc USER-ALLOT  0 alvoc C!
USER lhere
USER axtloc
USER dtyp  0 dtyp !   \ тип переменной
USER locxt 0 locxt !
USER iol   0 iol !
USER lxt   0 lxt !    \ адрес кода или данных, записываемый в строящуюся запись
USER jn    0 jn !     \ глубина вложенности компилируемых локальных тел
USER-CREATE jcells 8 CELLS USER-ALLOT \ переходы через эти тела

0x2000 CONSTANT lenudata \ область задачи многопоточных локальных переменных
USER-CREATE udata  lenudata USER-ALLOT
udata ' udata 5 + @ DUP VALUE udhere - VALUE basa
udhere lenudata + CONSTANT udend \ конец этой области (смещение)

m: usn! [ 0x8789 W, udhere , ] ;
m: usn@ [ 0x878B W, udhere , ] ;
m: adr@ [ 0xC78B W, udhere 0xC081 W, , ] ;  \ mov eax edi  add eax udhere
m: fldq [ 0x87DD W, udhere , ] ;   \ fld qword [edi+udhere]
m: fstpq [ 0x9FDD W, udhere , ] ;  \ fstp qword [edi+udhere]

\ обращение к значению типа 13 компилируется прямо в месте использования:
\ ячейка лежит в области задачи, поэтому достаточно одной команды со смещением,
\ а SetOP оставляет команду на виду у оптимизатора
\ ( off -- )  mov eax,[edi+off]
: l@t, ( off -- )
  ['] DUP INLINE,  OPT_INIT  SetOP  0x878B W,  ,  OPT  OPT_CLOSE ;
\ ( off -- )  lea eax,[edi+off]
: ladr, ( off -- )
  ['] DUP INLINE,  OPT_INIT  SetOP  0x878D W,  ,  OPT  OPT_CLOSE ;

\ -- c-addr u
\ первый байт буфера нулевой: это признак начала записи
: lvoc   alvoc 1+ lenlvoc 1- ;  0 alvoc C!  alvoc 1+ lhere !  \ словарь пуст

\ c-addr u -- axtloc \ здесь u на 1 или 2 символа меньше исходного имени с суффиксом типа в 1 или 2 символа
: lname, { a u | axt -- axtloc }
  lhere @ TO axt
  a axt u MOVE   0 axt u + C!
  axt u + 1+ DUP DUP lhere ! axtloc ! \ axtloc
;

\ -- a \ тело локального слова начинается сразу после перехода через него
\ переход сохраняет поток управления охватывающего определения, см. <body
\ переход компилируется стандартными байтами и не регистрируется в оптимизаторе,
\ поэтому оптимизатор ничего через него не просматривает и не перемещает
: body> ( -- a )
  0xE9 C,  DP @ jn @ CELLS jcells + !  1 jn +!   \ поле смещения перехода
  0 ,  DP @ ;

\ переход обходит только что скомпилированное тело
: <body ( -- )
  -1 jn +!
  jn @ CELLS jcells + @  DP @ OVER - 4 -  SWAP ! ;

: init-lvoc  0 alvoc C!  alvoc 1+ lhere ! ;

\ u -- \ проверка локальных областей перед созданием следующей записи имени
: ?lmem ( u -- )
  DUP lhere @ + 8 + alvoc lenlvoc + > ABORT" lvoc overflow: too many local names"
  DROP
  ldhere 2 CELLS + ldate lenldate + > ABORT" ldate overflow: too many local variables"
  udhere 2 CELLS + udend > ABORT" udata overflow: too many multithreaded local variables" ;

\ c-addr u -- \ запись хранит адрес из lxt: код локального слова
\ или хранилище локальной переменной
: headl  DUP ?lmem  lname, lxt @ SWAP !  lhere @ 7 + lhere ! ;

\ запись имеет вид: name 0 xt:4 flags typ
\ flags = длина кода чтения, бит 7 установлен, когда у имени нет входа по записи,
\ бит 6 установлен, когда запись хранит адрес хранилища;
\ вход по записи начинается сразу после кода чтения, поэтому его смещение = длина кода
0 VALUE wxt
0 VALUE ltyp
0 VALUE lwdel
0 VALUE lrlen
0 VALUE lwoff
: wdelta, ( -- )  wxt axtloc @ @ - axtloc @ 4 + C! ;
: nodelta, ( -- )  DP @ axtloc @ @ - 0x3F MIN 0x80 OR axtloc @ 4 + C! ;
\ код чтения перечисленных ниже типов не содержит относительного вызова, поэтому его можно копировать
\ в компилируемое определение (типы 6, 8, 9 вызывают DATA>FLOAT,
\ EVALUATE и xt, и должны оставаться на месте)
: inlinable? ( typ -- fl )
  DUP 2 = IF DROP TRUE EXIT THEN
  DUP 5 = IF DROP TRUE EXIT THEN
  DUP 11 = IF DROP TRUE EXIT THEN
  12 = ;

\ типы 0,1,3,4,10 хранят адрес своего хранилища в записи и
\ компилируются как литеральный адрес плюс слово доступа. Тогда компилятор видит
\ обычную переменную и оптимизирует её так же, как глобальную
\ (например, "a a *" превращается в "IMUL [addr]")
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
')' OF   0 ENDOF \ адрес переменной, 4 или 8 байт
'\' OF   1 ENDOF \ данные значения, с фиксированной точкой
'%' OF   2 ENDOF \ данные значения, многопоточные, с фиксированной точкой
'$' OF   4 ENDOF \ данные значения, с плавающей точкой
';' OF   5 ENDOF \ данные значения, многопоточные, с плавающей точкой
'"' OF   6 ENDOF \ строки для EVALUATE
'(' OF   7 ENDOF \ код - суффикс ")"
'[' OF   8 ENDOF \ макросы
'{' OF   9 ENDOF \ модификатор функции
']' OF  10 ENDOF \ данные массива, с фиксированной точкой
'}' OF  11 ENDOF \ данные массива, с плавающей точкой
'_' OF  13 ENDOF \ значение в области задачи, обращение одной командой
'^' OF  12 ENDOF \ векторы
ENDCASE
lhere @ u + 5 + DUP dtyp ! C! 0 lhere @ u + 6 + C!
;

\ c-addr u ss -- c-addr u
m: nf2-exit a u a u + 2- W@ s <> IF NOTFOUND EXIT THEN
a u 2- SFIND IF a u 1- CR TYPE S" <-- this name already exists" TYPE CR CR 2DROP THEN 2DROP
a u + 2- W@
CASE
'!d' OF  3 ENDOF \ данные значения, с фиксированной точкой, 64 бита
ENDCASE
lhere @ u + 4 + DUP dtyp ! C! 0 lhere @ u + 5 + C!
;

: +: : ;          \ продление области действия словаря предыдущих определений до следующего определения
: : init-lvoc : ; \ очистка словаря предыдущих определений следующим определением через ':'
: lempty?  lhere @ alvoc 1+ = ; \ в локальном словаре нет имён

: NOTFOUND ( a u -- ) '(' { a u s } nf1-exit 1-  body> lxt ! headl ;
: ) ( -- )  RET, <body nodelta, ; IMMEDIATE \ name(  ) код

\ рекурсия для локального слова
: recloc ( -- )  axtloc @ @ 0xE8 C, DP @ 4 + - , ; IMMEDIATE

\ текст имён ниже строится внутри определения (load-text выдаёт переход
\ через данные), запись хранит адрес текста и его длину; обращение
\ компилируется в месте использования, поэтому лишнего вызова в код нет
: NOTFOUND ( a u -- ) '"' { a u s } nf1-exit 1-  body> lxt ! headl  load-text 1- DLIT, RET, <body nodelta, ;          \ name"  " строка
: NOTFOUND ( a u -- ) '[' { a u s } nf1-exit 1-  body> lxt ! headl  load-text  DLIT, ` EVALUATE RET, <body nodelta, ; \ name[  ] макросы

\ создание анонимной функции
: NOTFOUND ( a u -- ) '{' { a u s } nf1-exit 1-  body> lxt ! headl  LOAD-TEXT ` xts RET, <body nodelta, ; \ name{  текст модификатора функции }
: x) ( -- )  RET, <body axtloc @ @ LIT, ; IMMEDIATE           \ name( ... x) выдаёт xt (имя дальше не используется)

\ поиск определения в словаре
: lsearch { a u a1 u1 \ a2 u2 fl -- a u 0|1 }
   0 TO fl BEGIN a u a1 u1 SEARCH >R TO u2 TO a2
                 R> a2 u1 + C@ 0= a2 1- C@ 0= AND AND
                 IF   1 TO fl a2 u1 TRUE
                 ELSE a2 u1 + 1+ TO a u2 u1 - 1- TO u
                      u u1 < IF 1 TO fl a u FALSE THEN
                 THEN
       fl UNTIL
;
: l' ( l' name -- xt ) TRUE locxt ! ; IMMEDIATE \ выдаёт xt для имени
USER st-wr  0 st-wr !
: -> 1 st-wr ! ; IMMEDIATE

: NOTFOUND \ a u --  компиляция из локального словаря в глобальный словарь
  OVER     \ a u a
  C@       \ первый символ имени
  '`' = IF 1 /STRING TRUE locxt ! THEN \ a u
  lvoc     \ a u av uv
  2OVER    \ a u av uv a u
  lsearch  \ a u a' u fl
  0= lempty? OR IF 2DROP NOTFOUND EXIT THEN \ a u a' u
  2SWAP    \  a' u a u
  NIP      \  a' u u
  NIP      \  a' u
  + 1+ DUP 5 + C@ TO ltyp  DUP 4 + C@ TO lwdel \ addr typ flags
  lwdel 0x7F AND TO lrlen
  lwdel 0xC0 AND IF 0 ELSE lrlen THEN TO lwoff   \ 0x40 - прямой адрес, 0x80 - нет входа по записи
  @                                              \ вход по чтению или адрес хранилища
  st-wr @ IF lwoff + THEN
  locxt @ 0<>
  IF   0 locxt !
       ltyp 13 = IF ladr, ELSE LIT, THEN      \ l' name -- адрес ячейки
  ELSE ltyp 13 =
            IF   st-wr @
                 IF   ladr,  ['] ! COMPILE, \ адрес ячейки, затем запись
                 ELSE l@t,                  \ одна команда: значение в EAX
                 THEN
            ELSE lwdel 0x40 AND
            IF   st-wr @ IF ltyp lpre!, THEN
                 LIT,                            \ литеральный адрес: компилятор оптимизирует
                 st-wr @ IF ltyp l!, ELSE ltyp l@, THEN \ обращение как к глобальной переменной
            ELSE st-wr @
                 IF   _COMPILE,              \ вход по записи идёт после кода чтения
                 ELSE                   \ код чтения копируется без завершающего RET,
                                        \ поэтому чтение локальной переменной обходится без CALL
                      ltyp inlinable?
                      IF   DP @ lrlen 1- MOVE  DP @ lrlen 1- + DP !
                      ELSE _COMPILE,
                      THEN
                 THEN
            THEN THEN
  THEN 0 st-wr ! ;

\ переменные однопоточные
: NOTFOUND ( a u --  ) \ 2variable variable    "name)"
  ')' { a u s } nf1-exit 1-  ldhere ALIGNED DUP TO ldhere lxt !
  headl  0x40 axtloc @ 4 + C!  \ запись хранит адрес хранилища
  ldhere 2 CELLS + TO ldhere ;

: NOTFOUND ( a u --  ) \ value   "name\"
  '\' { a u s } nf1-exit 1-  ldhere ALIGNED DUP TO ldhere lxt !
  headl  0x40 axtloc @ 4 + C!
  ldhere LIT, ` !                    \ запись при инициализации, тот же код, что у "value !"
  ldhere 1 CELLS + TO ldhere ;
: NOTFOUND ( a u --  ) \ 2value  "name!d"
  '!d' { a u s } nf2-exit 2-  ldhere ALIGNED DUP TO ldhere lxt !
  headl  0x40 axtloc @ 4 + C!
  ldhere LIT, ` 2!
  ldhere 2 CELLS + TO ldhere ;
: NOTFOUND ( a u --  ) \ fvalue  "name$"
  '$' { a u s } nf1-exit 1-  ldhere ALIGNED DUP TO ldhere lxt !
  headl  0x40 axtloc @ 4 + C!
  ldhere LIT, ` F!                          \ запись при инициализации: встроенное двойное
  ldhere 2 CELLS + TO ldhere ;

\ переменные многопоточные
: NOTFOUND ( a u --  ) \ значение в области задачи   "name_"
  '_' { a u s } nf1-exit 1-  udhere lxt !  headl  0x40 axtloc @ 4 + C!
  ` usn! ` DROP                       \ запись при инициализации, та же, что у "-> name_"
  udhere 1 CELLS + TO udhere ;
: NOTFOUND ( a u --  ) \ value   "name%"
  '%' { a u s } nf1-exit 1-  ` usn! ` DROP \ 2 ltyp !
  body> lxt ! headl
  ` DUP  ` usn@ RET, DP @ TO wxt        \ вход по чтению
  ` usn! ` DROP RET,                    \ вход по записи
  udhere 1 CELLS + TO udhere
  <body wdelta, ;
: NOTFOUND ( a u --  ) \ fvalue  "name;"  64-битное число с плавающей точкой в области задачи (fld/fstp qword)
  ';' { a u s } nf1-exit 1-  ` fstpq
  body> lxt ! headl
  ` fldq RET, DP @ TO wxt               \ вход по чтению
  ` fstpq RET,                          \ вход по записи
  udhere 2 CELLS + TO udhere
  <body wdelta, ;

\ массивы однопоточные
: NOTFOUND ( a u --  ) \ [ 20 ] arr]
  ']' { a u s } nf1-exit 1-  ldhere ALIGNED DUP TO ldhere lxt !
  headl  0x40 axtloc @ 4 + C!
  ldhere + TO ldhere ;
\ массивы многопоточные
: NOTFOUND ( a u --  ) \ [ 20 ] arr}
  '}' { a u s } nf1-exit 1-  body> lxt ! headl
  ` DUP ` adr@ RET,
  udhere + TO udhere
  <body nodelta, ;

\ векторы
: NOTFOUND ( a u --  ) \ вектор "name^"
  '^' { a u s } nf1-exit 1-  ldhere ALIGNED TO ldhere
  ldhere LIT, ` !                       \ запись при инициализации: xt со стека
  body> lxt ! headl
  ldhere LIT, ` @ ` EXECUTE RET, DP @ TO wxt \ вход по чтению
  ldhere LIT, ` ! RET,                  \ вход по записи
  1 CELLS ldhere + TO ldhere
  <body wdelta, ;

\ исполнение из forth, а если там нет - то из локального словаря
: NOTFOUND ( c-addr u -- ) { a u | [ 16 ] arr }
 a u + 1- C@ '`' = u 1 > AND 0= IF a u NOTFOUND EXIT THEN
 a u 1- SFIND IF EXECUTE              \ поиск в текущем глобальном словаре
              ELSE lvoc 2SWAP lsearch \ поиск в локальном словаре
                   IF + 1+ DUP 4 + C@ 0x40 AND
                      IF   DROP a u 1- NOTFOUND \ прямой адрес: компилируем обычное обращение
                      ELSE @ EXECUTE            \ вход по чтению: строка/макрос/модификатор/локальное слово
                      THEN
                   ELSE TYPE SPACE S" not found " TYPE CR
                   THEN
              THEN
;
\ распознавание числа с плавающей точкой  ( "1,0"  "-123,045" )
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
