; **********************************************************
; *  Woche 6: Sieb auslesen und Primzahlen in Prim speichern
; **********************************************************



; WOCHE 5: Sieb berechnen
;**********************************************************
;* Datenbereich
;**********************************************************

                AREA MyData, DATA, ALIGN=2

; Feld fuer Zahlen 0 bis 1000
; 1 = moegliche Primzahl
; 0 = keine Primzahl
Sieb            fill  1001, 0
Prim            fill  336, 0

                EXPORT Sieb
                EXPORT Prim

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
while_1
               cmp  r1,#1000
               bgt  endwhile_1

               strb r2, [r0, r1]     ; Sieb[i] = 1
               add  r1,r1, #1
               b    while_1

endwhile_1

; 0 und 1 auf 0 setzen weil keine Primzahl
               mov  r2,#0
               strb r2, [r0, #0]
               strb r2, [r0, #1]

;---------------------------------------------------------------
; Sieb des Eratosthenes
; r0 = Adresse Sieb
; r1 = p startet bei 2
; r2 = p*p
; r3 = k (innere Schleife)
; r4 = Sieb[p]
; r5 = 0 (zum Streichen)
;---------------------------------------------------------------
               mov  r1, #2
while_2
               mul  r2,r1,r1
               cmp  r2,#1000
               bgt  endwhile_2

               ldrb r4,[r0,r1]
               cmp  r4, #1
               bne  endIf_1

               mov  r3, r2                ; k = p*p
               mov  r5, #0                ; Wert 0 zum Streichen

while_3
               cmp  r3,#1000
               bgt  endwhile_3

    
               strb r5,[r0, r3]           ; Sieb[k] = 0 
               add  r3, r3, r1            ; k = k + p
               b    while_3    

endwhile_3  

endIf_1 
               add  r1,r1,#1
               b    while_2


endwhile_2

;   ---- WOCHE 6 -----   
; r0 = Adresse Sieb
; r1 = i (Index Sieb)
; r6 = Adresse Prim
; r7 = j (Index Prim) 

               ldr r0, =Sieb
               mov r1, #2
               ldr r6, =Prim
               mov r7, #0

while_4
               cmp r1,#1000
               bgt endwhile_4
               

               ldrb r2,[r0,r1]
               cmp r2,#1
               bne endIf_2

               strh r1,[r6,r7,lsl #1]        ; Prim[j] = i    (r6 + r7*2)
               add r7, r7,#1                  ; j = j + 1

            
endIf_2 
               add  r1,r1,#1
               b    while_4

      
endwhile_4

forever        b    forever               ; Endlosschleife
               ENDP
               END