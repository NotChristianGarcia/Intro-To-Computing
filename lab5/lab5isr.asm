;------------------------- Interrupt --------------------------;
; Directions: This interrupt service routine works with        ;
; "Lab5main.asm" and takes a keyboard input and displays       ;
; either "eeeeeeeeee","cccccccccc", or "ECE". Depending on     ;
; input.                                                       ;
;--------------------------------------------------------------;
; Christian R. Garcia                                          ;
; 5/1/18                                                       ;
;--------------------------------------------------------------;
		.ORIG	x1500

; Saves R0,R1,R2, and R7, from before ISR
		ST	R0, R0SAVE
		ST	R1, R1SAVE
		ST	R2, R2SAVE
		ST	R7, R7SAVE

; Load input from keyboard
		LDI	R0, KBDR

; Checks for e, if there is an e then EORCDISP is called
ECHK		LD	R1, ETEST
		NOT	R1, R1
		ADD	R1, R1, #1
		ADD	R1, R0, R1
		BRz	EORCDISP

; Checks for c, if there is a c then EORCDISP is called
CCHK		LD	R1, CTEST
		NOT	R1, R1
		ADD	R1, R1, #1
		ADD	R1, R0, R1
		BRz	EORCDISP

; If neither e or c then ECE is displayed
ECE		LD	R0, BIGE
		JSR	DISPLAY
		LD	R0, BIGC
		JSR	DISPLAY
		LD	R0, BIGE
		JSR	DISPLAY
		BR	ENDISR

; If e or c then e/c is displayed 10 times
EORCDISP	LD	R2, TEN
TENLOOP		JSR	DISPLAY			
		ADD	R2, R2, #-1
		BRz	ENDISR
		BR	TENLOOP

; Takes R0, and displays when DSR is ready by polling
DISPLAY		LDI	R1, DSR
		BRzp	DISPLAY
		STI	R0, DDR
		RET

; Loads back in saved registers and returns with RTI
ENDISR		LD	R0, R0SAVE
		LD	R1, R1SAVE
		LD	R2, R2SAVE
		LD	R7, R7SAVE
		RTI

R0SAVE		.BLKW		#1
R1SAVE		.BLKW		#1
R2SAVE		.BLKW		#1
R7SAVE		.BLKW		#1
BIGC		.FILL		x0043
BIGE		.FILL		x0045
ETEST		.FILL		x0065
CTEST		.FILL		x0063
TEN		.FILL		#10
KBDR		.FILL		xFE02
DSR		.FILL		xFE04
DDR		.FILL		xFE06
BUFFER		.BLKW		#100
		.END
