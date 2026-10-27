s0 @ constant dns

m: tail B=aP [ 0x8F8D w, 0x1F5C , ] @C=B ;

: nnip 0 do ` nip loop ; : ndrop 0 do ` drop loop ;

user-value isv 0 TO isv       \ inp loc vars
user-value osv 0 TO isv       \ out loc vars

m: numin: [ isv 1- 4 * >CS ] B=aP [ 0x8F8D w, 0x1F5C , ] @C=B ;
m: numsv> ` s0 ` @ nsv 4 * lit, ` - ` @ ;
m: >numsv ` s0 ` @ nsv 4 * lit, ` - ` ! ;

rec: ':' u 1- spos? a u 1- number? nip swap TO isv and u 1 > and u 4 < and
gen: ` numin: ;

rec: a u 1- number? nip swap nsv\ '>' u 1- spos? and u 1 > and u 4 < and
gen: numsv> ;

rec: '>' 0 spos? a 1+ u 1- number? nip swap TO osv and u 1 > and u 4 < and
gen: [ isv osv = ]
     [IF] ` dup ` s0 ` @ osv 4 * lit, ` - ` ! ` drop
     [ELSE]     ` s0 ` @ osv 4 * lit, ` - ` ! [THEN] ;

user-create arloc 1000 user-allot user-value hloc 0 TO hloc arloc 1000 erase
user-value ninp 0 TO ninp user-value nout 0 TO nout user-value stvar 0 TO stvar

\ подсчет вх.локов и вых.пар-ров, запись их имен с нумерацией
\ {. in1 .. ini -- out1 .. outj .}    \ i j + <= 99
i: {. 1 TO stvar 0. asv\ usv\ 0 TO ninp  0 TO nout 0 TO hloc
 hl+[ hloc  + TO hloc ]
ni++[ ninp 1+ TO ninp ]
no++[ nout 1+ TO nout ]
 hlw[ arloc hloc + c! 1 hl+ ]
begin
  NextWord -> usv -> asv asv usv "--" compare
  if  ni++ asv arloc hloc + usv move usv hl+ 0 hlw
  ninp 0 (D.) ui\ ai\ ui 1 = if '0' hlw ai c@ hlw else ai arloc hloc + 2 move 2 hl+ then
  '>' hlw 0 hlw 0 else 1 then
until
begin
  NextWord -> usv -> asv asv usv ".}" compare
  if  no++ asv arloc hloc + usv move usv hl+ 0 hlw
  nout 0 (D.) uo\ ao\ uo 1 = if '0' hlw ao c@ hlw else ao arloc hloc + 2 move 2 hl+ then
  '>' hlw 0 hlw 0 else 1 then
until ninp 0 (D.) 2dup + ';' swap ! 1+ evaluate ;

user-value iosv 0 TO iosv    \ чтение 0 запись 1
i: => 1 TO iosv ;

\ поиск и компиляция кода имен стековых локальных переменных
rec: arloc hloc a u search nip swap adrl\
     adrl u + c@ 0= and
     adrl u + 1+ 2 number? nip swap nsv\ and
     adrl u + 3 + c@ '>' = and
gen: iosv if   >numsv 0 TO iosv
          else numsv> then ;

i: ; stvar dup if 0 TO stvar then
   if nout
      if
        nout 1- 0
        ?do 0x8B c, 0x55 c, nout 2- i - 4 * c,
            0x89 c, 0x55 c, ninp nout + 1- i 1+ - 4 * c, loop
            0x8D c, 0x6D c, ninp 4 * c,
            arloc hloc erase 0 TO hloc dns s0 !
      else  arloc hloc erase 0 TO hloc dns s0 ! ninp 0 do ` drop loop
      then
   then ` ; ;
