; Lab 2
; Christian R. Garcia - CRG 2965
; One issue, A/B/C/D/F hex bits don't reset each time this is ran.
	.ORIG 	x3000

	LD	R0, STRT
	LD	R7, CNT
	LD	R4, CNT
	LD	R6, SCR
	LD	R5, MAX		; Count for SORT

	ADD	R5, R5, #-1
	NOT	R5, R5

END1	ADD	R1, R4, R5
	BRn	SORT
	BRz	LYZE1

INLP	LD	R7, CNT
	ADD	R4, R4, #1
	BR	END1

SORT	ADD	R1, R0, R7
	LDR	R2, R1, #1
	LDR	R3, R1, #3	
	ADD	R3, R3, #0
	BRz	INLP
	AND	R2, R2, R6
	AND	R3, R3, R6
	ADD	R3, R3, #-1
	NOT	R3, R3
	ADD	R2, R2, R3 
	BRp	SWP
END2	ADD	R7, R7, #2
	BR	END1

SWP	LDR	R2, R1, #1
	LDR	R3, R1, #3
	STR	R2, R1, #3
	STR	R3, R1, #1
	LDR	R2, R1, #0
	LDR	R3, R1, #2
	STR	R2, R1, #2
	STR	R3, R1, #0
	BR	END2

LYZE1	LD	R7, CNT
	LD	R6, SCR
LYZE2	ADD	R1, R0, R7
	LDR	R2, R1, #1
	BRz	STOP
	LDR	R2, R1, #1
	AND	R2, R2, R6
	BR	HIST

ADDED	ADD	R7, R7, #2
	BR	LYZE2

HIST	LD	R5, F
	ADD	R5, R5, #-1
	NOT 	R5, R5
	ADD	R3, R2, R5
	BRnz	ADDF
	LD	R5, D
	ADD	R5, R5, #-1
	NOT 	R5, R5
	ADD	R3, R2, R5
	BRnz	ADDD
	LD	R5, C
	ADD	R5, R5, #-1
	NOT 	R5, R5
	ADD	R3, R2, R5
	BRnz	ADDC
	LD	R5, B
	ADD	R5, R5, #-1
	NOT 	R5, R5
	ADD	R3, R2, R5
	BRnz	ADDB
	LD	R5, A
	ADD	R5, R5, #-1
	NOT 	R5, R5
	ADD	R3, R2, R5
	BRnz	ADDA

ADDF	LDR	R4, R0, #-5
	ADD	R4, R4, #1
	STR	R4, R0, #-5
	BR	ADDED

ADDD	LDR	R4, R0, #-4
	ADD	R4, R4, #1
	STR	R4, R0, #-4
	BR	ADDED
	
ADDC	LDR	R4, R0, #-3
	ADD	R4, R4, #1
	STR	R4, R0, #-3
	BR	ADDED

ADDB	LDR	R4, R0, #-2
	ADD	R4, R4, #1
	STR	R4, R0, #-2
	BR	ADDED

ADDA	LDR	R4, R0, #-1
	ADD	R4, R4, #1
	STR	R4, R0, #-1
	BR	ADDED

STOP	LD 	R2, Aa
	LDR	R3, R0, #-1
	ADD	R3, R3, R2
	STR	R3, R0, #-1
	
	LD 	R2, Ba
	LDR	R3, R0, #-2
	ADD	R3, R3, R2
	STR	R3, R0, #-2
	
	LD 	R2, Ca
	LDR	R3, R0, #-3
	ADD	R3, R3, R2
	STR	R3, R0, #-3
	
	LD 	R2, Da
	LDR	R3, R0, #-4
	ADD	R3, R3, R2
	STR	R3, R0, #-4
	
	LD 	R2, Fa
	LDR	R3, R0, #-5
	ADD	R3, R3, R2
	STR	R3, R0, #-5


STRT	.FILL	x4005
CNT	.FILL	X0000
SCR	.FILL	x00FF		; Gets score only
MAX	.FILL	x0014
A	.FILL	x0064
B	.FILL	x004F
C	.FILL	x003B
D	.FILL	x0027
F	.FILL	x0013
Aa	.FILL	x4100
Ba	.FILL	x4200
Ca	.FILL	x4300
Da	.FILL	x4400
Fa	.FILL	x4600
;MAX	.FILL	X007F		; Max array size of 256/2 = 128, for jumping by #2

	.END
