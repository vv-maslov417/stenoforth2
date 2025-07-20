\ максимальный байт в массиве
\ c-addr u -- n
: MaxByte  \12 [1b1i2jGIbML ;

\ минимальный байт в массиве
\ c-addr u -- n
: MinByte  \12 [1b1i2jGIbmL ;

\ сумма байтов массива
\ c-addr u -- n
: SumBytes  \12 [1b !3 [1i2jGIb3+:3L3 ;

\ сумма квадратов - разный синтаксис
\ n1 n2 -- n1*n1 + n2*n2

\ fix point
: sum-sq   DUP * SWAP DUP * + ;
: sum-sq0  | x\ y\ | x x * y y * + ;
: sum-sq1  \xy  x x * y y * + ;
: sum-sq2  \12 [11*22+ ;

\ float point
: sum-sq3  FDUP F* FSWAP FDUP F* F+ ;
: sum-sq4  f| dup  * swap dup * + |f ;
: sum-sq5  | x$ y$ | f| x x * y y * + |f ;
: sum-sq6  $xy f| x x * y y * + |f ;
: sum-sq7  $12  {11*22+ ;

\ Площадь треугольника по Герону
\ a b c -- S3

\ fix point
: S3   | x\ y\ z\ | x y z + + 2/ p!
       p x - p y - * p z - * p * sqrt ;
: S31  \xyz x y z + + 2/ p\
       p x - p y - * p z - * p * sqrt ;
: S32  \123 [123++ 2/ \4 [41-42-*43-*4*q ;

\ float point
: S33  | x$ y$ z$ | f| x y z + + 2/ p$
       p x - p y - * p z - * p * sqrt |f ;
: S34  $xyz f| x y z + + 2/ p$
       p x - p y - * p z - * p * sqrt |f ;
: S35  $123 {123++ 2e {/ $4 {41-42-*43-*4*q ;

\ стековые перестановки
\ обычным образом
: f1 DUP DUP >R 2SWAP R>      ; 1 2 3 f1 .s

\ прямой генерацией
: f2 3\33123 ;                  1 2 3 f2 .s

\ Инверсия строки
\ sd1 -- sd2
\           s1s2
\ в стат. памяти, не трогая исходную строку
: s-inv 0. \1234 [h:32_112+jDIb34+w4i:4YnN34 ;

S" 1234567" s-inv TYPE CR
\ в дин. памяти, не трогая исходную строку
: s-invh 0. \1234 [2 "A [:3112+jDIb34+w4i:4YnN34 ;

S" 12345678" s-invh TYPE CR

\ заменить исходную строку инвертированной
: s-invv [d 2/ 0 \1234 [13+:43iyD4I-b4I+b4I-w4I+wL12 ;

S" 123456789" s-invv TYPE

\ Решение квадратного уравнения ax**2+bx+c=0
\ D=b**2-4ac  [ D>0  x1=(-b+sqrtD)/2a x2=(-b-sqrtD)/2a ]
\             [ D=0  x1=-b/2a ] [ D<0  нет корней ]

\       abc                D
: x12  $123 {2p 4e {13**- $4
  k1[ {2n4q ] k2[ 2e {1*/. ] \ макросы
  {4z? ." x1=" k1 {+ k2
       ." x2=" k1 {- k2
    {e4Z? ." x1=" {2n k2
       {e ." no corners"
       {t
    {t ;

 CR 2e 6e -3e x12
