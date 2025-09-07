\ stenoforth32

\ short assm
\ rO     [rO     rOr    rO[r    [rOr  rO#    [rO#  r=r*#  rc+r     c-r     rc+[r  rc-[r   rc+#   rc-#    [rc+#  [rc-#
\ r>>    r<<     [r>>   [r<<    rc>>  rc<<   [rc>> [rc<<  ra>>     ra<<    [ra>>  [ra<<   ra     rra     /r     /[r
\ r=r?   r=[r?   [r=r?  r=#?    [r=#? rO@    @Or   @O#    <r=r     >r=r    Zr=r   zr=r    <r=[r  >r=[r   Zr=[r  zr=[r
\ r=l\r  r=h\r   r=l\[r r=h\[r  c=r\r c=[r\r c=r\# c=[r\# c=r0\r   c=[r0\r c=r0\# c=[r0\# c=r1\r c=[r1\r c=r1\# c=[r1\#
\ c=r~\r c=[r~\r c=r~\# c=[r~\# r3210 r+~r   [r+~r s@O#
\ cdq    pushad  popad  cf=0    cf=1  df=0   df=1  cpuid  dac=tscp nop

MODULE: asmforth
: CinStr { s a u -- tf }
  0 a u + a DO I C@ s = IF DROP TRUE LEAVE THEN LOOP ;
: sym>offs u\ a\ s\ \ s a u -- offset
  a u + a DO I C@ s = IF I a - LEAVE THEN LOOP ;
t: sregs acdbxpst ;   \ eax ecx edx ebx esp ebp esi  edi
t: soper |&^=+-*~ ;   \ or  and xor mov add sub imul xchg
t: soper1 |&^=+-~ ;
t: soper2 |&^=+- ;
m: regs? a + C@ sregs CinStr ;      \ pos reg -- flag
m: nregs a + C@ sregs sym>offs ;    \ pos reg -- numreg
m: oper?  a + C@ soper  CinStr ;    \ pos oper -- flag
m: oper1? a + C@ soper1 CinStr ;
m: oper2? a + C@ soper2 CinStr ;
m: spos? a + C@ = ;                 \ sym pos -- flag
m: 2spos?  a + W@ = ;               \ 2symop pos -- flag
m: spos a + C@ ;                    \ pos -- char
: cops  \ symb -- cop
  CASE '|' OF 0x0B ENDOF '&' OF 0x23 ENDOF '^' OF 0x33 ENDOF
       '+' OF 0x03 ENDOF '-' OF 0x2B ENDOF '~' OF 0x87 ENDOF
       '=' OF 0x8B ENDOF '*' OF 0xAF ENDOF
  ENDCASE ;
: cops1 \ symb -- cop
  CASE '|' OF 0x09 ENDOF '&' OF 0x21 ENDOF '^' OF 0x31 ENDOF
       '+' OF 0x01 ENDOF '-' OF 0x29 ENDOF '~' OF 0x87 ENDOF
       '=' OF 0x89 ENDOF
  ENDCASE ;
: cops2 \ symb -- cop
  CASE '|' OF 0x81 C, 0xC8 ENDOF '&' OF 0x81 C, 0xE0 ENDOF
       '^' OF 0x81 C, 0xF0 ENDOF '=' OF 0xB8         ENDOF
       '+' OF 0x81 C, 0xC0 ENDOF '-' OF 0x81 C, 0xE8 ENDOF
       '*' OF 0x69 C, 0xC0 ENDOF ENDCASE ;
: cops3 \ symb -- cop
  CASE '|' OF 0x81 C, 0x48 ENDOF '&' OF 0x81 C, 0x60 ENDOF
       '^' OF 0x81 C, 0x70 ENDOF '=' OF 0xC7 C, 0x40 ENDOF
       '+' OF 0x81 C, 0x40 ENDOF '-' OF 0x81 C, 0x68 ENDOF ENDCASE ;
\ ror  reg1 adc sbb reg2
: copsa  CASE 'c+' OF 0x13 C, 0xC0 ENDOF 'c-' OF 0x1B C, 0xC0 ENDOF ENDCASE ;
\ roc  reg adc sbb cell
: copsb  CASE 'c+' OF 0x13 C, 0x40 ENDOF 'c-' OF 0x1B C, 0x40 ENDOF ENDCASE ;
\ roi  reg adc sbb imm
: copsd  CASE 'c+' OF 0x81 C, 0xD0 ENDOF 'c-' OF 0x81 C, 0xD8 ENDOF ENDCASE ;
\ ccoi  cell adc sbb imm
: copse  CASE 'c+' OF 0x81 C, 0x50 ENDOF 'c-' OF 0x81 C, 0x58 ENDOF ENDCASE ;
\ rO
rec: 0 regs? '-' 1 spos? '~' 1 spos? or 'i' 1 spos? or 'j' 1 spos? or and u 2 = AND
gen: 0 nregs 1 spos
     case '-' of 0xF7 c, 0xD8 endof '~' of 0xF7 c, 0xD0 endof
          'i' of 0x40         endof 'j' of 0x48         endof endcase or c, ;
\ [rO  -~ij
rec: '[' 0 spos? 1 regs? and '-' 2 spos? '~' 2 spos? 'i' 2 spos? 'j' 2 spos?
     or or or and u 3 = and
gen: 1 nregs 2 spos
     case '-' of 0xF7 c, 0x58 endof '~' of 0xF7 c, 0x50 endof
          'i' of 0xFF c, 0x40 endof 'j' of 0xFF c, 0x48 endof endcase or c, c, ;
\ rOr  |&^=+-*~
rec: 0 regs? 1 oper? and 2 regs? and u 3 = and
gen: 0 nregs R\ 2 nregs r\ a 1+ C@ cops op\
     ror[ c, R 3 lshift r 0xC0 or or c, ]
     op 0xAF = IF R 0= r 0= and IF 0xF7 c, 0xE8 c, ELSE 0x0F C, op ror THEN
               ELSE 0xF7 op = IF op c, 0xF8 r or c, ELSE op ror THEN THEN ;
\ rO[r  |&^=+-*~
rec: 0 regs? 1 oper? and '[' 2 spos? and 3 regs? and u 4 = and
gen: 0 nregs R\ 3 nregs r\ a 1+ C@ cops op\
     roc[ c, 0x40 r or R 3 lshift or c, ]
     op 0xAF = IF 0x0F c, THEN op roc c, ;
\ [rOr  |&^=+-~
rec: '[' 0 spos? 1 regs? and 2 oper1? and 3 regs? and u 4 = and
gen: 3 nregs R\ 1 nregs r\ a 2+ C@ cops1 op\
     op 0xAF = IF 0x0F c, THEN op c, r 4 <>
     IF 0x40 r or R 3 lshift or c, ELSE 0x40 r or c, 0x24 c, THEN c, ;
\ r<< r>>
rec: 0 regs? '>>' 1 2spos? '<<' 1 2spos? dup pc\ or and u 3 = and
gen: 0xC1 c, pc IF 0xE0 ELSE 0xE8 THEN 0 nregs or c, c, ;
\ rc<< rc>>
rec: 0 regs? 'c' 1 spos? and '>>' 2 2spos? '<<' 2 2spos? dup pc\ or and u 4 = and
gen: 0xC1 c, pc IF 0xD0 ELSE 0xD8 THEN 0 nregs or c, c, ;
\ [r<< [r>>
rec: '[' 0 spos? 1 regs? and '>>' 2 2spos? '<<' 2 2spos? dup pc\ or and u 4 = and
gen: 0xC1 c, 1 nregs 4 <>
     IF   pc IF 0x60 ELSE 0x68 THEN 1 nregs or c,
     ELSE pc IF 0x60 ELSE 0x68 THEN 1 nregs or c, 0x24 c, THEN c, c, ;
\ [rc<< [rc>>
rec: '[' 0 spos? 1 regs? and 'c' 2 spos? and
     '>>' 3 2spos? '<<' 3 2spos? dup pc\ or and u 5 = and
gen: 0xC1 c, pc IF 0x50 ELSE 0x58 THEN
     1 nregs or c, 1 nregs 4 = IF 0x24 c, THEN c, c, ;
\ ra<< ra>>
rec: 0 regs? 'a' 1 spos? and '>>' 2 2spos? '<<' 2 2spos? dup pc\ or and u 4 = and
gen: 0xC1 c, pc IF 0xE0 ELSE 0xF8 THEN 0 nregs or c, c, ;
\ [ra<< [ra>>
rec: '[' 0 spos? 1 regs? and 'a' 2 spos? and
     '>>' 3 2spos? '<<' 3 2spos? dup pc\ or and u 5 = and
gen: 0xC1 c, pc IF 0x60 ELSE 0x78 THEN
     1 nregs or c, 1 nregs 4 = IF 0x24 c, THEN c, c, ;
\ rO#  |&^+-=*
rec: 0 n\ 0 regs? 1 oper? and '#' 2 spos? st\ st if 1 and u 3 = and else a 2+ u 2- number? nip swap -> n and u 12 < and u 2 > and then
gen: 1 spos cops2 0 nregs dup 3 lshift or or c, st 0= if n then , ;
\ [rO#  |&^+-=
rec: 0 n\ '[' 0 spos? 1 regs? and 2 oper2? and '#' 3 spos? st\
     st if 1 and u 4 = and else a 3 + u 3 - number? nip swap -> n and u 12 < and u 2 > and then
gen: 2 spos cops3 1 nregs 4 <> IF 1 nregs or c, ELSE 1 nregs or c, 0x24 c, THEN c, st 0= if n then , ;
\ r=r*#
rec: 0 n\ 0 regs? '=' 1 spos? and 2 regs? and '*' 3 spos? and '#' 4 spos? st\
     st if 1 and u 5 = and else a 4 + u 4 - number? nip swap -> n and u 14 < and u 4 > and then
gen: '*' cops2 0 nregs 3 lshift or 2 nregs or c, st 0= if n then , ;
\ rc+r rc-r
rec: 0 regs? 'c+' 1 2spos? 'c-' 1 2spos? or and 3 regs? and u 4 = and
gen: 0 nregs  R\ 3 nregs r\ a 1+ w@ copsa R 3 lshift r or or c, ;
\ rc+[r rc-[r
rec: 0 regs? 'c+' 1 2spos? 'c-' 1 2spos? or and '[' 3 spos? and 4 regs? and u 5 = and
gen: a 1+ W@ copsb 0 nregs 3 lshift or 4 nregs or c, 4 nregs 4 = IF 0x24 c, THEN c, ;
\ rc+# rc-#
rec: 0 n\ 0 regs? 'c+' 1 2spos? 'c-' 1 2spos? or and '#' 3 spos? st\ st if 1 and u 4 = and
     else a 3 + u 3 - number? nip swap -> n and u 13 < and u 3 > and then
gen: a 1+ w@ copsd 0 nregs or c, st 0= if n then , ;
\ [rc+# [rc-#
rec: 0 n\ '[' 0 spos? 1 regs? and 'c+' 2 2spos? 'c-' 2 2spos? or and
      '#' 4 spos? st\ st if 1 and u 5 = and else a 4 + u 4 - number? nip swap -> n and u 13 < and u 3 > and then
gen: a 2+ W@ copse 1 nregs or c, 1 nregs 4 = IF 0x24 c, THEN c, st 0= if n then , ;
\ ra
rec: 0 regs? 'a' 1 spos? and u 2 = and
gen: 0x8D c, 0x40 0 nregs or 0 nregs 3 LSHIFT or c, c, ;
\ rra
rec: 0 regs? 1 regs? and 'a' 2 spos? and u 3 = and
gen: 0x8D c, 0x40 1 nregs or 0 nregs 3 LSHIFT or c, 1 nregs 4 = IF 0x24 c, THEN c, ;
\ /r
rec: '/' 0 spos? 1 regs? and u 2 = and
gen: 0xF7 c, 0xF8 1 nregs or c, ;
\ /[r
rec: '/' 0 spos? '[' 1 spos? and 2 regs? and u 3 = and
gen: 0xF7 c, 0x78 2 nregs or c, 2 nregs 4 = IF 0x24 c, THEN c, ;
: cdq 0x99 c, ; immediate
\ r=r?
rec: 0 regs? '=' 1 spos? and 2 regs? and '?' 3 spos? and u 4 = and
gen: 0 nregs R\ 2 nregs r\ 0x3B c, 0xC0 R 3 lshift or r or c, ;
\ r=[r?
rec: 0 regs? '=' 1 spos? and '[' 2 spos? and 3 regs? and '?' 4 spos? and u 5 = and
gen: 0x3B c, 0 nregs R\ 3 nregs r\ 0x40 R 3 lshift or r or c, r 4 = IF 0x24 c, THEN c, ;
\ [r=r?
rec: '[' 0 spos? 1 regs? and '=' 2 spos? and 3 regs? and '?' 4 spos? and u 5 = and
gen: 0x39 c, 1 nregs R\ 3 nregs r\ 0x40 r 3 lshift or R or c, R 4 = IF 0x24 c, THEN c, ;
\ r=#?
rec: 0 regs? '=' 1 spos? and a 2+ u 3 - number? nip swap n\ and '?' u 1- spos? and u 3 > u 11 < and and
gen: 0x81 c, 0xF8 0 nregs or c, n , ;
\ [r=#?
rec: '[' 0 spos? 1 regs? and '=' 2 spos? and a 3 + u 4 - number? nip swap n\ and '?' u 1- spos? and u 4 > u 12 < and and
gen: 0x81 c, 0x78 1 nregs or c, 1 nregs 4 = if 0x24 c, then c, n , ;
\ rO@ +-=
rec: 0 regs? '+' 1 spos? '-' 1 spos? '=' 1 spos? or or and '@' 2 spos? and u 3 = and
gen: 1 spos case '+' of 0x3 endof '-' of 0x2B endof '=' of 0x8B endof endcase c, 5 0 nregs 3 lshift or c, , ;
\ @Or +-=
rec: '@' 0 spos?  '+' 1 spos? '-' 1 spos? '=' 1 spos? or or and 2 regs? and u 3 = and
gen: 1 spos case '+' of 0x1 endof '-' of 0x29 endof '=' of 0x89 endof endcase c, 5 2 nregs 3 lshift or c, , ;
\ @O#
rec: '@' 0 spos? '+' 1 spos? '-' 1 spos? '=' 1 spos? or or and a 2 + u 2 - number? nip swap n\ and u 2 > and u 12 < and
gen: 1 spos case '+' of 0x81 c, 0x5 c, endof '-' of 0x81 c, 0x2D c, endof '=' of 0xC7 c, 0x5 c, endof endcase , n , ;
\ @Oi
rec: '@' 0 spos?  '+' 1 spos? '-' 1 spos? or '=' 1 spos? or and 'i' 2 spos? and u 3 = and
gen: 1 spos case '+' of 0x81 c, 0x5  c, endof '-' of 0x81 c, 0x2D c, endof '=' of 0xC7 c, 0x5  c, endof endcase swap , , ;
\ <r=r >r=r Zr=r zr=r
rec: '<' 0 spos? '>' 0 spos? 'Z' 0 spos? 'z' 0 spos? or or or 1 regs? and '=' 2 spos? and 3 regs? and u 4 = and
gen: 1 nregs R\ 3 nregs r\ 0xF c, 0 spos
     case '<' of 0x4C endof '>' of 0x4F endof 'Z' of 0x44 endof 'z' of 0x45 endof endcase
     c, 0xC0 R 3 lshift or r or c, ;
\ <r=[r >r=[r Zr=[r zr=[r
rec: '<' 0 spos? '>' 0 spos? 'Z' 0 spos? 'z' 0 spos? or or or 1 regs? and '=[' 2 2spos? and 4 regs? and u 5 = and
gen: 1 nregs R\ 4 nregs r\ 0xF c, 0 spos
     case '<' of 0x4C endof '>' of 0x4F endof 'Z' of 0x44 endof 'z' of 0x45 endof endcase
     c, 0x40 R 3 lshift or r or c, r 4 = if 0x24 c, then c, ;
\ r=l\r r=h\r
rec: 0 regs? '=' 1 spos? and 'l\' 2 2spos? 'h\' 2 2spos? or and 4 regs? and u 5 = and
gen: 0 nregs R\ 4 nregs r\ 0xF c, 2 spos case 'l' of 0xBC endof 'h' of 0xBD endof endcase
     c, 0xC0 R 3 lshift or r or c, ;
\ r=l\[r r=h\[r
rec: 0 regs? '=' 1 spos? and 'l\' 2 2spos? 'h\' 2 2spos? or and '[' 4 spos? and 5 regs? and u 6 = and
gen: 0 nregs R\ 5 nregs r\ 0xF c, 2 spos case 'l' of 0xBC endof 'h' of 0xBD endof endcase
     c, 0x40 R 3 lshift or r or c, r 4 = if 0x24 c, then c, ;
\ c=r\r
rec: 'c' 0 spos? '=' 1 spos? and 2 regs? and  '\' 3 spos? and 4 regs? and u 5 = and
gen: 2 nregs R\ 4 nregs r\ 0xF c, 0xA3 c, 0xC0 r 3 lshift or R or c, ;
\ c=[r\r
rec: 'c' 0 spos? '=[' 1 2spos? and 3 regs? and  '\' 4 spos? and 5 regs? and u 6 = and
gen: 3 nregs R\ 5 nregs r\ 0xF c, 0xA3 c, 0x40 r 3 lshift or R or c, R 4 = if 0x24 c, then c, ;
\ c=r\#
rec: 'c' 0 spos? '=' 1 spos? and 2 regs? and  '\' 3 spos? and a 4 + u 4 - number? nip swap n\ and u 4 > and u 7 < and
gen: 2 nregs R\ 0xF c, 0xBA c, 0xC0 0x4 3 lshift or R or c, n c, ;
\ c=[r\#
rec: 'c' 0 spos? '=[' 1 2spos? and 3 regs? and '\' 4 spos? and a 5 + u 5 - number? nip swap n\ and u 5 > and u 8 < and
gen: 3 nregs R\ 0xF c, 0xBA c, 0x40 0x4 3 lshift or R or c, R 4 = if 0x24 c, then c, n c, ;
\ c=r0\r c=r1\r c=r~\r
rec: 'c=' 0 2spos? 2 regs? and '0\' 3 2spos? '1\' 3 2spos? '~\' 3 2spos? or or and 5 regs? and u 6 = and
gen: 2 nregs R\ 5 nregs r\ 0xF c, 3 spos case '0' of 0xB3 endof '1' of 0xAB endof '~' of 0xBB endof endcase c,
     0xC0 r 3 lshift or R or c, ;
\ c=[r0\r c=[r1\r c=[r~\r
rec: 'c=' 0 2spos? '[' 2 spos? and 3 regs? and '0\' 4 2spos? '1\' 4 2spos? '~\' 4 2spos? or or and 6 regs? and u 7 = and
gen: 3 nregs R\ 6 nregs r\ 0xF c, 4 spos case '0' of 0xB3 endof '1' of 0xAB endof '~' of 0xBB endof endcase c,
     0x40 r 3 lshift or R or c, R 4 = if 0x24 c, then c, ;
\ c=r0\# c=r1\# c=r~\#
rec: 'c=' 0 2spos? 2 regs? and '0\' 3 2spos? '1\' 3 2spos? '~\' 3 2spos? or or and a 5 + u 5 - number? nip swap n\ and
     u 5 > and u 8 < and
gen: 2 nregs R\ 0xF c, 0xBA c, 0xC0 3 spos case '0' of 0x6 endof '1' of 0x5 endof '~' of 0x7 endof endcase
     3 lshift or R or c, n c, ;
\ c=[r0\# c=[r1\# c=[r~\#
rec: 'c=' 0 2spos? '[' 2 spos? and 3 regs? and '0\' 4 2spos? '1\' 4 2spos? '~\' 4 2spos? or or and a 6 + u 6 - number? nip swap n\ and
     u 6 > and u 9 < and
gen: 3 nregs R\ 0xF c, 0xBA c, 0x40 4 spos case '0' of 0x6 endof '1' of 0x5 endof '~' of 0x7 endof endcase
     3 lshift or R or c, R 4 = if 0x24 c, then c, n c, ;
\ r3210
rec: 0 regs? s" 3210" a 1+ u 1- compare 0= and gen: 0xF c, 0xC8 0 nregs or c, ;
\ r+~r
rec: 0 regs? '+~' 1 2spos? and 3 regs? and u 4 = and
gen: 0xF c, 0xC1 c, 0xC0 3 nregs 3 lshift or 0 nregs or c, ;
\ [r+~r
rec: '[' 0 spos? 1 regs? and '+~' 2 2spos? and 4 regs? and u 5 = and
gen: 0xF c, 0xC1 c, 0x40 4 nregs 3 lshift or 1 nregs or c, 1 nregs 4 = if 0x24 c, then c, ;
I: pushad   0x60 c, ;
I: popad    0x61 c, ;
I: cf=0     0xF8 c, ;
I: cf=1     0xF9 c, ;
I: df=0     0xFC c, ;
I: df=1     0xFD c, ;
I: cpuid    0x0F c, 0xA2 c, ;
I: dac=tscp 0x0F c, 0x1 c, 0xF9 c, ;
I: nop      0x90 c, ;
I: rep      0xF3 c, ;
I: repn     0xF2 c, ;
EXPORT
m: A|  {{   asmforth ; m: |A  }}    ;
m: a|  {{ [ asmforth ; m: |a  ] }}  ;
;MODULE
