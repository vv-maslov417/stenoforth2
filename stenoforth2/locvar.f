\ cycle compilation
rec:
1 '|' pos-char? u '|' pos-char? and
gen:
2 pos>char '0' - nmax\
[ 6 ] regs] regs 6 erase
[ 9 ] celr] celr 9 erase
sm[ '0' - nmax swap - 1- cells ]                                  \ 'n' --  offset
frer[ 0 regs 1+ 5 ado i c@ 0= if drop i regs - leave then loop ]  \ -- free_reg
celr?[ celr + c@ ]                                                \ cell -- 0|reg
rfre[ 0 swap regs + c! ]                                          \ reg  --
0 ch\
\ r
oper2[
hex
case
'&' of 23 c,   frer c, sm c, endof
'^' of 33 c,   frer c, sm c, endof
'|' of 0B c,   frer c, sm c, endof
'+' of 03 c,   frer c, sm c, endof
'-' of 2B c,   frer c, sm c, endof
'*' of AF0F w, frer c, sm c, endof
\ '=' of sm r^c r-1 r-r       endof
\ '#' of sm r^c -r  r-r       endof
\ '>' of sm r=c? r=LE r&1 r-- endof
\ '<' of sm r=c? r=GE r&1 r-- endof
\ '/' of sm C=c cdq idivC     endof
\ '%' of sm C=c cdq idivC r=D endof
\ 'M' of sm D=c D=r? >r=D     endof
\ 'm' of sm D=c D=r? <r=D     endof
\ 'l' of sm C=c Cr<<          endof
\ 'r' of sm C=c Cr>>          endof
endcase
decimal
]





( cycl-comp) a 2+ u 3 - ado i c@ sm loop frer .s
;

|412+34*32-1+|

: s1 A*@P B*@P C*@P D+@P S+@P ; see s1

: s2 B*@P ; see s2

\ : str s" 123" ; see str

вот на один байт пораньше
s" 123" swap 1- swap dump

46D96A6   20 31 32 33  00 20 73 77  61 70 20 31  2D 20 73 77  123. swap 1- sw
результат тот же - вместо байта счетчика - пробел

\eof
& 23 ^ 33 | 0B + 03 - 2B * AF0F
A 1 45 B 2 5D C 3 4D D 4 55 5 S 75

oper '*' <> if oper c, else oper w, then reg c, sm c,
