\ =====================================================================
\  gui-form.f - пример формы на gui-kit
\  Рабочий файл: только подгрузка библиотеки и описание формы.
\  Правила параметризации - в шапке gui-kit.f.
\
\  Запуск:  spf486.exe gui-form.f
\ =====================================================================

REQUIRE WINDOW gui-kit.f
"Демо: приветствие"            WINDOW main 520 300
"&Файл"                        MENU
"&Выход"                       ITEM ^Q on-quit
"&Справка"                     MENU
"&О программе"                 ITEM - on-about
"Имя:"                         TEXT lname 16 16 120 18
                               EDIT ifld  140 14 340 24
"Приветствие:"                 TEXT lout  16 56 120 18
                               EDIT otvet 140 54 340 24
"Поздороваться"                BUTTON okbt 16 96 160 30 on-ok
"Выход"                        BUTTON bqit 190 96 160 30 on-quit
FORM-END

\ -------------------------------------------------------- обработчики
CREATE GREET 256 ALLOT  VARIABLE GLEN
: GADD { a u }  a GREET GLEN @ + u CMOVE  GLEN @ u + GLEN ! ;

: on-ok ( -- )
  0 GLEN !
  S" Привет, "  GADD
  ifld @ TEXT@  GADD
  S" !"  GADD
  GREET GLEN @ otvet @ TEXT!
;

: on-quit  ( -- ) QUIT-APP ;
: on-about ( -- ) S" gui-kit: WINDOW MENU ITEM TEXT EDIT BUTTON FORM-END SHOW" otvet @ TEXT! ;

\ ------------------------------------------------------------ запуск
HIDE-CONSOLE
SHOW main
BYE
