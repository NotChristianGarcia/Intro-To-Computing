; Getting length of an array that has it starting location in x3500

;	LD 	R0, PTR     	; R0 is the pointer to starting address of array
;	LD 	R0, R0, #0

	LDI	R0, PTR		; Replaces two things above, takes mem[mem[#]] and uses that.
	AND	R1, R1, #0	; Clearing R1
Loop	LDR	R2, R0, #0 	; Getting data from array address
		BR2	END


END 	LD 	R0, PTR
	STR 	R1, R0, #1
	.HALT

PTR 	.FILL 	x3500
