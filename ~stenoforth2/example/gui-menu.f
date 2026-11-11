\ =====================================================================
\  gui-menu.f - меню с вложенными подменю
\  Рабочий файл: только подгрузка библиотеки и описание формы.
\
\  Запуск:  spf486.exe gui-menu.f
\ =====================================================================

\ REQUIRE WINDOW gui-kit.f

"Вложенные меню"               WINDOW main 560 300
"Выбрано:"                     TEXT   lbl0 16 16 80 18
"-"                            TEXT   val0 100 16 430 18
"&Файл"                        MENU
"&Новый"                       ITEM ^N on-new
"&Открыть"                     ITEM ^O on-open
"Не&давние"                    SUBMENU
"Документ 1"                   ITEM - on-doc1
"Документ 2"                   ITEM - on-doc2
"Ещё"                          SUBMENU
"Вложенный пункт"              ITEM - on-doc3
                               MENU-END
                               MENU-END
"В&ыход"                       ITEM ^Q on-quit
"&Правка"                      MENU
"&Копировать"                  ITEM ^C on-copy
"В&ставить"                    ITEM ^V on-paste
FORM-END

\ ------------------------------------------------------------ обработчики
: SAY-OUT ( a u -- ) val0 @ TEXT! ;

: on-new   ( -- ) S" Новый документ"       SAY-OUT ;
: on-open  ( -- ) S" Открыть файл"         SAY-OUT ;
: on-doc1  ( -- ) S" Недавний: документ 1" SAY-OUT ;
: on-doc2  ( -- ) S" Недавний: документ 2" SAY-OUT ;
: on-doc3  ( -- ) S" Вложенный пункт"      SAY-OUT ;
: on-copy  ( -- ) S" Копировать"           SAY-OUT ;
: on-paste ( -- ) S" Вставить"             SAY-OUT ;
: on-quit  ( -- ) QUIT-APP ;

\ ---------------------------------------------------------------- запуск
4 RESIZE-MARGIN
HIDE-CONSOLE
SHOW main
BYE
