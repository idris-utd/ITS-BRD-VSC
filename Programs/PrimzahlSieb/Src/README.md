# PrimzahlSieb

## Aufgabe

In dieser Aufgabe soll ein Assemblerprogramm vorbereitet werden, das Primzahlen von 2 bis 1000 mit dem Sieb des Eratosthenes bestimmt.

## Idee des Programms

Zuerst werden alle Zahlen als mögliche Primzahlen markiert. Danach beginnt das Programm bei der Zahl 2 und streicht alle Vielfachen dieser Zahl aus dem Feld. Anschließend wird die nächste noch nicht gestrichene Zahl gesucht und ihre Vielfachen werden ebenfalls gestrichen.

Dieser Vorgang wird solange wiederholt, bis alle Primzahlen gefunden wurden.

## Verwendete Felder

Für das Programm wird ein Feld verwendet, das speichert, ob eine Zahl eine Primzahl ist oder nicht.

Der Index des Feldes entspricht dabei der jeweiligen Zahl.

Beispiel:

- Feld[2] -> Information für die Zahl 2
- Feld[7] -> Information für die Zahl 7

Die Elemente des Feldes sollen als Byte gespeichert werden:

- 1 = mögliche Primzahl
- 0 = keine Primzahl

## Aufbau des Programms

Das Programm besteht aus mehreren Schritten:

1. Feld initialisieren
2. Zahlen als mögliche Primzahlen markieren
3. Vielfache der aktuellen Primzahl streichen
4. Nächste Primzahl suchen
5. Ergebnisse abspeichern

## Verwendete Konzepte

- Schleifen
- Vergleiche
- Speicherzugriffe
- Felder/Arrays
- Multiplikation
- Bedingungen