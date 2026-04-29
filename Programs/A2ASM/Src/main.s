;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Description        : Aufgabe 2 - Speicher, Register und Byte-Manipulation
;*******************************************************************************

    EXTERN initITSboard
    EXPORT main

ConstByteA  EQU 0xaffe

    AREA DATA, DATA, align=2
VariableA   DCW 0xbeef
VariableB   DCW 0x1234
VariableC   DCW 0x0000

    AREA  |.text|, CODE, READONLY, ALIGN = 3
    ALIGN

main
    BL initITSboard

;* swap memory von VariableA: BEEF im Speicher sichtbar machen
    ldr     R0,=VariableA   ; Anw01: Adresse von VariableA in R0 laden
    ldrb    R2,[R0]         ; Anw02: erstes Byte laden: EF
    ldrb    R3,[R0,#1]      ; Anw03: zweites Byte laden: BE
    lsl     R2, #8          ; Anw04: EF nach links schieben -> EF00
    orr     R2, R3          ; Anw05: EF00 OR BE -> EFBE
    strh    R2,[R0]         ; Anw06: zurückschreiben, Speicher zeigt BE EF

;* const in Register
    mov     R5,#ConstByteA  ; Anw07: R5 = AFFE

;* VariableC anlegen und AFFE im Speicher sichtbar machen
    ldr     R0,=VariableC   ; Anw08: Adresse von VariableC laden

    mov     R2,R5           ; R2 = AFFE
    lsl     R2,#24          ; unteres Byte FE nach oben schieben
    lsr     R2,#16          ; Ergebnis: FE00

    mov     R3,R5           ; R3 = AFFE
    lsr     R3,#8           ; Ergebnis: 00AF

    orr     R2,R3           ; Ergebnis: FEAF
    strh    R2,[R0]         ; Speicher zeigt AF FE

;* VariableB so ändern, dass im Speicher 12 34 sichtbar ist
    ldr     R1,=VariableB   ; Anw09: Adresse von VariableB laden
    ldrb    R2,[R1]         ; erstes Byte laden: 34
    ldrb    R3,[R1,#1]      ; zweites Byte laden: 12
    lsl     R2,#8           ; 34 -> 3400
    orr     R2,R3           ; 3400 OR 12 -> 3412
    strh    R2,[R1]         ; Speicher zeigt 12 34

    b .

    ALIGN
    END