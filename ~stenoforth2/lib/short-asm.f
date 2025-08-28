\ stenoforth32

\ short assm \ rO [rO rOr rO[r [rOr r>> r<< [r>> [r<< rO# [rO#
\ r=r*# rc+r rc-r rc+[r rc-[r  rc+# rc-# rc+# rc-# [rc+# [rc-#
\ ra rra /r /[r5 cdq rc<< rc>> [rc>> [rc<<

MODULE: asmforth
m: exit 0= IF a u NOTFOUND EXIT THEN ;
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
m: cpos a + C@ ;                    \ pos -- char
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
       '*' OF 0x69 C, 0xC0 ENDOF
  ENDCASE ;
: cops3 \ symb -- cop
  CASE '|' OF 0x81 C, 0x48 ENDOF '&' OF 0x81 C, 0x60 ENDOF
       '^' OF 0x81 C, 0x70 ENDOF '=' OF 0xC7 C, 0x40 ENDOF
       '+' OF 0x81 C, 0x40 ENDOF '-' OF 0x81 C, 0x68 ENDOF
  ENDCASE ;
\ ror  reg1 adc sbb reg2
: copsa  CASE 'c+' OF 0x13 C, 0xC0 ENDOF
              'c-' OF 0x1B C, 0xC0 ENDOF
         ENDCASE ;
\ roc  reg adc sbb cell
: copsb  CASE 'c+' OF 0x13 C, 0x40 ENDOF
              'c-' OF 0x1B C, 0x40 ENDOF
         ENDCASE ;
\ roi  reg adc sbb imm
: copsd  CASE 'c+' OF 0x81 C, 0xD0 ENDOF
              'c-' OF 0x81 C, 0xD8 ENDOF
         ENDCASE ;
\ ccoi  cell adc sbb imm
: copse  CASE 'c+' OF 0x81 C, 0x50 ENDOF
              'c-' OF 0x81 C, 0x58 ENDOF
         ENDCASE ;
0 WARNING !
\ rO
: NOTFOUND u\ a\
  0 regs? '-' 1 spos? '~' 1 spos? or 'i' 1 spos? or 'j' 1 spos? or and
  u 2 = AND exit 0 nregs 1 cpos
  case '-' of 0xF7 c, 0xD8 endof '~' of 0xF7 c, 0xD0 endof
       'i' of 0x40         endof 'j' of 0x48         endof
  endcase or c, ;
\ [rO  -~ij
: NOTFOUND u\ a\
  '[' 0 spos? 1 regs? and '-' 2 spos? '~' 2 spos? 'i' 2 spos? 'j' 2 spos?
  or or or and u 3 = and exit 1 nregs 2 cpos
  case '-' of 0xF7 c, 0x58 endof '~' of 0xF7 c, 0x50 endof
       'i' of 0xFF c, 0x40 endof 'j' of 0xFF c, 0x48 endof
  endcase or c, c, ;
\ rOr  |&^=+-*~
: NOTFOUND u\ a\
  0 regs? 1 oper? and 2 regs? and
  u 3 = and exit 0 nregs R\ 2 nregs r\ a 1+ C@ cops op\
  ror[ c, R 3 lshift r 0xC0 or or c, ]
  op 0xAF = if R 0= r 0= and if 0xF7 c, 0xE8 c, else 0x0F C, op ror then
            else 0xF7 op = if op c, 0xF8 r or c, else op ror then then ;
\ rO[r  |&^=+-*~
: NOTFOUND u\ a\
  0 regs? 1 oper? and '[' 2 spos? and 3 regs? and
  u 4 = and  exit 0 nregs R\ 3 nregs r\ a 1+ C@ cops op\
  roc[ c, 0x40 r or R 3 lshift or c, ]
  op 0xAF = if 0x0F c, then op roc c, ;
\ [rOr  |&^=+-~
: NOTFOUND u\ a\
  '[' 0 spos? 1 regs? and 2 oper1? and 3 regs? and
  u 4 = and exit 3 nregs R\ 1 nregs r\ a 2+ C@ cops1 op\
  op 0xAF = if 0x0F c, then op c, r 4 <>
  if 0x40 r or R 3 lshift or c, else 0x40 r or c, 0x24 c, then c, ;
\ r<< r>>
: NOTFOUND u\ a\
  0 regs? '>>' 1 2spos? '<<' 1 2spos? dup pc\ or and
  u 3 = and exit 0xC1 c, pc if 0xE0 else 0xE8 then 0 nregs or c, c, ;
\ rc<< rc>>
: NOTFOUND u\ a\
  0 regs? 'c' 1 spos? and '>>' 2 2spos? '<<' 2 2spos? dup pc\ or and
  u 4 = and exit 0xC1 c, pc if 0xD0 else 0xD8 then 0 nregs or c, c, ;
\ [r<< [r>>
: NOTFOUND u\ a\
  '[' 0 spos? 1 regs? and '>>' 2 2spos? '<<' 2 2spos? dup pc\ or and
  u 4 = and exit 0xC1 c, 1 nregs 4 <>
  if   pc if 0x60 else 0x68 then 1 nregs or c,
  else pc if 0x60 else 0x68 then 1 nregs or c, 0x24 c, then c, c, ;
\ [rc<< [rc>>
: NOTFOUND u\ a\
  '[' 0 spos? 1 regs? and  '>>' 3 2spos? '<<' 3 2spos? dup pc\ or and
  u 5 = and exit 0xC1 c, pc if 0x50 else 0x58 then
  1 nregs or c, 1 nregs 4 = if 0x24 c, then c, c, ;
\ rO#  |&^+-=*
: NOTFOUND u\ a\
  0 regs? 1 oper? and
  a 2+ u 2- number? nip swap n\ and u 12 < and u 2 > and
  exit 1 cpos cops2 0 nregs dup 3 lshift or or c, n , ;
\ [rO#  |&^+-=
: NOTFOUND u\ a\
  '[' 0 spos? 1 regs? and 2 oper2? and
  a 3 + u 3 - number? nip swap n\ and u 12 < and u 2 > and
  exit 2 cpos cops3 1 nregs 4 <> if 1 nregs or c,
  else 1 nregs or c, 0x24 c, then c, n , ;
\ r=r*#
: NOTFOUND u\ a\
  0 regs? '=' 1 spos? and 2 regs? and '*' 3 spos? and
  a 4 + u 4 - number? nip swap n\ and u 14 < and u 4 > and
  exit '*' cops2 0 nregs 3 lshift or 2 nregs or c, n , ;
\ rc+r rc-r
: NOTFOUND u\ a\
  0 regs? 'c+' 1 2spos? 'c-' 1 2spos? or and 3 regs? and u 4 = and
  exit 0 nregs R\ 3 nregs r\ a 1+ w@ copsa R 3 lshift r or or c, ;
\ rc+[r rc-[r
: NOTFOUND u\ a\
  0 regs? 'c+' 1 2spos? 'c-' 1 2spos? or and '[' 3 spos? and 4 regs? and
  u 5 = and exit a 1+ W@ copsb 0 nregs 3 lshift or 4 nregs or c,
  4 nregs 4 = IF 0x24 c, THEN c, ;
\ rc+# rc-#
: NOTFOUND u\ a\
  0 regs? 'c+' 1 2spos? 'c-' 1 2spos? or and
  a 3 + u 3 - number? nip swap n\ and u 13 < and u 3 > and
  exit a 1+ w@ copsd 0 nregs or c, n , ;
\ [rc+# [rc-#
: NOTFOUND u\ a\
  '[' 0 spos? 1 regs? and 'c+' 2 2spos? 'c-' 2 2spos? or and
  a 4 + u 4 - number? nip swap n\ and u 13 < and u 3 > and exit
  a 2+ W@ copse 1 nregs or c, 1 nregs 4 = if 0x24 c, then c, n , ;
\ ra
: NOTFOUND u\ a\
  0 regs? 'a' 1 spos? and u 2 = and
  exit 0x8D c, 0x40 0 nregs or 0 nregs 3 LSHIFT or c, c, ;
\ rra
: NOTFOUND u\ a\
  0 regs? 1 regs? and 'a' 2 spos? and u 3 = and
  exit 0x8D c, 0x40 1 nregs or 0 nregs 3 LSHIFT or c, 1 nregs 4 = if 0x24 c, then c, ;
\ /r
: NOTFOUND u\ a\
  '/' 0 spos? 1 regs? and u 2 = and exit 0xF7 c, 0xF8 1 nregs or c, ;
\ /[r
: NOTFOUND u\ a\
  '/' 0 spos? '[' 1 spos? and 2 regs? and u 3 = and
  exit 0xF7 c, 0x78 2 nregs or c, 2 nregs 4 = if 0x24 c, then c, ;
: cdq 0x99 c, ; immediate
EXPORT
m: A|  {{   asmforth ;
m: |A  }}            ;
m: a|  {{ [ asmforth ;
m: |a  ] }}          ;
;MODULE
