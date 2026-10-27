: SYNONYM see SEE ;

\ cтроковые литералы в форме "....."
\ rec: a 1+ '"' PARSE u + 3\13 '"' 0 spos?
\ gen: state @ if slit, then ;

\ exs
\ "a b  c   d " TYPE CR
\ : s1 "  12 345 67  " ; s1 TYPE



: syndop ;
