\ =====================================================================
\ Шаблоны инструкций disp[base][index*scale] - через NOTFOUND,
\ как в sp-assm.f: отдельные слова в словарь не пишутся.
\
\ Регистры - одной буквой: A C D B X P S T (EA EC ED EB EX EP ES ET).
\ Смещение - перед мнемоникой: 0h (ноль) или $ <hex>.
\
\   0h A=@@PA*4      MOV EAX, 0[EBP][EAX*4]
\   0h @@PA*4=C      MOV 0[EBP][EAX*4], ECX
\   $ 8 D=@@BP*2     MOV EDX, 8[EBX][EBP*2]
\
\ Разбор: IDN сравнивает слово с шаблоном (LIKE: ? - один символ,
\ * - любая часть), RG! берёт регистр по смещению в слове, затем
\ MEMIDX собирает ModRM + SIB + смещение и выдаёт байты.
\ =====================================================================

VARIABLE MXS VARIABLE MXI VARIABLE MXB VARIABLE MXD
VARIABLE MXDISP VARIABLE MXOP

\ CS: [disp] dest base index scale ; код операции - на стеке данных
: MEMIDX ( op -- )
  MXOP !
  CS> MXS !
  CS> MXI !
  CS> MXB !
  CS> MXD !
  ?CS IF 0 ELSE CS> THEN MXDISP !
  MXOP @ C,
  MXDISP @ -129 > MXDISP @ 128 < AND IF 0x40 ELSE 0x80 THEN
  MXD @ 3 LSHIFT OR 4 OR C,
  MXS @ 6 LSHIFT  MXI @ 3 LSHIFT OR  MXB @ OR C,
  MXDISP @ -129 > MXDISP @ 128 < AND
  IF MXDISP @ C, ELSE MXDISP @ , THEN ;

\ нулевое смещение в привычной записи
I: 0h 0 >CS ;

\ чтение:  <D>=@@<b><i>[*2|*4|*8]
: NOTFOUND S" ?=@@??"    IDN 0 RG! 4 RG! 5 RG! 0 >CS 0x8B MEMIDX ;
: NOTFOUND S" ?=@@??\*2" IDN 0 RG! 4 RG! 5 RG! 1 >CS 0x8B MEMIDX ;
: NOTFOUND S" ?=@@??\*4" IDN 0 RG! 4 RG! 5 RG! 2 >CS 0x8B MEMIDX ;
: NOTFOUND S" ?=@@??\*8" IDN 0 RG! 4 RG! 5 RG! 3 >CS 0x8B MEMIDX ;

\ запись:  @@<b><i>[*2|*4|*8]=<D>
: NOTFOUND S" @@??=?"    IDN 5 RG! 2 RG! 3 RG! 0 >CS 0x89 MEMIDX ;
: NOTFOUND S" @@??\*2=?" IDN 7 RG! 2 RG! 3 RG! 1 >CS 0x89 MEMIDX ;
: NOTFOUND S" @@??\*4=?" IDN 7 RG! 2 RG! 3 RG! 2 >CS 0x89 MEMIDX ;
: NOTFOUND S" @@??\*8=?" IDN 7 RG! 2 RG! 3 RG! 3 >CS 0x89 MEMIDX ;
