\ stenoforth32

\ instructions parameterizable from the stack
\ to shorten the text
\ t - top of the stack - register eax
\ t B C D S T - registers eax ebx ecx edx esi edi
\ u - offset of the stack cell in bytes relative to the stack pointer from ebp,
\ b - a number in 1 byte, # - a number in 4 bytes
\ = mov =? cmp
\ in the instruction, the result receiver is on the left, and the source is on the right. Between them, an operation.
\ + - * / ++ -- arithmetic
\ | ^ & >> << -- logic and shifts
\ [B - address in the register
\ [tC= - write from the ecx register to the address from the eax register
\ 4 c[t= - is transferred from the address in eax to the cell addressed by the contents of ebp with an offset of +4
\ if the instruction does not need parameters, then the registers will be instead of t --> A,
\ instead of B C D S T P X --> EBX ECX EDX ESI EDI EBP EXP

: @t=   0x0589 W, , ;
: t@=   0xA1 C, , ;

\ ruO
: tu=   0x458B W, C, ;
: Bu=   0x5D8B W, C, ;
: Cu=   0x4D8B W, C, ;
: Du=   0x558B W, C, ;
: Su=   0x758B W, C, ;
: Tu=   0x7D8B W, C, ;

: tu+   0x4503 W, C, ;
: Bu+   0x5D03 W, C, ;
: Cu+   0x4D03 W, C, ;
: Du+   0x5503 W, C, ;
: Su+   0x7503 W, C, ;

: tu-   0x452B W, C, ;
: Bu-   0x5D2B W, C, ;
: Cu-   0x4D2B W, C, ;
: Du-   0x552B W, C, ;
: Su-   0x752B W, C, ;

: tu*   0x0F C, 0x45AF W, C, ;
: Bu*   0x0F C, 0x5DAF W, C, ;
: Cu*   0x0F C, 0x4DAF W, C, ;
: Du*   0x0F C, 0x55AF W, C, ;
: Su*   0x0F C, 0x75AF W, C, ;

\ r#O
: t#=   0xB8   C, , ;
: B#=   0xBB   C, , ;
: C#=   0xB9   C, , ;
: D#=   0xBA   C, , ;
: S#=   0xBE   C, , ;

: t#+   0xC081 W, , ;
: B#+   0xC381 W, , ;
: C#+   0xC181 W, , ;
: D#+   0xC281 W, , ;
: S#+   0xC681 W, , ;

: t#*   0xC069 W, , ;
: B#*   0xDB69 W, , ;
: C#*   0xC969 W, , ;
: D#*   0xD269 W, , ;
: S#*   0xF669 W, , ;

\ rr*#=
: tB*#= 0xC369 W, , ;
: tC*#= 0xC169 W, , ;
: tD*#= 0xC269 W, , ;
: tS*#= 0xC669 W, , ;
: Bt*#= 0xD869 W, , ;
: BC*#= 0xD969 W, , ;
: BD*#= 0xDA69 W, , ;
: BS*#= 0xDE69 W, , ;
: Ct*#= 0xC869 W, , ;
: CB*#= 0xCB69 W, , ;
: CD*#= 0xCA69 W, , ;
: CS*#= 0xCE69 W, , ;
: Dt*#= 0xD069 W, , ;
: DB*#= 0xD369 W, , ;
: DC*#= 0xD169 W, , ;
: DS*#= 0xD669 W, , ;
: St*#= 0xF069 W, , ;
: SB*#= 0xF369 W, , ;
: SC*#= 0xF169 W, , ;
: SD*#= 0xF269 W, , ;

\ urO
: ut=   0x4589 W, C, ;
: uB=   0x5D89 W, C, ;
: uC=   0x4D89 W, C, ;
: uD=   0x5589 W, C, ;
: uS=   0x7589 W, C, ;

: ut+   0x4501 W, C, ;
: uB+   0x5D01 W, C, ;
: uC+   0x4D01 W, C, ;
: uD+   0x5501 W, C, ;
: uS+   0x7501 W, C, ;

: ut-   0x4529 W, C, ;
: uB-   0x5D29 W, C, ;
: uC-   0x4D29 W, C, ;
: uD-   0x5529 W, C, ;
: uS-   0x7529 W, C, ;

\ u#O
: u#=   0x45C7 W, C, , ;
: u#+   0x4581 W, C, , ;
: u#-   0x6D81 W, C, , ;
: u#|   0x4D81 W, C, , ;
: u#&   0x6581 W, C, , ;
: u#^   0x7581 W, C, , ;

: [Bt=  0x4389 W, C, ;
: [Ct=  0x4189 W, C, ;
: [Dt=  0x4289 W, C, ;
: [St=  0x4689 W, C, ;

: Bc*#= 0x5D69 W, C, , ;
: LBu=  0xF C, 0x5D4C W, C, ;
: GBu=  0xF C, 0x5D4F W, C, ;
: tu?=  0x453B W, C, ;
: t#?=  0x3D C, , ;
: uB?=  0x5D39 W, C, ;
: B#?=  0xFB81 W, , ;
: Bu?=  0x5D3B W, C, ;
: -u    0x5DF7 W, C, ;
: u~    0x55F7 W, C, ;
: u++   0x45FF W, C, ;
: u--   0x4DFF W, C, ;
: tu&   0x4523 W, C, ;
: tu^   0x4533 W, C, ;
: tu|   0x450B W, C, ;

: tu/   0x7DF7 W, C, ;
: uC&   0x4D21 W, C, ;
: uC^   0x4D31 W, C, ;
: uC|   0x4D09 W, C, ;
: ut&   0x4521 W, C, ;
: ut^   0x4531 W, C, ;
: ut|   0x4509 W, C, ;

: B#^   0xF381 W, , ;
: Bu^   0x5D33 W, C, ;
: *t    0xE8F7 W, ;
: *u    0x6DF7 W, C, ;
: t#|   0xC881 W, , ;
: t#&   0xE081 W, , ;
: t#^   0x35 C, , ;

: t#-    NEGATE 0xC081 W, , ;

: tB+   0xC303 W, ;
: tC+   0xC103 W, ;
: tD+   0xC203 W, ;
: tS+   0xC603 W, ;
: BB*   0x0F C, 0xDBAF W, ;

: t<<   0xE0C1 W, C, ;
: t>>   0xE8C1 W, C, ;
: ta>>  0xF8C1 W, C, ;
: ta<<  0xF0C1 W, C, ;
: u<<   0x65C1 W, C, C, ;
: u>>   0x6DC1 W, C, C, ;
: Cc<<  0x65D3 W, C, ;
: Cc>>  0x6DD3 W, C, ;
: pa    0x6D8D W, C, ; \ lea ebp,  offset [ebp]  setting the stack pointer
: tcL=  0x48B W, 0x2D C, , ;
: cLt=  0x489 W, 0x2D C, , ;
: paL    0x8D C, 0xAD C, , ;     ( offset32 -- )
\ : c@r    0xE8 C, DP @ 4 + - , ;  ( addr -- )     \ call rell32

\EOF
: s1 [ 1 0 u<< ] ; see s1

\ запись выражения
: s1 /[541+5*32+/'1 ;
 1 2 3 4 5 s1
