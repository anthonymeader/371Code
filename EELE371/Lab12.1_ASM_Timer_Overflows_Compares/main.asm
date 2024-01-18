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
		bis.b	#BIT0, &P1DIR		; make p1 bit 0 and output
		bic.b	#BIT0, &P1OUT		; set low initially
		bis.b	#BIT6, &P6DIR
		bic.b	#BIT6, &P6OUT
		bic.b	#LOCKLPM5, &PM5CTL0	; enables dig i/o

;Demo1
;----SetUp Timers
		bis.w	#TBCLR, &TB0CTL		; clears timer
		bis.w	#TBCLR, &TB1CTL
		bis.w	#TBSSEL__ACLK, &TB0CTL
		bis.w	#TBSSEL__ACLK, &TB1CTL
		bis.w	#ID__4, &TB0CTL		;divide first divder by 4
		bis.w	#ID__8,	&TB1CTL
		bis.w	#MC__CONTINUOUS, &TB1CTL
		bis.w	#MC__CONTINUOUS, &TB0CTL
		bis.w	#CNTL_1, &TB0CTL	; timer into 12 bit mode
		bis.w	#CNTL_1, &TB1CTL

;----SetUp IRQ
		bis.w	#TBIE,&TB0CTL		; Local Enable for Time Overflow
		bis.w	#TBIE, &TB1CTL

		bis.w	#GIE, SR			; global enable for maskable

		bic.w	#TBIFG, &TB0CTL		; clear flag
		bic.w	#TBIFG,	&TB1CTL

;Demo2
;----SetUp Timers
;		bis.w	#TBCLR, &TB0CTL
;		bis.w	#TBSSEL__ACLK, &TB0CTL
;		bis.w	#MC__UP, &TB0CTL
;
;		mov.w	#8192,  &TB0CCR0		; set max overflow value in CCR0
;		bis.w	#CCIE,  &TB0CCTL0		; enable IRQ
;		bic.w	#CCIFG, &TB0CCTL0		; clear flag
;
;
;		bis.w	#TBCLR, &TB1CTL
;		bis.w	#TBSSEL__ACLK, &TB1CTL
;		bis.w	#MC__UP, &TB1CTL
;
;
;		mov.w	#16384, &TB1CCR0
;		bis.w	#CCIE,  &TB1CCTL0		; enable IRQ
;		bic.w	#CCIFG, &TB1CCTL0		; clear flag
;
;		bis.w	#GIE, SR				; turn on maskable IRQs
;
;


main:
		jmp		main
;------------------------------------------------------------
;--ISR
;------------------------------------------------------------
;Demo1
ISR_TB0_Overflow:
		xor.b	#BIT6, &P6OUT				; toggle LED 1 on P1.0
		bic.w	#TBIFG, &TB0CTL				; clear overflow flag
		reti
ISR_TB1_Overflow:
		xor.b	#BIT0, &P1OUT
		bic.w	#TBIFG, &TB1CTL
		reti
;
;
;Demo2
;ISR_TB0_Overflow:
;		xor.b	#BIT6, &P6OUT
;		bic.w	#CCIFG,	&TB0CCTL0		; clear CCR0 overflow flag
;		reti
;
;ISR_TB1_Overflow:
;		xor.b	#BIT0, &P1OUT
;		bic.w	#CCIFG,	&TB1CCTL0		; clear CCR0 overflow flag
;		reti
;;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
			;Demo1
            .sect ".int42"
            ;Demo2
            ;.sect	".int43"				; setup TB0 overflow Vector

            .short	ISR_TB0_Overflow


			;Demo1
			.sect ".int40"
			;Demo2
            ;.sect	".int41"

            .short	ISR_TB1_Overflow
