\ =====================================================================
\  Сборка win-demo.exe - приложения БЕЗ консольного окна
\
\  Запуск из любой текущей папки (например, кнопкой из редактора):
\      spf486.exe путь\к\example\win-demo-gui.f
\
\  Результат: win-demo.exe рядом с ЭТИМ сценарием, а не в текущей папке.
\  У собранного exe в заголовке PE подсистема GUI (Subsystem = 2),
\  поэтому консольное окно не создаётся вообще.
\
\  Как это работает:
\    SOURCE-NAME - полный путь к текущему файлу (этому сценарию), поэтому
\                  пути к win-demo.f и win-demo.exe не зависят от CWD;
\    BUILDING?   - флаг, который win-demo.f читает в конце: при TRUE он
\                  только компилирует слова и не запускает DEMO;
\    MAINX       - точка входа GUI-приложения SP-Forth;
\    ?GUI        - TRUE переключает SAVE на GUI-подсистему.
\ =====================================================================

VARIABLE BUILDING?
TRUE BUILDING? !

\ ------------------------------------------------- работа со строками
CREATE TBUF   260 ALLOT   VARIABLE TLEN
CREATE SRCBUF 260 ALLOT   VARIABLE SRCLEN
CREATE EXEBUF 260 ALLOT   VARIABLE EXELEN

: BUF-CLEAR ( -- ) 0 TLEN ! ;

: BUF+ { a u }                         \ дописать строку в TBUF
  a TBUF TLEN @ + u CMOVE
  TLEN @ u + TLEN !
;

: LAST-BSL { a u \ p }                 \ позиция последнего '\' или -1
  u 0 ?DO
    u I - 1- TO p
    p a + C@ 92 =
    IF p UNLOOP EXIT THEN
  LOOP
  -1
;

: DIR-OF { a u \ n }                   \ каталог вместе с завершающим '\'
  a u LAST-BSL TO n
  n 0< IF S" " EXIT THEN
  a n 1+
;

: MAKE-PATH { a u }                    \ TBUF := каталог этого файла + a u
  BUF-CLEAR
  SOURCE-NAME DIR-OF BUF+
  a u BUF+
;

: COPY-BUF { buf lv }                  \ TBUF -> buf, длина -> lv
  TLEN @ lv !
  TBUF buf TLEN @ CMOVE
;

\ --------------------------------------------------------------- сборка
: BUILD-EXE ( -- )
  \ пути считаем сразу: после INCLUDED SOURCE-NAME указывает уже на другой файл
  S" win-demo.f"   MAKE-PATH SRCBUF SRCLEN COPY-BUF
  S" win-demo.exe" MAKE-PATH EXEBUF EXELEN COPY-BUF

  SRCBUF SRCLEN @ ['] INCLUDED CATCH
  IF
    S" Не удалось загрузить: " TYPE SRCBUF SRCLEN @ TYPE CR
    BYE
  THEN

  S" MAIN" SFIND IF
    MAINX !
  ELSE
    2DROP S" Не найден MAIN в win-demo.f" TYPE CR BYE
  THEN
  TRUE TO ?GUI
  EXEBUF EXELEN @ SAVE

  S" собрано: " TYPE EXEBUF EXELEN @ TYPE CR
;

BUILD-EXE
BYE
