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
CURSOR_START	EQU	$5	; starting position for the menu cursor

START
	CALL Z_CLS	; Clear Screen, Set Position
	
	; draw the logo
	LD HL, logo ;load HL with address of the logo
PLOGO	LD A, (HL) ;load A with a character at HL
	CP $FF ;The end of the string?
	JR Z, ELOGO
	INC HL
	PUSH HL
	CALL PRINT_CHAR ;print character
	POP HL
	JR PLOGO
ELOGO

KEYSCAN	
	; redraw the menu
	LD B, CURSOR_START
	LD C, $0
	CALL PRINT_AT
	LD HL, menu
PMENU	LD A, (HL)
	CP $FF
	JR Z, EMENU
	CALL PRINT_CHAR	; print it
	INC HL		; next character
	JR PMENU
EMENU
	
	; set cursor position
	LD A, (cur_p)
	LD B, A
	LD C, $0
	CALL PRINT_AT

	LD A, _ASK
	CALL PRINT_CHAR

KWAIT	CALL KSCAN	; check for keyboard input
	LD B, H
	LD C, L
	LD D, C
	INC D
	LD A, 01H
	JR Z, KWAIT
	CALL DECODE
	LD A, (HL)	; Get the decoded character
	CP $22		; 6 or Down
	JP Z, CDOWN
	CP $23		; 7 or UP
	JP Z, CUP
	CP 76H		; NewLine (Enter)
	JP Z, CSEL
	JP KWAIT	; loop for keypress

CTOP	LD A, CURSOR_START
	LD (cur_p), A	; set the cursor to the top option
	JP KEYSCAN

CBOT	LD A, $7
	LD (cur_p), A	; set the cursor to the bottom option
	JP KEYSCAN

CDOWN	LD A, (cur_p)	; load the cursor position
	INC A		; increase pos
	LD (cur_p), A	; update the posiotion
	CP $8		; check if we're past the list
	JP Z, CTOP
	JP KEYSCAN

CUP	LD A, (cur_p)	; load the cursor position
	DEC A		; decreate position
	LD (cur_p), A	; update the position
	CP $4		; check if we're before the list
	JP Z, CBOT
	JP KEYSCAN

CSEL	CALL Z_CLS	; clear the screen

	LD HL, imgur
PIMG	LD A, (HL)
	CP $FF
	JP Z, EIMG
	CALL PRINT_CHAR
	INC HL
	CALL PIMG
EIMG

	; loop until enter is pressed
EWAIT	CALL KSCAN
	LD B, H
	LD C, L
	LD D, C
	INC D
	LD A, 01H
	JR Z, EWAIT
	
	; restart the app
	CALL Z_CLS
	CALL START

	JP PROG_END

Z_CLS:	; Clear Screen Subroutine
	PUSH HL
	PUSH BC
	PUSH DE
	CALL CLS

	LD B, $14
	LD C, $0	
	CALL PRINT_AT

	LD HL, vers
PVERS	LD A, (HL)
	CP $FF
	JP Z, EVERS
	CALL PRINT_CHAR
	INC HL
	JP PVERS
EVERS

	LD B, $0
	LD C, $0
	CALL PRINT_AT

	POP DE
	POP BC
	POP HL
	RET	; End Subroutine

; messages
logo:	DEFM _MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS
	DEFM _MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_NL,_MNS,_SPC,_I,_M,_G,_U,_R,_SPC
	DEFM _M,_A,_I,_N,_SPC,_M,_E,_N,_U,_SPC,_MNS,_NL,_MNS,_MNS,_MNS,_MNS
	DEFM _MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS
	DEFM _MNS,_MNS,_NL,_NL,_NL
	DEFB $FF

menu:	DEFM _SPC,_SPC,_F,_R,_O,_N,_T,_SPC,_P,_A,_G,_E,_NL
	DEFM _SPC,_SPC,_U,_S,_E,_R,_SPC,_S,_U,_B,_NL
	DEFM _SPC,_SPC,_U,_P,_L,_O,_A,_D,_SPC,_C,_O,_N,_T,_E,_N,_T,_NL
	DEFB $FF

imgur:	DEFM _MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS
	DEFM _MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS
	DEFM _MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_NL
	DEFM _CLN,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC
	DEFM _SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC
	DEFM _SPC,_SPC,_SPC,_SPC,_SPC,_CLN,_NL
	DEFM _CLN,_SPC,_SPC,_SPC,_SPC,_OBR,_GTH,_MNS,_LTH,_CBR,_SPC
	DEFM _I,_M,_G,_U,_R,_SPC,_I,_S,_SPC,_O,_V,_E,_R,_SPC,_SPC,_SPC
	DEFM _SPC,_CLN,_NL
	DEFM _CLN,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC
	DEFM _SPC,_C,_A,_P,_A,_C,_I,_T,_Y,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC
	DEFM _SPC,_SPC,_CLN,_NL
	DEFM _CLN,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC
        DEFM _SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC
        DEFM _SPC,_SPC,_SPC,_SPC,_SPC,_CLN,_NL
	DEFM _CLN,_SPC,_SPC,_W,_E,_CMA,_R,_E,_SPC,_E,_X,_P,_E,_R,_I,_E
	DEFM _N,_C,_I,_N,_G,_SPC,_A,_SPC,_L,_O,_T,_SPC,_CLN,_NL
	DEFM _CLN,_SPC,_SPC,_O,_F,_SPC,_T,_R,_A,_F,_F,_I,_C,_SPC,_R,_I
	DEFM _G,_H,_T,_SPC,_N,_O,_W,_FST,_SPC,_SPC,_SPC,_SPC,_CLN,_NL
	DEFM _CLN,_SPC,_SPC,_W,_E,_CMA,_R,_E,_SPC,_W,_O,_R,_K,_I,_N,_G
	DEFM _SPC,_O,_N,_SPC,_I,_T,_FST,_SPC,_SPC,_SPC,_SPC,_SPC,_CLN,_NL
	DEFM _CLN,_SPC,_SPC,_P,_L,_E,_A,_S,_E,_SPC,_T,_R,_Y,_SPC,_A,_G
	DEFM _A,_I,_N,_SPC,_I,_N,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_CLN,_NL
	DEFM _CLN,_SPC,_SPC,_A,_SPC,_F,_E,_W,_SPC,_M,_I,_N,_U,_T,_E,_S
	DEFM _FST,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC
	DEFM _SPC,_CLN,_NL
	DEFM _CLN,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC
        DEFM _SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC
        DEFM _SPC,_SPC,_SPC,_SPC,_SPC,_CLN,_NL
	DEFM _CLN,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC
        DEFM _SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC,_SPC
        DEFM _SPC,_SPC,_SPC,_SPC,_SPC,_CLN,_NL	
	DEFM _MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS
        DEFM _MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_MNS
        DEFM _MNS,_MNS,_MNS,_MNS,_MNS,_MNS,_NL
	DEFB $FF 

vers:	DEFB _I,_M,_G,_U,_R,_SPC,_Z,_X,_8,_1,_SPC,_C,_L,_I,_E,_N,_T,_SPC,_V,_0,_FST,_0,_1
	DEFB $FF

; variables
cur_p:	DEFB CURSOR_START

PROG_END
	RET

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

