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

: t=#    0xB8 C, , ;
: t=c    0x458B W, C, ;
: t=t*#  0xC069 W, , ;
: @=t    0x0589 W, , ;
: t=@    0xA1 C, , ;
: rB=c   0x5D8B W, C, ;
: rB=#   0xBB   C,  , ;
: rB=c*# 0x5D69 W, C, , ;
: rB+#   0xC381 W, , ;
: rC+#   0xC181 W, , ;
: rD+#   0xC281 W, , ;
: rS+#   0xC681 W, , ;
: [rB=t  0x4389 W, C, ;
: [rC=t  0x4189 W, C, ;
: [rD=t  0x4289 W, C, ;
: [rS=t  0x4689 W, C, ;
: rC=c   0x4D8B W, C, ;
: rC=#   0xB9   C,  , ;
: rD=c   0x558B W, C, ;
: rD=#   0xBA   C,  , ;
: c=t    0x4589 W, C, ;
: c=rB   0x5D89 W, C, ;
: c=rC   0x4D89 W, C, ;
: c=rD   0x5589 W, C, ;
: c=rS   0x7589 W, C, ;
: c=#    0x45C7 W, C, , ;
: LB=c   0xF C, 0x5D4C W, C, ;
: GB=c   0xF C, 0x5D4F W, C, ;
: t=c?   0x453B W, C, ;
: t=#?   0x3D C, , ;
: c=rB?  0x5D39 W, C, ;
: rB=#?  0xFB81 W, , ;
: rB=c?  0x5D3B W, C, ;
: -c     0x5DF7 W, C, ;
: c~     0x55F7 W, C, ;
: c++    0x45FF W, C, ;
: c--    0x4DFF W, C, ;
: t&c    0x4523 W, C, ;
: t^c    0x4533 W, C, ;
: t|c    0x450B W, C, ;
: t+c    0x4503 W, C, ;
: t-c    0x452B W, C, ;
: t*c    0x0F C, 0x45AF W, C, ;
: t/c    0x7DF7 W, C, ;
: rB+c   0x5D03 W, C, ;
: rB-c   0x5D2B W, C, ;
: rB*c   0x0F C, 0x5DAF W, C, ;
: rC+c   0x4D03 W, C, ;
: rC-c   0x4D2B W, C, ;
: rC*c   0x0F C, 0x4DAF W, C, ;
: rD+c   0x5503 W, C, ;
: rD-c   0x552B W, C, ;
: rD*c   0x0F C, 0x55AF W, C, ;
: rS=c   0x758B W, C, ;
: rS+c   0x7503 W, C, ;
: rS-c   0x752B W, C, ;
: rS*c   0x0F C, 0x75AF W, C, ;
: c&rC   0x4D21 W, C, ;
: c^rC   0x4D31 W, C, ;
: c|rC   0x4D09 W, C, ;
: c+rC   0x4D01 W, C, ;
: c-rC   0x4D29 W, C, ;
: c&t    0x4521 W, C, ;
: c^t    0x4531 W, C, ;
: c|t    0x4509 W, C, ;
: c+t    0x4501 W, C, ;
: c-t    0x4529 W, C, ;
: rB^#   0xF381 W, , ;
: rB^c   0x5D33 W, C, ;
: *c     0x6DF7 W, C, ;
: t|#    0xC881 W, , ;
: t&#    0xE081 W, , ;
: t^#    0x35 C, , ;
: t+#    0xC081 W, , ;
: t-#    NEGATE 0xC081 W, , ;
: c|#    0x4D81 W, C, , ;
: c&#    0x6581 W, C, , ;
: c^#    0x7581 W, C, , ;
: c+#    0x4581 W, C, , ;
: c-#    0x6D81 W, C, , ;
: t<<    0xE0C1 W, C, ;
: t>>    0xE8C1 W, C, ;
: ta>>   0xF8C1 W, C, ;
: ta<<   0xF0C1 W, C, ;
: c<<    0x65C1 W, C, C, ;
: c>>    0x6DC1 W, C, C, ;
: rCc<<  0x65D3 W, C, ;
: rCc>>  0x6DD3 W, C, ;
: pa     0x6D8D W, C, ; \ lea ebp,  offset [ebp]  setting the stack pointer
: t=cL   0x48B W, 0x2D C, , ;
: cL=t   0x489 W, 0x2D C, , ;
: rT=c   0x7D8B W, C, ;
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
