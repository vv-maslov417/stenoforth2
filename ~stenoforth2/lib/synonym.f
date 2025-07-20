: ENROLL-NAME \ ( xt d-newname -- ) \ basic factor
  \ see also: ~pinka/spf/compiler/native-wordlist.f
  SHEADER LAST-CFA @ ! ;
: ENROLL-SYNONYM \ ( d-oldname d-newname -- ) \ postfix version of SYNONYM
  2>R SFIND DUP 0= IF -321 THROW THEN \ ( xt -1|1 )
  SWAP 2R> ENROLL-NAME 1 = IF IMMEDIATE THEN
;
: SYNONYM \ ( "<spaces>newname" "<spaces>oldname" -- ) \ 2012 TOOLS EXT
  PARSE-NAME PARSE-NAME 2SWAP ENROLL-SYNONYM ;
