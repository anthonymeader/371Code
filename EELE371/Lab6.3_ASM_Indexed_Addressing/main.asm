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
			mov.w	#Block1, R4
			mov.w	#Block2, R5

			mov.w	0(R4), 0(R5)
			mov.w	2(R4), 2(R5)
			mov.w	4(R4), 4(R5)
			mov.w	6(R4), 6(R5)
			mov.w	8(R4), 8(R5)
			mov.w	10(R4),	10(R5)
			mov.w	12(R4),	12(R5)
			mov.w	14(R4),	14(R5)


			mov.w	#0000h, 0(R5)
			mov.w	#0000h, 2(R5)
			mov.w	#0000h, 4(R5)
			mov.w	#0000h, 6(R5)
			mov.w	#0000h, 8(R5)
			mov.w	#0000h,	10(R5)
			mov.w	#0000h,	12(R5)
			mov.w	#0000h,	14(R5)


			mov.w	0(R4), 14(R5)
			mov.w	2(R4), 12(R5)
			mov.w	4(R4), 10(R5)
			mov.w	6(R4), 8(R5)
			mov.w	8(R4), 6(R5)
			mov.w	10(R4),	4(R5)
			mov.w	12(R4),	2(R5)
			mov.w	14(R4),	0(R5)

			mov.w	#0000h, 0(R5)
			mov.w	#0000h, 2(R5)
			mov.w	#0000h, 4(R5)
			mov.w	#0000h, 6(R5)
			mov.w	#0000h, 8(R5)
			mov.w	#0000h,	10(R5)
			mov.w	#0000h,	12(R5)
			mov.w	#0000h,	14(R5)

			jmp		main


;---------------------------
;Data Memory Allocation
;---------------------------
			.data
			.retain
Block1:		.short	0DEADh, 0BEEFh, 0BABEh, 0FACEh, 0DEAFh, 0FADEh, 0DEEDh, 0ACEDh
Block2:		.short	0000h,	0000h, 	0000h,	0000h,	0000h,	0000h,	0000h,	0000h




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
            
