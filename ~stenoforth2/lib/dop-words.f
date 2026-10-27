: scan \ c-addr u char -- c-addr' u'
    4h B=@P C=@P
L2: bA=@bB? L1 J=
    B++ C-- L3 J= L2 JMP
L3: C++
L1: B++ C-- A=C 4h Pa @P=B
;

user trc~
0 trc~ !

: skip-next ( -- )
  begin source >in @ /string s" ~~~" search
  if drop source drop - >in ! exit then
  2drop refill 0= until ;

: ~~~ ( -- )
  trc~ @ if 0 trc~ ! skip-next else 1 trc~ ! then ; immediate


\eof
~~~
: ok-test ." OK" cr ;
~~~

…_„‹†_‚›‹ˆ’œ‘Ÿ
87t6sf  hjf6f7

~~~
ok-test
~~~
