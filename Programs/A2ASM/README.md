# Aufgabe 2 – Konstanten, Variablen und Operationen

## Ziel
In dieser Aufgabe wurde untersucht, wie Daten zwischen Speicher und Registern übertragen werden und wie Bit-Manipulationen funktionieren.

---

## VariableA (BE EF)

- Anfang: 0xBEEF im Speicher (Little Endian: EF BE)
- Bytes wurden getrennt geladen (R2, R3)
- Verschoben (LSL) und kombiniert (ORR)
- Ergebnis: BE EF im Speicher sichtbar

---

## ConstByteA → Register

- Konstante 0xAFFE wurde in Register R5 geladen
- Danach in Speicher geschrieben

---

## VariableC (AF FE)

- Ziel: Darstellung "affe"
- Bytes wurden verschoben (LSL, LSR)
- Danach kombiniert (ORR)
- Ergebnis im Speicher: AF FE

---

## VariableB (12 34)

- Ausgang: 0x1234
- Bytes wurden getrennt und neu angeordnet
- Ergebnis: 12 34 im Speicher

---

## Wichtige Befehle

- LDR / LDRB → Laden aus Speicher
- STRH → Schreiben in Speicher
- LSL → nach links schieben
- LSR → nach rechts schieben
- ORR → Bits kombinieren

---

## Erkenntnisse

- Speicher ist Little Endian (Byte-Reihenfolge wichtig)
- Register dienen zur Zwischenverarbeitung
- Bit-Operationen verändern gezielt Daten