\ mt-dsl.f - краткий синтаксис реальной многопоточности для SP-Forth 4.29
\ Проверено: spf4p.exe (f:\spf429) и spf486.exe (~stenoforth2-1\bin), 2026-11-11
\
\ Подключение:   S" <путь>\mt-dsl.f" INCLUDED
\ Пример:        ' B1 TASK: T1   0 T1 SPAWN   JOIN-ALL
\
\ Внешних библиотек нет: только KERNEL32, поэтому файл работает в обоих образах.

REQUIRE { lib\ext\locals.f

WINAPI: WaitForSingleObject        KERNEL32.DLL
WINAPI: SetThreadAffinityMask      KERNEL32.DLL
WINAPI: CreateMutexA               KERNEL32.DLL
WINAPI: ReleaseMutex               KERNEL32.DLL
WINAPI: InitializeCriticalSection  KERNEL32.DLL
WINAPI: EnterCriticalSection       KERNEL32.DLL
WINAPI: LeaveCriticalSection       KERNEL32.DLL

-1 CONSTANT INFINITE

\ --- данные ---
\ SHARED S1 0   -> общая ячейка: имя возвращает адрес, значение задаётся сразу
: SHARED ( "name" init -- ) PARSE-NAME 2DUP CREATED PARSE-NAME EVALUATE , DOES> ;
\ TLS TV        -> ячейка, своя у каждого потока (при старте = 0)
: TLS    ( "name" -- ) USER-VALUE ;

\ --- защита ---
\ CreateMutexA(lpMutexAttributes, bInitialOwner, lpName): ( name owner attrs )
: MUTEX ( "name" -- ) CREATE 0 0 0 CreateMutexA DUP 0= ABORT" MT: mutex" , DOES> @ ;
: LOCK   ( h -- ) INFINITE SWAP WaitForSingleObject DROP ;
: UNLOCK ( h -- ) ReleaseMutex DROP ;
: WITH-LOCK { xt h -- } h LOCK xt CATCH h UNLOCK THROW ;

\ CRITICAL_SECTION на x86 - 6 ячеек
: CRIT  ( "name" -- ) CREATE HERE 6 CELLS ALLOT DUP InitializeCriticalSection DROP DOES> ;
: CRIT-ENTER ( cs -- ) EnterCriticalSection DROP ;
: CRIT-LEAVE ( cs -- ) LeaveCriticalSection DROP ;
: WITH-CRIT { xt c -- } c CRIT-ENTER xt CATCH c CRIT-LEAVE THROW ;

\ --- потоки ---
8 CONSTANT MT-MAX
CREATE MT-TID MT-MAX CELLS ALLOT
VARIABLE MT-N

\ x task SPAWN - запустить задачу; tid остаётся на стеке и запоминается для JOIN-ALL
: SPAWN ( x task -- tid )
  START DUP 0= ABORT" MT: thread not started"
  MT-N @ MT-MAX < IF DUP MT-TID MT-N @ CELLS + ! 1 MT-N +! THEN ;

: JOIN ( tid -- ) INFINITE SWAP WaitForSingleObject DROP ;
: JOIN-ALL ( -- ) MT-N @ 0 ?DO MT-TID I CELLS + @ JOIN LOOP 0 MT-N ! ;
: PIN ( tid mask -- ) SWAP SetThreadAffinityMask DROP ;
\ барьер старта: GO=0 - ждать, GO=1 - работать
: WAIT-GO ( go -- ) BEGIN DUP @ 0= WHILE 1 PAUSE REPEAT DROP ;
