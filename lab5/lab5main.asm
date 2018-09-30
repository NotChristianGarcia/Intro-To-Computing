;--------------------- Interrupt Tester -----------------------;
; Directions: Use your keyboard to interrupt the infinite loop ;
; of printing "*  " 20 times per line. If your input is a      ;
; litte e then "eeeeeeeeee" will display, similar with c. All  ;
; other inputs will result in "ECE" being printed to display.  ;
;--------------------------------------------------------------;
; Christian R. Garcia                                          ;
; 5/1/18                                                       ;
;--------------------------------------------------------------;
		.ORIG	x2FFE

; Block out space for stack and initialize stack pointer
STACK		.BLKW	3
		LD	R6, STKPOINT			

; Add location of ISR to vector table @ x0180
MAKEVECT	LD	R0, KBRDVECT
		LD	R1, KBRDINTS
		STR	R1, R0, #0

; Enable keyboard interrupts by fliping bit 14 of KBSR to 1
ENABINT		LD	R0, KBSR
		LD	R1, KEY14
		STR	R1, R0, #0

; Code to print a line of data, then looping infinitely
PRINTLN		LD	R1, TWENTY
		LD	R0, NEWLN
		OUT
		JSR	WAIT
PRTLOOP		LD	R0, STAR
		OUT
		JSR	WAIT
		LD	R0, BLANK
		OUT
		JSR	WAIT
		OUT
		JSR	WAIT
		ADD	R1, R1, #-1
		BRnp	PRTLOOP
		BRz	PRINTLN
		
; Wait loop added after each character so allow time to read everything
WAIT		LD	R2, WAITTIME
WAITLOOP	ADD	R2, R2, #-1
		BRnp	WAITLOOP
		RET

STKPOINT	.FILL	x3000
KBRDVECT	.FILL	x0180
KBRDINTS	.FIll	x1500
KBSR		.FILL	xFE00
KEY14		.FILL	x4000
NEWLN		.FILL	x000A
STAR		.FILL	x002A
BLANK		.FILL	x0020
TWENTY		.FILL	#20
WAITTIME	.FILL	#10000
		.END
