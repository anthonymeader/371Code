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
;----Setup LED1
		bis.b	#BIT0, &P1DIR		; make p1 bit 0 and output
		bic.b	#BIT0, &P1OUT		; set low initially
		bic.b	#LOCKLPM5, &PM5CTL0	; enables dig i/o

;----Setup Time B0
		bis.w	#TBCLR, &TB0CTL				; clear time B0
		bis.w	#TLBSSEL__ACLK, &TB0CTL		; choose ACLK as source
		bis.w	#MC__CONTINUOUS, &TB0CTL	; put TB0 in continous
		bis.w	#TBIE, &TB0CTL				; local IRQ enable for TB0 overflow
		bic.w	#TBIFG, &TB0CTL				; clear overflow flag
		bis.w	#GIE, SR					; enable global IRQs

main:


		jmp		main
;------------------------------------------------------------
;--ISR
;------------------------------------------------------------
ISR_TB0_Overflow:
		xor.b	#BIT0, &P1OUT				; toggle LED 1 on P1.0
		bic.w	#TBIFG, &TB0CTL				; clear overflow flag
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
            
            .sect	".int42"				; setup TB0 overflow Vector
            .short	ISR_TB0_Overflow
