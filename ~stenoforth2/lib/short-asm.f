\ stenoforth32

\ short assm
\ rO     [rO     rOr    rO[r    [rOr  rOi    [rOi  r=r*i  rc+r     c-r     rc+[r  rc-[r   rc+i   rc-i    [rc+i  [rc-i
\ r>>    r<<     [r>>   [r<<    rc>>  rc<<   [rc>> [rc<<  ra>>     ra<<    [ra>>  [ra<<   ra     rra     /r     /[r
\ r=r?   r=[r?   [r=r?  r=i?    [r=i? rO@    @Or   @Oi    <r=r     >r=r    Zr=r   zr=r    <r=[r  >r=[r   Zr=[r  zr=[r
\ r=l\r  r=h\r   r=l\[r r=h\[r  c=r\r c=[r\r c=r\i c=[r\i c=r0\r   c=[r0\r c=r0\i c=[r0\i c=r1\r c=[r1\r c=r1\i c=[r1\i
\ c=r~\r c=[r~\r c=r~\i c=[r~\i r3210 r+~r   [r+~r @Oi
\ cdq    pushad  popad  cf=0    cf=1  df=0   df=1  cpuid  dac=tscp nop

module: asmforth
: cinstr  | s\ a\ u\ | \ -- tf
  0 a u + a do i c@ s = if drop true leave then loop ;
: sym>offs u\ a\ s\ \ s a u -- offset
  a u + a do i c@ s = if i a - leave then loop ;
t: sregs acdbxpst ;   \ eax ecx edx ebx esp ebp esi  edi
t: soper |&^=+-*~ ;   \ or  and xor mov add sub imul xchg
t: soper1 |&^=+-~ ;
t: soper2 |&^=+- ;
m: regs?  a + c@ sregs  cinstr ;      \ pos reg -- flag
m: nregs  a + c@ sregs  sym>offs ;    \ pos reg -- numreg
m: oper?  a + c@ soper  cinstr ;      \ pos oper -- flag
m: oper1? a + c@ soper1 cinstr ;
m: oper2? a + c@ soper2 cinstr ;
m: spos?  a + c@ = ;                  \ sym pos -- flag
m: 2spos? a + w@ = ;                  \ 2symop pos -- flag
m: spos   a + c@ ;                    \ pos -- char
: cops  \ symb -- cop
  case '|' of 0x0B endof '&' of 0x23 endof '^' of 0x33 endof
       '+' of 0x03 endof '-' of 0x2B endof '~' of 0x87 endof
       '=' of 0x8B endof '*' of 0xAF endof
  endcase ;
: cops1 \ symb -- cop
  case '|' of 0x09 endof '&' of 0x21 endof '^' of 0x31 endof
       '+' of 0x01 endof '-' of 0x29 endof '~' of 0x87 endof
       '=' of 0x89 endof
  endcase ;
: cops2 \ symb -- cop
  case '|' of 0x81 c, 0xC8 endof '&' of 0x81 c, 0xE0 endof
       '^' of 0x81 c, 0xF0 endof '=' of 0xB8         endof
       '+' of 0x81 c, 0xC0 endof '-' of 0x81 c, 0xE8 endof
       '*' of 0x69 c, 0xC0 endof endcase ;
: cops3 \ symb -- cop
  case '|' of 0x81 c, 0x48 endof '&' of 0x81 c, 0x60 endof
       '^' of 0x81 c, 0x70 endof '=' of 0xC7 c, 0x40 endof
       '+' of 0x81 c, 0x40 endof '-' of 0x81 c, 0x68 endof endcase ;
\ ror  reg1 adc sbb reg2
: copsa  case 'c+' of 0x13 c, 0xC0 endof 'c-' of 0x1B c, 0xC0 endof endcase ;
\ roc  reg adc sbb cell
: copsb  case 'c+' of 0x13 c, 0x40 endof 'c-' of 0x1B c, 0x40 endof endcase ;
\ roi  reg adc sbb imm
: copsd  case 'c+' of 0x81 c, 0xD0 endof 'c-' of 0x81 c, 0xD8 endof endcase ;
\ ccoi  cell adc sbb imm
: copse  case 'c+' of 0x81 c, 0x50 endof 'c-' of 0x81 c, 0x58 endof endcase ;
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
     op 0xAF = if R 0= r 0= and if 0xF7 c, 0xE8 c, else 0x0F c, op ror then
               else 0xF7 op = if op c, 0xF8 r or c, else op ror then then ;
\ rO[r  |&^=+-*~
rec: 0 regs? 1 oper? and '[' 2 spos? and 3 regs? and u 4 = and
gen: 0 nregs R\ 3 nregs r\ a 1+ C@ cops op\
     roc[ c, 0x40 r or R 3 lshift or c, ]
     op 0xAF = if 0x0F c, then op roc c, ;
\ [rOr  |&^=+-~
rec: '[' 0 spos? 1 regs? and 2 oper1? and 3 regs? and u 4 = and
gen: 3 nregs R\ 1 nregs r\ a 2+ C@ cops1 op\
     op 0xAF = if 0x0F c, then op c, r 4 <>
     if 0x40 r or R 3 lshift or c, else 0x40 r or c, 0x24 c, then c, ;
\ r<< r>>
rec: 0 regs? '>>' 1 2spos? '<<' 1 2spos? dup pc\ or and u 3 = and
gen: 0xC1 c, pc if 0xE0 else 0xE8 then 0 nregs or c, c, ;
\ rc<< rc>>
rec: 0 regs? 'c' 1 spos? and '>>' 2 2spos? '<<' 2 2spos? dup pc\ or and u 4 = and
gen: 0xC1 c, pc if 0xD0 else 0xD8 then 0 nregs or c, c, ;
\ [r<< [r>>
rec: '[' 0 spos? 1 regs? and '>>' 2 2spos? '<<' 2 2spos? dup pc\ or and u 4 = and
gen: 0xC1 c, 1 nregs 4 <>
     if   pc if 0x60 else 0x68 then 1 nregs or c,
     else pc if 0x60 else 0x68 then 1 nregs or c, 0x24 c, then c, c, ;
\ [rc<< [rc>>
rec: '[' 0 spos? 1 regs? and 'c' 2 spos? and
     '>>' 3 2spos? '<<' 3 2spos? dup pc\ or and u 5 = and
gen: 0xC1 c, pc if 0x50 else 0x58 then
     1 nregs or c, 1 nregs 4 = if 0x24 c, then c, c, ;
\ ra<< ra>>
rec: 0 regs? 'a' 1 spos? and '>>' 2 2spos? '<<' 2 2spos? dup pc\ or and u 4 = and
gen: 0xC1 c, pc if 0xE0 else 0xF8 then 0 nregs or c, c, ;
\ [ra<< [ra>>
rec: '[' 0 spos? 1 regs? and 'a' 2 spos? and
     '>>' 3 2spos? '<<' 3 2spos? dup pc\ or and u 5 = and
gen: 0xC1 c, pc if 0x60 else 0x78 then
     1 nregs or c, 1 nregs 4 = if 0x24 c, then c, c, ;
\ rOi  |&^+-=*
rec: 0 n\ 0 regs? 1 oper? and 'i' 2 spos? st\ st if 1 and u 3 = and else a 2+ u 2- number? nip swap -> n and u 12 < and u 2 > and then
gen: 1 spos cops2 0 nregs dup 3 lshift or or c, st 0= if n then , ;
\ [rOi  |&^+-=
rec: 0 n\ '[' 0 spos? 1 regs? and 2 oper2? and 'i' 3 spos? st\
     st if 1 and u 4 = and else a 3 + u 3 - number? nip swap -> n and u 12 < and u 2 > and then
gen: 2 spos cops3 1 nregs 4 <> if 1 nregs or c, else 1 nregs or c, 0x24 c, then c, st 0= if n then , ;
\ r=r*i
rec: 0 n\ 0 regs? '=' 1 spos? and 2 regs? and '*' 3 spos? and 'i' 4 spos? st\
     st if 1 and u 5 = and else a 4 + u 4 - number? nip swap -> n and u 14 < and u 4 > and then
gen: '*' cops2 0 nregs 3 lshift or 2 nregs or c, st 0= if n then , ;
\ rc+r rc-r
rec: 0 regs? 'c+' 1 2spos? 'c-' 1 2spos? or and 3 regs? and u 4 = and
gen: 0 nregs  R\ 3 nregs r\ a 1+ w@ copsa R 3 lshift r or or c, ;
\ rc+[r rc-[r
rec: 0 regs? 'c+' 1 2spos? 'c-' 1 2spos? or and '[' 3 spos? and 4 regs? and u 5 = and
gen: a 1+ W@ copsb 0 nregs 3 lshift or 4 nregs or c, 4 nregs 4 = if 0x24 c, then c, ;
\ rc+i rc-i
rec: 0 n\ 0 regs? 'c+' 1 2spos? 'c-' 1 2spos? or and 'i' 3 spos? st\ st if 1 and u 4 = and
     else a 3 + u 3 - number? nip swap -> n and u 13 < and u 3 > and then
gen: a 1+ w@ copsd 0 nregs or c, st 0= if n then , ;
\ [rc+i [rc-i
rec: 0 n\ '[' 0 spos? 1 regs? and 'c+' 2 2spos? 'c-' 2 2spos? or and
      'i' 4 spos? st\ st if 1 and u 5 = and else a 4 + u 4 - number? nip swap -> n and u 13 < and u 3 > and then
gen: a 2+ W@ copse 1 nregs or c, 1 nregs 4 = if 0x24 c, then c, st 0= if n then , ;
\ ra
rec: 0 regs? 'a' 1 spos? and u 2 = and
gen: 0x8D c, 0x40 0 nregs or 0 nregs 3 lshift or c, c, ;
\ rra
rec: 0 regs? 1 regs? and 'a' 2 spos? and u 3 = and
gen: 0x8D c, 0x40 1 nregs or 0 nregs 3 lshift or c, 1 nregs 4 = if 0x24 c, then c, ;
\ /r
rec: '/' 0 spos? 1 regs? and u 2 = and
gen: 0xF7 c, 0xF8 1 nregs or c, ;
\ /[r
rec: '/' 0 spos? '[' 1 spos? and 2 regs? and u 3 = and
gen: 0xF7 c, 0x78 2 nregs or c, 2 nregs 4 = if 0x24 c, then c, ;
\ r=r?
rec: 0 regs? '=' 1 spos? and 2 regs? and '?' 3 spos? and u 4 = and
gen: 0 nregs R\ 2 nregs r\ 0x3B c, 0xC0 R 3 lshift or r or c, ;
\ r=[r?
rec: 0 regs? '=' 1 spos? and '[' 2 spos? and 3 regs? and '?' 4 spos? and u 5 = and
gen: 0x3B c, 0 nregs R\ 3 nregs r\ 0x40 R 3 lshift or r or c, r 4 = if 0x24 c, then c, ;
\ [r=r?
rec: '[' 0 spos? 1 regs? and '=' 2 spos? and 3 regs? and '?' 4 spos? and u 5 = and
gen: 0x39 c, 1 nregs R\ 3 nregs r\ 0x40 r 3 lshift or R or c, R 4 = if 0x24 c, then c, ;
\ r=i?
rec: 0 regs? '=' 1 spos? and a 2+ u 3 - number? nip swap n\ and '?' u 1- spos? and u 3 > u 11 < and and
gen: 0x81 c, 0xF8 0 nregs or c, n , ;
\ [r=i?
rec: '[' 0 spos? 1 regs? and '=' 2 spos? and a 3 + u 4 - number? nip swap n\ and '?' u 1- spos? and u 4 > u 12 < and and
gen: 0x81 c, 0x78 1 nregs or c, 1 nregs 4 = if 0x24 c, then c, n , ;
\ rO@ +-=
rec: 0 regs? '+' 1 spos? '-' 1 spos? '=' 1 spos? or or and '@' 2 spos? and u 3 = and
gen: 1 spos case '+' of 0x3 endof '-' of 0x2B endof '=' of 0x8B endof endcase c, 5 0 nregs 3 lshift or c, , ;
\ @Or +-=
rec: '@' 0 spos?  '+' 1 spos? '-' 1 spos? '=' 1 spos? or or and 2 regs? and u 3 = and
gen: 1 spos case '+' of 0x1 endof '-' of 0x29 endof '=' of 0x89 endof endcase c, 5 2 nregs 3 lshift or c, , ;
\ @Oi
rec: '@' 0 spos?  '+' 1 spos? '-' 1 spos? or '=' 1 spos? or and 'i' 2 spos? u 3 = and dup st\
      a 2 + u 2 - number? nip swap n\  u 2 > and u 12 < and or and
gen: 1 spos case '+' of 0x81 c, 0x5  c, endof '-' of 0x81 c, 0x2D c, endof '=' of 0xC7 c, 0x5  c, endof endcase
     st if  swap , , else , n , then ;
\ <r=r >r=r Zr=r zr=r
rec: '<' 0 spos? '>' 0 spos? 'Z' 0 spos? 'z' 0 spos? or or or 1 regs? and '=' 2 spos? and 3 regs? and u 4 = and
gen: 1 nregs R\ 3 nregs r\ 0xF c, 0 spos
     case '<' of 0x4C endof '>' of 0x4F endof 'Z' of 0x44 endof 'z' of 0x45 endof endcase c, 0xC0 R 3 lshift or r or c, ;
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
\ c=r\i
rec: 'c' 0 spos? '=' 1 spos? and 2 regs? and  '\' 3 spos? and a 4 + u 4 - number? nip swap n\ and u 4 > and u 7 < and
gen: 2 nregs R\ 0xF c, 0xBA c, 0xC0 0x4 3 lshift or R or c, n c, ;
\ c=[r\i
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
\ c=r0\i c=r1\i c=r~\i
rec: 'c=' 0 2spos? 2 regs? and '0\' 3 2spos? '1\' 3 2spos? '~\' 3 2spos? or or and
     a 5 + u 5 - number? nip swap n\ and u 5 > and u 8 < and
gen: 2 nregs R\ 0xF c, 0xBA c, 0xC0 3 spos case '0' of 0x6 endof '1' of 0x5 endof '~' of 0x7 endof endcase
     3 lshift or R or c, n c, ;
\ c=[r0\i c=[r1\i c=[r~\i
rec: 'c=' 0 2spos? '[' 2 spos? and 3 regs? and '0\' 4 2spos? '1\' 4 2spos? '~\' 4 2spos? or or and
     a 6 + u 6 - number? nip swap n\ and u 6 > and u 9 < and
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
i: pushad   0x60 c, ;  i: popad    0x61 c, ;
i: cf=0     0xF8 c, ;  i: cf=1     0xF9 c, ;
i: df=0     0xFC c, ;  i: df=1     0xFD c, ;
i: cpuid    0x0F c, 0xA2 c, ;
i: dac=tscp 0x0F c, 0x1 c, 0xF9 c, ;
i: nop      0x90 c, ;  i: cdq 0x99 c, ;
i: rep      0xF3 c, ;  i: repn     0xF2 c, ;
export
m: A|  {{   asmforth ; m: |A  }}    ;
m: a|  {{ [ asmforth ; m: |a  ] }}  ;
;module

