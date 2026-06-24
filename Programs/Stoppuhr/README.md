# Stoppuhr auf dem ITS-Board (ARM-Assembler)

## Einleitung

Im Rahmen dieser Aufgabe wurde eine Stoppuhr für das ITS-Board in ARM-Assembler entwickelt. Ziel war es, die in den vorherigen Übungen behandelten Themen wie Displayausgabe, Tasterabfrage, LED-Ansteuerung und Timerprogrammierung in einem gemeinsamen Projekt anzuwenden.

Die Stoppuhr wird über die Taster des ITS-Boards gesteuert. Die aktuelle Zeit wird auf dem TFT-Display angezeigt. Zusätzlich werden LEDs verwendet, um den aktuellen Zustand der Stoppuhr sichtbar zu machen.

---

## Verwendete Hardware

### TFT-Display

Das TFT-Display dient zur Ausgabe der gemessenen Zeit. Die Zeit wird im Format

MM:SS.HH

angezeigt.

Dabei stehen:

* MM für Minuten
* SS für Sekunden
* HH für Hundertstel-Sekunden

Beispiel:

03:18.90

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

Zu Beginn wurde das bereitgestellte Beispielprogramm analysiert und auf das ITS-Board geladen. Anschließend wurden die wichtigsten Hardware-Komponenten einzeln getestet.

Dabei wurden folgende Funktionen untersucht:

* Ausgabe von Texten auf dem TFT-Display
* Einlesen von Tasterzuständen
* Ansteuerung der LEDs
* Initialisierung des Timers

Dadurch konnte der grundsätzliche Aufbau des Programms verstanden werden.

### Woche 8

Im zweiten Schritt wurde die Zustandsmaschine der Stoppuhr entwickelt.

Dafür wurden die drei Zustände

* INIT
* RUNNING
* HOLD

festgelegt und über die Taster steuerbar gemacht.

Zusätzlich wurde die Zustandsanzeige über die LEDs D8 und D9 umgesetzt.

### Woche 9

Im letzten Teil wurde die eigentliche Zeitmessung implementiert.

Der aktuelle Timerwert wird eingelesen und anschließend in Minuten, Sekunden und Hundertstel umgerechnet. Die berechneten Werte werden als Zeichenkette aufbereitet und auf dem TFT-Display ausgegeben.

Außerdem wird die Zeit nur im Zustand RUNNING aktualisiert. Im Zustand HOLD bleibt die zuletzt gemessene Zeit erhalten.

---

## Programmablauf

Die Hauptschleife des Programms besteht aus vier Schritten:

1. Taster einlesen
2. Zustand bestimmen
3. LEDs aktualisieren
4. Zeit aktualisieren

Diese Schritte werden fortlaufend wiederholt, solange das Programm läuft.

---

## Zustandsmaschine

Die Stoppuhr besitzt drei Zustände.

### INIT

Im Zustand INIT wird die Stoppuhr zurückgesetzt. Der Timer wird neu gestartet und die Anzeige auf 00:00.00 gesetzt.

### RUNNING

Im Zustand RUNNING läuft die Zeit. Der aktuelle Timerwert wird eingelesen, umgerechnet und auf dem Display dargestellt.

### HOLD

Im Zustand HOLD wird die aktuelle Zeit angehalten. Die Anzeige bleibt unverändert, bis die Stoppuhr wieder gestartet oder zurückgesetzt wird.

Der aktuelle Zustand wird in der Variablen `STATE` gespeichert.

---

## Unterprogramme und Schnittstellen

### readButtons

Liest den aktuellen Zustand der Taster ein.

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

Wandelt den Timerwert in Minuten, Sekunden und Hundertstel um.

**Eingabe:**

* `R0` = aktueller Timerwert

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

* `R2` = ASCII-Zeichen der Zehnerstelle
* `R3` = ASCII-Zeichen der Einerstelle

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

Aktualisiert die Zeitanzeige.

**Eingabe:**

* `STATE`

**Ausgabe:**

* Aktualisierte Anzeige im Zustand RUNNING

---

### stateMachine

Bestimmt anhand der gedrückten Taster den aktuellen Zustand.

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
* Anzeige zeigt 00:00.00

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

Die Stoppuhr konnte erfolgreich auf dem ITS-Board umgesetzt werden.

Folgende Funktionen wurden realisiert:

* Initialisierung von Board, Display und Timer
* Einlesen der Taster
* Zustandsmaschine mit INIT, RUNNING und HOLD
* Zustandsanzeige über LEDs
* Zeitmessung mit TIM2
* Umrechnung in Minuten, Sekunden und Hundertstel
* Anzeige der Zeit auf dem TFT-Display

Die Stoppuhr kann gestartet, angehalten und zurückgesetzt werden. Die aktuelle Zeit wird fortlaufend auf dem Display angezeigt, während die LEDs jederzeit den aktuellen Zustand der Stoppuhr signalisieren.

