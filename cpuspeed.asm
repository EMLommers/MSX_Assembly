; MSX Speed Check
;
; Testing:
; 3.57 Mhz
; 7.13 Mhz
; R800
;
; Result in var CPU:
; 1 = 3.57Mhz
; 2 = R800
; 3 = 7.13Mhz
;
; Free to use
; Code by Ernst M. Lommers
; Date: 22 Jan 2023


        ORG   &HC000
START:

;       LD    A,2             ; Turbo-R only (0=Z80, 1=R800 ROM,2=R800 DRAM)
;       CALL  &H0180

        DI
        LD    A,2
        OUT   (&H99),A
        LD    A,15 OR 128
        OUT   (&H99),A

        LD    HL,0
        LD    (RESULT),HL

LINE:   IN    A,(&H99)
        AND   &H40
        JR    Z,LINE

LINE2:  IN    A,(&H99)
        AND   &H40
        JR    NZ,LINE2

LINE3:  INC   HL
        IN    A,(&H99)
        AND   &H40
        JR    Z,LINE3

        XOR   A
        OUT   (&H99),A
        LD    A,15+128
        OUT   (&H99),A

        LD    (RESULT),HL
        LD    A,L
        RRA
        RRA
        RRA
        RRA
        RRA
        RRA
        AND   7
        LD    (CPU),A
        EI
        RET


RESULT: DW    0
CPU:    DB    0
      RRA
        RRA
        AND   7
        LD    (CPU),A
        EI
        RET


RESULT: DW    0
CPU