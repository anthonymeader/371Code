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
;---Setup LED2
		bis.b	#BIT6, &P6DIR
		bic.b	#BIT6, &P6OUT

		bic.b	#BIT1, &P4DIR		;Set P4.1 as input. P4.1 = S1
		bis.b	#BIT1, &P4REN		;enable pull up/down resistor on P4.1
		bis.b	#BIT1, &P4OUT		;conf resistor as pull up
		bis.b	#BIT1, &P4IES

		bic.b	#BIT3, &P2DIR
		bis.b	#BIT3, &P2REN
		bis.b	#BIT3, &P2OUT
		bis.b	#BIT3, &P2IES

		bic.b	#LOCKLPM5, &PM5CTL0

		bic.b	#BIT1, &P4IFG
		bis.b	#BIT1, &P4IE
		bic.b	#BIT3, &P2IFG
		bis.b	#BIT3, &P2IE

		bis.w	#GIE, SR

		mov.b	#00b, R4
main:
;		cmp.b 	#0, R4
;		jz		Zero
;		cmp.b	#1, R4
;		jz		One
;		cmp.b	#2, R4
;		jz		Two
;		cmp.b	#3, R4
;		jz		Three
;		jmp		Else
		jmp		main
;Zero:
;		bic.b	#BIT0, &P1OUT
;		bic.b	#BIT6, &P6OUT
;		jmp		main
;One:
;		bis.b	#BIT6, &P6OUT
;		bic.b	#BIT0, &P1OUT
;		jmp		main
;Two:
;		bic.b	#BIT6, &P6OUT
;		bis.b	#BIT0, &P1OUT
;		jmp		main
;Three:
;		bis.b	#BIT0, &P1OUT
;		bis.b	#BIT6, &P6OUT
;		jmp		main
;Else:
;		bic.b	#BIT0, &P1OUT
;		bic.b	#BIT6, &P6OUT
;		jmp		main
;Demo1
;ISR_INC:
;		inc.b	R4
;		bic.b	#BIT1, &P4IFG
;		reti
;ISR_DEC:
;	dec		R4
;	bic.b	#BIT3, &P2IFG
;	reti

;Demo2
ISR_S1:
		xor.b	#BIT0, &P1OUT
		bic.b	#BIT1, &P4IFG
		reti
ISR_S2:
		xor.b	#BIT6, &P6OUT
		bic.b	#BIT3, &P2IFG
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
            ;.short ISR_INC

            .sect	".int24"
            .short	ISR_S2
            ;.short ISR_DEC
