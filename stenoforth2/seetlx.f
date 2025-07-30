\ stenoforth32
: SEET ' xt\ 0. tics!d 0 ns\ 0. mcs\ ms\ 0. t1!d 0. t2!d
DAC=TSCP DUP A=D -> t1 A=C DUP -> ns
DAC=TSCP DUP A=D -> t2 A=C DUP -> ms
xt WordByAddr CR TYPE CR
DAC=TSCP DUP A=D 2DUP -> t1 A=C DUP -> ns
xt :A
DAC=TSCP DUP A=D -> t2 A=C DUP -> ms
t2 t1 D- -> tics
." p1=" ns . ." p2=" ms . CR
tics 10. D* 36. D/ DROP -> ns
ns      1000 / -> mcs
mcs     1000 / -> ms
." dT1 = "
tics            D. ." tics "
ms               . ." ms "
mcs ms  1000 * - . ." us "
ns mcs  1000 * - . ." ns " CR
xt :A xt :A xt :A xt :A
DAC=TSCP DUP A=D -> t1 A=C DUP -> ns
xt :A
DAC=TSCP DUP A=D -> t2 A=C DUP -> ms
t2 t1 D- -> tics
." p1=" ns . ." p2=" ms . CR
tics 10. D* 36. D/ DROP -> ns
ns      1000 / -> mcs
mcs     1000 / -> ms
." dTc = "
tics            D. ." tics "
ms               . ." ms "
mcs ms  1000 * - . ." us "
ns mcs  1000 * - . ." ns " CR
S0 @ SP!
;

: sseet ;
