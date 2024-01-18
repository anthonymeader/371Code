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
main:
	mov.w #16, R4
	mov.w #16, R6
	mov.w #16, R9
	mov.w #Data_Block, R5
	mov.w #Data_Block, R7
	mov.w #Data_Block, R8
push_loop:
	push.w @R5+
	dec	R4
	jnz	push_loop
	jz	pop_loop
pop_loop:
	pop.w R5
	call  #ADD3
	mov.w R5, 0(R7)
	incd R7
	dec	R6
	jnz pop_loop
	jz	main

ADD3:
	add #3, R5
	ret



;-------------------------------------------------------------------------------
; Data Memory Here
;-------------------------------------------------------------------------------
			.data
			.retain

Data_Block: .short	0000h, 1111h, 2222h, 3333h, 4444h, 5555h, 6666h, 7777h, 8888h, 9999h, 0AAAAh, 0BBBBh, 0CCCCh, 0DDDDh, 0EEEEh, 0FFFFh
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
            
