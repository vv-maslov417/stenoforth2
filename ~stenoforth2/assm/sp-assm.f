\ stenoforth32

\ Сокращенная форма записи мнемоник команд x86 - по мере необходимости пополняется из файла MP-Assm

I: ` [COMPILE] POSTPONE ;

USER-VALUE A-MNEM   USER-VALUE L-MNEM
USER-VALUE FLAG-RG  USER-VALUE CTRG

M: IDN
0 TO CTRG 2SWAP 2DUP 2>R 2SWAP LIKE FALSE =
IF 2R> NOTFOUND EXIT THEN 2R> TO L-MNEM TO A-MNEM
;

: A-M@ A-MNEM + C@ ;
: CTRG++ CTRG 1+ TO CTRG ;
: CS-DROPS
  CTRG 1-
  CASE
  1 OF CS-DROP ENDOF
  2 OF CS-DROP CS-DROP ENDOF
  3 OF CS-DROP CS-DROP CS-DROP ENDOF
  ENDCASE
;
: SRG  \ регистры общего назначения
  CTRG++
  0 TO FLAG-RG
  CASE
  'A' OF ` EA  ENDOF 'B' OF ` EB  ENDOF 'C' OF ` EC  ENDOF 'D' OF ` ED  ENDOF
  'X' OF ` EX  ENDOF 'P' OF ` EP  ENDOF 'S' OF ` ES  ENDOF 'T' OF ` ET  ENDOF
  1 TO FLAG-RG CS-DROPS
  ENDCASE
;
M: RG!
   A-M@ SRG FLAG-RG
   IF A-MNEM L-MNEM NOTFOUND EXIT THEN ;M

: SSRG  \ системные регистры
  CTRG++
  0 TO FLAG-RG
  CASE
  '0' OF ` CR0 ENDOF '2' OF ` CR2 ENDOF '3' OF ` CR3 ENDOF '4' OF ` CR4 ENDOF
  1 TO FLAG-RG CS-DROPS
  ENDCASE
;
M: SR!
   A-M@ SSRG FLAG-RG
   IF A-MNEM L-MNEM NOTFOUND EXIT THEN ;M

: SDRG  \ отладочные регистры
  CTRG++
  0 TO FLAG-RG
  CASE
  '0' OF ` DR0 ENDOF '1' OF ` DR1 ENDOF '2' OF ` DR2 ENDOF '3' OF ` DR3 ENDOF '6' OF ` DR6 ENDOF '7' OF ` DR7 ENDOF
  1 TO FLAG-RG CS-DROPS
  ENDCASE
;
M: DR!
   A-M@ SDRG FLAG-RG
   IF A-MNEM L-MNEM NOTFOUND EXIT THEN ;M

: SMRG  \ MMX регистры
  CTRG++
  0 TO FLAG-RG
  CASE
  '0' OF ` M0 ENDOF '1' OF ` M1 ENDOF '2' OF ` M2 ENDOF '3' OF ` M3 ENDOF
  '4' OF ` M4 ENDOF '5' OF ` M5 ENDOF '6' OF ` M6 ENDOF '7' OF ` M7 ENDOF
  1 TO FLAG-RG CS-DROPS
  ENDCASE
;
M: MR!
   A-M@ SMRG FLAG-RG
   IF A-MNEM L-MNEM NOTFOUND EXIT THEN ;M

: SXRG  \ XMM регистры
  CTRG++
  0 TO FLAG-RG
  CASE
  '0' OF ` X0 ENDOF '1' OF ` X1 ENDOF '2' OF ` X2 ENDOF '3' OF ` X3 ENDOF
  '4' OF ` X4 ENDOF '5' OF ` X5 ENDOF '6' OF ` X6 ENDOF '7' OF ` X7 ENDOF
  1 TO FLAG-RG CS-DROPS
  ENDCASE
;
M: XR!
   A-M@ SXRG FLAG-RG
   IF A-MNEM L-MNEM NOTFOUND EXIT THEN ;M

\ : !1  OP0 @ 4 - @ >CS POSTPONE DROP ;


\ идентификация и кодогенерация команд x86 по их мнемоникам в сокращенной форме
\ смещение      0123456          S-R1  S-R2  S-R3

\ ПЕРЕСЫЛКИ
: NOTFOUND   S" ?=?"         IDN 0 RG! 2 RG!       ` R=R        ;   \ MOV R,R
: NOTFOUND   S" w?=w?"       IDN 1 RG! 4 RG!       ` wR=wR      ;
: NOTFOUND   S" w?=b?"       IDN 1 RG! 4 RG!       ` wR=bR      ;
: NOTFOUND   S" b?=b?"       IDN 1 RG! 4 RG!       ` bR=bR      ;
: NOTFOUND   S" ?=w?"        IDN 0 RG! 3 RG!       ` R=wR       ;
: NOTFOUND   S" ?=b?"        IDN 0 RG! 3 RG!       ` R=bR       ;
: NOTFOUND   S" ?=@"         IDN 0 RG!             ` R=@        ;   \ MOV R,ADDR
: NOTFOUND   S" w?=@"        IDN 1 RG!             ` wR=@       ;
: NOTFOUND   S" b?=@"        IDN 1 RG!             ` bR=@       ;
: NOTFOUND   S" @=?"         IDN 2 RG!             ` @=R        ;   \ MOV ADDR,R
: NOTFOUND   S" @=w?"        IDN 3 RG!             ` @=wR       ;
: NOTFOUND   S" @=b?"        IDN 3 RG!             ` @=bR       ;
: NOTFOUND   S" ?=@?"        IDN 0 RG! 3 RG!       ` R=@R       ;   \ MOV R,[R]
: NOTFOUND   S" ?=@w?"       IDN 0 RG! 4 RG!       ` R=@wR      ;
: NOTFOUND   S" ?=@b?"       IDN 0 RG! 4 RG!       ` R=@bR      ;
: NOTFOUND   S" w?=@w?"      IDN 1 RG! 5 RG!       ` wR=@wR     ;
: NOTFOUND   S" w?=@b?"      IDN 1 RG! 5 RG!       ` wR=@bR     ;
: NOTFOUND   S" b?=@b?"      IDN 1 RG! 5 RG!       ` bR=@bR     ;
: NOTFOUND   S" @?=?"        IDN 1 RG! 3 RG!       ` @R=R       ;   \ MOV [R],R
: NOTFOUND   S" @b?=b?"      IDN 2 RG! 5 RG!       ` @bR=bR     ;
: NOTFOUND   S" @w?=w?"      IDN 2 RG! 5 RG!       ` @wR=wR     ;
: NOTFOUND   S" ?=@??"       IDN 0 RG! 3 RG! 4 RG! ` R=@RR      ;   \ MOV R,[R][R]
: NOTFOUND   S" ?=@w??"      IDN 0 RG! 4 RG! 5 RG! ` R=@wRR     ;
: NOTFOUND   S" ?=@b??"      IDN 0 RG! 4 RG! 5 RG! ` R=@bRR     ;
: NOTFOUND   S" w?=@w??"     IDN 1 RG! 5 RG! 6 RG! ` wR=@wRR    ;
: NOTFOUND   S" w?=@b??"     IDN 1 RG! 5 RG! 6 RG! ` wR=@bRR    ;
: NOTFOUND   S" b?=@b??"     IDN 1 RG! 5 RG! 6 RG! ` bR=@bRR    ;
: NOTFOUND   S" @??=?"       IDN 1 RG! 2 RG! 4 RG! ` @RR=R      ;   \ MOV [R][R],R
: NOTFOUND   S" @b??=b?"     IDN 2 RG! 3 RG! 6 RG! ` @bRR=bR    ;
: NOTFOUND   S" @w??=w?"     IDN 2 RG! 3 RG! 6 RG! ` @wRR=wR    ;
: NOTFOUND   S" ?=#"         IDN 0 RG!             ` Rg=#       ;   \ MOV R,#
: NOTFOUND   S" w?=w#"       IDN 1 RG!             ` wRg=w#     ;
: NOTFOUND   S" b?=b#"       IDN 1 RG!             ` bRg=b#     ;
: NOTFOUND   S" @?=#"        IDN 1 RG!             ` @R=#       ;   \ MOV [R],#
: NOTFOUND   S" @w?=w#"      IDN 2 RG!             ` @wR=w#     ;
: NOTFOUND   S" @b?=b#"      IDN 2 RG!             ` @bR=b#     ;
: NOTFOUND   S" @??=#"       IDN 1 RG! 2 RG!       ` @RR=#      ;
: NOTFOUND   S" @w??=w#"     IDN 2 RG! 3 RG!       ` @wRR=w#    ;
: NOTFOUND   S" @b??=b#"     IDN 2 RG! 3 RG!       ` @bRR=b#    ;
: NOTFOUND   S" sw?=sb?"     IDN 2 RG! 6 RG!       ` swR=sbR    ;
: NOTFOUND   S" s?=sb?"      IDN 1 RG! 5 RG!       ` sR=sbR     ;
: NOTFOUND   S" s?=sw?"      IDN 1 RG! 5 RG!       ` sR=swR     ;
: NOTFOUND   S" s?=@sw?"     IDN 1 RG! 6 RG!       ` sR=@swR    ;
: NOTFOUND   S" s?=@sb?"     IDN 1 RG! 6 RG!       ` sR=@sbR    ;
: NOTFOUND   S" sw?=@sb?"    IDN 2 RG! 7 RG!       ` swR=@sbR   ;
: NOTFOUND   S" s?=@sw??"    IDN 1 RG! 6 RG! 7 RG! ` sR=@swRR   ;
: NOTFOUND   S" s?=@sb??"    IDN 1 RG! 6 RG! 7 RG! ` sR=@sbRR   ;
: NOTFOUND   S" sw?=@sb??"   IDN 2 RG! 7 RG! 8 RG! ` swR=@sbRR  ;
: NOTFOUND   S" ?~?"         IDN 0 RG! 2 RG!       ` R~R        ;   \ XCHG R,R
: NOTFOUND   S" w?~w?"       IDN 1 RG! 4 RG!       ` wR~wR      ;
: NOTFOUND   S" b?~b?"       IDN 1 RG! 4 RG!       ` bR~bR      ;
: NOTFOUND   S" ?~@?"        IDN 0 RG! 3 RG!       ` R~@R       ;   \ XCHG R,[R]
: NOTFOUND   S" w?~@w?"      IDN 1 RG! 5 RG!       ` wR~@wR     ;
: NOTFOUND   S" b?~@b?"      IDN 1 RG! 5 RG!       ` bR~@bR     ;
: NOTFOUND   S" ?~@??"       IDN 0 RG! 3 RG! 4 RG! ` R~@RR      ;   \ XCHG R,[R][R]
: NOTFOUND   S" w?~@w??"     IDN 1 RG! 5 RG! 6 RG! ` wR~@wRR    ;
: NOTFOUND   S" b?~@b??"     IDN 1 RG! 5 RG! 6 RG! ` bR~@bRR    ;
: NOTFOUND   S" @?~?"        IDN 1 RG! 3 RG!       ` @R~R       ;   \ XCHG [R],R
: NOTFOUND   S" @w?~w?"      IDN 2 RG! 5 RG!       ` @wR~wR     ;
: NOTFOUND   S" @b?~b?"      IDN 2 RG! 5 RG!       ` @bR~bR     ;
: NOTFOUND   S" @??~?"       IDN 1 RG! 2 RG! 4 RG! ` @RR~R      ;   \ XCHG [R][R],R
: NOTFOUND   S" @w??~w?"     IDN 2 RG! 3 RG! 6 RG! ` @wRR~wR    ;
: NOTFOUND   S" @b??~b?"     IDN 2 RG! 3 RG! 6 RG! ` @bRR~bR    ;
: NOTFOUND   S" CR?=?"       IDN 2 SR! 4 RG!       ` CR=R       ;   \ MOV CR,R
: NOTFOUND   S" ?=CR?"       IDN 0 RG! 4 SR!       ` R=CR       ;   \ MOV R,CR
: NOTFOUND   S" ?=DR?"       IDN 0 RG! 4 DR!       ` R=DR       ;   \ MOV R,DR
: NOTFOUND   S" DR?=?"       IDN 2 DR! 4 RG!       ` DR=R       ;   \ MOV DR,R
: NOTFOUND   S" RS=?"        IDN 3 RG!             ` RS=R       ;   \ PUSH R
: NOTFOUND   S" RS=@?"       IDN 4 RG!             ` RS=@R      ;   \ PUSH [R]
: NOTFOUND   S" RS=@??"      IDN 4 RG! 5 RG!       ` RS=@RR     ;   \ PUSH [R],[R]
: NOTFOUND   S" RS=w?"       IDN 4 RG!             ` RS=wR      ;   \ PUSH wR
: NOTFOUND   S" RS=@w?"      IDN 5 RG!             ` RS=@wR     ;   \ PUSH [wR]
: NOTFOUND   S" RS=@w??"     IDN 5 RG! 6 RG!       ` RS=@wRR    ;   \ PUSH [R],[R]
: NOTFOUND   S" ?=RS"        IDN 0 RG!             ` R=RS       ;   \ POP R
: NOTFOUND   S" @?=RS"       IDN 1 RG!             ` @R=RS      ;   \ POP [R]
: NOTFOUND   S" @??=RS"      IDN 1 RG! 2 RG!       ` @RR=RS     ;   \ POP [R],[R]
: NOTFOUND   S" w?=RS"       IDN 1 RG!             ` wR=RS      ;   \ POP wR
: NOTFOUND   S" @w?=RS"      IDN 2 RG!             ` @wR=RS     ;   \ POP [wR]
: NOTFOUND   S" @w??=RS"     IDN 2 RG! 3 RG!       ` @wRR=RS    ;   \ POP [R],[R]
: NOTFOUND   S" ?=a?"        IDN 0 RG! 3 RG!       ` R=aR       ;   \ LEA R, [R]
: NOTFOUND   S" ?=a??"       IDN 0 RG! 3 RG! 4 RG! ` R=aRR      ;   \ LEA R, [R][R]
: NOTFOUND   S" ?a"          IDN 0 RG!             ` Ra         ;
: NOTFOUND   S" M?=?"        IDN 1 MR! 3 RG!       ` MR=R       ;   \ MOVD MMR, R
: NOTFOUND   S" M?=@?"       IDN 1 MR! 4 RG!       ` MR=@R      ;   \ MOVD MMR, [R]
: NOTFOUND   S" ?=M?"        IDN 0 RG! 3 MR!       ` R=MR       ;   \ MOVD R, MMR
: NOTFOUND   S" @?=M?"       IDN 1 RG! 4 MR!       ` @R=MR      ;   \ MOVD [R], MMR
: NOTFOUND   S" M?=@"        IDN 1 MR!             ` MR=@       ;   \ MOVQ MMR, ADR
: NOTFOUND   S" @=M?"        IDN 3 MR!             ` @=MR       ;   \ MOVQ ADR, MMR

: NOTFOUND   S" X?=?"        IDN 1 XR! 3 RG!       ` XR=R       ;   \ MOVD XMR, R
: NOTFOUND   S" X?=@?"       IDN 1 XR! 4 RG!       ` XR=@R      ;   \ MOVD XMR, [R]
: NOTFOUND   S" ?=X?"        IDN 0 RG! 3 XR!       ` R=XR       ;   \ MOVD R, XMR
: NOTFOUND   S" X?=M?"       IDN 1 XR! 4 MR!       ` XR=MR      ;   \ MOVDQ2Q XMR, MMR
: NOTFOUND   S" M?=X?"       IDN 1 MR! 4 XR!       ` MR=XR      ;   \ MOVDQ2Q MMR, XMR
: NOTFOUND   S" @?=X?"       IDN 1 RG! 4 XR!       ` @R=XR      ;   \ MOVD [R], XMR
: NOTFOUND   S" X?=X?"       IDN 1 XR! 4 XR!       ` XR=XR      ;   \ MOVUPS  XMR, XMR
: NOTFOUND   S" X?=@"        IDN 1 XR!             ` XR=@       ;   \ MOVUPS  XMR, ADR
: NOTFOUND   S" @=X?"        IDN 3 XR!             ` @=XR       ;   \ MOVUPS  ADR, XMR
: NOTFOUND   S" X?=|@"       IDN 1 XR!             ` XR=|@      ;   \ MOVAPS  XMR, |ADR
: NOTFOUND   S" |@=X?"       IDN 4 XR!             ` |@=XR      ;   \ MOVAPS  |ADR, XMR

\ АРИФМЕТИКА
: NOTFOUND   S" w?c-w?"      IDN 1 RG! 5 RG!       ` wRc-wR     ;
: NOTFOUND   S" w?c-w#"      IDN 1 RG!             ` wRc-w#     ;
: NOTFOUND   S" w?c-b#"      IDN 1 RG!             ` wRc-b#     ;
: NOTFOUND   S" w?c-@w??"    IDN 1 RG! 6 RG! 7 RG! ` wRc-@wRR   ;
: NOTFOUND   S" w?c-@w?"     IDN 1 RG! 6 RG!       ` wRc-@wR    ;
: NOTFOUND   S" w?c-@"       IDN 1 RG!             ` wRc-@      ;
: NOTFOUND   S" w?c+w?"      IDN 1 RG! 5 RG!       ` wRc+wR     ;
: NOTFOUND   S" w?c+w#"      IDN 1 RG!             ` wRc+w#     ;
: NOTFOUND   S" w?c+b#"      IDN 1 RG!             ` wRc+b#     ;
: NOTFOUND   S" w?c+@w??"    IDN 1 RG! 6 RG! 7 RG! ` wRc+@wRR   ;
: NOTFOUND   S" w?c+@w?"     IDN 1 RG! 6 RG!       ` wRc+@wR    ;
: NOTFOUND   S" w?c+@"       IDN 1 RG!             ` wRc+@      ;
: NOTFOUND   S" w?\*w?"      IDN 1 RG! 4 RG!       ` wR*wR      ;
: NOTFOUND   S" w?\*@w??"    IDN 1 RG! 5 RG! 6 RG! ` wR*@wRR    ;
: NOTFOUND   S" w?\*@w?"     IDN 1 RG! 5 RG!       ` wR*@wR     ;
: NOTFOUND   S" w?=w?\*w#"   IDN 1 RG! 4 RG!       ` wR=wR*w#   ;
: NOTFOUND   S" w?=w?\*b#"   IDN 1 RG! 4 RG!       ` wR=wR*b#   ;
: NOTFOUND   S" w?=@w?\*w#"  IDN 1 RG! 5 RG!       ` wR=@wR*w#  ;
: NOTFOUND   S" w?=@w?\*b#"  IDN 1 RG! 5 RG!       ` wR=@wR*b#  ;
: NOTFOUND   S" w?=@w??\*w#" IDN 1 RG! 5 RG! 6 RG! ` wR=@wRR*w# ;
: NOTFOUND   S" w?=@w??\*b#" IDN 1 RG! 5 RG! 6 RG! ` wR=@wRR*b# ;
: NOTFOUND   S" w?-w?"       IDN 1 RG! 4 RG!       ` wR-wR      ;
: NOTFOUND   S" w?-w#"       IDN 1 RG!             ` wR-w#      ;
: NOTFOUND   S" w?-b#"       IDN 1 RG!             ` wR-b#      ;
: NOTFOUND   S" w?-@w??"     IDN 1 RG! 5 RG! 6 RG! ` wR-@wRR    ;
: NOTFOUND   S" w?-@w?"      IDN 1 RG! 5 RG!       ` wR-@wR     ;
: NOTFOUND   S" w?-@"        IDN 1 RG!             ` wR-@       ;
: NOTFOUND   S" w?--"        IDN 1 RG!             ` wR--       ;
: NOTFOUND   S" w?+w?"       IDN 1 RG! 4 RG!       ` wR+wR      ;
: NOTFOUND   S" w?+w#"       IDN 1 RG!             ` wR+w#      ;
: NOTFOUND   S" w?+b#"       IDN 1 RG!             ` wR+b#      ;
: NOTFOUND   S" w?+@w??"     IDN 1 RG! 5 RG! 6 RG! ` wR+@wRR    ;
: NOTFOUND   S" w?+@w?"      IDN 1 RG! 5 RG!       ` wR+@wR     ;
: NOTFOUND   S" w?+@"        IDN 1 RG!             ` wR+@       ;
: NOTFOUND   S" w?++"        IDN 1 RG!             ` wR++       ;
: NOTFOUND   S" U\*w?"       IDN 3 RG!             ` U*wR       ;
: NOTFOUND   S" U\*b?"       IDN 3 RG!             ` U*bR       ;
: NOTFOUND   S" U\*@w??"     IDN 4 RG! 5 RG!       ` U*@wRR     ;
: NOTFOUND   S" U\*@w?"      IDN 4 RG!             ` U*@wR      ;
: NOTFOUND   S" U\*@b??"     IDN 4 RG! 5 RG!       ` U*@bRR     ;
: NOTFOUND   S" U\*@b?"      IDN 4 RG!             ` U*@bR      ;
: NOTFOUND   S" U\*@??"      IDN 3 RG! 4 RG!       ` U*@RR      ;
: NOTFOUND   S" U\*@?"       IDN 3 RG!             ` U*@R       ;
: NOTFOUND   S" U\*?"        IDN 2 RG!             ` U*R        ;
: NOTFOUND   S" U/w?"        IDN 3 RG!             ` U/wR       ;
: NOTFOUND   S" U/b?"        IDN 3 RG!             ` U/bR       ;
: NOTFOUND   S" U/@w??"      IDN 4 RG! 5 RG!       ` U/@wRR     ;
: NOTFOUND   S" U/@w?"       IDN 4 RG!             ` U/@wR      ;
: NOTFOUND   S" U/@b??"      IDN 4 RG! 5 RG!       ` U/@bRR     ;
: NOTFOUND   S" U/@b?"       IDN 4 RG!             ` U/@bR      ;
: NOTFOUND   S" U/@??"       IDN 3 RG! 4 RG!       ` U/@RR      ;
: NOTFOUND   S" U/@?"        IDN 3 RG!             ` U/@R       ;
: NOTFOUND   S" U/?"         IDN 2 RG!             ` U/R        ;
: NOTFOUND   S" b?c-b?"      IDN 1 RG! 5 RG!       ` bRc-bR     ;
: NOTFOUND   S" b?c-b#"      IDN 1 RG!             ` bRc-b#     ;
: NOTFOUND   S" b?c-@b??"    IDN 1 RG! 6 RG! 7 RG! ` bRc-@bRR   ;
: NOTFOUND   S" b?c-@b?"     IDN 1 RG! 6 RG!       ` bRc-@bR    ;
: NOTFOUND   S" b?c-@"       IDN 1 RG!             ` bRc-@      ;
: NOTFOUND   S" b?c+b?"      IDN 1 RG! 5 RG!       ` bRc+bR     ;
: NOTFOUND   S" b?c+b#"      IDN 1 RG!             ` bRc+b#     ;
: NOTFOUND   S" b?c+@b??"    IDN 1 RG! 6 RG! 7 RG! ` bRc+@bRR   ;
: NOTFOUND   S" b?c+@b?"     IDN 1 RG! 6 RG!       ` bRc+@bR    ;
: NOTFOUND   S" b?c+@"       IDN 1 RG!             ` bRc+@      ;
: NOTFOUND   S" b?-b?"       IDN 1 RG! 4 RG!       ` bR-bR      ;
: NOTFOUND   S" b?-b#"       IDN 1 RG!             ` bR-b#      ;
: NOTFOUND   S" b?-@b??"     IDN 1 RG! 5 RG! 6 RG! ` bR-@bRR    ;
: NOTFOUND   S" b?-@b?"      IDN 1 RG! 5 RG!       ` bR-@bR     ;
: NOTFOUND   S" b?-@"        IDN 1 RG!             ` bR-@       ;
: NOTFOUND   S" b?--"        IDN 1 RG!             ` bR--       ;
: NOTFOUND   S" b?+b?"       IDN 1 RG! 4 RG!       ` bR+bR      ;
: NOTFOUND   S" b?+b#"       IDN 1 RG!             ` bR+b#      ;
: NOTFOUND   S" b?+@b??"     IDN 1 RG! 5 RG! 6 RG! ` bR+@bRR    ;
: NOTFOUND   S" b?+@b?"      IDN 1 RG! 5 RG!       ` bR+@bR     ;
: NOTFOUND   S" b?+@"        IDN 1 RG!             ` bR+@       ;
: NOTFOUND   S" b?++"        IDN 1 RG!             ` bR++       ;
: NOTFOUND   S" \*w?"        IDN 2 RG!             ` *wR        ;
: NOTFOUND   S" \*b?"        IDN 2 RG!             ` *bR        ;
: NOTFOUND   S" \*@w??"      IDN 3 RG! 4 RG!       ` *@wRR      ;
: NOTFOUND   S" \*@w?"       IDN 3 RG!             ` *@wR       ;
: NOTFOUND   S" \*@b??"      IDN 3 RG! 4 RG!       ` *@bRR      ;
: NOTFOUND   S" \*@b?"       IDN 3 RG!             ` *@bR       ;
: NOTFOUND   S" \*@??"       IDN 2 RG! 3 RG!       ` *@RR       ;
: NOTFOUND   S" \*@?"        IDN 2 RG!             ` *@R        ;
: NOTFOUND   S" \*?"         IDN 1 RG!             ` *R         ;
: NOTFOUND   S" @w?c-w?"     IDN 2 RG! 6 RG!       ` @wRc-wR    ;
: NOTFOUND   S" @w?c-w#"     IDN 2 RG!             ` @wRc-w#    ;
: NOTFOUND   S" @w?c-b#"     IDN 2 RG!             ` @wRc-b#    ;
: NOTFOUND   S" @w?c+w?"     IDN 2 RG! 6 RG!       ` @wRc+wR    ;
: NOTFOUND   S" @w?c+w#"     IDN 2 RG!             ` @wRc+w#    ;
: NOTFOUND   S" @w?c+b#"     IDN 2 RG!             ` @wRc+b#    ;
: NOTFOUND   S" @w??c-w?"    IDN 2 RG! 3 RG! 7 RG! ` @wRRc-wR   ;
: NOTFOUND   S" @w??c-w#"    IDN 2 RG! 3 RG!       ` @wRRc-w#   ;
: NOTFOUND   S" @w??c-b#"    IDN 2 RG! 3 RG!       ` @wRRc-b#   ;
: NOTFOUND   S" @w??c+w?"    IDN 2 RG! 3 RG! 7 RG! ` @wRRc+wR   ;
: NOTFOUND   S" @w??c+w#"    IDN 2 RG! 3 RG!       ` @wRRc+w#   ;
: NOTFOUND   S" @w??c+b#"    IDN 2 RG! 3 RG!       ` @wRRc+b#   ;
: NOTFOUND   S" @w??-w?"     IDN 2 RG! 3 RG! 6 RG! ` @wRR-wR    ;
: NOTFOUND   S" @w??-w#"     IDN 2 RG! 3 RG!       ` @wRR-w#    ;
: NOTFOUND   S" @w??-b#"     IDN 2 RG! 3 RG!       ` @wRR-b#    ;
: NOTFOUND   S" @w??--"      IDN 2 RG! 3 RG!       ` @wRR--     ;
: NOTFOUND   S" @w??+w?"     IDN 2 RG! 3 RG! 6 RG! ` @wRR+wR    ;
: NOTFOUND   S" @w??+w#"     IDN 2 RG! 3 RG!       ` @wRR+w#    ;
: NOTFOUND   S" @w??+b#"     IDN 2 RG! 3 RG!       ` @wRR+b#    ;
: NOTFOUND   S" @w??++"      IDN 2 RG! 3 RG!       ` @wRR++     ;
: NOTFOUND   S" @w?-w?"      IDN 2 RG! 5 RG!       ` @wR-wR     ;
: NOTFOUND   S" @w?-w#"      IDN 2 RG!             ` @wR-w#     ;
: NOTFOUND   S" @w?-b#"      IDN 2 RG!             ` @wR-b#     ;
: NOTFOUND   S" @w?--"       IDN 2 RG!             ` @wR--      ;
: NOTFOUND   S" @w?+w?"      IDN 2 RG! 5 RG!       ` @wR+wR     ;
: NOTFOUND   S" @w?+w#"      IDN 2 RG!             ` @wR+w#     ;
: NOTFOUND   S" @w?+b#"      IDN 2 RG!             ` @wR+b#     ;
: NOTFOUND   S" @w?++"       IDN 2 RG!             ` @wR++      ;
: NOTFOUND   S" @c-w?"       IDN 4 RG!             ` @c-wR      ;
: NOTFOUND   S" @c-b?"       IDN 4 RG!             ` @c-bR      ;
: NOTFOUND   S" @c-?"        IDN 3 RG!             ` @c-R       ;
: NOTFOUND   S" @c+w?"       IDN 4 RG!             ` @c+wR      ;
: NOTFOUND   S" @c+b?"       IDN 4 RG!             ` @c+bR      ;
: NOTFOUND   S" @c+?"        IDN 3 RG!             ` @c+R       ;
: NOTFOUND   S" @b?c-b?"     IDN 2 RG! 6 RG!       ` @bRc-bR    ;
: NOTFOUND   S" @b?c-b#"     IDN 2 RG!             ` @bRc-b#    ;
: NOTFOUND   S" @b?c+b?"     IDN 2 RG! 6 RG!       ` @bRc+bR    ;
: NOTFOUND   S" @b?c+b#"     IDN 2 RG!             ` @bRc+b#    ;
: NOTFOUND   S" @b??c-b?"    IDN 2 RG! 3 RG! 7 RG! ` @bRRc-bR   ;
: NOTFOUND   S" @b??c-b#"    IDN 2 RG! 3 RG!       ` @bRRc-b#   ;
: NOTFOUND   S" @b??c+b?"    IDN 2 RG! 3 RG! 7 RG! ` @bRRc+bR   ;
: NOTFOUND   S" @b??c+b#"    IDN 2 RG! 3 RG!       ` @bRRc+b#   ;
: NOTFOUND   S" @b??-b?"     IDN 2 RG! 3 RG! 6 RG! ` @bRR-bR    ;
: NOTFOUND   S" @b??-b#"     IDN 2 RG! 3 RG!       ` @bRR-b#    ;
: NOTFOUND   S" @b??--"      IDN 2 RG! 3 RG!       ` @bRR--     ;
: NOTFOUND   S" @b??+b?"     IDN 2 RG! 3 RG! 6 RG! ` @bRR+bR    ;
: NOTFOUND   S" @b??+b#"     IDN 2 RG! 3 RG!       ` @bRR+b#    ;
: NOTFOUND   S" @b??++"      IDN 2 RG! 3 RG!       ` @bRR++     ;
: NOTFOUND   S" @b?-b?"      IDN 2 RG! 5 RG!       ` @bR-bR     ;
: NOTFOUND   S" @b?-b#"      IDN 2 RG!             ` @bR-b#     ;
: NOTFOUND   S" @b?--"       IDN 2 RG!             ` @bR--      ;
: NOTFOUND   S" @b?+b?"      IDN 2 RG! 5 RG!       ` @bR+bR     ;
: NOTFOUND   S" @b?+b#"      IDN 2 RG!             ` @bR+b#     ;
: NOTFOUND   S" @b?++"       IDN 2 RG!             ` @bR++      ;
: NOTFOUND   S" @?c-b#"      IDN 1 RG!             ` @Rc-b#     ;
: NOTFOUND   S" @?c-?"       IDN 1 RG! 4 RG!       ` @Rc-R      ;
: NOTFOUND   S" @?c-#"       IDN 1 RG!             ` @Rc-#      ;
: NOTFOUND   S" @?c+b#"      IDN 1 RG!             ` @Rc+b#     ;
: NOTFOUND   S" @?c+?"       IDN 1 RG! 4 RG!       ` @Rc+R      ;
: NOTFOUND   S" @?c+#"       IDN 1 RG!             ` @Rc+#      ;
: NOTFOUND   S" @??c-b#"     IDN 1 RG! 2 RG!       ` @RRc-b#    ;
: NOTFOUND   S" @??c-?"      IDN 1 RG! 2 RG! 5 RG! ` @RRc-R     ;
: NOTFOUND   S" @??c-#"      IDN 1 RG! 2 RG!       ` @RRc-#     ;
: NOTFOUND   S" @??c+b#"     IDN 1 RG! 2 RG!       ` @RRc+b#    ;
: NOTFOUND   S" @??c+?"      IDN 1 RG! 2 RG! 5 RG! ` @RRc+R     ;
: NOTFOUND   S" @??c+#"      IDN 1 RG! 2 RG!       ` @RRc+#     ;
: NOTFOUND   S" @??-b#"      IDN 1 RG! 2 RG!       ` @RR-b#     ;
: NOTFOUND   S" @??-?"       IDN 1 RG! 2 RG! 4 RG! ` @RR-R      ;
: NOTFOUND   S" @??--"       IDN 1 RG! 2 RG!       ` @RR--      ;
: NOTFOUND   S" @??-#"       IDN 1 RG! 2 RG!       ` @RR-#      ;
: NOTFOUND   S" @??+b#"      IDN 1 RG! 2 RG!       ` @RR+b#     ;
: NOTFOUND   S" @??+?"       IDN 1 RG! 2 RG! 4 RG! ` @RR+R      ;
: NOTFOUND   S" @??++"       IDN 1 RG! 2 RG!       ` @RR++      ;
: NOTFOUND   S" @??+#"       IDN 1 RG! 2 RG!       ` @RR+#      ;
: NOTFOUND   S" @?-b#"       IDN 1 RG!             ` @R-b#      ;
: NOTFOUND   S" @?-?"        IDN 1 RG! 3 RG!       ` @R-R       ;
: NOTFOUND   S" @?--"        IDN 1 RG!             ` @R--       ;
: NOTFOUND   S" @?-#"        IDN 1 RG!             ` @R-#       ;
: NOTFOUND   S" @?+b#"       IDN 1 RG!             ` @R+b#      ;
: NOTFOUND   S" @?+?"        IDN 1 RG! 3 RG!       ` @R+R       ;
: NOTFOUND   S" @?++"        IDN 1 RG!             ` @R++       ;
: NOTFOUND   S" @?+#"        IDN 1 RG!             ` @R+#       ;
: NOTFOUND   S" @-w?"        IDN 3 RG!             ` @-wR       ;
: NOTFOUND   S" @-b?"        IDN 3 RG!             ` @-bR       ;
: NOTFOUND   S" @-?"         IDN 2 RG!             ` @-R        ;
: NOTFOUND   S" @+w?"        IDN 3 RG!             ` @+wR       ;
: NOTFOUND   S" @+b?"        IDN 3 RG!             ` @+bR       ;
: NOTFOUND   S" @+?"         IDN 2 RG!             ` @+R        ;
: NOTFOUND   S" ?c-b#"       IDN 0 RG!             ` Rc-b#      ;
: NOTFOUND   S" ?c-@??"      IDN 0 RG! 4 RG! 5 RG! ` Rc-@RR     ;
: NOTFOUND   S" ?c-@?"       IDN 0 RG! 4 RG!       ` Rc-@R      ;
: NOTFOUND   S" ?c-@"        IDN 0 RG!             ` Rc-@       ;
: NOTFOUND   S" ?c-?"        IDN 0 RG! 3 RG!       ` Rc-R       ;
: NOTFOUND   S" ?c-#"        IDN 0 RG!             ` Rc-#       ;
: NOTFOUND   S" ?c+b#"       IDN 0 RG!             ` Rc+b#      ;
: NOTFOUND   S" ?c+@??"      IDN 0 RG! 4 RG! 5 RG! ` Rc+@RR     ;
: NOTFOUND   S" ?c+@?"       IDN 0 RG! 4 RG!       ` Rc+@R      ;
: NOTFOUND   S" ?c+@"        IDN 0 RG!             ` Rc+@       ;
: NOTFOUND   S" ?c+?"        IDN 0 RG! 3 RG!       ` Rc+R       ;
: NOTFOUND   S" ?c+#"        IDN 0 RG!             ` Rc+#       ;
: NOTFOUND   S" ?\*@??"      IDN 0 RG! 3 RG! 4 RG! ` R*@RR      ;
: NOTFOUND   S" ?\*@?"       IDN 0 RG! 3 RG!       ` R*@R       ;
: NOTFOUND   S" ?\*?"        IDN 0 RG! 2 RG!       ` R*R        ;
: NOTFOUND   S" ?=@?\*b#"    IDN 0 RG! 3 RG!       ` R=@R*b#    ;
: NOTFOUND   S" ?=@?\*#"     IDN 0 RG! 3 RG!       ` R=@R*#     ;
: NOTFOUND   S" ?=@??\*b#"   IDN 0 RG! 3 RG! 4 RG! ` R=@RR*b#   ;
: NOTFOUND   S" ?=@??\*#"    IDN 0 RG! 3 RG! 4 RG! ` R=@RR*#    ;
: NOTFOUND   S" ?=?\*b#"     IDN 0 RG! 2 RG!       ` R=R*b#     ;
: NOTFOUND   S" ?=?\*#"      IDN 0 RG! 2 RG!       ` R=R*#      ;
: NOTFOUND   S" ?-b#"        IDN 0 RG!             ` R-b#       ;
: NOTFOUND   S" ?-@??"       IDN 0 RG! 3 RG! 4 RG! ` R-@RR      ;
: NOTFOUND   S" ?-@?"        IDN 0 RG! 3 RG!       ` R-@R       ;
: NOTFOUND   S" ?-@"         IDN 0 RG!             ` R-@        ;
: NOTFOUND   S" ?-?"         IDN 0 RG! 2 RG!       ` R-R        ;
: NOTFOUND   S" ?--"         IDN 0 RG!             ` R--        ;
: NOTFOUND   S" ?-#"         IDN 0 RG!             ` R-#        ;
: NOTFOUND   S" ?+b#"        IDN 0 RG!             ` R+b#       ;
: NOTFOUND   S" ?+@??"       IDN 0 RG! 3 RG! 4 RG! ` R+@RR      ;
: NOTFOUND   S" ?+@?"        IDN 0 RG! 3 RG!       ` R+@R       ;
: NOTFOUND   S" ?+@"         IDN 0 RG!             ` R+@        ;
: NOTFOUND   S" ?+?"         IDN 0 RG! 2 RG!       ` R+R        ;
: NOTFOUND   S" ?++"         IDN 0 RG!             ` R++        ;
: NOTFOUND   S" ?+#"         IDN 0 RG!             ` R+#        ;
: NOTFOUND   S" Z/w?"        IDN 3 RG!             ` Z/wR        ;
: NOTFOUND   S" Z/b?"        IDN 3 RG!             ` Z/bR        ;
: NOTFOUND   S" Z/@w??"      IDN 4 RG! 5 RG!       ` Z/@wRR      ;
: NOTFOUND   S" Z/@w?"       IDN 4 RG!             ` Z/@wR       ;
: NOTFOUND   S" Z/@b??"      IDN 4 RG! 5 RG!       ` Z/@bRR      ;
: NOTFOUND   S" Z/@b?"       IDN 4 RG!             ` Z/@bR       ;
: NOTFOUND   S" Z/@??"       IDN 3 RG! 4 RG!       ` Z/@RR       ;
: NOTFOUND   S" Z/@?"        IDN 3 RG!             ` Z/@R        ;
: NOTFOUND   S" Z/?"         IDN 2 RG!             ` Z/R         ;
: NOTFOUND   S" -w?"         IDN 2 RG!             ` -wR        ;
: NOTFOUND   S" -b?"         IDN 2 RG!             ` -bR        ;
: NOTFOUND   S" -@w??"       IDN 3 RG! 4 RG!       ` -@wRR      ;
: NOTFOUND   S" -@w?"        IDN 3 RG!             ` -@wR       ;
: NOTFOUND   S" -@b??"       IDN 3 RG! 4 RG!       ` -@bRR      ;
: NOTFOUND   S" -@b?"        IDN 3 RG!             ` -@bR       ;
: NOTFOUND   S" -@??"        IDN 2 RG! 3 RG!       ` -@RR       ;
: NOTFOUND   S" -@?"         IDN 2 RG!             ` -@R        ;
: NOTFOUND   S" -?"          IDN 1 RG!             ` -R         ;
: NOTFOUND   S" ?+~?"        IDN 0 RG! 3 RG!       ` R+~R       ; \ XADD R,R
: NOTFOUND   S" @?+~?"       IDN 1 RG! 4 RG!       ` @R+~R      ; \ XADD [R],R

\ ЛОГИКА И СДВИГИ
: NOTFOUND   S" ?&?"         IDN 0 RG! 2 RG!       ` R&R        ;
: NOTFOUND   S" ?&@?"        IDN 0 RG! 3 RG!       ` R&@R       ;
: NOTFOUND   S" ?&@??"       IDN 0 RG! 3 RG! 4 RG! ` R&@RR      ;
: NOTFOUND   S" ?&#"         IDN 0 RG!             ` R&#        ;
: NOTFOUND   S" ?&b#"        IDN 0 RG!             ` R&b#       ;
: NOTFOUND   S" @?&?"        IDN 1 RG! 3 RG!       ` @R&R       ;
: NOTFOUND   S" @?&#"        IDN 1 RG!             ` @R&#       ;
: NOTFOUND   S" @??&?"       IDN 1 RG! 2 RG! 4 RG! ` @RR&R      ;
: NOTFOUND   S" @??&#"       IDN 1 RG! 2 RG!       ` @RR&#      ;
: NOTFOUND   S" w?&w?"       IDN 1 RG! 4 RG!       ` wR&wR      ;
: NOTFOUND   S" w?&@w?"      IDN 1 RG! 5 RG!       ` wR&@wR     ;
: NOTFOUND   S" w?&@w??"     IDN 1 RG! 5 RG! 6 RG! ` wR&@wRR    ;
: NOTFOUND   S" w?&w#"       IDN 1 RG!             ` wR&w#      ;
: NOTFOUND   S" @w?&w?"      IDN 2 RG! 5 RG!       ` @wR&wR     ;
: NOTFOUND   S" @w?&w#"      IDN 2 RG!             ` @wR&w#     ;
: NOTFOUND   S" @w??&w?"     IDN 2 RG! 3 RG! 6 RG! ` @wRR&wR    ;
: NOTFOUND   S" @w??&w#"     IDN 2 RG! 3 RG!       ` @wRR&w#    ;
: NOTFOUND   S" b?&b?"       IDN 1 RG! 4 RG!       ` bR&bR      ;
: NOTFOUND   S" b?&@b?"      IDN 1 RG! 5 RG!       ` bR&@bR     ;
: NOTFOUND   S" b?&@b??"     IDN 1 RG! 5 RG! 6 RG! ` bR&@bRR    ;
: NOTFOUND   S" b?&b#"       IDN 1 RG!             ` bR&b#      ;
: NOTFOUND   S" @b?&b?"      IDN 2 RG! 5 RG!       ` @bR&bR     ;
: NOTFOUND   S" @b?&b#"      IDN 2 RG!             ` @bR&b#     ;
: NOTFOUND   S" @b??&b?"     IDN 2 RG! 3 RG! 6 RG! ` @bRR&bR    ;
: NOTFOUND   S" @b??&b#"     IDN 2 RG! 3 RG!       ` @bRR&b#    ;
: NOTFOUND   S" z?&?"        IDN 1 RG! 3 RG!       ` zR&R       ;
: NOTFOUND   S" ?|?"         IDN 0 RG! 2 RG!       ` R|R        ;
: NOTFOUND   S" ?|@?"        IDN 0 RG! 3 RG!       ` R|@R       ;
: NOTFOUND   S" ?|@??"       IDN 0 RG! 3 RG! 4 RG! ` R|@RR      ;
: NOTFOUND   S" ?|#"         IDN 0 RG!             ` R|#        ;
: NOTFOUND   S" ?|b#"        IDN 0 RG!             ` R|b#       ;
: NOTFOUND   S" @?|?"        IDN 1 RG! 3 RG!       ` @R|R       ;
: NOTFOUND   S" @?|#"        IDN 1 RG!             ` @R|#       ;
: NOTFOUND   S" @??|?"       IDN 1 RG! 2 RG! 4 RG! ` @RR|R      ;
: NOTFOUND   S" @??|#"       IDN 1 RG! 2 RG!       ` @RR|#      ;
: NOTFOUND   S" w?|w?"       IDN 1 RG! 4 RG!       ` wR|wR      ;
: NOTFOUND   S" w?|@w?"      IDN 1 RG! 5 RG!       ` wR|@wR     ;
: NOTFOUND   S" w?|@w??"     IDN 1 RG! 5 RG! 6 RG! ` wR|@wRR    ;
: NOTFOUND   S" w?|w#"       IDN 1 RG!             ` wR|w#      ;
: NOTFOUND   S" @w?|w?"      IDN 2 RG! 5 RG!       ` @wR|wR     ;
: NOTFOUND   S" @w?|w#"      IDN 2 RG!             ` @wR|w#     ;
: NOTFOUND   S" @w??|w?"     IDN 2 RG! 3 RG! 6 RG! ` @wRR|wR    ;
: NOTFOUND   S" @w??|w#"     IDN 2 RG! 3 RG!       ` @wRR|w#    ;
: NOTFOUND   S" b?|b?"       IDN 1 RG! 4 RG!       ` bR|bR      ;
: NOTFOUND   S" b?|@b?"      IDN 1 RG! 5 RG!       ` bR|@bR     ;
: NOTFOUND   S" b?|@b??"     IDN 1 RG! 5 RG! 6 RG! ` bR|@bRR    ;
: NOTFOUND   S" b?|b#"       IDN 1 RG!             ` bR|b#      ;
: NOTFOUND   S" @b?|b?"      IDN 2 RG! 5 RG!       ` @bR|bR     ;
: NOTFOUND   S" @b?|b#"      IDN 2 RG!             ` @bR|b#     ;
: NOTFOUND   S" @b??|b?"     IDN 2 RG! 3 RG! 6 RG! ` @bRR|bR    ;
: NOTFOUND   S" @b??|b#"     IDN 2 RG! 3 RG!       ` @bRR|b#    ;
: NOTFOUND   S" ?^?"         IDN 0 RG! 2 RG!       ` R^R        ;
: NOTFOUND   S" ?^@?"        IDN 0 RG! 3 RG!       ` R^@R       ;
: NOTFOUND   S" ?^@??"       IDN 0 RG! 3 RG! 4 RG! ` R^@RR      ;
: NOTFOUND   S" ?^#"         IDN 0 RG!             ` R^#        ;
: NOTFOUND   S" ?^b#"        IDN 0 RG!             ` R^b#       ;
: NOTFOUND   S" @?^?"        IDN 1 RG! 3 RG!       ` @R^R       ;
: NOTFOUND   S" @?^#"        IDN 1 RG!             ` @R^#       ;
: NOTFOUND   S" @??^?"       IDN 1 RG! 2 RG! 4 RG! ` @RR^R      ;
: NOTFOUND   S" @??^#"       IDN 1 RG! 2 RG!       ` @RR^#      ;
: NOTFOUND   S" w?^w?"       IDN 1 RG! 4 RG!       ` wR^wR      ;
: NOTFOUND   S" w?^@w?"      IDN 1 RG! 5 RG!       ` wR^@wR     ;
: NOTFOUND   S" w?^@w??"     IDN 1 RG! 5 RG! 6 RG! ` wR^@wRR    ;
: NOTFOUND   S" w?^w#"       IDN 1 RG!             ` wR^w#      ;
: NOTFOUND   S" @w?^w?"      IDN 2 RG! 5 RG!       ` @wR^wR     ;
: NOTFOUND   S" @w?^w#"      IDN 2 RG!             ` @wR^w#     ;
: NOTFOUND   S" @w??^w?"     IDN 2 RG! 3 RG! 6 RG! ` @wRR^wR    ;
: NOTFOUND   S" @w??^w#"     IDN 2 RG! 3 RG!       ` @wRR^w#    ;
: NOTFOUND   S" b?^b?"       IDN 1 RG! 4 RG!       ` bR^bR      ;
: NOTFOUND   S" b?^@b?"      IDN 1 RG! 5 RG!       ` bR^@bR     ;
: NOTFOUND   S" b?^@b??"     IDN 1 RG! 5 RG! 6 RG! ` bR^@bRR    ;
: NOTFOUND   S" b?^b#"       IDN 1 RG!             ` bR^b#      ;
: NOTFOUND   S" @b?^b?"      IDN 2 RG! 5 RG!       ` @bR^bR     ;
: NOTFOUND   S" @b?^b#"      IDN 2 RG!             ` @bR^b#     ;
: NOTFOUND   S" @b??^b?"     IDN 2 RG! 3 RG! 6 RG! ` @bRR^bR    ;
: NOTFOUND   S" @b??^b#"     IDN 2 RG! 3 RG!       ` @bRR^b#    ;
: NOTFOUND   S" 1?>>"        IDN 1 RG!             ` 1R>>       ;
: NOTFOUND   S" 1w?>>"       IDN 2 RG!             ` 1wR>>      ;
: NOTFOUND   S" 1b?>>"       IDN 2 RG!             ` 1bR>>      ;
: NOTFOUND   S" 1@?>>"       IDN 2 RG!             ` 1@R>>      ;
: NOTFOUND   S" 1@w?>>"      IDN 3 RG!             ` 1@wR>>     ;
: NOTFOUND   S" 1@b?>>"      IDN 3 RG!             ` 1@bR>>     ;
: NOTFOUND   S" 1@??>>"      IDN 2 RG! 3 RG!       ` 1@RR>>     ;
: NOTFOUND   S" 1@w??>>"     IDN 3 RG! 4 RG!       ` 1@wRR>>    ;
: NOTFOUND   S" 1@b??>>"     IDN 3 RG! 4 RG!       ` 1@bRR>>    ;
: NOTFOUND   S" 1?c>>"       IDN 1 RG!             ` 1Rc>>      ;
: NOTFOUND   S" 1?a>>"       IDN 1 RG!             ` 1Ra>>      ;
: NOTFOUND   S" 1w?c>>"      IDN 2 RG!             ` 1wRc>>     ;
: NOTFOUND   S" 1b?c>>"      IDN 2 RG!             ` 1bRc>>     ;
: NOTFOUND   S" 1@?c>>"      IDN 2 RG!             ` 1@Rc>>     ;
: NOTFOUND   S" 1@w?c>>"     IDN 3 RG!             ` 1@wRc>>    ;
: NOTFOUND   S" 1@b?c>>"     IDN 3 RG!             ` 1@bRc>>    ;
: NOTFOUND   S" 1@??c>>"     IDN 2 RG! 3 RG!       ` 1@RRc>>    ;
: NOTFOUND   S" 1@w??c>>"    IDN 3 RG! 4 RG!       ` 1@wRRc>>   ;
: NOTFOUND   S" 1@b??c>>"    IDN 3 RG! 4 RG!       ` 1@bRRc>>   ;
: NOTFOUND   S" 1?o>>"       IDN 1 RG!             ` 1Ro>>      ;
: NOTFOUND   S" 1w?o>>"      IDN 2 RG!             ` 1wRo>>     ;
: NOTFOUND   S" 1b?o>>"      IDN 2 RG!             ` 1bRo>>     ;
: NOTFOUND   S" 1@?o>>"      IDN 2 RG!             ` 1@Ro>>     ;
: NOTFOUND   S" 1@w?o>>"     IDN 3 RG!             ` 1@wRo>>    ;
: NOTFOUND   S" 1@b?o>>"     IDN 3 RG!             ` 1@bRo>>    ;
: NOTFOUND   S" 1@??o>>"     IDN 2 RG! 3 RG!       ` 1@RRo>>    ;
: NOTFOUND   S" 1@w??o>>"    IDN 3 RG! 4 RG!       ` 1@wRRo>>   ;
: NOTFOUND   S" 1@b??o>>"    IDN 3 RG! 4 RG!       ` 1@bRRo>>   ;
: NOTFOUND   S" ?>>"         IDN 0 RG!             ` R>>        ;
: NOTFOUND   S" w?>>"        IDN 1 RG!             ` wR>>       ;
: NOTFOUND   S" b?>>"        IDN 1 RG!             ` bR>>       ;
: NOTFOUND   S" @?>>"        IDN 1 RG!             ` @R>>       ;
: NOTFOUND   S" @w?>>"       IDN 2 RG!             ` @wR>>      ;
: NOTFOUND   S" @b?>>"       IDN 2 RG!             ` @bR>>      ;
: NOTFOUND   S" @??>>"       IDN 1 RG! 2 RG!       ` @RR>>      ;
: NOTFOUND   S" @w??>>"      IDN 2 RG! 3 RG!       ` @wRR>>     ;
: NOTFOUND   S" @b??>>"      IDN 2 RG! 3 RG!       ` @bRR>>     ;
: NOTFOUND   S" #?>>"        IDN 1 RG!             ` #R>>       ;
: NOTFOUND   S" #w?>>"       IDN 2 RG!             ` #wR>>      ;
: NOTFOUND   S" #b?>>"       IDN 2 RG!             ` #bR>>      ;
: NOTFOUND   S" #@?>>"       IDN 2 RG!             ` #@R>>      ;
: NOTFOUND   S" #@w?>>"      IDN 3 RG!             ` #@wR>>     ;
: NOTFOUND   S" #@b?>>"      IDN 3 RG!             ` #@bR>>     ;
: NOTFOUND   S" #@??>>"      IDN 2 RG! 3 RG!       ` #@RR>>     ;
: NOTFOUND   S" #@w??>>"     IDN 3 RG! 4 RG!       ` #@wRR>>    ;
: NOTFOUND   S" #@b??>>"     IDN 3 RG! 4 RG!       ` #@bRR>>    ;
: NOTFOUND   S" ?a>>"        IDN 0 RG!             ` Ra>>       ;
: NOTFOUND   S" w?a>>"       IDN 1 RG!             ` wRa>>      ;
: NOTFOUND   S" b?a>>"       IDN 1 RG!             ` bRa>>      ;
: NOTFOUND   S" @?a>>"       IDN 1 RG!             ` @Ra>>      ;
: NOTFOUND   S" @w?a>>"      IDN 2 RG!             ` @wRa>>     ;
: NOTFOUND   S" @b?a>>"      IDN 2 RG!             ` @bRa>>     ;
: NOTFOUND   S" @??a>>"      IDN 1 RG! 2 RG!       ` @RRa>>     ;
: NOTFOUND   S" @w??a>>"     IDN 2 RG! 3 RG!       ` @wRRa>>    ;
: NOTFOUND   S" @b??a>>"     IDN 2 RG! 3 RG!       ` @bRRa>>    ;
: NOTFOUND   S" #?a>>"       IDN 1 RG!             ` #Ra>>      ;
: NOTFOUND   S" #w?a>>"      IDN 2 RG!             ` #wRa>>     ;
: NOTFOUND   S" #b?a>>"      IDN 2 RG!             ` #bRa>>     ;
: NOTFOUND   S" #@?a>>"      IDN 2 RG!             ` #@Ra>>     ;
: NOTFOUND   S" #@w?a>>"     IDN 3 RG!             ` #@wRa>>    ;
: NOTFOUND   S" #@b?a>>"     IDN 3 RG!             ` #@bRa>>    ;
: NOTFOUND   S" #@??a>>"     IDN 2 RG! 3 RG!       ` #@RRa>>    ;
: NOTFOUND   S" #@w??a>>"    IDN 3 RG! 4 RG!       ` #@wRRa>>   ;
: NOTFOUND   S" #@b??a>>"    IDN 3 RG! 4 RG!       ` #@bRRa>>   ;
: NOTFOUND   S" ?c>>"        IDN 0 RG!             ` Rc>>       ;
: NOTFOUND   S" w?c>>"       IDN 1 RG!             ` wRc>>      ;
: NOTFOUND   S" b?c>>"       IDN 1 RG!             ` bRc>>      ;
: NOTFOUND   S" @?c>>"       IDN 1 RG!             ` @Rc>>      ;
: NOTFOUND   S" @w?c>>"      IDN 2 RG!             ` @wRc>>     ;
: NOTFOUND   S" @b?c>>"      IDN 2 RG!             ` @bRc>>     ;
: NOTFOUND   S" @??c>>"      IDN 1 RG! 2 RG!       ` @RRc>>     ;
: NOTFOUND   S" @w??c>>"     IDN 2 RG! 3 RG!       ` @wRRc>>    ;
: NOTFOUND   S" @b??c>>"     IDN 2 RG! 3 RG!       ` @bRRc>>    ;
: NOTFOUND   S" #?c>>"       IDN 1 RG!             ` #Rc>>      ;
: NOTFOUND   S" #w?c>>"      IDN 2 RG!             ` #wRc>>     ;
: NOTFOUND   S" #b?c>>"      IDN 2 RG!             ` #bRc>>     ;
: NOTFOUND   S" #@?c>>"      IDN 2 RG!             ` #@Rc>>     ;
: NOTFOUND   S" #@w?c>>"     IDN 3 RG!             ` #@wRc>>    ;
: NOTFOUND   S" #@b?c>>"     IDN 3 RG!             ` #@bRc>>    ;
: NOTFOUND   S" #@??c>>"     IDN 2 RG! 3 RG!       ` #@RRc>>    ;
: NOTFOUND   S" #@w??c>>"    IDN 3 RG! 4 RG!       ` #@wRRc>>   ;
: NOTFOUND   S" #@b??c>>"    IDN 3 RG! 4 RG!       ` #@bRRc>>   ;
: NOTFOUND   S" ?o>>"        IDN 0 RG!             ` Ro>>       ;
: NOTFOUND   S" w?o>>"       IDN 1 RG!             ` wRo>>      ;
: NOTFOUND   S" b?o>>"       IDN 1 RG!             ` bRo>>      ;
: NOTFOUND   S" @?o>>"       IDN 1 RG!             ` @Ro>>      ;
: NOTFOUND   S" @w?o>>"      IDN 2 RG!             ` @wRo>>     ;
: NOTFOUND   S" @b?o>>"      IDN 2 RG!             ` @bRo>>     ;
: NOTFOUND   S" @??o>>"      IDN 1 RG! 2 RG!       ` @RRo>>     ;
: NOTFOUND   S" @w??o>>"     IDN 2 RG! 3 RG!       ` @wRRo>>    ;
: NOTFOUND   S" @b??o>>"     IDN 2 RG! 3 RG!       ` @bRRo>>    ;
: NOTFOUND   S" #?o>>"       IDN 1 RG!             ` #Ro>>      ;
: NOTFOUND   S" #w?o>>"      IDN 2 RG!             ` #wRo>>     ;
: NOTFOUND   S" #b?o>>"      IDN 2 RG!             ` #bRo>>     ;
: NOTFOUND   S" #@?o>>"      IDN 2 RG!             ` #@Ro>>     ;
: NOTFOUND   S" #@w?o>>"     IDN 3 RG!             ` #@wRo>>    ;
: NOTFOUND   S" #@b?o>>"     IDN 3 RG!             ` #@bRo>>    ;
: NOTFOUND   S" #@??o>>"     IDN 2 RG! 3 RG!       ` #@RRo>>    ;
: NOTFOUND   S" #@w??o>>"    IDN 3 RG! 4 RG!       ` #@wRRo>>   ;
: NOTFOUND   S" #@b??o>>"    IDN 3 RG! 4 RG!       ` #@bRRo>>   ;

: NOTFOUND   S" 1?<<"        IDN 1 RG!             ` 1R<<       ;
: NOTFOUND   S" 1w?<<"       IDN 2 RG!             ` 1wR<<      ;
: NOTFOUND   S" 1b?<<"       IDN 2 RG!             ` 1bR<<      ;
: NOTFOUND   S" 1@?<<"       IDN 2 RG!             ` 1@R<<      ;
: NOTFOUND   S" 1@w?<<"      IDN 3 RG!             ` 1@wR<<     ;
: NOTFOUND   S" 1@b?<<"      IDN 3 RG!             ` 1@bR<<     ;
: NOTFOUND   S" 1@??<<"      IDN 2 RG! 3 RG!       ` 1@RR<<     ;
: NOTFOUND   S" 1@w??<<"     IDN 3 RG! 4 RG!       ` 1@wRR<<    ;
: NOTFOUND   S" 1@b??<<"     IDN 3 RG! 4 RG!       ` 1@bRR<<    ;
: NOTFOUND   S" 1?c<<"       IDN 1 RG!             ` 1Rc<<      ;
: NOTFOUND   S" 1w?c<<"      IDN 2 RG!             ` 1wRc<<     ;
: NOTFOUND   S" 1b?c<<"      IDN 2 RG!             ` 1bRc<<     ;
: NOTFOUND   S" 1@?c<<"      IDN 2 RG!             ` 1@Rc<<     ;
: NOTFOUND   S" 1@w?c<<"     IDN 3 RG!             ` 1@wRc<<    ;
: NOTFOUND   S" 1@b?c<<"     IDN 3 RG!             ` 1@bRc<<    ;
: NOTFOUND   S" 1@??c<<"     IDN 2 RG! 3 RG!       ` 1@RRc<<    ;
: NOTFOUND   S" 1@w??c<<"    IDN 3 RG! 4 RG!       ` 1@wRRc<<   ;
: NOTFOUND   S" 1@b??c<<"    IDN 3 RG! 4 RG!       ` 1@bRRc<<   ;
: NOTFOUND   S" 1?o<<"       IDN 1 RG!             ` 1Ro<<      ;
: NOTFOUND   S" 1w?o<<"      IDN 2 RG!             ` 1wRo<<     ;
: NOTFOUND   S" 1b?o<<"      IDN 2 RG!             ` 1bRo<<     ;
: NOTFOUND   S" 1@?o<<"      IDN 2 RG!             ` 1@Ro<<     ;
: NOTFOUND   S" 1@w?o<<"     IDN 3 RG!             ` 1@wRo<<    ;
: NOTFOUND   S" 1@b?o<<"     IDN 3 RG!             ` 1@bRo<<    ;
: NOTFOUND   S" 1@??o<<"     IDN 2 RG! 3 RG!       ` 1@RRo<<    ;
: NOTFOUND   S" 1@w??o<<"    IDN 3 RG! 4 RG!       ` 1@wRRo<<   ;
: NOTFOUND   S" 1@b??o<<"    IDN 3 RG! 4 RG!       ` 1@bRRo<<   ;
: NOTFOUND   S" ?<<"         IDN 0 RG!             ` R<<        ;
: NOTFOUND   S" w?<<"        IDN 1 RG!             ` wR<<       ;
: NOTFOUND   S" b?<<"        IDN 1 RG!             ` bR<<       ;
: NOTFOUND   S" @?<<"        IDN 1 RG!             ` @R<<       ;
: NOTFOUND   S" @w?<<"       IDN 2 RG!             ` @wR<<      ;
: NOTFOUND   S" @b?<<"       IDN 2 RG!             ` @bR<<      ;
: NOTFOUND   S" @??<<"       IDN 1 RG! 2 RG!       ` @RR<<      ;
: NOTFOUND   S" @w??<<"      IDN 2 RG! 3 RG!       ` @wRR<<     ;
: NOTFOUND   S" @b??<<"      IDN 2 RG! 3 RG!       ` @bRR<<     ;
: NOTFOUND   S" #?<<"        IDN 1 RG!             ` #R<<       ;
: NOTFOUND   S" #?a<<"       IDN 1 RG!             ` #Ra<<      ;
: NOTFOUND   S" #w?<<"       IDN 2 RG!             ` #wR<<      ;
: NOTFOUND   S" #b?<<"       IDN 2 RG!             ` #bR<<      ;
: NOTFOUND   S" #@?<<"       IDN 2 RG!             ` #@R<<      ;
: NOTFOUND   S" #@w?<<"      IDN 3 RG!             ` #@wR<<     ;
: NOTFOUND   S" #@b?<<"      IDN 3 RG!             ` #@bR<<     ;
: NOTFOUND   S" #@??<<"      IDN 2 RG! 3 RG!       ` #@RR<<     ;
: NOTFOUND   S" #@w??<<"     IDN 3 RG! 4 RG!       ` #@wRR<<    ;
: NOTFOUND   S" #@b??<<"     IDN 3 RG! 4 RG!       ` #@bRR<<    ;
: NOTFOUND   S" ?c<<"        IDN 0 RG!             ` Rc<<       ;
: NOTFOUND   S" w?c<<"       IDN 1 RG!             ` wRc<<      ;
: NOTFOUND   S" b?c<<"       IDN 1 RG!             ` bRc<<      ;
: NOTFOUND   S" @?c<<"       IDN 1 RG!             ` @Rc<<      ;
: NOTFOUND   S" @w?c<<"      IDN 2 RG!             ` @wRc<<     ;
: NOTFOUND   S" @b?c<<"      IDN 2 RG!             ` @bRc<<     ;
: NOTFOUND   S" @??c<<"      IDN 1 RG! 2 RG!       ` @RRc<<     ;
: NOTFOUND   S" @w??c<<"     IDN 2 RG! 3 RG!       ` @wRRc<<    ;
: NOTFOUND   S" @b??c<<"     IDN 2 RG! 3 RG!       ` @bRRc<<    ;
: NOTFOUND   S" #?c<<"       IDN 1 RG!             ` #Rc<<      ;
: NOTFOUND   S" #w?c<<"      IDN 2 RG!             ` #wRc<<     ;
: NOTFOUND   S" #b?c<<"      IDN 2 RG!             ` #bRc<<     ;
: NOTFOUND   S" #@?c<<"      IDN 2 RG!             ` #@Rc<<     ;
: NOTFOUND   S" #@w?c<<"     IDN 3 RG!             ` #@wRc<<    ;
: NOTFOUND   S" #@b?c<<"     IDN 3 RG!             ` #@bRc<<    ;
: NOTFOUND   S" #@??c<<"     IDN 2 RG! 3 RG!       ` #@RRc<<    ;
: NOTFOUND   S" #@w??c<<"    IDN 3 RG! 4 RG!       ` #@wRRc<<   ;
: NOTFOUND   S" #@b??c<<"    IDN 3 RG! 4 RG!       ` #@bRRc<<   ;
: NOTFOUND   S" ?o<<"        IDN 0 RG!             ` Ro<<       ;
: NOTFOUND   S" w?o<<"       IDN 1 RG!             ` wRo<<      ;
: NOTFOUND   S" b?o<<"       IDN 1 RG!             ` bRo<<      ;
: NOTFOUND   S" @?o<<"       IDN 1 RG!             ` @Ro<<      ;
: NOTFOUND   S" @w?o<<"      IDN 2 RG!             ` @wRo<<     ;
: NOTFOUND   S" @b?o<<"      IDN 2 RG!             ` @bRo<<     ;
: NOTFOUND   S" @??o<<"      IDN 1 RG! 2 RG!       ` @RRo<<     ;
: NOTFOUND   S" @w??o<<"     IDN 2 RG! 3 RG!       ` @wRRo<<    ;
: NOTFOUND   S" @b??o<<"     IDN 2 RG! 3 RG!       ` @bRRo<<    ;
: NOTFOUND   S" #?o<<"       IDN 1 RG!             ` #Ro<<      ;
: NOTFOUND   S" #w?o<<"      IDN 2 RG!             ` #wRo<<     ;
: NOTFOUND   S" #b?o<<"      IDN 2 RG!             ` #bRo<<     ;
: NOTFOUND   S" #@?o<<"      IDN 2 RG!             ` #@Ro<<     ;
: NOTFOUND   S" #@w?o<<"     IDN 3 RG!             ` #@wRo<<    ;
: NOTFOUND   S" #@b?o<<"     IDN 3 RG!             ` #@bRo<<    ;
: NOTFOUND   S" #@??o<<"     IDN 2 RG! 3 RG!       ` #@RRo<<    ;
: NOTFOUND   S" #@w??o<<"    IDN 3 RG! 4 RG!       ` #@wRRo<<   ;
: NOTFOUND   S" #@b??o<<"    IDN 3 RG! 4 RG!       ` #@bRRo<<   ;
: NOTFOUND   S" ?~"          IDN 0 RG!             ` R~         ;
: NOTFOUND   S" w?~"         IDN 1 RG!             ` wR~        ;
: NOTFOUND   S" b?~"         IDN 1 RG!             ` bR~        ;
: NOTFOUND   S" @?~"         IDN 1 RG!             ` @R~        ;
: NOTFOUND   S" @w?~"        IDN 2 RG!             ` @wR~       ;
: NOTFOUND   S" @b?~"        IDN 2 RG!             ` @bR~       ;
: NOTFOUND   S" @??~"        IDN 1 RG! 2 RG!       ` @RR~       ;
: NOTFOUND   S" @w??~"       IDN 2 RG! 3 RG!       ` @wRR~      ;
: NOTFOUND   S" @b??~"       IDN 2 RG! 3 RG!       ` @bRR~      ;

\ СРАВНЕНИЯ
: NOTFOUND   S" ?=?\?"       IDN 0 RG! 2 RG!       ` R=R?       ;  \ CMP R, R
: NOTFOUND   S" ?=@?\?"      IDN 0 RG! 3 RG!       ` R=@R?      ;  \ CMP R, [R]
: NOTFOUND   S" @?=?\?"      IDN 1 RG! 3 RG!       ` @R=R?      ;  \ CMP [R], R
: NOTFOUND   S" ?=@??\?"     IDN 0 RG! 3 RG! 4 RG! ` R=@RR?     ;  \ CMP R, [R][R]
: NOTFOUND   S" @??=?\?"     IDN 1 RG! 2 RG! 4 RG! ` @RR=R?     ;  \ CMP [R][R], R
: NOTFOUND   S" ?=#\?"       IDN 0 RG!             ` R=#?       ;  \ CMP R, #
: NOTFOUND   S" @?=#\?"      IDN 1 RG!             ` @R=#?      ;  \ CMP [R], #
: NOTFOUND   S" @??=#\?"     IDN 1 RG! 2 RG!       ` @RR=#?     ;  \ CMP [R][R], #
: NOTFOUND   S" ?=b#\?"      IDN 0 RG!             ` R=b#?      ;  \ CMP R, b#
: NOTFOUND   S" @?=b#\?"     IDN 1 RG!             ` @R=b#?     ;  \ CMP [R], b#
: NOTFOUND   S" @??=b#\?"    IDN 1 RG! 2 RG!       ` @RR=b#?    ;  \ CMP [R][R], b#
: NOTFOUND   S" b?=b?\?"     IDN 1 RG! 4 RG!       ` bR=bR?     ;  \ CMP bR, bR
: NOTFOUND   S" b?=@b?\?"    IDN 1 RG! 5 RG!       ` bR=@bR?    ;  \ CMP bR, [bR]
: NOTFOUND   S" @b?=b?\?"    IDN 2 RG! 5 RG!       ` @bR=bR?    ;  \ CMP [bR], bR
: NOTFOUND   S" b?=@b??\?"   IDN 1 RG! 5 RG! 6 RG! ` bR=@bRR?   ;  \ CMP bR, [bR][bR]
: NOTFOUND   S" @b??=b?\?"   IDN 2 RG! 3 RG! 6 RG! ` @bRR=bR?   ;  \ CMP [bR][bR], bR
: NOTFOUND   S" b?=b#\?"     IDN 1 RG!             ` bR=b#?     ;  \ CMP bR, b#
: NOTFOUND   S" @b?=b#\?"    IDN 2 RG!             ` @bR=b#?    ;  \ CMP [bR], b#
: NOTFOUND   S" @b??=b#\?"   IDN 2 RG! 3 RG!       ` @bRR=b#?   ;  \ CMP [bR][bR], b#
: NOTFOUND   S" w?=w?\?"     IDN 1 RG! 4 RG!       ` wR=wR?     ;  \ CMP wR, wR
: NOTFOUND   S" w?=@w?\?"    IDN 1 RG! 5 RG!       ` wR=@wR?    ;  \ CMP wR, [wR]
: NOTFOUND   S" @w?=w?\?"    IDN 2 RG! 5 RG!       ` @wR=wR?    ;  \ CMP [wR], wR
: NOTFOUND   S" w?=@w??\?"   IDN 1 RG! 5 RG! 6 RG! ` wR=@wRR?   ;  \ CMP wR, [wR][wR]
: NOTFOUND   S" @w??=w?\?"   IDN 2 RG! 3 RG! 6 RG! ` @wRR=wR?   ;  \ CMP [wR][wR], wR
: NOTFOUND   S" w?=w#\?"     IDN 1 RG!             ` wR=w#?     ;  \ CMP wR, w#
: NOTFOUND   S" @w?=w#\?"    IDN 2 RG!             ` @wR=w#?    ;  \ CMP [wR], w#
: NOTFOUND   S" @w??=w#\?"   IDN 2 RG! 3 RG!       ` @wRR=w#?   ;  \ CMP [wR][wR], w#
: NOTFOUND   S" w?=b#\?"     IDN 1 RG!             ` wR=b#?     ;  \ CMP wR, b#
: NOTFOUND   S" @w?=b#\?"    IDN 2 RG!             ` @wR=b#?    ;  \ CMP [wR], b#
: NOTFOUND   S" @w??=b#\?"   IDN 2 RG! 3 RG!       ` @wRR=b#?   ;  \ CMP [wR][wR], b#

: NOTFOUND   S" @??=LE"      IDN 1 RG! 2 RG!       ` @RR=LE     ;
: NOTFOUND   S" O\\w?=?"     IDN 3 RG! 5 RG!       ` O\wR=R     ;

: NOTFOUND   S" A=?\?=?"     IDN 2 RG! 5 RG!       ` A=R?=R     ;
: NOTFOUND   S" A=@?\?=?"    IDN 3 RG! 6 RG!       ` A=@R?=R    ;
: NOTFOUND   S" A=@??\?=?"   IDN 3 RG! 4 RG! 7 RG! ` A=@RR?=R   ;
: NOTFOUND   S" A=b?\?=b?"   IDN 3 RG! 7 RG!       ` A=bR?=bR   ;
: NOTFOUND   S" A=@b?\?=b?"  IDN 4 RG! 8 RG!       ` A=@bR?=bR  ;
: NOTFOUND   S" A=@b??\?=b?" IDN 4 RG! 5 RG! 9 RG! ` A=@bRR?=bR ;
: NOTFOUND   S" A=w?\?=w?"   IDN 3 RG! 7 RG!       ` A=wR?=wR   ;
: NOTFOUND   S" A=@w?\?=w?"  IDN 4 RG! 8 RG!       ` A=@wR?=wR  ;
: NOTFOUND   S" A=@w??\?=w?" IDN 4 RG! 5 RG! 9 RG! ` A=@wRR?=wR ;

\ РАБОТА С БИТАМИ
: NOTFOUND   S" ?=L\\?"      IDN 0 RG! 4 RG!       ` R=L\R      ;  \ BSF R, R
: NOTFOUND   S" ?=L\\@?"     IDN 0 RG! 5 RG!       ` R=L\@R     ;  \ BSF R, [R]
: NOTFOUND   S" ?=H\\?"      IDN 0 RG! 4 RG!       ` R=H\R      ;  \ BSR R, R
: NOTFOUND   S" ?=H\\@?"     IDN 0 RG! 5 RG!       ` R=H\@R     ;  \ BSR R, [R]
: NOTFOUND   S" C=?\\?"      IDN 2 RG! 4 RG!       ` C=R\R      ;  \ BT  R, R
: NOTFOUND   S" C=?\\@?"     IDN 2 RG! 5 RG!       ` C=R\@R     ;  \ BT  R, [R]
: NOTFOUND   S" C=?\\?~"     IDN 2 RG! 4 RG!       ` C=R\R~     ;  \ BTC R, R
: NOTFOUND   S" C=?\\@?~"    IDN 2 RG! 5 RG!       ` C=R\@R~    ;  \ BTC R, [R]
: NOTFOUND   S" C=?\\?0"     IDN 2 RG! 4 RG!       ` C=R\R0     ;  \ BTR R, R
: NOTFOUND   S" C=?\\@?0"    IDN 2 RG! 5 RG!       ` C=R\@R0    ;  \ BTR R, [R]
: NOTFOUND   S" C=?\\?1"     IDN 2 RG! 4 RG!       ` C=R\R1     ;  \ BTS R, R
: NOTFOUND   S" C=?\\@?1"    IDN 2 RG! 5 RG!       ` C=R\@R1    ;  \ BTS R, [R]

\ ПЕРЕХОДЫ
: NOTFOUND   S" JR?"         IDN 2 RG!             ` JR         ;  \ JMP R
: NOTFOUND   S" J@?"         IDN 2 RG!             ` J@R        ;  \ JMP [R]
: NOTFOUND   S" J@??"        IDN 2 RG! 3 RG!       ` J@RR       ;  \ JMP [R][R]

\ УСЛОВНЫЕ ПЕРЕСЫЛКИ
: NOTFOUND   S" L\\?=?"      IDN 2 RG! 4 RG!       ` L\R=R      ;
: NOTFOUND   S" G\\?=?"      IDN 2 RG! 4 RG!       ` G\R=R      ;
: NOTFOUND   S" Z\\?=?"      IDN 2 RG! 4 RG!       ` Z\R=R      ;
: NOTFOUND   S" NZ\\?=?"     IDN 3 RG! 5 RG!       ` NZ\R=R     ;
: NOTFOUND   S" L\\?=@?"     IDN 2 RG! 5 RG!       ` L\R=@R     ;
: NOTFOUND   S" G\\?=@?"     IDN 2 RG! 5 RG!       ` G\R=@R     ;
: NOTFOUND   S" Z\\?=@?"     IDN 2 RG! 5 RG!       ` Z\R=@R     ;
: NOTFOUND   S" NZ\\?=@?"    IDN 3 RG! 6 RG!       ` NZ\R=@R    ;

\ УСТАНОВКА БАЙТА ПО УСЛОВИЮ
: NOTFOUND   S" ?=LE"        IDN 0 RG!             ` R=LE       ;  \ SETLE RL
: NOTFOUND   S" @?=LE"       IDN 1 RG!             ` @R=LE      ;  \ SETLE [RL]
: NOTFOUND   S" ?=GE"        IDN 0 RG!             ` R=GE       ;  \ SETGE RL
: NOTFOUND   S" @?=GE"       IDN 1 RG!             ` @R=GE      ;  \ SETGE [RL]
\ : NOTFOUND   S" ?=G"         IDN 0 RG!             ` R=G        ;

\ ПЕРЕСТАНОВКА БАЙТОВ
: NOTFOUND   S" ?0123"       IDN 0 RG!             ` R0123      ;  \ BSWAP

\ ВЫЗОВЫ ПОДПРОГРАММ
: NOTFOUND   S" :?"          IDN 1 RG!             ` :R         ;  \ CALL R

\ ПЛАВ. ТОЧКА
: NOTFOUND   S" 0=@w?"       IDN 4 RG!             ` 0=@wR      ;  \ FILD  m16int
: NOTFOUND   S" 0=@?"        IDN 3 RG!             ` 0=@R       ;  \ FILD  m32int
: NOTFOUND   S" 0=@d?"       IDN 4 RG!             ` 0=@dR      ;  \ FILD  m64int

: NOTFOUND   S" @w?=0"       IDN 2 RG!             ` @wR=0      ;  \ FIST m16int
: NOTFOUND   S" @w?=0-"      IDN 2 RG!             ` @wR=0-     ;  \ FISTP m16int
: NOTFOUND   S" @?=0"        IDN 1 RG!             ` @R=0       ;  \ FIST m32int
: NOTFOUND   S" @?=0-"       IDN 1 RG!             ` @R=0-      ;  \ FISTP m32int

: NOTFOUND   S" @d?=0-"      IDN 2 RG!             ` @dR=0-     ;  \ FISTP m64int

: NOTFOUND   S" 0+@w?"       IDN 4 RG!             ` 0+@wR      ;  \ FIADD m16int
: NOTFOUND   S" 0+@?"        IDN 3 RG!             ` 0+@R       ;  \ FIADD m32int
: NOTFOUND   S" 0-@w?"       IDN 4 RG!             ` 0-@wR      ;  \ FISUB m16int
: NOTFOUND   S" 0-@?"        IDN 3 RG!             ` 0-@R       ;  \ FISUB m32int
: NOTFOUND   S" 0\*@w?"      IDN 4 RG!             ` 0*@wR      ;  \ FIMUL m16int
: NOTFOUND   S" 0\*@?"       IDN 3 RG!             ` 0*@R       ;  \ FIMUL m32int
: NOTFOUND   S" 0/@w?"       IDN 4 RG!             ` 0/@wR      ;  \ FIDIV m16int
: NOTFOUND   S" 0/@?"        IDN 3 RG!             ` 0/@R       ;  \ FIDIV m32int

: NOTFOUND   S" @?=0\?"      IDN 1 RG!             ` @R=0?      ;  \ FICOM  m32int
: NOTFOUND   S" @?=0-\?"     IDN 1 RG!             ` @R=0-?     ;  \ FICOMP m32int

: NOTFOUND   S" @?=0-"       IDN 1 RG!             ` @R=0-      ;  \ FSTP m32real
: NOTFOUND   S" @d?=0-"      IDN 2 RG!             ` @dR=0-     ;  \ FSTP m64real
: NOTFOUND   S" @q?=0-"      IDN 2 RG!             ` @qR=0-     ;  \ FSTP m80real

: NOTFOUND   S" 0=@?"        IDN 3 RG!             ` 0=@R       ;  \ FLD  m32real
: NOTFOUND   S" 0=@d?"       IDN 4 RG!             ` 0=@dR      ;  \ FLD  m64real
: NOTFOUND   S" 0=@q?"       IDN 4 RG!             ` 0=@qR      ;  \ FLD  m80real

1 WARNING !
\EOF
\ поиск слова в СПФ
: TST
    RS=T
    D=@P                    \ длина счетчик
    D|D
L2  JZ                      \ если длина ноль - сразу на выход
    S=A                     \ вход в список
    $ 4 D=@P                \ искомое слово в ES:DI
    $ 0xFFFF B=#   $ 3 D=#?
L6  JB
    $ 0xFFFFFFFF B=#
L6: A=@T  $ 8 #A<<  D|A  D&B  $ 0 bA=b#  $ 0xFF A&#
L1  JMP
L3: $ 0xFF  A&#   $ 1 S=@SA
L1: S|S
L2  JZ                      \ конец поиска
    A=@S  A&B   A=D?
L3  JNZ                     \ длины не равны - идем дальше
    S++   DF=0  C^C  bC=bD
    RS=S  RS=T              \ сохраняем адрес начала искомого слова
    Repn  CMPSB  T=RS
L4  JZ
    A=RS                    \ значение esi не интересует в случае неудачи
    S=@SC
L1  JMP
L2: A^A
L5  JMP                     \ выход с "не найдено"
L4: S=RS  S-- A=S           \ передвигаемся от начала строки к NFA
L5: T=RS
;

SEE TST
