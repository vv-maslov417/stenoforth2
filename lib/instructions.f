\ stenoforth32

MODULE: instructions  \ instructions parameterizable from the stack
\ to shorten the text
\ t - top of the stack - register eax
\ rA rB rC rD rS - registers eax ebx ecx edx, esi
\ c - offset of the stack cell in bytes relative to the stack pointer from ebp,
\ b - a number in 1 byte, # - a number in 4 bytes
\ = mov =? cmp
\ in the instruction, the result receiver is on the left, and the source is on the right. Between them, an operation.
\ + - * / ++ -- arithmetic
\ | ^ & >> << -- logic and shifts
\ [rB - address in the register
\ [t=rC - write from the ecx register to the address from the eax register
\ 4 c=[t - is transferred from the address in eax to the cell addressed by the contents of ebp with an offset of +4
\ if the instruction does not need parameters, then the registers will be instead of t --> A,
\ instead of rB rC rD rS rT rP rX --> B C D S T P X

: @=t   0x0589 W, , ;
: t=@   0xA1 C, , ;

\ rOc
: t=c   0x458B W, C, ;
: B=c   0x5D8B W, C, ;
: C=c   0x4D8B W, C, ;
: D=c   0x558B W, C, ;
: S=c   0x758B W, C, ;
: T=c   0x7D8B W, C, ;

: t+c   0x4503 W, C, ;
: B+c   0x5D03 W, C, ;
: C+c   0x4D03 W, C, ;
: D+c   0x5503 W, C, ;
: S+c   0x7503 W, C, ;

: t-c   0x452B W, C, ;
: B-c   0x5D2B W, C, ;
: C-c   0x4D2B W, C, ;
: D-c   0x552B W, C, ;
: S-c   0x752B W, C, ;

: t*c   0x0F C, 0x45AF W, C, ;
: B*c   0x0F C, 0x5DAF W, C, ;
: C*c   0x0F C, 0x4DAF W, C, ;
: D*c   0x0F C, 0x55AF W, C, ;
: S*c   0x0F C, 0x75AF W, C, ;

\ rO#
: t=#   0xB8   C, , ;
: B=#   0xBB   C, , ;
: C=#   0xB9   C, , ;
: D=#   0xBA   C, , ;
: S=#   0xBE   C, , ;

: t+#   0xC081 W, , ;
: B+#   0xC381 W, , ;
: C+#   0xC181 W, , ;
: D+#   0xC281 W, , ;
: S+#   0xC681 W, , ;

: t*#   0xC069 W, , ;
: B*#   0xDB69 W, , ;
: C*#   0xC969 W, , ;
: D*#   0xD269 W, , ;
: S*#   0xF669 W, , ;

\ r=r*#
: t=B*# 0xC369 W, , ;
: t=C*# 0xC169 W, , ;
: t=D*# 0xC269 W, , ;
: t=S*# 0xC669 W, , ;
: B=t*# 0xD869 W, , ;
: B=C*# 0xD969 W, , ;
: B=D*# 0xDA69 W, , ;
: B=S*# 0xDE69 W, , ;
: C=t*# 0xC869 W, , ;
: C=B*# 0xCB69 W, , ;
: C=D*# 0xCA69 W, , ;
: C=S*# 0xCE69 W, , ;
: D=t*# 0xD069 W, , ;
: D=B*# 0xD369 W, , ;
: D=C*# 0xD169 W, , ;
: D=S*# 0xD669 W, , ;
: S=t*# 0xF069 W, , ;
: S=B*# 0xF369 W, , ;
: S=C*# 0xF169 W, , ;
: S=D*# 0xF269 W, , ;

\ cOr
: c=t   0x4589 W, C, ;
: c=B   0x5D89 W, C, ;
: c=C   0x4D89 W, C, ;
: c=D   0x5589 W, C, ;
: c=S   0x7589 W, C, ;

: c+t   0x4501 W, C, ;
: c+B   0x5D01 W, C, ;
: c+C   0x4D01 W, C, ;
: c+D   0x5501 W, C, ;
: c+S   0x7501 W, C, ;

: c-t   0x4529 W, C, ;
: c-B   0x5D29 W, C, ;
: c-C   0x4D29 W, C, ;
: c-D   0x5529 W, C, ;
: c-S   0x7529 W, C, ;

\ cO#
: c=#   0x45C7 W, C, , ;
: c+#   0x4581 W, C, , ;
: c-#   0x6D81 W, C, , ;
: c|#   0x4D81 W, C, , ;
: c&#   0x6581 W, C, , ;
: c^#   0x7581 W, C, , ;

: [B=t  0x4389 W, C, ;
: [C=t  0x4189 W, C, ;
: [D=t  0x4289 W, C, ;
: [S=t  0x4689 W, C, ;

: B=c*# 0x5D69 W, C, , ;
: LB=c  0xF C, 0x5D4C W, C, ;
: GB=c  0xF C, 0x5D4F W, C, ;
: t=c?  0x453B W, C, ;
: t=#?  0x3D C, , ;
: c=B?  0x5D39 W, C, ;
: B=#?  0xFB81 W, , ;
: B=c?  0x5D3B W, C, ;
: -c    0x5DF7 W, C, ;
: c~    0x55F7 W, C, ;
: c++   0x45FF W, C, ;
: c--   0x4DFF W, C, ;
: t&c   0x4523 W, C, ;
: t^c   0x4533 W, C, ;
: t|c   0x450B W, C, ;

: t/c   0x7DF7 W, C, ;
: c&C   0x4D21 W, C, ;
: c^C   0x4D31 W, C, ;
: c|C   0x4D09 W, C, ;
: c&t   0x4521 W, C, ;
: c^t   0x4531 W, C, ;
: c|t   0x4509 W, C, ;

: B^#   0xF381 W, , ;
: B^c   0x5D33 W, C, ;
: *c    0x6DF7 W, C, ;
: t|#   0xC881 W, , ;
: t&#   0xE081 W, , ;
: t^#   0x35 C, , ;

: t-#    NEGATE 0xC081 W, , ;

: t<<   0xE0C1 W, C, ;
: t>>   0xE8C1 W, C, ;
: ta>>  0xF8C1 W, C, ;
: ta<<  0xF0C1 W, C, ;
: c<<   0x65C1 W, C, C, ;
: c>>   0x6DC1 W, C, C, ;
: Cc<<  0x65D3 W, C, ;
: Cc>>  0x6DD3 W, C, ;
: pa    0x6D8D W, C, ; \ lea ebp,  offset [ebp]  setting the stack pointer
: t=cL  0x48B W, 0x2D C, , ;
: cL=t  0x489 W, 0x2D C, , ;

: paL    0x8D C, 0xAD C, , ;     ( offset32 -- )
: c@r    0xE8 C, DP @ 4 + - , ;  ( addr -- )     \ call rell32

EXPORT
m: g| {{   instructions ; \ compilation at state = false
m: |g }}                ;
m: i| {{ [ instructions ; \ compilation at state = true
m: |i ] }}  ;
;MODULE

\EOF  sum of squares
: ssq i| *t 0 rB=c B*B A+B 4 pa |i ;
SEE ssq
