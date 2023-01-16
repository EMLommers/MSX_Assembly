; Check Kbytes VRAM
;
; Use preferably in screen 0/1
;
; MSX 1  -> 16Kbytes
; MSX 2  -> 64/128Kbytes
; MSX 2+ -> 128Kbytes
; MSX Turbo R -> 128Kbytes
;
; Value RESULT * 16 = Amount VRAM
;
; Tested in OpenMSX:
; msx2plus -> RESULT=8 -> 128Kb
; msx 1 -> RESULT=1 -> 16K
; Canon V-25 -> RESULT=4 -> 64K
;
; Free to use
; Code by Ernst M. Lommers
; Date: 16 Jan 2022


        ORG   &HC000



VRBLCK: EQU   &H40            ;16k block


START:
        DI
        XOR   A
        LD    (RESULT),A

        LD    BC,&H2000       ; max 512k VRAM (beter be sure than sorry)
        PUSH  BC
        CALL  CHECK           ; C=0 -> INIT -> write 255 to addresses
        POP   BC
        INC   C
        CALL  CHECK           ; C=1 -> read and write block nr

        LD    A,&H20          ; same as B
        SUB   B
        LD    (RESULT),A
        EI
        RET

CHECK:  DEC   C
        LD    HL,0

LOOP:
        LD    DE,VRBLCK
        ADD   HL,DE

        LD    A,C
        OR    A
        JR    NZ,WRITE

        CALL  READVM
        OR    A
        RET   Z


WRITE:  CALL  WRITVM          ; init for the firest
        DJNZ  LOOP

        RET

WRITVM: DEFB  &HF6            ; OR + next byte (SCF) -> carry=0
READVM: SCF                   ; scf carry=1

        PUSH  HL
        PUSH  AF
        DEC   HL
        PUSH  HL

        ADD   HL,HL
        ADD   HL,HL

        LD    A,H
        OUT   (&H99),A
        LD    A,14+128
        OUT   (&H99),A

        POP   HL

        LD    A,&HFF
        OUT   (&H99),A
        POP   AF
        JR    C,READ

        LD    A,L
        AND   &B00111111
        OR    64
        OUT   (&H99),A

        LD    A,C
        OR    A
        JR    Z,BLOCKN
        JR    PRINT

BLOCKN: LD    A,&H20          ; same as inital B
        SUB   B
PRINT:  OUT   (&H98),A
        JR    ENDING

READ:   LD    A,L
        AND   &B00111111
        OUT   (&H99),A

        DEFB  0,0             ; nop nop waiting time before IN

        IN    A,(&H98)
ENDING: POP   HL
        RET

RESULT: DB    0



    
