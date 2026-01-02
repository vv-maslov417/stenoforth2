\ stenoforth32

rec: a u + 1- c@ smb\  0 nmb\
     dc[ smb = if a u 1- number? 3\31 -> nmb else 0 then ]
     smb 'd' = smb 'b' = or smb 'h' = or
     decimal    'd' dc
     0x2 base ! 'b' dc or
     hex        'h' dc or and u 1 > and decimal
gen: nmb >CS ;

\ saving registers in memory
m: A>a [ a) a >CS ] @=A ; m: B>b [ b) b >CS ] @=B ;
m: C>c [ c) c >CS ] @=C ; m: D>d [ d) d >CS ] @=D ;
m: S>s [ s) s >CS ] @=S ; m: T>t [ t) t >CS ] @=T ;
m: A>a1 [ a1) a1 >CS ] @=A ; m: B>b1 [ b1) b1 >CS ] @=B ;
m: C>c1 [ c1) c1 >CS ] @=C ; m: D>d1 [ d1) d1 >CS ] @=D ;
m: S>s1 [ s1) s1 >CS ] @=S ; m: T>t1 [ t1) t1 >CS ] @=T ;

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
m: a1>A [ a1 >CS ] A=@ ; m: b1>B [ b1 >CS ] B=@ ; m: c1>C [ c1 >CS ] C=@ ;
m: d1>D [ d1 >CS ] D=@ ; m: s1>S [ s1 >CS ] S=@ ; m: t1>T [ t1 >CS ] T=@ ;
