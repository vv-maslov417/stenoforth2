\ stenoforth32

MODULE: instructions
\ to shorten the text
\ t - top of the stack - register eax
\ A B C D S - registers eax ebx ecx edx, esi
\ c - offset of the stack cell in bytes relative to the stack pointer from ebp,
\ b - a number in 1 byte, # - a number in 4 bytes
\ = mov =? cmp
\ in the instruction, the result receiver is on the left, and the source is on the right. Between them, an operation.
\ t+B - add the contents of the ebx register to the contents of eax
\ + - * / ++ -- arithmetic
\ | ^ & >> << -- logic and shifts
\ [r - address in the register
\ [t=C - write from the ecx register to the address from the eax register
\ 4 c=[t - is transferred from the address in eax to the cell addressed by the contents of ebp with an offset of +4

: t=0    0xC0C7 W, 0 , ;
: t=-1   0xB8 C, 0xFFFFFFFF , ;
: t=1    0xB8 C, 1 , ;
: t=#    0xB8 C, , ;
: t=B    0xC38B W, ;
: t=C    0xC18B W, ;
: t=D    0xC28B W, ;
: t=S    0xC68B W, ;
: t=c    0x458B W, C, ;
: t=[t   0x008B W, ;
: [t=t   0x0089 W, ;
: [t=B   0x1889 W, ;
: [t=bB  0x1888 W, ;
: [t=C   0x0889 W, ;
: [t=bC  0x0888 W, ;
: [t=D   0x1089 W, ;
: [t=bD  0x1088 W, ;
: [t=S   0x3089 W, ;
: [t=bS  0x3088 W, ;

: [t+B   0x1801 W, ;
: [t+C   0x0801 W, ;
: [t+D   0x1001 W, ;
: [t+S   0x3001 W, ;

: B=b[t  0xF C, 0x18B6 W, ;
: B=b[B  0xF C, 0x1BB6 W, ;
: B=b[C  0xF C, 0x19B6 W, ;
: B=b[D  0xF C, 0x1AB6 W, ;
: C=b[t  0xF C, 0x08B6 W, ;
: C=b[B  0xF C, 0x0BB6 W, ;
: C=b[C  0xF C, 0x09B6 W, ;
: C=b[D  0xF C, 0x0AB6 W, ;
: D=b[t  0xF C, 0x10B6 W, ;
: D=b[B  0xF C, 0x13B6 W, ;
: D=b[C  0xF C, 0x11B6 W, ;
: D=b[D  0xF C, 0x12B6 W, ;
: [B=bC  0x0B88 W, ;

: t=b[t  0xF C, 0x00B6 W, ;
: t=b[B  0xF C, 0x03B6 W, ;
: t=b[C  0xF C, 0x01B6 W, ;
: t=b[D  0xF C, 0x02B6 W, ;

: t=LE   0x9E0F W, 0xC0 C, ;
: t=G    0x9F0F W, 0xC0 C, ;
: t=GE   0x9D0F W, 0xC0 C, ;
: t=bt   0xBE0F W, 0xC0 C, ;
: t=t*#  0xC069 W, , ;

: @=t    0x0589 W, , ;
: t=@    0xA1 C, , ;

: B=GE   0x9D0F W, 0xC3 C, ;
: B=LE   0x9E0F W, 0xC3 C, ;
: B=t    0xD88B W, ;
: B=c    0x5D8B W, C, ;
: B=C    0xD98B W, ;
: B=#    0xBB   C,  , ;
: B=c*#  0x5D69 W, C, , ;

: C=c    0x4D8B W, C, ;
: C=t    0xC88B W,    ;
: C=#    0xB9   C,  , ;

: D=c    0x558B W, C, ;
: D=#    0xBA   C,  , ;
: D=[D   0x128B W,    ;

: c=0    0x45C7 W, C, 0 , ;
: c=-1   0x45C7 W, C, -1 , ;
: c=t    0x4589 W, C, ;
: c=B    0x5D89 W, C, ;
: c=C    0x4D89 W, C, ;
: c=D    0x5589 W, C, ;
: c=S    0x7589 W, C, ;
: c=#    0x45C7 W, C, , ;
: LB=c   0xF C, 0x5D4C W, C, ;
: GB=c   0xF C, 0x5D4F W, C, ;
: LB=D   0xF C, 0xDA4C W, ;
: GB=D   0xF C, 0xDA4F W, ;
: Gt=D   0xF C, 0xC24F W, ;

: t=c?   0x453B W, C, ;
: t=#?   0x3D C, , ;

: c=B?   0x5D39 W, C, ;

: B=D?   0xDA3B W, ;
: B=#?   0xFB81 W, , ;
: B=c?   0x5D3B W, C, ;

: D=t?   0xD03B W, ;

: -t     0xD8F7 W, ;
: t~     0xD0F7 W, ;
: t--    0x48 C, ;

: -B     0xDBF7 W, ;
: -C     0xD9F7 W, ;
: -D     0xDAF7 W, ;

: B--    0x4B C, ;

: -c     0x5DF7 W, C, ;
: c~     0x55F7 W, C, ;
: c++    0x45FF W, C, ;
: c--    0x4DFF W, C, ;

: t^t    0xC033 W, ;
: t&t    0xC023 W, ;
: t|t    0xC00B W, ;
: t&c    0x4523 W, C, ;
: t^c    0x4533 W, C, ;
: t|c    0x450B W, C, ;
: t+c    0x4503 W, C, ;
: t-c    0x452B W, C, ;
: t*c    0x0F C, 0x45AF W, C, ;

: t/c    0x7DF7 W, C, ;
: t/B    0xFBF7 W, ;
: t/C    0xF9F7 W, ;
: t/D    0xFAF7 W, ;
: t/S    0xFEF7 W, ;

: B+c    0x5D03 W, C, ;
: B-c    0x5D2B W, C, ;
: B*c    0x0F C, 0x5DAF W, C, ;

: C+c    0x4D03 W, C, ;
: C-c    0x4D2B W, C, ;
: C*c    0x0F C, 0x4DAF W, C, ;

: D+c    0x5503 W, C, ;
: D-c    0x552B W, C, ;
: D*c    0x0F C, 0x55AF W, C, ;

: S=c    0x758B W, C, ;
: S+c    0x7503 W, C, ;
: S-c    0x752B W, C, ;
: S*c    0x0F C, 0x75AF W, C, ;

: t|B    0x0B C, ;
: t^B    0x33 C, ;
: t&B    0x23 C, ;
: t+B    0xC303 W, ;
: t-B    0x2B C, ;

: t+t    0xC003 W, ;
: t-t    0xC01B W, ;

: c&C    0x4D21 W, C, ;
: c^C    0x4D31 W, C, ;
: c|C    0x4D09 W, C, ;
: c+C    0x4D01 W, C, ;
: c-C    0x4D29 W, C, ;

: c&t    0x4521 W, C, ;
: c^t    0x4531 W, C, ;
: c|t    0x4509 W, C, ;
: c+t    0x4501 W, C, ;
: c-t    0x4529 W, C, ;

: B^#    0xF381 W, , ;
: B^c    0x5D33 W, C, ;

: t*B    0x0F C, 0xC3AF W, ;
: cdq    0x99 C, ;
: idivC  0xF9F7 W, ;
: t-1    0xE883 W, 1 C, ;
: B-1    0xEB83 W, 1 C, ;
: fB-B   0xDB1B W, ;
: B&1    0xE383 W, 1 C, ;

: >t=D   0x4F0F W, 0xC2 C, ;
: <t=D   0x4C0F W, 0xC2 C, ;

: t&1    0xE083 W, 1 C, ;
: *c     0x6DF7 W, C, ;
: *t     0xE8F7 W, ;

: B*B    0xAF0F W, 0xDB C, ;

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

: t^C    0xC133 W, ;
: t-C    0xC12B W, ;

: c<<    0x65C1 W, C, C, ;
: c>>    0x6DC1 W, C, C, ;
: ta>>31 0xF8C1 W, 0x1F C, ;
: Ca>>31 0xF9C1 W, 0x1F C, ;
: Ct<<   0xE0D3 W, ;
: Ct>>   0xE8D3 W, ;
: Cc<<   0x65D3 W, C, ;
: Cc>>   0x6DD3 W, C, ;

: Lt+1   0x408D W, 1 C, ;
: Lt-1   0x408D W, 0xFF C, ;
: Lt+2   0x408D W, 0x02 C, ;
: Lt-2   0x408D W, 0xFE C, ;
: Lt*2   0x8D C, 0x4 C, 0x45 C, 0 , ;
: Lt/2   0xF8D1 W, ;
: Lt=D   0x0F C, 0xC24C W, ;

: B+t    0xD803 W, ;
: B-t    0xD82B W, ;
: B*t    0xAF0F W, 0xD8 C, ;

: C+t    0xC803 W, ;
: C-t    0xC82B W, ;
: C*t    0xAF0F W, 0xC8 C, ;

: D+t    0xD003 W, ;
: D-t    0xD02B W, ;
: D*t    0xAF0F W, 0xD0 C, ;

: S+t    0xF003 W, ;
: S-t    0xF02B W, ;
: S*t    0xAF0F W, 0xF0 C, ;

: c2-    0x6D83 W, C, 2 C, ;
: c2+    0x4583 W, C, 2 C, ;

: z=t&t  0xC085 W, ;
: P+t    0xE803 W, ;
: t-P    0xC52B W, ;
: pa     0x6D8D W, C, ; \ lea ebp,  offset [ebp]  setting the stack pointer

: t=cL   0x48B W, 0x2D C, , ;
: cL=t   0x489 W, 0x2D C, , ;

: repnz  0xF2 C, ;
: stosb  0xAA C, ;
: stosd  0xAB C, ;

: B^B  0xDB33 W, ;
: C^C  0xC933 W, ;
: D^D  0xD233 W, ;
: S^S  0xF633 W, ;
: T^T  0xFF33 W, ;
: S=T  0xF78B W, ;
: T=S  0xFE8B W, ;
: T=c  0x7D8B W, C, ;

: PaL ( offset -- )   0x8D C, 0xAD C, , ;

EXPORT
m: g| {{   instructions ;
m: |g }}                ;
m: i| {{ [ instructions ;
m: |i ] }}  ;
;MODULE

\EOF  sum of squares
: ssq i| *t 0 B=c B*B t+B 4 Pa |i ;
SEE ssq
