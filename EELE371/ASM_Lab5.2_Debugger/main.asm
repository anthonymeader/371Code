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

;init:		bic.w	#0001h, PM5CTL0			;Setup LED1
;			bis.b 	#01h, P1DIR				;you dont really need to understand this
;			bic.b	#01h, P1OUT				;code to turn LED1 on and off

;main:		bis.b	#01h, P1OUT				;turn on LED1
;			bis.b	#01h, P1OUT				;turn off LED1
;
;			jmp main
;init:
;			mov.w 	#0AAAAh, R4				; put AAAH into R4
;			mov.w	#0BBBBh, R8				; put BBBh into R8
;main:
;			mov.w	R4, R5					;copy R4 into R5
;			mov.w	R5, R6					;copy R5 into R6
;			mov.w	R6, R7					;copy R6 into R7
;
;			mov.w	R8, R9					;copy R8 into R9
;			mov.w	R9, R10					;copy R9 into R10
;			mov.w	R10, R11				;copy R10 into R11
;
;			inv.w	R4						;invert all bits of R4
;			inv.w	R8						;invert all bits of R8
;
;			jmp								main
;
;
;-Using the Memory Browser
;init:
;		mov.w	#0371h, R4		; put 071h into R4
;		mov.w	R4, &2000h		; copy R4 into address location 200h
;main:
;		mov.w	&2000h, R5		; bring in the value held at 200h into R5
;		inc		R5				;increment R5
;		mov.w	R5, &2000h		; put the incremented value back into address 200h
;
;		jmp		main
init:
	bic.w	#0001h, PM5CTL0 ; Setup LED1
	bis.b	#01H, P1DIR		; you dont need to understand this yet,
	bic.b	#01h, P1OUT		; but this code allows us to turn LED1 on and off

	mov.w	#0FFFFh, &2002h ; Put 1234h into address location 2002h

main:
	mov.w	&2002h, R4		; Bring the data at memory location 2002h into R4
	dec		R4				; Decrement R4

	mov.w	R4, R5
	mov.w	R4, R6
	mov.w	R4, R7
	mov.w	R4, R8
	mov.w	R4, R9
	mov.w	R4, R10
	mov.w	R4, R11
	mov.w	R4, R12
	mov.w	R4, R13
	mov.w	R4, R14
	mov.w 	R4, R15

	mov.w	R4, &2002h		; Put value in R4 into memory location 2002h

	xor.b	#01h, P1OUT		; Toggle LED1

	jmp 	main
;------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack

;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
