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
;test
			mov.b	#22, R4
			tst.b	R4			;Z=0, N=0

			mov.b	#-22, R4
			tst.b R4			;Z= 0, N = 1

			mov.b	#0, R4
			tst.b	R4			;Z=1, N=0



;compare
			;mov.b	#22, R4;R4=22
			;cmp.b	#7, R4 ; is R4 = 7? NO, Z=0
			;cmp.b	#22,R4	; is R4=22? YES, Z=1

;and and bis/bisc
			;mov.b	#11110000b, R4
			;;bit.b	#11000000b,	R4		;if 7:6 =11, Z=0
			;mov.b	#00110000b, R4
			;;bit.b	#11000000b,	R4		;Z=1


			;mov.b	#00000000b, R4		;R4 = 00000000
			;bis.b	#00100000b, R4
			;bis.b	#00000011b, R4		;R4 = 00100011;
			;bic.b	#00000001b, R4		;R4 = 00100010

			;xor.b


			jmp 	main
                                            

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
            
