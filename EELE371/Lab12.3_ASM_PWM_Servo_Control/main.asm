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

		bis.b	#BIT4, &P1DIR
		bis.b	#BIT4, &P1OUT

		bic.b	#BIT1, &P4DIR		;Set P4.1 as input. P4.1 = S1
		bis.b	#BIT1, &P4REN		;enable pull up/down resistor on P4.1
		bis.b	#BIT1, &P4OUT		;conf resistor as pull up
		bis.b	#BIT1, &P4IES

		bic.b	#BIT3, &P2DIR
		bis.b	#BIT3, &P2REN
		bis.b	#BIT3, &P2OUT
		bis.b	#BIT3, &P2IES


		bic.b	#BIT1, &P4IFG
		bis.b	#BIT1, &P4IE
		bic.b	#BIT3, &P2IFG
		bis.b	#BIT3, &P2IE


		bis.w	#TBCLR, &TB0CTL
		bis.w	#TBSSEL__SMCLK, &TB0CTL
		bis.w	#MC__UP, &TB0CTL

		mov.w	#20000, &TB0CCR0
		mov.w	#1500, &TB0CCR1

		bis.w	#CCIE, &TB0CCTL0
		bic.w	#CCIFG, &TB0CCTL0

		bis.w	#CCIE, &TB0CCTL1
		bic.w	#CCIFG, &TB0CCTL1

		bic.b	#LOCKLPM5, &PM5CTL0


		bis.w	#GIE, SR


                                            
main:
		jmp		main
;---------------------------------------
;ISR:
;---------------------------------------
Switch_1:
	add.w	#100, &TB0CCR1
	cmp.b	#2000, &TB0CCR1
	jz		Boundry
	bic.b	#BIT1, &P4IFG
	reti
Switch_2:
	sub.w	#100, &TB0CCR1
	cmp.b	#1000, &TB0CCR1
	jz		Boundry1
	bic.b	#BIT3, &P2IFG
	reti

ISR_TB0_CCR1:
		bic.b	#BIT4, &P1OUT
		bic.w	#CCIFG, &TB0CCTL1
		reti

ISR_TB0_CCR0:
		bis.b	#BIT4, &P1OUT
		bic.w	#CCIFG, &TB0CCTL0
		reti

Boundry:
	mov.w	#2000, &TB0CCR1
	bic.b	#BIT0, &P1OUT
	reti

Boundry1:
	mov.w	#1000, &TB0CCR1
	bic.b	#BIT0, &P1OUT
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
            .short	Switch_1

            .sect 	".int24"
            .short	Switch_2

             .sect	".int43"
           .short	ISR_TB0_CCR0

           .sect 	".int42"
           .short	ISR_TB0_CCR1

