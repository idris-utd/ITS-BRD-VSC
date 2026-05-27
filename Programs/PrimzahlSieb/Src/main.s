; *******************************************
; * PrimzahlSieb - Woche 5
; *******************************************

; Ziel
; Primzahlen von 2 bis 1000 mit dem Sieb des Eratosthenes finden


;Speicher/Felder:
;Ein Feld speichert fuer jede Zahl
;ob sie Primzahl ist oder nicht
;1 = moegliche Primzahl
;0 = keine Primzahl

; Ablauf:

;1. Feld initialisieren
;Alle Werte zuerst auf 1 setzen

;2. Mit Zahl 2 beginnen

;3. Alle Vielfachen der aktuellen Zahl streichen 

;4. Naechste nicht gestrichene Zahl suchen

;5. Schritte wiederholen bis Grenze erreicht

;6. Gefundene Primzahlen abspeichern


; Wichtige Operationen:
; - Schleifen
; - Vergleiche
; - Speicherzugriffe
; - Multiplikation

; Pseudocode:

; i = 0
; solange i <= 1000:
;    Feld[i] = 1
;    i = i + 1

; Feld[0] = 0
; Feld[1] = 0

; zahl = 2
; solange zahl * zahl <= 1000:
;    wenn Feld[zahl] == 1:
;       vielfaches = zahl * zahl
;       solange vielfaches <= 1000:
;           Feld[vielfaches] = 0
;           vielfaches = vielfaches + zahl
;    zahl = zahl + 1

; Danach stehen alle Primzahlen noch mit 1 im Feld 


;**********************************************************
;* Datenbereich
;**********************************************************

                AREA MyData, DATA, ALIGN=2

; Feld fuer Zahlen 0 bis 1000
; 1 = moegliche Primzahl
; 0 = keine Primzahl
Sieb            SPACE 1001

                EXPORT Sieb

;**************************************************************
;* Beginn des Programms
;**************************************************************

                AREA |.text|, CODE, READONLY, ALIGN=3
                 
                EXPORT main
                EXTERN initITSboard

main            PROC
                bl initITSboard

;--------------------------------------------------------------
; Sieb initialisieren (alle auf 1)
; R0 = Adresse vom Sieb
; R1 = Index i (0 bis 1000)
; R2 = Wert 1
;--------------------------------------------------------------

               ldr  r0, =Sieb        ; Adresse vom Sieb laden
               mov  r1, #0           ; i = 0
               mov  r2, #1           ; Wert 1 setzen

; Alle Felder zuerst auf 1 setzen
beginWhile_init
               cmp  r1,#1000
               bgt  endWhile_init

               strb r2, [r0, r1]
               add  r1,r1, #1
               b    beginWhile_init

endWhile_init

; 0 und 1 auf 0 setzen weil keine Primzahl
               mov  r2,#0
               strb r2, [r0, #0]
               strb r2, [r0, #1]

;---------------------------------------------------------------
; Sieb des Eratosthenes
; r0 = Adresse Sieb
; r1 = p (äußere Schleife)
; r2 = p*p
; r3 = k (innere Schleife)
; r4 = Sieb[p]
; r5 = 0 (zum Streichen)
;---------------------------------------------------------------
               mov  r1, #2
beginWhile_outer
               mul  r2,r1,r1
               cmp  r2,#1000
               bgt  endWhile_outer

               ldrb r4,[r0,r1]
               cmp  r4, #1
               bne  endIf_1

               mov  r3, r2                ; k = p*p
               mov  r5, #0                ; Wert 0 zum Streichen

beginWhile_inner
               cmp  r3,#1000
               bgt  endWhile_inner

    
               strb r5,[r0, r3]           ; Sieb[k] = 0 
               add  r3, r3, r1            ; k = k + p
               b    beginWhile_inner    

endWhile_inner    

endIf_1 
               add  r1,r1,#1
               b    beginWhile_outer

endWhile_outer

forever        b    forever               ; Endlosschleife
               ENDP
               END

 

