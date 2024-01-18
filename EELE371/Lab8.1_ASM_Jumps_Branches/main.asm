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
	bic.b	#00001111b, P5DIR
	bis.b	#00001111b, P5REN
	bic.b	#00001111b, P5OUT

	bic.w	#001h, PM5CTL0

	bis.b	#0000000001000001b, P1DIR
	bis.b	#0000000001000000b, P6DIR
	bic.b	#0000000001000001b, P1OUT
	bic.b	#0000000001000000b, P6OUT

;Demo 1
main:
	mov.w	#0AAAAh, R4
	jmp		Add1
Sub1:
	sub		#000Fh, R4
	jmp		ToggleAll
RotateLeft:
	rla.w	R4
	jmp		Done
ToggleAll:
	xor		#1111111111111111b, R4
	jmp		RotateLeft
Add1:
	add		#0005h, R4
	jmp 	Sub1
Done:
	mov.b	P5IN, R5
	cmp.b	#00h, R5
	jz 		SolidGreen
	jnz		SolidRed
    jmp		Done
;Demo2
SolidGreen:
	bis.b	#0000000001000000b, P6OUT
	bic.b	#0000000001000001b, P1OUT

	jmp		Done


SolidRed:
	bis.b	#01000001b, P1OUT
	bic.b	#01000000b, P6OUT
	cmp.b	#04h, R5
	jge		FastBlink
	jl		SlowBlink
SlowBlink:
	bis.b	#01000000b, P6OUT
	mov.w	#0FFFFh, R6
SlowDelayOn:
	dec		R6
	jnz		SlowDelayOn
	bic.b	#01000000b, P6OUT
	mov.w	#0FFFFh, R6
SlowDelayOff:
	dec		R6
	jnz		SlowDelayOff
	jmp 	Done

FastBlink:
	bis.b	#01000000b, P6OUT
	mov.w	#0FFFh, R6
FastDelayOn:
	dec 	R6
	tst.w	R6
	jn		ContinueOn
	jmp		FastDelayOn
ContinueOn:
	bic.b	#01000000b, P6OUT
	mov.w	#0FFFh,	R6
FastDelayOff:
	dec 	R6
	tst.w	R6
	jn		ContinueOff
	jmp		FastDelayOff
ContinueOff:
	jmp 	Done



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
            
