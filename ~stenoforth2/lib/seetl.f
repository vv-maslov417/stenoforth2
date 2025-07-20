\ stenoforth32
: SEET ' xt\ 0. tics!d 0. ns!d 0. mcs\ ms\ 0. t1!d 0. t2!d  0. pr1\ pr2\
DAC=TSCP DUP A=D -> t1 A=C DUP -> pr1
DAC=TSCP DUP A=D -> t2 A=C DUP -> pr2
xt WordByAddr CR TYPE CR
DAC=TSCP DUP A=D 2DUP -> t1 A=C DUP -> pr1
xt :A
DAC=TSCP DUP A=D -> t2 A=C DUP -> pr2
t2 t1 D- -> tics
." p1=" pr1 . ." p2=" pr2 . CR
tics 10. D* 36. D/ -> ns
ns      1000. D/ DROP -> mcs
mcs     1000 / -> ms
." dT1 = "
tics            D. ." tics "
ms               . ." ms "
mcs ms  1000 * - . ." us "
ns DROP mcs  1000 * - . ." ns " CR
xt :A xt :A xt :A xt :A
DAC=TSCP DUP A=D -> t1 A=C DUP -> pr1
xt :A
DAC=TSCP DUP A=D -> t2 A=C DUP -> pr2
t2 t1 D- -> tics
." p1=" pr1 . ." p2=" pr2 . CR
tics 10. D* 36. D/  -> ns
ns      1000. D/ DROP -> mcs
mcs     1000 / -> ms
." dTc = "
tics            D. ." tics "
ms               . ." ms "
mcs ms  1000 * - . ." us "
ns DROP mcs  1000 * - . ." ns " CR
S0 @ SP!
;

: sseet ;
