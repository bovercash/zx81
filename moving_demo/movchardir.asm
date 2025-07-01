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

; Inverse equivalents of the above.

_SPCV       equ _SPC+0x80   ; [ ]
_DQTV       equ _DQT+0x80   ; ["]
_PNDV       equ _PND+0x80   ; [Â£]
_DLRV       equ _DLR+0x80   ; [$]
_CLNV       equ _CLN+0x80   ; [:]
_QMKV       equ _QMK+0x80   ; [?]
_OBRV       equ _OBR+0x80   ; [(]
_CBRV       equ _CBR+0x80   ; [)]
_GTHV       equ _GTH+0x80   ; [>]
_LTHV       equ _LTH+0x80   ; [<]
_EQUV       equ _EQU+0x80   ; [=]
_PLSV       equ _PLS+0x80   ; [+]
_MNSV       equ _MNS+0x80   ; [-]
_ASKV       equ _ASK+0x80   ; [*]
_SLSV       equ _SLS+0x80   ; [/]
_SMCV       equ _SMC+0x80   ; [;]
_CMAV       equ _CMA+0x80   ; [,]
_FSTV       equ _FST+0x80   ; [.]
_0V     equ _0+0x80
_1V     equ _1+0x80
_2V     equ _2+0x80
_3V     equ _3+0x80
_4V     equ _4+0x80
_5V     equ _5+0x80
_6V     equ _6+0x80
_7V     equ _7+0x80
_8V     equ _8+0x80
_9V     equ _9+0x80
_AV     equ _A+0x80
_BV     equ _B+0x80
_CV     equ _C+0x80
_DV     equ _D+0x80
_EV     equ _E+0x80
_FV     equ _F+0x80
_GV     equ _G+0x80
_HV     equ _H+0x80
_IV     equ _I+0x80
_JV     equ _J+0x80
_KV     equ _K+0x80
_LV     equ _L+0x80
_MV     equ _M+0x80
_NV     equ _N+0x80
_OV     equ _O+0x80
_PV     equ _P+0x80
_QV     equ _Q+0x80
_RV     equ _R+0x80
_SV     equ _S+0x80
_TV     equ _T+0x80
_UV     equ _U+0x80
_VV     equ _V+0x80
_WV     equ _W+0x80
_XV     equ _X+0x80
_YV     equ _Y+0x80
_ZV     equ _Z+0x80

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
CLS	    equ 0x0A2A

; ROM routines (a selection of).

KEYB_SCAN   equ 0x02bb
KEYB_DECODE equ 0x07bd

; Start of the system variables area.

ERR_NR      equ 0x4000
FLAGS       equ 0x4001
ERR_SP      equ 0x4002
RAMTOP      equ 0x4004
MODE        equ 0x4006
PPC     equ 0x4007

p_start:    org 0x4009

VERSN:      defb    0
E_PPC:      defw    20      ; BASIC line number of line with cursor.
D_FILE:     defw    display_file
DF_CC:      defw    display_file+1
VARS:       defw    variables
DEST:       defw    0
E_LINE:     defw    edit_line
CH_ADD:     defw    p_end-1
X_PTR:      defw    0
STKBOT:     defw    p_end
STKEND:     defw    p_end
BERG:       defb    0
MEM:        defw    MEMBOT
SPARE1:     defb    0
DF_SZ:      defb    2       ; Number of lines in lower part of screen.
S_TOP:      defw    10      ; BASIC line number of line at top of screen.
LAST_K:     defw    0xffff
DB_ST:      defb    0
MARGIN:     defb    55      ; Blank lines above/below TV picture: US = 31, UK = 55.
NXTLIN:     defw    display_file    ; Memory address of next program line to be executed.
OLDPPC:     defw    0
FLAGX:      defb    0
STRLEN:     defw    0
T_ADDR:     defw    0x0c8d
SEED:       defw    0
FRAMES:     defw    0       ; Updated once for every TV frame displayed.
COORDS:     defw    0
PR_CC:      defb    0xbc
S_POSN:     defb    0x21,0x18
CDFLAG:     defb    0x40
PRBUF:      defs    0x20
        defb    _NL
MEMBOT:     defs    0x1e
SPARE2:     defw    0

; Start of the BASIC area for user programs.

basic_0001: defb	0,1	;1 REM
	defw	basic_0010-basic_0001-4
	defb	_REM

; start of machine code

mem_16514:

; constants
DIR_R	EQU 0
DIR_D	EQU 1
DIR_L	EQU 2
DIR_U	EQU 3

 
PROG_START	; start of program		

	; Perform any initialization steps here
	
	; initial user location
	LD A, 3
	LD (user_x), A
	LD (user_y), A

	; initial user direction
	LD A, DIR_R
	LD (user_dir), A
	

MAIN_LOOP

	; check keys
KWAIT   CALL KSCAN      ; check for keyboard input
        LD B, H
        LD C, L
        LD D, C
        INC D
        LD A, 01H
        JR Z, KWAIT
        CALL DECODE
        LD A, (HL)      ; Get the decoded character

	; check pressed key
	CP $26	; A key
	JP Z, CLEFT
	CP $38	; S DOWN key
	JP Z, CDOWN
	CP $3C	; W key
	JP Z, CUP
	CP $29	; D key		
	JP Z, CRIGHT
	CP $36	; Q Key
	JP Z, PROG_END
	CP _R
	JP Z, CRESET
	CP _5	; 5 or LEFT
	JP Z, CLEFT
	CP _6	; 6 or DOWN
	JP Z, CDOWN
	CP _7	; 7 or UP
	JP Z, CUP
	CP _8	; 8 or RIGHT
	JP Z, CRIGHT
	CP _0	; 0
	JP Z, PROG_END
	JP LOOP_END	; Nothing pressed; delay and loop

CLEFT	LD A, DIR_L
	LD (user_dir), A
	LD A, (user_x)
	CP 0
	JP Z, KEND	; skip if zero
	DEC A
	LD (user_x), A
	JP KEND

CRIGHT	LD A, DIR_R
	LD (user_dir), A
	LD A,(user_x)
	CP $1F		; Max Cols 31
	JP Z, KEND	; skip if at the edge
	INC A
	LD (user_x), A
	JP KEND

CUP	LD A, DIR_U
	LD (user_dir), A
	LD A, (user_y)
	CP 0
	JP Z, KEND	; skip if zero
	DEC A
	LD (user_y),A
	JP KEND

CDOWN	LD A, DIR_D
	LD (user_dir), A
	LD A, (user_y)
	CP $15		; Max Rows 21
	JP Z, KEND	; skip if at the bottom
	INC A
	LD (user_y), A
	JP KEND

CRESET	LD A, 2
	LD (user_y), A
	LD (user_x), A
	JP KEND	

KEND	; end of keyboard handling

	LD A, _SPC
	CALL PRINT_CHAR_AT_SCREEN_OFFSET

	LD A, (user_y)	
	LD B, A
	LD A, (user_x)
	LD C, A
	LD A, _X
	CALL PRINT_CHAR_AT	; Print the user location 'X'


	; Print the Status Line
	LD A, $02
	LD D, A
	LD A, $D7
	LD E, A
	LD HL, (D_FILE)
	ADD HL, DE	; Status Line Offset
	
	; stash screen ref in DE
	LD D, H
	LD E, L

	LD HL, status_direction
print_status
	LD A, (HL)
	CP $FF		; Check for end of label
	JR Z, print_status_end
	LD (DE), A	; Output Character to the screen
	INC DE
	INC HL
	JR print_status
print_status_end
	
	LD A, (user_dir)
	ADD A, $1C	; offset for text output
	LD (DE), A	; Output Character to the screen
	; End of Status Line Output	

LOOP_END
	CALL DELAY	
	JP MAIN_LOOP	; loop forever

PROG_END	; end of program
	RET


; Global Variables

; user construct
user_x		db 0	; Row Postion
user_y		db 0	; Col Position
user_dir	db 0	; Direction

; Functions and Routines

; Function DELAY
; Delay for a set period of time
DELAY:	LD BC,$1200	; Set pause to $1200
DELAY_L	DEC BC		; Pause routine  - Probably need a debounce routine
	LD A,B
	OR C
	JR NZ, DELAY_L	; loop until 0
	RET
; End Function

; Function PRINT_CHAR_AT
; Place a character in A at position B,C (Row,Col)
PRINT_CHAR_AT:
	PUSH AF				; Preserve A
	CALL CALCULATE_OFFSET_INDEX	; Determine the screen index from BC
	POP AF				; Restore A	

PRINT_CHAR_AT_SCREEN_OFFSET:
	LD DE, (screen_offset)
	LD HL, (D_FILE)
	ADD HL, DE

	LD (HL), A
	RET
; End Function

; Function CALCULATE_OFFSET_INDEX
; Calculate a screen offset
; B	Row Position
; C	Column Position
; Clobbers: A, HL, DE
; Result is stored in screen_offset location in memory
CALCULATE_OFFSET_INDEX:
	LD A, B			 ; A <- Row Position
	SLA A			 ; A = A * 2
	LD E, A
	LD D, 0			 ; DE <- Row Position

	LD HL, screen_offset_map ; HL <- row offset map address
	ADD HL, DE
	; HL is now pointing to the lower bit of the screen offset

	XOR A

	; Add LSB
	LD A, (HL)
	ADD A, C	; Add C to Offset, sets carry bit
	LD (screen_offset), A	; Store LSB of result 	

	; Add MSB
	INC HL		
	LD A, (HL)	; A = MSB of Offset
	ADC A, 0	; A = A + Carry
	LD (screen_offset+1), A	; Store MSB of result

	RET
; End Function

; Functional Variables (things used by functions)

; Screen Row Offsets - Used by CALCULATE_OFFSET_INDEX Function
; Little Endian Format (LSB)
screen_offset_map:
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
	 
screen_offset:
	DB $01, $01	; Reserve 2 Bytes for Screen Offset Index


; Text and Labels
status_direction:
	DB _D,_I,_R,_CLN,_SPC
	DB $FF


; end of machine code

        defb    _NL
basic_0010: defb    0,10        ; 10 RAND VAL "USR 16514"
        defw    basic_0020-basic_0010-4
        defb    _RAND,_USR,_VAL,_DQT,_1,_6,_5,_1,_4,_DQT
        defb    _NL
basic_0020: defb    0,20        ; 20 REM ** TYPE RUN **
        defw    basic_end-basic_0020-4
        defb    _REM,_PWR,_SPC,_T,_Y,_P,_E,_RUN,_PWR
        defb    _NL
basic_end:

; clear the screen

; Expanded for > 3k RAM.

display_file:   defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL
        defs    32
        defb    _NL

variables:  defb    0x80

; Start of the edit line used by BASIC.

edit_line:

p_end:      end

