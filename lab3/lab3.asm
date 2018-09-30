;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Christian R. Garcia - CRG2965						;;
;; Lab 3									;;
;; Making a double linked list, one of students at UT and the other a list	;;
;; of students in 306. The list are exclusive. Input in the console will be	;;
;; a student ID which you are trying to add to 306, you get one of three	;;
;; outputs, successful inclusion, an error saying they're already in 306,	;;
;; or a message stating that the student cannot be found.			;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.ORIG	x3000


START	BR	SAVEID


SAVEID	LD	R1, IDSIZE
	LEA	R2, IDDATA
SVLP	GETC 
	OUT
	STR	R0, R2, #0
	ADD	R2, R2, #1
	ADD 	R1, R1, #-1
	BRp	SVLP
	BR	CHKEND


SCN306	LD	R0, NEWLIN
	OUT
	LDI	R0, STR306	; Scan 306 list
	LEA	R7, PREXST
	LEA	R6, NI306
	BR	CHKNOD
NI306	BR	SCNUTL		; Not in 306


SCNUTL	LDI	R0, STRUTL	; Scan UT list
	LEA	R7, ENROLL
	LEA	R6, NIUTL
	BR	CHKNOD
NIUTL	BR	NOEXST		; Not in UT


CHKNOD	LD	R5, IDSIZE
	ADD	R1, R0, #2
	LEA	R3, IDDATA
IDLOOP	LDR	R2, R1, #0
	LDR	R4, R3, #0	
	ADD	R1, R1, #1
	ADD	R3, R3, #1
	NOT	R4, R4
	ADD	R4, R4, #1
	ADD	R4, R2, R4
	BRnp	NEXTND
	ADD	R5, R5, #-1
	BRp	IDLOOP
	JMP	R7

NEXTND	LDR	R0, R0, #1
	BRnp	CHKNOD
	JMP	R6

	
ENROLL	LDR	R2, R0, #1	; Check if previous is 0
	LDR	R1, R0, #0
	BRz	PREV0
	STR	R2, R1, #1
CHKNXT	LDR	R2, R0, #1	; Check if next is 0
	BRz	CONT
	STR	R1, R2, #0

CONT	LD	R3, ZERO	; Add data to 306 list
		
	LDR	R1, R0, #1
	LDI	R2, STR306
	BRz	CONT2
	STR	R0, R2, #0
CONT2	STR	R3, R0, #0
	STR	R2, R0, #1	
	STI	R0, STR306	; Change 306 start
	LEA	R0, ENRSTU	; Word output
	PUTSP
	BR	START
PREV0	LDR	R4, R0, #1
	STI	R4, STRUTL
	BR	CHKNXT

	
PREXST	LEA	R0, ALRSTU
	PUTSP
	BR	START


NOEXST	LEA	R0, NOFSTU
	PUTSP
	BR	START


CHKEND	LD	R5, IDSIZE
	LEA	R1, ENDID
	LEA	R3, IDDATA	
ENDLP	LDR	R2, R1, #0
	LDR	R4, R3, #0	
	ADD	R1, R1, #1
	ADD	R3, R3, #1
	NOT	R4, R4
	ADD	R4, R4, #1
	ADD	R4, R2, R4
	BRnp	SCN306
	ADD	R5, R5, #-1
	BRp	ENDLP
	HALT

ZERO	.FILL	x0000
STR306	.FILL	x3800
STRUTL	.FILL	x3801
IDSIZE	.FILL	x0005
IDDATA	.BLKW	5
ENDID	.FILL	x0030		; If ID is this, halt
	.FILL	x0030
	.FILL	x0030
	.FILL	x0030
	.FILL	x0030
NEWLIN	.FILL	x000A
NOFSTU	.FILL	x6143		; No found student text
	.FILL	x6e6e
	.FILL	x746f
	.FILL	x6620
	.FILL	x6e69
	.FILL	x2064
	.FILL	x7473
	.FILL	x6475
	.FILL	x6e65
	.FILL	x0074
	.FILL	x0000
ENRSTU	.FILL	x7553		; Enrolled student text
	.FILL	x6363
	.FILL	x7365
	.FILL	x6673
	.FILL	x6c75
	.FILL	x796c
	.FILL	x6520
	.FILL	x726e
	.FILL	x6c6f
	.FILL	x656c
	.FILL	x2064
	.FILL	x7473
	.FILL	x6475
	.FILL	x6e65
	.FILL	x2074
	.FILL	x6e69
	.FILL	x3320
	.FILL	x3630
	.FILL	x0000
ALRSTU	.FILL	x7453		; Already enrolled student text
	.FILL	x6475
	.FILL	x6e65
	.FILL	x2074
	.FILL	x7369
	.FILL	x6120
	.FILL	x726c
	.FILL	x6165
	.FILL	x7964
	.FILL	x6520
	.FILL	x726e
	.FILL	x6c6f
	.FILL	x656c
	.FILL	x2064
	.FILL	x6e69
	.FILL	x3320
	.FILL	x3630
	.FILL	x0000

	.END
