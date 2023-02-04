; MSX Speed Check v 0.4
;
; Testing:
; 3.57 Mhz
; 7.13 Mhz
; R800
; Emulation
;
; Testing running in emulator
; How to: checking missing F flag in status register 0
; couple of times, subtract min from max
;
; WIP / only fixing subtraction TBD
;
; 
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
        IM    0
        DI



        LD    HL,ROTDMP
        LD    DE,LINE3
        LD    BC,16           ; part routine is 8 bits wating time
        LDIR
        LD    DE,0
        LD    A,(ROUTSL)
        RLCA
        RLCA
        RLCA
        LD    E,A
        LD    B,8
        LD    HL,L3S1
        ADD   HL,DE
        XOR   A
GONIT:
        LD    (HL),A
        INC   HL
        DJNZ  GONIT

        LD    DE,FIGNOR
        LD    B,255
        XOR   A
ERASE:
        LD    (DE),A
        INC   DE
        INC   HL
        DJNZ  ERASE

        LD    HL,0
        LD    IY,FRESLT
        LD    B,5
        LD    DE,0

        LD    A,(ROUTSL)
        OR    A
        JR    Z,NEXTR

        LD    B,128



NEXTR:


        LD    A,112 OR 128
        OUT   (&H99),A
        LD    A,1+128
        OUT   (&H99),A

        XOR   A
        OUT   (&H99),A
        LD    A,15 OR 128
        OUT   (&H99),A

        LD    A,B
        EX    AF,AF

RFLOOP: LD    HL,0
LINE:   IN    A,(&H99)
        AND   &H80
        JR    Z,LINE

LINE2:  IN    A,(&H99)
        AND   &H80
        JR    NZ,LINE2

LINE3:  INC   HL

L3S1:   IN    A,(&H99)        ;2btes
        AND   &H80            ;2btes
        JR    Z,LINE3         ;2bytes
        DEFB  0,0             ;2 bytes
L3S2:   IN    A,(&H99)
        AND   &H80
        JR    Z,LINE3
        DEFB  0,0

CONTIN: PUSH  HL
        LD    A,L
        AND   &HF0
        LD    L,A
        LD    (IY),L
        INC   IY
        POP   HL
JUMPLP: DJNZ  RFLOOP

        INC   H
        LD    (RESULT),HL
        LD    A,H
        INC   A
        AND   &B00111111
        LD    (CPU),A

        LD    DE,0
        LD    HL,RFRSLT
        PUSH  HL
        POP   BC
        EX    AF,AF
        PUSH  AF
        DEC   A
        DEC   A
        LD    E,A
        ADD   HL,DE
        PUSH  HL
        EX    DE,HL
        CALL  QSORT

        POP   DE
        POP   AF
        LD    BC,RFRSLT

        LD    A,(BC)
        LD    H,A
        LD    A,(DE)
        SUB   H
        AND   &B00001111
        CP    10
        RET   NC
        LD    A,1
        LD    (EMULAT),A

        RET
;       LD    A,L
;       AND   &HFC
;       LD    (IX),A
;       LD    A,H
;       LD    (IX+8),A
;       INC   IX


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

;
; >>> Quicksort routine v1.1 <<<
; by Frank Yaul 7/14/04
;
; Usage: bc->first, de->last,
;        call qsort
; Destroys: abcdefhl
;

QSORT:  LD    HL,0
        PUSH  HL
QSLOOP: LD    H,B
        LD    L,C
        OR    A
        SBC   HL,DE
        JP    C,NEXT1         ;loop until lo<hi
        POP   BC
        LD    A,B
        OR    C
        RET   Z               ;bottom of stack
        POP   DE
        JP    QSLOOP
NEXT1:  PUSH  DE              ;save hi,lo
        PUSH  BC
        LD    A,(BC)          ;pivot
        LD    H,A
        DEC   BC
        INC   DE
FLEFT:  INC   BC              ;do i++ while cur<piv
        LD    A,(BC)
        CP    H
        JP    C,FLEFT
FRIGHT: DEC   DE              ;do i-- while cur>piv
        LD    A,(DE)
        LD    L,A
        LD    A,H
        CP    L
        JP    C,FRIGHT
        PUSH  HL              ;save pivot
        LD    H,D             ;exit if lo>hi
        LD    L,E
        OR    A
        SBC   HL,BC
        JP    C,NEXT2
        LD    A,(BC)          ;swap (bc),(de)
        LD    H,A
        LD    A,(DE)
        LD    (BC),A
        LD    A,H
        LD    (DE),A
        POP   HL              ;restore pivot
        JP    FLEFT
NEXT2:  POP   HL              ;restore pivot
        POP   HL              ;pop lo
        PUSH  BC              ;stack=left-hi
        LD    B,H
        LD    C,L             ;bc=lo,de=right
        JP    QSLOOP
;
; >>> end Quicksort <<<
;





TIMDTA: DEFB  0,0,0,0
        DEFB  0,0,0,0
        INC   DE
TIMEND:

NTSC:   DB    0
EMULAT: DB    0
TURBO:  DB    0
RESULT: DW    0
FRESLT:
FIGNOR: DB    0
RFRSLT: DS    253
RFEND:  DB    0,0,0,0,0
CPU:    DB    0
ROUTSL: DB    0               ;route select 0=speed , 1=emulator
ROTDMP: INC   HL
        IN    A,(&H99)        ;2btes
        AND   &H80            ;2btes
        JR    Z,ROTDMP        ;2bytes
        DEFB  0,0             ;2 bytes
        IN    A,(&H99)
        AND   &H80
        JR    Z,ROTDMP
        DEFB  0,0



