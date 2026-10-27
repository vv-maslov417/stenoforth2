\ stenoforth32

\ t  - register eax
\ á  - offset @P
\ p  - reg ebp
\ x  - reg esp
\ 1  - reg ecx
\ 2  - reg edx
\ 3  - reg ebx
\ 6  - reg esi
\ 7  - reg edi
\ @  - address
\ [1 - [reg]

: @=t   0x0589 W, , ;
: t=@   0xA1 C, , ;

\ rOc
: t=c   0x458B W, C, ;
: 3=c   0x5D8B W, C, ;
: 1=c   0x4D8B W, C, ;
: 2=c   0x558B W, C, ;
: 6=c   0x758B W, C, ;
: 7=c   0x7D8B W, C, ;

: t+c   0x4503 W, C, ;
: 3+c   0x5D03 W, C, ;
: 1+c   0x4D03 W, C, ;
: 2+c   0x5503 W, C, ;
: 6+c   0x7503 W, C, ;

: t-c   0x452B W, C, ;
: 3-c   0x5D2B W, C, ;
: 1-c   0x4D2B W, C, ;
: 2-c   0x552B W, C, ;
: 6-c   0x752B W, C, ;

: t*c   0x0F C, 0x45AF W, C, ;
: 3*c   0x0F C, 0x5DAF W, C, ;
: 1*c   0x0F C, 0x4DAF W, C, ;
: 2*c   0x0F C, 0x55AF W, C, ;
: 6*c   0x0F C, 0x75AF W, C, ;

\ rO#
: t=#   0xB8   C, , ;
: 3=#   0xBB   C, , ;
: 1=#   0xB9   C, , ;
: 2=#   0xBA   C, , ;
: 6=#   0xBE   C, , ;

: t+#   0xC081 W, , ;
: 3+#   0xC381 W, , ;
: 1+#   0xC181 W, , ;
: 2+#   0xC281 W, , ;
: 6+#   0xC681 W, , ;

: t*#   0xC069 W, , ;
: 3*#   0xDB69 W, , ;
: 1*#   0xC969 W, , ;
: 2*#   0xD269 W, , ;
: 6*#   0xF669 W, , ;

\ r=r*#
: t=3*# 0xC369 W, , ;
: t=1*# 0xC169 W, , ;
: t=2*# 0xC269 W, , ;
: t=6*# 0xC669 W, , ;
: 3=t*# 0xD869 W, , ;
: 3=1*# 0xD969 W, , ;
: 3=2*# 0xDA69 W, , ;
: 3=6*# 0xDE69 W, , ;
: 1=t*# 0xC869 W, , ;
: 1=3*# 0xCB69 W, , ;
: 1=2*# 0xCA69 W, , ;
: 1=6*# 0xCE69 W, , ;
: 2=t*# 0xD069 W, , ;
: 2=3*# 0xD369 W, , ;
: 2=1*# 0xD169 W, , ;
: 2=6*# 0xD669 W, , ;
: 6=t*# 0xF069 W, , ;
: 6=3*# 0xF369 W, , ;
: 6=1*# 0xF169 W, , ;
: 6=2*# 0xF269 W, , ;

\ cOr
: c=t   0x4589 W, C, ;
: c=3   0x5D89 W, C, ;
: c=1   0x4D89 W, C, ;
: c=2   0x5589 W, C, ;
: c=6   0x7589 W, C, ;

: c+t   0x4501 W, C, ;
: c+3   0x5D01 W, C, ;
: c+1   0x4D01 W, C, ;
: c+2   0x5501 W, C, ;
: c+6   0x7501 W, C, ;

: c-t   0x4529 W, C, ;
: c-3   0x5D29 W, C, ;
: c-1   0x4D29 W, C, ;
: c-2   0x5529 W, C, ;
: c-6   0x7529 W, C, ;

\ cO#
: c=#   0x45C7 W, C, , ;
: c+#   0x4581 W, C, , ;
: c-#   0x6D81 W, C, , ;
: c|#   0x4D81 W, C, , ;
: c&#   0x6581 W, C, , ;
: c^#   0x7581 W, C, , ;

: [3=t  0x4389 W, C, ;
: [1=t  0x4189 W, C, ;
: [2=t  0x4289 W, C, ;
: [6=t  0x4689 W, C, ;

: 3=c*# 0x5D69 W, C, , ;
: L3=c  0xF C, 0x5D4C W, C, ;
: G3=c  0xF C, 0x5D4F W, C, ;
: t=c?  0x453B W, C, ;
: t=#?  0x3D C, , ;
: c=3?  0x5D39 W, C, ;
: 3=#?  0xFB81 W, , ;
: 3=c?  0x5D3B W, C, ;
: -c    0x5DF7 W, C, ;
: c~    0x55F7 W, C, ;
: c++   0x45FF W, C, ;
: c--   0x4DFF W, C, ;
: t&c   0x4523 W, C, ;
: t^c   0x4533 W, C, ;
: t|c   0x450B W, C, ;

: t/c   0x7DF7 W, C, ;
: c&1   0x4D21 W, C, ;
: c^1   0x4D31 W, C, ;
: c|1   0x4D09 W, C, ;
: c&t   0x4521 W, C, ;
: c^t   0x4531 W, C, ;
: c|t   0x4509 W, C, ;

: 3^#   0xF381 W, , ;
: 3^c   0x5D33 W, C, ;
: *c    0x6DF7 W, C, ;
: t|#   0xC881 W, , ;
: t&#   0xE081 W, , ;
: t^#   0x35 C, , ;

: t-#   NEGATE 0xC081 W, , ;

: t<<   0xE0C1 W, C, ;
: t>>   0xE8C1 W, C, ;
: ta>>  0xF8C1 W, C, ;
: ta<<  0xF0C1 W, C, ;
: c<<   0x65C1 W, C, C, ;
: c>>   0x6DC1 W, C, C, ;
: 1c<<  0x65D3 W, C, ;
: 1c>>  0x6DD3 W, C, ;
: pa    0x6D8D W, C, ; \ lea ebp,  offset [ebp]  setting the stack pointer
: t=cL  0x48B W, 0x2D C, , ;
: cL=t  0x489 W, 0x2D C, , ;

: paL    0x8D C, 0xAD C, , ;     ( offset32 -- )
: c@r    0xE8 C, DP @ 4 + - , ;  ( addr -- )     \ call rell32
