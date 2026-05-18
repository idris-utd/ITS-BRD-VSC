;*******************************************
:* PrimzahlSieb - Woche 4
;*******************************************

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