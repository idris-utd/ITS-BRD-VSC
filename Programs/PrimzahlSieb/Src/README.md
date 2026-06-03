Woche 6 – Primzahlen abspeichern

In Woche 5 wurde mit dem Sieb des Eratosthenes bestimmt, welche Zahlen zwischen 0 und 1000 Primzahlen sind. Im Feld Sieb steht für jede Zahl entweder eine 1 (Primzahl) oder eine 0 (keine Primzahl).

In Woche 6 werden die gefundenen Primzahlen in ein neues Feld Prim gespeichert.

Dazu wird das Feld Sieb von Index 2 bis 1000 durchlaufen. Für jeden Eintrag wird geprüft, ob der Wert 1 ist. Ist dies der Fall, wird der aktuelle Index in das Feld Prim geschrieben. Der Index entspricht dabei der gefundenen Primzahl.

Beispiel:

Sieb[2] = 1 → Prim[0] = 2
Sieb[3] = 1 → Prim[1] = 3
Sieb[4] = 0 → wird übersprungen
Sieb[5] = 1 → Prim[2] = 5

Die Primzahlen werden als uint16_t gespeichert. Deshalb wird für jeden Eintrag ein Speicherplatz von 2 Byte verwendet und der Befehl STRH zum Speichern eingesetzt.

Nach dem Durchlaufen des gesamten Siebs enthält das Feld Prim alle Primzahlen von 2 bis 1000 in aufsteigender Reihenfolge.

Die ersten gespeicherten Primzahlen sind:
2, 3, 5, 7, 11, 13, 17, 19, ...

Die letzte gespeicherte Primzahl ist: 997

Im Memory Browser können die gespeicherten Werte überprüft werden. Dort werden sie in 
Hexadezimaldarstellung angezeigt: 0002 0003 0005 0007 000B 000D 0011 0013 ...

Dies entspricht den Primzahlen: 2 3 5 7 11 13 17 19 ...

