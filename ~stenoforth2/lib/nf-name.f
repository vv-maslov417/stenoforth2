\ stenoforth32

\ �८�ࠧ���⥫� ���ᥬ 's','ss','sss','ssss' [s-�� ascii char] � �����୮� �᫮
: NOTFOUND { a u } \ -- n
  a C@ [CHAR] ' = a u + 1- C@ [CHAR] ' = AND u 3 6 1+ WITHIN AND 0= \ �ᯮ�����⥫�
  IF a u NOTFOUND EXIT THEN
  0 a 1+ a u + 2- DO 8 LSHIFT I C@ + -1 +LOOP STATE @ IF LIT, THEN  \ �������
;

: LOAD-LEX \ a u --
   S, BL C,    \ 0 C, ******
;
: load-text ( -- a u )
  5 ALLOT DP @ >R
  BEGIN NextWord ( -- a u )
  2DUP  DUP  2 = SWAP 1 = OR  \ a u a f
        IF   DUP  W@ DUP ';M' = SWAP DUP 'm)' = SWAP DUP 'c)' = SWAP DUP ':}' = SWAP '")' = OR OR OR OR SWAP
                  C@ DUP ';'  = SWAP DUP '"'  = DUP IF 0 C, THEN SWAP DUP '}' = SWAP ']'  = OR OR OR OR \ a u f
             IF   2DROP 1
             ELSE OVER C@ '\' =
                  IF   DROP 0xD PARSE DROP OVER - ERASE  \ a a1 a
                  ELSE LOAD-LEX THEN 0
             THEN
        ELSE DROP DUP 0=
             IF 2DROP REFILL DROP ELSE LOAD-LEX THEN 0
        THEN
  UNTIL
  DP @ R@ 5 - DP ! 0xE9 C, DUP R@ - ,
  DUP DP ! R@ SWAP R> - 1-
;
: LOAD-TEXT \ a u --
  load-text DLIT,
;
: load-str ( -- a u )
  5 ALLOT DP @ >R
  BEGIN NextWord ( -- a u )
  2DUP  1 =   \ a u a f
        IF   B@ ';' =  \ a u f
             IF   2DROP 1
             ELSE OVER B@ '\' =
                  IF   DROP 0xD PARSE DROP OVER - ERASE  \ a a1 a
                  ELSE LOAD-LEX THEN 0
             THEN
        ELSE DROP DUP 0=
             IF 2DROP REFILL DROP ELSE LOAD-LEX THEN 0
        THEN
  UNTIL
  DP @ R@ 5 - DP ! 0xE9 C, DUP R@ - ,
  DUP DP ! R@ SWAP R> - 1-
;
: LOAD-STR  \ a u --
  load-str  DLIT,
;
: load-txt ( -- a u )
  5 ALLOT DP @ >R
  BEGIN
       REFILL DROP
       0xD PARSE 2DUP DROP C@ 0xF9 = \  ������������ ᨬ��� '�'
          IF   2DROP 1
          ELSE LOAD-LEX 0xA C, 0xD C, 0
          THEN
  UNTIL
  DP @ R@ 5 - DP ! 0xE9 C, DUP R@ - ,
  DUP DP ! R@ SWAP R> - 1-
;
\ ���������� ��ப� ��� ����
: LOAD-TXT  load-txt DLIT, ;
\ ( "name" "text" -- )
: txt: : LOAD-TXT POSTPONE ; ;
: text: : LOAD-TXT POSTPONE ; ;

\ �����-��ப� ���������� - ����᪠�� �������ਨ ���� \ .....
: T:   ( name "text" -- ) : LOAD-TEXT POSTPONE ; ;
: t:   ( name "text" -- ) : LOAD-STR  POSTPONE ; ;
\ ����� ��� ��������� �ଠ�஢���� - ���������� ��ப�

\ ������ ���������� - ����᪠�� �������ਨ ���� \ .....
: M:  : IMMEDIATE LOAD-TEXT POSTPONE EVALUATE POSTPONE ; ;
: m:  : IMMEDIATE LOAD-STR  POSTPONE EVALUATE POSTPONE ; ;
: tx: : IMMEDIATE LOAD-TXT  POSTPONE EVALUATE POSTPONE ; ;

\ ���몠���
: xts ( a u -- xt )
  DP @ >R 1024 ALLOCATE THROW DUP >R DP !
  TRUE STATE ! EVALUATE RET, FALSE STATE !
  R@ DP @ R> - RESIZE THROW  R> DP !
;
\ ��।������ ᫮��-���몠��� C: Name .... ;
: C: : IMMEDIATE LOAD-TEXT ` xts POSTPONE ; ;
