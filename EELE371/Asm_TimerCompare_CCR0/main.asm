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
;--SetUp LED1
			bis.b	#BIT0, &P1DIR
			bic.b	#BIT0, &P1OUT

			bic.b	#LOCKLPM5, &PM5CTL0

;--SetUp Timers
			bis.w	#TBCLR, &TB0CTL			;Clears TB0
			bis.w	#TBSSEL__ACLK, &TB0CTL	; sets clock source to ACLK = 32k
			bis.w	#MC__UP, &TB0CTL		; Set mode to UP so i can use CCR0

;--SetUp Time Compare Register
			mov.w	#32768, &TB0CCR0		; set max overflow value in CCR0

			bis.w	#CCIE, &TB0CCTL0		; enable IRQ
			bic.w	#CCIFG, &TB0CCTL0		; clear flag


			bis.w	#GIE, SR				; turn on maskable IRQs

main:
			jmp		main

                                            
;----------------------------------------------------
; ISR
;----------------------------------------------------
ISR_TB0_CCR0:
			bis.b	#BIT0, &P1OUT 			; set LED1 = 1
			bic.w	#CCIFG,	&TB0CCTL0		; clear CCR0 overflow flag
			reti

ISR_TB0_CCR1:
			bic.b	#BIT0, &P1OUT 			; set LED1 = 1
			bic.w	#CCIFG,	&TB0CCTL1		; clear CCR1 overflow flag
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

            .sect	".int42"
            .short	ISR_TB0_CCR1


