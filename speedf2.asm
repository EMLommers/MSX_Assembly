; MSX Speed Check v 0.2
;
; Testing:
; 3.57 Mhz
; 7.13 Mhz
; R800
;
; Result in var CPU:
; 1 = 3.57Mhz
; 2 = 7 Mhz
; 4 = 14.28
;
; Or just (CPU) * 3.57
;
; Free to use
; Code by Ernst M. Lommers
; Date: 22 Jan 2023


        ORG   &HC000
START:
        DI

ROUT:
        XOR   A
        LD    (EMULAT),A

        LD    A,(NTSC)
        AND   &B10000010
        OUT   (&H99),A
        LD    A,9+128
        OUT   (&H99),A

        LD    A,(&H2D)
        CP    3
        JR    NZ,GO
        LD    A,(TURBO)       ; Turbo-R only (0=Z80, 1=R800 ROM,2=R800 DRAM)
        CALL  &H0180

GO:
        DI
        LD    HL,0
        LD    IX,VAR
        LD    A,112 OR 128
        OUT   (&H99),A
        LD    A,1+128
        OUT   (&H99),A


        XOR   A
        OUT   (&H99),A
        LD    A,15 OR 128
        OUT   (&H99),A

        NOP
        NOP
LINE:   IN    A,(&H99)
        AND   &H80
        JR    Z,LINE

LINE2:  IN    A,(&H99)
        AND   &H80
        JR    NZ,LINE2

LINE3:  INC   HL

;       DEFB  0,0,0,0,0       ;NOP = 4 t-states
;       DEFB  0,0,0,0,0
;       INC   DE              ; 6 t-states


        IN    A,(&H99)
        AND   &H80
        JR    Z,LINE3


        LD    (RESULT),HL
        LD    A,H
        INC   A
        RRA
        AND   &B00111111
        LD    (CPU),A


        LD    A,L
        AND   &HFC
        LD    (IX),A
        LD    A,H
        LD    (IX+8),A
        INC   IX


        EI
        LD    A,(RESULT)
        AND   &B00000100
        CP    0
        RET   NZ
        LD    A,1
        LD    (EMULAT),A
        RET
VDP:
        LD    A,(NTSC)
        AND   &B11111110
        XOR   128
        XOR   2
        LD    (NTSC),A
        OUT   (&H99),A
        LD    A,9+128
        OUT   (&H99),A
        RET

NTSC:   DB    0
EMULAT: DB    0
TURBO:  DB    0
RESULT: DW    0
CPU:    DB    0
SHOW:   DB    "------"
VAR:    DS    8
POST:   DB    "------"
















LT: DW    0
CPU:    DB    0
SHOW:   DB    "------"
VAR:    DS    8
POST:   DB    "------"
















