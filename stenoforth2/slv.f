\ |211*22*+|




\eof
m: eax1  [ 0 ] ;
m: ebx1  [ 3 ] ;
m: ecx1  [ 1 ] ;
m: edx1  [ 2 ] ;
m: esi1  [ 6 ] ;

m: oneg  [ 1 ] ;
m: oinv  [ 0 ] ;

m: eax2  [ 0x45 ] ;
m: ebx2  [ 0x5D ] ;
m: ecx2  [ 0x4D ] ;
m: edx2  [ 0x55 ] ;
m: esi2  [ 0x75 ] ;

m: 0c [   0 ] ; m: 1c [   4 ] ;
m: 2c [   8 ] ; m: 3c [  12 ] ;
m: 4c [  16 ] ; m: 5c [  20 ] ;
m: 6c [  24 ] ; m: 7c [  28 ] ;
m: c1 [  -4 ] ;
m: c2 [  -8 ] ; m: c3 [ -12 ] ;
m: c4 [ -16 ] ; m: c5 [ -20 ] ;
m: c6 [ -24 ] ; m: c7 [ -28 ] ;

m: oadd  [ 3 ] ;
m: osub  [ 0x2B ] ;
m: oimul [ 0x0FAF ] ;
\ m: or=c
\ m: or=t
\ m: oidiv

: ss / ; see ss

I: ro { r o } 0xF7 C, o 3 lshift r or 0xD0 or C, ;

: s1  esi1 oinv ro
      ebx1 oneg ro
; see s1

I: rco dup 0xFAF =
   if drop 0xAF0F w, else c, then
   { r c } r c, c c,
;

: s2
ecx2 0c oimul rco
esi2 3c osub  rco
edx2 c5 oadd  rco
; see s2


: s3
A=B A=C A=D A=S
B=A C=A D=A S=A

; see s3
