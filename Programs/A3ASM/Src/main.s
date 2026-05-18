;************************************************
;* Beginn der globalen Daten *
;************************************************
                   AREA MyData, DATA, align = 2
Base
VariableA          DCW 0x1234
VariableB          DCW 0x4711

VariableC          DCD  0

MeinHalbwortFeld   DCW 0x22 , 0x3e , -52, 78 , 0x27 , 0x45

MeinWortFeld       DCD 0x12345678 , 0x9dca5986
                   DCD -872415232 , 1308622848
                   DCD 0x27000000
                   DCD 0x45000000

MeinTextFeld       DCB "ABab0123",0

                   EXPORT VariableA
                   EXPORT VariableB
                   EXPORT VariableC
                   EXPORT MeinHalbwortFeld
                   EXPORT MeinWortFeld
                   EXPORT MeinTextFeld

;***********************************************
;* Beginn des Programms *
;************************************************
    AREA |.text|, CODE, READONLY, ALIGN = 3

; ----- Start des Hauptprogramms -----
                EXPORT main
                EXTERN initITSboard
 
main            PROC

                ; Board initialisieren
                bl    initITSboard                 ; Anw-01

; Laden von Konstanten in Register

                ; 0x12 nach R0 laden
                mov   r0,#0x12                     ; Anw-02

                ; -128 nach R1 laden
                mov   r1,#-128                     ; Anw-03

                ; Konstante nach R2 laden
                ldr   r2,=0x12345678              ; Anw-04

; Zugriff auf Variable

                ; Adresse von VariableA laden
                ldr   r0,=VariableA               ; Anw-05

                ; Halbwort laden
                ldrh  r1,[r0]                     ; Anw-06

                ; Wort laden
                ldr   r2,[r0]                     ; Anw-07

                ; Wert speichern
                str   r2,[r0,#VariableC-VariableA] ; Anw-08

; Zugriff auf Felder

                ; Adresse vom Feld laden
                ldr   r0,=MeinHalbwortFeld        ; Anw-09

                ; erstes Element laden
                ldrh  r1,[r0]                     ; Anw-10

                ; zweites Element laden
                ldrh  r2,[r0,#2]                  ; Anw-11

                ; Offset setzen
                mov   r3,#10                      ; Anw-12

                ; Element mit Offset laden
                ldrh  r4,[r0,r3]                  ; Anw-13

                ; Element laden und R0 erhöhen
                ldrh  r5,[r0,#2]!                 ; Anw-14

                ; nächstes Element laden
                ldrh  r6,[r0,#2]!                 ; Anw-15

                ; Wert speichern
                strh  r6,[r0,#2]!                 ; Anw-16

; Addition und Subtraktion

                ; Adresse vom Wortfeld laden
                ldr   r0,=MeinWortFeld            ; Anw-17

                ; erstes Wort laden
                ldr   r1,[r0]                     ; Anw-18

                ; zweites Wort laden
                ldr   r2,[r0,#4]                  ; Anw-19

                ; addieren
                adds  r3,r1,r2                    ; Anw-20

                ; drittes Wort laden
                ldr   r4,[r0,#8]                  ; Anw-21

                ; viertes Wort laden
                ldr   r5,[r0,#12]                 ; Anw-22

                ; subtrahieren
                subs  r6,r4,r5                    ; Anw-23

                ; fünftes Wort laden
                ldr   r7,[r0,#16]                 ; Anw-24

                ; sechstes Wort laden
                ldr   r8,[r0,#20]                 ; Anw-25

                ; nochmal subtrahieren
                subs  r9,r7,r8                    ; Anw-26

                ; Endlosschleife
forever         b   forever

                ENDP
                END        