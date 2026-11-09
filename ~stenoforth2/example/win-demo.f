\ =====================================================================
\  Пример: окно графического приложения из SP-Forth 4.29 (StenoForth)
\
\  Запуск:   spf486.exe win-demo.f
\            (консольное окно сразу скрывается, остаётся только окно)
\
\  Сборка exe без консоли вообще:  см. win-demo-gui.f
\
\  Показано:
\    - регистрация собственного класса окна (RegisterClassExA)
\    - создание окна (CreateWindowExA)
\    - своя оконная процедура (WNDPROC:): WM_PAINT, WM_DESTROY,
\      остальные сообщения уходят в DefWindowProcA
\    - цикл сообщений GetMessageA / TranslateMessage / DispatchMessageA
\      и корректный выход из него
\    - рисование в клиентской области (BeginPaint/TextOutA/Rectangle)
\    - скрытие консольного окна (GetConsoleWindow + ShowWindow SW_HIDE)
\
\  Соглашения SP-Forth, использованные здесь:
\    WINAPI: имя DLL   - импорт stdcall-функции: аргументы кладутся на
\                        стек СПРАВА НАЛЕВО, т.е. последний аргумент
\                        C-прототипа кладётся первым, первый аргумент
\                        оказывается НАВЕРХУ стека
\    --                - поле структуры (оно же FIELD)
\    { a b | c d }     - локальные переменные: a,b берутся со стека, c,d = 0
\    ' xt WNDPROC: имя - оформить форт-слово как оконную процедуру
\
\  В WNDPROC:-слове стек на входе (снизу вверх):
\        lParam   wParam   msg   hwnd      ->   lresult
\  то есть hwnd лежит НАВЕРХУ стека.
\ =====================================================================

\ ---------------------------------------------------------------- Win32
WINAPI: GetModuleHandleA    KERNEL32.DLL
WINAPI: GetCurrentThreadId  KERNEL32.DLL
WINAPI: GetConsoleWindow    KERNEL32.DLL
WINAPI: RegisterClassExA    USER32.DLL
WINAPI: CreateWindowExA     USER32.DLL
WINAPI: ShowWindow          USER32.DLL
WINAPI: UpdateWindow        USER32.DLL
WINAPI: GetMessageA         USER32.DLL
WINAPI: TranslateMessage    USER32.DLL
WINAPI: DispatchMessageA    USER32.DLL
WINAPI: DefWindowProcA      USER32.DLL
WINAPI: PostThreadMessageA  USER32.DLL
WINAPI: BeginPaint          USER32.DLL
WINAPI: EndPaint            USER32.DLL
WINAPI: TextOutA            GDI32.DLL
WINAPI: Rectangle           GDI32.DLL
WINAPI: SetBkMode           GDI32.DLL

\ ------------------------------------------------------------ константы
 1 CONSTANT CS_VREDRAW
 2 CONSTANT CS_HREDRAW

0x00CF0000 CONSTANT WS_OVERLAPPEDWINDOW
         0 CONSTANT SW_HIDE
         5 CONSTANT SW_SHOW

0x000F CONSTANT WM_PAINT
0x0002 CONSTANT WM_DESTROY
0x0010 CONSTANT WM_CLOSE
0x0012 CONSTANT WM_QUIT

         2 CONSTANT TRANSPARENT        \ SetBkMode: не закрашивать фон текста
         6 CONSTANT COLOR-WINDOW-BRUSH \ COLOR_WINDOW + 1: кисть фона окна

\ ------------------------------------------------------------- структуры
\ WNDCLASSEX (32-разрядная Windows, 48 байт)
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
CONSTANT /WNDCLASSEX

\ RECT
0
 CELL -- rcLeft
 CELL -- rcTop
 CELL -- rcRight
 CELL -- rcBottom
CONSTANT /RECT

\ PAINTSTRUCT (64 байта)
0
 CELL -- psHdc
 CELL -- psErase
 /RECT -- psPaint
 CELL -- psRestore
 CELL -- psIncUpdate
   32 -- psReserved
CONSTANT /PAINTSTRUCT

\ MSG
0
 CELL -- mHwnd
 CELL -- mMessage
 CELL -- mWParam
 CELL -- mLParam
 CELL -- mTime
    8 -- mPt
CONSTANT /MSG

\ -------------------------------------------------- буферы под структуры
CREATE WNDCLASS /WNDCLASSEX  ALLOT
CREATE PAINTBUF /PAINTSTRUCT ALLOT
CREATE MSGBUF    /MSG        ALLOT

VARIABLE HWND

\ Признак "идёт сборка exe" (win-demo-gui.f выставляет его в TRUE,
\ чтобы при подключении этого файла DEMO не запускалась).
[DEFINED] BUILDING? [IF] [ELSE] VARIABLE BUILDING? FALSE BUILDING? ! [THEN]

\ ------------------------------------------------------- строки (ANSI!)
\ S" в теле определения компилирует строку в словарь с завершающим
\ нулём, поэтому её адрес можно передавать в WinAPI.
: CLASS-NAME  S" StenoDemoClass" ;
: WINDOW-NAME S" SP-Forth 4.29 - window demo" ;
: TXT1 S" Hello from SP-Forth 4.29 / StenoForth!" ;
: TXT2 S" Class: RegisterClassExA    Window: CreateWindowExA" ;
: TXT3 S" Paint: WM_PAINT            Exit: WM_DESTROY" ;
: TXT4 S" Close this window to terminate the program." ;

\ ------------------------------------------- скрытие консольного окна
\ Консоль есть только у консольного процесса: у exe с GUI-подсистемой
\ GetConsoleWindow вернёт 0, и слово ничего не сделает.
: HIDE-CONSOLE ( -- )
  GetConsoleWindow DUP              \ hwnd
  IF   SW_HIDE SWAP ShowWindow DROP
  ELSE DROP
  THEN
;

\ ------------------------------------------- рисование содержимого окна
\ TextOutA(hdc, x, y, lpString, cch): первым кладётся cch, последним hdc.
\ Локальные переменные избавляют от путаницы с порядком аргументов.
: TXT ( hdc x y a u -- )
  { h x y a u }
  u a y x h TextOutA DROP
;

: DRAW-CONTENT ( hdc -- )
  { h }
  TRANSPARENT h SetBkMode DROP              \ прозрачный фон у текста
  295 395 5 5 h Rectangle DROP              \ рамка: bottom right top left
  h 20  20 TXT1 TXT
  h 20  50 TXT2 TXT
  h 20  80 TXT3 TXT
  h 20 120 TXT4 TXT
;

\ ------------------------------------------------- оконная процедура
\ Стек на входе (снизу вверх): lParam wParam msg hwnd
: (WND-PROC) { lp wp msg hwnd | hdc ps }
  msg WM_PAINT =
  IF
    PAINTBUF TO ps
    ps hwnd BeginPaint TO hdc
    hdc DRAW-CONTENT
    ps hwnd EndPaint DROP
    0 EXIT
  THEN

  msg WM_DESTROY =
  IF
    \ Завершаем цикл сообщений. Обычно здесь пишут 0 PostQuitMessage,
    \ но в этой сборке вызов PostQuitMessage ИЗНУТРИ оконной процедуры
    \ аварийно завершает процесс (STATUS_FATAL_USER_CALLBACK_EXCEPTION).
    \ Эквивалент: послать WM_QUIT в очередь своего потока.
    0 WM_QUIT GetCurrentThreadId PostThreadMessageA DROP
    0 EXIT
  THEN

  \ всё остальное - системе (перемещение, размер, WM_CLOSE и т.д.)
  lp wp msg hwnd DefWindowProcA
;

' (WND-PROC) WNDPROC: WND-PROC

\ --------------------------------------------- регистрация класса окна
: REGISTER-CLASS ( -- )
  0 GetModuleHandleA WNDCLASS wcHInstance !

  /WNDCLASSEX               WNDCLASS wcCbSize !
  CS_HREDRAW CS_VREDRAW OR  WNDCLASS wcStyle !
  ['] WND-PROC              WNDCLASS wcLpfnWndProc !
  0                         WNDCLASS wcCbClsExtra !
  0                         WNDCLASS wcCbWndExtra !
  0                         WNDCLASS wcHIcon !
  0                         WNDCLASS wcHCursor !
  COLOR-WINDOW-BRUSH        WNDCLASS wcHbrBackground !
  0                         WNDCLASS wcLpszMenuName !
  CLASS-NAME DROP           WNDCLASS wcLpszClassName !
  0                         WNDCLASS wcHIconSm !

  WNDCLASS RegisterClassExA 0= ABORT" RegisterClassExA failed"
;

\ ------------------------------------------------------ создание окна
: CREATE-WINDOW ( -- hwnd )
  \ CreateWindowExA(dwExStyle, lpClassName, lpWindowName, dwStyle,
  \                 x, y, w, h, hWndParent, hMenu, hInstance, lpParam)
  0                          \ lpParam
  0 GetModuleHandleA         \ hInstance
  0                          \ hMenu
  0                          \ hWndParent
  300                        \ nHeight
  420                        \ nWidth
  100                        \ y
  100                        \ x
  WS_OVERLAPPEDWINDOW        \ dwStyle
  WINDOW-NAME DROP           \ lpWindowName
  CLASS-NAME  DROP           \ lpClassName
  0                          \ dwExStyle
  CreateWindowExA
  DUP 0= ABORT" CreateWindowExA failed"
;

\ --------------------------------------------------------- цикл сообщений
: MESSAGE-LOOP ( hwnd -- )
  DROP
  BEGIN
    0 0 0 MSGBUF GetMessageA 0>     \ 0 = получен WM_QUIT, -1 = ошибка
  WHILE
    MSGBUF TranslateMessage DROP
    MSGBUF DispatchMessageA DROP
  REPEAT
;

\ ------------------------------------------------------------ программа
: DEMO ( -- )
  HIDE-CONSOLE                 \ убрать консольное окно
  REGISTER-CLASS
  CREATE-WINDOW DUP HWND !
  SW_SHOW SWAP ShowWindow DROP
  HWND @ UpdateWindow DROP
  HWND @ MESSAGE-LOOP
;

\ ------------------- точка входа для exe (см. win-demo-gui.f) ----
: MAIN ( -- )
  DEMO
  BYE
;

\ ============================================================== запуск
BUILDING? @ 0= [IF]
  DEMO
  BYE
[THEN]
