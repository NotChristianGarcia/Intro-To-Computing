;--------------------------- PACMAN ---------------------------;
; Directions: Use the wasd keys to move the around the MAZE.   ;
; You win when you eat the 'o' on the screen. If you get caught;
; by the ghosts, you lose!                                     ;
;--------------------------------------------------------------;
; Christian R. Garcia                                          ;
; 4/22/18                                                      ;
;--------------------------------------------------------------;
	.ORIG	x3000
	
	JSR 	INIT
	JSR 	DISPLAY
	JSR	DELETE_OLD
	LD	R0, MAZE
	
REP		
	JSR	GET_INPUT
	JSR	UPDATE_HEAD
	JSR	UPDATE_MAZE
	JSR	DISPLAY
	JSR	DELETE_OLD
	JSR	CHECK_END
	BR 	REP

;-------------------------------------------------------------;
; Initializes the position of the head (stored at HEAD_P) and ;
; and stores the corresponding character '<' in the first     ;
; frame.                                                      ;
; Input        : None                                         ;
; Output       : Position of the head, stored at HEAD_P       ;
;-------------------------------------------------------------;
INIT
	ST	R7, IN_R7
	LD	R1, MAZE	; Base address of the MAZE
	LD	R2, C_OFF	
	ADD	R1, R1, R2
	ADD	R1, R1, #2	; Start at the top left corner

	LD	R0, HEAD
	STR	R0, R1, #0 	; Store head char (1st frame)	
	ST	R1, HEAD_P
	
	LD	R7, IN_R7
	RET

HEAD	.FILL	x3C
HEAD_P	.BLKW	#1
IN_R7	.BLKW	#1

;-------------------------------------------------------------;
; Loads next frame into location MAZE, and updates HEAD_P to  ;
; point to the a location on the next frame.                  ;
; Input        : Pointer to MAZE(R0), position of head(R1)    ;
; Output       : Pointer to MAZE(R0), position of head(R1)    ; 
;-------------------------------------------------------------;
UPDATE_MAZE	
	ST	R7, UA_R7

	LD	R3, FRAME_N
	LD	R4, FRAME_T
	ADD	R3, R3, #1
	ST 	R3, FRAME_N
	ADD	R3, R3, R4
	
	BRZ	REP_FRAME	
	LD	R2, MAZE_O
	ADD	R0, R0, R2
	ADD	R1, R1, R2
	ST	R0, MAZE
	
	LD	R0, HEAD
	STR	R0, R1, #0	
	ST	R1, HEAD_P
	LD	R0, MAZE
	RET

REP_FRAME
	AND	R5, R5, #0
	ST	R5, FRAME_N
	LD	R2, MAZE_N
	ADD	R0, R0, R2
	ST	R0, MAZE
	ADD	R1, R1, R2
	
	LD	R0, HEAD
	STR	R0, R1, #0
	ST	R1, HEAD_P
	LD	R0, MAZE

	LD	R7, UA_R7
	RET

FRAME_N	.FILL	#0
FRAME_T	.FILL	#-23
UA_R7	.BLKW	#1

MAZE_O	.FILL #1058
MAZE_N	.FILL #-23276

;-------------------------------------------------------------;
; This subroutine displays the MAZE                           ;
; Input        : None                                         ;
; Output       : None                                         ; 
;-------------------------------------------------------------;
DISPLAY 
	ST	R0, DS_R0
	ST	R7, DS_R7

	LD 	R1, MAZE
	LD	R2, C_OFF	; R1 is column counter
	LD	R3, R_OFF	; R2 is row counter

D_MAZE	
	ADD	R0, R1, #0
	PUTS	
	LD 	R0, LF
	OUT
	ADD	R1, R1, R2
	ADD	R3, R3, #-1
	BRP	D_MAZE		; Prints each row	 
	
	LD	R0, DS_R0
	LD	R7, DS_R7
	RET

C_OFF	.FILL	#46
R_OFF	.FILL	#23
LF	.FILL	x0A
DS_R7	.BLKW	#1
DS_R0	.BLKW	#1

;-------------------------------------------------------------;
; This subroutine gets the user's input.                      ;
;-------------------------------------------------------------;
GET_INPUT	
	ST	R0, INP_R0
	ST	R7, INP_R7
	
	GETC
	ADD	R3, R0, #0

	LD	R0, INP_R0
	LD	R7, INP_R7
	RET

INP_R0	.BLKW	#1
INP_R7	.BLKW	#1

;-------------------------------------------------------------;
; Updates position of pacman head.                            ;
; Input        : Input from keyboard (R3)                     ;
; Output       : New head position (R1)                       ;
;-------------------------------------------------------------;
UPDATE_HEAD	
	LD	R1, HEAD_P
	
	ST	R1, PACOLD
	LD	R2, WCHK
	NOT	R2, R2
	ADD	R2, R2, #1
	ADD	R2, R3, R2
	BRz	UP

	LD	R2, ACHK
	NOT	R2, R2
	ADD	R2, R2, #1
	ADD	R2, R3, R2
	BRz	LEFT

	LD	R2, SCHK
	NOT	R2, R2
	ADD	R2, R2, #1
	ADD 	R2, R3, R2
	BRz	DOWN

	LD	R2, DCHK
	NOT	R2, R2
	ADD	R2, R2, #1
	ADD	R2, R3, R2
	BRz	RIGHT

UP		
	LD	R2, UP_OFF
	ADD	R1, R1, R2	; New head pos
	BR	CHK_POS

LEFT		
	ADD	R1, R1, #-2
	BR	CHK_POS

DOWN		
	LD	R2, DOWN_OFF
	ADD	R1, R1, R2	; New head pos
	BR	CHK_POS
	
RIGHT		
	ADD	R1, R1, #2
	BR	CHK_POS

CHK_POS		
	LD	R2, ASTRCHK
	LDR	R3, R1, #0
	ADD	R2, R3, R2
	BRnp	NO_WALL
	LD	R1, HEAD_P
	
NO_WALL		
	;ST	R1, HEAD_P
	RET

PACOLD		.BLKW	#1
ASTRCHK 	.FILL	xFFD6	; -*
WCHK		.FILL	x0077	; w
ACHK		.FILL	x0061	; a
SCHK		.FILL	x0073	; s
DCHK		.FILL	x0064	; d
UP_OFF		.FILL	#-46
DOWN_OFF	.FILL	#46

;-------------------------------------------------------------;
; This subroutine moves the pacman head in accordance to user.;
; This was thrown into UPDATE_MAZE                            ;
;-------------------------------------------------------------;
DELETE_OLD	
	ST	R7, DO_R7
	
	LD	R4, HEAD_P
	LD	R5, SPACE
	STR	R5, R4, #0

	LD	R7, DO_R7
	RET

DO_R7	.BLKW	#1
SPACE	.FILL	x0020

;-------------------------------------------------------------;
; Checks to see if the game is over.                          ;
;-------------------------------------------------------------;
CHECK_END
	LD	R3, HEAD_P	; Logic for win
	LD	R4, MAZE
	LD	R5, WIN_P
	ADD	R4, R4, R5
	NOT	R4, R4
	ADD	R4, R4, #1
	ADD	R4, R3, R4
	BRz	WIN
	
				; Logic for loss
		

	RET

LOSE	LEA	R0, GAME_OVER
	PUTS
	HALT

WIN	LEA	R0, GAME_GOOD
	PUTS
	HALT
	
WIN_P	.FILL	x2F0
GAME_OVER
	.STRINGZ "Game Over! You Lose!"
GAME_GOOD
	.STRINGZ "Game Over! You Win!"
MAZE	.FILL	X5000


	.END
