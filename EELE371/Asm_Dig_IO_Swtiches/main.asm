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
			;Setup P4.1 as Input w/ Pull UP Resistor
			bis.b	#BIT1, &P4DIR	; P4.1 in input
			bis.b	#BIT1, &P4REN ; Enable Pull Up/Down Resistors
			bis.b	#BIT1, &P4OUT ;Make it a pull UP using P4OUT

			bis.b	#BIT0, &P1DIR	; P1.0 is an OUTPUT (P1DIR.0 = 1)

			bic.b	#LOCKLPM5,	&PM5CTL0; take out of LPM turn on DigIO
main:

poll_S1:
			bit.b	#BIT1, &P4IN
			jnz		poll_S1
toggle_LED1:
			xor.b	#BIT0,	&P1OUT ; LED1= P1.0
			mov.w	#0FFFh,	R4
delay:
			dec.w	R4
			jn	delay

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
            
