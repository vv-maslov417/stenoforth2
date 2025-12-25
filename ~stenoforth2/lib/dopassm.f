\ stenoforth32

\ Simplify the recording of immediate values
\ $ 4 --> 4h $ 20 --> 32d  $ A  --> 1010b
rec: nmb?[ a u 1- number? ]
     smb?[ a u + 1- c@ = ]
     snmb?[ smb? nmb? nip nip and ]
     'h' snmb? 'd' snmb? or 'b' snmb? or
gen: 'b' smb? if 0x2 BASE ! nmb? then
     'd' smb? if nmb? then
     'h' smb? if hex nmb? then
     2drop >CS decimal ;

\ saving registers in memory
m: A>a [ a) a >CS ] @=A ; m: B>b [ b) b >CS ] @=B ;
m: C>c [ c) c >CS ] @=C ; m: D>d [ d) d >CS ] @=D ;
m: S>s [ e) e >CS ] @=S ; m: T>t [ f) f >CS ] @=S ;

\ restoring registers from memory
m: a>A [ a >CS ] A=@ ; m: a>B [ a >CS ] B=@ ; m: a>C [ a >CS ] C=@ ;
m: a>D [ a >CS ] D=@ ; m: a>S [ a >CS ] S=@ ; m: a>T [ a >CS ] T=@ ;
m: b>A [ b >CS ] A=@ ; m: b>B [ b >CS ] B=@ ; m: b>C [ b >CS ] C=@ ;
m: b>D [ b >CS ] D=@ ; m: b>S [ b >CS ] S=@ ; m: b>T [ b >CS ] T=@ ;
m: c>A [ c >CS ] A=@ ; m: c>B [ c >CS ] B=@ ; m: c>C [ c >CS ] C=@ ;
m: c>D [ c >CS ] D=@ ; m: c>S [ c >CS ] S=@ ; m: c>T [ c >CS ] T=@ ;
m: d>A [ d >CS ] A=@ ; m: d>B [ d >CS ] B=@ ; m: d>C [ d >CS ] C=@ ;
m: d>D [ d >CS ] D=@ ; m: d>S [ d >CS ] S=@ ; m: d>T [ d >CS ] T=@ ;
m: s>A [ s >CS ] A=@ ; m: s>B [ s >CS ] B=@ ; m: s>C [ s >CS ] C=@ ;
m: s>D [ s >CS ] D=@ ; m: s>S [ s >CS ] S=@ ; m: s>T [ s >CS ] T=@ ;
m: t>A [ t >CS ] A=@ ; m: t>B [ t >CS ] B=@ ; m: t>C [ t >CS ] C=@ ;
m: t>D [ t >CS ] D=@ ; m: t>S [ t >CS ] S=@ ; m: t>T [ t >CS ] T=@ ;
