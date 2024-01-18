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
;Int Var1, Var2

;while(Var1 = 3){
;	Var2 = 0xDEAD;
;}
;main:
;		mov.w	#2, R5 ; this is where im putting Var1

;while1:

;	cmp.w	#3, R5 ; this compares Var1 to 3
;	jnz, endwhile1 ; bool is NOT TRUE, so exit
;	mov.w	#0DEADh, R4 ; R4 is Var2
;endwhile:
;		jmp main

------
;for while
while1:
	mov.w	#0, R6
for1:
	mov.w	R6, R14  ;var1 = i;
	inc.w	R6
	cmp.w	#4, R6
	jnz,	for1
	jmp		while1

;if else
init:
	mov.w	#0, R7
while:

if:
	cmp.w	#5, R7
	jnz, else
	mov.w	#0, R7
else:
	inc.w	R7
end_if:
	jmp while:









                                            

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
            
