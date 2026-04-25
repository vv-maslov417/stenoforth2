\ stenoforth32

100 STACK st-dop
\ переложить со стека параметров на стек
: >" ( x -- | cs: -- x) st-dop cell over +! @ ! ;
\ скопировать со стека на стек параметров
: "@ ( cs: x -- x | -- x) st-dop @ @ ;
\ убрать верхний со стека
: "drop ( cs: x --) st-dop dup dup @ = invert if cell negate swap +! then ;
\ переложить со стека на стек параметров
: "> ( cs: x -- | -- x) "@ "drop ;
\ очистить стек
: "0 ( cs: n*x --) st-dop dup ! ;
\ дать глубину стека
: "depth ( cs: n*x -- n*x | -- n) st-dop dup @ swap - cell / ;
\ проверить на пустоту fl=-1 - стек пуст
: ?" ( -- fl) "depth 0= ;


