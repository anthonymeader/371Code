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
		bis.b	#BIT0, &P1DIR
		bis.b	#BIT0, &P1OUT

		bis.b	#BIT6, &P6DIR
		bis.b	#BIT6, &P6OUT
		bic.b	#LOCKLPM5, &PM5CTL0

		bis.w	#TBCLR, &TB0CTL
		bis.w	#TBCLR, &TB1CTL
		bis.w	#TBSSEL__ACLK, &TB0CTL
		bis.w	#TBSSEL__ACLK, &TB1CTL
		bis.w	#MC__UP, &TB0CTL
		bis.w	#MC__UP, &TB1CTL


		mov.w	#32768, &TB0CCR0
		mov.w	#328,	&TB0CCR1
		bis.w	#CCIE, &TB0CCTL0
		bic.w	#CCIFG, &TB0CCTL0
		bis.w	#CCIE, &TB0CCTL1
		bic.w	#CCIFG, &TB0CCTL1

		mov.w	#32768,	&TB1CCR0
		mov.w	#8192,	&TB1CCR1
		bis.w	#CCIE, &TB1CCTL0
		bic.w	#CCIFG, &TB1CCTL0
		bis.w	#CCIE, &TB1CCTL1
		bic.w	#CCIFG, &TB1CCTL1

		bis.w	#GIE, SR

main:
		jmp		main

;--------------------------------------------------------------------
; Interrupt Service Routines
;--------------------------------------------------------------------

ISR_TB0_CCR1:
		bic.b	#BIT0, &P1OUT
		bic.w	#CCIFG, &TB0CCTL1
		reti

ISR_TB0_CCR0:
		bis.b	#BIT0, &P1OUT
		bic.w	#CCIFG, &TB0CCTL0
		reti

ISR_TB1_CCR1:
		bic.b	#BIT6, &P6OUT
		bic.w	#CCIFG, &TB1CCTL1
		reti
ISR_TB1_CCR0:
		bis.b	#BIT6, &P6OUT
		bic.w	#CCIFG, &TB1CCTL0
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

           .sect	".int43"
           .short	ISR_TB0_CCR0

           .sect 	".int42"
           .short	ISR_TB0_CCR1

           .sect	".int41"
           .short	ISR_TB1_CCR0

           .sect 	".int40"
           .short	ISR_TB1_CCR1

