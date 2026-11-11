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

\ каталог сценария. Если SOURCE-NAME пуст (сценарий подан на stdin - так,
\ например, запускают редакторы), берём каталог spf486.exe и поднимаемся
\ из bin\ в example\
CREATE GUI-MBUF 260 ALLOT
CREATE GUI-DBUF 260 ALLOT   VARIABLE GUI-DLEN

: GUI-EXE-DIR ( -- a u )               \ каталог spf486.exe вместе с '\'
  260 GUI-MBUF 0 GetModuleFileNameA    \ -> длина пути
  GUI-MBUF SWAP DIR-OF ;

: GUI-DBUF+ { a u }                    \ дописать строку в GUI-DBUF
  a GUI-DBUF GUI-DLEN @ + u CMOVE
  GUI-DLEN @ u + GUI-DLEN !
;

: BASE-DIR ( -- a u )                  \ каталог, где лежат win-demo.f и .exe
  SOURCE-NAME DIR-OF DUP 0= IF
    2DROP
    0 GUI-DLEN !                       \ отдельный буфер: TBUF здесь нельзя,
    GUI-EXE-DIR GUI-DBUF+              \ иначе MAKE-PATH допишет TBUF в себя
    S" ..\example\" GUI-DBUF+
    GUI-DBUF GUI-DLEN @
  THEN ;

: MAKE-PATH { a u }                    \ TBUF := BASE-DIR + a u
  BUF-CLEAR
  BASE-DIR BUF+
  a u BUF+
;

: COPY-BUF { buf lv }                  \ TBUF -> buf, длина -> lv
  TLEN @ lv !
  TBUF buf TLEN @ CMOVE
;

\ ------------------------------------------------------------ диагностика
\ Пишем короткий лог рядом с win-demo.exe: по нему видно, откуда запущено,
\ что вернул SOURCE-NAME и какие пути получились.
CREATE LOG-BUF 512 ALLOT   VARIABLE LOG-LEN

: LOG-RESET ( -- ) 0 LOG-LEN ! ;
: LOG+ { a u }                         \ дописать строку в LOG-BUF
  a LOG-BUF LOG-LEN @ + u CMOVE
  LOG-LEN @ u + LOG-LEN ! ;

: LOG-PATH ( -- a u )                  \ каталог exe + "win-demo-gui.log"
  BUF-CLEAR
  EXEBUF EXELEN @ DIR-OF BUF+
  S" win-demo-gui.log" BUF+
  TBUF TLEN @ ;

: LOG-FLUSH { \ fid ior }
  LOG-PATH R/W CREATE-FILE TO ior TO fid
  ior IF EXIT THEN
  LOG-BUF LOG-LEN @ fid WRITE-FILE DROP
  fid CLOSE-FILE DROP ;

: PATHS+ ( -- )
  S" exe dir=[" LOG+ GUI-EXE-DIR LOG+
  S" ] source=[" LOG+ SOURCE-NAME LOG+
  S" ] src=[" LOG+ SRCBUF SRCLEN @ LOG+
  S" ] exe=[" LOG+ EXEBUF EXELEN @ LOG+
  S" ]" LOG+ ;

: LOG-PATHS ( -- )  LOG-RESET PATHS+ LOG-FLUSH ;
: LOG-FAIL { a u }  LOG-RESET PATHS+ S"  FAILED: " LOG+ a u LOG+ LOG-FLUSH ;

\ --------------------------------------------------------------- сборка
: BUILD-EXE ( -- )
  \ пути считаем сразу: после INCLUDED SOURCE-NAME указывает уже на другой файл
  S" win-demo.f"   MAKE-PATH SRCBUF SRCLEN COPY-BUF
  S" win-demo.exe" MAKE-PATH EXEBUF EXELEN COPY-BUF
  LOG-PATHS
  S" exe dir: " TYPE GUI-EXE-DIR TYPE CR
  S" src    : " TYPE SRCBUF SRCLEN @ TYPE CR
  S" exe    : " TYPE EXEBUF EXELEN @ TYPE CR

  SRCBUF SRCLEN @ ['] INCLUDED CATCH
  IF
    S" Не удалось загрузить: " TYPE SRCBUF SRCLEN @ TYPE CR
    S" INCLUDED failed" LOG-FAIL
    BYE
  THEN

  S" MAIN" SFIND IF
    MAINX !
  ELSE
    2DROP S" Не найден MAIN в win-demo.f" TYPE CR
    S" no MAIN" LOG-FAIL
    BYE
  THEN
  TRUE TO ?GUI
  EXEBUF EXELEN @ ['] SAVE CATCH
  IF
    S" SAVE failed, код " TYPE . CR
    S" SAVE failed" LOG-FAIL
    BYE
  THEN

  S" собрано: " TYPE EXEBUF EXELEN @ TYPE CR
;

BUILD-EXE
BYE
