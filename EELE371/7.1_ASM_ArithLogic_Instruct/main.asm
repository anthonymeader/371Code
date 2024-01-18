;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
main:
;Demo1
;Add
			mov.w	AddendA, R4
			mov.w	AddendB, R5
			add		R4, R5
			mov.w	R5, SumAB

			mov.w	AddendC, R4
			mov.w	AddendD, R5
			add		R4, R5
			mov.w	R5, SumCD

			mov.w	AddendE, R4
			mov.w	AddendF, R5
			add		R4, R5
			mov.w 	R5, SumEF

			mov.w	AddendG, R4
			mov.w	AddendH, R5
			add		R4, R5
			mov.w	R5, SumGH
;Sub

			mov.w	#MinuendA, R4
			mov.w	#SubtrahendB, R5
			mov.w	#DiffAB, R6

			mov.w	0(R4), R7
			mov.w	0(R5), R8
			sub.w	R8, R7
			mov.w	R7, 0(R6)

			mov.w	#DiffCD, R6
			mov.w	6(R4), R7
			mov.w	6(R5), R8
			sub.w	R8, R7
			mov.w	R7, 0(R6)


			mov.w	#DiffEF, R6
			mov.w	12(R4), R7
			mov.w	12(R5), R8
			sub.w	R8, R7
			mov.w	R7, 0(R6)


			mov.w	#DiffGH, R6
			mov.w	18(R4), R7
			mov.w	18(R5), R8
			sub.w	R8, R7
			mov.w	R7, 0(R6)

;Demo2

			mov.w	#Input1, R4
			mov.w	#Input2, R5
			mov.w	#Sum12, R6
			mov.w	#Diff12, R7

			mov.w	0(R4), R8
			mov.w	0(R5), R9
			add.w	R8, R9
			mov.w	R9, 0(R6)

			mov.w 	2(R4), R10
			mov.w	2(R5), R11
			addc.w	R10, R11
			mov.w 	R11, 2(R6)

;Demo3
			mov.b	#00000000b, R3
			mov.b	#00000000b, R4
			mov.b	#00000000b, R5

			mov.b	#0FFh, R4
			and.b	#11111110b, R4
			and.b	#01111111b, R4
			and.b	#10011111b, R4

			mov.b	#0000h, R4
			or.b	#00000001b, R4
			or.b	#10000001b, R4
			or.b	#01111110b, R4

			mov.b	#0000h, R4
			xor.b	#11110000b, R4
			xor.b	#00111100b, R4
			xor.b	#11110000b, R4





			jmp		main

;--------------------------------------
;Data Memory Allocation
;--------------------------------------
			.data
			.retain

AddendA:	.short	5555h
AddendB:	.short	0BBBBh
SumAB:		.space	2
AddendC:	.short	0FFFFh
AddendD:	.short	0FFFFh
SumCD:		.space 	2
AddendE:	.short	5555h
AddendF:	.short 	5555h
SumEF:		.space 	2
AddendG:	.short	0002h
AddendH:	.short	0FFFEh
SumGH:		.space 	10
;Sub
MinuendA:		.short	0BBBBh
SubtrahendB:	.short	5555h
DiffAB:			.space	2
MinuendC:		.short	5555h
SubtrahendD:	.short	0BBBBh
DiffCD:			.space	2
MinuendE:		.short	5555h
SubtrahendF:	.short	5555h
DiffEF:			.space	2
MinuendG:		.short	2222h
SubtrahendH:	.short	4444h
DiffGH:			.space	10
;Demo2 Initialize
Input1:			.long	55555BBBh
Input2:			.long	0BBBBB555h
Sum12:			.space 4
Diff12:			.space 4
Space:			.space 16



;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
