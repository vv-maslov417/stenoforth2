( выражение состоит из последовательности операндов и операторов
операнды могут быть именованные и неименованные и могут находиться в стеке и в регистрах
операторы могут быть двухоперандные, однооперандные и безоперандные
каждый оператор имеет свой результат в регистре или в стеке
оператор может иметь в качестве операндов результаты предыдущих операторов и исходные операнды в стеке )

\ сколько ячеек в стеке до исполнения и сколько ячеек после исполнения кода определения


rec:
1 '|' pos-char? u '|' pos-char? and
gen:
[ 6 ] regs] regs 6 erase
[ 9 ] opers] opers 9 erase
0 nopers\
op++[ nopers 1+ -> nopers ]

[ 5 ] regc]
   0 regc      c!
0x5D regc 1 +  c!
0x4D regc 2 +  c!
0x55 regc 3 +  c!
0x75 regc 4 +  c!

[ 9 ] celr] celr 9 erase
dig?[ i swap - c@ '0' '9' 1+ within ]
2 pos>char '0' - nmax\
sm[ '0' - nmax swap - 1- cells ]
0 rgf\
rfree[ 0 regs 1+ 5 ado i c@ 0=
 if drop i regs - regc + c@ 1 i c! leave then
loop -> rgf ]
cel-r?[ celr + c@ ]
set-rfree[ 0 swap regs + c! ]

arg2[ 2 dig? 1 dig? and ]
arg1[ 2 dig? 0= 1 dig? and ]
arg0[ 2 dig? 0= 1 dig? 0= and ]
rf=c[ c, arg2 if rfree rgf c, i 2- c@ sm c, then ]
rfOc[ c, arg2 if rgf c, i 1- c@ sm c, then ]
oper2[ case
'&' of op++ 0x8B rf=c 0x23 rfOc endof
'^' of op++ 0x8B rf=c 0x33 rfOc endof
'|' of op++ 0x8B rf=c 0x0B rfOc endof
'+' of op++ 0x8B rf=c 0x03 rfOc endof
'-' of op++ 0x8B rf=c 0x2B rfOc endof
'*' of op++ 0x8B rf=c 0x0F c, 0xAF rfOc endof
(
'=' of sm r^c r-1 r-r       endof
'#' of sm r^c -r  r-r       endof
'>' of sm r=c? r=LE r&1 r-- endof
'<' of sm r=c? r=GE r&1 r-- endof
'/' of sm C=c cdq idivC     endof
'%' of sm C=c cdq idivC r=D endof
'M' of sm D=c D=r? >r=D     endof
'm' of sm D=c D=r? <r=D     endof
'l' of sm C=c Cr<<          endof
'r' of sm C=c Cr>>          endof
)
endcase ]
oper1[ 'n' of ]
a 2+ u 3 - ado i c@ oper2 loop ret, nopers .
;
: ss |211*22*+| ; see ss

\ : sntf { a b } a negate b negate a abs b abs a invert b invert ; see sntf
