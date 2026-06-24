# Stoppuhr auf dem ITS-Board (ARM-Assembler)

## Einleitung

In dieser Aufgabe wurde eine Stoppuhr für das ITS-Board in ARM-Assembler entwickelt. Ziel war es, die in den vorherigen Übungen behandelten Themen wie Tasterabfrage, Displayausgabe, LED-Ansteuerung und Timerprogrammierung praktisch anzuwenden und in einem gemeinsamen Projekt umzusetzen.

Die Stoppuhr kann über die Taster des ITS-Boards gesteuert werden. Die gemessene Zeit wird auf dem TFT-Display angezeigt. Zusätzlich zeigen die LEDs D8 und D9 den aktuellen Zustand der Stoppuhr an.

---

## Verwendete Hardware

### TFT-Display

Das TFT-Display dient zur Ausgabe der gemessenen Zeit. Die Zeit wird im Format

```text
MM:SS.HH
```

angezeigt.

Dabei stehen:

* MM für Minuten
* SS für Sekunden
* HH für Hundertstel-Sekunden

Beispiel:

```text
03:18.90
```

### Taster

Die Steuerung der Stoppuhr erfolgt über die Taster S5 bis S7.

| Taster | Funktion                                   |
| ------ | ------------------------------------------ |
| S5     | Stoppuhr zurücksetzen (INIT)               |
| S6     | Stoppuhr anhalten (HOLD)                   |
| S7     | Stoppuhr starten bzw. fortsetzen (RUNNING) |

Die Tasterzustände werden über das GPIO-Register `GPIO_F_PIN` eingelesen.

### LEDs

Zur Anzeige des aktuellen Zustands werden die LEDs D8 und D9 verwendet.

| Zustand | D8  | D9  |
| ------- | --- | --- |
| INIT    | aus | aus |
| RUNNING | an  | aus |
| HOLD    | an  | an  |

### Timer

Für die Zeitmessung wird der Hardware-Timer TIM2 verwendet. Der Prescaler wird so eingestellt, dass ein Timer-Tick einer Zeit von 10 µs entspricht.

---

## Bearbeitung der Aufgabe

### Woche 7

Zu Beginn wurde das bereitgestellte Beispielprogramm untersucht und auf das ITS-Board geladen. Anschließend wurden die einzelnen Hardware-Komponenten getestet.

Dabei wurden erste Versuche mit der Displayausgabe, der Tasterabfrage, den LEDs und dem Timer durchgeführt. Dadurch konnte der grundsätzliche Aufbau des Programms verstanden werden.

### Woche 8

In der zweiten Woche wurde die Zustandsmaschine der Stoppuhr umgesetzt.

Hierfür wurden die Zustände INIT, RUNNING und HOLD festgelegt. Über die Taster S5 bis S7 kann zwischen diesen Zuständen gewechselt werden. Zusätzlich wurde die Zustandsanzeige über die LEDs D8 und D9 realisiert.

### Woche 9

Im letzten Teil der Aufgabe wurde die eigentliche Zeitmessung implementiert.

Dazu wird der aktuelle Timerwert eingelesen und die seit dem letzten Schleifendurchlauf vergangene Zeit berechnet. Diese Zeit wird zur bisherigen Stoppuhrzeit addiert und anschließend in Minuten, Sekunden und Hundertstel umgerechnet.

Die berechneten Werte werden als Zeichenkette aufbereitet und auf dem TFT-Display ausgegeben. Die Anzeige wird nur im Zustand RUNNING aktualisiert. Im Zustand HOLD bleibt die zuletzt gemessene Zeit erhalten.

---

## Programmablauf

Nach der Initialisierung von Board, Display und Timer läuft das Programm in einer Endlosschleife (Superloop).

Innerhalb dieser Schleife werden nacheinander die Taster eingelesen, der aktuelle Zustand bestimmt, die LEDs aktualisiert und anschließend die Zeitmessung durchgeführt. Dadurch reagiert die Stoppuhr kontinuierlich auf Benutzereingaben und aktualisiert die Anzeige laufend.

---

## Zustandsmaschine

Die Stoppuhr besitzt drei Zustände:

### INIT

Im Zustand INIT wird die Stoppuhr zurückgesetzt. Der Timer wird neu gestartet und die Anzeige auf `00:00.00` gesetzt.

### RUNNING

Im Zustand RUNNING läuft die Zeit. Die seit dem letzten Schleifendurchlauf vergangene Zeit wird zur bisherigen Stoppuhrzeit addiert und anschließend auf dem Display dargestellt.

### HOLD

Im Zustand HOLD bleibt die aktuelle Zeit stehen. Die Anzeige wird nicht weiter aktualisiert, bis die Stoppuhr erneut gestartet oder zurückgesetzt wird.

Der aktuelle Zustand wird in der Variablen `STATE` gespeichert.

---

## Unterprogramme und Schnittstellen

### readButtons

Liest die aktuellen Tasterzustände ein.

**Eingabe:**

* keine

**Ausgabe:**

* `R0` enthält den aktuellen Tasterzustand

---

### readTimer

Liest den aktuellen Wert des Hardware-Timers TIM2.

**Eingabe:**

* keine

**Ausgabe:**

* `R0` enthält den aktuellen Timerwert

---

### convertTime

Wandelt die gemessene Zeit in Minuten, Sekunden und Hundertstel um.

**Eingabe:**

* `R0` = Zeitwert in Timer-Ticks

**Ausgabe:**

* `MINUTES`
* `SECONDS`
* `HUNDREDTHS`

---

### twoDigitsToAscii

Wandelt eine Zahl zwischen 0 und 99 in zwei ASCII-Zeichen um.

**Eingabe:**

* `R0` = Zahl zwischen 0 und 99

**Ausgabe:**

* `R2` = ASCII-Zehnerstelle
* `R3` = ASCII-Einerstelle

---

### displayTime

Erstellt aus Minuten, Sekunden und Hundertstel einen Zeitstring und gibt diesen auf dem TFT-Display aus.

**Eingabe:**

* `MINUTES`
* `SECONDS`
* `HUNDREDTHS`

**Ausgabe:**

* Aktualisierung von `MY_TEXT`
* Ausgabe auf dem TFT-Display

---

### updateClk

Berechnet die seit dem letzten Schleifendurchlauf vergangene Zeit und aktualisiert die Stoppuhr im Zustand RUNNING.

**Eingabe:**

* `STATE`
* aktueller Timerwert

**Ausgabe:**

* Aktualisierung von `STOPWATCH_TICKS`
* Aktualisierung der Zeitanzeige

---

### stateMachine

Bestimmt anhand der gedrückten Taster den aktuellen Zustand der Stoppuhr.

**Eingabe:**

* `R0` = aktueller Tasterzustand

**Ausgabe:**

* Aktualisierung der Variable `STATE`

---

### setInit

Setzt die Stoppuhr zurück.

**Eingabe:**

* keine

**Ausgabe:**

* `STATE = INIT`
* Timer wird zurückgesetzt
* Zeitwerte werden auf 0 gesetzt
* Anzeige wird auf `00:00.00` zurückgesetzt

---

### setHold

Versetzt die Stoppuhr in den Zustand HOLD.

**Eingabe:**

* keine

**Ausgabe:**

* `STATE = HOLD`

---

### setRunning

Versetzt die Stoppuhr in den Zustand RUNNING.

**Eingabe:**

* keine

**Ausgabe:**

* `STATE = RUNNING`

---

### showStateLEDs

Zeigt den aktuellen Zustand über die LEDs D8 und D9 an.

**Eingabe:**

* `STATE`

**Ausgabe:**

* Aktualisierung der LEDs

---

## Ergebnis

Die Stoppuhr konnte erfolgreich auf dem ITS-Board umgesetzt und getestet werden.

Die Zustände INIT, RUNNING und HOLD werden über die Taster gesteuert und zusätzlich durch die LEDs angezeigt. Die Zeit wird mit Hilfe des Hardware-Timers TIM2 gemessen und im Format `MM:SS.HH` auf dem TFT-Display dargestellt.

Damit sind alle wesentlichen Funktionen der Stoppuhr erfolgreich implementiert worden. Die Stoppuhr kann gestartet, angehalten und zurückgesetzt werden und zeigt die gemessene Zeit zuverlässig auf dem Display an.

Damit sind alle wesentlichen Funktionen der Stoppuhr erfolgreich implementiert und getestet worden.
