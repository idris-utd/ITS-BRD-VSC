;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Version            : V1.0
;* Description        : Rahmen zur Loesung von GTP Woche 7-9 (Stoppuhr).
;
;*******************************************************************************

; Define address of selected GPIO and Timer registers
PERIPH_BASE     	       equ	 0x40000000                 ;Peripheral base address
AHB1PERIPH_BASE       	equ	 (PERIPH_BASE + 0x00020000)
APB1PERIPH_BASE             equ     PERIPH_BASE

GPIOD_BASE			equ	 (AHB1PERIPH_BASE + 0x0C00)
GPIOF_BASE			equ	 (AHB1PERIPH_BASE + 0x1400)
TIM2_BASE                   equ     (APB1PERIPH_BASE + 0x0000)
	
GPIO_F_PIN        	       equ	 (GPIOF_BASE + 0x10)         ; Taster einlesen

GPIO_D_PIN			equ	 (GPIOD_BASE + 0x10)
GPIO_D_SET			equ     (GPIOD_BASE + 0x18)
GPIO_D_CLR			equ	 (GPIOD_BASE + 0x1A)
	
TIMER				equ     (TIM2_BASE + 0x24)          ; CNT : current time stamp (32 bit),  resolution
TIM2_PSC			equ     (TIM2_BASE + 0x28)          ; Prescaler  resolution
TIM2_ERG			equ     (TIM2_BASE + 0x14)          ; 16 Bit register, Bit 0 : 1 Restart Timer


    EXTERN initITSboard
    EXTERN GUI_init
	EXTERN TP_Init
	EXTERN initTimer
	EXTERN lcdSetFont
	EXTERN lcdGotoXY      		; TFT goto x y function
	EXTERN lcdPrintS		; TFT output function	
        EXTERN lcdPrintC                ; TFT output one character		
	EXTERN Delay			; Delay (ms) function


;********************************************
; Data section, aligned on 4-byte boundery
;********************************************
	AREA MyData, DATA, align = 2

DEFAULT_BRIGHTNESS	   DCW     800
MY_TEXT		   DCB     "00:00.00",0
STATE                   DCB     0
HUNDREDTHS              DCD     0
SECONDS                 DCD     0
MINUTES                 DCD     0
LAST_TIMESTAMP          DCD     0    ; letzter gelesener Zeitstempel
STOPWATCH_TICKS         DCD    0     ; gesamte gestoppte Zeit in Tics

; Code section, aligned on 8-byte boundery
;********************************************
	AREA |.text|, CODE, READONLY, ALIGN = 3


;--------------------------------------------
; main subroutine
;--------------------------------------------
	EXPORT main [CODE]
	
main	PROC

		; Initialisierung des ITS-Boards, Displays und Timers
		BL		initITSboard

		; Display-Helligkeit laden und GUI initialisieren
		ldr   	r1, =DEFAULT_BRIGHTNESS
		ldrh 	r0, [r1]
		bl   	GUI_init
        
		; Timer TIM2 initialisieren
		bl  	initTimer

		
		ldr 	R1,=TIM2_PSC   		    ; Prescaler setzen: ein Timer-Tick entspricht 10 us
		mov 	R0,#(90*10-1) 
		strh	R0,[R1]


		ldr 	R1,=TIM2_ERG   		    ; Timer neu starten	
		mov     R0,#0x01
		strh	R0,[R1]			    ; Set UG Bit
		
		             
		MOV 	R0, #24                         ; Schriftgroesse fuer TFT-Ausgabe setzen     
		bl  	lcdSetFont

		
		BL displayTime                         ; Anfangsanzeige der Stoppuhr (00:00.00) ausgeben
superloop
                BL      readButtons                  ; Aktuelle Tasterzustände einlesen
                BL      stateMachine                 ; Zustand der Stoppuhr bestimmen
                BL      showStateLEDs                ; Zustand über LEDs anzeigen
                BL      updateClk                    ; Zeitmessung und Anzeige aktulisieren
                BAL     superloop                    ; End of superloop
                ENDP

readButtons PROC                                     ; Taster lesen
	 	  LDR	R0,=GPIO_F_PIN
		  ldrh	R0,[R0]
		  and	R0,#0xFF                        ; Nur die unteren 8 Bits behalten
		  BX	LR
		  ENDP
readTimer PROC             
                LDR     R0,=TIMER                    ; Liest den aktuellen Timmerwert
                LDR     R0,[R0]
                BX      LR
                ENDP

convertTime PROC
                MOV     R1,#1000                     ; R0= Timerwert in Ticks
                UDIV    R2,R0,R1                     ; Timer-Ticks in Hundertstel umrechnen
                
                MOV     R3,#100                      ; 100 Hunderstel = 1 Sekunde
                UDIV    R4,R2,R3                     ; R4 = Sekunden gesamtwert berechnen
                
                MUL     R5,R4,R3                     ; Sekunden * 100
                SUB     R5,R2,R5                     ; R5 = Rest-Hundertstel (0..99) berechnen

                LDR     R1,=HUNDREDTHS               ; Adresse von Hundredths laden
                STR     R5,[R1]                      ; R5 = Rest Hunderstel speichern
                
                MOV     R6,#60                       ; 60 Sekunden = 1 Minute
                UDIV    R7,R4,R6                     ; R7 = Minuten berechnen (Gesamtsekunden / 60)

                MUL     R8,R7,R6                     ; R8 = Minuten * 60
                SUB     R8,R4,R8                     ; R8 = Rest-sekunden (0..59) innerhalb der aktuellen Minute
                
                LDR     R1,=MINUTES                  ; Adresse von Minuten laden
                STR     R7,[R1]                      ; Minuten speichern

                LDR     R1,=SECONDS                  ; Adresse von Sekunden laden
                STR     R8,[R1]                      ; Rest-Sekunden speichern

                BX      LR
                ENDP

twoDigitsToAscii PROC
                MOV     R1,#10

                UDIV    R2,R0,R1                     ; Zehnerstelle bestimmen
 
                MUL     R3,R2,R1
                SUB     R3,R0,R3                     ; Einerstelle bestimmen

                ADD     R2,R2,#0x30                  ; ASCII-Zehner
                ADD     R3,R3,#0x30                  ; ASCII-Einer

                BX      LR
                ENDP
                             	
displayTime PROC
               PUSH    {R4,R5,LR}

               LDR     R4,=MY_TEXT                    ; Adresse von MY_TEXT merken     

               LDR     R5,=MINUTES                    ; MINUTES lesen und in ASCII umwandeln
               LDR     R0,[R5]
               BL      twoDigitsToAscii               ; Zahl in zwei ASCII-Zeichen umwandeln, macht draus (R2 = '0' und R3 = '0')
               STRB    R2,[R4,#0]                     ; Schreibt in MY_TEXT[0] 
               STRB    R3,[R4,#1]                     ; Schreibt in MY_TEXT[1] 

               LDR     R5,=SECONDS                    ; SECONDS lesen und in ASCII umwandeln
               LDR     R0,[R5] 
               BL      twoDigitsToAscii               
               STRB    R2,[R4,#3]                      
               STRB    R3,[R4,#4]                     

               LDR     R5,=HUNDREDTHS                 ; HUNDREDTHS lesen und in ASCII umwandeln
               LDR     R0,[R5]
               BL      twoDigitsToAscii
               STRB    R2,[R4,#6]                     
               STRB    R3,[R4,#7]                     
 
             
               MOV     R0, #5                         ; X Position der Zeitanzeige
               MOV     R1, #3                         ; Y Position der Zeitanzeige
               BL      lcdGotoXY                      ; Cursor auf feste Position setzen

        
               LDR     R0,=MY_TEXT                    ; Zeitstring anzeigen
               BL      lcdPrintS

               POP     {R4,R5,PC}
               ENDP

updateClk PROC
               PUSH    {LR} 

               LDR     R0,=TIMER
               LDR     R0,[R0]                        ; Aktuellen Timerwert lesen
              
               LDR     R1,=LAST_TIMESTAMP             ; Differenz zum letzten Zeitstempel brechnen
               LDR     R2, [R1]
               SUB     R3,R0,R2
               
               STR     R0, [R1]                       ; Aktuellen Zeitstempel als neuen Zeitstempel speichern
  
               LDR     R1,=STATE                      ; STATE lesen
               LDRB    R0,[R1]

        
               CMP     R0,#1                          ; Prüfen, ob Zustand RUNNING aktive ist
               BEQ     updateRunning                  ; nur im RUNNING-Zustand Zeit aktualisieren

               POP     {PC}

updateRunning
               LDR     R1,=STOPWATCH_TICKS            ; STOPWATCH_TICKS += Delta
               LDR     R0,[R1]
               ADD     R0,R0,R3
               STR     R0,[R1]

               BL      convertTime                    ; R0 = gesamte gestoppte Zeit
               BL      displayTime

               POP     {PC}
               ENDP

stateMachine PROC                                    ; Zustand der Taster bestimmen
               PUSH    {R2,LR}

               MOV     R2,R0

               TST     R2,#0x20
               BEQ     setInit

               TST     R2,#0x40
               BEQ     setHold

               TST     R2,#0x80
               BEQ     setRunning

               POP     {R2,PC}

setInit       
               LDR     R1,=STATE                    ; Zustand auf INIT setzen
               MOV     R0,#0
               STRB    R0,[R1]                      ; STATE = INIT speichern
          
               LDR     R1,=TIM2_ERG                 ; Timer neu starten / zuruecksetzen
               MOV     R0,#0x01
               STRH    R0,[R1]

               LDR     R1,=HUNDREDTHS               ; Anzeige wieder auf 00:00.00 setzen
               MOV     R0,#0
               STR     R0,[R1]

               LDR     R1,=SECONDS
               STR     R0,[R1]

               LDR     R1,=MINUTES
               STR     R0,[R1]

               LDR     R1,=STOPWATCH_TICKS
               MOV     R0,#0
               STR     R0,[R1]

               LDR     R1,=LAST_TIMESTAMP
               MOV     R0,#0
               STR     R0,[R1]

               BL      displayTime  

               BL      displayTime

               POP     {R2,PC}

setHold
               LDR     R1,=STATE
               MOV     R0,#2
               STRB    R0,[R1]
               POP     {R2,PC}
        

setRunning
               LDR     R1,=STATE
               MOV     R0,#1
               STRB    R0,[R1]
               POP     {R2,PC}	
               ENDP	

showStateLEDs PROC

               MOV     R0,#0x03                      ; LEDs D8-D9 zunächst ausschalten      
               LDR     R1,=GPIO_D_CLR
               STR     R0,[R1]

               LDR     R1,=STATE                     ; STATE lesen
               LDRB    R0,[R1]
 
               CMP     R0,#0
               BEQ     showInit

               CMP     R0,#1
               BEQ     showRunning

               CMP     R0,#2
               BEQ     showHold

               BX      LR

showInit
               MOV     R0,#0x00                       ; INIT: D8 aus, D9 aus
               B       setStateLed

showRunning
               MOV     R0,#0x01                       ; RUNNING: D8 an, D9 aus
               B       setStateLed

showHold
               MOV     R0,#0x03                       ; HOLD: D8 an, D9 an

setStateLed
               LDR     R1,=GPIO_D_SET
               STR     R0,[R1]
               BX      LR
               ENDP

        ALIGN
        END 