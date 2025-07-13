_SPC        equ 0x00        ; " "
_DQT        equ 0x0b        ; "
_PND        equ 0x0c        ; Â£
_DLR        equ 0x0d        ; $
_CLN        equ 0x0e        ; :
_QMK        equ 0x0f        ; ?
_OBR        equ 0x10        ; (
_CBR        equ 0x11        ; )
_GTH        equ 0x12        ; >
_LTH        equ 0x13        ; <
_EQU        equ 0x14        ; =
_PLS        equ 0x15        ; +
_MNS        equ 0x16        ; -
_ASK        equ 0x17        ; *
_SLS        equ 0x18        ; /
_SMC        equ 0x19        ; ;
_CMA        equ 0x1a        ; ,
_FST        equ 0x1b        ; .
_0      equ 0x1c
_1      equ 0x1d
_2      equ 0x1e
_3      equ 0x1f
_4      equ 0x20
_5      equ 0x21
_6      equ 0x22
_7      equ 0x23
_8      equ 0x24
_9      equ 0x25
_A      equ 0x26
_B      equ 0x27
_C      equ 0x28
_D      equ 0x29
_E      equ 0x2a
_F      equ 0x2b
_G      equ 0x2c
_H      equ 0x2d
_I      equ 0x2e
_J      equ 0x2f
_K      equ 0x30
_L      equ 0x31
_M      equ 0x32
_N      equ 0x33
_O      equ 0x34
_P      equ 0x35
_Q      equ 0x36
_R      equ 0x37
_S      equ 0x38
_T      equ 0x39
_U      equ 0x3a
_V      equ 0x3b
_W      equ 0x3c
_X      equ 0x3d
_Y      equ 0x3e
_Z      equ 0x3f

_NL     equ 0x76

_VAL        equ 0xc5
_INT        equ 0xcf
_USR        equ 0xd4
_NOT        equ 0xd7
_PWR        equ 0xd8        ; **
_THEN       equ 0xde
_STOP       equ 0xe3
_REM        equ 0xea
_LET        equ 0xf1
_PRINT      equ 0xf5
_RUN        equ 0xf7
_SAVE       equ 0xf8
_RAND       equ 0xf9
_IF     equ 0xfa

; RST routines (a selection of).

ERROR       equ 0x08        ; Follow with a byte error code -1.
PRINT_CHAR  equ 0x10        ; regA contains the char.
PRINT_AT    equ 0x08F5	    ; Row = B, Col = C 
KSCAN	    equ 0x02BB
DECODE	    equ 0x07BD
CLS	    	equ 0x0A2A
RAND    	equ 0x0E6C		; Sets the SEED

; Start of the system variables area.

ERR_NR      equ 0x4000
FLAGS       equ 0x4001
ERR_SP      equ 0x4002
RAMTOP      equ 0x4004
MODE        equ 0x4006
PPC     	equ 0x4007

p_start:    org 0x4009

VERSN:      DB    0
E_PPC:      DW    10
D_FILE:     DW    display_file
DF_CC:      DW    display_file+1
VARS:       DW    variables
DEST:       DW    0
E_LINE:     DW    edit_line
CH_ADD:     DW    p_end-1
X_PTR:      DW    0
STKBOT:     DW    p_end
STKEND:     DW    p_end
BERG:       DB    0
MEM:        DW    MEMBOT
SPARE1:     DB    0
DF_SZ:      DB    2       ; Number of lines in lowe	r part of screen.
S_TOP:      DW    10      ; BASIC line number of line at top of screen.
LAST_K:     DW    0xffff
DB_ST:      DB    0
MARGIN:     DB    31      ; Blank lines above/below TV picture: US = 31, UK = 55.
NXTLIN:     DW    display_file    ; Memory address of next program line to be executed.
OLDPPC:     DW    0
FLAGX:      DB    0
STRLEN:     DW    0
T_ADDR:     DW    0x0c8d
SEED:       DW    0		
FRAMES:     DW    0       ; Updated once for every TV frame displayed.
COORDS:     DW    0
PR_CC:      DB    0xbc
S_POSN:     DB    0x21,0x18
CDFLAG:     DB    0x40
PRBUF:      DS    0x20
        	DB    _NL
MEMBOT:     DS    0x1e
SPARE2:     DW    0

; Start of the BASIC area for user programs.

basic_0001: DB	0,1	;1 REM
	DW	basic_0010-basic_0001-4
	DB	_REM

; start of machine code

mem_16514:

ProgramStart:
; ------------------------------------------------------------- 
; Perform any initialization steps here

	; initial player location
	LD A, 3
	LD (player.x), A
	LD (player.y), A

	; zero the score
	LD A, 0
	LD (player.score), A 

	; set the timer
	LD A, $64		; 100 seconds
	LD (timer), A 

	; initial player direction
	LD A, _RIGHT
	LD (player.direction), A
	
	; set the current map
	LD HL, MAP_TWO
	LD (CURRENT_MAP), HL 

	; clear the screen initialized flag
	LD A, 0 
	LD (ScreenInitFlag), A 

	; Setup the Nuts for the Game
	CALL InitializeNuts 

MainLoop:

	; Check the Splash Screen
	LD A, (ShowSplashFlag)
	CP 1							; If ShowSplashFlag == 1, Show the Splash Screen
	JP Z, HandleSplashScreen			; Kick out to the splash screen

	; check keys
_KeyboardScanLoop
	CALL KSCAN      ; check for keyboard input
	LD B, H
	LD C, L
	LD D, C
	INC D
	LD A, 01H
	JP Z, MainLoopCleanup
	CALL DECODE
	LD A, (HL)      ; Get the decoded character

	CP _O				; O and P for Left and Right
	JP Z, HandleKeyLeft
	CP _P				
	JP Z, HandleKeyRight
	CP _Q				; Q and A for Up and Down
	JP Z, HandleKeyUp
	CP _A				
	JP Z, HandleKeyDown
	
	CP _W
	JP Z, HandleDigKey
	JP MainLoopCleanup	; Nothing pressed; delay and loop

	HandleKeyLeft:
	LD A, _LEFT
	LD (player.direction), A
	LD A, (player.x)
	CP 0
	JP Z, MainLoopUpdate	; skip if zero
	
	; check the target map tile
	LD A, (player.y)
	LD B, A
	LD A, (player.x)
	DEC A
	LD C, A
	CALL GetMapTile
	OR A
	JP NZ, MainLoopUpdate

	LD A, (player.x)
	DEC A
	LD (player.x), A
	JP MainLoopUpdate

	HandleKeyRight:
	LD A, _RIGHT
	LD (player.direction), A
	LD A,(player.x)
	CP $1F					; Max Cols 31
	JP Z, MainLoopUpdate	; skip if at the edge
	
	; check the target map tile
	LD A, (player.y)
	LD B, A
	LD A, (player.x)
	INC A
	LD C, A
	CALL GetMapTile
	OR A
	JP NZ, MainLoopUpdate

	LD A, (player.x)
	INC A
	LD (player.x), A
	JP MainLoopUpdate

	HandleKeyUp:
	LD A, _UP
	LD (player.direction), A
	LD A, (player.y)
	OR A
	JP Z, MainLoopUpdate	; skip if zero

	; check the target map tile
	LD A, (player.y)
	DEC A
	LD B, A
	LD A, (player.x)
	LD C, A
	CALL GetMapTile	; Tile position is now in A
	OR A			; Blank tiles can be walked on
	JP NZ, MainLoopUpdate	; Not a walkable tile, skip over this

	LD A, (player.y)
	DEC A
	LD (player.y),A
	JP MainLoopUpdate

	HandleKeyDown:
	LD A, _DOWN
	LD (player.direction), A
	LD A, (player.y)
	CP $15					; Max Rows 21
	JP Z, MainLoopUpdate	; skip if at the bottom
	
	; check the target map tile
	LD A, (player.y)
	INC A
	LD B, A
	LD A, (player.x)
	LD C, A
	CALL GetMapTile
	OR A
	JP NZ, MainLoopUpdate	; Not a walkable tile, skip over this

	LD A, (player.y)
	INC A
	LD (player.y), A
	JP MainLoopUpdate

	ResetPlayerPosition:
	LD A, 2
	LD (player.y), A
	LD (player.x), A

	LD A, $00
	LD (ScreenInitFlag), A	; tell the screen to redraw too
	JP MainLoopUpdate

DrawScreen:		; Draw the current map to the screen
	LD A, $01
	LD (ScreenInitFlag), A	; Tell the program not to draw the screen again

	; Draw the Header Message
	LD HL, (D_FILE)
	INC HL	; Step over the first _NL
	EX DE, HL

	LD HL, headerMessage
_drawScreenHeaderLoop
	LD A, (HL)
	CP $FF 
	JR Z, _drawScreenMap
	LD (DE), A
	INC HL 
	INC DE
	JR _drawScreenHeaderLoop

_drawScreenMap
	CALL DrawCurrentMap

MainLoopUpdate:
	; Perform screen and state updates

	;; Erase the player's last position
	LD A, (player.prevY)	
	LD B, A
	LD A, (player.prevX)
	LD C, A
	OR B 		; Skip if both prevX and prevY are zero
	JR Z, _MainLoopUpdateDrawPlayer
	LD A, _SPC
	CALL PrintCharacterAt

_MainLoopUpdateDrawPlayer
	;; Draw the curent player location
	LD A, (player.y)	
	LD B, A
	LD A, (player.x)
	LD C, A
	LD A, _X				; Player's Position is marked with X
	CALL PrintCharacterAt

	;; Update the player's previous position
	LD A, (player.y)
	LD (player.prevY), A 
	LD A, (player.x)
	LD (player.prevX), A

	; For now, debug out the Nuts
	CALL DrawNuts 

MainLoopCleanup
	; Do any cleanup steps and prepare for the next loop
	LD A, (ScreenInitFlag)
	OR A
	JP Z, DrawScreen

	CALL DrawStatusLine

	CALL Delay	

	;; Handle Timer
	LD A, (tickCount)
	DEC A 
	JR Z, _countDownTimer
	LD (tickCount), A 
	JP MainLoop

	_countDownTimer
	LD A, TICKS_PER_SECOND
	LD (tickCount), A

	LD A, (timer)
	DEC A
	JP Z, GameOver
	LD (timer), A   

	JP MainLoop		; loop forever

ProgramEnd
	RET

; -------------------------------------------------------------
; Program Constants

TICKS_PER_SECOND EQU 7	; Adjust for timing

;; Directions
_RIGHT	EQU 0
_DOWN	EQU 1
_LEFT	EQU 2
_UP		EQU 3

; -------------------------------------------------------------
; Global Variables

; Screen State Flags
ShowSplashFlag		DB 1	; Show the Splash Screen on Startup
ScreenInitFlag		DB 0	; Track if the screen has been initialized

; Player Construct
player.x			DB 0	; Row Postion
player.y			DB 0	; Col Position
player.direction	DB 0	; Direction
player.prevX		DB 0	; Previous Position
player.prevY		DB 0	; Previous Position
player.score 		DB 0	; Current Score

tickCount			DB TICKS_PER_SECOND
timer				DB 0	; Time Remaining

; Nuts Array
nuts				DS 20	; 10 nuts, 2 bytes each (y and x postion)

; -------------------------------------------------------------
; -- Text and Labels ------------------------------------------
headerMessage:
	DB _D,_I,_G,_N,_U,_T
	DB $FF
instructionsTitle:
	DB _I,_N,_S,_T,_R,_U,_C,_T,_I,_O,_N,_S
	DB $FF
instructionsMessage:
	DB _D,_I,_G,_SPC,_F,_O,_R,_SPC,_N,_U,_T,_S,_SPC,_B,_E,_F,_O,_R,_E,_SPC,_T,_I,_M,_E,$FF
	DB _R,_U,_N,_S,_SPC,_O,_U,_T,$FF 
	DB $FF 
instructionsKeys:
	DB _U,_P,_SLS,_D,_O,_W,_N,$1B,$1B,$1B,  $1B,$1B,$1B,$1B,$1B,_Q,_SLS,_A,$FF
	DB _L,_E,_F,_T,_SLS,_R,_I,_G,_H,_T,     $1B,$1B,$1B,$1B,$1B,_O,_SLS,_P,$FF
	DB _D,_I,_G,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B,_W,$FF
	DB $FF
scoreLabel:
	DB _S,_C,_O,_R,_E,_CLN,_SPC
	DB $FF
timeLabel:
	DB _T,_I,_M,_E,_CLN,_SPC
	DB $FF 
gameOverMessage:
	DB _G,_A,_M,_E,_SPC,_O,_V,_E,_R 
	DB $FF

; -------------------------------------------------------------
; -- Functions and Routines -----------------------------------

; -------------------------------------------------------------
; Function Delay
; Delay for a set period of time
; Clobers A, BC
Delay:		LD BC, $1200	; Set pause to $1200
DelayFor:					; Delay for amount in BC	
	DEC BC
	LD A,B
	OR C
	JR NZ, DelayFor			; loop until 0
	RET
; End Function

; -------------------------------------------------------------
; Function InitializeNuts
; Function to setup nuts array and initial position
InitializeNuts:
	LD A, 0				; Starting Index
_InitializeNutsLoop
	CALL RandomizeNutPosition
	INC A 
	CP 10
	RET Z				; Loop while A < 10
	JR _InitializeNutsLoop

; -------------------------------------------------------------
; Function DrawNuts
; Draw the Nuts to the screen - This is for debug purposes
DrawNuts:
	LD A, 0
_DrawNutsLoop
	CALL DrawNutAt	; Draw nut at index A
	INC A
	CP 10
	RET Z
	JR _DrawNutsLoop

; -------------------------------------------------------------
; Function DrawNutAt
; Draw Nut at index A
DrawNutAt:
	PUSH AF
	LD HL, nuts
	LD D, 0
	LD E, A
	SLA E 		; E = E * 2
	ADD HL, DE 

	LD B, (HL)
	INC HL
	LD C, (HL) 
	; B,C now contains the Nut Y,X Position
	LD A, _N
	CALL PrintCharacterAt
	POP AF
	RET
; End Function

; -------------------------------------------------------------
; Function: RandomizeSeed
; Generate a new random number at SEED
RandomizeSeed:
	PUSH AF
	PUSH BC
	PUSH DE
	PUSH HL
	LD BC, $200		; Give the CPU time to do something
	CALL DelayFor	; and generate a new random value
	LD BC, (FRAMES)
	LD (SEED), BC   ; Copy Frames
	POP HL
	POP DE
	POP BC
	POP AF 
	RET
; End Function

; -------------------------------------------------------------
; Function: Divide
; A / B
; Clobers A, B
; Result is in C
; Remainder is in A
Divide:
	LD C, 0
_DivideLoop:
	SUB B 		; A - B
	JP M, _DivideResult
	INC C 
	JR _DivideLoop
_DivideResult
	ADD A, B
	RET 
; End Function

; -------------------------------------------------------------
; Function: ABS
; Make value in A = |A|
ABS:
	RES 7, A 
	RET 
; End Function

; -------------------------------------------------------------
; Function: Modulo
; A MOD B
; Clobbers A, B
; Result is in A
Modulo:
	CP B 
	RET C
	SUB B 
	JR Modulo
; End Function

; -------------------------------------------------------------
; Function RandomizeNutPosition
; Generate a random X and Y for a NUT at index A
RandomizeNutPosition:

	PUSH AF 		; Stash A 
_TestNutPosition
	CALL RandomizeSeed		; Populate SEED with a Random Number
	LD HL, (SEED)
	
	; Set the Y Position
	LD A, L
	LD B, 18
	CALL Modulo 
	ADD A, 2
	LD C, A

	CALL RandomizeSeed		; Populate SEED with a Random Number
	LD HL, (SEED)

	; Set the X Position
	LD A, L
	LD B, 30
	CALL Modulo
	INC A

	; Setup BC
	LD B, C
	LD C, A 
	
	; Check if the X/Y is a Walkable Location
	CALL GetMapTile		; Stashes Tile value in A
	OR A
	JP NZ, _TestNutPosition	; Not a walkable tile, try again
	POP AF			; A is the index

	LD HL, nuts
	LD D, 0
	LD E, A 
	SLA E 			; E = E * 2
	ADD HL, DE

	LD (HL), B 
	INC HL
	LD (HL), C 

	RET
; End Function

; -------------------------------------------------------------
; Function PrintCharacterAt
; Place a character in A at position B,C (Row,Col)
PrintCharacterAt:
	PUSH AF				; Preserve A
	CALL CalculateOffsetIndex	; Determine the screen index from BC
	POP AF				; Restore A	

PrintCharacterAtScreenOffset:
	LD DE, (SCREEN_OFFSET_INDEX)
	LD HL, (D_FILE)
	ADD HL, DE

	LD (HL), A
	RET
; End Function

; -------------------------------------------------------------
; Function CalculateOffsetIndex
; Calculate a screen offset
; B	Row Position
; C	Column Position
; Clobbers: A, HL, DE
; Result is stored in SCREEN_OFFSET_INDEX location in memory
CalculateOffsetIndex:
	LD A, B			 ; A <- Row Position
	SLA A			 ; A = A * 2
	LD E, A
	LD D, 0			 ; DE <- Row Position

	LD HL, SCREEN_OFFSET_MAP ; HL <- row offset map address
	ADD HL, DE
	; HL is now pointing to the lower bit of the screen offset

	XOR A

	; Add LSB
	LD A, (HL)
	ADD A, C			; Add C to Offset, sets carry bit
	LD (SCREEN_OFFSET_INDEX), A	; Store LSB of result 	

	; Add MSB
	INC HL		
	LD A, (HL)			; A = MSB of Offset
	ADC A, 0			; A = A + Carry
	LD (SCREEN_OFFSET_INDEX+1), A	; Store MSB of result

	RET
; End Function

; -------------------------------------------------------------
; Screen Row Offsets - Used by CalculateOffsetIndex Function
; Little Endian Format (LSB)
SCREEN_OFFSET_MAP:
	 DB $01, $00	; [0] = 1
	 DB $22, $00	; [1] = 34
	 DB $43, $00	; [2] = 67
	 DB $64, $00	; [3] = 100
	 DB $85, $00	; [4] = 133
	 DB $A6, $00	; [5] = 166
	 DB $C7, $00	; [6] = 199
	 DB $E8, $00	; [7] = 232
	 DB $09, $01	; [9] = 265
	 DB $2A, $01	; [10]= 298
	 DB $4B, $01	; [11]= 331
	 DB $6C, $01	; [12]= 364
	 DB $8D, $01	; [13]= 397
	 DB $AE, $01	; [14]= 430
	 DB $CF, $01	; [15]= 463
	 DB $F0, $01	; [16]= 496
	 DB $11, $02	; [17]= 529
	 DB $32, $02	; [18]= 562
	 DB $53, $02	; [19]= 595
	 DB $74, $02	; [20]= 628
	 DB $95, $02	; [21]= 661
	 DB $B6, $02	; [22]= 694
	 DB $D7, $02	; [23]= 727
	 DB	$F8, $02	; [24]= 760
	 DB	$19, $03	; [35]= 793
	 
SCREEN_OFFSET_INDEX:	; Current Screen Offset
	DB $01, $01	; Reserve 2 Bytes for Screen Offset Index


; -------------------------------------------------------------
; Function: GetMapTile
; Returns the Byte tile value for the current map at position Y/X
; Y/X is in BC
; Clobbers: HL, DE
; Result in A (the corresponding tile is in the lower 4 bites)
GetMapTile:
	LD A, B
	DEC A		; The Map starts at row 1, not row zero
	LD H, 0
	LD L, A

	; Equivalant to 2Byte Left Shifts
	ADD HL, HL	; HL = HL * 2
	ADD HL, HL	; HL = HL * 2
	ADD HL, HL	; HL = HL * 2
	ADD HL, HL	; HL = HL * 2

	LD A, B
	DEC A
	LD D, 0
	LD E, A
	ADD HL, DE	; HL is now on the correct row
	LD D, H		; Store HL into DE
	LD E, L

	LD HL, (CURRENT_MAP)
	ADD HL, DE	; HL is now on the correct row	

	XOR A		; Clear A and all the Flags
	LD A, C		; X Position
	SRL A		; A = A / 2
	JR C, _ReturnLowerNibble

	_ReturnUpperNibble
	LD D, 0
	LD E, A
	ADD HL, DE
	LD A, (HL)

	SRL A
	SRL A
	SRL A
	SRL A
	RET	

	_ReturnLowerNibble
	LD D, 0
	LD E, A
	ADD HL, DE	
	LD A, (HL)
	AND $0F
	RET
; end function

; -------------------------------------------------------------
; Function: DrawCurrentMap
; Draws the map at CURRENT_MAP directly to screen memory
; Clobbers A, BC, DE, HL
; Uses CURRENT_MAP, D_FILE_INDEX
DrawCurrentMap:

	; Reset D_FILE_INDEX
	LD HL, (D_FILE)
	LD DE, 34				; Skip the first line
	ADD HL, DE
	LD (D_FILE_INDEX), HL	

	; Load the Map
	LD HL, (CURRENT_MAP)

	_DrawMapByte
	LD A, (HL)
	CP $FF
	JP Z, _DrawMapDone
	CP _NL
	JP Z, _DrawMapNextByte

	; Load the first Nibble
	PUSH AF
	SRL A			; Shift Right 4 Bits to isolate the nibble
	SRL A
	SRL A
	SRL A

	PUSH HL
	LD HL, TILE_MAP		; Load the Tile Map
	LD B, 0
	LD C, A
	ADD HL, BC		; Lookup index in Tile Map
	LD A, (HL)
	LD HL, (D_FILE_INDEX)
	LD (HL), A

	LD HL, (D_FILE_INDEX)	; Move to the next Byte
	INC HL
	LD (D_FILE_INDEX), HL
	POP HL
	POP AF

	; Load the second Nibble
	AND $0F			; Mask off the first four bits
	
	PUSH HL
        LD HL, TILE_MAP		; Load the Tile Map
        LD B, 0
        LD C, A
        ADD HL, BC		; Lookup index in Tile Map
        LD A, (HL)
	LD HL, (D_FILE_INDEX)
        LD (HL), A
	POP HL

	_DrawMapNextByte
	; Move to the next D_FILE location
	LD DE, (D_FILE_INDEX)
	INC DE
	LD (D_FILE_INDEX), DE

	INC HL			; Next Byte
	JR _DrawMapByte	; Keep Looping

	_DrawMapDone
	RET 
; End Function

; -------------------------------------------------------------
; Function: DrawSplashScreen
; Draw the Slash Screen to Screen Memory
; Clobbers: A, HL, DE
DrawSplashScreen:
	LD HL, (D_FILE)		; Point to the screen memory
	LD D, H
	LD E, L
	LD HL, SPLASH_SCREEN
_DrawSplashScreenByte	
	LD A, (HL)			; read splash screen byte
	CP $FF				; Check if I'm at the end
	RET Z
	LD (DE), A
	INC HL
	INC DE
	JR _DrawSplashScreenByte
; End Function

; -------------------------------------------------------------
; Subroutine: HandleSplashScreen
; Draw the splash screen and block
; Clobbers: All
; Updates ShowSplashFlag
HandleSplashScreen:
	; Draw the Slash Screen
	CALL DrawSplashScreen

	XOR A
_splashLoop   
	CALL KSCAN
    LD B, H
    LD C, L
    LD D, C
	INC D
	LD A, 01H
	JR Z, _splashLoop
	CALL DECODE
	LD A, (HL)

	CP $2A				; E Key
	JR Z, _splashEnd
	JR _splashLoop		; Loop Waiting for user to continue

_splashEnd
	CALL CLS			; Clear the screen
	LD A, 0
	LD (ShowSplashFlag), A
	JP ShowInstructions
; End Subroutine

; -------------------------------------------------------------
; Subcroutine: ShowInstructions
ShowInstructions:
	LD HL, (D_FILE)
	LD B, $00
	LD C, $09
	ADD HL, BC

	LD DE, instructionsTitle 
	_showInstructionsTitleLoop
	LD A, (DE)
	CP $FF 
	JR Z, _showInstructionsTitleDone
	LD (HL), A 
	INC HL
	INC DE 
	JR _showInstructionsTitleLoop

	_showInstructionsTitleDone
	LD HL, (D_FILE)
	LD B, $00
	LD C, $88 
	ADD HL, BC 
	LD (D_FILE_INDEX), HL

	LD DE, instructionsMessage
	_printInstructionLoop
	LD A, (DE)
	CP $FF
	JR Z, _printNextInstruction
	LD (HL), A
	INC HL
	INC DE 
	JR _printInstructionLoop

	_printNextInstruction
	LD HL, (D_FILE_INDEX)
	LD B, 0
	LD C, $21		; Next Line
	ADD HL, BC 
	LD (D_FILE_INDEX), HL	
	INC DE 		; Next instruction
	LD A, (DE)
	CP $FF 
	JP NZ, _printInstructionLoop;

	LD HL, (D_FILE)
	LD B, $01
	LD C, $72
	ADD HL, BC 
	LD (D_FILE_INDEX), HL	

	LD DE, instructionsKeys
	_printInstructionKeysLoop
	LD A, (DE)
	CP $FF
	JR Z, _printNextInstructionKey
	LD (HL), A
	INC HL
	INC DE 
	JR _printInstructionKeysLoop

	_printNextInstructionKey
	LD HL, (D_FILE_INDEX)
	LD B, 0 
	LD C, $21		; Next Line
	ADD HL, BC 
	LD (D_FILE_INDEX), HL	
	INC DE 		; Next instruction
	LD A, (DE)
	CP $FF 
	JP NZ, _printInstructionKeysLoop;
	

	CALL WaitForAnyKey

	CALL CLS
	JP MainLoop
; End Subrouting

; -------------------------------------------------------------
; Subroutine: HandleDigKey
HandleDigKey:
	; Determin the target dig spot based on location and direction
	LD A, (player.y)
	LD B, A 
	LD A, (player.x)
	LD C, A 

	LD A, (player.direction)
	CP _RIGHT
	JR Z, _DigRight
	CP _LEFT
	JR Z, _DigLeft 
	CP _UP 
	JR Z, _DigUp 
	JR _DigDown

	_DigRight:
		LD A, C 
		CP $1F
		JR Z, _ContinueToMainLoop

		INC A
		LD C, A 
		JR _DigForNut

	_DigLeft:
		LD A, C 
		CP 0
		JR Z, _ContinueToMainLoop

		DEC A
		LD C, A 
		JR _DigForNut

	_DigUp:
		LD A, B
		CP 1
		JR Z, _ContinueToMainLoop

		DEC A
		LD B, A 
		JR _DigForNut

	_DigDown:
		LD A, B
		CP $15
		JR Z, _ContinueToMainLoop

		INC A
		LD B, A 

	_DigForNut:		; BC Contains Dig Y,X
		LD A, 0		; index counter
		LD HL, nuts
	_DigForNutLoop
		PUSH AF
		PUSH BC
		LD A, (HL)	; Y Position
		SUB B
		LD B, A 
		INC HL
		LD A, (HL)
		SUB C 
		OR B 		; If B and C are both 0, we have a hit
		JP Z, _FoundNut
		POP BC 
		POP AF 
		CP 9 	; End of the loop
		JR Z, _ContinueToMainLoop 

		INC A
		INC HL

		JR _DigForNutLoop

	_FoundNut		; HL contains the position of the nut
	POP BC 

	;; erase the nut
	LD A, $08
	CALL PrintCharacterAt

	;; increase score
	LD A, (player.score)
	INC A 
	LD (player.score), A 

	POP AF 
	;; Change Nut Position
	CALL RandomizeNutPosition

	_ContinueToMainLoop
	JP MainLoopUpdate
; End Subroutine

; -------------------------------------------------------------
; Function: DrawStatusLine
; Prints Score and Time
DrawStatusLine:
	;; Status line is at the bottom of the screen
	LD HL, (D_FILE)
	LD B, $02
	LD C, $B6 
	ADD HL, BC 

	LD DE, scoreLabel
	_DrawStatusLineScoreLoop
	LD A, (DE)
	CP $FF
	JR Z, _DrawStatusLineScoreDone
	LD (HL), A
	INC HL
	INC DE 
	JR _DrawStatusLineScoreLoop
	_DrawStatusLineScoreDone

	;; Print the Player Score
	LD A, (player.score)
	LD B, 100
	CALL Divide			; 100's Place
	PUSH AF 
	LD A, C
	CALL ABS  
	ADD A, $1C
	LD (HL), A
	POP AF

	INC HL 
	LD B, 10 
	CALL Divide			; 10's Place
	PUSH AF 
	LD A, C 
	CALL ABS 
	ADD A, $1C
	LD (HL), A
	POP AF 

	INC HL  
	CALL ABS 
	ADD A, $1C 			; 1's Place
	LD (HL), A 

	;; draw the timer value
	LD HL, (D_FILE)
	LD B, $02
	LD C, $C6 
	ADD HL, BC 

	LD DE, timeLabel
	_DrawStatusLineTimerLoop
	LD A, (DE)
	CP $FF
	JR Z, _DrawStatusLineTimerDone
	LD (HL), A
	INC HL
	INC DE 
	JR _DrawStatusLineTimerLoop
	_DrawStatusLineTimerDone

	;; Print the current timer value
	LD A, (timer)
	LD B, 100
	CALL Divide			; 100's Place
	PUSH AF 
	LD A, C
	CALL ABS  
	ADD A, $1C
	LD (HL), A
	POP AF

	INC HL 
	LD B, 10 
	CALL Divide			; 10's Place
	PUSH AF 
	LD A, C 
	CALL ABS 
	ADD A, $1C
	LD (HL), A
	POP AF 

	INC HL  
	CALL ABS 
	ADD A, $1C 			; 1's Place
	LD (HL), A 

	RET
; End Function

; -------------------------------------------------------------
; Subroutine: GameOver
GameOver:
	CALL CLS 

	;; Status line is at the bottom of the screen
	LD HL, (D_FILE)
	LD B, $01
	LD C, $15 
	ADD HL, BC 

	LD DE, gameOverMessage
	_GameOverMessageLoop
	LD A, (DE)
	CP $FF
	JR Z, _GameOverMessageDone
	LD (HL), A
	INC HL
	INC DE 
	JR _GameOverMessageLoop
	_GameOverMessageDone

	LD HL, (D_FILE)
	LD B, $01
	LD C, $36 
	ADD HL, BC 

	LD DE, scoreLabel
	_GameOverScoreLabelLoop
	LD A, (DE)
	CP $FF
	JR Z, _GameOverScoreLabelDone
	LD (HL), A
	INC HL
	INC DE 
	JR _GameOverScoreLabelLoop
	_GameOverScoreLabelDone

	;; Print the Player Score
	LD A, (player.score)
	LD B, 100
	CALL Divide			; 100's Place
	PUSH AF 
	LD A, C
	CALL ABS  
	ADD A, $1C
	LD (HL), A
	POP AF

	INC HL 
	LD B, 10 
	CALL Divide			; 10's Place
	PUSH AF 
	LD A, C 
	CALL ABS 
	ADD A, $1C
	LD (HL), A
	POP AF 

	INC HL  
	CALL ABS 
	ADD A, $1C 			; 1's Place
	LD (HL), A 

	CALL WaitForAnyKey

	; Restart the Game
	JP ProgramStart 

; -------------------------------------------------------------
; Function: WaitForAnyKey
; Pause and wait for any key to be pressed
WaitForAnyKey:
	; Wait for ~1 second
	LD BC, $5A00 
	CALL Delay

	XOR A
_WaitForAnyKeyLoop   
	CALL KSCAN
    LD B, H
    LD C, L
    LD D, C
	INC D
	LD A, 01H
	JR Z, _WaitForAnyKeyLoop

	RET
; End Function

; -- Splash Screen --------------------------------------------
SPLASH_SCREEN
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $07, $03, $03, $86, $00, $00, $00, $00, $00, $00, $05, $00, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $05, $00, $00, $85, $00, $00, $00, $00, $00, $00, $82, $00, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $05, $00, $00, $85, $00, $00, $00, $00, $00, $00, $05, $86, $05, $00, $00, $00, $00, $00, $05, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $05, $00, $00, $85, $02, $00, $00, $00, $00, $00, $05, $00, $05, $05, $00, $85, $00, $03, $07, $03, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $05, $00, $00, $85, $85, $00, $06, $03, $86, $00, $05, $00, $05, $05, $00, $85, $00, $00, $05, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $82, $83, $83, $06, $85, $00, $05, $00, $85, $00, $05, $00, $05, $86, $83, $06, $00, $00, $86, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $83, $83, $83, $83, $83, $83, $83, $00, $86, $83, $81, $00, $83, $83, $83, $83, $83, $83, $83, $83, $83, $83, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $85, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $86, $83, $06, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2c, $26, $32, $2a, $00, $29, $2a, $32, $34, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $35, $37, $2a, $38, $38, $00, $2a, $00, $39, $34, $00, $38, $39, $26, $37, $39, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76,$00, $00, $00, $3b, $1c, $1b, $1d, $00, $00, $00, $00, $00, $00, $00, $27, $3e, $00, $29, $2a, $37, $35, $35, $37, $34, $2c, $37, $26, $32, $32, $2a, $37, $00
	DB	$76,$00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	DB	$76, $FF


; -- Maps and Tiles -------------------------------------------

; Default Map Data
CURRENT_MAP:  DS 2	; Pointer to the current map
D_FILE_INDEX: DS 2	; Pointer to the current D_FILE position

; MAP and TILES
TILE_MAP	DB $00	; [0] Empty Tile
			DB $83	; [1] Top
			DB $05	; [2] Left
			DB $85	; [3] Right
			DB $03	; [4] Bottom 
			DB $08	; [5] Gray Block
			DB $06	; [6] /
			DB $86	; [7] \
			DB $80	; [8] Solid Tile
			DB $02	; [9] .
			DB $82	; [A] '.
			DB $0A	; [B] ^

; Maps are made up of 32 nibbles (16 Bytes) by 20 rows 
MAP_ONE
	DB $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $01, $11, $10, $00, $00, $00, $00, $00, $00, $00, $01, $11, $10, $00, $03,_NL
	DB $20, $02, $55, $30, $00, $00, $00, $00, $00, $00, $00, $02, $55, $30, $00, $03,_NL
	DB $20, $02, $55, $30, $00, $00, $00, $00, $00, $00, $00, $02, $55, $30, $00, $03,_NL
	DB $20, $02, $55, $30, $00, $00, $00, $00, $00, $00, $00, $02, $55, $30, $00, $03,_NL
	DB $20, $02, $55, $30, $00, $00, $00, $00, $00, $00, $00, $02, $55, $30, $00, $03,_NL
	DB $20, $04, $44, $40, $00, $00, $00, $00, $00, $00, $00, $04, $44, $40, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44,_NL
	DB $FF

MAP_TWO
	DB $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $0A, $64, $47, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $65, $55, $55, $20, $00, $00, $00, $00, $00, $00, $0A, $AA, $00, $03,_NL
	DB $20, $00, $22, $55, $55, $60, $00, $00, $00, $00, $00, $06, $45, $55, $70, $03,_NL
	DB $20, $00, $97, $55, $53, $00, $00, $00, $00, $00, $00, $02, $55, $55, $30, $03,_NL
	DB $20, $00, $00, $44, $66, $00, $00, $00, $00, $00, $00, $07, $65, $55, $57, $03,_NL
	DB $20, $00, $00, $05, $00, $00, $0A, $AA, $A0, $00, $00, $00, $66, $47, $56, $03,_NL
	DB $20, $00, $00, $05, $00, $00, $65, $55, $5A, $00, $00, $00, $0B, $5B, $40, $03,_NL
	DB $20, $00, $00, $05, $00, $00, $25, $55, $55, $70, $00, $00, $00, $50, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $25, $65, $55, $52, $00, $00, $00, $50, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $94, $A6, $56, $60, $00, $00, $00, $50, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $50, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $50, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $50, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $20, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03,_NL
	DB $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44, $44,_NL
	DB $FF

	RET
; end of machine code

        DB    _NL
basic_0010: DB    0,10        ; 10 RAND USR VAL "16514"
        DW    basic_end-basic_0010-4
        DB    _RAND,_USR,_VAL,_DQT,_1,_6,_5,_1,_4,_DQT
        DB    _NL
basic_end:

; clear the screen

; Expanded for > 3k RAM.

display_file:   DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL
        DS    32
        DB    _NL

variables:  DB    0x80

; Start of the edit line used by BASIC.

edit_line:

p_end:      end
