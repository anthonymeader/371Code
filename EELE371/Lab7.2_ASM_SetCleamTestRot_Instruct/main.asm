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
init:
			mov.w #0000h, R4
			mov.w #0FFFFh, R5
			mov.w #0F0F0h, R6
			mov.w #0BEEFh, R7
			mov.w #0DEEDh, R8
			mov.w #0ECEh, R9
			mov.w #0000h, R10
			mov.w #1000h, R11
;Demo1
main:
			bis.w	#0001000000001000b, R4
			bis.w	#0000000000000110b, R4

			bic.w	#0000010000100000b, R5
			bic.w	#0001100000000000b, R5


;Demo2
			bit.w	#0000000000000001b, R6
			bit.w	#1000000000000000b, R6
			bit.w	#0000000000001111b, R6
			bit.w	#1111000000000000b, R6

			cmp.w	#0DEEDh, R7
			cmp.w	#0DEEDh, R8
			cmp.w	#0DEEDh, R9

			tst.w 	R7
			tst.w 	R10
			tst.w	R8
			tst.w	R9


;Demo 3

			rla.w	R11
			rla.w	R11
			rla.w	R11
			rla.w	R11

			rrc.w	R11

			rra.w	R11
			rra.w	R11
			rra.w 	R11

			rlc.w	R11

			rlc.w	R11
			rlc.w	R11
			rlc.w	R11
			rlc.w	R11
			rrc.w	R11
			rrc.w	R11
			rrc.w	R11
			rrc.w	R11
			rrc.w	R11


			mov.w	#0000h, R12
			add		#8, R12
			add		#50, R12
			add		#78, R12
			add		#40, R12

			rra.w	R12
			rra.w	R12



			jmp		main
                                            

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
            
