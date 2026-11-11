\ =====================================================================
\  gui-kit.f - библиотека GUI-компонентов для Windows
\  SP-Forth 4.29 / StenoForth, 32-разрядная Windows
\
\  Всё описание компонентов и правил параметризации - здесь, один раз.
\  Рабочий файл содержит только:
\      REQUIRE WINDOW gui-kit.f     \ подгрузка библиотеки (если её нет в образе)
\      ... описание формы ...
\      END
\      HIDE-CONSOLE SHOW имя        \ показать и войти в цикл сообщений
\
\  ОБЩЕЕ ПРАВИЛО СИНТАКСИСА
\    Текст компонента пишется ПЕРЕД словом и попадает на стек, само слово
\    разбирает за собой имя и числа. Одна строка - один компонент.
\
\      "Заголовок"   WINDOW main 520 300
\      "&Файл"       MENU
\      "&Выход"      ITEM ^Q on-quit
\
\  МОДИФИКАТОР ОКНА
\    TOPMOST    строка перед WINDOW - окно остаётся поверх всех остальных
\      TOPMOST
\      "Поверх всех"  WINDOW top 400 300
\    Действует на ближайшую строку WINDOW; после неё флаг сбрасывается.
\    Тот же эффект из кода для готового окна:  имя @ TOPMOST!
\
\  КОМПОНЕНТЫ  (в скобках - что забирается со стека до слова)
\
\    WINDOW ( a u ) "имя" ширина высота      окно; "имя" создаёт слово -> HWND
\    DIALOG ( a u ) "имя" ширина высота      модальное окно: компоненты те же,
\                                            показывать через SHOW-DIALOG
\    MENU   ( a u )                          выпадающее меню верхнего уровня
\    ITEM   ( a u ) "ускоритель" "обработчик"
\                                            пункт меню; ускоритель: ^Q или -
\    SUBMENU ( a u )                         открыть подменю в текущем меню
\    MENU-END                                вернуться на уровень выше
\    TEXT   ( a u ) "имя" x y w h            статическая надпись
\    EDIT          "имя" x y w h             поле ввода (текст задаётся кодом)
\    BUTTON ( a u ) "имя" x y w h "обработчик"
\                                            кнопка
\    CHECK  ( a u ) "имя" x y w h "обработчик"
\                                            флажок (независимый)
\    RADIO  ( a u ) "имя" x y w h "группа" "обработчик"
\                                            переключатель; "группа": G - первый
\                                            в группе, - - продолжение группы
\    SLIDER        "имя" x y w h min max "H|V" "обработчик"
\                                            ползунок; H - горизонтальный,
\                                            V - вертикальный; min/max - диапазон
\    GROUPBOX ( a u ) "имя" x y w h          рамка с заголовком (текст - заголовок)
\    LISTBOX       "имя" x y w h "обработчик"     список
\    COMBO         "имя" x y w h "обработчик"     выпадающий список
\    END                                     конец описания формы
\    SHOW          "имя"                     показать форму, цикл сообщений
\
\  ЯКОРЯ  (слово ставится ПЕРЕД строкой компонента, действует на неё одну)
\    STRETCH-W    - ширина тянется вместе с окном
\    STRETCH-H    - высота тянется вместе с окном
\    STRETCH      - и ширина, и высота
\    MOVE-R       - правый край держится за окном
\    MOVE-B       - нижний край держится за окном
\
\      STRETCH-W "Поле:"   EDIT    ed 16 16 500 24
\      STRETCH-H "Список"  LISTBOX lb 16 60 500 200 on-lb
\      MOVE-B    "OK"      BUTTON  ok 16 320 120 32 on-ok
\
\  КРАЯ ОКНА ДЛЯ МЫШИ
\    n RESIZE-MARGIN  - расширить зону захвата краёв внутрь клиентской части
\                       на n пикселей (по умолчанию 0 - стандартная рамка).
\                       Помогает, когда за тонкую нижнюю рамку трудно зацепиться.
\
\  ЗНАЧЕНИЯ КОМПОНЕНТОВ
\    имя              - адрес ячейки с HWND:   имя @   = HWND
\    a u HWND TEXT!   - записать текст (поле ввода)
\    HWND TEXT@       - ( -- a u ) прочитать текст
\    HWND STATE@      - ( -- 0/1 ) состояние флажка/переключателя
\    n HWND STATE!    - установить состояние
\    HWND POS@        - ( -- n ) позиция ползунка
\    n HWND POS!      - установить позицию
\    min max HWND RANGE! - сменить диапазон ползунка
\    a u HWND ITEM+   - добавить строку в список/выпадающий список
\    HWND SEL@        - ( -- n ) номер выбранной строки (-1 = нет)
\    n HWND SEL!      - выбрать строку n
\    HWND SELTEXT@    - ( -- a u ) текст выбранной строки
\    HWND LCOUNT@     - ( -- n ) число строк
\    QUIT-APP         - закрыть форму и выйти
\    HIDE-CONSOLE     - убрать консольное окно (у exe с GUI-подсистемой нет)
\
\  ДИАЛОГИ
\    имя @ SHOW-DIALOG    - показать модально: владелец заблокирован, пока
\                           диалог не закрыт (крестиком или из обработчика)
\    "Тексты|*.txt|Все файлы|*.*|" OPEN-FILE   ( -- a u f )
\    "Тексты|*.txt"                SAVE-FILE   ( -- a u f )
\                         - системный диалог выбора файла; f=1 - выбран,
\                           a u - путь в кодировке исходника (0 0 при отказе)
\    a u FILE-NAME!       - имя файла, предложенное в диалоге сохранения
\
\  СОСТОЯНИЕ ФОРМЫ (ini)
\    "имя.ini" SAVE-INI   - записать положение и размер окна, текст полей,
\                           флажки, ползунки, выбранные строки списков
\    "имя.ini" LOAD-INI   - прочитать и применить (до SHOW, иначе до первого показа)
\    Файл обычный ini, секция [form]; ключ - имя компонента из описания формы.
\    Сохраняются только компоненты, которым в описании дано имя.
\
\  ОБРАБОТЧИКИ
\    Обычные форт-слова; имя ищется в момент события, поэтому их можно
\    объявлять где угодно - обычно после END. Вызываются не из оконной
\    процедуры, а из цикла сообщений (вложенный вызов форта в этой сборке
\    ненадёжен). События: нажатие кнопки/флажка/переключателя/пункта меню
\    (WM_COMMAND) и перемещение ползунка (WM_HSCROLL/WM_VSCROLL), причём
\    id ползунка определяется по lParam.
\
\  КОДИРОВКИ
\    Исходник может быть в UTF-8, cp1251 или cp866 - строки для WinAPI
\    определяются автоматически и запоминаются в SRC-CP. Жёстко задать:
\        866 SRC-CP !      \ или 1251, или 65001
\
\  В строке WINDOW cbpSize и стили заданы внутри; прочие детали Win32
\  (классы контролов, стили, сообщения) скрыты - наружу только этот синтаксис.
\ =====================================================================
0 WARNING !

\ ---------------------------------------------------------------- Win32
WINAPI: GetModuleHandleA        KERNEL32.DLL
WINAPI: GetCurrentThreadId      KERNEL32.DLL
WINAPI: MultiByteToWideChar     KERNEL32.DLL
WINAPI: WideCharToMultiByte     KERNEL32.DLL
WINAPI: RegisterClassExW        USER32.DLL
WINAPI: CreateWindowExW         USER32.DLL
WINAPI: DefWindowProcW          USER32.DLL
WINAPI: GetMessageW             USER32.DLL
WINAPI: TranslateMessage        USER32.DLL
WINAPI: DispatchMessageW        USER32.DLL
WINAPI: ShowWindow              USER32.DLL
WINAPI: UpdateWindow            USER32.DLL
WINAPI: IsWindow                USER32.DLL
WINAPI: EnableWindow             USER32.DLL
WINAPI: DestroyWindow           USER32.DLL
WINAPI: PostThreadMessageA      USER32.DLL
WINAPI: GetWindowTextW          USER32.DLL
WINAPI: SendMessageW            USER32.DLL
WINAPI: PostMessageA            USER32.DLL
WINAPI: GetDlgCtrlID            USER32.DLL
WINAPI: GetClassNameW           USER32.DLL
WINAPI: GetDlgCtrlID            USER32.DLL
WINAPI: GetClassNameW           USER32.DLL
WINAPI: SetWindowTextW          USER32.DLL
WINAPI: SetWindowPos             USER32.DLL
WINAPI: GetClientRect            USER32.DLL
WINAPI: GetWindow                USER32.DLL
WINAPI: SetPropW                 USER32.DLL
WINAPI: SetWindowLongW            USER32.DLL
WINAPI: GetWindowLongW            USER32.DLL
WINAPI: GetPropW                 USER32.DLL
WINAPI: MapWindowPoints          USER32.DLL
WINAPI: GetWindowRect             USER32.DLL
WINAPI: CreateMenu              USER32.DLL
WINAPI: CreatePopupMenu         USER32.DLL
WINAPI: AppendMenuW             USER32.DLL
WINAPI: SetMenu                 USER32.DLL
WINAPI: DrawMenuBar             USER32.DLL
WINAPI: CreateAcceleratorTableW USER32.DLL
WINAPI: TranslateAcceleratorW   USER32.DLL
WINAPI: GetConsoleWindow        KERNEL32.DLL

\ ----------------------------------------------------------- константы
0x00CF0000 CONSTANT WS_OVERLAPPEDWINDOW
0x40000000 CONSTANT WS_CHILD
0x10000000 CONSTANT WS_VISIBLE
0x80000000 CONSTANT WS_POPUP
0x00C00000 CONSTANT WS_CAPTION
0x00080000 CONSTANT WS_SYSMENU
0x00800000 CONSTANT WS_BORDER
0x00000200 CONSTANT WS_EX_CLIENTEDGE
0x00000008 CONSTANT WS_EX_TOPMOST
         1 CONSTANT SWP_NOSIZE
         2 CONSTANT SWP_NOMOVE
         4 CONSTANT SWP_NOZORDER
        16 CONSTANT SWP_NOACTIVATE
         5 CONSTANT GW_CHILD
         2 CONSTANT GW_HWNDNEXT
       100 CONSTANT PROP-MX
       101 CONSTANT PROP-MY
       102 CONSTANT PROP-NAME
       103 CONSTANT PROP-NAMELEN

         5 CONSTANT SW_SHOW
0x00000080 CONSTANT ES_AUTOHSCROLL
0x00000000 CONSTANT BS_PUSHBUTTON
0x00000000 CONSTANT SS_LEFT

0x0002 CONSTANT WM_DESTROY
0x0111 CONSTANT WM_COMMAND
0x0005 CONSTANT WM_SIZE
0x0214 CONSTANT WM_SIZING
0x0084 CONSTANT WM_NCHITTEST
           1 CONSTANT HTCLIENT
          10 CONSTANT HTLEFT
          11 CONSTANT HTRIGHT
          12 CONSTANT HTTOP
          15 CONSTANT HTBOTTOM
0x0012 CONSTANT WM_QUIT

0x0010 CONSTANT MF_POPUP
0x0000 CONSTANT MF_STRING
0x0009 CONSTANT ACC_CTRL            \ FVIRTKEY or FCONTROL

0x0000FFFF CONSTANT COMMAND-ID

0x00010000 CONSTANT WS_GROUP
0x00000003 CONSTANT BS_AUTOCHECKBOX
0x00000009 CONSTANT BS_AUTORADIOBUTTON
0x00000002 CONSTANT TBS_VERT
0x00000000 CONSTANT TBS_HORZ

0x0114 CONSTANT WM_HSCROLL
0x0115 CONSTANT WM_VSCROLL

0x00000007 CONSTANT BS_GROUPBOX
0x00200000 CONSTANT WS_VSCROLL
0x00000001 CONSTANT LBS_NOTIFY
0x00000100 CONSTANT LBS_NOINTEGRALHEIGHT
0x00000200 CONSTANT CBS_NOINTEGRALHEIGHT
0x00000003 CONSTANT CBS_DROPDOWNLIST

0x0180 CONSTANT LB_ADDSTRING
0x0186 CONSTANT LB_SETCURSEL
0x0188 CONSTANT LB_GETCURSEL
0x0189 CONSTANT LB_GETTEXT
0x018B CONSTANT LB_GETCOUNT
0x0143 CONSTANT CB_ADDSTRING
0x0146 CONSTANT CB_GETCOUNT
0x0147 CONSTANT CB_GETCURSEL
0x0148 CONSTANT CB_GETLBTEXT
0x014E CONSTANT CB_SETCURSEL
0x00F0 CONSTANT BM_GETCHECK
0x00F1 CONSTANT BM_SETCHECK
0x0400 CONSTANT TBM_GETPOS
0x0405 CONSTANT TBM_SETPOS
0x0406 CONSTANT TBM_SETRANGE
   6   CONSTANT BRUSH-WHITE     \ COLOR_WINDOW + 1

\ ----------------------------------------------------------- структуры
0
 CELL -- wcCbSize
 CELL -- wcStyle
 CELL -- wcLpfnWndProc
 CELL -- wcCbClsExtra
 CELL -- wcCbWndExtra
 CELL -- wcHInstance
 CELL -- wcHIcon
 CELL -- wcHCursor
 CELL -- wcHbrBackground
 CELL -- wcLpszMenuName
 CELL -- wcLpszClassName
 CELL -- wcHIconSm
CONSTANT /WNDCLASSEXW

0
 CELL -- mHwnd
 CELL -- mMessage
 CELL -- mWParam
 CELL -- mLParam
 CELL -- mTime
    8 -- mPt
CONSTANT /MSG

\ ACCEL { BYTE fVirt; WORD key; WORD cmd; } - поля выровнены по 2 байта
: acFVirt ( p -- p )      ;
: acKey   ( p -- p+2 )  2 + ;
: acCmd   ( p -- p+4 )  4 + ;
6 CONSTANT /ACCEL

\ -------------------------------------------------------------- буферы
CREATE WBUF   8 1024 * ALLOT        \ кольцо под UTF-16 строки
VARIABLE WIDX
CREATE WTB    512 2 * ALLOT         \ UTF-16 текст окна
CREATE AOBUF  1024 ALLOT            \ UTF-8 результат
CREATE MSGBUF /MSG ALLOT
CREATE WNDCLS /WNDCLASSEXW ALLOT
CREATE ACCBUF 64 /ACCEL * ALLOT
CREATE NAMBUF 64 ALLOT   VARIABLE NAMLEN
CREATE TXTBUF 256 ALLOT  VARIABLE TXTLEN

VARIABLE PARENT        \ окно, куда добавляются компоненты
VARIABLE MBAR          \ полоса меню
VARIABLE CUR-MENU      \ текущее выпадающее меню
CREATE MENUSTK 8 CELLS ALLOT      \ стек открытых подменю
VARIABLE MDEPTH        \ глубина вложенности меню
VARIABLE HACCEL        \ таблица горячих клавиш
VARIABLE NACC          \ число акселераторов
VARIABLE FORM          \ текущая форма (HWND)
VARIABLE ACCKEY        \ код клавиши текущего пункта
VARIABLE CLASSED?      \ класс окна уже зарегистрирован
VARIABLE TOP-CTX       \ следующее окно создавать поверх всех
VARIABLE PENDING       \ отложенная команда (id), выполняется в цикле сообщений

\ ------------------------------------------------------- обработчики
64 CONSTANT MAXH
VARIABLE NH
VARIABLE NEXT-ID
\ ------------------------------------------- раскладка при изменении размера
\ Якоря хранятся в свойствах самого окна-компонента (SetPropW), поэтому
\ таблиц, индексируемых по id, не нужно.
VARIABLE LASTH                    \ HWND последнего созданного компонента
VARIABLE PMX VARIABLE PMY         \ отложенный якорь для следующего компонента
VARIABLE CXC VARIABLE CYC         \ клиентская часть при последней раскладке
VARIABLE NEWW VARIABLE NEWH       \ размер клиента из lParam сообщения WM_SIZE
VARIABLE SIZEN VARIABLE SIZINGN   \ счётчики сообщений (для диагностики)
VARIABLE RMARGIN  0 RMARGIN !     \ расширение краёв для захвата мышью, px
CREATE RECTB 16 ALLOT
CREATE HIDS  MAXH CELLS ALLOT
CREATE HADDR MAXH CELLS ALLOT
CREATE HLEN  MAXH CELLS ALLOT

101 NEXT-ID !

: W-STORE { v ad }  v 256 MOD ad C!  v 256 / ad 1+ C! ;

\ -------------------------------------------------- UTF-8 <-> UTF-16
\ Кодировка строк в исходнике заранее неизвестна: редакторы сохраняют
\ UTF-8, cp1251 или cp866. Порядок определения в >W:
\   1) строгий UTF-8 (MB_ERR_INVALID_CHARS), 2) если байты похожи на
\   cp866 - cp866, иначе cp1251. Можно задать жёстко: SRC-CP !
\   (65001 - UTF-8, 1251, 866, 0 - автоопределение).
VARIABLE SRC-CP  0 SRC-CP !

VARIABLE CP-HI  VARIABLE CP-LO
: DETECT-CP ( a u -- cp )
  0 CP-HI !  0 CP-LO !
  BEGIN
    DUP 0=
    IF
      2DROP
      CP-HI @ CP-LO @ > IF 866 ELSE 1251 THEN
      EXIT
    THEN
    OVER C@
    DUP 127 > OVER 175 < AND IF CP-HI 1+! THEN
    DUP 191 > OVER 223 < AND IF CP-LO 1+! THEN
    DROP
    SWAP 1+ SWAP 1-
  AGAIN
;
: >W { a u \ slot dst n w cp }
  WIDX @ TO slot
  slot 1+ 7 AND WIDX !
  WBUF slot 1024 * + TO dst
  u 0= IF 0 dst ! dst EXIT THEN
  u 511 MIN TO n
  SRC-CP @
  IF
    SRC-CP @ TO cp
    512 dst n a 0 cp MultiByteToWideChar TO w
  ELSE
    512 dst n a 8 65001 MultiByteToWideChar TO w          \ строгий UTF-8
    w 0=
    IF
      a u DETECT-CP TO cp
      cp SRC-CP !                                         \ запомнить кодировку
      512 dst n a 0 cp MultiByteToWideChar TO w
    THEN
  THEN
  0 dst w 2* + W-STORE
  dst
;

: SRC-CODE ( -- cp )  SRC-CP @ 0= IF 65001 ELSE SRC-CP @ THEN ;

\ Обратное преобразование: Unicode -> кодировка исходника, чтобы результаты
\ TEXT@ можно было склеивать с литералами из исходника.
: W>TEXT { waddr n }
  0 0 1024 AOBUF n waddr 0 SRC-CODE WideCharToMultiByte
  AOBUF SWAP
;
: TEXT@ { h \ n }
  255 WTB h GetWindowTextW TO n
  WTB n W>TEXT
;

: TEXT! { a u h }
  a u >W h SetWindowTextW DROP
;

\ ------------------------------------------------------- имена/строки
: TOKEN ( -- a u ) BL WORD COUNT ;
: "  ( -- a u ) 34 PARSE ;

\ Число в описании: литерал, имя переменной или имя слова, выдающего число
\ (CONSTANT, VALUE, ": имя ... ;"). Переменная указывается БЕЗ @:
\     VARIABLE WW 520 WW !        "Демо" WINDOW main WW HH
\     520 CONSTANT CW             "Метка" TEXT l1 CW 40 120 18
\ Адрес переменной отличается от значений координат по величине.
: NUM ( "n" | "name" -- n )
  { \ a u xt }
  TOKEN TO u TO a
  a u NUMBER?
  IF DROP EXIT THEN
  2DROP
  a u SFIND IF TO xt ELSE 2DROP 0 TO xt THEN
  xt 0= IF S" gui-kit: ожидается число, имя переменной или слова" TYPE CR BYE THEN
  xt EXECUTE
  DUP 1000000 > IF @ THEN
;

: >NAM { a u \ n }
  u 63 MIN TO n
  n NAMLEN !
  a NAMBUF n CMOVE
;
: >TXT { a u \ n }
  u 255 MIN TO n
  n TXTLEN !
  a TXTBUF n CMOVE
;
: COPY-NAME { a u \ p }
  HERE TO p
  a p u CMOVE
  u ALLOT
  p
;

\ ------------------------------------------------ таблица обработчиков
: NEW-ID ( -- id ) NEXT-ID @ DUP 1+ NEXT-ID ! ;

: DEF-HANDLER { a u id \ p }
  NH @ MAXH < 0= IF EXIT THEN
  id  HIDS  NH @ CELLS + !
  a u COPY-NAME TO p
  p   HADDR NH @ CELLS + !
  u   HLEN  NH @ CELLS + !
  NH 1+!
;

: HANDLER-XT ( id -- xt | 0 )
  { id \ i res }
  0 TO res
  NH @ 0 ?DO
    res 0= IF
      id HIDS I CELLS + @ =
      IF
        HADDR I CELLS + @ HLEN I CELLS + @ SFIND
        IF TO res ELSE 2DROP THEN
      THEN
    THEN
  LOOP
  res
;
: ACCEL-ADD { key id \ p }
  ACCBUF NACC @ /ACCEL * + TO p
  ACC_CTRL p acFVirt C!
  key      p acKey   W-STORE
  id       p acCmd   W-STORE
  NACC 1+!
;

\ ------------------------------- захват краёв окна мышью (необязательно)
\ Стандартная рамка остаётся; RESIZE-MARGIN n расширяет зону захвата внутрь
\ клиентской части на n пикселей. 0 - как обычно. Помогает, когда за тонкий
\ нижний край трудно зацепиться мышью.
: RESIZE-MARGIN ( n -- ) RMARGIN ! ;

: HIT-EDGE { lp \ x y w hh m }
  RMARGIN @ TO m
  m 0= IF HTCLIENT EXIT THEN
  RECTB FORM @ GetWindowRect DROP
  lp COMMAND-ID AND  RECTB 0 + @ - TO x
  lp 65536 /         RECTB 4 + @ - TO y
  RECTB 8  + @ RECTB 0 + @ - TO w
  RECTB 12 + @ RECTB 4 + @ - TO hh
  y m <               IF HTTOP    EXIT THEN
  y m + hh < 0=       IF HTBOTTOM EXIT THEN
  x m <               IF HTLEFT   EXIT THEN
  x m + w < 0=        IF HTRIGHT  EXIT THEN
  HTCLIENT
;
\ ---------------------------------------------------- оконная процедура
: (WND-PROC) { lp wp msg hwnd \ id xt }
  msg WM_NCHITTEST =
  IF
    lp wp msg hwnd DefWindowProcW
    DUP HTCLIENT =
    IF DROP lp HIT-EDGE EXIT THEN
    EXIT
  THEN
  msg WM_SIZING =
  IF SIZINGN 1+! THEN                               \ счётчик для диагностики
  msg WM_SIZE =
  IF
    SIZEN 1+!
    lp COMMAND-ID AND NEWW !                        \ lParam: ширина (lo) и
    lp 65536 / NEWH !                               \ высота (hi) клиента
    -1 PENDING !                                    \ пересчитать раскладку
    0 0 0 GetCurrentThreadId PostThreadMessageA DROP
    lp wp msg hwnd DefWindowProcW EXIT              \ отдать системе как обычно
  THEN
  msg WM_COMMAND =
  IF
    \ Обработчик НЕ вызываем здесь: вложенный вызов форта из оконной
    \ процедуры в этой сборке ненадёжен. Запоминаем id, а вызывает его
    \ цикл сообщений (слово PUMP), уже в обычном контексте.
    wp COMMAND-ID AND PENDING !
    0 0 0 GetCurrentThreadId PostThreadMessageA DROP   \ разбудить цикл
    0 EXIT
  THEN
  msg WM_HSCROLL = msg WM_VSCROLL = OR
  IF
    \ lParam - окно ползунка: находим его id и обрабатываем как команду
    lp GetDlgCtrlID PENDING !
    0 0 0 GetCurrentThreadId PostThreadMessageA DROP
    0 EXIT
  THEN
  msg WM_DESTROY =
  IF
    0 WM_QUIT GetCurrentThreadId PostThreadMessageA DROP
    0 EXIT
  THEN
  lp wp msg hwnd DefWindowProcW
;
' (WND-PROC) WNDPROC: WND-PROC

: REGISTER-CLASS ( -- )
  CLASSED? @ IF EXIT THEN
  /WNDCLASSEXW            WNDCLS wcCbSize !
  3                       WNDCLS wcStyle !      \ CS_HREDRAW or CS_VREDRAW
  ['] WND-PROC            WNDCLS wcLpfnWndProc !
  0                       WNDCLS wcCbClsExtra !
  0                       WNDCLS wcCbWndExtra !
  0 GetModuleHandleA      WNDCLS wcHInstance !
  0                       WNDCLS wcHIcon !
  0                       WNDCLS wcHCursor !
  BRUSH-WHITE             WNDCLS wcHbrBackground !
  0                       WNDCLS wcLpszMenuName !
  S" GuiKitForm" >W       WNDCLS wcLpszClassName !
  0                       WNDCLS wcHIconSm !
  WNDCLS RegisterClassExW 0= ABORT" RegisterClassExW failed"
  TRUE CLASSED? !
;

\ ---------------------------------------------------- создание компонент
: MKCTRL { ca cu ex style x y w h id \ wc wt hc }
  ca cu >W TO wc
  TXTBUF TXTLEN @ >W TO wt
  0 0 GetModuleHandleA id PARENT @ h w y x style wt wc ex
  CreateWindowExW TO hc
  hc LASTH !
  PMX @ PMY @ 16 * +  21 NEGATE hc SetWindowLongW DROP   \ якорь строкой выше
  0 PMX !  0 PMY !
  hc
;

: DEF-CTRL { h \ p }              \ слово имя -> адрес ячейки с HWND
  NAMBUF NAMLEN @ COPY-NAME TO p  \ имя ещё и в свойствах: нужно для ini
  p        PROP-NAME     h SetPropW DROP
  NAMLEN @ PROP-NAMELEN  h SetPropW DROP
  h NAMBUF NAMLEN @ CREATED ,
;

\ Якоря: слово ставится ПЕРЕД строкой компонента и задаёт его поведение
\ при растягивании окна (действует на один, ближайший компонент).
\ По умолчанию компонент остаётся на месте.
\   STRETCH-W - ширина тянется за окном
\   STRETCH-H - высота тянется за окном
\   STRETCH   - и ширина, и высота
\   MOVE-R    - правый край держится за окном
\   MOVE-B    - нижний край держится за окном
: STRETCH-W ( -- ) 1 PMX ! ;
: STRETCH-H ( -- ) 1 PMY ! ;
: STRETCH   ( -- ) 1 PMX ! 1 PMY ! ;
: MOVE-R    ( -- ) 2 PMX ! ;
: MOVE-B    ( -- ) 2 PMY ! ;
\ --------------------------------------------- пересчёт раскладки по WM_SIZE
: CLIENT-W ( -- n ) RECTB FORM @ GetClientRect DROP RECTB 8  + @ ;
: CLIENT-H ( -- n ) RECTB FORM @ GetClientRect DROP RECTB 12 + @ ;

: RELAYOUT ( -- )                 \ применить якоря к новому размеру клиента
  { \ dx dy ch x y w hh mx my mm }
  NEWW @ CXC @ - TO dx
  NEWH @ CYC @ - TO dy
  dx 0= dy 0= AND IF EXIT THEN
  NEWW @ CXC !
  NEWH @ CYC !
  GW_CHILD FORM @ GetWindow TO ch
  BEGIN
    ch 0= IF EXIT THEN
    21 NEGATE ch GetWindowLongW TO mm
    mm 16 MOD TO mx
    mm 16 / TO my
    mx 0<> my 0<> OR
    IF
      RECTB ch GetWindowRect DROP
      2 RECTB FORM @ 0 MapWindowPoints DROP
      RECTB 0  + @ TO x
      RECTB 4  + @ TO y
      RECTB 8  + @ RECTB 0  + @ - TO w
      RECTB 12 + @ RECTB 4  + @ - TO hh
      mx 1 = IF w  dx + TO w  THEN
      mx 2 = IF x  dx + TO x  THEN
      my 1 = IF hh dy + TO hh THEN
      my 2 = IF y  dy + TO y  THEN
      w  0< IF 1 TO w  THEN
      hh 0< IF 1 TO hh THEN
      SWP_NOZORDER SWP_NOACTIVATE OR
      hh w y x 0 ch SetWindowPos DROP
    THEN
    GW_HWNDNEXT ch GetWindow TO ch
  AGAIN
;

\ -------------------------------------------------------------- синтаксис
\ Строки пишутся перед словом: их читает интерпретатор словом " ,
\ а имя и числа разбирает само слово. Пример:
\     "Заголовок"  WINDOW main 520 300
\     "Имя:"       TEXT   lname 16 16 120 18
\                  EDIT   ime 140 14 340 24
\     "OK"         BUTTON ok 16 96 160 30 on-ok

: TOPMOST ( -- )                  \ окно, описанное далее, - поверх всех
  TRUE TOP-CTX !
;

: TOPMOST! ( hwnd -- )            \ готовое окно - поверх всех
  { h } 3 0 0 0 0 -1 h SetWindowPos DROP
;

: WINDOW ( a u "name" w h -- )
  { ta tu \ w h hwnd }
  TOKEN >NAM
  NUM TO w
  NUM TO h
  ta tu >TXT
  REGISTER-CLASS
  0 0 GetModuleHandleA 0 0
  h w 100 100
  WS_OVERLAPPEDWINDOW
  TXTBUF TXTLEN @ >W
  S" GuiKitForm" >W
  TOP-CTX @ IF WS_EX_TOPMOST ELSE 0 THEN
  CreateWindowExW
  FALSE TOP-CTX !
  DUP 0= ABORT" CreateWindowExW failed"
  DUP TO hwnd
  DUP PARENT ! DUP FORM !
  DEF-CTRL
;

: DIALOG ( a u "name" w h -- )      \ модальное окно поверх владельца
  { ta tu \ w h hwnd }
  TOKEN >NAM
  NUM TO w
  NUM TO h
  ta tu >TXT
  REGISTER-CLASS
  0 0 GetModuleHandleA 0 FORM @
  h w 100 100
  WS_POPUP WS_CAPTION OR WS_SYSMENU OR
  TXTBUF TXTLEN @ >W
  S" GuiKitForm" >W
  TOP-CTX @ IF WS_EX_TOPMOST ELSE 0 THEN
  CreateWindowExW
  FALSE TOP-CTX !
  DUP 0= ABORT" CreateWindowExW failed"
  DUP TO hwnd
  DUP PARENT !
  DEF-CTRL
;
: MENU ( a u -- )
  >TXT
  0 MDEPTH !                      \ новое верхнее меню - чистый стек
  MBAR @ 0= IF CreateMenu MBAR ! THEN
  CreatePopupMenu CUR-MENU !
  TXTBUF TXTLEN @ >W
  CUR-MENU @ MF_POPUP MBAR @
  AppendMenuW DROP
;

: SUBMENU ( a u -- )              \ подменю в текущем меню
  { a u \ m }
  a u >TXT
  CreatePopupMenu TO m
  TXTBUF TXTLEN @ >W m MF_POPUP CUR-MENU @ AppendMenuW DROP
  MDEPTH @ 8 < IF
    CUR-MENU @ MENUSTK MDEPTH @ CELLS + !
    MDEPTH 1+!
  THEN
  m CUR-MENU !
;

: MENU-END ( -- )                 \ вернуться на уровень выше
  MDEPTH @ 0= IF EXIT THEN
  MDEPTH 1-!
  MENUSTK MDEPTH @ CELLS + @ CUR-MENU !
;

: PARSE-ACCEL { a u }
  u 2 = a C@ 94 = AND
  IF
    a 1+ C@ DUP 96 > OVER 122 < AND IF 32 - THEN
    ACCKEY !
  ELSE 0 ACCKEY ! THEN
;

: ITEM ( a u "accel" "handler" -- )
  { ta tu \ id }
  ta tu >TXT
  TOKEN PARSE-ACCEL
  NEW-ID TO id
  TXTBUF TXTLEN @ >W id MF_STRING CUR-MENU @ AppendMenuW DROP
  ACCKEY @ IF ACCKEY @ id ACCEL-ADD THEN
  TOKEN id DEF-HANDLER
;

: TEXT ( a u "name" x y w h -- )
  { ta tu \ x y w h id }
  TOKEN >NAM
  NUM TO x  NUM TO y  NUM TO w  NUM TO h
  ta tu >TXT
  NEW-ID TO id
  S" STATIC" 0 WS_CHILD WS_VISIBLE OR SS_LEFT OR x y w h id MKCTRL DEF-CTRL
;

: EDIT ( "name" x y w h -- )
  { \ x y w h id }
  TOKEN >NAM
  NUM TO x  NUM TO y  NUM TO w  NUM TO h
  0 TXTLEN !
  NEW-ID TO id
  S" EDIT" WS_EX_CLIENTEDGE
  WS_CHILD WS_VISIBLE OR WS_BORDER OR ES_AUTOHSCROLL OR
  x y w h id MKCTRL DEF-CTRL
;

: BUTTON ( a u "name" x y w h "handler" -- )
  { ta tu \ x y w h id }
  TOKEN >NAM
  NUM TO x  NUM TO y  NUM TO w  NUM TO h
  ta tu >TXT
  NEW-ID TO id
  S" BUTTON" 0 WS_CHILD WS_VISIBLE OR BS_PUSHBUTTON OR x y w h id MKCTRL DEF-CTRL
  TOKEN id DEF-HANDLER
;

\ ------------------------------------- флажки, переключатели, ползунки
\ Значение компонента:
\   имя @        - HWND
\   HWND STATE@  /  n HWND STATE!   - флажок и радиокнопка (0/1)
\   HWND POS@    /  n HWND POS!     - ползунок
\ Синтаксис (как у остальных: строка, слово, токены):
\   "Флажок"     CHECK  chk  16 200 200 24 on-chk
\   "Вариант A"  RADIO  ra   16 230 200 24 G on-rad     \ G - первый в группе
\   "Вариант B"  RADIO  rb   16 255 200 24 - on-rad     \ - - продолжение
\                SLIDER vol 140 120 220 30 0 100 H on-vol
\                SLIDER lvl 400  40  30 120 0 100 V on-lvl

: STATE@ ( hwnd -- n )  { h }  0 0 BM_GETCHECK h SendMessageW ;
: STATE! ( n hwnd -- )  { n h }  0 n BM_SETCHECK h SendMessageW DROP ;
: POS@ ( hwnd -- n )    { h }  0 0 TBM_GETPOS h SendMessageW ;
: POS! ( n hwnd -- )    { n h }  n 1 TBM_SETPOS h SendMessageW DROP ;
: RANGE! { mn mx h }    mn mx 65536 * + 1 TBM_SETRANGE h SendMessageW DROP ;

: TOKEN-CH ( -- ch )
  TOKEN DUP 1 =
  IF DROP C@ ELSE 2DROP 0 THEN
;

: CHECK ( a u "name" x y w h "handler" -- )
  { ta tu \ x y w h id }
  TOKEN >NAM
  NUM TO x  NUM TO y  NUM TO w  NUM TO h
  ta tu >TXT
  NEW-ID TO id
  S" BUTTON" 0 WS_CHILD WS_VISIBLE OR BS_AUTOCHECKBOX OR x y w h id MKCTRL DEF-CTRL
  TOKEN id DEF-HANDLER
;

: RADIO ( a u "name" x y w h "group" "handler" -- )
  { ta tu \ x y w h id st }
  TOKEN >NAM
  NUM TO x  NUM TO y  NUM TO w  NUM TO h
  ta tu >TXT
  NEW-ID TO id
  WS_CHILD WS_VISIBLE OR BS_AUTORADIOBUTTON OR TO st
  TOKEN-CH 71 = IF st WS_GROUP OR TO st THEN
  S" BUTTON" 0 st x y w h id MKCTRL DEF-CTRL
  TOKEN id DEF-HANDLER
;

: SLIDER ( "name" x y w h min max "H|V" "handler" -- )
  { \ x y w h mn mx id st hw }
  TOKEN >NAM
  NUM TO x  NUM TO y  NUM TO w  NUM TO h
  NUM TO mn  NUM TO mx
  0 TXTLEN !
  TOKEN-CH 86 = IF TBS_VERT ELSE TBS_HORZ THEN TO st
  NEW-ID TO id
  S" msctls_trackbar32" 0 WS_CHILD WS_VISIBLE OR st OR x y w h id MKCTRL TO hw
  hw DEF-CTRL
  mn mx hw RANGE!
  mn hw POS!
  TOKEN id DEF-HANDLER
;
\ --------------------------------------- рамка, список, выпадающий список
\ Синтаксис (у списков заголовка нет - подпись задаётся отдельным TEXT):
\   "Группа"  GROUPBOX grp 10 10 300 200            рамка с заголовком
\   LISTBOX   lst 16  60 200 120  on-sel            список
\   COMBO     cmb 16 200 200 120  on-sel            выпадающий список
\ Значения:
\   a u HWND ITEM+   - добавить строку
\   HWND SEL@        - ( -- n ) номер выбранной строки (-1 = нет выбора)
\   n HWND SEL!      - сделать строку n выбранной
\   HWND SELTEXT@    - ( -- a u ) текст выбранной строки
\   HWND LCOUNT@     - ( -- n ) число строк
\ Признак "это combo / это список" хранится по id компонента.

CREATE KINDS 4096 ALLOT
CREATE CBUFS 512 ALLOT

: KIND! { n id }  n KINDS id + C! ;
: KIND@ ( hwnd -- n ) { h }  h GetDlgCtrlID KINDS + C@ ;

: ITEM+ ( a u hwnd -- )
  { a u h \ w }
  a u >W TO w
  h KIND@ 1 =
  IF w 0 CB_ADDSTRING h SendMessageW DROP
  ELSE w 0 LB_ADDSTRING h SendMessageW DROP
  THEN
;

: SEL@ ( hwnd -- n )
  { h }
  h KIND@ 1 =
  IF 0 0 CB_GETCURSEL h SendMessageW
  ELSE 0 0 LB_GETCURSEL h SendMessageW
  THEN
;

: SEL! ( n hwnd -- )
  { n h }
  h KIND@ 1 =
  IF 0 n CB_SETCURSEL h SendMessageW DROP
  ELSE 0 n LB_SETCURSEL h SendMessageW DROP
  THEN
;

: LCOUNT@ ( hwnd -- n )
  { h }
  h KIND@ 1 =
  IF 0 0 CB_GETCOUNT h SendMessageW
  ELSE 0 0 LB_GETCOUNT h SendMessageW
  THEN
;

: SELTEXT@ ( hwnd -- a u )
  { h \ i k }
  h SEL@ TO i
  i 0< IF S" " EXIT THEN
  h KIND@ 1 =
  IF CBUFS i CB_GETLBTEXT h SendMessageW TO k
  ELSE CBUFS i LB_GETTEXT    h SendMessageW TO k
  THEN
  k 0< IF S" " EXIT THEN
  CBUFS k W>TEXT
;

: GROUPBOX ( a u "name" x y w h -- )
  { ta tu \ x y w h id }
  TOKEN >NAM
  NUM TO x  NUM TO y  NUM TO w  NUM TO h
  ta tu >TXT
  NEW-ID TO id
  S" BUTTON" 0 WS_CHILD WS_VISIBLE OR BS_GROUPBOX OR x y w h id MKCTRL DEF-CTRL
;

: LISTBOX ( "name" x y w h "handler" -- )
  { \ x y w h id }
  TOKEN >NAM
  NUM TO x  NUM TO y  NUM TO w  NUM TO h
  0 TXTLEN !
  NEW-ID TO id
  2 id KIND!
  S" LISTBOX" 0
  WS_CHILD WS_VISIBLE OR WS_BORDER OR WS_VSCROLL OR LBS_NOTIFY OR
  LBS_NOINTEGRALHEIGHT OR
  x y w h id MKCTRL DEF-CTRL
  TOKEN id DEF-HANDLER
;

: COMBO ( "name" x y w h "handler" -- )
  { \ x y w h id }
  TOKEN >NAM
  NUM TO x  NUM TO y  NUM TO w  NUM TO h
  0 TXTLEN !
  NEW-ID TO id
  1 id KIND!
  S" COMBOBOX" 0
  WS_CHILD WS_VISIBLE OR CBS_DROPDOWNLIST OR WS_VSCROLL OR
  CBS_NOINTEGRALHEIGHT OR
  x y w h id MKCTRL DEF-CTRL
  TOKEN id DEF-HANDLER
;
: END ( -- )
  MBAR @ IF MBAR @ FORM @ SetMenu DROP FORM @ DrawMenuBar DROP THEN
  NACC @ IF NACC @ ACCBUF CreateAcceleratorTableW HACCEL ! THEN
  CLIENT-W CXC !  CLIENT-H CYC !
;

\ ---------------------------------------------------------------- вывод
: TRANSLATED? ( -- f )
  HACCEL @ 0= IF FALSE EXIT THEN
  MSGBUF HACCEL @ FORM @ TranslateAcceleratorW
  IF TRUE ELSE FALSE THEN
;

: HIDE-CONSOLE ( -- )
  GetConsoleWindow DUP
  IF 0 SWAP ShowWindow DROP ELSE DROP THEN
;

: PUMP ( -- f )                   \ одно сообщение; f=0 - пришёл WM_QUIT
  0 0 0 MSGBUF GetMessageW 0> 0=
  IF FALSE EXIT THEN
  TRANSLATED? 0=
  IF
    MSGBUF TranslateMessage DROP
    MSGBUF DispatchMessageW DROP
  THEN
  PENDING @
  IF
    PENDING @ 0 PENDING !
    DUP -1 =
    IF
      DROP RELAYOUT
    ELSE
      HANDLER-XT DUP IF EXECUTE ELSE DROP THEN
    THEN
  THEN
  TRUE
;
: SHOW ( "name" -- )
  TOKEN SFIND
  IF EXECUTE @ ELSE 2DROP S" gui-kit: форма не найдена" TYPE CR BYE THEN
  FORM !
  SW_SHOW FORM @ ShowWindow DROP
  FORM @ UpdateWindow DROP
  BEGIN PUMP 0= UNTIL
;

: SHOW-DIALOG ( hwnd -- )         \ показать модально, ждать закрытия
  { h \ owner }
  FORM @ TO owner
  owner 0 EnableWindow DROP
  SW_SHOW h ShowWindow DROP
  h UpdateWindow DROP
  BEGIN
    h IsWindow 0=
    IF owner TRUE EnableWindow DROP FORM @ PARENT ! EXIT THEN
    PUMP 0=
    IF owner TRUE EnableWindow DROP FORM @ PARENT ! EXIT THEN
  AGAIN
;
: QUIT-APP ( -- ) FORM @ DestroyWindow DROP ;

\ ------------------------------------------------------ файловые диалоги
\   "Описание|*.txt|Все файлы|*.*|"  OPEN-FILE   ( -- a u f )
\   "Описание|*.txt"                 SAVE-FILE   ( -- a u f )
\   f=1 - файл выбран, a u - путь в кодировке исходника; f=0 - отказ.
WINAPI: GetOpenFileNameW       COMDLG32.DLL
WINAPI: GetSaveFileNameW       COMDLG32.DLL

CREATE FMBUF 2048 ALLOT          \ фильтр в UTF-16: пары через 0, два 0 на конце
CREATE FWBUF 1040 ALLOT          \ выбранный путь в UTF-16 (520 символов)
CREATE OFN   88 ALLOT            \ OPENFILENAMEW (x86): 23 поля, 88 байт

0x00080000 CONSTANT OFN-EXPLORER
0x00000800 CONSTANT OFN-PATHMUSTEXIST
0x00001000 CONSTANT OFN-FILEMUSTEXIST
0x00000002 CONSTANT OFN-OVERWRITEPROMPT
0x00000008 CONSTANT OFN-HIDEREADONLY

: W-FETCH ( ad -- u )  DUP C@ SWAP 1+ C@ 256 * + ;
: W-LEN ( ad -- n )              \ длина строки UTF-16 без завершающего нуля
  { ad \ n }
  0 TO n
  BEGIN ad n 2* + W-FETCH 0= IF n EXIT THEN n 1+ TO n AGAIN
;
: PIPE>NUL ( ad n -- )           \ '|' -> 0, чтобы получить список строк
  { ad n \ i }
  0 TO i
  BEGIN
    i n < 0= IF EXIT THEN
    ad i 2* + W-FETCH 124 = IF 0 ad i 2* + W-STORE THEN
    i 1+ TO i
  AGAIN
;
: >FILTER ( a u -- )
  { a u \ d n }
  a u >W TO d
  d W-LEN TO n
  d n PIPE>NUL
  d FMBUF n 1+ 2* CMOVE
  0 FMBUF n 1+ 2* + W-STORE
;
: OFN-INIT ( flags -- )
  { fl }
  OFN 88 0 FILL
  88      OFN !
  FORM @  OFN 4  + !            \ hwndOwner
  0       OFN 8  + !            \ hInstance
  FMBUF   OFN 12 + !            \ lpstrFilter
  0       OFN 16 + !            \ lpstrCustomFilter
  0       OFN 20 + !            \ nMaxCustFilter
  1       OFN 24 + !            \ nFilterIndex
  FWBUF   OFN 28 + !            \ lpstrFile
  520     OFN 32 + !            \ nMaxFile
  fl      OFN 52 + !            \ Flags
;
: FILE-NAME! { a u }            \ имя файла, предложенное в диалоге
  a u >W DUP W-LEN 1+ 2* FWBUF SWAP CMOVE
;
: OPEN-FILE { a u }
  a u >FILTER
  OFN-EXPLORER OFN-PATHMUSTEXIST OR OFN-FILEMUSTEXIST OR
  OFN-HIDEREADONLY OR OFN-INIT
  OFN GetOpenFileNameW
  IF FWBUF DUP W-LEN W>TEXT TRUE ELSE 0 0 FALSE THEN
;
: SAVE-FILE { a u }
  a u >FILTER
  OFN-EXPLORER OFN-PATHMUSTEXIST OR OFN-OVERWRITEPROMPT OR
  OFN-HIDEREADONLY OR OFN-INIT
  OFN GetSaveFileNameW
  IF FWBUF DUP W-LEN W>TEXT TRUE ELSE 0 0 FALSE THEN
;

\ ------------------------------------------- состояние формы в ini-файле
\   "имя.ini"  SAVE-INI   ( -- )   записать положение окна и значения
\   "имя.ini"  LOAD-INI   ( -- )   прочитать и применить
\ Секция [form]: win-x, win-y, win-w, win-h и по строке на каждый компонент
\ с именем из описания формы: текст поля ввода, состояние флажка и
\ переключателя, позиция ползунка, выбранная строка списка и combo.
\ Надписи, кнопки и рамки не сохраняются.
WINAPI: WritePrivateProfileStringW   KERNEL32.DLL
WINAPI: GetPrivateProfileStringW     KERNEL32.DLL

CREATE IFBUF  520 2 * ALLOT      \ путь к файлу в UTF-16
CREATE CLSB   128 ALLOT          \ имя класса окна
CREATE GBUF   512 2 * ALLOT      \ прочитанное значение в UTF-16
CREATE INVBUF 512 ALLOT          \ значение в кодировке исходника (свой буфер)

: >NUMSTR ( n -- a u ) 0 <# #S #> ;
: >IFILE { a u }                \ путь -> IFBUF (UTF-16, с нулём)
  IFBUF 1040 0 FILL
  a u >W DUP W-LEN 1+ 2* IFBUF SWAP CMOVE
;
: CLASS@ { h \ n } 64 CLSB h GetClassNameW TO n  CLSB n W>TEXT ;
: CLS= { h a u \ ca cu i ok }    \ совпадает ли класс окна со строкой a u
  h CLASS@ TO cu TO ca
  u cu <> IF FALSE EXIT THEN
  TRUE TO ok
  u 0 ?DO a I + C@ ca I + C@ <> IF FALSE TO ok THEN LOOP
  ok
;
: BTN-KIND ( h -- n ) -16 SWAP GetWindowLongW 15 AND ;   \ 3-флажок, 9-переключатель

: W-STR { a u valW }             \ записать строку
  IFBUF valW a u >W S" form" >W WritePrivateProfileStringW DROP
;
: W-NUM { n a u }                \ записать число
  IFBUF n >NUMSTR >W a u >W S" form" >W WritePrivateProfileStringW DROP
;
: SAVE-CTRL { ch np nl \ ca cu } \ np nl - имя компонента
  ch CLASS@ TO cu TO ca
  ch S" Edit" CLS= IF np nl ch TEXT@ >W W-STR EXIT THEN
  ch S" Button" CLS= IF
    ch BTN-KIND DUP 3 = SWAP 9 = OR
    IF ch STATE@ np nl W-NUM THEN
    EXIT
  THEN
  ch S" msctls_trackbar32" CLS= IF ch POS@ np nl W-NUM EXIT THEN
  ch S" ListBox"  CLS= IF ch SEL@ np nl W-NUM EXIT THEN
  ch S" ComboBox" CLS= IF ch SEL@ np nl W-NUM EXIT THEN
;
: SAVE-INI { a u \ ch np nl }
  a u >IFILE
  RECTB FORM @ GetWindowRect DROP
  RECTB 0  + @                    S" win-x" W-NUM
  RECTB 4  + @                    S" win-y" W-NUM
  RECTB 8  + @ RECTB 0  + @ -     S" win-w" W-NUM
  RECTB 12 + @ RECTB 4  + @ -     S" win-h" W-NUM
  GW_CHILD FORM @ GetWindow TO ch
  BEGIN
    ch 0= IF EXIT THEN
    PROP-NAME    ch GetPropW TO np
    PROP-NAMELEN ch GetPropW TO nl
    np 0<> nl 0<> AND IF ch np nl SAVE-CTRL THEN
    GW_HWNDNEXT ch GetWindow TO ch
  AGAIN
;
: W>INV { waddr n }              \ UTF-16 -> INVBUF (свой буфер, не AOBUF)
  0 0 512 INVBUF n waddr 0 SRC-CODE WideCharToMultiByte
  INVBUF SWAP
;
: R-KEY { a u \ k n }            \ прочитать значение ключа a u
  a u >W TO k
  IFBUF 1024 GBUF 0 0 >W k S" form" >W GetPrivateProfileStringW TO n
  GBUF n W>INV
;
: LOAD-CTRL { ch np nl \ a u }
  np nl R-KEY TO u TO a
  u 0= IF EXIT THEN
  ch S" Edit" CLS= IF a u ch TEXT! EXIT THEN
  ch S" Button" CLS= IF
    ch BTN-KIND DUP 3 = SWAP 9 = OR
    IF a u NUMBER? IF DROP ch STATE! ELSE 2DROP THEN THEN
    EXIT
  THEN
  a u NUMBER?
  IF DROP
    ch S" msctls_trackbar32" CLS= IF ch POS! EXIT THEN
    ch S" ListBox"  CLS= IF ch SEL! EXIT THEN
    ch S" ComboBox" CLS= IF ch SEL! EXIT THEN
    DROP
  ELSE 2DROP
  THEN
;
: LOAD-WIN ( -- )                \ положение и размер окна
  { \ x y w h }
  S" win-x" R-KEY NUMBER? IF DROP TO x ELSE 2DROP EXIT THEN
  S" win-y" R-KEY NUMBER? IF DROP TO y ELSE 2DROP EXIT THEN
  S" win-w" R-KEY NUMBER? IF DROP TO w ELSE 2DROP EXIT THEN
  S" win-h" R-KEY NUMBER? IF DROP TO h ELSE 2DROP EXIT THEN
  SWP_NOZORDER h w y x 0 FORM @ SetWindowPos DROP
  CLIENT-W NEWW !  CLIENT-H NEWH !
  RELAYOUT
;
: LOAD-INI { a u \ ch np nl }
  a u >IFILE
  LOAD-WIN
  GW_CHILD FORM @ GetWindow TO ch
  BEGIN
    ch 0= IF EXIT THEN
    PROP-NAME    ch GetPropW TO np
    PROP-NAMELEN ch GetPropW TO nl
    np 0<> nl 0<> AND IF ch np nl LOAD-CTRL THEN
    GW_HWNDNEXT ch GetWindow TO ch
  AGAIN
;
