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

	mov.w	#6, R7 ;will decrement 5 times


main:
	mov.w	P5IN, R5
	bis.b	#BIT0, &P1OUT
	bis.b	#BIT6, &P6OUT
	;mov.w	#0FFFFh, R4
;MainDelayOn:
	;dec		R4
	;jnz		MainDelayOn
	;bic.b	#BIT0, &P1OUT
	;mov.w	#0FFFFh, R4
;MainDelayOff:
	;dec		R4
	;jnz 	MainDelayOff



;demo1----------------
;While:
;    bic.b	#BIT6, &P6OUT
;    cmp.w	#01h,	P5IN
;	jz		GreenLight
;    jnz		EndWhile
;EndWhile:
	;jmp 	main



;demo2----for the green light function, I had a sub function "greenlight" but I eneded up removing it and just implementing it to every function. But since I already got and demoed demo 1 &2 i left them as is
;ForLoop:
	;dec		R7
	;tst.w	R7
	;jnz		GreenLight
	;jz		EndFor
;EndFor:
	;jmp		main


;demo3-----------------
If:
	cmp.b	#01h,	R5
	jz		GreenLight
	jnz		Elseif1
GreenLight:
	bic.b	#BIT0,	P1OUT
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
	jz		EndIf

Elseif1:
	mov.w	P5IN, R5
	mov.w	#0FFFFh,R4
	cmp.b	#02h, R5
	jz		MainDelayOn
	jnz		Elseif2
MainDelayOn:
	bic.b	#BIT6,	&P6OUT
	dec		R4
	jnz		MainDelayOn
	bic.b	#BIT0, &P1OUT
	mov.w	#0FFFFh, R4
MainDelayOff:
	dec		R4
	jnz 	MainDelayOff
	jz		EndIf

Elseif2:
	mov.w	P5IN, R5
	cmp.b	#04h, R5
	jz		Both
	jnz		Else
Both:
	bis.b	#01000000b, P6OUT
	bis.b	#BIT0, &P1OUT
SlowDelayOnIE2:
	dec		R6
	jnz		SlowDelayOnIE2
	bic.b	#01000000b, P6OUT
	bic.b	#BIT0, &P1OUT
	mov.w	#0FFFFh, R6

SlowDelayOffIE2:
	dec		R6
	jnz		SlowDelayOffIE2
	jz		EndIf

Else:
	jmp		EndIf
EndIf:
	jmp		main



;demo4

;Default:
;	mov.w	P5IN, R5
;	cmp.b 	#01h, R5
;	jz		Case1
;	mov.w	P5IN, R5
;	cmp.b 	#02h, R5
;	jz		Case2
;	mov.w	P5IN, R5
;	cmp.b 	#04h, R5
;	jz		Case3
;	jmp 	main
;
;Case1:
;	bic.b	#BIT0, &P1OUT
;GreenLight:
;	bis.b	#01000000b, P6OUT
;	mov.w	#0FFFFh, R6
;SlowDelayOn:
;	dec		R6
;	jnz		SlowDelayOn
;	bic.b	#01000000b, P6OUT
;	mov.w	#0FFFFh, R6
;SlowDelayOff:
;	dec		R6
;	jnz		SlowDelayOff
;	jz		Default
;
;Case2:
;	bic.b	#BIT6, &P6OUT
;	bis.b	#BIT0, &P1OUT
;	mov.w	#0FFFFh, R4
;MainDelayOn:
;	dec		R4
;	jnz		MainDelayOn
;	bic.b	#BIT0, &P1OUT
;	mov.w	#0FFFFh, R4
;MainDelayOff:
;	dec		R4
;	jnz 	MainDelayOff
;	jz		Default

;Case3:
;	bis.b	#01000000b, P6OUT
;	bis.b	#BIT0, &P1OUT
;SlowDelayOnIE:
	;dec		R6
	;jnz		SlowDelayOnIE
	;bic.b	#01000000b, P6OUT
	;bic.b	#BIT0, &P1OUT
	;mov.w	#0FFFFh, R6
;SlowDelayOffIE:
	;dec		R6
	;jnz		SlowDelayOffIE
	;jz		Default

;GreenLight:
	;bis.b	#01000000b, P6OUT
	;mov.w	#0FFFFh, R6
;SlowDelayOn:
	;dec		R6
	;jnz		SlowDelayOn
	;bic.b	#01000000b, P6OUT
	;mov.w	#0FFFFh, R6
;SlowDelayOff:
	;dec		R6
	;jnz		SlowDelayOff
	;jz		Default




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
            
