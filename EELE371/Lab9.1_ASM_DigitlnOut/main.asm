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
			bis.b	#BIT6, &P6DIR		; Setup P6.6 as output. P6.6 = LED2
			bic.b	#BIT6, &P6OUT		;Set initial value of LED2 = OFF

			bis.b	#BIT0, &P1DIR
			bic.b	#BIT0, &P1OUT

			bic.b	#BIT1, &P4DIR		;Set P4.1 as input. P4.1 = S1
			bis.b	#BIT1, &P4REN		;enable pull up/down resistor on P4.1
			bis.b	#BIT1, &P4OUT		;conf resistor as pull up

			bic.b	#BIT3, &P2DIR
			bis.b	#BIT3, &P2REN
			bis.b	#BIT3, &P2OUT

			bic.b	#BIT0, P5DIR
			bis.b	#BIT0, P5REN
			bic.b	#BIT0, P5OUT


			bic.b	#LOCKLPM5, &PM5CTL0 ; enabled digital I/O


main:
			mov.w	#0FFFFh, R4
			mov.b	#00h, R5
			mov.b	#00h, R6
			mov.b	#00h, R7
polling_p5:
			mov.b	&P4IN, R5
			mov.b	&P2IN, R6
			mov.b 	&P5IN, R7
			bit.b	#BIT0,	&P5IN
			jnz		polling_S1
			jz		main
			;jz		polling_S1
polling_S1:
			bit.b	#BIT1, &P4IN
			jnz		polling_S2
			jz		selandled2
polling_S2:
			bit.b	#BIT3, &P2IN
			jnz		main
			jz 		selandled1
selandled2:
			mov.b	&P4IN, R5
			mov.b	&P2IN, R6
			mov.b 	&P5IN, R7
			xor.b	#BIT6, &P6OUT
			jmp		delay
selandled1:
			mov.b	&P4IN, R5
			mov.b	&P2IN, R6
			mov.b 	&P5IN, R7
			xor.b	#BIT0, &P1OUT
			jmp		delay

delay:
			dec.w	R4
			jnz 	delay
			jmp		main







;Flashing LED Code
;poll_S1:
;			bit.b	#BIT1, &P4IN		;test P4.1
;			jnz		poll_S2				;stay in polling loop
;			jz		flash_led2
;poll_S2:
;			bit.b	#BIT3, &P2IN
;			jnz		main
;			jz		flash_led1
;flash_led2:
;		bis.b	#BIT6, &P6OUT
;		mov.w	#0FFFFh, R4
;MainDelayOn:
;		dec		R4
;		jnz		MainDelayOn
;		bic.b	#BIT6, &P6OUT
;		mov.w	#0FFFFh, R4
;MainDelayOff:
;		dec		R4
;		jnz 	MainDelayOff
;		jz		main
;
;flash_led1:
;		bis.b	#BIT0,	&P1OUT
;		mov.w	#0FFFFh, R4
;MainDelayOn1:
;		dec		R4
;		jnz		MainDelayOn1
;		bic.b	#BIT0, &P1OUT
;		mov.w	#0FFFFh, R4
;MainDelayOff1:
;		dec		R4
;		jnz 	MainDelayOff1
;		jz		main



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
            
