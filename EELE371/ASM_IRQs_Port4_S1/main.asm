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
	;Set Up S1 = P4.1
	bic.b	#BIT1, &P4DIR	; make P4.1 and INPUT
	bis.b	#BIT1, &P4REN	; enable pull UP/DOWN resistor
	bis.b	#BIT1, &P4OUT	; Make resistor a Pull Up

	;Set Up LED1 = P1.0
	bis.b	#BIT0, &P1DIR
	bic.b	#BIT0, &P1OUT	;initially drive LED = off

	bic.b	#LOCKLPM5, &PM5CTL0 ;turn on dig I/O

	;Setup P4.1 Interupt
	bis.b	#BIT1, &P4IES	; Make IRQ Falling Edge sens
	bic.b	#BIT1, &P4IFG	; clear IRQ Fkag intally
	bis.b	#BIT1, &P4IE	; Enable Local Enable

	bis.w	#GIE, SR		; Enable Global Enable
main:
			jmp		main	; Loop Forever

;-------------------------------------------------------------------------------
;-- ISR for P4.1 = SW1
;-------------------------------------------------------------------------------
ISR_S1:
	xor.b	#BIT0, &P1OUT	; Toggle LED1
	bic.b	#BIT1, &P4IFG	; cleared the flag
	reti

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
            
            .sect	".int22"
            .short	ISR_S1
