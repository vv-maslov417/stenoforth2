\ stenoforth32

\ Постфиксный целочисленный ассемблер для платформы IA-32(без набора команд расширения ММХ)


0 WARNING !

0 VALUE R1 0 VALUE R2 0 VALUE R3 0 VALUE SM 0 VALUE DT 0 VALUE ADR

\ : I: : IMMEDIATE ;
: ITO CREATE , IMMEDIATE DOES> @ >CS ;

\ регистры общего назначения
\    EAX      ECX      EDX      EBX     ESP     EBP     ESI     EDI
0 ITO EA  1 ITO EC  2 ITO ED  3 ITO EB 4 ITO EX 5 ITO EP 6 ITO ES 7 ITO ET
4 ITO AH 5 ITO CH 6 ITO DH 7 ITO BH

\ регистры MMX
\   MMX0     MMX1     MMX2     MMX3     MMX4     MMX5     MMX6     MMX7
0 ITO M0 1 ITO M1 2 ITO M2 3 ITO M3 4 ITO M4 5 ITO M5 6 ITO M6 7 ITO M7

\ регистры XMM
\   XMM0     XMM1     XMM2     XMM3     XMM4     XMM5     XMM6     XMM7
0 ITO X0 1 ITO X1 2 ITO X2 3 ITO X3 4 ITO X4 5 ITO X5 6 ITO X6 7 ITO X7

I: $ HEX NextWord NUMBER? DROP D>S >CS DECIMAL ;  \ decimal

: 1R  CS>  TO R1 C, ;
: 1R1 CS@ CS> TO R1 TO R2 C, ;
: 2R  CS> CS> TO R1 TO R2 C, ;
: 3R  CS> CS> CS> TO R1 TO R2 TO R3 C, ;
: 2@D CS> CS> TO ADR TO DT C, ;
: 1R@ CS> CS> TO ADR TO R1 C, ;
: 1RD CS> CS> TO DT TO R1 C, ;
: 1rd CS> CS> TO DT TO R1 ;
: 1@R CS> CS> TO R1 TO ADR C, ;   \ ****
: 2RD CS> CS> CS> TO DT TO R1 TO R2 C, ;
: 3RD CS> CS> CS> CS> TO DT TO R1 TO R2 TO R3 C, ;

: SM, ?CS 0= IF  CS> C, THEN ;
: ?P 5 = IF 0x40 ELSE 0x00 THEN ;
: ?X 4 = IF 0x24 C, THEN ;
: RRM  3 LSHIFT OR ;
: RRM! RRM C, ;
: RRL! SWAP RRM C, ;
: RRML! RRM OR C, ;
: RRMR! SWAP RRML! ;
: SIB! RRM C, ;
: ?0SM!    5 = IF ?CS IF 0 ELSE  CS> THEN C, ELSE SM, THEN ;
: ?MD01    ?CS IF ?P ELSE DROP 0x40 THEN ;
: ROR      2R  0xC0     R1 R2 RRMR! ;
: RO@      1R@           5 R1 RRM! ADR ,  ;
: @OR      1R@           5 R1 RRM! ADR ,  ;  \ ******
: ROR1     2R  0xC0     R1 R2 RRML! ;
: RO@R     2R  R2 ?MD01 R1 R2   RRMR! R2 ?X  R2 ?0SM! ;
: RO@R1    1R1 R2 ?MD01 R1 R2   RRMR! R2 ?X  R2 ?0SM! ;
: RO@RR    3R  R2 ?MD01 R1 0x04 RRMR! R2 R3 SIB! R2 ?0SM! ;
: @ROR     2R  R1 ?MD01 R1 R2   RRML! R1 ?X R1 ?0SM! ;
: @RROR    3R  R1 ?MD01 R3 0x04 RRMR! R1 R2 SIB! R1 ?0SM! ;
\ : @RROR1   3R  R1 ?MD01 R3 0x04 RRMR! R1 R2 SIB! R1 ?0SM! ;      \ ********
: @O#      2@D           5 RRL! ADR , DT ,  ;
: @Ow#     2@D           5 RRL! ADR , DT W, ;
: @Ob#     2@D           5 RRL! ADR , DT C, ;
: RO#      1RD 0xC0     R1 ROT  RRML! DT ,  ;
: ROb#     1RD 0xC0     R1 ROT  RRML! DT C, ;
: ROw#     1RD 0xC0     R1 ROT  RRML! DT W, ;
: @RO#     1RD R1 ?MD01 R1 ROT  RRML! R1 ?X R1 ?0SM! DT , ;
: @ROb#    1RD R1 ?MD01 R1 ROT  RRML! R1 ?X R1 ?0SM! DT C, ;
: @ROw#    1RD R1 ?MD01 R1 ROT  RRML! R1 ?X R1 ?0SM! DT W, ;
: @RRO#    2RD R1 ?MD01  4 ROT  RRML! R1 R2 SIB! SM, DT , ;
: @RROb#   2RD R1 ?MD01  4 ROT  RRML! R1 R2 SIB! SM, DT C, ;
: @RROw#   2RD R1 ?MD01  4 ROT  RRML! R1 R2 SIB! SM, DT W, ;
: RO       1R   0xC0    R1 ROT  RRML! ;
: RO1      CS> OR C, ;
: @RO      1R  R1 ?MD01 R1 ROT RRML! R1 ?X R1 ?0SM! ;
: @RRO     2R  R1 ?MD01  4 ROT RRML! R1 R2 SIB! SM, ;
: R=RO#    2RD 0xC0  R1 R2 RRMR! DT , ;
: R=ROw#   2RD 0xC0  R1 R2 RRMR! DT W, ;
: R=ROb#   2RD 0xC0  R1 R2 RRMR! DT C, ;
: R=@RO#   2RD R2 ?MD01 R1 R2 RRMR! R2 ?X R2 ?0SM! DT , ;
: R=@ROw#  2RD R2 ?MD01 R1 R2 RRMR! R2 ?X R2 ?0SM! DT W, ;
: R=@ROb#  2RD R2 ?MD01 R1 R2 RRMR! R2 ?X R2 ?0SM! DT C, ;
: R=@RRO#  3RD R2 ?MD01 R1 0x04 RRMR! R2 R3 SIB! R2 ?0SM! DT , ;
: R=@RROw# 3RD R2 ?MD01 R1 0x04 RRMR! R2 R3 SIB! R2 ?0SM! DT W, ;
: R=@RROb# 3RD R2 ?MD01 R1 0x04 RRMR! R2 R3 SIB! R2 ?0SM! DT C, ;
: Dw,  0x66 C, ;

\ арифметика  ADD ADC SUB SBB MUL IMUL CWD CDQ DIV IDIV INC DEC NEG
I: R+@              0x03 RO@      ; I: wR+@       Dw,         0x03 RO@      ; I: bR+@           0x02 RO@    ;
I: R+R              0x03 ROR      ; I: R+@R                   0x03 RO@R     ; I: R+@RR          0x03 RO@RR  ;
I: wR+wR      Dw,   0x03 ROR      ; I: wR+@wR     Dw,         0x03 RO@R     ; I: wR+@wRR  Dw,   0x03 RO@RR  ;
I: bR+bR            0x02 ROR      ; I: bR+@bR                 0x02 RO@R     ; I: bR+@bRR        0x02 RO@RR  ;
I: @+R              0x01 @OR      ; I: @+wR       Dw,         0x01 @OR      ; I: @+bR           0x00 @OR    ;
I: @R+R             0x01 @ROR     ; I: @RR+R                  0x01 @RROR    ;
I: @wR+wR     Dw,   0x01 @ROR     ; I: @wRR+wR    Dw,         0x01 @RROR    ;
I: @bR+bR           0x00 @ROR     ; I: @bRR+bR                0x00 @RROR    ;
I: @+#            0 0x81 @O#      ; I: @+w#       Dw,       0 0x81 @Ow#     ; I: @+b#         0 0x80 @Ob#   ;
I: R+#            0 0x81 RO#      ; I: @R+#                 0 0x81 @RO#     ; I: @RR+#        0 0x81 @RRO#  ;
I: R+b#           0 0x83 ROb#     ; I: @R+b#                0 0x83 @ROb#    ; I: @RR+b#       0 0x83 @RROb# ;
I: wR+w#      Dw, 0 0x81 ROw#     ; I: @wR+w#     Dw,       0 0x81 @ROw#    ; I: @wRR+w#  Dw, 0 0x81 @RROw# ;
I: wR+b#      Dw, 0 0x83 ROb#     ; I: @wR+b#     Dw,       0 0x83 @ROb#    ; I: @wRR+b#  Dw, 0 0x83 @RROb# ;
I: bR+b#          0 0x80 ROb#     ; I: @bR+b#               0 0x80 @ROb#    ; I: @bRR+b#      0 0x80 @RROb# ;
I: Rc+@             0x13 RO@      ; I: wRc+@      Dw,         0x13 RO@      ; I: bRc+@          0x12 RO@    ;
I: Rc+R             0x13 ROR      ; I: Rc+@R                  0x13 RO@R     ; I: Rc+@RR         0x13 RO@RR  ;
I: wRc+wR     Dw,   0x13 ROR      ; I: wRc+@wR    Dw,         0x13 RO@R     ; I: wRc+@wRR Dw,   0x13 RO@RR  ;
I: bRc+bR           0x12 ROR      ; I: bRc+@bR                0x12 RO@R     ; I: bRc+@bRR       0x12 RO@RR  ;
I: @c+R             0x11 @OR      ; I: @c+wR      Dw,         0x11 @OR      ; I: @c+bR          0x10 @OR    ;
I: @Rc+R            0x11 @ROR     ; I: @RRc+R                 0x11 @RROR    ;
I: @wRc+wR    Dw,   0x11 @ROR     ; I: @wRRc+wR   Dw,         0x11 @RROR    ;
I: @bRc+bR          0x10 @ROR     ; I: @bRRc+bR               0x10 @RROR    ;
I: @c+#           2 0x81 @O#      ; I: @c+w#      Dw,       2 0x81 @Ow#     ; I: @c+b#        2 0x80 @Ob#   ;
I: Rc+#           2 0x81 RO#      ; I: @Rc+#                2 0x81 @RO#     ; I: @RRc+#       2 0x81 @RRO#  ;
I: Rc+b#          2 0x83 ROb#     ; I: @Rc+b#               2 0x83 @ROb#    ; I: @RRc+b#      2 0x83 @RROb# ;
I: wRc+w#     Dw, 2 0x81 ROw#     ; I: @wRc+w#    Dw,       2 0x81 @ROw#    ; I: @wRRc+w# Dw, 2 0x81 @RROw# ;
I: wRc+b#     Dw, 2 0x83 ROb#     ; I: @wRc+b#    Dw,       2 0x83 @ROb#    ; I: @wRRc+b# Dw, 2 0x83 @RROb# ;
I: bRc+b#         2 0x80 ROb#     ; I: @bRc+b#              2 0x80 @ROb#    ; I: @bRRc+b#     2 0x80 @RROb# ;
I: R-@              0x2B RO@      ; I: wR-@       Dw,         0x2B RO@      ; I: bR-@           0x2A RO@    ;
I: R-R              0x2B ROR      ; I: R-@R                   0x2B RO@R     ; I: R-@RR          0x2B RO@RR  ;
I: wR-wR      Dw,   0x2B ROR      ; I: wR-@wR     Dw,         0x2B RO@R     ; I: wR-@wRR  Dw,   0x2B RO@RR  ;
I: bR-bR            0x2A ROR      ; I: bR-@bR                 0x2A RO@R     ; I: bR-@bRR        0x2A RO@RR  ;
I: @-R              0x29 @OR      ; I: @-wR       Dw,         0x29 @OR      ; I: @-bR           0x28 @OR    ;
I: @R-R             0x29 @ROR     ; I: @RR-R                  0x29 @RROR    ;
I: @wR-wR     Dw,   0x29 @ROR     ; I: @wRR-wR    Dw,         0x29 @RROR    ;
I: @bR-bR           0x28 @ROR     ; I: @bRR-bR                0x28 @RROR    ;
I: @-#            5 0x81 @O#      ; I: @-w#       Dw,       5 0x81 @Ow#     ; I: @-b#         5 0x80 @Ob#   ;
I: R-#            5 0x81 RO#      ; I: @R-#                 5 0x81 @RO#     ; I: @RR-#        5 0x81 @RRO#  ;
I: R-b#           5 0x83 ROb#     ; I: @R-b#                5 0x83 @ROb#    ; I: @RR-b#       5 0x83 @RROb# ;
I: wR-w#      Dw, 5 0x81 ROw#     ; I: @wR-w#     Dw,       5 0x81 @ROw#    ; I: @wRR-w#  Dw, 5 0x81 @RROw# ;
I: wR-b#      Dw, 5 0x83 ROb#     ; I: @wR-b#     Dw,       5 0x83 @ROb#    ; I: @wRR-b#  Dw, 5 0x83 @RROb# ;
I: bR-b#          5 0x80 ROb#     ; I: @bR-b#               5 0x80 @ROb#    ; I: @bRR-b#      5 0x80 @RROb# ;
I: Rc-@             0x1B RO@      ; I: wRc-@      Dw,         0x1B RO@      ; I: bRc-@          0x1A RO@    ;
I: Rc-R             0x1B ROR      ; I: Rc-@R                  0x1B RO@R     ; I: Rc-@RR         0x1B RO@RR  ;
I: wRc-wR     Dw,   0x1B ROR      ; I: wRc-@wR    Dw,         0x1B RO@R     ; I: wRc-@wRR Dw,   0x1B RO@RR  ;
I: bRc-bR           0x1A ROR      ; I: bRc-@bR                0x1A RO@R     ; I: bRc-@bRR       0x1A RO@RR  ;
I: @c-R             0x19 @OR      ; I: @c-wR      Dw,         0x19 @OR      ; I: @c-bR          0x18 @OR    ;
I: @Rc-R            0x19 @ROR     ; I: @RRc-R                 0x19 @RROR    ;
I: @wRc-wR    Dw,   0x19 @ROR     ; I: @wRRc-wR   Dw,         0x19 @RROR    ;
I: @bRc-bR          0x18 @ROR     ; I: @bRRc-bR               0x18 @RROR    ;
I: @c-#           3 0x81 @O#      ; I: @c-w#       Dw,      3 0x81 @Ow#     ; I: @c-b#        3 0x80 @Ob#   ;
I: Rc-#           3 0x81 RO#      ; I: @Rc-#                3 0x81 @RO#     ; I: @RRc-#       3 0x81 @RRO#  ;
I: Rc-b#          3 0x83 ROb#     ; I: @Rc-b#               3 0x83 @ROb#    ; I: @RRc-b#      3 0x83 @RROb# ;
I: wRc-w#     Dw, 3 0x81 ROw#     ; I: @wRc-w#    Dw,       3 0x81 @ROw#    ; I: @wRRc-w# Dw, 3 0x81 @RROw# ;
I: wRc-b#     Dw, 3 0x83 ROb#     ; I: @wRc-b#    Dw,       3 0x83 @ROb#    ; I: @wRRc-b# Dw, 3 0x83 @RROb# ;
I: bRc-b#         3 0x80 ROb#     ; I: @bRc-b#              3 0x80 @ROb#    ; I: @bRRc-b#     3 0x80 @RROb# ;
I: CWD              0x98 C,       ; I: CDQ                    0x99 C,       ;
I: *R             5 0xF7 RO       ; I: *@R                  5 0xF7 @RO      ; I: *@RR         5 0xF7 @RRO   ;
I: *wR        Dw, 5 0xF7 RO       ; I: *@wR       Dw,       5 0xF7 @RO      ; I: *@wRR    Dw, 5 0xF7 @RRO   ;
I: *bR            5 0xF6 RO       ; I: *@bR                 5 0xF6 @RO      ; I: *@bRR        5 0xF6 @RRO   ;
I: U*R            4 0xF7 RO       ; I: U*@R                 4 0xF7 @RO      ; I: U*@RR        4 0xF7 @RRO   ;
I: U*wR       Dw, 4 0xF7 RO       ; I: U*@wR      Dw,       4 0xF7 @RO      ; I: U*@wRR   Dw, 4 0xF7 @RRO   ;
I: U*bR           4 0xF6 RO       ; I: U*@bR                4 0xF6 @RO      ; I: U*@bRR       4 0xF6 @RRO   ;
I: -R             3 0xF7 RO       ; I: -@R                  3 0xF7 @RO      ; I: -@RR         3 0xF7 @RRO   ;
I: -wR        Dw, 3 0xF7 RO       ; I: -@wR       Dw,       3 0xF7 @RO      ; I: -@wRR    Dw, 3 0xF7 @RRO   ;
I: -bR            3 0xF6 RO       ; I: -@bR                 3 0xF6 @RO      ; I: -@bRR        3 0xF6 @RRO   ;
I: R--              0x48 RO1      ; I: @R--                 1 0xFF @RO      ; I: @RR--        1 0xFF @RRO   ;
I: wR--       Dw,   0x48 RO1      ; I: @wR--      Dw,       1 0xFF @RO      ; I: @wRR--   Dw, 1 0xFF @RRO   ;
I: bR--           1 0xFE RO       ; I: @bR--                1 0xFE @RO      ; I: @bRR--       1 0xFE @RRO   ;
I: R++              0x40 RO1      ; I: @R++                 0 0xFF @RO      ; I: @RR++        0 0xFF @RRO   ;
I: wR++       Dw,   0x40 RO1      ; I: @wR++      Dw,       0 0xFF @RO      ; I: @wRR++   Dw, 0 0xFF @RRO   ;
I: bR++           0 0xFE RO       ; I: @bR++                0 0xFE @RO      ; I: @bRR++       0 0xFE @RRO   ;
I: Z/R            7 0xF7 RO       ; I: Z/@R                 7 0xF7 @RO      ; I: Z/@RR        7 0xF7 @RRO   ;
I: Z/wR       Dw, 7 0xF7 RO       ; I: Z/@wR       Dw,      7 0xF7 @RO      ; I: Z/@wRR   Dw, 7 0xF7 @RRO   ;
I: Z/bR           7 0xF6 RO       ; I: Z/@bR                7 0xF6 @RO      ; I: Z/@bRR       7 0xF6 @RRO   ;
I: U/R            6 0xF7 RO       ; I: U/@R                 6 0xF7 @RO      ; I: U/@RR        6 0xF7 @RRO   ;
I: U/wR       Dw, 6 0xF7 RO       ; I: U/@wR      Dw,       6 0xF7 @RO      ; I: U/@wRR   Dw, 6 0xF7 @RRO   ;
I: U/bR           6 0xF6 RO       ; I: U/@bR                6 0xF6 @RO      ; I: U/@bRR       6 0xF6 @RRO   ;
I: R*R      0x0F C, 0xAF ROR      ; I: wR*wR      Dw, 0x0F C, 0xAF ROR      ;
I: R*@R     0x0F C, 0xAF RO@R     ; I: wR*@wR     Dw, 0x0F C, 0xAF RO@R     ;
I: R*@RR    0x0F C, 0xAF RO@RR    ; I: wR*@wRR    Dw, 0x0F C, 0xAF RO@RR    ;
I: R=R*#            0x69 R=RO#    ; I: wR=wR*w#   Dw,         0x69 R=ROw#   ;
I: R=R*b#           0x6B R=ROb#   ; I: wR=wR*b#   Dw,         0x6B R=ROb#   ;
I: R=@R*#           0x69 R=@RO#   ; I: wR=@wR*w#  Dw,         0x69 R=@ROw#  ;
I: R=@R*b#          0x6B R=@ROb#  ; I: wR=@wR*b#  Dw,         0x6B R=@ROb#  ;
I: R=@RR*#          0x69 R=@RRO#  ; I: wR=@wRR*w# Dw,         0x69 R=@RROw# ;
I: R=@RR*b#         0x6B R=@RROb# ; I: wR=@wRR*b# Dw,         0x6B R=@RROb# ;

\ логика и сдвиги  AND OR XOR NOT SHL SHR
I: bR&bR        0x22 ROR  ; I: bR&@bR        0x22 RO@R  ; I: bR&@bRR     0x22 RO@RR  ;
I: wR&wR  Dw,   0x23 ROR  ; I: wR&@wR  Dw,   0x23 RO@R  ; I: wR&@wRR Dw, 0x23 RO@RR  ;
I: R&R          0x23 ROR  ; I: R&@R          0x23 RO@R  ; I: R&@RR       0x23 RO@RR  ;
I: @bR&bR       0x20 @ROR ; I: @bRR&bR       0x20 @RROR ;
I: @wR&wR Dw,   0x21 @ROR ; I: @wRR&wR Dw,   0x21 @RROR ;
I: @R&R         0x21 @ROR ; I: @RR&R         0x21 @RROR ;
I: zR&R         0x85 ROR  ;
I: bR|bR        0x0A ROR  ; I: bR|@bR        0x0A RO@R  ; I: bR|@bRR     0x0A RO@RR  ;
I: wR|wR  Dw,   0x0B ROR  ; I: wR|@wR  Dw,   0x0B RO@R  ; I: wR|@wRR Dw, 0x0B RO@RR  ;
I: R|R          0x0B ROR  ; I: R|@R          0x0B RO@R  ; I: R|@RR       0x0B RO@RR  ;
I: @bR|bR       0x08 @ROR ; I: @bRR|bR       0x08 @RROR ;
I: @wR|wR Dw,   0x09 @ROR ; I: @wRR|wR Dw,   0x09 @RROR ;
I: @R|R         0x09 @ROR ; I: @RR|R         0x09 @RROR ;
I: bR^bR        0x32 ROR  ; I: bR^@bR        0x32 RO@R  ; I: bR^@bRR     0x32 RO@RR  ;
I: wR^wR  Dw,   0x33 ROR  ; I: wR^@wR  Dw,   0x33 RO@R  ; I: wR^@wRR Dw, 0x33 RO@RR  ;
I: R^R          0x33 ROR  ; I: R^@R          0x33 RO@R  ; I: R^@RR       0x33 RO@RR  ;
I: @bR^bR       0x30 @ROR ; I: @bRR^bR       0x30 @RROR ; I: R^b#         6 0x83 ROb#   ;
I: @wR^wR Dw,   0x31 @ROR ; I: @wRR^wR Dw,   0x31 @RROR ; I: R|b#         1 0x83 ROb#   ;
I: @R^R         0x31 @ROR ; I: @RR^R         0x31 @RROR ; I: R&b#         4 0x83 ROb#   ; \ ***********
I: bR&b#      4 0x80 ROb# ; I: @bR&b#      4 0x80 @ROb# ; I: @bRR&b#      4 0x80 @RROb# ;
I: wR&w#  Dw, 4 0x81 ROw# ; I: @wR&w#  Dw, 4 0x81 @ROw# ; I: @wRR&w#  Dw, 4 0x81 @RROw# ;
I: R&#        4 0x81 RO#  ; I: @R&#        4 0x81 @RO#  ; I: @RR&#        4 0x81 @RRO#  ;
I: bR|b#      1 0x80 ROb# ; I: @bR|b#      1 0x80 @ROb# ; I: @bRR|b#      1 0x80 @RROb# ;
I: wR|w#  Dw, 1 0x81 ROw# ; I: @wR|w#  Dw, 1 0x81 @ROw# ; I: @wRR|w#  Dw, 1 0x81 @RROw# ;
I: R|#        1 0x81 RO#  ; I: @R|#        1 0x81 @RO#  ; I: @RR|#        1 0x81 @RRO#  ;
I: bR^b#      6 0x80 ROb# ; I: @bR^b#      6 0x80 @ROb# ; I: @bRR^b#      6 0x80 @RROb# ;
I: wR^w#  Dw, 6 0x81 ROw# ; I: @wR^w#  Dw, 6 0x81 @ROw# ; I: @wRR^w#  Dw, 6 0x81 @RROw# ;
I: R^#        6 0x81 RO#  ; I: @R^#        6 0x81 @RO#  ; I: @RR^#        6 0x81 @RRO#  ;
I: bR~        2 0xF6 RO   ; I: @bR~        2 0xF6 @RO   ; I: @bRR~        2 0xF6 @RRO   ;
I: wR~    Dw, 2 0xF7 RO   ; I: @wR~    Dw, 2 0xF7 @RO   ; I: @wRR~    Dw, 2 0xF7 @RRO   ;
I: R~         2 0xF7 RO   ; I: @R~         2 0xF7 @RO   ; I: @RR~         2 0xF7 @RRO   ;
I: bR<<       4 0xD2 RO   ; I: @bR<<       4 0xD2 @RO   ; I: @bRR<<       4 0xD2 @RRO   ;
I: bRc<<      2 0xD2 RO   ; I: @bRc<<      2 0xD2 @RO   ; I: @bRRc<<      2 0xD2 @RRO   ;
I: 1bR<<      4 0xD0 RO   ; I: 1@bR<<      4 0xD0 @RO   ; I: 1@bRR<<      4 0xD0 @RRO   ;
I: 1bRc<<     2 0xD0 RO   ; I: 1@bRc<<     2 0xD0 @RO   ; I: 1@bRRc<<     2 0xD0 @RRO   ;
I: wR<<   Dw, 4 0xD3 RO   ; I: @wR<<   Dw, 4 0xD3 @RO   ; I: @wRR<<   Dw, 4 0xD3 @RRO   ;
I: wRc<<  Dw, 2 0xD3 RO   ; I: @wRc<<  Dw, 2 0xD3 @RO   ; I: @wRRc<<  Dw, 2 0xD3 @RRO   ;
I: 1wR<<  Dw, 4 0xD1 RO   ; I: 1@wR<<  Dw, 4 0xD1 @RO   ; I: 1@wRR<<  Dw, 4 0xD1 @RRO   ;
I: 1wRc<< Dw, 2 0xD1 RO   ; I: 1@wRc<< Dw, 2 0xD1 @RO   ; I: 1@wRRc<< Dw, 2 0xD1 @RRO   ;
I: R<<        4 0xD3 RO   ; I: @R<<        4 0xD3 @RO   ; I: @RR<<        4 0xD3 @RRO   ;
I: Rc<<       2 0xD3 RO   ; I: @Rc<<       2 0xD3 @RO   ; I: @RRc<<       2 0xD3 @RRO   ;
I: 1R<<       4 0xD1 RO   ; I: 1@R<<       4 0xD1 @RO   ; I: 1@RR<<       4 0xD1 @RRO   ;
I: 1Rc<<      2 0xD1 RO   ; I: 1@Rc<<      2 0xD1 @RO   ; I: 1@RRc<<      2 0xD1 @RRO   ;
I: #bR<<      4 0xC0 ROb# ; I: #@bR<<      4 0xC0 @ROb# ; I: #@bRR<<      4 0xC0 @RROb# ;
I: #bRc<<     2 0xC0 ROb# ; I: #@bRc<<     2 0xC0 @ROb# ; I: #@bRRc<<     2 0xC0 @RROb# ;
I: #wR<<  Dw, 4 0xC1 ROb# ; I: #@wR<<  Dw, 4 0xC1 @ROb# ; I: #@wRR<<  Dw, 4 0xC1 @RROb# ;
I: #wRc<< Dw, 2 0xC1 ROb# ; I: #@wRc<< Dw, 2 0xC1 @ROb# ; I: #@wRRc<< Dw, 2 0xC1 @RROb# ;
I: #R<<       4 0xC1 ROb# ; I: #@R<<       4 0xC1 @ROb# ; I: #@RR<<       4 0xC1 @RROb# ;
I: #Ra<<      4 0xC1 ROb# ;
I: #Rc<<      2 0xC1 ROb# ; I: #@Rc<<      2 0xC1 @ROb# ; I: #@RRc<<      2 0xC1 @RROb# ;
I: bR>>       5 0xD2 RO   ; I: @bR>>       5 0xD2 @RO   ; I: @bRR>>       5 0xD2 @RRO   ;
I: bRc>>      3 0xD2 RO   ; I: @bRc>>      3 0xD2 @RO   ; I: @bRRc>>      3 0xD2 @RRO   ;
I: 1bR>>      5 0xD0 RO   ; I: 1@bR>>      5 0xD0 @RO   ; I: 1@bRR>>      5 0xD0 @RRO   ;
I: 1bRc>>     3 0xD0 RO   ; I: 1@bRc>>     3 0xD0 @RO   ; I: 1@bRRc>>     3 0xD0 @RRO   ;
I: wR>>   Dw, 5 0xD3 RO   ; I: @wR>>   Dw, 5 0xD3 @RO   ; I: @wRR>>   Dw, 5 0xD3 @RRO   ;
I: wRc>>  Dw, 3 0xD3 RO   ; I: @wRc>>  Dw, 3 0xD3 @RO   ; I: @wRRc>>  Dw, 3 0xD3 @RRO   ;
I: 1wR>>  Dw, 5 0xD1 RO   ; I: 1@wR>>  Dw, 5 0xD1 @RO   ; I: 1@wRR>>  Dw, 5 0xD1 @RRO   ;
I: 1wRc>> Dw, 3 0xD1 RO   ; I: 1@wRc>> Dw, 3 0xD1 @RO   ; I: 1@wRRc>> Dw, 3 0xD1 @RRO   ;
I: R>>        5 0xD3 RO   ; I: @R>>        5 0xD3 @RO   ; I: @RR>>        5 0xD3 @RRO   ;
I: Rc>>       3 0xD3 RO   ; I: @Rc>>       3 0xD3 @RO   ; I: @RRc>>       3 0xD3 @RRO   ;
I: 1R>>       5 0xD1 RO   ; I: 1@R>>       5 0xD1 @RO   ; I: 1@RR>>       5 0xD1 @RRO   ;
I: 1Rc>>      3 0xD1 RO   ; I: 1@Rc>>      3 0xD1 @RO   ; I: 1@RRc>>      3 0xD1 @RRO   ;
I: #bR>>      5 0xC0 ROb# ; I: #@bR>>      5 0xC0 @ROb# ; I: #@bRR>>      5 0xC0 @RROb# ;
I: #bRc>>     3 0xC0 ROb# ; I: #@bRc>>     3 0xC0 @ROb# ; I: #@bRRc>>     3 0xC0 @RROb# ;
I: #wR>>  Dw, 5 0xC1 ROb# ; I: #@wR>>  Dw, 5 0xC1 @ROb# ; I: #@wRR>>  Dw, 5 0xC1 @RROb# ;
I: #wRc>> Dw, 3 0xC1 ROb# ; I: #@wRc>> Dw, 3 0xC1 @ROb# ; I: #@wRRc>> Dw, 3 0xC1 @RROb# ;
I: #R>>       5 0xC1 ROb# ; I: #@R>>       5 0xC1 @ROb# ; I: #@RR>>       5 0xC1 @RROb# ;
I: #Rc>>      3 0xC1 ROb# ; I: #@Rc>>      3 0xC1 @ROb# ; I: #@RRc>>      3 0xC1 @RROb# ;

I: bRa>>      7 0xD2 RO   ; I: @bRa>>      7 0xD2 @RO   ; I: @bRRa>>      7 0xD2 @RRO   ;
I: 1bRa>>     7 0xD0 RO   ; I: 1@bRa>>     7 0xD0 @RO   ; I: 1@bRRa>>     7 0xD0 @RRO   ;
I: wRa>>  Dw, 7 0xD3 RO   ; I: @wRa>>  Dw, 7 0xD3 @RO   ; I: @wRRa>>  Dw, 7 0xD3 @RRO   ;
I: 1wRa>> Dw, 7 0xD1 RO   ; I: 1@wRa>> Dw, 7 0xD1 @RO   ; I: 1@wRRa>> Dw, 7 0xD1 @RRO   ;
I: Ra>>       7 0xD3 RO   ; I: @Ra>>       7 0xD3 @RO   ; I: @RRa>>       7 0xD3 @RRO   ;
I: 1Ra>>      7 0xD1 RO   ; I: 1@Ra>>      7 0xD1 @RO   ; I: 1@RRa>>      7 0xD1 @RRO   ;
I: #bRa>>     7 0xC0 ROb# ; I: #@bRa>>     7 0xC0 @ROb# ; I: #@bRRa>>     7 0xC0 @RROb# ;
I: #wRa>> Dw, 7 0xC1 ROb# ; I: #@wRa>> Dw, 7 0xC1 @ROb# ; I: #@wRRa>> Dw, 7 0xC1 @RROb# ;
I: #Ra>>      7 0xC1 ROb# ; I: #@Ra>>      7 0xC1 @ROb# ; I: #@RRa>>      7 0xC1 @RROb# ;

I: bRo<<      0 0xD2 RO   ; I: @bRo<<      0 0xD2 @RO   ; I: @bRRo<<      0 0xD2 @RRO   ;
I: 1bRo<<     0 0xD0 RO   ; I: 1@bRo<<     0 0xD0 @RO   ; I: 1@bRRo<<     0 0xD0 @RRO   ;
I: wRo<<  Dw, 0 0xD3 RO   ; I: @wRo<<  Dw, 0 0xD3 @RO   ; I: @wRRo<<  Dw, 0 0xD3 @RRO   ;
I: 1wRo<< Dw, 0 0xD1 RO   ; I: 1@wRo<< Dw, 0 0xD1 @RO   ; I: 1@wRRo<< Dw, 0 0xD1 @RRO   ;
I: Ro<<       0 0xD3 RO   ; I: @Ro<<       0 0xD3 @RO   ; I: @RRo<<       0 0xD3 @RRO   ;
I: 1Ro<<      0 0xD1 RO   ; I: 1@Ro<<      0 0xD1 @RO   ; I: 1@RRo<<      0 0xD1 @RRO   ;
I: #bRo<<     0 0xC0 ROb# ; I: #@bRo<<     0 0xC0 @ROb# ; I: #@bRRo<<     0 0xC0 @RROb# ;
I: #wRo<< Dw, 0 0xC1 ROb# ; I: #@wRo<< Dw, 0 0xC1 @ROb# ; I: #@wRRo<< Dw, 0 0xC1 @RROb# ;
I: #Ro<<      0 0xC1 ROb# ; I: #@Ro<<      0 0xC1 @ROb# ; I: #@RRo<<      0 0xC1 @RROb# ;
I: bRo>>      1 0xD2 RO   ; I: @bRo>>      1 0xD2 @RO   ; I: @bRRo>>      1 0xD2 @RRO   ;
I: 1bRo>>     1 0xD0 RO   ; I: 1@bRo>>     1 0xD0 @RO   ; I: 1@bRRo>>     1 0xD0 @RRO   ;
I: wRo>>  Dw, 1 0xD3 RO   ; I: @wRo>>  Dw, 1 0xD3 @RO   ; I: @wRRo>>  Dw, 1 0xD3 @RRO   ;
I: 1wRo>> Dw, 1 0xD1 RO   ; I: 1@wRo>> Dw, 1 0xD1 @RO   ; I: 1@wRRo>> Dw, 1 0xD1 @RRO   ;
I: Ro>>       1 0xD3 RO   ; I: @Ro>>       1 0xD3 @RO   ; I: @RRo>>       1 0xD3 @RRO   ;
I: 1Ro>>      1 0xD1 RO   ; I: 1@Ro>>      1 0xD1 @RO   ; I: 1@RRo>>      1 0xD1 @RRO   ;
I: #bRo>>     1 0xC0 ROb# ; I: #@bRo>>     1 0xC0 @ROb# ; I: #@bRRo>>     1 0xC0 @RROb# ;
I: #wRo>> Dw, 1 0xC1 ROb# ; I: #@wRo>> Dw, 1 0xC1 @ROb# ; I: #@wRRo>> Dw, 1 0xC1 @RROb# ;
I: #Ro>>      1 0xC1 ROb# ; I: #@Ro>>      1 0xC1 @ROb# ; I: #@RRo>>      1 0xC1 @RROb# ;

\ пересылки   MOVSX MOVZX MOV XCHG LODS MOVS LEA
I: swR=sbR Dw,  0x0F C, 0xBE ROR  ; I: swR=@sbR Dw, 0x0F C, 0xBE RO@R  ; I: swR=@sbRR Dw, 0x0F C, 0xBE RO@RR  ;
I: sR=sbR       0x0F C, 0xBE ROR  ; I: sR=@sbR      0x0F C, 0xBE RO@R  ; I: sR=@sbRR      0x0F C, 0xBE RO@RR  ;
I: sR=swR  Dw,  0x0F C, 0xBF ROR  ; I: sR=@swR  Dw, 0x0F C, 0xBF RO@R  ; I: sR=@swRR  Dw, 0x0F C, 0xBF RO@RR  ;
I: bR=bR                0x8A ROR  ; I: bR=@bR               0x8A RO@R  ; I: bR=@bRR               0x8A RO@RR  ;
I: @bR=bR               0x88 @ROR ; I: @bRR=bR              0x88 @RROR ;
I: @=wR    Dw,          0x89 @OR  ; I: @=bR                 0x88 @OR   ;
I: wR=wR   Dw,          0x8B ROR  ; I: wR=@wR   Dw,         0x8B RO@R  ; I: wR=@wRR   Dw,         0x8B RO@RR  ;
I: @wR=wR  Dw,          0x89 @ROR ; I: @wRR=wR  Dw,         0x89 @RROR ;
I: wR=bR   Dw,  0x0F C, 0xB6 ROR  ; I: wR=@bR   Dw, 0x0F C, 0xB6 RO@R  ; I: wR=@bRR   Dw, 0x0F C, 0xB6 RO@RR  ;
I: R=bR         0x0F C, 0xB6 ROR  ; I: R=@bR        0x0F C, 0xB6 RO@R  ; I: R=@bRR        0x0F C, 0xB6 RO@RR  ;
I: R=wR         0x0F C, 0xB7 ROR  ; I: R=@wR        0x0F C, 0xB7 RO@R  ; I: R=@wRR        0x0F C, 0xB7 RO@RR  ;
I: bR=b#              0 0xC6 ROb# ; I: @bR=b#             0 0xC6 @ROb# ; I: @bRR=b#             0 0xC6 @RROb# ;
I: bRg=b#  1rd 0xB0 R1 + C, DT C, ;
I: wRg=w# Dw, 1rd 0xB8 R1 + C, DT W, ; I: @wR=w#   Dw,       0 0xC7 @ROw# ; I: @wRR=w#   Dw,       0 0xC7 @RROw# ;
I: wR=w#  Dw,         0 0xC7 ROw# ;
I: bR~bR                0x86 ROR  ; I: bR~@bR               0x86 RO@R  ; I: bR~@bRR               0x86 RO@RR  ;
I: @bR~bR               0x86 @ROR ; I: @bRR~bR              0x86 @RROR ;
I: wR~wR   Dw,          0x87 ROR  ; I: wR~@wR   Dw,         0x87 RO@R  ; I: wR~@wRR   Dw,         0x87 RO@RR  ;
I: @wR~wR  Dw,          0x87 @ROR ; I: @wRR~wR  Dw,         0x87 @RROR ;
I: R=@                  0x8B RO@  ; I: wR=@     Dw,         0x8B RO@   ; I: bR=@                  0x8A RO@    ;
I: R=R                  0x8B ROR  ; I: R=@R                 0x8B RO@R  ; I: R=@RR                 0x8B RO@RR  ;
I: @=R                  0x89 @OR  ;
I: @R=R                 0x89 @ROR ; I: @RR=R                0x89 @RROR ;
I: R~R                  0x87 ROR  ; I: R~@R                 0x87 RO@R  ; I: R~@RR                 0x87 RO@RR  ;
I: @R~R                 0x87 @ROR ; I: @RR~R                0x87 @RROR ;
I: R=#                0 0xC7 RO#  ; I: @R=#               0 0xC7 @RO#  ; I: @RR=#               0 0xC7 @RRO#  ;
I: Rg=#               1rd 0xB8 R1 + C, DT , ;
I: @=#                0 0xC7 @O#  ; I: @=w#     Dw,       0 0xC7 @Ow#  ; I: @=b#                0 0xC6 @Ob#   ;
I: LODSb                0xAC C,   ;
I: LODSw   Dw,          0xAD C,   ;
I: LODSd                0xAD C,   ;
I: MOVSb                0xA4 C,   ;
I: MOVSw   Dw,          0xA5 C,   ;
I: MOVSd                0xA5 C,   ;
I: R=aR                 0x8D RO@R ;
I: Ra                   0x8D RO@R1 ;
I: R=aRR                0x8D RO@RR ;
I: R+~R          0x0F C, 0xC1 ROR  ; \ XADD R,R
I: @R+~R         0x0F C, 0xC1 @ROR ; \ XADD @R,R
 

I: MR=R  0x0F C, 0x6E ROR  ;         I: R=MR  0x0F C, 0x7E ROR1 ;
I: MR=@R 0x0F C, 0x6E RO@R ;         I: @R=MR 0x0F C, 0x7E @ROR ;
I: XR=MR 0xF3 C, 0x0F C, 0xD6 ROR ;  I: MR=XR 0xF2 C, 0x0F C, 0xD6 ROR1 ;
I: @=MR  0x0F C, 0x7F @OR  ;         I: MR=@  0x0F C, 0x6F RO@  ;

I: XR=R  0x66 C, 0x0F C, 0x6E ROR  ; I: R=XR  0x66 C, 0x0F C, 0x7E ROR1 ;
I: XR=@R 0x66 C, 0x0F C, 0x6E RO@R ; I: @R=XR 0x66 C, 0x0F C, 0x7E @ROR ;
I: XR=XR 0x0F C, 0x10 ROR ;

\ пересылка невыравненых 8 байтов
I: XR=@  0x0F C, 0x10 RO@  ;         I: @=XR  0x0F C, 0x11 @OR  ;

\ пересылка 8 байтов, выравненых по границе, кратной 16-ти байтам ( д.б. сброшены в 0 4 младших бита адреса)
I: XR=|@ 0x0F C, 0x28 RO@  ;         I: |@=XR 0x0F C, 0x29 @OR  ;

I: Rep  0xF3 C, ; \ ДЛЯ INS OUTS MOVS STOS CMPS SCAS
I: Repn 0xF2 C, ; \ ДЛЯ CMPS SCAS
I: XLAT 0xD7 C, ; \ перекодировка байта в AL из таблицы с адресом в EBX

\ сравнения  CMP CMPS SCAS CMPXCHG  CMPXCHG8B
I: bR=bR?                 0x3A ROR  ; I: bR=@bR?               0x3A RO@R  ; I: bR=@bRR?               0x3A RO@RR  ;
I: @bR=bR?                0x38 @ROR ; I: @bRR=bR?              0x38 @RROR ;
I: wR=wR?   Dw,           0x3B ROR  ; I: wR=@wR?   Dw,         0x3B RO@R  ; I: wR=@wRR?   Dw,         0x3B RO@RR  ;
I: @wR=wR?  Dw,           0x39 @ROR ; I: @wRR=wR?  Dw,         0x39 @RROR ;
I: R=R?                   0x3B ROR  ; I: R=@R?                 0x3B RO@R  ; I: R=@RR?                 0x3B RO@RR  ;
I: @R=R?                  0x39 @ROR ; I: @RR=R?                0x39 @RROR ;
I: bR=b#?               7 0x80 ROb# ; I: @bR=b#?             7 0x80 @ROb# ; I: @bRR=b#?             7 0x80 @RROb# ;
I: wR=w#?   Dw,         7 0x81 ROw# ; I: @wR=w#?   Dw,       7 0x81 @ROw# ; I: @wRR=w#?   Dw,       7 0x81 @RROw# ;
I: wR=b#?   Dw,         7 0x83 ROb# ; I: @wR=b#?   Dw,       7 0x83 @ROb# ; I: @wRR=b#?   Dw,       7 0x83 @RROb# ;
I: R=b#?                7 0x83 ROb# ; I: @R=b#?              7 0x83 @ROb# ; I: @RR=b#?              7 0x83 @RROb#  ;
I: R=#?                 7 0x81 RO#  ; I: @R=#?               7 0x81 @RO#  ; I: @RR=#?               7 0x81 @RRO#  ;
I: CMPSb                  0xA6 C,   ;
I: CMPSw    Dw,           0xA7 C,   ;
I: CMPSd                  0xA7 C,   ;
I: SCASb                  0xAE C,   ;
I: SCASw    Dw,           0xAF C,   ;
I: SCASd                  0xAF C,   ;
I: A=bR?=bR     0x0F C,   0xB0 ROR1 ; I: A=@bR?=bR     0x0F C, 0xB0 @ROR  ; I: A=@bRR?=bR     0x0F C, 0xB0 @RROR  ;
I: A=wR?=wR Dw, 0x0F C,   0xB1 ROR1 ; I: A=@wR?=wR Dw, 0x0F C, 0xB1 @ROR  ; I: A=@wRR?=wR Dw, 0x0F C, 0xB1 @RROR  ;
I: A=R?=R       0x0F C,   0xB1 ROR1 ; I: A=@R?=R       0x0F C, 0xB1 @ROR  ; I: A=@RR?=R       0x0F C, 0xB1 @RROR  ;
I: DA=@R?=CB    0x0F C, 1 0xC7 @RO  ;
I: DA=@RR?=CB   0x0F C, 1 0xC7 @RRO ;

\ команды управления:
\ условные переходы  Jcc

\ реализация механизма многопроходной компиляции определений

\ REQUIRE $!           ~mak\place.f

CREATE XSOURCE 0x101 ALLOT
0 VALUE X>IN
0 VALUE XDP
VARIABLE XFP 0 ,
VARIABLE XCURSTR
0 VALUE XN
0 VALUE $LABEL
CREATE X-L 96 ALLOT
: addrL X-L  + ;      \ адреса меток
: addrX X-L 32 + + ;  \ признаки длин интервалов  от  00000000  до 11111111
: addrC X-L 64 + + ;  \ счетчики меток  от 1 до 8
: lab1  0 addrL ; : lab2  4 addrL ; : lab3  8 addrL ; : lab4 12 addrL ;
: lab5 16 addrL ; : lab6 20 addrL ; : lab7 24 addrL ; : lab8 28 addrL ;
: xln1  0 addrX ; : xln2  4 addrX ; : xln3  8 addrX ; : xln4 12 addrX ;
: xln5 16 addrX ; : xln6 20 addrX ; : xln7 24 addrX ; : xln8 28 addrX ;
: count1  0 addrC ; : count2  4 addrC ; : count3  8 addrC ; : count4 12 addrC ;
: count5 16 addrC ; : count6 20 addrC ; : count7 24 addrC ; : count8 28 addrC ;

: count+ DUP 1+! 1 TO $LABEL ;
I: L1 lab1 @ xln1 count1 count+ ; I: L1: DP @ lab1 ! ; I: L2 lab2 @ xln2 count2 count+ ; I: L2: DP @ lab2 ! ;
I: L3 lab3 @ xln3 count3 count+ ; I: L3: DP @ lab3 ! ; I: L4 lab4 @ xln4 count4 count+ ; I: L4: DP @ lab4 ! ;
I: L5 lab5 @ xln5 count5 count+ ; I: L5: DP @ lab5 ! ; I: L6 lab6 @ xln6 count6 count+ ; I: L6: DP @ lab6 ! ;
I: L7 lab7 @ xln7 count7 count+ ; I: L7: DP @ lab7 ! ; I: L8 lab8 @ xln8 count8 count+ ; I: L8: DP @ lab8 ! ;
: CTL0 count1 0! count2 0! count3 0! count4 0! count5 0! count6 0! count7 0! count8 0! 0 TO $LABEL ; \ обнуление счетчиков числа ссылок на метки

: [begin]
  >IN @ TO X>IN  DP @ TO XDP  SOURCE XSOURCE $!
  SOURCE-ID FILE-POSITION DROP XFP 2! CURSTR @ XCURSTR !
;
: [again]
   XSOURCE COUNT DUP #TIB ! TIB SWAP MOVE
   XCURSTR @ CURSTR ! X>IN  >IN ! XDP DP !
   XFP 2@ SOURCE-ID REPOSITION-FILE DROP
;
\ переопределение слов : и ; под автораспознавание меток
: : : 3 TO XN [begin] ;

\ компиляция без команды RET
: noret  [COMPILE] [ SMUDGE ClearJpBuff 0 TO LAST-NON ;
\ I: -;  CTL0 XN IF XN 1- TO XN [again] EXIT THEN noret ;
: L;  CTL0 XN IF XN 1- TO XN [again] EXIT THEN POSTPONE ; ;
: L-; CTL0 XN IF XN 1- TO XN [again] EXIT THEN noret ;
I: ;  $LABEL IF L;  ELSE POSTPONE ; THEN ;
I: (; $LABEL IF L-; ELSE noret THEN ;
\ TZRS: F-флаг равен 1, f-флаг равен 0, F1|F2-по ИЛИ,f1F2-по И, = - равенство, # - неравенство.

0 VALUE JRCZ
: D-L DROP 2DROP ; \ A-Lab A-Len A-Cnt --
: INT-L!  \ A-Lab A-Len A-Cnt --  признак интервала в метку в бит = порядковому номеру этой метки в опр-ии
  ROT     \ A-Len A-Cnt A-Lab
  DP @ 4 + - ABS 0x7F >
  IF 1 ELSE 0 THEN
          \ A-Len A-Cnt 1/0
  SWAP    \ A-Len 1/0 A-Cnt
  @       \ A-Len 1/0 Cnt
  ROT     \ 1/0 Cnt A-Len
  DUP     \ 1/0 Cnt A-Len A-Len
  @       \ 1/0 Cnt A-Len Len
  2SWAP   \ A-Len Len 1/0 Cnt
  LSHIFT  \ A-Len Len PR[0010.00]
  OR      \ A-Len Len~
  SWAP !
;
: INT-L@  \ A-Lab A-Len A-Cnt COD -- A-Lab COD  1/0  дать интервал для ссылки на метку
  -ROT    \ A-Lab COD   A-Len A-Cnt
  @       \ A-Lab COD   A-Len Cnt
  SWAP    \ A-Lab COD   Cnt   A-Len
  @       \ A-Lab COD   Cnt   Len
  SWAP    \ A-Lab COD   Len   Cnt
  RSHIFT  \ A-Lab COD   PR[0000.01]
  1 AND   \ A-Lab COD   1/0
;
: RAZ-Jcc 0 W, 0 , ;
: COD-Jcc \ A-Lab COD  1/0 --
  IF JRCZ ABORT" REQUIRE Jcc-rel8" 0 TO JRCZ 0x0F C, 0x10 + C, DP @ 4 + - , ELSE C, DP @ 1+ - C, THEN
;
: REL0-Jcc   \ A-Lab A-Len A-Cnt COD --
  DROP D-L RAZ-Jcc
;
: REL1-Jcc
  DROP RAZ-Jcc INT-L!
;
: REL2-Jcc   \ A-Lab A-Len A-Cnt COD --
  INT-L@     \ A-Lab A-Len A-Cnt COD -- A-Lab COD  1/0
  COD-Jcc
;

\ REQUIRE CASE         lib\ext\case.f

: REL-Jcc
XN CASE
3 OF REL0-Jcc ENDOF 2 OF REL1-Jcc ENDOF 1 OF REL2-Jcc ENDOF 0 OF REL2-Jcc ENDOF
ENDCASE
;
: ?JO     0x70 REL-Jcc  ;    I: JO   ?JO     ;
: ?Jo     0x71 REL-Jcc  ;    I: JNO  ?Jo     ;
: ?JC     0x72 REL-Jcc  ;    I: JB   ?JC     ;    I: JC    ?JC     ;   I: JNAE ?JC     ;
: ?Jc     0x73 REL-Jcc  ;    I: JAE  ?Jc     ;    I: JNB   ?Jc     ;   I: JNC  ?Jc     ;
: ?JZ     0x74 REL-Jcc  ;    I: JE   ?JZ     ;    I: JZ    ?JZ     ;   I: J0=  ?JZ     ;  I: J=   ?JZ     ;
: ?Jz     0x75 REL-Jcc  ;    I: JNZ  ?Jz     ;    I: JNE   ?Jz     ;   I: J0<> ?Jz     ;  I: J<>  ?Jz     ;
: ?JC|Z   0x76 REL-Jcc  ;    I: JBE  ?JC|Z   ;    I: JNA   ?JC|Z   ;
: ?Jcz    0x77 REL-Jcc  ;    I: JA   ?Jcz    ;    I: JNNBE ?Jcz    ;
: ?JS     0x78 REL-Jcc  ;    I: JS   ?JS     ;                         I: J0<  ?JS     ;
: ?Js     0x79 REL-Jcc  ;    I: JNS  ?Js     ;                         I: J0>= ?Js     ;
: ?JP     0x7A REL-Jcc  ;    I: JP   ?JP     ;    I: JPE   ?JP     ;
: ?Jp     0x7B REL-Jcc  ;    I: JPO  ?Jp     ;    I: JNP   ?Jp     ;
: ?JS#O   0x7C REL-Jcc  ;    I: JL   ?JS#O   ;    I: JNGE  ?JS#O   ;   I: J<   ?JS#O   ;
: ?JS=O   0x7D REL-Jcc  ;    I: JGE  ?JS=O   ;    I: JNL   ?JS=O   ;                      I: J>=  ?JS=O   ;
: ?JZ|S#O 0x7E REL-Jcc  ;    I: JLE  ?JZ|S#O ;    I: JNG   ?JZ|S#O ;   I: J<=  ?JZ|S#O ;
: ?JzS=O  0x7F REL-Jcc  ;    I: JG   ?JzS=O  ;    I: JNLE  ?JzS=O  ;   I: J>   ?JzS=O  ;
: ?JRCZ   1 TO JRCZ  0xE3 REL-Jcc  ;              I: JCXZ  ?JRCZ   ;   I: JECXZ ?JRCZ  ;

\ безусловные относительные переходы   JMP REL8/REL32
: RAZ-J8/32  0 C, 0 , ;
: COD-J8/32  IF 0xE9 C, DP @ 4 + - , ELSE 0xEB C, DP @ 1+ - C, THEN ;
: RELJ0   D-L  RAZ-J8/32  ;
: RELJ1   RAZ-J8/32  INT-L!  ;
: RELJ2   0 INT-L@ SWAP DROP  COD-J8/32  ;
I: JMP  XN CASE 3 OF RELJ0 ENDOF 2 OF RELJ1 ENDOF 1 OF RELJ2 ENDOF 0 OF RELJ2 ENDOF ENDCASE ;

\ безусловные абсолютные косвенные переходы  типа r32/m32
\ JR, J@R, J@RR - JMP REG, JMP (SM) [REG], JMP (SM) [REG] [REG]
I: JR    4 0xFF RO   ; I: J@R   4 0xFF @RO  ; I: J@RR  4 0xFF @RRO ;

\ команды установки байта по условию   SETcc
: ROS  0x0F C, 0 SWAP RO ; : @ROS  0x0F C, 0 SWAP @RO ; : @RROS  0x0F C, 0 SWAP @RRO ;

: ?R=O       0x90 ROS    ; I: R=O   ?R=O         ;
: ?R=o       0x91 ROS    ; I: R=NO  ?R=o         ;
: ?R=C       0x92 ROS    ; I: R=B   ?R=C         ;  I: R=C    ?R=C         ; I: R=NAE ?R=C      ;
: ?R=c       0x93 ROS    ; I: R=AE  ?R=c         ;  I: R=NB   ?R=c         ; I: R=NC  ?R=c      ;
: ?R=Z       0x94 ROS    ; I: R=E   ?R=Z         ;  I: R=Z    ?R=Z         ;
: ?R=z       0x95 ROS    ; I: R=NZ  ?R=z         ;  I: R=NE   ?R=z         ;
: ?R=C|Z     0x96 ROS    ; I: R=BE  ?R=C|Z       ;  I: R=NA   ?R=C|Z       ;
: ?R=cz      0x97 ROS    ; I: R=A   ?R=cz        ;  I: R=NNBE ?R=cz        ;
: ?R=S       0x98 ROS    ; I: R=S   ?R=S         ;
: ?R=s       0x99 ROS    ; I: R=NS  ?R=s         ;
: ?R=P       0x9A ROS    ; I: R=P   ?R=P         ;  I: R=PE   ?R=P         ;
: ?R=p       0x9B ROS    ; I: R=PO  ?R=p         ;  I: R=NP   ?R=p         ;
: ?R=S#O     0x9C ROS    ; I: R=L   ?R=S#O       ;  I: R=NGE  ?R=S#O       ;
: ?R=S=O     0x9D ROS    ; I: R=GE  ?R=S=O       ;  I: R=NL   ?R=S=O       ;
: ?R=Z|S#O   0x9E ROS    ; I: R=LE  ?R=Z|S#O     ;  I: R=NG   ?R=Z|S#O     ;
: ?R=zS=O    0x9F ROS    ; I: R=G   ?R=zS=O      ;  I: R=NLE  ?R=zS=O      ;

: ?@R=O      0x90 @ROS   ; I: @R=O   ?@R=O       ;
: ?@R=o      0x91 @ROS   ; I: @R=NO  ?@R=o       ;
: ?@R=C      0x92 @ROS   ; I: @R=B   ?@R=C       ;  I: @R=C    ?@R=C       ; I: @R=NAE ?@R=C    ;
: ?@R=c      0x93 @ROS   ; I: @R=AE  ?@R=c       ;  I: @R=NB   ?@R=c       ; I: @R=NC  ?@R=c    ;
: ?@R=Z      0x94 @ROS   ; I: @R=E   ?@R=Z       ;  I: @R=Z    ?@R=Z       ;
: ?@R=z      0x95 @ROS   ; I: @R=NZ  ?@R=z       ;  I: @R=NE   ?@R=z       ;
: ?@R=C|Z    0x96 @ROS   ; I: @R=BE  ?@R=C|Z     ;  I: @R=NA   ?@R=C|Z     ;
: ?@R=cz     0x97 @ROS   ; I: @R=A   ?@R=cz      ;  I: @R=NNBE ?@R=cz      ;
: ?@R=S      0x98 @ROS   ; I: @R=S   ?@R=S       ;
: ?@R=s      0x99 @ROS   ; I: @R=NS  ?@R=s       ;
: ?@R=P      0x9A @ROS   ; I: @R=P   ?@R=P       ;  I: @R=PE   ?@R=P       ;
: ?@R=p      0x9B @ROS   ; I: @R=PO  ?@R=p       ;  I: @R=NP   ?@R=p       ;
: ?@R=S#O    0x9C @ROS   ; I: @R=L   ?@R=S#O     ;  I: @R=NGE  ?@R=S#O     ;
: ?@R=S=O    0x9D @ROS   ; I: @R=GE  ?@R=S=O     ;  I: @R=NL   ?@R=S=O     ;
: ?@R=Z|S#O  0x9E @ROS   ; I: @R=LE  ?@R=Z|S#O   ;  I: @R=NG   ?@R=Z|S#O   ;
: ?@R=zS=O   0x9F @ROS   ; I: @R=G   ?@R=zS=O    ;  I: @R=NLE  ?@R=zS=O    ;

: ?@RR=O     0x90 @RROS  ; I: @RR=O   ?@RR=O     ;
: ?@RR=o     0x91 @RROS  ; I: @RR=NO  ?@RR=o     ;
: ?@RR=C     0x92 @RROS  ; I: @RR=B   ?@RR=C     ;  I: @RR=C    ?@RR=C     ; I: @RR=NAE ?@RR=C  ;
: ?@RR=c     0x93 @RROS  ; I: @RR=AE  ?@RR=c     ;  I: @RR=NB   ?@RR=c     ; I: @RR=NC  ?@RR=c  ;
: ?@RR=Z     0x94 @RROS  ; I: @RR=E   ?@RR=Z     ;  I: @RR=Z    ?@RR=Z     ;
: ?@RR=z     0x95 @RROS  ; I: @RR=NZ  ?@RR=z     ;  I: @RR=NE   ?@RR=z     ;
: ?@RR=C|Z   0x96 @RROS  ; I: @RR=BE  ?@RR=C|Z   ;  I: @RR=NA   ?@RR=C|Z   ;
: ?@RR=cz    0x97 @RROS  ; I: @RR=A   ?@RR=cz    ;  I: @RR=NNBE ?@RR=cz    ;
: ?@RR=S     0x98 @RROS  ; I: @RR=S   ?@RR=S     ;
: ?@RR=s     0x99 @RROS  ; I: @RR=NS  ?@RR=s     ;
: ?@RR=P     0x9A @RROS  ; I: @RR=P   ?@RR=P     ;  I: @RR=PE   ?@RR=P     ;
: ?@RR=p     0x9B @RROS  ; I: @RR=PO  ?@RR=p     ;  I: @RR=NP   ?@RR=p     ;
: ?@RR=S#O   0x9C @RROS  ; I: @RR=L   ?@RR=S#O   ;  I: @RR=NGE  ?@RR=S#O   ;
: ?@RR=S=O   0x9D @RROS  ; I: @RR=GE  ?@RR=S=O   ;  I: @RR=NL   ?@RR=S=O   ;
: ?@RR=Z|S#O 0x9E @RROS  ; I: @RR=LE  ?@RR=Z|S#O ;  I: @RR=NG   ?@RR=Z|S#O ;
: ?@RR=zS=O  0x9F @RROS  ; I: @RR=G   ?@RR=zS=O  ;  I: @RR=NLE  ?@RR=zS=O  ;

\ операции условных пересылок CMOVcc
: ?ROR      0x0F C, ROR ; : ?RO@R      0x0F C, RO@R ;  : ?RO@RR      0x0F C, RO@RR ;
: ?wROR Dw, 0x0F C, ROR ; : ?wRO@R Dw, 0x0F C, RO@R ;  : ?wRO@RR Dw, 0x0F C, RO@RR ;

: w?OR=R       0x40 ?wROR   ; I:  O\wR=R   w?OR=R       ;
: w?oR=R       0x41 ?wROR   ; I: NO\wR=R   w?oR=R       ;
: w?CR=R       0x42 ?wROR   ; I:  B\wR=R   w?CR=R       ; I:    C\wR=R   w?CR=R       ; I: NAE\wR=R   w?CR=R   ;
: w?bR=R       0x43 ?wROR   ; I: AE\wR=R   w?bR=R       ; I:   NB\wR=R   w?bR=R       ; I:  NC\wR=R   w?bR=R   ;
: w?ZR=R       0x44 ?wROR   ; I:  E\wR=R   w?ZR=R       ; I:    Z\wR=R   w?ZR=R       ;
: w?zR=R       0x45 ?wROR   ; I: NZ\wR=R   w?zR=R       ; I:   NE\wR=R   w?zR=R       ;
: w?C|ZR=R     0x46 ?wROR   ; I: BE\wR=R   w?C|ZR=R     ; I:   NA\wR=R   w?C|ZR=R     ;
: w?bzR=R      0x47 ?wROR   ; I:  A\wR=R   w?bzR=R      ; I: NNBE\wR=R   w?bzR=R      ;
: w?SR=R       0x48 ?wROR   ; I:  S\wR=R   w?SR=R       ;
: w?sR=R       0x49 ?wROR   ; I: NS\wR=R   w?sR=R       ;
: w?PR=R       0x4A ?wROR   ; I:  P\wR=R   w?PR=R       ; I:   PE\wR=R   w?PR=R       ;
: w?pR=R       0x4B ?wROR   ; I: PO\wR=R   w?pR=R       ; I:   NP\wR=R   w?pR=R       ;
: w?S#OR=R     0x4C ?wROR   ; I:  L\wR=R   w?S#OR=R     ; I:  NGE\wR=R   w?S#OR=R     ;
: w?S=OR=R     0x4D ?wROR   ; I: GE\wR=R   w?S=OR=R     ; I:   NL\wR=R   w?S=OR=R     ;
: w?Z|S#OR=R   0x4E ?wROR   ; I: LE\wR=R   w?Z|S#OR=R   ; I:   NG\wR=R   w?Z|S#OR=R   ;
: w?zS=OR=R    0x4F ?wROR   ; I:  G\wR=R   w?zS=OR=R    ; I:  NLE\wR=R   w?zS=OR=R    ;

: w?OR=@R      0x40 ?wRO@R  ; I:  O\wR=@R  w?OR=@R      ;
: w?oR=@R      0x41 ?wRO@R  ; I: NO\wR=@R  w?oR=@R      ;
: w?CR=@R      0x42 ?wRO@R  ; I:  B\wR=@R  w?CR=@R      ; I:    C\wR=@R  w?CR=@R      ; I: NAE\wR=@R  w?CR=@R  ;
: w?bR=@R      0x43 ?wRO@R  ; I: AE\wR=@R  w?bR=@R      ; I:   NB\wR=@R  w?bR=@R      ; I:  NC\wR=@R  w?bR=@R  ;
: w?ZR=@R      0x44 ?wRO@R  ; I:  E\wR=@R  w?ZR=@R      ; I:    Z\wR=@R  w?ZR=@R      ;
: w?zR=@R      0x45 ?wRO@R  ; I: NZ\wR=@R  w?zR=@R      ; I:   NE\wR=@R  w?zR=@R      ;
: w?C|ZR=@R    0x46 ?wRO@R  ; I: BE\wR=@R  w?C|ZR=@R    ; I:   NA\wR=@R  w?C|ZR=@R    ;
: w?bzR=@R     0x47 ?wRO@R  ; I:  A\wR=@R  w?bzR=@R     ; I: NNBE\wR=@R  w?bzR=@R     ;
: w?SR=@R      0x48 ?wRO@R  ; I:  S\wR=@R  w?SR=@R      ;
: w?sR=@R      0x49 ?wRO@R  ; I: NS\wR=@R  w?sR=@R      ;
: w?PR=@R      0x4A ?wRO@R  ; I:  P\wR=@R  w?PR=@R      ; I:   PE\wR=@R  w?PR=@R      ;
: w?pR=@R      0x4B ?wRO@R  ; I: PO\wR=@R  w?pR=@R      ; I:   NP\wR=@R  w?pR=@R      ;
: w?S#OR=@R    0x4C ?wRO@R  ; I:  L\wR=@R  w?S#OR=@R    ; I:  NGE\wR=@R  w?S#OR=@R    ;
: w?S=OR=@R    0x4D ?wRO@R  ; I: GE\wR=@R  w?S=OR=@R    ; I:   NL\wR=@R  w?S=OR=@R    ;
: w?Z|S#OR=@R  0x4E ?wRO@R  ; I: LE\wR=@R  w?Z|S#OR=@R  ; I:   NG\wR=@R  w?Z|S#OR=@R  ;
: w?zS=OR=@R   0x4F ?wRO@R  ; I:  G\wR=@R  w?zS=OR=@R   ; I:  NLE\wR=@R  w?zS=OR=@R   ;

: w?OR=@RR     0x40 ?wRO@RR ; I:  O\wR=@RR w?OR=@RR     ;
: w?oR=@RR     0x41 ?wRO@RR ; I: NO\wR=@RR w?oR=@RR     ;
: w?CR=@RR     0x42 ?wRO@RR ; I:  B\wR=@RR w?CR=@RR     ; I:    C\wR=@RR w?CR=@RR     ; I: NAE\wR=@RR w?CR=@RR ;
: w?bR=@RR     0x43 ?wRO@RR ; I: AE\wR=@RR w?bR=@RR     ; I:   NB\wR=@RR w?bR=@RR     ; I:  NC\wR=@RR w?bR=@RR ;
: w?ZR=@RR     0x44 ?wRO@RR ; I:  E\wR=@RR w?ZR=@RR     ; I:    Z\wR=@RR w?ZR=@RR     ;
: w?zR=@RR     0x45 ?wRO@RR ; I: NZ\wR=@RR w?zR=@RR     ; I:   NE\wR=@RR w?zR=@RR     ;
: w?C|ZR=@RR   0x46 ?wRO@RR ; I: BE\wR=@RR w?C|ZR=@RR   ; I:   NA\wR=@RR w?C|ZR=@RR   ;
: w?bzR=@RR    0x47 ?wRO@RR ; I:  A\wR=@RR w?bzR=@RR    ; I: NNBE\wR=@RR w?bzR=@RR    ;
: w?SR=@RR     0x48 ?wRO@RR ; I:  S\wR=@RR w?SR=@RR     ;
: w?sR=@RR     0x49 ?wRO@RR ; I: NS\wR=@RR w?sR=@RR     ;
: w?PR=@RR     0x4A ?wRO@RR ; I:  P\wR=@RR w?PR=@RR     ; I:   PE\wR=@RR w?PR=@RR     ;
: w?pR=@RR     0x4B ?wRO@RR ; I: PO\wR=@RR w?pR=@RR     ; I:   NP\wR=@RR w?pR=@RR     ;
: w?S#OR=@RR   0x4C ?wRO@RR ; I:  L\wR=@RR w?S#OR=@RR   ; I:  NGE\wR=@RR w?S#OR=@RR   ;
: w?S=OR=@RR   0x4D ?wRO@RR ; I: GE\wR=@RR w?S=OR=@RR   ; I:   NL\wR=@RR w?S=OR=@RR   ;
: w?Z|S#OR=@RR 0x4E ?wRO@RR ; I: LE\wR=@RR w?Z|S#OR=@RR ; I:   NG\wR=@RR w?Z|S#OR=@RR ;
: w?zS=OR=@RR  0x4F ?wRO@RR ; I:  G\wR=@RR w?zS=OR=@RR  ; I:  NLE\wR=@RR w?zS=OR=@RR  ;

: ?OR=R        0x40 ?ROR    ; I:  O\R=R   ?OR=R         ;
: ?oR=R        0x41 ?ROR    ; I: NO\R=R   ?oR=R         ;
: ?CR=R        0x42 ?ROR    ; I:  B\R=R   ?CR=R         ; I:    C\R=R   ?CR=R         ; I: NAE\R=R   ?CR=R     ;
: ?bR=R        0x43 ?ROR    ; I: AE\R=R   ?bR=R         ; I:   NB\R=R   ?bR=R         ; I:  NC\R=R   ?bR=R     ;
: ?ZR=R        0x44 ?ROR    ; I:  E\R=R   ?ZR=R         ; I:    Z\R=R   ?ZR=R         ;
: ?zR=R        0x45 ?ROR    ; I: NZ\R=R   ?zR=R         ; I:   NE\R=R   ?zR=R         ;
: ?C|ZR=R      0x46 ?ROR    ; I: BE\R=R   ?C|ZR=R       ; I:   NA\R=R   ?C|ZR=R       ;
: ?bzR=R       0x47 ?ROR    ; I:  A\R=R   ?bzR=R        ; I: NNBE\R=R   ?bzR=R        ;
: ?SR=R        0x48 ?ROR    ; I:  S\R=R   ?SR=R         ;
: ?sR=R        0x49 ?ROR    ; I: NS\R=R   ?sR=R         ;
: ?PR=R        0x4A ?ROR    ; I:  P\R=R   ?PR=R         ; I:   PE\R=R   ?PR=R         ;
: ?pR=R        0x4B ?ROR    ; I: PO\R=R   ?pR=R         ; I:   NP\R=R   ?pR=R         ;
: ?S#OR=R      0x4C ?ROR    ; I:  L\R=R   ?S#OR=R       ; I:  NGE\R=R   ?S#OR=R       ;
: ?S=OR=R      0x4D ?ROR    ; I: GE\R=R   ?S=OR=R       ; I:   NL\R=R   ?S=OR=R       ;
: ?Z|S#OR=R    0x4E ?ROR    ; I: LE\R=R   ?Z|S#OR=R     ; I:   NG\R=R   ?Z|S#OR=R     ;
: ?zS=OR=R     0x4F ?ROR    ; I:  G\R=R   ?zS=OR=R      ; I:  NLE\R=R   ?zS=OR=R      ;

: ?OR=@R       0x40 ?RO@R   ; I:  O\R=@R  ?OR=@R        ;
: ?oR=@R       0x41 ?RO@R   ; I: NO\R=@R  ?oR=@R        ;
: ?CR=@R       0x42 ?RO@R   ; I:  B\R=@R  ?CR=@R        ; I:    C\R=@R  ?CR=@R        ; I: NAE\R=@R  ?CR=@R    ;
: ?bR=@R       0x43 ?RO@R   ; I: AE\R=@R  ?bR=@R        ; I:   NB\R=@R  ?bR=@R        ; I:  NC\R=@R  ?bR=@R    ;
: ?ZR=@R       0x44 ?RO@R   ; I:  E\R=@R  ?ZR=@R        ; I:    Z\R=@R  ?ZR=@R        ;
: ?zR=@R       0x45 ?RO@R   ; I: NZ\R=@R  ?zR=@R        ; I:   NE\R=@R  ?zR=@R        ;
: ?C|ZR=@R     0x46 ?RO@R   ; I: BE\R=@R  ?C|ZR=@R      ; I:   NA\R=@R  ?C|ZR=@R      ;
: ?bzR=@R      0x47 ?RO@R   ; I:  A\R=@R  ?bzR=@R       ; I: NNBE\R=@R  ?bzR=@R       ;
: ?SR=@R       0x48 ?RO@R   ; I:  S\R=@R  ?SR=@R        ;
: ?sR=@R       0x49 ?RO@R   ; I: NS\R=@R  ?sR=@R        ;
: ?PR=@R       0x4A ?RO@R   ; I:  P\R=@R  ?PR=@R        ; I:   PE\R=@R  ?PR=@R        ;
: ?pR=@R       0x4B ?RO@R   ; I: PO\R=@R  ?pR=@R        ; I:   NP\R=@R  ?pR=@R        ;
: ?S#OR=@R     0x4C ?RO@R   ; I:  L\R=@R  ?S#OR=@R      ; I:  NGE\R=@R  ?S#OR=@R      ;
: ?S=OR=@R     0x4D ?RO@R   ; I: GE\R=@R  ?S=OR=@R      ; I:   NL\R=@R  ?S=OR=@R      ;
: ?Z|S#OR=@R   0x4E ?RO@R   ; I: LE\R=@R  ?Z|S#OR=@R    ; I:   NG\R=@R  ?Z|S#OR=@R    ;
: ?zS=OR=@R    0x4F ?RO@R   ; I:  G\R=@R  ?zS=OR=@R     ; I:  NLE\R=@R  ?zS=OR=@R     ;

: ?OR=@RR      0x40 ?RO@RR  ; I:  O\R=@RR ?OR=@RR       ;
: ?oR=@RR      0x41 ?RO@RR  ; I: NO\R=@RR ?oR=@RR       ;
: ?CR=@RR      0x42 ?RO@RR  ; I:  B\R=@RR ?CR=@RR       ; I:    C\R=@RR ?CR=@RR       ; I: NAE\R=@RR ?CR=@RR   ;
: ?bR=@RR      0x43 ?RO@RR  ; I: AE\R=@RR ?bR=@RR       ; I:   NB\R=@RR ?bR=@RR       ; I:  NC\R=@RR ?bR=@RR   ;
: ?ZR=@RR      0x44 ?RO@RR  ; I:  E\R=@RR ?ZR=@RR       ; I:    Z\R=@RR ?ZR=@RR       ;
: ?zR=@RR      0x45 ?RO@RR  ; I: NZ\R=@RR ?zR=@RR       ; I:   NE\R=@RR ?zR=@RR       ;
: ?C|ZR=@RR    0x46 ?RO@RR  ; I: BE\R=@RR ?C|ZR=@RR     ; I:   NA\R=@RR ?C|ZR=@RR     ;
: ?bzR=@RR     0x47 ?RO@RR  ; I:  A\R=@RR ?bzR=@RR      ; I: NNBE\R=@RR ?bzR=@RR      ;
: ?SR=@RR      0x48 ?RO@RR  ; I:  S\R=@RR ?SR=@RR       ;
: ?sR=@RR      0x49 ?RO@RR  ; I: NS\R=@RR ?sR=@RR       ;
: ?PR=@RR      0x4A ?RO@RR  ; I:  P\R=@RR ?PR=@RR       ; I:   PE\R=@RR ?PR=@RR       ;
: ?pR=@RR      0x4B ?RO@RR  ; I: PO\R=@RR ?pR=@RR       ; I:   NP\R=@RR ?pR=@RR       ;
: ?S#OR=@RR    0x4C ?RO@RR  ; I:  L\R=@RR ?S#OR=@RR     ; I:  NGE\R=@RR ?S#OR=@RR     ;
: ?S=OR=@RR    0x4D ?RO@RR  ; I: GE\R=@RR ?S=OR=@RR     ; I:   NL\R=@RR ?S=OR=@RR     ;
: ?Z|S#OR=@RR  0x4E ?RO@RR  ; I: LE\R=@RR ?Z|S#OR=@RR   ; I:   NG\R=@RR ?Z|S#OR=@RR   ;
: ?zS=OR=@RR   0x4F ?RO@RR  ; I:  G\R=@RR ?zS=OR=@RR    ; I:  NLE\R=@RR ?zS=OR=@RR    ;

\ операция получения информации о процессоре
I: CPUID 0x0F C, 0xA2 C, ;

\ операции с битами BSF BSR BT BTC BTR BTS
\ BSF
I: wR=L\wR  Dw, 0x0F C, 0xBC ROR    ; I: wR=L\@wR  Dw, 0x0F C, 0xBC RO@R    ; I: wR=L\@wRR  Dw, 0x0F C, 0xBC RO@RR    ;
I: R=L\R        0x0F C, 0xBC ROR    ; I: R=L\@R        0x0F C, 0xBC RO@R    ; I: R=L\@RR        0x0F C, 0xBC RO@RR    ;
\ BSR
I: wR=H\wR  Dw, 0x0F C, 0xBD ROR    ; I: wR=H\@wR  Dw, 0x0F C, 0xBD RO@R    ; I: wR=H\@wRR  Dw, 0x0F C, 0xBD RO@RR    ;
I: R=H\R        0x0F C, 0xBD ROR    ; I: R=H\@R        0x0F C, 0xBD RO@R    ; I: R=H\@RR        0x0F C, 0xBD RO@RR    ;
\ BT
I: C=R\wR   Dw, 0x0F C, 0xA3 ROR    ; I: C=R\@wR   Dw, 0x0F C, 0xA3 RO@R    ; I: C=R\@wRR   Dw, 0x0F C, 0xA3 RO@RR    ;
I: C=R\R        0x0F C, 0xA3 ROR    ; I: C=R\@R        0x0F C, 0xA3 RO@R    ; I: C=R\@RR        0x0F C, 0xA3 RO@RR    ;
I: C=b#\wR  Dw, 0x0F C, 4 0xBA ROb# ; I: C=b#\@wR  Dw, 0x0F C, 4 0xBA @ROb# ; I: C=b#\@wRR  Dw, 0x0F C, 4 0xBA @RROb# ;
I: C=b#\R       0x0F C, 4 0xBA ROb# ; I: C=b#\@R       0x0F C, 4 0xBA @ROb# ; I: C=b#\@RR       0x0F C, 4 0xBA @RROb# ;
\ BTC
I: C=R\wR~  Dw, 0x0F C, 0xBB ROR    ; I: C=R\@wR~  Dw, 0x0F C, 0xBB RO@R    ; I: C=R\@wRR~  Dw, 0x0F C, 0xBB RO@RR    ;
I: C=R\R~       0x0F C, 0xBB ROR    ; I: C=R\@R~       0x0F C, 0xBB RO@R    ; I: C=R\@RR~       0x0F C, 0xBB RO@RR    ;
I: C=b#\wR~ Dw, 0x0F C, 7 0xBA ROb# ; I: C=b#\@wR~ Dw, 0x0F C, 7 0xBA @ROb# ; I: C=b#\@wRR~ Dw, 0x0F C, 7 0xBA @RROb# ;
I: C=b#\R~      0x0F C, 7 0xBA ROb# ; I: C=b#\@R~      0x0F C, 7 0xBA @ROb# ; I: C=b#\@RR~      0x0F C, 7 0xBA @RROb# ;
\ BTR
I: C=R\wR0  Dw, 0x0F C, 0xB3 ROR    ; I: C=R\@wR0  Dw, 0x0F C, 0xB3 RO@R    ; I: C=R\@wRR0  Dw, 0x0F C, 0xB3 RO@RR    ;
I: C=R\R0       0x0F C, 0xB3 ROR    ; I: C=R\@R0       0x0F C, 0xB3 RO@R    ; I: C=R\@RR0       0x0F C, 0xB3 RO@RR    ;
I: C=b#\wR0 Dw, 0x0F C, 6 0xBA ROb# ; I: C=b#\@wR0 Dw, 0x0F C, 6 0xBA @ROb# ; I: C=b#\@wRR0 Dw, 0x0F C, 6 0xBA @RROb# ;
I: C=b#\R0      0x0F C, 6 0xBA ROb# ; I: C=b#\@R0      0x0F C, 6 0xBA @ROb# ; I: C=b#\@RR0      0x0F C, 6 0xBA @RROb# ;
\ BTS
I: C=R\wR1  Dw, 0x0F C, 0xAB ROR    ; I: C=R\@wR1  Dw, 0x0F C, 0xAB RO@R    ; I: C=R\@wRR1  Dw, 0x0F C, 0xAB RO@RR    ;
I: C=R\R1       0x0F C, 0xAB ROR    ; I: C=R\@R1       0x0F C, 0xAB RO@R    ; I: C=R\@RR1       0x0F C, 0xAB RO@RR    ;
I: C=b#\wR1 Dw, 0x0F C, 5 0xBA ROb# ; I: C=b#\@wR1 Dw, 0x0F C, 5 0xBA @ROb# ; I: C=b#\@wRR1 Dw, 0x0F C, 5 0xBA @RROb# ;
I: C=b#\R1      0x0F C, 5 0xBA ROb# ; I: C=b#\@R1      0x0F C, 5 0xBA @ROb# ; I: C=b#\@RR1      0x0F C, 5 0xBA @RROb# ;

\ операции коррекции результатов ар. команд:  AAA  AAD  AAM  AAS  DAA  DAS
I: AAA 0x37 C, ;
I: AAD 0xD5 C, 0x0A C, ;
I: AAM 0xD4 C, 0x0A C, ;
I: AAS 0x3F C, ;
I: DAA 0x27 C, ;
I: DAS 0x2F C, ;

\ операции загрузки селекторов: LDS LES LFS LGS LSS
I: DS:wR=@wR Dw,         0xC5 RO@R ; I: DS:wR=@wRR  Dw,         0xC5 RO@RR ;
I: DS:R=@R               0xC5 RO@R ; I: DS:R=@RR                0xC5 RO@RR ;

I: ES:wR=@wR Dw,         0xC4 RO@R ; I: ES:wR=@wRR  Dw,         0xC4 RO@RR ;
I: ES:R=@R               0xC4 RO@R ; I: ES:R=@RR                0xC4 RO@RR ;

I: FS:wR=@wR Dw, 0x0F C, 0xB4 RO@R ; I: FS:wR=@wRR  Dw, 0x0F C, 0xB4 RO@RR ;
I: FS:R=@R       0x0F C, 0xB4 RO@R ; I: FS:R=@RR        0x0F C, 0xB4 RO@RR ;

I: GS:wR=@wR Dw, 0x0F C, 0xB5 RO@R ; I: GS:wR=@wRR  Dw, 0x0F C, 0xB5 RO@RR ;
I: GS:R=@R       0x0F C, 0xB5 RO@R ; I: GS:R=@RR        0x0F C, 0xB5 RO@RR ;

I: SS:wR=@wR Dw, 0x0F C, 0xB2 RO@R ; I: SS:wR=@wRR  Dw, 0x0F C, 0xB2 RO@RR ;
I: SS:R=@R       0x0F C, 0xB2 RO@R ; I: SS:R=@RR        0x0F C, 0xB2 RO@RR ;

\ ввод-вывод значений и строк  IN INSB INSW INSD   OUT OUTSB OUTSW OUTSD
\ IN
I: bA=Pb#     CS> 0xE4 C, C, ;
I: wA=Pb# Dw, CS> 0xE5 C, C, ;
I:  A=Pb#     CS> 0xE5 C, C, ;
I: bA=PwD         0xEC C,    ;
I: wA=PwD Dw,     0xED C,    ;
I:  A=PwD         0xED C,    ;
\ INSB INSW INSD
I: INSB           0x6C C,    ;
I: INSW   Dw,     0x6D C,    ;
I: INSD           0x6D C,    ;
\ OUT
I: P#b=bA     CS> 0xE6 C, C, ;
I: P#b=wA Dw, CS> 0xE7 C, C, ;
I: P#b=A      CS> 0xE7 C, C, ;
I: PwD=bA         0xEE C,    ;
I: PwD=wA Dw,     0xEF C,    ;
I: PwD=A          0xEF C,    ;
\ OUTSB OUTSW OUTSD
I: OUTSB          0x6E C,    ;
I: OUTSW  Dw,     0x6F C,    ;
I: OUTSD          0x6F C,    ;

\ операции со стеком: PUSH PUSHA PUSHAD PUSHF PUSHFD POP  POPA  POPAD  POPF  POPFD
\ PUSH PUSHA PUSHAD PUSHF PUSHFD
I: RS=wR    Dw,   0x50 RO1   ; I: RS=R           0x50 RO1   ;
I: RS=@wR   Dw, 6 0xFF @RO   ; I: RS=@R        6 0xFF @RO   ; I: RS=@wRR Dw, 6 0xFF @RRO ; I: RS=@RR 6 0xFF @RRO ;
I: RS=b#    CS>   0x6A C, C, ; I: RS=w#  Dw, CS> 0x68 C, W, ; I: RS=#    CS>   0x68 C, , ;
I: RS=CS          0x0E C,    ; I: RS=SS          0x16 C,    ; I: RS=DS         0x1E C,   ; I: RS=ES    0x06 C,   ;
I: RS=FS  0x0F C, 0xA0 C,    ; I: RS=GS  0x0F C, 0xA8 C,    ;
I: PUSHA    Dw,   0x60 C,    ; I: PUSHAD         0x60 C,    ; I: PUSHF   Dw,   0x9C C,   ; I: PUSHFD   0x9C C,   ;
                              ( I: f{             0x60 C,    ; )
\ POP  POPA  POPAD  POPF  POPFD
I: @wR=RS   Dw, 0 0x8F @RO   ; I: @R=RS        0 0x8F @RO   ; I: @wRR=RS Dw, 0 0x8F @RRO ; I: @RR=RS 0 0x8F @RRO ;
I: wR=RS    Dw,   0x58 RO1   ; I: R=RS           0x58 RO1   ;
I: SS=RS          0x17 C,    ; I: DS=RS          0x1F C,    ; I: ES=RS         0x07 C,   ;
I: FS=RS  0x0F C, 0xA1 C,    ; I: GS=RS  0x0F C, 0xA9 C,    ;
I: POPA     Dw,   0x61 C,    ; I: POPAD          0x61 C,    ; I: POPF    Dw,   0x9D C,   ; I: POPFD    0x9D C,   ;
                             (  I: }f             0x61 C,    ; )

\ операции изменения разрядности путем расширения знака CBW CWDE CWD CDQ
I: wA=bA 0x98 C, ; I: A=wA Dw, 0x98 C, ; I: wDA=wA Dw, 0x99 C, ; I: DA=A 0x99 C, ;

\ операции над флагами LAHF SAHF CLC STC CMC CLD STD
I: AH=F 0x9F C, ; I: F=AH 0x9E C, ; I: CF=0 0xF8 C, ; I: CF=1 0xF9 C, ;
I: CF~  0xF5 C, ; I: DF=0 0xFC C, ; I: DF=1 0xFD C, ;

\ обработка прерываний INT INT0 INT3 IRET CLI STI
I: INT   CS> 0xCD C, C, ;
I: INT0      0xCE C,    ;
I: INT3      0xCC C,    ;
I: IRET  Dw, 0xCF C,    ;
I: IRETD     0xCF C,    ;
I: IF=0      0xFA C,    ;
I: IF=1      0xFB C,    ;

\ команды чтения 64-разрядного счетчика меток реального времени  RDTSC и RDTSCP
I: DA=TSC   0x0F C, 0x31 C, ;
\ сброс конвейера, в рег. EDX(hi) EAX(lo) состояние TSC, в рег. ECX номер лог. проц-ра
I: DAC=TSCP 0x0F C, 0x1 C, 0xF9 C, ;
\ пересылки - системный вариант
\ системные регистры
0 ITO CR0 2 ITO CR2 3 ITO CR3 4 ITO CR4
\ отладочные регистры
0 ITO DR0 1 ITO DR1 2 ITO DR2 3 ITO DR3 6 ITO DR6 7 ITO DR7

I: R=CR 0x0F C, 0x20 ROR1 ;
I: CR=R 0x0F C, 0x22 ROR  ;
I: R=DR 0x0F C, 0x21 ROR1 ;
I: DR=R 0x0F C, 0x23 ROR  ;

\ команды защиты памяти SGDT SIDT STR LGDT LIDT LTR CLTS ARPL LAR LSL VERR VERRW LMSW SMSW
I: @RR=GDTR        0x0F C, 0 0x01 @RRO  ;  \ LGDT
I: @RR=IDTR        0x0F C, 1 0x01 @RRO  ;  \ LIDT
I: GDTR=@RR        0x0F C, 2 0x01 @RRO  ;  \ LGDT
I: IDTR=@RR        0x0F C, 3 0x01 @RRO  ;  \ LIDT
I: R=TR            0x0F C, 1 0x00 RO    ;  \ STR
I: @R=TR           0x0F C, 1 0x00 @RO   ;
I: @wR=TR      Dw, 0x0F C, 1 0x00 @RO   ;
I: @RR=TR          0x0F C, 1 0x00 @RRO  ;
I: @wRR=TR     Dw, 0x0F C, 1 0x00 @RRO  ;
I: TR=R            0x0F C, 3 0x00 RO    ;  \ LTR
I: TR=@R           0x0F C, 3 0x00 @RO   ;
I: TR=@wR      Dw, 0x0F C, 3 0x00 @RO   ;
I: TR=@RR          0x0F C, 3 0x00 @RRO  ;
I: TR=@wRR     Dw, 0x0F C, 3 0x00 @RRO  ;
I: TS=0            0x0F C,   0x06 C,    ;  \ CLTS
I: ?PsR=PdR                  0x63 ROR1  ;  \ ARPL  dR   sR
I: ?PsR=Pd@R                 0x63 @ROR  ;  \ ARPL  d@R  sR
I: ?PsR=Pd@RR                0x63 @RROR ;  \ ARPL  d@RR sR
I: wR=wR[AR]   Dw, 0x0F C,   0x02 ROR   ;  \ LAR
I: R=R[AR]         0x0F C,   0x02 ROR   ;
I: wR=w@R[AR]  Dw, 0x0F C,   0x02 RO@R  ;
I: R=@R[AR]        0x0F C,   0x02 RO@R  ;
I: wR=w@RR[AR] Dw, 0x0F C,   0x02 RO@RR ;
I: R=@RR[AR]       0x0F C,   0x02 RO@RR ;
I: wR=wR[SL]   Dw, 0x0F C,   0x03 ROR   ;  \ LSL
I: R=R[SL]         0x0F C,   0x03 ROR   ;
I: wR=w@R[SL]  Dw, 0x0F C,   0x03 RO@R  ;
I: R=@R[SL]        0x0F C,   0x03 RO@R  ;
I: wR=w@RR[SL] Dw, 0x0F C,   0x03 RO@RR ;
I: R=@RR[SL]       0x0F C,   0x03 RO@RR ;
I: R[SG]r          0x0F C, 4 0x00 RO    ;  \ VERR
I: @R[SG]r         0x0F C, 4 0x00 @RO   ;
I: @RR[SG]r        0x0F C, 4 0x00 @RRO  ;
I: R[SG]w          0x0F C, 5 0x00 RO    ;  \ VERW
I: @R[SG]w         0x0F C, 5 0x00 @RO   ;
I: @RR[SG]w        0x0F C, 5 0x00 @RRO  ;

\ BOUND
I: wR<>@wR\i5  Dw, 0x62 RO@R  ;   I: wR<>@wRR\i5 Dw, 0x62 RO@RR  ;
I: R<>@R\i5        0x62 RO@R  ;   I: R<>@RR\i5       0x62 RO@RR  ;

I: R0123    0x0F C, 0xC8 RO1 ;  \ BSWAP
I: HLT              0xF4 C,  ;  \ HLT
I: WAIT             0x9B C,  ;  \ WAIT
I: NOP              0x90 C,  ;  \ NOP
I: RDMSR    0x0F C, 0x32 C,  ;  \ RDMSR
I: WRMSR    0x0F C, 0x30 C,  ;  \ WRMSR
I: RDPMC    0x0F C, 0x33 C,  ;  \ RDPMC
I: RSM      0x0F C, 0xAA C,  ;  \ RSM
I: SYSENTER 0x0F C, 0x34 C,  ;  \ SYSENTER
I: SYSEXIT  0x0F C, 0x35 C,  ;  \ SYSEXIT
I: UD2      0x0F C, 0x0B C,  ;  \ UD2

\ ВОЗВРАТ ИЗ ПОДПРОГРАММ
I: ret      0xC3 C, ;
: ret,      0xC3 C, ;

\ ВЫЗОВЫ ПОДПРОГРАММ
I: :@  CS> 0xE8 C, DP @ 4 + - , ;  \ CALL REL32
:  :@, CS> 0xE8 C, DP @ 4 + - , ;  \ CALL ADDR
I: :R      0xFF C, 0xD0 RO1     ;  \ CALL R

\ ИНСТРУКЦИИ СОПРОЦЕССОРА
I: 0=@wR  0 0xDF @RO ; \ FILD m16int
I: 0=@R   0 0xDB @RO ; \ FILD m32int
I: 0=@dR  5 0xDF @RO ; \ FILD m64int

I: @wR=0  2 0xDF @RO ; \ FIST m16int
I: @R=0   2 0xDB @RO ; \ FIST m32int
I: @wR=0- 3 0xDF @RO ; \ FISTP m16int
I: @R=0-  3 0xDB @RO ; \ FISTP m32int
I: @dR=0- 7 0xDF @RO ; \ FISTP m64int

I: 0+@wR  0 0xDE @RO ; \ FIADD m16int
I: 0+@R   0 0xDA @RO ; \ FIADD m32int
I: 0-@wR  4 0xDE @RO ; \ FISUB m16int
I: 0-@R   4 0xDA @RO ; \ FISUB m32int
I: 0*@wR  1 0xDE @RO ; \ FIMUL m16int
I: 0*@R   1 0xDA @RO ; \ FIMUL m32int
I: 0/@wR  6 0xDE @RO ; \ FIDIV m16int
I: 0/@R   6 0xDA @RO ; \ FIDIV m32int

I: @R=0?  2 0xDA @RO ; \ FICOM m32int
I: @R=0-? 3 0xDA @RO ; \ FICOMP m32int
I: @R=0-  3 0xD9 @RO ; \ FSTP m32real
I: @dR=0- 3 0xDD @RO ; \ FSTP m64real
I: @qR=0- 7 0xDB @RO ; \ FSTP m80real
I: 0=@R   0 0xD9 @RO ; \ FLD  m32real
I: 0=@dR  0 0xDD @RO ; \ FLD  m64real
I: 0=@qR  5 0xDB @RO ; \ FLD  m80real

I: wA=CWR 0x9B C, 0xDF C, 0xE0 C, ; \ FSTSW AX

I: 0SQRT  0xD9 C, 0xFA C, ; \ FSQRT
