\ =====================================================================
\  gui-ini.f - сохранение состояния формы в ini-файл
\  Рабочий файл: только подгрузка библиотеки и описание формы.
\
\  Запуск:  spf486.exe gui-ini.f
\  Кнопки "Сохранить"/"Загрузить" пишут и читают state.ini рядом с exe:
\  положение и размер окна, текст поля, флажок, ползунок, выбор в списке.
\ =====================================================================

REQUIRE WINDOW gui-kit.f

"Состояние формы"            WINDOW main 560 360
"Имя:"                       TEXT   lbl0  16 16 60 18
STRETCH-W                             EDIT   edit1  84 14 440 24
"Звук включён"                CHECK  chkb 16 52 200 24 on-chk
                              SLIDER svol 16 86 400 30 0 100 H on-vol
"Уровень:"                    TEXT   lbl1  16 124 60 18
"-"                           TEXT   val1  84 124 60 18
                              LISTBOX list1 16 154 300 110 on-lb
"Сохранить"                   BUTTON bsave 330 154 190 32 on-save
"Загрузить"                   BUTTON bload 330 196 190 32 on-load
FORM-END

\ ------------------------------------------------------------ обработчики
: INIFILE ( -- a u ) S" state.ini" ;

: SHOWV ( -- ) svol @ POS@ >NUMSTR val1 @ TEXT! ;

: on-save ( -- ) INIFILE SAVE-INI ;
: on-load ( -- ) INIFILE LOAD-INI SHOWV ;

: on-vol ( -- ) SHOWV ;

\ ---------------------------------------------------------------- запуск
"первый"  list1 @ ITEM+
"второй"  list1 @ ITEM+
"третий"  list1 @ ITEM+
SHOWV
4 RESIZE-MARGIN
HIDE-CONSOLE
SHOW main
BYE
