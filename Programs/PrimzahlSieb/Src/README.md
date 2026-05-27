# PrimzahlSieb - Woche 5

## Ziel

In dieser Aufgabe soll das Sieb des Eratosthenes in ARM-Assembler umgesetzt werden.

Das Programm soll Primzahlen von 2 bis 1000 finden.
Dafuer wird ein Feld benutzt, in dem gespeichert wird,
ob eine Zahl noch eine moegliche Primzahl ist oder nicht.

1 bedeutet:
- moegliche Primzahl

0 bedeutet:
- keine Primzahl


## Idee vom Algorithmus

Zuerst werden alle Werte im Feld auf 1 gesetzt.

Danach werden 0 und 1 auf 0 gesetzt,
weil sie keine Primzahlen sind.

Anschliessend startet die aeussere Schleife mit p = 2.

Wenn eine Zahl noch den Wert 1 hat,
gilt sie noch als moegliche Primzahl.
Dann startet die innere Schleife.

Die innere Schleife streicht alle Vielfachen von p,
indem sie die Werte im Feld auf 0 setzt.

Am Ende bleiben nur die Primzahlen mit dem Wert 1 im Feld stehen.


## Verwendete Kontrollstrukturen

### While-Schleifen

Es werden mehrere While-Schleifen benutzt:

- Initialisierung des Feldes
- aeussere Schleife fuer p
- innere Schleife fuer die Vielfachen

Die Schleifen arbeiten mit:
- cmp
- bedingten Sprungbefehlen
- Labels


## Wichtige Befehle

### cmp

Vergleicht zwei Werte.

Beispiel:

cmp r2, #1000

Hier wird geprueft,
ob p*p groesser als 1000 ist.


### bgt

Branch if greater.

Springt,
wenn der linke Wert groesser ist.


### bne

Branch if not equal.

Springt,
wenn zwei Werte nicht gleich sind.


### ldrb

Laedt 1 Byte aus dem Speicher.

Wird benutzt,
um einen Wert aus dem Sieb-Feld zu lesen.


### strb

Speichert 1 Byte im Speicher.

Wird benutzt,
um Vielfache auf 0 zu setzen.


## Registerbelegung

r0 = Adresse vom Sieb

r1 = p (aktuelle Zahl der aeusseren Schleife)

r2 = p*p

r3 = k (aktuelles Vielfaches)

r4 = Sieb[p]

r5 = Wert 0 zum Streichen


## Warum startet die innere Schleife bei p*p?

Kleinere Vielfache wurden bereits
von kleineren Primzahlen gestrichen.

Beispiel:

Bei p = 5 wurden:
10, 15 und 20 schon vorher gestrichen.

Deshalb beginnt die Schleife erst bei:
25.


## Zusammenfassung

Die aeussere Schleife waehlt die aktuelle Zahl p.

Die innere Schleife streicht alle Vielfachen von p.

Durch das Streichen bleiben am Ende nur die Primzahlen im Feld erhalten.