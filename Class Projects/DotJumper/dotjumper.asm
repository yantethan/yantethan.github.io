; Dot Jumper Gamee
; Ethan Yant

; PIC18F452 Configuration Bit Settings
; Assembly source line config statements

; CONFIG1H
  CONFIG  OSC = XT           ; Oscillator Selection bits (RC oscillator w/ OSC2 configured as RA6)
  CONFIG  OSCS = OFF            ; Oscillator System Clock Switch Enable bit (Oscillator system clock switch option is disabled (main oscillator is source))

; CONFIG2L
  CONFIG  PWRT = ON           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOR = ON           ; Brown-out Reset Enable bit (Brown-out Reset disabled)
  CONFIG  BORV = 20             ; Brown-out Reset Voltage bits (VBOR set to 2.0V)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 128           ; Watchdog Timer Postscale Select bits (1:128)

; CONFIG3H
  CONFIG  CCP2MUX = OFF         ; CCP2 Mux bit (CCP2 input/output is multiplexed with RB3)

; CONFIG4L
  CONFIG  STVR = OFF            ; Stack Full/Underflow Reset Enable bit (Stack Full/Underflow will not cause RESET)
  CONFIG  LVP = OFF             ; Low Voltage ICSP Enable bit (Low Voltage ICSP disabled)

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000200-001FFFh) not code protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot Block (000000-0001FFh) not code protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000200-001FFFh) not write protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot Block (000000-0001FFh) not write protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000200-001FFFh) not protected from Table Reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from Table Reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from Table Reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from Table Reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot Block (000000-0001FFh) not protected from Table Reads executed in other blocks)
  PROCESSOR 18f452
  #include <xc.inc>

PSECT resetVect, class=CODE, reloc=2, abs
; Intialize Variables
Seg1 EQU 0x000					; 7-Segment Values
Seg2 EQU 0x001
Seg3 EQU 0x002
Seg4 EQU 0x003
Seg5 EQU 0x004
An EQU 0x005					; Anode Data
DotRow1 EQU 0x006				; DotMatrix Row Data
DotRow2 EQU 0x007
DotRow3 EQU 0x008
DotRow4 EQU 0x009
DotRow5 EQU 0x00A
DotRow6 EQU 0x00B
DotRow7 EQU 0x00C
DotRow8 EQU 0x00D
Player_X EQU 0x00E				; Current Player Position
Player_Y EQU 0x00F
Counter1 EQU 0x010				; Loop Counters
Counter2 EQU 0x011
X_Pos EQU 0x012
Y_Pos EQU 0x013
ADC_Select EQU 0x014			; ADC Variables
ADC_Pos_Buf EQU 0x015
Max_Address EQU 0x016			; SPI Communication
Max_Data EQU 0x017
Col_Det EQU 0x018				; Other Game Registers 
StoreW EQU 0x019
LevelSpeed EQU 0x01A
LevelSpeedSet EQU 0x01B
PlayerStartX EQU 0x01C
PlayerStartY EQU 0x01D
Finish_Det EQU 0x01E 
FinishCounter EQU 0x01F
CelLeft EQU 0x020
CelRight EQU 0x021
LevelSelect EQU 0x022
 
ORG 0x0000
    GOTO Sys_Init
     
ORG 0x000008 ; Reserved address for inturrut handler
    BTFSS INTCON, 2
    RETFIE
    GOTO T0_ISR 
    
; Timer Inturupt Calls Segment Update to Rotate Anodes
ORG 0x0100
    T0_ISR:
	MOVWF StoreW, 0
	CALL Segment_Update, 1
	MOVLW 0x00
	IORWF StoreW, 0
	RETFIE
	
; Program Start
ORG 0x0200
	Sys_Init:
		//Initalize Values
		MOVLW 0x00
		MOVWF Seg1
		MOVWF Seg2
		MOVWF Seg3
		MOVWF Seg4
		MOVWF Seg5
		MOVWF An
		MOVWF ADC_Select
		MOVWF DotRow1
		MOVWF DotRow2
		MOVWF DotRow3
		MOVWF DotRow4
		MOVWF DotRow5
		MOVWF DotRow6
		MOVWF DotRow7
		MOVWF DotRow8
		MOVWF Col_Det
		MOVWF Finish_Det
		MOVLW 0x01
		MOVWF Player_X
		MOVWF Player_Y
		MOVWF X_Pos
		MOVWF Y_Pos
		MOVWF ADC_Pos_Buf
		MOVWF LevelSelect
		MOVLW 0x08
		MOVWF PlayerStartX
		MOVLW 0x01
		MOVWF PlayerStartY
		MOVWF CelLeft
		MOVWF CelRight
		
		//Setup Inputs and Outputs
		CLRF TRISD				;PORTD Output
		CLRF TRISB				;PORTB Output	
		
		//Initialize ADC
		BSF TRISA, 0			;Set RA0 and RA1 to Input
		BSF TRISA, 1
		MOVLW 0b10000001 //Sets AD Clock to Frc, channel AN0, and turns on the converter
		MOVWF ADCON0
		MOVLW 0b11000100 //Sets result to right justified, Clock to Frc, and Port Configuration AN0, 1, and 3 to analog, and Vref is PIC
		MOVWF ADCON1
		BCF ADCON0, 5			;Set to Channel 00x
		BCF ADCON0, 4
		
		//Initialize Timers and Inturrupts
		MOVLW 0x08				;timer0, 16-bit, internal clock, no prescaler
		MOVWF T0CON
		MOVLW 0xF6				;2500 Counter giving 400 Hz
		MOVWF TMR0H
		MOVLW 0x2F
		MOVWF TMR0L
		BCF INTCON, 2			;Clear TMR0 Inturrupt Flag
		MOVLW 0xFE 
		MOVWF PORTB
		
		//Initialize MSSP for SLI
		MOVLW 0b01000000    	; Sample Middle, Transmit on Falling Edge
		MOVWF SSPSTAT	
		MOVLW 0b00110001    	;SPI master mode, Enable Sync Pins, Clk Idle High, clock = Fosc / 16
		MOVWF SSPCON1
		CLRF TRISC	    		;Make PORTC as Output
		BSF TRISC, 4	    	;Except SDI
		BCF PIR1, 3	    		;Clears MSSP IF to Waiting Transmit
		BSF PORTC, 2	    	;Set chip select high (Unselected)
		
		BSF TRISC, 1	    	;Set RC1 as Input for Joystick Button Pressing
		
		//Setup Inturrupts and start timer
		BSF INTCON, 5
		BSF INTCON, 7
		BSF T0CON, 7			;Start TMR0
		
		//Initialize Dot Display
		CALL Max_Init

; Game Start
ORG 0x0300
	//Game Menu
    Menu: 
		CALL Clear_Max
		CALL Clear_MAX_Reg
		MOVLW 0x00
		MOVWF Seg1
		MOVLW 0xFF
		MOVWF Seg2
		MOVLW 0x55
		MOVWF Seg3
		MOVLW 0xAA
		MOVWF Seg4
		MOVLW 0x80
		MOVWF Seg5
		MenuLoop: RRNCF Seg3
		RLNCF Seg4
		INCF Seg1
		DECF Seg2
		INCF Seg5
		CALL S_Delay
		BTFSC PORTC, 1
		BRA MenuLoop
    
    //Display Start and Begin Game
	PlayGame:
		MOVLW 0b01011011
		MOVWF Seg1
		MOVLW 0b00000111
		MOVWF Seg2
		MOVLW 0b01110111
		MOVWF Seg3
		MOVLW 0b00000101
		MOVWF Seg4
		MOVLW 0b00000111
		MOVWF Seg5
		CALL L_Delay
		CALL L_Delay

		MOVLW 0x01						; Start at Level 1
		MOVWF LevelSelect
	
	//Load the Level Data based on LevelSelect Register
	LevelDataLoad:
	    MOVFF PlayerStartX, Player_X
	    MOVFF PlayerStartY, Player_Y
	    MOVLW 0x01
	    XORWF LevelSelect, 0
	    BZ Level1
	    MOVLW 0x02
	    XORWF LevelSelect, 0
	    BZ Level2
	    MOVLW 0x03
	    XORWF LevelSelect, 0
	    BZ Level3
	    MOVLW 0x04
	    XORWF LevelSelect, 0
	    BZ Level4
	    MOVLW 0x05
	    XORWF LevelSelect, 0
	    BZ Level5
	    MOVLW 0x06
	    XORWF LevelSelect, 0
	    BZ Level6Jump
	    MOVLW 0x07
	    XORWF LevelSelect, 0
	    BZ Level7Jump
	    MOVLW 0x08
	    XORWF LevelSelect, 0
	    BZ Level8Jump
	    MOVLW 0x09
	    XORWF LevelSelect, 0
	    BZ Level9Jump
	    MOVLW 0x0A
	    XORWF LevelSelect, 0
	    BZ Level10Jump
	    CALL Celebrate
	    GOTO Menu
	    Level6Jump: GOTO Level6
	    Level7Jump: GOTO Level7
	    Level8Jump: GOTO Level8
	    Level9Jump:	GOTO Level9
	    Level10Jump: GOTO Level10
	   
		//Level Data Sets the Logs and the Game Speed
	    Level1: MOVLW 0b00001110
			MOVWF Seg1
			MOVLW 0b00000110
			MOVWF Seg2
			MOVLW 0x00
			MOVWF Seg3
			MOVWF Seg4
			MOVWF Seg5
			MOVLW 0b01100011
			MOVWF DotRow3
			MOVLW 0b00011000
			MOVWF DotRow7
			MOVLW 0x0A
			MOVWF LevelSpeed
			MOVWF LevelSpeedSet
			GOTO Game_Loop
	    Level2: MOVLW 0b00001110
			MOVWF Seg1
			MOVLW 0b01101101
			MOVWF Seg2
			MOVLW 0x00
			MOVWF Seg3
			MOVWF Seg4
			MOVWF Seg5
			MOVLW 0b01110011
			MOVWF DotRow3
			MOVLW 0b01100110
			MOVWF DotRow7
			MOVLW 0x09
			MOVWF LevelSpeed
			MOVWF LevelSpeedSet
			GOTO Game_Loop
		Level3: MOVLW 0b00001110
			MOVWF Seg1
			MOVLW 0b01111001
			MOVWF Seg2
			MOVLW 0x00
			MOVWF Seg3
			MOVWF Seg4
			MOVWF Seg5
			MOVLW 0b01100011
			MOVWF DotRow3
			MOVLW 0b01010011
			MOVWF DotRow5
			MOVLW 0b00011000
			MOVWF DotRow7
			MOVLW 0x09
			MOVWF LevelSpeed
			MOVWF LevelSpeedSet
			GOTO Game_Loop
	    Level4: MOVLW 0b00001110
			MOVWF Seg1
			MOVLW 0b00110011
			MOVWF Seg2
			MOVLW 0x00
			MOVWF Seg3
			MOVWF Seg4
			MOVWF Seg5
			MOVLW 0b01010110
			MOVWF DotRow3
			MOVLW 0b00011010
			MOVWF DotRow5
			MOVLW 0b11011011
			MOVWF DotRow7
			MOVLW 0x08
			MOVWF LevelSpeed
			MOVWF LevelSpeedSet
			GOTO Game_Loop
	    Level5: MOVLW 0b00001110
			MOVWF Seg1
			MOVLW 0b01011011
			MOVWF Seg2
			MOVLW 0x00
			MOVWF Seg3
			MOVWF Seg4
			MOVWF Seg5
			MOVLW 0b01100011
			MOVWF DotRow3
			MOVLW 0b01010011
			MOVWF DotRow5
			MOVLW 0b00011000
			MOVWF DotRow7
			MOVLW 0x08
			MOVWF LevelSpeed
			MOVWF LevelSpeedSet
			GOTO Game_Loop
	    Level6: MOVLW 0b00001110
			MOVWF Seg1
			MOVLW 0b00011111
			MOVWF Seg2
			MOVLW 0x00
			MOVWF Seg3
			MOVWF Seg4
			MOVWF Seg5
			MOVLW 0b01101011
			MOVWF DotRow3
			MOVLW 0b01010011
			MOVWF DotRow5
			MOVLW 0b11011000
			MOVWF DotRow7
			MOVLW 0x07
			MOVWF LevelSpeed
			MOVWF LevelSpeedSet
			GOTO Game_Loop
	    Level7: MOVLW 0b00001110
			MOVWF Seg1
			MOVLW 0b01110000
			MOVWF Seg2
			MOVLW 0x00
			MOVWF Seg3
			MOVWF Seg4
			MOVWF Seg5
			MOVLW 0b01101011
			MOVWF DotRow2
			MOVLW 0b01010011
			MOVWF DotRow4
			MOVLW 0b11010010
			MOVLW DotRow5
			MOVLW 0b00101011
			MOVWF DotRow7
			MOVLW 0x07
			MOVWF LevelSpeed
			MOVWF LevelSpeedSet
			GOTO Game_Loop
	    Level8: MOVLW 0b00001110
			MOVWF Seg1
			MOVLW 0b01111111
			MOVWF Seg2
			MOVLW 0x00
			MOVWF Seg3
			MOVWF Seg4
			MOVWF Seg5
			MOVLW 0b01111001
			MOVWF DotRow2
			MOVLW 0b11010010
			MOVWF DotRow4
			MOVLW 0b10011010
			MOVLW DotRow5
			MOVLW 0b10001011
			MOVWF DotRow7
			MOVLW 0x05
			MOVWF LevelSpeed
			MOVWF LevelSpeedSet
			GOTO Game_Loop
	    Level9: MOVLW 0b00001110
			MOVWF Seg1
			MOVLW 0b01110011
			MOVWF Seg2
			MOVLW 0x00
			MOVWF Seg3
			MOVWF Seg4
			MOVWF Seg5
			MOVLW 0b010010101
			MOVWF DotRow2
			MOVLW 0b010101011
			MOVWF DotRow4
			MOVLW 0b110100101
			MOVWF DotRow5
			MOVLW 0b001011010
			MOVWF DotRow7
			MOVLW 0x04
			MOVWF LevelSpeed
			MOVWF LevelSpeedSet
			GOTO Game_Loop
	    Level10: MOVLW 0b00001110
			MOVWF Seg1
			MOVLW 0b00110000
			MOVWF Seg2
			MOVLW 0b01111110
			MOVWF Seg3
			MOVLW 0x00
			MOVWF Seg4
			MOVWF Seg5
			MOVLW 0b01001101
			MOVWF DotRow2
			MOVLW 0b10011011
			MOVWF DotRow3
			MOVLW 0b11010010
			MOVWF DotRow5
			MOVLW 0b00101011
			MOVWF DotRow6
			MOVLW 0x03
			MOVWF LevelSpeed
			MOVWF LevelSpeedSet
			
	//Main Game Loop
	Game_Loop:
	    TSTFSZ DotRow8				;Check if Player has reached row 9
	    BRA LComplete
	    BTFSS PORTC, 1				;Check if player has pressed the joystick to return to menu
	    BRA Menu
	    BCF ADC_Select, 0			;Read joystick x and y positions - ADC_Select = 0 or 1 to represent x or y reading
	    CALL Read_ADC
	    BSF ADC_Select, 0
	    CALL Read_ADC
	    CALL Dot_Draw				;Update row data with player position and log rotation
	    CALL Max_Update				;Refresh dot matrix to display the new row data
	    CALL S_Delay
	    TSTFSZ Col_Det				;Check if player has collided with a row
	    BRA LFail
	    BRA Game_Loop
	    LFail: CALL TriggerCol
	    BRA LevelDataLoad
	    LComplete: CALL TriggerComp
	    INCF LevelSelect
	    GOTO LevelDataLoad
    
ORG 0x1000
Dot_Draw:
	Player_Remove: MOVLW 0x01		;Remove player from row data to prevent the player from rotating with the rows
	    ANDWF Player_Y, 0
	    BZ RRow2
	    MOVFF Player_X, WREG
	    COMF WREG, 0
	    ANDWF DotRow1, 1
	    BRA Game_Draw
	    RRow2: MOVLW 0x02
	    ANDWF Player_Y, 0
	    BZ RRow3
	    MOVFF Player_X, WREG
	    COMF WREG, 0
	    ANDWF DotRow2, 1
	    BRA Game_Draw
	    RRow3: MOVLW 0x04
	    ANDWF Player_Y, 0
	    BZ RRow4
	    MOVFF Player_X, WREG
	    COMF WREG, 0
	    ANDWF DotRow3, 1
	    BRA Game_Draw
	    RRow4: MOVLW 0x08
	    ANDWF Player_Y, 0
	    BZ RRow5
	    MOVFF Player_X, WREG
	    COMF WREG, 0
	    ANDWF DotRow4, 1
	    BRA Game_Draw
	    RRow5: MOVLW 0x10
	    ANDWF Player_Y, 0
	    BZ RRow6
	    MOVFF Player_X, WREG
	    COMF WREG, 0
	    ANDWF DotRow5, 1
	    BRA Game_Draw
	    RRow6: MOVLW 0x20
	    ANDWF Player_Y, 0
	    BZ RRow7
	    MOVFF Player_X, WREG
	    COMF WREG, 0
	    ANDWF DotRow6, 1
	    BRA Game_Draw
	    RRow7: MOVLW 0x40
	    ANDWF Player_Y, 0
	    BZ RRow8
	    MOVFF Player_X, WREG
	    COMF WREG, 0
	    ANDWF DotRow7, 1
	    BRA Game_Draw
	    RRow8: MOVFF Player_X, WREG
	    COMF WREG, 0
	    ANDWF DotRow8, 1

	Game_Draw: DECF LevelSpeed			;Rotate Rows based on level speed
	    BNZ XMoveRight
	    RRNCF DotRow2
	    RRNCF DotRow3
	    RLNCF DotRow4
	    RRNCF DotRow5
	    RLNCF DotRow6
	    RLNCF DotRow7
	    MOVFF LevelSpeedSet, LevelSpeed

	XMoveRight: MOVFF X_Pos, WREG		;Update player position based on ADC Reading
	    ANDLW 0x02
	    BZ XMoveLeft
	    MOVFF Player_X, WREG
	    ANDLW 0x80
	    BNZ PDrawLoad
	    RLNCF Player_X
	    BRA YMoveUp
	XMoveLeft: MOVFF X_Pos, WREG
	    ANDLW 0x01
	    BNZ YMoveUp
	    MOVFF Player_X, WREG
	    ANDLW 0x01
	    BNZ PDrawLoad
	    RRNCF Player_X

	YMoveUp: MOVFF Y_Pos, WREG
	    ANDLW 0x02
	    BZ YMoveDown
	    MOVFF Player_Y, WREG
	    ANDLW 0x80
	    BNZ PDrawLoad
	    RLNCF Player_Y
	    BRA PDrawLoad
	YMoveDown: MOVFF Y_Pos, WREG
	    ANDLW 0x01
	    BNZ PDrawLoad
	    MOVFF Player_Y, WREG
	    ANDLW 0x01
	    BNZ PDrawLoad
	    RRNCF Player_Y

	PDrawLoad: MOVLW 0x01				;Add the player back to the rows and check for collision
	    ANDWF Player_Y, 0
	    BZ Row2
	    MOVFF Player_X, WREG
	    MOVFF DotRow1, Col_Det
	    ANDWF Col_Det, 1
	    IORWF DotRow1, 1
	    BRA EndDraw
	    Row2: MOVLW 0x02
	    ANDWF Player_Y, 0
	    BZ Row3
	    MOVFF Player_X, WREG
	    MOVFF DotRow2, Col_Det
	    ANDWF Col_Det, 1
	    IORWF DotRow2, 1
	    BRA EndDraw
	    Row3: MOVLW 0x04
	    ANDWF Player_Y, 0
	    BZ Row4
	    MOVFF Player_X, WREG
	    MOVFF DotRow3, Col_Det
	    ANDWF Col_Det, 1
	    IORWF DotRow3, 1
	    BRA EndDraw
	    Row4: MOVLW 0x08
	    ANDWF Player_Y, 0
	    BZ Row5
	    MOVFF Player_X, WREG
	    MOVFF DotRow4, Col_Det
	    ANDWF Col_Det, 1
	    IORWF DotRow4, 1
	    BRA EndDraw
	    Row5: MOVLW 0x10
	    ANDWF Player_Y, 0
	    BZ Row6
	    MOVFF Player_X, WREG
	    MOVFF DotRow5, Col_Det
	    ANDWF Col_Det, 1
	    IORWF DotRow5, 1
	    BRA EndDraw
	    Row6: MOVLW 0x20
	    ANDWF Player_Y, 0
	    BZ Row7
	    MOVFF Player_X, WREG
	    MOVFF DotRow6, Col_Det
	    ANDWF Col_Det, 1
	    IORWF DotRow6, 1
	    BRA EndDraw
	    Row7: MOVLW 0x40
	    ANDWF Player_Y, 0
	    BZ Row8
	    MOVFF Player_X, WREG
	    MOVFF DotRow7, Col_Det
	    ANDWF Col_Det, 1
	    IORWF DotRow7, 1
	    BRA EndDraw
	    Row8: MOVFF Player_X, WREG
	    MOVFF DotRow1, Col_Det
	    ANDWF Col_Det, 1
	    IORWF DotRow8, 1

	    EndDraw: MOVFF DotRow8, WREG
	    ANDLW 0xFF
	    BZ EndDraw2
	    MOVLW 0x01
	    MOVWF Finish_Det
	    EndDraw2: RETURN

//Level Failed Animation
TriggerCol:
	MOVLW 0b00001110
	MOVWF Seg1
	MOVLW 0b01111110
	MOVWF Seg2
	MOVLW 0b01011011
	MOVWF Seg3
	MOVLW 0b01001111
	MOVWF Seg4
	MOVLW 0b00000101
	MOVWF Seg5

	MOVLW 0x81
	MOVWF DotRow1
	MOVLW 0x42
	MOVWF DotRow2
	MOVLW 0x24
	MOVWF DotRow3
	MOVLW 0x18
	MOVWF DotRow4
	MOVWF DotRow5
	MOVLW 0x24
	MOVWF DotRow6
	MOVLW 0x42
	MOVWF DotRow7
	MOVLW 0x81
	MOVWF DotRow8
	CALL Max_Update
	CALL L_Delay
	CALL L_Delay
	CALL Clear_MAX_Reg
	CALL Clear_Max
	MOVLW 0x00
	MOVWF Finish_Det
	RETURN

//Level Completed Animation
TriggerComp: 
	MOVLW 0x04
	MOVWF FinishCounter
	MOVLW 0b01111011
	MOVWF Seg1
	MOVLW 0b00011101
	MOVWF Seg2
	MOVLW 0b00011101
	MOVWF Seg3
	MOVLW 0b00111101
	MOVWF Seg4
	MOVLW 0b0000000
	MOVWF Seg5
	MOVLW 0x55
	MOVWF DotRow1
	MOVLW 0xAA
	MOVWF DotRow2
	MOVLW 0x55
	MOVWF DotRow3
	MOVLW 0xAA
	MOVWF DotRow4
	MOVLW 0x55
	MOVWF DotRow5
	MOVLW 0xAA
	MOVWF DotRow6
	MOVLW 0x55
	MOVWF DotRow7
	MOVLW 0xAA
	MOVWF DotRow8
	CompleteLoop: RRNCF DotRow1
		RLNCF DotRow2
		RRNCF DotRow3
		RLNCF DotRow4
		RRNCF DotRow5
		RLNCF DotRow6
		RRNCF DotRow7
		RLNCF DotRow8
		CALL Max_Update
		CALL L_Delay
		DECF FinishCounter
		BNZ CompleteLoop
		CALL Clear_MAX_Reg
		CALL Clear_Max
		MOVLW 0x00
		MOVWF Finish_Det
		RETURN

//Celebration Animation when Completing all Levels
Celebrate: MOVLW 0x00
	MOVWF CelRight
	MOVWF Seg1
	MOVWF Seg5
	MOVLW 0xFF
	MOVWF CelLeft
	MOVLW 0b01000111
	MOVWF Seg2
	MOVLW 0b00000100
	MOVWF Seg3
	MOVLW 0b00010101
	MOVWF Seg4

	//Celebration Loop
	CelebrateLoop: TSTFSZ CelLeft
		BRA KeepCelebrate
		BRA EndCelebrate
		KeepCelebrate: MOVFF CelRight, DotRow1
		MOVFF CelRight, DotRow3
		MOVFF CelRight, DotRow5
		MOVFF CelRight, DotRow7
		MOVFF CelRight, DotRow2
		CLRF DotRow2
		BTFSC CelRight, 0
		BSF DotRow2, 7
		BTFSC CelRight, 1
		BSF DotRow2, 6
		BTFSC CelRight, 2
		BSF DotRow2, 5
		BTFSC CelRight, 3
		BSF DotRow2, 4
		BTFSC CelRight, 4
		BSF DotRow2, 3
		BTFSC CelRight, 5
		BSF DotRow2, 2
		BTFSC CelRight, 6
		BSF DotRow2, 1
		BTFSC CelRight, 7
		BSF DotRow2, 0
		MOVFF DotRow2, DotRow4
		MOVFF DotRow2, DotRow6
		MOVFF DotRow2, DotRow8

		CALL Max_Update
		CALL SS_Delay
		INCF CelRight
		DECF CelLeft
		BTFSS PORTC, 1
		BRA EndCelebrate
		BRA CelebrateLoop
	
	//Celebration Finished
	EndCelebrate: CALL Clear_MAX_Reg
		CALL Clear_Max
		MOVLW 0x00
		MOVWF Finish_Det
		RETURN


//Function for Reading ADC Values (ADC_Select = 0 for X, 1 for Y)
Read_ADC:
    BTFSC ADC_Select, 0				;Selects ADC Channel to Read from (for X or Y)
    BRA Select_Y
    BCF ADCON0, 3
    BRA Start_ADC
    Select_Y: BSF ADCON0, 3

    Start_ADC: BSF ADCON0, 2		;Reading ADC value, loop here until done
    Reading: BTFSC ADCON0, 2
    BRA Reading

    MOVFF ADRESH, WREG				;Check if value is past threshold values to have player move
    XORLW 0x03
    BNZ Check_Low
    MOVLW 0x02
    MOVWF ADC_Pos_Buf
    BRA PosLoad
    Check_Low: MOVFF ADRESH, WREG
    XORLW 0x00
    BNZ SetCenter
    MOVLW 0x00
    MOVWF ADC_Pos_Buf
    BRA PosLoad

    SetCenter:
	MOVLW 0x01
	MOVWF ADC_Pos_Buf

    PosLoad: BTFSC ADC_Select, 0	;Sets the new player position
    BRA LoadY
    MOVFF ADC_Pos_Buf, Y_Pos
    RETURN
    LoadY: MOVFF ADC_Pos_Buf, X_Pos
    RETURN 

//Super-Short Delay 
SS_Delay:
	MOVLW 0x43
	MOVWF Counter1
	MOVWF Counter2

	SSLoop1: DCFSNZ Counter1
		RETURN
		MOVWF Counter2
		SSLoop2: DCFSNZ Counter2
		BRA SSLoop1
		BRA SSLoop2

//Short Delay
S_Delay:
	MOVLW 0x8F
	MOVWF Counter1
	MOVWF Counter2

	SLoop1: DCFSNZ Counter1
		RETURN
		MOVWF Counter2
		SLoop2: DCFSNZ Counter2
		BRA SLoop1
		BRA SLoop2

//Long Delay
L_Delay:  MOVLW 0xFF
    MOVWF Counter1
    MOVWF Counter2

    LLoop1: DCFSNZ Counter1
	RETURN
	MOVWF Counter2
	LLoop2: DCFSNZ Counter2
	BRA LLoop1
	BRA LLoop2

//Display Functions Code
ORG 0x2000
    /* Function to Cycle Anode selection for 7-Segment Display */
    /*   Updated only by the TMR0 Inturrupt Service Routine    */
    Segment_Update:
	Next1:			//If an = 11110
	    MOVFF PORTB, WREG
	    XORLW 0xFE
	    BNZ Next2
	    RLNCF PORTB, 1
	    MOVFF Seg4, PORTD
	    BRA Seg_Done
	
	Next2:			//if an = 11101
	    MOVFF PORTB, WREG
	    XORLW 0xFD
	    BNZ Next3
	    RLNCF PORTB, 1
	    MOVFF Seg3, PORTD
	    BRA Seg_Done
	
	Next3:			//if an = 11011
	    MOVFF PORTB, WREG
	    XORLW 0xFB
	    BNZ Next4
	    RLNCF PORTB, 1
	    MOVFF Seg2, PORTD
	    BRA Seg_Done
	
	Next4:			//if an = 10111
	    MOVFF PORTB, WREG
	    XORLW 0xF7
	    BNZ Next5
	    RLNCF PORTB, 1
	    MOVFF Seg1, PORTD
	    BRA Seg_Done
	
	Next5:			//If an = 01111
	    MOVFF PORTB, WREG
	    XORLW 0xEF
	    BNZ Next1
	    MOVLW 0xFE
	    MOVWF PORTB
	    MOVFF Seg5, PORTD
	    BRA Seg_Done
	
	Seg_Done:
	    MOVLW 0xF6		;Reset Timer Counter
	    MOVWF TMR0H
	    MOVLW 0x2F
	    MOVWF TMR0L
	    BCF INTCON, 2	;Clear Inturrupt Flag
	    BSF T0CON, 7	;Start Timer Again
	    RETURN
	    
//Initialize Max 
    Max_Init:
	MOVLW 0x09
	MOVWF Max_Address
	MOVLW 0x00
	MOVWF Max_Data
	CALL Write_Max	    ;Decoding : BCD
	MOVLW 0x0A
	MOVWF Max_Address
	MOVLW 0x03
	MOVWF Max_Data
	CALL Write_Max	    ;Brightness
	MOVLW 0x0B
	MOVWF Max_Address
	MOVLW 0x07
	MOVWF Max_Data
	CALL Write_Max	    ;Scanlimit: 8 LEDs
	MOVLW 0x0C
	MOVWF Max_Address
	MOVLW 0x01
	MOVWF Max_Data
	CALL Write_Max	    ;Power-Down Mode: 0, normal mode: 1
	MOVLW 0x0F
	MOVWF Max_Address
	MOVLW 0x00
	MOVWF Max_Data
	CALL Write_Max	    ;Test Display : 1: EOT, display: 0
	RETURN

//Updates the Dot Matrix with the Stored Rows Values
Max_Update:
    MOVLW 0x01
    MOVWF Max_Address
    MOVFF DotRow1, Max_Data
    CALL Write_Max
    INCF Max_Address
    MOVFF DotRow2, Max_Data
    CALL Write_Max
    INCF Max_Address
    MOVFF DotRow3, Max_Data
    CALL Write_Max
    INCF Max_Address
    MOVFF DotRow4, Max_Data
    CALL Write_Max
    INCF Max_Address
    MOVFF DotRow5, Max_Data
    CALL Write_Max
    INCF Max_Address
    MOVFF DotRow6, Max_Data
    CALL Write_Max
    INCF Max_Address
    MOVFF DotRow7, Max_Data
    CALL Write_Max
    INCF Max_Address
    MOVFF DotRow8, Max_Data
    CALL Write_Max
    
    RETURN
    

//Write Function to Write Data to the Dot Matrix using the MSSP Module
Write_Max:
    BCF PORTC, 2 				; Set CS to low

    BCF PIR1, 3 				; Clear Transmit Check Bit
    MOVFF Max_Address, SSPBUF 	; Load Address into SSPBUF to Transmit
    Rec_Check: BTFSS PIR1, 3 	; Wait for Transmit to Complete <- MPLAB Sim Gets Stuck Here
    BRA Rec_Check 				; Loop Until Transmit Completes

    BCF PIR1, 3					; Same process as above except for the data
    MOVFF Max_Data, SSPBUF
    Rec_Check2: BTFSS PIR1, 3
    BRA Rec_Check2 

    BSF PORTC, 2 ; Set CS to High

    RETURN

//Clears the Dot Matrix
Clear_Max: 
    MOVLW 0x01
    MOVWF Max_Address
    MOVLW 0x00
    MOVWF Max_Data
    CALL Write_Max
    INCF Max_Address
    CALL Write_Max
    INCF Max_Address
    CALL Write_Max
    INCF Max_Address
    CALL Write_Max
    INCF Max_Address
    CALL Write_Max
    INCF Max_Address
    CALL Write_Max
    INCF Max_Address
    CALL Write_Max
    INCF Max_Address
    CALL Write_Max
    RETURN
   
//Clears the Row Data   
Clear_MAX_Reg: MOVLW 0x00 
	MOVWF DotRow1
	MOVWF DotRow2
	MOVWF DotRow3
	MOVWF DotRow4
	MOVWF DotRow5
	MOVWF DotRow6
	MOVWF DotRow7
	MOVWF DotRow8
	RETURN
END
